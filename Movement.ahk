#Requires AutoHotkey v2.0
#SingleInstance Force

; Encoding note (v2): AutoHotkey v2 reads script files as UTF-8 by default, so a
; BOM is no longer strictly required. Saving as "UTF-8 with BOM" is still fine and
; guarantees the special characters below are read correctly on all editors.

; ~~~~~~~~~~~~
; INTRODUCTION
; ~~~~~~~~~~~~
; This script is a collection of keyboard shortcuts which helps with inserting commonly-used special
; characters (especially within STEM fields), and provides Vim-like navigation across the entire OS,
; as well as a collection of other utilities.
;
; This script is written in AutoHotkey (AHK) v2. It was migrated from the original v1 version.
; Any script for AHK will be executable if you have AHK installed on your computer.
; Alternatively, AHK scripts can be compiled to executable, to be used on any computer.
;
; This script is written by Alex Goldstein (algoldst), and is available to the public for free.
; It should not be sold.
; However, it can, and should, be modified to suit its users' needs.


; ~~~~~~~~~~~~~~~~~~~~~~
; AUTOHOTKEY QUICK-START (v2)
; ~~~~~~~~~~~~~~~~~~~~~~
; ##########
; Hotstrings
; ##########
; By far the most common in this script are hotstrings, which replace "hotstring" text with something else.
; For example, a hotstring can replace the literal text "\pi" with "π".
;
; The template for an auto-replace hotstring is:
;    ::X::Y
; where X = abbreviation (key) and Y = replacement text.
; Example:  ::PI::π
;
; A hotstring that runs code (rather than replacing with static text) uses a block:
;    ::X:: {
;        ; ...code...
;    }

; ###################
; Hotstring Modifiers
; ###################
; Modifiers go between the first two colons: :ZZZ:X::Y
;    C   |  Case-sensitive keys
;    ?   |  Trigger even when the abbreviation is inside another word
;    *   |  Trigger immediately (no ending character such as Space needed)
;    O   |  Omit the ending character from the replacement

; #######
; Hotkeys (v2)
; #######
; Hotkeys respond to key combinations. Multi-line hotkeys use braces:
;    XX:: {
;        ; ...code...
;    }
; where XX = key combination. A single-line hotkey needs no braces:  ^e::Send("π")
;
; Special key symbols:
;    ^ = Ctrl   ! = Alt   # = Win   + = Shift

; -------------------------------------------------------------
; ~~~~~~~~~~~~~~~~
; COMMANDS
; ~~~~~~~~~~~~~~~~
;    Key    Replacement
;    \^(       |   ⁽
;    \^)       |   ⁾
;    \PI       |   π  (via Greek keyboard now)
;    \THT      |   θ
;    \DEG      |   °
;    \inf      |   ∞
;    +-        |   ±
;    -+        |   ∓
;    \sqrt     |   √
;    \integ    |   ∫
;    \<=       |   ≤
;    \>=       |   ≥
;    \!=       |   ≠
;    \1/2      |   ½
; Suspend AHK  |  LeftCtrl + RightCtrl  -or-  Ctrl + CapsLock

; ~~~~~~~~~~
; THE SCRIPT
; ~~~~~~~~~~

; ####
; Init (auto-execute section)
; ####

; VIM modal state: 1 = normal mode, 0 = insert mode
normalMode := 1

; Show the blue screen border when entering insert mode? 1 = yes, 0 = no
showInsertBorder := 1

; Superscript/subscript cycling state for CapsLock+^
superscripts := 0

; ConEmu transparency toggle state
isTransparent := 0

; Insert-mode screen border settings (2px, blue)
borderColor := "0000FF"
borderThick := 2
borderGuis  := []

; Obsidian MRU list (most-recently-used window order)
obsidianMRU := []

; Keep CapsLock disabled at the OS level from the start.
SetCapsLockState("AlwaysOff")

; Build the (hidden) insert-mode border windows once at startup.
InitBorder()

