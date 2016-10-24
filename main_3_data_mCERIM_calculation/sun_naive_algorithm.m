% This program is for the naive algorithm implement on the 2nd, 3rd, and
% 4th receiver. Here, parity vector with length equal to 4 is chosen. Only
% receiver 2, and 4 are considered in the usual case. Receiver 3 is
% considered when 2 is not avaible.
function [Naive_mCERIM_set,all_p4,all_p4_ns] = sun_naive_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial)
    %% transfer on the same platform
    all_p4=[];
    all_p4_ns=[];
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
            %extra plotting
            match_time_platform.match_time(match_time).p2_ns=gpssolve.car_counter(car_counter).time(time).parity_no_difference;
            Q2=gpssolve.car_counter(car_counter).time(time).Q_sd;
            L2=chol(Q2,'lower');
            y2=L2\gpssolve.car_counter(car_counter).time(time).parity_sd;
            match_time_platform.match_time(match_time).y2=y2;
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
            %extra plotting
            match_time_platform.match_time(match_time).p3_ns=gpssolve.car_counter(car_counter).time(time).parity_no_difference;
            Q3=gpssolve.car_counter(car_counter).time(time).Q_sd;
            L3=chol(Q3,'lower');
            y3=L3\gpssolve.car_counter(car_counter).time(time).parity_sd;
            match_time_platform.match_time(match_time).y3=y3;
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
            %extra plotting
            match_time_platform.match_time(match_time).p4_ns=gpssolve.car_counter(car_counter).time(time).parity_no_difference;
            Q4=gpssolve.car_counter(car_counter).time(time).Q_sd;
            L4=chol(Q4,'lower');
            y4=L3\gpssolve.car_counter(car_counter).time(time).parity_sd;
            match_time_platform.match_time(match_time).y4=y4;
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
    temp = 0;
    temp_2 = 0;
    temp3 = 0;
    temp4=0;
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
        temp_2=temp_2+1;
        if isempty(match_time_platform.match_time(mt).p4) || ...,
                length(match_time_platform.match_time(mt).p4) ~= 4
            temp = temp +1;
            continue;
        elseif ~isempty(match_time_platform.match_time(mt).p2) && ...,
                length(match_time_platform.match_time(mt).p2) == 4
                %average p
                match_time_platform.match_time(mt).average_p = ...,
                    (match_time_platform.match_time(mt).p2 + match_time_platform.match_time(mt).p4) *1/2;
                %average Q
                match_time_platform.match_time(mt).average_Q = ...,
                    (match_time_platform.match_time(mt).Q2 + match_time_platform.match_time(mt).Q4) *1/4;
                %p4 and p4_ns
                all_p4=[all_p4,match_time_platform.match_time(mt).p4(3)];
                all_p4_ns=[all_p4_ns,match_time_platform.match_time(mt).p4_ns(3)];
                temp4=temp4+1;
        elseif ~isempty(match_time_platform.match_time(mt).p3) && ...,
                length(match_time_platform.match_time(mt).p3) == 4
                %average p
                match_time_platform.match_time(mt).average_p = ...,
                    (match_time_platform.match_time(mt).p3 + match_time_platform.match_time(mt).p4) *1/2;
                %average Q
                match_time_platform.match_time(mt).average_Q = ...,
                    (match_time_platform.match_time(mt).Q3 + match_time_platform.match_time(mt).Q4) *1/4;
                %p4 and p4_ns
                all_p4=[all_p4,match_time_platform.match_time(mt).p4(3)];
                all_p4_ns=[all_p4_ns,match_time_platform.match_time(mt).p4_ns(3)];
                temp4=temp4+1;
        else
            temp3=temp3+1;
            continue;
        end
        %Naive mCERIM cal
        p_bar=match_time_platform.match_time(mt).average_p;
        Q_bar=match_time_platform.match_time(mt).average_Q;
        match_time_platform.match_time(mt).Naive_mCERIM = p_bar'/Q_bar*p_bar;
        Naive_mCERIM_set = [Naive_mCERIM_set,match_time_platform.match_time(mt).Naive_mCERIM];
    end
end