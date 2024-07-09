function StopBar = workbar(fractiondone, message, progtitle)
% WORKBAR Graphically monitors progress of calculations
%
% Version : CUSTOM-1.0
%
%   WORKBAR(X) creates and displays the workbar with the fractional length
%   "X". It is an alternative to the built-in matlab function WAITBAR,
%   Featuring:
%       - Doesn't slow down calculations
%       - Stylish progress look
%       - Requires only a single line of code
%       - Displays time remaining
%       - Display time complete
%       - Capable of title and description
%       - Only one workbar can exist (avoids clutter)
%
%   WORKBAR(X, MESSAGE) sets the fractional length of the workbar as well as
%   setting a message in the workbar window.
%
%   WORKBAR(X, MESSAGE, TITLE) sets the fractional length of the workbar,
%   message and title of the workbar window.
%
%   WORKBAR is typically used inside a FOR loop that performs a lengthy
%   computation.  A sample usage is shown below:
%
%   for i = 1:10000
%       % Calculation
%       workbar(i/10000,'Performing Calclations...','Progress')
%   end
%
%   Another example:
%
%   for i = 1:10000
%         % Calculation
%         if i < 2000,
%              workbar(i/10000,'Performing Calclations (Step 1)...','Step 1')
%         elseif i < 4000
%              workbar(i/10000,'Performing Calclations (Step 2)...','Step 2')
% 	    elseif i < 6000
%              workbar(i/10000,'Performing Calclations (Step 3)...','Step 3')
%         elseif i < 8000
%              workbar(i/10000,'Performing Calclations (Step 4)...','Step 4')
%         else
%              workbar(i/10000,'Performing Calclations (Step 5)...','Step 5')
%         end
%     end
%
% See also: WAITBAR, TIMEBAR, PROGRESSBAR

% Adapted from:
% Chad English's TIMEBAR
% and Steve Hoelzer's PROGRESSBAR
%
% Created by:
% Daniel Claxton
%
% Modified by:
% Felix Chenier to get it compatible with Matlab 2009 and Simulink and
% to add an unknown progress state (call with -1 in fractiondone).

StopBar = 0; %Dummy to use in Simulink as a Matlab Function

persistent progfig progpatch starttime lastupdate text

% Set defaults for variables not passed in
if nargin < 1,
    fractiondone = 0;
end