; Minimize ScreenRotate App at Startup
if WinWait("Screen Rotate", , 10)   ; Wait up to 10s for the window to appear
    PostMessage(0x112, 0xF020, , , "Screen Rotate")  ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE

; Start the background poll that keeps the Obsidian MRU list in sync.
SetTimer(ObsMRU_Poll, 250)


; ####
; Meta
; ####
; To Suspend the script (e.g. to type the literal "\sqrt", "\deg" etc.):
; Left Ctrl + Right Ctrl  -or-  Ctrl + CapsLock
; #SuspendExempt keeps these hotkeys working WHILE suspended so you can resume.
#SuspendExempt
LCtrl & RCtrl::
^CapsLock:: {
    Suspend(-1)   ; toggle
    if (A_IsSuspended)
        SetCapsLockState("Off")       ; let CapsLock work normally while suspended
    else
        SetCapsLockState("AlwaysOff")  ; re-disable CapsLock when resuming
}

; Reload the script after changing .ahk file: Win+`
#`::Reload
#SuspendExempt false


; ##################
; Unicode Characters
; ##################

; Disable hotstring replacement if the current window is a code editor (Atom shown as example).
#HotIf !WinActive("ahk_exe atom.exe")

; Superscripts / Subscripts
; Eg. type CapsLock+^ to cycle Super/Sub/off, then "x", "2", etc.
CapsLock & ^:: {
    global superscripts
    ; Cycle through 0 = off, 1 = superscript, 2 = subscript
    superscripts := Mod(superscripts + 1, 3)

    if (superscripts == 0)
        ToolTip()
    else if (superscripts == 1)
        ToolTip("Super")
    else if (superscripts == 2)
        ToolTip("Sub")
}

; --- Superscript hotstrings (active only while superscripts == 1) ---
#HotIf superscripts == 1
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
:?*:r::ʳ
:?*:s::ˢ
:?*:t::ᵗ
:?*:u::ᵘ
:?*:v::ᵛ
:?*:w::ʷ
:?*:x::ˣ
:?*:y::ʸ
:?*:z::ᶻ

; --- Subscript hotstrings (active only while superscripts == 2) ---
#HotIf superscripts == 2
:?*:a::ₐ
:?*:e::ₑ
:?*:h::ₕ
:?*:i::ᵢ
:?*:j::ⱼ
:?*:k::ₖ
:?*:l::ₗ
:?*:m::ₘ
:?*:n::ₙ
:?*:o::ₒ
:?*:p::ₚ
:?*:r::ᵣ
:?*:s::ₛ
:?*:t::ₜ
:?*:u::ᵤ
:?*:v::ᵥ
:?*:x::ₓ

#HotIf   ; end superscript context; the following hotstrings are always active

; Greek Letters
; Removed, using Greek keyboard instead.

:?*:\sect::§

; Mathematical Symbols
:?*:\DEG::°
:?*:\angle::∠
:?*:\perp::⫠
:?*:\inf::∞
:?*:\+-::±
:?*:\-+::∓
:?*:\1/2::½

:?*:\nabla::∇
:?*:\integ::∫
:?*:\cinteg::∮
:?*:\partial::∂

; Nth Root
:?*:\sqrt::√
:?*:\rad::√
:?*:\3rad::∛
:?*:\4rad::∜

; Inequalities
:?*:\<=::≤
:?:\!<::≮
:?:\!<=::≰
:?:\!>::≯
:?:\!>=::≱
:?*:\>=::≥
:?*:\!=::≠
:?*:\?=::≟
:?*:\a=::≅
:?*:\~=::≈

; Arrows - ⭢
:?*:\rarrow::→
:?*:\larrow::←
:?*:\biarrow::↔
:?*:\2arrows::⇄
:?*:\implies::⇒
:?*:\limplies::⇐
:?*:\uarrow::↑
:?*:\darrow::↓
:?*:\therefore::∴

