function varargout = svca4_timeShiftGui(varargin)
% SVCA4_TIMESHIFTGUI MATLAB code for svca4_timeShiftGui.fig
%      SVCA4_TIMESHIFTGUI, by itself, creates a new SVCA4_TIMESHIFTGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_TIMESHIFTGUI returns the handle to a new SVCA4_TIMESHIFTGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_TIMESHIFTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_TIMESHIFTGUI.M with the given input arguments.
%
%      SVCA4_TIMESHIFTGUI('Property','Value',...) creates a new SVCA4_TIMESHIFTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_timeShiftGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_timeShiftGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_timeShiftGui

% Last Modified by GUIDE v2.5 28-Nov-2016 13:30:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_timeShiftGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_timeShiftGui_OutputFcn, ...
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


% --- Executes just before svca4_timeShiftGui is made visible.
function svca4_timeShiftGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svca4_timeShiftGui (see VARARGIN)

% Choose default command line output for svca4_timeShiftGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes svca4_timeShiftGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global svca4
handles.listsubs.String = svca4.PET_list;
handles.listsubs.Max = length(svca4.PET_list);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_timeShiftGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in listsubs.
function listsubs_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns listsubs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listsubs


% --- Executes during object creation, after setting all properties.
function listsubs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listsubs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in shift.
function shift_Callback(hObject, eventdata, handles)
global svca4
targetPeak = 60;
clc
inds = handles.listsubs.Value; % indices to the subjects we want to time shift - the same indice for data, masks etc.
for s = 1:length(handles.listsubs.Value)
    
    % load the brain mask
    mname = fullfile(svca4.MASK_dir,svca4.MASK_list{inds(s)});
    MASK_struct = load_nii(mname);
    MASK = single(MASK_struct.img);
    clear MASK_struct
    
    pname = fullfile(svca4.PET_dir,svca4.PET_list{inds(s)});
    PET_struct = load_nii(pname);
    PET = single(PET_struct.img);
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    PET_struct.img = [];
    
    % normalize the PET data. This is the same code as Vincent, except
    % I removed the subject index (fi)
    indMask = find(MASK==1);
    PET_norm = single(zeros(size(PET)));
    for t=1:length(svca4.PET_standardDurations)
        PET_t = PET(:,:,:,t);
        mu(t) = mean(PET_t(indMask));
        vals  = PET_t(indMask) - mu(t);
        sig(t) = std(vals(:));
        vals = vals./sig(t);
        PET_norm_t = zeros(size(PET_t));
        PET_norm_t(indMask) = vals;
        PET_norm(:,:,:,t) = PET_norm_t;
    end
    clear PET_t PET_norm_t mu vals sig
    
    % load the blood mask
    bname = fullfile(svca4.BANANA_dir, svca4.BANANA_list{inds(s)});
    BANANA_struct = load_nii(bname);
    BANANA = single(BANANA_struct.img);
    BM4D = single(repmat(BANANA, [1 1 1 numel(svca4.BLOOD_frames)]));
    clear BANANA_struct
    
    firstFrames = PET_norm(:,:,:,svca4.BLOOD_frames).*BM4D;
    vox_tm_max = max(firstFrames, [], 4);
    
    IDIF = zeros(1,length(svca4.PET_standardDurations));
    for j=1:svca4.BLOOD_num_pixels
        [val, ind] = max(vox_tm_max(:));
        [indx, indy, indz] = ind2sub([xDim yDim zDim], ind);
        IDIF = IDIF + squeeze(PET_norm(indx,indy,indz,1:length(svca4.PET_standardDurations)))';
        %plot(svca4.PET_standardEndTimes,flip(squeeze(PET_norm(indx,indy,indz,1:length(svca4.PET_standardDurations)))));hold on
        vox_tm_max(indx, indy, indz) = 0;
    end
    IDIF = squeeze(IDIF/svca4.BLOOD_num_pixels);
    [mval,mind] = max(IDIF);
    flipTimes = flip(svca4.PET_standardEndTimes);
    actualPeak = flipTimes(mind);
    peak_diff = targetPeak-actualPeak;
    
    PET_shift = single(nan(size(PET)));
    [is,js,ks] = ind2sub(size(MASK),indMask);
    
    disp(['Shifting ' svca4.PET_list{inds(s)} '...'])
    
    for vs = 1%:length(is) % for all voxels in the brain mask
        if peak_diff ~= 0
            % interpolate between two consecutive time points based on the number of seconds between the them
            durs = svca4.PET_standardDurations;
            for t = 2:length(svca4.PET_standardDurations)
                tvals = flip(squeeze(PET_norm(is(vs),js(vs),ks(vs),:))); % vector of values at all time points for a single voxel
                x = [1,durs(t)]'; % first value is always 1 second is number of seconds between the 2 time points
                v = tvals(t-1:t); % the values of the 2 time points
                lin_v{t-1} = interp1(x,v,1:durs(t)); % linear interpolation between the 2 values with second precision.
            end
            new_ts = [lin_v{:}]; % interpolated time series
            switch sign(peak_diff)
                case 1 % positive difference = shift left = remove first peak_diff values and add last peak_diff values
                    shifted_ts = [new_ts(abs(peak_diff)+1:end) ones(1,abs(peak_diff))*new_ts(end)];
                case -1 % positive difference = shift right = remove last peak_diff values and add first peak_diff values
                    shifted_ts = [ones(1,abs(peak_diff))*new_ts(1) new_ts(1:length(new_ts)-abs(peak_diff))];
            end
            % here we still do not have enough time series points, we have
            % minus the duration of the first image so lets correct that
            pad_ts = [ones(1,svca4.PET_standardDurations(1))*shifted_ts(1) shifted_ts];
            PET_shift(is(vs),js(vs),ks(vs),:) = flip(pad_ts(svca4.PET_standardEndTimes)); % flip back the time
            
            %%% TESTING %%%
            figure; plot([ones(1,svca4.PET_standardDurations(1))*new_ts(1) new_ts]);hold on
            plot(svca4.PET_standardEndTimes,tvals,'*k')
            plot(pad_ts,'--r')
             plot(svca4.PET_standardEndTimes,pad_ts(svca4.PET_standardEndTimes),'*r')
        end
    end
    if peak_diff == 0
        % final output is the same as normalized input image
        PET_shift = PET_norm;
    end
    % save the normalized and shifted dynamic PET data
    oname = fullfile(svca4.PET_dir, [svca4.PET_list{inds(s)}(1:end-4) '_norm_shift_' num2str(peak_diff) '.nii']);
    PET_struct.img = single(flip(PET_shift));
    %save_untouch_nii(PET_struct, oname)
end
