% Loads/plots ECoG predictions of music/speech-selective fMRI components (Figure 7)

% path to the downloaded repository
repo_directory = fileparts(fileparts(which('fmri_component_predictions.m')));

% load and plot music component responses and predictions
load([repo_directory '/data/fMRI-component-predictions/music.mat'], ...
    'fmri_comp', 'ecog_pred', 'C');
figh = figure;
set(figh, 'Position', [100 100 500 500]);
bounds = [min([fmri_comp; ecog_pred]), max([fmri_comp; ecog_pred])];
bounds = bounds + [-1,1]*diff(bounds)*0.1;
plot(bounds, bounds, 'k-', 'LineWidth', 2); hold on;
for k = 1:size(R,1)
    h = plot(ecog_pred(k),fmri_comp(k), 'o', ...
        'Color', C.colors(C.category_assignments(k),:), ...
        'LineWidth', 3, 'MarkerSize', 10);
end
xlabel('Predicted'); ylabel('Actual');
xlim(bounds); ylim(bounds);