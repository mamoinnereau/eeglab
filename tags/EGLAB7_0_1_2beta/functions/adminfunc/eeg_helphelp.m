% eeg_helphelp() - How to use EEGLAB help.
%
% EEGLAB MENU: 
% Each EEGLAB menu item calls a Matlab function from the commandline. If this 
% function pops up a graphic interface window, the figure title usually 
% contains the name of the function that the window will call. EEGLAB help 
% files are thus simply the collection of all the help files of the called 
% functions. 
%
% FUNCTION CALL CONVENTION:
% When the EEGLAB menu calls a function, it takes the EEG dataset as 
% an argument, sometimes with additional parameters. The function then
% pops-up an interactive window asking for additional parameter values.
% The advantage of this process is that the same function can be called in 
% two ways, either in interactive (pop_) mode or directly from the commandline. 
% This trick allows EEGLAB to build a history of the commands run under an 
% EEGLAB session. (See the eegh() function for details). The command history allows 
% users to build their own EEGLAB macros by copying and pasting commands from 
% the EEGLAB history (using eegh() and pop_saveh()) into new Matlab script files.
%
% EEGLAB HELP WINDOWS:
% The help message of any function may be called from from the EEGLAB menu 
% by opening the 'Help > EEGLAB' menu window. The help message of each function 
% is then displayed. Note that many EEGLAB functions do not actually process 
% data (in particular, the 'pop_' functions). To understand their use, look 
% at the help message for the (non-pop) function they call which actually 
% processes the data. For example, the menu item % "Plot > Channel ERP image" 
% calls the function 'pop_erpimage()'. This function in turn serves as a 
% graphic user interface for the computing and plotting function 'erpimage()'.

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2001 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: not supported by cvs2svn $
% Revision 1.7  2002/11/15 01:29:59  arno
% header for web
%
% Revision 1.6  2002/08/13 18:54:14  scott
% editing help message
%
% Revision 1.5  2002/08/13 16:25:40  scott
% test
%
% Revision 1.4  2002/08/11 17:29:34  arno
% editing header
%
% Revision 1.3  2002/05/01 03:35:25  arno
% editing header
%
% Revision 1.2  2002/04/21 01:04:56  scott
% edited help msg -sm
%
% Revision 1.1  2002/04/05 17:46:04  jorn
% Initial revision
%

help eeg_helphelp
