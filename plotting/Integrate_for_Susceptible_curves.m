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
   figure
for i = 1:2
    
    %------ spm covid
    M.T                          = 180;
    [Z{i},X{i}]                  = spm_COVID_gen(GCM{i}.Ep,M,4);
    tmp                          = X{i}{2};
    susceptible_spm              = (tmp(:,1)*exp(GCM{i}.Ep.N))*1e6  ;
    pop_less_susceptible_spm     = susceptible_spm  + (populations(i)*1e6 - susceptible_spm(1)) ;
    
    %---- Moghada
    clear M
    M.f    = @Prem_Moghada_fx2_quar_lim;
    M.g    = []; % GET ALL STATES
    M.IS   = 'Initial_state_integrator_prem_mog_quar';
    M.n    = 12;
    M.x    = zeros(12,1);
    M.l    =  2;
    U.u     = zeros(180,1);
    U.dt    = 1;
    
    all_states_inverted          = feval(M.IS,DCM_Country{i}.Ep,M,U);
    susceptible_mog              = all_states_inverted(:,1);
    pop_less_susceptible         =  susceptible_mog  + (populations(i)*1e6 - susceptible_mog(1));
   
    
 
    subplot(2,1,i)
    plot(t,pop_less_susceptible./(populations(i)*1e4),'LineStyle','--','Color',color_7(i,:),'LineWidth',3)
    hold on
    plot(t,pop_less_susceptible_spm./(populations(i)*1e4),'Color',color_7(i,:),'LineWidth',3)
    ylim([40 100])
  
    
end
