clear;
warning off;
dataPath = '/some/path';
audio_folder = 'skype_audio';

format = 'wav';
format = lower(format);

sessionNames = {'cx004'; 'cx005'; 'cx006'; 'cx007'; 'cx010'; 'cx011'; 'cx012'; 'cx013'; 'cx014'; 'cx015'; 'cx016'; 'cx017'; 'cx018'; 'cx019'; 'cx020'; 'cx021'; 'cx022'; 'cx023'; 'cx024'; 'cx025'; 'cx026'; 'cx027'; 'cx028'; 'cx030'; 'cx031'; 'cx033'; 'cx034'; 'cx035'; 'cx036'; 'cx037'; 'cx038'; 'cx039'; 'cx040'; 'cx041'; 'cx044'; 'cx045'; 'cx047'; 'cx049'; 'cx050'; 'cx051'; 'cx052'; 'cx053'; 'cx054'; 'cx055'; 'cx056'; 'cx057'; 'cx060'; 'cx061'; 'cx062'; 'cx063'; 'cx066'; 'cx067'; 'cx068'; 'cx069'; 'cx070'; 'cx071'; 'cx073'; 'cx074'; 'cx075'; 'cx077'; 'cx078'; 'cx079'; 'cx080'; 'cx081'; 'cx082'; 'cx083'; 'cx084'; 'cx085'; 'cx086'; 'cx087'; 'cx089'; 'cx090'; 'cx091'; 'cx092'; 'cx093'; 'cx096'; 'cx097'; 'cx117'; 'cx122'; 'cx125'; 'cx126'; 'cx129'; 'cx130'; 'cx131'; 'cx132'; 'cx133'; 'cx134'; 'cx135'; 'cx136'; 'cx137'; 'cx138'; 'cx139'; 'cx140'; 'cx141'; 'cx142'; 'cx143'; 'cx144'; 'cx145'; 'cx148'; 'cx150'; 'cx151'; 'cx152';}

for idx = 1:length(sessionNames)
    tic
    session = sessionNames{idx}
    apath = fullfile(dataPath, strcat(session, 'a'), audio_folder);
    anames = getTaskFileNames(apath, format);
    bpath = fullfile(dataPath, strcat(session, 'b'), audio_folder);
    bnames = getTaskFileNames(bpath, format);
    for ti = 1:6
        fa = fullfile(apath, anames{ti,1});
        fb = fullfile(bpath, bnames{ti,1});
        [ya, Fsa, yb, Fsb] = getEqualSignals(fa, fb);
        % load VAD files
        if strcmp(format, 'wav')
            fvad_a = load(fullfile(apath, 'VADfromWav', strcat('VAD_task_', num2str(ti), '.mat')));
            fvad_b = load(fullfile(bpath, 'VADfromWav', strcat('VAD_task_', num2str(ti), '.mat')));

        else
            fvad_a = load(fullfile(apath, 'VAD', strcat('VAD_task_', num2str(ti), '.mat')));
            fvad_b = load(fullfile(bpath, 'VAD', strcat('VAD_task_', num2str(ti), '.mat')));
        end
        vad_a = fvad_a.Outs_Final;
        vad_a_t = fvad_a.t;
        vad_b = fvad_b.Outs_Final;
        vad_b_t = fvad_b.t;
        dt = 1/Fsa;
        tAxis = zeros(length(ya), 1);
        tAxis(1) = 0;
        for i=2:length(tAxis)
            tAxis(i) = tAxis(i-1)+dt;
        end
        % interpolate VAD values and threshold to get flags
        vad_interp_a = interp1(vad_a_t,vad_a,tAxis,'linear','extrap');
        vad_interp_b = interp1(vad_b_t,vad_b,tAxis,'linear','extrap');
        vad_flag_a = vad_interp_a;
        vad_flag_a(vad_flag_a>0.8) = 1.0;
        vad_flag_a(vad_flag_a~=1.0) = 0.0;
        vad_flag_b = vad_interp_b;
        vad_flag_b(vad_flag_b>0.8) = 1.0;
        vad_flag_b(vad_flag_b~=1.0) = 0.0;
        
        % Getting turns
        currTurn = 0; % 0, 1 for a, 2 for b
        currInterrupt = 0; % 0, 1 for a interrupts b, 2 for b interrupts a
        startIofTurn = -1;
        %currIofTurn = -1;
        % initialized to -1
        turns = zeros(length(tAxis), 1)-1;
        interrupts = zeros(length(tAxis), 1)-1;
        pauses = zeros(length(tAxis), 1);
        silencecount = 0;
        for i=1:length(tAxis)
            a_s = ya(i);
            a_f = vad_flag_a(i);
            b_s = yb(i);
            b_f = vad_flag_b(i);
            % how turns start
            if currTurn==0 && a_f==1 % no ones turn and a starts talking
                currTurn = 1;
                startIofTurn = i;
            end
            if currTurn==0 && b_f==1 % no ones turn and b starts talking
                currTurn = 2;
                startIofTurn = i;
            end
            % NOTE - turn is not switched when the person holding the turn
            % stops speaking
            % It only switches when the other person starts
            if currTurn==1 && b_f == 1 && a_f ==0 % interruptions are different and are not handled here
                currTurn = 2;
            end
            if currTurn==2 && a_f == 1 && b_f ==0 % interruptions are different and are not handled here
                currTurn = 1;
            end
            % continuing turn
            if currTurn==1 && a_f==1
                currTurn = 1;
            end
            if currTurn==2 && b_f==1
                currTurn = 2;
            end
            % Now lets handle interruptions
            % if the 2nd person interrupts the first person, turn only
            % switches to the 2nd person if the 1st person stops talking
            % before the 2nd perso finishes speaking 
            if currTurn==1 && b_f==1 && a_f==1
                currInterrupt = 2;
            end
            if currTurn==2 && a_f==1 && b_f==1
                currInterrupt = 1;
            end
            if b_f==1 && a_f==0 % b talking, a stops
               currInterrupt = 0;
               if interrupts(i-1) == 2 % b had interrupt a previously
                   j=i-1;
                   while j~=0 && interrupts(j)==2
                       turns(j) = 2;
                       j = j-1;
                   end
               end
            end
            if a_f==1 && b_f==0 % a talking, b stops
               currInterrupt = 0;
               if interrupts(i-1) == 1 % a had interrupt b previously
                   j=i-1;
                   while j~=0 && interrupts(j)==1
                       turns(j) = 1;
                       j = j-1;
                   end
               end
            end
            % note pauses
            if a_f==0 && b_f==0
                pauses(i) = 1;
                silencecount = silencecount+1;
            else
                pauses(i) = 0;
                silencecount = 0;
            end
            % handling long silences
            if (silencecount/double(Fsa))>2 && currTurn ~= 0
                currTurn = 0;
                j = i-1;
                while j~=0 && pauses(j)==1
                    turns(j) = 0;
                    j = j-1;
                end
            end
            % assigning values
            turns(i) = currTurn;
            interrupts(i) = currInterrupt;
        end
        if strcmp(format, 'wav')
            turnpath = fullfile(dataPath, session, 'TurnsFromWav');
        else
            turnpath = fullfile(dataPath, session, 'Turns');
        end
        if ~exist(turnpath, 'dir')
            mkdir(turnpath);
        end
        turnpath = fullfile(turnpath, strcat('Task_', num2str(ti), '.mat')); 
        save(turnpath, 'turns', 'interrupts', 'pauses', 'vad_flag_a', 'vad_flag_b'); 
    end
    toc
end