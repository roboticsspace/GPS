%% this program mainly helps to select the trial for each receiver and prepare the limit for "sun_file_load" for loading the data
function [file_location,interval_start,interval_end,station_ref]=sun_trial_slection(file_number,ref_car)
    switch file_number
        case 5
            station_ref = 0;
            set_location={'../Data/car1/Sirf_GPS_car1_trial5.dat';
                    '../Data/car2/Sirf_GPS_car2_trial5.dat';
                    '../Data/car3/Sirf_GPS_car3_trial5.dat';
                    '../Data/station/ref_station_trial5.dat'};
            set_start=[1,1,1,1];
            set_end=[5324,6918,6322,10272];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end

        case 6
            station_ref = 0;
            set_location={
            '../Data/car1/Sirf_GPS_car1_trial6.dat';
            '../Data/car2/Sirf_GPS_car2_trial6.dat';
            '../Data/car3/Sirf_GPS_car3_trial6.dat';
            '../Data/station/ref_station_trial4_6.dat'};
            set_start=[1,1,1,25107];
            set_end=[3724,3743,3746,44408];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end

        case 7
            station_ref = 0;
            set_location={
            '../Data/car1/Sirf_GPS_car1_trial7.dat';
            '../Data/car2/Sirf_GPS_car2_trial7.dat';
            '../Data/car3/Sirf_GPS_car3_trial7.dat';
            '../Data/station/ref_station_trial7_9.dat'};
            set_start=[1,1,1,1];
            set_end=[3523,4506,4760,22073];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end

        case 8
            station_ref = 0;
            set_location={
            '../Data/car1/Sirf_GPS_car1_trial8.dat';
            '../Data/car2/Sirf_GPS_car2_trial8.dat';
            '../Data/car3/Sirf_GPS_car3_trial8.dat';
            '../Data/station/ref_station_trial7_9.dat'};
            set_start=[1,1,1,1];
            set_end=[1187,4381,4428,22073];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end
        case 13
            station_ref = 0;
            set_location={
            '../Data/car1/Sirf_GPS_car1_trial5.dat';
            '../Data/car2/Sirf_GPS_car2_trial5.dat';
            '../Data/car3/Sirf_GPS_car3_trial5.dat';
            '../Data/station/ref_station_trial1_3.dat'};
            set_start=[1,1,1,1];
            set_end=[5324,6918,6322,43661];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end

        case 46
            station_ref = 0;
            set_location={
            '../Data/car1/Sirf_GPS_car1_trial5.dat';
            '../Data/car2/Sirf_GPS_car2_trial5.dat';
            '../Data/car3/Sirf_GPS_car3_trial5.dat'
                '../Data/station/ref_station_trial4_6.dat';};
            set_start=[1,1,1,1];
            set_end=[5324,6918,6322,44408];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end

        case 79
            station_ref = 0;
            set_location={
                '../Data/car1/Sirf_GPS_car1_trial5.dat';
                '../Data/car2/Sirf_GPS_car2_trial5.dat';
                '../Data/car3/Sirf_GPS_car3_trial5.dat';
                '../Data/station/ref_station_trial7_9.dat';};
            set_start=[1,1,1,1];
            set_end=[5324,6918,6322,30641];
            if ref_car == 1
                file_location={set_location{1};set_location{2};set_location{3};set_location{4}};
                interval_start=[set_start(1),set_start(2),set_start(3),set_start(4)];
                interval_end=[set_end(1),set_end(2),set_end(3),set_end(4)];
            elseif ref_car == 2
                file_location={set_location{2};set_location{1};set_location{3};set_location{4}};
                interval_start=[set_start(2),set_start(1),set_start(3),set_start(4)];
                interval_end=[set_end(2),set_end(1),set_end(3),set_end(4)];
            elseif ref_car == 3
                file_location={set_location{3};set_location{1};set_location{2};set_location{4}};
                interval_start=[set_start(3),set_start(1),set_start(2),set_start(4)];
                interval_end=[set_end(3),set_end(1),set_end(2),set_end(4)];
            elseif ref_car == 4
                file_location={set_location{4};set_location{1};set_location{2};set_location{3}};
                interval_start=[set_start(4),set_start(1),set_start(2),set_start(3)];
                interval_end=[set_end(4),set_end(1),set_end(2),set_end(3)];
                station_ref = 1;
            end
        otherwise

    end
end