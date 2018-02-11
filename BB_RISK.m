
function [RISKrelization]=BB_RISK(Levels,runNUM,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker)
TIMEstamp
runNUMs=num2str(runNUM);
fid_risk = fopen([outputPath '/' subjectID '_risk_' runNUMs '_' TIMEstamp '.txt'],'a');
fprintf(fid_risk,'Trial\tEffort_Risk\tEffort_Level\tif_sanity\tRiskisL\tonset\tRTchoice\tchoice\n');
maxChoiceTime=2;
Ntrials=length(Levels.risk(runNUM).effort);

%^rect sizes
baserectLong=600;
baserectShort=150;
five_percent=baserectLong*0.05;

% baserectW=0.3125*wWidth;% relative to screen size
% baserectH=0.1389*wHeight;% relative to screen size
RVrectStartX=wWidth*.75-baserectShort;
RVrectStartY=(wHeight-baserectLong)/2;
baserectR=[RVrectStartX RVrectStartY RVrectStartX+baserectShort RVrectStartY+baserectLong];
choiceRectR=[baserectR(1)-75 baserectR(2)-15 baserectR(3)+75 baserectR(4)+15];

LVrectStartX=wWidth*.25;
LVrectStartY=(wHeight-baserectLong)/2;
baserectL=[LVrectStartX LVrectStartY LVrectStartX+baserectShort LVrectStartY+baserectLong];
choiceRectL=[baserectL(1)-75 baserectL(2)-15 baserectL(3)+75 baserectL(4)+15];

HrectpenW=10;

%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];%gray

%find Instructions indecies
risk_instruct = find(strcmp({Instructions_struct.name}, ['risk_instruct' '.jpg'])==1);
no_choice = find(strcmp({Instructions_struct.name}, ['no_choice' '.jpg'])==1);


%response keys
KbName('UnifyKeyNames');
%MRI=0;

leftstack = 'LeftArrow';
rightstack = 'RightArrow';
%         leftstack = 'b';
%         rightstack = 'y';
badresp = 'x';


%%

