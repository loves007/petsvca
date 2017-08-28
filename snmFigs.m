%% SNM Talk:
close all
avc = '/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_snm_avc/';
thal = '/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_snm_thal/';

close all
hf = figure;
xSi = 10;
ySi = 7;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 10;
mSize = 2;
lWidth = 1.5;

% ax1
% do avc mean
load([avc 'svca4_snm_avc.mat'])
plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.classes_it00(svca4.GMWM_sel,1,:))),'-d','LineWidth',lWidth,'color', [0.9290    0.6940    0.1250]); hold on
plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.classes_it00(svca4.GMWM_sel,2,:))),'-s','LineWidth',lWidth,'MarkerFaceColor',[0    0.4470    0.7410],'color', [0    0.4470    0.7410])
plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.classes_it00(svca4.BLOOD_sel,3,:))),'-x','LineWidth',lWidth,'color', [0.8500    0.150    0.0980])
plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.classes_it00(svca4.TSPO_sel,4,:))),'-^','LineWidth',lWidth,'MarkerFaceColor',[0.4940    0.1840    0.5560],'color', [0.4940    0.1840    0.5560])

% do thal
load([thal 'svca4_snm_thal.mat'])
plot(svca4.PET_standardEndTimes,nanmean(squeeze(svca4.classes_it00(svca4.TSPO_sel,4,:))),'-o','LineWidth',lWidth,'MarkerFaceColor',[0.4660    0.6740    0.1880],'color', [0.4660    0.6740    0.1880])
ylim([-1 8])
xlim([0 3600])

set(findall(gcf,'type','line'),'MarkerSize',mSize)
hl = legend('Grey','White','Blood','HSB-Stroke','HSB-Thalamus');
set(hl,'box','off')

xlabel('Time after injection (sec)')
ylabel('normalized Bq/cc')
set(findall(gcf,'type','axes'),'FontSize',fSize)

set(gca,'box','off')
print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/classes.png')

%%
close all
meanTACs = '/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/';
avc = '/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/';
thal = '/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/';

cereb = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/mean_CB_GM.txt');
thal = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/thal_mean_svcaRef_G0.00W1.00B1.00T1.00.txt');
thal_q = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/thal_q_mean_svcaRef_G0.05W0.05B0.05T0.05.txt');
avc = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/avc_mean_svcaRef_G0.00W1.00B1.00T1.00.txt');
avc_q = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/avc_q_mean_svcaRef_G0.05W0.05B0.05T0.05.txt');
noCB_thal_q = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/thal_q_mean_noCB_svcaRef_G0.05W0.05B0.05T0.05.txt');
noCB_avc_q = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/avc_q_mean_noCB_svcaRef_G0.05W0.05B0.05T0.05.txt');
noCB_thal = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/thal_mean_noCB_svcaRef_G0.00W1.00B1.00T1.00.txt');
noCB_avc = readtable('/Users/scott/Dropbox/Experiments/nideco/NIDECO/FigureTACs/avc_mean_noCB_svcaRef_G0.00W1.00B1.00T1.00.txt');

close all
hf = figure;
xSi = 10;
ySi = 7;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 10;
mSize = 2;
lWidth = 1.5;

plot(cereb.end_seconds_,cereb.TAC_1_1_,'LineWidth',lWidth,'color',[0.4660    0.6740    0.1880]);hold on
plot(thal.end_seconds_,thal.TAC_1_1_,'LineWidth',lWidth,'color',[0    0.4470    0.7410]);hold on
plot(avc.end_seconds_,avc.TAC_1_1_,'LineWidth',lWidth,'color',[0.9290    0.6940    0.1250]);hold on

xlim([0 3600])

xlabel('Time after injection (sec)')
ylabel('Bq/cc')
set(gca,'box','off')

hh = legend('Cerebellum','svca_HSB-thalamus','svca_HSB-stroke');
set(hh,'box','off','Interpreter', 'none','Location','south')
print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/thalVavc.png')

%% with the no CB as well
close all
hf = figure;
xSi = 10;
ySi = 7;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 10;
mSize = 2;
lWidth = 1.5;

