
0 cutText["Loading objective ...", "BLACK FADED"];
0 cutFadeOut 9999999;

if (isServer) then
{
	waitUntil {time > 0};

	if (isNull b_vip) then { endMission "END2"; };

	[] call VIPX_fnc_initObjectives;

	[] call VIPX_fnc_initVIP;

	if (!isNull b_alpha) then   { [b_alpha,  -1] call VIPX_fnc_initLeader; };
	if (!isNull b_bravo) then   { [b_bravo,   0] call VIPX_fnc_initLeader; };
	if (!isNull b_charlie) then { [b_charlie, 1] call VIPX_fnc_initLeader; };

	if (!isNull o_alpha) then   { [o_alpha,  -1] call VIPX_fnc_initLeader; };
	if (!isNull o_bravo) then   { [o_bravo,   0] call VIPX_fnc_initLeader; };
	if (!isNull o_charlie) then { [o_charlie, 1] call VIPX_fnc_initLeader; };

	if (!isNull i_alpha) then   { [i_alpha,  -1] call VIPX_fnc_initLeader; };
	if (!isNull i_bravo) then   { [i_bravo,   0] call VIPX_fnc_initLeader; };
	if (!isNull i_charlie) then { [i_charlie, 1] call VIPX_fnc_initLeader; };

	[] call VIPX_fnc_initTriggers;
};

if (!isDedicated) then
{
	// wait for player, or JIP after 10 seconds
	waitUntil {!isNull player || time > 10};

	if (time > 10) then // must be JIP
	{
		0 cutText ["Mission already started ...", "BLACK FADED"];

		waitUntil {!isNull player};
		endMission "END4";
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
