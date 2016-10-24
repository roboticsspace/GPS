%This program is to synchronize the time-different data from two receivers.
%The input contains all the data, the car_counter which denotes the
%receiver you are working on, the time which denotes the time you want to
%synchronize. The output match_time_ref means the corresponding time in
%receiver 1. If the match_time_ref returns 0, it means that the
%corresponding time point in receiver 1 has not been found.

function match_time_ref=liyan_synchronize(gpssolve,car_counter,time)

    %Find the matching data sets for this time in reference station
    match_time_ref=0; %initialize
    for time_refstation=1:length(gpssolve.car_counter(1).time)
        if gpssolve.car_counter(1).time(time_refstation).gpsTime == gpssolve.car_counter(car_counter).time(time).gpsTime
            match_time_ref=time_refstation; %find the match time of the reference station
            break
        end
    end
end