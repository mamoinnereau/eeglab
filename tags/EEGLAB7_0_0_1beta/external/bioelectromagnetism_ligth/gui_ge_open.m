function [mri] = gui_ge_open(mri,command,parent)

% gui_ge_open - Load & Display MRI data
% 
% Useage: [mri] = gui_ge_open(mri,[command],[parent])
% 
% mri is a structure, generated by 'mri_toolbox_defaults'
% command is either 'init' or 'load'
% parent is a handle to the gui that calls this gui, useful
% for updating the UserData field of the parent from this gui.
% The mri structure may be returned to the parent when the parent 
% handle is given.
%

% $Revision: 1.1 $ $Date: 2009-04-28 22:13:56 $

% Licence:  GNU GPL, no express or implied warranties
% History:  08/2002, Darren.Weber@flinders.edu.au
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('mri','var'),
    mri = mri_toolbox_defaults;
elseif isempty(mri),
    mri = mri_toolbox_defaults;
end

if ~exist('command','var'),
    command = 'init';
elseif isempty(command),
    command = 'init';
end

command = lower(command);

switch command,
case 'init',
    if exist('parent','var'),
        MRIOpen = INIT(mri,parent);
    else
        MRIOpen = INIT(mri,'');
    end
otherwise,
    MRIOpen = get(gcbf,'Userdata');
    set(MRIOpen.gui,'Pointer','watch');
end


switch command,
    
case 'plot',
    
    MRIOpen.mri.plot = 1;
    MRIOpen.mri = mri_open(MRIOpen.mri);
    
case 'return',
    
    MRIOpen.mri.plot = 0;
    MRIOpen.mri = mri_open(MRIOpen.mri);
    
case 'save',
    
    fprintf('\ngui_ge_open: Save As not implemented yet.\n');
    
otherwise,
    
end


% -- tidy up & return

switch command,
case 'init',
case 'cancel',
    GUI.parent = MRIOpen.parent;
    mri_updateparent(GUI);
    close gcbf;
otherwise,
    set(MRIOpen.gui,'Pointer','arrow');
    set(MRIOpen.gui,'Userdata',MRIOpen);
    
    mri = mri_updateparent(MRIOpen,0);
    
    if isequal(get(MRIOpen.handles.Bhold,'Value'),0),
        close gcbf;
        if isfield(MRIOpen,'parent'),
            parent = MRIOpen.parent.gui;
        else
            parent = [];
        end
    else
        parent = MRIOpen.gui;
    end
end


