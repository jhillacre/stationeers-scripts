alias daylight r0
alias horiangle r1
alias vertangle r2
alias state r3
alias hrotate r4
alias hpark r5
alias vpark r6
alias ratio r7
alias maxratio r8
alias maxindex r9

# if the panels never move...
# check for new prefab hashs
define heavy -934345724
define heavydual -1545574413
define normal -2045627372
define normaldual -539224550
define daylightsensor 1076425094

init:
move state 6
move hrotate 0
move hpark 0
move vpark 0
move ratio 0
move maxratio 0
move maxindex 0

main:
jal loadDevices
bnez daylight day
night:
bnez state day
move horiangle hpark
move vertangle vpark
day:
beq state 6 waitForDay
beq state 5 stackHRotateToRatio
beq state 4 setHRotateByMaxRatio
beq state 3 waitForNight
beq state 2 waitForDay
beq state 1 setPark
returnToMain:
jal setDevices
j main

stackHRotateToRatio:
move sp 0
move maxratio 0
pushRatio:
jal loadDevices
move hrotate sp
mul hrotate hrotate 90
jal setDevices
sleep 15
lb ratio heavy Ratio Maximum
max maxratio maxratio ratio
lb ratio heavydual Ratio Maximum
max maxratio maxratio ratio
lb ratio normal Ratio Maximum
max maxratio maxratio ratio
lb ratio normaldual Ratio Maximum
max maxratio maxratio ratio
push maxratio
blt sp 4 pushRatio
sub state state 1
j returnToMain

setHRotateByMaxRatio:
move maxratio 0
findMax:
ble sp 0 foundMax
pop ratio
max maxratio maxratio ratio
beq ratio maxratio findMaxSet
j findMax
findMaxSet:
move maxratio ratio
move maxindex sp
j findMax
foundMax:
mul hrotate maxindex 90
sub state state 1
j returnToMain

waitForNight:
bgtz daylight returnToMain
sub state state 1
j returnToMain

waitForDay:
blez daylight returnToMain
sub state state 1
j returnToMain

setPark:
move hpark horiangle
move vpark vertangle
sub state state 1
j returnToMain

loadDevices:
lb daylight daylightsensor Activate 3
lb horiangle daylightsensor Horizontal 3
lb vertangle daylightsensor Vertical 3
j ra

setDevices:
add horiangle horiangle hrotate
sub vertangle 90 vertangle
sb heavy Horizontal horiangle
sb heavy Vertical vertangle
sb heavydual Horizontal horiangle
sb heavydual Vertical vertangle
sb normal Horizontal horiangle
sb normal Vertical vertangle
sb normaldual Horizontal horiangle
sb normaldual Vertical vertangle
s db Setting state
yield
j ra
