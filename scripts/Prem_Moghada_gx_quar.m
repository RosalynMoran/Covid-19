function g = Prem_Moghada_gx(x,u,P,M) % for spm_int
 
% S         = x(1); % susceptible
% E         = x(2);% exposed
% I_NH      = x(3); % infected will not require hospitalization
% I_NH_SI   = x(4); % infected will not require hospitalization
% I_RH       = x(5);  % infected will Require Hospitalization
% I_RH_SI    = x(6);  % infected will Require Hospitalization
% I_SC       = x(7);% infected asymotmatic - Sub Clinical
% I_SC_SI   = x(8);% infected asymotmatic - Sub Clinical
% I_H    = x(9); % Hospitalized NOT n ICU
% I_ICU  = x(10); % Hospitalized in the ICU
% R      = x(11); % recovered
% D      = x(12); % deaths
% 
% % assume reported cases are mainly from I_NH and I_H
%  cases  =    0.01*x(5)  +  0.2*x(3) +  x(4); % ten percent of Symptomatic not hospitalised cases tested one percent of Asymptomatic tested

prop_asymp  = 0.01*exp(P.cases_from_SC);
prop_sympNH = 0.2*exp(P.cases_from_NH);
prop_asymp  =  min([prop_asymp, 1]);
prop_sympNH =  min([prop_sympNH, 1]);

cases  =    prop_asymp*(x(7) +x(8))  +   prop_sympNH*(x(3)+x(4)) +  x(5) + x(6); % twenty percent of Symptomatic not hospitalised cases tested one percent of Asymptomatic tested

deaths =  x(12);
g      =  [cases, deaths] ; % cases deaths with case reporting rates, incorporating test rates & death rates

