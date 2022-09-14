% This programm will complete the coursework trajectory task.
% in our task, the manipulator will writing a letter "OK" in a clined plane
% There are an obstacle between the word "O" and "K", and an obstacle in
% the returning path, the manipulator will avoid them
%% Define the task points
clear
T1=FowKi(104*pi/180,57*pi/180,-59*pi/180,40*pi/180,0);
T2=FowKi(109*pi/180,79*pi/180,-93*pi/180,25*pi/180,0);
T3=FowKi(97*pi/180,83*pi/180,-97*pi/180,26*pi/180,0);
T4=FowKi(95*pi/180,60*pi/180,-63*pi/180,40*pi/180,0);
q1 = [104*pi/180 57*pi/180 -59*pi/180 40*pi/180 0];
q2 = [pi/2 pi/2 -pi/6 0 0];
q3 = [81*pi/180 60*pi/180 -63*pi/180 40*pi/180 0];
T5=FowKi(81*pi/180,60*pi/180,-63*pi/180,40*pi/180,0);
T6=FowKi(77.7*pi/180,83*pi/180,-97.5*pi/180,26*pi/180,0);
q4 = [77.7*pi/180 83*pi/180 -97.5*pi/180 26*pi/180 0];
q5 = [77.7*pi/180 100*pi/180 -60*pi/180 26*pi/180 0];
q6 = [75.5*pi/180 57*pi/180 -59*pi/180 41*pi/180 0];
T7=FowKi(75.5*pi/180,57*pi/180,-59*pi/180,41*pi/180,0);
T8=FowKi(79*pi/180,70*pi/180,-77*pi/180,29*pi/180,0);
T9=FowKi(64.7*pi/180,72.7*pi/180,-84.7*pi/180,19.4*pi/180,0);
q7=[64.7*pi/180 72.7*pi/180 -84.7*pi/180 19.4*pi/180 0];
q8=[30*pi/180 90*pi/180 -30*pi/180 30*pi/180 0];
q9=[0 0 0 0 0];

%% Plotting
plotcube([0.4 10 3.5],[-0.2 8 -2],.8,[0 1 1]) % generate a cube obstacle
plotcube([10 1 8],[5 4.5 -2],.8,[0 1 1]) % generate a cube obstacle
SLTraj(T1,T2,2,0.5);
SLTraj(T2,T3,2,0.5);
SLTraj(T3,T4,2,0.5);
SLTraj(T4,T1,2,0.5);
FMTraj(q1,q2,2,0.5);
FMTraj(q2,q3,2,0.5);
SLTraj(T5,T6,2,0.5);
FMTraj(q4,q5,2,0.5);
FMTraj(q5,q6,2,0.5);
SLTraj(T7,T8,2,0.5);
SLTraj(T8,T9,2,0.5);
FMTraj(q7,q8,2,0.5);
FMTraj(q8,q9,2,0.5);



