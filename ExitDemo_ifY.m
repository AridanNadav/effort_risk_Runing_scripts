

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




