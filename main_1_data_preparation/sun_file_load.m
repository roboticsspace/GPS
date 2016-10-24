%% This function is for loading the datas from .dat file into each sirfdata struct
%file_location: files' address
%number_of_line: number of lines in .dat file
%cars: cars' number
function sirfdata=sun_file_load(file_location,interval_start,interval_end,car,station_ref)
    if station_ref ~= 1
        for car_counter=1:car-1 %create a loop to get the data from .dat files of the 3 cars to sirfdata
            sirfdata(car_counter)=sun_complete_data_parser(file_location{car_counter},interval_start(car_counter),interval_end(car_counter));
        end
        car_counter=car;
        sirfdata(car_counter)=sun_sirfdemoRead(file_location{car_counter},interval_start(car_counter),interval_end(car_counter));
        %parameters used later: sirfdata
    else %if the reference station is the sationary receiver, then we need to switch the sequence
        car_counter=1;
        sirfdata(car_counter)=sun_sirfdemoRead(file_location{car_counter},interval_start(car_counter),interval_end(car_counter));
        for car_counter=2:car %create a loop to get the data from .dat files of the 3 cars to sirfdata
            sirfdata(car_counter)=sun_complete_data_parser(file_location{car_counter},interval_start(car_counter),interval_end(car_counter));
        end
        %parameters used later: sirfdata
    end
end