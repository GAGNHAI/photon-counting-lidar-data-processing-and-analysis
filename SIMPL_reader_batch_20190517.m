% ################ modified and appended on 2018-12-13 ################## %
%
clear;
close;
tic;

% % definition of anonymous function
% global dist2d;
% dist2d = @(x1, y1, x2, y2)sqrt((x1 - x2) .^ 2 + (y1 - y2) .^ 2); % 2D  Euclidean distance

% start to read HDF file
simplfiles = dir('simpl*.h5');

grp = 9;
% chl = 4; % 532 nm
chl = 2; % 1064 nm
indStart = 1;
%}

for f = 1:length(simplfiles) - 1
    %%
    h5filename = ([simplfiles(f,1).name]); % identify the MABEL HDF5 file to pass through each function
    data = h5info(h5filename); % generates the structure profile for each HDF5 file being analyzed from which time and elevation data will be called
        
    % read variables from HDF file
    % channel 2: 1064 nm, parallel direction
    % Elapsed seconds since first data point in granuleGPS time = delta_time + gps_sec_offset (in /ancillary_data)
    elev_initial = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/elev'])); % initial range elevations of returned photons
    lat_initial = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/latitude'])); % corresponding latitudes for initial range elevations
    lon_initial = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/longitude'])); % corresponding longitudes for initial range elevations
    time_initial = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/delta_time'])); % timestamp of photons
    
    x_waVelocity = hdf5read(h5filename,([data.Groups((8),1).Groups(3,1).Name,'/x_waVelocity'])); % meters/second
    y_waVelocity = hdf5read(h5filename,([data.Groups((8),1).Groups(3,1).Name,'/y_waVelocity'])); % meters/second
    time_gps = hdf5read(h5filename,('ins/delta_time')); % timestamp of gps, source = Derived (gps_seconds-metadata.gps_sec_offset)

    lat_gps = hdf5read(h5filename,([data.Groups((8),1).Groups(2,1).Name,'/latitude']));
    lon_gps = hdf5read(h5filename,([data.Groups((8),1).Groups(2,1).Name,'/longitude']));
    
%     gps_sec_offset = hdf5read(h5filename,('/ancillary_data/gps_sec_offset')); % to be used
    
    photon_id = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/photon_id'])); % to be used
    shot_num = hdf5read(h5filename,([data.Groups((grp),1).Groups(chl,1).Name,'/shot_num'])); % to be used
    
    %%
    % calculate resultant velocity
    velocity_total = sqrt((x_waVelocity).^2.+(y_waVelocity).^2); % meters/second
    
    % convert time of each photon to distance based on velocity
    [ distances ] = time2distance( velocity_total, time_initial, time_gps ); % unit: meter
    %}
    
    % organize vectors of time, lon, lat and elevation into matrix
    lon_initial_west = lon_initial - 360; % west longitude is expressed as negative, from -180 to 0 degree counterclockwise.
    tlle_initial = [time_initial, lat_initial, lon_initial_west, elev_initial]; % [time, lat, lon, ele]
    
    %% readed data
    % truncate and obtain the photons within the first segment of 1000 m starting from the designated point
    indkm = find(distances >= distances(indStart) & distances - distances(indStart) <= 1000);
    ATD_km = distances(indkm) - distances(indkm(1)); % along track distance of this segment, unit: meter
    ele_km = tlle_initial(indkm, 4); % elevation  of this segment, unit: meter
    ATD_ele_km = [ATD_km, ele_km]; % [ATD, elevation], % 2018-12-05, by Gang
    tlle_km = tlle_initial(indkm, :); % [time, lat, lon, ele] of this segment
    
%     % record the indices of photons for final use
%     indPho = (1:1:size(tlle_initial,1))'; % indices of photons, 2018-12-05, by Gang
%     indPho = indPho(indkm); % indices of photons filtered within 1km, 2018-12-05, by Gang
    
end

toc;