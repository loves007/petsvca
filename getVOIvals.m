%% Used to get mean values from a VOI. Set to use the raw PET data.
% svca4_voiTACGui does similar but this could still be useful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_newstart/svca4_newstart.mat')

for s = 1:length(svca4.PET_list)
    subj = svca4.PET_list{s};
    subj = subj(1:5); % should remove this hard coding!!!
    
    %%% load PET image %%%
    PET_struct = load_untouch_nii(fullfile(svca4.PET_dir, svca4.PET_list{s}));
    PET = single(PET_struct.img);
    svca4.Res = PET_struct.hdr.dime.pixdim([2 4 3]); %
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    
    %%% load VOI image %%%
    VOI_struct = load_untouch_nii([svca4.outputPath '/roiMasks/' subj '_thalamus.nii.gz']);
    VOI = single(VOI_struct.img);
    indVOI = find(VOI==1);
    
    
    PET_vals = zeros(xDim,yDim,zDim,svca4.nFrames);
    for t=1:svca4.nFrames
        PET_t = PET(:,:,:,t);
        vals(s,t)  = mean(PET_t(indVOI));
    end
    figure; plot(svca4.PET_standardEndTimes,vals(s,:))
end

