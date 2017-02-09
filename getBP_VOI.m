load('/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_newstart/svca4_newstart.mat')

for s = 1:length(svca4.PET_list)
    subj = svca4.PET_list{s};
    subj = subj(1:5); % should remove this hard coding!!!
    
    %%% load VOI image %%%
    VOI_struct = load_nii([svca4.outputPath '/roiMasks/' subj '_thalamus.nii.gz']);
    VOI = single(VOI_struct.img);
    indVOI = find(VOI==1);
    
    BPc_struct = load_nii([svca4.outputPath '/petData_quantif/interfile_' subj '_pet_flip_CEREBa2_BPnd_SRTM2.nii']);
    BPc = single(BPc_struct.img);
    thalBPc(s) = mean(BPc(indVOI));
    
    BPs_struct = load_nii([svca4.outputPath '/petData_quantif/interfile_' subj '_pet_flip_SVCAa2_BPnd_SRTM2.nii']);
    BPs = single(BPs_struct.img);
    thalBPs(s) = mean(BPs(indVOI));
end

%%
load('/Users/scott/Dropbox/Experiments/nideco/NIDECO/forCor.mat')
hf = figure;
xSi = 5;
ySi = 5;
linWidth = 1.5;
fSize = 6;
lwidth = .8;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

plot(thalBPc,thalBPs,'*','MarkerSize',2.5)

coeffs = polyfit(thalBPc, thalBPs, 1);
% Get fitted values
fittedX = linspace(min(thalBPc), max(thalBPc), 200);
fittedY = polyval(coeffs, fittedX);
% Plot the fitted line
hold on;
plot(fittedX, fittedY, 'k-', 'LineWidth', lwidth);

title('Thalamus BPs')
xlabel('Cerebellum Reference')
ylabel('SVCA Reference')
text(0.09,0.03,'r=.85, p=.002')
set(gca,'FontSize',fSize)

print(gcf,'-dpng', '-r300','test.png')

%% class figure - should remove from here
hf = figure;
xSi = 5;
ySi = 5;
linWidth = 1.5;
fSize = 6;
lwidth = .8;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

plot(svca4.PET_standardEndTimes,mean(squeeze(svca4.TAC_TABLE(svca4.BLOOD_sel,1,:))),'-b','LineWidth',lwidth); hold on
plot(svca4.PET_standardEndTimes,mean(squeeze(svca4.TAC_TABLE(svca4.GMWM_sel,2,:))),'-g','LineWidth',lwidth)
plot(svca4.PET_standardEndTimes,mean(squeeze(svca4.TAC_TABLE(svca4.GMWM_sel,3,:))),'-r','LineWidth',lwidth)
plot(svca4.PET_standardEndTimes,mean(squeeze(svca4.TAC_TABLE(svca4.TSPO_sel,4,:))),'-k','LineWidth',lwidth)
legend('Grey','White','Blood','TSPO')
xlabel('Time (sec)')
ylabel('normalized kBq/cc')
title('Class TACs')

set(gca,'FontSize',fSize)
print(gcf,'-dpng', '-r300','teClass.png')
