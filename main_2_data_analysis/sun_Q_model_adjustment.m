function J_set = sun_Q_model_adjustment(gpssolve,availsat,first_one_third_end_time,last_one_third_start_time,which_part_trial)
        a0=1;
        a1_set=1:40;
        thetac_set = 1:45;
        J_set =zeros(45,40);

        for model_i = 1:45
            for model_j = 1:40
                %determine the parameters
                a1 = a1_set(model_j);
                thetac = thetac_set(model_i);
                gpssolve = sun_Q_calculation_single_difference(gpssolve,availsat,a0,a1,thetac);

                [a1,thetac]
                % Here calcualte the vector y
                gpssolve = sun_y_calculation_single_difference(gpssolve);

                % optimize the model
                [J,y_square_set] = sun_J_calculation_single_difference(gpssolve,first_one_third_end_time,last_one_third_start_time,which_part_trial);
                J_set(model_i,model_j) = J;
            end
        end
end