%%%%%%%%%%%%%%%%%% Function of straight line trajectory %%%%%%%%%%%%%%%%%%%
% This function will output the anime plot of the straight line motion, and
% the the straight line motion process consists of three part: acceleration
% section, constant velocity section and deceleration section
% This function has 4 input: 
%     T1 is the transformation matrix of the starting point of motion, it should be a
%     4*4 matrix
%     T2 is the transformation matrix of the ending point of motion, it should be a
%     4*4 matrix
%     tt is the total time of the motion
%     ta is the time of acceleration as well as decceleration
% The input parameters tt and ta should obey this relation: tt >= 2*ta

% The color of straight line motion trajectory is red

%Example:
% Ts=FowKi(2*pi/3,0,0,0,0);
% Te=FowKi(75*pi/180,pi/6,-pi/6,0,0);
% SLTraj(Ts,Te,3,1)
function [] = SLTraj(Ts,Te,tt,ta)
tau=ta/2; T = tt-2*tau;
m=10*(T+2*tau)+1;
Roti = cell(1,m);
Posi = cell(1,m);
Ti = cell(1,m);
qi = cell(1,m);
TMi = cell(1,m);
pos1 = Ts(1:3,4);
pos2 = Te(1:3,4);
rot1 = Ts(1:3,1:3);
rot2 = Te(1:3,1:3);

%% Define the lux manipulator in robotics toolbox (in order to plot by toolbox)
L1=Link('a',0,'d',0,'alpha',pi/2);
L2=Link('a',5.75,'d',0,'alpha',0);
L3=Link('a',7.375,'d',0,'alpha',0);
L4=Link('a',0,'d',0,'alpha',pi/2);
L5=Link('a',0,'d',3.375,'alpha',0);
lynx = SerialLink([L1 L2 L3 L4 L5], 'name', 'lynx');

%% Transfer the rotation matrix to Euler angle(ZYX), and then transfer the Euler angle to quaternion
eul1 = rotm2eul(rot1);
eul2 = rotm2eul(rot2);
quat1 = quaternion(eul1,'eulerd','ZYX','frame');
quat2 = quaternion(eul2,'eulerd','ZYX','frame');
InterpoQuat = quaternion();

%% The acceleration section
for t = -tau:0.1:tau
    i = round(10*(t+tau)+1);
    InterpoQuat(i) = quat1+(quat2-quat1).*(t+tau)^2./(4*T*tau);
    Posi{i} = pos1+(pos2-pos1)*(t+tau)^2/(4*T*tau);
end

%% The constant velocity section
for t = tau+0.1:0.1:T-tau
    i = round(10*(t+tau)+1);
    InterpoQuat(i) = quat1+(quat2-quat1).*t./T;
    Posi{i} = pos1+(pos2-pos1)*t/T;
end

%% The decceleration section
for t = T-tau+0.1:0.1:T+tau
    i = round(10*(t+tau)+1);
    j = i-10*T;
    InterpoQuat(i) = 2.*quat1+(quat2-quat1).*t./T-InterpoQuat(j);
    Posi{i} = 2.*pos1+(pos2-pos1)*t/T-Posi{j};
end

%% Generate the transformation matrix and joint angle for each point
q = eulerd(InterpoQuat,'ZYX','frame'); % transfer all the quaternion to euler angle

for k = 1:m
    try
    Roti{k} = eul2rotm(q(k,:)); % transfer the euler angle to rotation matrix
    Ti{k} = [Roti{k}, Posi{k};0 0 0 1]; % combine the ratation matrix and position vector to generate the transformation matrix
    qi{k} = InvKi(Ti{k}); % Use the function of inverse kinematic to generate the joint angle [q1 q2 q3 q4 q5]
    TMi{k} = FowKi(qi{k}(1),qi{k}(2),qi{k}(3),qi{k}(4),qi{k}(5)); % Use the function of foward kinematic to generate the transformation matrix corresponding to joint angle qi
    end
end

%% Plotting
for k = 1:m
    try
    lynx.plot(qi{k},'tilesize',3); % Plot the manipulator by robotics toolbox
    Te = TMi{k};
    hold on
    plot3(Te(1,4),Te(2,4),Te(3,4),'r.') % Plot the trajectory point
    hold off
    pause(0.01);
    end
end