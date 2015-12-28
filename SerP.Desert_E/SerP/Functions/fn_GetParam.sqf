/*
	Function: Returns parameter value from mission parameters
	Author: Blender
	Arguments:
	- (string) Parameter name
	- (int) Default value
	Return:
	- (int) Value
*/

_return = _this select 1;

_cfg = missionConfigFile >> "Params";

for "_i" from 0 to ((count _cfg) - 1) do {
	_entry = _cfg select _i;
	if ((configName _entry) == (_this select 0)) exitWith {
		if (isNil "paramsArray") then {
			_return = getNumber (_entry >> "default")
		} else {
			_return = paramsArray select _i
		}
	}
};

_return