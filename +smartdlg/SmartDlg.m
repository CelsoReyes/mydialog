classdef SmartDlg < handle
    % SMARTDLG create a smart dialog box
    % 
    %
    % Usage:
    %
    %    % create a dialog box containing:
    %    %  1. a drop-down menu
    %    
    %    % % general usage: (TAG, TEXT/LABEL, CHOICES/FORMAT, DEFAULT, tooltips, [name-value pairs...])
    %    dd = smartdlg.DropDownPart('method',... Tag
    %                               'Choose a method:',... Label/Text
    %                               {'first','second','third'},...
    %                               'second',...                default value
    %                               'Choose a method for calculation');
    %                               % You can add Additional properties [prop, value]: 
    %                                   % ItemsData
    %                               
    %
    %    %  2. a checkbox
    %
    %    cb = smartdlg.CheckboxPart('dodates',... Tag
    %                               'Use date fields?',... Label/Text
    %                               [],...                  UNUSED
    %                               true,...                default value
    %                               'activate date fields');
    %)
    %
    %    %  3-6. four edit fields: 
    %    %    3. text
    %
    %    txf = smartdlg.TextFieldPart('statement',... Tag
    %                               'Saysomething',... Label/Text
    %                               [],...              formatting option (ValueDIsplayFormat)
    %                               'something',...                default value
    %                               'enter some text here');
    %
    %    %    4. numeric
    %
    %    nmf = smartdlg.NumericFieldPart('number',... Tag
    %                               'favorite number',... Label/Text
    %                               '11.4g',...              formatting option (ValueDIsplayFormat)
    %                               42,...                default value
    %                               'enter your favorite number');
    %                               % You can add Additional properties [prop, value]: 
    %                                   % Limits, LowerLimitInclusive, UpperLimitInclusive, RoundFractionalValues
    %
    %    %    5. date
    %
    %    dtf = smartdlg.DateFieldPart('birthday',... Tag
    %                               'Birth date:',... Label/Text
    %                               'yyyy-MM-dd hh:mm:ss',... formatting option
    %                               datetime,...                default value
    %                               'enter your birth day here');
    %                               % You can add Additional properties [prop, value]: 
    %                                   % Limits, LowerLimitInclusive, UpperLimitInclusive, RoundTo ['day','hour','year',etc]
    %
    %    %    6. duration
    %
    %    drf = smartdlg.DurationFieldPart('timelength',... Tag
    %                               'Length of time',... Label/Text
    %                               'days',...  formatting option: 'days','minutes', 'years', etc...
    %                               days(23),...                default value
    %                               'enter some length of time in days');
    %                               % You can add Additional properties [prop, value]: 
    %                                   % Limits, LowerLimitInclusive, UpperLimitInclusive, RoundFractionalValues
    %        
    %   %    7. radio button group
    %
    %    rbg = smartdlg.RadioPart('rbuttons',... Tag
    %                               'Choose a color',... Label/Text
    %                               {'green','red','blue'},...
    %                               'blue',...                default value
    %                               'Choose your first grade teacher's favorite color');
    
    %    % The Checkbox controls whether the  date and duration fields are enabled:
    %
    %    cb.attach([ dtf, drf]);
    %
    %    sdlg = smartdlg.SmartDlg('mydialog',... Tag
    %                               'Dialog Title',... Label/Text
    %                               [dd, cb, txf, dtf, drf, rbg],... all the pieces that belong in this dialog
    %                               [],...                default value
    %                               'tooltip?');
    %   [res, okPressed] = sdlg.Create();
    %
    %   % res will then be a struct with fields that match the Tags.
    %       res.method
    %       res.statement
    %       res.number
    %       etc...
    %    
    
    properties
        parts
        minX=20
        minY=60
        width=330
        results
        okPressed
    end
    
    methods
        function obj = SmartDlg(components)
            obj.parts=components;
        end
        
        function addComponent(obj,component)
            obj.parts(end+1)=component;
        end
        
        function [result, okPressed] = create(obj,mytitle)
            % CREATE displays the dialog box
            % returns the result as a struct tree and also whether ok was pressed
            
            % create the dialog box
            curHeight=obj.calculate_height;
            f = figure('Name',mytitle,'MenuBar','none',...
                'Position',[obj.minX, obj.minY, obj.width+2*obj.minX, obj.calculate_height]);
            
            % add each component
            Y=obj.minY;
            for n=numel(obj.parts):-1:1
                obj.parts(n) = obj.parts(n).draw(f, obj.minX, Y);
                Y=Y+obj.parts(n).height;
            end
            f.Position(4)=obj.calculate_height;
            
            % add OK and Cancel buttons
            obj.addCancelButton([obj.width-200 10 70 obj.minY/2],f);
            obj.addOKButton([obj.width-90 10 70 obj.minY/2],f);
            
            
            obj.results=struct();
            
            % if we are expecting an answer, wait until dialog is finished.
            if nargout > 0
                uiwait(f)
            end
            okPressed = obj.okPressed;
            result=obj.results;
        end
        
    end
    
    methods(Access=private)
        function ht = calculate_height(obj)
            ht=sum([obj.parts.height]);
            ht=ht+obj.minY;
        end
        
        
        function addOKButton(obj,position,f) % add it to Dialog
            % create "go" button -> modifies properties, closes figure, does calculation
            uicontrol('style','pushbutton','String','go',...
                'Position',position,...
                'Callback',@(src,~)obj.okDlg(f));
        end
        
        function addCancelButton(obj,position,f) %add it to Dialog
            % create "cancel" button -> leaves properties unchanged, closes figure
            
            uicontrol('style','pushbutton','String','cancel',...
                'Position',position,...
                'Callback',@(src,~)obj.clearDlg(f));
        end
        
        
        function clearDlg(obj, f)
            % close the dialog box (without making any changes)
            % this should be the callback for the cancel/clear buttons for
            % the interactive dialog boxes
            obj.okPressed=false;
            close(f);
        end
        
                
        function okDlg(obj,f)
            % copy values back to caller hCaller, using tags as reference.
            obj.okPressed=true;
            
            for n=1:numel(obj.parts)
                tag=obj.parts(n).tag;
                if isempty(tag)
                    continue;
                end
                obj.results.(tag) = obj.parts(n).Value;
            end
            close(f);
            
        end
        
    end
            
end
