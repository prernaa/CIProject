% This file calculates synchrony in facial expressions using DTW

clear;
sessionNames = {'cx066', 'cx067', 'cx068', 'cx069', 'cx070', 'cx071', 'cx073', 'cx074', 'cx075', 'cx077', 'cx078', 'cx079', 'cx080', 'cx081', 'cx082', 'cx083', 'cx084', 'cx085', 'cx086', 'cx087', 'cx089', 'cx090', 'cx091', 'cx092', 'cx093', 'cx096', 'cx097', 'cx109', 'cx114', 'cx117',  'cx118', 'cx121', 'cx122', 'cx125', 'cx126', 'cx129', 'cx130', 'cx131', 'cx132', 'cx133',  'cx134', 'cx135', 'cx136', 'cx137', 'cx138', 'cx139', 'cx140', 'cx141', 'cx142', 'cx143', 'cx144', 'cx145', 'cx146', 'cx147', 'cx148', 'cx150', 'cx151', 'cx152'};
%sessionNames = {'cx066'};

datapath = '/some/path';

nsessions = length(sessionNames);

mex dtw_c.c;

dtwposvsneg = zeros(nsessions,6);

dtwwins = zeros(nsessions,6);
fs = 29;

dtwwin = 5*fs; %60*fs; % approx 60 seconds
dtwwin2 = dtwwin;


for i = 1:length(sessionNames)
    session = sessionNames{i}
    A_aus_all = [];
    B_aus_all = [];
    for j=1:6 % for each task
        taskname = strcat('task',int2str(j))
        inPath = strcat(datapath, '/', session, '/AUS_',taskname, '.mat');
        inMat = load(inPath);
        A_aus_in = inMat.aus1;
        B_aus_in = inMat.aus2;
        A_aus_all = [A_aus_all A_aus_in];
        B_aus_all = [B_aus_all B_aus_in];
        if dtwwin==-1
            dtwwin = abs(length(A_aus_in)-length(B_aus_in));
        else
            dtwwin = dtwwin2 + abs(length(A_aus_in)-length(B_aus_in));
        end
        dtwwins(i,j) = dtwwin;
        normfac = 1;
        % positive vs negative
        plotwhich = 'smoothfewerneg';
        [A_aus, B_aus, ~] = getTransformedAUS(A_aus_in, B_aus_in, plotwhich, datapath, session, taskname);
        d = dtw_c(A_aus, B_aus,dtwwin);
        d = d/normfac;
        dtwposvsneg(i,j) = d;        
    end
    toc
end

sessionNames = sessionNames';
% task ALL -- for the concatenated file across all tasks 
posvsneg = sum(dtwposvsneg,2);

Tdyadic = table(sessionNames, posvsneg);
writetable(Tdyadic,strcat(datapath, '/', 'dtw_study2_nonorm_all_dtwwin_',int2str(dtwwin2),'.csv'),'Delimiter',',');