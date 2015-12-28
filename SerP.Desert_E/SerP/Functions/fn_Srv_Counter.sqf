#include "blnd_macros.h"
/*
	Script: Startup timer visualization for SerP (serverside)
	Author: Blender
	Arguments:
	- Time in minutes (int)
	Return values: None
*/

private ["_briefingTime", "_briefingEndTime", "_updateCycle", "_lastUpdateTime"];

_briefingTime = (_this select 0) * 60;

waitUntil { sleep 0.1; time > 0 };

_briefingEndTime = diag_tickTime + _briefingTime;
_updateCycle = 10;

VAR(TimeLeft) = _briefingTime;
publicVariable QUOTE(VAR(TimeLeft));

_lastUpdateTime = diag_tickTime;

while { warbegins == 0 } do {
	private "_currentTime";

	_currentTime = diag_tickTime;

	if (_currentTime > (_lastUpdateTime + _updateCycle)) then {
		_lastUpdateTime = _currentTime;
		VAR(TimeLeft) = _briefingEndTime - diag_tickTime;
		publicVariable QUOTE(VAR(TimeLeft));
	};

	if (diag_tickTime > _briefingEndTime) exitWith {
		warbegins = 1;
		publicVariable "warbegins";
	};
	sleep 1.218;
};