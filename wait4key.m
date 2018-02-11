%
% KbQueueCreate()
% KbQueueStart();%%start listening
% KbQueueFlush();%%removes all keyboard presses
%
%
%
%
% noresp=1;
% while noresp,
%     [keyIsDown] = KbCheck; %(-1); % deviceNumber=keyboard
%     if keyIsDown && noresp,
%         noresp=0;
%     end;
% end;
%
% HideCursor;


noresp=1;

while noresp,
    KbQueueCreate()
    KbQueueStart();%%start listening
    KbQueueFlush();%%removes all keyboard presses
    [keyIsDown,~,keyCode] = KbCheck(-1);
    %try strcmp( KbName(keyCode),'space');
    if keyIsDown % && strcmp( KbName(keyCode),'space')
        noresp=0;
    end;
    %     catch
    %    noresp=1;
    %
    %     end
end;

