% this function calculate the Q matrix
function gpssolve = sun_Q_calculation_single_difference(gpssolve,availsat,a0,a1,thetac)
    for car_counter=2:4
        temp_timesteps=length(availsat.car_counter(car_counter).time); %number of timesteps in this car   
            
        %switch between different timesteps
        for time=1:temp_timesteps %create a loop to get the data for each timesteps
            if isempty(gpssolve.car_counter(car_counter).time(time).null_matrix_sd)
                continue;
            end
            N = gpssolve.car_counter(car_counter).time(time).null_matrix_sd;
            %elevation angle
            satellite_carrier = gpssolve.car_counter(car_counter).time(time).satellite_carrier_sd;
            avai_struct_satellite_carrier = availsat.car_counter(car_counter).time(time).satcarrier;
            elev_sequence = availsat.car_counter(car_counter).time(time).elevAngle;
            [sat_com,satorer1,satorder2] = intersect(satellite_carrier,avai_struct_satellite_carrier,'stable');
            elev_sequence = elev_sequence(satorder2);
            gpssolve.car_counter(car_counter).time(time).elevAngle_sd = elev_sequence;
            
            %R matrix building
            R_length=length(elev_sequence);
            R=zeros(R_length);
            for i=1:R_length
                sigma=a0+a1*exp(-elev_sequence(i)/thetac); %get the individual rms errors
                R(i,i)= sigma^2; %errors into the R matrix
            end
            
            Q = N' * R * N;
            gpssolve.car_counter(car_counter).time(time).Q_sd = Q;
        end
    end
end