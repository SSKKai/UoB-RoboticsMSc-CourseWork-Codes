%%%%%%%%%%%%%%%%%%%%%%% Function of Free Motion%%%%%%%%%%%%%%%%%%%%%%
% This function will output the anime plot of the free motion, and the free
% motion process consists of three part: acceleration section, constant
% velocity section and decceleration section
% This function has 5 input: 
%     qs is the joint angles at the starting point of motion, it should be a
%     1*5 vector [q1.q2,q3,q4,q5]
%     qe is the joint angles at the ending point of motion, it should be a
%     1*5 vector [q1,q2,q3,q4,q5]
%     tt is the total time of the motion
%     ta is the time of acceleration as well as decceleration
% The input parameters tt and ta should obey this relation: tt >= 2*ta

% The color of free motion trajectory is blue

% Example: FMTraj([0,0,0,0,0],[1.2,0.9,-0.68,1,0],3,1)

function [] = FMTraj(qs,qe,tt,ta)
tau=ta/2;T=tt-2*tau;
m=10*(T+2*tau)+1;
qi = cell(1,m);
TMi = cell(1,m);

%% Define the lux manipulator in robotics toolbox (in order to plot by toolbox)
L1=Link('a',0,'d',0,'alpha',pi/2);
L2=Link('a',5.75,'d',0,'alpha',0);
L3=Link('a',7.375,'d',0,'alpha',0);
L4=Link('a',0,'d',0,'alpha',pi/2);
L5=Link('a',0,'d',3.375,'alpha',0);
lynx = SerialLink([L1 L2 L3 L4 L5], 'name', 'lynx');

%% The acceleration section
for t = -tau:0.1:tau
    k = round(10*(t+tau)+1);
    qi{k} = qs+(qe-qs).*(t+tau)^2./(4*T*tau);
    TMi{k} = FKi(qi{k});
end

%% The constant velocity section
for t = tau+0.1:0.1:T-tau
    k = round(10*(t+tau)+1);
    qi{k} = qs+(qe-qs).*t./T;
    TMi{k} = FKi(qi{k});
end

%% The decceleration section
for t = T-tau+0.1:0.1:T+tau
    k = round(10*(t+tau)+1);
    j = k-10*T;
    qi{k} = 2.*qs+(qe-qs).*t./T-qi{j};
    TMi{k} = FKi(qi{k});
end
    
%% plotting
for k = 1:m
    lynx.plot(qi{k},'tilesize',3); % Plot the manipulator by robotics toolbox
    Te = TMi{k};
    hold on
    plot3(Te(1,4),Te(2,4),Te(3,4),'b.') % Plot the trajectory point
    hold off
    pause(0.01);
end
