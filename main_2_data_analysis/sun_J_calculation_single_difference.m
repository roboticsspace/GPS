% this function optimize the model by minimizing the J
function [J,y_square_set] = sun_J_calculation_single_difference(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial)
    %storage
    y_square_set = [];

    for car_counter=2:4
        temp_timesteps=length(gpssolve.car_counter(car_counter).time); %number of timesteps in this car   
        
        %switch between different timesteps
        for time=1:temp_timesteps %create a loop to get the data for each timesteps
            %determine the part
            switch which_part_trial
                case 1
                    if gpssolve.car_counter(car_counter).time(time).gpsTime >= first_one_third_end_time
                        continue;
                    end
                case 2
                    if gpssolve.car_counter(car_counter).time(time).gpsTime <= last_one_third_start_time
                        continue;
                    end                    
                case 3
                    if gpssolve.car_counter(car_counter).time(time).gpsTime > last_one_third_start_time || ...,
                            gpssolve.car_counter(car_counter).time(time).gpsTime < first_one_third_end_time
                        continue;
                    end                    
            end
                
            if isempty(gpssolve.car_counter(car_counter).time(time).regularized_y_sd)
                continue;
            end
            %data download
            y = gpssolve.car_counter(car_counter).time(time).regularized_y_sd;
            
            %calculation
            y_square_set = [y_square_set, 1/length(y)*y'*y];
        end
    end
    
    %J calculation
    sigma_hat_square = sum(y_square_set)/length(y_square_set);
    J=(sigma_hat_square-1)^2;
end