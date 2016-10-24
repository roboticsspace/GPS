%calculate the parity vector, y vector, Q etc
addpath('main_2_data_analysis')
%% parity vector calculation
gpssolve = sun_parity_vector_calculation_single_difference(gpssolve,availsat);

%% adjust the model or calculate the Q matrix
choice = questdlg('Would you like adjust the model or ..., simply get the best Q?','Q analysis','adjust_the_model','get_Q','Nothing'); 
switch choice 
    case 'adjust_the_model'
        %trial determin
        first_one_third_end_time = 153680;
        last_one_third_start_time = 153770;
        which_part_trial = 1;
        J_set = sun_Q_model_adjustment(gpssolve,availsat,first_one_third_end_time,last_one_third_start_time,which_part_trial);
        
        %plot the graph
        surf((1:40),(1:45),J_set);
        view(110+37.5,30)
        set(gca,'ZScale','log')
        x_str='$$ a_1 $$';
        xlabel(x_str,'Interpreter','latex','FontSize',30)
        y_str='$$ \theta_c $$';
        ylabel(y_str,'Interpreter','latex','FontSize',30)
        z_str='$$ \log J $$';
        zlabel(z_str,'Interpreter','latex','FontSize',30)
        min_value = min(J_set(:));
        [min_thetac,min_a1] = find(J_set == min_value);
        hold on
        plot3(min_a1,min_thetac,min_value,'o','Markersize',10)
        hold off
        
    case 'get_Q'
        % Here form the Q matrix
        a0=1;
        a1 = 12;
        thetac=18;
        gpssolve = sun_Q_calculation_single_difference(gpssolve,availsat,a0,a1,thetac);
    case 'Nothing'
end