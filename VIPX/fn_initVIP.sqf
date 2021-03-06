
_vipPos = markerPos ("vip_" + objective);
_building = nearestBuilding _vipPos;
_buildingPos = [_building] call VIPX_fnc_buildingPosMax;
_buildingPos = _buildingPos / 2;

b_vip setPosATL (_building buildingPos _buildingPos);
b_vip setCaptive true;
b_vip disableAI "MOVE";
removeAllWeapons b_vip;

b_vip addEventHandler ["Killed", { ["END2", "endMission", true, true, false] call BIS_fnc_MP; }];

// create guard group
_group = createGroup independent;
{
	_buildingPos = _buildingPos - 1;
	_pos = _building buildingPos _buildingPos;
	_unit = _group createUnit [_x, _pos, [], 0, ""];
	_unit setPosATL _pos;
	_unit disableAI "MOVE";
}
forEach ["I_medic_F", "I_Soldier_GL_F", "I_Soldier_02_f"];

// create ammo box
_crate = "Land_CratesWooden_F" createVehicle [_vipPos select 0, (_vipPos select 1) + 1, (_vipPos select 2) + 1];
[[_crate, "<t color='#ff1111'>Virtual Arsenal</t>", "[""Open"",true] spawn BIS_fnc_arsenal", nil, 0, true, true, "", "independent == side _this"], "VIPX_fnc_addAction", true, true, false] call BIS_fnc_MP;

VIPX_vip_running = false;
VIPX_vip_contact = false;

[] spawn
{
	_pos = getPosATL b_vip;

	while {true} do
	{
		sleep 2;

		if (!VIPX_vip_running && getPosATL b_vip distance _pos > 5) then
		{
			VIPX_vip_running = true;
			["VIP is running!", "hint", true, false, false] call BIS_fnc_MP;
			[[b_vip, false], "setCaptive", b_vip, false, false] call BIS_fnc_MP;
			{
				_group = group _x;
				_group reveal [b_vip, 3];
				deleteWaypoint [_group, 0];
				_wp = _group addWaypoint [b_vip, 0];
				_wp setWaypointType "DESTROY";
				_wp setWaypointDescription "Find the VIP";
			}
			forEach i_leaders;
		};
		if (!VIPX_vip_contact) then
		{
			{
				if (b_vip distance _x < 2 && !VIPX_vip_contact) then
				{
					VIPX_vip_contact = true;
					b_vip setCaptive false;
					b_vip enableAI "MOVE";
					b_vip setBehaviour "CARELESS";
					[b_vip] join group _x;
					{ _x reveal [b_vip, 3]; } foreach allunits;
					["VIP contacted!", "hint", true, false, false] call BIS_fnc_MP;
				};
			}
			forEach b_leaders;
		};
		if (getPosATL b_vip distance _pos > 500) then
		{
			["END1", "endMission", true, true, false] call BIS_fnc_MP;
		};
	};
};

false