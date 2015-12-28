#include "const.sqf"
__debug(start)

waitUntil { player == player };

// VARIABLES
trashArray = [];
planeList = [];

private ["_isAdmin", "_player", "_leader", "_veh", "_vehFiredList", "_serp_loading", "_firedEHIndex", "_blocker2"];

_isAdmin = serverCommandAvailable "#kick";
_player = player;
_leader = leader (group _player);
_veh = (vehicle _player);
_vehFiredList = [];

setViewDistance ((getNumber (missionConfigFile >> "SerP_const" >> "viewDistance")) min 3500);

if (!isMultiplayer || !(alive _player)) exitWith {
	[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf"
};
sleep .01;

_player setVariable ["SerP_isPlayer", true, true];

_serp_loading = ["loading", 1] call SerP_blnd_fnc_GetParam;
if (
	(_serp_loading == 0) &&
	(time < 60) &&
	(
		(_player != _leader) &&
		!_isAdmin &&
		(120 > ({isPlayer _x} count playableUnits))
	)
) exitWith {
	failMission "loser";
};

if (
	(_serp_loading == 2) &&
	(time < 60) &&
	!((_player == _leader) || _isAdmin)
) exitWith {
	failMission "loser";
};

openMap [true,true];
_veh enableSimulation false;

if (
	_veh != _player &&
	{!isNil {_veh getVariable "CREW_GETININDEX"}}
) then {
	[[_veh,"",_player],_veh getVariable "CREW_GETININDEX"] call isCrew
};

_firedEHIndex = _player addEventHandler ["fired", {deleteVehicle (_this select 6)}];
_blocker2 = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", '
	[0,-1] call ace_sys_weaponselect_fnc_keypressed;
	false
'];
[0,-1] call ace_sys_weaponselect_fnc_keypressed;

try {
	private ["_waitTime", "_vehList", "_index", "_side", "_inZone"];
	_waitTime = time + 90;
	waitUntil { sleep 1; !isNil "warbegins" || (time > _waitTime) };
	if (isNil "warbegins") then { warbegins = 1 };
	if (warbegins == 1) then { throw "warbegins" };
	[] spawn compile preprocessFileLineNumbers "SerP\Scripts\cli_counter.sqf";
	_vehList = vehicles;
	for "_i" from 0 to ((count _vehList) - 1) do {
		private ["_vehFiredObject", "_vehFiredIndex"];
		_vehFiredObject = _vehList select _i;
		_vehFiredIndex = _vehFiredObject addEventHandler ["fired", {deleteVehicle (_this select 6)}];
		_vehFiredList SET [count _vehFiredList, [_vehFiredObject, _vehFiredIndex]];
	};
	_index = 2;
	_side = side _player;
	switch true do {
		case (_side == __sideREDFOR): {_index = 1;_side = "REDFOR"};
		case (_side == __sideBLUEFOR): {_index = 0;_side = "BLUEFOR"};
	};
	if (_index < 2) then {
		private ["_radio", "_endTrigger"];
		_radio = createTrigger["EmptyDetector",[0,0]];
		_radio setTriggerActivation ["INDIA","PRESENT",true];
		_radio setTriggerStatements ["this",format ["
			if (readyArray select %1) then
				{readyArray set [%1, false];publicVariable ""readyArray"";[""%2 not ready (%3)""] call SerP_msg}
			else
				{readyArray set [%1, true];publicVariable ""readyArray"";[""%2 ready (%3)""] call SerP_msg};
			", _index, _side, name _player],
			""];
		trashArray set [count trashArray, _radio];

		_endTrigger = createTrigger["EmptyDetector",[0,0]];
		_endTrigger setTriggerActivation ["ANY", "PRESENT", true];
		_endTrigger setTriggerStatements[
			format["(readyArray select %1)",_index],
			"9 setRadioMsg localize ""STR_serp_continue_briefing"";",
			"9 setRadioMsg localize ""STR_serp_end_briefing"";"
		];
		trashArray set [count trashArray, _endTrigger];

		9 setRadioMsg (localize "STR_serp_end_briefing");
	};
	_waitTime = time + 90;
	waitUntil { sleep 1; !isNil "startZones" || (time > _waitTime) };
	if (isNil "startZones") then {
		startZones = [[getPos _veh,__defZoneSize,1,objNull,objNull]];
	};
	
	_inZone = false;
	{
		private ["_pos", "_size", "_helper", "_ppos", "_dist"];
		_pos = (_x select 0);
		_size = (_x select 1);
		_helper = (_x select 3);
		_ppos = _player getVariable ["SerP_startPos", getPos _veh];
		_dist = [_ppos select 0,_ppos select 1,0] distance [_pos select 0,_pos select 1,0];
		if (_dist<(_size+__hintzonesize)) exitWith {
			private "_act";
			_inZone = true;
			_waitTime = time + 90;
			waitUntil { sleep .5; (time>_waitTime) || ((getDir _helper != 0)&&!(isNull _helper))||(isNull _helper)};
			[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf";
			openMap [false,false];
			_veh enableSimulation true;

			_act = _veh addAction ["Change optics", "SerP\opticsChange.sqf"];
			while { warbegins != 1 } do {
				sleep 1;
				_ppos = getPos (vehicle player);
				_dist = [_ppos select 0,_ppos select 1,0] distance [_pos select 0,_pos select 1,0];
				if (_dist> (_size+__hintzonesize)) then {
					hint localize "STR_serp_sorry";
					player say "r44";
					player say "svd_single_shot_v2";
					player say "All_haha";
					//player say "ACE_rus_combat143";
					sleep 4;
					player setPos (player getVariable ["SerP_startPos",[_pos select 0,_pos select 1,0]]);
				};
				if (_dist > _size) then {
					hint localize "STR_serp_outOfZone";
					(vehicle player) setVelocity [0,0,0];
					switch round(random 11) do {
						case 0: {player say "r11"};
						case 1: {player say "r15"};
						case 2: {player say "r26"};
						case 3: {player say "r29"};
						case 4: {player say "r25"};
						case 5: {player say "r04"};
						case 6: {player say "r21_4"};
						case 7: {player say "ACE_rus_combat117"};
						case 8: {player say "ACE_rus_combat197"};
						case 9: {player say "Zora_AK74";player say "UnderFire1"};
						case 10: {player say "Zora_M16";player say "UnderFire2"};
						case 11: {player say "svd_single_shot_v2";player say "UnderFire3"};
					};
					sleep 3;
				};
			};
			_veh removeAction _act;
			throw "";
		};
	} forEach startZones;
	throw "outOfZone";
}
catch {
	if (_exception == "outOfZone") then {
		diag_log "startmission_client.sqf - player is out of zones";
		[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf";
		_veh enableSimulation true;
		openMap [false,false];
	};
	if (_exception == "warbegins") then {
		[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf";
		_veh enableSimulation true;
		openMap [false,false];
	};
	(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", _blocker2];
	_player removeEventHandler ["fired", _firedEHIndex];
	for "_i" from 0 to ((count _vehFiredList) - 1) do {
		private ["_vehEntry", "_vehFiredObject"];
		_vehEntry = _vehFiredList select _i;
		_vehFiredObject = _vehEntry select 0;
		if (!isNull _vehFiredObject) then {
			_vehFiredObject removeEventHandler ["fired", _vehEntry select 1];
		};
	};
};
__debug(end)