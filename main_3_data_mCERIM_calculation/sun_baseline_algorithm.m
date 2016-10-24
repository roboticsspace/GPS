% This program is for the baseline algorithm implement on the 2nd, 3rd, and
% 4th receiver. Here, parity vector with length equal to 4 is chosen. Only
% receiver 2, and 4 are considered in the usual case. Receiver 3 is
% considered when 2 is not avaible.
function Baseline_mCERIM_set = sun_baseline_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial)
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
    Baseline_mCERIM_set = [];
    temp = 0;
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
            
        if isempty(match_time_platform.match_time(mt).p4) || ...,
                length(match_time_platform.match_time(mt).p4) ~= 4
            temp = temp +1;
            continue;
        elseif ~isempty(match_time_platform.match_time(mt).p2) && ...,
                length(match_time_platform.match_time(mt).p2) == 4
                %calculate the parity square for this one
                p4=match_time_platform.match_time(mt).p4;
                p2=match_time_platform.match_time(mt).p2;
                Q4=match_time_platform.match_time(mt).Q4;
                Q2=match_time_platform.match_time(mt).Q2;
                mCERIM = p4'/Q4*p4 + p2'/Q2*p2;
                match_time_platform.match_time(mt).Base_mCERIM = mCERIM;             
        elseif ~isempty(match_time_platform.match_time(mt).p3) && ...,
                length(match_time_platform.match_time(mt).p3) == 4
                %calculate the parity square for this one
                p4=match_time_platform.match_time(mt).p4;
                p3=match_time_platform.match_time(mt).p3;
                Q4=match_time_platform.match_time(mt).Q4;
                Q3=match_time_platform.match_time(mt).Q3;
                mCERIM = p4'/Q4*p4 + p3'/Q3*p3;
                match_time_platform.match_time(mt).Base_mCERIM = mCERIM;
        else
            continue;
        end
        %Baseline mCERIM cal
        Baseline_mCERIM_set = [Baseline_mCERIM_set,match_time_platform.match_time(mt).Base_mCERIM];
    end
end    
