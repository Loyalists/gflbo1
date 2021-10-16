//PENTAGON
//Scripter: Chris Eng (FXVille)
//Builder: Reed Shingledecker (FXVille)

/*
//******************************************************************************
//EVENT and BEAT Rundown
//
//E1) HELIPAD
//	b1) Mason (player) sees the Pentagon as the helicopter lands.
//	b2) Mason turns to Hudson and experiences as flashback.
//	b3) Hudson and Mason exit onto the helipad, where the screen splits 24-style.
//	b4) Hudson and Mason enter a limousine that pulls up in front of them.
//	b5) Mason is introduced to McNamara.
//	b6) The limousine and motorcade peel out en route to the Pentagon.
//
//E2) MOTORCADE
//	b1) McNamara hands Mason a dossier containing Dragovich's profile.
//	b2) Mason experiences a sequence of flashbacks triggered by the profile.
//	b3) The motorcade is shown arriving at the Pentagon via a sequence of cuts.
//
//E3) SECURITY
//	b1) McNamara checks in at the security counter.
//	b2) Hudson, Mason, and McNamara bypass the metal detectors.
//	b3) Their entrance into the pool is truncated by fast-forward effects.
//
//E4) POOL
//	b1) Hudson, Mason, and McNamara walk through as McNamara guides them.
//	b2) Mason's view lingers on the secretary, who then exhales smoke at him.
//	b2) McNamara checks in at the security checkpoint. 
//	b3) Hudson, Mason, and McNamara walk to the elevator at the end of the hall.
//	b4) McNamara speaks a password to the guards, who then let them in.
//	
//E5) ELEVATOR
//	b1) The elevator descent is truncated by fast-forward effects.
//
//E6) WARROOM
//	b1) Hudson, Mason, and McNamara exit the elevator.
//	b2) They travel downstairs while the screen splits 24-style.
//	b3) They stop at midlanding to admire the activity.
//	b4) They resume down to the antechamber door, where McNamara gives another password.
//	b5) The guards step aside and let them through.
//
//E7) BRIEFING
//	b1) Hudson, Mason, and McNamara enter as two generals leave.
//	b2) Hudson departs while McNamara has Mason sit.
//	b3) McNamara addresses President Kennedy in the corner.
//	b4) Kennedy sits, then discusses Dragovich with Mason.
//******************************************************************************
*/

#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;
#include maps\_utility;
#include maps\_vehicle;
#include maps\pentagon_code;

main()
{
	//client flag to toggle on and off glasses shader on hudson.
	level.CLIENT_SWITCH_GLASSES	= 2;
	level.CLIENT_SWITCH_GLASSES_BINK = 3;
	
	level.CLIENT_JFK_MON1 = 4;
	level.CLIENT_JFK_MON2 = 5;
	level.CLIENT_JFK_MON3 = 6;
	level.CLIENT_JFK_MON4 = 7;
	level.CLIENT_JFK_MON5 = 8;
	level.CLIENT_JFK_MON6 = 9;
	level.CLIENT_JFK_MON7 = 10;
	level.CLIENT_JFK_MON8 = 11;
	level.CLIENT_JFK_MON9 = 12;
	level.CLIENT_JFK_MON10 = 13;
	level.CLIENT_JFK_MON11 = 14;
	
	
	//Keep this first for CreateFX.
	level maps\pentagon_fx::main();
	
	//Setups that need to be called before _load::main().
	level setup_precache();
	level setup_flags();

	level.reviveFeature = false; 					//To prevent RTE from _load::main().
	level.contextualMeleeFeature = false; //To prevent RTE from _load::main();

	//DEV - Starts
	default_start( ::e1_jumpto );
	add_start( "e1_helipad",	 ::e1_jumpto, &"E1_HELIPAD"	  );
	add_start( "e2_motorcade", ::e2_jumpto, &"E2_MOTORCADE" );
	add_start( "e3_security",  ::e3_jumpto, &"E3_SECURITY"  );
	add_start( "e4_pool",   	 ::e4_jumpto, &"E4_POOL" 		  );
	add_start( "e5_elevator",  ::e5_jumpto, &"E5_ELEVATOR"  );
	add_start( "e6_warroom",   ::e6_jumpto, &"E6_WARROOM"   );
	add_start( "e7_briefing",  ::e7_jumpto, &"E7_BRIEFING"  );
	add_start( "dev_freeroam_exterior", ::dev_freeroam_exterior, &"DEV_FREEROAM_EXTERIOR" );
	add_start( "dev_freeroam_interior", ::dev_freeroam_interior, &"DEV_FREEROAM_INTERIOR" );

	//------------------
	// Load!
	//------------------
	level maps\_load::main();
	//------------------
	// End Load
	//------------------

	//Player
	OnPlayerConnect_Callback( ::setup_player );

	//Other level files
	level maps\pentagon_amb::main();
	level maps\pentagon_anim::main();

	//Level
	level.FADE_TIME = 1.00;
	level.DEFAULTFOV = GetDvarFloat( "cg_fov" ); //65.0deg
	level setup_anim_structs();
	level setup_camera_prefabs();
	level thread init_dummies(); //Threaded because it contains wait statements.

	//All setup complete, begin running the level.
	level thread events_main();
}

//******************************************************************************
//HIGH LEVEL SETUP
//******************************************************************************
setup_precache() //self == level
{
	//Actors
	PrecacheModel( "c_usa_pent_mcnamara_sitting_fb" );
	//PreCacheModel( "c_usa_pent_mcnamara_fb" );
	PrecacheModel( "t5_gfl_m1903_body_sitting" );

	//Fullscreen video
	precacheShader( "cinematic" );

	//Vehicles
	PrecacheModel( "vehicle_ch46e_interior" );

	//Player
	PrecacheModel( "c_usa_pentagon_mason_fb" );

	//Props
	PrecacheModel( "p_glo_cigarette01" );
	PrecacheModel( "p_pent_coffeemug" );
	PrecacheModel( "p_glo_clipboard_wpaper" );
	PrecacheModel( "t5_weapon_M16A1_world_clean" );
	PrecacheModel( "anim_pent_chair_office_simple" ); //Final
	PrecacheModel( "anim_pent_av_cart" );							//Final
	PrecacheModel( "p_pent_dossier" );								//This is the correct model, just named incorrectly.
	PrecacheModel( "anim_pent_chair_boardroom" );
	PrecacheModel( "anim_pent_phone_office" );

	//Elevator
	PrecacheModel( "p_pent_elevator_indicator_lit_large" ); //Exterior indicator, swaps in when guard presses button.
	PrecacheModel( "p_pent_elevator_indicator_lit02" );			//Interior indicator, swaps in when elevator reaches warroom.
		
	//gun model
	PrecacheModel("t5_weapon_1911_lh_world");

}

setup_flags() //self == level
{
	//TODO: Convert waittills into flag_waits!
	flag_init( "player_setup_complete" );
	flag_init("glasses_movie");
	flag_init("glasses_done");
	flag_init("warroom");
}

setup_player() //self == player
{
	//Need a wait so that AllowSprint(), etc., work.
	level wait_for_all_players();

	//BUG - If the player restarts the level while using the secondary camera, the
	//view upon restart will be frozen! Fix the problem by always deactivating it.
	//Bloom/exposure: if the player restarts during the JFK TV bloom (grr...) then
	//it will carry over into the next playthrough. This will stop that.
	self CameraActivate( false );
	SetDvar( "r_bloomTweaks", "0" );
	SetDvar( "r_exposureTweak", "0" );

	//Make the player behave.
	self TakeAllWeapons(); //Take any weapons that may have slipped through.
	self DisableWeapons(); //Disable weapons to further block their use.
	self HideViewModel();	 //The player will not be holding weapons anyway, so hide this.
	self AllowMelee( false );
	self AllowSprint( false );
	self AllowJump( false );
	self AllowCrouch( false );
	self AllowProne( false );
	self AllowLean( false );
	//self.disablemelee = 1;

	//Needed for player speech.
	self.animname = "mason";

	//Turn off combat-related HUD elements.
	self SetClientDvar( "compass", "0" );
	self SetClientDvar( "hud_showstance", "0" );
	self SetClientDvar( "actionSlotsHide", "1" );
	self SetClientDvar( "ammoCounterHide", "1" );

	//Give the player a first-person body so we can "animate" them.
	//NOTE: Must wait between spawning and linking, otherwise the game will crash on restart!
	self.playerbody_firstperson = spawn_anim_model( "playerbody_firstperson" );
	self.playerbody_firstperson align_to( self );
	wait 0.05;
	
	self thread player_linkto_function();
	
	//Give the player a third-person body so we can show them with other cameras.
	self.playerbody_thirdperson = spawn_anim_model( "playerbody_thirdperson" );
	//self.playerbody_thirdperson align_to( self );
	//wait 0.05;
	//self.playerbody_thirdperson LinkTo( self.playerbody_firstPerson, "tag_origin" ); //Is this link necessary?

	//Show the first-person body, hide the third-person body.
	self player_show_first_person();

	//Now that a player has connected, fog settings will be acknowledged.
	level maps\createart\pentagon_art::main();

	//All done! Let setup_heroes() know that it can add self.playerbody_firstperson to its collection of heroes.
	flag_set( "player_setup_complete" );
	get_players()[0] SetClientdvar( "cg_fov", 65 );
}


player_linkto_function()
{
	self player_linkto_delta(self.playerbody_firstperson, "tag_player");
	
	flag_wait("glasses_movie");
	
	self StartCameraTween(1.0);
	
	self PlayerLinkToDelta(self.playerbody_firstperson, "tag_player", 1, 0, 0, 0, 0, false);
	
	flag_wait("glasses_done");
	
	self player_linkto_delta(self.playerbody_firstperson, "tag_player");
}


setup_anim_structs() //self == level
{
	if( !isDefined( level.anim_structs ) )
	{
		//Collect all of the animation alignment structs in the level.
		unsorted_structs = getStructArray( "struct_anim_align", "script_noteworthy" );

		//Prepare a new array to store each of them.
		level.anim_structs = [];

		//For each struct, store it using their targetname as their key.
		for( i = 0; i < unsorted_structs.size; i++ )
		{
			struct = unsorted_structs[i];

			level.anim_structs[ struct.targetname ] = struct;
		}
	}

	//Intended use:
	//level.anim_structs[ "helipad" ] anim_single( guy, "chicken_dance" );
}

