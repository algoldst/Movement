# Movement
AHK Script. Install AutoHotKey to run the `.ahk` file, or download the .exe to run without installing.

### Administrative
~~~
Left & Right Control :: Suspend script temporarily
Win + ` :: Reload script
~~~

### Superscripts/Subscripts

CapsLock + ^ :: Cycles between regular, superscript, and subscript text typing.
A tooltip will appear to show which mode of input the user is in.

### Symbols

Type the part on the right to get the symbol on the left. 
(Note: For capitals, just type any (or all) of the symbol name uppercase.)
~~~
αΑ :: \alpha
βΒ :: \beta
γΓ :: \gamma
δΔ :: \delta
εΕ :: \epsilon
ζΖ :: \zeta
ηΗ :: \eta
θΘ :: \theta
ιΙ :: \iota
κΚ :: \kappa
λΛ :: \lambda
μΜ :: \mu
νΝ :: \nu
ξΞ :: \xi
φΦ :: \phi
ρΡ :: \rho 
σΣ :: \sigma
τΤ :: \tau
υΥ :: \upsilon
φΦ :: \phi
χΧ :: \chi
ψΨ :: \psi
ωΩ :: \omega
℧℧ :: \mho

∇ :: \nabla
∫ :: \integ
∮ :: \cinteg
∂ :: \partial

√ :: \sqrt \rad
∛ :: \3rad
∜ :: \4rad

° :: \deg
∠ :: \angle
⫠ :: \perp
∞ :: \inf
± :: \+-
∓ :: \-+
½ :: \1/2

≤ :: \<=
≮ :: \!<
≰ :: \!<=
≯ :: \!>
≱ :: \!>=
≥ :: \>=
≠ :: \!=
≟ :: \?=
≅ :: \a=
≈ :: \~=

→ :: \rarrow
← :: \larrow
↔ :: \biarrow
⇄ :: \2arrows
⇒ :: \implies
⇐ :: \limplies
↑ :: \uarrow
↓ :: \darrow
∴ :: \therefore

á :: ''a
é :: ''e
í :: ''i
ó :: ''o
ú :: ''u
ö :: ""o
ü :: ""u
ñ :: ~~n
¡ :: \!!
¿ :: \??

~~~

### Expansions

Interactive Python IDLE

```python -i  :: pyi```

Google Sheets - Reference the value of a cell immediately above the current cell.

```=INDIRECT( ADDRESS( ROW( ) - 1 , COLUMN( ) ) )  :: \=IND```

### Navigation

Users of VIM will be familiar with using the keyboard to navigate text. 
This script applies VIM-like navigation to the keyboard directly, by holding the CapsLock key and pressing the corresponding navigation key:

~~~
h :: Left Arrow
l :: Right Arrow
j :: Down Arrow
k :: Up Arrow
w :: Ctrl + Right Arrow (next word)
b :: Ctrl + Left Arrow (previous word)
0 :: Home
$ :: End
g :: Ctrl + Home (go to beginning of document)
G :: Ctrl + End (go to end of document)
v :: Highlight current line
d :: Delete
Backspace :: Ctrl + Delete
~~~

The same navigation keys above can be used for highlighting, by holding down Shift at the same time as CapsLock.

Eg. `Shift + CapsLock + w --> highlight the next word`

### Shortcuts

~~~
Win + C :: Opens Shift + Right Click context menu
This is useful if your keyboard lacks this button.

Win + Space :: Set the current window as "Always on Top." Press again to de-activate.
Right Alt + Mouse Click/Drag :: Repositions window

Right Alt + Space :: Play/Pause Media
Right Ctrl + Right Arrow :: Next Song
Right Ctrl + Left Arrow :: Previous Song
Win + Break :: Show/hide persistent (always on top) volume mixer
~~~
