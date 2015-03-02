
_building = _this select 0;

_n = 0;
while { (_building buildingPos _n) select 0 != 0 } do
{
	_n = _n + 1;
};

_n - 1