setup_camera_prefabs()
{
	//Get the limo and bike entities.
	prefabLimo = GetEnt( "smodel_camera_alignment_limo", "targetname" );
	prefabBike = GetEnt( "smodel_camera_alignment_bike", "targetname" );
	
	//Get their camera entities.
	prefabLimoEnts = GetEntArray( "origin_camera_alignment_limo_component", "script_noteworthy" );
	prefabBikeEnts = GetEntArray( "origin_camera_alignment_bike_component", "script_noteworthy" );
	
	//Tell the client that these entities are "important", allowing us to use them for camera purposes.
	//NOTE: this has nothing to do with sound, the function merely doubles as a way to get the client's attention.
	array_thread( prefabLimoEnts, ::stop_sounds );
	array_thread( prefabBikeEnts, ::stop_sounds );
	
	//Link their camera entities to them so we can move all of them together at once.
	array_thread( prefabLimoEnts, ::link_to, prefabLimo );
	array_thread( prefabBikeEnts, ::link_to, prefabBike );
	
	//Hide both of the vehicle entities; we want to use their orientation, not see them!
	prefabLimo Hide();
	prefabBike Hide();
	
	//Make each of the vehicle entities available for quick reference.
	level.prefabLimo = prefabLimo;
	level.prefabBike = prefabBike;
}

setup_heroes()
{
	if( !IsDefined( level.heroes ) )
	{
		//Wait until the playerbody_firstperson exists.
		flag_wait( "player_setup_complete" );

		//Spawn the other two heroes.
		level.hudson 	 							 = simple_spawn_dummy( "spawner_hudson" );
		level.mcnamara 							 = simple_spawn_dummy( "spawner_mcnamara" );
		if( is_true( level.sitting_mcnamara ) )
		{
			level.mcnamara SetModel( "t5_gfl_m1903_body_sitting" );
		}
		level.playerbody_firstperson = get_players()[0].playerbody_firstperson;

		//Store them in an array so we can use anim_* functions on them as a group.
		level.heroes = [];
		level.heroes[ 0 ] = level.playerbody_firstperson;
		level.heroes[ 1 ] = level.hudson;
		level.heroes[ 2 ] = level.mcnamara;
		
		//TEST
		//level.playerbody_thirdperson = get_players()[0].playerbody_thirdperson;
		//level.heroes[ 3 ] = level.playerbody_thirdperson;
	}
	
	level thread do_cinematic_blending( true );
}

//******************************************************************************
//EVENT-SPECIFIC SETUPS
//******************************************************************************
setup_helicopter()
{
	if( !isDefined( level.helicopter ) )
	{
		//Spawn the body of the helicopter.
		level.helicopter = spawn_anim_model( "helicopter", level.anim_structs[ "helipad" ].origin, level.anim_structs[ "helipad" ].angles );

		//Assemble the rotor blades (the effect is rotated 90degrees to the side,
		//so a little rotation-link magic is needed to align them correctly).
		level.helicopter.main_ent = spawn( "script_model", (0,0,0) );
		level.helicopter.tail_ent = spawn( "script_model", (0,0,0) );
		level.helicopter.main_ent setModel( "tag_origin" );
		level.helicopter.tail_ent setModel( "tag_origin" );
		level.helicopter.main_ent linkTo( level.helicopter, "main_rotor_jnt", (0,0,0), (-90,0,0) );
		level.helicopter.tail_ent linkTo( level.helicopter, "tail_rotor_jnt", (0,0,0), (-90,0,0) );
		PlayFXOnTag( level._effect[ "chinook_main_blade" ], level.helicopter.main_ent, "tag_origin" );
		PlayFXOnTag( level._effect[ "chinook_rear_blade" ], level.helicopter.tail_ent, "tag_origin" );

		/*//Add pilots.
		level.helicopter.pilot0 = spawn_drones( "struct_pilot_spawner" )[0];
		level.helicopter.pilot1 = spawn_drones( "struct_pilot_spawner" )[0];
		level.helicopter.pilot0 linkTo( level.helicopter, "tag_driver" );		 //Necessary or else they will not follow the heli!
		level.helicopter.pilot1 linkTo( level.helicopter, "tag_passenger" ); //Necessary or else they will not follow the heli!
		level.helicopter thread anim_loop_aligned( level.helicopter.pilot0, "drive_idle_loop", "tag_driver" );
		level.helicopter thread anim_loop_aligned( level.helicopter.pilot1, "drive_idle_loop", "tag_passenger" );

		level.helicopter.usss0 = spawn_drones( "struct_usss_spawner" )[0];
		level.helicopter.usss1 = spawn_drones( "struct_usss_spawner" )[0];
		*/

		//Add drone occupants.
		level.helicopter.riders = [];
		level.helicopter.riders[ "cia" ]  = simple_spawn_dummy( "spawner_cia_chopper" );
		level.helicopter.riders[ "usmp" ] = simple_spawn_dummy( "spawner_usmp_guard" );

		//level.helicopter.riders[ "cia_guyb" ] = simple_spawn_dummy( "spawner_cia" );
		//level.helicopter.riders[ "cia_guyc" ] = simple_spawn_dummy( "spawner_cia" );

		//Light the cabin!
		level.helicopter maps\pentagon_fx::heli_interior_lights_on();
		SetSavedDvar( "r_flashLightRange", "300" );
		SetSavedDvar( "r_flashLightEndRadius", "600" );
		SetSavedDvar( "r_flashLightBrightness", "25" );
		SetSavedDvar( "r_flashLightFlickerAmount", "0" );
		SetSavedDvar( "r_flashLightFlickerRate", "0" );
		SetSavedDvar( "r_flashLightColor", "1 1 1" );
		SetSavedDvar( "r_enableFlashlight","0" );   

	}

}

clear_helicopter()
{
	if( isDefined( level.helicopter ) )
	{
		//Delete the rotor effects (just delete the ent they are playing on).
		level.helicopter.main_ent delete();
		level.helicopter.tail_ent delete();
		
		//Delete the helicopter dummies (this includes the guy who opens the door).
		array_thread( level.helicopter.riders, ::dummy_delete );

		//Delete the helicopters's interior light, otherwise it will leak.
		level.helicopter.interior_lights Delete();

		//All dependencies deleted, now delete the helicopter itself.
		level.helicopter delete();
	}
}

setup_interior()
{
	//Setup the elevator doors and movement logic.
	level elevator_system_init();

	//This is now handled by set_pool_visuals(), et. al.
	//Visuals.
	//level maps\pentagon_fx::set_pool_visuals( 0.0 );
	//Turn the wind off so the little model trees don't sway.
	//level maps\pentagon_fx::wind_still_setting();

	//Link the TV to the AV cart so the cartpush_hurry guy can push them both.
	//cart = GetEnt( "smodel_pool_cart", "targetname" );
	//tv = GetEnt( "smodel_pool_cart_tv", "targetname" );
	//tv LinkTo( cart );


}

//HELIPAD MOTORCADE MADE ENTIRELY OF SCRIPT_MODELS, SINCE THEY WILL BE ANIMATED!
setup_fake_motorcade()
{
	if( !IsDefined( level.fakeMotorcade ) )
	{
		//Create an array to store the fakes.
		level.fakeMotorcade = [];

		//Setup four motorcycles.
		for( i = 0; i < 4; i++ )
		{
			//Spawn the motorcycle and rider.
			motorcycle 										= spawn_anim_model( "motorcycle" );
			motorcycle.riders[ "driver" ] = simple_spawn_dummy( "spawner_usmp_moto" );

			//Turn the lights on.
			motorcycle maps\pentagon_fx::vehicle_lights_on( true, true );

			//Add the motorcycle to the array, indexed by key.
			level.fakeMotorcade[ "motorcycle_" + string(i) ] = motorcycle;
		}

		//Setup two cars.
		for( i = 0; i < 2; i++ )
		{
			//Spawn the car, driver, and passenger.
			car 			 								= spawn_anim_model( "car" );
			car.riders[ "driver" ] 	  = simple_spawn_dummy( "spawner_usmp_guard" ); //simple_spawn_dummy( "spawner_cia" ); //spawn_drones( "struct_usss_spawner" )[0];
			car.riders[ "passenger" ] = simple_spawn_dummy( "spawner_usmp_guard" ); //simple_spawn_dummy( "spawner_cia" ); //spawn_drones( "struct_usss_spawner" )[0];

			//Seat them and have them loop basic animations.
			car.riders[ "driver" ] 	 linkTo( car, "tag_driver", (0,0,0), (0,0,0) );
			car.riders[ "passenger" ] linkTo( car, "tag_passenger", (0,0,0), (0,0,0) );
			wait 0.05; //Let the characters move into place before animating them!
			car.riders[ "driver" ] 	 thread anim_single( car.riders[ "driver" ], 	 "limousine_driver" );
			car.riders[ "passenger" ] thread anim_single( car.riders[ "passenger" ], "limousine_passenger" );

			//Turn the lights on.
			car maps\pentagon_fx::vehicle_lights_on( true );

			//Add the car to the array, indexed by key.
			level.fakeMotorcade[ "car_" + string(i) ] = car;
		}

		//Setup the limo.
		limo 			 		 						 = spawn_anim_model( "limousine" );
		limo.riders[ "driver" ] 	 = simple_spawn_dummy( "spawner_cia" ); 		 //spawn_drones( "struct_usss_spawner" )[0];
		limo.riders[ "passenger" ] = simple_spawn_dummy( "spawner_cia" );			 //spawn_drones( "struct_usss_spawner" )[0];
		limo.riders[ "general" ]   = simple_spawn_dummy( "spawner_general" );	 //spawn_drones( "struct_general_spawner" )[0];

		//Seat the driver and passenger and have them loop basic animations.
		limo.riders[ "driver" ] 	 LinkTo( limo, "tag_driver", (0,0,0), (0,0,0) );
		limo.riders[ "passenger" ] LinkTo( limo, "tag_passenger", (0,0,0), (0,0,0) );
		wait 0.05; //Let the characters move into place before animating them!	
		limo.riders[ "driver" ] 	 thread anim_single( limo.riders[ "driver" ], 	 "limousine_driver" );
		limo.riders[ "passenger" ] thread anim_single( limo.riders[ "passenger" ], "limousine_passenger" );

		//Swap McNamara's model to the sitting version!
		level.mcnamara SetModel( "t5_gfl_m1903_body_sitting" );

		//Seat McNamara and the general into a seat by using anim_first_frame();
		limo anim_first_frame( level.mcnamara, 					 "helipad_rail_limo", "tag_origin" );
		limo anim_first_frame( limo.riders[ "general" ], "helipad_rail_limo", "tag_origin" );
		wait 0.05;
		level.mcnamara 					 LinkTo( limo );
		limo.riders[ "general" ] LinkTo( limo );

		//Turn the lights on.
		limo maps\pentagon_fx::vehicle_lights_on( true );
		limo maps\pentagon_fx::limo_interior_lights_on();

		//Add the limo to the array, indexed by key.
		level.fakeMotorcade[ "limousine" ] = limo;
	}
}

