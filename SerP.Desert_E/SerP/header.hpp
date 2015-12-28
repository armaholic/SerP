#define __SerP_loadscreen __EVAL(["ca\Missions_e\campaign\missions\CE7B_PhoenixOp.Takistan\img\loading08_phoenixop_co.paa","ca\Missions_e\campaign\missions\CE7A_FinishingTouch.Takistan\img\loading08_finishingtouch_co.paa","ca\Missions_e\campaign\missions\CE6_EyeOfTheHurricane.Zargabad\img\loading07_co.paa","ca\Missions_e\campaign\missions\CE5B_FromHell.Takistan\img\loading06_fromhell_co.paa","ca\Missions_e\campaign\missions\CE5A_Sandstorm.Takistan\img\loading06_sandstorm_co.paa","ca\Missions_e\campaign\missions\CE4_OpenSeason.Takistan\img\loading05_co.paa","ca\Missions_e\campaign\missions\CE3_ColtanBlues.Takistan\img\loading04_co.paa","ca\Missions_e\campaign\missions\CE2_Pathfinder.Takistan\img\loading03_co.paa","ca\Missions_e\campaign\missions\CE1_GoodMorningTStan.Takistan\img\loading02_goodmorning_co.paa","ca\Missions_e\campaign\missions\CE0_Backstab.Zargabad\img\loading01_co.paa","ca\Missions_e\scenarios\SPE1_Jackal.Takistan\loading_jackal_co.paa","ca\Missions_e\scenarios\SPE1_Vehicles_US.Takistan\loading_showus_co.paa","ca\Missions_e\scenarios\SPE1_Vehicles_TKG.Zargabad\loading_showgue_co.paa","ca\Missions_e\scenarios\SPE1_Vehicles_TKA.Zargabad\loading_showtk_co.paa","ca\Missions_e\scenarios\SPE1_Vehicles_Civilian.Zargabad\loading_showciv_co.paa","ca\Missions_e\scenarios\SPE1_Vehicles_Allies.Takistan\loading_shownato_co.paa","ca\Missions_e\scenarios\SPE1_SteelPanthers.Takistan\loading_steelpanthers_co.paa","ca\Missions_e\scenarios\SPE1_OneShotOneKill.Takistan\loading_oneshotonekill_co.paa","ca\Missions_e\scenarios\SPE1_Littlebird.Takistan\loading_littlebird_co.paa","ca\Missions_e\scenarios\SPE1_LaserShow.Takistan\loading_lasershow_co.paa","ca\Missions_e\scenarios\SPE1_HikeInTheHills.Takistan\loading_hikeinthehills_co.paa","ca\Missions_e\scenarios\SPE1_DeathFromAbove.Takistan\loading_deathfromabove_co.paa","ca\Missions_e\scenarios\SPE1_Benchmark1.Takistan\loading_benchmark_co.paa","ca\Missions_e\MPScenarios\MPE1_Dogfighters.Takistan\loading_mpdogfight_co.paa","ca\Missions_e\MPScenarios\MPE_MountainWarfare.Takistan\loading_mpwarfare_co.paa","ca\Missions_e\MPScenarios\MPE_SectorControl.Zargabad\img\loading_mpsectorcontrol_co.paa"] select round random 25)

class Extended_PreInit_EventHandlers {
	class SerP {
		Init = "call compile preProcessFileLineNumbers 'SerP\preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers {
	class SerP {
		Init = "call compile preProcessFileLineNumbers 'SerP\postInit.sqf'";
	};
};

SerP_version = 37.8;
respawn = 1;
respawndelay = 3;
class Header	{
	gameType = Unknown;
	minPlayers = 1;
	maxPlayers = 200;
};

onLoadMission = $STR_missionname;
loadScreen = __SerP_loadscreen;
disableChannels[] = {0,2,3,5,6};