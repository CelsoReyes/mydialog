function reposition(uielement, spacing, varargin)
    % REPOSITION Reposition the elements within an App figure (UIFIGURE).
    %
    % REPOSITION(uielement, spacing [, option list])
    %
    % options:
    %     GROW_CONTAINER : Adjust the Height of the container to match items within
    %     FILL_WIDTH : Sets the width of items within the container to the full width 
    %     LEFT_JUSTIFY: moves items to left of container (spacing pixels from border)
    %     RECURSE : resize items within containers (with same options)
    
    grow_container = ismember('GROW_CONTAINER',varargin);
    left_justify = ismember('LEFT_JUSTIFY',varargin);
    fill_width = ismember('FILL_WIDTH',varargin);
    recurse = ismember('RECURSE',varargin);
    assert(sum([grow_container, left_justify, fill_width, recurse])==numel(varargin),...
        sprintf('some options were not recogized.\n\n%s',help('smartdlg.reposition')));
    
    ch=uielement.Children;
    z=spacing;
    
    % adjust the width and possible starting X of each element in container
    if fill_width
        maxw=uielement.Position(3);
        for n=1:numel(ch)
            if left_justify
                ch(n).Position(2)=spacing;
            end
            ch(n).Position(3)=maxw - 2*ch(n).Position(1);
        end
    end
    
    % adjust the Z value of each object in containter
    for i=numel(ch):-1:1
        if startsWith(class(ch(i)),'matlab.ui.container') 
            if recurse
            smartdlg.reposition(ch(i),spacing,varargin{:});
            end
            if ~isempty(ch(i).Title)
                ch(i).Position(4) = ch(i).Position(4)+ch(i).FontSize+3;
            end
        end
        ch(i).Position(2)=z;
        z=z+ch(i).Position(4)+spacing;
    end
    
    % adjust the height of the container
    if grow_container
        uielement.Position(4)=z;
    end
end
