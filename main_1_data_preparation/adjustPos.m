function xAdjust=adjustPos(Prange,GPSt,SOFTt,xSat,vSat)
earthPeriod=23*3600+56*60+04.09053; % this is the period of earth's rotation about its axis
w=2*pi/earthPeriod;
Kmax=length(xSat);
c = 2.99792458e8; %Speed of light
% transitT=80e-3; % this is the initial estimate of the transit time to earth
%  accounting for the earth's rotation
transitT=GPSt-SOFTt+Prange/c; % this method is from the sirf
xAdjust=xSat-vSat.*repmat(transitT,1,3);

for k=1:Kmax
rotateM=[cos(w*transitT(k)) sin(w*transitT(k)) 0;
            -sin(w*transitT(k)) cos(w*transitT(k)) 0;
            0 0 1];
        %doing 2 things at once; 1) adjust xSat(t) to xSat(t-transitT)...
        %         2) applying the rotation matrix to xSat(t-transitT)
        temp=rotateM*xAdjust(k,:)';
        xAdjust(k,:)=temp';
end
