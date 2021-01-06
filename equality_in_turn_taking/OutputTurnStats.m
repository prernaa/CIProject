clear;
warning off;
dataPath = '/some/path';
audio_folder = 'skype_audio';
format = 'wav';

% CIScorepath = fullfile(dataPath, 'CIAndLogs_cleaned_final.csv');
% Tscores = readtable(CIScorepath, 'FileType','text', 'Delimiter',',', 'ReadVariableNames',true);


% sessionNames = {'cx004'; 'cx005'; 'cx006'; 'cx007'; 'cx010'; 'cx011'; 'cx012'; 'cx013'; 'cx014'; 'cx015'; 'cx016'; 'cx017'; 'cx018'; 'cx019'; 'cx020'; 'cx021'; 'cx022';  'cx023'; 'cx024'; 'cx025'; 'cx026'; 'cx027'; 'cx028'; 'cx030'; 'cx031'; 'cx033'; 'cx034'; 'cx035'; 'cx036'; 'cx037'; 'cx038'; 'cx039'; 'cx040'; 'cx041'; 'cx043'; 'cx044'; 'cx047'; 'cx048'; 'cx049'; 'cx050'; 'cx056'; 'cx057'; 'cx060'; 'cx061'; 'cx062'; 'cx063'};
sessionNames = {'cx004'; 'cx005'; 'cx006'; 'cx007'; 'cx010'; 'cx011'; 'cx012'; 'cx013'; 'cx014'; 'cx015'; 'cx016'; 'cx017'; 'cx018'; 'cx019'; 'cx020'; 'cx021'; 'cx022'; 'cx023'; 'cx024'; 'cx025'; 'cx026'; 'cx027'; 'cx028'; 'cx030'; 'cx031'; 'cx033'; 'cx034'; 'cx035'; 'cx036'; 'cx037'; 'cx038'; 'cx039'; 'cx040'; 'cx041'; 'cx044'; 'cx045'; 'cx047'; 'cx049'; 'cx050'; 'cx051'; 'cx052'; 'cx053'; 'cx054'; 'cx055'; 'cx056'; 'cx057'; 'cx060'; 'cx061'; 'cx062'; 'cx063'; 'cx066'; 'cx067'; 'cx068'; 'cx069'; 'cx070'; 'cx071'; 'cx073'; 'cx074'; 'cx075'; 'cx077'; 'cx078'; 'cx079'; 'cx080'; 'cx081'; 'cx082'; 'cx083'; 'cx084'; 'cx085'; 'cx086'; 'cx087'; 'cx089'; 'cx090'; 'cx091'; 'cx092'; 'cx093'; 'cx096'; 'cx097'; 'cx117'; 'cx122'; 'cx125'; 'cx126'; 'cx129'; 'cx130'; 'cx131'; 'cx132'; 'cx133'; 'cx134'; 'cx135'; 'cx136'; 'cx137'; 'cx138'; 'cx139'; 'cx140'; 'cx141'; 'cx142'; 'cx143'; 'cx144'; 'cx145'; 'cx148'; 'cx150'; 'cx151'; 'cx152';}

numsessions = length(sessionNames);

countTurnA_var = zeros(numsessions, 7)-1;
countTurnB_var = zeros(numsessions, 7)-1;
sumSamplesA_var = zeros(numsessions, 7)-1;
sumSamplesB_var = zeros(numsessions, 7)-1;
veryShortTurnCountA_var = zeros(numsessions, 7)-1;
veryShortTurnCountB_var = zeros(numsessions, 7)-1;
sumPausesA_var = zeros(numsessions, 7)-1;
sumPausesB_var = zeros(numsessions, 7)-1;
sumPercentPauseA_var = zeros(numsessions, 7)-1;
sumPercentPauseB_var = zeros(numsessions, 7)-1;
silentSamples_var = zeros(numsessions, 7)-1;
noholdSamples_var = zeros(numsessions, 7)-1;
countInterA_var = zeros(numsessions, 7)-1;
countInterB_var = zeros(numsessions, 7)-1;
smoothSwitchA_var = zeros(numsessions, 7)-1;
smoothSwitchB_var = zeros(numsessions, 7)-1;
interSwitchA_var = zeros(numsessions, 7)-1;
interSwitchB_var = zeros(numsessions, 7)-1;
CIscores_var = zeros(numsessions, 7)-1;
totalSamples_var = zeros(numsessions, 7)-1;

