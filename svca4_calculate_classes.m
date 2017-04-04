function [TAC_TABLE] = svca4_calculate_classes(svca4)

clear TAC_TABLE
global svca4

svca4
%%% %%%

% There are probably less TSPO masks than other masks. This next bit of
% code trys to put the TSPO masks in the correct place for the fi loop
% below. It works now for me but may cause problems for other situations!!!
% It might be necessary to do something similar for all file types. It
% might require a total rethink of how things are done!
if length(svca4.INF_list) < length(svca4.classIDs)
    tmp = cell(1,length(svca4.classIDs));
    tmp(1,svca4.TSPO_sel) = svca4.INF_list;
    svca4.INF_list = tmp;
end

%%% parse aquisition times %%%
times = readtable(fullfile(svca4.TIMES_dir, svca4.TIMES));
svca4.PET_standardStartTimes = times.Start;
svca4.PET_standardMidTimes = times.Mid;
svca4.PET_standardDurations = times.Duration;
svca4.PET_standardEndTimes = times.End;

fprintf('* Calculating CLASS TACs. Please wait ...\n');
for fi=svca4.classIDs
    %%% time info %%%
    % NB: this is really just a placeholder and is not really used
    % now. In the future it can be used when there are different
    % times for different subjects.
    svca4.PET_starttimes = svca4.PET_standardStartTimes;
    svca4.PET_midtimes = svca4.PET_standardMidTimes;
    svca4.PET_durations = svca4.PET_standardDurations;
    
    %%% load brain mask %%%
    MASK_struct = load_untouch_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{fi}));
    MASK = single(MASK_struct.img);
    %clear MASK_struct
    
    %%% load PET image %%%
    PET_struct = load_untouch_nii(fullfile(svca4.PET_dir, svca4.PET_list{fi}));
    PET = single(PET_struct.img);
    svca4.Res = PET_struct.hdr.dime.pixdim([2 4 3]); %
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    %clear PET_struct;
    
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
        if isfield(svca4,'BANANA_list')
            BANANA_fname = fullfile(svca4.BANANA_dir, svca4.BANANA_list{fi});
            BANANA_struct = load_untouch_nii(BANANA_fname);
            BANANA = single(BANANA_struct.img); clear BANANA_struct
            BM4D = repmat(BANANA, [1 1 1 numel(svca4.BLOOD_frames)]);
            firstFrames = PET_norm(:,:,:,svca4.BLOOD_frames).*single(BM4D);
        else firstFrames = PET_norm(:,:,:,svca4.BLOOD_frames);
        end
        
        vox_tm_max = max(firstFrames, [], 4);
        out_blood_vox = zeros(size(vox_tm_max));
        
        BLOOD = zeros(1,svca4.nFrames); % BLOOD on normalized image
        for j=1:svca4.BLOOD_num_pixels
            [~, ind] = max(vox_tm_max(:));
            [indx, indy, indz] = ind2sub([xDim yDim zDim], ind);
            BLOOD = BLOOD + squeeze(PET_norm(indx,indy,indz,1:svca4.nFrames))';
            vox_tm_max(indx, indy, indz) = 0;
            out_blood_vox(indx, indy, indz) = 1;
        end
        TAC_TABLE(fi,3,1:svca4.nFrames) = squeeze(BLOOD/svca4.BLOOD_num_pixels);
        OUT_struct = MASK_struct;
        OUT_struct.img = [];
                
        fname = sprintf('%s/BloodVoxels/%s_BloodVoxels.nii.gz', svca4.outputPath, svca4.Names{fi});
        OUT_struct.img = single(out_blood_vox);
        save_untouch_nii(OUT_struct, fname);
    end
    
    %%% GM/WM classes %%%
    isGMWM = any(svca4.GMWM_sel==fi);
    if isGMWM
        SEG_fname = fullfile(svca4.SEG_dir, svca4.SEG_list{fi});
        SEG_struct = load_untouch_nii(SEG_fname);
        GM = single(SEG_struct.img).*MASK; clear SEG_struct;
        WM = GM; WM(WM~=2) = 0; WM(WM==2)=1;
        GM(GM~=1) = 0;
        GM(GM~=1) = 0; % retain only pure GM
        WM(WM~=1) = 0; % retain only pure WM
        if isfield(svca4,'GMWMerodeParameter')
            %myStrel = strel(ones(svca4.GMWMerodeParameter ,svca4.GMWMerodeParameter ,svca4.GMWMerodeParameter));
            %WM = imerode(WM, myStrel);
            %GM = imerode(GM, myStrel);
            WM = sffilt('min',WM,[svca4.GMWMerodeParameter svca4.GMWMerodeParameter svca4.GMWMerodeParameter]);
            GM = sffilt('min',GM,[svca4.GMWMerodeParameter svca4.GMWMerodeParameter svca4.GMWMerodeParameter]);
            
        end
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
        INF_fname = fullfile(svca4.INF_dir, svca4.INF_list{fi});
        INF_struct = load_untouch_nii(INF_fname);
        INF = single(INF_struct.img); clear INF_struct;
        % it's not here we want to dilate!
        %         if svca4.TSPODilateParameter
        %             %myStrel = strel(ones(svca4.TSPODilateParameter ,svca4.TSPODilateParameter ,svca4.TSPODilateParameter));
        %             %INF = imerode(INF, myStrel);
        %             INF = sffilt('min',INF,[svca4.TSPODilateParameter svca4.TSPODilateParameter svca4.TSPODilateParameter]);
        %         end
        for t=1:svca4.nFrames
            tmp = single(INF).*PET_norm(:,:,:,t);
            TAC_TABLE(fi,4,t) = mean(tmp(tmp~=0));
        end
    end
end
svca4.classes_it00 = TAC_TABLE;

uisave({'svca4'}, 'svca4.mat')