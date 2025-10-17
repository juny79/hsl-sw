@echo off
net time \\HSL-TIMESRV /set /yes
w32tm /resync /rediscover
