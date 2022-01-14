% Loads and plots category-selective electrodes (Figure 6)

% path to the downloaded repository
repo_directory = fileparts(fileparts(which('category_selective_electrodes.m')));

% Load response of one electrode plus auxilliary info
% R: sound x time
% t: time stamps in seconds
% C: structure with category info, in particular see "C.category_labels" and
% "C.category_assignments"
% stim_names: cell array with the names of the sounds
% plotting_order: order the sounds were plotted in for paper
% cbrew_blue_red_cmap: color map used for raster
load([repo_directory '/data/individual-electrodes/song-elec1-response.mat'],...
    'R', 't', 'C', 'stim_names', 'plotting_order', 'cbrew_blue_red_cmap');

% plot raster
figh = figure;
set(gcf, 'Position', [100 100 400 600]);
ax1 = axes('Position', [0.1 0.1 0.8 0.8]);
ax1.ActivePositionProperty = 'position';
b = quantile(R(:), 0.99);
imagesc(R(plotting_order, :), [-b b]);
colormap(cbrew_blue_red_cmap);
hold on;

% add temporal offset
plot(find(t==2)*[1, 1], [1, length(stim_names)], 'k-', 'LineWidth', 2);

% add category divisions
for j = 2:length(C.category_labels)
    plot([1, length(t)], ...
        find(C.category_assignments(plotting_order)==C.plotting_order(j), 1) * [1, 1] - 0.5, ...
        'k--', 'LineWidth', 2);
end
set(gca, 'YTick', []);
set(gca, 'XTick', []);


