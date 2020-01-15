%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Learning Exemplars (VET-like) Task
% OT Beta
% Jan. 15, 2020 - Updated by: Jason Chow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NOMT_Sheinbug(subjno, experimenter, hand, dataDir)
try
    %% Experiment parameters
    Screen('Preference', 'SkipSyncTests', 1); %%%%%% TURN THIS OFF %%%%%%%
    
    keys = ['G', 'H', 'J']; % Response keys
    ITI = 0.5; % Intertrial interval
    
    %% Setup
    % Standalone startup if needed
    if ~exist('subjno', 'var') && ~exist('experimenter', 'var') && ...
            ~exist('hand', 'var')
        inputInfo = inputdlg({'Subject ID', 'Experimenter', 'L.Q.'});
        subjno = str2double(inputInfo{1});
        experimenter = inputInfo{2};
        hand = str2double(inputInfo{3});
    end
    
    % Check which data directory save to
    if ~exist('dataDir', 'var')
        dataDir = 'data';
    end
    
    % Restrict interaction
    ListenChar(2);
    HideCursor;
    commandwindow;
    RestrictKeysForKbCheck([]);
    
    % Get KbNames for keys
    resp1 = KbName(keys(1));
    resp2 = KbName(keys(2));
    resp3 = KbName(keys(3));
    
    % Data format
    dataFormat = '%f,%d,%s,%d,%s,%s,%d,%d,%d,%f,%f,%s,%s\n';
    
    %% Open Screen on max monitor index
    whichScreen = max(Screen('Screens'));
    
    % Make screen and set parameters
    [w, ~] = Screen('OpenWindow', whichScreen, 255);
    Screen(w, 'TextSize', 24);
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextStyle', 1);
    prior = Priority(MaxPriority(w));
    
    %% Create files for saving data
    % Timestamp
    timestamp = char(datetime('now', 'Format', 'MMM-dd-y--HH-mm-ss'));
    
    % Create datafile
    fileName = [dataDir '/' num2str(subjno) '_nomtShein_' timestamp '.csv'];
    dataFile = fopen(fileName, 'w');
    fprintf(dataFile, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,\n', ...
        'SbjID', 'Trial', 'TestImage', 'FoilLevel', 'View', 'Noise', ...
        'CorrRes', 'Response', 'Corr', 'RT', 'Handedness', ...
        'Experimenter', 'DateTime');
    fclose(dataFile);
    
    %% Load study Screens
    studyScreen1 = imread('Sheinbug_study1.jpg');
    studyScreen1_texture = Screen('MakeTexture', w, studyScreen1);
    
    studyScreen2 = imread('Sheinbug_study2.jpg');
    studyScreen2_texture = Screen('MakeTexture', w, studyScreen2);
    
    diffview = imread('diffview_instruct.jpg');
    diffview_texture = Screen('MakeTexture', w, diffview);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Instructions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Restrict to just spacebar for instructions
    RestrictKeysForKbCheck(KbName('space'));
    
    Screen('Flip', w);
    center_text(w, 'In this task you will learn to recognize six new exemplars from a category.', 0, -100);
    center_text(w, 'First you will study the six exemplars, and then there will be a test phase.', 0, -50);
    center_text(w, 'Press the spacebar to continue.', 0, 150);
    Screen('Flip', w); 
    KbWait([], 3); 
    
    % Clear screen briefly
    Screen('FillRect', w, 255);
    Screen('Flip', w);
    
    center_text(w, 'In each test trial you will see 3 images: ONE of the studied images (target) + TWO distractors.', 0, -100);
    center_text(w, 'There will always be a target present, but sometimes it will be presented in visual noise.', 0, -50);
    center_text(w, 'Your task will be to select the target image from among the distractors.', 0, 0);
    center_text(w, 'Response keys will be presented below each image. Take your time, and be as ACCURATE as possible.', 0, 50);
    center_text(w, 'Press the spacebar to continue.', 0, 150);
    Screen('Flip', w);
    KbWait([], 3); 
    
    % Clear screen for future flip
    Screen('FillRect', w, 255);
    
    % Free Keys for KBCheck
    RestrictKeysForKbCheck([]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Experimental Trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read in trial data
    trials = readtable('Sheinbug_trials.txt', 'Format', ...
        '%u %s %s %u %u %s %s %s %s');
    varNames = {'Trial', 'TestImgName', 'Target', 'CorrRes', ...
        'FoilLevel', 'View', 'Noise', 'Foil1', 'Foil2'};
    trials.Properties.VariableNames = varNames;
    
    % Restrict keys to response keys
    RestrictKeysForKbCheck([resp1 resp2 resp3]);
    
    for i = 1:height(trials)
        %% Study Screen before trials 1 and 7
        if i == 1 || i == 7
            % Restrict to just spacebar for instructions
            RestrictKeysForKbCheck(KbName('space'));
            
            Screen('DrawTexture', w, studyScreen1_texture);
            Screen('Flip', w);
            KbWait([], 3); 
            
            Screen('Flip',w);
            while KbCheck; end
            
            % Restrict keys to response keys
            RestrictKeysForKbCheck([resp1 resp2 resp3]);
        end
        
        %% Study Screen before trial 25 (different view instructions)
        if i == 25
            % Restrict to just spacebar for instructions
            RestrictKeysForKbCheck(KbName('space'));
            
            Screen('DrawTexture', w, diffview_texture);
            Screen('Flip', w);
            KbWait([], 3); 
            
            Screen('Flip',w);
            while KbCheck; end
            
            Screen('DrawTexture', w, studyScreen2_texture);
            Screen('Flip', w);
            KbWait([], 3); 
            
            Screen('Flip',w);
            while KbCheck; end
            
            % Restrict keys to response keys
            RestrictKeysForKbCheck([resp1 resp2 resp3]);
        end
        
        % Allow for ITI blank between trials
        t = Screen('Flip', w);
        
        % Test Screen until response
        testim = imread(['stimuli/' trials.TestImgName{1}]);
        testtexture = Screen('MakeTexture', w, testim);
        Screen('DrawTexture', w, testtexture);
        
        % Display response keys on Screen
        center_text(w, keys(1), 0, 150, -250);
        center_text(w, keys(2), 0, 150, 0);
        center_text(w, keys(3), 0, 150, 250);
        
        [~, time] = Screen('Flip', w, t + ITI);
        
        FlushEvents('keyDown');
        
        % Record response time
        keepGoing = true;
        while keepGoing
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                responsecode = find(keyCode);
                if length(responsecode) == 1 && (responsecode == resp1 || responsecode == resp2 || responsecode == resp3)
                    keepGoing = false;
                end
            end
            
            % Pause briefly
            pause(0.00005);
        end
        
        rt = (secs - time) .* 1000;
        
        % Set response for output file
        if responsecode == resp1
            response = 1;
        elseif responsecode == resp2
            response = 2;
        elseif responsecode == resp3
            response = 3;
        end
        
        % Set correct response for outputfile
        if response == trials.CorrRes(i)
            GradedRes = 1;
        else
            GradedRes = 0;
        end
        
        % Save data
        dataFile = fopen(fileName, 'a');
        % Data format: '%f,%d,%s,%d,%s,%s,%d,%d,%d,%f,%f,%s,%s\n';
        fprintf(dataFile, dataFormat, subjno, i, trials.TestImgName{i}, ...
            trials.FoilLevel(i), trials.View{i}, trials.Noise{i}, ...
            trials.CorrRes(i), response, GradedRes, rt, hand, ...
            experimenter, char(datetime));
        fclose(dataFile);
        
        Screen('Close', testtexture);
    end
    RestrictKeysForKbCheck(KbName('space'));
    
    Screen('Flip', w);
    center_text(w, 'You have finished this task!', 0);
    center_text(w, 'Press the spacebar', 0, 50);
    Screen('Flip', w);
    WaitSecs(.2);
    
    % Press any key to quit the program
    FlushEvents('keyDown');
    KbWait;
    
    % Experiment cleanup
    sca;
    ListenChar();
    ShowCursor();
    RestrictKeysForKbCheck([]);
    if exist('prior', 'var')
        Priority(prior);
    end
catch
    % Save error
    error = lasterror; %#ok<LERR>
    save(['err_', char(datetime('now', 'Format', 'MMM-dd-y--HH-mm-ss'))]); 
    
    % Experiment cleanup
    sca;
    ListenChar();
    ShowCursor();
    RestrictKeysForKbCheck([]);
    if exist('prior', 'var')
        Priority(prior);
    end
    
    % Panic!
    rethrow(error);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Aug 22. 2019 - Jason Chow
% Remove unused variables
% Reorganized code and added comments
% Flush keys at start of trial loop
% Replaced common kbWait loop with simpler KbWait([], 3)
% Remove additional KbChecks
% Abbreviate Screen('clearall') to sca
% Add error dumping
% Add priority increase
% Add max monitor screen ID
% Add debug switch
% Move input/command window constraints higher
% Add standalone startup
% Remove unnecessary input arguments
% Change data file name
% Add experimenter input
% Parameterize experiment parameters
% Move KbName conversion outside of loop
% Remove directory changing
% Change trial loading and handling to load into a table
% Change to only support one category
% Change to save after every trial
% Save data after every trial
% Remove sum
% Remove quit key
% Rewrote response polling for slightly more precision
% Only respond to single key response
% Add data directory input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
