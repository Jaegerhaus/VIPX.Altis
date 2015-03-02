
objectives = [];

{
	if ([_x, "vip_"] call VIPX_fnc_startsWith) then
	{
		_objective = _x select [4, count(toArray _x) - 4];
		objectives pushBack _objective;
	};
}
forEach allMapMarkers;

objective = objectives call BIS_fnc_selectRandom;
