function [win]=BB_gain_realization(study100,gain_relization,Window,Instructions_struct)
%instructions
squeez100=3;

try [daq]=DaqFind;
catch
    daq=2;
end
Achan = 8; Arange = 1;


[wWidth, wHeight]=Screen('WindowSize', Window); % General window size
HrectpenW=10;

%^ rect sizes
baserectLong=600;
baserectShort=150;

% baserectW=0.3125*wWidth;% relative to screen size
% baserectH=0.1389*wHeight;% relative to screen size
VrectStartX=(wWidth-baserectShort)/2;
VrectStartY=(wHeight-baserectLong)/2;
five_percent=baserectLong*0.05;

Vbaserect=[VrectStartX VrectStartY VrectStartX+baserectShort VrectStartY+baserectLong];

%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];%gray


RISK_realization1stDRAW = find(strcmp({Instructions_struct.name}, ['RISK_realization1stDRAW' '.jpg'])==1);
RISK_realizationDRAWrisk = find(strcmp({Instructions_struct.name}, ['RISK_realizationDRAWrisk' '.jpg'])==1);
RISK_realizationRESULT = find(strcmp({Instructions_struct.name}, ['RISK_realizationRESULT' '.jpg'])==1);
RISK_realizationRESULTsz= size(Instructions_struct(RISK_realizationRESULT).image);
RISK_realizationRESULTrect=[((wWidth-RISK_realizationRESULTsz(2))/2), wHeight*0.05,((wWidth+RISK_realizationRESULTsz(2))/2),RISK_realizationRESULTsz(1)+wHeight*0.05];
CONT = find(strcmp({Instructions_struct.name}, ['CONT' '.jpg'])==1);
CONTsz= size(Instructions_struct(CONT).image);
CONTrect=[((wWidth-CONTsz(2))/2), wHeight*0.9,((wWidth+CONTsz(2))/2),CONTsz(1)+wHeight*0.9];
RISK_realizationsqueeze = find(strcmp({Instructions_struct.name}, ['RISK_realizationsqueeze' '.jpg'])==1);
RISK_realizationsqueezeSZ=size(Instructions_struct(RISK_realizationsqueeze).image);
RISK_realizationsqueezerect=[((wWidth-RISK_realizationsqueezeSZ(2))/2), wHeight*0.8,((wWidth+RISK_realizationsqueezeSZ(2))/2),RISK_realizationsqueezeSZ(1)+wHeight*0.8];
RISK_realizationsqueezerect=RISK_realizationsqueezerect*0.5;
RISK_realizationRESULTrect=RISK_realizationRESULTrect*0.5;
%% choice raffle
Screen('PutImage',Window,Instructions_struct(RISK_realization1stDRAW).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key
%draw random level


stoP=GetSecs;
while GetSecs<stoP+1.5
    randopt=randperm(length(gain_relization));
    for i=1:length(gain_relization)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% offer
        Screen('PutImage',Window,Instructions_struct(RISK_realizationRESULT).image,RISK_realizationRESULTrect);
        Screen('TextSize', Window, 40);
        Screen('FillRect', Window, black, Vbaserect);
        Screen('FillRect', Window, gray, [ Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))-five_percent , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))+five_percent]);
Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('DrawLine', Window ,black, Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )) , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )),HrectpenW);        
    DrawFormattedText(Window,num2str(gain_relization(1,randopt(i))*100),Vbaserect(1)-50,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))-10,black);
        DrawFormattedText(Window,['+ ' num2str(gain_relization(2,randopt(i)))],Vbaserect(1)+35,Vbaserect(2)-40,white);
        Screen(Window,'Flip');
    end
end

Screen('PutImage',Window,Instructions_struct(RISK_realizationRESULT).image,RISK_realizationRESULTrect);

Screen('PutImage',Window,Instructions_struct(RISK_realizationRESULT).image,RISK_realizationRESULTrect);
        Screen('TextSize', Window, 40);
        Screen('FillRect', Window, black, Vbaserect);
        Screen('FillRect', Window, gray, [ Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))-five_percent , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))+five_percent]);
Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('DrawLine', Window ,black, Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )) , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )),HrectpenW);        
    DrawFormattedText(Window,num2str(gain_relization(1,randopt(i))*100),Vbaserect(1)-50,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i)))-10,black);
        DrawFormattedText(Window,['+ ' num2str(gain_relization(2,randopt(i)))],Vbaserect(1)+35,Vbaserect(2)-40,white);
        Screen('PutImage',Window,Instructions_struct(CONT).image,CONTrect);

        Screen(Window,'Flip');
WaitSecs(0.5);
wait4key


% find if the chosen level is risk or safe

    
    

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------ squeez-------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

daqVec=[0 0];
holdVec=1;
daqBase= DaqAIn(daq,Achan,Arange);
start_percent_squeezVEC=0;
percent_squeezVEC=[];

percent_squeez=0;
hold_start=GetSecs;
trialstart=GetSecs;
noRT=1;
hold_time=0;
while hold_time<squeez100
    squeez= DaqAIn(daq,Achan,Arange)+abs(daqBase);
    if squeez>0
        if noRT
            RTdyno=GetSecs-trialstart;
            noRT=0;
        else
            daqVec=[daqVec squeez];
            last2=[daqVec(end-1) daqVec(end)];
            percent_squeez=(mean(last2)/study100)/gain_relization(1,randopt(i));
        end
        
        %if start_percent_squeezVEC
            percent_squeezVEC=[percent_squeezVEC percent_squeez];
        %end
    else
        percent_squeez=0;
    end
            Screen('PutImage',Window,Instructions_struct(RISK_realizationsqueeze).image,RISK_realizationsqueezerect);

    Screen('FillRect', Window, black, Vbaserect);
    Screen('FillRect', Window, gray, [ Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) ))-five_percent , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) ))+five_percent]);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('DrawLine', Window ,black, Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )) , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) )),HrectpenW);
    Screen('TextSize', Window, 40);
    DrawFormattedText(Window,num2str(gain_relization(1,randopt(i))*100),Vbaserect(1)-50,Vbaserect(2)+baserectLong-(baserectLong*gain_relization(1,randopt(i) ))-10,black);
            DrawFormattedText(Window,['+ ' num2str(gain_relization(2,randopt(i)))],Vbaserect(1)+35,Vbaserect(2)-40,white);

    if percent_squeez>0
        currentY= ceil(wHeight-VrectStartY-percent_squeez*gain_relization(1,randopt(i))*baserectLong);
        Screen('FillRect', Window, white, [Vbaserect(1) currentY  Vbaserect(3) Vbaserect(4) ]);
    end
    
    
    
    if  percent_squeez>0.95  && percent_squeez<1.06
        if startHold
            hold_start=GetSecs;
            startHold=0;
        else
            hold_time= GetSecs-hold_start;
        end
    else
        startHold=1;
    end
    
    Screen('Flip', Window);
end
win=(gain_relization(2,randopt(i)));

