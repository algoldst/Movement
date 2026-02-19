; Warning: Make sure to save as UTF-8 with BOM! Regular UTF-8 encodings (without BOM) will be read as ANSI and not work properly.

; ~~~~~~~~~~~~
; INTRODUCTION
; ~~~~~~~~~~~~
; This script is a collection of keyboard shortcuts which helps with inserting commonly-used special
; characters (especially within STEM fields), and provides Vim-like navigation across the entire OS,
; as well as a collection of other utilities.

; How to use this script:
; This script is written in AutoHotKey (AHK).
; Any script for AHK will be executable if you have AHK installed on your computer.
; Alternatively, AHK scripts can be compiled to executable, to be used on any computer.

; This script is written by Alex Goldstein (algoldst), and is available to the public for free.
; It should not be sold.
; However, it can, and should, be modified to suit its users' needs.


; ~~~~~~~~~~~~~~~~~~~~~~
; AUTOHOTKEY QUICK-START
; ~~~~~~~~~~~~~~~~~~~~~~
; ##########
; Hotstrings
; ##########
; By far the most common in this script are hotstrings, which replace "hotstring" text with something else.
; For example, a hotstring can be defined to replace the literal text
;    \pi
; with
;    π.

; The template for a hotstring is as follows:

;    ::X::Y
;    return

; where
;    X       =  abbreviated string (key)
;    Y       =  string to replace the key X
;    return  =  signals the end of the hotstring

; As an example, this script (without the semicolons and indentation):

;    ::PI::π
;    return

; will cause an output "π" whenever the user types "PI" followed by a space.
; Alternatively, the "return" can be omitted if the entire hotstring is only one line:

;    ::PI::π

; The above example accomplishes the same as the first.


; ###################
; Hotstring Modifiers
; ###################
; It is possible, and recommended, to modify hotstrings beyond the basic X->Y format, in order to add
; functionality and responsiveness.
; Modifiers for hotstrings are placed in between first two semicolons, like so:

;    :ZZZ:X::Y
;    return

; where Z = modifier(s)

; For a list of all possible modifiers, check the AutoHotkey documentation.
; This is a list of modifiers used within this script:

;    C   |  Makes keys case-sensitive
;    ?   |  Trigger AHK keys as parts of strings; for example, the key "PI" will be triggered by the string "HAPPINESS." Omitting "?" will only allow keys to be triggered as discrete strings (so that, in order to write "HAPπNESS", AHK would require you to type "HAP" {Space} "PI" {Space} "NESS")
;    *   |  Trigger AHK keys immediately on typing. Default behavior necessitates typing "PI{Space}" before triggering; however, with "*", "PI" is a sufficient trigger without a space following it.
;    O   |  Remove the trailing {Space} from AHK replacements. (Does not work in conjunction with *). For example, typing "PI{Space}" will output "π"; without the "O" modifier, "PI{Space}" will be replaced by "π ".


; #######
; Hotkeys
; #######
; Where hotstrings replace text, hotkeys respond to a combination of keyboard commands, such as Ctrl+Alt+Del.
; Hotkeys follow the template:

;    XX::
;    YYYY
;	 YYYY
;    YYYY
;    return

; where
;    XX     =  hotkey command combination
;    YYYY   =  script to automate
;    return =  signals the end of the hotkey (required)

; As an example, the following script types the character "π" whenever the letter "Ctrl + e" is pressed:

;    ^e::
;    Send π
;    return

; Note that this is a very simple usage of hotkey scripts, which can do much more than simple text replacement.

; Special keys can be represented by the following characters:
;    ^  |  Ctrl
;    !  |  Alt
;    #  |  Win
;    +  |  Shift

; Therefore, instead of "e", we can use ^e, !e, or #e to create a hotkey for Ctrl+E, Alt+E, or Win+E.

