
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
_trigger setTriggerStatements ["this", "VIPX_west_eliminated = true", ""];
_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
_trigger setTriggerStatements ["VIPX_west_eliminated && VIPX_east_eliminated", "[[""END3""], ""VIPX_fnc_endMission"", true, true, true] call BIS_fnc_mp;", ""];

// create trigger for timeout
_trigger = createTrigger ["EmptyDetector", getPosATL b_vip];
_trigger setTriggerTimeout [600, 600, 600, false];
_trigger setTriggerStatements ["true", "[[""END3""], ""VIPX_fnc_endMission"", true, true, true] call BIS_fnc_mp;", ""];
