classdef HeaderPart < smartdlg.SmartDlgPart
    %HeaderPart
    % hp = HEADERPART(text, alignment, tooltip)
    % 
    
    
    properties
        text
        alignment
    end
    
    methods(Access=public)
        function obj=HeaderPart(text, alignment, tooltip)
            % HEADERPART
            obj.text=text;
            if ~exist('alignment','var') || isempty('alignment')
                alignment='center';
            end
            assert(ismember(alignment,{'left','center','right'}));
            obj.alignment=alignment;
            
            if exist('tooltip','var')
                obj.tooltip=tooltip;
            end
        end
        
        function obj=draw(obj,fig, minx, miny)
            
            obj.h=uilabel('parent',fig,...
                'Text',[obj.text, ' : '],...
                'FontWeight','bold',...
                'HorizontalAlignment',obj.alignment,...
                'Position',[minx miny obj.width, obj.height]);
            obj.height=obj.h.Extent(4);
        end
        
        function v=Value(obj)
            v=[];
        end
    end
end