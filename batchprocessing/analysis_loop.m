function analysis_loop(CBF)

% List all mat files in the folder
stk_files = dir([CBF.sourceP,'*.mat']);


%% Run through all recordings 

progress()
for iRec = 1:length(stk_files)
    progress(iRec,length(stk_files),1)
      
    % load the recording
    [~, CBF.name, ~] = fileparts(stk_files(iRec).name); % Give a names
    var = who(matfile(fullfile(CBF.sourceP,CBF.name)));
    data = double(load(fullfile(CBF.sourceP,CBF.name),var{1}).(var{1}));

    % Set some metadata
    CBF.x = size(data,1); 
    CBF.y = size(data,2); 
    
    % Retrieve the frame rate of acquisition
    try
        [~,value]=import_json([CBF.sourceP, erase(CBF.name,CBF.metadata_ID), '.json']);
        CBF.Fs = value(8); % Frequency of acquisition
    catch
        sprintf('there is probably no associated .json metadata file')
    end

   % Define the target path
    CBF.targetP = fullfile(CBF.folderP, CBF.name, filesep);
    [~, ~] = mkdir(CBF.targetP);
    
    
    Master_analysis_for_loop
    
end