% This function will solve the inverse kinematic problem of the coursework parallel robot.
% The input xc and yc are the coordinate of the needle, and alpha is the angle 
% between the platform and horizontal direction. And the function will output a 8¡Á3 matrix, 
% its each line is a set of solution of three active angles. 
% The function will also output the plot of eight postures. 
% Example1: theta = ParallelIKPlot(260,180,30)
% Example2: theta = ParallelIKPlot(213,185,-10)
function theta = ParallelIKPlot(xc,yc,alpha)
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

%% solution
theta = [theta1(1) theta2(1) theta3(1); theta1(1) theta2(1) theta3(2); theta1(1) theta2(2) theta3(1); theta1(1) theta2(2) theta3(2); 
          theta1(2) theta2(1) theta3(1); theta1(2) theta2(1) theta3(2); theta1(2) theta2(2) theta3(1); theta1(2) theta2(2) theta3(2)];

%% Plotting      
thetai = theta.*pi./180;    
bax=0; bay=0; bbx=290*3^0.5; bby=0; bcx=145*3^0.5; bcy=435;
pax=xc-rp*cos(f1); pay=yc-rp*sin(f1);
pbx=xc+rp*cos(pi-f2); pby=yc-rp*sin(pi-f2);
pcx=xc-rp*cos(2*pi-f3); pcy=yc+rp*sin(2*pi-f3);

for kk = 1:8
        max = 170*cos(thetai(kk,1)); may = 170*sin(thetai(kk,1));
        mbx = 170*cos(thetai(kk,2))+290*3^0.5; mby = 170*sin(thetai(kk,2));
        mcx = 170*cos(thetai(kk,3))+145*3^0.5; mcy = 170*sin(thetai(kk,3))+435;
        subplot(2,4,kk);
        hold on
        plot([pax,pbx,pcx,pax],[pay,pby,pcy,pay],'r','Linewidth',2)
plot([bax,bbx],[bay,bby],'b','Linewidth',3)
plot([bax,bcx],[bax,bcy],'b','Linewidth',3)
plot([bbx,bcx],[bby,bcy],'b','Linewidth',3)
plot([bax,max],[bay,may],'k','Linewidth',2)
plot([bbx,mbx],[bby,mby],'k','Linewidth',2)
plot([bcx,mcx],[bcy,mcy],'k','Linewidth',2)
plot([max,pax],[may,pay],'k','Linewidth',2)
plot([mbx,pbx],[mby,pby],'k','Linewidth',2)
plot([mcx,pcx],[mcy,pcy],'k','Linewidth',2)
xlabel('x(mm)','Fontsize',13)
ylabel('y(mm)','Fontsize',13)
title(['Posture No.',num2str(kk)],'Fontsize',13)
axis equal
axis([-100 600 -100 500]);
grid on
hold off
end   
suptitle(['Models when xc=',num2str(xc),'mm   yc=',num2str(yc),'mm   alpha=',num2str(alpha*180/pi)]);

    