function [ posEstStnd, deltaRange, null_matrix, geo_matrix] = sun_GPS_solve( X,Vsat,pRange,clkBias,GPSt,SOFTt)
%   This function takes information from a single satellite and computes
%   user position
%   Thanks to Jonah Kadoko, Chris Wagenbach for the bulk of this code.

% k is the total number of satellites
% Xsat(k by 3)- xyz position of satellites; Vsat( k by 3) - velocity of satellites; 
% Prange(k by 1) is pseudorange; clkBias (k by 1) - satellite clock bias; GPSt (k by 1)- GPS time
% SOFTt(k by 1) - GPS software time;

%satellites position set up
K=length(X); %to get the number of available satellites
satPos=adjustPos(pRange,GPSt,SOFTt,X,Vsat); %adjust the satellite position due to the rotation

pRange0=zeros(K,1); %initialize Pseudorange 0
Magnitude=zeros(K,1); %distance between the guess point and the satellite
unitvectorK=zeros(K,3); %initialize unit vector
userPosEst=zeros(1,3); %esitimate a postion of the user
bGuess=0; %first guess for a bias
c = 2.99792458e8; %Speed of light

for i=1:10
    
    %calculation for Geo matrix
    for k=1:K
        Magnitude(k,1)=norm(satPos(k,:)-userPosEst); %to get the Pseudorange 0;
        vector_x0_xk=satPos(k,:)-userPosEst; %create a vector pointing from pos-estimated user position x0 to satelltie xk
        unitvectorK(k,:)=1/Magnitude(k,1)*vector_x0_xk;
        pRange0=Magnitude+bGuess-clkBias*c; %
    end
    geo_matrix=[-1*unitvectorK,ones(K,1)]; %form the geometry matrix
    
    %get the delta pseudorange
    dpRange=pRange-pRange0; 

    %use the least square method to get the correction vector,has 4 elements:
    %dx, dy, dz, db
    dx_and_db=(transpose(geo_matrix)*geo_matrix)\transpose(geo_matrix)*dpRange; 
    userPosEst=userPosEst+[dx_and_db(1),dx_and_db(2),dx_and_db(3)]; %renew the position to approach to the real position
    bGuess=bGuess+dx_and_db(4); %to approach to the real bias
    
end

%the final result
posEstStnd(1,:)=userPosEst(1,:); %The final estimated position
deltaRange=transpose(dpRange); %residual for each satellite
null_matrix=null(geo_matrix');  %null space of the geometry matrix

end