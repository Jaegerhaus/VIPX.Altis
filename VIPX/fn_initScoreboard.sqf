
1 cutRsc ["ScoreBoard", "PLAIN"];
[] spawn
{
	disableSerialization;
	_scoreBoard = uiNamespace getVariable ["ScoreBoard", displayNull];
	waitUntil { !isNull _scoreBoard };
	_scoreTimeRemaining = _scoreBoard displayCtrl 1101;

	while {time <= 600} do
	{
		_scoreTimeRemaining ctrlSetStructuredText text format ["%1", [600 - time, "MM:SS"] call BIS_fnc_secondsToString];
		sleep 0.99;
	};
};

false