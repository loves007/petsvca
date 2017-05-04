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

Nrand = [.1 1];
Nboots = 2000;
Output = zeros(numel(Nrand),Nboots,31,length(pet_files));
for s = 1:length(pet_files)
    subj = pet_files(s).name(1:6);
    
    %%% load pet image %%%
    PET_struct = load_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/data_pet/' pet_files(s).name]);
    PET = single(PET_struct.img);
    
    %%% load brain mask %%%
    %     BRAIN_struct = load_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/roiMasks/' brain_files(s).name]);
    %     BRAIN = single(BRAIN_struct.img);
    %     indBRAIN = find(BRAIN==1);
    
    %%% load Grey mask %%%
    GM_struct = load_nii(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_avc/gmwm/' gmwm_files(s).name]);
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
            GRAYt(:) = GRAYt(:)/numel(randInds);
            
            Output(n,b,:,s) = GRAYt;
        end
        numVox(n,s) = numel(randInds);
    end
    
    % get the cerebellum reference for this subject
    tacTable = readtable(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/TACs/' subj 'CB_GM.txt']);
    cereb(:,s) = tacTable.TAC_kBq_cc_;
    tacTable = readtable(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/TACs/' subj 'svcaRef_G0.00W1.00B1.00T1.00.txt']);
    thal(:,s) = tacTable.TAC_kBq_cc_;
    tacTable = readtable(['/Users/scott/Dropbox/Experiments/nideco/NIDECO/svca4_thals/TACs/' subj 'svcaRef_G0.05W0.05B0.05T0.05.txt']);
    thal_q(:,s) = tacTable.TAC_kBq_cc_;
end

%% smallest number of voxels
close all
hf = figure;
xSi = 16;
ySi = 14;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 5;
mSize = 2.5;
lWidth = 0.8;

ys = .13;
gap = .07;
s = .05;
ax(1) = axes('Position',[0 0 1 1],'Visible','off');
ax(2) = axes('Position',[.105 ys*4+gap*4+s .5-.105 ys]);
ax(3) = axes('Position',[.5+gap ys*4+gap*4+s .5-.105 ys]);
ax(4) = axes('Position',[.105 ys*3+gap*3+s .5-.105 ys]);
ax(5) = axes('Position',[.5+gap ys*3+gap*3+s .5-.105 ys]);
ax(6) = axes('Position',[.105 ys*2+gap*2+s .5-.105 ys]);
ax(7) = axes('Position',[.5+gap ys*2+gap*2+s .5-.105 ys]);
ax(8) = axes('Position',[.105 ys+gap+s .5-.105 ys]);
ax(9) = axes('Position',[.5+gap ys+gap+s .5-.105 ys]);
ax(10) = axes('Position',[.105 s .5-.105 ys]);
ax(11) = axes('Position',[.5+gap s .5-.105 ys]);

for s = 1:length(pet_files)
    x=s+1;
    p(1,:) = plot(ax(x),xt,squeeze(Output(1,:,:,s)),'-k','LineWidth',lWidth);hold(ax(x),'on')
    p2 = plot(ax(x),xt,cereb(:,s),'-g','LineWidth',lWidth);
    p3 = plot(ax(x),xt,thal(:,s),'-c','LineWidth',lWidth);
    p4 = plot(ax(x),xt,thal_q(:,s),'-r','LineWidth',lWidth);
    xlim(ax(x),[0 3600])
    ylabel(ax(x),'kBq/cc')
    set(ax(x),'box','off')
    %hl = legend(ax(x),[p2 p3 p4 p(1,1)],{'Cerebellum','svca_thal','svca_thal_q','Random'},'location','northoutside','orientation','horizontal','interpreter','none');
    %set(hl,'box','off')
end
hl = legend(ax(2),[p2 p3 p4 p(1,1)],{'Cerebellum','svca_thal','svca_thal_q','Random'},'location','northoutside','orientation','horizontal','interpreter','none');
set(hl,'box','off')

set(findall(gcf,'type','axes'),'FontSize',fSize)
print(gcf,'-dpng', '-r300','/Users/scott/GoogleDrive/pet_avc/TheSVCAPaper/figures/Love_ForFunSmall.png')

%% smallest number of voxels
close all
hf = figure;
xSi = 16;
ySi = 14;
linWidth = 2;
set(hf,'color','w',...
    'PaperUnits','centimeters',...
    'paperpositionmode','manual',...
    'paperposition',[0 0 xSi ySi],...
    'papersize',[xSi ySi])

fSize = 5;
mSize = 2.5;
lWidth = 0.8;

ys = .13;
gap = .07;
s = .05;
ax(1) = axes('Position',[0 0 1 1],'Visible','off');
ax(2) = axes('Position',[.105 ys*4+gap*4+s .5-.105 ys]);
ax(3) = axes('Position',[.5+gap ys*4+gap*4+s .5-.105 ys]);
ax(4) = axes('Position',[.105 ys*3+gap*3+s .5-.105 ys]);
ax(5) = axes('Position',[.5+gap ys*3+gap*3+s .5-.105 ys]);
ax(6) = axes('Position',[.105 ys*2+gap*2+s .5-.105 ys]);
ax(7) = axes('Position',[.5+gap ys*2+gap*2+s .5-.105 ys]);
ax(8) = axes('Position',[.105 ys+gap+s .5-.105 ys]);
ax(9) = axes('Position',[.5+gap ys+gap+s .5-.105 ys]);
ax(10) = axes('Position',[.105 s .5-.105 ys]);
ax(11) = axes('Position',[.5+gap s .5-.105 ys]);

for s = 1:length(pet_files)
    x=s+1;
    p(1,:) = plot(ax(x),xt,squeeze(Output(end,:,:,s)),'-k','LineWidth',lWidth);hold(ax(x),'on')
    p2 = plot(ax(x),xt,cereb(:,s),'-g','LineWidth',lWidth);
    p3 = plot(ax(x),xt,thal(:,s),'-c','LineWidth',lWidth);
    p4 = plot(ax(x),xt,thal_q(:,s),'-r','LineWidth',lWidth);
    xlim(ax(x),[0 3600])
    ylabel(ax(x),'kBq/cc')
    set(ax(x),'box','off')
    %hl = legend(ax(x),[p2 p3 p4 p(1,1)],{'Cerebellum','svca_thal','svca_thal_q','Random'},'location','northoutside','orientation','horizontal','interpreter','none');
    %set(hl,'box','off')
end
hl = legend(ax(2),[p2 p3 p4 p(1,1)],{'Cerebellum','svca_thal','svca_thal_q','Random'},'location','northoutside','orientation','horizontal','interpreter','none');
set(hl,'box','off')

set(findall(gcf,'type','axes'),'FontSize',fSize)
print(gcf,'-dpng', '-r300','/Users/scott/GoogleDrive/pet_avc/TheSVCAPaper/figures/Love_ForFunLarge.png')