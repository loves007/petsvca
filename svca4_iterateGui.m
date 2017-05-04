function varargout = svca4_iterateGui(varargin)
% SVCA4_ITERATEGUI MATLAB code for svca4_iterateGui.fig
%      SVCA4_ITERATEGUI, by itself, creates a new SVCA4_ITERATEGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_ITERATEGUI returns the handle to a new SVCA4_ITERATEGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_ITERATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_ITERATEGUI.M with the given input arguments.
%
%      SVCA4_ITERATEGUI('Property','Value',...) creates a new SVCA4_ITERATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_iterateGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_iterateGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_iterateGui

% Last Modified by GUIDE v2.5 16-Jan-2017 12:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_iterateGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_iterateGui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before svca4_iterateGui is made visible.
function svca4_iterateGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svca4_iterateGui (see VARARGIN)

% Choose default command line output for svca4_iterateGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes svca4_iterateGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = svca4_iterateGui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;



function it_num_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function it_num_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function it_weight_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function it_weight_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in iterate.
function iterate_Callback(hObject, eventdata, handles)
global svca4

num_its = str2num(handles.it_num.String);
q = str2num(handles.it_weight.String);

for its = 1:num_its % for each iteration
    fprintf('* Iteration %d\n',its)
    fprintf('Calculating CLASS TACs. Please wait ...\n');
    clear TAC_TABLE
    
    ifeedback=its-1;
    
    for fi=svca4.classIDs % for each target subject
        %%% load brain mask %%%
        MASK_struct = load_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{fi}));
        MASK = single(MASK_struct.img);
        clear MASK_struct
        
        %%% load PET image %%%
        PET_struct = load_nii(fullfile(svca4.PET_dir, svca4.PET_list{fi}));
        PET = single(PET_struct.img);
        svca4.Res = PET_struct.hdr.dime.pixdim([2 4 3]); %
        xDim = size(PET,1);
        yDim = size(PET,2);
        zDim = size(PET,3);
        clear PET_struct;
        
        %%%% Normalizing dPET scan
        indMASK = find(MASK==1);
        PET_norm = zeros(xDim,yDim,zDim,svca4.nFrames);
        for t=1:svca4.nFrames
            PET_t = PET(:,:,:,t);
            vals  = PET_t(indMASK) - mean(PET_t(indMASK));
            vals = vals/std(vals(:));
            PET_t_norm = PET_norm(:,:,:,t);
            PET_t_norm(indMASK) = vals;
            PET_norm(:,:,:,t) = PET_t_norm;
        end
        
        %%% Blood class %%%
        isBLOOD = any(svca4.BLOOD_sel==fi);
        if isBLOOD
            if its == 1
                fname = sprintf('%s/weights/%s_BLOOD_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, ifeedback);
            else fname = sprintf('%s/weights/%s_BLOOD_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,ifeedback);
            end
            BLOOD = load_nii(fname);
            BLOOD = BLOOD.img;
            BLOOD = BLOOD.*MASK;
            quant_BLOOD = quantile(BLOOD(BLOOD~=0),q);
            BLOODMASK = single(zeros(size(MASK)));
            BLOODMASK(BLOOD>quant_BLOOD) = 1;
            BM4D = repmat(BLOODMASK, [1 1 1 numel(svca4.BLOOD_frames)]);
            
            firstFrames = PET_norm(:,:,:,svca4.BLOOD_frames).*single(BM4D);
            vox_tm_max = max(firstFrames, [], 4);
            
            BLOOD = zeros(1,svca4.nFrames); % BLOOD on normalized image
            for j=1:svca4.BLOOD_num_pixels
                [~, ind] = max(vox_tm_max(:));
                [indx, indy, indz] = ind2sub([xDim yDim zDim], ind);
                BLOOD = BLOOD + squeeze(PET_norm(indx,indy,indz,1:svca4.nFrames))';
                vox_tm_max(indx, indy, indz) = 0;
            end
            TAC_TABLE(fi,3,1:svca4.nFrames) = squeeze(BLOOD/svca4.BLOOD_num_pixels);
        end
        
        %%% GM/WM classes %%%
        isGMWM = any(svca4.GMWM_sel==fi);
        if isGMWM
            if its == 1
                fname = sprintf('%s/weights/%s_GRAY_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, ifeedback);
            else fname = sprintf('%s/weights/%s_GRAY_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,ifeedback);
            end
            GRAY = load_nii(fname);
            GRAY = GRAY.img;
            GRAY = GRAY.*MASK;
            quant_GRAY = quantile(GRAY(GRAY~=0),q);
            GM = single(zeros(size(MASK)));
            GM(GRAY>quant_GRAY) = 1;
            
            if its == 1
                fname = sprintf('%s/weights/%s_WHITE_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, ifeedback);
            else fname = sprintf('%s/weights/%s_WHITE_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,ifeedback);
            end
            WHITE = load_nii(fname);
            WHITE = WHITE.img;
            WHITE = WHITE.*MASK;
            quant_WHITE = quantile(WHITE(WHITE~=0),q);
            WM = single(zeros(size(MASK)));
            WM(WHITE>quant_WHITE) = 1;
            
            for t=1:svca4.nFrames
                % GM
                tmp = single(MASK).*single(GM).*PET_norm(:,:,:,t);
                TAC_TABLE(fi,1,t) = mean(tmp(tmp~=0));
                % WM
                tmp = single(MASK).*single(WM).*PET_norm(:,:,:,t);
                TAC_TABLE(fi,2,t) = mean(tmp(tmp~=0));
            end
        end
        
        %%% TSPO class %%%
        isINF = any(svca4.TSPO_sel==fi);
        if isINF
            if its == 1
                fname = sprintf('%s/weights/%s_TSPO_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, ifeedback);
            else fname = sprintf('%s/weights/%s_TSPO_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,ifeedback);
            end
            TSPO = load_nii(fname);
            TSPO = TSPO.img;
            TSPO = TSPO.*MASK;
            quant_TSPO = quantile(TSPO(TSPO~=0),q);
            INF = single(zeros(size(MASK)));
            INF(TSPO>quant_TSPO) = 1;
            
            for t=1:svca4.nFrames
                tmp = single(INF).*PET_norm(:,:,:,t);
                TAC_TABLE(fi,4,t) = mean(tmp(tmp~=0));
            end
        end
        
    end % loops target subjects
    
    % save iterated TAC_TABLE to svca4 structure
    svca4.(sprintf('TAC_TABLE_q%d_it%.2d',q*100,its)) = TAC_TABLE;
    
    figure; set(gcf,'color','white')
    plot(svca4.PET_standardEndTimes,mean(squeeze(TAC_TABLE(svca4.BLOOD_sel,1,:))),'-b','LineWidth',2); hold on
    plot(svca4.PET_standardEndTimes,mean(squeeze(TAC_TABLE(svca4.GMWM_sel,2,:))),'-g','LineWidth',2)
    plot(svca4.PET_standardEndTimes,mean(squeeze(TAC_TABLE(svca4.GMWM_sel,3,:))),'-r','LineWidth',2)
    plot(svca4.PET_standardEndTimes,mean(squeeze(TAC_TABLE(svca4.TSPO_sel,4,:))),'-k','LineWidth',2)
    title(['Iteration ' num2str(its)])
    legend('Grey','White','Blood','TSPO')
    xlabel('Time (sec)')
    ylabel('normalized kBq/ml')
    set(gca,'FontSize',14)
    
    print(gcf,sprintf('%s/figs/classes_q%d_it%.2d.png', svca4.outputPath, q*100,its),'-dpng')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Supervised Cluster Analysis %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for fi=svca4.classIDs % for each target subject
        % exclude target from TAC
        GMWM_sel = svca4.GMWM_sel; GMWM_sel(svca4.GMWM_sel==fi) = [];
        BLOOD_sel = svca4.BLOOD_sel; BLOOD_sel(svca4.BLOOD_sel==fi) = [];
        TSPO_sel = svca4.TSPO_sel; TSPO_sel(svca4.TSPO_sel==fi) = [];
        
        % Get Classes from TAC_TABLE : GRAY WHITE BLOOD TSPO
        CLASS(:,1) = nanmean(squeeze(TAC_TABLE(GMWM_sel,1,:)),1);
        CLASS(:,2) = nanmean(squeeze(TAC_TABLE(GMWM_sel,2,:)),1);
        CLASS(:,3) = nanmean(squeeze(TAC_TABLE(BLOOD_sel,3,:)),1);
        CLASS(:,4) = nanmean(squeeze(TAC_TABLE(TSPO_sel,4,:)),1);
        CLASS(isnan(CLASS)) = 0; % this might not be the best approach but the regression cannot have NaNs
        
        %%% load brain mask %%%
        MASK_struct = load_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{fi}));
        MASK = single(MASK_struct.img);
        clear MASK_struct
        
        %%% load target image %%%
        TARGET_struct = load_nii(fullfile(svca4.PET_dir, svca4.PET_list{fi}));
        TARGET = single(TARGET_struct.img);
        xDim = size(TARGET,1);
        yDim = size(TARGET,2);
        zDim = size(TARGET,3);
        clear TARGET_struct
        
        %%% normalizing dPET target %%%
        indMASK = find(MASK==1);
        PET_norm = zeros(xDim,yDim,zDim,svca4.nFrames);
        for t=1:svca4.nFrames
            PET_t = TARGET(:,:,:,t);
            vals  = PET_t(indMASK) - mean(PET_t(indMASK));
            vals = vals/std(vals(:));
            PET_t_norm = PET_norm(:,:,:,t);
            PET_t_norm(indMASK) = vals;
            PET_norm(:,:,:,t) = PET_t_norm;
        end
        
        % Fitting kinetic classes
        fprintf('Fitting kinetic classes. Please wait ...\n');
        
        % initializing parametric maps
        GRAY = zeros(size(MASK));
        WHITE = GRAY; BLOOD = GRAY; TSPO = GRAY;
        
        % vectorizing target for speed
        PET_vector = reshape(PET_norm, xDim*yDim*zDim, svca4.nFrames);
        for j = 1:size(PET_vector,1);
            if MASK(j) > 0
                TAC = squeeze(PET_vector(j,:)');
                TAC(isnan(TAC)) = 0;
                % fitting
                par = lsqnonneg(CLASS,TAC);
                
                % filling parametric maps
                GRAY(j) = par(1);
                WHITE(j) = par(2);
                BLOOD(j) = par(3);
                TSPO(j) = par(4);
            end
        end
        
        %%% Save parametric maps %%%
        % NB: there is a L/R flip for the data needed but I'm not sure it
        % always will be!!!
        OUT_struct = load_nii(sprintf('%s/%s', svca4.MRI_dir, svca4.MRI_list{fi}));
        OUT_struct.img = [];
        
        fprintf('* Saving parametric maps for Target %d ...\n',fi);
        
        fname = sprintf('%s/weights/%s_GRAY_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,its);
        OUT_struct.img = single(flip(GRAY));
        save_untouch_nii(OUT_struct, fname);
        
        fname = sprintf('%s/weights/%s_WHITE_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,its);
        OUT_struct.img = single(flip(WHITE));
        save_untouch_nii(OUT_struct, fname);
        
        fname = sprintf('%s/weights/%s_BLOOD_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,its);
        OUT_struct.img = single(flip(BLOOD));
        save_untouch_nii(OUT_struct, fname);
        
        fname = sprintf('%s/weights/%s_TSPO_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{fi}, q*100,its);
        OUT_struct.img = single(flip(TSPO));
        save_untouch_nii(OUT_struct, fname);
    end
end
clear grey white blood tspo
leg = cell(1,num_its+1);
leg{1} = 'it0';
for its = 1:num_its % for each iteration
    ifeedback=its+1;
    
    grey(its,:) = eval(sprintf('mean(squeeze(svca4.classes_q%d_it%.2d(svca4.GMWM_sel,1,:)))',q*100,its));
    white(its,:) = eval(sprintf('mean(squeeze(svca4.classes_q%d_it%.2d(svca4.GMWM_sel,2,:)))',q*100,its));
    blood(its,:) = eval(sprintf('mean(squeeze(svca4.classes_q%d_it%.2d(svca4.BLOOD_sel,3,:)))',q*100,its));
    tspo(its,:) = eval(sprintf('mean(squeeze(svca4.classes_q%d_it%.2d(svca4.TSPO_sel,4,:)))',q*100,its));
    leg{ifeedback} = sprintf('it%d',its);
end

grey = [mean(squeeze(svca4.classes_it00(svca4.GMWM_sel,1,:))); grey ];
white = [mean(squeeze(svca4.classes_it00(svca4.GMWM_sel,2,:))); white ];
blood = [mean(squeeze(svca4.classes_it00(svca4.BLOOD_sel,3,:))); blood ];
tspo = [mean(squeeze(svca4.classes_it00(svca4.TSPO_sel,4,:))); tspo ];

figure; set(gcf,'color','white')
plot(svca4.PET_standardEndTimes,grey,'LineWidth',2);
title('Grey')
legend(leg)
xlabel('Time (sec)')
ylabel('normalized kBq/ml')
set(gca,'FontSize',14)
print(gcf,sprintf('%s/figs/grey_q%d_its%d.png', svca4.outputPath, q*100,num_its),'-dpng')

figure; set(gcf,'color','white')
plot(svca4.PET_standardEndTimes,white,'LineWidth',2);
title('White')
legend(leg)
xlabel('Time (sec)')
ylabel('normalized kBq/ml')
set(gca,'FontSize',14)
print(gcf,sprintf('%s/figs/white_q%d_its%d.png', svca4.outputPath, q*100,num_its),'-dpng')

figure; set(gcf,'color','white')
plot(svca4.PET_standardEndTimes,blood,'LineWidth',2);
title('Blood')
legend(leg)
xlabel('Time (sec)')
ylabel('normalized kBq/ml')
set(gca,'FontSize',14)
print(gcf,sprintf('%s/figs/blood_q%d_its%d.png', svca4.outputPath, q*100,num_its),'-dpng')

figure; set(gcf,'color','white')
plot(svca4.PET_standardEndTimes,tspo,'LineWidth',2);
title('TSPO')
legend(leg)
xlabel('Time (sec)')
ylabel('normalized kBq/ml')
set(gca,'FontSize',14)
print(gcf,sprintf('%s/figs/tspo_q%d_its%d.png', svca4.outputPath, q*100,num_its),'-dpng')

%
uisave({'svca4'}, 'svca4.mat')