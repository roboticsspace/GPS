function struct=init_struct()
for car_number=1:4
    %initializing the cars
    
    for sat=1:40
        %initializing the satellites
        struct.car(car_number).satellite(sat).sat_ID=0;
        struct.car(car_number).satellite(sat).pRange=0;
        struct.car(car_number).satellite(sat).delta_pRange=0;
    end
end       
    