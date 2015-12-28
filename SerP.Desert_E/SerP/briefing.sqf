#include "const.sqf"
__debug(start)
private ["_unitside"];
_unitside = side group player;
_JIP = if (time>10) then {true}else{false};
_version = getNumber(missionConfigFile >> "SerP_version");
if (_version==0) then {
	_version = getText(missionConfigFile >> "SerP_version");
}else{
	_version = "v"+str(_version);
};
_cred = player createDiaryRecord ["diary", [localize "credits_title",format ["%1 <br/>SerP %2",localize "credits",_version]]];
//отобразит игроков стороны в отрядах
_grpText = "";
{
	if (side(_x) == _unitside) then {
		_units = units _x;
		_markerName = "SerP_startposMarker"+str _x;
		_tmpText = "<br/>" + (if (_JIP) then {str _x}else{"<marker name = '"+_markerName+"'>"+str _x+"</marker>"});

		{
			if ((alive _x)&&((isPlayer _x)||isServer)) then {
				_tmpText = _tmpText + "<br/>--  " + (name _x);
				{
					_weapon = (configFile >> "cfgWeapons" >> _x);
					if ((getNumber(_weapon >> "type") in [1,4,5])&&!isNil{(getArray(_weapon >> "magazines") select  0)}) then {
						_tmpText = _tmpText + "  -  " + getText(_weapon >> "displayName");
					};
				} forEach weapons(_x);
			};
		} forEach _units;
		if (!_JIP) then {
			_grpText = _grpText + _tmpText + "<br/>";
		};
	};
} forEach allGroups;

_groups = player createDiaryRecord ["diary", [localize "groups_title",_grpText]];

//условности, одни на всех
if (localize "convent" != "") then {_cond = player createDiaryRecord ["diary", [localize "convent_title",localize "convent"]];};
//погода из настроек миссии

_hour = date select 3;
_time = switch true do {
	case (_hour>=21||_hour<4): {localize "STR_timeOfDay_Option7"};
	case (_hour<5): {localize "STR_timeOfDay_Option0"};
	case (_hour<8): {localize "STR_timeOfDay_Option1"};
	case (_hour<10): {localize "STR_timeOfDay_Option2"};
	case (_hour<14): {localize "STR_timeOfDay_Option3"};
	case (_hour<16): {localize "STR_timeOfDay_Option4"};
	case (_hour<18): {localize "STR_timeOfDay_Option5"};
	case (_hour<21): {localize "STR_timeOfDay_Option6"};
	default {localize "STR_timeOfDay_Option8"};
};

_weather = switch true do {
	case (overcast>0.9): {localize "STR_weather_Option4"};
	case (overcast<0.1): {localize "STR_weather_Option0"};
	case (overcast>0.1): {localize "STR_weather_Option1"};
	case (fog>0.9): {localize "STR_weather_Option3"};
	case (fog>0.5): {localize "STR_weather_Option2"};
	default {localize "STR_weather_Option5"};
};

_vd = getNumber(missionConfigFile >> "SerP_const" >> "viewDistance");
_weather = player createDiaryRecord ["diary", [localize "STR_weather",
format [localize "STR_timeOfDay" + " - %1<br/>" + localize "STR_weather" + " - %2<br/>" + localize "str_disp_xbox_editor_wizard_weather_viewdistance" + " - %3" ,_time,_weather,_vd]
]];
//задачи, вооружение и брифинги сторон
switch true do {
	case (_unitside == east): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		}} forEach [
			[localize "machinery_title",(localize "machinery_rf")],
			[localize "enemy_title",localize "enemy_rf"],
			[localize "execution_title",localize "execution_rf"],
			[localize "task_title",localize "task_rf"],
			[localize "situation_title",localize "situation_rf"]
		];
	};
	case (_unitside == west): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "machinery_title",(localize "machinery_bf")],
			[localize "enemy_title",localize "enemy_bf"],
			[localize "execution_title",localize "execution_bf"],
			[localize "task_title",localize "task_bf"],
			[localize "situation_title",localize "situation_bf"]
		];
	};
	case (_unitside == resistance): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "machinery_title",(localize "machinery_guer")],
			[localize "enemy_title",localize "enemy_guer"],
			[localize "execution_title",localize "execution_guer"],
			[localize "task_title",localize "task_guer"],
			[localize "situation_title",localize "situation_guer"]
		];
	};
	default {//цивилы
		_mis = player createDiaryRecord ["diary", [localize "situation_title", localize "situation_tv"]];
	};
};

__debug(end)