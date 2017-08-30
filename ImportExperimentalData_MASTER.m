function [] = ImportExperimentalData_MASTER(filename, ROIname)
%   function [] =  ()
%
%   Author: Aaron Winder
%   Affiliation: Engineering Science and Mechanics, Penn State University
%   https://github.com/awinde
%
%   DESCRIPTION:
%
%_______________________________________________________________
%   PARAMETERS:
%
%_______________________________________________________________
%   RETURN:
%
%_______________________________________________________________

%% Parse file timestamp
[~,~,~,fileID] = GetFileInfo(filename);
%% Read in .tdms file
[RawData] = ReadInTDMSFile(filename);

%% Track whisker angle
ImgParams.height = RawData.Info.Whisker_Cam_Height_pix;
ImgParams.width = RawData.Info.Whisker_Cam_Width_pix;
ImgParams.BitDepth = 'uint8';
RawData.Data.WhiskerAngle = WhiskerTracker([fileID '_WhiskCam.bin'],ImgParams);

%% Read in CBV
ImgParams.height = RawData.Info.CBV_Cam_Height_pix;
ImgParams.width = RawData.Info.CBV_Cam_Width_pix;
ImgParams.BitDepth = 'uint16';
animal = RawData.Info.Animal_ID;
hem = RawData.Info.Imaged_Hemisphere;
[RawData.Data.CBV.ROIname] = GetROIIntensity([fileid '_WindowCam.bin'],...
    ROIname, ImgParams, animal, hem);