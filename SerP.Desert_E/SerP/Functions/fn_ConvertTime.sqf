/*
	Function: Converter from seconds to HH:MM:SS format
	Author: Blender
	Arguments:
	- (int) Time in seconds
	Return values:
	- (string) Formatted time
*/

private ["_hours", "_minutes", "_seconds"];

if (_this < 0) then { _this = 0 };

_hours = floor (_this / 60 / 60);
_minutes = floor (_this / 60);
_seconds = floor (_this mod 60);

if (_minutes >= 120) then { _minutes = _minutes - 60 };
if (_minutes >= 60) then { _minutes = _minutes - 60 };

if (_hours < 10) then { _hours = format["0%1", _hours] };
if (_minutes < 10) then { _minutes = format["0%1", _minutes] };
if (_seconds < 10) then { _seconds = format["0%1", _seconds] };
format["%1:%2:%3", _hours, _minutes, _seconds]