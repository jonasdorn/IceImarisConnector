function setDataVolume( this, stack, channel, timepoint )
% IceImarisConnector:  setDataVolume (public method)
% 
% DESCRIPTION
% 
%   This method sets the data volume to Imaris.
% 
% SYNOPSIS
% 
%   stack = conn.setDataVolume( stack, channel, timepoint )
% 
% INPUT
% 
%   stack    : 3D array of type uint8, uint16 or single
%   channel  : channel number (0/1-based depending on indexing start)
%   timepoint: timepoint number (0/1-based depending on indexing start)
% 
% OUTPUT
% 
%   none

% AUTHORS
%
% Author: Aaron Ponti
% Contributor: Jonas Dorn

% LICENSE
%
% ImarisConnector is a simple commodity class that eases communication between 
% Imaris and MATLAB using the Imaris XT interface.
% Copyright (C) 2011  Aaron Ponti
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

if nargin ~= 4
    % The this parameter is hidden
    error( '3 input parameters expected.' );
end

if this.isAlive( ) == 0
    return
end

% Create an alias
iDataSet = this.mImarisApplication.GetDataSet;

% Check whether we have some voxels in the dataset
if iDataSet.GetSizeX == 0
    return
end

% convert channel, timepoint, to 0-based indexing
channel = channel - this.mIndexingStart;
timepoint = timepoint - this.mIndexingStart;

% Check that the requested channel and timepoint exist
if channel > ( iDataSet.GetSizeC - 1 )
    error( 'The requested channel index is out of bounds.' );
end
if timepoint > ( iDataSet.GetSizeT - 1 )
    error( 'The requested time index is out of bounds.' );
end

% Get the dataset class
switch char( iDataSet.GetType )
    case 'eTypeUInt8',   outDatatype = 'uint8';
    case 'eTypeUInt16',  outDatatype = 'uint16';
    case 'eTypeFloat',   outDatatype = 'single';
    otherwise,
        error('Bad value for mDataSet.mType');
end

% Check that the input and output datatypes match
if ~isa( stack, outDatatype )
    error( 'Data type mismatch.' );
end

% Check that the size matches
outSizes = this.getSizes( );
if ndims( stack ) == 2
    sizes = [ size( stack ) 1 ];
else
    sizes = size( stack );
end
if any( sizes( 1 : 3 ) ~= outSizes( 1 : 3 ) )
    error( 'Data volume size mismatch.' );
end

% Set the stack
switch char( iDataSet.GetType )
    case 'eTypeUInt8',   
        iDataSet.SetDataVolumeAs1DArrayBytes( stack( : ), channel, timepoint );
    case 'eTypeUInt16',
        iDataSet.SetDataVolumeAs1DArrayShorts( stack( : ), channel, timepoint );
    case 'eTypeFloat',
        iDataSet.SetDataVolumeAs1DArrayFloats( stack( : ), channel, timepoint );
    otherwise,
        error('Bad value for type');
end

end