//MOTORCADE MADE ENTIRELY OF SCRIPT_VEHICLES, SINCE THEY WILL BE DRIVEN!
setup_real_motorcade()
{
	if( !isDefined( level.realMotorcade ) )
	{
		//Spawn the motorcade.
		level.realMotorcade = maps\_vehicle::scripted_spawn( 1 );
		
		//MUST WAIT FOR ANIMATION TO BE UPDATED TO ACCOMODATE THIS NEW MODEL.
		//Test - Swap McNamara's model to the sitting version!
		level.mcnamara SetModel( "t5_gfl_m1903_body_sitting" );

		//Setup the rear passengers of the limousine, anim_first_frame()ing them into place.
		limo = getEnt( "limo", "script_noteworthy" );
		limo.riders[ "hudson" ]     = level.hudson;
		limo.riders[ "mcnamara" ]   = level.mcnamara;
		limo.riders[ "general" ]    = simple_spawn_dummy( "spawner_general" );
		limo.riders[ "playerbody_firstperson" ] = level.playerbody_firstperson;

		limo anim_first_frame( limo.riders[ "general" ], "motorcade_rail_limo", "tag_origin" );
		limo anim_first_frame( level.heroes, 						 "motorcade_rail_limo", "tag_origin" );
		
		//limo thread show_tag_pos( "tag_origin" );
		array_thread( limo.riders, ::link_to, limo );

		//scrapper - turning on the domelights here, not sure why it's skipping it below. 
		limo maps\pentagon_fx::limo_interior_lights_on();

		//Just for ease-of-scripting later.
		level.limousine = limo;
		level.middleCar = GetEnt( "car1", "script_noteworthy" );

		//Setup each vehicle.
		for( i = 0; i < level.realMotorcade.size; i++ )
		{
			vehicle = level.realMotorcade[i];

			vehicle maps\_vehicle::getOnPath( GetVehicleNode( vehicle.target, "targetname" ) );

			switch( vehicle.vehicletype )
			{
				case "civ_pentagon_sedan_police":
					//Spawn a driver and passenger for this vehicle.
					vehicle.riders[ "driver" ] 	  = simple_spawn_dummy( "spawner_usmp_guard" );
					vehicle.riders[ "passenger" ] = simple_spawn_dummy( "spawner_usmp_guard" );
					
					//Have them loop an idle sit animation.
					vehicle.riders[ "driver" ] 	 linkTo( vehicle, "tag_driver", (0,0,0), (0,0,0) );
					vehicle.riders[ "passenger" ] linkTo( vehicle, "tag_passenger", (0,0,0), (0,0,0) );
					wait 0.05; //Let the characters move into place before animating them!
					vehicle.riders[ "driver" ] 	 thread anim_single( vehicle.riders[ "driver" ], "limousine_driver" );
					vehicle.riders[ "passenger" ] thread anim_single( vehicle.riders[ "passenger" ], "limousine_passenger" );

					//Turn on the lights.
					//vehicle maps\pentagon_fx::vehicle_lights_on( true );
					vehicle lights_police_car();
					break;
				
				case "civ_pentagon_limousine":
					//Spawn a driver and passenger for this vehicle.
					vehicle.riders[ "driver" ] 	  = simple_spawn_dummy( "spawner_cia" );
					vehicle.riders[ "passenger" ] = simple_spawn_dummy( "spawner_cia" );
					
					//Have them loop an idle sit animation.
					vehicle.riders[ "driver" ] 	 linkTo( vehicle, "tag_driver", (0,0,0), (0,0,0) );
					vehicle.riders[ "passenger" ] linkTo( vehicle, "tag_passenger", (0,0,0), (0,0,0) );
					wait 0.05; //Let the characters move into place before animating them!
					vehicle.riders[ "driver" ] 	 thread anim_single( vehicle.riders[ "driver" ], "limousine_driver" );
					vehicle.riders[ "passenger" ] thread anim_single( vehicle.riders[ "passenger" ], "limousine_passenger" );

					//Turn on the lights.
					//vehicle maps\pentagon_fx::vehicle_lights_on( true );
					vehicle lights_limo();
					break;
				
				case "civ_pentagon_motorcycle": //"motorcycle_ai":
					//Spawn a driver for this vehicle.
					vehicle.riders[ "driver" ] = simple_spawn_dummy( "spawner_usmp_moto" );
					vehicle.riders[ "driver" ].animname = "generic";
					
					//Have them loop an idle sit animation.
					vehicle.riders[ "driver" ] linkTo( vehicle, "tag_driver", (0,0,0), (0,0,0) );
					//wait 0.05; //Let the characters move into place before animating them!
					
					wait(RandomFloatRange(0.05, 0.1));
					
					vehicle.riders[ "driver" ] thread anim_loop( vehicle.riders[ "driver" ], "motorcycle_driver" );
					
					vehicle.animname = "motorcycle";
					vehicle thread anim_loop( vehicle, "bike_ride" );
										
					//Turn on the lights.
					//vehicle maps\pentagon_fx::vehicle_lights_on( true );
					vehicle maps\pentagon_fx::bike_sirens_on();
					vehicle lights_motorcycle();
					break;
			}
		}
	}
}


//******************************************************************************
//EVENTS_MAIN
//******************************************************************************
events_main() //self == level
{
	//events_main() is called before e#_jumpto() completes, so wait for it to tell
	//us which event we need to jump to.
	level waittill( "jumpto_complete", jumpto_string );

	//Notice the lack of break statements; the fall throughs are intentional!
	switch( toLower( jumpto_string ) )
	{
	case "helipad":	 	level e1_main();
	case "motorcade":	level e2_main();
	case "security": 	level e3_main();
	case "pool": 			level e4_main();
	case "elevator":	level e5_main();
	case "warroom": 	level e6_main();
	case "briefing": 	level e7_main(); break;
	default: 					AssertMsg( "events_main() - jumpto_string is invalid!" ); return;
	}

	//Mission accomplished! Move on to Flashpoint.
	nextMission();
}

//******************************************************************************
//EVENT 1: HELIPAD
//******************************************************************************
e1_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	//------------------
	//PREVIOUS STATES
	//------------------
	//None! There are no events prior to this.

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "helipad" );
}

e1_main()
{
	//----------------
	//EVENT SETUP
	//----------------
	level e1_setup();

	//----------------
	//EVENT FLOW
	//----------------
	//The helicopter and motorcade arrive simultaneously.	
	level thread e1_motorcade_arrival();
	level  			 e1_helicopter_landing();

	level e1_walk_to_limousine();
	level e1_enter_limousine_and_greet();
	level thread e1_motorcade_peels_out();

	//----------------
	//EVENT CLEANUP
	//----------------
	level thread e1_clear();
}

e1_setup()
{
	//Spawn Hudson and McNamara; the helicopter; and the fake motorcade.
	level setup_heroes();
	level setup_helicopter();
	level thread do_cinematic_blending( false );
	level setup_fake_motorcade();

	//Align the motorcade into place.
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_0" ], "helipad_arrive_0" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_1" ], "helipad_arrive_1" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_2" ], "helipad_arrive_2" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_3" ], "helipad_arrive_3" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_0" ].riders[ "driver" ], "helipad_arrive_0" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_1" ].riders[ "driver" ], "helipad_arrive_1" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_2" ].riders[ "driver" ], "helipad_arrive_2" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "motorcycle_3" ].riders[ "driver" ], "helipad_arrive_3" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "car_0" ], "helipad_arrive_cara" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "car_1" ], "helipad_arrive_carb" );
	level.anim_structs[ "helipad" ] anim_first_frame( level.fakeMotorcade[ "limousine" ], "helipad_arrive" );

	//OLD
	//DEBUG NOTES: 1)must LinkTo tag for guys' anims to rotate with heli, rather than just translate.
	//						 2)the origin and angle offsets MUST be present to teleport the characters to the tag!
	//				  	 3)anim_first_frame() is NOT necessary.

	//Align the helicopter into the sky. Wait a tick to let it complete its movement.
	level.anim_structs[ "helipad" ] anim_first_frame( level.helicopter, "helipad_landing" );
	wait 0.05;
	
	//ECKERT Change Music State
	level thread maps\_audio::switch_music_wait("HELI_LAND", 1.95);

	//Move the playerbody_firstperson into place. Wait a tick to let it complete its movement.
	level.helicopter anim_first_frame( level.playerbody_firstperson,	"helipad_landing", "tag_guy3" );
	wait 0.05;

	//Make the player face forward. It helps make the camera pop when the animations begin a little better.
	get_players()[0] player_face_forward();

	//Link the occupants to the helicopter so they will travel with it.
	level.hudson           					 LinkTo( level.helicopter, "tag_guy3", (0,0,0), (0,0,0) );
	level.helicopter.riders[ "cia" ] LinkTo( level.helicopter, "tag_guy3", (0,0,0), (0,0,0) );
	level.playerbody_firstperson	     LinkTo( level.helicopter, "tag_guy3" );

	//Keep the helicopter and its occupants frozen in the sky until the introscreen begins to fade away.
	flag_wait( "starting final intro screen fadeout" );
	playsoundatposition( "evt_helo_land_front" , (0,0,0));



	//Dvars cannot be set on first frame? It may be why we need to move this here...
	//Set the DOF while we are in the chopper interior.
	//level maps\pentagon_fx::dof_chopper_setting( 0.0 );
	
	level maps\pentagon_fx::set_helicopter_visuals( 0.05 );

	//HACK - prolong the whitefade to hide the camera pop between anim_first_frame() to anim_single_aligned().
	level hud_utility_show( "white", 0.0 );

	//Spawn vehicles in parking lot and have them drive.
	level.parkinglotVehicles = maps\_vehicle::scripted_spawn( 0 ); //0: parking lot and west highway cars, 1: real motorcade
	array_thread( level.parkinglotVehicles, ::vehicle_traffic_think );

	//Spawn dummies in parking lot.
	level.parkinglotDummies = simple_spawn_dummy( "spawner_helipad_parkinglot" );

	//The game is automatically autosaved at the start of the level.
}

