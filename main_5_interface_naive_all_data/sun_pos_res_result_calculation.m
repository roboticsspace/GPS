%This part is for using the data in sirfdata and calculate the position, 
%residual, null space matrix, geo matrix, and store it in gpssolve
function [gpssolve,availsat,X] = sun_pos_res_result_calculation(sirfdata,cars,gpssolve,availsat,elevMax)

    for car_counter=1:cars
            temp_timesteps=length(sirfdata(car_counter).state); %number of timesteps in this car   

                %switch between different timesteps
                for time=1:temp_timesteps %create a loop to get the data for each timesteps
                    satellite_carrier=sort(sirfdata(car_counter).state(time).availSat); %available sats this car, this time, small to large
                    AsatNum=length(satellite_carrier); %amount of available sats
                    
                    %check if all the sats have data
                    for each_sat=1:AsatNum
                        if sirfdata(car_counter).state(time).satellite(satellite_carrier(each_sat)).xSat == 0 || ...,
                                sirfdata(car_counter).state(time).satellite(satellite_carrier(each_sat)).ySat ...,
                                == 0 || sirfdata(car_counter).state(time).satellite(satellite_carrier(each_sat)).zSat == 0 || ...,
                                sirfdata(car_counter).state(time).satellite(satellite_carrier(each_sat)).pRange == 0
                                disp('Wrong! Data in availSat is 0.')
                        end
                    end

                    %calculate position related results in gpssolve struct
                    [gpssolve,X]=sun_position_related_calculation(gpssolve,AsatNum,satellite_carrier,sirfdata,time,car_counter);
                    if isempty(gpssolve.car_counter(car_counter).time(time).posEstStnd)
                        continue
                    end
                    
                    %This section uses location calculated before to eliminate the unwanted satellites with small elevation angle
                    availsat=sun_low_sat_elimination(availsat,car_counter,time,AsatNum,gpssolve,X,satellite_carrier,elevMax);
                    satellite_carrier2=sort(availsat.car_counter(car_counter).time(time).satcarrier); %id of avai sats, small to large
                    AsatNum2=length(satellite_carrier2);    %avai sat amount
                    
                    %position calculation
                    [gpssolve,X]=sun_position_related_calculation(gpssolve,AsatNum2,satellite_carrier2,sirfdata,time,car_counter); %calculate the correct position
                end
    end
end