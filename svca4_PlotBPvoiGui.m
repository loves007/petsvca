function varargout = svca4_PlotBPvoiGui(varargin)
% SVCA4_PLOTBPVOIGUI MATLAB code for svca4_PlotBPvoiGui.fig
%      SVCA4_PLOTBPVOIGUI, by itself, creates a new SVCA4_PLOTBPVOIGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_PLOTBPVOIGUI returns the handle to a new SVCA4_PLOTBPVOIGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_PLOTBPVOIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_PLOTBPVOIGUI.M with the given input arguments.
%
%      SVCA4_PLOTBPVOIGUI('Property','Value',...) creates a new SVCA4_PLOTBPVOIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_PlotBPvoiGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_PlotBPvoiGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_PlotBPvoiGui

% Last Modified by GUIDE v2.5 10-Mar-2017 10:01:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_PlotBPvoiGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_PlotBPvoiGui_OutputFcn, ...
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


% --- Executes just before svca4_PlotBPvoiGui is made visible.
function svca4_PlotBPvoiGui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = svca4_PlotBPvoiGui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function out = gfn(in)
out = flip(strtok(flip(in),'/'));

% --- Executes on button press in load_bp.
function load_bp_Callback(hObject, eventdata, handles)
global svca4

bp_list = uipickfiles('Prompt','Select the BP images.');

load(bp_list{1})

handles.list_subsGR1.String = bpTable.Subjects;
n = {'none'};
handles.list_subsGR2.String = [n;bpTable.Subjects];

handles.bp_list = bp_list;

modelNames = cellfun(@gfn, bp_list,'UniformOutput',false);
handles.models.String = modelNames;


guidata(hObject, handles);

% --- Executes on selection change in list_subsGR1.
function list_subsGR1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function list_subsGR1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_subsGR2.
function list_subsGR2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function list_subsGR2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in regions.
function regions_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function regions_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
load(fullfile(fileparts(which('svca4_mainGui')),'freeLabels.mat'))

% group the scatter color
GR.one = handles.list_subsGR1.Value;
if isempty(find(strcmp(handles.list_subsGR2.String(handles.list_subsGR2.Value),'none')))
    GR.two = handles.list_subsGR2.Value-1;
end

for m = 1:length(handles.bp_list)
    load(handles.bp_list{m});
    [tmp, tmp1] = fileparts(handles.bp_list{m});
    
    eval(['bpTables.' tmp1 '= bpTable;'])
    modelName{m} = tmp1;
end

for r = 1:numel(handles.regions.Value) % for all regions
    %clear scat
    for m = 1:numel(handles.models.Value)
        % get BP values for each model
        scat(:,m) = bpTables.(modelName{handles.models.Value(m)}){:,handles.regions.Value(r)};
    end
    %%% plot %%%
    hf = figure; set(hf,'color','w')
    hf.Color = 'w';
    
    if numel(fieldnames(GR)) == 1 % if there is no grouping
        x = ones(size(scat));
        x = cumsum(x,2);
        plot(x,scat,'*');
        set(gca,'XTick',x(1,:));
    else % if there is a grouping
        x = ones(size(scat));
        % group 1
        x1 = x(GR.one,:);
        scat1 = scat(GR.one,:);
        x1 = cumsum(x1,2);
        plot(x1,scat1,'*'); hold on
        %group 2
        x2 = x(GR.two,:);
        scat2 = scat(GR.two,:);
        x2 = cumsum(x2,2);
        set(gca,'ColorOrderIndex',1);
        plot(x2,scat2,'s');
        set(gca,'XTick',x2(1,:));
    end
    xLim = xlim;
    xlim([xLim(1)-0.5 xLim(2)+0.5]);
    
    set(gca,'XTickLabel',modelName(handles.models.Value));
    set(gca,'TickLabelInterpreter','none');
    set(gca,'XTickLabelRotation',30);
    title(labels.Region(handles.regions.Value(r)),'interpreter','none');
    
    ylabel('BP')
end


% --- Executes on button press in corrBP.
function corrBP_Callback(hObject, eventdata, handles)
% correlate the mean BP for a region calculated from different
% reference region models.
% NB: THERE IS SOME BAD HARDING CODING IN HERE!!!
addpath(genpath('/Users/scott/Dropbox/MATLAB/Toolboxes/Corr_toolbox_v2'));

% load region names
load(fullfile(fileparts(which('svca4_mainGui')),'freeLabels.mat'));

% get grouping
GR.one = handles.list_subsGR1.Value;
if isempty(find(strcmp(handles.list_subsGR2.String(handles.list_subsGR2.Value),'none')))
    GR.two = handles.list_subsGR2.Value-1;
end
for m = 1:numel(handles.models.Value)
    load(handles.bp_list{handles.models.Value(m)});
    [tmp, tmp1] = fileparts(handles.bp_list{handles.models.Value(m)});
    
    eval(['bpTables.' tmp1 '= bpTable;'])
    modelName{handles.models.Value(m)} = tmp1;
end
for r = 1:numel(handles.regions.Value) % for all regions
    for m = 1:numel(handles.models.Value)
        % get BP values for each model
        scat(:,m) = bpTables.(modelName{handles.models.Value(m)}){:,handles.regions.Value(r)};
    end
    
    %%% correlate %%%
    [R,P,RL,RU] = corrcoef(scat,'rows','pairwise');
    
    % display pairwise correlations
    figure; set(gcf,'color','w')
    imagesc(R);
    set(gca,'XTick',1:length(R),'YTick',1:length(R));
    colorbar;
    set(gca,'XTickLabel',modelName(handles.models.Value),'YTickLabel',modelName(handles.models.Value));
    set(gca,'TickLabelInterpreter','none');
    set(gca,'XTickLabelRotation',30);
    title(labels.Region(handles.regions.Value(r)),'interpreter','none');
    
    
    figure; set(gcf,'color','w')
    nSub = numSubplots(size(scat,2));
    for s = 1:size(scat,2)-1
        ind = 2:size(scat,2);
        ax(s) = subplot(nSub(1),nSub(2),s);
        if numel(fieldnames(GR)) == 1 % if there is no grouping
            scatter(scat(:,ind(s)),scat(:,1),'*');
        else
            scatter(scat(GR.one,ind(s)),scat(GR.one,1),'*'); hold on
            scatter(scat(GR.two,ind(s)),scat(GR.two,1),'bs');
        end
        xlabel(modelName{handles.models.Value(s+1)},'interpreter','none') % NB HARD CODED +1!!!!!
        if s == 1; ylabel('BP Cerebellum');end
        title(['r=' num2str(R(1,ind(s)))]);
    end
    set(ax,'YLim',[round(min(min(scat)),2) round(max(max(scat)),2)]);
    set(ax,'XLim',[round(min(min(scat)),2) round(max(max(scat)),2)]);
    
end


% --- Executes on selection change in models.
function models_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function models_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
