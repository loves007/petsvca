function varargout = svca4_PlotClassGui(varargin)
% SVCA4_PLOTCLASSGUI MATLAB code for svca4_plotclassgui.fig

% Last Modified by GUIDE v2.5 07-Dec-2016 13:54:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_PlotGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_PlotGui_OutputFcn, ...
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

% --- Executes just before svca4_plotclassgui is made visible.
function svca4_PlotGui_OpeningFcn(hObject, eventdata, handles, varargin)

global svca4
% Choose default command line output for svca4_plotclassgui
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using svca4_plotclassgui.
if strcmp(get(hObject,'Visible'),'off')
    plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.GMWM_sel,1,:))),'-b','LineWidth',2); hold on
    plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.GMWM_sel,2,:))),'-g','LineWidth',2)
    plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.BLOOD_sel,3,:))),'-r','LineWidth',2)
    plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.TSPO_sel,4,:))),'-k','LineWidth',2)
    legend('Grey','White','Blood','TSPO')
    xlabel('Time (sec)')
    set(gca,'FontSize',14)
end

% --- Outputs from this function are returned to the command line.
function varargout = svca4_PlotGui_OutputFcn(hObject, eventdata, handles)
global svca4
% Get default command line output from handles structure
varargout{1} = svca4;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global svca4
axes(handles.axes1);
cla;

popup_sel_index = get(handles.plotChoice, 'Value');
switch popup_sel_index
    case 1
        plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.GMWM_sel,1,:))),'-b','LineWidth',4); hold on
        plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.GMWM_sel,2,:))),'-g','LineWidth',4)
        plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.BLOOD_sel,3,:))),'-r','LineWidth',4)
        plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.TSPO_sel,4,:))),'-k','LineWidth',4)
        legend('Grey','White','Blood','TSPO')
        xlabel('Time (sec)')
        set(gca,'FontSize',20,'FontWeight','bold')
    case 2
        figure;
        for s = svca4.BLOOD_sel
            subplot(2,4,s)
            plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(s,3,:)),'-r','LineWidth',2); hold on
            plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(s,1,:)),'-b','LineWidth',2);
            plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(s,2,:)),'-g','LineWidth',2);
            plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(s,4,:)),'-k','LineWidth',2); hold on
            
            %xlim([0 60])
            
            ys(s,:) = get(gca,'ylim');
        end
%         for s = svca4.TSPO_sel
%             subplot(2,4,svca4.TSPO_sel(s))
%             plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(s,4,:)),'-k','LineWidth',2); hold on
%         end
        
        set(findall(gcf,'type','axes'),'ylim',[min(ys(:,1)) max(ys(:,2))])
        set(findall(gcf,'type','axes'),'xlim',[0 svca4.PET_standardEndTimes(end)])     % should remove the hard coding here
        set(findall(gcf,'type','axes'),'FontSize',12)
    case 3
        plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(svca4.BLOOD_sel,3,:)),'LineWidth',2); hold on
        legend off
    case 4
        
        plot(svca4.PET_standardEndTimes,squeeze(svca4.TAC_TABLE_it00(svca4.TSPO_sel,4,:)),'LineWidth',2); hold on
        plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.TAC_TABLE_it00(svca4.TSPO_sel,4,:))),'--k','LineWidth',2);
        legend(cellstr(num2str(svca4.TSPO_sel')),'Average')
    case 5
        
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)

file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)

printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)

selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in plotChoice.
function plotChoice_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function plotChoice_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Plot average', 'Plot individuals', 'Plot blood for individuals','Plot TSPO'});


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
