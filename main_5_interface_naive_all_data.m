%section b naive 
%remember this program will destroy the data in sirf data and gpssolve. So
%if you want to keep using the sirf data and gpssolve, clear and run the data
%preparation and data analysis file again.

%% section b naive
addpath('main_5_interface_naive_all_data')
%list the available satellites
for car_counter = 2:4
        temp_timesteps=length(availsat.car_counter(car_counter).time); %number of timesteps in this car   

        for time=(1:temp_timesteps)
            if isempty(gpssolve.car_counter(car_counter).time(time).match_time_ref) || ...,
                    gpssolve.car_counter(car_counter).time(time).match_time_ref == 0
                continue;
            end
            match_time = gpssolve.car_counter(car_counter).time(time).match_time_ref;
            if car_counter == 2
                match_time_list(match_time).available_sat_2=availsat.car_counter(car_counter).time(time).satcarrier;
                match_time_list(match_time).time2 = time;
            elseif car_counter == 3
                match_time_list(match_time).available_sat_3=availsat.car_counter(car_counter).time(time).satcarrier;
                match_time_list(match_time).time3 = time;
            else
                match_time_list(match_time).available_sat_4=availsat.car_counter(car_counter).time(time).satcarrier; 
                match_time_list(match_time).time4 = time;
            end
        end
end    

%get the min satellite set
for match_time = 1:length(match_time_list)
    intersect_sat = intersect(match_time_list(match_time).available_sat_2,match_time_list(match_time).available_sat_3);
    intersect_sat = intersect(intersect_sat, match_time_list(match_time).available_sat_4);
    match_time_list(match_time).intersect_sat = intersect_sat;
end

% this part change the sirf data
for car_counter=2:4
        temp_timesteps=length(sirfdata(car_counter).state); %number of timesteps in this car   

        %switch between different timesteps
        for time=1:temp_timesteps %create a loop to get the data for each timesteps
            if car_counter == 2
                found = 0;
                for m_t = 1:length(match_time_list)
                    if ~isempty(match_time_list(m_t).time2) && time == match_time_list(m_t).time2
                        sirfdata(car_counter).state(time).availSat = match_time_list(m_t).intersect_sat;
                        found = 1;
                    end
                end
                if found == 0
                    sirfdata(car_counter).state(time).availSat = [];
                end
            elseif car_counter == 3
                found = 0;
                for m_t = 1:length(match_time_list)
                    if ~isempty(match_time_list(m_t).time3) && time == match_time_list(m_t).time3
                        sirfdata(car_counter).state(time).availSat = match_time_list(m_t).intersect_sat;
                        found = 1;
                    end
                end
                if found == 0
                    sirfdata(car_counter).state(time).availSat = [];
                end                    
            else
                found = 0;
                for m_t = 1:length(match_time_list)
                    if ~isempty(match_time_list(m_t).time4) && time == match_time_list(m_t).time4
                        sirfdata(car_counter).state(time).availSat = match_time_list(m_t).intersect_sat;
                        found = 1;
                    end
                end
                if found == 0
                    sirfdata(car_counter).state(time).availSat = [];
                end                    
            end
        end
end

%% calculate the position, residual, null space matrix, geo matrix, and store it in gpssolve
gpssolve = [];
availsat = [];
[gpssolve,availsat] = sun_pos_res_result_calculation(sirfdata,cars,gpssolve,availsat,elevMax);

%% calculate the single difference related results
gpssolve = sun_res_result_single_difference(sirfdata,cars,gpssolve,availsat);

%% parity vector calculation
gpssolve = sun_parity_vector_calculation_single_difference(gpssolve,availsat);

%% Here form the Q matrix
a0=1;
a1 = 12;
thetac=18;
gpssolve = sun_Q_calculation_single_difference(gpssolve,availsat,a0,a1,thetac);

%% preparation
plot_number = 1;
axis_limit=[0,1.4,0,50];
bin_width = 0.05;
edge=[0 0:bin_width:1.5 2];

%% Naive algorithm
button = questdlg('last subtrial or the combined trial?','subtrial selection','l','c','None');
first_one_third_end_time = 153680;
last_one_third_start_time = 153770;
if button == 'l'
   which_part_trial=3;
else
   which_part_trial=4;
end


%get the mNaive distribution and DOF for each of them
[Naive_mCERIM_set,Naive_mCERIM_DOF] = sun_naive_algorithm_all_data(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
Naive_mCERIM_set_divide_T = Naive_mCERIM_set./chi2inv(1-1e-5,Naive_mCERIM_DOF);

Poss_Naive_mCERIM=chi2cdf(Naive_mCERIM_set,Naive_mCERIM_DOF); %calculate the possibility 
sorted_poss_Naive_mCERIM_set=sort(Poss_Naive_mCERIM); %sort the possibility
x_axis=sorted_poss_Naive_mCERIM_set;
y_axis = 1/length(Naive_mCERIM_set):1/length(Naive_mCERIM_set):1;
plot(x_axis,y_axis,'Linewidth',3);
xlabel('Theoretical CDF','FontSize',20)
ylabel('Empirical CDF','FontSize',20)
% title('Naive Algorithm','FontSize',20)
hold on

%the line in the middle y=x
t_x=0:0.01:1;
t_y=0:0.01:1;
plot(t_x,t_y,'Linewidth',3)
% legend('data-derived','theoretical prediction','Position',[1,1,800,200])
set(gca,'fontsize',18);
hold off

figure
histogram(Naive_mCERIM_set_divide_T,edge)
title('Naive Algorithm','FontSize',20)
x_str1='$$ m_{naive}/T $$';
xlabel(x_str1,'Interpreter','latex','FontSize',20)
ylabel('numbers of data points','FontSize',20)
axis(axis_limit)
hold on
temp_x=[1,1,1];
temp_y=[0,1,axis_limit(1,4)];
plot(temp_x,temp_y)
legend('Distribution of m/T','T/T=1','FontSize',20)

%mark
points_a1 = length(find(Naive_mCERIM_set_divide_T>1));
rate_a1 = length(find(Naive_mCERIM_set_divide_T>1))/length(Naive_mCERIM_set_divide_T);
points_larger_T_a1 = sprintf('# of points > 1:  %.1d',points_a1);
if rate_a1 >= 1e-5
    false_alarm_usim_rate_a1 = sprintf('False Alarm Rate:  %.2d',rate_a1);
else
    false_alarm_usim_rate_a1 = sprintf('False Alarm Rate:  %.1d',rate_a1);
end
text(axis_limit(1,2)*2/3,1/8*axis_limit(1,4),points_larger_T_a1,'FontSize',20)
text(axis_limit(1,2)*2/3,1/4*axis_limit(1,4),false_alarm_usim_rate_a1,'FontSize',20)

hold off

% basic Chi-square
c_x = 0:0.2:40;
c_y = chi2pdf(c_x,4) * length(Naive_mCERIM_set) * bin_width * T;
c_x = c_x / T ;
plot(c_x,c_y)
set(gca,'fontsize',18);
hold off