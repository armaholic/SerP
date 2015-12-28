#include "const.sqf"

__debug(start)
if (isServer) then {
	[] call compile preprocessFileLineNumbers "SerP\startmission_server.sqf";
};
if (!isDedicated) then {
    crewIndex = false;
    arrRelCrew = [];
    arrRelCommander = ["US_Soldier_SL_EP1","US_Soldier_Officer_EP1","mas_us_rangs_ace_acu_tl","mas_us_rangs_ace_des_tl","mas_us_rangs_ace_mul_tl","mas_us_rangs_ace_pcu_tl","mas_us_rangs_ace_wod_tl","ACE_USMC_Soldier_SL_D","ACE_USMC_Soldier_Officer_D","USMC_Soldier_SL","USMC_Soldier_Officer","BAF_Soldier_SL_MTP","BAF_Soldier_Officer_MTP","BAF_Soldier_SL_DDPM","BAF_Soldier_Officer_DDPM","BAF_Soldier_SL_W","BAF_Soldier_Officer_W","usm_marine_80s_d_h_off","usm_marine_80s_d_l_off","usm_marine_80s_w_h_off","usm_marine_80s_w_l_off","usm_marine_90s_d_h_off","usm_marine_90s_d_l_off","usm_marine_90s_w_h_off","usm_marine_90s_w_l_off","usm_soldier_80s_d_h_off","usm_soldier_80s_d_l_off","usm_soldier_80s_w_h_off","usm_soldier_80s_w_l_off","usm_soldier_90s_d_h_off","usm_soldier_90s_d_l_off","usm_ranger_90s_d_h_off","usm_ranger_90s_d_l_off","usm_soldier_90s_w_h_off","usm_soldier_90s_w_l_off","usm_ranger_90s_w_h_off","usm_ranger_90s_w_l_off","usm_ranger_90s_w_l_ftl","usm_ranger_93_d_h_off","ACE_RU_Commander_D","ACE_RU_Soldier_SL_D","ACE_RU_Soldier_Officer_D","RU_Commander","RU_Soldier_SL","RU_Soldier_Officer","odkb_RU_Commander","odkb_RU_Soldier_SL","odkb_RU_Soldier_Officer","pxl_RU_Commander","pxl_RU_Soldier_SL","pxl_RU_Soldier_Officer","tusg_P85_ussr_vest_team","tusg_P85_ussr_9c_lc1","tusg_P85_ussr_regular_officer","tusg_P85_ussr_specnaz_team","tusg_P85_ussr_specnaz_kzs","p85_new_ussr_vdv","TK_INS_Warlord_EP1","MOL_Soldier_Officer","Ins_Commander","Soldier_TL_PMC","GUE_Soldier_CO","GUE_Commander","TK_GUE_Soldier_TL_EP1","TK_GUE_Warlord_EP1","UN_CDF_Soldier_Officer_EP1","cwr2_OfficerE_W","cwr2_OfficerE_Night_W","cwr2_OfficerG_W","cwr2_OfficerG_Night_W","CWR2_OfficerW_W","CWR2_OfficerW_Night_W","CDF_Commander","CDF_Soldier_Officer","GER_Soldier_TL_EP1","CZ_Soldier_SL_DES_EP1","CZ_Soldier_Office_DES_EP1"];
    if (!isnil{relCrew}) then { arrRelCrew = arrRelCrew + relCrew; };
    if (!isnil{relCommander}) then { arrRelCommander = arrRelCommander + relCommander; };

	call compile format["'SerP_markers_%1' addPublicVariableEventHandler {(_this select 1) call SerP_updateMarkers};if (count(SerP_markers_%1 select 1)>0) then {SerP_markers_%1 call SerP_updateMarkers}",side group player];
	[] execVM "SerP\startmission_client.sqf";
	[] call compile preprocessFileLineNumbers "SerP\briefing.sqf";
	enableRadio false;
	[["AllVehicles"], [ace_sys_interaction_key], 2, ["SerP\interactionMenu.sqf", "main"]] call CBA_ui_fnc_add;
	[["player"], [ace_sys_interaction_key_self], 2, ["SerP\selfInteractionMenu.sqf", "main"]] call CBA_ui_fnc_add;

	_spectatorLimits = ["spectator", 1] call SerP_blnd_fnc_GetParam;
	if (_spectatorLimits == 1) then {
		//disable spectator's map
		ace_sys_spectator_ShownSides = [playerSide];
		ace_sys_spectator_fnc_startSpectator_old = ace_sys_spectator_fnc_startSpectator;
		ace_sys_spectator_fnc_startSpectator = {
			ace_sys_spectator_ShownSides = [playerSide];
			if (isNil{_this}||count(_this)==0) then {
				_this = [player];
			};
			_this call ace_sys_spectator_fnc_startSpectator_old;
		};
		ace_sys_spectator_fnc_spectate_events_old = ace_sys_spectator_fnc_spectate_events;
		ace_sys_spectator_fnc_spectate_events = {
			if !(ace_sys_spectator_camSelLast in [0,2,4]) then {
				ace_sys_spectator_NewCameraIdx = 2;
				ace_sys_spectator_camSelLast = 2;
			};
			ace_sys_spectator_szoom = 1;
			ace_sys_spectator_sdistance = 1;
			if (ctrlVisible 55014) then {ctrlShow [55014, false];};
			if (ctrlVisible 55013) then {ctrlShow [55013, false];};
			if (ctrlVisible 55015) then {ctrlShow [55015, false];};

			switch true do {
				case ((_this select 0) in ["ToggleTags","UnitFired","ToggleMapBird","ToggleMap","MapClick","MouseZChanged"]): {false};
				case ((_this select 0) == "KeyUp"): {
					_key = (_this select 1) select 1;
					switch(_key) do {
						case 49: {
							if (ace_sys_spectator_UseNVG == 0) then {
								ace_sys_spectator_UseNVG = 1;
								ace_sys_spectator_NVGMode = 2
							} else {
								ace_sys_spectator_UseNVG = 0;
								ace_sys_spectator_NVGMode = -1;
								ace_sys_spectator_OldNVGMode = -5;
							};
						};
						case 37: {};
						case 57: {if (ace_sys_spectator_cameras select ace_sys_spectator_cameraIdx == ace_sys_spectator_cam_1stperson) then {_this call ace_sys_spectator_fnc_spectate_events_old}};
						default {_this call ace_sys_spectator_fnc_spectate_events_old};
					}
				};
				default {_this call ace_sys_spectator_fnc_spectate_events_old};
			};
		};
		ace_sys_spectator_fnc_menucamslbchange_old = ace_sys_spectator_fnc_menucamslbchange;
		ace_sys_spectator_fnc_menucamslbchange = {
			switch (_this select 1) do {
				case 1: { // separator
				};
				case 3: { // separator
				};
				case 7: { // Special for toggling NVG
					if (ace_sys_spectator_UseNVG == 0) then {
						ace_sys_spectator_UseNVG = 1;
						ace_sys_spectator_NVGMode = 2
					} else {
						ace_sys_spectator_UseNVG = 0;
						ace_sys_spectator_NVGMode = -1;
						ace_sys_spectator_OldNVGMode = -5;
					};
				};
				case 8: { // Special for toggling tags
				};
				default {
					_this call ace_sys_spectator_fnc_menucamslbchange_old;
				};
			};
		};
	};
};

//testing
if (isServer&&!isDedicated) then {
	[] call compile preprocessFileLineNumbers "SerP\template_test.sqf";
};
__debug(end)