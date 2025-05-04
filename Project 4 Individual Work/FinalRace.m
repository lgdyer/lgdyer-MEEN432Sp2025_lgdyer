% Simulates the model for 60 mins
% Calls all other relevent scripts
GenTrack;
P4init;
simout = sim("P4_model.slx", "StopTime", "3600");
carX = simout.X.Data;
carY = simout.Y.Data;
tout = simout.tout;

% Race Statistics
race = raceStat(carX, carY, tout, path, simout);
disp(race)

% SOC Graph 
figure;
plot(simout.SOC)
xlabel('Time [s]')
ylabel('Battery SOC')
title('SOC vs. Time')
grid

% Uncomment for Animation
% Animate_Track;