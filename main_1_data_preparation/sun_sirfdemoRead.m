function [sirfData, CERIM_data]=sun_sirfdemoRead(filename,interval_start,interval_end)

fstream=fopen(filename);

t=0; % this is the time step for each reading
sv=1; % this a counter that keeps track of the satelites that were
% available at each timestep - such a variable will make it to iterate
% through each time step.
currentTime=0;

 for line=1:interval_end 
%      (~feof(fstream))
    dataLine=fgetl(fstream);    
    messageID=str2double(strcat(dataLine(1),dataLine(2)));
    if line>=interval_start
        switch messageID
            case 28
                % 1 is the Message ID, 2 is the satellite ID, 3 is the gps software
                % time, 4 is the pseudorange, 5 is carrer frequency, 6 is
                % carier phase
               % the reason is matlab matrices start at index =1 t=0
                  data=sscanf(dataLine,'%d%d%d%d%f%f%f%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d');
                   if(currentTime < data(5)) % if the current is time is
                    % greater than the previouse measured time then we are
                    % in the next state.
                    t=t+1;
                    currentTime=data(5);
                    sirfData.state(t)=initSirf();
                    CERIM_data.state(t)=init_struct();
                    sv=0;
                   end


                    if((data(4)<100)&&(data(4)>0))% I am expecting to see a maximum of 30 satellites
                        % sometimes the first reading in a log file is way greater
                        % than 30 (errorneous)
                        sv=sv+1;
                        sirfData.state(t).satellite(data(4)).softwareTime=data(5);
                        sirfData.state(t).satellite(data(4)).pRange=data(6);
                        sirfData.state(t).satellite(data(4)).crFreq=data(7);
                        sirfData.state(t).satellite(data(4)).crPhase=data(8);
                        sirfData.state(t).availSat(sv)=data(4);
                        %CERIM_data.state(t).car(car_counter).satellite(data(4)).sat_ID=(data(4));
                        %CERIM_data.state(t).car(car_counter).satellite(data(4)).pRange=(data(6));


                        %^struct.car(car_number).satellite(sat).pRange=0;
           % struct.car(car_number).satellite(sat).delta_pRange=0;


                        %struct.car(car_number).satellite(sat).sat_ID=0;
                    end


            case 30
                %1 is MessageID, 2 is satellite ID, 3 is gps time, 4 is xSat,5
                %ySat,6 zSat, 7 VxSat, 8 VySat, 9 VzSat
                if (t >0)% the reason is matlab matrices start at index =1 t=0
                    data=sscanf(dataLine,'%d%d%f%f%f%f%f%f%f%f%f%d%f%f%f');
                    if((data(2)<100)&&(data(2)>0))
                        sirfData.state(t).satellite(data(2)).gpsTime=data(3);
                        sirfData.state(t).satellite(data(2)).xSat=data(4);
                        sirfData.state(t).satellite(data(2)).ySat=data(5);
                        sirfData.state(t).satellite(data(2)).zSat=data(6);
                        sirfData.state(t).satellite(data(2)).vxSat=data(7);
                        sirfData.state(t).satellite(data(2)).vySat=data(8);
                        sirfData.state(t).satellite(data(2)).vzSat=data(9);

                        sirfData.state(t).satellite(data(2)).clkBias=data(10);
                        sirfData.state(t).satellite(data(2)).clkDrift=data(11);
                        sirfData.state(t).satellite(data(2)).ionDelay=data(15);
                    end
                end
            case 2
                %             1 is Message ID, 2 is the xUser, 3 yUser, 4 zUser, 5 vxUser,
                %             6 vyUser, 7 vzUser
                if (t>0)% the reason is matlab matrices start at index =1 t=0
                    data=sscanf(dataLine,'%d%f%f%f%f%f%f%d%d%d%d%f%d%d%d%d%d%d%d%d%d%d%d%d%d');
                    sirfData.state(t).xUser=data(2);
                    sirfData.state(t).yUser=data(3);
                    sirfData.state(t).zUser=data(4);
                    sirfData.state(t).vxUser=data(5);
                    sirfData.state(t).vyUser=data(6);
                    sirfData.state(t).vzUser=data(7);
                end
              otherwise


        end
    end
end
fclose(fstream);
end
