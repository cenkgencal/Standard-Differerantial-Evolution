% --------------  Differential Evolution  -------------------------------
% This is the classic differential evolution algorithm that utilize the strategy
% of DE/rand/1/bin.
% ------------------------ Inputs --------------------------------
% popsize                       : Size of the population
% maxIter                       : Number of generations
% CR                            : Crossover Rate
% F                             : Mutation Factor
% GC(Gene_constraints)          : This parameter has 2*n parameters,
% where n is the #gene, which are;
%           ul : upper limit of the range 
%           ll : lower limit of the range
% GC must be like "[ ul1 ul2
%                    ll1  ll2  ]" if every individual has 2 genes.
% f_name                        : The name of objective function which must
% be entered like 'function name'.
% -----------------------------------------------------------------

% ------------------------ Outputs ----------------------------------
% mincost                       : The found minimum fitness value
% member                        : The individual having mincost value
% bests                         : All bests throughout iterations
% -------------------------------------------------------------------

function [mincost,member,bests]=DE(popsize, maxIter,CR,F,GC,f_name,seed)

rng(seed);
% As an example, you can call the function like;
% [mincost,member,bests]=de(100,100,0.7,0.8,[5 5;-5 -5],'dejong')

n=size(GC,2);

%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%  
pop=ones(popsize,n);

% By using uls and lls in GC, we can create our population
for i=1:n
    pop(:,i)=unifrnd(GC(2*i),GC(2*i-1),popsize,1);
end

% Calculate fitness values of each individual
cost=feval(f_name,pop(:,1),pop(:,2));
% Depends on n, you can write this equality as follows;
% cost=feval(f_name,pop(:,1),pop(:,2),...,pop(:,n) )

% Create the matrix "bests" which is one of our outputs
bests=zeros(maxIter,1);

% For plotting
% iter= 1:maxIter;

count=maxIter;

while maxIter>0
    
    %%%%%%%% Mutation %%%%%%%%
    
    % Randomly choose 3 individuals for each member of the population
    rnd_in=df_vls(popsize);
    
    % Donor vectors for each individual 
    donor=(pop(rnd_in(:,1),:)-pop(rnd_in(:,2),:))*F+pop(rnd_in(:,3),:);
    % (DE/rand/1/bin)
    
    %%%%%%%% Recombination %%%%%%%%
    
    Irand=round(1+(n-1)*rand(popsize,n));
    
    % Define trial vector
    trial=zeros(popsize,n);
    random=rands(popsize,1);
    for i=1:popsize
        for j=1:n
            if random(i)<=CR || j==Irand(i,j)
                trial(i,:)=donor(i,:);
            else
                trial(i,:)=pop(i,:);
            end
        end
    end
    
    %%%%%%%% Selection %%%%%%%%
    new_cost=feval(f_name,trial(:,1),trial(:,2));
    new_pop=ones(popsize,n);
    
    for k=1:popsize
    % For minimization (if you want to maximize, change inequality as ">")
        if cost(k)<=new_cost(k)
            new_pop(k,:)=pop(k,:);
        else
            new_pop(k,:)=trial(k,:);
        end
    end
    
    maxIter=maxIter-1;
    
    % Finding the best for each iteration
    index=count-maxIter;
    cost=feval(f_name,new_pop(:,1),new_pop(:,2));
    [val,~]=min(cost);
    bests(index)=val;
    
    % Return the new population to the next generation
    pop=new_pop;
end

% Show min value at the end
newcost=feval(f_name,pop(:,1),pop(:,2));
[mincost,in]=min(newcost);
member=pop(in,:);

% For plotting
% figure;
% semilogy(iter,bests,'b');
% xlabel('Iterations');
% ylabel('Best Value');
