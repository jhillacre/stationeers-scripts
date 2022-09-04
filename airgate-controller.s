alias doorCommand d0

define CLEAR 0
define OPENALL 1
define OPENINT 2
define OPENEXT 3
define CLOSEINT 4
define CLOSEEXT 5
define CLOSEALL 6

define AIRGATE 1736080881
define RespondToInternal 1
define CLEARCMDSLEEP 0.5
define MAINSLEEP 1

alias doorHash r7
alias doOpen r8
alias doOpenAll r9
alias doClose r10
alias doCloseAll r11

init:
move doorHash AIRGATE
select doOpen RespondToInternal OPENINT OPENEXT
move doOpenAll OPENALL
select doClose RespondToInternal CLOSEINT CLOSEEXT
move doCloseAll CLOSEALL

main:
sleep MAINSLEEP
l r0 doorCommand Setting
beq r0 doOpen open
beq r0 doOpenAll open
beq r0 doClose close
beq r0 doCloseAll close
j main

open:
sb doorHash Open 1
j clear

close:
sb doorHash Open 0

clear:
sleep CLEARCMDSLEEP
s doorCommand Setting CLEAR
j main
