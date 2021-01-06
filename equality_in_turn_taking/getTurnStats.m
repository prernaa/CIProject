function [countTurnA, countTurnB, sumSamplesA, sumSamplesB, veryShortTurnCountA, veryShortTurnCountB, sumPausesA, sumPausesB, sumPercentPauseA, sumPercentPauseB, silentSamples, noholdSamples, countInterA, countInterB, smoothSwitchA, smoothSwitchB, interSwitchA, interSwitchB, turnsTimes] = getTurnStats(turns, pauses, interrupts, sr)
    % DONE-Number* of turns of A, Number* of turns of B (*can express as % of total)
    % DONE-Avg duration of turns of A, Avg duration of turns of B
    % DONE-Prosody - Percentage of turn that was a pause for A and B,
    % DONE - not incld pauses - Avg duration of turns of A, Avg duration of turns of B
    % DONE - Percentage of silence/ turn held by no one
    % DONE- Turns of <1sec as backchannels
    % DONE- Turns of <1sec as backchannels
    % DONE- Number of interruptions
    % NOT_DONE, TOO_SLOW- Number of interruptions (after smoothing)
    % NOT_DONE- Percentage of interruptions that were successful or unsuccessful
    % DONE- Percentage of turn switches that were smooth or unterrupted
    % noholdsamples and silentsamples should give us pretty much the same
    % value on real data
    countTurnA = 0;
    countTurnB = 0;
    sumSamplesA = 0;
    sumSamplesB = 0;
    sumSamplesANoPause = 0;
    sumSamplesBNoPause = 0;
    samplesInTurn = 0;
    veryShortTurnCountA = 0;
    veryShortTurnCountB = 0;
    sumPausesA = 0;
    sumPausesB = 0;
    pausesInTurn = 0;
    sumPercentPauseA = 0;
    sumPercentPauseB = 0;
    silentSamples = 0;
    noholdSamples = 0;
    prevTurn = -1;
    prevInter = -1;
    countInterA = 0;
    countInterB = 0;
%     disp('smoothing')
%     interruptsSm = smooth(interrupts, sr*2);
%     disp('smoothing done')
%     prevInterSm = -1;
%     countInterSmA = 0;
%     countInterSmB = 0;
    smoothSwitchA = 0;
    smoothSwitchB = 0;
    interSwitchA = 0;
    interSwitchB = 0;
    turnsTimes = [];
    turnS = -1;
    for i=1:length(turns)
        currTurn = turns(i);
        currInter = interrupts(i);
        %currInterSm = interruptsSm(i);
        % count silence; turn held by no one
        if currTurn==0
            noholdSamples = noholdSamples+1;
            if pauses(i)==1
                silentSamples = silentSamples+1;
            end
        end
        % turn distribution; turn end
        if (currTurn~=prevTurn || i==length(turns)) && prevTurn>0
            secs = samplesInTurn/double(sr);
            if i==length(turns)
                samplesInTurn = samplesInTurn+1;
                turnE = i;
            else
                turnE = i-1;
            end
            turnsTimes = [turnsTimes; turnS, turnE, prevTurn];
            if secs<=1 && secs>=0.1
                if prevTurn ==1
                    veryShortTurnCountA = veryShortTurnCountA+1;
                else
                    veryShortTurnCountB = veryShortTurnCountB+1;
                end 
            end

            pausepercent = (pausesInTurn/double(samplesInTurn))*100;
            if prevTurn ==1
                sumPercentPauseA = sumPercentPauseA + pausepercent;
            else
                sumPercentPauseB = sumPercentPauseB + pausepercent;
            end
            samplesInTurn = 0;
            pausesInTurn = 0;
        end
        % count number of turns; turn start/switch
        if currTurn~=prevTurn && currTurn~=0 % turn switches to another person
            samplesInTurn = samplesInTurn+1;
            turnS = i;
            if pauses(i) == 1
                pausesInTurn = pausesInTurn+1;
            end 
            if currTurn==1
                countTurnA = countTurnA+1;
                sumSamplesA = sumSamplesA+1;
                if pauses(i) == 0
                    sumSamplesANoPause = sumSamplesANoPause+1;
                end
            else
                countTurnB = countTurnB+1;
                sumSamplesB = sumSamplesB+1;
                if pauses(i) == 0
                    sumSamplesBNoPause = sumSamplesBNoPause+1;
                end
            end
            % count smooth switches
            interflag = 0;
            j = i;
            if currTurn==1
                while j~=max([0,i-sr*2]) && interflag == 0
                    if j<i && turns(j)~=2
                        break;
                    end
                    if interrupts(j) == 1
                        interflag = 1;
                    end
                    j=j-1;
                end
                if interflag==0
                    smoothSwitchA = smoothSwitchA+1;
                else
                    interSwitchA = interSwitchA+1;
                end
            else
                while j~=max([0,i-sr*2]) && interflag == 0
                    if j<i && turns(j)~=1
                        break;
                    end
                    if interrupts(j) == 2
                        interflag = 1;
                    end
                    j=j-1;
                end
                if interflag==0
                    smoothSwitchB = smoothSwitchB+1;
                else
                    interSwitchB = interSwitchB+1;
                end
            end
        end
        % count interruptions
        if currInter~=prevInter && currInter~=0
            if currInter==1
                countInterA = countInterA+1;
            else
                countInterB = countInterB+1;
            end
        end
%         if currInterSm~=prevInterSm && currInterSm~=0
%             if currInterSm==1
%                 countInterSmA = countInterSmA+1;
%             else
%                 countInterSmB = countInterSmB+1;
%             end
%         end
        % sum duration of turns in samples; turn continues
        if currTurn==prevTurn && currTurn~=0
            samplesInTurn = samplesInTurn+1;
            if pauses(i) == 1
                pausesInTurn = pausesInTurn+1;
            end 
            if currTurn==1
                sumSamplesA = sumSamplesA+1;
                if pauses(i) == 0
                    sumSamplesANoPause = sumSamplesANoPause+1;
                end
            else
                sumSamplesB = sumSamplesB+1;
                if pauses(i) == 0
                    sumSamplesBNoPause = sumSamplesBNoPause+1;
                end
            end
        end
        % Counting pauses
        if currTurn==1 && pauses(i)==1
            sumPausesA = sumPausesA+1;
        elseif currTurn==2 && pauses(i)==1
            sumPausesB = sumPausesB+1;
        end
        prevTurn = currTurn;
        prevInter = currInter;
        %prevInterSm = currInterSm;
    end
end