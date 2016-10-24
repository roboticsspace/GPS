%This program is for implementing the Common Residual Algorithm for all the data.
addpath('main_7_interface_common_all_data')
%% preparation
plot_number = 1;
axis_limit=[0,1.4,0,50];
bin_width = 0.05;
edge=[0 0:bin_width:1.5 2];

button = questdlg('last subtrial or combined trial?','subtrial selection','l','c','None');
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
    [Common_mCERIM_set,Common_mCERIM_DOF] = sun_common_algorithm_all_data(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
else
    [Common_mCERIM_set,Common_mCERIM_DOF] = sun_common_algorithm_all_data_2_receivers(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
end
Common_mCERIM_set_divide_T=Common_mCERIM_set./chi2inv(1-1e-5,Common_mCERIM_DOF);

Poss_Common_mCERIM=chi2cdf(Common_mCERIM_set,Common_mCERIM_DOF); %calculate the possibility 
sorted_poss_Common_mCERIM_set=sort(Poss_Common_mCERIM); %sort the possibility
x_axis=sorted_poss_Common_mCERIM_set;
y_axis = 1/length(Common_mCERIM_set):1/length(Common_mCERIM_set):1;
plot(x_axis,y_axis,'Linewidth',3);
xlabel('Theoretical CDF','FontSize',20)
ylabel('Empirical CDF','FontSize',20)
% title('Common Residual Algorithm','FontSize',20)
hold on

%the line in the middle y=x
t_x=0:0.01:1;
t_y=0:0.01:1;
plot(t_x,t_y,'Linewidth',3)
% legend('data-derived','theoretical prediction','Position',[1,1,800,200])
set(gca,'fontsize',18);

figure
histogram(Common_mCERIM_set_divide_T,edge)
title('Common Residual Algorithm','FontSize',20)
x_str1='$$ m_{cr}/T $$';
xlabel(x_str1,'Interpreter','latex','FontSize',20)
ylabel('numbers of data points','FontSize',20)
hold on
temp_x=[1,1,1];
temp_y=[0,1,axis_limit(1,4)*1.4];
plot(temp_x,temp_y)

%mark
points_a3 = length(find(Common_mCERIM_set_divide_T>1));
rate_a3 = length(find(Common_mCERIM_set_divide_T>1))/length(Common_mCERIM_set_divide_T);
points_larger_T_a3 = sprintf('# of points > 1:  %.1d',points_a3);
if rate_a3 >= 1e-5
    false_alarm_usim_rate_a3 = sprintf('False Alarm Rate:  %.2d',rate_a3);
else
    false_alarm_usim_rate_a3 = sprintf('False Alarm Rate:  %.1d',rate_a3);
end
text(axis_limit(1,2)*2/3,1/8*axis_limit(1,4),points_larger_T_a3,'FontSize',20)
text(axis_limit(1,2)*2/3,1/4*axis_limit(1,4),false_alarm_usim_rate_a3,'FontSize',20)
set(gca,'fontsize',18);
hold off