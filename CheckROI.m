function [isok] = CheckROI(ROIname)
%   function [isok] = CheckROI(ROIname)
%
%   Author: Aaron Winder
%   Affiliation: Engineering Science and Mechanics, Penn State University
%   https://github.com/awinde
%
%   DESCRIPTION: Checks whether the given ROI exists in shared
%   variables.
%   
%_______________________________________________________________
%   PARAMETERS:             
%                   ROIname - [string] a name designating the ROI
%_______________________________________________________________
%   RETURN:                     
%                   isok - [boolean] designates whether ROI exists      
%_______________________________________________________________

ROIfile = ls('*ROIs.mat');
if not(isempty(ROIfile))
    load(ROIfile)
else
    ROIs = [];
end

if isfield(ROIs,ROIname);
    isok = true;
else
    isok = false;
end