; -------------------------------------------------------------
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~
; COMMANDS
; ~~~~~~~~~~~~~~~~
;    Key    Replacement
;    \^(       |   ⁽
;    \^)       |   ⁾
;    \^+       |   ⁺
;    \^-       |   ⁻  (superscript minus)
;    \^1       |   ¹
;    \^2       |   ²
;    \^3       |   ³
;    \^4       |   ⁴
;    \^5       |   ⁵
;    \^6       |   ⁶
;    \^7       |   ⁷
;    \^8       |   ⁸
;    \^9       |   ⁹
;    \^0       |   ⁰
;    \^x       |   ˣ
;    \^y       |   ʸ
;    \^n       |   ⁿ
;    \PI       |   π
;    \THT      |   θ
;    \DEG      |   °
;    \inf      |   ∞
;     \mu      |   μ
;   \lambda    |   λ
;    +-        |   ±
;    -+        |   ∓
;    \sqrt     |   √
;   \sigma     |   Σ
;   \integ     |   ∫
;    \<=       |   ≤
;    \>=       |   ≥
;    \!=       |   ≠
;    \1/2      |   ½
;    Alt+n     |   ñ
; Suspend AHK  |  LeftCtrl + RightCtrl

; ~~~~~~~~~~
; THE SCRIPT
; ~~~~~~~~~~

; ####
; Init
; ####

; Minimize ScreenRotate App at Startup
WinWait , Screen Rotate , , 10 ;Waits 10 seconds for window to appear before timeout
PostMessage, 0x112, 0xF020,,, Screen Rotate ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE

; ####
; Meta
; ####
; To Suspend the script (such as in cases where you wish to type the literal "\sqrt", "\deg" etc.)
; Left Ctrl + Right Ctrl
LCtrl & RCtrl::
Suspend Toggle
Return

; Reload the script after changing .ahk file: Win+`
#`::Reload
Return


; ##################
; Unicode Characters
; ##################

; Disable hotstring replacement script if current window is a code editor.
; Replace / append with your code editor of choice (VSCode, Atom, etc).
; Note: ahk_exe is required, not one of the code editors.
#IfWinNotActive ahk_exe atom.exe

; Superscripts / Subscripts
; Eg. 5^^(^^x^^+^^2^^) --> 5⁽ˣ⁺²⁾
CapsLock & ^::
	; Cycles through 0=off, 1=superscript, 2=subscript
	; If this is the first run, variable has empty string value "". Convert to 0.
	if(superscripts == "")
		superscripts := 0
	
	; Increment superscripts, to cycle through 0,1,2
	superscripts := superscripts+1
	superscripts := mod(superscripts, 3) ; <-- Not sure why this isn't working
	
	; Display ToolTip to indicate which mode we're in (or none if "off")
	if(superscripts == 0)
		ToolTip, 
	if(superscripts == 1)
		ToolTip, Super
	if(superscripts == 2)
		ToolTip, Sub
	
	; Hotstrings
	#If superscripts = 1
		:?*:(::⁽
		:?*:)::⁾
		:?*:+::⁺
		:?*:-::⁻
		:?*:=::⁼
		:?*:/::⸍
		:?*:*:: ⃰

		:?*:1::¹
		:?*:2::²
		:?*:3::³
		:?*:4::⁴
		:?*:5::⁵
		:?*:6::⁶
		:?*:7::⁷
		:?*:8::⁸
		:?*:9::⁹
		:?*:0::⁰

		:?*:a::ᵃ
		:?*:b::ᵇ
		:?*:c::ᶜ
		:?*:d::ᵈ
		:?*:e::ᵉ
		:?*:f::ᶠ
		:?*:g::ᵍ
		:?*:h::ʰ
		:?*:i::ⁱ
		:?*:j::ʲ
		:?*:k::ᵏ
		:?*:l::ˡ
		:?*:m::ᵐ
		:?*:n::ⁿ
		:?*:o::ᵒ
		:?*:p::ᵖ
		:?*:q::
		:?*:r::ʳ
		:?*:s::ˢ
		:?*:t::ᵗ
		:?*:u::ᵘ
		:?*:v::ᵛ
		:?*:w::ʷ
		:?*:x::ˣ
		:?*:y::ʸ
		:?*:z::ᶻ
	#If superscripts = 2
		:?*:a::ₐ
		:?*:b::
		:?*:c::
		:?*:d::
		:?*:e::ₑ
		:?*:f::
		:?*:g::
		:?*:h::ₕ
		:?*:i::ᵢ
		:?*:j::ⱼ
		:?*:k::ₖ
		:?*:l::ₗ
		:?*:m::ₘ
		:?*:n::ₙ
		:?*:o::ₒ
		:?*:p::ₚ
		:?*:q::
		:?*:r::ᵣ
		:?*:s::ₛ
		:?*:t::ₜ
		:?*:u::ᵤ
		:?*:v::ᵥ
		:?*:w::
		:?*:x::ₓ
		:?*:y::
		:?*:z::
	#If
