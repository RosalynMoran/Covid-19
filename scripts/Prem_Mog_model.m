function [M, P] = Prem_Mog_model(countries)
        
        load populations_30;
        M.f    = @Prem_Moghada_fx2_quar_lim;
        M.g    = @Prem_Moghada_gx_quar;
        M.IS   = 'Initial_state_integrator_prem_mog_quar';
        M.n    = 12;
        M.x    = zeros(12,1);
        M.l    =  2;

        % initial conditions before integration - estimate
        P.N          = log(1); % 1 million susceptible community
        P.initialE   = log(100);
        P.initialNH  = log(100);
        P.initialH   = log(100);
        P.initialSC  = log(100);

        % model parameters - scaling real vaues in fx
        P.beta  = 0 ;
        P.k     = 0 ;     % R0 = beta x contacts x 4.6 days = 2.3
        P.gamma = 0 ;                 % recovery rate = 1/days_infectious 4.6 from pnas, 3 or 7 from lancet
        P.kappa = 0 ;  % latency rate 1/(days incubation) - assume 5.2 days
        P.alpha= 0 ;     % reduced transmission rate for subclinical cases - a prior one quarter PNAS - one half
        P.p     = 0 ;     % proportion of cases that are symptomatic - that may or may not need hospitalization
        P.delta = 0 ;  % 1/average time from symptom onset to hospitalization
        P.h    = 0 ;% proportion of clinical cases requiring hospital or ICU
        P.c    = 0 ;  % proportion in hospital requiring ICU- estimate 10% -PNAS 1/100
        P.mh   = 0 ;% weight of death rate among non ICA
        P.muh  = 0 ;   % 1/average days from hospitalized non-ICU deaths
        P.phih = 0 ; % length of hospital stay before recovery
        P.mc   = 0 ; % weight of death rate among  ICU
        P.muc  = 0 ; % 1/average days from hospitalized ICU to deaths
        P.phic = 0 ; % length of ICU stay before reocvery
        P.cases_from_SC = 0;
        P.cases_from_NH = 0;
        P.q    = 0;
        P.fi   = 0;
        P.taui = 0;
        P.fa   = 0;
        P.taua = 0;
        P.k_SI  = 0;
        P.no_cities = populations(countries);

        M.P      = P;
        M.pE     = P;
        M.pC     = eye(length(spm_vec(P)))*(1/2);
        M.pC(end,end) =0;
        M.hE     =  2;
        M.hC     =  1;

    end