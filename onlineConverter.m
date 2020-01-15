%{
Converts this task to the online format encoding the experiment information
into the image titles.

Originally built for OT_Beta.
Jan13, 2020 - Jason Chow
%}
clear all;

%% Generation parameters
% Experiment parameter
ITI = 500; % Intertrial interval

% Image parameters
imgSouce = 'stimuli';
study1 = 'onlineAssets/online_study1.png';
study2 = 'onlineAssets/online_study2.png';
diffInstruct = 'onlineAssets/online_diffview_instruct.png';

%% Check folder and move convert instructions
if ~exist('onlineExperiment', 'dir')
    mkdir('onlineExperiment');
end

% Convert instructions
inst = dir('onlineAssets/trial*');
inst = {inst.name};

for i = 1:numel(inst)
    fileName = inst{i};
    img = imread(['onlineAssets/' fileName]);
    fileName = strrep(fileName, '.png', '.jpg');
    imwrite(img, ['onlineExperiment/' fileName]);
end 

%% Assemble practice trials
% Determine trial start
files = dir('onlineExperiment/trial*');
files = sort({files.name});
trialNum = strsplit(files{numel(files)}, '_');
trialNum = str2double(trialNum{2});

% Read in trial data
trials = readtable('Sheinbug_trials.txt', 'Format', ...
    '%u %s %s %u %u %s %s %s %s');
varNames = {'Trial', 'TestImgName', 'Target', 'CorrRes', 'FoilLevel', ...
    'View', 'Noise', 'Foil1', 'Foil2'};
trials.Properties.VariableNames = varNames;

block = 1;
for i = 1:height(trials)
    if i == 1 || i == 7 % Study screen
        trialNum = trialNum + 1;
        img = imread(study1);
        imgName = ['trial_' num2str(trialNum) '_block-' block ...
            '_sections-1_clickable-true_isi-250.jpg'];
        imwrite(img, ['onlineExperiment/' imgName]);
    elseif i == 25 % Different view instruction screen
        trialNum = trialNum + 1;
        block = block + 1;
        img = imread(diffInstruct);
        imgName = ['trial_' num2str(trialNum) '_block-' block ...
            '_sections-1_clickable-true_isi-250.jpg'];
        imwrite(img, ['onlineExperiment/' imgName]);
        
        trialNum = trialNum + 1;
        img = imread(study2);
        imgName = ['trial_' num2str(trialNum) '_block-' block ...
            '_sections-1_clickable-true_isi-250.jpg'];
        imwrite(img, ['onlineExperiment/' imgName]);
    end
    
    trialNum = trialNum + 1;
    img = imread(['stimuli/' trials.TestImgName{i}]);
    imgName = ['trial_' num2str(trialNum) '_block-' block ...
        '_sections-3_clickable-true_isi-' num2str(ITI) '.jpg'];
    imwrite(img, ['onlineExperiment/' imgName]);
end


%% Package images into zips for upload with workaround
allTrials = dir('onlineExperiment/trial*');
allTrials = {allTrials.name};
packs = ceil(numel(allTrials)/250);

% Zip together sets of images for upload
for i = 1:packs
    if i == packs % Last pack
        zip(['onlineSheinNOMT' num2str(i) '.zip'], ...
            allTrials((((i-1)*250)+1):numel(allTrials)),...
            'onlineExperiment')
    else
        zip(['onlineSheinNOMT' num2str(i) '.zip'], ...
            allTrials((((i-1)*250)+1):i*250), 'onlineExperiment')
    end
end
