function [exprs] = getAUS(T)
% positive_real = +2 (6+12), positive_fake=+1 (12)
% negative=-1 (1_or_4 + 15) negative=-1 (1+4+15), negative = -2 (4+23),
% negative = -3 (9+15)
% none=0
H = height(T);
exps = [];
for i = 1:H
    au12_r = T{i,{'AU12_r'}};
    au12_c = T{i,{'AU12_c'}};
    au6_r = T{i, {'AU06_r'}};
    au1_r = T{i, {'AU01_r'}};
    au4_r = T{i, {'AU04_r'}};
    au4_c = T{i, {'AU04_c'}};
    au15_r = T{i, {'AU15_r'}};
    au15_c = T{i, {'AU15_c'}};
    au23_c = T{i, {'AU23_c'}};
    au9_r = T{i, {'AU09_r'}};
    currpos = 0;
    posamp = 0.0;
    currneg = 0;
    negamp = 0.0;
    if (au12_c==1)
        currpos = 1;
        posamp = au12_r;
        if (au6_r>0.50)
            currpos = 2;
            posamp = max([au6_r, au12_r]);
        end
    end
    if(au15_c==1)
        if (au1_r>0.5 || (au4_c==1 || au4_r>0.5))
            currneg = -1;
            negamp = max([au1_r, au4_r, au15_r]);
        end
        %if((currneg==0 && au9_r>0.5) || (currneg~=0 && au9_r>0.8))
        if(currneg==0 && au9_r>0.5)
            currneg = -3;
            negamp = max([au9_r, au15_r]);
        end
    end
    %if(currneg==0 && ((au23_c==1 && au4_c==1 && negamp<0.8) || (au23_c==1 && au4_r>0.5 && negamp<0.8)))
    if(currneg==0 && ((au23_c==1 && au4_c==1) || (au23_c==1 && au4_r>0.5)))
        currneg = -2;
        negamp = max([negamp, au4_r]);
    end
    if((currpos>0 && currneg~=0) || (currneg<0 && currpos~=0)) % conflict
        %if (abs(posamp)<abs(negamp) && abs(negamp)>0.7)
        if (abs(posamp)<abs(negamp))
            currau = currneg;
        else
            currau = currpos;
        end
    else
        if currpos>0
            currau = currpos;
        elseif currneg<0
            currau = currneg;
        else
            currau = 0;
        end
    end
    exps = [exps, currau];
end
exprs = exps;
end