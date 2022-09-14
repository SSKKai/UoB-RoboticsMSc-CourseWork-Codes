%%%%%%%%%%%%%%%%Function of Foward Kinematic %%%%%%%%%%%%%%%%%%%%%
% The input (q1,q2,q3,q4,q5) is the 5 joint angle in the order
% The output is the 4*4 transformation matrix
% The range of the input angle is:
% q1: 0----pi;
% q2: 0----5*pi/6
% q3: -5*pi/6---0
% q4: 0------pi
% q5: 0------pi
% Example: T = FowKi(2*pi/3,pi/3,-pi/4,pi/4,0)
% Example: T = FowKi(1.2,0.5,-0.8,1,0)
function [T] = FowKi(q1,q2,q3,q4,q5)
T = [ sin(q1)*sin(q5) + cos(q2 + q3 + q4)*cos(q1)*cos(q5),   cos(q5)*sin(q1) - cos(q2 + q3 + q4)*cos(q1)*sin(q5), sin(q2 + q3 + q4)*cos(q1), (cos(q1)*(27*sin(q2 + q3 + q4) + 59*cos(q2 + q3) + 46*cos(q2)))/8;
cos(q2 + q3 + q4)*cos(q5)*sin(q1) - cos(q1)*sin(q5), - cos(q1)*cos(q5) - cos(q2 + q3 + q4)*sin(q1)*sin(q5), sin(q2 + q3 + q4)*sin(q1), (sin(q1)*(27*sin(q2 + q3 + q4) + 59*cos(q2 + q3) + 46*cos(q2)))/8;
                          sin(q2 + q3 + q4)*cos(q5),                            -sin(q2 + q3 + q4)*sin(q5),        -cos(q2 + q3 + q4),   (59*sin(q2 + q3))/8 - (27*cos(q2 + q3 + q4))/8 + (23*sin(q2))/4;
                                                  0,                                                     0,                         0,                                                                 1];