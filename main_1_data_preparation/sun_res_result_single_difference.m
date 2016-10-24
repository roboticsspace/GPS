% this program works for the single difference calculation. To calculate 
% single difference residuals
function gpssolve = sun_res_result_single_difference(sirfdata,cars,gpssolve,availsat)
    for car_counter=2:cars
            temp_timesteps=length(availsat.car_counter(car_counter).time); %number of timesteps in this car   
            
            %switch between different timesteps
            for time=1:temp_timesteps %create a loop to get the data for each timesteps

                %calculate residuals
                [dPR_res,null_matrix_sd,match_time_ref,satellite_carrier]  = sun_position_related_calculation_single_difference ...,
                    (gpssolve,sirfdata,time,car_counter,availsat);
                gpssolve.car_counter(car_counter).time(time).residual_sd = dPR_res;
                gpssolve.car_counter(car_counter).time(time).null_matrix_sd = null_matrix_sd;
                gpssolve.car_counter(car_counter).time(time).match_time_ref = match_time_ref;
                gpssolve.car_counter(car_counter).time(time).satellite_carrier_sd = satellite_carrier;
           end
    end
end