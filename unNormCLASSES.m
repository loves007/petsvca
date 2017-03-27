clear all; close all

load('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thal/svca4_thal.mat')

for fi = 1:numel(svca4.PET_list)
    
    %%% load brain mask %%%
    MASK_struct = load_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{fi}));
    MASK = single(MASK_struct.img);
    %clear MASK_struct
    
    %%% load PET image %%%
    PET_struct = load_nii(fullfile(svca4.PET_dir, svca4.PET_list{fi}));
    PET = single(PET_struct.img);
    svca4.Res = PET_struct.hdr.dime.pixdim([2 4 3]); %
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    
    %%%% Normalizing dPET scan
    indMASK = find(MASK==1);
    for t=1:svca4.nFrames
        PET_t = PET(:,:,:,t);
        vals  = PET_t(indMASK) - mean(PET_t(indMASK));
        vals = vals/std(vals(:));
        frameMean(t)  = mean(PET_t(indMASK));
        frameSTD(t) = std(vals(:));
        frameS(t) = std(PET_t(indMASK));
        
    end
    
    CLASSES = squeeze(nanmean(svca4.classes_it00,1));
    
    repMean = repmat(frameMean,4,1,1);
    repSTD = repmat(frameS,4,1,1);
    indCLASSES(:,:,fi) = (CLASSES.*repSTD)+repMean;
    figure; plot(svca4.PET_standardEndTimes,indCLASSES(:,:,fi)')
end

