function BB_VAS_Demo(study100,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
% try different unknown levels out of eMVC and rate percived % of eMVC
%% pre run

runtype='PE'; %percived effort
%eye_tracker_setup

%^ output file
TIMEstamp
fid_vas = fopen([outputPath '/' subjectID '_vas_Demo _' TIMEstamp '.txt'],'a');
fprintf(fid_vas,'Trial\tEffort_level\tRTdyno\tPercentInTarget\tRTrate\tEffort_rate\tdyno\n');

%^times
squeezBruto=4;
squeez100=3;

%^ rect sizes
baserectLong=600;
baserectShort=150;

% baserectW=0.3125*wWidth;% relative to screen size
% baserectH=0.1389*wHeight;% relative to screen size
HrectStartX=(wWidth-baserectLong)/2;
HrectStartY=(wHeight-baserectShort)/2;
VrectStartX=(wWidth-baserectShort)/2;
VrectStartY=(wHeight-baserectLong)/2;
five_percent=baserectLong*0.05;

Hbaserect =[HrectStartX HrectStartY HrectStartX+baserectLong HrectStartY+baserectShort];% 100% of goal
Vbaserect=[VrectStartX VrectStartY VrectStartX+baserectShort VrectStartY+baserectLong];
targetrect =[HrectStartX+baserectLong-five_percent HrectStartY HrectStartX+baserectLong+five_percent HrectStartY+baserectShort]; % +- 5% of 100% experiment's MVC

HrectpenW=baserectLong/100;

%!colors
black = [0 0 0]; %black
white = [255 255 255]; %white
gray=[128 128 128];
%^daq
try [daq]=DaqFind;
catch
    daq=2;
end
Achan = 8; Arange = 1;

effortLevels=(.10:.05:.90);
effortLevels_Shuffled=Shuffle(effortLevels);
alldaqVec=cell(length(effortLevels),1);

%find Instructions indecies
vas_instruct_demo = find(strcmp({Instructions_struct.name}, ['vas_instruct_demo' '.jpg'])==1);
dontsqeeze = find(strcmp({Instructions_struct.name}, ['dont_squeeze' '.jpg'])==1);
vas_gtrdy2rate = find(strcmp({Instructions_struct.name}, ['vas_gtrdy2rate' '.jpg'])==1);
vas_gtrdy2squeeze = find(strcmp({Instructions_struct.name}, ['vas_gtrdy2squeeze' '.jpg'])==1);
vas_100gtrdy2squeeze = find(strcmp({Instructions_struct.name}, ['vas_100gtrdy2squeeze' '.jpg'])==1);
vas_gtrdy2rate100 = find(strcmp({Instructions_struct.name}, ['vas_gtrdy2rate100' '.jpg'])==1);
vas_gtrdy2squeezeSZ=size(Instructions_struct(vas_gtrdy2squeeze).image);
vas_gtrdy2rateSZ=size(Instructions_struct(vas_gtrdy2rate).image);
vas_gtrdy2squeeze2 = find(strcmp({Instructions_struct.name}, ['vas_gtrdy2squeeze2' '.jpg'])==1);
no_squeeze=find(strcmp({Instructions_struct.name}, ['no_squeeze' '.jpg'])==1);
%% Run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------- instructions----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('PutImage',Window,Instructions_struct(vas_instruct_demo).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------- Demo-100----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('PutImage',Window,Instructions_struct(vas_100gtrdy2squeeze).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key

startHold=1;
daqVec=[0 0];
daqBase= DaqAIn(daq,Achan,Arange);
start_percent_squeezVEC=0;
hold_time=0;
percent_squeez=0;
%squeez time
while hold_time<squeez100
    squeez= DaqAIn(daq,Achan,Arange)+abs(daqBase);
    if squeez>0
        daqVec=[daqVec squeez];
        last2=[daqVec(end-1) daqVec(end)];
        percent_squeez=(mean(last2)/study100);
        if start_percent_squeezVEC
            percent_squeezVEC=[percent_squeezVEC percent_squeez];
        end
    else
        percent_squeez=0;
    end
    Screen('FillRect', Window, black, Hbaserect);
    Screen('FillRect', Window, gray, targetrect);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('DrawLine', Window ,black, Hbaserect(3), Hbaserect(2) ,Hbaserect(3), Hbaserect(4) ,HrectpenW);
    
    if percent_squeez>=0
        currentX=HrectStartX+ceil(percent_squeez*(baserectLong));
        Screen('FillRect', Window, white, [HrectStartX HrectStartY currentX HrectStartY+baserectShort]);
    end
    
    if  percent_squeez>0.91  && percent_squeez<1.09
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
Screen('PutImage',Window,Instructions_struct(vas_gtrdy2rate100).image);
Screen(Window,'Flip');
WaitSecs(0.5);
wait4key
noclick=1;
%ShowCursor(0,Window);
Screen('LineStipple', Window,0 );

while noclick
    
    [GetMouseclicksx,GetMouseclicksy,clicks]=GetMouse(Window);
    Screen('TextSize', Window, 40);
    
    DrawFormattedText(Window,'0',Vbaserect(3)+3,Vbaserect(1)-40,black);
    DrawFormattedText(Window,'100',Vbaserect(3)+3,Vbaserect(2)+10,black);
    Screen('FillRect', Window, black, Vbaserect);
    if GetMouseclicksx>Vbaserect(1) && GetMouseclicksx<Vbaserect(3)&&  GetMouseclicksy>Vbaserect(2) && GetMouseclicksy<Vbaserect(4)
        Screen('DrawLine', Window ,white, Vbaserect(1), GetMouseclicksy ,Vbaserect(3), GetMouseclicksy ,baserectLong*0.01);
        currentY=ceil(100-((GetMouseclicksy-Vbaserect(2))/baserectLong*100));
        DrawFormattedText(Window,num2str(currentY),Vbaserect(1)-50,GetMouseclicksy+10,black);
    end
    
    Screen('Flip',Window);
    
    if clicks(1)==1 && GetMouseclicksx>Vbaserect(1) && GetMouseclicksx<Vbaserect(3)&&  GetMouseclicksy>Vbaserect(2) && GetMouseclicksy<Vbaserect(4)&& currentY==100
        noclick=0;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------- full part ----------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ieffortLevels=1:length(effortLevels)
    %settings
    goal=effortLevels_Shuffled(ieffortLevels);
    winvec(1,ieffortLevels)=goal;
    timeHolding=0;
    daqVec=[0 0];
    holdVec=1;
    daqBase= DaqAIn(daq,Achan,Arange);
    start_percent_squeezVEC=0;
    percent_squeezVEC=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %------------ squeez-------------%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Instructions vas_gtrdy2squeez
    %     Screen('Flip',Window);
    %     wait4key
    %     Screen('Flip',Window);
    %fixation
    fixstart=GetSecs;
    Screen('TextSize', Window, 70);
    DrawFormattedText(Window,'+','center','center',white);
    Screen('Flip',Window);
    
    while GetSecs-fixstart<1.5
        
        
        
        
        WaitSecs(0.5)
        dont= DaqAIn(daq,Achan,Arange);
        if dont>0.1
            Screen('PutImage',Window,Instructions_struct(dontsqeeze).image);
            Screen('Flip',Window);
            WaitSecs(0.5)
            fixstart=GetSecs;
            
        else
            Screen('TextSize', Window, 70);
            DrawFormattedText(Window,'+','center','center',white);
            Screen('Flip',Window);
        end
    end
    
    
    Screen('FillRect', Window, black, Hbaserect);
    Screen('FillRect', Window, gray, targetrect);
    Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
    Screen('DrawLine', Window ,black, Hbaserect(3), Hbaserect(2) ,Hbaserect(3), Hbaserect(4) ,HrectpenW);
    Screen('Flip',Window);
    
    
    
    
    %squeez time
    
    Screen('PutImage',Window,Instructions_struct(vas_gtrdy2squeeze2).image);
    Screen(Window,'Flip');
    wait4key
    hold_start=GetSecs;
    trialstart=GetSecs;
    squeez=0;
    noRT=1;
    RTdyno=NaN;
    percent_squeez=0;
    
    while GetSecs-trialstart<squeezBruto && GetSecs-hold_start<squeez100
        
        KbQueueCreate()
        KbQueueStart();%%start listening
        KbQueueFlush();%%removes all keyboard presses
        KbName('UnifyKeyNames');
        [keyIsDown,secs,keyCode]= KbCheck;
        if keyIsDown
            inp=KbName(keyCode);
            try KEY=strcmp(inp{1},'y');
            catch
                KEY=strcmp(inp,'y');
            end
            
            if KEY
                return
            end
        end
        
        squeez= DaqAIn(daq,Achan,Arange)+abs(daqBase);
        if squeez>=0.05
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
        Screen('PutImage',Window,Instructions_struct(vas_gtrdy2squeeze).image,[wWidth/2-vas_gtrdy2squeezeSZ(2)/2,20,wWidth/2+vas_gtrdy2squeezeSZ(2)/2,20+vas_gtrdy2squeezeSZ(1)]);
        Screen('FillRect', Window, black, Hbaserect);
        Screen('FillRect', Window, gray, targetrect);
        Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
        Screen('DrawLine', Window ,black, Hbaserect(3), Hbaserect(2) ,Hbaserect(3), Hbaserect(4) ,HrectpenW);
        
        if percent_squeez>=0
            currentX=HrectStartX+ceil(percent_squeez*(baserectLong));
            Screen('FillRect', Window, white, [HrectStartX HrectStartY currentX HrectStartY+baserectShort]);
        end
        
        if percent_squeez>0.95
            if holdVec;
                holdVec=0;
                hold_start=GetSecs;
                start_percent_squeezVEC=1;
            end
        end
        
        Screen('Flip', Window);
        
    end
    
    
    %     Screen('Flip',Window);
    %     wait4key
    %     Screen('Flip',Window);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %------------ rate---------------%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if start_percent_squeezVEC
        
        noclick=1;
        ShowCursor('Hand' ,Window);
        rate_start=GetSecs;
        Screen('LineStipple', Window,0 );
        
        while noclick
            
            KbQueueCreate()
            KbQueueStart();%%start listening
            KbQueueFlush();%%removes all keyboard presses
            KbName('UnifyKeyNames');
            [keyIsDown,secs,keyCode]= KbCheck;
            if keyIsDown
                inp=KbName(keyCode);
                try KEY=strcmp(inp{1},'y');
                catch
                    KEY=strcmp(inp,'y');
                end
                
                if KEY
                    return
                end
            end
            
            
            Screen('PutImage',Window,Instructions_struct(vas_gtrdy2rate).image,[wWidth/2-vas_gtrdy2rateSZ(2)/2,20,wWidth/2+vas_gtrdy2rateSZ(2)/2,20+vas_gtrdy2rateSZ(1)]);
            
            [GetMouseclicksx,GetMouseclicksy,clicks]=GetMouse(Window);
            Screen('TextSize', Window, 40);
            
            DrawFormattedText(Window,'0',Vbaserect(3)+3,Vbaserect(1)-40,black);
            DrawFormattedText(Window,'100',Vbaserect(3)+3,Vbaserect(2)+10,black);
            Screen('FillRect', Window, black, Vbaserect);
            if GetMouseclicksx>Vbaserect(1) && GetMouseclicksx<Vbaserect(3)&&  GetMouseclicksy>Vbaserect(2) && GetMouseclicksy<Vbaserect(4)
                Screen('DrawLine', Window ,white, Vbaserect(1), GetMouseclicksy ,Vbaserect(3), GetMouseclicksy ,baserectLong*0.01);
                currentY=ceil(100-((GetMouseclicksy-Vbaserect(2))/baserectLong*100));
                DrawFormattedText(Window,num2str(currentY),Vbaserect(1)-50,GetMouseclicksy+10,black);
            end
            ShowCursor('Hand' ,Window);
            Screen('Flip',Window);
            
            if clicks(1)==1 && GetMouseclicksx>Vbaserect(1) && GetMouseclicksx<Vbaserect(3)&&  GetMouseclicksy>Vbaserect(2) && GetMouseclicksy<Vbaserect(4)
                
                noclick=0;
                RTrate=GetSecs-rate_start;
                Effort_rate=currentY;
                
                
            end
        end
        
        
    else
        Screen('PutImage',Window,Instructions_struct(no_squeeze).image);
        Screen(Window,'Flip');
        WaitSecs(1);
        RTrate=NaN;Effort_rate=NaN;
    end
    %post trial calculations
    findgoal= percent_squeezVEC>1-0.05*study100/goal & percent_squeezVEC< 1+0.05*study100/goal ;
    PwhithinTargetRange=sum(findgoal)/length(findgoal);
    winvec(2,ieffortLevels)=PwhithinTargetRange;
    alldaqVec{ieffortLevels}=daqVec;
    SdaqVec=num2str(daqVec);
    
    fprintf(fid_vas,'%d\t %d\t %d\t %d\t %d\t %d\t %s\n', ieffortLevels,goal*100, RTdyno, PwhithinTargetRange,RTrate,Effort_rate,SdaqVec); %#################
    
    
    fixstart=GetSecs;
    Screen('TextSize', Window, 70);
    
    DrawFormattedText(Window,'+','center','center',white);
    Screen('Flip',Window);
    while GetSecs-fixstart<1.5
        
        KbQueueCreate()
        KbQueueStart();%%start listening
        KbQueueFlush();%%removes all keyboard presses
        KbName('UnifyKeyNames');
        [keyIsDown,secs,keyCode]= KbCheck;
        if keyIsDown
            inp=KbName(keyCode);
            try KEY=strcmp(inp{1},'y');
            catch
                KEY=strcmp(inp,'y');
            end
            
            if KEY
                return
            end
        end
        
        
        
        WaitSecs(0.5)
        dont= DaqAIn(daq,Achan,Arange);
        if dont>0.1
            Screen('PutImage',Window,Instructions_struct(dontsqeeze).image);
            Screen('Flip',Window);
            WaitSecs(0.3)
        else
            Screen('TextSize', Window, 70);
            
            DrawFormattedText(Window,'+','center','center',white);
            Screen('Flip',Window);
        end
    end
    
end
fclose(fid_vas);
HideCursor;

percent_goal=nanmean(winvec(2,:));
save ([outputPath '/' subjectID '_BB_VAS_demo'])
%ShowCursor;
%{

    
    msg=['vas_run_' runNUMs '_image_' num2str(RAndFRACT(l)) '_offset_' num2str(GetSecs-runStart)];
    Eyelinkmsg;% ---------------------------
    
    
    

msg=['VAS_run_' runNUMs '_endtime_' num2str(GetSecs)];
Eyelinkmsg




eye_tracker_wrapup
%}
end
