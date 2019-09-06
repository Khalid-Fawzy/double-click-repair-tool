;Double click repair tool
;September 2019
;Copyright © 2019 by Khalid Fawzy
;Khalid.Fawzy@yahoo.com
;Created using: Autohotkey
;
;About;
;Double click repair tool is a simple program that will help eliminate extra clicks on a faulty mouse button by specifying minimum time in milliseconds between each click.
;
;Usage:
;> Select the button/s you want to fix.
;> Adjust the time to your liking "100ms is the average".
;> Special keys are the extra macro keys in the mouse, to fix one of them, select from the drop down list the function it is currently mapped to "usually browser back & forward or volume up & down".
;
;Notes:
;> Program must run as administrator to work properly.
;> Due to a weird bug, i had to disable the left click fix from working inside the program itself, this applies only to the left click fix.
;> You can edit Custom_Keys.txt file to add / delete keys.;
;###################################################################

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
#UseHook
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
AppTitle := "Double click repair tool "
AppVersion := "v1.0"
SkippedClicks = 0


IfNotExist, %A_WorkingDir%\Custom_Keys.txt
{
	Try
	{
		FileAppend, None|Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|0|1|2|3|4|5|6|7|8|9|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadDot|NumpadEnter|NumpadMult|NumpadDiv|NumpadAdd|NumpadSub|NumpadDel|NumpadIns|NumpadClear|NumpadUp|NumpadDown|NumpadLeft|NumpadRight|NumpadHome|NumpadEnd|NumpadPgUp|NumpadPgDn|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|Up|Down|Left|Right|PgUp|PgDn|Enter|Escape|Space|Tab|Backspace|Delete|Insert|Shift|LShift|RShift|Ctrl|LCtrl|RCtrl|Alt|LAlt|RAlt|LWin|RWin|CapsLock|ScrollLock|NumLock|PrintScreen|CtrlBreak|Pause|Sleep|!|#|+|^|{|}|WheelDown|WheelUp|WheelLeft|WheelRight|LButton|Rbutton|MButton|XButton1|XButton2|AppsKey, %A_WorkingDir%\Custom_Keys.txt
	}
	Catch
	{
		MsgBox, 4112, % AppTitle . AppVersion, Something went wrong while creating Custom_Keys.txt file!
		ExitApp
	}
}

FileRead, DropDownListItems, Custom_Keys.txt

