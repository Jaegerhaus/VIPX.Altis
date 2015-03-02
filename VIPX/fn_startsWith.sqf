
private ["_needle", "_haystack", "_found"];

_haystack = [_this, 0, "", [""]] call BIS_fnc_param;
_needle = [_this, 1, "", [""]] call BIS_fnc_param;
_found = false;

if (_needle != "" && _needle isEqualTo (_haystack select [0, count _needle])) then
{
	_found = true;
};

_found