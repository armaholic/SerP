#include "const.sqf"

_endMissionToggle = ["endMission", 1] call SerP_blnd_fnc_GetParam;
if (_endMissionToggle == 0) exitWith {SerP_endMission = {}};

//инициализируем функции
SerP_processorEND = {
	SerP_endMission = {};
	_message = _this select 0;
	taskHint [_message,[1, 0, 0, 1], "taskNew"];
	_toRPT = [];
	{_toRPT set [count _toRPT,format ["Alive at side %1: %2",_x,_x countSide playableUnits]]} forEach [east,west,resistance,civilian];
	_toRPT set [count _toRPT,"SerP Unit states:"];
	{
		_toRPT set [count _toRPT,format ["Group: %1",_x select 0]];
		_toRPT set [count _toRPT,"Name:			Lifestate:	Weapons:"];
		{
			_wpnStr = "";
			{
				_weapon = (configFile >> "cfgWeapons" >> _x);
				if ((getNumber(_weapon >> "type") in [1,4,5])&&!isNil{(getArray(_weapon >> "magazines") select  0)}) then {
					_wpnStr = _wpnStr + _x + " ";
				};
			} forEach weapons(_x select 1);
			_toRPT set [count _toRPT, format ['%1		%2		%3', _x select 0,lifeState(_x select 1),_wpnStr]];
		} forEach (_x select 1);
	} forEach SerP_all_units;
	_toRPT set [count _toRPT, "Vehicles:"];
	_toRPT set [count _toRPT,"Type:	Position:	Damage:	Crew:"];
	{
		_pos = getPos _x; _pos = [round(_pos select 0),round(_pos select 1),round(_pos select 2)];
		_crew = crew _x;
		{_crew set [_forEachIndex,name _x]} forEach _crew;
		_toRPT set [count _toRPT, format ['%1		%2		%3		%4',getText(configFile >> "cfgVehicles" >> typeOf(_x) >> "DisplayName"),_pos,damage _x, _crew]];
	} forEach (allMissionObjects "Plane")+(allMissionObjects "LandVehicle")+(allMissionObjects "Helicopter")+(allMissionObjects "Ship");
	[_message,_toRPT] spawn {
		_message = _this select 0;
		_toRpt = _this select 1;
		createDialog "RscDisplayStatistics";
		{
			lbAdd [101, _x];
			diag_log _x;
		} forEach _toRpt;
		2 cutText ['','BLACK',5];
		sleep 5;
		(vehicle player) enableSimulation false;
		sleep 25;
		2 cutText[_this select 0,'BLACK FADED',5];
		sleep 4;
		endMission 'LOSER';
	};
};

SerP_endMission = {
	_title = _this select 0;
	if (count(_this)==1) then {
		SerP_end = [_title,true];
		publicVariable "SerP_end";
	};
	_title = switch toLower(_title) do {
		case "redfor_win": {format [localize "STR_win_call", __titleREDFOR]};
		case "bluefor_win": {format [localize "STR_win_call", __titleBLUEFOR]};
		case "redfor_retreat": {format [localize "STR_dead_call", __titleREDFOR]};
		case "bluefor_retreat": {format [localize "STR_dead_call", __titleBLUEFOR]};
		case "end_admin": {localize "STR_mission_end_admin"};
		default {_title};
	};
	[_title] call SerP_processorEND
};

sleep 10;
//админ может завершить миссию досрочно нажав комбинацию клавиш ctrl+alt+shift+end
if ((serverCommandAvailable "#kick")||isServer) then {
	(findDisplay 46) displayAddEventHandler ["KeyDown", '
		_ctrl = _this select 0;
		_dikCode = _this select 1;
		_shift = _this select 2;
		_ctrlKey = _this select 3;
		_alt = _this select 4;
		_handled = false;
		if ((_dikCode==207)&&_shift&&_ctrlKey&&_alt) then {
			["end_admin"] call SerP_endMission
		};
	'];
};

//ждем пока не закончится фризтайм
waitUntil {sleep 1;!isNil{warbegins}};
waitUntil {sleep 1;warbegins==1};

if isNil{SerP_end} then {
	SerP_end = ['',false];
}else{
	if (SerP_end select 1) then {
		SerP_end call SerP_endMission
	};
};

if (!isDedicated&&isServer) then {//костыль для тестов
	_trigger = createTrigger["EmptyDetector",[0,0]];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerStatements[
		"SerP_end select 1",
		"SerP_end call SerP_endMission",
		""
	];
}else{//завершение
	"SerP_end" addPublicVariableEventHandler {
		if ((_this select 1) select 1) then {
			(_this select 1) call SerP_endMission
		};
	};
};


SerP_all_units = []; //собираем список юнитов в начале игры потому-что узнать имя мертвого игрока нельзя
{
	_show = false;
	_unitsInGroup = [];
	{if isPlayer(_x) then {
		_show = true;
		_unitsInGroup set [count _unitsInGroup,[name _x, _x]];
	};} forEach (units _x);
	if _show then {
		SerP_all_units set [count SerP_all_units, [_x,_unitsInGroup]];
	};
} forEach allGroups;

_initRFCount = {(isPlayer _x)&&(alive _x)&&(side _x == __sideREDFOR)} count playableUnits;
_initBFCount = {(isPlayer _x)&&(alive _x)&&(side _x == __sideBLUEFOR)} count playableUnits;

while {true} do {
	sleep 10;
	_RFCount = {(alive _x)&&(side _x == __sideREDFOR)} count playableUnits;
	_BFCount = {(alive _x)&&(side _x == __sideBLUEFOR)} count playableUnits;
	//REDFOR retreat
	if ((_RFCount<_initRFCount*__RFRetreat)&&(_RFCount*__domiMult<_BFCount)) exitWith {
		["redfor_retreat"] call SerP_endMission;
	};
	//BLUEFOR retreat
	if ((_BFCount<_initBFCount*__BFRetreat)&&(_BFCount*__domiMult<_RFCount)) exitWith {
		["bluefor_retreat"] call SerP_endMission;
	};
};