IfNotExist, %A_WorkingDir%\Settings.ini ;creating Settings.ini file if not existed and giving default values.
{
	iniLButtonChk = 0
	iniLButtonTime = 100
	iniRButtonChk = 0
	iniRButtonTime = 100
	iniMButtonChk = 0
	iniMButtonTime = 100
	iniCustomKey1 = None
	iniCustomKey1Time = 100
	iniCustomKey2 = None
	iniCustomKey2Time = 100
	iniCustomKey3 = None
	iniCustomKey3Time = 100
	iniWheelChk = 0
	iniAdminChk = 0
	iniBeep = 0
	Try
	{
		FileAppend,, Settings.ini
		IniWrite, %iniLButtonChk%, %A_WorkingDir%\Settings.ini, Left Button, Checked
		IniWrite, %iniLButtonTime%, %A_WorkingDir%\Settings.ini, Left Button, Time
		IniWrite, %iniRButtonChk%, %A_WorkingDir%\Settings.ini, Right Button, Checked
		IniWrite, %iniRButtonTime%, %A_WorkingDir%\Settings.ini, Right Button, Time
		IniWrite, %iniMButtonChk%, %A_WorkingDir%\Settings.ini, Middle Button, Checked
		IniWrite, %iniMButtonTime%, %A_WorkingDir%\Settings.ini, Middle Button, Time
		IniWrite, %iniCustomKey1%, %A_WorkingDir%\Settings.ini, CustomKey1, Key Name
		IniWrite, %iniCustomKey1Time%, %A_WorkingDir%\Settings.ini, CustomKey1, Time
		IniWrite, %iniCustomKey2%, %A_WorkingDir%\Settings.ini, CustomKey2, Key Name
		IniWrite, %iniCustomKey2Time%, %A_WorkingDir%\Settings.ini, CustomKey2, Time
		IniWrite, %iniCustomKey3%, %A_WorkingDir%\Settings.ini, CustomKey3, Key Name
		IniWrite, %iniCustomKey3Time%, %A_WorkingDir%\Settings.ini, CustomKey3, Time
		IniWrite, %iniWheelChk%, %A_WorkingDir%\Settings.ini, Mouse Wheel, Checked
		IniWrite, %iniAdminChk%, %A_WorkingDir%\Settings.ini, Administrator, Checked
		IniWrite, %iniBeep%, %A_WorkingDir%\Settings.ini, Beep, Checked
	}
	Catch
	{
		MsgBox, 4112, % AppTitle . AppVersion, Something went wrong while creating Settings.ini file!
		ExitApp
	}
}
else ;reading contents of Settings.ini file
{
	Try
	{
		IniRead, iniLButtonChk, %A_WorkingDir%\Settings.ini, Left Button, Checked
		IniRead, iniLButtonTime, %A_WorkingDir%\Settings.ini, Left Button, Time
		IniRead, iniRButtonChk, %A_WorkingDir%\Settings.ini, Right Button, Checked
		IniRead, iniRButtonTime, %A_WorkingDir%\Settings.ini, Right Button, Time
		IniRead, iniMButtonChk, %A_WorkingDir%\Settings.ini, Middle Button, Checked
		IniRead, iniMButtonTime, %A_WorkingDir%\Settings.ini, Middle Button, Time
		IniRead, iniCustomKey1, %A_WorkingDir%\Settings.ini, CustomKey1, Key Name
		IniRead, iniCustomKey1Time, %A_WorkingDir%\Settings.ini, CustomKey1, Time
		IniRead, iniCustomKey2, %A_WorkingDir%\Settings.ini, CustomKey2, Key Name
		IniRead, iniCustomKey2Time, %A_WorkingDir%\Settings.ini, CustomKey2, Time
		IniRead, iniCustomKey3, %A_WorkingDir%\Settings.ini, CustomKey3, Key Name
		IniRead, iniCustomKey3Time, %A_WorkingDir%\Settings.ini, CustomKey3, Time
		IniRead, iniWheelChk, %A_WorkingDir%\Settings.ini, Mouse Wheel, Checked
		IniRead, iniAdminChk, %A_WorkingDir%\Settings.ini, Administrator, Checked
		IniRead, iniBeep, %A_WorkingDir%\Settings.ini, Beep, Checked
	}
	Catch
	{
		MsgBox, 4112, % AppTitle . AppVersion, Something went wrong while reading from Settings.ini file, try deleting the file!
		ExitApp
	}
}

if (A_IsAdmin) ;if the script is running as administrator, skip to main section below
	Goto Main
	
IfExist, %A_WorkingDir%\Settings.ini
{
	IniRead, iniAdminChk, %A_WorkingDir%\Settings.ini, Administrator, Checked ;checking the Administrator value from Settings.ini, if set to 1 the script will restart as Administrator.
	if (iniAdminChk = 1)
	{
	Try
	{
       	if A_IsCompiled
           Run *RunAs "%A_ScriptFullPath%" /restart
       	else
           Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
   	}
   	Catch
   	{
		MsgBox, 4112, % AppTitle . AppVersion, Something went wrong!
		ExitApp
   	}
	}
}

if !(A_IsAdmin) ;if the script is not running as administrator, warn the user and offer to restart the script as Administrator
{
	MsgBox, 4132, % AppTitle . AppVersion, Program must run as Administrator in order to work properly, Restart app as Administrator?
	ifMsgBox yes
	{
    Try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    Catch
    {
		MsgBox, 4112, % AppTitle . AppVersion, Something went wrong!
		ExitApp
    }
	}
}

