%% Disc: Apply ICA on data trials (segmented data structure)
%% Scripted by: Amit Jaiswal @MEGIN (Elekta Oy), Helsinki, Finland
%%
    data_orig = data; % Copy data to use later 

    % Downsample Data
    cfg = []; 
    cfg.resamplefs = 250; % hdr.Fs/4
    cfg.feedback   = 'gui';
    cfg.detrend    = 'no'; 
    data = ft_resampledata(cfg, data_orig);

    % Run ICA on downsampled data
    cfg        = [];
    cfg.method = 'fastica';
    comp       = ft_componentanalysis(cfg, data);

    % Visualize Components
    cfg = []; 
    cfg.viewmode = 'component'; 
    cfg.layout = 'neuromag306all.lay';
    ft_databrowser(cfg, comp)

    % Decompose the original data 
    cfg           = [];
    cfg.topolabel = comp.topolabel;
    cfg.unmixing  = comp.unmixing;
    comp_orig     = ft_componentanalysis(cfg, data_orig);
    
    % Reject components from original data and reconstruct the cleaned data
    rejcomp = input('List the components to remove (in the form [1 2 3]).. \n');
    cfg           = [];
    cfg.component = rejcomp; %these are the components to be removed
    data_clean    = ft_rejectcomponent(cfg, comp_orig, data_orig);

    % Save the clean data
    save([data_path mfname '_icaed_data_clean.mat'],'data_clean','-v7.3')
    
%  Display cleaned data
    cfg            = [];
    cfg.channel    = megchan;
    %cfg.channel = 'MEGGRAD';
    %cfg.channel = 'MEGMAG';
    cfg.viewmode   = 'butterfly';
    ft_databrowser(cfg, data_clean);
