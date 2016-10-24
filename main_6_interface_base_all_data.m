%This program is for implementing the Baseline Algorithm for all the data.
addpath('main_6_interface_base_all_data')
%% preparation
plot_number = 1;
axis_limit=[0,1.4,0,50];
bin_width = 0.05;
edge=[0 0:bin_width:1.5 2];

button = questdlg('last subtrial or the combined trial?','subtrial selection','l','c','None');
first_one_third_end_time = 153680;
last_one_third_start_time = 153770;
if button == 'l'
   which_part_trial=3;
else
   which_part_trial=4;
end


%% calculation
buttion = questdlg('3 receivers or 2 receivers?','receivers','3','2','None');
if buttion == '3'
    [Baseline_mCERIM_set,Baseline_mCERIM_DOF] = sun_baseline_algorithm_all_data(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
else
    [Baseline_mCERIM_set,Baseline_mCERIM_DOF] = sun_baseline_algorithm_all_data_2_receivers(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
end
Baseline_mCERIM_set_divide_T=Baseline_mCERIM_set./chi2inv(1-1e-5,Baseline_mCERIM_DOF);

Poss_Baseline_mCERIM=chi2cdf(Baseline_mCERIM_set,Baseline_mCERIM_DOF); %calculate the possibility 
sorted_poss_Baseline_mCERIM_set=sort(Poss_Baseline_mCERIM); %sort the possibility
x_axis=sorted_poss_Baseline_mCERIM_set;
y_axis = 1/length(Baseline_mCERIM_set):1/length(Baseline_mCERIM_set):1;
plot(x_axis,y_axis,'Linewidth',3);
xlabel('Theoretical CDF','FontSize',20)
ylabel('Empirical CDF','FontSize',20)
% title('Baseline Algorithm','FontSize',20)
hold on

%the line in the middle y=x
t_x=0:0.01:1;
t_y=0:0.01:1;
plot(t_x,t_y,'Linewidth',3)
% legend('Results of Simulation','Reference Line','Position',[1,1,800,200])
set(gca,'fontsize',18);

figure
histogram(Baseline_mCERIM_set_divide_T,edge)
title('Baseline Algorithm','FontSize',20)
x_str1='$$ m_{base}/T $$';
xlabel(x_str1,'Interpreter','latex','FontSize',20)
ylabel('numbers of data points','FontSize',20)
hold on
temp_x=[1,1,1];
temp_y=[0,1,axis_limit(1,4)*1.4];
plot(temp_x,temp_y)

%mark
points_a2 = length(find(Baseline_mCERIM_set_divide_T>1));
rate_a2 = length(find(Baseline_mCERIM_set_divide_T>1))/length(Baseline_mCERIM_set_divide_T);
points_larger_T_a2 = sprintf('# of points > 1:  %.1d',points_a2);
if rate_a2 >= 1e-5
    false_alarm_usim_rate_a2 = sprintf('False Alarm Rate:  %.2d',rate_a2);
else
    false_alarm_usim_rate_a2 = sprintf('False Alarm Rate:  %.1d',rate_a2);
end
text(axis_limit(1,2)*2/3,1/8*axis_limit(1,4),points_larger_T_a2,'FontSize',20)
text(axis_limit(1,2)*2/3,1/4*axis_limit(1,4),false_alarm_usim_rate_a2,'FontSize',20)
set(gca,'fontsize',18);
hold off