;#############################################
;#############################################
;########### MAIN SECTION ####################
;#############################################
;#############################################
Main:
Gui, MainApp: New, , % AppTitle . AppVersion
Gui, MainApp: Font, s10
Gui, MainApp: Add, Checkbox, xm w250 Section Checked%iniLButtonChk% vLeftMouseButton gChkBox1, Left Mouse Button
Gui, MainApp: Add, Edit, x+1 w50 h20 Center Limit3 Number vMyEdit1 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown1 Range1-999, %iniLButtonTime%
Gui, MainApp: Add, Checkbox, xs w250 Checked%iniRButtonChk% vRightMouseButton gChkBox2, Right Mouse Button
Gui, MainApp: Add, Edit, x+1 w50 h20 Center Limit3 Number vMyEdit2 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown2 Range1-999, %iniRButtonTime%
Gui, MainApp: Add, Checkbox, xs w250 Checked%iniMButtonChk% vMiddleMouseButton gChkBox3, Middle Mouse Button
Gui, MainApp: Add, Edit, x+1 w50 h20 Center Limit3 Number vMyEdit3 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown3 Range1-999, %iniMButtonTime%
Gui, MainApp: Add, Text, xs, Custom Key1:
Gui, MainApp: Add, DropDownList, x+5 w150 vCustomKey1Choice gDDL1, %DropDownListItems%
Gui, MainApp: Add, Edit, x+11 w50 h20 Center Limit3 Number vMyEdit4 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown4 Range1-999, %iniCustomKey1Time%
Gui, MainApp: Add, Text, xs, Custom Key2:
Gui, MainApp: Add, DropDownList, x+5 w150 vCustomKey2Choice gDDL2, %DropDownListItems%
Gui, MainApp: Add, Edit, x+11 w50 h20 Center Limit3 Number vMyEdit5 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown5 Range1-999, %iniCustomKey2Time%
Gui, MainApp: Add, Text, xs, Custom Key3:
Gui, MainApp: Add, DropDownList, x+5 w150 vCustomKey3Choice gDDL3, %DropDownListItems%
Gui, MainApp: Add, Edit, x+11 w50 h20 Center Limit3 Number vMyEdit6 glblRefresh
Gui, MainApp: Add, UpDown, vMyUpDown6 Range1-999, %iniCustomKey3Time%
Gui, MainApp: Add, Checkbox, xs w170 Checked%iniWheelChk% vDisableMouseWheel gChkBox4, Disable Mouse Wheel.
Gui, MainApp: Font, s10 Norm italic
Gui, Add, StatusBar, vMyStatusBar -Theme Backgrounddedede ;Bar's starting text (omit to start off empty).
SB_SetParts(140,90) ;width of first part
SB_SetText(A_Tab "Skipped Clicks: 0", 1)
if (A_IsAdmin)
{
	SB_SetText(A_Tab "Admin: Yes", 2)
}
else
{
	SB_SetText(A_Tab "Admin: No", 2)
}
SB_SetText(A_Tab "Running...", 3)
Menu, FileMenu, Add, Restart`tCtrl+Shift+R, MenuFileRestart  ; See remarks below about Ctrl+O.
Menu, FileMenu, Add, Suspend`tCtrl+Shift+S, MenuFileSuspend  ; See remarks below about Ctrl+O.
Menu, FileMenu, Add ;Separator line
Menu, FileMenu, Add, Exit`tCtrl+Shift+X, MainAppGuiClose
Menu, SettingsMenu, Add, Always run as Admin, MenuSettingsAdmin
Menu, SettingsMenu, Add, Beep when skippig clicks, MenuSettingsBeep
Menu, HelpMenu, Add, About, HelpForm ;Help
Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
Menu, MyMenuBar, Add, &Settings, :SettingsMenu
if iniAdminChk = 1
{
	Menu, SettingsMenu, Check, Always run as Admin
	AdminChk = 1
}
else
{
	Menu, SettingsMenu, UnCheck, Always run as Admin
	AdminChk = 0
}
if iniBeep = 1
{
	Menu, SettingsMenu, Check, Beep when skippig clicks
	BeepChk = 1
}
else
{
	Menu, SettingsMenu, UnCheck, Beep when skippig clicks
	BeepChk = 0
}
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar

Menu, Tray, NoStandard ; remove standard Menu items
Menu, Tray, Add , Open, ShowGUI ;add an item named Open that shows the script when minimized
Menu, Tray, Add, About, HelpForm ;Help
Menu, Tray, add ;separator
Menu, Tray, Add, Settings, :SettingsMenu
Menu, Tray, add ;separator
Menu, Tray, Add , Restart`tCtrl+Shift+R, MenuFileRestart ;add an item named Open that shows the script when minimized
Menu, Tray, Add , Suspend`tCtrl+Shift+S, MenuFileSuspend ;add an item named Open that shows the script when minimized
Menu, Tray, add ;separator
Menu, Tray, Add , E&xit`tCtrl+Shift+X, MainAppGuiClose ;add an item named Exit that exits the script
Menu, Tray, Default, Open ;choose the default action when tray icon left clicked
Menu, Tray, Icon , %A_ScriptDir%\icon\GreenArrow.ico,, 1
Menu, Tray, Click, 1 ;determining number of left clicks needed to open tray icon
GuiControl, ChooseString, CustomKey1Choice, %iniCustomKey1% ;choosing value of DropDownList1 according to Settings.ini
GuiControl, ChooseString, CustomKey2Choice, %iniCustomKey2% ;choosing value of DropDownList2 according to Settings.ini
GuiControl, ChooseString, CustomKey3Choice, %iniCustomKey3% ;choosing value of DropDownList3 according to Settings.ini
GoSub ChkBox1 ;Jumping to subroutine to activate or deactivate LButton Hotkey according to the checkbox status
GoSub ChkBox2 ;Jumping to subroutine to activate or deactivate RButton Hotkey according to the checkbox status
GoSub ChkBox3 ;Jumping to subroutine to activate or deactivate MButton Hotkey according to the checkbox status
GoSub ChkBox4 ;Jumping to subroutine to activate or deactivate Mouse Wheel according to the checkbox status
GoSub DDL1 ;Jumping to subroutine to activate or deactivate Custom Key1 Hotkey according to the value of DropDownList1
GoSub DDL2 ;Jumping to subroutine to activate or deactivate Custom Key2 Hotkey according to the value of DropDownList2
GoSub DDL3 ;Jumping to subroutine to activate or deactivate Custom Key3 Hotkey according to the value of DropDownList3
Gui, MainApp: +AlwaysOnTop ;-Caption  ;+E0x08000000 ;+ToolWindow
Gui, MainApp: Show, Center AutoSize
Return


