%PARAMS
% m1 = 100;
% m2 = 10;
% k = 1000;
% c = 100;
% phi_c0 = pi/2;
% phi_k0 = pi/2;
% kf = 0.15;
% cf = 0.15;
% e = 0.3;
% r = 0.5;
% mu = 0.01;
syms x y t theta x_dot y_dot theta_dot m1 m2 k c phi_c0 phi_k0 kf cf e r mu w I1;
x_init = [r*cos(phi_k0);-r*cos(phi_k0);-r*cos(phi_c0);r*cos(phi_c0)];
y_init = [r*sin(phi_k0);-r*sin(phi_k0);-r*sin(phi_c0);r*sin(phi_c0)];

%w = 500;


x1 = r*cos(phi_k0+theta)+x;
x2 = r*cos(pi-phi_k0+theta)+x;
x3 = r*cos(pi+phi_c0+theta)+x;
x4 = r*cos(-phi_c0+theta)+x;

y1 = r*sin(phi_k0+theta)+y;
y2 = r*sin(pi-phi_k0+theta)+y;
y3 = r*sin(pi+phi_c0+theta)+y;
y4 = r*sin(-phi_c0+theta)+y;

xf1 = (r+kf)*cos(phi_k0);
xf2 = (r+kf)*cos(pi-phi_k0);
xf3 = (r+cf)*cos(pi+phi_c0);
xf4 = (r+cf)*cos(-phi_c0);


yf1 = (r+kf)*sin(phi_k0);
yf2 = (r+kf)*sin(pi-phi_k0);
yf3 = (r+cf)*sin(pi+phi_c0);
yf4 = (r+cf)*sin(-phi_c0);

theta1 = atan((yf1-y1)/(xf1-x1));
theta2 = atan((yf2-y2)/(xf2-x2));
theta3 = atan((yf3-y3)/(xf3-x3));
theta4 = atan((yf4-y4)/(xf4-x4));


Fk1 = k*(sqrt((x1-xf1)^2+(y1-yf1)^2)-kf);
Fk2 = k*(sqrt((x2-xf2)^2+(y2-yf2)^2)-kf);

x3_dot = -r*sin(pi+phi_c0+theta)*theta_dot+x_dot;
y3_dot = r*cos(pi+phi_c0+theta)*theta_dot+y_dot;

x4_dot = -r*sin(-phi_c0+theta)*theta_dot+x_dot;
y4_dot = r*cos(-phi_c0+theta)*theta_dot+y_dot;

v3 = x3_dot*cos(theta3)+y3_dot*sin(theta3);
v4 = x4_dot*cos(theta4)+y4_dot*sin(theta4);

Fc3 = -c*v3; Fc4 = -c*v4;

Fk1x = Fk1*cos(theta1); Fk2x = Fk2*cos(theta2);
Fk1y = Fk1*sin(theta1); Fk2y = Fk2*sin(theta2);

Fc3x = Fc3*cos(theta3); Fc4x = Fc4*cos(theta4);
Fc3y = Fc3*sin(theta3); Fc4y = Fc4*sin(theta4);

M1 = (x1-x)*Fk1y-(y1-y)*Fk1x;
M2 = (x2-x)*Fk2y-(y2-y)*Fk2x;
M3 = (x3-x)*Fc3y-(y3-y)*Fc3x;
M4 = (x4-x)*Fc4y-(y4-y)*Fc4x;

x_ddot = (Fk1x+Fk2x+Fc3x+Fc4x+m2*e*w^2*sin(w*t))/(m1+m2);
y_ddot = (Fk1y+Fk2y+Fc3y+Fc4y+m2*e*w^2*cos(w*t))/(m1+m2);
%I1 = 100;
theta_ddot = (M1+M2+M3+M4)/(I1+m2*e^2);

x_ddot = simplify(x_ddot)
y_ddot = simplify(y_ddot)
theta_ddot = simplify(theta_ddot)