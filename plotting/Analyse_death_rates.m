clear all
close all

load 'data_all_to_April_5'
load populations_30;

load Prem_Mog_Results_QUAR_1to7_lims
load Friston_GCM_1_7

%---- plot features etc.
countries_test = {'Ireland','United Kingdom','Italy','Spain','France','Germany','Switzerland'};
color_7{1} = [0 1 0]; color_7{2} = [0 0 1]; color_7{3} = [1 0 0]; color_7{4} = [1 1 0]; color_7{5} = [1 0 1]; color_7{6} = [0.2 0.2 0.2]; color_7{7} = [0.5 0 0.5];
days      =  [[23:31]     [1:29]     [1:31]     [1:5]];
months    =  [[23:31]*0+1 [1:29]*0+2 [1:31]*0+3 [1:5]*0+4 ];
t         =  [1:length(days)]/7;
days_pred =  [1:180];
t_next    =  [length(days)+1:days_pred(end)]/7;
tpred     =  [t t_next];

%-----------------------------------------------------------------------------------------  fits
for i = 1:7
    
    use_c        = find(countries_hubei==countries_test{i}) ;
    %---- data
    acc_deaths  = cumsum(data_all.deaths_diff(use_c,:));
    Y{i}     = [data_all.cases_diff(use_c,:)', acc_deaths']  ; %% days x 2 [cases per day and accumulated deaths]
    U.u     = zeros(180,1);
    U.dt =1;
     
    %--- countries
    M.f    = @Prem_Moghada_fx2_quar_lim;
    M.g    = @Prem_Moghada_gx_quar;
    M.IS   = 'Initial_state_integrator_prem_mog_quar';
    M.n    = 12;
    M.x    = zeros(12,1);
    M.l    =  2;
    susceptible_popM_country(i)     = ((exp(DCM_Country{i}.Ep.N))/populations(i)) ;
    obs_states_inverted_country{i}  = feval(M.IS,DCM_Country{i}.Ep,M,U);
    
    
    
    %------ spm covid
     M.T                        = 180;
    [Z{i},X{i}]                 = spm_COVID_gen(GCM{i}.Ep,M,4);
    obs_states_inverted_GCM{i}  = Z{i};
    susceptible_popM_country_GCM(i) = (exp(GCM{i}.Ep.N))/populations(i);
    
   
    
end


 color_7=    [0.3718    0.7176    0.3612; ...
    0.2941    0.5447    0.7494;...
    0.9047    0.1918    0.1988;...
    1.0000    0.5482    0.1000;...
    0.8650    0.8110    0.4330;...
    0.6859    0.4035    0.2412;...
    0.9718    0.5553    0.7741;...
    0.6400    0.6400    0.6400;...
    0.6365    0.3753    0.6753];

   figure
for i = 1:7
  
    subplot(2,4,i)
    plot(t,Y{i}(:,2),['ok'])
    hold on
   % plot(tpred ,obs_states_inverted_cities{i}(:,1),'LineStyle','-.','Color',color_7{i})
    plot(tpred ,obs_states_inverted_country{i}(:,2),'LineStyle','--','Color',color_7(i,:),'LineWidth',3)
    plot(tpred ,cumsum(obs_states_inverted_GCM{i}(:,1)),'Color',color_7(i,:),'LineWidth',3)
 
   title([countries_test{i}])
end


  