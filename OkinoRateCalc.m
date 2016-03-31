function RateOut = OkinoRateCalc(LON,LAT,MODEL,MOVINGPLATE,FIXEDPLATE)
% example RateOut = OkinoRateCalc(-20,-25,'MORVEL','nb','pa')
% INPUTS
% This could be a structure, if you want to change the relative plates used
% LON = longitude
% LAT = latitude
% MODEL = model to use, note that this changes the necessity of the plates
%           MORVEL is most used, i think
% MOVINGPLATE = choose from here: 
%               http://ofgs.aori.u-tokyo.ac.jp/~okino/global_plate_geom.jpg
% FIXEDPLATE = not used in absolute. 

% MODEL List  
% NUVEL-1:(relative motion, Pacific plate fixed)
% NUVEL-1A:(relative motion, Pacific plate fixed)
% Please note that the model parameters for Philippine Sea Plate are based on Seno et al. (JGR, 1993)
% Please note that the velocity calculated based on NUVEL-1 and NUVEL-1A may be 4.5% and <2% faster than those measured by space geodetic methods by using VLBI/SLR (Gordon, Nature 1993)
% NNR-NUVEL-1:(absolute plate motion, no-net rotation)
% NNR-NUVEL-1A:(absolute plate motion, no-net rotation)
% HS3-NUVEL-1A:(absolute plate motion, relative to hotspot frame)
% MORVEL: (new relative motion model for 25 tectonic plates, spreading rates and fault azimuths are used to determine the motions of 19 plates, and GPS station velocites and azimuthal data for 6 smaller plates with little or no connection to the mid-ocean ridges)
% NNR-MORVEL: (absolute plate motion, no-net rotation, for MORVEL 25 plates and Bird(2003) 's 31 plates)

% the url 
okino_rate_calc_url = 'http://ofgs.aori.u-tokyo.ac.jp/~okino/rate_calc_new2012.cgi';
% set up our request form 
FormData = [ ...
    {   'model'         ;   MODEL       } ; ...
    {   'movingplate'   ;   MOVINGPLATE } ; ...
    {   'fixed'         ;   FIXEDPLATE  } ; ...
    {   'lon'           ;   num2str(LON)} ; ...
    {   'lat'           ;   num2str(LAT)}];
% urlread is very easy to use!
page = urlread(okino_rate_calc_url,'post',FormData);

% what we want
peices = {'plate velocity' , 'direction' , 'north component of velocity' , 'east component of velocity ' };
for n = 1:length(peices)
    idx = strfind(page,peices{n});
    startblock = find(page(idx:end) == '[');    
    endblock = find(page(idx:end) == '>');
    val(n) = str2num(page(idx+endblock(1):idx+startblock(1)-2));
end
% construct output structure
RateOut.V_total = val(1);
RateOut.DegFromNorth = val(2);
RateOut.V_north = val(3);
RateOut.V_east = val(4);