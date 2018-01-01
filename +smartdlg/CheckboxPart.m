classdef CheckboxPart < SmartDlgPart
    %CheckboxPart add a checkbox to a dialog that is capable of enabling/disabling other controls
    %
    %
    % zcb=CheckboxPart('chk','my checkbox',true,'click me');
    %
    % % add something for this to control...
    % zp=RadioPart('allbuttons','my title',{'c1','c2','c3'},{'choice1', 'other possibility', 'yet another choice'},2,{'tip1','tip2','tip3'})
    % zp=zp.draw(figure,30,30)
    %
    % zcb=zcb.addDependencies(zp);
    % zcb=zcb.draw(gcf,30,150);
    
    properties
        label
        checked
    end
    
    methods(Access=public)
        function obj = CheckboxPart(tag, string, checked, tooltip)
            obj.tag=tag;
            obj.label=string;
            obj.checked=checked;
            obj.tooltip=tooltip;
        end
        
        function obj=draw(obj,fig, minx, miny)
            % DRAW
            % obj=draw(obj,fig, minx, miny) 
            %
            % if this checkbox controls other UI items, then addDependencies
            % should have already been called prior to calling draw
            assert(nargout>0);
            obj.h=uicheckbox('Parent',fig,...
                'Value',obj.checked,...
                'Text',obj.label,...
                'Tag',obj.tag,...
                'Position',[minx, miny, obj.width, obj.height],...
                'ToolTipString',obj.tooltip,...
                'Callback',@(src,~) obj.cb_callback(src));
            obj.height=obj.h.Extent(4)+5;
            obj.h.Position(4) = obj.height;
        end
        
        function v = Value(obj)
            % VALUE get checked-state: true or false
            try
                v= obj.h.Value == 1;
            catch
                warning('either prematurely deleted object, or never drawn')
                v=obj.checked;
            end
        end
        function cb_callback(obj,src)
            %{
            switch src.Value
                case 0
                    for i=1:numel(obj.dependent_objs)
                        obj.dependent_objs(i).disable()
                    end
                case 1
                    for i=1:numel(obj.dependents)
                        obj.dependent_objs(i).enable()
                    end
            end
            %}
        end
    end
end