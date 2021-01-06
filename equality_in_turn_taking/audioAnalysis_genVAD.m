% audio analysis
% Step 1: try resampling and listening to audio file
% THEN PERFORMS VOICE ACTIVITY DETECTION

% Lengths of tasks:
% Typing 6:30, Matrix 6:00, Brainstorming 2:00, 
% Unscrambled 2:00, Sudoku 3:30, Memory 2:00
clear; 
dataPath = '/some/path';
audio_folder = 'skype_audio';

format = 'wav';
format = lower(format);
sessionNames = {'cx114'; 'cx146'; 'cx147';} % This is just an example

length(sessionNames)
for idx = 1:length(sessionNames)
    tic
    session = sessionNames{idx}
    apath = fullfile(dataPath, strcat(session, 'a'), audio_folder);
    anames = getTaskFileNames(apath, format);
    bpath = fullfile(dataPath, strcat(session, 'b'), audio_folder);
    bnames = getTaskFileNames(bpath, format);
    for j=1:6
        j
        fa = fullfile(apath, anames{j,1});
        [ya,Fsa] = audioread(fa);
        infoa = audioinfo(fa);
        fb = fullfile(bpath, bnames{j,1});
        [yb,Fsb] = audioread(fb);
        infob = audioinfo(fb);
        % make equal
        sr = 16000;
        len = min(infoa.Duration, infob.Duration);
        if abs(infoa.Duration-infob.Duration)>1
            disp('problem with session (diff>1 sec) ', session);
            disp('ya size ', size(ya));
            disp('yb size ', size(yb));
        end
        ya = ya(1:sr*len);
        yb = yb(1:sr*len);
        % ensure their sizes are equal
        if size(ya)~=size(yb)
            disp('problem with session (unequal)', session);
            disp('ya size ', size(ya));
            disp('yb size ', size(yb));
        end
        fvad = strcat('VAD_task_', num2str(j), '.mat');
        % Voice activity detection for a
        try
            [Outs_Final,Outs_Sadjadi,Outs_New,t] = VAD_Drugman_prerna(ya,Fsa,0);
        catch exception
            msgText = getReport(exception)
            disp('Version or toolboxes do not support neural network object used in VAD. VAD skipped.')
        end
        if strcmp(format, 'wav')
            apath_out = fullfile(apath, 'VADfromWav');
        else
            apath_out = fullfile(apath, 'VAD');
        end
        if ~exist(apath_out, 'dir') 
            mkdir(apath_out);
        end
        save(fullfile(apath_out, fvad), 'ya', 'Outs_Final','Outs_Sadjadi','Outs_New','t'); 
        % Voice activity detection for b
        try
            [Outs_Final,Outs_Sadjadi,Outs_New,t] = VAD_Drugman_prerna(yb,Fsb,0);
        catch exception
            msgText = getReport(exception)
            disp('Version or toolboxes do not support neural network object used in VAD. VAD skipped.')
        end
        if strcmp(format, 'wav')
            bpath_out = fullfile(bpath, 'VADfromWav');
        else
            bpath_out = fullfile(bpath, 'VAD');
        end
        if ~exist(bpath_out, 'dir') 
            mkdir(bpath_out);
        end
        save(fullfile(bpath_out, fvad), 'yb', 'Outs_Final','Outs_Sadjadi','Outs_New','t'); 
    toc
    end
end