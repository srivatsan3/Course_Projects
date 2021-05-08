function [pcrfem] = convergenceTest(E,I,tnel,tleng,bc)
%--------------------------------------------------------------------------
% Purpose :                                                                
%         To find the critical loads for different element numbers  
%
% Synopsis : 
%          [pcrfem] = convergenceTest(E,I,tnel,tleng,bc)
% 
% Variable Description:
% INPUT parameters:
%           E : Young's Modulus
%           I : Second Moment of Area
%           tnel : final number of elements(division of elements starts from 2)
%           tleng : length of the beam
%           bc : type of constraint
%
% OUTPUT PARAMETERS :
%           pcrfem : stores the critical load values
%--------------------------------------------------------------------------

% Boundary Conditions
%c-f->clamped-free
%c-c->clamped-clamped
%c-s->clamped-supported
%s-s->supported-supported

% Discretizing the Beam
pcrfem=zeros(tnel-1,1);
for nel=2:tnel     %number of elements
nnode=nel+1;       %total number of nodes in system
sdof=2*nnode;      %total system dofs 

% Material properties
leng = tleng/nel;             %uniform mesh (equal size of elements)

kk=zeros(sdof,sdof);    %initializing system stiffness matrix
kkg=zeros(sdof,sdof);   %initializing system geomtric stiffness matrix 


for iel=1:nel                           %loop for the total number of elements
    index=[2*iel-1 2*iel 2*iel+1 2*iel+2];  %system dofs associated with element
    
    %element stiffness matrix
    k=E*I/(leng^3)*[12       6*leng    -12       6*leng;...
                    6*leng   4*leng^2  -6*leng   2*leng^2;...
                   -12      -6*leng     12      -6*leng;...
                    6*leng   2*leng^2  -6*leng   4*leng^2];

    %element geometric stiffness matrix
    kg=1/(30*leng)*[36       3*leng    -36       3*leng;...
                    3*leng   4*leng^2  -3*leng  -1*leng^2;...
                   -36      -3*leng     36      -3*leng;...
                    3*leng  -1*leng^2  -3*leng   4*leng^2];
  
    kk(index,index)=kk(index,index)+k([1:4],[1:4]);     %assemble element stiffness matrices into system matrix
    kkg(index,index)=kkg(index,index)+kg([1:4],[1:4]);  %assemble geometric stiffness matrices into system matrix
end

kk0=kk;     %to temporarily store stiffness matrix  
kkg0=kkg;   %to temporarily store geometric stiffness matrix
[nbcd,~,kk0,kkg0] = BoundaryConditions(sdof,bc,kk0,kkg0); %reducing the matrix size by applying constraints

% Buckling load
[~, ebl] = eig(kk0,kkg0);  %solve the eigenvalue problem for Buckling Loads
ebl = diag(ebl);

pcrfem(nel-1,1) = ebl(nbcd+1);     %FEM first buckling load
end
end

