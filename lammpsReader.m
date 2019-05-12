function [file] = lammpsReader(filename, varargin)
% LAMMPSREADER extracts text and numerical data from lammps dump files into a
% matlab structure variable. It is more computationally efficient that using
% existing function 'importdata' as the size of the data is known in the header
% of the dump file. 
% 
% INPUT
%   filename - name of dump file
%   numHeaderRows - number of header lines in dump file (optional)
%   entryRow - row number of the header containing the number of entries (optional)
%   keyRow - row number of the header containing the keys of the data (optional)
%   keyRemove - number of redundant keys to remove (optional).
% 
% The header lines in a lammps dump file generally have the same format. An
% example is shown below:
%
%   ITEM: TIMESTEP
%   7000000
%   ITEM: NUMBER OF ENTRIES
%   292954
%   ITEM: BOX BOUNDS pp pp pp
%   0 0.0131809
%   0 0.0131534
%   0 0.0131559
%   ITEM: ENTRIES c_pair[1] c_pair[2] c_pair[3] c_pair[4] c_pair[5] c_pair[6] 
% 
% The optional input arguments have defaults which fit this format, and in
% general should not be changed. Nevertheless, the option is provided.
% 
% OUTPUT
%   file - structure variable with header lines in 'textdata' field and numerical data in the 'data' field. 
% 
% This format of the output structure variable follows 'importdata'.
% 
% USAGE 
% % If no optional arguments are required (which should be the case in most
% instances), then the function can be called using:
% 
%   file = lammpsReader('example.dump');
% 
% If optional arguments are required, then use the name-value format typical
% of most matlab functions.
% 
%   file = lammpsReader('example.dump', 'numHeaderRows', 8);
% 
% AUTHOR
% Adnan Sufian
% Department of Civil & Environmental Engineering
% Imperial College London, UK
% e.mail: a.sufian@imperial.ac.uk
% Release data: 02 May 2019

    % Set up the input parser
    p = inputParser;
    addRequired(p, 'filename', @(x) (isfile(x)))
    addParameter(p, 'numHeaderRows', 9, @(x)(and(x>0, floor(x)==x)))
    addParameter(p, 'entryRow', 4, @(x)(and(x>0, floor(x)==x)))
    addParameter(p, 'keyRow', 9, @(x)(and(x>0, floor(x)==x)))
    addParameter(p, 'keyRemove', 2, @(x)(and(x>0, floor(x)==x)))

    parse(p, filename, varargin{:})
    numHeaderRows = p.Results.numHeaderRows;
    keyRow = p.Results.keyRow;
    entryRow = p.Results.entryRow;
    keyRemove = p.Results.keyRemove;

    % Open the file
    fid = fopen(filename);
    
    % Extract the header text data in dump file, including the number of rows
    % and columns of the following data.
    textdata = textscan(fid, '%s', numHeaderRows, 'delimiter', '\n');
    textdata = textdata{1};
    keys = textscan(textdata{keyRow}, '%s');
    numCol = length(keys{1}) - keyRemove;
    numRow = sscanf(textdata{entryRow}, '%d');
    
    % Extract the data following the header as a float, noting that the number
    % of rows and columns should be the same as determined from the header.
    fmt = repmat('%f ', 1, numCol);
    data = textscan(fid, fmt, numRow, 'CollectOutput', 1);
    data = data{1};
    assert(all(size(data)==[numRow,numCol]))

    % bufferSize = 1000000;
    % data = zeros(numRow, numCol);
    % counter = 1;
    % while ~feof(fid)
    %     dataBlock = textscan(fid, fmt, bufferSize, 'CollectOutput', 1);
    %     dataBlock = dataBlock{1};
    %     lenBlock = size(dataBlock, 1);
    %     data(counter:(counter + lenBlock - 1), :) = dataBlock;
    %     counter = counter + lenBlock;
    % end
    % assert(all(size(data)==[numRow,numCol]))

    % Save as a structure variable with fields 'textdata' and 'data' as per
    % the importdata function.
    file.textdata = textdata;
    file.data = data;
    fclose(fid);
end
