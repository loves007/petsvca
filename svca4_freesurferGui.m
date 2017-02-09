function varargout = svca4_freesurferGui(varargin)
% SVCA4_FREESURFERGUI MATLAB code for svca4_freesurferGui.fig

% Last Modified by GUIDE v2.5 25-Jan-2017 14:28:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_freesurferGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_freesurferGui_OutputFcn, ...
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

% --- Executes just before svca4_freesurferGui is made visible.
function svca4_freesurferGui_OpeningFcn(hObject, eventdata, handles, varargin)

global svca4
if ~isfield(svca4,'FREESURFER_HOME')
    warndlg('Set the FREESURFER_HOME path before working here!')
elseif ~isfield(svca4,'outputPath')
    warndlg('There is not enough information (e.g., outPath) in the "svca4" structure!')
    disp('Here is the "svca4" structure::')
    disp(svca4)
elseif ~isfield(svca4,'PET_dir')
    warndlg('There is not enough information (e.g., PET_dir) in the "svca4" structure!')
    disp('Here is the "svca4" structure::')
    disp(svca4)
    
end
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_freesurferGui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

% --- Executes on button press in free_createMask.
function free_createMask_Callback(hObject, eventdata, handles)
global svca4
svca4_MaskGui(svca4)

% --- Executes on button press in gray.
function gray_Callback(hObject, eventdata, handles)
% Combines left and right hemisphere gray matter masks
global svca4
if ~exist([svca4.outputPath '/gmwm'],'dir')
    mkdir([svca4.outputPath '/gmwm'])
end
%disp(length(svca4.MRI_list))
[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
        'mri_binarize --i ' [svca4.SUBJECTS_DIR '/' subs{s} '/mri/rh.ribbon.mgz'] ' --merge ' [svca4.SUBJECTS_DIR '/' subs{s} '/mri/lh.ribbon.mgz'] ' --o ' [svca4.outputPath '/gmwm/' subs{s} '_gm.nii.gz'] ' --match 1;'...
        'mri_binarize --i ' [svca4.SUBJECTS_DIR '/' subs{s} '/mri/ribbon.mgz'] ' --wm --binval 2 --o ' [svca4.outputPath '/gmwm/' subs{s} '_wm.nii.gz;']...
        'mri_binarize --i ' [svca4.outputPath '/gmwm/' subs{s} '_gm.nii.gz'] ' --merge ' [svca4.outputPath '/gmwm/' subs{s} '_wm.nii.gz'] ' --match 1 --o ' [svca4.outputPath '/gmwm/' subs{s} '_gmwm.nii.gz']];
    system(cmd)
    delete([svca4.outputPath '/gmwm/' subs{s} '_gm.nii.gz'])
    delete([svca4.outputPath '/gmwm/' subs{s} '_wm.nii.gz'])
end
hObject.Value = 0;

% --- Executes on button press in free_avg.
function free_avg_Callback(hObject, eventdata, handles)
% Calculates the average (across time) PET image
global svca4
if ~exist([svca4.outputPath '/meanPET'],'dir')
    mkdir([svca4.outputPath '/meanPET'])
end

