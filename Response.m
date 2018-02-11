KbQueueCreate()
    KbQueueStart();%%start listening
    KbQueueFlush();%%removes all keyboard presses
    [ ~,keyCode] = KbWait();
    REsponse = KbName(keyCode);
    %Response = Response(1);
    while     ~ismember(REsponse,['y','Y','n','N'])
        KbQueueCreate()
        KbQueueStart();%%start listening
        KbQueueFlush();%%removes all keyboard presses
        [ ~,keyCode] = KbWait();
        REsponse = KbName(keyCode);
        
    end
    if ismember(REsponse,['y','Y'])
        Done = 1;
    end