%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bootstrapped randomly selected references
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc
addpath('/Users/scott/Dropbox/MATLAB/Toolboxes/nifti_tools')

pet_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/data_pet/*_flip*' );
gmwm_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/gmwm/*_2pet*' );
brain_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/roiMasks/*_brainMask*' );

for s = 1%:length(pet_files)
    %%% load pet image %%%
    PET_struct = load_nii(pet_files(s));
    PET = single(TARGET_struct.img);
end
%%