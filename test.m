clear all
close all
clc
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
refTAC = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/TACs/02_02_CB_GM.txt');

%pet = load_untouch_nii('/Users/scott/Dropbox/Experiments/nideco/NIDECO/data_pet/02_02_pet_flip.nii');
pet = load_nii('/Users/scott/Dropbox/Experiments/nideco/NIDECO/data_pet/02_02_nifti_from_dicom_PMOD.nii');
PET = pet.img;

PET(10:20,10:20,10:20,:) = repmat(reshape(refTAC.TAC_kBq_cc_,1,1,1,31),11,11,11,1);
pet.img = PET;
save_nii(pet,'/Users/scott/Dropbox/Experiments/nideco/NIDECO/data_pet/02_02_nifti_from_dicom_PMOD_resaved.nii')


pet_un = load_nii('/Users/scott/Dropbox/Experiments/nideco/NIDECO/data_pet/02_02_nifti_from_dicom_PMOD_resaved.nii');
PET = single(pet.img);

out = [refTAC.TAC_kBq_cc_...
       refTAC.TAC_kBq_cc_.*pet_un.hdr.dime.scl_slope...
       squeeze(pet_un.img(15,15,15,:))...
       squeeze(pet_un.img(15,15,15,:)).*pet_un.hdr.dime.scl_slope]
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scottWeights = load_untouch_nii('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals_pmod/weights/01_08_GRAY_it00.nii');
[im_TEP,TEPinfos]=gtiminterfileread('/Users/scott/Dropbox/Experiments/nideco/NIDECO/data_interfile/SVCA_map_grey_s01.hdr');

close all
figure; imagesc(squeeze(scottWeights.img(end:-1:1,end:-1:1,45)))
figure; imagesc(squeeze(im_TEP(:,:,45)))

sMean = mean(scottWeights.img(scottWeights.img ~= 0))
sSTD = std(scottWeights.img(scottWeights.img ~= 0))

cMean = mean(im_TEP(im_TEP ~= 0))
cSTD = std(im_TEP(im_TEP ~= 0))

diff = squeeze(scottWeights.img(end:-1:1,end:-1:1,:))-squeeze(im_TEP(:,:,:));

[min(diff(:)) mean(diff(:)) max(diff(:)) std(diff(:))]

[min(unique(squeeze(scottWeights.img(end:-1:1,end:-1:1,:))-squeeze(im_TEP(:,:,:)))) max(unique(squeeze(scottWeights.img(end:-1:1,end:-1:1,:))-squeeze(im_TEP(:,:,:))))]
