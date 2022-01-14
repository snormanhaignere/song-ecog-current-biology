% Read in ecog component responses to the modulation-matched stimuli
% and plot the timecourses (Fig 4B)

% path to the downloaded repository
repo_directory = fileparts(fileparts(which('ecog_component_modmatch.m')));

%% Load component response matrices (R) and auxilliary info

% R: sound x condition (natural, synthetic) x time x component
% t: time stamps in seconds
% C: structure with category info
% C.category_labels: cell array of the 11 categories
% C.onehot: matrix of "1-hot" category labels indicating which sounds
% belong to which categories
% conditions: natural, synthetic
% stim_names: cell array with the names of the 36 natural sounds
load([repo_directory '/data/ecog_component_modmatch.mat'],...
    'R', 't', 'C', 'conditions', 'stim_names');

% Get just song-selective component (C11)
% sound x condition (natural, synthetic) x time
c = 11;
X = R(:,:,:,c);

%% Plot the timecourses separately for each category, color-coded by condition (natural vs. synthetic)

% indices for the four different categories to plot
category_indices = find(ismember(C.category_labels, {'Speech', 'Music', 'Song', 'NonSpMu'}));
figh = figure;
set(gcf, 'Position', [100 100 1400 200]);
for k = 1:length(category_indices) % loop through categories
        
    % setup plot, add time markers
    subplot(1, 4, k);
    hold on;
    xL = [0, 2]; % plot just first two seconds
    yL = [0, max(X(:))];
    yL = yL + [0 1]*0.1*diff(yL);
    line_width = 4;
    plot([0 0], yL, 'k-', 'LineWidth', line_width);
    time_marks = setdiff(0.5:0.5:xL(2)-0.1,4);
    for l = 1:length(time_marks)
        plot(time_marks(l)*[1 1], yL, 'k--', 'LineWidth', line_width);
    end
    
    % plot the responses
    stim_inds = find(logical(C.onehot(:,category_indices(k)))); % stimulus indices for this category
    for m = 1:length(stim_inds) % loop through stimuli
        for l = 1:2 % loop through conditions (natural/synthetic)
            
            % get color for this category
            col = C.colors(category_indices(k),:); 
            if strcmp(conditions{l}, 'synthetic') % darken for synthetic
                col = col*0.4;
            end
            
            % plot timecourse
            xi = t>=xL(1) & t<=xL(2);
            plot(t(xi), squeeze(X(stim_inds(m), l, xi)), ...
                'Color', col, 'LineWidth', line_width);
            clear xi;
            
        end
    end
    ylim(yL);
    xlim(xL);
    title(C.category_labels(category_indices(k)));
    
end