return

; Greek Letters
; Removed, using Greek keyboard instead.

:?*:`\sect::§

; Mathematical Symbols
:?*:`\DEG::°
:?*:`\angle::∠
:?*:`\perp::⫠
:?*:`\inf::∞
:?*:`\+-::±
:?*:`\-+::∓
:?*:\1/2::½

:?*:`\nabla::∇
:?*:`\integ::∫
:?*:`\cinteg::∮
:?*:`\partial::∂

; Nth Root
:?*:`\sqrt::√
:?*:`\rad::√
:?*:`\3rad::∛
:?*:`\4rad::∜

; Inequalities
:?*:`\<=::≤
:?:`\!<::≮
:?:`\!<=::≰
:?:`\!>::≯
:?:`\!>=::≱
:?*:`\>=::≥
:?*:`\!=::≠
:?*:`\?=::≟
:?*:`\a=::≅
:?*:`\~=::≈

; Arrows - ⭢
:?*:`\rarrow::→
:?*:`\larrow::←
:?*:`\biarrow::↔
:?*:`\2arrows::⇄
:?*:`\implies::⇒
:?*:`\limplies::⇐
:?*:`\uarrow::↑
:?*:`\darrow::↓
:?*:`\therefore::∴

; Statistics
:?*:`\bar::{U+0305}
:?*:`\hat::{U+0302}

; Symbol Replacements (eg. dash)
:?*:`\--::—

; Foreign Language Characters
:?*:''a::á
:?*:''e::é
:?*:''i::í
:?*:''o::ó
:?*:''u::ú
:?*:""o::ö
:?*:""u::ü
:?*:~~n::ñ
:?*:`\!!::¡
:?*:`\??::¿

; Phone Symbols
:?*:`\up::👍
:?*:`\down::👎
:?*:`\party::🎉
:?*:`\heart::💗
:?*:`\lit::🔥
:?*:`\smile::😊
:?*:`\ref::↗

#IfWinNotActive

; ###############
; Macro Expansion
; ###############

; Journal Date Breadcrumbs
::`\dbc::
today = %a_now%
today += -1, days
FormatTime, today, %today%, yyyy.MM.dd
SendInput <<[[%today%]] | [[
today = %a_now%
today += 1, days
FormatTime, today, %today%, yyyy.MM.dd
SendInput %today%]]>>
return

; Date
::`\td::
SendInput %A_YYYY%.%A_MM%.%A_DD%
return

