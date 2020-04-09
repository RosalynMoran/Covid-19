function [y] = Initial_state_integrator_prem_mog(P,M,U)

N_pop      =  (exp(P.N))*1e6;
N_E       =  exp(P.initialE);
N_NH       =  exp(P.initialNH);
N_H        =  exp(P.initialH);
N_SC       =  exp(P.initialSC);

% S         = x(1); % susceptible
% E         = x(2);% exposed
% I_NH      = x(3); % infected will not require hospitalization
% I_NH_SI   = x(4); % infected will not require hospitalization Self
% isolation
% I_RH       = x(5);  % infected will Require Hospitalization
% I_RH_SI    = x(6);  % infected will Require Hospitalization
% I_SC       = x(7);% infected asymotmatic - Sub Clinical
% I_SC_SI   = x(8);% infected asymotmatic - Sub Clinical
% I_H    = x(9); % Hospitalized NOT n ICU
% I_ICU  = x(10); % Hospitalized in the ICU
% R      = x(11); % recovered
% D      = x(12); % deaths
% 

M.x    = zeros(12,1); % for correct size
M.x(1) = N_pop  ;
M.x(2) = N_E ;
M.x(3) = N_NH ;
M.x(5) = N_H ;
M.x(7) = N_SC ;
 
y       = spm_int_ode(P,M,U);
 