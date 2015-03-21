
0 cutText["Loading objective ...", "BLACK FADED"];
0 cutFadeOut 9999999;

if (isServer) then
{
	waitUntil {time > 0};

	if (isNull (missionNamespace getVariable ["b_vip", objNull])) then
	{
		["END2", "endMission", true, true, false] call BIS_fnc_MP;
	};

	[] call VIPX_fnc_initObjectives;
	[] call VIPX_fnc_initVIP;

	b_leaders = [];
	["b_alpha",  -1] call VIPX_fnc_initLeader;
	["b_bravo",   0] call VIPX_fnc_initLeader;
	["b_charlie", 1] call VIPX_fnc_initLeader;

	o_leaders = [];
	["o_alpha",  -1] call VIPX_fnc_initLeader;
	["o_bravo",   0] call VIPX_fnc_initLeader;
	["o_charlie", 1] call VIPX_fnc_initLeader;

	i_leaders = [];
	["i_alpha",  -1] call VIPX_fnc_initLeader;
	["i_bravo",   0] call VIPX_fnc_initLeader;
	["i_charlie", 1] call VIPX_fnc_initLeader;

	[] call VIPX_fnc_initTriggers;
};

if (!isDedicated) then
{
	// wait for player, or JIP after 10 seconds
	waitUntil {!isNull player || time > 10};

	if (time > 10) then // must be JIP
	{
		0 cutText ["Mission already started ...", "BLACK IN", 5];
	}
	else // player
	{
		// fixes #1 complaint
		player enableFatigue false;

		[player] call VIPX_fnc_initEarplugs;

		if (b_vip == player) then
		{
			player setCaptive true;
			player addEventHandler ["Killed", { ["END2", "endMission", true, true, false] call BIS_fnc_MP }];
		};

		waitUntil {time > 3};
		0 cutText ["", "BLACK IN"];
	};

	// setup timer display
	[] call VIPX_fnc_initScoreboard;

	if (!isNull player) then
	{
		// give the player a sec, then present task
		waitUntil {time > 10};
		[] call VIPX_fnc_initTask;
	};
};
