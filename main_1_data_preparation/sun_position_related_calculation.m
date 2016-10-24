%This function used to calculate the position related results like
%position,residuals, geo matrix, null matrix
%AsatNum: amount of available sats
%satellite_carrier: id of available sats, small to large
%sirfdata: raw data
%time: which timesteps
%car_counter: which cars
%return gpssolve, contains position related information
%return X, contains satellite position
function [gpssolve,X]=sun_position_related_calculation(gpssolve,AsatNum,satellite_carrier,sirfdata,time,car_counter)  
        %% eliminate the situation where less than 4 sats
        if AsatNum<5
            gpssolve.car_counter(car_counter).time(time).posEstStnd = [];
            gpssolve.car_counter(car_counter).time(time).deltaRange = [];
            gpssolve.car_counter(car_counter).time(time).null_matrix = [];
            gpssolve.car_counter(car_counter).time(time).geo_matrix = [];
            gpssolve.car_counter(car_counter).time(time).lla = [];
            gpssolve.car_counter(car_counter).time(time).gpsTime = [];
            X = [];
            return;
        end



        
        %% initialize temporary storage for this time step
        pRange=zeros(1,AsatNum); %initialize temporary storage
        xSat=zeros(1,AsatNum); %initialize temporary storage
        ySat=zeros(1,AsatNum); %initialize temporary storage
        zSat=zeros(1,AsatNum); %initialize temporary storage
        vxSat=zeros(1,AsatNum); %initialize temporary storage
        vySat=zeros(1,AsatNum); %initialize temporary storage
        vzSat=zeros(1,AsatNum); %initialize temporary storage
        ionDelay=zeros(1,AsatNum); %initialize temporary storage
        clkBias=zeros(1,AsatNum); %intialize matrix to store
        GPSt=zeros(1,AsatNum); %intialize matrix to store
        SOFTt=zeros(1,AsatNum); %intialize matrix to store
        X=zeros(AsatNum,3); %form a vector for wagenbach_GPS_solve_with_null
        Vsat=zeros(AsatNum,3);%form a vector for wagenbach_GPS_solve_with_null

    
        %% switch between available satellites to transfer values from sirfdata to current variables
        for satSeq=1:AsatNum
        
            %load all the datas from sirfdata of this car,this timestep into
            %the temporary matrix
            pRange(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).pRange; %load the Prange 
            xSat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).xSat; %load the x position of Sat 
            ySat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).ySat; %load the y position of Sat 
            zSat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).zSat; %load the z position of Sat 
            vxSat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).vxSat; %load the x velocity of Sat 
            vySat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).vySat; %load the y velocity of Sat 
            vzSat(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).vzSat; %load the z velocity of Sat 
            ionDelay(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).ionDelay; %load the ion Delay of Sat 
            %Here use ionDelay to get a revised pRange
            pRange(1,satSeq)=pRange(1,satSeq)-ionDelay(1,satSeq); %elminate the influence of ionospheric error
            clkBias(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).clkBias; %load the ion Delay of Sat 
            GPSt(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).gpsTime; %load the gps time of Sat 
            SOFTt(1,satSeq)=sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).softwareTime; %load the siftwareTime of Sat         
            X(satSeq,:)=[xSat(1,satSeq),ySat(1,satSeq),zSat(1,satSeq)]; %create temporary X matrix to store the sat position data
            Vsat(satSeq,:)=[vxSat(1,satSeq),vySat(1,satSeq),vzSat(1,satSeq)]; %create temporary sat velocity matrix to store the data       
        end
        
        
        %% here gets the receiver position related results 
        % include: Position, Residual, Null matrix, Geo matix, LLA
        % position, gps time
        [gpssolve.car_counter(car_counter).time(time).posEstStnd, gpssolve.car_counter(car_counter).time(time).deltaRange, ...,
            gpssolve.car_counter(car_counter).time(time).null_matrix, gpssolve.car_counter(car_counter).time(time).geo_matrix] ...,
            = sun_GPS_solve(X,Vsat,pRange',clkBias',GPSt',SOFTt');  %function call to GPS solver. the output is calculated XYZ position
        gpssolve.car_counter(car_counter).time(time).parity_no_difference = gpssolve.car_counter(car_counter).time(time).null_matrix' * ...,
            gpssolve.car_counter(car_counter).time(time).deltaRange';
        [reflat,reflon,refalt]=wgsxyz2lla(gpssolve.car_counter(car_counter).time(time).posEstStnd'); %xyz to lla
        gpssolve.car_counter(car_counter).time(time).lla=[reflon,reflat,refalt]; %lla position
        gpssolve.car_counter(car_counter).time(time).gpsTime=round(sirfdata(car_counter).state(time).satellite(satellite_carrier(satSeq)).gpsTime); %record the current gps Time.


end