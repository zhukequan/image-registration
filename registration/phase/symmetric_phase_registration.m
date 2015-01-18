function [update] = symmetric_phase_registration(...
    moving, fixed, movingDeformed, fixedDeformed, ...
    movingCertainty, fixedCertainty, ...
    movingDeformedCertainty, fixedDeformedCertainty, ...
    transformationModel, currentScale)
% PHASE_REGISTRATION Estimates a displacement field using phase-difference
%
% [update] = symmetric_phase_registration(...
%     moving, fixed, movingDeformed, fixedDeformed, ...
%     movingCertainty, fixedCertainty, ...
%     movingDeformedCertainty, fixedDeformedCertainty, ...
%     transformationModel, currentScale)
%
% INPUT ARGUMENTS
% moving                        - Moving iamge
% fixed                         - Fixed image
% movingDeformed                - Deformed moving iamge
% fixedDeformed                 - Deformed fixed image
% movingCertainty               - Certainty mask moving iamge
% fixedCertainty                - Certainty mask fixed image
% movingDeformedCertainty       - Certainty mask deformed moving iamge
% fixedDeformedCertainty        - Certainty mask deformed fixed image
% transformationModel           - Transformation model for estimating the
%                                 displacement field
%                                 'translation', 'affine', 'non-rigid'
% currentScale                  - Current scale
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% update
%  displacementUpdateForward    - Estimated update field from fixed to
%                                 moving deformed
%  displacementUpdateBackward   - Estimated update field from moving to
%                                 fixed deformed
% (only if transformation model is set to translation or affine)
%  transformationMatrixForward  - Estimate transformation matrix from fixed 
%                                 to moving deformed
%  transformationMatrixBackward - Estimate transformation matrix from moving 
%                                 to fixed deformed

% Copyright (c) 2012 Daniel Forsberg
% danne.forsberg@outlook.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

dims = ndims(moving);

if strcmp(transformationModel,'non-rigid')
    switch dims
        case 2
            [update.displacementForward] = morphon2d(...
                movingDeformed, movingDeformedCertainty, ...
                fixed, fixedCertainty, currentScale);
            [update.displacementBackward] = morphon2d(...
                fixedDeformed, fixedDeformedCertainty, ...
                moving, movingCertainty, currentScale);
        case 3
            [update.displacementForward] = morphon3d(...
                movingDeformed, movingDeformedCertainty, ...
                fixed, fixedCertainty, currentScale);
            [update.displacementBackward] = morphon3d(...
                fixedDeformed, fixedDeformedCertainty, ...
                moving, movingCertainty, currentScale);
    end
else
    switch dims
        case 2
            [update.transformationMatrixForward] = ...
                phase_difference_linear_registration2d(...
                movingDeformed, movingDeformedCertainty, ...
                fixed, fixedCertainty,...
                'transformationModel',transformationModel);
            [update.transformationMatrixBackward] = ...
                phase_difference_linear_registration2d(...
                fixedDeformed,fixedDeformedCertainty,...
                moving,movingCertainty,...
                'transformationModel',transformationModel);
        case 3
            [update.transformationMatrixForward] = ...
                phase_difference_linear_registration3d(...
                movingDeformed, movingDeformedCertainty, ...
                fixed, fixedCertainty,...
                'transformationModel',transformationModel);
            [update.transformationMatrixBackward] = ...
                phase_difference_linear_registration3d(...
                fixedDeformed,fixedDeformedCertainty,...
                moving,movingCertainty,...
                'transformationModel',transformationModel);
    end
end