e1_helicopter_landing()
{
	//Note: this plays simultaneously with e1_motorcade_arrival().

	//Play the animations!
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.helicopter, 								 "helipad_landing" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.helicopter.riders[ "usmp" ], "helipad_landing_guyc" );
	level.helicopter thread anim_single_aligned( level.hudson, 										 "helipad_landing", 		 "tag_guy3" );
	level.helicopter thread anim_single_aligned( level.helicopter.riders[ "cia" ], "helipad_landing_guya", "tag_guy3" );
	wait(0.4);
	level.helicopter thread anim_single_aligned( level.playerbody_firstperson, 		 "helipad_landing", 		 "tag_guy3" );
	
	light_fx_ent = spawn( "script_model", (0,0,0) );
	light_fx_ent setModel( "tag_origin" );
	
	light_fx_ent LinkTo( level.helicopter, "tag_light_cargo02", (0,0,0), (0,45,0));
	
	PlayFXOnTag(level._effect[ "helicopter_light" ], light_fx_ent, "tag_origin");
	
	//Play the Helo Approach sound
	level	thread sound_dummy("evt_helo_approach_front");



	//Make the player face forward according to the bone they are linked to.
	get_players()[0] thread player_face_forward( 1.0 );
	level thread narrator_player_dialog_helipad();
	
	level thread do_glasses_movie();

	//Wait until the helipad landing anims are complete.
	level.helicopter waittill( "helipad_landing" );

	//Unlink the riders from the helicopter, otherwise they will not play their tarmac animations correctly.
	level.hudson Unlink();
	level.playerbody_firstperson Unlink();
	level.helicopter.riders["cia"] Unlink();
	
	level waittill( "glasses_movie_done" );

	level thread do_cinematic_blending( true );

	//TODO: USE DELAYTHREAD
	//level maps\pentagon_fx::dof_default_setting( 2.0 );
	level maps\pentagon_fx::set_tarmac_visuals( 2.0 );
	//SetSavedDvar( "r_enableFlashlight","0" ); 
	
}

e1_hudson_flashback()
{
	//Flash of Rebirth Island.
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "temp_glasses", false, true );

	hud_utility_hide( "white", level.FADE_TIME );
}

e1_motorcade_arrival()
{
	//Note: this plays simultaneously with e1_helipad_landing(), just delayed nearly to the end.
	wait 10.0;

	//Play the animations!
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_2" ], "helipad_arrive_2" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_3" ], "helipad_arrive_3" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_2" ].riders[ "driver" ] , "helipad_arrive_2" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_3" ].riders[ "driver" ] , "helipad_arrive_3" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "car_0" ], "helipad_arrive_cara" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "car_1" ], "helipad_arrive_carb" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "limousine" ], "helipad_arrive" );

	//TEMP - Delay the last two motorcycles until the player can see them arrive.
	delay = 10.0;
	level.anim_structs[ "helipad" ] delayThread( delay, ::anim_single_aligned, level.fakeMotorcade[ "motorcycle_0" ], "helipad_arrive_0" );
	level.anim_structs[ "helipad" ] delayThread( delay, ::anim_single_aligned, level.fakeMotorcade[ "motorcycle_1" ], "helipad_arrive_1" );
	level.anim_structs[ "helipad" ] delayThread( delay, ::anim_single_aligned, level.fakeMotorcade[ "motorcycle_0" ].riders[ "driver" ], "helipad_arrive_0" );
	level.anim_structs[ "helipad" ] delayThread( delay, ::anim_single_aligned, level.fakeMotorcade[ "motorcycle_1" ].riders[ "driver" ], "helipad_arrive_1" );

	//Wait for the motorcade to arrive.
	level.anim_structs[ "helipad" ] waittill( "helipad_arrive" );
}

e1_walk_to_limousine()
{
	//This makes the playerbody_firstperson's previous animation not muddy the next.
	array_thread( array( level.hudson, level.playerbody_firstperson ), ::clear_anim );

	level thread update_sound_for_tarmac();

	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.helicopter.riders["usmp"], "helipad_tarmac_guyc" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.helicopter.riders["cia"], "helipad_tarmac_guya" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.helicopter, "helipad_tarmac" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.hudson,								 "helipad_rail_tarmac" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.playerbody_firstperson, "helipad_rail_tarmac" );

	level.playerbody_firstperson waittillmatch( "single anim", "limo_open" );

	//Have the limousine passenger get out and open the rear door for Hudson and Mason.
	level.fakeMotorcade[ "limousine" ].riders[ "passenger" ] Unlink();
	level.fakeMotorcade[ "limousine" ] thread anim_single_aligned( level.fakeMotorcade[ "limousine" ].riders[ "passenger" ], "helipad_rail_tarmac", "tag_origin" );
	level.fakeMotorcade[ "limousine" ] thread anim_single_aligned( level.fakeMotorcade[ "limousine" ], 					 						 "helipad_rail_tarmac", "tag_origin" );

	level.playerbody_firstperson waittillmatch( "single anim", "end" );
}

e1_enter_limousine_and_greet()
{
	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );

	playsoundatposition( "evt_num_num_03_d" , (0,0,0) );

	//Play the animations!
	level.fakeMotorcade[ "limousine" ] thread anim_single_aligned( level.heroes, 																				   "helipad_rail_limo", "tag_origin" );
	level.fakeMotorcade[ "limousine" ] thread anim_single_aligned( level.fakeMotorcade[ "limousine" ].riders[ "general" ], "helipad_rail_limo", "tag_origin" );

	//TODO: USE DELAYTHREAD OR NOTETRACKS FOR THESE.
	
	//level thread maps\pentagon_fx::dof_limo_setting();
	//get_players()[0] set_vision_set( "pentagon_limousine", 1.0 ); //<--SOMEHOW THIS IS CAUSING THE BLOOM AFTER THE ELEVATOR TO PERSIST?!
	level maps\pentagon_fx::set_limousine_visuals( 1.0 );
	ClientNotify ("in_limo");
	//level thread start_limo_movie();
	level thread e1_play_player_vo();
	
	
	level.fakeMotorcade[ "limousine" ] waittill( "helipad_rail_limo" );

	//Link the passenger back to the car.
	level.fakeMotorcade[ "limousine" ].riders[ "passenger" ] LinkTo( level.fakeMotorcade[ "limousine" ] );
}
e1_play_player_vo()
{
	wait(4);
	player = get_players()[0];
	player thread anim_single( player, "mcnamara");
	//wait(30);
	//player thread anim_single( player, "whendowekill");
}

e1_motorcade_peels_out()
{
	level thread dof_motorcade_start();
	
	//Align the camera prefab limo and bike onto the helipad, where the fakeMotorcade limo and bike are.
	//Wait a tick to allow the alignment to complete.
	level.prefabLimo align_to( level.fakeMotorcade[ "limousine" ] );
	level.prefabBike align_to( level.fakeMotorcade[ "motorcycle_0" ] );
	wait 0.05;
	
	//Get the camera entities needed for this sequence.
	cut0_pos_start = GetEnt( "origin_motorcycle_cut0_position_start", "targetname" );
	cut0_pos_end 	 = GetEnt( "origin_motorcycle_cut0_position_end", 	"targetname" );
	cut0_lookat		 = GetEnt( "origin_motorcycle_cut0_lookat",					"targetname" );
	
	cut1_pos_start = GetEnt( "origin_motorcycle_cut1_position_start", "targetname" );
	cut1_pos_end 	 = GetEnt( "origin_motorcycle_cut1_position_end", 	"targetname" );
	cut1_lookat		 = GetEnt( "origin_motorcycle_cut1_lookat",					"targetname" );
	
	//cut2_pos			 = GetEnt( "origin_limousine_cut0_position", 				"targetname" );
	//cut2_lookat		 = GetEnt( "origin_limousine_cut0_lookat",	 				"targetname" );
	cut2_pos_start    = GetEnt( "origin_limousine_cut0_position_start", "targetname" );
	cut2_pos_end	 	  = GetEnt( "origin_limousine_cut0_position_end",	  "targetname" );
	cut2_lookat_start = GetEnt( "origin_limousine_cut0_lookat_start",		"targetname" );
	cut2_lookat_end		= GetEnt( "origin_limousine_cut0_lookat_end",			"targetname" );

	//Play the animations (all seven vehicles pull away from the helipad).
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_0" ], 			  						"helipad_peelout_0" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_0" ].riders[ "driver" ], "helipad_peelout_0" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_1" ], 			  						"helipad_peelout_1" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_1" ].riders[ "driver" ], "helipad_peelout_1" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_2" ], 			  						"helipad_peelout_2" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_2" ].riders[ "driver" ], "helipad_peelout_2" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_3" ], 			  						"helipad_peelout_3" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "motorcycle_3" ].riders[ "driver" ], "helipad_peelout_3" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "limousine" ],							 					"helipad_peelout" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "car_0" ], "helipad_peelout_cara" );
	level.anim_structs[ "helipad" ] thread anim_single_aligned( level.fakeMotorcade[ "car_1" ], "helipad_peelout_carb" );

	//Play the accompanying sound effects.
	level thread sound_dummy("evt_drive_front");

	//------------------
	//CUT 0 (Panning at motorcycle driver)
	//------------------

	//Unlink the camera components so they can move.
	cut0_pos_start Unlink();

	//Setup the shot.
	moveTime = 1.0;
	cut0_pos_start MoveTo( cut0_pos_end.origin, moveTime );
	get_players()[0] SetClientdvar( "cg_fov", 45 );
	
	//Play the bike's exhaust effect now that the camera will be looking at it.
	PlayFXOnTag( level._effect[ "bike_exhaustpipe" ], level.fakeMotorcade[ "motorcycle_0" ], "tag_origin" );
	
	//Show the shot.
	get_players()[0] CameraSetPosition( cut0_pos_start );
	get_players()[0] CameraSetLookAt( cut0_lookat );
	get_players()[0] CameraActivate( true );
	playsoundatposition( "evt_limo_ride_front" , (0,0,0));
	wait moveTime;

	//------------------
	//CUT 1 (Panning at motorcycle engine)
	//------------------

	//Unlink the camera components so they can move.
	cut1_pos_start Unlink();

	//Setup the shot.
	moveTime = 1.05; //1.125; //0.5; //1.0; //seconds, as defined by the walkthrough video.
	cut1_pos_start MoveTo( cut1_pos_end.origin, moveTime );
	get_players()[0] SetClientDvar( "cg_fov", 45 );
	
	//Show the shot.
	get_players()[0] CameraSetPosition( cut1_pos_start );
	get_players()[0] CameraSetLookAt( cut1_lookat );
	get_players()[0] CameraActivate( true );
	wait moveTime;

	//Move the playerbody_firstperson to the highway.
	//NOTE: Must thread setup_real_motorcade() since it would interfere with camera timing (it does a lot of work!).
	get_players()[0] FreezeControls( true );
	level thread setup_real_motorcade();

	//------------------
	//CUT 2 (Stationary at limousine tire)
	//------------------
	
	//Unlink the camera components so they can move.
	cut2_pos_start Unlink();
	cut2_lookat_start Unlink();
	
	//Setup the shot.
	moveTime = 2.0;
	cut2_pos_start MoveTo( cut2_pos_end.origin, moveTime );
	cut2_lookat_start MoveTo( cut2_lookat_end.origin, moveTime );
	get_players()[0] SetClientDvar( "cg_fov", 65 );
		
	//Play exahustFX for the limo now that the camera will be looking at it.
	PlayFXOnTag( level._effect[ "limo_peelout_exhaust" ], level.fakeMotorcade[ "limousine" ], "tag_origin" );
	
	//Show the shot.
	get_players()[0] CameraSetPosition( cut2_pos_start );
	get_players()[0] CameraSetLookAt( cut2_lookat_start );
	get_players()[0] CameraActivate( true );
	wait moveTime;

	level notify( "start_real_motorcade" );
	wait( 0.10 ); //Looks better?
	level notify( "cleanup_fake_motorcade" );

	//------------------
	//ALL DONE
	//------------------

	//Turn off the helipad limousine cut camera.
	get_players()[0] CameraActivate( false );
	get_players()[0] FreezeControls( false );
	
	player = get_players()[0];
	player maps\_art::setdefaultdepthoffield();
}

