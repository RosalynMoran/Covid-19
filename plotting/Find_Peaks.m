%clear all
close all

load 'data_all_to_April_5'
load populations_30;

load Prem_Mog_Results_QUAR_CITIES_1to7_lims
load Prem_Mog_Results_QUAR_1to7_lims
load Friston_GCM_1_7

%---- plot features etc.
countries_test = {'Ireland','United Kingdom','Italy','Spain','France','Germany','Switzerland'};
days      =  [[23:31]     [1:29]     [1:31]     [1:30]];
months    =  [[23:31]*0+1 [1:29]*0+2 [1:31]*0+3 [1:30]*0+4 ];
t         =  [1:length(days)]/7;
days_pred =  [1:180];
t_next    =  [length(days)+1:days_pred(end)]/7;
tpred     =  [t t_next];
color_7=    [0.3718    0.7176    0.3612; ...
    0.2941    0.5447    0.7494;...
    0.9047    0.1918    0.1988;...
    1.0000    0.5482    0.1000;...
    0.8650    0.8110    0.4330;...
    0.6859    0.4035    0.2412;...
    0.9718    0.5553    0.7741;...
    0.6400    0.6400    0.6400;...
    0.6365    0.3753    0.6753];

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
    F_city_country_GCM(i,:) = [  DCM_Cities{i}.F  DCM_Country{i}.F   GCM{1}.F ];
    
end


 
for i = 1:7
    % over t pred from Jan22nd
   [cases_peak_mog(i)  , cases_peakDk_mog(i) ]  = max(obs_states_inverted_country{i}(:,1));
   [cases_peak_spm(i)  , cases_peakDk_spm(i) ]  = max(obs_states_inverted_GCM{i}(:,2));
end

cases_peakWk_mog = cases_peakDk_mog./7
cases_peakWk_spm = cases_peakDk_spm./7

% from current day April 7th

for i =1:7
cases_peakWk_mog_from_April_7(i) =cases_peakWk_mog(i)- 10.9
cases_peakWk_spm_from_April_7(i) =cases_peakWk_spm(i)- 10.9

day_peak(i)   = days(cases_peakDk_mog(i))
month_peak(i) = months(cases_peakDk_mog(i))

day_spm_peak(i)   = days(cases_peakDk_spm(i))
month_spm_peak(i) = months(cases_peakDk_spm(i))

end


for i = 1:7
    % over t pred from Jan22nd
   [Ds_peak_mog(i)  , Ds_peakDk_mog(i) ]  = max(obs_states_inverted_country{i}(:,2));
   [Ds_peak_spm(i)  , Ds_peakDk_spm(i) ]  = max(cumsum(obs_states_inverted_GCM{i}(:,1)));
end
DODE = Ds_peak_mog/1000
DSPM = Ds_peak_spm/1000