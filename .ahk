#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Alt	!
; Ctrl	^
; Shift	+
; Win Logo	#
; --
; Space	Space
; Tab	Tab
; Enter	Enter
; Esc	Esc
; Backspace	Backspace
; --
; ↑	Up
; ↓	Down
; ←	Left
; →	Right
; ScrLk	ScrollLock
; Caps Lock	CapsLock
; PrtScn/SysRq	PrintScreen
; Pause/Break	Pause
; see more at http://xahlee.info/mswin/autohotkey_key_notations.html

Esc & j::Send {Left}
Esc & k::Send {Down} 
Esc & i::Send {Up} 
Esc & l::Send {Right}

#s::Send ^s
#q::Send !{F4}
#a::Send ^a
#t::Send ^t
#+t::Send ^+t
#z::Send ^z
#w::Send ^w
#x::Send ^x
#v::Send ^v

