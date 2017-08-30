function [ROIIntensity] = GetROIIntensity(filename, ROIname, imgParams, animal, hem)
%   [ROIIntensity] = GetROIIntensity(filename, ROIname, imgParams, animal, hem)
%
%   Author: Aaron Winder
%   Affiliation: Engineering Science and Mechanics, Penn State University
%   https://github.com/awinde
%
%   DESCRIPTION: Create an ROI from camera frames and average the
%   reflectance from the ROI to get a timeseries. Add the result into the
%   *rawdata.mat file.
%   
%_______________________________________________________________
%   PARAMETERS:             
%                   filename - [string]
%
%                   ROIname - [string] Description of ROI
%
%                   imgParams - [struct] structure containing fields:
%                           height - [int] the height of the window image
%                           in pixels, this information can be found in the
%                           .tdms file.
%                           width - [int] the width of the window image in
%                           pixels, this information can be found in the
%                           .tdms file
%                           BitDepth - [string] identifies the bit depth of
%                           the images. The window camera acquires at 12
%                           bits per pixel, the appropriate designator is
%                           'uint16'
%
%                   animal - [string] 
%
%                   hem - [string] identifies the imaged hemisphere ('RH'
%                   or 'LH')
%_______________________________________________________________
%   RETURN:                     
%                   ROIIntensity - [array] time series of the mean 
%                   intensity within the ROI
%_______________________________________________________________

% Import the window camera frames
[Frames]=ReadBinaryFileToMatrix(filename,imgParams.height,...
    imgParams.width,imgParams.BitDepth);

% Load or create a file containing the ROI location
ROIFile = dir('*ROIs.mat');
if not(isempty(ROIFile))
    load(ROIFile.name)
else
    ROIs = [];
end

[~,~,fileDate,~] = GetFileInfo(filename);
strday = ConvertDate(fileDate);

[ROIExists] = CheckROI([ROIname '_' strday]);
if not(ROIExists)
    mask = CreateROI(Frames(:,:,1),[ROIname '_' strday],animal,hem);
elseif ROIExists
    mask = GetROI(Frames(:,:,1),[ROIname '_' strday],animal,hem);
end

nFrames = size(Frames,3);
ROIIntensity = zeros(1,nFrames);
for frameNum = 1:nFrames
    mask = mask.*double(Frames(:,:,frameNum));
    ROIIntensity(frameNum) = mean(nonzeros(mask));
end