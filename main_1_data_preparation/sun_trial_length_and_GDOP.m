%% this part determines the length of the trial and the part we want see on the trial
%The following pass_574_time is the time when the last car passed 574 building for each trial.
function [start_time,end_time,GDOP_trigger, GDOP_minimum] = sun_trial_length_and_GDOP(file_number)
    %The following are the time in the data which passes the 574 buildings
    if  file_number == 5
        pass_574_time = 153770; 
    elseif file_number == 6
        pass_574_time = 154151;
    elseif file_number == 7
        pass_574_time = 154389;
    end

    %determine the start_time and end_time according to the task
    trial_decision=sun_trial_decider;
    GDOP_trigger=0;
    if trial_decision == 1
        start_time = 1;
        end_time = inf;
    elseif trial_decision == 2
        start_time = 1;
        end_time = pass_574_time;
    elseif trial_decision == 3
        start_time = pass_574_time;
        end_time = inf;
    elseif trial_decision == 4
        start_time = 1;
        end_time = pass_574_time-75;
    elseif trial_decision == 5
        start_time = pass_574_time-75;
        end_time = pass_574_time;
    elseif trial_decision == 6
        start_time = pass_574_time;
        end_time = pass_574_time+75;
    elseif trial_decision == 7
        start_time = pass_574_time+75;
        end_time = inf;
    elseif trial_decision == 8
        start_time = 1;
        end_time = inf;
        GDOP_trigger = 1;
    end

    %if you want to check data based on GDOP, than set the upper bound
    if GDOP_trigger == 1
        GDOP_minimum = str2double(inputdlg({'What do you want for the upper bound of GDOP'},'Input',1,{'0'})); %select the boud of GDOP
    else
        GDOP_minimum = 0; %meaning less
    end
end