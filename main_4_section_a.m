%this program helps to calculate the future work section a and b

%% section a, comparing P and Q
all_P=zeros(4);
all_Q=zeros(4);
count = 0;
for car_counter=2:4
    temp_timesteps=length(availsat.car_counter(car_counter).time); %number of timesteps in this car   

    %switch between different timesteps
    for time=1:temp_timesteps %create a loop to get the data for each timesteps
        if isempty(gpssolve.car_counter(car_counter).time(time).parity_sd)
            continue;
        end
        p = gpssolve.car_counter(car_counter).time(time).parity_sd;
        P = p*p';
        gpssolve.car_counter(car_counter).time(time).P_sd = P;
        gpssolve.car_counter(car_counter).time(time).Q_div_P = gpssolve.car_counter(car_counter).time(time).Q_sd...,
            ./gpssolve.car_counter(car_counter).time(time).P_sd;
        if length(p)==4
            all_P = all_P + P;
            all_Q = all_Q + gpssolve.car_counter(car_counter).time(time).Q_sd;
            count = count +1;
        end
    end
end

%show the P and Q matrix
all_P=all_P/count
all_Q=all_Q/count