return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MRIOpen] = INIT(mri,parent)
    % GUI General Parameters
    
    GUIwidth  = 500;
    GUIheight = 120;
    
    version = '$Revision: 1.1 $';
    name = sprintf('GE File Open [v %s]\n',version(11:15));
    
    GUI = figure('Name',name,'Tag','GE_OPEN',...
                 'NumberTitle','off',...
                 'MenuBar','none','Position',[1 1 GUIwidth GUIheight]);
    movegui(GUI,'center');
    
    Font.FontName   = 'Helvetica';
    Font.FontUnits  = 'Pixels';
    Font.FontSize   = 12;
    Font.FontWeight = 'normal';
    Font.FontAngle  = 'normal';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Voltage Data Selection and Parameters
    
    G.Title_data = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
        'Position',[.01 .75 .17 .2],...
        'String','Data Type:','HorizontalAlignment','left');
    
    mri.type = 'GE';
    G.PmriType = uicontrol('Tag','PmriType','Parent',GUI,'Style','edit',...
        'Units','Normalized',Font,  ...
        'Position',[.20 .75 .25 .2],...
        'String','GE');
    
    G.Title_path = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
        'Position',[.01 .50 .17 .2],...
        'String','Path','HorizontalAlignment','left');
    G.EmriPath = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
    	'Position',[.20 .50 .58 .2], 'String',mri.path,...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'MRIOpen.mri.path = get(MRIOpen.handles.EmriPath,''String'');',...
                          'set(gcbf,''Userdata'',MRIOpen); clear MRIOpen;'));
    
    G.Title_file = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
        'Position',[.01 .25 .17 .2],...
        'String','File','HorizontalAlignment','left');
    G.EmriFile = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
    	'Position',[.20 .25 .58 .2], 'String',mri.file,...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'MRIOpen.mri.file = get(MRIOpen.handles.EmriFile,''String'');',...
                          'set(gcbf,''Userdata'',MRIOpen); clear MRIOpen;'));
    
    Font.FontWeight = 'bold';
    
    % BROWSE: Look for the data
    browsecommand = strcat('MRIOpen = get(gcbf,''Userdata'');',...
        'cd(MRIOpen.mri.path);',...
        '[file, path] = uigetfile(',...
        '{''*.MR;*.I*'', ''GE Signa 5.x/LX (*.MR,*.I*)'';', ...
        ' ''*.*'',   ''All Files (*.*)''},', ...
        '''Select first GE file in sequence (eg, E22119S1I1.MR)'');',...
        'if ~isequal(path,0), MRIOpen.mri.path = path; end;',...
        'if ~isequal(file,0), MRIOpen.mri.file = file; end;',...
        'set(MRIOpen.handles.EmriPath,''String'',MRIOpen.mri.path);',...
        'set(MRIOpen.handles.EmriFile,''String'',MRIOpen.mri.file);',...
        'set(gcbf,''Userdata'',MRIOpen); clear MRIOpen file path;');
    G.BmriFile = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized',Font, ...
        'Position',[.01 .01 .17 .2], 'String','BROWSE',...
        'BackgroundColor',[0.8 0.8 0.0],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback', browsecommand );
    
    % PLOT: Load & plot the data!
    G.Bplot = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
        'Position',[.20 .01 .18 .2],...
        'String','PLOT','BusyAction','queue',...
        'TooltipString','Plot the MRI data and return p struct.',...
        'BackgroundColor',[0.0 0.5 0.0],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'mri = gui_ge_open(MRIOpen.mri,''plot'');',...
                          'clear MRIOpen;'));

    % Save As
	G.Bsave = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
        'Position',[.40 .01 .18 .2],'HorizontalAlignment', 'center',...
        'String','SAVE AS','TooltipString','MRI File Conversion Tool (not implemented yet)',...
        'BusyAction','queue',...
        'Visible','on',...
        'BackgroundColor',[0.0 0.0 0.75],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'mri = gui_ge_open(MRIOpen.mri,''save'');',...
                          'clear MRIOpen;'));

    % Quit, return file parameters
    G.Breturn = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
        'Position',[.60 .01 .18 .2],...
        'String','RETURN','BusyAction','queue',...
        'TooltipString','Return p struct to workspace and parent GUI.',...
        'BackgroundColor',[0.75 0.0 0.0],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'mri = gui_ge_open(MRIOpen.mri,''return'');',...
                          'clear MRIOpen;'));
    
    % Cancel
    G.Bcancel = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
        'Position',[.80 .01 .18 .2],...
        'String','CANCEL','BusyAction','queue',...
        'TooltipString','Close, do not return parameters.',...
        'BackgroundColor',[0.75 0.0 0.0],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback',strcat('MRIOpen = get(gcbf,''Userdata'');',...
                          'mri = gui_ge_open(MRIOpen.mri,''cancel'');',...
                          'clear MRIOpen;'));
    
    
	% Help
	G.Bhelp = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
        'Position',[.80 .25 .18 .2],'String','Help','BusyAction','queue',...
        'BackgroundColor',[1 1 0],...
        'ForegroundColor',[0 0 0], 'HorizontalAlignment', 'center',...
        'Callback','doc mri_toolbox;');
    
    % Hold GUI Open checkbox
	G.Bhold = uicontrol('Parent',GUI,'Style','checkbox','Units','Normalized', Font, ...
        'Position',[.80 .50 .18 .2],'String','Hold GUI','BusyAction','queue',...
        'TooltipString','MRI File Load GUI remains open after ''Plot'' or ''Return'' commands.',...
        'Value',mri.hold,'HorizontalAlignment', 'center');
    
    
    % Store userdata
    if exist('parent','var'), MRIOpen.parent.gui = parent; end
    MRIOpen.gui = GUI;          
    MRIOpen.handles = G;
    MRIOpen.mri = mri;
    set(GUI,'Userdata',MRIOpen);
    set(GUI,'HandleVisibility','callback');
    
return
