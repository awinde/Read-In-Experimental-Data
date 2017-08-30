function [image_mat]=ReadBinaryFileToMatrix(filename, height, width, imgBitDepth)
%   function [image_mat]=ReadBinaryFileToMatrix(filename, height, width, imgBitDepth)
%
%   Author: Aaron Winder
%   Affiliation: Engineering Science and Mechanics, Penn State University
%   https://github.com/awinde
%
%   DESCRIPTION: Reads in a binary image file into a matrix
%
%_______________________________________________________________
%   PARAMETERS:
%               filename - [string] complete file name including extension
%
%               height - [int] height of the grabbed images in pixels, this
%               can be found in the .tdms file notes
%
%               width - [int] width of the grapped images in pixels, this
%               can be found in the .tdms file notes
%
%               imgBitDepth - [string] bit depth of the grabbed images. For
%               the whisker camera, this should be 'uint8', for the CBV
%               camera, this should be 'uint16'
%_______________________________________________________________
%   RETURN:
%               image_mat - [matrix, width x height x frames]
%_______________________________________________________________

% Calculate pixels per frame for fread
pixels_per_frame=width*height;

% open the file , get file size , back to the begining
fid=fopen(filename);
fseek(fid,0, 'eof');
thefile_size=ftell(fid);
fseek(fid,0, 'bof');

% Identify the number of frames to read. Each frame has a previously
% defined width and height (as inputs). uint16 has 2 bytes per pixel, uint8
% has 1 byte per pixel.

% Get the number of bytes
testVariable = zeros(1,imgBitDepth);
varData = whos('testVariable');
numBytes = varData.bytes;

nframes_to_read=floor(thefile_size/(numBytes*pixels_per_frame));
display(['read_binary_file_to_matrix: ' num2str(nframes_to_read)...
    ' frames to read.'])

% PreAllocate
image_mat = zeros(width,height,nframes_to_read,imgBitDepth);
for n=1:nframes_to_read
    z=fread(fid,pixels_per_frame,['*' imgBitDepth],0,'l');
    image_mat(:,:,n) = reshape(z(1:pixels_per_frame),width,height);
end
fclose(fid);
