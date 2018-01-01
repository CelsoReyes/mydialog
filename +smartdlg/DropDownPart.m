classdef DropDownPart < smartdlg.SmartDlgPart
    %DROPDOWNPART drop down menu
    %
    
    % note about uidropdown
    %    if the ItemsData field is empty, then 'Value' contains the string
    %    otherwise, 'Value' is whichever item is in ItemsData(n)
    %    eg.  dd.Items={'A','B','C'} %Assume User selected 'B'
    %         dd.ItemsData=''
    %         % then Value is 'B'
    %         dd.ItemsData=[32 48 93]
    %         % then Value is 48
    %         likewise, if ItemsData could be a datetime, cells
    %         %switching back and forth without intermediate [] might give warnings
    %
    %    You can only set the value to either the displayed text (if ItemsData is empty)
    %    or to one of the ItemsData values, in which case, Items will display the appropriately
    %    referenced Items value.
    
    properties
        choices % text to display in drop-down box
        values % values that will be returned, when the equivelent choice is made
        defaultchoice % value to retur upon default.
        label % text label describing this drop-down box
        hlabel % handle for the label
    end
    
    methods(Access=public)
        function obj=DropDownPart(tag, label, choices, values, default, tooltip)
            
            %DROPDOWNPART represents a drop-down menu
            % obj=DROPDOWNPART(obj,tag, label, choices, values, defaultChoice,tooltip)
            %   CHOICES : this is the text that displays in the dropdown box
            %   VALUES : this is value returned, based on the choice
            %   DEFAULT : this should be one of the VALUES
            
            obj.tag=tag;
            obj.label=label;
            obj.choices=choices;
            obj.values=values;
            obj.defaultchoice=default;
            obj.tooltip=tooltip;
        end
        
        function obj=draw(obj,fig, minx, miny, label2fieldratio)
            % DRAW
            % obj=draw(obj,fig, minx, miny)
            % obj=draw(obj,fig, minx, miny, label2fieldratio)
            assert(nargout>0);
            
            if ~exist('label2fieldratio','var')
                label2fieldratio=1/3;
            end
            labelwidth=ceil(obj.width * label2fieldratio);
            popx = labelwidth + minx + 20;
            popwidth=floor( obj.width * (1-label2fieldratio) ) - 20;
            
            % create the label
            obj.hlabel=uilabel('parent',fig,'Style','text',...
                'Text',[obj.label, ' : '],...
                'HorizontalAlignment','right',...
                'Position',[minx miny labelwidth obj.height]);
            obj.height=ceil(obj.hlabel.Extent(4)*1.6);
            obj.hlabel.Position(4)=obj.height;
            
            % create the dropdown
            obj.h=uidropdown('parent',fig,...
                'Value',obj.defaultchoice,...
                'Items',obj.choices,...
                'Tag',obj.tag,...
                'ToolTipString',obj.tooltip,...
                'Position',[popx miny popwidth obj.height]);
            
        end
        
        function enable(obj)
            set([obj.h obj.hlabel],'Enable','on');
        end
        function disable(obj)
            set([obj.h obj.hlabel],'Enable','off');
        end
        
        function [text,n]=Value(obj)
            % VALUE
            % [popupText, positionInPopup]=Value(obj)
            try
                n=obj.h.Value;
            catch
                warning('either prematurely deleted object, or never drawn')
                n=obj.defaultchoice;
            end
            text=obj.choices{n};
        end
    end
end