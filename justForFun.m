%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bootstrapped randomly selected references
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc
addpath('/Users/scott/Dropbox/MATLAB/Toolboxes/nifti_tools')

pet_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/data_pet/*_flip*' );
gmwm_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/gmwm/*_2pet*' );
brain_files = dir('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/roiMasks/*_brainMask*' );

load('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/svca4_thals.mat', 'svca4')
xt = svca4.PET_standardEndTimes; clear svca4;

Nrand = [.1 .5 1 10];
Nboots = 10;
Output = zeros(numel(Nrand),Nboots,31,length(pet_files));
for s = 1%:length(pet_files)
    %%% load pet image %%%
    PET_struct = load_untouch_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/data_pet/' pet_files(s).name]);
    PET = single(PET_struct.img);
    
    %%% load brain mask %%%
    %     BRAIN_struct = load_untouch_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/roiMasks/' brain_files(s).name]);
    %     BRAIN = single(BRAIN_struct.img);
    %     indBRAIN = find(BRAIN==1);
    
    %%% load Grey mask %%%
    GM_struct = load_untouch_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/gmwm/' gmwm_files(s).name]);
    GM = single(GM_struct.img);
    indGM = find(GM==1);
    
    for n = 1:numel(Nrand)
        for b = 1:Nboots
            randInds = randperm(numel(indGM),round(numel(indGM)*Nrand(n)/100));
            for t=1:31
                PET_t=PET(:,:,:,t);
                TEMP = GM(indGM(randInds)).*PET_t(indGM(randInds));
                GRAYt(t) = sum(TEMP(:));
            end
            GRAYt(s,:) = GRAYt(:)/numel(randInds);
            Output(n,b,:,s) = GRAYt;
        end
    end
end

%%