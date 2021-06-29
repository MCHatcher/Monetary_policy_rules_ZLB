%Monetary policy rules and the zero lower bound
%Svensson (1997, 1999) Inflation forecast targeting model
%The natural rate is assumed to 1, or 0 in logs, so
%that the output gap equals log output
%Written by Michael Hatcher in 2014

clear; clc;

%-------------------------
% 1. Calibration
%------------------------
beta_y = 0.5;      %output persistence
beta_r = 0.1;      %interest rate elasticity of output; based on Rudebusch and Svensson (1999, NBER WP 6512)
alpha_pi = 0.5;    %inflation persistence
alpha_y = 0.15;     %Phillips curve slope; based on Rudebusch and Svensson (1999)
pistar = 0.02;      %inflation target
lambda = 0.5;       %weight on output gap in social loss function

%Initial values

y(1) = 0;           %output gap
pi(1) = pistar;     %inflation
R(1) = pistar;      %nominal interest rate
p(1) = 1;           %price level (in logs)
pstar(1) = 1;       %target price level in period 1 (in logs)

%All variables above are assumed to be at equilibrium to begin with

%Shock standard deviations
sd_eps = 0.008; %based loosely on Rudebusch and Svensson (1999)    
sd_eta = 0.008; %based loosely on Rudebusch and Svensson (1999)
sd_mu = 0.005;

%Simulation parameters
nsim = 1000; %no. of simulations
nper = 1550; %no. of periods per simulation

%Vectors with all simulated values
Loss_stack = [];
count_stack = [];
pi_stack = [];
y_stack = [];

%Model simulations

for j=1:nsim
    

for t=2:nper
    
    count(t) = 0;
    
    eps(t) = randn*sd_eps;
    
    eta(t) = randn*sd_eta;
    
    mu(t) = randn*sd_mu;
    
    pi(t) = alpha_pi*pi(t-1) + (1-alpha_pi)*pistar + alpha_y*y(t-1) + eps(t);
    
    p(t) = pi(t) + p(t-1);
    
    pstar(t) = pstar(1) + pistar*(t-1); %Target price level
    
    y(t) = beta_y*y(t-1) - beta_r*(R(t-1) - alpha_pi*pi(t-1) - (1-alpha_pi)*pistar) + eta(t);  
    
    %Taylor rules for monetary policy (Coefficients were chosen optimally)
    
    %IT Taylor rule
    %R(t) = pistar + 0.5*(pi(t) - pistar) + 4.4*y(t) + mu(t);
    
    %NGDP growth targeting Taylor rule
    %R(t) = pistar + 2.2*(pi(t) + y(t) - y(t-1) - pistar) + mu(t);
    
    %NGDP_level Taylor rule
    %R(t) = pistar + 0.1*(y(t) + p(t) - pstar(t)) + mu(t);
    
    %PT Taylor rule
    R(t) = pistar + 0.1*(p(t) - pstar(t)) + 4.85*y(t) + mu(t);
    
    %--------------------
    %Subloop for ZLB contraint
    if R(t) < 0
        R(t) = 0;
        count(t) = 1;
    end
    %--------------------
    
    Loss(t) = -1*( (pi(t) - pistar)^2 + lambda*y(t)^2 );
     
end

    %The first 50 values of each simulation are dropped to randomise initial conditions
    
   Loss_stack = [Loss_stack; Loss(51:nper)'];
   count_stack = [count_stack; count(51:nper)'];
   pi_stack = [pi_stack; pi(51:nper)'];
   y_stack = [y_stack; y(51:nper)'];
    
end
    

Social_welfare = mean(Loss_stack);
Prob_ZLB = mean(count_stack);
vpi = var(pi_stack);
vy = var(y_stack);