Screen('PutImage',Window,Instructions_struct(risk_instruct).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key

msg=['Risk_run_' runNUMs '_starttime_' num2str(GetSecs)];
Eyelinkmsg

runStart= GetSecs;
Screen('TextSize', Window, 90);
DrawFormattedText(Window,'+','center','center',white);
Screen(Window,'Flip');
%%
    relization_counter=1;

for cur_trial=1:Ntrials
    Sgoal=Levels.risk(runNUM).effort(cur_trial)/100 ;
    putRiskL=round(rand);
    
    if  putRiskL==1 % put risk option on the left
        baserectRsk=baserectL;
        baserectSf=baserectR;

    else
        baserectRsk=baserectR;
        baserectSf=baserectL;
  
    end
    
    if  ismember(Sgoal,[0.62,0.38]) && Levels.risk(runNUM).sanity_chooseRISK(cur_trial)% put risk option on the left
        RgoalH=Sgoal ;
        RgoalL =(Levels.risk(runNUM).effort(cur_trial)-2*Levels.risk(runNUM).risk(cur_trial))/100  ;
    elseif ismember(Sgoal,[0.62,0.38])
        RgoalH=(Levels.risk(runNUM).effort(cur_trial)+2*Levels.risk(runNUM).risk(cur_trial))/100  ;
        RgoalL=Sgoal;
    else
        RgoalH=(Levels.risk(runNUM).effort(cur_trial)+Levels.risk(runNUM).risk(cur_trial))/100  ;
        RgoalL=(Levels.risk(runNUM).effort(cur_trial)-Levels.risk(runNUM).risk(cur_trial))/100  ;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% offer
    
    Screen('TextSize', Window, 90);
    DrawFormattedText(Window,'+','center','center',[255 255 255]);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('TextSize', Window, 40);
    
    %%%%%% Safe
    Screen('FillRect', Window, black, baserectSf);
    Screen('FillRect', Window, gray, [ baserectSf(1), baserectSf(2)+baserectLong-(baserectLong*Sgoal)-five_percent , baserectSf(3) ,baserectSf(2)+baserectLong-(baserectLong*Sgoal)+five_percent]);
    Screen('DrawLine', Window ,black, baserectSf(1), baserectSf(2)+baserectLong-(baserectLong*Sgoal) , baserectSf(3) ,baserectSf(2)+baserectLong-(baserectLong*Sgoal),HrectpenW);
    %%%%%% risk
    Screen('FillRect', Window, black, baserectRsk);
    Screen('FillRect', Window, gray, [ baserectRsk(1), baserectRsk(2)+baserectLong-(baserectLong*RgoalH)-five_percent , baserectRsk(3) ,baserectRsk(2)+baserectLong-(baserectLong*RgoalH)+five_percent]);
    Screen('DrawLine', Window ,black, baserectRsk(1), baserectRsk(2)+baserectLong-(baserectLong*RgoalH) , baserectRsk(3) ,baserectRsk(2)+baserectLong-(baserectLong*RgoalH),HrectpenW);
    Screen('FillRect', Window, gray, [ baserectRsk(1), baserectRsk(2)+baserectLong-(baserectLong*RgoalL)-five_percent , baserectRsk(3) ,baserectRsk(2)+baserectLong-(baserectLong*RgoalL)+five_percent]);
    Screen('DrawLine', Window ,black, baserectRsk(1), baserectRsk(2)+baserectLong-(baserectLong*RgoalL) , baserectRsk(3) ,baserectRsk(2)+baserectLong-(baserectLong*RgoalL),HrectpenW);
    
    %%%%%% text
    if  putRiskL==0 % put risk option on the left
    DrawFormattedText(Window,num2str(Sgoal*100),baserectSf(1)+160,baserectSf(2)+baserectLong-(baserectLong*Sgoal)+10,black);
    DrawFormattedText(Window,num2str(RgoalH*100),baserectRsk(3)-210,baserectRsk(2)+baserectLong-(baserectLong*RgoalH)+10,black);
    DrawFormattedText(Window,num2str(RgoalL*100),baserectRsk(3)-210,baserectRsk(2)+baserectLong-(baserectLong*RgoalL)+10,black);
    elseif putRiskL==1
    DrawFormattedText(Window,num2str(Sgoal*100),baserectSf(1)-60,baserectSf(2)+baserectLong-(baserectLong*Sgoal)+10,black);
    DrawFormattedText(Window,num2str(RgoalH*100),baserectRsk(3)+10,baserectRsk(2)+baserectLong-(baserectLong*RgoalH)+10,black);
    DrawFormattedText(Window,num2str(RgoalL*100),baserectRsk(3)+10,baserectRsk(2)+baserectLong-(baserectLong*RgoalL)+10,black);    
        
    end
    
    Screen(Window,'Flip',Levels.risk(runNUM).onsets(cur_trial)+runStart,1);
    trial_real_onsetTime= GetSecs-runStart;
    trialStart=GetSecs;
    msg=['Risk_run_' runNUMs '_trial_' num2str(cur_trial) 'option_display_time_' num2str(GetSecs)];
    Eyelinkmsg
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% response
    noresp = 1;
    goodresp = 0;
    KbQueueCreate()
    KbQueueStart();%%start listening
    KbQueueFlush();%%removes all keyboard presses
    
    while noresp
        % check for response
        
        [keyIsDown, firstPress] = KbQueueCheck;
        
        if keyIsDown && noresp
            keyPressed = KbName(firstPress);
            if ischar(keyPressed) == 0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                keyPressed = char(keyPressed);
                keyPressed = keyPressed(1);
            end
            switch keyPressed
                case leftstack
                    respTime = firstPress(KbName(leftstack))-trialStart;
                    noresp = 0;
                    goodresp = 1;
                case rightstack
                    respTime = firstPress(KbName(rightstack))-trialStart;
                    noresp = 0;
                    goodresp = 1;
            end
            msg=['Risk_run_' runNUMs '_trial_' num2str(cur_trial) 'choice_time_' num2str(GetSecs)];
            Eyelinkmsg
        end % end if keyIsDown && noresp
        
        % check for reaching time limit
        if noresp && GetSecs-trialStart >= maxChoiceTime
            noresp = 0;
            keyPressed = badresp;
            respTime = NaN;
        end
    end % end while noresp
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% choice rect
    if goodresp==1
        
        if strcmp(keyPressed,leftstack)
            Screen('FrameRect', Window, white, choiceRectL, HrectpenW);
            
        elseif strcmp(keyPressed,rightstack)
            Screen('FrameRect', Window, white, choiceRectR, HrectpenW);
            
        end
        
        Screen(Window,'Flip',0,1);
        WaitSecs(0.5);
        
    else % if did not respond: show text 'You must respond faster!'
        Screen(Window,'Flip',0,0);
        Screen('PutImage',Window,Instructions_struct(no_choice).image);
        Screen(Window,'Flip',0,0);
        WaitSecs(0.7);
    end % end if goodresp==1
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    %-----------------------------------------------------------------
    Screen(Window,'Flip',0,0);
    Screen('TextSize', Window, 90);
    DrawFormattedText(Window,'+','center','center',white);
    Screen(Window,'Flip',0,0);
    msg=['Risk_run_' runNUMs '_trial_' num2str(cur_trial) 'fixation_time_' num2str(GetSecs)];
            Eyelinkmsg
    %     fprintf(fid_risk,'Effort_Risk\tEffort_L\tRiskisL\tonset\tRTchoice\tchoice\n');
    
    %%%%% choice for relization
    if ~strcmp(badresp,keyPressed)

        if (putRiskL && strcmp(leftstack,keyPressed))||(~putRiskL && ~strcmp(leftstack,keyPressed))  %choose risk
        RgoalHvec(relization_counter)= RgoalH;
        RgoalLvec(relization_counter)= RgoalL;
        else %choose safe
        RgoalHvec(relization_counter)= Sgoal;
        RgoalLvec(relization_counter)=Sgoal;
        end
        relization_counter=relization_counter+1;

    end

        
    fprintf(fid_risk,'%d\t %d\t %d\t %d\t %d\t %d\t %d\t %s\n', cur_trial,Levels.risk(runNUM).risk(cur_trial), Levels.risk(runNUM).effort(cur_trial),Levels.risk(runNUM).sanity_chooseRISK(cur_trial), putRiskL,trial_real_onsetTime,respTime,keyPressed); %#################
end

msg=['Risk_run_' runNUMs 'end_time_' num2str(GetSecs)];
            Eyelinkmsg
RISKrelization=[RgoalHvec;RgoalLvec];

% relization(runNUM).RgoalH=RgoalHvec;
% relization(runNUM).RgoalL=RgoalLvec;
fclose(fid_risk);
end