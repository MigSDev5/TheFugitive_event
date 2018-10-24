/*
Dayz Event The Fugitive 
Created by Mig.
You can use, edit, share this script.
*/
if (!isNil "eventIsAlreadyRunning") exitWith {};

private ["_markerRadius","_skins","_fugiWeaponClass","_fugiWeaponAmmo","_numberMagsWeapon","_fugiLuncherClass","_fugiLuncherAmmo","_numberMagsLuncher","_fugiFirstVehicleClass","_fugitiveCoins","_fugitiveMagLoot","_fugitiveWeapLoot","_debug","_waitTime","_startTime","_towns","_randomTowns","_nameTown","_position","_newPos","_allPos","_check","_loop","_getPos","_thePos","_thePos","_monitor","_unit","_eventMarker","_dot","_time","_group","_Pos","_posMoto","_posCar","_unit2","_m","_aiskin","_unitGroup","_bot","_dot","_wp","_eventRun","_pos1"];

eventIsAlreadyRunning = true;

//----------- CONFIG --------------------------
_markerRadius = 850;                             // radius of the marker
_skins = ["Functionary2","Functionary1","Assistant","Citizen4","Pilot","Rocker3","SchoolTeacher","Villager3"];  // this is a class name of the skin of the fugitive
_fugiWeaponClass = "AK_107_kobra";               // class name fugitive weapon
_fugiWeaponAmmo = "30Rnd_545x39_AK";                // class name of the ammo for the fugitive weapon
_numberMagsWeapon = 4;                           // number magazine for the fugitive weapon 
_fugiLuncherClass = "M136";                      // clssname of the luncher
_fugiLuncherAmmo = "M136";                       // clssname ammo of the luncher
_numberMagsLuncher = 3;                          // number magazines for the luncher
_fugiFirstVehicleClass = "Old_moto_TK_Civ_EP1";  // class name of the first vehicle
_fugitiveCoins = 25000;                          // number  Coin in the fugitive ,if you want a random amount : round(random 20) * 1000; // number between 0 and 20 000
_fugitiveMagLoot = [["ItemWoodFloor",6],["ItemSandbag",7],["workbench_kit",9],["metal_floor_kit",12],["ItemDesertTent",10]];  // loot magazines on the fugitive
_fugitiveWeapLoot = ["ItemEtool","ItemCrowbar","ItemKnife","ItemSledge","ItemCompass","Binocular"];    // loot tools on the fugitive
_debug = false;                                   // activate/deactivate debug markers
_waitTime          = 2400;                       // time end event
//------------END CONFIG ---------------------------


//------------ do not touch after this line------------
uptdateRun = false;
_startTime = floor(time);

east setFriend [west,0];

_towns = nearestLocations [getMarkerPos "center", ["NameVillage","NameCity","NameCityCapital"],5000];
_randomTowns = (_towns select (floor (random (count _towns))));
_nameTown = text _randomTowns;
_position = position _randomTowns;
_newPos = _position findEmptyPosition [0,350];
_allPos = [_newPos];

_check = {
    _position = _this;
    _loop = true;
    while {_loop} do {
        _getPos = selectBestPlaces [[_position,0,1950,0,0,0.5,0] call BIS_fnc_findSafePos,20,"forest",1,1];
		_thePos = ((_getPos select 0) select 0);
		{
		    if ((_thePos distance _x < 600) or (_thePos distance _x >= 1500)) then {_loop = true;}else{_loop = false;
			    _thePos
		    };
		} forEach _allPos;
	};
	if (_debug) then {
	   _m setMarkerPos _thePos;
	};
	   _thePos
};

	[] spawn {
        timeleft = 0;
        _eventRun = true;
        while {_eventRun} do {
            timeleft = timeleft + 1;  
            uisleep 1;
        };
    };

_monitor = {
	_unit = _this select 0;
	_eventMarker = _this select 2;
	_dot = _this select 3;
	_time = _this select 4;
	_group = _this select 5;
	_fugiWeaponClass = _this select 6;
	_numberMagsWeapon = _this select 7;
	_fugiWeaponAmmo = _this select 8;
	_fugiLuncherClass = _this select 9;
	_numberMagsLuncher = _this select 10;
	_fugiLuncherAmmo = _this select 11;
	_fugiFirstVehicleClass = _this select 12;
	
	if (uptdateRun) exitWith {};
	uptdateRun = true;
	
	while {alive _unit} do {
	    sleep 20;
		_Pos = getPos _unit;
	    _eventMarker setMarkerPos [(_Pos select 0) + (round random 550),(_pos select 1) + (round random 550),0];
	    _dot setMarkerPos [_Pos select 0,(_pos select 1) + 600,0];
		
        if ((timeleft >= 200) and (timeleft <= 225)and (isNil "stepOne")) then { // ~3 minutes
		    stepOne = true;
			[nil,nil,rTitleText, "Be careful, the fugitive steals a weapon !", "PLAIN",10] call RE;
			_unit addWeapon _fugiWeaponClass;
	        _unit selectWeapon _fugiWeaponClass;
	        for "_a" from 1 to _numberMagsWeapon do {
	            _unit addMagazine _fugiWeaponAmmo;
            };
		};
		if ((timeleft >= 300) and (timeleft <= 325) and (isNil "stepToo")) then { // ~5 minutes
		    stepToo = true;
			[nil,nil,rTitleText, "The fugitive to find a rocket launcher and ammunition !", "PLAIN",10] call RE;
			_unit addWeapon _fugiLuncherClass;
	        for "_a" from 1 to _numberMagsLuncher do {
	            _unit addMagazine _fugiLuncherAmmo;
            };
		};
		if ((timeleft >= 420) and (timeleft <= 500) and (isNil "stepTree")) then {  // ~7 minutes
		    stepTree = true;
			[nil,nil,rTitleText, "The fugitive to steal a motorcycle, he will flee !", "PLAIN",10] call RE;
			_posMoto = [getPos _unit,0,35,0,0,0.5,0] call BIS_fnc_findSafePos;
			moto = createVehicle [_fugiFirstVehicleClass,_posMoto, [],0, "NONE"];
			moto setDir (getDir _unit);
			dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,moto];
			_unit moveIndriver moto;
			moto setVehicleLock "LOCKED";
		};
		if ((timeleft >= 600) and (timeleft <= 660) and (isNil "stepFour")) then {   // ~10 minutes
		    stepFour = true;
			[nil,nil,rTitleText, "The fugitive to steal an armed vehicle, find it!", "PLAIN",10] call RE;
			_posCar = [getPos _unit,0,36,0,0,0.5,0] call BIS_fnc_findSafePos;
			if (!isNil "moto") then {
			    moto setFuel 0;
			    sleep 2;
			    deleteVehicle moto;
			};
			car = createVehicle ["HMMWV_M1151_M2_CZ_DES_EP1",_posCar, [],0, "NONE"];
			car setDir (getDir _unit);
			car setVehicleLock "LOCKED";
			car engineOn true;
			dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,car];
			_unit moveIndriver car;
		};
		if ((timeleft >= 700) and (timeleft <= 725) and (isNil "stepFive")) then {   // ~11 minutes
		    stepFive = true;
			[nil,nil,rTitleText, "The fugitive recruit a gunner for his armed vehicle", "PLAIN",10] call RE;
            _unit2 = _group createUnit ["TK_Soldier_Engineer_EP1",[0,0,0], [],0, "NONE"];
		    _unit2 setVariable ["bodyName","Bob",false];
            [_unit2] joinSilent _group;
			_unit2 moveInGunner car;
			_unit2 assignAsGunner car;
		};			
	};
};

