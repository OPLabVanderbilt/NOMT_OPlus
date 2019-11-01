%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Learning Exemplars (VET-like) Task
%% IDEAL
%% Nov. 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [acc] = VET_0(subjno,subjini,age,sex,hand)
try
    
    %% Open Screen
    whichScreen = 0; %changed to 1 to test on laptop
    
    [w, rect] = Screen('OpenWindow', whichScreen, 255);
    xc = rect(3)/2;
    yc = rect(4)/2;
    hand = hand;
    age = age;
    sex = sex;
    category = 0; % sets category
    sum = 0;
    
    Screen(w, 'TextSize', 24);
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextStyle', 1);
    
    %% create files for saving data
    cd('data_L')
    fileName1 = ['L_' num2str(subjno) '_' subjini '_' num2str(category) '.txt'];
    dataFile1 = fopen(fileName1, 'w');
    cd('..')
    
    ListenChar(2);
    HideCursor;
    commandwindow;
    
    %% load study Screens
    studyScreen1 = imread([num2str(category) '_study1.jpg']);
    studyScreen1_texture = Screen('MakeTexture', w, studyScreen1);
    
    studyScreen2 = imread([num2str(category) '_study2.jpg']);
    studyScreen2_texture = Screen('MakeTexture', w, studyScreen2);
    
    diffview = imread('diffview_instruct.jpg');
    diffview_texture = Screen('MakeTexture', w, diffview);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Instructions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('Flip', w);
    center_text(w, 'In this task you will learn to recognize six new exemplars from a category.', 0, -100);
    center_text(w, 'First you will study the six exemplars, and then there will be a test phase.', 0, -50);
    center_text(w, 'Press the spacebar to continue.', 0, 150);
    Screen('Flip', w);
    FlushEvents('keyDown');
    responsecode = [];
    temp = 0;
    responsecode = 0;
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            responsecode = find(keyCode);
            if responsecode == KbName('space')
                break
            end
        end
    end
    while KbCheck; end
    Screen('FillRect', w, 255);
    
    Screen('Flip', w);
    center_text(w, 'In each test trial you will see 3 images: ONE of the studied images (target) + TWO distractors.', 0, -100);
    center_text(w, 'There will always be a target present, but sometimes it will be presented in visual noise.', 0, -50);
    center_text(w, 'Your task will be to select the target image from among the distractors.', 0, 0);
    center_text(w, 'Response keys will be presented below each image. Take your time, and be as ACCURATE as possible.', 0, 50);
    center_text(w, 'Press the spacebar to continue.', 0, 150);
    Screen('Flip', w);
    FlushEvents('keyDown');
    responsecode = [];
    temp = 0;
    responsecode = 0;
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            responsecode = find(keyCode);
            if responsecode == KbName('space')
                break
            end
        end
    end
    while KbCheck; end
    Screen('FillRect', w, 255);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Experimental Trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [trial testim_name  target CorrRes foil_level view noise foil1 foil2] = textread([num2str(category) '_trials.txt'], '%u %s %s %u %u %s %s %s %s');
    
    ntrials = 48;
    for i = 1: ntrials
        
        %% study Screen before trials 1 and 7
        if i == 1 || i == 7
            Screen('DrawTexture', w, studyScreen1_texture);
            Screen('Flip', w);
            while 1
                [keyIsDown,secs,keyCode]=KbCheck;
                if keyIsDown
                    responsecode=find(keyCode);
                    if responsecode==KbName('space')
                        break
                    end
                end
            end
            Screen('Flip',w);
            while KbCheck; end
        end
        
        %% study Screen before trial 25 (different view instructions)
        if i == 25
            Screen('DrawTexture', w, diffview_texture);
            Screen('Flip', w);
            while 1
                [keyIsDown,secs,keyCode]=KbCheck;
                if keyIsDown
                    responsecode=find(keyCode);
                    if responsecode==KbName('space')
                        break
                    end
                end
            end
            Screen('Flip',w);
            while KbCheck; end
            
            Screen('DrawTexture', w, studyScreen2_texture);
            Screen('Flip', w);
            while 1
                [keyIsDown,secs,keyCode]=KbCheck;
                if keyIsDown
                    responsecode=find(keyCode);
                    if responsecode==KbName('space')
                        break
                    end
                end
            end
            Screen('Flip',w);
            while KbCheck; end
        end
        
        %500 ms blank between trials
        t = Screen('Flip', w);
        
        %test Screen until response
        testim = imread(['stimuli/' num2str(category) '_Screens/' char(testim_name(i))]);
        testtexture = Screen('MakeTexture', w, testim);
        Screen('DrawTexture', w, testtexture);
        
        %display response keys on Screen
        center_text(w, 'J', 0, 150, -250);
        center_text(w, 'K', 0, 150, 0);
        center_text(w, 'L', 0, 150, 250);
        
        t = Screen('Flip', w, t+.5);
        
        FlushEvents('keyDown');
        temp = 0;
        rt = GetSecs;
        responsecode = 0;
        
        %record response time
        resp1 = KbName('j');
        resp2 = KbName('k');
        resp3 = KbName('l');
        GoOn = 0;
        keyIsDown = 0;
        while GoOn == 0;
            temp = GetSecs-rt;
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                responsecode = find(keyCode);
                if responsecode == resp1 || responsecode == resp2 || responsecode == resp3
                    keyIsDown = 0;
                    GoOn = 1;
                end
                if responsecode == KbName('q')
                    Screen('CloseAll');
                end
            end
        end
        
        rt = secs-rt;
        rt = rt*1000;
        
        %set response for output file
        if responsecode == resp1
            response = 1;
        elseif responsecode == resp2
            response = 2;
        elseif responsecode == resp3
            response = 3;
        end
        
        %set correct response for outputfile
        if response == CorrRes(i)
            GradedRes = 1;
        else
            GradedRes = 0;
        end
        
         sum = sum+GradedRes; %running count of total score
         
        fprintf(dataFile1, '%d\t%i\t%i\t%s\t%i\t%s\t%s\t%i\t%i\t%i\t%f\n', str2double(subjno), i, category, char(testim_name(i)), foil_level(i), char(view(i)), char(noise(i)), CorrRes(i), response, GradedRes, rt);
        
        Screen('Close', testtexture);
    end
    
    acc = sum/ntrials; %percent accuracy 
    
    Screen('Flip', w);
    center_text(w, 'You have finished this task!', 0);
    center_text(w, 'Press the spacebar', 0, 50);
    Screen('Flip', w);
    WaitSecs(.2);
    responsecode = [];
    temp = 0;
    responsecode = 0;
    
    % Press any key to quit the program
    FlushEvents('keyDown');
    pressKey = KbWait;
    
    ShowCursor;
    Screen('CloseAll');
    
    ListenChar;
    %Screen('CloseAll');
    
catch
    ListenChar(0);
    ShowCursor;
    Screen('CloseAll');
    rethrow(lasterror);
end
end

