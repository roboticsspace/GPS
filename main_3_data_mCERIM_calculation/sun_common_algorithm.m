% This program is for the baseline algorithm implement on the 2nd, 3rd, and
% 4th receiver. Here, parity vector with length equal to 4 is chosen. Only
% receiver 2, and 4 are considered in the usual case. Receiver 3 is
% considered when 2 is not avaible.
function Common_mCERIM_set = sun_common_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial)
    Common_mCERIM_set = [];
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
            match_time_platform.match_time(match_time).N2=gpssolve.car_counter(car_counter).time(time).null_matrix_sd;
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
            match_time_platform.match_time(match_time).N3=gpssolve.car_counter(car_counter).time(time).null_matrix_sd;
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
            match_time_platform.match_time(match_time).N4=gpssolve.car_counter(car_counter).time(time).null_matrix_sd;
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
    Common_mCERIM_set = [];
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
            
        %calculation
        if isempty(match_time_platform.match_time(mt).p4) || ...,
                length(match_time_platform.match_time(mt).p4)~=4
            continue;
        elseif ~isempty(match_time_platform.match_time(mt).p2) && ...,
                length(match_time_platform.match_time(mt).p2) == 4
                p4=match_time_platform.match_time(mt).p4;
                p2=match_time_platform.match_time(mt).p2;
                Q4=match_time_platform.match_time(mt).Q4;
                Q2=match_time_platform.match_time(mt).Q2;
                N4=match_time_platform.match_time(mt).N4;
                N2=match_time_platform.match_time(mt).N2;
                
                if length(N4)<length(N2)
                    Nav=N2;
                else
                    Nav=N4;
                end
                
                %P2,N2,A2
                P_col_len = length(Nav);
                P_row_len = length(N2);
                Pl = zeros(P_row_len,P_col_len);
                for i=1:P_row_len
                    Pl(i,i) = 1;
                end  
                A2 = N2'*Pl*Nav;
                
                %P4,N4,A4
                P_col_len = length(Nav);
                P_row_len = length(N4);
                Pl = zeros( P_row_len,P_col_len);
                for i=1:P_row_len
                    Pl(i,i) = 1;
                end  
                A4 = N4'*Pl*Nav;
                
                %A
                A=[A2' A4']';
                
                %Qs
                l_Q2 = length(Q2);
                l_Q4 = length(Q4);
                Qs = [Q2, zeros(l_Q2,l_Q4); zeros(l_Q4,l_Q2),Q4];
                
                %A+
                A_plus = (A'/Qs*A)\A'/Qs;
                
                %concatenated p
                pc=[p2' p4']';
                
                %c
                c=A_plus * pc;
                
                %Qec
                Qec = inv(A2'/Q2*A2 + A4'/Q4*A4);
                
                %Qc_hat
                Qc_hat=Qec;
                
                %mCERIM
                mCERIM= c'/ Qc_hat * c;
                
                %Common Residual mCERIM cal   
                match_time_platform.match_time(mt).Common_mCERIM = mCERIM;
                
        elseif ~isempty(match_time_platform.match_time(mt).p3) && ...,
                length(match_time_platform.match_time(mt).p3) == 4
            
                p4=match_time_platform.match_time(mt).p4;
                p3=match_time_platform.match_time(mt).p3;
                Q4=match_time_platform.match_time(mt).Q4;
                Q3=match_time_platform.match_time(mt).Q3;
                N4=match_time_platform.match_time(mt).N4;
                N3=match_time_platform.match_time(mt).N3;
                
                if length(N4)<length(N3)
                    Nav=N3;
                else
                    Nav=N4;
                end
                
                %P3,N3,A3
                P_col_len = length(Nav);
                P_row_len = length(N3);
                Pl = zeros(P_row_len,P_col_len);
                for i=1:P_row_len
                    Pl(i,i) = 1;
                end  
                A3 = N3'*Pl*Nav;
                
                %P4,N4,A4
                P_col_len = length(Nav);
                P_row_len = length(N4);
                Pl = zeros( P_row_len,P_col_len);
                for i=1:P_row_len
                    Pl(i,i) = 1;
                end  
                A4 = N4'*Pl*Nav;
                
                %A
                A=[A3' A4']';
                
                %Qs
                l_Q3 = length(Q3);
                l_Q4 = length(Q4);
                Qs = [Q3, zeros(l_Q3,l_Q4); zeros(l_Q4,l_Q3),Q4];
                
                %A+
                A_plus = (A'/Qs*A)\A'/Qs;
                
                %concatenated p
                pc=[p3' p4']';
                
                %c
                c=A_plus * pc;
                
                %Qec
                Qec = inv(A3'/Q3*A3 + A4'/Q4*A4);
                
                %Qc_hat
                Qc_hat=Qec;
                
                %mCERIM
                mCERIM= c'/ Qc_hat * c;
                
                %Common Residual mCERIM cal
                match_time_platform.match_time(mt).Common_mCERIM = mCERIM;             
        else
            continue;
        end
        
        %Common Residual mCERIM cal
        Common_mCERIM_set = [Common_mCERIM_set,match_time_platform.match_time(mt).Common_mCERIM];  

    end
end    