clear
clc
%% Part 1
disp('Part 1');
%% Forward kinematic
disp('A forward kinematic example q1=[2*pi/3,pi/3,-pi/4,pi/4,0]');
T1 = FowKi(2*pi/3,pi/3,-pi/4,pi/4,0)
disp('Another forward kinematic example q2=[1.2,0.5,-0.8,1,0] ');
T2 = FowKi(1.2,0.5,-0.8,1,0)
input('Foward kinematic done. Press enter to continue \n');
%% Inverse kinematic
disp('Using InvKi to solve the inverse kinematic of T1');
q1 = InvKi(T1)
disp('Using InvKi to solve the inverse kinematic of T2');
q2 = InvKi(T2)
disp('Another inverse kinematic example q=[0.5,1,-0.3,0.7,0]');
q3 = InvKi(FowKi(0.5,1,-0.3,0.7,0))
input('Inverse kinematic done. Press enter to continue \n');
%% Workspace
clear
disp('The workspace of Lynxmotion arm')
i = 0;
xwork=zeros(1,100048);
ywork=zeros(1,100048);
zwork=zeros(1,100048);
for q1=0:pi/60:pi
    for q2=0:pi/15:5*pi/6
        for q3=-5*pi/6:pi/15:0
            for q4=0:pi/15:pi
                    i=i+1;
                    T0e = fk(q1,q2,q3,q4,0);
                    xwork(i) = T0e(1,4);
                    ywork(i) = T0e(2,4);
                    zwork(i) = T0e(3,4);
            end
        end
    end
end

c=zwork;
figure('Position', [30,550,560,420]);
scatter3(xwork,ywork,zwork,6,c,'.')
title('3D Workspace','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('y(inch)','Fontsize',15)
zlabel('z(inch)','Fontsize',15)
grid on
axis equal
view(-75,20);

figure('Position', [830,550,560,420]);
scatter(xwork,ywork,6,c,'.')
title('2D Workspace in Z','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('y(inch)','Fontsize',15)
grid on
axis equal

figure('Position', [30,50,560,420]);
scatter(xwork,zwork,6,c,'.')
title('2D Workspace in Y','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('z(inch)','Fontsize',15)
grid on
axis equal

figure('Position', [830,50,560,420]);
scatter(ywork,zwork,6,c,'.')
title('2D Workspace in X','Fontsize',15)
xlabel('y(inch)','Fontsize',15)
ylabel('z(inch)','Fontsize',15)
grid on
axis equal
input('Workspace done. Press enter to continue \n');
close
close
close
close
%% Free motion
disp('A free motion trajectory example')
figure
FMTraj([0,0,0,0,0],[1.2,0.9,-0.68,1,0],3,1)
input('Free motion done. Press enter to continue \n');
close
%% Straight-line motion
disp('A straight-line trajectory example')
figure
Ts=FowKi(2*pi/3,0,0,0,0);
Te=FowKi(75*pi/180,pi/6,-pi/6,0,0);
SLTraj(Ts,Te,3,1)
input('Straight-line motion done. Press enter to continue \n');
close
%% Trajectory task
disp('The trajectory task: writing a "OK" and avoid the obstacles')
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

figure
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
input('Task done. Press enter to continue \n');
close
%% Part 2
disp('Part 2');
%% inverse kinematic parallel robot
disp('A inverse kinematic example of parallel robot xc=260mm, yc=180mm, alpha=30degree');
theta1 = ParallelIKPlot(260,180,30)
input('For better display please magnify the figure. Press enter to continue \n');
close

%% Workspace space of parallel robot
disp('A workspace example of parallel robot alpha=-10degree');
ParallelWorkspace(-10)
input('For better display please magnify the figure. Press enter to finish \n');
disp('All done');
close