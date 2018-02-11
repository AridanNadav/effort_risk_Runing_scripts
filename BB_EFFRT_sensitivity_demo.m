
function BB_EFFRT_sensitivity_demo(gain_demolevels,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)

%% pre run

TIMEstamp
fid_gain_demo = fopen([outputPath '/' subjectID '_effort_sensitivity_demo_' TIMEstamp '.txt'],'a');
fprintf(fid_gain_demo,'Gain_gain\tGain_Effort_Level\tSafe_gain\tSafe_Effort_Level\tif_sanity\tGainisL\tonset\tRTchoice\tchoice\n');
maxChoiceTime=3;

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
demo_trials=length(gain_demolevels);

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

runStart= GetSecs;
Screen('TextSize', Window, 90);
DrawFormattedText(Window,'+','center','center',white);
Screen(Window,'Flip');
%%
    relization_counter=1; % save choices for relization
sanity_counter=1;
for cur_trial=1:demo_trials

        lowgoal=0.15;
        lowgain=0.5;
        gaingoal=gain_demolevels(1,cur_trial) ;
        gaingain=gain_demolevels(2,cur_trial)  ;
    
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
    DrawFormattedText(Window,['+ ' num2str(lowgain)],baserectSf(1)+35,baserectSf(2)-20,white);
    
    %%%%%% gain
    Screen('FillRect', Window, black, baserectgain);
    Screen('FillRect', Window, gray, [ baserectgain(1), baserectgain(2)+baserectLong-(baserectLong*gaingoal)-five_percent , baserectgain(3) ,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+five_percent]);
    Screen('DrawLine', Window ,black, baserectgain(1), baserectgain(2)+baserectLong-(baserectLong*gaingoal) , baserectgain(3) ,baserectgain(2)+baserectLong-(baserectLong*gaingoal),HrectpenW);
       DrawFormattedText(Window,['+ ' num2str(gaingain)],baserectgain(1)+35,baserectgain(2)-20,white);
 %%%%%% text
    if  putgainL==0 % put risk option on the left
        DrawFormattedText(Window,num2str(lowgoal*100),baserectSf(3)+10,baserectSf(2)+baserectLong-(baserectLong*lowgoal)+10,black);
        DrawFormattedText(Window,num2str(gaingoal*100),baserectgain(1)-50,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+10,black);
        
    elseif putgainL==1
        DrawFormattedText(Window,num2str(lowgoal*100),baserectSf(3)+10,baserectSf(2)+baserectLong-(baserectLong*lowgoal)+10,black);
        DrawFormattedText(Window,num2str(gaingoal*100),baserectgain(1)-50,baserectgain(2)+baserectLong-(baserectLong*gaingoal)+10,black);
        
    end
    
    Screen(Window,'Flip',0,1);
    trial_real_onsetTime= GetSecs-runStart;
    trialStart=GetSecs;
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
    is_sanity=0;
    fprintf(fid_gain_demo,'%d\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %s\n',gaingain , gaingoal,lowgoal,lowgain, is_sanity, putgainL,trial_real_onsetTime,respTime,keyPressed); %#################

end

 gaingoal=gain_demolevels(1,cur_trial)/100 ;
        gaingain=gain_demolevels(2,cur_trial)  ;
% relization(runNUM).RgoalH=RgoalHvec;
% relization(runNUM).RgoalL=RgoalLvec;
fclose(fid_gain_demo);
end