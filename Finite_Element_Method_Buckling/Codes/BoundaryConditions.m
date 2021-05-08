function [nbcd,bcdof,kk,mm] = BoundaryConditions(sdof,bc,kk,mm)

%--------------------------------------------------------------------------
% Purpose :                                                                
%         To get the arrested degree's of freedom for the beam depending on
% type of the boundary conditions      
%
% Synopsis : 
%          [nbcd,bcdof,kk,mm] = BoundaryConditions(sdof,bc,kk,mm)
% 
% Variable Description:
% INPUT parameters:
%           sdof : system degrees of freedom
%           bc : boundary condition type
%           kk,mm : stiffness matrices on ehich constraints are applied
%
% OUTPUT PARAMETERS :
%           bcdof : boundary degrees of freedom
%           nbcd : number of boundary conditions
%           kk,mm : final stiffness matrices
%--------------------------------------------------------------------------
 

 if bc == 'c-c'                  %clamped-clamped
    bcdof = [1 2 sdof-1 sdof];
    nbcd = length(bcdof); 
 elseif bc == 'c-f'              %clamped-free
    bcdof = [1 2] ;
    nbcd = length(bcdof);
 elseif bc == 'c-s'              %clamped-supported
     bcdof = [1 2 sdof-1];
     nbcd = length(bcdof); 
 elseif bc == 's-s'              %supported-supported
     bcdof = [ 1 sdof-1];
     nbcd = length(bcdof);
 end
 
 %applying the constraint condition for that particular boundary dof 
 for i=1:nbcd      %loop to go through all the constrained dofs
    c=bcdof(i);    %current constrained dof
    %row corresponding to the dof in both matrices
    kk(:,c)=0;
    mm(:,c)=0;
    %column corresponding to the dof in both matrices
    kk(c,:)=0;
    mm(c,:)=0;
    %diagonal element corresponding to the dof in both matrices
    kk(c,c)=1;
    mm(c,c)=1;
 end
 end
 
     
