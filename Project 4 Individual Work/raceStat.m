% Records Race Stats
function raceStats = raceStat(X,Y,t,path,out)
prev_section = 6;
loops = -1;
j = 0;
k = 0;
Xerr = [];
Yerr = [];
terr = [];
for i = 1:length(X)
    if X(i) < path.l_st
        if X(i) >= 0
            if Y(i) < path.radius
                section = 1;
            else
                section = 4;
            end
        else
            if Y(i) < path.radius
                section = 6;
            else
                section = 5;
            end
        end
    else
        if Y(i) < path.radius
            section = 2;
        else
            section = 3;
        end
    end
    if ((prev_section == 6) && (section == 1))
        loops = loops  + 1;
        j = j+1;
        tloops(j) = t(i);
    end
    prev_section = section;
    if ~insideTrack(X(i),Y(i),section,path)
        k = k+1;
        Xerr(k) = X(i);
        Yerr(k) = Y(i);
        terr(k) = t(i);
    end
end
raceStats.loops = loops;
raceStats.tloops = tloops;
raceStats.leftTrack.X = Xerr;
raceStats.leftTrack.Y = Yerr;
raceStats.leftTrack.t = terr;

raceStats.minSOC = min(out.SOC.Data);
raceStats.maxSOC = max(out.SOC.Data);
raceStats.endSOC = out.SOC.Data(end);

end

function yesorno = insideTrack(x,y,section,path)
switch section
    case 1
        if ((y < (0.0 + path.width)) && (y > (0.0 - path.width))) 
            yesorno = 1;
        else
            yesorno = 0;
        end
    case {2, 3}
        rad = sqrt((x - path.l_st)^2 + (y - path.radius)^2);
        if ((rad < path.radius + path.width) && ...
                (rad > path.radius - path.width))
            yesorno = 1;
        else
            yesorno = 0;
        end
    case 4
        if ((y < (2 * path.radius + path.width)) && ...
                (y > (2 * path.radius - path.width))) 
            yesorno = 1;
        else
            yesorno = 0;
        end        
    case {5, 6}
        rad = sqrt((x - 0.0)^2 + (y - path.radius)^2);
        if ((rad < path.radius + path.width) && ...
                (rad > path.radius - path.width))
            yesorno = 1;
        else
            yesorno = 0;
        end
    otherwise
        print("error");
end
end