% callexp

function []=callexp(Window,Instructions_struct)
instrct_callexp = find(strcmp({Instructions_struct.name}, ['callexp' '.jpg'])==1);

Screen('PutImage',Window,Instructions_struct(instrct_callexp).image);

Screen(Window,'Flip');
escapeKey = KbName('y');

KbQueueCreate()
KbQueueStart();%%start listening
KbQueueFlush();%%removes all keyboard presses

while 1
    
    [keyIsDown,~,keyCode] = KbCheck(-1);
    if keyIsDown && keyCode(escapeKey)
        break;
    end
end

% DisableKeysForKbCheck(KbName('y')); % So trigger is no longer detected
end