; Statistics
:?*:\bar::{U+0305}
:?*:\hat::{U+0302}

; Symbol Replacements (eg. dash)
:?*:\--::—

; Foreign Language Characters
:?*:''a::á
:?*:''e::é
:?*:''i::í
:?*:''o::ó
:?*:''u::ú
:?*:""o::ö
:?*:""u::ü
:?*:~~n::ñ
:?*:\!!::¡
:?*:\??::¿

; Phone Symbols
:?*:\up::👍
:?*:\down::👎
:?*:\party::🎉
:?*:\heart::💗
:?*:\lit::🔥
:?*:\smile::😊
:?*:\ref::↗

#HotIf   ; end "not Atom" context


; ###############
; Macro Expansion
; ###############

; Date (today) => YYYY.MM.DD
::\td:: {
    SendInput(A_YYYY "." A_MM "." A_DD)
}

; Date (yesterday) => YYYY.MM.DD
::\yd:: {
    today := DateAdd(A_Now, -1, "Days")
    today := FormatTime(today, "yyyy.MM.dd")
    SendInput(today)
}

; Markdown H6 heading
::\h6:: {
    SendInput("{#}{#}{#}{#}{#}{#}{Space}")
}

; Invoke Interactive Python IDLE
::pyi::python -i

; LTSPICE Hotstrings
::\ltlt:: {
    SendText("
(
* NOTES:
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
)")
}

; #############
; Google Sheets
; #############
; References the value of the cell immediately above current.
::\=IND::=INDIRECT( ADDRESS( ROW( ) - 1 , COLUMN( ) ) )


; ########
; CAPSLOCK
; ########
; Source of some of this: https://github.com/ThatOneCoder/ahk/blob/master/Wynshaft.ahk.txt

; Ctrl + CapsLock toggles actual CapsLock
+CapsLock:: {
    if !GetKeyState("CapsLock", "T")
        SetCapsLockState("On")
    else
        SetCapsLockState("AlwaysOff")
}

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; VIM MODAL NAVIGATION
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Normal mode is active by default (normalMode = 1).
; Press 'i' in normal mode to enter insert mode.
; Press Escape or CapsLock in insert mode to return to normal mode.
; In normal mode, CapsLock also acts as Escape.
; Entering insert mode shows a blue border around the screen (replaces the old tooltip).

; --- Helpers to switch modes and drive the border ---
EnterInsert() {
    global normalMode, showInsertBorder
    normalMode := 0
    if (showInsertBorder)
        ShowBorder()
}
ExitInsert() {
    global normalMode
    normalMode := 1
    HideBorder()
}

; --- Enter insert mode (only active in normal mode) ---
#HotIf normalMode
i:: {
    EnterInsert()
}
#HotIf

; --- CapsLock: Escape equivalent in normal mode; exit insert mode in insert mode ---
CapsLock:: {
    global normalMode
    SetCapsLockState("AlwaysOff")
    if (normalMode)
        return
        ;Send("{Escape}")
    else
        ExitInsert()
}

; --- Escape: sends literal Escape ---
$Escape:: {
    Send("{Escape}")
}

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; NORMAL MODE -- VIM hjkl and motion keys
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; NOTE ON MODIFIERS:
;   Ctrl/Alt/Win combos are never bound below, so hotkeys like ^s, !Tab, #e, etc.
;   pass straight through in BOTH modes. Tab, Enter, arrows, etc. are also unbound.
#HotIf normalMode

; hjkl movement (plain = move, +Shift = select)
h::Send("{Left}")
+h::Send("+{Left}")
l::Send("{Right}")
+l::Send("+{Right}")
j:: {
    if WinActive("ahk_exe ONENOTE.EXE")
        SendPlay("{Down}")
    else
        Send("{Down}")
}
+j:: {
    if WinActive("ahk_exe ONENOTE.EXE")
        SendPlay("+{Down}")
    else
        Send("+{Down}")
}
k:: {
    if WinActive("ahk_exe ONENOTE.EXE")
        SendPlay("{Up}")
    else
        Send("{Up}")
}
+k:: {
    if WinActive("ahk_exe ONENOTE.EXE")
        SendPlay("+{Up}")
    else
        Send("+{Up}")
}

; Line / document motions
; 0 = start of line   |  Shift+0 = highlight to BEGINNING of line
0::Send("{Home}")
+0::Send("+{Home}")
; 4 = end of line     |  Shift+4 ($) = highlight to END of line
4::Send("{End}")
+4::Send("+{End}")
; b/w = word left/right (Shift selects)
b::Send("^{Left}")
+b::Send("^+{Left}")
w::Send("^{Right}")
+w::Send("^+{Right}")
; g = top of document  |  Shift+G = highlight to END of document
g::Send("^{Home}")
+g::Send("^+{End}")

; Select current line (v) / whole line incl. wraps (V)
v::Send("{Home}+{End}")
+v:: {
    Send("{Shift Up}")
    Send("{Home}{Home}{Shift Down}{End}{End}{Shift Up}")
}

; Insert line above (o) / below (Shift+O), then enter insert mode.
; Shift is released first so {End}{Enter} isn't turned into Shift+End/Shift+Enter.
o:: {
    Send("{Shift Up}")
    Send("{End}{Enter}")
    EnterInsert()
}
+o:: {
    Send("{Home}{Enter}{Up}")
    EnterInsert()
}

; Undo (u) / Redo (Shift+U)
u::Send("^z")
+u::Send("^y")

; Delete char forward (d)
d::Send("{Delete}")

; Delete word forward (f) = Ctrl+Delete
f::Send("^{Delete}")

; Delete word backward (Backspace) = Ctrl+Backspace in normal mode.
+Backspace::Send("^{Backspace}")

; Yank/copy (y), cut (x), paste (p)
y::Send("^c")
x::Send("^x")
p::Send("^v")

; Append: move right then enter insert mode (a)
a:: {
    Send("{Right}")
    EnterInsert()
}

; --- Suppress all other typing in normal mode (real modal behavior) ---
q::return
e::return
r::return
t::return
s::return
z::return
c::return
n::return
m::return
1::return
2::return
3::return
5::return
6::return
7::return
8::return
9::return

#HotIf

; ##############
; Administrative
; ##############
::a/cp::algoldst@calpoly.edu

; Disable shortcut to open Edge browser from Explorer / Desktop
#HotIf WinActive("ahk_class WorkerW") || WinActive("ahk_class CabinetWClass")
!e::return
#HotIf

; Disable F1 Help in select apps
GroupAdd("Helps", "ahk_exe WINWORD.EXE")
GroupAdd("Helps", "ahk_exe EXCEL.EXE")
GroupAdd("Helps", "ahk_exe POWERPNT.EXE")
GroupAdd("Helps", "ahk_exe notepad.exe")
GroupAdd("Helps", "ahk_class WorkerW")
GroupAdd("Helps", "ahk_class CabinetWClass")

#HotIf WinActive("ahk_group Helps")
F1::return
#HotIf

; ----------------------------------------
; Shortcut to open/cycle Obsidian windows

; --- Helper: remove a value from the MRU list ---
obsMRU_Remove(hwnd) {
    global obsidianMRU
    Loop obsidianMRU.Length {
        if (obsidianMRU[A_Index] = hwnd) {
            obsidianMRU.RemoveAt(A_Index)
            return
        }
    }
}

; --- Helper: push a HWND to the front of the MRU list ---
obsMRU_Touch(hwnd) {
    global obsidianMRU
    obsMRU_Remove(hwnd)
    obsidianMRU.InsertAt(1, hwnd)
}

; --- Background timer: poll the active window and keep MRU in sync ---
; Runs every 250 ms. Adds newly-focused Obsidian windows to the front of the list
; and prunes HWNDs for windows that no longer exist.
ObsMRU_Poll() {
    global obsidianMRU
    ; Prune dead windows
    i := obsidianMRU.Length
    while (i >= 1) {
        if !WinExist("ahk_id " obsidianMRU[i])
            obsidianMRU.RemoveAt(i)
        i--
    }
    ; If the currently active window is an Obsidian window, move it to front
    activeHWND := WinExist("A")
    if !activeHWND
        return
    try
        activeExe := WinGetProcessName("ahk_id " activeHWND)
    catch
        return
    if (activeExe = "Obsidian.exe")
        obsMRU_Touch(activeHWND)
}

; Cycles through all open Obsidian windows on repeated Win+O presses (MRU order).
#o:: {
    global obsidianMRU
    obsWins := WinGetList("ahk_exe Obsidian.exe")

    if (obsWins.Length = 0)   ; No Obsidian windows open
        return

    if (obsWins.Length = 1) { ; Only one -- just activate it
        WinActivate("ahk_id " obsWins[1])
        return
    }

    ; Ensure MRU list contains every currently-open Obsidian window
    for hwnd in obsWins {
        found := false
        for m in obsidianMRU {
            if (m = hwnd) {
                found := true
                break
            }
        }
        if !found
            obsidianMRU.Push(hwnd)
    }

    ; Find the currently active window in the MRU list
    activeHWND := WinExist("A")
    currentIdx := 0
    for idx, m in obsidianMRU {
        if (m = activeHWND) {
            currentIdx := idx
            break
        }
    }

    ; Advance to next in MRU order, wrapping around
    nextIdx := (currentIdx = 0 || currentIdx >= obsidianMRU.Length) ? 1 : currentIdx + 1
    WinActivate("ahk_id " obsidianMRU[nextIdx])
}

