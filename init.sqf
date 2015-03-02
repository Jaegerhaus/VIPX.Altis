
0 cutText["Loading objective ...", "BLACK FADED"];
0 cutFadeOut 9999999;

if (isServer) then
{
	waitUntil {time > 0};

	[] call VIPX_fnc_initObjectives;

	[] call VIPX_fnc_initVIP;

	[b_alpha, 0] call VIPX_fnc_initLeader;
	[b_bravo, 1] call VIPX_fnc_initLeader;
	[b_charlie, -1] call VIPX_fnc_initLeader;
	[o_alpha, 0] call VIPX_fnc_initLeader;
	[o_bravo, 1] call VIPX_fnc_initLeader;
	[o_charlie, -1] call VIPX_fnc_initLeader;
	[i_alpha, 0] call VIPX_fnc_initLeader;
	[i_bravo, 1] call VIPX_fnc_initLeader;
	[i_charlie, -1] call VIPX_fnc_initLeader;

	// create trigger for VIP to run when guards are gone
	_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
	_trigger setTriggerArea [10000, 10000, 0, false];
	_trigger setTriggerActivation ["GUER", "NOT PRESENT", false];
	_trigger setTriggerStatements ["this", "VIPX_vip_running = true; b_vip setCaptive false; b_vip enableAI ""MOVE""; _pos = markerPos (""vip_"" + objective); b_vip move [_pos select 0, (_pos select 1) + 500, _pos select 2]; [""VIP is free!"", ""hint"", true, true, true] call BIS_fnc_mp;", ""];

	// create triggers for indy win
	_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
	_trigger setTriggerArea [10000, 10000, 0, false];
	_trigger setTriggerActivation ["EAST", "NOT PRESENT", false];
	_trigger setTriggerStatements ["this", "VIPX_east_eliminated = true", ""];
	_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
	_trigger setTriggerArea [10000, 10000, 0, false];
	_trigger setTriggerActivation ["WEST", "NOT PRESENT", false];
	_trigger setTriggerStatements ["this && VIPX_east_eliminated", "[[""END3""], ""VIPX_fnc_endMission"", true, true, true] call BIS_fnc_mp;", ""];

	// create trigger for timeout
	_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
	_trigger setTriggerTimeout [600, 600, 600, false];
	_trigger setTriggerStatements ["true", "[[""END3""], ""VIPX_fnc_endMission"", true, true, true] call BIS_fnc_mp;", ""];
};

if (!isDedicated) then
{
	waitUntil {!isNull player || time > 10};

	if (time > 10) exitWith { 0 cutText ["", "BLACK IN"]; };

	player enableFatigue false;
	[player] call VIPX_fnc_initEarplugs;

	if (b_vip == player) then { b_vip setCaptive true; };

	waitUntil {time > 3};

	0 cutText ["", "BLACK IN"];
	cutRsc ["ScoreBoard", "PLAIN"];

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

	[] spawn
	{
		disableSerialization;
		_scoreBoard = uiNamespace getVariable ["ScoreBoard", displayNull];
		waitUntil { !isNull _scoreBoard };
		_scoreUnitsRemaining = _scoreBoard displayCtrl 1100;
		_scoreTimeRemaining = _scoreBoard displayCtrl 1101;

		while {true} do
		{
			_scoreUnitsRemaining ctrlSetStructuredText text format ["%1", sprinklesRemaining];
			_scoreTimeRemaining ctrlSetStructuredText text format ["%1", [600 - time, "MM:SS"] call BIS_fnc_secondsToString];
			sleep 0.99;
		};
	};
};
