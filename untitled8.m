
Screen('LineStipple', Window,1,1,[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0] );
Screen('TextSize', Window, 30);
Sgoal=0.5;
RgoalH=0.75;
RgoalL=0.25;
        DrawFormattedText(Window,'+','center','center',[255 255 255]);


Screen('FillRect', Window, black, baserectR);
Screen('FrameRect', Window, white, choiceRectR, HrectpenW);
Screen('FillRect', Window, red, [ baserectR(1), baserectR(2)+baserectLong-(baserectLong*Sgoal)-five_percent , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*Sgoal)+five_percent]);
Screen('DrawLine', Window ,black, baserectR(1), baserectR(2)+baserectLong-(baserectLong*Sgoal) , baserectR(3) ,baserectR(2)+baserectLong-(baserectLong*Sgoal),HrectpenW);
DrawFormattedText(Window,num2str(Sgoal*100),baserectR(1)-50,baserectR(2)+baserectLong-(baserectLong*Sgoal)+10,white);


Screen('FillRect', Window, black, baserectL);

Screen('FillRect', Window, red, [ baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalH)-five_percent , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalH)+five_percent]);
Screen('DrawLine', Window ,black, baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalH) , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalH),HrectpenW);
DrawFormattedText(Window,num2str(RgoalH*100),baserectL(1)-50,baserectL(2)+baserectLong-(baserectLong*RgoalH)+10,white);

Screen('FillRect', Window, red, [ baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalL)-five_percent , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalL)+five_percent]);
Screen('DrawLine', Window ,black, baserectL(1), baserectL(2)+baserectLong-(baserectLong*RgoalL) , baserectL(3) ,baserectL(2)+baserectLong-(baserectLong*RgoalL),HrectpenW);
DrawFormattedText(Window,num2str(RgoalL*100),baserectL(1)-50,baserectL(2)+baserectLong-(baserectLong*RgoalL)+10,white);

Screen(Window,'Flip');


imageArray=Screen('GetImage', Window);
imwrite(imageArray, 'test.jpg')