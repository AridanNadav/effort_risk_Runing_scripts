
function []=BB_RISK_demo(risk_demolevels,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)

TIMEstamp
fid_riskDemo = fopen([outputPath '/' subjectID '_risk_demo_' TIMEstamp '.txt'],'a');
fprintf(fid_riskDemo,'Effort_Risk\tEffort_L\tRiskisL\tRTchoice\tchoice\n');

%^times
choice=2;

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

demo_trials=length(risk_demolevels);

%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];%gray

%find Instructions indecies
risk_instruct_demo1 = find(strcmp({Instructions_struct.name}, ['risk_instruct_demo1' '.jpg'])==1);
risk_instruct_demo2 = find(strcmp({Instructions_struct.name}, ['risk_instruct_demo2' '.jpg'])==1);
risk_instruct_demo3 = find(strcmp({Instructions_struct.name}, ['risk_instruct_demo3' '.jpg'])==1);
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

Screen('PutImage',Window,Instructions_struct(risk_instruct_demo1).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key
Screen('PutImage',Window,Instructions_struct(risk_instruct_demo2).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key
Screen('PutImage',Window,Instructions_struct(risk_instruct_demo3).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key

%%

for cur_demotrial=1:demo_trials
    demotrialStart=GetSecs;
    
    Sgoal=risk_demolevels(1,cur_demotrial)  ;
    RgoalH=risk_demolevels(1,cur_demotrial)+risk_demolevels(2,cur_demotrial)  ;
    RgoalL=risk_demolevels(1,cur_demotrial)-risk_demolevels(2,cur_demotrial)  ;
    
    putRiskL=round(rand);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% offer
    
    Screen('TextSize', Window, 90);
    DrawFormattedText(Window,'+','center','center',[255 255 255]);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('TextSize', Window, 40);
    
    if  putRiskL==1
        Screen('FillRect', Window, black, baserectR);
        Screen('FillRect', Window, gray, [ baserectR(1), baserectR(2)+baserectLong-(baserectLong*Sgoal)-five_percent , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*Sgoal)+five_percent]);
        Screen('DrawLine', Window ,black, baserectR(1), baserectR(2)+baserectLong-(baserectLong*Sgoal) , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*Sgoal),HrectpenW);
        DrawFormattedText(Window,num2str(Sgoal*100),baserectR(1)-60,baserectR(2)+baserectLong-(baserectLong*Sgoal)+10,black);
        
        Screen('FillRect', Window, black, baserectL);
        Screen('FillRect', Window, gray, [ baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalH)-five_percent , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalH)+five_percent]);
        Screen('DrawLine', Window ,black, baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalH) , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalH),HrectpenW);
        DrawFormattedText(Window,num2str(RgoalH*100),baserectL(3)+10,baserectL(2)+baserectLong-(baserectLong*RgoalH)+10,black);
        Screen('FillRect', Window, gray, [ baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalL)-five_percent , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalL)+five_percent]);
        Screen('DrawLine', Window ,black, baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalL) , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalL),HrectpenW);
        DrawFormattedText(Window,num2str(RgoalL*100),baserectL(3)+10,baserectL(2)+baserectLong-(baserectLong*RgoalL)+10,black);
    else
        Screen('FillRect', Window, black, baserectL);
        Screen('FillRect', Window, gray, [ baserectL(1), baserectL(2)+baserectLong-(baserectLong*Sgoal)-five_percent , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*Sgoal)+five_percent]);
        Screen('DrawLine', Window ,black, baserectL(1), baserectL(2)+baserectLong-(baserectLong*Sgoal) , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*Sgoal),HrectpenW);
        DrawFormattedText(Window,num2str(Sgoal*100),baserectL(3)+10,baserectL(2)+baserectLong-(baserectLong*Sgoal)+10,black);
        
        Screen('FillRect', Window, black, baserectR);
        Screen('FillRect', Window, gray, [ baserectR(1), baserectR(2)+baserectLong-(baserectLong*RgoalH)-five_percent , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*RgoalH)+five_percent]);
        Screen('DrawLine', Window ,black, baserectR(1), baserectR(2)+baserectLong-(baserectLong*RgoalH) , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*RgoalH),HrectpenW);
        DrawFormattedText(Window,num2str(RgoalH*100),baserectR(1)-60,baserectR(2)+baserectLong-(baserectLong*RgoalH)+10,black);
        Screen('FillRect', Window, gray, [ baserectR(1), baserectR(2)+baserectLong-(baserectLong*RgoalL)-five_percent , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*RgoalL)+five_percent]);
        Screen('DrawLine', Window ,black, baserectR(1), baserectR(2)+baserectLong-(baserectLong*RgoalL) , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*RgoalL),HrectpenW);
        DrawFormattedText(Window,num2str(RgoalL*100),baserectR(1)-60,baserectR(2)+baserectLong-(baserectLong*RgoalL)+10,black);
    end
    
    Screen(Window,'Flip',0,1);
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
                    respTime = firstPress(KbName(leftstack))-demotrialStart;
                    noresp = 0;
                    goodresp = 1;
                case rightstack
                    respTime = firstPress(KbName(rightstack))-demotrialStart;
                    noresp = 0;
                    goodresp = 1;
            end
        end % end if keyIsDown && noresp
        
        % check for reaching time limit
        if noresp && GetSecs-demotrialStart >= choice
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
        WaitSecs(0.5);
    end % end if goodresp==1
    
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    %-----------------------------------------------------------------
    Screen(Window,'Flip',0,0);
    Screen('TextSize', Window, 90);
    DrawFormattedText(Window,'+','center','center',[255 255 255]);
    Screen(Window,'Flip',0,0);
    WaitSecs(3)
    
    
    
    fprintf(fid_riskDemo,'%d\t %d\t %d\t %d\t %s\n', risk_demolevels(2,cur_demotrial), Sgoal, putRiskL,respTime,keyPressed); %#################
end

%%%run again?



DrawFormattedText(Window,'Continue? ','center','center',[255 255 255]);
Screen('Flip',Window);

KbQueueCreate()
KbQueueStart();%%start listening
KbQueueFlush();%%removes all keyboard presses
[ ~,keyCode] = KbWait();
Response = KbName(keyCode);
%Response = Response(1);
while     ~ismember(Response,['y','Y','n','N'])
    KbQueueCreate()
    KbQueueStart();%%start listening
    KbQueueFlush();%%removes all keyboard presses
    [ ~,keyCode] = KbWait();
    Response = KbName(keyCode);
    
end
if ~ismember(Response,['y','Y'])
    BB_RISK_demo(risk_demolevels,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)    
end
Screen('Flip',Window);



fclose(fid_riskDemo);
