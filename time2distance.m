function [ distances, avgVelocity ] = time2distance( velocity, time_initial, time_gps )

% tic;

% distances = zeros(numel(time_initial), 1);
timeFirst = time_initial(1);
timeEnd = time_initial(end);


indStarts = find(time_gps <= timeFirst);
indStart = indStarts(end);

indEnds = find(time_gps >= timeEnd);
indEnd = indEnds(1);

indFlight = (indStart:1:indEnd)';
avgVelocity = mean(velocity(indFlight)); % meters/second

%{
count = 1;
for i = 1:1:numel(indFlight) - 1
    i
    iAvgVelocity = mean(velocity(i:i + 1)); % average velocity, unit: meters/second
    
    iPhotonTime = time_initial(time_initial >= time_gps(indFlight(i)) & time_initial < time_gps(indFlight(i) + 1));
    iPhotonNumber = numel(iPhotonTime);
    
    dT = iPhotonTime - timeFirst; % time increment, unit: second
    distances(count:count + iPhotonNumber - 1,1) = iAvgVelocity .* dT;
    
    count = count + iPhotonNumber;
end
%}

%
dT = time_initial - timeFirst; % time increment, unit: second
distances = avgVelocity .* dT; % unit: meter
%}

% toc;
end


