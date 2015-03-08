
0 cutText["Loading objective ...", "BLACK FADED"];
0 cutFadeOut 9999999;

if (isServer) then
{
	waitUntil {time > 0};

	[] call VIPX_fnc_initObjectives;

	[] call VIPX_fnc_initVIP;

	[b_alpha,  -1] call VIPX_fnc_initLeader;
	[b_bravo,   0] call VIPX_fnc_initLeader;
	[b_charlie, 1] call VIPX_fnc_initLeader;

	[o_alpha,  -1] call VIPX_fnc_initLeader;
	[o_bravo,   0] call VIPX_fnc_initLeader;
	[o_charlie, 1] call VIPX_fnc_initLeader;

	[i_alpha,  -1] call VIPX_fnc_initLeader;
	[i_bravo,   0] call VIPX_fnc_initLeader;
	[i_charlie, 1] call VIPX_fnc_initLeader;

	[] call VIPX_fnc_initTriggers;
};

if (!isDedicated) then
{
	// wait for player, or JIP after 10 seconds
	waitUntil {!isNull player || time > 10};

	if (time > 10) then // must be JIP
	{
		0 cutText ["Waiting for next round ...", "BLACK IN"];
	}
	else
	{
		// have to reset setCaptive for players
		if (b_vip == player) then { b_vip setCaptive true; };

		[player] call VIPX_fnc_initEarplugs;

		player enableFatigue false; // fixes #1 complaint

		waitUntil {time > 3};
		0 cutText ["", "BLACK IN"];
	};

	// setup timer display
	cutRsc ["ScoreBoard", "PLAIN"];
	[] spawn
	{
		disableSerialization;
		_scoreBoard = uiNamespace getVariable ["ScoreBoard", displayNull];
		waitUntil { !isNull _scoreBoard };
		_scoreTimeRemaining = _scoreBoard displayCtrl 1101;

		while {time <= 600} do
		{
			_scoreTimeRemaining ctrlSetStructuredText text format ["%1", [600 - time, "MM:SS"] call BIS_fnc_secondsToString];
			sleep 0.99;
		};
	};

	if (!isNull player) then
	{
		// give the player a sec, then present task
		waitUntil {time > 10};
		_description = "";
		switch (side player) do
		{
			case west: {_description = "Extract the VIP"};
			case east: {_description = "Eliminate the VIP"};
			case civilian: {_description = "Wait for extraction"};
			case independent: {_description = "Protect the VIP"};
		};
		_task = player createSimpleTask ["vip"];
		_task setSimpleTaskDescription [_description, _description, "VIP"];
		_task setSimpleTaskDestination (getPosATL b_vip);
		player setCurrentTask _task;
		["TaskAssigned", ["", _description]] call BIS_fnc_showNotification;
	};
};
