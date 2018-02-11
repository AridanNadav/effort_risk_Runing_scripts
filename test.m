
AA_Screen_Set_n_Open
effortLevels=[1 Shuffle(.10:.05:.90)];
winvec=zeros(2,length(effortLevels));
for i=1:length(effortLevels)
    goal=effortLevels(i);
    winvec(1,i)=goal;
    timeHolding=0;
    daqVec=[0 0];
                holdVec=[];

    start=GetSecs;
    daqBase= DaqAIn(daq,Achan,Arange);
    while GetSecs-start<5 && timeHolding<3
        squeez= DaqAIn(daq,Achan,Arange)+abs(daqBase);
        if squeez>=0
            daqVec=[daqVec squeez];
            last2=[daqVec(end-1) daqVec(end)];
            percent_squeez=(mean(last2)/study100);
        end
        %Screen('FillRect', Window, baserectColor, baserect);
        Screen('FrameRect', Window, baserectColor, baserect,penW);
        if percent_squeez>=0
            Screen('FillRect', Window, efrtrectColor, [rectStartX+penW rectStartY+penW rectStartX+penW+ceil(percent_squeez/goal*(baserectW-penW)) rectStartY+baserectH-penW]);
        end
        
        if percent_squeez>goal-0.05 && percent_squeez<goal+0.05
            if isempty(holdVec)
                holdVec=1;
                Arcrect_start=GetSecs;
            else
                timeHolding=GetSecs-Arcrect_start;
                if timeHolding>3
                    timeHolding=3;
                end
                %holdVec=  [holdVec squeez];
                %Screen('FillArc',Window,efrtrectColor,Arcrect,0,length(holdVec)/ceil(SR*squeez100)*360)
                Screen('FillArc',Window,efrtrectColor,Arcrect,0,timeHolding/squeez100*360)
                if timeHolding==3
                    winvec(2,i)=1;
                end
                
            end
            
            
            
        else
            timeHolding=0;
            holdVec=[];
        end
        
        Screen('Flip', Window);

    end
    
    DrawFormattedText(Window,'+','center','center',[255 255 255]);
    Screen('Flip',Window);
    while GetSecs-start<7
    end
    
end
sca


[stippleEnabled stippleFactor stipleVector]=Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0] );
Screen('DrawLine', Window ,baserectColor, baserect(3)+25, baserect(2) ,baserect(3)+25, baserect(4) ,penW);
        Screen('Flip', Window);
