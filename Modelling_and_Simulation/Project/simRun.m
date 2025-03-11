function [optim_matrix] = simRun()
run Constant_Matrix.m
run Design_Matrix.m

[row,col]=size(design_mat0);
optim_matrix = zeros(8, col);

for ii=1:col
    design_mat = design_mat0(:,ii);
    xz_values = sim('Project_Model2020b',[0 10]);
    
    st_val=90;                      %percentage of final value to be assumed as steady state
    t0=1.8*log(1/(1-st_val*0.01));  %at st_val% of final value, steady state is achieved 
    i=find(xz_values(1,1).tout<=t0);
    
    optim_matrix(1,ii) = max(xz_values.xz([2:i(end)],1));         %transient_max_x
    optim_matrix(2,ii) = max(xz_values.xz([i(end)+1:end],1));        %steady_max_x
    optim_matrix(3,ii) = max(xz_values.xz([2:i(end)],2));         %transient_max_z
    optim_matrix(4,ii) = max(xz_values.xz([i(end)+1:end],2));        %steady_max_z

    optim_matrix(5,ii) = min(xz_values.xz([2:i(end)],1));         %transient_min_x
    optim_matrix(6,ii) = min(xz_values.xz([i(end)+1:end],1));        %steady_min_x
    optim_matrix(7,ii) = min(xz_values.xz([2:i(end)],2));         %transient_min_z
    optim_matrix(8,ii) = min(xz_values.xz([i(end)+1:end],2));        %steady_min_z
end
end




% plot(xz_values(1,1).tout,xz_values(1,1).xz([1:end-1],1))      %x vs time
% grid on;
% figure()
% plot(xz_values(1,1).tout,xz_values(1,1).force_x([1:end-1],1)) %xforce vs time
% grid on;