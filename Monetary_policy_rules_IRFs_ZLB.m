%Monetary policy rules and the zero lower bound - impulse responses
%Svensson (1997, 1999) Inflation forecast targeting model
%The natural rate is assumed to 1, or 0 in logs, so
%that the output gap equals log output
%Written by Michael Hatcher in 2014

clear; clc;

%-------------------------
% 1. Calibration
%------------------------
beta_y = 0.5;      %output persistence
beta_r = 0.1;      %interest rate elasticity of output
alpha_pi = 0.5;    %inflation persistence
alpha_y = 0.15;     %Phillips curve slope
pistar = 0.02;      %inflation target
lambda = 0.5;       %weight on output gap in social loss function

%Initial values
y(1) = 0;           %output gap
pi(1) = pistar;     %inflation
R(1) = pistar;      %nominal interest rate
p(1) = 1;           %price level (in logs)
pstar(1) = 1;       %target price level (in logs)

%Simulation parameters
nper = 13; %no. of periods per simulation

eps = [0 -0.1 0 0 0 0 0 0 0 0 0 0 0]'; %This vector specifies a one-off negative demand shock

%Model simulations    

for t=2:nper
    
    pi(t) = alpha_pi*pi(t-1) + (1-alpha_pi)*pistar + alpha_y*y(t-1);
    
    p(t) = pi(t) + p(t-1);
    
    pstar(t) = pstar(1) + pistar*(t-1); %Target price level
    
    y(t) = beta_y*y(t-1) - beta_r*(R(t-1) - alpha_pi*pi(t-1) - (1-alpha_pi)*pistar) + eps(t);  
    
    %Taylor rules for monetary policy
    
    %IT Taylor rule
    %R(t) = pistar + 0.5*(pi(t) - pistar) + 4.4*y(t);
    
    %Nominal GDP targeting Taylor rule
    %R(t) = pistar + 2.2*(pi(t) + y(t) - y(t-1) - pistar);
    
    %NGDP_level Taylor rule
    %R(t) = pistar + 0.1*(y(t) + p(t) - pstar(t));
    
    %PT Taylor rule
    R(t) = pistar + 0.1*(p(t) - pstar(t)) + 4.85*y(t);
    
    %Uncomment this bit to impose the ZLB 
    if R(t) < 0
        R(t) = 0;
    end
    
end

hold on,
plot(pi(2:nper))
plot(y(2:nper))
plot(R(2:nper))
%plot(1:nper, p(1:nper)-pstar(1:nper))