function names = getTaskFileNames(path, format)

names = cell(6,1);
tasks = {'Typing'; 'Matrix'; 'Brainstorming'; 'Unscramble'; 'Sudoku'; 'Memory'};
for i = 1:length(tasks)
    t = tasks{i};
    if strcmp(format,'wav')
        ftry = strcat('CI_',t,'_Task*.wav');
    else
        ftry = strcat('CI_',t,'_Task*.m4a');
    end
    fullpath = fullfile(path, ftry);
    n = dir(fullpath);
    names{i,1} = n.name;
end
end