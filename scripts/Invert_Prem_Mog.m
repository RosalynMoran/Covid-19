% Integrate SEIRs model
% see Prem et al Lancet 2020

% /Users/k1775598/OneDrive - King's College London/Predicting_the_Future_Cardiff/FromNanServerforRosalind/spm12/spm.m
clear all
close all
 
load 'data_all_to_April_5'
countries_test = {'Ireland','United Kingdom','Italy','Spain','France','Germany','Switzerland'};
load populations_30;

for countries = 1:7
    
    use_c        = find(countries_hubei==countries_test{countries}) ;
    %---- data
    acc_deaths  = cumsum(data_all.deaths_diff(use_c,:));
    Y.y{1}      = [data_all.cases_diff(use_c,:)', acc_deaths']  ; %% days x 2 [cases per day and accumulated deaths]
    
    U.u     = zeros(length(acc_deaths),1);
    U.dt    = 1;
    
    [M, P] = Prem_Mog_model(countries);
    
    [Ep,Cp,Eh,F,L,dFdp,dFdpp] = spm_nlsi_GN(M,U,Y);
    
    DCM.Ep    = Ep;
    DCM.Cp    = Cp;
    DCM.Eh    = Eh;
    DCM.F     = F;
    DCM.L     = L;
    DCM.dFdp  = dFdp;
    DCM.dFdpp = dFdpp;
    
    U.u     = zeros(180,1);
    obs_states_inverted   = feval(M.IS,EpU);              % prediction of all final states
    
    DCM.fits = obs_states_inverted;
    DCM.M = M;
    DCM_Prem_Moghada{countries} = DCM;
  
      
    figure
    plot(Y.y{1}(:,1))
    hold on
    plot(obs_states_inverted(:,1),'--r')
    title('cases')
    
    figure
    plot(Y.y{1}(:,2))
    hold on
    plot(obs_states_inverted(:,2),'--m')
    title('deaths')
end

save('Prem_Mog_1_7') 
  