e1_clear()
{
	level waittill( "cleanup_fake_motorcade" );
	
	//Delete the helicopter, its rotor effects, and each drone it carried.
	clear_helicopter();

	//Delete the fake limousine's interior light, otherwise it will leak.
	level.fakeMotorcade[ "limousine" ].interior_lights Delete();

	//Delete all fakeMotorcade vehicles, their riders, and any camera ents.
	//The heroes were NOT included in the limousine's .riders array for this reason!
	vehicleKeys = GetArrayKeys( level.fakeMotorcade );
	for( i = 0; i < vehicleKeys.size; i++ )
	{
		vehicle = level.fakeMotorcade[ vehicleKeys[i] ];

		if( isDefined( vehicle.riders ) && isArray( vehicle.riders ) )
		{
			occupantKeys = GetArrayKeys( vehicle.riders );
			for( j = 0; j < occupantKeys.size; j++ )
			{
				vehicle.riders[ occupantKeys[j] ] dummy_delete(); //drone_delete(); //delete();
			}
		}
		if( isDefined( vehicle.camera_pos ) && isArray( vehicle.camera_pos ) )
		{
			array_delete( vehicle.camera_pos );
		}
		if( isDefined( vehicle.camera_look ) && isArray( vehicle.camera_look ) )
		{
			array_delete( vehicle.camera_look );
		}

		vehicle delete();
	}
	level.fakeMotorcade = undefined;

	//Delete all parking lot vehicles.
	level.parkinglotVehicles = array_removeUndefined( level.parkinglotVehicles );
	array_delete( level.parkinglotVehicles );

	//Delete all parking lot drones.
	level.parkinglotDummies = array_removeUndefined( level.parkinglotDummies );
	array_thread( level.parkinglotDummies, ::dummy_delete );
}

//******************************************************************************
//EVENT 2: MOTORCADE
//******************************************************************************
e2_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	//------------------
	//PREVIOUS STATES
	//------------------
	//From E1 - Helipad:
	level setup_heroes();
	//level setup_exterior();
	level maps\pentagon_fx::set_limousine_visuals( 0.05 );
	level setup_real_motorcade();
	//level maps\pentagon_fx::dof_limo_setting( 0 );
	//get_players()[0] set_vision_set( "pentagon_limousine", 0.0 );
	ClientNotify("in_limo");

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "motorcade" );
	
	//HACK: Wait a tick to also send the "start_real_motorcade" notify.
	wait 0.05;
	level notify( "start_real_motorcade" );
}

e2_main()
{
	//----------------
	//EVENT SETUP
	//----------------
	level e2_setup();

	//----------------
	//EVENT FLOW
	//----------------
	level e2_ride_limousine();
	level e2_motorcade_camera_cuts();

	//----------------
	//EVENT CLEANUP
	//----------------
	level e2_clear();
}

e2_setup()
{
	//The motorcade and all riders, including Hudson and McNamara, have already
	//be created and seated in e1_motorcade_peels_out()->setup_real_motorcade()!

	level waittill( "start_real_motorcade" );

	//TEST!
	level.pulloverCount = 0;	 //Number of cars pulled over.
	level.pulloverWait  = 1.5; //Amount of time to wait per car pulled over.

	//East highway spawners, oncoming.
	level.northboundVehicles = maps\_vehicle::scripted_spawn( 2 );
	array_thread( level.northboundVehicles, ::vehicle_traffic_think );

	//East highway vehicles that pull over when the motorcade approaches.
	//level.southboundVehicles = maps\_vehicle::scripted_spawn( 3 );
	//array_thread( level.southboundVehicles, ::vehicle_traffic_think, level.middleCar, 2500 ); //2000 );
	level.southboundVehicles = [];

	//Set the southboundVehicles' speed low so that the motorcade will catch them.
	//40MPH is the motorcade speed.
	//24MPH is the traffic speed.
	//array_thread( level.southboundVehicles, ::set_speed_immediate, 25, 5, 5 );

	//For every motorcade vehicle...
	for( i = 0; i < level.realMotorcade.size; i++ )
	{
		//Delay sending the vehicle until the traffic has had a chance to get up to speed.
		//Otherwise the motorcade will ram into the stationary traffic!
		vehicle = level.realMotorcade[i];
		vehicle thread go_path( GetVehicleNode( vehicle.target, "targetname" ) );

		//Also, set their switchnode so they change lanes underneath the Pentagon sign.
		if( vehicle.script_noteworthy == "veh_motorcade_bike1" || vehicle.script_noteworthy == "veh_motorcade_bike3" )
		{
			//Only motorcycles 1 and 3 use the center lane path, so set switchnodes along the center path.
			vehicle set_switch_node
				( 
				GetVehicleNode( "vnode_motorcade_switchnode_main_center", "script_noteworthy" ), 
				GetVehicleNode( "vnode_motorcade_switchnode_detour_center", "script_noteworthy" ) 
				);
		}
		else
		{
			//All other motorcade vehicles use the left lane path, so set switchnodes alogn the left path.
			vehicle set_switch_node
				( 
				GetVehicleNode( "vnode_motorcade_switchnode_main_left", "script_noteworthy" ), 
				GetVehicleNode( "vnode_motorcade_switchnode_detour_left", "script_noteworthy" ) 
				);
		}
	}

	//Get the dossier in McNamara's hands.
	level.dossier = spawn_anim_model( "dossier", level.mcnamara.origin, level.mcnamara.angles );
	level.dossier LinkTo( level.mcnamara, "TAG_WEAPON_LEFT", (0,0,0), (0,0,0) );
}

e2_ride_limousine()
{
	//Play the animations!
	level.limousine thread anim_single_aligned( level.limousine.riders[ "general" ], "motorcade_rail_limo", "tag_origin" );
	level.limousine thread anim_single_aligned( level.heroes, 						 					 "motorcade_rail_limo", "tag_origin" );
	level.limousine thread anim_single( level.dossier, "motorcade_rail_limo" );

	//Make the player face forward according to the bone they are linked to.
	get_players()[0] thread player_face_forward( 1.0 );
	
	//bumps along the road
	level.bumps = true;
	level thread limo_ride_bumps();

	//McNamara's animation has a notetrack to let us know when to begin the camera cuts in e2_motorcade_camera_cuts().
	flag_wait("notetrack_start_camera_cuts");
	//level waittill( "notetrack_start_camera_cuts" );
}

