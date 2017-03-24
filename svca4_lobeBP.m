function [BP] = svca4_lobeBP(bpTable)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gives the BP for each lobe, i.e., the average BP from all regions within
% the lobe.
% regions in lobes taken from: https://surfer.nmr.mgh.harvard.edu/fswiki/CorticalParcellation
% Desikan-Killiany ROIs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frontal.name = {'ctx_lh_superiorfrontal' 'ctx_rh_superiorfrontal'...
    'ctx_lh_rostralmiddlefrontal' 'ctx_rh_rostralmiddlefrontal'...
    'ctx_lh_caudalmiddlefrontal' 'ctx_rh_caudalmiddlefrontal'...
    'ctx_lh_parsopercularis' 'ctx_rh_parsopercularis'...
    'ctx_lh_parstriangularis' 'ctx_rh_parstriangularis'...
    'ctx_lh_parsorbitalis' 'ctx_rh_parsorbitalis'...
    'ctx_lh_lateralorbitofrontal' 'ctx_rh_lateralorbitofrontal'...
    'ctx_lh_medialorbitofrontal' 'ctx_rh_medialorbitofrontal'...
    'ctx_lh_precentral' 'ctx_rh_precentral'...
    'ctx_lh_paracentral' 'ctx_rh_paracentral'...
    'ctx_lh_frontalpole' 'ctx_rh_frontalpole'};
frontal.num = [69 104 68 103 45 80 59 94 61 96 60 95 53 88 55 90 65 100 58 93 73 108];
BP.frontal = mean(bpTable{:,frontal.num},2);

parietal.name = {'ctx_lh_superiorparietal' 'ctx_rh_superiorparietal'...
    'ctx_lh_inferiorparietal' 'ctx_rh_inferiorparietal'...
    'ctx_lh_supramarginal' 'ctx_rh_supramarginal'...
    'ctx_lh_postcentral' 'ctx_rh_postcentral'...
    'ctx_lh_precuneus' 'ctx_rh_precuneus'};
parietal.num = [70 105 49 84 72 107 63 98 66 101];
BP.parietal = mean(bpTable{:,parietal.num},2);


temporal.name = {'ctx_lh_superiortemporal' 'ctx_rh_superiortemporal'...
    'ctx_lh_middletemporal' 'ctx_rh_middletemporal'...
    'ctx_lh_inferiortemporal' 'ctx_rh_inferiortemporal'...
    'ctx_lh_bankssts' 'ctx_rh_bankssts'...
    'ctx_lh_fusiform' 'ctx_rh_fusiform'...
    'ctx_lh_transversetemporal' 'ctx_rh_transversetemporal'...
    'ctx_lh_entorhinal' 'ctx_rh_entorhinal'...
    'ctx_lh_temporalpole' 'ctx_rh_temporalpole'...
    'ctx_lh_parahippocampal' 'ctx_rh_parahippocampal'};
temporal.num = [71 106 56 91 50 85 43 78 48 83 75 110 47 82 74 109 57 92];
BP.temporal = mean(bpTable{:,temporal.num},2);

occipital.name = {'ctx_lh_lateraloccipital' 'ctx_rh_lateraloccipital'...
    'ctx_lh_lingual' 'ctx_rh_lingual'...
    'ctx_lh_cuneus' 'ctx_rh_cuneus'...
    'ctx_lh_pericalcarine' 'ctx_rh_pericalcarine'};
occipital.num = [52 87 54 89 46 81 62 97];
BP.occipital = mean(bpTable{:,occipital.num},2);
