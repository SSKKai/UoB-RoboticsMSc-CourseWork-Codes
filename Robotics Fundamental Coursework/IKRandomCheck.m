% This programm is for check the correctness of the inverse kinematic function: InvKi
% It randomly generate 100000 sets of joint angle (q1,q2,q3,q4,q5) in their range
% And check the answer of InvKi(FowKi(q1,q2,q3,q4,q5)) whether is equal to
% (q1,q2,q3,q4,q5)
% If the answer doesn't equal to (q1,q2,q3,q4,q5), the programm will break
% and show that answer and its correspond (q1,q2,q3,q4,q5)
for i = 1:100000
q1 = rand()*pi; %Randomly generate q1,q2,q3,q4,q5
q2 = rand()*2*pi/3;
q3 = -rand()*2*pi/3;
q4 = rand()*pi;
q5=0;

ik = InvKi(FowKi(q1,q2,q3,q4,q5));
i

if abs(ik(1)-q1)>10e-10 || abs(ik(2)-q2)>10e-10 || abs(ik(3)-q3)>10e-10 || abs(ik(4)-q4)>10e-10 % Checking
    ik
    [q1 q2 q3 q4 q5]
    break
end
end