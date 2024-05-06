%%
% Basic example

x = -pi:pi/10:pi;
%y = tan(sin(x)) - sin(tan(x));
y1 = sin(x);
y2 = cos(x);
y3 = randn(1000,1);
y4 = y3+1;

plotdata2d(x,y1);

%%
% You can also include axis labels
plotdata2d(x,y1, 'x','y');

%%
% You can make multiple plots with labels
plotdata2d(x,{y1,'r-', 'Label','Line Plot'},...
             {y2, 'PlotType','stem', 'Label','Stem Plot'}, ...
           'x','y');

%%
% Or use histograms
plotdata2d(x,{y3, 'FaceAlpha',0.5', 'PlotType','hist', 'Label','y3'}, ...
             {y4, 'FaceAlpha',0.5', 'PlotType','hist', 'Label','y4'}, ...
           'x','y');
       
%%
% Example with units
plotdata2d(1e-6*x, 1e-3*y1, 'x','y', 'XUnits','um', 'YUnits','mm');

