%This program is more like preparing for the data, based on code created by
%Liyan Yang.
clc
clear
addpath('main_1_data_preparation')
%% variables that do not need to renew each time
% non-zero initialization
cars=4; %cars amounts
elevMax=15; %minimum elevation angle for satellites this is probably a little too high

% zero initialization
cars_timesteps=zeros(cars,1);  %initialize a matrix to hold the number of timesteps for each data set
gpssolve = struct;
availsat = struct;
% 
%% reference receiver selection
ref_car = sun_choose_ref_car_dialog; %select reference receiver

%% trial selection
file_number = sun_choose_file_dialog; %H-C interation face
[file_location,interval_start,interval_end,station_ref]=sun_trial_slection(file_number,ref_car); %trial and limit selection

%% trial length selection
[start_time,end_time,GDOP_trigger, GDOP_minimum] = sun_trial_length_and_GDOP(file_number); %select the length and whether to do GDOP

%% loading the data from .dat file into sirf struct
sirfdata=sun_file_load(file_location,interval_start,interval_end,cars,station_ref); %load into sirfdata struct

%% calculate the position, residual, null space matrix, geo matrix, and store it in gpssolve
[gpssolve,availsat] = sun_pos_res_result_calculation(sirfdata,cars,gpssolve,availsat,elevMax);

%% calculate the single difference related results
gpssolve = sun_res_result_single_difference(sirfdata,cars,gpssolve,availsat);
