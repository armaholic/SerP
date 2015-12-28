#include "blnd_macros.h"
/*
	Script: Startup timer visualization for SerP (clientside)
	Author: Blender
	Arguments: None
	Return values: None
*/

if (warbegins == 1) exitWith {};

if (isNil QUOTE(FNC(ConvertTime))) then {
	FNC(ConvertTime) = compile preprocessFileLineNumbers "SerP\Functions\fn_ConvertTime.sqf";
};

disableSerialization;

private ["_layer", "_display", "_ctrl", "_exit", "_lastKnownTime", "_timeLeft"];

_layer = 15205; // "blnd_counter" call BIS_fnc_rscLayer;
_layer cutRsc ["blnd_counter", "PLAIN", 2];

_display = uiNameSpace getVariable ["blnd_counter", displayNull];

if (isNull _display) then { sleep 1; _display = uiNameSpace getVariable ["blnd_counter", displayNull]; };
if (isNull _display) exitWith { hint "ERROR: Cant display counter!"; diag_log "ERROR: Cant display counter!"; };

_ctrl = _display displayCtrl 2828;
_ctrl ctrlSetStructuredText (parseText "<t size='1.6' shadow='0' color='#7f0000ff' valign='middle' align='center'>COUNTING</t>");

_exit = false;

if (isNil QUOTE(VAR(TimeLeft))) then {
	private "_safeCount";
	_safeCount = 10;
	_exit = true;
	for "_i" from 1 to _safeCount do {
		sleep 1;
		if (!isNil QUOTE(VAR(TimeLeft))) exitWith {
			_exit = false;
		};
	};
};

if (_exit) exitWith {
	_layer cutText ["", "PLAIN"];
	hint "ERROR: Cant get remaining time variable!";
	diag_log "ERROR: Cant get remaining time variable!";
};

_lastKnownTime = -1;
_timeLeft = -1;

while {warbegins == 0 && !_exit} do {
	_timeLeft = _timeLeft - 1;
	if (_lastKnownTime != VAR(TimeLeft)) then {
		_lastKnownTime = VAR(TimeLeft);
		_timeLeft = VAR(TimeLeft);
	};
	
	if (_timeLeft <= 0) then {
		_ctrl ctrlSetStructuredText (parseText "<t size='1.6' shadow='0' color='#7fff0000' valign='middle' align='center'>00:00:00</t>");
		_exit = true;
	} else {
		if (_timeLeft > 30) then {
			_ctrl ctrlSetStructuredText (parseText format["<t size='1.6' shadow='0' color='#7fffffff' valign='middle' align='center'>%1</t>", _timeLeft call FNC(ConvertTime)]);
		} else {
			_ctrl ctrlSetStructuredText (parseText format["<t size='1.6' shadow='0' color='#7fff0000' valign='middle' align='center'>%1</t>", _timeLeft call FNC(ConvertTime)]);
		};
	};
	
	sleep 1;
};

_ctrl ctrlSetStructuredText (parseText "<t size='1.6' shadow='0' color='#7f00ff00' valign='middle' align='center'>START</t>");

sleep 2;

_layer cutText ["", "PLAIN"];