% This program is for the naive algorithm implement on the 2nd, 3rd, and
% 4th receiver. Here, as what was discussed as the future works section b.
% No requirement for data in this program
function  [Naive_mCERIM_set,Naive_mCERIM_DOF] = yang_naive_algorithm_all_data(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial)
    %% transfer on the same platform
    for car_counter=2
        temp_timesteps=length(gpssolve.car_counter(car_counter).time); %number of timesteps in this car   

        for time=(1:temp_timesteps)
            if isempty(gpssolve.car_counter(car_counter).time(time).match_time_ref) || ...,
                    gpssolve.car_counter(car_counter).time(time).match_time_ref == 0
                continue;
            end
            match_time = gpssolve.car_counter(car_counter).time(time).match_time_ref;
            match_time_platform.match_time(match_time).p2=gpssolve.car_counter(car_counter).time(time).parity_sd; 
            match_time_platform.match_time(match_time).Q2=gpssolve.car_counter(car_counter).time(time).Q_sd;
        end
    end

    for car_counter=3
        temp_timesteps=length(gpssolve.car_counter(car_counter).time); %number of timesteps in this car   

        for time=(1:temp_timesteps)
            if isempty(gpssolve.car_counter(car_counter).time(time).match_time_ref) || ...,
                    gpssolve.car_counter(car_counter).time(time).match_time_ref == 0
                continue;
            end
            match_time = gpssolve.car_counter(car_counter).time(time).match_time_ref;
            match_time_platform.match_time(match_time).p3=gpssolve.car_counter(car_counter).time(time).parity_sd; 
            match_time_platform.match_time(match_time).Q3=gpssolve.car_counter(car_counter).time(time).Q_sd;
        end
    end

    for car_counter=4
        temp_timesteps=length(gpssolve.car_counter(car_counter).time); %number of timesteps in this car   

        for time=(1:temp_timesteps)
            if isempty(gpssolve.car_counter(car_counter).time(time).match_time_ref) || ...,
                    gpssolve.car_counter(car_counter).time(time).match_time_ref == 0
                continue;
            end
            match_time = gpssolve.car_counter(car_counter).time(time).match_time_ref;
            match_time_platform.match_time(match_time).p4=gpssolve.car_counter(car_counter).time(time).parity_sd; 
            match_time_platform.match_time(match_time).Q4=gpssolve.car_counter(car_counter).time(time).Q_sd;
        end
    end

    %% translate the time
    first_one_third_end_time_match_time = 0;
    last_one_third_start_time_match_time = 0;
    for tran_time = 1:length(gpssolve.car_counter(1).time)
        if first_one_third_end_time == gpssolve.car_counter(1).time(tran_time).gpsTime
            first_one_third_end_time_match_time = tran_time;
        end
        
        if last_one_third_start_time == gpssolve.car_counter(1).time(tran_time).gpsTime
            last_one_third_start_time_match_time = tran_time;
        end
    end
    if first_one_third_end_time_match_time == 0 || last_one_third_start_time_match_time == 0;
        disp('Wrong')
    end
    
    %% calculate the mCERIM
    Naive_mCERIM_set = [];
    Naive_mCERIM_DOF=[];
    for mt=1:length(match_time_platform.match_time)
        %limit the trial
        switch which_part_trial
            case 1
                if mt >= first_one_third_end_time_match_time
                    continue;
                end
            case 2
                if mt > last_one_third_start_time_match_time || ...,
                        mt < first_one_third_end_time_match_time
                    continue;
                end                   
            case 3
                if mt <= last_one_third_start_time_match_time
                    continue;
                end    
            case 4
                if mt >= first_one_third_end_time_match_time && mt <= last_one_third_start_time_match_time 
                    continue;
                end                    
        end
     
        if ~isempty(match_time_platform.match_time(mt).p2)
                %average p
                match_time_platform.match_time(mt).average_p = ...,
                    (match_time_platform.match_time(mt).p2 + match_time_platform.match_time(mt).p3...,
                    + match_time_platform.match_time(mt).p4) *1/3;
                %average Q
                match_time_platform.match_time(mt).average_Q = ...,
                    (match_time_platform.match_time(mt).Q2 + match_time_platform.match_time(mt).Q3 ...,
                    + match_time_platform.match_time(mt).Q4) *1/9;
        else
            continue;
        end
        

        %Naive mCERIM cal
        p_bar=match_time_platform.match_time(mt).average_p;
        Q_bar=match_time_platform.match_time(mt).average_Q;
        match_time_platform.match_time(mt).DOF = length(p_bar); %degree of freedom
        match_time_platform.match_time(mt).Naive_mCERIM = p_bar'/Q_bar*p_bar;
        T=chi2inv(1-1e-5,match_time_platform.match_time(mt).DOF);
        match_time_platform.match_time(mt).Naive_mCERIM_divide_T = match_time_platform.match_time(mt).Naive_mCERIM/T;
        Naive_mCERIM_set = [Naive_mCERIM_set,match_time_platform.match_time(mt).Naive_mCERIM];
        Naive_mCERIM_DOF=[Naive_mCERIM_DOF,length(p_bar)]; 
    end
end