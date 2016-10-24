%% This function selects the section to use for the simulation
function choice = sun_trial_decider
    d = dialog('Position',[300 300 250 150],'Name','Select Section');
    % move the dialog box to the center of the screen
    movegui(d, 'center'); 
    
    % set the text in the dialog box
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','Select a section of the trial');
       
    % set the pop-up menu in the dialog box
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[75 70 100 25],...
           'String',{'entire';'0-1/2';'1/2-1';...
           '0-1/4';'1/4-1/2';'1/2-3/4';'3/4-1';'DOP'},'Callback',@popup_callback);
       
    % set the button in the dialog box
    btn = uicontrol('Parent',d,...
           'Position',[89 20 70 25],...
           'String','Go',...
           'Callback','delete(gcf)');
       
    % set the first choice in the pop-up menu 
    choice = 1;
       
    % uiwait ensures that only the choice after pressing  the button "go"
    % is the one that returns
    uiwait(d);
   
    % set up the call back function for the pop-up menu   
    function popup_callback(popup,callbackdata)
          idx = popup.Value;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          %idx = get(popup,'Value');
          %popup_items = get(popup,'String');
          choice = idx;
       end

end