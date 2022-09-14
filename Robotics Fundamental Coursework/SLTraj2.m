clear
clc
L1=Link('a',0,'d',0,'alpha',pi/2);
L2=Link('a',5.75,'d',0,'alpha',0);
L3=Link('a',7.375,'d',0,'alpha',0);
L4=Link('a',0,'d',0,'alpha',pi/2);
L5=Link('a',0,'d',3.375,'alpha',0);
robot = SerialLink([L1 L2 L3 L4 L5], 'name', 'my robot');


T1=FowKi(2*pi/3,120.55*pi/180,-109*pi/180,17*pi/180,0);
T2=FowKi(75*pi/180,106*pi/180,-88*pi/180,46*pi/180,0);

An = T1(:,1); Ao = T1(:,2); Aa = T1(:,3); Ap = T1(:,4);
Bn = T2(:,1); Bo = T2(:,2); Ba = T2(:,3); Bp = T2(:,4);

x = An'*(Bp-Ap); y = Ao'*(Bp-Ap); z = Aa'*(Bp-Ap);


fai = atan2(Ao'*Ba,An'*Ba);
theta = atan2(((An'*Ba)^2+(Ao'*Ba)^2)^0.5,Aa'*Ba);
sf = sin(fai); cf = cos(fai); st = sin(theta); ct = cos(theta); vt = 1-cos(theta);
sg = -sf*cf*vt*(An'*Bn)+((cf^2)*vt+ct)*(Ao'*Bn)-sf*st*(Aa'*Bn);
cg = -sf*cf*vt*(An'*Bo)+((cf^2)*vt+ct)*(Ao'*Bo)-sf*st*(Aa'*Bo);
gama = atan2(sg,cg);

Ti = cell(1,11);
qi = cell(1,11);
TMi = cell(1,11);
Ti{1} = T1;
qi{1} = InvKi(T1);
TMi{1} = FKi(qi{1});


for k=0.1:0.1:1
    vtk = 1-cos(k*theta);
    ctk = cos(k*theta);
    stk = sin(k*theta);
    cgk = cos(k*gama);
    sgk = sin(k*gama);

Th = [1 0 0 x*k;0 1 0 y*k;0 0 1 z*k; 0 0 0 1];


Rah = [(sf^2)*vtk+ctk, -sf*cf*vtk, cf*stk, 0;
      -sf*cf*vtk, (cf^2)*vtk+ctk, sf*stk, 0;
      -cf*stk, -sf*stk, ctk, 0;
      0 0 0 1];
  

Roh = [cgk -sgk 0 0;sgk cgk 0 0; 0 0 1 0;0 0 0 1];

i = 10*k+1;
Ti{i} = T1*Th*Rah*Roh;
try
   qi{i} = InvKi(Ti{i});
   TMi{i} = FKi(qi{i});
end
end

for m = 1:11
    try
    robot.plot(qi{m},'tilesize',3);
    Te = TMi{m};
    hold on
    plot3(Te(1,4),Te(2,4),Te(3,4),'r.')
    hold off
    pause(0.3);
    end
end