for idx = 1:length(sessionNames)
    tic
    session = sessionNames{idx}
    countTurnA_total = 0;
    countTurnB_total = 0;
    sumSamplesA_total = 0;
    sumSamplesB_total = 0;
    veryShortTurnCountA_total = 0;
    veryShortTurnCountB_total = 0;
    sumPausesA_total = 0;
    sumPausesB_total = 0;
    sumPercentPauseA_total = 0;
    sumPercentPauseB_total = 0;
    silentSamples_total = 0;
    noholdSamples_total = 0;
    countInterA_total = 0;
    countInterB_total = 0;
    smoothSwitchA_total = 0;
    smoothSwitchB_total = 0;
    interSwitchA_total = 0;
    interSwitchB_total = 0;
    turnsTimes_total = [];
    totalSamples_total = 0;
    ya_all = [];
    yb_all = [];
    apath = fullfile(dataPath, strcat(session, 'a'), audio_folder);
    anames = getTaskFileNames(apath, format);
    bpath = fullfile(dataPath, strcat(session, 'b'), audio_folder);
    bnames = getTaskFileNames(bpath, format);
    for ti = 1:6
%         CIscores_var(idx, ti) = getScore(Tscores, session, strcat('task',num2str(ti)));
        fa = fullfile(apath, anames{ti,1});
        fb = fullfile(bpath, bnames{ti,1});
        [ya, Fsa, yb, Fsb] = getEqualSignals(fa, fb);
        totalSamples_var(idx, ti) = length(ya);
        totalSamples_total = totalSamples_total+length(ya);
        ya_all = [ya_all;ya];
        yb_all = [yb_all;yb];
        turnpath = fullfile(dataPath, session, 'TurnsFromWav', strcat('Task_', num2str(ti), '.mat')); 
        load(turnpath);
        [countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB, turnsTimes] = getTurnStats(turns, pauses, interrupts, 16000);
        % storing vals for each task
        countTurnA_var(idx, ti) = countTurnA;
        countTurnB_var(idx, ti) = countTurnB;
        sumSamplesA_var(idx, ti) = sumSamplesA;
        sumSamplesB_var(idx, ti) = sumSamplesB;
        veryShortTurnCountA_var(idx, ti) = veryShortTurnCountA;
        veryShortTurnCountB_var(idx, ti) = veryShortTurnCountB;
        sumPausesA_var(idx, ti) = sumPausesA;
        sumPausesB_var(idx, ti) = sumPausesB;
        sumPercentPauseA_var(idx, ti) = sumPercentPauseA;
        sumPercentPauseB_var(idx, ti) = sumPercentPauseB;
        silentSamples_var(idx, ti) = silentSamples;
        noholdSamples_var(idx, ti) = noholdSamples;
        countInterA_var(idx, ti) = countInterA;
        countInterB_var(idx, ti) = countInterB;
        smoothSwitchA_var(idx, ti) = smoothSwitchA;
        smoothSwitchB_var(idx, ti) = smoothSwitchB;
        interSwitchA_var(idx, ti) = interSwitchA;
        interSwitchB_var(idx, ti) = interSwitchB;
        % outputting turns and signals
        outpath = fullfile(dataPath, session, 'TurnsFromWav', strcat('Turn_Tuples_For_Task_', num2str(ti), '.mat'));
        turnTs = turnsTimes;
        save(outpath, 'turnTs', 'ya', 'Fsa', 'yb', 'Fsb');
        % adding for full CI
        countTurnA_total = countTurnA_total+countTurnA;
        countTurnB_total = countTurnB_total+countTurnB;
        sumSamplesA_total = sumSamplesA_total+sumSamplesA;
        sumSamplesB_total = sumSamplesB_total+sumSamplesB;
        veryShortTurnCountA_total = veryShortTurnCountA_total+veryShortTurnCountA;
        veryShortTurnCountB_total = veryShortTurnCountB_total+veryShortTurnCountB;
        sumPausesA_total = sumPausesA_total+sumPausesA;
        sumPausesB_total = sumPausesB_total+sumPausesB;
        sumPercentPauseA_total = sumPercentPauseA_total+sumPercentPauseA;
        sumPercentPauseB_total = sumPercentPauseB_total+sumPercentPauseB;
        silentSamples_total = silentSamples_total+silentSamples;
        noholdSamples_total = noholdSamples_total+noholdSamples;
        countInterA_total = countInterA_total+countInterA;
        countInterB_total = countInterB_total+countInterB;
        smoothSwitchA_total = smoothSwitchA_total+smoothSwitchA;
        smoothSwitchB_total = smoothSwitchB_total+smoothSwitchB;
        interSwitchA_total = interSwitchA_total+interSwitchA;
        interSwitchB_total = interSwitchB_total+interSwitchB;
        turnsTimes_total = [turnsTimes_total; turnsTimes];
    end
    % storing vals for whole CI
    ti = 7;
    totalSamples_var(idx, ti) = totalSamples_total;
