function [] = svca4_calculate(svca4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Supervised Cluster Analysis %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for targetID = svca4.targetIDs
    % exclude target from TAC
    GMWM_sel = svca4.GMWM_sel; GMWM_sel(svca4.GMWM_sel==targetID) = [];
    BLOOD_sel = svca4.BLOOD_sel; BLOOD_sel(svca4.BLOOD_sel==targetID) = [];
    TSPO_sel = svca4.TSPO_sel; TSPO_sel(svca4.TSPO_sel==targetID) = [];
    
    % Get Classes from TAC_TABLE : GRAY WHITE BLOOD TSPO
    CLASS(:,1) = nanmean(squeeze(svca4.TAC_TABLE_it00(GMWM_sel,1,:)),1);
    CLASS(:,2) = nanmean(squeeze(svca4.TAC_TABLE_it00(GMWM_sel,2,:)),1);
    CLASS(:,3) = nanmean(squeeze(svca4.TAC_TABLE_it00(BLOOD_sel,3,:)),1);
    CLASS(:,4) = nanmean(squeeze(svca4.TAC_TABLE_it00(TSPO_sel,4,:)),1);
    CLASS(isnan(CLASS)) = 0; % this might not be the best way but if we don't do it the regression doesn't work.
        
    %%% load brain mask %%%
    MASK_struct = load_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{targetID}));
    MASK = single(MASK_struct.img);
    
    %%% load target image %%%
    TARGET_struct = load_nii(fullfile(svca4.PET_dir, svca4.PET_list{targetID}));
    TARGET = single(TARGET_struct.img);
    %    svca4.Res = TARGET_struct.hdr.dime.pixdim([2 4 3]);
    xDim = size(TARGET,1);
    yDim = size(TARGET,2);
    zDim = size(TARGET,3);
    clear TARGET_struct
    
    %%% normalizing dPET target %%%
    indMASK = find(MASK==1);
    PET_norm = zeros(xDim,yDim,zDim,svca4.nFrames);
    for t=1:svca4.nFrames
        PET_t = TARGET(:,:,:,t);
        vals  = PET_t(indMASK) - mean(PET_t(indMASK));
        vals = vals/std(vals(:));
        PET_t_norm = PET_norm(:,:,:,t);
        PET_t_norm(indMASK) = vals;
        PET_norm(:,:,:,t) = PET_t_norm;
    end
    
    % Fitting kinetic classes
    fprintf('* Fitting kinetic classes for Target %d.\n',targetID);
    
    % initializing parametric maps
    GRAY = zeros(size(MASK));
    WHITE = GRAY; BLOOD = GRAY; TSPO = GRAY;
    
    % vectorizing target for speed
    PET_vector = reshape(PET_norm, xDim*yDim*zDim, svca4.nFrames);
    for j = 1:size(PET_vector,1);
        if MASK(j) > 0
            TAC = squeeze(PET_vector(j,:)');
            TAC(isnan(TAC)) = 0;
            % fitting
            par = lsqnonneg(CLASS,TAC);
            
            % filling parametric maps
            GRAY(j) = par(1);
            WHITE(j) = par(2);
            BLOOD(j) = par(3);
            TSPO(j) = par(4);
        end
    end
    
    if ~exist([svca4.outputPath filesep 'weights'],'dir')
        mkdir([svca4.outputPath filesep 'weights'])
    end
    
    %%% Save parametric maps %%%
    ifeedback=0;
    OUT_struct = MASK_struct;
    OUT_struct.img = [];
    
    fprintf('* Saving parametric maps for Target %d ...\n',targetID);
    
    fname = sprintf('%s/weights/%s_GRAY_it%.2d.nii', svca4.outputPath, svca4.Names{targetID}, ifeedback);
    OUT_struct.img = single(GRAY);
    save_nii(OUT_struct, fname);
    
    fname = sprintf('%s/weights/%s_WHITE_it%.2d.nii', svca4.outputPath, svca4.Names{targetID}, ifeedback);
    OUT_struct.img = single(WHITE);
    save_nii(OUT_struct, fname);
    
    fname = sprintf('%s/weights/%s_BLOOD_it%.2d.nii', svca4.outputPath, svca4.Names{targetID}, ifeedback);
    OUT_struct.img = single(BLOOD);
    save_nii(OUT_struct, fname);
    
    fname = sprintf('%s/weights/%s_TSPO_it%.2d.nii', svca4.outputPath, svca4.Names{targetID}, ifeedback);
    OUT_struct.img = single(TSPO);
    save_nii(OUT_struct, fname);
    
end
display('DONE')