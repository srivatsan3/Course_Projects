function plotShapes(vec,beam,nbc) 
%--------------------------------------------------------------------------
% Purpose :                                                                
%         To Plot the Mode Shapes  
%
% Synopsis : 
%          PlotModeShapes(vec,fsol,beam,nbc) 
% 
% Variable Description:
% INPUT parameters:
%           vec : Eigenvector
%           fsol : Eigenvalues
%           beam : length vector of the beam (length discretization)
%           nbc : Number of boundary conditions 
%--------------------------------------------------------------------------
v = vec(1:2:end,:) ;    %collecting only displacement dofs 
L = max(beam) ;         %length of the beam
% 
% Plot First Mode shape
plot(v(:,nbc+1),beam,'-ob','linewidth',1);   %plots only for the critical dof
lim=1.5*max(abs(v(:,nbc+1)));
axis([-lim,lim,0,L]);
xlabel('Transverse Direction');
ylabel('Axial Direction');
grid on;
end