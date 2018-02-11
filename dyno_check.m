function [SR] = dyno_check()

%% this checks to see if the dynomometer is working, plots live input

try [daq]=DaqFind;
catch
    daq=2;
end
squeeztime=2;
Achan = 8; Arange = 1;
% Calibrate max and min values
CalibMsg = {'Relax....','SQUEEZE as hard as you can!'};
CurrcMsg = CalibMsg{1};
disp(CurrcMsg);

counter = 1;
CalOnTime = GetSecs;
while (GetSecs - CalOnTime) <= squeeztime
    voltagecalibration(counter) = DaqAIn(daq,Achan,Arange);
    % if you get an error it might be due to wrong daq number ->restart matlab
    counter = counter + 1;
end

Calibration(1) = mean(voltagecalibration);

MinCal = Calibration(1);

SR=length(voltagecalibration)/squeeztime;

KbQueueCreate()
KbQueueStart();%%start listening
KbQueueFlush();%%removes all keyboard presses
dynocheck_done=0;
  escapeKey = KbName('y');

while ~dynocheck_done
    voltage = DaqAIn(daq,Achan,Arange)-MinCal;
    if voltage<0.001
        voltage=0
    else voltage
    end
    
    [keyIsDown]= KbQueueCheck;
    
    if keyIsDown %&& keyCode(escapeKey)
        dynocheck_done=1;
    end
    WaitSecs(0.3);
end




end