plot(cereb.end_seconds_,cereb.TAC_1_1_,'LineWidth',lWidth,'color',[0.4660    0.6740    0.1880]);hold on
plot(thal.end_seconds_,thal.TAC_1_1_,'LineWidth',lWidth,'color',[0    0.4470    0.7410]);hold on
plot(noCB_thal.end_seconds_,noCB_thal.TAC_1_1_,'--','LineWidth',lWidth,'color',[0    0.4470    0.7410]);hold on

plot(avc.end_seconds_,avc.TAC_1_1_,'LineWidth',lWidth,'color',[0.9290    0.6940    0.1250]);hold on
plot(noCB_avc.end_seconds_,noCB_avc.TAC_1_1_,'--','LineWidth',lWidth,'color',[0.9290    0.6940    0.1250]);hold on

xlim([0 3600])

xlabel('Time after injection (sec)')
ylabel('Bq/cc')
set(gca,'box','off')

hh = legend('Cerebellum','svca_HSB-thalamus','svca_HSB-thalamus_noCerebellum','svca_HSB-stroke','svca_HSB-stroke_noCerebellum');
set(hh,'box','off','Interpreter', 'none','Location','south')
print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/cbVnocb.png')

%% with quantiles
close all
hf = figure;
xSi = 10;
ySi = 8;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 10;
mSize = 2;
lWidth = 1.5;

plot(cereb.end_seconds_,cereb.TAC_1_1_,'LineWidth',lWidth,'color',[0.4660    0.6740    0.1880]);hold on
plot(thal.end_seconds_,thal.TAC_1_1_,'LineWidth',lWidth,'color',[0    0.4470    0.7410]);hold on
plot(thal_q.end_seconds_,thal_q.TAC_1_1_,'--','LineWidth',lWidth,'color',[0    0.4470    0.7410]);hold on

plot(avc.end_seconds_,avc.TAC_1_1_,'LineWidth',lWidth,'color',[0.9290    0.6940    0.1250]);hold on
plot(avc_q.end_seconds_,avc_q.TAC_1_1_,'--','LineWidth',lWidth,'color',[0.9290    0.6940    0.1250]);hold on

xlim([0 3600])

xlabel('Time after injection (sec)')
ylabel('Bq/cc')
set(gca,'box','off')

hh = legend('Cerebellum','svca_HSB-thalamus','svca_HSB-thalamus_quantiles','svca_HSB-stroke','svca_HSB-stroke_quantiles');
set(hh,'box','off','Interpreter', 'none','Location','south')
print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/quantiles.png')


%%
% define the lobes
%%%% Compare noCB to CB models %%%
cd('/Users/scott/Dropbox/Experiments/nideco/NIDECO/quantification')
% load stroke HSB model with and without CB
stroke = load('svca_strokeSRTM2.mat','bpTable');
stroke_nC = load('svca_stroke_noCBSRTM2.mat','bpTable');
stroke_q = load('svca_stroke_qSRTM2.mat','bpTable');
cereb = load('cerebellumSRTM2.mat','bpTable');
clear bpTable

% load thalamus HSB model with and without CB
thal = load('svca_thalamusSRTM2.mat','bpTable');
thal_nC = load('svca_thalamus_noCBSRTM2.mat','bpTable');
clear bpTable

lobes.stroke = svca4_lobeBP(stroke.bpTable);
lobes.stroke_nC = svca4_lobeBP(stroke_nC.bpTable);
lobes.stroke_q = svca4_lobeBP(stroke_q.bpTable);
lobes.thal = svca4_lobeBP(thal.bpTable);
lobes.thal_nC = svca4_lobeBP(thal_nC.bpTable);
lobes.cereb = svca4_lobeBP(cereb.bpTable);