try
    % Access progfig to see if it exists ('try' will fail if it doesn't)
    dummy = get(progfig, 'UserData');

    % If progress bar needs to be reset, close figure and set handle to empty
    if fractiondone == 0
        delete(progfig) % Close progress bar
        progfig = []; % Set to empty so a new progress bar is created
    end
catch
    progfig = []; % Set to empty so a new progress bar is created
end

if nargin < 2 && isempty(progfig)
    message = '';
end
if nargin < 3 && isempty(progfig)
    progtitle = '';
end

% If task completed, close figure and clear vars, then exit
percentdone = floor(100*fractiondone);
if percentdone == 100 % Task completed
    delete(progfig) % Close progress bar
    clear progfig progpatch starttime lastupdate % Clear persistent vars
    return
end

%if the user closes the progress bar during the data processing
%then this will erase all the variables are return 1 to the output
if isempty(progfig)

    if fractiondone > 0 %User closed the window himself
        delete(progfig) % Close progress bar
        % Clear persistent vars
        clear progfig progpatch starttime lastupdate firstIteration
        StopBar = 1;
        return

    else %We should build the window

        %%%%%%%%%% SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        winwidth = 300; % Width of timebar window
        winheight = 75; % Height of timebar window
        screensize = get(0, 'screensize'); % User's screen size [1 1 width height]
        screenwidth = screensize(3); % User's screen width
        screenheight = screensize(4); % User's screen height
        winpos = [0.5 * (screenwidth - winwidth), ...
            0.5 * (screenheight - winheight), ...
            winwidth, winheight]; % Position of timebar window origin
        wincolor = [0.9254901960784314, ...
            0.9137254901960784, ...
            0.8470588235294118]; % Define window color
        est_text = 'Estimated time remaining: '; % Set static estimated time text
        pgx = [0, 0];
        pgy = [41, 43];
        pgw = [57, 57];
        pgh = [0, -3];
        m = 1;
        %%%%%%%% END SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Initialize progress bar
        progfig = figure('menubar', 'none', ... % Turn figure menu display off
            'numbertitle', 'off', ... % Turn figure numbering off
            'position', winpos, ... % Set the position of the figure as above
            'color', wincolor, ... % Set the figure color
            'resize', 'off', ... % Turn of figure resizing
            'tag', 'timebar'); % Tag the figure for later checking

        work.progtitle = progtitle; % Store initial values for title
        work.message = message; % Store initial value for message
        set(progfig, 'userdata', work); % Save text in figure's userdata

        % ------- Delete Me (Begin) ----------
        %     winchangeicon(progfig,'MavLogo.ico');                   % Change icon (Not Released)
        % ------- Delete Me (End) ------------

        axes('parent', progfig, ... % Set the progress bar parent to the figure
            'units', 'pixels', ... % Provide axes units in pixels
            'pos', [10, winheight - 45, winwidth - 50, 15], ... % Set the progress bar position and size
            'xlim', [0, 1], ... % Set the range from 0 to 1
            'visible', 'off', ... % Turn off axes
            'drawmode', 'fast'); % Draw faster (I dunno if this matters)


        progpatch = patch( ...
            'XData', [1, 0, 0, 1], ... % Initialize X-coordinates for patch
            'YData', [0, 0, 1, 1], ... % Initialize Y-coordinates for patch
            'Facecolor', 'b', ... % Set Color of patch
            'edgecolor', 'none'); % Set the edge color of the patch to none

        framepatch = patch( ...
            'XData', [1, 0, 0, 1], ... % Initialize X-coordinates for patch
            'YData', [0, 0, 1, 1], ... % Initialize Y-coordinates for patch
            'Facecolor', 'none', ... % Set Color of patch
            'edgecolor', 'k'); % Set the edge color of the patch to none

        text(1) = uicontrol(progfig, 'style', 'text', ... % Prepare message text (set the style to text)
            'pos', [10, winheight - 30, winwidth - 20, 20], ... % Set the textbox position and size
            'hor', 'left', ... % Center the text in the textbox
            'backgroundcolor', wincolor, ... % Set the textbox background color
            'foregroundcolor', 0*[1, 1, 1], ... % Set the text color
            'string', message); % Set the text to the input message

        text(2) = uicontrol(progfig, 'style', 'text', ... % Prepare static estimated time text
            'pos', [10, 5, winwidth - 20, 20], ... % Set the textbox position and size
            'hor', 'left', ... % Left align the text in the textbox
            'backgroundcolor', wincolor, ... % Set the textbox background color
            'foregroundcolor', 0*[1, 1, 1], ... % Set the text color
            'string', est_text); % Set the static text for estimated time

        text(3) = uicontrol(progfig, 'style', 'text', ... % Prepare estimated time
            'pos', [135, 5, winwidth - 145, 20], ... % Set the textbox position and size
            'hor', 'left', ... % Left align the text in the textbox
            'backgroundcolor', wincolor, ... % Set the textbox background color
            'foregroundcolor', 0*[1, 1, 1], ... % Set the text color
            'string', ''); % Initialize the estimated time as blank

        text(4) = uicontrol(progfig, 'style', 'text', ... % Prepare the percentage progress
            'pos', [winwidth - 35, winheight - 50, 25, 20], ... % Set the textbox position and size
            'hor', 'right', ... % Left align the text in the textbox
            'backgroundcolor', wincolor, ... % Set the textbox background color
            'foregroundcolor', 0*[1, 1, 1], ... % Set the textbox foreground color
            'string', ''); % Initialize the progress text as blank


        % Set time of last update to ensure a redraw
        lastupdate = clock - 1;

        % Task starting time reference
        if isempty(starttime) | (fractiondone == 0)
            starttime = clock;
        end

    end
end


% Enforce a minimum time interval between updates
if etime(clock, lastupdate) < 0.1
    return
end

% Update progress patch
set(progpatch, 'XData', [0, fractiondone, fractiondone, 0])

% Set all dynamic text
runtime = etime(clock, starttime);
if ~fractiondone,
    fractiondone = 0.001;
end
work = get(progfig, 'userdata');

if ~exist('title', 'var')
    progtitle = work.progtitle;
end
if ~exist('message', 'var')
    message = work.message;
end


timeleft = runtime / fractiondone - runtime;
timeleftstr = sec2timestr(timeleft);
set(text(1), 'string', message);

if fractiondone >= 0
    titlebarstr = sprintf('%2d%%  %s', percentdone, progtitle);
    set(progfig, 'Name', titlebarstr)
    set(text(3), 'string', timeleftstr);
    set(text(4), 'string', [num2str(percentdone), ' %']);
else
    titlebarstr = sprintf('%s', progtitle);
    set(progfig, 'Name', titlebarstr)
    set(text(3), 'string', 'Unknown');
    set(text(4), 'string', '');
end

% Force redraw to show changes
drawnow

% Record time of this update
lastupdate = clock;

end


% ------------------------------------------------------------------------------
function timestr = sec2timestr(sec)

% Convert seconds to hh:mm:ss
h = floor(sec/3600); % Hours
sec = sec - h * 3600;
m = floor(sec/60); % Minutes
sec = sec - m * 60;
s = floor(sec); % Seconds

if isnan(sec),
    h = 0;
    m = 0;
    s = 0;
end

if h < 10;
    h0 = '0';
else h0 = '';
end % Put leading zero on hours if < 10
if m < 10;
    m0 = '0';
else m0 = '';
end % Put leading zero on minutes if < 10
if s < 10;
    s0 = '0';
else s0 = '';
end % Put leading zero on seconds if < 10
timestr = strcat(h0, num2str(h), ':', m0, ...
    num2str(m), ':', s0, num2str(s));

end
