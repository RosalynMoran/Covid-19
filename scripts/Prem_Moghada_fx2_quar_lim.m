function f = Prem_Moghada_fx2_quar(x,u,P,M) % for spm_int

% https://www.pnas.org/content/pnas/suppl/2020/04/03/2004064117.DCSupplemental/pnas.2004064117.sapp.pdf
% and prem lancet

N0        =  (exp(P.N))*1e6;
%beta      = (0.06*exp(P.beta))*(10*exp(P.k));      % R0 = beta x contacts x 4.6 days = 2.76
beta      = (0.09*exp(P.beta))*(10*exp(P.k));      % R0 = beta x contacts x 4.6 days = 2.76
betaSI      = (0.09*exp(P.beta))*(2*exp(P.k_SI));      % contacts in isolation
gamma     =  (1/4.6)*exp(P.gamma);                  % recovery rate = 1/days_infectious 4.6 from pnas, 3 or 7 from lancet

kappa     = (1/5.2)*exp(P.kappa);  % latency rate 1/(days incubation) - assume 5.2 days
alpha     = (1/2)*exp(P.alpha);     % reduced transmission rate for subclinical cases - a prior one quarter PNAS - one half
alpha = min([alpha 0.5]);

p_clin    =  (1/4)*exp(P.p);      % proportion of cases that are symptomatic - that may or may not need hospitalization
p_clin = min([p_clin 0.5]);

delta     =  (1/7)*exp(P.delta);  % 1/average time from symptom onset to hospitalization


h       = (1/2)*exp(P.h) ;% proportion of clinical cases requiring hospital or ICU
h       = min([h 0.5]);

c       = (1/10)*exp(P.c);   % proportion in hospital requiring ICU- estimate 10% -PNAS 1/100
c       = min([c 0.75]);

mh     = 0.02*exp(P.mh); % weight of death rate among non ICU
mh     = min([mh 0.5]);

muh    = (1/9.7)*exp(P.muh)  ;  % 1/average days from hospitalized non-ICU deaths
phih   = (1/10)*exp(P.phih); % length of hospital stay before recovery

mc   =   0.13*exp(P.mc) ; % weight of death rate among  ICU
mc   = min([mc 0.75]);

muc  =   (1/7)*exp(P.muc)  ; % 1/average days from hospitalized ICU to deaths
phic =   (1/14)*exp(P.phic) ;  % length of ICU stay before reocvery

q    = 0.05*exp(P.q); 
q    = min([q 1]);

fi   = 0.8*exp(P.fi);
fi   = min([fi 1]);

taui = 1*exp(P.taui);
fa   = 0.05*exp(P.fa);
fa   = min([fa 1]);

taua =  (1/2)*exp(P.taua);



% assume all symptomatic / severe cases practice self isolation

S         = x(1); % susceptible
E         = x(2);% exposed
I_NH      = x(3); % infected will not require hospitalization
I_NH_SI   = x(4); % infected will not require hospitalization
I_RH       = x(5);  % infected will Require Hospitalization
I_RH_SI    = x(6);  % infected will Require Hospitalization
I_SC       = x(7);% infected asymotmatic - Sub Clinical
I_SC_SI   = x(8);% infected asymotmatic - Sub Clinical
I_H    = x(9); % Hospitalized NOT n ICU
I_ICU  = x(10); % Hospitalized in the ICU
R      = x(11); % recovered
D      = x(12); % deaths


dS_dt       =  -beta*(S/N0)*(I_NH + I_RH) - alpha*beta*(S/N0)*I_SC...
    -betaSI*(S/N0)*(I_NH_SI + I_RH_SI) - alpha*betaSI*(S/N0)*I_SC_SI;

dE_dt       =  beta*(S/N0)*(I_NH + I_RH)  + alpha*beta*(S/N0)*I_SC ...
    + beta*(S/N0)*(I_NH_SI + I_RH_SI) + alpha*beta*(S/N0)*I_SC_SI- kappa*E;

dI_NH_dt    =  p_clin*(1-q)*(1-h)*kappa*E  -  (1-fi)*gamma*I_NH - (fi)*taui*I_NH;
dI_NH_SI_dt    =  p_clin*q*(1-h)*kappa*E  -  gamma*I_NH_SI +  (fi)*taui*I_NH;

dI_RH_dt     =  p_clin*(1-q)*(h)*kappa*E    -  (1-fi)*delta*I_RH - fi*taui*I_RH; 
dI_RH_SI_dt     =  p_clin*q*(h)*kappa*E    -  delta*I_RH_SI + fi*taui*I_RH;

dI_SC_dt    = (1-p_clin)*kappa*E     - (1-fa)*gamma*I_SC - (fa)*taua*I_SC;
dI_SC_SI_dt    = (fa)*taua*I_SC     - gamma*I_SC_SI;

dH_dt       =  (1-c)*(1-fi)*delta*I_RH +  (1-c)*delta*I_RH_SI  - (mh*muh + (1-mh)*phih)*I_H;   %
dICU_dt     =  c*(1-fi)*delta*I_RH + c*delta*I_RH_SI      - (mc*muc + (1-mc)*phic)*I_ICU; %


dR_dt    =  gamma*(I_SC +  I_NH + I_SC_SI +  I_NH_SI) +  (1-mh)*phih*I_H  + (1-mc)*phic*I_ICU;
dD_dt    =  mh*muh*I_H + mc*muc*I_ICU ;

f =[dS_dt ;...
    dE_dt ;...
    dI_NH_dt;...
    dI_NH_SI_dt;...
    dI_RH_dt;...
    dI_RH_SI_dt;...
    dI_SC_dt;...
    dI_SC_SI_dt;...
    dH_dt;...
    dICU_dt;...
    dR_dt;...
    dD_dt]';


