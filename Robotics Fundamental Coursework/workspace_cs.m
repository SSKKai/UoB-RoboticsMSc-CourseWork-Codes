%% Plot the workspace
i = 0;
xwork=zeros(1,35557);
ywork=zeros(1,35557);
zwork=zeros(1,35557);
q1=pi/2;
    for q2=0:pi/36:5*pi/6
        for q3=-5*pi/6:pi/36:0
            for q4=0:pi/36:pi
                    i=i+1;
                    T0e = fk(q1,q2,q3,q4,0);
                    xwork(i) = T0e(1,4);
                    ywork(i) = T0e(2,4);
                    zwork(i) = T0e(3,4);
                    i
            end
        end
    end

% plot3(xwork,ywork,zwork,'.','MarkerSize',4)

c=zwork;

figure
scatter(ywork,zwork,15,c,'.')
title('Cross-section Workspace in X','Fontsize',15)
xlabel('y(inch)','Fontsize',15)
ylabel('z(inch)','Fontsize',15)
grid on
axis equal