;#############################################
;#############################################
;################# LABLES ####################
;#############################################
;#############################################
MenuSettingsAdmin:
if AdminChk = 0
{
	Menu, SettingsMenu, Check, Always run as Admin
	AdminChk = 1
}
else
{
	Menu, SettingsMenu, UnCheck, Always run as Admin
	AdminChk = 0
}
Return

MenuSettingsBeep:
if BeepChk = 0
{
	Menu, SettingsMenu, Check, Beep when skippig clicks
	BeepChk = 1
}
else
{
	Menu, SettingsMenu, UnCheck, Beep when skippig clicks
	BeepChk = 0
}
Return

^+R::
MenuFileRestart:
GoSub SaveSettings
Reload
Return

MenuFileSuspend:
Gui, MainApp:Default
Suspend
if A_IsSuspended = 0
{
	SB_SetText(A_Tab "Running...", 3) ;changing status bar part3 to "Running..."
	Menu, Tray, Icon, %A_ScriptDir%\icon\GreenArrow.ico ;changing tray icon
	Menu, Tray, Rename, Continue`tCtrl+Shift+S, Suspend`tCtrl+Shift+S ;renaming tray menu's "suspend" item to "continue"
	Menu, FileMenu, Rename, Continue`tCtrl+Shift+S, Suspend`tCtrl+Shift+S ;renaming file menu's "suspend" item to "continue"
Return
}
else
{
	SB_SetText(A_Tab "Suspended!", 3) ;changing status bar part3 to "Suspended!"
	Menu, Tray, Icon, %A_ScriptDir%\icon\RedArrow.ico ;changing tray icon
	Menu, Tray, Rename, Suspend`tCtrl+Shift+S, Continue`tCtrl+Shift+S ;renaming tray menu's "continue" item to "suspend"
	Menu, FileMenu, Rename, Suspend`tCtrl+Shift+S, Continue`tCtrl+Shift+S ;renaming file menu's "continue" item to "suspend"
}
Return

MainAppGuiSize: ;Called when the window is resized, minimized, maximized, or restored
if (A_EventInfo = 1) ;When the script is minimized
{
	WinHide ;hide the script
	GoSub SaveSettings ;
}
Return

