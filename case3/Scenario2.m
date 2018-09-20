clc
clear all

tic
%parameter initialize
UPPER_LIMIT=100000;
LOWER_LIMIT=-100000;
popSize=200;%population size
offspSize=1400;

n=4;
tau=1/sqrt(2*sqrt(n));
sigma=1;
%initialize population
for i=1:popSize
    population(i)=Trajectory1;
    population(i).sigma_lambda(1)=normrnd(0,sigma);
    population(i).sigma_lambda(2)=normrnd(0,sigma);
    population(i).sigma_lambda(3)=normrnd(0,sigma);
    population(i).sigma_lambda(4)=normrnd(0,sigma);
    
    %random generate initial lambda values
    lambda1=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    lambda2=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    lambda3=randi([LOWER_LIMIT,UPPER_LIMIT])+rand;
    lambda4=randi([0,UPPER_LIMIT])+rand;
    population(i).lambda(1)=lambda1;
    population(i).lambda(2)=lambda2;
    population(i).lambda(3)=lambda3;
    population(i).lambda(4)=lambda4;
    
    %calculate trajectory by current lambda and C, and fitness
    [population(i).alpha population(i).theta population(i).x population(i).y population(i).z population(i).fitness]=trajGenerate3(lambda1,lambda2,lambda3,lambda4);
    
end

%evolution begins
Gen=1;
figure
best=population(1);
while(Gen<=200)
    
    %print generation and best fitness
    fprintf(['Generation: %i \n',...
        'Best fitness: %f \n',...
        ],Gen,best.fitness);
    fprintf('-------------------- \n');
    
    %generate offsprings
    count=0;
    while(count<offspSize)
        %Parent select and crossover
        p1Index=randi([1,popSize]);
        p2Index=randi([1,popSize]);
        parent1=population(p1Index);
        parent2=population(p2Index);
        offspring1=parent1;
        offspring2=parent2;
        crossover_point1=randi([1,n]);
        crossover_point2=randi([1,n]);
        for i=1:n
            if(i<=crossover_point1)
                offspring1.lambda(i)=parent1.lambda(i);
                offspring2.lambda(i)=parent2.lambda(i);
            else
                offspring1.lambda(i)=parent2.lambda(i);
                offspring2.lambda(i)=parent1.lambda(i);
            end
            if(i<=crossover_point2)
                offspring1.sigma_lambda(i)=parent1.sigma_lambda(i);
                offspring2.sigma_lambda(i)=parent2.sigma_lambda(i);
            else
                offspring1.sigma_lambda(i)=parent2.sigma_lambda(i);
                offspring2.sigma_lambda(i)=parent1.sigma_lambda(i);
            end
        end
        
        
        %mutate offsprings sigma first, then lambda values
        for i=1:n
            offspring1.sigma_lambda(i)=offspring1.sigma_lambda(i)*exp(tau*normrnd(0,sigma));
            offspring1.lambda(i)=offspring1.lambda(i)+offspring1.sigma_lambda(i)*normrnd(0,sigma);
            
            offspring2.sigma_lambda(i)=offspring2.sigma_lambda(i)*exp(tau*normrnd(0,sigma));
            offspring2.lambda(i)=offspring2.lambda(i)+offspring2.sigma_lambda(i)*normrnd(0,sigma);
        end
        
        %evaluate offspring fitness and trajectory
        [offspring1.alpha offspring1.theta offspring1.x offspring1.y offspring1.z offspring1.fitness]=trajGenerate3(offspring1.lambda(1),offspring1.lambda(2),offspring1.lambda(3),offspring1.lambda(4));
        [offspring2.alpha offspring2.theta offspring2.x offspring2.y offspring2.z offspring2.fitness]=trajGenerate3(offspring2.lambda(1),offspring2.lambda(2),offspring2.lambda(3),offspring2.lambda(4));
        
        offsprings(count+1)=offspring1;
        offsprings(count+2)=offspring2;
        count=count+2;
    end
    
    %survival selection (u+lambda) with replacement
%     newpopulation=[population offsprings];
%     [~,index]=sort([newpopulation.fitness]);
%     temp=newpopulation(index);
%     population=temp(1:popSize);
[~,index]=sort([offsprings.fitness]);
temp=offsprings(index);
    if(temp(1).fitness<best.fitness)
        best=temp(1);
    end
    population=temp(1:popSize);
    
    %store values
    bestFitness(Gen)=population(1).fitness;
    sigmas(Gen,:)=population(1).sigma_lambda;


    %next generation and plot
    Gen=Gen+1;
    if(mod(Gen,10)==0)
        plot3(population(1).x,population(1).y,population(1).z)
        hold on
    end
    
    
end
toc
plot3(population(1).x,population(1).y,population(1).z,'r')
hold on
plot3(1400,1400,-2000,'r*');
grid on

figure
plot(bestFitness)

figure
plot(sigmas(:,1),'r')
hold on
plot(sigmas(:,2),'g')
hold on
plot(sigmas(:,3),'b')
hold on
plot(sigmas(:,4),'k')

