% Illustrate correlation with acoustic features (Fig 5D/E)

% path to the downloaded repository
repo_directory = fileparts(fileparts(which('ecog_acoustic_corr.m')));

% load cochlear and modulation acoustic statistics
load([repo_directory '/data/acoustic_features.mat'], ...
    'F_coch', 'F_mod', 'coch_freqs',  'temp_mod_rates', 'spec_mod_scales');

% partial out cochlear stat from modulation stats
for i = 1:size(F_mod, 2)
    for j = 1:size(F_mod, 3)
        F_mod(:,i,j) = F_mod(:,i,j) - F_coch * pinv(F_coch) * F_mod(:,i,j);
    end
end

% load component response matrices (R) and auxilliary info
% R: sound x time x component
% t: time stamps in seconds
% C: structure with category info, in particular see "C.category_labels" and
% "C.category_assignments"
% stim_names: cell array with the names of the sounds
% plotting_order: order the sounds were plotted in for paper
% cbrew_blue_red_cmap: color map used for raster
load([repo_directory '/data/ecog_component_responses.mat'],...
    'R', 't', 'C', 'stim_names', 'plotting_order', 'cbrew_blue_red_cmap');

% select responses for just C2
c = 2;
X = R(:,:,c);

% get first PC
[U, ~, V] = svd(X, 'econ');
firstPC = U(:,1) * sign(mean(V(:,1)));

% correlation with frequency stats
r_coch = corr(firstPC, F_coch);
xL = [0.5,6.5];
figh = figure;
set(figh, 'Position', [100 100 350 300]);
plot(xL, [0 0], 'k-', 'LineWidth', 2); hold on;
plot(r_coch, 'k-o', 'LineWidth', 2);
ylim([-1, 1]*0.8);
xlim(xL);
box off;
set(gca, 'XTick', 1:6, 'XTickLabel', [200, 400, 800, 1600, 3200, 6400]/1000);

% correlation with modulation stats
r_spectemp = nan(size(F_mod, 2), size(F_mod, 3));
for i = 1:size(F_mod, 2)
    for j = 1:size(F_mod, 3)
        r_spectemp(i,j) = corr(F_mod(:,i,j), firstPC);
    end
end
figh = figure;
set(figh, 'Position', [100 100 50*9 50*7]);
imagesc(flipud(r_spectemp), [-1,1]*0.75);
colormap(cbrew_blue_red_cmap);
set(gca, 'XTick', 1:9, 'XTickLabels', temp_mod_rates);
set(gca, 'YTick', 1:7, 'YTickLabels', fliplr(spec_mod_scales));