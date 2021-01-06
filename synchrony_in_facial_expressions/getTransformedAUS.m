function [A_aus, B_aus, outPath] = getTransformedAUS(A_aus, B_aus, plotwhich, datapath, session, taskname)
outPath = '';
if strcmp(plotwhich,'fewerneg')
    outPath = strcat(datapath, '/', session, '/AUS_plot_fewerneg_',taskname, '.png');
    A_aus(A_aus==-1)=-1;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus>0)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=-1;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus>0)=1;B_aus(B_aus==0)=0;
elseif strcmp(plotwhich, 'realvsfakepos')
    outPath = strcat(datapath, '/', session, '/AUS_plot_realvsfakepos_',taskname, '.png');
    A_aus(A_aus==-1)=0;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus==1)=-1;A_aus(A_aus==2)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=0;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus==1)=-1;B_aus(B_aus==2)=1;B_aus(B_aus==0)=0;
elseif strcmp(plotwhich,'smoothfewerneg')
    outPath = strcat(datapath, '/', session, '/AUS_plot_smoothfewerneg_',taskname, '.png');
    A_aus(A_aus==-1)=-1;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus>0)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=-1;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus>0)=1;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
elseif strcmp(plotwhich,'smoothfewerneg_nopos')
    A_aus(A_aus==-1)=-1;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus>0)=0;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=-1;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus>0)=0;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
elseif strcmp(plotwhich,'smoothonlyfakepos')
    A_aus(A_aus==-1)=0;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus==1)=1;A_aus(A_aus==2)=0;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=0;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus==1)=1;A_aus(B_aus==2)=0;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
elseif strcmp(plotwhich,'smoothonlyrealpos')
    A_aus(A_aus==-1)=0;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus==1)=0;A_aus(A_aus==2)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=0;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus==1)=0;A_aus(B_aus==2)=1;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
elseif strcmp(plotwhich,'smoothonlypos')
    A_aus(A_aus==-1)=0;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus>0)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=0;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus>0)=1;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));

elseif strcmp(plotwhich, 'smoothrealvsfakepos')
    outPath = strcat(datapath, '/', session, '/AUS_plot_realvsfakepos_',taskname, '.png');
    A_aus(A_aus==-1)=0;A_aus(A_aus==-2)=0;A_aus(A_aus==-3)=0;A_aus(A_aus==-4)=0;A_aus(A_aus==1)=-1;A_aus(A_aus==2)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus==-1)=0;B_aus(B_aus==-2)=0;B_aus(B_aus==-3)=0;B_aus(B_aus==-4)=0;B_aus(B_aus==1)=-1;B_aus(B_aus==2)=1;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
elseif strcmp(plotwhich, 'smoothall')
    outPath = strcat(datapath, '/', session, '/AUS_plot_smoothall_',taskname, '.png');
    A_aus(A_aus<0)=-1;A_aus(A_aus>0)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus<0)=-1;B_aus(B_aus>0)=1;B_aus(B_aus==0)=0;
    A_aus = round(smooth(A_aus, 29));
    B_aus = round(smooth(B_aus, 29));
else
    outPath = strcat(datapath, '/', session, '/AUS_plot_',taskname, '.png');
    A_aus(A_aus<0)=-1;A_aus(A_aus>0)=1;A_aus(A_aus==0)=0;
    B_aus(B_aus<0)=-1;B_aus(B_aus>0)=1;B_aus(B_aus==0)=0;
end

end