e2_motorcade_camera_cuts()
{
	level thread dof_convoy();
	
	//turn off bumps on road
	level.bumps = false;
	
	//Set highway visuals, including default DOF so we can read the sign.
	level maps\pentagon_fx::set_highway_visuals( 0.05 );
	
	//Teleport the motorcade backwards to fake that there is more road than there really is.
	level move_motorcade_back( "vnode_motorcade_restart0_" );

	//TODO: Move timescale setting into pentagon_fx::set_highway_visuals()?
	//Slowmo.
	timescale = 0.50; //0.75;
	
	//------------------
	//SHOT 1 (Bird's Eye)
	//------------------
	
	//Align the prefab limo to the real limousine. Wait a tick to let the movement settle.
	level thread fade_to_black();
	level.prefabLimo align_to( level.limousine );
	
	wait 0.05;
	
	//Grab the camera entities needed to perform this shot.
	cut1_lookat 				= GetEnt( "origin_cut1_lookat",         "targetname" );
	cut1_position_start = GetEnt( "origin_cut1_position_start", "targetname" );
	cut1_position_end   = GetEnt( "origin_cut1_position_end",   "targetname" );

	//Link the lookat entity to the limousine so the camera will track it.
	cut1_lookat LinkTo( level.limousine );

	//Unlink the position entities so they do NOT follow the limo.
	//cut1_position_start Unlink();
	//cut1_position_end 	Unlink();

	//Move the cut1_position_start entity toward the cut1_position_end entity.
	moveTime = 3.5 * timescale; //seconds, according to the walkthrough video
	get_players()[0] setblur( 1, 0.05 );
	cut1_position_start MoveTo( cut1_position_end.origin, moveTime );
	SetTimeScale( timescale );
	//Show the shot.
	
	get_players()[0] CameraActivate( true );
	get_players()[0] CameraSetPosition( cut1_position_start );
	get_players()[0] CameraSetLookAt( cut1_lookat );
	wait moveTime;
	
	//Now that the first-person camera is deactivated, we can teleport the heroes
	//into security. This lets the heroes settle in security.
	get_players()[0] FreezeControls( true );
	level move_heroes_to_security();
	
	//------------------
	//SHOT 2 (Dolly Front)
	//------------------
	
	//Align the prefab limo to the real limousine. Wait a tick to let the movement settle.
	//level.prefabLimo align_to( level.limousine );
	level thread fade_to_black();
	level.prefabLimo align_to( level.limousine, undefined, true );
	
	wait 0.05;
	
	//Grab the camera entities needed to perform this shot.
	cut2_position_start = GetEnt( "origin_cut2_position_start", "targetname" );
	cut2_position_end   = GetEnt( "origin_cut2_position_end",   "targetname" );
	
	//Unlink the position entities so they do NOT follow the limo.
	cut2_position_start Unlink();
	cut2_position_end 	Unlink();
	
	//Move the cut2_position_start entity toward the cut2_position_end entity.
	moveTime = 3.0 * timescale; //seconds, according to the walkthrough video
	cut2_position_start MoveTo( cut2_position_end.origin, moveTime );

	//Zoom in.
	get_players()[0] SetClientDvar( "cg_fov", 65 / 2 );
	
	//Show the shot.
	get_players()[0] CameraSetPosition( cut2_position_start );
	get_players()[0] CameraSetLookAt( level.limousine );
	//get_players()[0] CameraActivate( true );
	wait moveTime;

	//------------------
	//SHOT 3 (Dolly Rear)
	//------------------
	
	//Teleport the motorcade backwards to fake that there is more road than there really is.
	level thread fade_to_black();
	level move_motorcade_back( "vnode_motorcade_restart1_" );
	
	//Align the prefab limo to the real limousine. Wait a tick to let the movement settle.
	level.prefabLimo align_to( level.limousine );
	
	wait 0.05;
	
	//Grab the camera entities needed to perform this shot.
	cut3_position_start = GetEnt( "origin_cut3_position_start", "targetname" );
	cut3_position_end   = GetEnt( "origin_cut3_position_end",   "targetname" );
	cut3_lookat_start 	= GetEnt( "origin_cut3_lookat_start",   "targetname" );
	cut3_lookat_end 		= GetEnt( "origin_cut3_lookat_end",     "targetname" );
	
	//Unlink the entities so they do NOT follow the limo.
	array_thread( array( cut3_position_start, cut3_position_end, cut3_lookat_start, cut3_lookat_end ), ::un_link );
	
	//Move the cut3_position_start entity toward the cut3_position_end entity.
	moveTime = 4.0 * timescale; //seconds, according to the walkthrough video
	cut3_position_start MoveTo( cut3_position_end.origin, moveTime );
	cut3_lookat_start MoveTo( cut3_lookat_end.origin, moveTime );

	//Zoom in.
	get_players()[0] SetClientDvar( "cg_fov", 65 / 2 );

	//Show the shot.
	get_players()[0] CameraSetPosition( cut3_position_start );
	get_players()[0] CameraSetLookAt( cut3_lookat_start );
	//get_players()[0] CameraActivate( true );
	wait moveTime;

	//Return to normal zoom.
	//get_players()[0] SetClientDvar( "cg_fov", level.DEFAULTFOV );

	//------------------
	//SHOT 4 (Zoom to Sign)
	//------------------
		level thread fade_to_black();
	//Grab the camera entities needed to perform this shot.
	cut4_position_start = GetEnt( "origin_cut4_position_start", "targetname" );
	cut4_position_end   = GetEnt( "origin_cut4_position_end",   "targetname" );
	
	//Don't forget to tell the client to pay attention...
	array_thread( array(cut4_position_start, cut4_position_end, cut3_lookat_end), ::stop_sounds );

	//Move the cut3_position_start entity toward the cut3_position_end entity.
	moveTime = 2.0 * timescale;
	cut4_position_start MoveTo( cut4_position_end.origin, moveTime );

	//Zoom in.
	get_players()[0] SetClientDvar( "cg_fov", 65 / 2 );

	//Show the shot. NOTE: we are reusing cut3_lookat_end, which is centered at the road sign.
	get_players()[0] CameraSetPosition( cut4_position_start );
	get_players()[0] CameraSetLookAt( cut3_lookat_end );
	//get_players()[0] CameraActivate( true );
	wait moveTime;
	
	//------------------
	//ALL DONE
	//------------------

	//Hide the screen, we need to cover the pop at security.
	level thread fade_to_black();

	//Restore default settings.
	get_players()[0] SetClientDvar( "cg_fov", 65 );
	SetTimeScale( 1.0 );
	
	//Deactivate the camera. The player has long been teleported to security.
	get_players()[0] CameraActivate( false );
	get_players()[0] FreezeControls( false );
	get_players()[0] setblur( 0, 0.05 );
	
	player = get_players()[0];
	player maps\_art::setdefaultdepthoffield();
}

e2_clear()
{
	//Remove the heroes from the limousine array, otherwise they will be deleted.
	level.limousine.riders[ "playerbody_firstperson" ] = undefined;
	level.limousine.riders[ "mcnamara" ]   = undefined;
	level.limousine.riders[ "hudson" ]		 = undefined;

	//Delete the limousine's interior light, otherwise it will leak.
	level.limousine.interior_lights Delete();

	//Delete all realMotorcade vehicles, their riders, and any camera ents.
	vehicleKeys = GetArrayKeys( level.realMotorcade );
	for( i = 0; i < vehicleKeys.size; i++ )
	{
		vehicle = level.realMotorcade[ vehicleKeys[i] ];

		if( isDefined( vehicle.riders ) && isArray( vehicle.riders ) )
		{
			occupantKeys = GetArrayKeys( vehicle.riders );
			for( j = 0; j < occupantKeys.size; j++ )
			{
				vehicle.riders[ occupantKeys[j] ] delete();
			}
		}
		if( isDefined( vehicle.camera_pos ) && isArray( vehicle.camera_pos ) )
		{
			array_delete( vehicle.camera_pos );
		}
		if( isDefined( vehicle.camera_look ) && isArray( vehicle.camera_look ) )
		{
			array_delete( vehicle.camera_look );
		}

		vehicle delete();
	}
	level.realMotorcade = undefined;

	//Delete the remaining cars on the east highway.
	level.northboundVehicles = array_removeundefined( level.northboundVehicles );
	array_delete( level.northboundVehicles );

	level.southboundVehicles = array_removeundefined( level.southboundVehicles );
	array_delete( level.southboundVehicles );

	//Detach the dossier, otherwise McNamara will carry it through the Pentagon.
	//level.mcnamara detach( "p_pent_dossier", "TAG_WEAPON_LEFT" );
	level.dossier Delete();
}

//******************************************************************************
//EVENT 3: SECURITY
//******************************************************************************
e3_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	level.sitting_mcnamara = false;

	//------------------
	//PREVIOUS STATES
	//------------------
	//From E1 - Helipad:
	level setup_heroes();

	//From E2 - Motorcade:
	level move_heroes_to_security();

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "security" );
}

e3_main()
{

	level.streamHintEnt = createStreamerHint((-34904, -9532, 150.3), 1.0 );

	//----------------
	//EVENT SETUP
	//----------------
	level e3_setup();

	//----------------
	//EVENT FLOW
	//----------------
	level e3_pass_through_security();
	level e3_exit_security();

	//----------------
	//EVENT CLEANUP
	//----------------
	level e3_clear();
}

e3_setup()
{
	level thread do_cinematic_blending( true );
	
	level.mcnamara SetModel( "t5_gfl_m1903_body" );
	
	//Turn off any blur that may be lingering from previous events.
	//level thread maps\pentagon_fx::dof_default_setting( 0.0 );
	level maps\pentagon_fx::set_security_visuals( 0.05 );

	//Security is the first event in the interior. Setup interior components.
	level setup_interior();

	//Setup the flashback trigger on the security sign.
	//GetEnt( "trig_security_sign_lookat", "targetname" ) thread look_trigger_think( ::e3_optional_flashback );

	//Setup the metal detector trigger.
	level thread e3_metal_detector_beeps();

	//Autosave here since this is the beginning of the upper interior sections.
	//autosave_by_name();
}

e3_pass_through_security()
{
	//Hide the camera pop that occurs while transitioning from anim_first_frame() into anim_single_aligned().
	level thread hud_utility_show( "black", 0 );

	//Have the clerk, detector guard, and door guards begin their animations. The animations are
	//synced to play right as the heroes begin their rail animations. Spawning the
	//dummies is sufficient since the spawners have KVPs that handle animating.
	level.manualSecurityDummies = simple_spawn_dummy( "spawner_security_important_rail_dummy" );

	//Open the first two doors (this plays super early along with the manualScriptDummies...)
	door_l = GetEnt( "smodel_security_door_left", "targetname" );
	door_r = GetEnt( "smodel_security_door_right", "targetname" );
	door_l init_anim_model( "door", true );
	door_r init_anim_model( "door", true );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( door_l, "security_rail_exit_first_door_left" );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( door_r, "security_rail_exit_first_door_right" );

	

	//McNamara addresses the clerk at the security counter, then the heroes walk through the metal detector.
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.heroes, "security_rail_vip" );


	
	//Make the player face forward according to the bone they are linked to. Wait a tick so the animation can start.
	wait 0.1;
	get_players()[0] thread player_face_forward( 1.0 );
	level thread hud_utility_hide( "black", 1 );
	//Wait for the player animation to end before moving onto the next set of animations.
	level.playerbody_firstperson waittillmatch( "single anim", "end" );
}


#using_animtree( "generic_human" );
e3_security_replace_body_with_full( guy )
{
	player = get_players()[0];
	
	player startCameraTween(1.0);

	level thread security_camera_cuts();
	level thread narrator_player_dialog_pentagon();
	
	level.fake_mason = simple_spawn_single("spawner_security_mason");
	level.fake_mason hide();
	level.fake_mason.animname = "generic";
	level.fake_mason animscripts\shared::placeWeaponOn( level.fake_mason.primaryweapon, "none");
	level.anim_structs[ "pool_rail" ] anim_single_aligned(level.fake_mason, "fullbody_rail");
	level.fake_mason delete();
	level.streamHintEnt delete();
}


e3_exit_security()
{
	//Time the opening of the second two doors.
	door_l2 = GetEnt( "smodel_pool_door_left", "targetname" );
	door_r2 = GetEnt( "smodel_pool_door_right", "targetname" );
	door_l2 init_anim_model( "door", true );
	door_r2 init_anim_model( "door", true );
	door_l2 get_anim_ent() delaythread( 5.5, ::door_slam_open, false );
	door_r2 get_anim_ent() delaythread( 5.5, ::door_slam_open, true );
	//TEMP - USE NOTETRACKS FOR SOUND.
	level delaythread( 5.5, ::ClientNotify, "open_pool_door" );

	//The two guards at the door had their animations started in e3_pass_through_security(),
	//ditto for the two doors they open for the heroes.

	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );

	//The heroes continue from the security detector into the typing pool.
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.heroes, "security_rail_exit" );
	level.anim_structs[ "pool_rail" ] waittill( "security_rail_exit" );
}

