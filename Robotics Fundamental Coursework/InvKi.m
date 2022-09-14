%%%%%%%%%%%%%%%%Function of Inverse Kinematic %%%%%%%%%%%%%%%%%%%%%
% The input is the 4*4 transformation matirx of the manipulator
% The output is the vector contains 5 joint angle in the order of: [q1 q2
% q3 q4 q5]
% Example1: InvKi([    0.1492    0.4794    0.8648   10.5954;
%    0.0815   -0.8776    0.4724    5.7883;
%   0.9854         0   -0.1700    9.0159;
%         0         0         0    1.0000;])
% Example2: InvKi(FowKi(0.5,1,-0.3,0.7,0))
% i1,i2,i3,i4,i5 correspond to q1,q2,q3,q4,q5 respectively
% There are 2 sets of solution, but only one sets is correct


function ik = InvKi(T0e)
d2=5.75; d3=7.375; d4=3.375;

nx = T0e(1,1); ny = T0e(2,1); nz = T0e(3,1);
ox = T0e(1,2); oy = T0e(2,2); oz = T0e(3,2);
ax = T0e(1,3); ay = T0e(2,3); az = T0e(3,3);
xe = T0e(1,4); ye = T0e(2,4); ze = T0e(3,4);

%% Solving q1
i1 = atan2(ye,xe); 
if i1<0            % When the elevation angle of the manipulator is very large and makes ye<0, atan2(ye,xe) will smaller than 0.
    i1 = i1+pi;    % At this situation, we need to modify q1
end

%% Solving q2
Z4 = ze-az*d4; D4 = (xe-ax*d4)/cos(i1);
if D4 == 0
    D4 = ((xe-ax*d4)^2+(ye-ay*d4)^2)^0.5;
end
beta = atan2(D4,Z4);

i2 = zeros(1,2); % There are two solution for q2
s2beta = (Z4^2+D4^2+d2^2-d3^2)/(2*d2*(Z4^2+D4^2)^0.5);
c2beta1 = (1-s2beta^2)^0.5;
c2beta2 = -(1-s2beta^2)^0.5;
i2(1) = atan2(s2beta,c2beta1)-beta; % the first solution of q2
i2(2) = atan2(s2beta,c2beta2)-beta; % the second solution for q2

%% Solving q3
i3 = zeros(1,2); % Because q3 is related to q2, so q3 also has two solutions
i3(1) = atan2(Z4-d2*sin(i2(1)),D4-d2*cos(i2(1)))-i2(1); % the first solution for q3
i3(2) = atan2(Z4-d2*sin(i2(2)),D4-d2*cos(i2(2)))-i2(2); % the second solution for q3

%% Solving q4
i4 = zeros(1,2); % Because q4 is related to q2 and q3, so q4 also has two solutions
i4(1) = atan2(nz,nx*cos(i1)+ny*sin(i1))-i2(1)-i3(1); % the first solution for q4
i4(2) = atan2(nz,nx*cos(i1)+ny*sin(i1))-i2(2)-i3(2); % the second solution for q4


if i2(1)<0 || i3(1)>0 % According to the range of the joint angle, the correct solution should follow q2>0 and q3<0
    ik = [i1 i2(2) i3(2) i4(2) 0];
else
    ik = [i1 i2(1) i3(1) i4(1) 0];
end

if ik(4)<0
    ik(4) = ik(4)+2*pi;
elseif ik(4)>pi
    ik(4) = ik(4)-pi;
end






