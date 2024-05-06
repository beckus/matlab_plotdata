function [ax,fig,result] = plotdata3d( varargin )
% TODO: add an option to do a clf
% TODO: option for livescripts to do clf at beginning and skip figsize
%   How to do this elegantly?
%   Should I add an option to do "configs" with different defaults?
%   i.e. you would pass in 'Config','Livescript' or 'Config','Default' or 'Normal'
%   See https://www.mathworks.com/matlabcentral/answers/321066-plotting-from-a-loop-in-a-live-script-in-matlab-2016b
%     Maybe need to see purest way to handle figures in livescript

% PLOTDATA3D Generate 3D plot - Version 0.1
%   PLOTDATA3D(x,y,Z) plots the data in Z with axis vectors x and y.
%   If x or y are [], then numbers will be auto-generated.
%
%   PLOTDATA3D(x,y,Z, xlab,ylab, 'PropertyName',PropertyValue,...)
%   Uses xlab and ylab for the axis labels. Sets
%   the value of the specified property. Multiple property values can be set
%   with a single statement. See below for a list of properties.
%
%   PLOTDATA3D(FIG,...) plots into the figure with handle FIG.
%
%   PLOTDATA3D(AX,...) plots into the axes with handle AX.
%
%   By default, if you pass in a figure/axis handle, focus will be put
%   on the figure. Likewise, if you specify the "FigNum" parameter, and the
%   figure already exists, focus will also be put on the figure.
%   If in these situations you do NOT want focus on the figure,set
%   FigFocus=false. This is useful if, for example, you
%   are repeatedly updating figures in a loop and you want the figures to
%   remain in the background. This way, you can do other tasks on your
%   computer without figures popping up and interrupting your work.
%
%   Return values:
%     ax     Axis used for plot
%     fig    Figure used for plot
%     result Return value of the plot command
%
%
%   NAME/VALUE PAIRS
%   Any extra parameters not defined here are passed into the plot function.
%   Properties are not case sensitive
%
%   - Title
%     Sets plot title
%
%   - WindowTitle
%     Sets title on window (useful if you want to label the figure, but
%     don't want to include a title in the plot itself).
%
%   - PlotType
%     Either imagesc, surg, or mesh. Defaults to imagesc.
%
%   - FontName, FontSize
%     Set plot font. Specify [] to keep default font.
%     Defaults to Times New Roman 12.
%
%   - FigSize
%     Set figure size. By default, figure size is only set when a new
%     figure is created (and is left as-is if the figure already exists).
%     The default size is [375, 280].
%
%     The FigSizeForce parameter allows you to control when the
%     figure size is set. The functionality based on the values of
%     FigSize and FigSizeForce is as follows:
%  
%       FigSize   FigSizeForce    Action
%       =======   =============   =======================
%       []        N/A             Never resize the figure (when a new
%                                 figure is created, it is left at the
%                                 default size used by Matlab).
%       [x,y]     false           When creating a new figure, set its
%                                 size to [x,y]. But, if the figure already
%                                 exists, do not resize it.
%                                 (if FigSize is not specified, default
%                                  size is used).
%       [x,y]     true            Always set figure size to [x,y], even
%                                 if figure already exists.
%                                 (if FigSize is not specified, default
%                                  size is used).
%
%   - XUnits, YUnits
%     Set units of X or Y axes. also prints the unit in labels in
%     parameters. XLim/YLim are specified in terms of these units.
%     e.g. if XUnit is "mm", then XLim is with respect to milimeters.
%     Valid values:
%       nm   nanometers
%       um   micrometers
%       mm   millimeters
%       cm   centimeters
%       m    meters
%       mm-1 inverse nanometers
%       um-1 inverse micrometers
%
%   - XLim, YLim, ZLim, CAxis
%     Set X, Y, Z, or colorbar (C) limits [lower,upper].
%     If -inf is used for the lower limit, the miminum
%     value of the vector/data is used. Likewise for the upper bound if inf
%     is used. If inf is used instead of vector, this is equivalent to
%     using [-inf,inf].
%
%   - XYLim
%     Set both X and Y limits to same value.
%
%   - Normalize
%     Normalize Z data.
%
%   - Box
%     Enables or disables box around plot
%
%   - XTicks, YTicks
%
%   - TickDir
%     Sets tick mark direct. Can be in, out, or both (i.e. centered).
%     If not specified, or set to [], default Matlab setting is used.
%
%   - TitleInterpreter
%     By default, title is treated as tex code - for example underscores
%     indicate a subscript. To override, set this to one of the following
%     values: tex, latex, none
%
%   - FigNum
%     Use the specified figure number. Creates the figure if it does not
%     exist, or uses existing figure if it does exist.
%
%   - FigFocus
%     Flag to force focus onto figure (defaults to true)
%
%   - DownSample
%     If using surf or mesh the data is downsampled if it gets
%     too large. This parameter gives the maximum number of datapoints
%     allowed. Set this to [] to disable downsampling. Defaults to 1000.
%
%   - Colorbar
%     Flag to enable/disable colorbar. Default is to show colorbar.
%
%   - Colormap
%     Set colormap. If not specified, default Matlab colormap is used.
%
%   - DiscreteColormap
%     Use a discrete color map, which has a different color for each
%     integer (starting at zero). Set DiscreteColormap to the desired colormap.
%     If DiscreteColormap is set to true or 1,
%     then a default colormap will be used, which is the nested
%     default_discretecolormap function at the end of this file.
%     If DiscreteColormap is set to false or 0, then this feature will be
%     disabled.
%
%   - ZLabel
%     Also sets a label on the Z axis (for surf and mesh plots) as well as
%     on the color bar. (the text on the colorbar needs work...).
%
%   - SaveFig, SaveImage
%     Save figure or image using specified file names.
%
%   - XDir,YDir
%     Defaults to "normal"
%
%   - View
%     For surf and mesh commands.
%
%   - EdgeColor
%     For surf or mesh commands. For surf, this defaults to 'none' if
%     not specified.
%
%   - Drawnow
%     Indicates whether the drawnow command should be called after
%     plotting. Defaults to true. If set to false, and the SaveFig or
%     SaveImage commands are used, the drawnow command will still be called
%     before saving to avoid glitches.
%
%   - DrawnowLimitrate
%     Indicates whether or not the "limitrate" option should be passed
%     to the drawnow command. Defaults to false.
%
%   - FigHandle,AxesHandle
%     The figure or axis to plot to. Using these parameters is equivalent
%     to passing the handle in as the first argument.
%


    % Process the arguments
    argidx = 1;
    currarg = varargin{argidx};

    % Make sure the graphics argument is valid if specified.
    % We need to do this before calling get(currarg,'type').
    if (isa(currarg,'matlab.ui.Figure') || ...
        isa(currarg,'matlab.graphics.axis.Axes')) && ...
       ~isvalid(currarg)
        error('Graphics object has been deleted');
    end   

    % Handle first argument is a graphics object
    if ~isscalar(currarg) || ~isgraphics(currarg)
        fig = [];
        ax = [];
    elseif strcmp(get(currarg,'type'),'axes')
        fig = [];
        ax = currarg;
        argidx = argidx + 1;
    elseif strcmp(get(currarg,'type'),'figure')
        fig = currarg;
        ax = [];
        argidx = argidx + 1;
    else
        error('Illegal first argument');
    end
    
    x = varargin{argidx};
    y = varargin{argidx+1};
    z = varargin{argidx+2};
    parameters = varargin((argidx+3):end);

    
    % Find the configuration parameter. We need to do this before we
    % parse so that we know which defaults to use.
    config = 'Default';
    for ii = 3:2:length(parameters)
        if strcmpi(parameters{ii},'Config')
            config = parameters{ii+1};
        end
    end

    % Default values
    default_plottype = 'imagesc';
    default_FontName = 'Times New Roman';
    default_FontSize = 12;
    default_TitleInterpreter = [];
    default_ColorBar = true;
    default_ColorMap = [];
    default_YDir = 'normal';
    default_downsample = 1000;
    default_SurfEdgeColor = 'none';
    default_View = [];
    default_FigFocus = true;

    if strcmpi(config,'Default')
        default_FigSize = [375, 280];
        %default_ClfAfter = false;
    elseif strcmpi(config,'LiveScript')
        default_FigSize = [];
        %default_ClfAfter = true;
    elseif strcmpi(config,'LS')
        default_FigSize = [];
    end
        
    
    p = inputParser;
    p.KeepUnmatched = true;
    addOptional(p,'x_label','',@(x) 1); 
    addOptional(p,'y_label','',@(x) 1); 
    addParameter(p,'Title','');
    addParameter(p,'WindowTitle','');
    addParameter(p,'PlotType',default_plottype);
    addParameter(p,'Colorbar',default_ColorBar);
    addParameter(p,'Colormap',default_ColorMap);
    addParameter(p,'DiscreteColormap',[]);
    addParameter(p,'FontName',default_FontName);
    addParameter(p,'FontSize',default_FontSize);
    addParameter(p,'FigSize',default_FigSize);
    addParameter(p,'FigSizeForce',[]);
    addParameter(p,'CAxis',[]);
    addParameter(p,'XUnits',[]);
    addParameter(p,'YUnits',[]);
    addParameter(p,'XLim',[]);
    addParameter(p,'YLim',[]);
    addParameter(p,'XYLim',[]);
    addParameter(p,'ZLim',[]);
    addParameter(p,'Normalize',0);
    addParameter(p,'Box',[]);
    addParameter(p,'XTicks',[]);
    addParameter(p,'YTicks',[]);
    addParameter(p,'TickDir',[]);
    addParameter(p,'TitleInterpreter',default_TitleInterpreter);
    addParameter(p,'FigNum',[]);
    addParameter(p,'FigFocus', default_FigFocus);
    addParameter(p,'DownSample',default_downsample);
    addParameter(p,'ZLabel',[]);
    addParameter(p,'SaveFig', []);
    addParameter(p,'SaveImage', []);
    addParameter(p,'XDir', 'normal');
    addParameter(p,'YDir', default_YDir);
    addParameter(p,'View', default_View);
    addParameter(p,'Drawnow', true);
    addParameter(p,'DrawnowLimitrate', false);
    addParameter(p,'FigHandle', []);
    addParameter(p,'AxesHandle', []);
    addParameter(p,'Config', []); % Dummy - we don't use this
    %addParameter(p,'ClfAfter', default_ClfAfter); % for livescript: this seems to trigger the figure to be put into the livescript
    parse(p,parameters{:});
    
    Colormap = p.Results.Colormap;
    DiscreteColormap = p.Results.DiscreteColormap;
    
    if ~isempty(DiscreteColormap)
        % If user specified a single value, then assume it is a truth value
        % (0,1,true,false) indicating whether or not the user wants a
        % discrete colormap, and use the default
        if numel(DiscreteColormap) == 1
            if DiscreteColormap
                DiscreteColormap = default_discretecolormap();
            else
                % If false, then clear out the colormap. In the remaining code,
                % all we have to check is for emptiness.
                DiscreteColormap = [];
            end
        end
        % Otherwise, assume that the user passed in the actual discrete
        % color map and leave as-is.
    end

    if isempty(fig)
        fig = p.Results.FigHandle;
    end
    if isempty(ax)
        ax = p.Results.AxesHandle;
    end
    
    x_label = p.Results.x_label;
    y_label = p.Results.y_label;
    
    plotfuncargs = p.Unmatched;

    
    % Figure out how to handle the figure / axes
    newfigurecreated = false;
    fig_has_focus = false;
    if isempty(fig) && isempty(ax)
        if isempty(p.Results.FigNum)
            fig = figure;
            %clf(fig)
            newfigurecreated = true;
            fig_has_focus = true;
        else
            % Note that if fig is passed as first parameter, and
            % FigNum is specified, FigNum takes precedence.
            fig = findall(0, 'Type','figure', 'Number',p.Results.FigNum);
            if isempty(fig)
                fig = figure(p.Results.FigNum);
                newfigurecreated = true;
                fig_has_focus = true;
            end
        end
    end
    
    if isempty(fig) && ~isempty(ax)
        fig = ancestor(ax,'figure');
    elseif ~isempty(fig) && isempty(ax)
        % Many of the commands require an axis handle. If the user did not
        % give us one, find an existing axis or create a new one.
        allaxes = findall(fig, 'type', 'axes');
        if isempty(allaxes)
            ax = axes(fig);
        elseif iscell(allaxes)
            error('Multiple axes exist in figure');
        else
            ax = allaxes;
        end
    end

    % If user did not specify a true/false value for FigSizeForce, set it
    % depending on whether a new figure was created.
    FigSizeForce = p.Results.FigSizeForce;
    if isempty(FigSizeForce)
        FigSizeForce = newfigurecreated;
    end
    
    if ~isempty(p.Results.FigSize) && FigSizeForce
        pos = get(fig, 'Position');
        sizex = p.Results.FigSize(1);
        sizey = p.Results.FigSize(2);
        set(fig, 'Position', [pos(1), pos(2)-(sizey-pos(4)), sizex, sizey]);
    end
    
    windowtitle = buildstr(p.Results.WindowTitle);
    if ~isempty(windowtitle)
        set(fig, 'name',windowtitle);
    end

    if p.Results.FigFocus && ~fig_has_focus
        figure(fig);
    end
    

    
    % If no axis vectors are gieven, generate them
    if isempty(x)
        x = 1:size(z,2);
    end
    if isempty(y)
        y = 1:size(z,1);
    end
    
    %{
    if any(strcmp(p.Results.PlotType, {'surf', 'mesh'})) && p.Results.DownSample
        [ xdown, ydown, zdown ] = downsample_grid( x, y, z, default_downsample_N, default_downsample_N );
    else
        xdown = x;
        ydown = y;
        zdown = z;
    end
    %}

    % The data should be real - if not, just take the real part
    x = real(x);
    y = real(y);
    z = real(z);
    % TODO: Add warning if has complex values?
    
    % Set scaling based on the units
    if isempty(p.Results.XUnits)
        x_scale = 1;
    else
        [x_scale,x_dispname] = get_unit_scale(p.Results.XUnits);
        x_label = [x_label ' (' x_dispname ')'];
    end
    
    if isempty(p.Results.YUnits)
        y_scale = 1;
    else
        [y_scale,y_dispname] = get_unit_scale(p.Results.YUnits);
        y_label = [y_label ' (' y_dispname ')'];
    end
    
    % Decide which function to call based on plot type
    switch p.Results.PlotType
        case 'surf'
            plot_func = @plot_surf;
        case 'mesh'
            plot_func = @plot_mesh;
        case 'imagesc'
            plot_func = @plot_imagesc;
        otherwise
            error('Invalid plot type');
    end
 
    % Perform normalization
    if p.Results.Normalize
        z = double(z) / max(max(double(z)));
    end

    % Do the plotting
    result = plot_func(ax, x*x_scale, y*y_scale, z);

    % Set various display properties
    figtitle =  buildstr(p.Results.Title);
    if ~isempty(figtitle)
        h_title = title(ax, figtitle);
        if ~isempty(p.Results.TitleInterpreter)
            set(h_title, 'Interpreter', p.Results.TitleInterpreter)
        end
    end
    
    xlabel(ax, x_label);
    ylabel(ax, y_label);
    
    if ~isempty(p.Results.ZLabel)
        zlabel(ax, p.Results.ZLabel);
    end

    if p.Results.Colorbar
        hcb = colorbar(ax);
        if ~isempty(p.Results.ZLabel)
            ylabel(hcb, p.Results.ZLabel, 'fontweight','bold');
        end
    end
    
    if ~isempty(DiscreteColormap)
        % We need to force the caxis scale for the discrete color map to work
        % properly.
        caxis(ax,[0,size(DiscreteColormap,1)]);
    elseif ~isempty(p.Results.CAxis)
        climits = p.Results.CAxis;
        if isinf(climits)
            climits = [-inf inf];
        end
        
        if climits(2) > climits(1)
            caxis(ax, climits);
        end
    end

    % Note that XYLim takes prescedence over XLim and YLim.
    if ~isempty(p.Results.XYLim)
        xlimits = p.Results.XYLim;
        ylimits = p.Results.XYLim;
    else
        xlimits = p.Results.XLim;
        ylimits = p.Results.YLim;
    end
    
    if ~isempty(xlimits)
        if isinf(xlimits)
            xlimits = [-inf inf];
        end
    	xlim(ax, xlimits);
    end

    if ~isempty(ylimits)
        if isinf(ylimits)
            ylimits = [-inf inf];
        end
    	ylim(ax, ylimits);
    end

    if ~isempty(p.Results.ZLim)
        zlimits = p.Results.ZLim;
        if isinf(zlimits)
            zlimits = [-inf inf];
        end
    	zlim(ax, zlimits);
    end
    
    if ~isempty(p.Results.FontName)
        set(ax,'FontName', p.Results.FontName);
    end
    
    if ~isempty(p.Results.FontSize)
        set(ax,'FontSize', p.Results.FontSize);
    end
    
    if isempty(p.Results.Box)
    elseif p.Results.Box
        box(ax, 'on');
    else
        box(ax, 'off');
    end
    
    if ~isempty(p.Results.TickDir)
        set(ax, 'TickDir', p.Results.TickDir);
    end

    if ~isempty(DiscreteColormap)
        colormap(ax, DiscreteColormap);
    elseif ~isempty(Colormap)
        colormap(ax, Colormap);
    end

    if ~isempty(p.Results.XDir)
        set(ax,'XDir',p.Results.XDir);
    end
    if ~isempty(p.Results.YDir)
        set(ax,'YDir',p.Results.YDir);
    end

    if ~isempty(p.Results.XTicks)
        xticks(ax,p.Results.XTicks);
    end
    if ~isempty(p.Results.YTicks)
        yticks(ax,p.Results.YTicks);
    end
    
    %{
    % Various old options not currently used - maybe will readd these later
    if isfield(args, 'AxesPosition')
       set(ax, 'Position', args.AxesPosition);
    end
    if isfield(args, 'XTick')
        set(ax,'xtick',args.XTick);
    end
    if isfield(args, 'YTick')
        set(ax,'xtick',args.YTick);
    end
    %}
    
    if p.Results.Drawnow || ~isempty(p.Results.SaveFig) || ~isempty(p.Results.SaveImage)
        if p.Results.DrawnowLimitrate
            drawnow limitrate;
        else
            drawnow;
        end
    end
    
    
    if ~isempty(p.Results.SaveFig)
        savefig(fig, buildstr(p.Results.SaveFig));
    end
    
    SaveImage = buildstr(p.Results.SaveImage);
    if ~isempty(SaveImage)
        [~,~,ext] = fileparts(SaveImage);
        if strcmp(ext, '.eps')
            saveas(fig, SaveImage, 'epsc2');
        else
            saveas(fig, SaveImage);
        end
    end

    %{
    if p.Results.ClfAfter
       clf(fig);
    end
    %}

    
    
    
    %***** Local helper functions
    function result = plot_surf(ax, x, y, z)
        if ~isfield(plotfuncargs,'EdgeColor')
            plotfuncargs.EdgeColor = default_SurfEdgeColor;
        end
        surfargscell = struct2vararg(plotfuncargs);
        
        % Do downsampling to make sure we are not plotting an excessive number
        % of points.
        if ~isempty(p.Results.DownSample)
            [ x, y, z ] = downsample_grid( x, y, z, p.Results.DownSample, p.Results.DownSample );
        end
        
        result = surf(ax, x, y, z, surfargscell{:});
        if ~isempty(p.Results.View)
            view(ax, p.Results.View);
        end
    end

    function result = plot_mesh(ax, x, y, z)
        surfargscell = struct2vararg(plotfuncargs);
        
        % Do downsampling to make sure we are not plotting an excessive number
        % of points.
        if ~isempty(p.Results.DownSample)
            [ x, y, z ] = downsample_grid( x, y, z, p.Results.DownSample, p.Results.DownSample );
        end
        
        result = mesh(ax, x, y, z, surfargscell{:});
        if ~isempty(p.Results.View)
            view(ax, p.Results.View);
        end
    end

    function result = plot_imagesc(ax, x, y, z)
        surfargscell = struct2vararg(plotfuncargs);
        result = imagesc(ax, x, y, z, surfargscell{:});
    end

    function [ xdown, ydown, zdown ] = downsample_grid( x, y, z, maxN1, maxN2 )
        scale1 = ceil(length(x)/maxN1);
        scale2 = ceil(length(y)/maxN2);
        xdown = x(1:scale1:end);
        ydown = y(1:scale2:end);
        zdown = z(1:scale2:end, 1:scale1:end);
    end

    function [ scale,dispname ] = get_unit_scale( unit_str )
        dispname = unit_str;
        switch unit_str
            case ''
                scale = 1;
                dispname = '';
            case 'nm'
                scale = 1e9;
            case 'um'
                scale = 1e6;
                dispname = '\mum';
                %dispname = 'um';
            case 'mm'
                scale = 1e3;
            case 'cm'
                scale = 1e2;
            case 'm'
                scale = 1;
            case 'mm-1'
                scale = 1e-3;
                dispname = 'mm^{-1}';
            case 'um-1'
                scale = 1e-6;
                dispname = '\mum^{-1}';
            otherwise
                error('Invalid unit');
        end
    end

    function C = struct2vararg( S )
        names = fieldnames(S);
        vals = struct2cell(S);
        C = cell(length(names),1);
        for ii = 1:length(names)
            C{2*ii-1} = names{ii};
            C{2*ii} = vals{ii};
        end
    end

    function str = buildstr(str)
        if iscell(str)
            str = sprintf( str{:} );
        end
    end

    function c = default_discretecolormap()
        c = [0,0,0; ...   % 0 = black
             1,1,1; ...   % 1 = white
             1,0,0; ...   % 2 = red
             0,1,0; ...   % 3 = green
             0,0,1; ...   % 4 = blue
             1,1,0; ...   % 5 = yellow
             0,0.5,0; ... % 6 = dark green
             0,0.8,0; ... % 7 = darkish green
            ];    
    end

end
