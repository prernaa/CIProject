%{
This file reads the facial expression features (i.e. AUs) generated from the video files of each task, and labels them as positive or negative.
It saves the pos/neg labels across all frames in each task into files, and also concatenates the pos/neg labels across all frames in ALL tasks to create one file for all tasks.
We couldnt directly run it on the original file because the original file also contained video frames from when the participants were reading the instructions for each task
%}
 
clear;
%sessionNames = {'cx066'}
%sessionNames = {'cx066', 'cx067', 'cx068', 'cx069', 'cx070', 'cx071', 'cx073', 'cx074', 'cx075', 'cx077', 'cx078', 'cx079', 'cx080', 'cx081', 'cx082', 'cx083', 'cx084', 'cx085', 'cx086', 'cx087', 'cx089', 'cx090', 'cx091', 'cx092', 'cx093', 'cx096', 'cx097', 'cx109', 'cx114', 'cx117',  'cx118', 'cx121', 'cx122', 'cx125', 'cx126', 'cx129', 'cx130', 'cx131', 'cx132', 'cx133',  'cx134', 'cx135', 'cx136', 'cx137', 'cx138', 'cx139', 'cx140', 'cx141', 'cx142', 'cx143', 'cx144', 'cx145', 'cx146', 'cx147', 'cx148', 'cx150', 'cx151', 'cx152'};
sessionNames = {'cx071', 'cx073', 'cx074', 'cx075', 'cx077', 'cx078', 'cx079', 'cx080', 'cx081', 'cx082', 'cx083', 'cx084', 'cx085', 'cx086', 'cx087', 'cx089', 'cx090', 'cx091', 'cx092', 'cx093', 'cx096', 'cx097', 'cx109', 'cx114', 'cx117',  'cx118', 'cx121', 'cx122', 'cx125', 'cx126', 'cx129', 'cx130', 'cx131', 'cx132', 'cx133',  'cx134', 'cx135', 'cx136', 'cx137', 'cx138', 'cx139', 'cx140', 'cx141', 'cx142', 'cx143', 'cx144', 'cx145', 'cx146', 'cx147', 'cx148', 'cx150', 'cx151', 'cx152'};


length(sessionNames)
% no 8 and no 9


datapath = '/some/path';


% vidprefixs = ['CI_Typing_Task_', 'CI_Matrix_Task_', 'CI_Brainstorming_Task_', 'CI_Unscramble_Task_', 'CI_Sudoku_Task_', 'CI_Memory_Task_'];
for i = 1:length(sessionNames)
    session = sessionNames{i}
    apath = strcat(datapath, '/', session, 'a/skype_trim_features/');
    anames = dir(fullfile(apath, 'CI_*_Task*.txt'));
    bpath = strcat(datapath, '/', session, 'b/skype_trim_features/');
    bnames = dir(fullfile(bpath, 'CI_*_Task*.txt'));
    tic
    A_all = [];
    B_all = [];
    for j=1:6 % for each task
        taskname = strcat('task',int2str(j))
        af = strcat(apath, anames(j).name);
        aT = readtable(af,'Delimiter',',','ReadVariableNames',true);
        bf = strcat(bpath, bnames(j).name);
        bT = readtable(bf,'Delimiter',',','ReadVariableNames',true);
        a_aus = getAUS(aT);
        A_all = [A_all, a_aus];
        b_aus = getAUS(bT); 
        B_all = [B_all, b_aus];
        outpath = strcat(datapath, '/', session, '/AUS_',taskname, '.mat');
        saveAUS(outpath, a_aus, b_aus);
    end
    outpath = strcat(datapath, '/', session, '/AUS_all', '.mat');
    saveAUS(outpath, A_all, B_all);
    toc
end
