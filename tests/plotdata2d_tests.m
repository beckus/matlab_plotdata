%% Setup

x = -pi:pi/10:pi;
%y = tan(sin(x)) - sin(tan(x));
y1 = sin(x);
y2 = cos(x);
y3 = randn(1000,1);
y4 = y3+1;

plotdata2d(x,y1);

%%
% Others
plotdata2d({x,y1},{x,y2}, 'x','y');
plotdata2d({x,y1},{x,y2}, 'x','y', 'ShowLegend',1);
plotdata2d(x,y1, 'x','y', 'FigNum',243);
plotdata2d(x,y1, 'x','y', 'XUnit','m');

%% Various test commands

% Make sure to check outputs

% Multiple types
[ax,fig,result,h_legend] = plotdata2d({y3, 'PlotType','hist','Normalization','pdf','facealpha',.5}, {x,y1, 'PlotType','stem'},{x,y2});
testspecshist1 = {{y3, 'PlotType','hist','Normalization','pdf','facealpha',.5}, {y4, 'PlotType','hist','Normalization','pdf','facealpha',.5}};
[ax,fig,result,h_legend] = plotdata2d(testspecshist1{:});

% Shared x versus different x
testspecs1 = {{x,y1, 'PlotType','stem'},{x,y2}};
[ax,fig,result,h_legend] = plotdata2d(testspecs1{:});
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem'},{y2});

% No legend
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem'},{y2}, 'x','y');
% Legend should appears
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem Plot'},{y2, 'Label','Line Plot'}, 'x','y');
% Legend should not appear. But if you turn it on, you should see your labels
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem Plot'},{y2, 'Label','Line Plot'}, 'x','y', 'ShowLegend',0);
% Legend should appears, even though we didn't specify any labels
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem'},{y2}, 'x','y', 'ShowLegend',1);
% Location of legend should move to ther corner
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem Plot'},{y2, 'Label','Line Plot'}, 'x','y', 'LegendLocation','southwest');

% Legend should inherit FontName from main plot
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem Plot'},{y2, 'Label','Line Plot'}, 'x','y', 'FontName','Courier New');
% Legend should have issues with underscore
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem_Plot'},{y2, 'Label','Line_Plot'}, 'x','y');
% Underscore issue should be resolved
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem_Plot'},{y2, 'Label','Line_Plot'}, 'x','y', 'LegendInterpreter','none');
% Font in legend should change
[ax,fig,result,h_legend] = plotdata2d(x, {y1, 'PlotType','stem', 'Label','Stem_Plot'},{y2, 'Label','Line_Plot'}, 'x','y', 'ShowLegend',1, 'LegendFontName','Courier New', 'LegendFontSize',20);

% Test normalization
% Should be off
plotdata2d(x,{2*y1},{y2/2}, 'x','y');
plotdata2d(x,{2*y1},{y2/2}, 'x','y', 'Normalize',0);
% Scale should change to 1
plotdata2d(x,{2*y1},{y2/2}, 'x','y', 'Normalize',1);
% Both should scale to 1
plotdata2d(x,{2*y1},{y2/2}, 'x','y', 'Normalize',2);

% Test of making a cell with plot specs
[ax,fig,result,h_legend] = plotdata2d(plotspecs{:});

% Logx scale
plotdata2d(testspecs1{:}, 'x','y', 'AxisScale','logx');
plotdata2d(testspecshist1{:}, 'x','y', 'AxisScale','logx');
% Logy scale
plotdata2d(testspecs1{:}, 'x','y', 'AxisScale','logy');
plotdata2d(testspecshist1{:}, 'x','y', 'AxisScale','logy');
% LogLog scale
plotdata2d(testspecs1{:}, 'x','y', 'AxisScale','loglog');
plotdata2d(testspecshist1{:}, 'x','y', 'AxisScale','loglog');

% Check limit commands
plotdata2d(x,y1, 'x','y', 'XLim',[0 20], 'YLim',[0 30]);
plotdata2d(x,y1, 'x','y', 'XLim',[-inf 0], 'YLim',[-inf 0]);
plotdata2d(x,y1, 'x','y', 'XLim',[0 inf], 'YLim',[0 inf]);
plotdata2d(x,y1, 'x','y', 'XLim',[-inf inf], 'YLim',[-inf inf]);
plotdata2d(x,y1, 'x','y', 'XLim',inf, 'YLim',inf);

% Test grid
plotdata2d(x,y1, 'x','y', 'Grid',0);
plotdata2d(x,y1, 'x','y', 'Grid',1);
plotdata2d(x,y1, 'x','y', 'Grid',2);
plotdata2d(x,y1, 'x','y', 'Grid',3);
plotdata2d(x,y1, 'x','y', 'Grid',false);
plotdata2d(x,y1, 'x','y', 'Grid',true);

% Set title and window title
plotdata2d(x,y1, 'x','y', 'Title','Test Plot Title', 'WindowTitle','Test Window Title');

% Check latex
plotdata2d(x,y1, 'x','y', 'Title','Test_Plot_Title');
plotdata2d(x,y1, 'x','y', 'Title','Test_Plot_Title', 'TitleInterpret','none');

% Box and ticks
plotdata2d(x,y1, 'x','y', 'Box',0);
plotdata2d(x,y1, 'x','y', 'TickDir','in');
plotdata2d(x,y1, 'x','y', 'TickDir','out');
plotdata2d(x,y1, 'x','y', 'TickDir','both');



% Font and figure settings should be left as default if not specified.
plotdata2d(x,y1, 'x','y', 'FontName',[], 'FontSize',[], 'FigSize',[]);


%% Figures

% Pending
%{
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
%}