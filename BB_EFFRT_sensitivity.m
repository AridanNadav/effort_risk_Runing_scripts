
function [gain_relization]=BB_EFFRT_sensitivity(Levels,runNUM,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker)

%% pre run

TIMEstamp
runNUMs=num2str(runNUM);
fid_gain = fopen([outputPath '/' subjectID '_effort_sensitivity_' runNUMs '_' TIMEstamp '.txt'],'a');
fprintf(fid_gain,'Trial\tGain_gain\tGain_Effort_Level\tSafe_gain\tSafe_Effort_Level\tif_sanity\tGainisL\tonset\tRTchoice\tchoice\n');
maxChoiceTime=3;
Ntrials=length(Levels.gain(runNUM).effort);

%^rect sizes
baserectLong=600;
baserectShort=150;
five_percent=baserectLong*0.05;

% baserectW=0.3125*wWidth;% relative to screen size
% baserectH=0.1389*wHeight;% relative to screen size
RVrectStartX=wWidth*.75-baserectShort;
RVrectStartY=(wHeight-baserectLong)/2;
baserectR=[RVrectStartX RVrectStartY RVrectStartX+baserectShort RVrectStartY+baserectLong];
choiceRectR=[baserectR(1)-75 baserectR(2)-80 baserectR(3)+75 baserectR(4)+15];

LVrectStartX=wWidth*.25;
LVrectStartY=(wHeight-baserectLong)/2;
baserectL=[LVrectStartX LVrectStartY LVrectStartX+baserectShort LVrectStartY+baserectLong];
choiceRectL=[baserectL(1)-75 baserectL(2)-80 baserectL(3)+75 baserectL(4)+15];

HrectpenW=10;

%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];%gray

%find Instructions indecies
money_instruct = find(strcmp({Instructions_struct.name}, ['money_instruct' '.jpg'])==1);
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

Screen('PutImage',Window,Instructions_struct(money_instruct).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key


msg=['EffortReward_run_' runNUMs '_starttime_' num2str(GetSecs)];
Eyelinkmsg

runStart= GetSecs;
Screen('TextSize', Window, 90);
DrawFormattedText(Window,'+','center','center',white);
Screen(Window,'Flip');
%%
relization_counter=1; % save choices for relization
sanity_counter=1;
for cur_trial=1:Ntrials
    
    if Levels.gain(runNUM).effort(cur_trial)==1 %sanity
        lowgoal=Levels.gain(runNUM).sanity(sanity_counter,1)/100;
        lowgain=Levels.gain(runNUM).sanity(sanity_counter,2);
        gaingoal=Levels.gain(runNUM).sanity(sanity_counter,3)/100 ;
        gaingain= Levels.gain(runNUM).sanity(sanity_counter,4) ;
        sanity_counter=sanity_counter+1;
        is_sanity=1;
    else
        lowgoal=0.15;
        lowgain=0.5;
        gaingoal=Levels.gain(runNUM).effort(cur_trial)/100 ;
        gaingain=Levels.gain(runNUM).gain(cur_trial)  ;
        is_sanity=0;
        
    end
    
    %randomize options location
    putgainL=round(rand);
    
    if  putgainL==1 % put gain option on the left
        baserectgain=baserectL;
        baserectSf=baserectR;
    else
        baserectgain=baserectR;
        baserectSf=baserectL;
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% offer
    
    Screen('TextSize', Window, 90);
    DrawFormattedText(Window,'+','center','center',[255 255 255]);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('TextSize', Window, 40);
    
    %%%%%% Safe
    Screen('FillRect', Window, black, baserectSf);
    Screen('FillRect', Window, gray, [ baserectSf(1), baserectSf(2)+baserectLong-(baserectLong*lowgoal)-five_percent , baserectSf(3) ,baserectSf(2)+baserectLong-(baserectLong*lowgoal)+five_percent]);
    Screen('DrawLine', Window ,black, baserectSf(1), baserectSf(2)+baserectLong-(baserectLong*lowgoal) , baserectSf(3) ,baserectSf(2)+baserectLong-(baserectLong*lowgoal),HrectpenW);
    DrawFormattedText(Window,['+ ' num2str(lowgain)],baserectSf(1)+35,baserectSf(2)-40,white);
    
    %%%%%% gain
    Screen('FillRect', Window, black, baserectgain);
    Screen('FillRect', Window, gray, [ baserectgain(1), baserectgain(2)+baserectLong-(baserectLong*gaingoal)-five_percent , baserectgain(3) ,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+five_percent]);
    Screen('DrawLine', Window ,black, baserectgain(1), baserectgain(2)+baserectLong-(baserectLong*gaingoal) , baserectgain(3) ,baserectgain(2)+baserectLong-(baserectLong*gaingoal),HrectpenW);
    DrawFormattedText(Window,['+ ' num2str(gaingain)],baserectgain(1)+35,baserectgain(2)-40,white);
    
    %%%%%% text
    if  putgainL==0 % put risk option on the left
        DrawFormattedText(Window,num2str(lowgoal*100),baserectSf(3)+10,baserectSf(2)+baserectLong-(baserectLong*lowgoal)+10,black);
        DrawFormattedText(Window,num2str(gaingoal*100),baserectgain(1)-60,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+10,black);
        
    elseif putgainL==1
        DrawFormattedText(Window,num2str(lowgoal*100),baserectSf(3)-210,baserectSf(2)+baserectLong-(baserectLong*lowgoal)+10,black);
        DrawFormattedText(Window,num2str(gaingoal*100),baserectgain(1)+160,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+10,black);
        
    end
    
    
    
    Screen(Window,'Flip',Levels.gain(runNUM).onsets(cur_trial)+runStart,1);
    trial_real_onsetTime= GetSecs-runStart;
    trialStart=GetSecs;
    
    msg=['EffortReward_run_' runNUMs '_trial_' num2str(cur_trial) 'option_display_time_' num2str(GetSecs)];
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
            
            msg=['EffortReward_run_' runNUMs '_trial_' num2str(cur_trial) 'choice_time_' num2str(GetSecs)];
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
       msg=['EffortReward_run_' runNUMs '_trial_' num2str(cur_trial) 'fixation_time_' num2str(GetSecs)];
            Eyelinkmsg
    %     fprintf(fid_gain,'Effort_gain\tEffort_L\tgainisL\tonset\tRTchoice\tchoice\n');
    
    %%%%% choice for relization
    if ~strcmp(badresp,keyPressed)
        
        if (putgainL && strcmp(leftstack,keyPressed))||(~putgainL && ~strcmp(leftstack,keyPressed))  %choose gain
            gaineffortvec(relization_counter)= gaingoal;
            gaingainvec(relization_counter)= gaingain;
        else %choose safe
            gaineffortvec(relization_counter)= lowgoal;
            gaingainvec(relization_counter)=lowgain;
        end
        relization_counter=relization_counter+1;
        
    end
    
    fprintf(fid_gain,'%d\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %s\n',cur_trial,gaingain , gaingoal,lowgain,lowgoal, is_sanity, putgainL,trial_real_onsetTime,respTime,keyPressed); %#################
end

msg=['EffortReward_run_' runNUMs 'end_time_' num2str(GetSecs)];
            Eyelinkmsg
gain_relization=[gaineffortvec;gaingainvec];

% relization(runNUM).RgoalH=RgoalHvec;
% relization(runNUM).RgoalL=RgoalLvec;
fclose(fid_gain);
end