[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    if ~exist([svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz'],'file')
        cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
            'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
            'mri_concat ' fullfile(svca4.PET_dir,[subs{s} '_pet.nii '...
            '--mean --o ' [svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz'] ])];
        system(cmd)
    end
end
svca4.meanPET_dir = [svca4.outputPath '/meanPET'];
hObject.Value = 0;

% --- Executes on button press in free_coreg.
function free_coreg_Callback(hObject, eventdata, handles)
% Use to coregister PET to T1. Note this only calculates the transformation
% matrix it does not actually transform the data. The inverse of this
% matrix will be used to put ROI segmentations into PET space.
global svca4
if ~isfield(svca4,'SUBJECTS_DIR')
    warndlg('Set the SUBJECTS_DIR path before working here!')
end
if ~exist([svca4.outputPath '/pet_2_irm_Transforms'],'dir')
    mkdir([svca4.outputPath '/pet_2_irm_Transforms'])
end
nCs = feature('numCores'); % not sure this is optimal as it is cores and not threads???
[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    if exist([svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz'],'file')
        cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
            'export SUBJECTS_DIR=' svca4.SUBJECTS_DIR ';'...
            'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
            'mri_coreg --s ' subs{s} ' --mov ' [svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz']...
            ' --reg ' [svca4.outputPath '/pet_2_irm_Transforms/' subs{s} '_pet2irm.lta']...
            ' --threads ' num2str(nCs)];
        system(cmd)
    end
end
hObject.Value = 0;

% --- Executes on button press in free_checkReg.
function free_checkReg_Callback(hObject, eventdata, handles)
% Display the registration between the mean PET image and the T1
global svca4
[subs] = uigetdirMultiSelect();

if length(subs) == 1
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'export SUBJECTS_DIR=' svca4.SUBJECTS_DIR ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
        'tkregisterfv --mov ' [svca4.outputPath '/meanPET/' subs{1} '_meanPET.nii.gz' ] ' --targ ' svca4.SUBJECTS_DIR '/' subs{1} '/mri/brainmask.mgz --reg ' [svca4.outputPath '/pet_2_irm_Transforms/'] subs{1} '_pet2irm.lta --s ' subs{1} ' --surfs'];
    system(cmd)
else warndlg('You should only select one subject at a time!')
end
hObject.Value = 0;

% --- Executes on button press in free_gmwmToPET.
function free_gmwmToPET_Callback(hObject, eventdata, handles)
% Transform the gray and white matter masks to PET space
global svca4
%svca4.FREESURFER_HOME = '/Applications/MRI/freesurfer_v6beta';
[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
                    'export SUBJECTS_DIR=' svca4.SUBJECTS_DIR ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
       'mri_vol2vol --mov ' svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz '...
       '--targ ' svca4.outputPath '/gmwm/' subs{s} '_gmwm.nii.gz'...
       ' --inv --nearest --lta ' svca4.outputPath '/pet_2_irm_Transforms/' subs{s} '_pet2irm.lta'...
       ' --o ' svca4.outputPath '/gmwm/' subs{s} '_gmwm_2pet.nii.gz'
       ];
    system(cmd)
end
hObject.Value = 0;

% --- Executes on button press in free_roi_2_pet.
function free_roi_2_pet_Callback(hObject, eventdata, handles)
global svca4

[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
                    'export SUBJECTS_DIR=' svca4.SUBJECTS_DIR ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
       'mri_vol2vol --targ ' svca4.SUBJECTS_DIR '/' subs{s} '/label/' subs{s} '_AparcAseg_in_raxavg.nii.gz '...
       '--mov ' svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz'...
       ' --nearest --inv --lta ' svca4.outputPath '/pet_2_irm_Transforms/' subs{s} '_pet2irm.lta'...
       ' --o ' svca4.SUBJECTS_DIR '/' subs{s} '/label/' subs{s} '_AparcAseg_in_PET.nii.gz'
       ];
    system(cmd)
end
hObject.Value = 0;

% --- Executes on button press in free_toMNI.
function free_toMNI_Callback(hObject, eventdata, handles)
% Use to coregister T1 to the Freesurfer cvs_avg35_inMNI space.
%The transform output of this call can be used to, for example, transform
%any other file also in cvs_avg35_inMNI space or (perhaps) MNI space in
%general.
global svca4
if ~isfield(svca4,'SUBJECTS_DIR')
    warndlg('Set the SUBJECTS_DIR path before working here!')
end

[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    if ~exist([svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}],'dir')
        mkdir([svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}])
    end
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'export SUBJECTS_DIR=' [svca4.FREESURFER_HOME '/subjects/;']...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
        'mri_cvs_register --mov cvs_avg35_inMNI152 --template ' subs{s}...
        ' --templatedir ' svca4.SUBJECTS_DIR...
        ' --outdir ' [svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}] ' &'];
    system(cmd)
    cmd1 = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'export SUBJECTS_DIR=' [svca4.FREESURFER_HOME '/subjects/;']...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
        'mri_cvs_register --mov cvs_avg35_inMNI152 --template ' subs{s}...
        ' --templatedir ' svca4.SUBJECTS_DIR...
        ' --outdir ' [svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}] ];
end
hObject.Value = 0;

% --- Executes on button press in free_transVess.
function free_transVess_Callback(hObject, eventdata, handles)
% Transform the Vessel Density template to a native space using the
% transform output by the CVS registration.
global svca4
if ~exist([svca4.outputPath '/blood'],'dir')
    mkdir([svca4.outputPath '/blood'])
end
[vess, vessPath] = uigetfile({'*.nii.gz','*.nii'},'Select the Vessel Density template');
[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
       'mri_convert ' fullfile(vessPath, vess) ' -at ' svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}...
       '/final_CVSmorph_to' subs{s} '.m3z -ic 0 0 0 ' svca4.outputPath '/blood/VesselDensityLR_to_' subs{s} '.nii.gz'];
    system(cmd)
end
hObject.Value = 0;

% --- Executes on button press in free_vessDen_toPET.
function free_vessDen_toPET_Callback(hObject, eventdata, handles)
global svca4
[subs] = uigetdirMultiSelect();
for s = 1:length(subs)
    cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
       'mri_convert ' fullfile(vessPath, vess) ' -ait ' svca4.SUBJECTS_DIR '/' subs{s} '/cvs_avg_inMNI_to_' subs{s}...
       '/final_CVSmorph_to' subs{s} '.m3z -ic 0 0 0 ' svca4.outputPath '/blood/VesselDensityLR_to_' subs{s} '.nii.gz'];
    system(cmd)
end
hObject.Value = 0;

% --- Executes on button press in free_checkVessReg.
function free_checkVessReg_Callback(hObject, eventdata, handles)
% PLACEHOLDER
% Display the Vessel Density template in native T1 space

function [outfiles] = uigetdirMultiSelect()
% This function allows the user to select the subject folders (created by
% Freesurfer) to be worked on.
global svca4

import com.mathworks.mwswing.MJFileChooserPerPlatform;
jchooser = javaObjectEDT('com.mathworks.mwswing.MJFileChooserPerPlatform',svca4.SUBJECTS_DIR);
jchooser.setFileSelectionMode(javax.swing.JFileChooser.DIRECTORIES_ONLY);
jchooser.setMultiSelectionEnabled(true);
jchooser.setDialogTitle('Choose the folders of subjects you want to work with.')
jchooser.showOpenDialog([]);

if jchooser.getState() == javax.swing.JFileChooser.APPROVE_OPTION
    jFiles = jchooser.getSelectedFiles();
    files = arrayfun(@(x) char(x.getPath()), jFiles, 'UniformOutput', false);
elseif jchooser.getState() == javax.swing.JFileChooser.CANCEL_OPTION
    files = [];
else
    error('Error occurred while picking file');
end

for fi = 1:length(files)
    [a,b,c]= fileparts(files{fi});
    outfiles{fi}=b;
end


% --- Executes on button press in transT1.
function transT1_Callback(hObject, eventdata, handles)
% global svca4
% 
% [subs] = uigetdirMultiSelect();
% for s = 1:length(subs)
%     cmd = ['export FREESURFER_HOME=' svca4.FREESURFER_HOME ';'...
%                     'export SUBJECTS_DIR=' svca4.SUBJECTS_DIR ';'...
%         'source $FREESURFER_HOME/SetUpFreeSurfer.sh;'...
%        'mri_vol2vol --mov ' svca4.SUBJECTS_DIR '/' subs{s} '/label/' subs{s} '_AparcAseg_in_raxavg.nii.gz '...
%        '--targ ' svca4.outputPath '/meanPET/' subs{s} '_meanPET.nii.gz'...
%        ' --inv --lta ' svca4.outputPath '/pet_2_irm_Transforms/' subs{s} '_pet2irm.lta'...
%        ' --o ' svca4.SUBJECTS_DIR '/' subs{s} '/label/' subs{s} '_AparcAseg_in_PET.nii.gz'
%        ];
%     system(cmd)
% end
% hObject.Value = 0;
