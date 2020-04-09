% Integrate SEIRs model
% see Prem et al Lancet 2020

% /Users/k1775598/OneDrive - King's College London/Predicting_the_Future_Cardiff/FromNanServerforRosalind/spm12/spm.m
clear all
close all
 

load 'data_all_to_April_5'
load populations_30;

load Prem_Mog_Results_QUAR_1to7_lims
load Friston_GCM_1_7

color_7=    [0.3718    0.7176    0.3612; ...
    0.2941    0.5447    0.7494;...
    0.9047    0.1918    0.1988;...
    1.0000    0.5482    0.1000;...
    0.8650    0.8110    0.4330;...
    0.6859    0.4035    0.2412;...
    0.9718    0.5553    0.7741;...
    0.6400    0.6400    0.6400;...
    0.6365    0.3753    0.6753];


t = [1:180]/7;
 
for i = 1:7
    
    % incubation period
    days_inc(i,1) =   exp(GCM{i}.Ep.Tin); % or 1/(exp(-1/P.Tin);)
    days_inc(i,2) =   1/((1/5.2)*exp(DCM_Country{i}.Ep.kappa));
    
    % infectious /symptomatic period
    days_inf(i,1) =   exp(GCM{i}.Ep.Tcn); % or 1/(exp(-1/P.Tin);)
    days_inf(i,2) =   1/((1/4.6)*exp(DCM_Country{i}.Ep.gamma));
    
    % symptomatic period
    days_inf(i,3) =   exp(GCM{i}.Ep.Tsy); % or 1/(exp(-1/P.Tsy);)
    

    % Probabilty of symptoma and  Severe symptoms
    prob_symp(i,1) = GCM{i}.Ep.dev;
    prob_symp(i,2) = (1/4)*exp(DCM_Country{i}.Ep.p);      % proportion of cases that are symptomatic - that may or may not need hospitalization
    
    prob_sev(i,1)  =  GCM{i}.Ep.sev;   %h  = min([h 0.5]);% proportion in hospital requiring ICU- estimate 10% -PNAS 1/100
    if (1/2)*exp(DCM_Country{i}.Ep.h)  <0.5
    prob_sev(i,2)  =  (1/2)*exp(DCM_Country{i}.Ep.h) ;% proportion of clinical cases requiring hospital or ICU
    else
        prob_sev(i,2)  =0.5  ; 
    end
    if  (1/10)*exp(DCM_Country{i}.Ep.c)  <0.75
    prob_sev(i,3)  = (1/10)*exp(DCM_Country{i}.Ep.c);   % OR proportion in hospital requiring ICU- estimate 10% -PNAS 1/100
    else
         prob_sev(i,3)  = 0/75;
    end
  
    
    % death probabilities at home hospital
    % Pfat = exp(P.fat);      % P(fatality | CCU)
    % P(survival | home)
    % Psur = exp(P.sur)
    prob_death_home_hosp(i,1)= (1-  exp(GCM{i}.Ep.sur)); %mh:  weight of death rate among non ICU
    if  0.02*exp(DCM_Country{i}.Ep.mh) <0.5
    prob_death_home_hosp(i,2)=  0.02*exp(DCM_Country{i}.Ep.mh)   ; %mh:  weight of death rate among non ICU - BUT TIME WIEGHTED %(1/9.7)*exp(P.muh)  ;  % 1/average days from hospitalized non-ICU deaths
    else
        prob_death_home_hosp(i,2)= 0.5;
    end
    
    % death probabilities at home hospital
    prob_death_ICU(i,1)=  exp(GCM{i}.Ep.fat );
 
    %mc = min([mc 0.75]);
    if  0.13*exp(DCM_Country{i}.Ep.mc) <0.75
           prob_death_ICU(i,2)=  0.13*exp(DCM_Country{i}.Ep.mc)   ; %mc:  weight of death rate among non ICU  - BUT TIME WIEGHTED  (1/7)*exp(P.muc)  ; % 1/average days from hospitalized ICU to deaths
    else
         prob_death_ICU(i,2)= 0.75   ;
    end
    
    % transmission prob
    prob_transmission(i,1)  = GCM{i}.Ep.trn;
    prob_transmission(i,2)  = (0.09*exp(DCM_Country{i}.Ep.beta)); % symptomatic
    if (1/2)*exp(DCM_Country{i}.Ep.alpha) <0.5
    prob_transmission(i,3)  =  (0.09*exp(DCM_Country{i}.Ep.beta))*(1/2)*exp(DCM_Country{i}.Ep.alpha);% aymsptomaic 
    else
        prob_transmission(i,3)  = 0.5;% aymsptomaic 
    end
    % beta      = (0.09*exp(P.beta))*(10*exp(P.k));      % R0 = beta x contacts x 4.6 days = 2.76
    % betaSI      = (0.09*exp(P.beta))*(2*exp(P.k_SI));      % contacts in isolation
    % alpha     = (1/2)*exp(P.alpha);     % reduced transmission rate for subclinical cases - a prior one quarter PNAS - one half
    % alpha = min([alpha 0.5]);
    
    % contacts 'work'/normals
    k_out(i,1) =  GCM{i}.Ep.Rou;
    k_out(i,2) = (10*exp(DCM_Country{i}.Ep.k));
  
      
     % contacts isolated
     k_in(i,1) =  GCM{i}.Ep.Rin;
     k_in(i,2) = (2*exp(DCM_Country{i}.Ep.k_SI));
    
end


 % incubation period
 figure
 plot( days_inc(:,1), days_inc(:,2),'ok')
 hold on
 plot(mean(days_inc(:,1)),mean(days_inc(:,2)),'xr')
 
    
    % infectious /symptomatic period
 figure
 plot( days_inf(:,1), days_inf(:,2),'ok')
 hold on
 plot(mean(days_inf(:,1)),mean(days_inf(:,2)),'xr')
 
 
    
 % Probabilty of symptoma and  Severe symptoms
 figure
 plot(exp(prob_symp(:,1)), (prob_symp(:,2)),'ok')
 hold on
 plot(mean(exp(prob_symp(:,1))),mean(prob_symp(:,2)),'xr')
 
 % Probabilty of symptoma and  Severe symptoms
 figure
 plot(exp(prob_sev(:,1)), prob_sev(:,3),'ok')
 hold on
 plot(mean(exp(prob_sev(:,1))),mean(prob_sev(:,3)),'xr')
 
 
 % transmission prob beta
 figure
 plot(exp(prob_transmission(:,1)), prob_transmission(:,2),'ok')
 hold on
 plot(mean(exp(prob_transmission(:,1))),mean(prob_transmission(:,2)),'xr')
 
 % contacts 'work'/normals
 figure
 plot(exp(k_out(:,1)), k_out(:,2),'ok')
 hold on
 plot(mean(exp(k_out(:,1))),mean(k_out(:,2)),'xr')
 
 % contacts 'work'/normals
 figure
 plot(exp(k_in(:,1)), k_in(:,2),'ok')
 hold on
 plot(mean(exp(k_in(:,1))),mean(k_in(:,2)),'xr')
 
      
 
 % fatalities
 
 
 figure
 plot( (prob_death_ICU(:,1)), prob_death_ICU(:,2),'ok')
 hold on
 plot(mean( (prob_death_ICU(:,1))),mean(prob_death_ICU(:,2)),'xr')
  