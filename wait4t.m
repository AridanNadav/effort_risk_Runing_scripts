% escapeKey = 40;

DisableKeysForKbCheck([]); % So trigger is no longer detected
    
CenterText(Window,'Get ready, starting in a few seconds', white,0,0);
Screen(Window,'Flip'); 
    
    
  escapeKey = KbName('t');

KbQueueCreate()
KbQueueStart();%%start listening
KbQueueFlush();%%removes all keyboard presses
  
    while 1
        [keyIsDown,~,keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(escapeKey)
            break;
        end
    end
    
DisableKeysForKbCheck(KbName('t')); % So trigger is no longer detected
