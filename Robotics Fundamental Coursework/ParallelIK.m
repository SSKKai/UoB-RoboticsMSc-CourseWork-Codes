function theta = ParallelIK(xc,yc,alpha)
theta1=zeros(1,2); theta2=zeros(1,2); theta3=zeros(1,2); 
q1 = zeros(1,2);  q2 = zeros(1,2); q3 = zeros(1,2);
alpha=alpha*pi/180;
rp=130; rb=290; S=170; L=130;
f1 = alpha+pi/6; f2 = alpha+5*pi/6; f3 = alpha+3*pi/2;

%% theta1
p1= atan2(yc-rp*sin(f1),xc-rp*cos(f1));
cq1 = (S^2-L^2+(xc-rp*cos(f1))^2+(yc-rp*sin(f1))^2)/(2*S*((xc-rp*cos(f1))^2+(yc-rp*sin(f1))^2)^0.5);
sq1 = (1-cq1^2)^0.5;
q1(1) = atan2(sq1,cq1);
q1(2) = atan2(-sq1,cq1);
p1 = p1.*180./pi;
q1 = q1.*180./pi;
theta1(1) = p1+q1(1); theta1(2) = p1+q1(2);

%% theta2
p2 = atan2(yc-rp*sin(pi-f2),xc+rp*cos(pi-f2)-(3^0.5)*rb);
cq2 = (S^2-L^2+(xc+rp*cos(pi-f2)-(3^0.5)*rb)^2+(yc-rp*sin(pi-f2))^2)/(2*S*((xc+rp*cos(pi-f2)-(3^0.5)*rb)^2+(yc-rp*sin(pi-f2))^2)^0.5);
sq2 = (1-cq2^2)^0.5;
q2(1) = atan2(sq2,cq2);
q2(2) = atan2(-sq2,cq2);
p2 = p2.*180./pi;
q2 = q2.*180./pi;
theta2(1) = p2+q2(1); theta2(2) = p2+q2(2);

% if alpha < 0
%     theta2 = 360+theta2;
% end

%% theta3
p3 = atan2(yc+rp*sin(2*pi-f3)-3*rb/2, xc-rp*cos(2*pi-f3)-(3^0.5)*rb/2);
cq3 = (S^2-L^2+(xc-rp*cos(2*pi-f3)-(3^0.5)*rb/2)^2+(yc+rp*sin(2*pi-f3)-3*rb/2)^2)/(2*S*((xc-rp*cos(2*pi-f3)-(3^0.5)*rb/2)^2+(yc+rp*sin(2*pi-f3)-3*rb/2)^2)^0.5);
sq3 = (1-cq3^2)^0.5;
q3(1) = atan2(sq3,cq3);
q3(2) = atan2(-sq3,cq3);
p3 = p3.*180./pi;
q3 = q3.*180./pi;
theta3(1) = p3+q3(1); theta3(2) = p3+q3(2);

%% solution validation
theta = [theta1(1) theta2(1) theta3(1); theta1(1) theta2(1) theta3(2); theta1(1) theta2(2) theta3(1); theta1(1) theta2(2) theta3(2); 
          theta1(2) theta2(1) theta3(1); theta1(2) theta2(1) theta3(2); theta1(2) theta2(2) theta3(1); theta1(2) theta2(2) theta3(2)];

thetai = theta.*pi./180;    

    