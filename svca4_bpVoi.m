%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the average BP for each VOI individually and for each subject.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outName] = svca4_bpVoi(bp_list, bp_dir, outName, svca4)

% load all label names
load(fullfile(fileparts(which('svca4_mainGui')),'freeLabels.mat'))

for i = 1:length(bp_list)
    
    % find BP image for current subject
    subj = svca4.Names{i};
    ind = strfind(bp_list, subj);
    ind = find(not(cellfun('isempty', ind)));
    bpf = bp_list{ind};
    
    %%% load all BP image %%%
    BP_struct = load_untouch_nii([bp_dir bpf]);
    BP = single(BP_struct.img);
    
    %%% load all VOIs %%%
    VOI_struct = load_untouch_nii([svca4.SUBJECTS_DIR filesep subj filesep 'label' filesep subj '_AparcAseg_in_PET.nii.gz']);
    VOI = single(VOI_struct.img);
    VOInums = unique(VOI);
    VOInums = VOInums(VOInums > 0);
    nVOIs = length(VOInums);
    
    % get mean of each VOI
    for v = 1:nVOIs
        indVOI = find(VOI==VOInums(v));
        
        bp_voi(i,v) = mean(BP(indVOI));
    end
    outName = array2table(bp_voi,'variablenames',labels.Region);
    outName.Subjects = svca4.Names;
end
