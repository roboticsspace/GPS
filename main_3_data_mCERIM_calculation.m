%calculate the mCERIM using 3 algorithms
addpath('main_3_data_mCERIM_calculation')
plot_number = 1;
axis_limit=[0,1.4,0,50];
bin_width = 0.05;
edge=[0 0:bin_width:1.5 2];

first_one_third_end_time = 153680;
last_one_third_start_time = 153770;
which_part_trial=3;

% %% plotting the p and y
% [all_p_1,all_p_2,all_p_3,all_p_4,all_y_1,all_y_2,all_y_3,all_y_4] = ...,
%     yang_plotting_p_and_y(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
% subplot(4,2,1)
% histogram(all_p_1)
% std_str='$$ \theta:';

button = questdlg('combined plot or independent plot','plot','c','i','None');

%% Naive algorithm
figure
if button == 'c'
    subplot(3,1,1)
end

[Naive_mCERIM_set,all_p4,all_p4_ns] = sun_naive_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
T=chi2inv(1-1e-5,4);
Naive_mCERIM_set_divide_T = Naive_mCERIM_set/T;
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
text(axis_limit(1,2)*1/3,5/8*axis_limit(1,4),points_larger_T_a1,'FontSize',20)
text(axis_limit(1,2)*1/3,6/8*axis_limit(1,4),false_alarm_usim_rate_a1,'FontSize',20)

% basic Chi-square
c_x = 0:0.2:40;
c_y = chi2pdf(c_x,4) * length(Naive_mCERIM_set) * bin_width * T;
c_x = c_x / T ;
plot(c_x,c_y)
hold off

if button == 'i'
    figure
    Poss_Naive_mCERIM=chi2cdf(Naive_mCERIM_set,4); %calculate the possibility 
    sorted_poss_Naive_mCERIM_set=sort(Poss_Naive_mCERIM); %sort the possibility
    x_axis=sorted_poss_Naive_mCERIM_set;
    y_axis = 1/length(Naive_mCERIM_set):1/length(Naive_mCERIM_set):1;
    plot(x_axis,y_axis,'Linewidth',3);
    xlabel('Theoretical CDF','FontSize',20)
    ylabel('Empirical CDF','FontSize',20)
%     title('Naive Algorithm','FontSize',20)

    hold on

    %the line in the middle y=x
    t_x=0:0.01:1;
    t_y=0:0.01:1;
    plot(t_x,t_y,'Linewidth',3)
    legend('Results of Simulation','Reference Line','Position',[1,1,800,200])
    set(gca,'fontsize',18);
    hold off
    
end

%% Baseline algorithm
if button == 'c'
    subplot(3,1,2)
else
    figure
end

Baseline_mCERIM_set = sun_baseline_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
T=chi2inv(1-1e-5,8);
Baseline_mCERIM_set_divide_T = Baseline_mCERIM_set/T;
histogram(Baseline_mCERIM_set_divide_T,edge)
title('Baseline Algorithm','FontSize',20)
x_str1='$$ m_{base}/T $$';
xlabel(x_str1,'Interpreter','latex','FontSize',20)
ylabel('numbers of data points','FontSize',20)
axis(axis_limit)
hold on
temp_x=[1,1,1];
temp_y=[0,1,axis_limit(1,4)];
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
text(axis_limit(1,2)*1/3,5/8*axis_limit(1,4),points_larger_T_a2,'FontSize',20)
text(axis_limit(1,2)*1/3,6/8*axis_limit(1,4),false_alarm_usim_rate_a2,'FontSize',20)

% basic Chi-square
c_x = 0:0.2:40;
c_y = chi2pdf(c_x,4) * length(Baseline_mCERIM_set) * bin_width * T;
c_x = c_x / T;
plot(c_x,c_y)
hold off

if button == 'i'
    figure
    Poss_Baseline_mCERIM=chi2cdf(Baseline_mCERIM_set,8); %calculate the possibility 
    sorted_poss_Baseline_mCERIM_set=sort(Poss_Baseline_mCERIM); %sort the possibility
    x_axis=sorted_poss_Baseline_mCERIM_set;
    y_axis = 1/length(Baseline_mCERIM_set):1/length(Baseline_mCERIM_set):1;
    plot(x_axis,y_axis,'Linewidth',3);
    xlabel('Theoretical CDF','FontSize',20)
    ylabel('Empirical CDF','FontSize',20)
%     title('Baseline Algorithm','FontSize',20)
    hold on
    
    %the line in the middle y=x
    t_x=0:0.01:1;
    t_y=0:0.01:1;
    plot(t_x,t_y,'Linewidth',3)
    legend('Results of Simulation','Reference Line','Position',[1,1,800,200])
    set(gca,'fontsize',18);
    hold off
end
%% Common Residual Algorithm
if button == 'c'
    subplot(3,1,3)
else
    figure
end

Common_mCERIM_set = sun_common_algorithm(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
T=chi2inv(1-1e-5,4);
Common_mCERIM_set_divide_T = Common_mCERIM_set/T;
histogram(Common_mCERIM_set_divide_T,edge)
title('Common Residual Algorithm','FontSize',20)
x_str1='$$ m_{cr}/T $$';
xlabel(x_str1,'Interpreter','latex','FontSize',20)
ylabel('numbers of data points','FontSize',20)
axis(axis_limit)
hold on
temp_x=[1,1,1];
temp_y=[0,1,axis_limit(1,4)];
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
text(axis_limit(1,2)*1/3,5/8*axis_limit(1,4),points_larger_T_a3,'FontSize',20)
text(axis_limit(1,2)*1/3,6/8*axis_limit(1,4),false_alarm_usim_rate_a3,'FontSize',20)

% basic Chi-square
c_x = 0:0.2:40;
c_y = chi2pdf(c_x,4) * length(Common_mCERIM_set) * bin_width * T;
c_x = c_x / T;
plot(c_x,c_y)
hold off

if button == 'i'

    figure
    Poss_Common_mCERIM=chi2cdf(Common_mCERIM_set,4); %calculate the possibility 
    sorted_poss_Common_mCERIM_set=sort(Poss_Common_mCERIM); %sort the possibility
    x_axis=sorted_poss_Common_mCERIM_set;
    y_axis = 1/length(Common_mCERIM_set):1/length(Common_mCERIM_set):1;
    plot(x_axis,y_axis,'Linewidth',3);
    xlabel('Theoretical CDF','FontSize',20)
    ylabel('Empirical CDF','FontSize',20)
%     title('Common Residual Algorithm','FontSize',20)
    hold on
    
    %the line in the middle y=x
    t_x=0:0.01:1;
    t_y=0:0.01:1;
    plot(t_x,t_y,'Linewidth',3)
    legend('Results of Simulation','Reference Line','Position',[1,1,800,200])
    set(gca,'fontsize',18);
    hold off

end