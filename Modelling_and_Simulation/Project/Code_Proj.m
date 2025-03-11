
%Intitial Values:
m = 10; %Mass of Washing Machine
mu = 2; %Unbalanced Mass
r = 0.2; %Radius
% sf1 = 0.1;
% sf2 = 0.1;
% df1 = 0.1;
% df2 = 0.1;
% angle_sf1 = pi/4;
% angle_sf2 = 3*pi/4;
% angle_df1 = 5*pi/4;
% angle_df2 = 7*pi/4;

k = 1665; %Spring Constant
c = 308.6; %Damping Constant
N = 900; %Steady state RPM
t = 2; %Instant of time

% xs1 = (r+sf1)*cos(angle_sf1); zs1 = (r+sf1)*sin(angle_sf1);
% xs2 = (r+sf2)*cos(angle_sf2); zs2 = (r+sf2)*sin(angle_sf2);
% xd1 = (r+df1)*cos(angle_df1); zd1 = (r+df1)*sin(angle_df1);
% xd2 = (r+df2)*cos(angle_df2); zd2 = (r+df2)*sin(angle_df2);

xs1 = 0.212;zs1 = 0.2121; %Position of fixed ends of spring 1
xs2 = -0.212;zs2 = 0.2121; %Position of fixed ends of spring 2
xd1 = 0.212;zd1 = -0.2121; %Position of fixed ends of damper 1
xd2 = -0.212;zd2 = -0.2121; %Position of fixed ends of damper 2

syms x z x_dot z_dot x_ddot y_ddot

% SPRING 1
xs1_d = xs1-x; zs1_d = zs1-z;
ls1 = sqrt(xs1^2+zs1^2);
ls1_d = sqrt(xs1_d^2+zs1_d^2);
Fs1 = (ls1-ls1_d)*k;
Fs1_x = Fs1*xs1_d/ls1_d;
Fs1_z = Fs1*zs1_d/ls1_d;

% SPRING 2
xs2_d = xs2+x; zs2_d = zs2-z;
ls2 = sqrt(xs2^2+zs2^2);
ls2_d = sqrt(xs2_d^2+zs2_d^2);
Fs2 = (ls2-ls2_d)*k;
Fs2_x = Fs2*xs2_d/ls2_d;
Fs2_z = Fs2*zs2_d/ls2_d;

% DAMPER 1
xd1_d = xd1-x; zd1_d = zd1+z;
ld1 = sqrt(xd1^2+zd1^2);
ld1_d = sqrt(xd1_d^2+zd1_d^2);
Fd1 = (((xd1-x)*(-x_dot)+(zd1+z)*(z_dot))/ld1_d)*c;
Fd1_x = Fd1*xd1_d/ld1_d;
Fd1_z = Fd1*zd1_d/ld1_d;

% DAMPER 2
xd2_d = xd2+x; zd2_d = zd2+z;
ld2 = sqrt(xd2^2+zd2^2);
ld2_d = sqrt(xd2_d^2+zd2_d^2);
Fd2 = (((xd2+x)*(x_dot)+(zd2+z)*(z_dot))/ld2_d)*c;
Fd2_x = Fd2*xd2_d/ld2_d;
Fd2_z = Fd2*zd2_d/ld2_d;

%EXTERNALS
beta_dot = N*(1-exp(-t/1.8));
beta = N*(t+(1.8*exp(-t/1.8)));
beta_ddot = N*exp(-t/1.8)/1.8;

Fn = mu*r*(beta_dot)^2;
Ft = mu*r*beta_ddot;

Fx_ext = Fn*cos(beta)-Ft*sin(beta);
Fz_ext = Fn*sin(beta)+Ft*cos(beta);

%FINAL EQUATIONS:
F = [Fx_ext-Fs1_x+Fs2_x+Fd1_x-Fd2_x;...
     Fz_ext-Fs1_z-Fs2_z-Fd1_z-Fd2_z];
x_ddot = vpa((1/m)*F(1))
z_ddot = vpa((1/m)*F(2))








