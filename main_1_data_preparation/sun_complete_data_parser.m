function sirfData = liyan_complete_data_parser(file_location, interval_start,interval_end)
% This function reads a GPS data file and parses the data
%  Given a file location and the number of lines in the file,
%  this function goes in and separates the different components of the data

%  NOTE: this function requires Jonah's "initSirf" function to initialize
%  all of the structs

my_file=fopen(file_location);
version=1;
current_GPS_time=0;
currentTime=0;
sv=1;
t=0;
tgps=0;
satelite_counter=0;
max_sat_ID=41;
error_tracker=0;
MID=0; %this is a variable to keep track of the previous message ID
% it will be used for error tracking

%while(~feof(my_file))  %this is the line Jonah uses, my simpler needs
%allow me to use a FOR loop instead
for line=1:interval_end
    dataLine=fgetl(my_file); %read each line of the file from top to bottom
    messageID=str2double(strcat(dataLine(1), dataLine(2))); %use the first 2 digits in the file as a tag
        if line>=interval_start
            switch messageID

                case 1

                    %this message ID is tied to the version of labview used to
                    %collect the data, its for the 01 1.7 at the beginning of the
                    %file

                    if version == 1
                        data=sscanf(dataLine, '%d%f');
                        version=data(2);
                    end

                case 28
                    % 1 is the Message ID, 2 is the satellite ID, 3 is the gps software
                    % time, 4 is the pseudorange, 5 is carrer frequency, 6 is
                    % carier phase

                    % the reason is matlab matrices start at index =1 t=0
                    data=sscanf(dataLine, '%d%d%f%f%f%f');

                    if (current_GPS_time<data(3))&& (MID==28) 
                        if (t<=tgps)

                            tgps=tgps+1; satellite_counter=0;
                            t=tgps; current_GPS_time=data(3);
                            sirfData.state(t)=initSirf();
                        end
                    end

                    if (data(2)<max_sat_ID && data(2) ~=0)
                        sirfData.state(t).satellite(data(2)).sat_ID=data(2);
                        sirfData.state(t).satellite(data(2)).softwareTime=data(3);
                        sirfData.state(t).satellite(data(2)).pRange=data(4);
                        sirfData.state(t).satellite(data(2)).crFreq=data(5);
                        sirfData.state(t).satellite(data(2)).crPhase=data(6);
                        current_GPS_time=data(3);
                        sat=data(2);
                    end


                    MID=28;

                case 30
                    %1 is MessageID, 2 is satellite ID, 3 is gps time, 4 is xSat,5
                    %ySat,6 zSat, 7 VxSat, 8 VySat, 9 VzSat, 10 clkBias, 11 clkDrift

                    if (t>0)

                        if (version==1.7) %make sure there are 01 1.7 at the top of the file and have been read
                            data=sscanf(dataLine, '%d%d%f%f%f%f%f%f%f%f%f%f');
                        elseif (version==1)
                            data=sscanf(dataLine, '%d%d%f%f%f%f%f%f%f%f%f');
                        end

                        %this step is to check for errors  *** very important /else
                        %there will be unexplainable spikes.
                        deltaT=abs(current_GPS_time-data(3));
                        %%the difference between gps satellite time and gps software time

                        if(data(2)<max_sat_ID && (data(2)~=0) &&(deltaT<0.2))
                            sirfData.state(t).satellite(data(2)).sat_ID=data(2);
                            sirfData.state(t).satellite(data(2)).gpsTime=data(3);
                            sirfData.state(t).satellite(data(2)).xSat=data(4);
                            sirfData.state(t).satellite(data(2)).ySat=data(5);
                            sirfData.state(t).satellite(data(2)).zSat=data(6);
                            sirfData.state(t).satellite(data(2)).vxSat=data(7);
                            sirfData.state(t).satellite(data(2)).vySat=data(8);
                            sirfData.state(t).satellite(data(2)).vzSat=data(9);
                            sirfData.state(t).satellite(data(2)).clkBias=data(10);
                            sirfData.state(t).satellite(data(2)).clkDrift=data(11);

                            if (version==1.7)
                                sirfData.state(t).satellite(data(2)).ionDelay=data(12);
                            end

                            % this part check to for message 28 for the satellite
                            % in question, if message 28 is available then the
                            % satellite's message is full and it is available

                            if((sirfData.state(t).satellite(data(2)).softwareTime~=0)&&...
                                    (sirfData.state(t).satellite(data(2)).pRange~=0)&&...
                                    (sirfData.state(t).satellite(data(2)).crFreq~=0)&&...
                                    (deltaT<0.2))
                                sv=sv+1;
                                sirfData.state(t).availSat(sv)=data(2);

                                sat=data(2);

                            end

                            if(data(2)==0)
                                disp('satID=0');
                            end
                        end
                    end

                case 2

                    %             1 is Message ID, 2 is the xUser, 3 yUser, 4 zUser, 5 vxUser,
                    %             6 vyUser, 7 vzUser

                    if (t>0)% the reason is matlab matrices start at index =1 t=0
                        data=sscanf(dataLine,'%u%f%f%f%f%f%f');
                        sirfData.state(t).xUser=data(2);
                        sirfData.state(t).yUser=data(3);
                        sirfData.state(t).zUser=data(4);
                        sirfData.state(t).vxUser=data(5);
                        sirfData.state(t).vyUser=data(6);
                        sirfData.state(t).vzUser=data(7);
                    end

                case 0
                    % message 0 is  a custom message, it carries the syncronized
                    % clock between the laser and the GPS, and the Camera, and gyro
                    % scope. it is the computer clock, it is being written right
                    % when the message is received
                    %              the messages come in chunks order as follows :
                    %              commontime, message 28, message 30,message 2,


                    data=sscanf(dataLine,'%u%f%');
                    if (currentTime<data(2))
                        % if the current is time is greater than the previous
                        %  measured time then we are in the next state.

                        t=t+1;tgps=t;
                        currentTime=data(2);
                        sirfData.state(t)=initSirf();
                        sv=0;

                    end

                    sirfData.state(t).commonTime=data(2);
                    MID=0;

                otherwise
                    %

            end
        end  
end
fclose(my_file);
end