%%% average across hemisphere and get correlation between with and without CB
%%% HSB-stroke %%%
% for stroke_thal
stroke.thalamus = mean([stroke.bpTable.Left_Thalamus_Proper stroke.bpTable.Right_Thalamus_Proper],2);
stroke_nC.thalamus = mean([stroke_nC.bpTable.Left_Thalamus_Proper stroke_nC.bpTable.Right_Thalamus_Proper],2);
[R.stroke.thal,P.stroke.thal,RL.stroke.thal,RU.stroke.thal] = corrcoef(stroke.thalamus,stroke_nC.thalamus);
% for stroke_putamen
stroke.putamen = mean([stroke.bpTable.Left_Putamen stroke.bpTable.Right_Putamen],2);
stroke_nC.putamen = mean([stroke_nC.bpTable.Left_Putamen stroke_nC.bpTable.Right_Putamen],2);
[R.stroke.putamen,P.stroke.putamen,RL.stroke.putamen,RU.stroke.putamen] = corrcoef(stroke.putamen,stroke_nC.putamen);
% for stroke_caudate
stroke.caudate = mean([stroke.bpTable.Left_Caudate stroke.bpTable.Right_Caudate],2);
stroke_nC.caudate = mean([stroke_nC.bpTable.Left_Caudate stroke_nC.bpTable.Right_Caudate],2);
[R.stroke.caudate,P.stroke.caudate,RL.stroke.caudate,RU.stroke.caudate] = corrcoef(stroke.caudate,stroke_nC.caudate);
% for stroke_hippo
stroke.hippo = mean([stroke.bpTable.Left_Hippocampus stroke.bpTable.Right_Hippocampus],2);
stroke_nC.hippo = mean([stroke_nC.bpTable.Left_Hippocampus stroke_nC.bpTable.Right_Hippocampus],2);
[R.stroke.hippo,P.stroke.hippo,RL.stroke.hippo,RU.stroke.hippo] = corrcoef(stroke.hippo,stroke_nC.hippo);
% for stroke_whiteMatter
stroke.white = mean([stroke.bpTable.Left_Cerebral_White_Matter stroke.bpTable.Right_Cerebral_White_Matter],2);
stroke_nC.white = mean([stroke_nC.bpTable.Left_Cerebral_White_Matter stroke_nC.bpTable.Right_Cerebral_White_Matter],2);
[R.stroke.white,P.stroke.white,RL.stroke.white,RU.stroke.white] = corrcoef(stroke.white,stroke_nC.white);
% for stroke_cerebellum
stroke.cerebellum = mean([stroke.bpTable.Left_Cerebellum_Cortex stroke.bpTable.Right_Cerebellum_Cortex],2);
stroke_nC.cerebellum = mean([stroke_nC.bpTable.Left_Cerebellum_Cortex stroke_nC.bpTable.Right_Cerebellum_Cortex],2);
[R.stroke.cerebellum,P.stroke.cerebellum,RL.stroke.cerebellum,RU.stroke.cerebellum] = corrcoef(stroke.cerebellum,stroke_nC.cerebellum);

[R.stroke.frontal,P.stroke.frontal,RL.stroke.frontal,RU.stroke.frontal] = corrcoef(lobes.stroke.frontal,lobes.stroke_nC.frontal);
[R.stroke.parietal,P.stroke.parietal,RL.stroke.parietal,RU.stroke.parietal] = corrcoef(lobes.stroke.parietal,lobes.stroke_nC.parietal);
[R.stroke.temporal,P.stroke.temporal,RL.stroke.temporal,RU.stroke.temporal] = corrcoef(lobes.stroke.temporal,lobes.stroke_nC.temporal);
[R.stroke.occipital,P.stroke.occipital,RL.stroke.occipital,RU.stroke.occipital] = corrcoef(lobes.stroke.occipital,lobes.stroke_nC.occipital);

