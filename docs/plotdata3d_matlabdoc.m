%%
% Basic example

x = -10:0.5:10;
y = -20:1:20;
[X,Y] = meshgrid(x,y);
Z = sin(X) + cos(Y);
% C = X.*Y;

plotdata3d(x,y,Z);

%%
% You can also include axis labels
plotdata3d(x,y,Z, 'x','y');

%%
% You can also do this:
%
%  plot(x,y,z);

