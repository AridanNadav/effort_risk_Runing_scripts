function []=BB_training(study100,runNUM,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
% learn different known levels out of eMVC
%% pre run

runNUMs=num2str(runNUM);
runtype='Tn'; %percived effort
%WithORnot_eyeTracker
%eye_tracker_setup

%^ output file
TIMEstamp
fid_train = fopen([outputPath '/' subjectID '_training_' runNUMs '_' TIMEstamp '.txt'],'a');
fprintf(fid_train,'Trial\tEffort_level\tRTdyno\tPercentInTarget\tdyno\n');

%^times
squeezBruto=4;
squeez100=3;
trialt=6;

%^ rect sizes
baserectLong=600;
baserectShort=150;

% baserectW=0.3125*wWidth;% relative to screen size
% baserectH=0.1389*wHeight;% relative to screen size
VrectStartX=(wWidth-baserectShort)/2;
VrectStartY=(wHeight-baserectLong)/2;
five_percent=baserectLong*0.05;

Vbaserect=[VrectStartX VrectStartY VrectStartX+baserectShort VrectStartY+baserectLong];

HrectpenW=10;


%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];%gray

%^daq
try [daq]=DaqFind;
catch
    daq=2;
end
Achan = 8; Arange = 1;

effortLevels=(.10:.05:.90);
effortLevels_Shuffled=Shuffle(effortLevels);
blocks=5;
alldaqVec=cell(length(effortLevels),1);

%find Instructions indecies
training_instruct = find(strcmp({Instructions_struct.name}, ['training_instruct' '.jpg'])==1);
dont_sqeeze = find(strcmp({Instructions_struct.name}, ['dont_squeeze' '.jpg'])==1);
breaknow = find(strcmp({Instructions_struct.name}, ['breaknow' '.jpg'])==1);
end_break = find(strcmp({Instructions_struct.name}, ['CONT' '.jpg'])==1);


%% Run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------- instructions----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('PutImage',Window,Instructions_struct(training_instruct).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------- full part ----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%fixation
fixstart=GetSecs;
Screen('TextSize', Window, 70);
DrawFormattedText(Window,'+','center','center',white);
Screen('Flip',Window);

while GetSecs-fixstart<1.5
    dont= DaqAIn(daq,Achan,Arange);
    if dont>0.1
        Screen('PutImage',Window,Instructions_struct(dont_sqeeze).image);
        Screen('Flip',Window);
        WaitSecs(0.5)
        fixstart=GetSecs;
        
    else
        Screen('TextSize', Window, 70);
        DrawFormattedText(Window,'+','center','center',white);
        Screen('Flip',Window);
    end
end

for current_block=1:blocks
    for ieffortLevels=1:length(effortLevels_Shuffled)
        %settings
        goal=effortLevels_Shuffled(ieffortLevels);
        winvec(1,ieffortLevels+blocks*(current_block-1))=goal;
        daqVec=[0 0];
        holdVec=1;
        daqBase= DaqAIn(daq,Achan,Arange);
        start_percent_squeezVEC=0;
        percent_squeezVEC=[];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %------------ squeez-------------%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        percent_squeez=0;
        hold_start=GetSecs;
        trialstart=GetSecs;
        noRT=1;
        RTdyno=999;
        while GetSecs-hold_start<squeez100 && GetSecs-trialstart<squeezBruto
            squeez= DaqAIn(daq,Achan,Arange)+abs(daqBase);
            if squeez>0.05
                if noRT
                    RTdyno=GetSecs-trialstart;
                    noRT=0;
                else
                    daqVec=[daqVec squeez];
                    last2=[daqVec(end-1) daqVec(end)];
                    percent_squeez=(mean(last2)/study100/goal);
                end
                if start_percent_squeezVEC
                    percent_squeezVEC=[percent_squeezVEC percent_squeez];
                end
            else
                percent_squeez=0;
            end
            Screen('FillRect', Window, black, Vbaserect);
            Screen('FillRect', Window, gray, [ Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*goal)-five_percent , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*goal)+five_percent]);
            Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
            Screen('DrawLine', Window ,black, Vbaserect(1), Vbaserect(2)+baserectLong-(baserectLong*goal) , Vbaserect(3) ,Vbaserect(2)+baserectLong-(baserectLong*goal),HrectpenW);
            Screen('TextSize', Window, 30);
            DrawFormattedText(Window,num2str(goal*100),Vbaserect(1)-50,Vbaserect(2)+baserectLong-(baserectLong*goal)+10,white);
            
            if percent_squeez>0
                currentY= ceil(wHeight-VrectStartY-percent_squeez*goal*baserectLong);
                Screen('FillRect', Window, white, [Vbaserect(1) currentY  Vbaserect(3) Vbaserect(4) ]);
            end
            
            if percent_squeez>goal-0.05*study100
                if holdVec;
                    holdVec=0;
                    hold_start=GetSecs;
                    start_percent_squeezVEC=1;
                end
            end
            
            Screen('Flip', Window);
            
        end
        
        
        
        
        %post trial calculations
        findgoal= percent_squeezVEC>1-0.05*study100/goal & percent_squeezVEC< 1+0.05*study100/goal ;
        PwhithinTargetRange=sum(findgoal)/length(findgoal);
        winvec(2,ieffortLevels+blocks*(current_block-1))=PwhithinTargetRange;
        alldaqVec{ieffortLevels}=daqVec;
        SdaqVec=num2str(daqVec);
        fprintf(fid_train,'%d\t %d\t %d\t %d\t %d\t %d\t %s\n',ieffortLevels, goal*100, RTdyno, PwhithinTargetRange,SdaqVec); %#################
        
        %fixation
        Screen('TextSize', Window, 70);
        DrawFormattedText(Window,'+','center','center',[255 255 255]);
        Screen('Flip',Window);
        WaitSecs(0.5)
        
        
        while GetSecs-trialstart<trialt
            dont= DaqAIn(daq,Achan,Arange);
            if dont>0.1
                Screen('PutImage',Window,Instructions_struct(dont_sqeeze).image);
                Screen('Flip',Window);
                WaitSecs(0.3)
            else
                Screen('TextSize', Window, 70);
                
                DrawFormattedText(Window,'+','center','center',white);
                Screen('Flip',Window);
            end
        end
        
    end
    
    Screen('PutImage',Window,Instructions_struct(breaknow).image);
    Screen('Flip',Window);
    WaitSecs(10)
    Screen('PutImage',Window,Instructions_struct(end_break).image);
    Screen('Flip',Window);
    wait4key
    
end

fclose(fid_train);
percent_goal=nanmean(winvec(2,:));
save ([outputPath '/' subjectID '_BB_train_' runNUMs])
%ShowCursor;
%{

    
    msg=['vas_run_' runNUMs '_image_' num2str(RAndFRACT(l)) '_offset_' num2str(GetSecs-runStart)];
    Eyelinkmsg;% ---------------------------
    
    
    

msg=['VAS_run_' runNUMs '_endtime_' num2str(GetSecs)];
Eyelinkmsg




eye_tracker_wrapup
%}
end
