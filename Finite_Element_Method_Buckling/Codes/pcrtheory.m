function [pcr] = pcrtheory(bc,E,I,L)
%--------------------------------------------------------------------------------------
% Purpose :                                                                
%         To find Critical Euler Buckling load for the boundary conditions from theory  
%
% Synopsis : 
%          [pcr] = pcrtheory(bc,E,I,L)
% 
% Variable Description:
% INPUT parameters:
%           bc : type of constraint
%           E : Young's Modulus
%           I : Second Moment of Area
%           L : length of the beam
%
% OUTPUT PARAMETERS :
%           pcr : stores the theoretical critical load value
%--------------------------------------------------------------------------

if(bc=='c-c')                                   
    pcr=pi^2*E*I/(0.5*L)^2;   %pcr for clamped-clamped
    
elseif(bc=='c-s')
    pcr=pi^2*E*I/(0.7*L)^2;   %pcr for clamped-supported
    
elseif(bc=='c-f')
    pcr=pi^2*E*I/(2*L)^2;     %pcr for clamped-free
    
elseif(bc=='s-s') 
    pcr=pi^2*E*I/(1*L)^2;     %pcr for supported-supported
end
end