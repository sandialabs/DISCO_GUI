classdef Pupil
    %PUPIL The pupil object describes one of the subpupils formed by the
    %fiber relay
    %   int     ID:       the integer indentifier for a certain pupil
    %   double  Center:   [h,k] the center of the circle returned by
    %                       imfindcircles(), and rounded to int.
    %   int  Radius:   Radius of circle returned from infindcircles()
    %   double  Rotation: the DEGREE value of rotation of the pupil
    %   int     Translation: [dRow dCol] translation of pupil's original
    %                        [h,k] to final location
    
    properties
        ID;         % Pupil ID Number
        Center;     % (Row, Col) location of Pupil's center
        Radius;     % Integer radial extent of Pupil
        Rotation;   % Degree value of Pupil Rotation
        Translation;% [dR dC] distance away from Center
        Mask;       % 2x2 Binary Mask of pupil
        Im;         % Image of individual pupil
        Subbed;     % Boolean flag: Has the Pupil been substituted?
    end
    
    methods
        function obj = Pupil()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if nargin ~=0
                
                obj.ID = 0;
                obj.Center = [0,0];
                obj.Radius = 0;
                obj.Rotation = 0;
                obj.Translation = 0;
                obj.Im = [];
                obj.Subbed = 0;
                
            end
        end
        
%         function pupilVector = makeVect(idx)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             pupilVector = nan(idx,1);
%             for i=1:idx
%                 pupilVector(idx,:) =  Pupil;
%             end % end for
%             
%         end
    end
end

