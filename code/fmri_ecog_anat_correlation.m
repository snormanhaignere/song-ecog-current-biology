% Loads/plots the anatomical weight correlations between fMRI and ECoG 
% data along with fMRI & ECoG reliabilities (Fig 2C)

% path to the downloaded repository
repo_directory = fileparts(fileparts(which('fmri_ecog_anat_correlation.m')));

% load and plot the three matrices in Figure 2C
load([repo_directory '/data/fmri-ecog-correlations.mat'], ...
    'reliability_ecog', 'reliability_fmri', 'fmri_ecog_corr', ...
    'component_numbers', 'cbrew_blue_red_cmap');
corr_stats = {reliability_ecog, reliability_fmri, fmri_ecog_corr};
stat_names = {'ECoG', 'fMRI', 'ECoG-fMRI'};
figh = figure;
set(figh, 'Position', [100 100 1200 300]);
bounds = [-1, 1];
for i = 1:length(corr_stats)
    subplot(1,3,i);
    imagesc(corr_stats{i}, bounds);
    colormap(cbrew_blue_red_cmap);
    set(gca, 'XTick', 1:length(component_numbers), 'XTickLabel', component_numbers, ...
        'YTick', 1:length(component_numbers), 'YTickLabel', component_numbers);
    title(stat_names{i});
end