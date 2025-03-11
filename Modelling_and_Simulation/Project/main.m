clc
clear
close all

run Design_Matrix.m
run Constant_Matrix.m

for i=1:2
    design_mat = design_mat0(:,i);
    xz_values(i) = sim('Project_Model2020b',[0 10]);
end

st_val=90;                      %percentage of final value to be assumed as steady state
t0=1.8*log(1/(1-st_val*0.01));  %at st_val% of final value, steady state is achieved 
i=find(xz_values(1,1).tout<=t0);
transient=max(xz_values(1,1).xz([2:i(end)],1))
steady=max(xz_values(1,1).xz([i(end)+1:end],1))

x = xz_values(1,1).xz([1:end-1],1);
z = xz_values(1,1).xz([1:end-1],2);

figure(3)
pbaspect([1 1 1]);
for i=1:length(x)
    circle(x(i),z(i),r)
end

figure(1)
plot(xz_values(1,1).tout,xz_values(1,1).xz([1:end-1],1))      %x vs time
grid on;
figure(2)
plot(xz_values(1,1).tout,xz_values(1,1).force_x([1:end-1],1)) %xforce vs time
grid on;