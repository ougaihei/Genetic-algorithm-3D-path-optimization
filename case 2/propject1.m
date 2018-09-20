clc
clear all


%parameter initialize
weight=0.3; %weight for crossover
TARGET_TVD=2000;
TARGET_ALPHA=0;
TARGET_THETA=pi/2;
UPPER_LIMIT=500;
LOWER_LIMIT=-500;
LENGTH=3000;
N=1000;%number of trajectory sections
popSize=200;%population size
ds=LENGTH/N;
tau=1/sqrt(2*sqrt(2));

%initialize population
for i=1:popSize
    population(i)=Trajectory1;
    population(i).length=LENGTH;
    population(i).ds=LENGTH/N;
    population(i).sigma_lambda=normrnd(0,1);
    population(i).sigma_C=normrnd(0,1);
    
    %random generate initial lambda and C
    lambda=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    C=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    while(C-abs(lambda)<=0)
        lambda=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
        C=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    end
    population(i).C=C;
    population(i).lambda=lambda;
    
    %calculate trajectory by current lambda and C, and fitness
    [population(i).alpha population(i).theta population(i).x population(i).y population(i).z population(i).fitness population(i).error_tvd]=trajGenerate(N,TARGET_ALPHA,TARGET_THETA,TARGET_TVD,LENGTH,ds,lambda,C);
    
end

%evolution begins
Gen=1;
figure

while(Gen<=500)
    
    %print generation and best fitness
    fprintf(['Generation: %i \n',...
        'Best fitness: %f \n',...
        ],Gen,population(1).fitness);
    fprintf('-------------------- \n');
    
    
    %Parent select and crossover
    p1Index=randi([1,100]);
    p2Index=randi([1,100]);
    parent1=population(p1Index);
    parent2=population(p2Index);
    offspring1=Trajectory1;
    offspring2=Trajectory1;
    
    offspring1.lambda=weight*parent1.lambda+weight*parent2.lambda;
    offspring1.C=weight*parent1.C+weight*parent2.C;
    offspring1.sigma_lambda=weight*parent1.sigma_lambda+weight*parent2.sigma_lambda;
    offspring1.sigma_C=weight*parent1.sigma_C+weight*parent2.sigma_C;
    
    
    offspring2.lambda=(1-weight)*parent1.lambda+(1-weight)*parent2.lambda;
    offspring2.C=(1-weight)*parent1.C+(1-weight)*parent2.C;
    offspring2.sigma_lambda=(1-weight)*parent1.sigma_lambda+(1-weight)*parent2.sigma_lambda;
    offspring2.sigma_C=(1-weight)*parent1.sigma_C+(1-weight)*parent2.sigma_C;
    
    
    %mutate offsprings sigma first
    offspring1.sigma_lambda=offspring1.sigma_lambda*exp(tau*normrnd(0,1));
    offspring1.sigma_C=offspring1.sigma_C*exp(tau*normrnd(0,1));
    
    offspring2.sigma_lambda=offspring2.sigma_lambda*exp(tau*normrnd(0,1));
    offspring2.sigma_C=offspring2.sigma_C*exp(tau*normrnd(0,1));
    %mutate lambda and C
    offspring1.lambda=offspring1.lambda+offspring1.sigma_lambda*normrnd(0,1);
    offspring1.C=offspring1.C+offspring1.sigma_C*normrnd(0,1);
    
    offspring2.lambda=offspring2.lambda+offspring2.sigma_lambda*normrnd(0,1);
    offspring2.C=offspring2.C+offspring2.sigma_C*normrnd(0,1);
    %evaluate offspring fitness and trajectory
    [offspring1.alpha offspring1.theta offspring1.x offspring1.y offspring1.z offspring1.fitness offspring1.error_tvd]=trajGenerate(N,TARGET_ALPHA,TARGET_THETA,TARGET_TVD,LENGTH,ds,offspring1.lambda,offspring1.C);
    [offspring2.alpha offspring2.theta offspring2.x offspring2.y offspring2.z offspring2.fitness offspring1.error_tvd]=trajGenerate(N,TARGET_ALPHA,TARGET_THETA,TARGET_TVD,LENGTH,ds,offspring2.lambda,offspring2.C);
    
    %survival selection (u+lambda) with replacement
    newpopulation=population;
    newpopulation(popSize+1)=offspring1;
    newpopulation(popSize+2)=offspring2;
    [~,index]=sort([newpopulation.fitness]);
    temp=newpopulation(index);
    population=temp(1:popSize);
    
    %next generation and plot
    Gen=Gen+1;
    if(mod(Gen,50)==0)
    plot3(population(1).x,population(1).y,population(1).z)
    hold on
%     text(population(1).x(N),population(1).y(N),population(1).z(N), sprintf('%i', Gen))
%     hold on
    end
    
    
    
    
end

     plot3(population(1).x,population(1).y,population(1).z,'r')
grid on

