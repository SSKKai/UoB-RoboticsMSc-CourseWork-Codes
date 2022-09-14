%% Caculate the position
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

%% 3D plot
c=zwork;
figure
scatter3(xwork,ywork,zwork,6,c,'.')
title('3D Workspace','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('y(inch)','Fontsize',15)
zlabel('z(inch)','Fontsize',15)
grid on
axis equal
view(-75,20);

%% 2D plot in Z direction
figure
scatter(xwork,ywork,6,c,'.')
title('2D Workspace in Z','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('y(inch)','Fontsize',15)
grid on
axis equal

%% 2D plot in Y direction
figure
scatter(xwork,zwork,6,c,'.')
title('2D Workspace in Y','Fontsize',15)
xlabel('x(inch)','Fontsize',15)
ylabel('z(inch)','Fontsize',15)
grid on
axis equal

%% 2D plot in X direction
figure
scatter(ywork,zwork,6,c,'.')
title('2D Workspace in X','Fontsize',15)
xlabel('y(inch)','Fontsize',15)
ylabel('z(inch)','Fontsize',15)
grid on
axis equal