; --------------------------------------

; Win+Period opens Shift+RClick Context Menu (in Explorer)
#HotIf WinActive("ahk_class CabinetWClass")
#.:: {
    KeyWait("LWin")
    Send("{Shift down}{AppsKey}{Shift up}")
}
#HotIf

; Win+C switches to cli-calc window if it exists
#c:: {
    if WinExist("cli-calc")
        WinActivate("cli-calc")
}

; Always On Top: Win+Space
#Space::WinSetAlwaysOnTop(-1, "A")

; ConEmu transparency toggle: Alt+`
#HotIf WinActive("ahk_exe ConEmu64.exe")
!`:: {
    global isTransparent
    KeyWait("Alt")
    if (isTransparent) {
        Send("^#y")
        isTransparent := 0
    } else {
        Send("^#t")
        isTransparent := 1
    }
}
#HotIf

; Change Power Plan: Win+F1/F2
; Replace each string with a power plan's GUID (run: powercfg -l)
;#F1::Run("powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e")
;#F2::Run("powercfg -s 7a07f404-58aa-4f23-9464-fbf413247218")


; ###################
; Music/Audio Control
; ###################
; Keyboard Remaps (right-Alt + key)
>!Space::Media_Play_Pause
>!Right::Media_Next
>!Left::Media_Prev
>!Up::Volume_Up
>!Down::Volume_Down

