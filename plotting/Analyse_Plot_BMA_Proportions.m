clear all
close all

load 'data_all_to_April_5'
load populations_30;

%load Prem_Mog_Results_QUAR_CITIES_1to7_lims
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
 

%--------------------------------------------- plot parameters
for i = 1:7

    N0_Ep(i)   =  DCM_Country{i}.Ep.N ;
    N0_Cp(i) = DCM_Country{i}.Cp(1,1) ;
    
    N0_Ep_GCM(i)   =  GCM{i}.Ep.N ;
    N0_Cp_GCM(i) = GCM{i}.Cp(2,2) ;

end

 
ci    = spm_invNcdf(1 - 0.05);
ax    = gca;
colf  = [.8 .8 1];
col   = [1 1/4 1/4];
colB  = [0.6 0.6 0.6];
herd_immunity = 60; % predicted herd immunity
colH  = [0.4 0.7 0.4];
pos = [1 2 4 5 7 8 10 11 13 14 16 17 19 20]; %% LINE N0 Estimates model 1 model 2 , coutnry 1 country 2

figure
sum_prec = 0;

for m = 1:7
    
    N0_plot((m-1)*2+1)      =  (exp(N0_Ep(m)))/populations(m);
    N0_plot((m-1)*2+2)      =  (exp(N0_Ep_GCM(m)))/populations(m);
    N0ci_plot((m-1)*2+1,1)  =  (exp(-ci*sqrt(N0_Cp(m)) + N0_Ep(m)))/populations(m);
    N0ci_plot((m-1)*2+2,1)  =  (exp(-ci*sqrt(N0_Cp_GCM(m)) + N0_Ep_GCM(m)))/populations(m);
    N0ci_plot((m-1)*2+1,2)  =  (exp(ci*sqrt(N0_Cp(m)) + N0_Ep(m)))/populations(m);
    N0ci_plot((m-1)*2+2,2)  =  (exp(ci*sqrt(N0_Cp_GCM(m)) + N0_Ep_GCM(m)))/populations(m);
    
    sum_prec         = sum_prec + (1/(N0_Cp(m))) +  (1/(N0_Cp_GCM(m))) ;
end

weighted_mean_proportion = 0;
for m = 1:7
    weighted_mean_proportion=   weighted_mean_proportion + (N0_plot((m-1)*2+1)*(1/(N0_Cp(m))))/sum_prec +(N0_plot((m-1)*2+2)*(1/(N0_Cp_GCM(m))))/sum_prec ;
end

% bayesian average of all
bar(ax,pos,N0_plot*100,'Edgecolor',colf,'Facecolor',colf);
for k = 1:14
    hold(ax,'on');
    line([pos(k) pos(k)],N0ci_plot(k,:)*100,...
        'LineWidth',4,'Color',col,'Parent',ax);
end
line([0 pos 21],(ones(1,length(pos)+2)*weighted_mean_proportion)*100,...
    'LineWidth',4,'Color',colB,'Parent',ax);
 ylim([0 100])

cycles_for_herd_immunity_average = (60/(weighted_mean_proportion*100)) -1;

for m = 1:7
    use_est(m)                          = max([exp(N0_Ep(m))   exp(N0_Ep_GCM(m))]);
    max_percent(m)                      = (use_est(m)/populations(m))*100;
    cycles_for_herd_immunity_country(m) =  herd_immunity/((use_est(m)/populations(m))*100);
end
cycles_for_herd_immunity_countryf = floor(cycles_for_herd_immunity_country) 
clear ax
clear gca
ax    = gca;
max_per_country =[1 3 5 7 9 11 13];

bar(ax,pos(1:2:end),N0_plot(max_per_country)*100,'Edgecolor',colf,'Facecolor',colf);
 hold(ax,'on');
line([0 pos 21],(ones(1,length(pos)+2)*herd_immunity) ,...
    'LineWidth',4,'Color',colH,'Parent',ax);
 ylim([0 100])

 