%     CIscores_var(idx, ti) = getScore(Tscores, session, 'all');
    countTurnA_var(idx, ti) = countTurnA_total;
    countTurnB_var(idx, ti) = countTurnB_total;
    sumSamplesA_var(idx, ti) = sumSamplesA_total;
    sumSamplesB_var(idx, ti) = sumSamplesB_total;
    veryShortTurnCountA_var(idx, ti) = veryShortTurnCountA_total;
    veryShortTurnCountB_var(idx, ti) = veryShortTurnCountB_total;
    sumPausesA_var(idx, ti) = sumPausesA_total;
    sumPausesB_var(idx, ti) = sumPausesB_total;
    sumPercentPauseA_var(idx, ti) = sumPercentPauseA_total;
    sumPercentPauseB_var(idx, ti) = sumPercentPauseB_total;
    silentSamples_var(idx, ti) = silentSamples_total;
    noholdSamples_var(idx, ti) = noholdSamples_total;
    countInterA_var(idx, ti) = countInterA_total;
    countInterB_var(idx, ti) = countInterB_total;
    smoothSwitchA_var(idx, ti) = smoothSwitchA_total;
    smoothSwitchB_var(idx, ti) = smoothSwitchB_total;
    interSwitchA_var(idx, ti) = interSwitchA_total;
    interSwitchB_var(idx, ti) = interSwitchB_total;
    % outputting turns and signals
    outpath = fullfile(dataPath, session, 'TurnsFromWav', strcat('Turn_Tuples_For_CI.mat'));
    turnTs = turnsTimes_total;
    ya = ya_all;
    yb = yb_all;
    save(outpath, 'turnTs', 'ya', 'Fsa', 'yb', 'Fsb');
    toc
end

% saving statistics
% task1
ti = 1;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task2
ti = 2;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task3
ti = 3;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task4
ti = 4;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task5
ti = 5;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task6
ti = 6;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_task',num2str(ti),'.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');

% task7
ti = 7;
% CIscore = CIscores_var(:,ti);
totalSamples = totalSamples_var(:,ti); countTurnA = countTurnA_var(:,ti); countTurnB = countTurnB_var(:,ti); sumSamplesA = sumSamplesA_var(:,ti); sumSamplesB = sumSamplesB_var(:,ti); veryShortTurnCountA = veryShortTurnCountA_var(:,ti); veryShortTurnCountB = veryShortTurnCountB_var(:,ti); sumPausesA = sumPausesA_var(:,ti); sumPausesB = sumPausesB_var(:,ti); sumPercentPauseA = sumPercentPauseA_var(:,ti); sumPercentPauseB = sumPercentPauseB_var(:,ti); silentSamples = silentSamples_var(:,ti); noholdSamples = noholdSamples_var(:,ti); countInterA = countInterA_var(:,ti); countInterB = countInterB_var(:,ti); smoothSwitchA = smoothSwitchA_var(:,ti); smoothSwitchB = smoothSwitchB_var(:,ti); interSwitchA = interSwitchA_var(:,ti); interSwitchB = interSwitchB_var(:,ti);
outpath = fullfile(dataPath, strcat('TurnStats_fullCI.csv'));
% Ttable = table(sessionNames, CIscore, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
Ttable = table(sessionNames, totalSamples, countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB);
writetable(Ttable,outpath,'Delimiter',',');
