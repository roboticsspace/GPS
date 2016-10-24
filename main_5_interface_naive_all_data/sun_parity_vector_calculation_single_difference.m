% this function calculate the parity vector
function gpssolve = sun_parity_vector_calculation_single_difference(gpssolve,availsat)
    for car_counter=2:4
        temp_timesteps=length(availsat.car_counter(car_counter).time); %number of timesteps in this car   
            
        %switch between different timesteps
        for time=1:temp_timesteps %create a loop to get the data for each timesteps
            if isempty(gpssolve.car_counter(car_counter).time(time).residual_sd)
                continue;
            end

            r = gpssolve.car_counter(car_counter).time(time).residual_sd;
            N = gpssolve.car_counter(car_counter).time(time).null_matrix_sd;
            p = N' * r';
            gpssolve.car_counter(car_counter).time(time).parity_sd = p;
        end
    end
end