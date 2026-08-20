#Requires AutoHotkey v2.0
#SingleInstance Force

; ~~~~~~~~~~~~
; ergo.ahk
; ~~~~~~~~~~~~
; Enforces ergonomic, opposite-handed Shift usage for touch typing.
;
; The rule:
;   - LEFT-hand keys only produce their shifted character with the RIGHT Shift.
;   - RIGHT-hand keys only produce their shifted character with the LEFT Shift.
;   - Using the SAME-hand Shift with a key is BLOCKED (nothing is typed).
;
; Examples:
;   - Left Shift + j / k / 7 (&)   -> works   (j,k,7 are right-hand keys)
;   - Right Shift + a/s/d/f/g / 6  -> works   (all left-hand keys)
;   - Left Shift + a               -> blocked (same hand)
;   - Right Shift + j              -> blocked (same hand)
;
; Hand assignments (standard touch typing):
;   LEFT hand : ` 1 2 3 4 5 6 | q w e r t | a s d f g | z x c v b
;   RIGHT hand: 7 8 9 0 - =    | y u i o p [ ] | h j k l ; ' | n m , . /
;
; Unshifted keys are untouched and type normally.

; ---------------------------------------------------------------
; Key -> shifted-output maps
; ---------------------------------------------------------------

; LEFT-hand keys: require RIGHT Shift to produce the shifted char.
leftHand := Map(
    "``", "~",
    "1", "!", "2", "@", "3", "#", "4", "$", "5", "%", "6", "^",
    "q", "Q", "w", "W", "e", "E", "r", "R", "t", "T",
    "a", "A", "s", "S", "d", "D", "f", "F", "g", "G",
    "z", "Z", "x", "X", "c", "C", "v", "V", "b", "B"
)

; RIGHT-hand keys: require LEFT Shift to produce the shifted char.
rightHand := Map(
    "7", "&", "8", "*", "9", "(", "0", ")", "-", "_", "=", "+",
    "y", "Y", "u", "U", "i", "I", "o", "O", "p", "P", "[", "{", "]", "}",
    "h", "H", "j", "J", "k", "K", "l", "L", ";", ":", "'", "`"",
    "n", "N", "m", "M", ",", "<", ".", ">", "/", "?"
)

; ---------------------------------------------------------------
; Handlers
; ---------------------------------------------------------------

MakeSender(char) {
    return (*) => SendText(char)
}

Blocked(*) {
    return  ; swallow the keystroke
}

; ---------------------------------------------------------------
; Register hotkeys
;   > = Right Shift, < = Left Shift
; ---------------------------------------------------------------

for key, shifted in leftHand {
    Hotkey(">+" key, MakeSender(shifted))  ; correct: right shift
    Hotkey("<+" key, Blocked)              ; wrong: left shift -> blocked
}

for key, shifted in rightHand {
    Hotkey("<+" key, MakeSender(shifted))  ; correct: left shift
    Hotkey(">+" key, Blocked)              ; wrong: right shift -> blocked
}
