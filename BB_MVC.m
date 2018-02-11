function [study100,daqBase]=BB_MVC(subjectID,Window,Instructions_struct,SR,outputPath)
% grip calibration- get subject's MVC by avarege of 3 sqeezes

%%pre run

%durations
CalibDur = 4;
sustainTime=3;

% daq setup
try [daq]=DaqFind;
catch
    daq=2;
end
Achan = 8; Arange = 1;

% Show Instructions
index = find(strcmp({Instructions_struct.name}, ['calibration' '.jpg'])==1);
Screen('PutImage',Window,Instructions_struct(index).image);
Screen(Window,'Flip');
WaitSecs(0.5);

wait4key

%% squeeze time
CalibDone = 0;
while ~CalibDone
    
    vcal=cell(4,1);
    
    % first relax baseline
    OK_relax = 0;
    while ~OK_relax
        
        ctr1 = 1;
        index = find(strcmp({Instructions_struct.name}, ['dont_squeeze' '.jpg'])==1);
        Screen('PutImage',Window,Instructions_struct(index).image);
        Screen(Window,'Flip');        
        
        CalOnTime = GetSecs; % Get the current cloack's seconds.
        
        while (GetSecs - CalOnTime) <= CalibDur
            
            % Creates a vector containing the voltage at each sumple -
            % According to a prefixed sumpling rate.
            measure1(1,ctr1) = DaqAIn(daq,Achan,Arange);
            measure1(2,ctr1)=GetSecs - CalOnTime;
            ctr1 = ctr1 + 1;
            vcal{1}=measure1;
        end
        % To make sure the subject doesnt squeeze during the relax phase.
        
        
        % if max(measure1)>=1.65
        if max(measure1)>=0.2
            index = find(strcmp({Instructions_struct.name}, ['recalib' '.jpg'])==1);
Screen('PutImage',Window,Instructions_struct(index).image);
            Screen(Window,'Flip');
            WaitSecs(2)
        else OK_relax=1;
        end
    end
    
    
    for i=2:4
        index = find(strcmp({Instructions_struct.name}, ['squeeze' '.jpg'])==1);
Screen('PutImage',Window,Instructions_struct(index).image);
        Screen(Window,'Flip');
        % CurrMsg = CalibMsg{2};
        %  DrawFormattedText(Window,CurrMsg,'center','center',CalibColor{2});
        
        ctr = 1;
        
        CalOnTime = GetSecs; % Get the current clock's seconds.
        measure=[];
        while (GetSecs - CalOnTime) <= CalibDur
            
            % Creates a vector containing the voltage at each sumple -
            % According to a prefixed sumpling rate.
            measure(1,ctr) = DaqAIn(daq,Achan,Arange);
            measure(2,ctr)=GetSecs - CalOnTime;
            ctr = ctr + 1;
            vcal{i}=measure;
        end
        
        CalOnTime = GetSecs; % Get the current cloack's seconds.
                index = find(strcmp({Instructions_struct.name}, ['dont_squeeze' '.jpg'])==1);
Screen('PutImage',Window,Instructions_struct(index).image);
        Screen(Window,'Flip');
        while (GetSecs - CalOnTime) <= CalibDur
        end
        
    end
    
    Screen('Flip',Window);
    
    
    %% calculate largest sustained v over 3 secs
    %     for delta=1:length(vcal{2})-1
    %     SR(delta)=measure(2,delta+1)-measure(2,delta);
    %     end
    
    %     mSR=mean(SR);
    endvec=sustainTime*SR    ;
    maxcals=zeros(3,1);
    
    for trys=2:4
        maxcal=0;
        squeezVEC=vcal{trys};
        for imax=1: (length(squeezVEC(1,:))-endvec)
            currentMAX=min(squeezVEC(1,imax:ceil(imax+endvec)));
            if currentMAX>maxcal
                maxcal=currentMAX;
            end
        end
        
    maxcals(trys-1)=maxcal;   
    end
    
    MaxCal=mean (maxcals);
    MinCal=(vcal{1,1});
    mxMinCal = max(MinCal(1,:));
    
    daqBase=min(MinCal(1,:));
    
    % fix num2str(vcal{2:end});
    
    % SelfPower is the max grip of the subject minus the noise.
    SelfPower=(MaxCal-mxMinCal);
    mvc2_100=0.9;% %experiment's MVC of real MVC
study100 = SelfPower*mvc2_100;% experiment's MVC
    % ScaleFactor divides the dynamic part of the screen to subject's grip
    % range units.
    % ! ScaleFactor =ActiveRange/SelfPower;
    
    %     fid4 = fopen([outputPath '/' subjectID '_grip_cal' timestamp '.txt'],'a'); %#################
    %     fprintf(fid4,'Min\t Max_Vec\t max\t Self_Power\n'); %#################
    %     fprintf(fid4,'%d\t %s\t %d\t %d\n', MinCal, max_vec, MaxCal, SelfPower); %#################
    %     fclose(fid4); %#################
    
    CalibOutMsg = ['Max grip: ' num2str(SelfPower)];
    %     DrawFormattedText(Window,CalibOutMsg,'center','center',TextColor);
    %     Screen('Flip',Window);
    %     %    FlushEvents; %#####
    %     %    KbQueueFlush;
    %     %    KbQueueStart;
    %     % Waits for keyboard input.
    %     wait4key
    
    DrawFormattedText(Window,CalibOutMsg,'center','center',[255 255 255]);
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
    if ismember(Response,['y','Y'])
        CalibDone = 1;
    end
    
    Screen('Flip',Window);
    
    
end
Screen('Flip',Window);
save ([outputPath '/' subjectID '_calib_parameters'])

end
