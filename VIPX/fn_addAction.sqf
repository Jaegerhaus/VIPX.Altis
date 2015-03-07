
_unit = [_this, 0, objNull] call BIS_fnc_param;
_title = [_this, 1, ""] call BIS_fnc_param;
_script = [_this, 2, ""] call BIS_fnc_param;
_arguments = [_this, 3, objNull] call BIS_fnc_param;
_priority = [_this, 4, 0] call BIS_fnc_param;
_showWindow = [_this, 5, true] call BIS_fnc_param;
_hideOnUse = [_this, 6, true] call BIS_fnc_param;
_shortcut = [_this, 7, ""] call BIS_fnc_param;
_condition = [_this, 8, "true"] call BIS_fnc_param;

_unit addAction [_title, _script, _arguments, _priority, _showWindow, _hideOnUse, _shortcut, _condition];

false