; Show/hide persistent volume control panel: Win+Pause/Break
#Pause:: {
    if WinExist("ahk_exe SndVol.exe") {
        WinClose("ahk_exe SndVol.exe")
    } else {
        Run("C:\Windows\System32\SndVol.exe")
        WinWait("ahk_exe SndVol.exe")
        WinGetPos(, , &Width, &Height, "ahk_exe SndVol.exe")
        if WinExist("ahk_exe SndVol.exe")
            WinActivate("ahk_exe SndVol.exe")
        WinWaitActive("ahk_exe SndVol.exe")
        WinMove(3840 - Width, 1080 - Height, , , "ahk_exe SndVol.exe")
        WinSetAlwaysOnTop(1, "A")
    }
}

; Mouse Remaps

; Reposition window on Right Alt + Click/Drag
; Source: https://autohotkey.com/board/topic/83253-alt-drag-windows/
A_MaxHotkeysPerInterval := 200
RAlt & LButton:: {
    global
    CoordMode("Mouse")  ; Switch to screen/absolute coordinates.
    MouseGetPos(&EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin)
    WinGetPos(&EWD_OriginalPosX, &EWD_OriginalPosY, , , "ahk_id " EWD_MouseWin)
    EWD_WinState := WinGetMinMax("ahk_id " EWD_MouseWin)
    if (EWD_WinState = 0)  ; Only if the window isn't maximized
        SetTimer(EWD_WatchMouse, 10)  ; Track the mouse as the user drags it.
}
EWD_WatchMouse() {
    global
    if !GetKeyState("LButton", "P") {  ; Button released, so drag is complete.
        SetTimer(EWD_WatchMouse, 0)
        return
    }
    if GetKeyState("Escape", "P") {    ; Escape pressed, so drag is cancelled.
        SetTimer(EWD_WatchMouse, 0)
        WinMove(EWD_OriginalPosX, EWD_OriginalPosY, , , "ahk_id " EWD_MouseWin)
        return
    }
    ; Otherwise reposition the window to match the change in mouse coordinates.
    CoordMode("Mouse")
    MouseGetPos(&EWD_MouseX, &EWD_MouseY)
    WinGetPos(&EWD_WinX, &EWD_WinY, , , "ahk_id " EWD_MouseWin)
    SetWinDelay(-1)   ; Makes the move faster/smoother.
    WinMove(EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY, , , "ahk_id " EWD_MouseWin)
    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
}