%%% HSB-thalamus %%%
% for thal_thal
thal.thalamus = mean([thal.bpTable.Left_Thalamus_Proper thal.bpTable.Right_Thalamus_Proper],2);
thal_nC.thalamus = mean([thal_nC.bpTable.Left_Thalamus_Proper thal_nC.bpTable.Right_Thalamus_Proper],2);
[R.thal.thal,P.thal.thal,RL.thal.thal,RU.thal.thal] = corrcoef(thal.thalamus,thal_nC.thalamus);
% for thal_putamen
thal.putamen = mean([thal.bpTable.Left_Putamen thal.bpTable.Right_Putamen],2);
thal_nC.putamen = mean([thal_nC.bpTable.Left_Putamen thal_nC.bpTable.Right_Putamen],2);
[R.thal.putamen,P.thal.putamen,RL.thal.putamen,RU.thal.putamen] = corrcoef(thal.putamen,thal_nC.putamen);
% for thal_caudate
thal.caudate = mean([thal.bpTable.Left_Caudate thal.bpTable.Right_Caudate],2);
thal_nC.caudate = mean([thal_nC.bpTable.Left_Caudate thal_nC.bpTable.Right_Caudate],2);
[R.thal.caudate,P.thal.caudate,RL.thal.caudate,RU.thal.caudate] = corrcoef(thal.caudate,thal_nC.caudate);
% for thal_hippo
thal.hippo = mean([thal.bpTable.Left_Hippocampus thal.bpTable.Right_Hippocampus],2);
thal_nC.hippo = mean([thal_nC.bpTable.Left_Hippocampus thal_nC.bpTable.Right_Hippocampus],2);
[R.thal.hippo,P.thal.hippo,RL.thal.hippo,RU.thal.hippo] = corrcoef(thal.hippo,thal_nC.hippo);
% for thal_whiteMatter
thal.white = mean([thal.bpTable.Left_Cerebral_White_Matter thal.bpTable.Right_Cerebral_White_Matter],2);
thal_nC.white = mean([thal_nC.bpTable.Left_Cerebral_White_Matter thal_nC.bpTable.Right_Cerebral_White_Matter],2);
[R.thal.white,P.thal.white,RL.thal.white,RU.thal.white] = corrcoef(thal.white,thal_nC.white);
% for thal_cerebellum
thal.cerebellum = mean([thal.bpTable.Left_Cerebellum_Cortex thal.bpTable.Right_Cerebellum_Cortex],2);
thal_nC.cerebellum = mean([thal_nC.bpTable.Left_Cerebellum_Cortex thal_nC.bpTable.Right_Cerebellum_Cortex],2);
[R.thal.cerebellum,P.thal.cerebellum,RL.thal.cerebellum,RU.thal.cerebellum] = corrcoef(thal.cerebellum,thal_nC.cerebellum);

[R.thal.frontal,P.thal.frontal,RL.thal.frontal,RU.thal.frontal] = corrcoef(lobes.thal.frontal,lobes.thal_nC.frontal);
[R.thal.parietal,P.thal.parietal,RL.thal.parietal,RU.thal.parietal] = corrcoef(lobes.thal.parietal,lobes.thal_nC.parietal);
[R.thal.temporal,P.thal.temporal,RL.thal.temporal,RU.thal.temporal] = corrcoef(lobes.thal.temporal,lobes.thal_nC.temporal);
[R.thal.occipital,P.thal.occipital,RL.thal.occipital,RU.thal.occipital] = corrcoef(lobes.thal.occipital,lobes.thal_nC.occipital);

% thal vs avc
[R.avcVsthal.thal,P.avcVsthal.thal,RL.avcVsthal.thal,RU.avcVsthal.thal] = corrcoef(stroke.thalamus,thal.thalamus);

cereb.thalamus = mean([cereb.bpTable.Left_Thalamus_Proper cereb.bpTable.Right_Thalamus_Proper],2);
cereb.putamen = mean([cereb.bpTable.Left_Putamen cereb.bpTable.Right_Putamen],2);
cereb.hippo = mean([cereb.bpTable.Left_Hippocampus cereb.bpTable.Right_Hippocampus],2);
cereb.caudate = mean([cereb.bpTable.Left_Caudate cereb.bpTable.Right_Caudate],2);


