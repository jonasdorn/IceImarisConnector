function stack = getDataVolumeRM( this, channel, timepoint, iDataset )
% Imaris Connector:  getDataVolumeRM (public method)
% 
% DESCRIPTION
% 
%   This method returns the data volume from Imaris in row-major order.
% 
% SYNOPSIS
% 
%   (1) stack = imarisConnector.getDataVolume( channel, timepoint )
%   (2) stack = imarisConnector.getDataVolume( channel, timepoint, iDataset )
% 
% INPUT
% 
%   channel  : channel number (0/1-based depending on indexing start)
%   timepoint: timepoint number (0/1-based depending on indexing start)
%   dataset  : (optional) get the data volume from the passed IDataset
%               object instead of current one; if omitted, current dataset
%               (i.e. this.mImarisApplication.mDataset) will be used.
%               This is useful for instance when masking channels.
% 
% OUTPUT
% 
%   stack    : data volume (3D matrix)

% Author: Aaron Ponti

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

% Initialize stack
stack = [ ];

if this.isAlive( ) == 0
    return
end

% We let getDataVolume do the parameter checking
stack = this.getDataVolume( channel, timepoint, iDataset );

% Now we permute the stack
stack = permute( stack, [ 2 1 3 ] );

if nargin < 3 || nargin > 4
    % The this parameter is hidden
    error( '2 or 3 input parameters expected.' );
end

end
