
_unitName = [_this, 0, ""] call BIS_fnc_param;
_offset = [_this, 1, 0] call BIS_fnc_param;

_unit = missionNamespace getVariable [_unitName, objNull];
if (isNull _unit) exitWith {};

_pos = [0, 0, 0];
_team = [];
_vicType = "";

_initWest =
{
	b_leaders = b_leaders + [_unit];
	_pos = markerPos ("b_" + objective);
	_vicType = "B_Heli_Light_01_F";
	_team =
		[
			["B_medic_F"],
			["B_Soldier_GL_F"]
		];
};
_initEast =
{
	o_leaders = o_leaders + [_unit];
	_pos = markerPos ("o_" + objective);
	_vicType = "O_G_Offroad_01_armed_F";
	_team =
		[
			["O_medic_F"],
			["O_Soldier_GL_F"]
		];
};
_initIndependent =
{
	i_leaders = i_leaders + [_unit];
	_pos = markerPos ("vip_" + objective);
	_team =
		[
			["I_medic_F"],
			["I_Soldier_GL_F"],
			["I_Soldier_02_f"]
		];
};

switch (side _unit) do
{
	case west: _initWest;
	case east: _initEast;
	case independent: _initIndependent;
};

_pos = [(_pos select 0) + _offset * 10, _pos select 1, (_pos select 2) + 1];
_unit setPos _pos;

// create the group and clear waypoints
_group = createGroup side _unit;
deleteWaypoint [_group, 0];

_vipPos = getPosATL b_vip;

if ("" != _vicType) then
{
	// spawn the vehicle
	_vicPos = [_pos select 0, (_pos select 1) + 10, _pos select 2];
	_vic = _vicType createVehicle _vicPos;
	_vic setDir 180;

	// add ammobox
	[[_vic, "<t color='#ff1111'>Virtual Arsenal</t>", "[""Open"",true] spawn BIS_fnc_arsenal", nil, 0, true, true, "", format ["%1 == side _this", side _unit]], "VIPX_fnc_addAction", true, true, false] call BIS_fnc_MP;

	// get in the vehicle
	_wp = _group addWaypoint [_vicPos, 0];
	//_wp showWaypoint "ALWAYS";
	_wp setWaypointType "GETIN";
	_wp waypointAttachVehicle _vic;
	_wp setWaypointDescription "Get in!";

	// move to the AO
	_wp = _group addWaypoint [_vipPos, 0];
	//_wp showWaypoint "ALWAYS";
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 500;
	_wp setWaypointDescription "Get to the VIP";

	// get out of the vehicle
	_wp = _group addWaypoint [_vipPos, 0];
	//_wp showWaypoint "ALWAYS";
	_wp setWaypointType "GETOUT";
	_wp setWaypointCompletionRadius 500;
	_wp setWaypointDescription "Get to the VIP";

	// move to the VIP
	_wp = _group addWaypoint [_vipPos, 0];
	//_wp showWaypoint "ALWAYS";
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 0.1;
	_wp setWaypointDescription "Find the VIP";

	if (west == side _unit) then
	{
		// move to extract the VIP
		_wp = _group addWaypoint [[_vipPos select 0, (_vipPos select 1) + 1000, _vipPos select 2], 0];
		//_wp showWaypoint "ALWAYS";
		_wp setWaypointType "MOVE";
		_wp setWaypointDescription "Extract the VIP";
	};
}
else
{
	_wp = _group addWaypoint [_vipPos, 0];
	_wp setWaypointType "GUARD";
	_wp setWaypointCompletionRadius 500;
};

// add the unit and team to the group
[_unit] join _group;
{
	_type = _x select 0;
	_subordinate = _group createUnit [_type, _pos, [], 0, ""];
	_subordinate setPosATL _pos;
	[_subordinate] join _group;
}
forEach _team;

false