if (_debug) then {
    _m = createMarker ["desti",[0,0,0]];
    _m setMarkerText "Destination";
    _m setMarkerShape "ICON";
    _m setMarkerType "dot";
    _m setMarkerColor "ColorBlue";
    _m setMarkerAlpha 1;
    _m setMarkerSize [1,1];
};

_eventMarker = createMarker [format["fugitive_%1", _startTime], _position];
_eventMarker setMarkerShape "ELLIPSE";
_eventMarker setMarkerColor "ColorBlue";
_eventMarker setMarkerAlpha 0.5;
_eventMarker setMarkerSize [_markerRadius,_markerRadius];

_aiskin = _skins call BIS_fnc_selectRandom;
_curentTime = floor(time);

_unitGroup = createGroup east;
_unit = _unitGroup createUnit [_aiskin, _newPos, [], 10, "PRIVATE"];
[_unit] joinSilent _unitGroup;
_unit setVariable ["bodyName","Stan",false];

if (_fugitiveCoins != 0) then {
    _unit setVariable["cashMoney",_fugitiveCoins,true];
};

_unit enableAI "TARGET";
_unit enableAI "AUTOTARGET";
_unit enableAI "MOVE";
_unit enableAI "ANIM";
_unit enableAI "FSM";
_unit setCombatMode "RED";
_unitGroup setBehaviour "COMBAT";
removeAllWeapons _unit;
removeAllItems _unit;

if (count _fugitiveMagLoot > 0) then {
    {
	    for "_m" from 1 to (_x select 1) do {
            _unit addMagazine _x select 0;
		};
    } forEach _fugitiveMagLoot;
};
if (count _fugitiveWeapLoot > 0) then {
    {
         _unit addWeapon _x;
    } forEach _fugitiveWeapLoot;
};
	
if (_debug) then {
	_unit spawn {
	    _unit = _this;
	    while {alive _unit} do {
			_bot = createMarker ["bot", getPos _unit];
            _bot setMarkerText "Is Here";
            _bot setMarkerShape "ICON";
            _bot setMarkerType "camp";
            _bot setMarkerColor "ColorRed";
            _bot setMarkerAlpha 1;
            _bot setMarkerSize [1,1];
			sleep 1;
			deleteMarker _bot;
		};	
	};
};

_dot = createMarker [format["dot_%1", _startTime], [_newPos select 0,(_newPos select 1) + 500,0]];
_dot setMarkerText "Fugitive";
_dot setMarkerShape "ICON";
_dot setMarkerType "dot";
_dot setMarkerColor "ColorGreen";
_dot setMarkerAlpha 1;
_dot setMarkerSize [1,1];

[nil,nil,rTitleText,format ["A dangerous bandit  is  escape from the prison of %1, he managed to steal material and the money before disappearing in the nature. catch and kill it before he leaves the country !!",_nameTown], "PLAIN",10] call RE;

while {true} do {
    if (!alive _unit) exitWith {};
	if (timeleft > _waitTime) exitWith {};
	_Pos1 = _position call _check;
	_allPos set [count _allPos,_Pos1];
    [_unit,_Pos1,_eventMarker,_dot,_startTime,_unitGroup,_fugiWeaponClass,_numberMagsWeapon,_fugiWeaponAmmo,_fugiLuncherClass,_numberMagsLuncher,_fugiLuncherAmmo,_fugiFirstVehicleClass] spawn _monitor;
	_wp =_unitGroup addWaypoint [_Pos1,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 10;
	waitUntil {(!alive _unit) Or (_unit distance _Pos1 < 20)};
};

deleteMarker _eventMarker;
deleteMarker _dot;
uptdateRun = nil;
eventIsAlreadyRunning = nil;
_eventRun = false;

if (!alive _unit) then {
    [nil,nil,rTitleText,"The fugitive was killed.!!", "PLAIN",10] call RE;
	car = nil;
	moto = nil;
};
