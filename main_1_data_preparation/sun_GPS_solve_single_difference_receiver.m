function [deltaResidual,null_matrix] = liyan_GPS_solve_single_difference_receiver(refposEst, X,Vsat,pRange,clkBias,GPSt,SOFTt)
%   This function takes information from satellites and computes
%   position difference between two receivers
%   Thanks to Jonah Kadoko, Chris Wagenbach for the bulk of this code.

% k is the total number of satellites
% Xsat(k by 3)- xyz position of satellites; Vsat( k by 3) - velocity of satellites; 
% Prange(k by 1) is pseudorange; clkBias (k by 1) - satellite clock bias; GPSt (k by 1)- GPS time
% SOFTt(k by 1) - GPS software time;

%% Preparation for Geo matrxi construction
K=length(X(:,1,2)); %to get the number of available satellites for current receiver
satPos=adjustPos(pRange(:,2),GPSt(:,2),SOFTt(:,2),X(:,:,2),Vsat(:,:,2)); %adjust the ref receiver's satellite position due to the rotation(it is all the same)
Magnitude=zeros(K,1); %distance between the guess point and the satellite
unitvectorK=zeros(K,3); %initialize unit vector

for i=1:10
    
    %% Construction of Geo matrix
    if (i == 1)
        for k=1:K
            Magnitude(k,1)=norm(satPos(k,:)-refposEst); %to get the Pseudorange 0;
            vector_x0_xk=satPos(k,:)-refposEst; %create a vector pointing from pos-estimated user position x0 to satelltie xk
            unitvectorK(k,:)=1/Magnitude(k,1)*vector_x0_xk;
        end
        geo_matrix=[-1*unitvectorK,ones(K,1)]; %form the geometry matrix
    end
    
    %%get the delta pseudorange residual
    dpRange_residual_u_minus_r=pRange(:,1)-pRange(:,2); %do not have to minus the clkBias since they are the same for both receiver

    dx_and_db_u_minus_r = (transpose(geo_matrix)*geo_matrix)\transpose(geo_matrix)*dpRange_residual_u_minus_r; %This dx is the difference between the user and the ref station
    %dx, dy, dz, db

end
deltaResidual=dpRange_residual_u_minus_r-geo_matrix*dx_and_db_u_minus_r; %the residual
deltaResidual=transpose(deltaResidual); %residual for each satellite
null_matrix = null(geo_matrix');
end