e3_metal_detector_beeps()
{
	//Wait for the party to pass through and set off the detector.
	trigger = trigger_wait( "trig_security_detector" );
	clientnotify ("play_alarm");
	trigger delete();
}

e3_optional_flashback()
{
	//Flash of Rebirth Island.
	hud_utility_show( "cinematic", 0 );
	//playsoundatposition ("evt_shocking_1", (0,0,0));
	Start3DCinematic( "jfk_tv01_256", false, true );
	//DEBUGTEXT( "ZAPRETNAYA ZONA" );
	wait 1.0;

	//Flash of Rebirth Island, no Reznov.
	//playsoundatposition ("evt_shocking_2", (0,0,0));
	Start3DCinematic( "jfk_tv01_256", false, true );
	//DEBUGTEXT( "REBIRTH ISLAND, NO REZNOV" );
	wait 1.0;

	hud_utility_hide( "white", level.FADE_TIME );
	Stop3DCinematic();
}

e3_clear()
{
	array_thread( level.manualSecurityDummies, ::dummy_delete );
}

//******************************************************************************
//EVENT 4: (TYPING) POOL
//******************************************************************************
e4_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	level.sitting_mcnamara = false;

	//------------------
	//PREVIOUS STATES
	//------------------
	//From E1 - Helipad:
	level setup_heroes();

	//From E3 - Security:
	level setup_interior();

	//Move the heroes into place.
	level.anim_structs[ "pool_rail" ] anim_first_frame( level.heroes, "pool_rail_marvel" );

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "pool" );
}

e4_main()
{
	//----------------
	//EVENT SETUP
	//----------------
	level e4_setup();

	//----------------
	//EVENT FLOW
	//----------------
	level e4_walk_through_pool();
	level e4_checkin_at_desk();
	level e4_walk_to_elevator();
	level e4_board_elevator();

	//----------------
	//EVENT CLEANUP
	//----------------
	level e4_clear();
}

e4_setup()
{
	//Setup the flashback trigger on the security sign.
	//GetEnt( "trig_pool_sign_lookat", "targetname" ) thread look_trigger_think( ::e4_optional_flashback );

	//Turn off the conference door lookat trigger until the player is close enough to see it if they trip it.
	trigger_off( "trigger_pool_conference_door", "script_noteworthy" );
}

e4_walk_through_pool()
{
	//This will make the secretary begin animating.
	//trigger_use( "trigger_pool_secretary_smoking", "script_noteworthy" );
	trigger_use( "trigger_pool_secretary_smoking", "targetname" );
	level thread smoking_girl_camera_cut();
	level thread narrator_pentagon_pool_dialog();
	
	//TEMP - The cigarette animation uses a tag_origin_animate to move it (>_<).
	//testCig = spawn_anim_model( "cigarette", (0,0,0), (0,0,0), true );
	
	//level.anim_structs[ "pool_rail" ] thread anim_single_aligned( testCig, "pool_rail_marvel" );

	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );

	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.hudson, 							 	"pool_rail_marvel" );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.mcnamara, 						 	"pool_rail_marvel" );
	level.anim_structs[ "pool_rail" ] 			 anim_single_aligned( level.playerbody_firstperson, 						"pool_rail_marvel" );
}


e4_checkin_at_desk()
{
	//Now that the player is close enough, turn the conference door trigger back on.
	//level delaythread( 2.0, ::DEBUGTEXT, "TRIGGER ON..." );
	level delaythread( 2.0, ::trigger_on, "trigger_pool_conference_door", "script_noteworthy" );

	//Cool! This will tell the pool desk clerk and guard to start animating.
	//trigger_use( "trigger_pool_desk_guards", "script_noteworthy" );
	trigger_use( "trigger_pool_desk_guards", "targetname" );

	//The guard offers a clipboard.
	clipboard = spawn_anim_model( "clipboard" );
	clipboard init_anim_model( "clipboard", true );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( clipboard,									 "pool_rail_checkin" );

	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );

	//The heroes arrive at the checkpoint desk. McNamara signs-in on a clipboard.
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.hudson, "pool_rail_checkin" );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.mcnamara, "pool_rail_checkin" );
	level.anim_structs[ "pool_rail" ] anim_single_aligned( level.playerbody_firstperson, "pool_rail_checkin" );
}

e4_walk_to_elevator()
{
	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );
	
	level thread flash_pentagon_numbers();
	playsoundatposition( "evt_num_num_05_d" , (0,0,0) );

	//The heroes walk toward the elevator. McNamara points out the portraits on the walls.
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.hudson, "pool_rail_hall" );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.mcnamara, "pool_rail_hall" );
	level.anim_structs[ "pool_rail" ] anim_single_aligned( level.playerbody_firstperson, "pool_rail_hall" );
}

e4_board_elevator()
{
	clientNotify( "open_door" );

	//This will make the elevator guards animate!
	trigger_use( "trigger_pool_elevator_guards", "targetname" );

	//This makes the previous animations not muddy the next.
	//array_thread( level.heroes, ::clear_anim );

	//McNamara gives the password to the elevator guards, then the heroes board.
	//level thread do_cinematic_blending( false );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.hudson, "pool_rail_elevator" );
	level.anim_structs[ "pool_rail" ] thread anim_single_aligned( level.mcnamara, "pool_rail_elevator" );
	level.anim_structs[ "pool_rail" ] anim_single_aligned( level.playerbody_firstperson, "pool_rail_elevator" );
}

/*e4_optional_flashback()
{
	//Flash of Russian freighter at end of Cuba.
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "jfk_tv01_256", false, true );
	DEBUGTEXT( "RUSSIAN FREIGHTER IN CUBA" );
	wait 1.0;

	hud_utility_hide( "white", level.FADE_TIME );
	Stop3DCinematic();
}*/

e4_clear()
{
	//Do nothing?
}

//******************************************************************************
//EVENT 5: ELEVATOR
//******************************************************************************
e5_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	level.sitting_mcnamara = false;

	//------------------
	//PREVIOUS STATES
	//------------------
	//From E1 - Helipad:
	level setup_heroes();

	//From E3 - Security:
	level setup_interior();

	//Since the elevator loop animations are not aligned to either rail struct, we
	//must move the heroes into place without the help of anim_first_frame().
	level teleport_heroes( "struct_elevator_teleport" );

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "elevator" );
}

e5_main()
{
	//----------------
	//EVENT SETUP
	//----------------
	level e5_setup();

	//----------------
	//EVENT FLOW
	//----------------
	level e5_elevator_descends();

	//----------------
	//EVENT CLEANUP
	//----------------
	level e5_clear();
}

e5_setup()
{
	//Autosave here since this is the beginning of the lower interior sections.
//	autosave_by_name();
}

e5_elevator_descends()
{
	//Link the heroes to a tag_origin entity, then link those entities to the elevator.
	//Finally, play their animations aligned to the tag_origin entity's tag_origin bone.
	//Since the heroes are performing animations aligned to the same bone they are linked
	//to, the link and alignment will not fight each other!

	//Give each hero a tag_origin entity to link to.	
	for( i = 0; i < level.heroes.size; i++ )
	{
		//Get a hero.
		hero = level.heroes[i];

		//Create a link ent for them.
		linkEnt = Spawn( "script_model", hero.origin );
		linkEnt SetModel( "tag_origin_animate" );
		linkEnt align_to( hero );
		hero.linkEnt = linkEnt;

		hero DisableClientLinkTo();

		//Link them to the link ent.
		hero LinkTo( hero.linkEnt, "origin_animate_jnt" );

		//Link the link ent to the elevator.
		linkEnt DisableClientLinkTo();
		hero.linkEnt LinkTo( level.elevator.cab );
	}

	//IMPORTANT: LET THE LINKS SETTLE IN BEFORE ATTEMPTING ANIMATIONS ON THEM TO AVOID FIGHTING!
	wait 0.05;

	level thread do_cinematic_blending( false );

	//Play the animations!
	level.hudson.linkEnt 								thread anim_single_aligned( level.hudson, 	 					   	"pool_rail_elevator_idle", "tag_origin" );
	level.mcnamara.linkEnt 							thread anim_single_aligned( level.mcnamara, 					   	"pool_rail_elevator_idle", "tag_origin" );
	level.playerbody_firstperson.linkEnt 						thread anim_single_aligned( level.playerbody_firstperson, 						"pool_rail_elevator_idle", "tag_origin" );

	//Begin fast-forwarding!
	level maps\pentagon_fx::set_elevator_fastforward_visuals( 0.05 );

	//Begin the elevator's descent.
	ClientNotify ("elevator_moving"); //Play the descending sound.
	floorStruct = GetStruct( "struct_warroom_elevator_align", "targetname" );
	level elevator_move( floorStruct );

	//End the fast-forward effects.
	level maps\pentagon_fx::set_warroom_visuals( 1.0 );
	ClientNotify ("elevator_stop");
	playsoundatposition( "evt_num_num_06_d" , (0,0,0) );
}

e5_clear()
{
	//Unlink the heroes from their personal linker ents.
	array_thread( level.heroes, ::un_link );

	//Delete the linkEnts.
	for( i = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i].linkEnt Delete();
	}
}

//******************************************************************************
//EVENT 6: WARROOM
//******************************************************************************
e6_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	level.sitting_mcnamara = false;

	//------------------
	//PREVIOUS STATES
	//------------------
	//From e1 - Helipad:
	level setup_heroes();

	//From e3 - Security:
	setup_interior();

	//From e5 - Elevator:
	level.elevator elevator_move( getStruct( "struct_warroom_elevator_align", "targetname" ), 0.05 );
	level maps\pentagon_fx::set_warroom_visuals( 0.05 );

	//Move the heroes into the warroom.
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.heroes, "warroom_rail_enter" );

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "warroom" );
}

e6_main()
{
	//----------------
	//EVENT SETUP
	//----------------	
	level e6_setup();

	//----------------
	//EVENT FLOW
	//----------------
	//These two play simultaneously to get the heroes out of the elevator faster.
	level thread e6_open_elevator_doors();
	level 			 e6_enter_warroom();
	
	level e6_walk_down_stairs();
	level e6_exit_warroom();

	//----------------
	//EVENT CLEANUP
	//----------------
	level e6_clear();
}

