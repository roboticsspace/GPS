        

function availsat=liyan_low_sat_elimination(availsat,car_counter,time,AsatNum,gpssolve,X,satellite_carrier,elevMax)
        if AsatNum<5;
        availsat.car_counter(car_counter).time(time).availSat=zeros(AsatNum,1); %avoid null in avaiSat
        availsat.car_counter(car_counter).time(time).satcarrier=zeros(1,AsatNum); %avoid null in satcarrier
        availsat.car_counter(car_counter).time(time).elevAngle=zeros(1,AsatNum); %avoid null in elevAngle
        return
        end



        %initialize
        elevAngle=zeros(AsatNum,1); %initialize elevAngle
        Xenu=zeros(AsatNum,3); %initialize Xenu
        azimuth=zeros(AsatNum,1); %initialize azimuth
        
        %Calculate lla position
        [reflat,reflon,refalt]=wgsxyz2lla(gpssolve.car_counter(car_counter).time(time).posEstStnd'); %get lla position
        
        %Calculate Elevation Angle for each sat
        for satSeq=1:AsatNum; %create a sequence to record the avaible satellites 
            Xenu(satSeq,:)=wgsxyz2enu(X(satSeq,:)',reflat,reflon,refalt); %get the enu of satellite satSeq.
            elevAngle(satSeq,1)=asin(Xenu(satSeq,3)/sqrt(Xenu(satSeq,1).^2+Xenu(satSeq,2).^2+Xenu(satSeq,3).^2)); %calculating elevation angle for this sat
            azimuth(satSeq,1)=asin(Xenu(satSeq,1)/sqrt(Xenu(satSeq,1).^2+Xenu(satSeq,2).^2)); %calculate the pseudo azimuth
            % check which quadrant is the point placed
            if Xenu(satSeq,1)>=0 && Xenu(satSeq,2)>=0
                azimuth(satSeq,1) = (azimuth(satSeq,1));
            elseif Xenu(satSeq,1)>0 && Xenu(satSeq,2)<0
                azimuth(satSeq,1) = (pi-azimuth(satSeq,1));
            elseif Xenu(satSeq,1)<=0 && Xenu(satSeq,2)<=0
                azimuth(satSeq,1) = (pi-azimuth(satSeq,1));
            elseif Xenu(satSeq,1)<0 && Xenu(satSeq,2)>0
                azimuth(satSeq,1) = (2*pi+azimuth(satSeq,1));
            end
        end
        elevAngle=elevAngle*180/pi; % elevation angle in degrees
        satK=find(elevAngle>elevMax); % eliminate high elevation satellites
        availsat.car_counter(car_counter).time(time).availSat=satK; %store the available sat number just as sirfdata-avail
        availsat.car_counter(car_counter).time(time).satcarrier=satellite_carrier(satK); %to keep record of the original 
        availsat.car_counter(car_counter).time(time).elevAngle=elevAngle(satK); %store the elevation angle
        availsat.car_counter(car_counter).time(time).azimuth=azimuth(satK); %store the xenu position
end        
        
        