HelpForm: ;help gui routine
Gui, HelpGui: New, , % AppTitle . AppVersion
Gui, HelpGui: Color, White
Gui, HelpGui: +OwnerMainApp +AlwaysOnTop -Caption +Border
Gui, MainApp: +Disabled
Gui, HelpGui: Font, s10 +Bold
Gui, HelpGui: Add, Text, y+20 Section vHelpText1, %AppTitle%%AppVersion%
Gui, HelpGui: Font, s10 Norm
Gui, HelpGui: Add, Text, y+10 vHelpText2, Copyright(c) 2019
Gui, HelpGui: Add, Text, y+30 w100, Author:
Gui, HelpGui: Add, Text, x+10, Khalid Fawzy
Gui, HelpGui: Add, Text, xs y+10 w100, E-Mail:
Gui, HelpGui: Add, Link, x+10, <a href="Khalid.Fawzy@yahoo.com">Khalid.Fawzy@yahoo.com</a> ;Khalid.Fawzy@yahoo.com
Gui, HelpGui: Add, Text, xs y+10 w100, Created using:
Gui, HelpGui: Add, Text, x+10, AutoHotkey
Gui, HelpGui: Add, GroupBox, xs y+20 Section w400 h180 , Description && Usage:
Gui, HelpGui: Add, Edit, xs+10 ys+30 w380 h130 ReadOnly,
(
%AppTitle%is a simple program that will help eliminate extra clicks on a faulty mouse button by specifying minimum time in milliseconds between each click.

Usage:
> Select the button/s you want to fix.
> Adjust the time to your liking "100ms is the average".
> Special keys are the extra macro keys in the mouse, to fix one of them, select from the drop down list the function it is currently mapped to "usually browser back & forward or volume up & down".

Notes:
> Program must run as administrator to work properly.
> Due to a weird bug, i had to disable the left click fix from working inside the program itself, this applies only to the left click fix.
> You can edit Custom_Keys.txt file to add / delete keys.
)

Gui, HelpGui: Add, GroupBox, xs y+30 Section w400 h180 , License Agreement:
Gui, HelpGui: Add, Edit, xs+10 ys+30 w380 h130 ReadOnly,
(
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY: without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
)

Gui, HelpGui: Add, Button, y+30 w50 Default vHelpButton gHelpGuiGuiClose, OK
Gui, HelpGui: Show, Center AutoSize
GuiControl, Focus, HelpButton
Return

HelpGuiGuiSize: ;Called when the window is resized, minimized, maximized, or restored
;Centering App Title, Copyright & button of HelpGui
GuiControlGet, HelpText1, Pos
CenteredPos := (A_GuiWidth - HelpText1W)/2
GuiControl, MoveDraw, HelpText1, x%CenteredPos%

GuiControlGet, HelpText2, Pos
CenteredPos := (A_GuiWidth - HelpText2W)/2
GuiControl, MoveDraw, HelpText2, x%CenteredPos%

GuiControlGet, HelpButton, Pos
CenteredPos := (A_GuiWidth - HelpButtonW)/2
GuiControl, MoveDraw, HelpButton, x%CenteredPos%
Return

HelpGuiGuiClose:
HelpGuiGuiEscape:
Gui, MainApp: -Disabled
Gui, HelpGui: Destroy
Return

ShowGUI:
Gui, MainApp: Show, Center AutoSize
Return

lblRefresh: ;
Gui, MainApp: Submit, NoHide
Return

ChkBox1: ;activate or deactivate LButton Hotkey according to the checkbox status
Gui, MainApp: Submit, NoHide
Hotkey, IfWinNotActive, % AppTitle . AppVersion ;To turn off LButton Hotkey while script's window is active, Otherwise the left click hotkey will be bugged when used inside the script's GUI
if (LeftMouseButton = 0)
{
	Hotkey, LButton, LButtonFunc, off
}
else
{
	Hotkey, LButton, LButtonFunc, on
}
Hotkey, IfWinNotActive ;turning off the above IfWinNotActive condition to prevent it from applying to other hotkeys
Return

ChkBox2: ;activate or deactivate RButton Hotkey according to the checkbox status
Gui, MainApp: Submit, NoHide
if (RightMouseButton = 0)
{
	Hotkey, RButton, RButtonFunc, off
}
else
{
	Hotkey, RButton, RButtonFunc, on
}
Return

ChkBox3: ;activate or deactivate MButton Hotkey according to the checkbox status
Gui, MainApp: Submit, NoHide
if (MiddleMouseButton = 0)
{
	Hotkey, MButton, MButtonFunc, off
}
else
{
	Hotkey, MButton, MButtonFunc, on
}
Return

ChkBox4: ;activate or deactivate Mouse Wheel according to the checkbox status
Gui, MainApp: Submit, NoHide
if (DisableMouseWheel = 0)
{
	Hotkey, WheelDown, MouseWheelFunc, off
	Hotkey, WheelUp, MouseWheelFunc, off
}
else
{
	Hotkey, WheelDown, MouseWheelFunc, on
	Hotkey, WheelUp, MouseWheelFunc, on
}
Return

DDL1: ;activate or deactivate Custom Key1 Hotkey according to the value of DropDownList1
Gui, MainApp: Submit, NoHide
if (CustomKey1 <> "None" And CustomKey1 <> "")
	Hotkey, %CustomKey1%, CustomKey1Func, off