::`\yd::  ; 
today = %a_now%
today += -1, days
FormatTime, today, %today%, yyyy.MM.dd
SendInput %today%   
return

::`\h6::
SendInput {#}{#}{#}{#}{#}{#}{Space}
return

; Invoke Interactive Python IDLE
::pyi::python -i
return

; LTSPICE Hotstrings
; Voltage Traces
::v(a[3])+ ::SendInput {Raw}1/5*(V(a[0]) + 2*V(a[1]) + 4*V(a[2]) + 8*V(a[3]))
::v(a[7])+ ::SendInput {Raw}1/5*(V(a[0]) + 2*V(a[1]) + 4*V(a[2]) + 8*V(a[3]) + 16*V(a[4]) + 32*V(a[5]) + 64*V(a[6]) + 128*V(a[7]))

::v(b[3])+ ::SendInput {Raw}1/5*(V(b[0]) + 2*V(b[1]) + 4*V(b[2]) + 8*V(b[3]))
::v(b[7])+ ::SendInput {Raw}1/5*(V(b[0]) + 2*V(b[1]) + 4*V(b[2]) + 8*V(b[3]) + 16*V(b[4]) + 32*V(b[5]) + 64*V(b[6]) + 128*V(b[7]))

::v(c[3])+ ::SendInput {Raw}1/5*(V(s[0]) + 2*V(s[1]) + 4*V(s[2]) + 8*V(s[3]))
::v(c[7])+ ::SendInput {Raw}1/5*(V(s[0]) + 2*V(s[1]) + 4*V(s[2]) + 8*V(s[3]) + 16*V(s[4]) + 32*V(s[5]) + 64*V(s[6]) + 128*V(s[7]))

::`\ltlt::
SendInput `
(
{Raw}* NOTES:
* V[name] [net] [ground=0] PWM (t0 v0 t1 v1 ...)
* V[name] [net] [ground=0] PULSE(V1 V2 Tdelay Trise Tfall Ton Period Ncycles)

* IMPORT MODELS
.lib DetailedModel.mod

* VOLTAGE VDD
VDD VDD 0 5

* VOLTAGE A, B, C
VA A 0 pulse(0 5 4m 100p 100p 4m 8m 1)
VB B 0 pulse(0 5 2m 100p 100p 2m 4m 2)
VC C 0 pulse(0 5 1m 100p 100p 1m 2m 4)

* BUS VOLTAGE A, B
VA3 A[3] 0 pulse(5 0 0 100p 100p 16m 32m)
VA2 A[2] 0 pulse(5 0 0 100p 100p 8m 16m)
VA1 A[1] 0 pulse(5 0 0 100p 100p 4m 8m)
VA0 A[0] 0 pulse(5 0 0 100p 100p 2m 4m)

VB3 B[3] 0 pulse(0 5 15m 100p 100p 16m 32m)
VB2 B[2] 0 pulse(0 5 7m 100p 100p 8m 16m)
VB1 B[1] 0 pulse(0 5 3m 100p 100p 4m 8m)
VB0 B[0] 0 pulse(0 5 1m 100p 100p 2m 4m)


* SIMULATION TYPE:
.tran 31m
)

; #############
; Google Sheets
; #############
; References the value of the cell immediately above current.
::`\=IND::=INDIRECT( ADDRESS( ROW( ) - 1 , COLUMN( ) ) )


; ########
; Window Switching
#o::
SetTitleMatchMode, RegEx
InputBox, winTitle, Switch windows, Enter a window title.,, 300, 125
WinActivate, i)\Q%winTitle%\E
Return


; ########
; CAPSLOCK
; ########
; Source of some of this: https://github.com/ThatOneCoder/ahk/blob/master/Wynshaft.ahk.txt

; Disable CapsLock
    ; Using "AlwaysOff" keeps CapsLock + [any unassigned key] from turning on CapsLock
    ; CapsLock would otherwise turn on from any combination not explicitly assigned
SetCapsLockState, AlwaysOff

; Tilde ~ allows this CapsLock hotkey to run, even if another hotkey is matched later
; E.g. If you hold CapsLock and then press "k", without ~ would cause the Caps+K script to run, but not this one.
; This would only kick off when you release Caps, bc AHK needs to confirm that no other hotkey was matched.
; Whereas, with the ~, this script will run immediately on CapsLock down. Pressing a matching hotkey combo like "k"
; causes a branch to that hotkey script; then, when it's finished executing, returns to here.
; It's kinda like programming and having the stack call another function, and then return.
~CapsLock::
SetCapsLockState, AlwaysOff
timeSinceCapsDown := A_TickCount
; Wait until capslock is released
Keywait, CapsLock
; After Keywait, A_ThisHotkey will either be "~CapsLock", or some other combo (e.g. "CapsLock + k")
mostRecentHotkeyExecuted := A_ThisHotkey
If (A_TickCount - timeSinceCapsDown < 150) && (mostRecentHotkeyExecuted = "~CapsLock")
; Only sends Escape if recent (< 150ms) capslock press, and we didn't trigger any other hotkey combo
Send, {Escape}
Return

Send, {Escape}
return

; Ctrl + CapsLock toggles actual CapsLock
^CapsLock::
if !GetKeyState("CapsLock", "T")
    SetCapsLockState, On
else
    SetCapsLockState, AlwaysOff
return

; CapsLock + hjkl --> VIM hjkl
CapsLock & h::
	Send, {Left}
	return
CapsLock & l::
	Send, {Right}
	return
CapsLock & j::
	if WinActive("ahk_exe ONENOTE.EXE") {
		SendPlay, {Down}
	}
	else {
		Send, {Down}
	}
	return
CapsLock & k::
	if WinActive("ahk_exe ONENOTE.EXE") {
		SendPlay, {Up}
	}
	else {
		Send, {Up}
	}
	return 

; Capslock w,b,0,$,g --> VIM
CapsLock & 0::
Send {Home}
return
CapsLock & $::
Send {End}
return
CapsLock & b::
Send ^{Left}
return
CapsLock & w::
Send ^{Right}
return
CapsLock & g::
Send ^{Home}

; Highlighting
CapsLock & v::
Send, {Home}+{End}
return

#if Getkeystate("Shift","p") ;if shift is held the following hotkey is active.
CapsLock & h::
Send, +{Left}
return
CapsLock & l::
Send, +{Right}
return
CapsLock & j::
	if WinActive("ahk_exe ONENOTE.EXE") {
		SendPlay, +{Down}
	}
	else {
		Send, +{Down}
	}
	return
CapsLock & k::
	if WinActive("ahk_exe ONENOTE.EXE") {
		SendPlay, +{Up}
	}
	else {
		Send, +{Up}
	}
	return 
CapsLock & 0::
Send +{Home}
return
CapsLock & $::
Send +{End}
return
CapsLock & b::
Send ^+{Left}
return
CapsLock & w::
Send ^+{Right}
return
CapsLock & g::
Send ^+{End}
return

CapsLock & v::
Send, {Home}{Home}{ShiftDown}{End}{End}{ShiftUp}
return

; Shift + Caps + O :: Insert Line Below
CapsLock & o::
Send {End}{Enter}
return

#if

; Caps + O :: Insert Line
CapsLock & o::
Send {Home}{Enter}{Up}
return

; Remaps:
CapsLock & u::
Send ^z
return

CapsLock & d::
Send {Delete}
return

; Delete current word
CapsLock & r::
Send ^{Left}
Send ^+{Right}
Send {Delete}
return

CapsLock & Backspace::
Send ^{Delete}
return

; ##############
; Administrative
; ##############
::a/cp::algoldst@calpoly.edu

; Disable shortcut to open Edge browser from Explorer / Desktop
#IfWinActive ahk_class WorkerW CabinetWClass
!e::
return
#IfWinActive

; Disable F1 Help
; For F1 Exclusions
GroupAdd, Helps , ahk_exe WINWORD.EXE
GroupAdd, Helps , ahk_exe EXCEL.EXE 
GroupAdd, Helps , ahk_exe POWERPNT.EXE
GroupAdd, Helps , ahk_exe notepad.exe
GroupAdd, Helps , ahk_class WorkerW 
GroupAdd, Helpls, ahk_class CabinetWClass

#IfWinActive , ahk_group Helps 
F1::
return
#IfWinActive

; Shortcut top open Obsidian
; Note: AHK put flags before a close-parenthesis. i = case-insensitive
!o::
SetTitleMatchMode, RegEx
WinActivate, i).* Obsidian .*
Return

; Win+C opens Shift+RClick Context Menu
#IfWinActive ahk_class CabinetWClass  ; for use in explorer.
#c::
Keywait, LWin
Send, {Shift down}{AppsKey}{Shift up}
;Sleep, 50		; Uncomment these two lines to launch Cmder with Win+C
;Send, c		; The letter sent can be modified (eg. Send, p → Launch powershell here)
return
#IfWinActive

; Always On Top: Win+Space
#SPACE::  Winset, Alwaysontop, , A
#IfWinActive ahk_exe ConEmu64.exe
isTransparent := 0
!`::
Keywait, Alt
If(isTransparent) {
    Send, ^#y
    isTransparent := 0
}
Else {
    Send, ^#t
    isTransparent := 1
}
return
#IfWinActive

; Change Power Plan: Win+F1/F2
; Replace each string with a power plan's GUID (run in command prompt: powercfg -l)
;#F1::Run, powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e
;return
;#F2::Run, powercfg -s 7a07f404-58aa-4f23-9464-fbf413247218
;return


; ###################
; Music/Audio Control
; ###################
; Keyboard Remaps

; Useful on plain keyboards -- leave commented out if your laptops has these hotkeys already.
;ScrollLock:: Send {Volume_Up}
;^ScrollLock::ScrollLock
;PrintScreen:: Send {Volume_Down}
;^PrintScreen::PrintScreen
;break::Send {Volume_Mute} ; PauseBreak key mutes

>!Space::Media_Play_Pause
return
>!Right::Media_Next
>!Left::Media_Prev
>!Up::Volume_Up
>!Down::Volume_Down

; Show/hide persistent volume control panel
#Break::
If WinExist("ahk_exe SndVol.exe"){
    WinClose , ahk_exe SndVol.exe
}
Else{
Run C:\Windows\System32\SndVol.exe,
WinWait, ahk_exe SndVol.exe
WinGetPos ,,, Width, Height, ahk_exe SndVol.exe,,,
If WinExist("ahk_exe SndVol.exe")
    WinActivate, ahk_exe SndVol.exe
WinWaitActive, ahk_exe SndVol.exe
WinMove, ahk_exe SndVol.exe,, 3840-Width, 1080-Height
Winset, Alwaysontop, , A
}
Return

; Mouse Remaps

; LEGACY Modifications for Regular Mouse
; XButton1 toggles the mouse-wheel from scrolling to Volume control.
#MaxHotkeysPerInterval 200
;XButton1::State:=!State
;$WheelUp:: ; $ sign makes the hotkey non-triggerable by the Send command (so as not to introduce infinite loops)
;If State
;Send {Volume_Up}
;Else
;Send {WheelUp}
;Return
;$WheelDown::
;If State
;Send {Volume_Down}
;Else
;Send {WheelDown}
;Return
; Alternatively, if you have a second mouse button to sacrifice:
;XButton2 & WheelUp::Send {Volume_Up}
;XButton2 & WheelDown::Send {Volume_Down}

; Fast Scrolling (press in MButton while scrolling)
;MButton & WheelUp::Send {PgUp}
;MButton & WheelDown::Send {PgDn}
;$MButton::Send {MButton}

; Reposition window on Right Alt + Click/Drag
; Source: https://autohotkey.com/board/topic/83253-alt-drag-windows/
RAlt & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
if EWD_WinState = 0  ; Only if the window isn't maximized
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return
EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return



; Pan-Scrolling using Pen Input
; Scrolling in tablet mode activates with Alt key. Press Alt again to stop scrolling.
; (Mapped Alt key to pen modifier button.)
; isTabletMode := 1
; penScrollActive := 0
; #MaxThreadsPerHotkey 2   ; Allows a second instance to modify penScrollActive while PenScroll is looping.
; $Alt::
; 	; Check if PC is in tablet mode.
; 	;	1 --> Tablet, 0 --> Desktop
; 	RegRead, isTabletMode, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell,TabletMode
; 	if(isTabletMode) {
; 		if(penScrollActive) {
; 			penScrollActive := 0
; 		}
; 		else {
; 			penScrollActive := 1
; 		}
; 	GoSub PenScroll
; 	}
; 	else
; 		Send, {Alt}
; 	return
; PenScroll:
; 	loop {
; 		MouseGetPos, mouseX, mouseY
; 		ToolTip, %mouseX% %mouseY%
; 		Sleep, 20
; 		MouseGetPos, mouseX_new, mouseY_new
; 		if (mouseX_new - mouseX > 0)
; 			Send, {WheelLeft}
; 		else if (mouseX_new - mouseX < 0)
; 			Send, {WheelRight}
; 		if (mouseY_new - mouseY > 0)
; 			Send, {WheelUp}
; 		else if (mouseY_new - mouseY < 0)
; 			Send, {WheelDown}
; 		if (penScrollActive = 0)
; 			break
; 	}
; 	return
; #If penScrollActive
; LButton::Return

; Blackout Screen
#b::Run, cmd /c scrnsave.scr /s


; CHANGELOG:
; 1.2:
; Add changelog.
; Add undo, delete current word.
; Add volume up/down keyboard remaps.

; 1.3:
; Add phone symbols: smile, thumbs up/down, fire, party

; 1.4:
; Add LTSpice hotstrings

; 1.5:
; F1 Help disabled in Notepad, Excel, Word, Powerpoint, and Explorer

