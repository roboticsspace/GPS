function struct=initSirf()
% Jonah Kadoko
% ASAR Tufts University - 2011
% this function is initializes all the variables to 0 for every state of
% the satellites
% make sure that the file format is the same as stated in the importsirf.m
% function
%  initializing the variables
for sat=1:40
    % initializing the satellites
    struct.satellite(sat).sat_ID=0;
    struct.satellite(sat).softwareTime=0;
    struct.satellite(sat).pRange=0;
    struct.satellite(sat).gpsTime=0;
    struct.satellite(sat).xSat=0;
    struct.satellite(sat).ySat=0;
    struct.satellite(sat).zSat=0;
    struct.satellite(sat).vxSat=0;
    struct.satellite(sat).vySat=0;
    struct.satellite(sat).vzSat=0;
    struct.satellite(sat).crPhase=0;
    struct.satellite(sat).crFreq=0;
    struct.satellite(sat).clkBias=0;
    struct.satellite(sat).clkDrift=0;
    struct.satellite(sat).ionDelay=0;
end
struct.xUser=0;
struct.yUser=0;
struct.zUser=0;
struct.vxUser=0;
struct.vyUser=0;
struct.vzUser=0;
struct.availSat=[];
struct.commonTime=0;
end