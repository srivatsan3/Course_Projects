% main 
clear
clc

% controling paramters of the GA algortihm
Problem.obj = @Sphere;
Problem.nVar = 18;

M = 20; % number of chromosomes (cadinate solutions)
N = Problem.nVar;  % number of genes (variables)
MaxGen = 10;
Pc = 0.85;
Pm = 0.01;
Er = 0.05;
visualization = 1; % set to 0 if you do not want the convergence curve 

[BestChrom]  = GeneticAlgorithm (M , N, MaxGen , Pc, Pm , Er , Problem.obj , visualization)

disp('The best chromosome found: ')
gene = BestChrom.Gene
disp('The best fitness value: ')
BestChrom.Fitness

mat = decoder_array(gene);
design_mat0 = mat(1,:);
design_mat0 = design_mat0';

run MAIN_CODE.m