% this program works for the single difference calculation.
function [dPR_res,null_matrix,match_time_ref,satellite_carrier] = sun_position_related_calculation_single_difference(gpssolve,sirfdata,time,car_counter,availsat)
        %% find out the match time
        match_time_ref = sun_synchronize(gpssolve,car_counter,time);
        if match_time_ref == 0
            dPR_res = [];
            null_matrix=[];
            satellite_carrier = [];
            return;
        end

        %% find out the share satellites
        satellite_carrier=intersect(availsat.car_counter(1).time(match_time_ref).satcarrier,...,
                availsat.car_counter(car_counter).time(time).satcarrier);
        AsatNum = length(satellite_carrier);
            
        %% situation without enought sats
        if AsatNum<5  || isempty(gpssolve.car_counter(1).time(match_time_ref).posEstStnd)
            dPR_res = [];
            null_matrix=[];
            satellite_carrier = [];
            return;
        end
        
        %% initialize temporary storage for this time step
        pRange=zeros(2,AsatNum); %initialize temporary storage
        xSat=zeros(2,AsatNum); %initialize temporary storage
        ySat=zeros(2,AsatNum); %initialize temporary storage
        zSat=zeros(2,AsatNum); %initialize temporary storage
        vxSat=zeros(2,AsatNum); %initialize temporary storage
        vySat=zeros(2,AsatNum); %initialize temporary storage
        vzSat=zeros(2,AsatNum); %initialize temporary storage
        ionDelay=zeros(2,AsatNum); %initialize temporary storage
        clkBias=zeros(2,AsatNum); %intialize matrix to store
        GPSt=zeros(2,AsatNum); %intialize matrix to store
        SOFTt=zeros(2,AsatNum); %intialize matrix to store
        X=zeros(AsatNum,3,2); %form a vector for wagenbach_GPS_solve_with_null
        Vsat=zeros(AsatNum,3,2);%form a vector for wagenbach_GPS_solve_with_null

        %% get data for current one
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
            X(satSeq,:,1)=[xSat(1,satSeq),ySat(1,satSeq),zSat(1,satSeq)]; %create temporary X matrix to store the sat position data
            Vsat(satSeq,:,1)=[vxSat(1,satSeq),vySat(1,satSeq),vzSat(1,satSeq)]; %create temporary sat velocity matrix to store the data       
        
        end

        %% get data for the reference one
        for satSeq=1:AsatNum
        
            %load all the datas from sirfdata of this car,this timestep into
            %the temporary matrix
            pRange(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).pRange; %load the Prange 
            xSat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).xSat; %load the x position of Sat 
            ySat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).ySat; %load the y position of Sat 
            zSat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).zSat; %load the z position of Sat 
            vxSat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).vxSat; %load the x velocity of Sat 
            vySat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).vySat; %load the y velocity of Sat 
            vzSat(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).vzSat; %load the z velocity of Sat 
            ionDelay(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).ionDelay; %load the ion Delay of Sat 
            %Here use ionDelay to get a revised pRange
            pRange(2,satSeq)=pRange(2,satSeq)-ionDelay(2,satSeq); %elminate the influence of ionospheric error
            clkBias(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).clkBias; %load the ion Delay of Sat 
            GPSt(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).gpsTime; %load the gps time of Sat 
            SOFTt(2,satSeq)=sirfdata(1).state(match_time_ref).satellite(satellite_carrier(satSeq)).softwareTime; %load the siftwareTime of Sat         
            X(satSeq,:,2)=[xSat(2,satSeq),ySat(2,satSeq),zSat(2,satSeq)]; %create temporary X matrix to store the sat position data
            Vsat(satSeq,:,2)=[vxSat(2,satSeq),vySat(2,satSeq),vzSat(2,satSeq)]; %create temporary sat velocity matrix to store the data       
        end
        
        refposEst=gpssolve.car_counter(1).time(match_time_ref).posEstStnd;
        [dPR_res,null_matrix]=sun_GPS_solve_single_difference_receiver(refposEst,X,Vsat,pRange',clkBias',GPSt',SOFTt');  ...,
            %function call to GPS solver. the output is calculated XYZ position
end