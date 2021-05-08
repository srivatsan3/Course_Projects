%% To find the First Euler Buckling Load of a steel column with various Boundary Conditions
clc
clear
close all

% Discretizing the Beam
nel=50;            %number of elements
nnode=nel+1;       %total number of nodes in system
sdof=2*nnode;      %total system dofs 

% Material properties(in SI Units)
E=2.1*10^11;                  %young's modulus
I=2000*10^-8;                 %moment of inertia of cross-section
tleng = 10;                   %total length of the beam
leng = tleng/nel;             %uniform mesh (equal size of elements)
lengthvector = 0:leng:tleng ;


% Boundary Conditions
bct=['c-f';'c-c';'c-s';'s-s'];
%c-f->clamped-free
%c-c->clamped-clamped
%c-s->clamped-supported
%s-s->supported-supported

kk=zeros(sdof,sdof);    %initializing system stiffness matrix
kkg=zeros(sdof,sdof);   %initializing system geomtric stiffness matrix 
index=zeros(2*nel,1);   %initializing index vector


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

% Applying Boundary conditions
pcrth=zeros(4,1);   %to store theoretical load values
pcrfem=zeros(4,1);  %to store fem load values
error=zeros(4,1);   %to store error values

for i=1:4     %loop to solve for different constraints
    bc=bct(i,:);
    kk0=kk;     %to temporarily store stiffness matrix  
    kkg0=kkg;   %to temporarily store geometric stiffness matrix
    [nbcd,bcdof,kk0,kkg0] = BoundaryConditions(sdof,bc,kk0,kkg0); %reducing the matrix size by applying constraints

% Buckling load
    [vecebl, ebl] = eig(kk0,kkg0);  %solve the eigenvalue problem for Buckling Loads
    ebl = diag(ebl);

% To Plot Mode Shapes for different BCs
    h = figure;
    set(h,'name','First Buckling Mode Shape','numbertitle','off')
    subplot(1,3,2)
    plotShapes(vecebl,lengthvector,nbcd)   %calling the funtion to plot
    title(bct(i,:));
    hold on;

    pcrth(i,1) = pcrtheory(bc,E,I,tleng);  %theoretical buckling load
    pcrfem(i,1) = ebl(nbcd+1);             %FEM buckling load
    error(i,1) = 100-100*pcrfem(i,1)/pcrth(i,1);             %error(in %)
end

%printing out the final results
fprintf("Results:\n");
for i=1:26
    fprintf("-");
end
fprintf("First Euler Buckling Load(N)");
for i=1:26
    fprintf("-");
end
fprintf("\n  Type of Constraint   Theoretical Value           FEM Value          Error(in %%)\n\n");
for i=1:4
    fprintf("%20s%20f%20f%20f\n",bct(i,:),pcrth(i),pcrfem(i),error(i));
end
for i=1:80
    fprintf("-");
end
fprintf("\n");
%
%convergence test by increasing element numbers
tnel=10;    %final number of elements 
x=2:tnel;   %division of elements starts from 2
y=zeros(1,tnel-1);
for i=1:4     %loop to plot for different constraints
    t=convergenceTest(E,I,tnel,tleng,bct(i,:));   %call function to get the critical load values
    h = figure;
    set(h,'name','Convergence of Critical Buckling Force(in N)','numbertitle','off')
    hold on;
%plot FEM values
    plot(x,t,'-o');
%plot theoretical value
    y(1,:)=pcrth(i);
    plot(x,y,'--*');
    
    xlabel('Number of Elements');
    ylabel('Critical Load(in N)');
    title('Critical Buckling Force vs Number of Elements');
    legend('Critical Load from FEM','Critical Load from Theory');
    lim=1.0005*max(abs(t));
    axis([1,1.05*tnel,0.9995*pcrth(i),lim]);
    axis square;
    grid on;
end