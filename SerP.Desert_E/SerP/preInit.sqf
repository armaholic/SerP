#include "const.sqf"

__debug(start)
enableSaving [false, false];

//init global variables
if (isClass(configFile >> "cfgPatches" >> "ace_main")) then {
	ace_sys_wounds_enabled = true;
	ace_sys_repair_default_tyres= true;
	ace_sys_tracking_markers_enabled_override = true;
	ace_sys_tracking_markers_enabled = false;
	ace_sys_spectator_playable_only = true;
	ace_sys_spectator_can_exit_spectator = false;
	ace_sys_spectator_no_butterfly_mode = true;
	ace_sys_spectator_ShownSides = [playerSide];
	ace_sys_spectator_NoMarkersUpdates = true;
	//ace_sys_nvg_rangelimit_enabled = true;
	ace_settings_enable_vd_change = true;
	missionNamespace setVariable ["ace_viewdistance_limit",getNumber(missionConfigFile >> "SerP_const" >> "viewDistance")];
	//ACE_NoStaminaEffects = true;
	//[] spawn {_s = time+100;waitUntil{sleep 1;!ACE_SYS_STAMINA||_s>time};ACE_SYS_STAMINA=true;};
};

enableEngineArtillery false;

//// FUNCTIONS
SerP_blnd_fnc_GetParam = compile preprocessFileLineNumbers "SerP\Functions\fn_GetParam.sqf";

SerP_msg = {//["Hello world!",west] call SerP_msg;
		if (count(_this)==2) then {
			if ((side player)==(_this select 1)) then {
				taskHint [(_this select 0),[1, 0, 0, 1], "taskNew"];
			};
		}else{
			taskHint [(_this select 0),[0, 1, 0, 1], "taskNew"];
		};
	SerP_msgText = _this;
	publicVariable "SerP_msgText";
};

[] execVM "SerP\endmission.sqf";
//server
if (isServer) then {
	{
		call compile format["SerP_markers_%1 = [[],[]];publicVariable 'SerP_markers_%1';",_x];
		call compile format["SerP_vehicles_%1 = [];publicVariable 'SerP_vehicles_%1';",_x];
	} forEach [east,west,resistance,civilian];

	SerP_markerCount = [0,0,0,0];
	SerP_addMarker = {
		_side = _this select 0;
		_markerInfo = _this select 1;
		_name = _markerInfo select 0;

		if (_name == "") then {
			_index = switch _side do {
				case east: {0};
				case west: {1};
				case resistance: {2};
				case civilian: {3};
			};
			_count = SerP_markerCount select _index;

			_name = "SerP_marker"+str(_side) + str(_count);
			_markerInfo set [0,_name];
			SerP_markerCount set [_index,_count+1];
		};

		SerP_tempMarkers = call compile format["SerP_markers_%1",_side];
		_delete = SerP_tempMarkers select 0;
		_markers = SerP_tempMarkers select 1;
		_markers set [count _markers,_markerInfo];
		SerP_tempMarkers = [_delete,_markers];
		call compile format["SerP_markers_%1 = SerP_tempMarkers",_side];
		SerP_tempMarkers = nil;
	};
	SerP_commitMarkers = {
		{
			call compile format["publicVariable 'SerP_markers_%1';",_x];
		} forEach [east,west,resistance,civilian];
		if (!isDedicated) then {
			call compile format["SerP_markers_%1 call SerP_updateMarkers",side group player];
		};
	};

	[] call compile preprocessFileLineNumbers "SerP\setMissionConditions.sqf";
};
//client
if (!isDedicated) then {
	SerP_server_message = "";
	"SerP_server_message" addPublicVariableEventHandler {hint (_this select 1)};
	SerP_taskhint = "";
	"SerP_taskhint" addPublicVariableEventHandler {taskHint [(_this select 1),[1, 0, 0, 1], "taskNew"];};
	SerP_msgText = "";
	"SerP_msgText" addPublicVariableEventHandler {
		if (count(_this select 1)==2) then {
			if ((side player)==(_this select 1) select 1) then {
				taskHint [(_this select 1) select 0,[1, 0, 0, 1], "taskNew"];
			};
		}else{
			taskHint [(_this select 1) select 0,[0, 1, 0, 1], "taskNew"];
		};
	};
	SerP_localMarkers = [];
	SerP_updateMarkers = {
		_toDelete = _this select 0;
		_toCreate = _this select 1;
		if (_toDelete select 0=="all") then {
			{
				deleteMarkerLocal _x;
			} forEach SerP_localMarkers;
			SerP_localMarkers = [];
		}else{
			{
				deleteMarkerLocal _x;
			} forEach _toDelete;
		};
		{
			_name = _x select 0;
			createMarkerLocal [_name,_x select 1];
			_name setMarkerTypeLocal (_x select 2);
			_name setMarkerSizeLocal (_x select 3);
			_name setMarkerTextLocal (_x select 4);
			_name setMarkerColorLocal (_x select 5);
			_name setMarkerAlphaLocal (_x select 6);
			_name setMarkerBrushLocal (_x select 7);
			_name setMarkerShapeLocal (_x select 8);
			SerP_localMarkers set [count SerP_localMarkers,_name];
		} forEach _toCreate;
	};
};

__debug(end)