e6_setup()
{
	//This occurs in e5_elevator_descends() now.
	//Set vision.
	//level maps\pentagon_fx::set_warroom_visuals( 1.0 );
}

e6_open_elevator_doors()
{
	//Swap the interior floor indicator model with one without "down" and "B" lit, only "SB".
	indicator = GetEnt( "smodel_pool_indicator_small", "script_noteworthy" );
	indicator SetModel( "p_pent_elevator_indicator_lit02" );

	ClientNotify("open_door_2");		//Second door-opening sound.
	ClientNotify("elevator_open");	//Plays warroom ambient sound.
	level elevator_open_doors();
	
	level thread flash_warroom_numbers();
}

e6_enter_warroom()
{
	//Light the fuse on the warroom split-screen tech.
	level thread start_warroom_split_screen();
	
	//Wait a bit before starting the heroes, otherwise they will clip through the elevator doors.
	wait 1.0;
	
	level thread do_cinematic_blending( true );
	
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.hudson, "warroom_rail_enter" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.mcnamara, "warroom_rail_enter" );
	level.anim_structs[ "warroom_rail" ] anim_single_aligned( level.playerbody_firstperson, "warroom_rail_enter" );
}

e6_walk_down_stairs()
{	
	//Make the five guys ("alarm" and "moonwalk" animations) begin animating now for visual interest.
	trigger_use( "trigger_warroom_alarm_guys", "targetname" );

	array_thread( level.heroes, ::clear_anim );

	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.hudson, "warroom_rail_midlanding" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.mcnamara, "warroom_rail_midlanding" );
	level.anim_structs[ "warroom_rail" ] anim_single_aligned( level.playerbody_firstperson, "warroom_rail_midlanding" );
}

e6_exit_warroom()
{
	//Call this early to hide the spawning of Kennedy, the two chairs, and the dossier.
	level setup_briefing_room();
	playsoundatposition( "evt_num_num_07_d" , (0,0,0) );

	//Make the guards at the antechamber doors begin animating.
	trigger_use( "trigger_warroom_guards", "targetname" );

	//Also, open the doors they are guarding.
	doorl = GetEnt( "smodel_briefing_door_left", "targetname" );
	doorr = GetEnt( "smodel_briefing_door_right", "targetname" );
	doorl init_anim_model( "door", true );
	doorr init_anim_model( "door", true );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( doorl.anim_link, "warroom_open_door_left" );
	level.anim_structs[ "warroom_rail" ] thread	anim_single_aligned( doorr.anim_link, "warroom_open_door_right" );
	
	level thread rare_door_audio();

	array_thread( level.heroes, ::clear_anim );

	//The heroes turn and head for the antechamber door.

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_1", false, true);
	playsoundatposition ("evt_shocking_1", (0,0,0));
	

	level thread stop_cinematic();
	
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.hudson, "warroom_rail_exit" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.playerbody_firstperson, "warroom_rail_exit" );
	level.anim_structs[ "warroom_rail" ] anim_single_aligned( level.mcnamara, "warroom_rail_exit" );
	
	
	
}

rare_door_audio()
{
	wait 7.5;
	playsoundatposition ("evt_door_open_3", (0,0,0));
}
stop_cinematic()
{
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();
}

e6_clear()
{
	//Nothing?
}

//******************************************************************************
//EVENT 7: BRIEFING
//******************************************************************************
e7_jumpto()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	level.sitting_mcnamara = false;

	//------------------
	//PREVIOUS STATES
	//------------------
	//From e1 - Helipad:
	level setup_heroes();

	//From e3 - Security:
	level setup_interior();

	//From e6 - Briefing:
	level setup_briefing_room();

	//Move the heroes into place.
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.heroes, "briefing_rail_entrance" );

	//------------------
	//BEGIN EVENT
	//------------------
	level notify( "jumpto_complete", "briefing" );
}

e7_main()
{
	//----------------
	//EVENT SETUP
	//----------------
	level e7_setup();

	//----------------
	//EVENT FLOW
	//----------------
	level e7_enter_briefing();
	level e7_discuss_the_mission();
	level e7_bloom_effect();

	//----------------
	//EVENT CLEANUP
	//----------------
	//None? End of level.
}

e7_setup()
{
	//Kennedy, the chairs, and the dossier were already spawned during event 6.

	//Autosave here since this is the beginning of the final speech.
//	autosave_by_name();
	
	//set up the monitors for the timescale sequence

	level.static_monitors = [];
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_1","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_2","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_3","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_4","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_5","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_6","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_7","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_8","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_9","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_10","targetname");
	level.static_monitors[level.static_monitors.size] = getent("jfk_monitor_11","targetname");
	
	
	level.bink_monitors = [];
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_1_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_2_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_3_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_4_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_5_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_6_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_7_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_8_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_9_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_10_bink","targetname");
	level.bink_monitors[level.bink_monitors.size] = getent("jfk_monitor_11_bink","targetname");	
	
	//hide the bink monitors until the timescale sequence
	for(i=0;i<level.bink_monitors.size;i++)
	{
		level.bink_monitors[i] hide();
	}
	
}

e7_enter_briefing()
{
	//This causes the two generals to exit!
	trigger_use( "trigger_briefing_generals_leave", "targetname" );
	clientnotify ("close_war");
	playsoundatposition( "evt_num_num_08_d" , (0,0,0) );

	//Vision
	//get_players()[0] set_vision_set( "pentagon_kennedy", 1.0 );
	level maps\pentagon_fx::set_briefing_visuals( 1.0 );

	array_thread( level.heroes, ::clear_anim );
	level thread e7_play_player_vo();
	//The chairs and dossier animations start their animations at the entrance point.
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.chairMason, 	 "briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.chairKennedy, "briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.dossier, 		 "briefing_rail_entrance" );

	//The heroes enter the briefing room as two generals leave.
	level.anim_structs[ "warroom_rail" ] thread	anim_single_aligned( level.kennedy,	"briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.hudson,  "briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.mcnamara,  "briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] anim_single_aligned( level.playerbody_firstperson,  "briefing_rail_entrance" );
	clientnotify ("close_conference");
	clientnotify ("meeting_start");
}

e7_discuss_the_mission()
{
	//Hudson leaves. McNamara seats Mason. Kennedy enters, sits, and chats with Mason.
	//level.anim_structs[ "warroom_rail" ] thread	anim_single_aligned( level.heroes,  "briefing_rail_mission" );
	level.anim_structs[ "warroom_rail" ] thread	anim_single_aligned( level.kennedy, "briefing_rail_mission" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.hudson,  "briefing_rail_mission" );
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.mcnamara,  "briefing_rail_mission" );
	
	level thread player_briefing();
	
	//Wait until Kennedy starts to lean back, then start the bloom effect.
	//His animation has a notetrack that sets this flag.
	flag_wait( "notetrack_start_bloom" );
	
	//player = get_players()[0];
	//player anim_single( player, "Iam");
}


player_briefing()
{
	// prevents player's view from popping to center of room
	level.anim_structs[ "warroom_rail" ] anim_single_aligned( level.playerbody_firstperson,  "briefing_rail_mission" );
	level.anim_structs[ "warroom_rail" ] thread anim_loop_aligned( level.playerbody_firstperson,  "briefing_rail_mission_loop" );
}


e7_bloom_effect()
{
	//Start the bloom effects.
	//get_players()[0] set_vision_set( "pentagon_kennedy_bloom", 1.0 );
	playsoundatposition("evt_end_bloom", (0,0,0));
	level maps\pentagon_fx::set_briefing_bloom_visuals( 1.0 );
	
	level thread maps\pentagon_fx::whiteout( 4 );
	wait(3);
}

e7_play_player_vo()
{
	wait(21);
	player = get_players()[0];
	//IPrintLnBold("mr president");
	player thread anim_single( player, "Mr_president");

	wait(1);
	playsoundatposition( "evt_num_num_09_d" , (0,0,0) );

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();
	wait(1);
	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();
	
	//IPrintLnBold( "last shock" );//kevin


	//wait(12);

//	//temp movie placeholder
//	hud_utility_show( "cinematic", 0 );
//	Start3DCinematic( "jfk_tv01_256", false, true );
//	wait(1);
//	hud_utility_hide();
//	Stop3DCinematic(); 
//
//	level clientnotify("start_bulging");
}

//******************************************************************************
//FREEROAM
//******************************************************************************
dev_freeroam_exterior()
{	
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	//Unlink the player from the playerbody_firstperson. Otherwise they will be anchored.
	get_players()[0] Unlink();

	//NOTE: This function is intended to let devs float around the level without
	//having to worry about the scripts; this waittill will never be notified!
	level waittill( "stop_freeroam" );
}

dev_freeroam_interior()
{
	//Ensure that the player(s) exist before setting the events in motion!
	flag_wait( "player_setup_complete" );

	//Unlink the player from the playerbody_firstperson. Otherwise they will be anchored.
	get_players()[0] Unlink();

	//Teleport the player to security.
	teleport_heroes( "struct_security_teleport" );

	//NOTE: This function is intended to let devs float around the level without
	//having to worry about the scripts; this waittill will never be notified!
	level waittill( "stop_freeroam" );
}

narrator_player_dialog_helipad()
{
	player = get_players()[0];

	wait(2);
	player thread anim_single( player, "taketopentagon");
	wait(2);
	player thread anim_single( player, "hudson_handler");
	wait(9);
	player thread anim_single( player, "whypentagon");
	wait(1);
	player thread anim_single( player, "noclearance");


}

narrator_player_dialog_pentagon()
{
	player = get_players()[0];


	wait(2.2);
	player anim_single( player, "everyone_watching");
	wait(1.2);
	player anim_single( player, "cant_trust");
	wait(4);
	player anim_single( player, "evenyourself");
	wait(3);
	player anim_single( player, "whywehere");

}
narrator_pentagon_pool_dialog()
{
	wait(7.5);
	player = get_players()[0];
	player anim_single( player, "watchingyoualltime");
	//wait(1);
	player anim_single( player, "notposssible");
	player anim_single( player, "wasinpentagon");

	wait(16);
	player anim_single( player, "numberinhead");
	wait(12.0);
	player anim_single( player, "eatingme");
	wait(5.5);	//wait longer due to timescale
	player anim_single( player, "whatmason");
	wait(10);
	player anim_single( player, "indream");
	wait(0.5);
	player anim_single( player, "closetoobjective");
	
	flag_set("warroom");
	
	wait(0.5);
	player anim_single( player, "wasworking");
}

