% This function will plot the workspace for a given orientation alpha
% Example: ParallelWorkspace(-10)
function []=ParallelWorkspace(alpha)
%% Recording the workspace
i=0;
x = zeros(1,10000); y = zeros(1,10000);
for xc = 70:1:420
    for yc = 0:1:320
        try
            ParallelIK(xc,yc,alpha);    
            i = i+1;
            x(i) = xc;
            y(i) = yc;
        end
    end
end
x = x(x~=0); y = y(y~=0);

%% Plotting
bax=0; bay=0; bbx=290*3^0.5; bby=0; bcx=145*3^0.5; bcy=435;
hold on
plot([bax,bbx],[bay,bby],'b','Linewidth',3)
plot([bax,bcx],[bax,bcy],'b','Linewidth',3)
plot([bbx,bcx],[bby,bcy],'b','Linewidth',3)
plot(x,y,'r.')
xlabel('x(mm)','Fontsize',20)
ylabel('y(mm)','Fontsize',20)
title(['Workspace of the needle when alpha=',num2str(alpha),'degree'],'Fontsize',20)
axis equal
axis([-100 600 -100 500]);
grid on
hold off
