# CIProject

## For synchrony in facial expressions:
After extracting features (i.e. facial expression action units) from OpenFace, run:

1. saveExpressions.m
2. getFaceDTWFeatures.m


## For equality in turn-taking
1. Extracting wav/m4a from mp4
python code: extractAudioFromVideo.py OR extractAudioFromVideoWAV.py
generates m4a or wav files in the skype_audio directory for cxNNNa and cxNNNb

2. Voice Activity Detection (VAD)
matlab code: audioAnalysis_genVAD.m (set "format" variable to wav or m4a before running)
generates mat files in "skype_audio/VAD" or "skype_audio/VADfromWav" for cxNNNa and cxNNNb
These mat files contain (i) ya/yb (the signal), (ii) Outs_Final, (iii) Outs_Sadjadi, (iv) Outs_New', (v) 't'

3. Extracting turns using VAD output
Matlab code: extractTurns.m (set "format" variable to wav or m4a before running)
generates mat files in "Turns" or "TurnsFromWav" under cxNNN (session folder)
These mat files contain (i) Turns (whose turn was it?), (ii) Interrupts (who interrupted whom?), (iii) Pauses

4. Getting turn-related stats for each partner in the dyad
Matlab code: OutputTurnStats.m

5. Calculate difference in turns, samples, etc as measures of equality in turn-taking
Python code: Turn-Taking\_Diff\_and\_Total\_Calc.py


# Citation
## If you use the code for calculating synchrony in facial expressions, please cite:
Chikersal, P., Tomprou, M., Kim, Y. J., Woolley, A. W., & Dabbish, L. (2017, February). Deep structures of collaboration: Physiological correlates of collective intelligence and group satisfaction. In Proceedings of the 2017 ACM Conference on Computer Supported Cooperative Work and Social Computing (pp. 873-888).

## If you use the code for equality in turn-taking, please cite:


