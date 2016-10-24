% this function calculate the vector y
function gpssolve = sun_y_calculation_single_difference(gpssolve)
    for car_counter=2:4
        temp_timesteps=length(gpssolve.car_counter(car_counter).time); %number of timesteps in this car   
            
        %switch between different timesteps
        for time=1:temp_timesteps %create a loop to get the data for each timesteps
            if isempty(gpssolve.car_counter(car_counter).time(time).parity_sd)
                continue;
            end
            %data download
            p = gpssolve.car_counter(car_counter).time(time).parity_sd;
            Q = gpssolve.car_counter(car_counter).time(time).Q_sd;
            
            %cholesky
            L=chol(Q,'lower');
            
            %y calculation
            y=L\p;
            gpssolve.car_counter(car_counter).time(time).regularized_y_sd=y;

        end
    end
end