CustomKey1 = %CustomKey1Choice%
if (CustomKey1 <> "None" And CustomKey1 <> "")
	Hotkey, %CustomKey1%, CustomKey1Func, on
Return

DDL2: ;activate or deactivate Custom Key2 Hotkey according to the value of DropDownList2
Gui, MainApp: Submit, NoHide
if (CustomKey2 <> "None" And CustomKey2 <> "")
	Hotkey, %CustomKey2%, CustomKey2Func, off
CustomKey2 = %CustomKey2Choice%
if (CustomKey2 <> "None" And CustomKey2 <> "")
	Hotkey, %CustomKey2%, CustomKey2Func, on
Return

DDL3: ;activate or deactivate Custom Key3 Hotkey according to the value of DropDownList3
Gui, MainApp: Submit, NoHide
if (CustomKey3 <> "None" And CustomKey3 <> "")
	Hotkey, %CustomKey3%, CustomKey3Func, off
CustomKey3 = %CustomKey3Choice%
if (CustomKey3 <> "None" And CustomKey3 <> "")
	Hotkey, %CustomKey3%, CustomKey3Func, on
Return

SaveSettings:
Try
{
	IniWrite, %LeftMouseButton%, %A_WorkingDir%\Settings.ini, Left Button, Checked
	IniWrite, %MyEdit1%, %A_WorkingDir%\Settings.ini, Left Button, Time
	IniWrite, %RightMouseButton%, %A_WorkingDir%\Settings.ini, Right Button, Checked
	IniWrite, %MyEdit2%, %A_WorkingDir%\Settings.ini, Right Button, Time
	IniWrite, %MiddleMouseButton%, %A_WorkingDir%\Settings.ini, Middle Button, Checked
	IniWrite, %MyEdit3%, %A_WorkingDir%\Settings.ini, Middle Button, Time
	IniWrite, %CustomKey1Choice%, %A_WorkingDir%\Settings.ini, CustomKey1, Key Name
	IniWrite, %iniCustomKey1Time%, %A_WorkingDir%\Settings.ini, CustomKey1, Time
	IniWrite, %CustomKey2Choice%, %A_WorkingDir%\Settings.ini, CustomKey2, Key Name
	IniWrite, %iniCustomKey2Time%, %A_WorkingDir%\Settings.ini, CustomKey2, Time
	IniWrite, %CustomKey3Choice%, %A_WorkingDir%\Settings.ini, CustomKey3, Key Name
	IniWrite, %iniCustomKey3Time%, %A_WorkingDir%\Settings.ini, CustomKey3, Time
	IniWrite, %DisableMouseWheel%, %A_WorkingDir%\Settings.ini, Mouse Wheel, Checked
	IniWrite, %AdminChk%, %A_WorkingDir%\Settings.ini, Administrator, Checked
	IniWrite, %BeepChk%, %A_WorkingDir%\Settings.ini, Beep, Checked
}
Catch
{
	MsgBox, 4112, % AppTitle . AppVersion, Something went wrong while saving the Settings!
}
Return

^+X:: ;Ctrl+Shift+X to exit the script
MainAppGuiEscape:
MainAppGuiClose:
GoSub SaveSettings
ExitApp

LButtonFunc:
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit1 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {LButton Down}
KeyWait LButton		;physical state
Send {LButton Up}
Return

RButtonFunc: 
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit2 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {RButton Down}
KeyWait RButton		;physical state
Send {RButton Up}
Return

MButtonFunc:
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit3 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {MButton Down}
KeyWait MButton		;physical state
Send {MButton Up}
Return

CustomKey1Func: 
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit4 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {%CustomKey1% Down}
KeyWait %CustomKey1%		;physical state
Send {%CustomKey1% Up}
Return

CustomKey2Func: 
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit5 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {%CustomKey2% Down}
KeyWait %CustomKey2%		;physical state
Send {%CustomKey2% Up}
Return

CustomKey3Func: 
Gui, MainApp:Default
If (A_TimeSincePriorHotkey < MyEdit6 AND A_ThisHotkey = A_PriorHotkey)
{
	SB_SetText(A_Tab "Skipped Clicks: " . SkippedClicks += 1, 1)
	if BeepChk = 1 
		SoundBeep, ,100
	Return
}
Send {%CustomKey3% Down}
KeyWait %CustomKey3%		;physical state
Send {%CustomKey3% Up}
Return

MouseWheelFunc: 
Return ;Do nothing