
_unit = _this select 0;

actionEarplugs =
[
	"<t color='#ffff33'>Ear plugs IN</t>",
	{
		_s = _this select 0;
		_i = _this select 2;

		if (soundVolume != 1) then
		{
			1 fadeSound 1;
			_s setUserActionText [_i, "<t color='#ffff33'>Ear plugs IN</t>"];
		}
		else
		{
			1 fadeSound 0.1;
			_s setUserActionText [_i, "<t color='#ffff33'>Ear plugs OUT</t>"];
		}
	},
	[],
	-90,
	false
];

_unit addAction actionEarplugs;

_unit addEventHandler
[
	"Respawn",
	{
		1 fadeSound 1;
		(_this select 0) addAction actionEarplugs;
	}
];

false