; Blackout Screen: Win+B
#b::Run("cmd /c scrnsave.scr /s")


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; INSERT-MODE SCREEN BORDER
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Draws a 2px blue border around the entire (virtual) screen while in insert mode.
; Implemented as four thin, always-on-top, click-through GUI windows created once
; at startup and simply shown/hidden as the mode changes.

InitBorder() {
    global borderGuis, borderColor, borderThick
    vx := SysGet(76)   ; SM_XVIRTUALSCREEN  (left)
    vy := SysGet(77)   ; SM_YVIRTUALSCREEN  (top)
    vw := SysGet(78)   ; SM_CXVIRTUALSCREEN (width, all monitors)
    vh := SysGet(79)   ; SM_CYVIRTUALSCREEN (height, all monitors)
    t  := borderThick

    ; Each edge: [x, y, w, h] -> Top, Bottom, Left, Right
    edges := [ [vx,          vy,          vw, t ]
             , [vx,          vy + vh - t, vw, t ]
             , [vx,          vy,          t,  vh]
             , [vx + vw - t, vy,          t,  vh] ]

    for e in edges {
        ; -Caption: no title bar   +ToolWindow: no taskbar button
        ; +E0x20 (WS_EX_TRANSPARENT): click-through
        ; +E0x08000000 (WS_EX_NOACTIVATE): never steal focus
        g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")
        g.BackColor := borderColor
        g.Show("x" e[1] " y" e[2] " w" e[3] " h" e[4] " NoActivate")
        g.Hide()   ; remembers position/size for later re-show
        borderGuis.Push(g)
    }
}

ShowBorder() {
    global borderGuis
    for g in borderGuis
        g.Show("NoActivate")
}

HideBorder() {
    global borderGuis
    for g in borderGuis
        g.Hide()
}


; CHANGELOG:
; 1.2:
; Add changelog. Add undo, delete current word. Add volume up/down keyboard remaps.
; 1.3:
; Add phone symbols: smile, thumbs up/down, fire, party
; 1.4:
; Add LTSpice hotstrings
; 1.5:
; F1 Help disabled in Notepad, Excel, Word, Powerpoint, and Explorer
; 2.0:
; Migrated entire script from AutoHotkey v1 to v2.
; Replaced the "-- INSERT --" tooltip with a 2px blue border around the screen
;   that appears while in Vim insert mode.
