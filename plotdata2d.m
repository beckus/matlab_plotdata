function [ax,fig,result,h_legend] = plotdata2d( varargin )
% TODO:
%  - Add a colormap option (for use with stem plots)?
% TODO: add an option to do a clf
% TODO: option for livescripts to do clf at beginning and skip figsize
%   How to do this elegantly?
%   Should I add an option to do "configs" with different defaults?
%   i.e. you would pass in 'Config','Livescript' or 'Config','Default' or 'Normal'
%   See https://www.mathworks.com/matlabcentral/answers/321066-plotting-from-a-loop-in-a-live-script-in-matlab-2016b
%     Maybe need to see purest way to handle figures in livescript

% PLOTDATA2D Generate 2D plot - Version 0.1
%   PLOTDATA2D(x,y) plots the data in Z with axis vectors x and y.
%   y should be a vector, and not a matrix.
%   may occur.
%   If x is [], then numbers will be auto-generated.
%
%   PLOTDATA2D(x,y, xlab,ylab, 'PropertyName',PropertyValue,...)
%   uses xlab and ylab for the axis labels. Sets
%   the value of the specified properties. Multiple property values can be set
%   with a single statement. See below for a list of properties.
%
%   PLOTDATA2D( {x1,y1,...}, {x2,y2,...}, ...)
%   Generate multiple plots ont he same axis (see PLOT PARAMETERS section
%   below).
%
%   PLOTDATA2D( x, {y1,...}, {y2,...}, ...)
%   Also shows multiple plots, but uses a common set of X values for
%   all plots.
%
%   PLOTDATA2D(FIG,...) plots into the figure with handle FIG.
%
%   PLOTDATA2D(AX,...) plots into the axes with handle AX.
%
%   PLOTDATA2D(..., {}, ...) Creates a new empty plot.
%
%
%   PLOT PARAMETERS
%   The parameters inside the curly braces are the standard parameters
%   passed to the plot command. These are passed directly to the plot
%   command. Examples:
%     {x,y,'r.'}
%     {x,y,'r.', 'MarkerSize',10}
%
%   Other plot commands can be used by specifying the 'PlotType' parameter.
%   As with the plot command, any parameters will be passed to the
%   respective command as-is. Valid plot types are 'plot','stem','bar',
%   'scatter','errorbar','hist','xline', and 'yline'. Example:
%     {x,y, 'PlotType','stem'}
%   Although the bar command allows the X parameter to be omitted, the
%   x parameter must be included when calling plotdata2d with the "bar"
%   plot type. For the hist plot type, the "histogram" command is used.
%   For this plot type, no X parameter should be given.
%   If a common X is provided, it will be ignored when calling the
%   historgram command.
%   Examples:
%     PLOTDATA2D( x, {y1, 'PlotType','plot'}, ...
%                    {y2, 'PlotType','bar'}, ...
%                    {y3, 'PlotType','hist'});
%     PLOTDATA2D( {x1,y1, 'PlotType','plot'}, ...
%                 {x2,y2, 'PlotType','bar'}, ...
%                 {y3, 'PlotType','hist'});
%
%   A label for the legend can be set as well by specifying the 'Label'
%   parameter. Unlabeled plots will receive a default name. Examples:
%     {x,y, 'Label','Data 1'}
%     {x,y, 'PlotType','stem', 'Label','Data 1'}
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
%     ax       Axis used for plot
%     fig      Figure used for plot
%     result   Return value of the plot command. If multiple commands called,
%              a cell array will be returned with each value.
%     h_legend Handle to legend (if shown).
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
%   - AxisScale
%     Sets log axis scales. Values are as follows:
%        linear  Both scales are linear (default)
%        logx    X axis is log, Y axis is linear
%        logy    X axis is linear, Y axis is log
%        loglog  Both axes are log
%
%   - XLim, YLim
%     Set X or Y limits [lower,upper].
%     If -inf is used for the lower limit, the miminum
%     value of the vector/data is used. Likewise for the upper bound if inf
%     is used. If inf is used instead of vector, this is equivalent to
%     using [-inf,inf].
%
%   - XYLim
%     Set both X and Y limits to same value.
%
%   - Normalize
%     Normalize Y data. This field has three possible integer values
%     (it can also be set to true or false):
%       0/false Do not normalize
%       1/true  If multiple datasets are specified, all are normalized
%               to the same maximum (the global maximum).
%       2       Normalize each dataset to its own maximum (i.e. all
%               plots will have a maximum of 1). In other words, each
%               plot is scaled to a different value.
%
%   - ShowLegend
%     Indicates whether to show legend or not. If left unspecified or set
%     to [], the legend will only be shown if a label is specified for any
%     of the plots. If ShowLegend is false, the lines will still be
%     labeled should the legend later be turned on.
%
%   - LegendFontName, LegendFontSize
%     Sets legend font properties. If LegendFontName is not specified,
%     dont is inherited from plot. If not specified, LegendFontSize takes
%     default value.
%     
%   - LegendLocation
%     See https://www.mathworks.com/help/matlab/ref/legend.html#bt6ef_q-1-lcn
%
%   - LegendInterpreter
%     By default, legend entries are treated as tex code - for example underscores
%     indicate a subscript. To override, set this to one of the following
%     values: tex, latex, none
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
%   - XDir,YDir
%     Defaults to "normal"
%
%   - Grid
%     Controls grid. This field has four possible integer values
%     (it can also be set to true or false):
%       0/false  No grid
%       1/true   Show minor and major grids
%       2        Show only major grid
%       3        Show only minor grid
%
%   - TitleInterpreter
%     By default, title is treated as tex code - for example underscores
%     indicate a subscript. To override, set this to one of the following
%     values: tex, latex, none
%
%   - FigNum
%     Use the specified figure number. Creates the figure if it does not
%     exist, or uses existing figure if it already exists.
%
%   - FigFocus
%     Flag to force focus onto figure (defaults to true)
%
%   - SaveFig, SaveImage
%     Save figure or image using specified file names.
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

    % Handle the plot specification(s)
    currarg = varargin{argidx};
    if length(varargin) > argidx
        nextarg = varargin{argidx+1};
    else
        nextarg = [];
    end
    % Check if multiple plots requested and first argument is a
    % common x vector.
    if ~iscell(currarg) && iscell(nextarg)
        is_common_x_given = true;
        common_x = currarg;
        argidx = argidx + 1;
    else
        is_common_x_given = false;
        common_x = [];
    end
    
    % Get the plot specifications
    currarg = varargin{argidx};
    if iscell(currarg)
        % If a cell is given, then get all the cells in the list (each
        % one specifies a different plot).
        startarg = argidx;
        argidx = argidx + 1;
        while argidx<=length(varargin) && iscell(varargin{argidx})
            argidx = argidx + 1;
        end
        plot_specs_cell = varargin(startarg:argidx-1);
    else
        % Otherwise, there is just one plot. Save the x and y arguments
        plot_specs_cell = { {varargin{argidx}, varargin{argidx+1}} };
        argidx = argidx + 2;
    end
    N = length(plot_specs_cell); % Number of plots
    
    % Get the remaining parameters
    parameters = varargin((argidx):end);
    
    
    % Find the configuration parameter. We need to do this before we
    % parse so that we know which defaults to use.
    config = 'Default';
    for ii = 3:2:length(parameters)
        if strcmpi(parameters{ii},'Config')
            config = parameters{ii+1};
        end
    end
    
    % Default values
    default_Grid = 0;
    default_FontName = 'Times New Roman';
    default_FontSize = 12;
    default_TitleInterpreter = [];
    default_FigFocus = true;
    default_box = true;

    if strcmpi(config,'Default')
        default_FigSize = [375, 280];
    elseif strcmpi(config,'LiveScript')
        default_FigSize = [];
    elseif strcmpi(config,'LS')
        default_FigSize = [];
    end
    
    
    p = inputParser;
    p.KeepUnmatched = true;
    addOptional(p,'x_label','',@(x) 1); 
    addOptional(p,'y_label','',@(x) 1);
    
    %addParameter(p,'HoldOn',1);
    addParameter(p,'Title','');
    addParameter(p,'WindowTitle','');
    addParameter(p,'Grid',default_Grid);
    addParameter(p,'Normalize',0);
    addParameter(p,'Box',default_box);
    addParameter(p,'XTicks',[]);
    addParameter(p,'YTicks',[]);
    addParameter(p,'TickDir',[]);
    
    addParameter(p,'ShowLegend', []);
    addParameter(p,'LegendLocation',[]);
    addParameter(p,'LegendFontName',[]);
    addParameter(p,'LegendFontSize',[]);
    addParameter(p,'LegendInterpreter',[]);
    
    addParameter(p,'FontName',default_FontName);
    addParameter(p,'FontSize',default_FontSize);
    addParameter(p,'FigSize',default_FigSize);
    addParameter(p,'FigSizeForce',[]);
    addParameter(p,'TitleInterpreter',default_TitleInterpreter);
    addParameter(p,'XUnits',[]);
    addParameter(p,'YUnits',[]);
    addParameter(p,'XLim',[]);
    addParameter(p,'YLim',[]);
    addParameter(p,'XYLim',[]);
    addParameter(p,'AxisScale', []);
    addParameter(p,'FigNum', []);
    addParameter(p,'FigFocus', default_FigFocus);
    %addParameter(p,'ClearAxes', true);
    addParameter(p,'SaveFig', []);
    addParameter(p,'SaveImage', []);
    addParameter(p,'XDir', 'normal');
    addParameter(p,'YDir', 'normal');
    addParameter(p,'Drawnow', true);
    addParameter(p,'DrawnowLimitrate', false);

    addParameter(p,'FigHandle', []);
    addParameter(p,'AxesHandle', []);
    
    addParameter(p,'Config', []); % Dummy - we don't use this
    parse(p,parameters{:});
    
    plotfuncargs = struct2vararg(p.Unmatched);
    
    
    if isempty(fig)
        fig = p.Results.FigHandle;
    end
    if isempty(ax)
        ax = p.Results.AxesHandle;
    end
    
    x_label = p.Results.x_label;
    y_label = p.Results.y_label;
    
    % Interpret the normalize parameter.
    % Normalize is meant to be used as a integer with three values.
    % However, it could also be used as a logical value, i.e. true/false
    if islogical(p.Results.Normalize)
        if p.Results.Normalize
            normalizetype = 1;
        else
            normalizetype = 0;
        end
    else
        normalizetype = p.Results.Normalize;
    end

    
    % Figure out how to handle the figure / axes
    newfigurecreated = false;
    fig_has_focus = false;
    if isempty(fig) && isempty(ax)
        if isempty(p.Results.FigNum)
            fig = figure;
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
    
   
    % Build a struct array with all the plot specifications.
    global_maxy = -inf;
    plot_specs = struct();
    for ii = 1:N
        plot_spec_cell = plot_specs_cell{ii};
        
        if isempty(plot_spec_cell)
            plot_specs(ii).PlotType = 'plot';
            plot_specs(ii).Label = [];
            plot_specs(ii).x = [];
            plot_specs(ii).y = [];
            plot_specs(ii).params = [];
        else
            % Go through the parameter list and find name/values we are
            % interested in. In general, we don't know what the structure
            % of the parameters (some of them may not be name/value pairs),
            % but we can assume the name/values appear at the end.
            % So, start at the end and work our way back. 
            % Also, the length of the list will change as we remove pairs,
            % so working our way backward will keep indexing consistent.
            % We want to look at names rather values, so at each iteration
            % we skip 2 indices.
            plot_specs(ii).PlotType = 'plot'; % Default type
            plot_specs(ii).Label = []; % Default label
            plotparams = plot_spec_cell;
            for jj = length(plotparams)-1 : -2 : 1
                if ischar(plotparams{jj})
                    if strcmp(plotparams{jj},'PlotType') ...
                       || strcmp(plotparams{jj},'Label')
                      match = true;
                    else
                      match = false;
                    end
                else
                    % If the current entry is not a string, we must not be in
                    % the name/value pairs anymore.
                    break;
                end
                if match
                    plot_specs(ii).(plotparams{jj}) = plotparams{jj+1};
                    % Remove parameters from list so that they do not get
                    % passed to function.
                    plotparams(jj:jj+1) = [];
                end
            end

            if strcmp(plot_specs(ii).PlotType,'hist') || strcmp(plot_specs(ii).PlotType,'xline') || strcmp(plot_specs(ii).PlotType,'yline')
            else
                if is_common_x_given
                    x = common_x;
                    y = plotparams{1};
                    plotparams(1) = [];
                else
                    x = plotparams{1};
                    y = plotparams{2};
                    plotparams(1:2) = [];
                end
                x = real(x);
                if isempty(x)
                    x = 1:length(y);
                end
                y = real(y);
                if size(y,1)>1 && size(y,2)>1
                    error('y cannot be a matrix');
                end
                plot_specs(ii).x = x;
                plot_specs(ii).y = y;
                if normalizetype > 0
                    % Note that maxy will be a vector if y is a matrix.
                    % Note: we normalize against maximum MAGNITUDE
                    %   - if the function is negative at this point,
                    %     the function will be flipped.
                    [plot_specs(ii).maxy,maxidx] = max(abs(y));
                    if y(maxidx) < 0
                        plot_specs(ii).maxy = -plot_specs(ii).maxy;
                    end
                    global_maxy = max(global_maxy, plot_specs(ii).maxy);
                end
            end

            plot_specs(ii).params = plotparams;
        end
    end
    
    % Apply scaling
    if normalizetype > 0
        for ii = 1:N
            if ~strcmp(plot_specs(ii).PlotType,'hist') && ~strcmp(plot_specs(ii).PlotType,'xline') && ~strcmp(plot_specs(ii).PlotType,'yline')
                if normalizetype == 1
                    plot_specs(ii).y = double(plot_specs(ii).y) / double(global_maxy);
                elseif normalizetype == 2
                    plot_specs(ii).y = double(plot_specs(ii).y) ./ double(plot_specs(ii).maxy);
                end
            end
        end
    end
    
    % Do the plots - note that the code should still work if N==0, it will
    % just give an empty figure.
    cla(ax);
    hold(ax,'on');
    result = cell(N,1);
    labeled_entries = [];
    legend_entries = {};
    for ii = 1:N
        plot_spec = plot_specs(ii);
        
        if isfield(plot_spec,'x')
            scaledx = plot_spec.x*x_scale;
        end
        if isfield(plot_spec,'y')
            scaledy = plot_spec.y*y_scale;
        end
        
        % TODO: Add scatter plots? Other types?
        switch plot_specs(ii).PlotType
            case 'plot'
                if isempty(plot_spec.y)
                    continue;
                end
                currresult = plot(ax, scaledx, scaledy, plot_spec.params{:}, plotfuncargs{:});
            case 'stem'
                if isempty(plot_spec.y)
                    continue;
                end
                currresult = stem(ax, scaledx, scaledy, plot_spec.params{:}, plotfuncargs{:});
            case 'bar'
                currresult = bar(ax, scaledx, scaledy, plot_spec.params{:}, plotfuncargs{:});
            case 'scatter'
                currresult = scatter(ax, scaledx, scaledy, plot_spec.params{:}, plotfuncargs{:});
            case 'errorbar'
                currresult = errorbar(ax, scaledx, scaledy, plot_spec.params{:}, plotfuncargs{:});
            case 'hist'
                currresult = histogram(ax, plot_spec.params{:}, plotfuncargs{:});
            case 'xline'
                currresult = xline(ax, plot_spec.params{:}, plotfuncargs{:});
            case 'yline'
                currresult = yline(ax, plot_spec.params{:}, plotfuncargs{:});
            otherwise
                error('Invalid plot type %s',plot_specs(ii).PlotType);
        end
        
        result{ii} = currresult;
        
        if isempty(plot_spec.Label)
            labeled = false;
            curr_legend = sprintf('Data %d',ii);
        else
            labeled = true;
            curr_legend = plot_spec.Label;
        end
        labeled_entries = [labeled_entries labeled];
        legend_entries = [legend_entries curr_legend];
        
        % TODO: add line breaks - use line handle to get last color?
        % see https://www.mathworks.com/matlabcentral/answers/11366-get-next-plot-color
        % Need to skip legends for extra lines, see https://www.mathworks.com/matlabcentral/answers/406-how-do-i-skip-items-in-a-legend
    end
    hold(ax,'off');
    
    xlabel(ax, x_label);
    ylabel(ax, y_label);

    if ~isempty(p.Results.AxisScale)
        switch p.Results.AxisScale
            case 'loglog'
                set(ax, 'XScale', 'log');
                set(ax, 'YScale', 'log');
            case 'logx'
                set(ax, 'XScale', 'log');
                set(ax, 'YScale', 'linear');
            case 'logy'
                set(ax, 'XScale', 'linear');
                set(ax, 'YScale', 'log');
            case 'linear'
                set(ax, 'XScale', 'linear');
                set(ax, 'YScale', 'linear');
        end
    end
    
    if islogical(p.Results.Grid)
        if p.Results.Grid
            gridtype = 1;
        else
            gridtype = 0;
        end
    else
        gridtype = p.Results.Grid;
    end
    if gridtype == 1
        grid(ax,'on');
        set(ax,'xgrid','on', 'ygrid','on');
        set(ax,'xminorgrid','on', 'yminorgrid','on');
    elseif gridtype == 2
        grid(ax,'on');
        set(ax,'xgrid','on', 'ygrid','on');
        set(ax,'xminorgrid','off', 'yminorgrid','off');
    elseif gridtype == 3
        grid(ax,'on');
        set(ax,'xgrid','off', 'ygrid','off');
        set(ax,'xminorgrid','on', 'yminorgrid','on');
    end


    % Handle legend
    make_legend = false;
    % If any labels are provided, then the legend will be created regardless
    % of whether it is shown or not.
    % This will label the lines should the user later decided to turn the
    % legend back on.
    if length(legend_entries) > 1 && any(labeled_entries)
        make_legend = true;
    end
    
    if isempty(p.Results.ShowLegend)
        % If ShowLegend is not specified, show legend only if it is created.
        show_legend = make_legend;
    elseif p.Results.ShowLegend
        % If ShowLegend is true, legend is created even if no labels
        % given (overriding earlier decision) and also shown.
        make_legend = true;
        show_legend = true;
    else
        % If ShoeLegend is false, don't show it (but let it be created
        % per the earlier decision).
        show_legend = false;
    end
            
    h_legend = [];
    if make_legend
        extralegendargs = {};
        if ~isempty(p.Results.LegendLocation)
            extralegendargs = [extralegendargs 'Location' p.Results.LegendLocation];
        end
        if ~isempty(p.Results.LegendFontName)
            extralegendargs = [extralegendargs 'FontName' p.Results.LegendFontName];
        elseif ~isempty(p.Results.FontName)
            extralegendargs = [extralegendargs 'FontName' p.Results.FontName];
        end
        if ~isempty(p.Results.LegendFontSize)
            extralegendargs = [extralegendargs 'FontSize', p.Results.LegendFontSize];
        end
        if ~isempty(p.Results.LegendInterpreter)
            extralegendargs = [extralegendargs 'Interpreter', p.Results.LegendInterpreter];
        end
   
        h_legend = legend(ax,legend_entries, extralegendargs{:});
        
        if ~show_legend
            % If we don't want to show the legend that has been created,
            % delete it (perhaps there is a cleaner way to label the lines
            % than creating and deleting the legend).
            delete(h_legend);
            h_legend = [];
            % Setting the legend invisibile is kind of weird - the legend
            % button in the figure remains on even though the legend
            % is hidden. Maybe this is ok and we should hide it
            % rather than delete it...
            %set(h_legend,'visible','off');
        end
    end

        
   
    figtitle =  buildstr(p.Results.Title);
    if ~isempty(figtitle)
        h_title = title(ax, figtitle);
        if ~isempty(p.Results.TitleInterpreter)
            set(h_title, 'Interpreter', p.Results.TitleInterpreter)
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
    

      

    %***** Local helper functions
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


end

