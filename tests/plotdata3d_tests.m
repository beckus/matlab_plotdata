%% Setup

x = -10:0.5:10;
y = -20:1:20;
[X,Y] = meshgrid(x,y);
Z = sin(X) + cos(Y);

%% Various test commands

% Check limit commands
plotdata3d(x,y,Z, 'x','y', 'XLim',[0 20], 'YLim',[0 30]);
plotdata3d(x,y,Z, 'x','y', 'XLim',[-inf 0], 'YLim',[-inf 0]);
plotdata3d(x,y,Z, 'x','y', 'XLim',[0 inf], 'YLim',[0 inf]);
plotdata3d(x,y,Z, 'x','y', 'XLim',[-inf inf], 'YLim',[-inf inf]);
plotdata3d(x,y,Z, 'x','y', 'XLim',inf, 'YLim',inf);

plotdata3d(x,y,Z, 'x','y', 'XYLim',[0 20]);
plotdata3d(x,y,Z, 'x','y', 'XYLim',[-inf 0]);
plotdata3d(x,y,Z, 'x','y', 'XYLim',[0 inf]);
plotdata3d(x,y,Z, 'x','y', 'XYLim',[-inf inf]);
plotdata3d(x,y,Z, 'x','y', 'XYLim',inf);

plotdata3d(x,y,Z, 'x','y', 'ZLim',[0 3], 'PlotType','surf');
plotdata3d(x,y,Z, 'x','y', 'ZLim',[-inf 0], 'PlotType','surf');
plotdata3d(x,y,Z, 'x','y', 'ZLim',[0 inf], 'PlotType','surf');
plotdata3d(x,y,Z, 'x','y', 'ZLim',[-inf inf], 'PlotType','surf');
plotdata3d(x,y,Z, 'x','y', 'ZLim',inf, 'PlotType','surf');

plotdata3d(x,y,Z, 'x','y', 'CAxis',[0 3]);
plotdata3d(x,y,Z, 'x','y', 'CAxis',[-inf 0]);
plotdata3d(x,y,Z, 'x','y', 'CAxis',[0 inf]);
plotdata3d(x,y,Z, 'x','y', 'CAxis',[-inf inf]);
plotdata3d(x,y,Z, 'x','y', 'CAxis',inf);

% Set title and window title
plotdata3d(x,y,Z, 'x','y', 'Title','Test Plot Title', 'WindowTitle','Test Window Title');

% Check latex
plotdata3d(x,y,Z, 'x','y', 'Title','Test_Plot_Title');
plotdata3d(x,y,Z, 'x','y', 'Title','Test_Plot_Title', 'LatexInterpretTitle',0);

% Box and ticks
plotdata3d(x,y,Z, 'x','y', 'Box',0);
plotdata3d(x,y,Z, 'x','y', 'TickDir','in');
plotdata3d(x,y,Z, 'x','y', 'TickDir','out');
plotdata3d(x,y,Z, 'x','y', 'TickDir','both');

% Color bar / color map
plotdata3d(x,y,Z, 'x','y', 'ColorBar',false, 'Colormap',gray);

% Test Zlabel - should appear on color bar, too
plotdata3d(x,y,Z, 'x','y', 'PlotType','surf', 'ZLabel','Test Z Label');

% Check downsampling
plotdata3d(x,y,Z, 'x','y', 'PlotType','surf', 'DownSample',10);

% If specified without giving plot type - it should be passed to imagesc
% command which throws as error.
plotdata3d(x,y,Z, 'x','y', 'XLim',[0 20], 'YLim',[0 30], 'EdgeColor','none');

% Edgecolor setting
plotdata3d(x,y,Z, 'x','y', 'PlotType','surf', 'XLim',[0 20], 'YLim',[0 30], 'EdgeColor',[1 0 0], 'View',[1 0 1]);
plotdata3d(x,y,Z, 'x','y', 'PlotType','mesh', 'View',[1 0 1], 'EdgeColor',[1 0 0]);

% Font and figure settings should be left as default if not specified.
plotdata3d(x,y,Z, 'x','y', 'FontName',[], 'FontSize',[], 'FigSize',[]);


%% Figures

close all;

% New figure 1 should pop up
[~,newax,newfig] = plotdata3d(x,y,Z, '','')

close(newfig);

% New figure 50 should pop up
[~,newax,newfig] = plotdata3d(x,y,Z, '','', 'FigNum',50)

% Put figure behind something - it should not pop up
[~,newax,newfig] = plotdata3d(x,y,-Z, '','', 'FigNum',50)

% Put it behind something again - it should pop up this time
[~,newax,newfig] = plotdata3d(x,y,-Z, '','', 'FigNum',50, 'FigFocus',1)


% Now let's create some handles
close all;
fig1 = figure(100);
set(fig1, 'name','Existing figure');
fig2 = figure(101);
set(fig2, 'name','Existing');
ax2 = axes(fig2);

% Put the windows behind something - they should NOT pop up
% fig1 should be resized, but not fig2
plotdata3d(fig1, x,y,Z, '','');
plotdata3d(ax2, x,y,Z, '','');

% Put it behind something again. Also resize fig1 and fig2.
% They should pop up this time, and fig1 should be resized again.
plotdata3d(fig1, x,y,Z, '','', 'FigFocus',1);
plotdata3d(ax2, x,y,Z, '','', 'FigFocus',1);

% Change the size of fig1 up. Thsi time it won't be resized.
plotdata3d(fig1, x,y,Z, '','', 'FigSize',[]);



% Future features (maybe)?
% - Handle matrices for x and y
% - Log scale for colorbar