%%
close all
% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(stroke.thalamus(1:8),thal.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke.thalamus(9:10),thal.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
ylabel('BP for HSB-thalamus')
xlabel('BP for HSB-stroke')
title('Thalamus')
[r,p] = corrcoef(stroke.thalamus,thal.thalamus);
text(.04,.92,'r = .98, p = .0001')

subplot(1,3,2)
plot(lobes.stroke.temporal(1:8),lobes.thal.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.stroke.temporal(9:10),lobes.thal.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-stroke')
title('Temporal')
[r,p] = corrcoef(lobes.stroke.temporal,lobes.thal.temporal);
text(.04,.55,'r = .94, p = .0001')

subplot(1,3,3)
plot(stroke.putamen(1:8),thal.putamen(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke.putamen(9:10),thal.putamen(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-stroke')
title('Putamen')
set(findall(gcf,'type','axes'),'FontSize',fSize)
[r,p] = corrcoef(stroke.putamen,thal.putamen);

text(.04,.55,'r = .87, p = .0001')

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_thalVSavc.png')

%% cereb no cereb
close all
% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(stroke_nC.thalamus(1:8),stroke.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke_nC.thalamus(9:10),stroke.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
ylabel('BP for HSB-stroke_noCerebellum','Interpreter','none')
title('Thalamus')
[r,p] = corrcoef(stroke.thalamus,stroke_nC.thalamus);
text(.04,.92,'r = .99, p = .0001')

subplot(1,3,2)
plot(lobes.stroke_nC.temporal(1:8),lobes.stroke.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.stroke_nC.temporal(9:10),lobes.stroke.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
%ylabel('BP for HSB-stroke_noCerebellum','Interpreter','none')
title('Temporal')
[r,p] = corrcoef(lobes.stroke.temporal,lobes.stroke_nC.temporal);
text(.04,.92,'r = .99, p = .0001')

subplot(1,3,3)
plot(stroke_nC.putamen(1:8),stroke.putamen(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke_nC.putamen(9:10),stroke.putamen(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
%ylabel('BP for HSB-stroke_noCerebellum','Interpreter','none')
title('Putamen')
[r,p] = corrcoef(lobes.stroke.temporal,lobes.stroke_nC.temporal);
text(.04,.92,'r = .99, p = .0001')
set(findall(gcf,'type','axes'),'FontSize',fSize)

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_cbVnocb.png')

%% cereb no cereb thal
close all
% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(thal_nC.thalamus(1:8),thal.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(thal_nC.thalamus(9:10),thal.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-thalamus')
ylabel('BP for HSB-thalamus_noCerebellum','Interpreter','none')
title('Thalamus')
[r,p] = corrcoef(thal_nC.thalamus,thal.thalamus);
text(.04,.92,'r = .99, p = .0001')

subplot(1,3,2)
plot(lobes.thal_nC.temporal(1:8),lobes.thal.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.thal_nC.temporal(9:10),lobes.thal.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-thalamus')
%ylabel('BP for HSB-stroke_noCerebellum','Interpreter','none')
title('Temporal')
[r,p] = corrcoef(lobes.thal.temporal,lobes.thal_nC.temporal);
text(.04,.92,'r = .99, p = .0001')

subplot(1,3,3)
plot(thal_nC.putamen(1:8),thal.putamen(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(thal_nC.putamen(9:10),thal.putamen(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-thalamus')
%ylabel('BP for HSB-stroke_noCerebellum','Interpreter','none')
title('Putamen')
[r,p] = corrcoef(lobes.thal_nC.temporal,lobes.thal.temporal);
text(.04,.92,'r = .99, p = .0001')
set(findall(gcf,'type','axes'),'FontSize',fSize)

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_cbVnocbTHAL.png')

%% quant no quant
close all

stroke_q.thalamus= mean([stroke_q.bpTable.Left_Thalamus_Proper stroke_q.bpTable.Right_Thalamus_Proper],2);
stroke_q.putamen = mean([stroke_q.bpTable.Left_Putamen stroke_q.bpTable.Right_Putamen],2);

% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(stroke_q.thalamus(1:8),stroke.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke_q.thalamus(9:10),stroke.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
ylabel('BP for HSB-stroke_quantiles','Interpreter','none')
title('Thalamus')
[r,p] = corrcoef(stroke.thalamus,stroke_q.thalamus);
text(.04,.92,'r = .97, p = .0001')

subplot(1,3,2)
plot(lobes.stroke_q.temporal(1:8),lobes.stroke.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.stroke_q.temporal(9:10),lobes.stroke.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
ylabel('BP for HSB-stroke_quantiles','Interpreter','none')
title('Temporal')
[r,p] = corrcoef(lobes.stroke.temporal,lobes.stroke_q.temporal);
text(.04,.92,'r = .85, p = .0015')

subplot(1,3,3)
plot(stroke_q.putamen(1:8),stroke.putamen(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke_q.putamen(9:10),stroke.putamen(9:10),'k+','markersize',mSize); hold on
axis([0 1 0 1])
xlabel('BP for HSB-Stroke')
ylabel('BP for HSB-stroke_quantiles','Interpreter','none')
title('Putamen')
[r,p] = corrcoef(stroke_q.putamen,stroke.putamen);
text(.04,.92,'r = .48, p = .1')
set(findall(gcf,'type','axes'),'FontSize',fSize)

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_quants.png')

%%
close all
% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(stroke.thalamus(1:8),cereb.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke.thalamus(9:10),cereb.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
ylabel('BP for Cerebellum')
xlabel('BP for HSB-stroke')
title('Thalamus')
[r,p] = corrcoef(stroke.thalamus,cereb.thalamus);
text(.04,.92,'r = .96, p = .0001')

subplot(1,3,2)
plot(lobes.stroke.temporal(1:8),lobes.cereb.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.stroke.temporal(9:10),lobes.cereb.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-stroke')
title('Temporal')
[r,p] = corrcoef(lobes.stroke.temporal,lobes.cereb.temporal);
text(.04,.55,'r = .94, p = .0001')

subplot(1,3,3)
plot(stroke.caudate(1:8),cereb.caudate(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(stroke.caudate(9:10),cereb.caudate(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-stroke')
title('Putamen')
set(findall(gcf,'type','axes'),'FontSize',fSize)

[r,p] = corrcoef(stroke.caudate,cereb.caudate);

text(.04,.275,'r = .93, p = .0001')

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_cerebVavc.png')

%%
close all
% plot
hf = figure;
xSi = 15;
ySi = 5;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 6;
mSize = 3.5;
lWidth = 0.8;

set(gcf,'color','w')
subplot(1,3,1)
plot(thal.thalamus(1:8),cereb.thalamus(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(thal.thalamus(9:10),cereb.thalamus(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
ylabel('BP for Cerebellum')
xlabel('BP for HSB-thalamus')
title('Thalamus')
[r,p] = corrcoef(thal.thalamus,cereb.thalamus);
text(.04,.92,'r = .96, p = .0001')

subplot(1,3,2)
plot(lobes.thal.temporal(1:8),lobes.cereb.temporal(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(lobes.thal.temporal(9:10),lobes.cereb.temporal(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-thalamus')
title('Temporal')
[r,p] = corrcoef(lobes.thal.temporal,lobes.cereb.temporal);
text(.04,.275,'r = .94, p = .0001')

subplot(1,3,3)
plot(thal.putamen(1:8),cereb.putamen(1:8),'o','markersize',mSize,'MarkerFaceColor','b'); hold on
set(gca,'ColorOrderIndex',1);
plot(thal.putamen(9:10),cereb.putamen(9:10),'k+','markersize',mSize); hold on
axis([0 max(axis) 0 max(axis)])
%ylabel('HSB-thalamus')
xlabel('BP for HSB-thalamus')
title('Putamen')
set(findall(gcf,'type','axes'),'FontSize',fSize)

[r,p] = corrcoef(thal.putamen,cereb.putamen);

text(.04,.275,'r = .72, p = .021')

print(gcf,'-dpng', '-r1500','/Users/scott/GoogleDrive/pet_avc/snmmi_2017/snmTalk/BP_cerebVthal.png')
