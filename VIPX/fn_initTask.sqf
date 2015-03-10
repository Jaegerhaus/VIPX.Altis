
if (isNull player) exitWith {};

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

false