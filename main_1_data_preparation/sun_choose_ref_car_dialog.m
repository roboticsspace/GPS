%% This function selects a reference car for the simulation
function choice = sun_choose_ref_car_dialog
    % create a dialog box for the user to choose the experiment car
    d = dialog('Position',[300 300 250 150],'Name','Select Car');
    % move the dialog box to the center of the screen
    movegui(d, 'center'); 
    
    % set the text in the dialog box
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','Select a car as a ref car');
       
    % set the pop-up menu in the dialog box
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[75 70 100 25],...
           'String',{'m_car1';'m_car2';'m_car3';'s_car'},...
           'Callback',@popup_callback);
       
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
          % idx = get(popup,'Value');
          choice = idx;
    end

end