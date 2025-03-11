clc
clear
close all

run Constant_Matrix.m

[row,column]=size(design_mat0);
for i=1:column
    design_mat = design_mat0(:,i);
    xz_values(i) = sim('Project_Model2020b',[0 10]);
end

st_val=90;                      %percentage of final value to be assumed as steady state
t0=1.8*log(1/(1-st_val*0.01));  %at st_val% of final value, steady state is achieved 
i=find(xz_values(1,1).tout<=t0);
transient_max=max(xz_values(1,1).xz([2:i(end)],1))
steady_max=max(xz_values(1,1).xz([i(end)+1:end],1))
transient_min=min(xz_values(1,1).xz([2:i(end)],1))
steady_min=min(xz_values(1,1).xz([i(end)+1:end],1))

x = xz_values(1,1).xz([1:end-1],1);
z = xz_values(1,1).xz([1:end-1],2);

figure(3)

ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
pause on;

for i=1:10:(length(x))
    plot(x(i)+xp,z(i)+yp);
    hold on
    plot([x(i) x(i)+xp(idivide(length(ang),int16(8)))],[z(i) z(i)+yp(idivide(length(ang),int16(8)))]);
    plot([x(i) x(i)+xp(idivide(3*length(ang),int16(8)))],[z(i) z(i)+yp(idivide(3*length(ang),int16(8)))]);
    plot([x(i) x(i)+xp(idivide(5*length(ang),int16(8)))],[z(i) z(i)+yp(idivide(5*length(ang),int16(8)))]);
    plot([x(i) x(i)+xp(idivide(7*length(ang),int16(8)))],[z(i) z(i)+yp(idivide(7*length(ang),int16(8)))]);
    hold off
    grid on;
    frames(:, i) = getframe;
end

pause(5);
plot(xp,yp,'g','LineStyle','--','LineWidth',2);
hold on


figure(1)
plot(xz_values(1,1).tout,xz_values(1,1).xz([1:end-1],1))      %x vs time
grid on;
figure(2)
plot(xz_values(1,1).tout,xz_values(1,1).force_x([1:end-1],1)) %xforce vs time
grid on;
