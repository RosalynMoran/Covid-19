
load 'data_all_to_April_5'

% This data be generated with 'Invert_DEM_COVID.m'
load 'Friston_GCM_1_7'
% This data be generated with 'Invert_Prem_Mog.m'
load 'Prem_Mog_1_7'

% Extract countries from data_all source
cases_idx_eire = find(countries_hubei=='Ireland');
cases_idx_uk    = find(countries_hubei=='United Kingdom');

% Specify 'cases'
Y_eire = data_all.cases_diff(cases_idx_eire,:)'; % cases per day
Y_uk = data_all.cases_diff(cases_idx_uk,:)'; % cases per day

% See 'Invert_' scripts for country specific indices
Friston_DCM_eire = GCM{1};
Friston_DCM_UK   = GCM{2};
MOGH_DCM_eire    = DCM_Country{1};
MOGH_DCM_UK      = DCM_Country{2};

% Generate case predictions from (Friston) COVID model
[FDCM_Z_eire,~]  = spm_COVID_gen(Friston_DCM_eire.Ep,Friston_DCM_eire.M,4);
FDCM_cases_eire = FDCM_Z_eire(:,2);

[FDCM_Z_eire,~]  = spm_COVID_gen(Friston_DCM_UK.Ep,Friston_DCM_UK.M,4);
FDCM_cases_UK = FDCM_Z_eire(:,2);

% Generate case predictions from (Moghadas) COVID model
MOGH_IS   = 'Initial_state_integrator_prem_mog_quar';
U.u = zeros(180,1);
[M, ~]    = Prem_Mog_model(1); % Ireland
MOGH_cases_eire = feval(MOGH_IS,MOGH_DCM_eire.Ep, M, U);
[M, ~]    = Prem_Mog_model(2); % UK
MOGH_cases_UK   = feval(MOGH_IS,MOGH_DCM_UK.Ep,   M, U);

subplot(1,2,1)
hold on
plot(FDCM_cases_eire,'b','LineWidth',2)
plot(MOGH_cases_eire(:,1),'k','LineWidth',2)
plot(Y_eire,'r','LineWidth',2)
xlabel('Time (days)'),ylabel('Number of Cases')
title('Predicted Cases - Ireland')
legend('Friston','Moghadan', 'True')

subplot(1,2,2)
hold on
plot(FDCM_cases_UK,'b','LineWidth',2)
plot(MOGH_cases_UK(:,1),'k','LineWidth',2)
plot(Y_uk, 'r','LineWidth',2)
xlabel('Time (days)'),ylabel('Number of Cases')
title('Predicted Cases - UK')
legend('Friston','Moghadan', 'True')