classdef Pupil
    %PUPIL The pupil object describes one of the subpupils formed by the
    %fiber relay
    %   int     ID:       the integer indentifier for a certain pupil
    %   double  Center:   [h,k] the center of the circle returned by
    %                       imfindcircles(), and rounded to int.
    %   double  Radius:   Radius of circle returned from infindcircles()
    %   double  Rotation: the DEGREE value of rotation of the pupil
    %   int     Translation: [dRow dCol] translation of pupil's original
    %                        [h,k] to final location
    
    properties
        ID;
        Center;
        Radius;
        Rotation;
        Translation;
        Mask;
        Im;
        Subbed;
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

