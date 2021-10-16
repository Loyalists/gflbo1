
/*===========================================================================
EVENTS:

	 aftermath
	 boat_drop - uses "cleanup_boat_drop"
	 initial_island_engagement 
	 missile_launcher_engagement - uses "cleanup_missile_launcher_event"
	 helicopters_fly_in_and_destroy_bridge - uses "cleanup_helicopter_bridge_area"
	 american_forces_move_into_NVA_base
	 AA_gun_encounter - uses "cleanup_helicopter_bridge_area"
	 first_turn_sampans_2_arrive - uses "cleanup_AA_guns_area" 
	 first_sampan_encounter
	 boss_boat_encounter - uses "cleanup_sampan_area"
	 boat_drag
	 river_pacing
===========================================================================*/

#include animscripts\combat_utility;
#include animscripts\anims;
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\flamer_util;
#include maps\_music;

/*==========================================================================
FUNCTION: main
SELF: level (not used)
PURPOSE: set up beat progression and skiptos in an easily modifiable way

ADDITIONS NEEDED:
==========================================================================*/
main( beat_name )
{
	level thread setup_event_wide_functions();
	
	// array of function pointers that should be run in sequential order
	beats = [];
	beats[ "aftermath" ] 								= ::aftermath;
//	beats[ "boat_drop" ] 								= ::boat_drop; 
	beats[ "initial_island_engagement" ] 				= ::initial_island_engagement;
	beats[ "missile_launcher_engagement"] 				= ::missile_launcher_engagement;
	beats[ "helicopters_fly_in_and_destroy_bridge" ] 	= ::helicopters_fly_in_and_destroy_bridge;
//	beats[ "american_forces_move_into_NVA_base" ] 		= ::american_forces_move_into_NVA_base;
	beats[ "AA_gun_encounter" ] 						= ::AA_gun_encounter;
	beats[ "first_turn_sampans_2_arrive" ]	 			= ::first_turn_sampans_2_arrive;
	beats[ "first_sampan_encounter" ] 					= ::first_sampan_encounter;
	beats[ "boss_boat_encounter" ] 						= ::boss_boat_encounter;
	//beats[ "boat_drag" ] 								= ::boat_drag;
//	beats[ "flashback" ]								= ::flashback;
	beats[ "river_pacing" ] 							= ::river_pacing;

	keys = maps\river_util::get_array_keys_in_order( beats );

	beat_num = 0;

	if( IsDefined( beat_name ) )
	{
		for( i = 0; i < beats.size; i++ )
		{
			if( keys[ i ] == beat_name )
			{
				beat_num = i;
				break;
			}
		}
	}
	
	for( i = beat_num; i < beats.size; i++ )
	{
		current_beat = [[ beats[ keys[ i ] ] ]]();
		
		if( i == 1 )  // causes a performance hitch when saving between 'aftermath' and 'initial_island_engagement'
		{
			continue;
		}
		
		autosave_by_name( "river_autosave" );
	}
	
}

/*==========================================================================
FUNCTION: setup_event_wide_functions
SELF: level (not used)
PURPOSE: this is where all the event wide stuff gets set up that's specific
         only to this event

ADDITIONS NEEDED:
==========================================================================*/
setup_event_wide_functions()
{
	setup_spawners();
	maps\river_util::setup_destructible_buildings( "boat_drive_done" );
	setup_all_guard_towers();	
	level thread maps\river_util::monitor_spawners("boat_drive_goal_volumes");
	
	flag_wait( "player_inside_boat" );
	
	level.boat thread maps\river_util::monitor_boat_damage_state();
	
	// make it easier to have friendly drones highlighted in green
	level.old_friendly_fire_dist = GetDvar( "g_friendlyfireDist" );
	SetSavedDvar( "g_friendlyfireDist", "5000" );
	//level.old_friendly_name_dist = GetDvar( "g_friendlynameDist" );
	//SetSavedDvar( "g_friendlynameDist", "5000" );
}

setup_spawners()
{	
	shore_guys = GetEntArray( "boat_drive_spawners", "script_noteworthy" );
	AssertEx( ( shore_guys.size > 0 ), "boat_drive_spawners are missing!" );
	for( i=0; i<shore_guys.size; i++ )
	{
		shore_guys[i] add_spawn_function( ::generic_shore_guys_function );
	}
	
	tower1_guys = GetEntArray( "tower1_guys", "targetname" );  // boat_drive_base_tower_guys
	AssertEx( ( tower1_guys.size ), "tower_guys are missing" );
	for( i = 0; i < tower1_guys.size; i++ )
	{
		tower1_guys[ i ] add_spawn_function(  maps\river_util::RPG_fire_prediction, 6500, 0.5, 1.1 );  // 6500, 1.25, 3.50 
		tower1_guys[ i ] add_spawn_function( ::debug_tower_guys );
	}
	
	base_tower_guys = GetEntArray( "boat_drive_base_tower_guys", "script_noteworthy" );  // boat_drive_base_base_tower_guys
	AssertEx( ( base_tower_guys.size ), "base_tower_guys are missing" );
	for( i = 0; i < base_tower_guys.size; i++ )
	{
		base_tower_guys[ i ] add_spawn_function(  maps\river_util::RPG_fire_prediction, 7000, 0.5, 1.1, true );  // 6500, 1.25, 3.50 
		base_tower_guys[ i ] add_spawn_function( ::debug_tower_guys );
	}	


	
	tower5_guys = GetEntArray( "tower5_guys", "targetname" );  // boat_drive_base_second_AA_gun_tower_guys
	AssertEx( ( tower5_guys.size ), "tower5_guys are missing" );
	for( i = 0; i < tower5_guys.size; i++ )
	{
		tower5_guys[ i ] add_spawn_function(  maps\river_util::RPG_fire_prediction, 7000, 0.5, 1.1, true );  // 6500, 1.25, 3.50 
		tower5_guys[ i ] add_spawn_function( ::debug_tower_guys );
	}		
	
	//left_initial_island_guys
	left_island_guys = GetEntArray( "left_initial_island_guys", "script_noteworthy" );
	AssertEx( ( left_island_guys.size > 0 ), "left_initial_island_guys are missing!" );
	for( i=0; i<left_island_guys.size; i++ )
	{
		left_island_guys[i] add_spawn_function( ::island_guys_function );
	}
	
	right_island_guys = GetEntArray( "right_initial_island_guys", "script_noteworthy" );
	AssertEx( ( right_island_guys.size > 0 ), "left_initial_island_guys are missing!" );
	for( i=0; i<right_island_guys.size; i++ )
	{
		right_island_guys[i] add_spawn_function( ::island_guys_function, false );
	}
	 
	tower2_guys = GetEntArray( "tower2_guys", "targetname" );
	for( i = 0; i < tower2_guys.size; i++ )
	{
		tower2_guys[ i ] add_spawn_function( maps\river_util::fallback_behavior, "post_bridge_rpg_fallback_trigger", "base_rpg_fallback_node" );
		tower2_guys[ i ] add_spawn_function(  maps\river_util::RPG_fire_prediction, 7000, 2, 3, true );
		tower2_guys[ i ] add_spawn_function( ::print_what_killed_me );
	}
	
	tower3_guys = GetEntArray( "tower3_guys", "targetname" );
	for( i = 0; i < tower3_guys.size; i++ )
	{
		tower3_guys[ i ] add_spawn_function( maps\river_util::RPG_fire_prediction, 3400, 1, 1.5, true );
		tower3_guys[ i ] add_spawn_function( ::debug_tower_guys );
	}
	
	//used to be in AA_gun_encounter
	add_spawn_function_veh( "boat_drive_left_path_quad50", ::high_value_target );
	add_spawn_function_veh("quad50_2", ::high_value_target );  // same with this one
	add_spawn_function_veh("quad50_3", ::high_value_target );
	
	add_spawn_function_veh( "boat_drive_left_path_quad50", ::flag_set_on_death, "quad50_1_dead" );
	add_spawn_function_veh( "quad50_2", ::flag_set_on_death, "quad50_2_dead" );
	add_spawn_function_veh( "quad50_3", ::flag_set_on_death, "quad50_3_dead" );
	
	add_spawn_function_veh("boat_drive_left_path_quad50", maps\river_util::vehicle_setup, undefined, true );
//	add_spawn_function_veh("boat_drive_left_path_quad50", maps\river_util::quad50_fires_guns, boat, "open_fire" );
//	add_spawn_function_veh("boat_drive_left_path_quad50", ::vehicle_stop_on_notify, "stop_moving" );
	add_spawn_function_veh("quad50_3", maps\river_util::vehicle_setup, undefined, false, 5000 );  
	add_spawn_function_veh("quad50_3", maps\river_util::quad50_fires_guns, level.boat, "wait_here", true, "quad50_3_moves" );  // "quad50_3_moves" notify sent from script_notify on trigger in radiant
	add_spawn_function_veh("quad50_2", maps\river_util::vehicle_setup, undefined, true, 5000 );  
	add_spawn_function_veh("quad50_2", maps\river_util::quad50_fires_guns, level.boat, "wait_here", true, "quad50_2_moves" );  // same with this one
	add_spawn_function_veh( "helicopter_AA_gun_1", ::Delete_at_end_of_spline );
	add_spawn_function_veh( "helicopter_AA_gun_2", ::Delete_at_end_of_spline );
	
	add_spawn_function_veh( "helicopter_AA_gun_1", maps\river_util::huey_cone_light );
	add_spawn_function_veh( "helicopter_AA_gun_2", maps\river_util::huey_cone_light );		
	
	// used to be in first_sampan_encounter
	add_spawn_function_veh("s_turn_bend_2_sampan_1", maps\river_util::vehicle_setup );
	add_spawn_function_veh( "s_turn_bend_2_sampan_1", ::high_value_target );  // counts towards achievement
//	add_spawn_function_veh( "s_turn_bend_2_sampan_1", maps\river_fx::sampan_spotlight );
	add_spawn_function_veh("s_turn_bend_2_sampan_2", maps\river_util::vehicle_setup );
	add_spawn_function_veh( "s_turn_bend_2_sampan_2", ::high_value_target );  // counts towards achievement
//	add_spawn_function_veh( "s_turn_bend_2_sampan_2", maps\river_fx::sampan_spotlight );	
	

	add_spawn_function_veh( "truck_with_gun_north", maps\river::notification_on_death, "single50_dead", level._effect[ "quad50_temp_death_effect" ] );
	add_spawn_function_veh( "truck_with_gun_north", maps\river_util::quad50_fires_guns, level.boat );
	add_spawn_function_veh( "truck_with_gun_north", maps\river_util::vehicle_setup, undefined, false, 6000 );
	add_spawn_function_veh( "truck_with_gun_north", ::high_value_target );	
	
	// used to be in third_aa_gun_encounter
	heli_rocket_target1 = getstruct( "third_AA_gun_helicopter_2_5_start", "targetname" );
//	add_spawn_function_veh( "third_AA_gun_helicopter_1", ::vehicle_shootat_target );
//	add_spawn_function_veh( "third_AA_gun_helicopter_1", ::vehicle_windowdressing );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", ::vehicle_shootat_target, 1.5, 0.5 );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_util::helicopter_fires_rockets_at_target, "fire_rockets", heli_rocket_target1, undefined, 2 );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", ::vehicle_windowdressing );
//	add_spawn_function_veh( "third_AA_gun_helicopter_1", maps\river_util::huey_cone_light );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_util::huey_cone_light );	
	//add_spawn_function_veh( "third_AA_gun_helicopter_2", ::helicopter_speed_scale, 2000 );	
	
	// used to be in initial_island_engagement
	add_spawn_function_veh( "initial_engagement_flyby_helicopter1", ::vehicle_windowdressing, true );
	add_spawn_function_veh( "initial_engagement_flyby_helicopter2", ::vehicle_windowdressing, true );
	add_spawn_function_veh( "initial_engagement_flyby_helicopter1", ::vehicle_shootat_target, undefined, 1.5 );
	add_spawn_function_veh( "initial_engagement_flyby_helicopter2", ::vehicle_shootat_target, undefined, 2 );	
	add_spawn_function_veh( "initial_engagement_flyby_helicopter3", ::vehicle_windowdressing, true );
	add_spawn_function_veh( "initial_engagement_flyby_helicopter3", ::vehicle_shootat_target );	
	// add spotlights
	add_spawn_function_veh( "initial_engagement_flyby_helicopter1", maps\river_util::huey_cone_light );	
	add_spawn_function_veh( "initial_engagement_flyby_helicopter2", maps\river_util::huey_cone_light );
	add_spawn_function_veh( "initial_engagement_flyby_helicopter3", maps\river_util::huey_cone_light );		

	// used to be in first_turn_sampans_2_arrive
	add_spawn_function_veh("s_curve_flatbed_truck", maps\river_util::vehicle_setup);
		
	for(i=1; i<3; i++)  // 2 sampans
	{
		add_spawn_function_veh("first_turn_2_sampan_" + i, maps\river_util::vehicle_setup);
		add_spawn_function_veh( "first_turn_2_sampan_" + i, ::high_value_target ); // counts towards achievement
		add_spawn_function_veh( "first_turn_2_sampan_" + i, maps\river_fx::sampan_spotlight );
	}
	
	// used to be in missile_launcher_engagement
	add_spawn_function_veh( "missile_launcher_helicopter_1", ::vehicle_windowdressing );
	add_spawn_function_veh( "missile_launcher_helicopter_1", ::vehicle_shootat_target );	
	//add_spawn_function_veh( "missile_launcher_helicopter_1", Maps\river_util::helicopter_fires_rockets_at_target, "fire_missiles", helicopter_1_RPG_struct );
	add_spawn_function_veh( "missile_launcher_helicopter_1", Maps\river_util::huey_cone_light );
					
	// used to be in helicopters_fly_in_and_destroy_bridge
	add_spawn_function_veh( "boat_drive_helicopter_1", ::vehicle_shootat_target );
	add_spawn_function_veh( "boat_drive_helicopter_2", ::vehicle_shootat_target );
	add_spawn_function_veh( "boat_drive_helicopter_1", ::vehicle_windowdressing );
	add_spawn_function_veh( "boat_drive_helicopter_2", ::vehicle_windowdressing );
	add_spawn_function_veh( "boat_drive_helicopter_1", maps\river_util::huey_cone_light );
	add_spawn_function_veh( "boat_drive_helicopter_2", maps\river_util::huey_cone_light );					
}


//*****************************************************************************
//*****************************************************************************

print_what_killed_me()
{
	/#
	self waittill( "death", attacker, type, weapon );
	
	wait( 1 );
	#/
}

/*==========================================================================
FUNCTION: high_value_target
SELF: something that needs to die in order to get achievements
PURPOSE: simple way to track deaths of achievement targets

ADDITIONS NEEDED:
==========================================================================*/
high_value_target()
{
	if( !IsDefined( level._high_value_targets ) )
	{
		level._high_value_targets = 0;
	}
	
	level._high_value_targets++;
	
	self waittill( "death" );
	
	if( !IsDefined( level._high_value_targets_killed ) )
	{
		level._high_value_targets_killed = 0;
	}
	
	level._high_value_targets_killed++;
	PrintLn( "high value target killed. total = " + level._high_value_targets_killed + " of " + level._high_value_targets );
}

debug_tower_guys()
{
	while( IsAlive( self ) )
	{
		self waittill("damage", amount, who);
		maps\river_util::Print_debug_message( who.classname + " " + amount + " damage", true );	
	}
}

aftermath()
{
	flag_wait( "all_players_connected" );
		
	level thread intro_screen_dialogue();
				
	// Wait for the introscreen text to fade out
	flag_wait( "starting final intro screen fadeout" ); 
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		level.friendly_boats[ i ] ent_flag_clear( "can_move" );
	}
	
	level thread move_boats_with_player( undefined, undefined, -2000, 1200, -1200 );
	
    //C. Ayers: To fade in the rest of the maps audio
    clientnotify( "fdin" );
	
	player = get_players()[0];
	player SetLowReady( false );

	// VISION SET - Village Section
	level thread maps\createart\river_art::village_section( 0 );
	
	level thread maps\river_anim::boat_drop_vignette();
	
//	/#
//		level thread update_billboard("E1 B1: aftermath", "vignettes and pacing", "TEMP: 10-20 seconds", "roughout");
//		level thread maps\river_util::event_timer("aftermath", "aftermath_done");
//	#/
	
	level thread play_village_vignettes();
	level thread move_squad_to_boat();	
	level thread aftermath_hueys_arrive();

	// Create the vehicles in position for the initial boat drive	
	level thread maps\river_features::intro_vehicles_spawn();
	
	// What we have to hack in to ship............
	level thread check_if_player_jumps_in_copter_blades();
	
	squad_ready_for_boat_drive();  // make sure all animations are finished and squad is ready for player to use boat
	
	//level.boat MakeVehicleUsable();
	//level.boat setseatoccupied( 1, true );
	
	maps\river_util::wait_for_player_to_use_boat();

	level.boat notify( "ready_for_boat_drive" );
	level.boat.supportsAnimScripted = false;
	
	player = get_players()[0];
	player SetLowReady( false );

	// VISION SET - Boat Section
	level thread maps\createart\river_art::boat_section( 0 );
		
	// Start the drones in the boat drive introduction
	maps\river_features::start_boat_drive_background_drones();
		
	flag_set("aftermath_done");
	
	boat_drop();
}


intro_screen_dialogue()
{
	//Wait until fade is completed
	level waittill("finished final intro screen fadein");
	level thread maps\river_amb::intro_music();
	wait( 0.1 );
	
	//level.mason thread maps\river_vo::playVO_proper( "the_cia_downed", 1.0 );
	//level.woods thread maps\river_vo::playVO_proper( "wed_better_get", 4.5 );
	
	level.woods thread maps\river_vo::playVO_proper( "wed_better_get", 8.5 );
	
	level.mason thread maps\river_vo::playVO_proper( "right_lets_move", 14.5 );
}



squad_ready_for_boat_drive()
{
	flag_wait( "ready_for_boat_drive" );

//	level.woods ent_flag_wait( "ready_for_boat_drive" );  
//	level.reznov ent_flag_wait( "ready_for_boat_drive" );
//	level.bowman ent_flag_wait( "ready_for_boat_drive" );	

//	dock_clip = GetEnt( "player_shore_clip_opening", "targetname" );
//	if( !IsDefined( dock_clip ) )
//	{
//		IPrintLnBold( "dock_clip is missing!" );
//	}
//	dock_clip Delete(); // let the player on the boat...	
//		
}

aftermath_hueys_arrive()
{
	// spawn functions for helicopters - try populate_huey( num_ai_passengers, passenger_targetnames, skip_driver, skip_driver2, skip_gunner, skip_gunner2 )
//	add_spawn_function_veh( "aftermath_landing_huey1", ::huey_passenger_setup, "aftermath_huey1_passenger", 6, "initial_engagement_started" );
//	add_spawn_function_veh( "aftermath_landing_huey2", ::huey_passenger_setup, "aftermath_huey2_passenger", 6, "initial_engagement_started" );
//	add_spawn_function_veh( "aftermath_landing_huey3", ::huey_passenger_setup, "aftermath_huey3_passenger", 6, "initial_engagement_started" );

//	add_spawn_function_veh( "aftermath_landing_huey1", maps\river_jungle::populate_huey, 0 );
	//add_spawn_function_veh( "aftermath_landing_huey2", maps\river_jungle::populate_huey, 0 );
//	add_spawn_function_veh( "aftermath_landing_huey3", maps\river_jungle::populate_huey, 0, undefined, true, false, true, false );
	
//	add_spawn_function_veh( "aftermath_landing_huey1", ::vehicle_windowdressing, false, false, true );
	add_spawn_function_veh( "aftermath_landing_huey2", ::vehicle_windowdressing, false, false, true );
	add_spawn_function_veh( "aftermath_landing_huey3", ::vehicle_windowdressing, false, false, true );

//	add_spawn_function_veh( "aftermath_landing_huey1", maps\river_util::huey_cone_light );
	add_spawn_function_veh( "aftermath_landing_huey2", maps\river_util::huey_cone_light );
	//add_spawn_function_veh( "aftermath_landing_huey3", maps\river_util::huey_cone_light );
	
	level thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 35 );  // dropoff hueys in village. NOT boat drop hueys!	
	
	level thread huey_intro_effects();	
	
	wait( 0.1 );
	
	aftermath_huey3 = GetEnt( "aftermath_landing_huey3", "targetname" );
	if( !IsDefined( aftermath_huey3 ) )
	{
		//IPrintLnBold( "aftermath_huey3 is missing!" );
		return;
	}
	
	aftermath_huey3 maps\river_jungle::populate_huey( 0, undefined, false, false, true, true );
	
	aftermath_huey2 = GetEnt( "aftermath_landing_huey2", "targetname" );
	if( !IsDefined( aftermath_huey2 ) )
	{
		//IPrintLnBold( "aftermath_huey2 is missing!" );
		return;
	}
	
	aftermath_huey2 maps\river_jungle::populate_huey( 0, undefined, false, false, true, true );
	
}


//*****************************************************************************
// 
//*****************************************************************************
huey_intro_effects()
{
	wait( 1 );
	ent = GetEnt( "aftermath_landing_huey3", "targetname" );
	if( isdefined( ent ) )
	{
		// Blinking light FX
		PlayFXOnTag( level._effect["huey_blinking"], ent, "tag_origin" );
	}
}


/*==========================================================================
FUNCTION: huey_passenger_setup
SELF: helicopter that's about to have some passengers riding in it
PURPOSE: to put guys in a helicopter in an easy way

ADDITIONS NEEDED:
==========================================================================*/
huey_passenger_setup( spawner_targetname, num_passengers, delete_flag )
{
	if( !IsDefined( spawner_targetname ) )
	{
		PrintLn( "spawner_targetname is missing in huey_passenger_setup" );
		return;	
	}
	
	if( !IsDefined( num_passengers ) )
	{
		PrintLn( "num_passengers is missing in huey_passenger_setup. Defaulting to 4." );
		num_passengers = 4;
	}
	
//	if( !IsDefined( delete_flag ) )
//	{
//		PrintLn( "delete_flag required for clean up in huey_passenger_setup. returning." );
//		return;
//	}
	
	if( num_passengers > 8 )
	{
		PrintLn( "huey_passenger_setup passed in invalid number of max passengers. it's capped at 8." );
		num_passengers = 8;
	}
	
	for( i = 0; i < num_passengers; i++ )
	{
		guy = simple_spawn_single( spawner_targetname, ::ignore_everything );
		if( IsDefined( guy.gearModel ) )
		{
			guy Detach( guy.gearModel, "" );
		}
		
		guy thread enter_vehicle( self );
	}
}

ignore_everything( delete_flag )  // self = AI that's dead to the world
{
	self set_ignoreme( true );
	self set_ignoreall( true );
	
	if( IsDefined( delete_flag ) )
	{
		flag_wait( delete_flag );
		self Delete();
	}
}

/*===========================================================================
all vignettes in Aftermath beat are handled in these functions
===========================================================================*/
play_village_vignettes()
{	
	maps\_patrol::patrol_init();	
	
	level thread guards_and_prisoners_scene();
	
	level thread helicopter_landing_scene();
	
	level thread wounded_guy_scene();
	
	level thread attention_guys_scene();
	
	level thread poser_guys_group_a_scene();
	
	level thread poser_guys_group_b_scene();
	
	level thread usher_guys_loop_scene();
	
	level thread photographer_think();
	
	level thread injured_group_b_scene();
	
	level thread limping_guy_group_b();
	
	level thread limping_guy_group_c();
	
	level thread guys_in_pain();
	
	maps\river_util::Print_debug_message( "notify: poser_guys_group_a_start", true );
	level notify( "poser_guys_group_a_start" );
	
	wait( 20 );
	
	maps\river_util::Print_debug_message( "notify: poser_guys_group_b_start", true );
	level notify( "poser_guys_group_b_start" );	
	
	level thread kill_off_village_vignettes();
}

kill_off_village_vignettes()
{
	flag_wait( "missile_launcher_engagement_started" );
	
	wait( 2 );
	
	models = GetEntArray( "initial_engagement_started", "script_noteworthy" );
	if( models.size == 0 )
	{
		PrintLn( "couldn't find models for kill_off_village_vignettes" );
		return;
	}
	
	for( i = 0; i < models.size; i++ )
	{
		if( IsDefined( models[ i ] ) )
		{
			models[ i ] Delete();
		}
		
		wait( 0.25 );
	}
}

animated_model_clip()
{
	//wait( RandomFloatRange( 0.1, 0.5 ) );
	
	clip = GetEntArray( "animated_model_clip", "targetname" );
	if( clip.size == 0 )
	{
		PrintLn( "couldn't find animated_model_clip!" );
		return;
	}
	
	guys = [];
	
	if( IsArray( self ) )
	{
		guys = self;
	}
	else
	{
		guys[ guys.size ] = self;
	}
	
//	for( k = 0; k < guys.size; k++ )
//	{
//		guys[ k ] disableclientlinkto();
//	}
	
	j = 0;
	tag = "tag_origin";
	
	for( i = 0; i < clip.size; i++ )
	{
		if( IsDefined( clip[ i ].used ) )  // not checking for a value because if one is there, it's being used.
		{
			continue;
		}
		else 
		{			
			while( !IsDefined( guys[ j ].last_anim_time ) )  // make sure he's animating before linking clip to him
			{
				wait( 0.1 );
			}
			
			wait( 0.05 );
			
			pos = guys[ j ] GetTagOrigin( tag );
			clip[ i ] moveto( pos, 0.1 );
			clip[ i ] waittill( "movedone" );
			clip[ i ] LinkTo( guys[ j ], tag );
			clip[ i ].used = true;
			guys[ j ].clip = clip[ i ];
			j++;
			
			if( j == guys.size )  // if counter equals number of guys, we can stop. otherwise would access undefined array index
			{
				break;
			}
			
			if( i == clip.size )
			{
				PrintLn( "ran out of clip!" );
			}
		}
	}
	
}

interrogation_scene()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", "m16_sp", "model_interrogation_guy_1", "aftermath", "aftermath_interrogation_guys_anim_struct", true, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", "m16_sp", "model_interrogation_guy_2", "aftermath", "aftermath_interrogation_guys_anim_struct", true, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "vc", undefined, "model_interrogation_guy_3", "aftermath", "aftermath_interrogation_guys_anim_struct", true, "initial_engagement_started" );	
}

/*===========================================================================
	// guys in pain
	level.scr_anim[ "guy_in_pain_1" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyinpain_01;
	level.scr_anim[ "guy_in_pain_2" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyinpain_02;
	level.scr_anim[ "guy_in_pain_3" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyinpain_03;
	level.scr_anim[ "guy_in_pain_4" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyinpain_04;
	level.scr_anim[ "guy_in_pain_5" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyinpain_05;	
===========================================================================*/
guys_in_pain()
{
//	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "guy_in_pain_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "guy_in_pain_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "guy_in_pain_3", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "guy_in_pain_4", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "guy_in_pain_5", "aftermath", "village_animation_node", false, "initial_engagement_started" );
}

stretcher_guys_scene()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_medic_soldier_01", "aftermath", "aftermath_stretcher_guys_struct", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_medic_soldier_02", "aftermath", "aftermath_stretcher_guys_struct", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_medic_soldier_03", "aftermath", "aftermath_stretcher_guys_struct", false, "initial_engagement_started" );	
}

guards_and_prisoners_scene()
{
//	guys = [];
//	
//	level thread maps\river_anim::make_ai_model_and_animate( "american", "m16_sp", "model_guard_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "american", "m16_sp", "model_guard_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );
////	level thread maps\river_anim::make_ai_model_and_animate( "vc", undefined, "model_prisoner_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "vc1", undefined, "model_prisoner_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );
////	level thread maps\river_anim::make_ai_model_and_animate( "vc", undefined, "model_prisoner_3", "aftermath", "village_animation_node", false, "initial_engagement_started" );
////	level thread maps\river_anim::make_ai_model_and_animate( "vc", undefined, "model_prisoner_4", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "vc2", undefined, "model_prisoner_5", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	level thread maps\river_anim::make_ai_model_and_animate( "vc3", undefined, "model_prisoner_6", "aftermath", "village_animation_node", false, "initial_engagement_started" );
//	
	//guys animated_model_clip();
	
	level endon( "player_using_boat" );
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node is missing for limping_guy_group_b!" );
		return;
	}
	
	american_anims = [];
	american_anims[ american_anims.size ] = "guard_1";
	american_anims[ american_anims.size ] = "guard_2";
	
	vc_anims = [];
	vc_anims[ vc_anims.size ] = "model_prisoner_2";
	vc_anims[ vc_anims.size ] = "model_prisoner_5";
	vc_anims[ vc_anims.size ] = "model_prisoner_6";
	
	guys = simple_spawn( "aftermath_prisoner_guards" );
	for( i = 0; i < american_anims.size; i++ )
	{
		//guys[ i ] = maps\river_anim::make_animated_character_model( "american", "m16_sp" );
		guys[ i ].animname = american_anims[ i ];
	}
	
	vc_guys = [];
	for( i = 0; i < vc_anims.size; i++ )
	{
		vc_guys[ i ] = maps\river_anim::make_animated_character_model( "vc"+ (i + 1), undefined );
		vc_guys[ i ].animname = vc_anims[ i ];
	}
	
	for( i = 0; i < vc_guys.size; i++ )
	{
		vc_guys[ i ].script_noteworthy = "aftermath_model_guys";
	}
	//all_guys thread animated_model_clip();
	
	node thread anim_loop_aligned( vc_guys, "aftermath" );
	node thread anim_loop_aligned( guys, "aftermath" );
}

helicopter_landing_scene()
{
	guy1 = simple_spawn_single( "aftermath_far_guys_1" );
	guy1 thread simply_patrol( "opening_huey_patrol_1" );
	
	guy2 = simple_spawn_single( "aftermath_far_guys_2" );
	guy2 thread simply_patrol( "opening_huey_patrol_2" );
	
	//level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_heli_landing_guy_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	//level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_heli_landing_guy_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );	
}

injured_group_b_scene()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_b", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_b_medic_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_b_medic_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );	
}

injured_group_c_scene()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_c", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_c_medic_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "injured_dude_c_medic_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );	
}

wounded_guy_scene()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_injured_dude", "aftermath", "triage_guys_struct", false, "initial_engagement_started" );	
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_medic_1", "aftermath", "triage_guys_struct", false, "initial_engagement_started" );	
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "model_medic_2", "aftermath", "triage_guys_struct", false, "initial_engagement_started" );		
}

limping_guy_group_b()
{
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "limping_guy_b", "aftermath", "village_animation_node", false, "initial_engagement_started" );	
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "limping_guy_b_helper_1", "aftermath", "village_animation_node", false, "initial_engagement_started" );	
	level thread maps\river_anim::make_ai_model_and_animate( "american", undefined, "limping_guy_b_helper_2", "aftermath", "village_animation_node", false, "initial_engagement_started" );		

	/*
	level endon( "player_using_boat" );
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node is missing for limping_guy_group_b!" );
		return;
	}
	
	anims = [];
	anims[ anims.size ] = "limping_guy_b";
	anims[ anims.size ] = "limping_guy_b_helper_1";
	anims[ anims.size ] = "limping_guy_b_helper_2";
	
	guys = [];
	for( i = 0; i < 3; i++ )
	{
		guys[ i ] = maps\river_anim::make_animated_character_model( "american", undefined );
		guys[ i ].animname = anims[ i ];
	}
	
	node anim_single_aligned( guys, "aftermath" );
	
	array_delete( guys );  // these guys only play once, so get rid of them once the anim is done
	*/
}

limping_guy_group_c()
{
	level endon( "player_using_boat" );
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node is missing for limping_guy_group_b!" );
		return;
	}
	
	anims = [];
	anims[ anims.size ] = "limping_guy_c";
	anims[ anims.size ] = "limping_guy_c_helper_1";
	anims[ anims.size ] = "limping_guy_c_helper_2";
	
	guys = [];
	for( i = 0; i < 3; i++ )
	{
		guys[ i ] = maps\river_anim::make_animated_character_model( "american", undefined );
		guys[ i ].animname = anims[ i ];
	}
	
	level thread skip_time_on_limping_guys( guys );
	
	node anim_single_aligned( guys, "aftermath" );
	
	array_delete( guys );  // these guys only play once, so get rid of them once the anim is done
}

skip_time_on_limping_guys( guys )
{
	wait( 0.05 );
	for( i = 0; i < guys.size; i++ )
	{
		anim_set_time( guys[i], "aftermath", 0.4 );
	}
}

photographer_think()
{
	level endon( "player_using_boat" );
	
	struct = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( struct ) )
	{
		//IPrintLnBold( "node is missing for photographer_think!" );
		return;
	}
	
	node = Spawn( "script_origin", struct.origin );
	node.angles = struct.angles;
	
	// set up photographer
	//photographer = maps\river_anim::make_animated_character_model( "american", undefined );
	photographer = simple_spawn_single( "photographer" );
	photographer.script_noteworthy = "aftermath_model_guys";
	photographer gun_remove();
	//photographer HidePart( "tag_weapon_right", self.weapon );
	
//	// set up camera
	camera = GetEnt( "photographers_camera", "targetname" );
	camera init_anim_model( "camera", true );
	//photographer Attach( "p_rus_camera", "tag_weapon_right" );
	camera_tag = "tag_weapon_right";
//	camera = Spawn( "script_model", photographer GetTagOrigin( camera_tag ) );
//	camera SetModel( "P_rus_camera" )
//	camera LinkTo( photographer, camera_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	camera thread maps\river_util::ent_name_visible();
	
	// photographer starts in idle
	photographer.animname = "model_photographer_start_idle";
	//node thread anim_loop_aligned( photographer, "aftermath", undefined, "photographer_start" );
	//node thread anim_loop_aligned( camera, "idle_start", undefined, "photographer_start" );		
	
//	wait( 3 );  // TEMP: unsure when to start photographer right now - tj25
	
	maps\river_util::Print_debug_message( "photographer_start", true );
	level notify( "photographer_start" );

	// goes through village taking pictures	
	photographer.animname = "model_photographer_path";
	node thread anim_single_aligned( camera, "path" );
	node anim_single_aligned( photographer, "aftermath", undefined );

	// finishes up, idles by triage tent
	photographer.animname = "model_photographer_done_idle";
	node thread anim_loop_aligned( photographer, "aftermath" );
	level notify( "photographer_path_done" );
	node thread anim_loop_aligned( camera, "idle_end" );
	
	trigger = GetEnt( "mason_photo", "targetname" );
	if( !IsDefined( trigger ) )
	{
		PrintLn( "mason_photo trigger is missing in photographer_think" );
		return;
	}
	
	/*
	while( true )
	{
		trigger waittill( "trigger" );
		if( get_players()[0] IsLookingAt( photographer ) )
		{
			//IPrintLnBold( "say cheese!" );
			camera_flash( 0.5, 5 );
			break;
		}
		
		wait( 1 );
	}
	*/
}

usher_guys_loop_scene()
{
	level endon( "player_using_boat" );	
	/*
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node is missing for usher_guys_loop_scene!" );
		return;
	}
	
	loop_anims = [];
	loop_anims[ loop_anims.size ] = "model_usher_guy_1";
	loop_anims[ loop_anims.size ] = "model_usher_guy_2";
	//loop_anims[ loop_anims.size ] = "model_usher_guy_3";
	
	scene = "aftermath";
	*/
	guy1 = simple_spawn_single( "aftermath_usher_patrol_guys_1", ::replace_head, "c_usa_jungmar_head2" );
	guy1 thread simply_patrol( "usher_patrol_1" );
	
	guy2 = simple_spawn_single( "aftermath_usher_patrol_guys_2", ::replace_head, "c_usa_jungmar_head5" );
	guy2 thread simply_patrol( "usher_patrol_2" );
//	guys = [];
//	for( i = 0; i < 2; i++ )
//	{
//		guys[ i ] = maps\river_anim::make_animated_character_model( "american", "m16_sp" );
//		guys[ i ].animname = loop_anims[ i ];
//		guys[ i ].script_noteworthy = "aftermath_model_guys";
//		node thread anim_single_then_patrol( guys[i], "aftermath" );  // these are threaded individually in case the animations don't have the same loop time
//	}
}

replace_head( headmodel )
{
	if( !IsDefined( headmodel ) )
	{
		PrintLn( "no headmodel to attach for " + self.targetname );
		return;
	}
	
	if( IsDefined( self.headmodel ) )
	{
		// self Detach( self.headmodel );
		// self Attach( headmodel );
	}
	else
	{
		PrintLn( self.targetname + " is missing a headmodel. can't replace." );
	}
}

anim_single_then_patrol( node, scene ) // self = guy
{
	self endon( "death" );
	if( !IsDefined( self.script_animname ) )
	{
		//IPrintLnBold( self.targetname + " is missing script_animname!" );
	}
	else
	{
		self.animname = self.script_animname;
	}
	
	node anim_single_aligned( self, scene );
	self StopAnimScripted();
	//IPrintLnBold( "patrol starting: " + self.animname );
	
	//patrol_path = GetNode( self.script_string, "targetname" );
	
	self thread maps\_patrol::patrol( self.script_string );
}

simply_patrol( node_name ) // self = guy
{
	self.disable_melee = true;
	self thread maps\_patrol::patrol( node_name );
}

poser_guys_group_a_scene()
{
	level endon( "player_using_boat" );
	
	photographer_notify = "poser_guys_group_a_start";
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node for poser_guys_group_a_scene is missing!" );
		return;
	}
	
	// set up idle and single anims
	idle_anims = [];
	idle_anims[ idle_anims.size ] = "model_poserguy_a_01_idle";
	idle_anims[ idle_anims.size ] = "model_poserguy_a_02_idle";

	action_anims = [];
	action_anims[ action_anims.size ] = "model_poserguy_a_01";
	action_anims[ action_anims.size ] = "model_poserguy_a_02";
	
	// set up guys
	guys = [];
	for( i = 0; i < 2; i++ )
	{
		guys[ i ] = maps\river_anim::make_animated_character_model( "american", "m16_sp" );
		guys[ i ].script_noteworthy = "aftermath_model_guys";
		guys[ i ].animname = idle_anims[ i ];
	}
	
	//guys thread animated_model_clip();
	
	// guys idle
	node thread anim_loop_aligned( guys, "aftermath", undefined, photographer_notify );
	
	// wait until notify
	level waittill( photographer_notify );
	
	// play single anim
	for( i = 0; i < 2; i++ )
	{
		guys[ i ].animname = action_anims[ i ];
	}	
	
	node anim_single_aligned( guys, "aftermath" );
	
	// go back to idling
	for( i = 0; i < 2; i++ )
	{
		guys[ i ].animname = idle_anims[ i ];
	}
	
	node anim_loop_aligned( guys, "aftermath" );
}

poser_guys_group_b_scene()
{
	level endon( "player_using_boat" );
	
	photographer_notify = "poser_guys_group_b_start";
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node for poser_guys_group_b_scene is missing!" );
		return;
	}
	
	// set up idle and single anims
	idle_anims = [];
	idle_anims[ idle_anims.size ] = "model_poserguy_b_01_idle";
	idle_anims[ idle_anims.size ] = "model_poserguy_b_02_idle";

	action_anims = [];
	action_anims[ action_anims.size ] = "model_poserguy_b_01";
	action_anims[ action_anims.size ] = "model_poserguy_b_02";
	
	// set up guys
	guys = [];
	for( i = 0; i < 2; i++ )
	{
		guys[ i ] = maps\river_anim::make_animated_character_model( "american", "m16_sp" );
		guys[ i ].script_noteworthy = "aftermath_model_guys";
		guys[ i ].animname = idle_anims[ i ];
	}
	
	//guys thread animated_model_clip();
	
	// guys idle
	node thread anim_loop_aligned( guys, "aftermath", undefined, photographer_notify );
	
	// wait until notify
	level waittill( photographer_notify );
	
	// play single anim
	for( i = 0; i < 2; i++ )
	{
		guys[ i ].animname = action_anims[ i ];
	}	
	
	node anim_single_aligned( guys, "aftermath" );
	
	// go back to idling
	for( i = 0; i < 2; i++ )
	{
		guys[ i ].animname = idle_anims[ i ];
	}
	
	node anim_loop_aligned( guys, "aftermath" );
}

// guys that idle, then a trigger is hit where they play a one shot animation, then they go back to idling
attention_guys_scene()
{
	level endon( "player_using_boat" );
	
	trigger = GetEnt( "attention_guys_trigger", "targetname" );
	if( !IsDefined( trigger ) )
	{
		//IPrintLnBold( "trigger for attention_guys_scene is missing!" );
	}
	
	node = getstruct( "village_animation_node", "targetname" );
	if( !IsDefined( node ) )
	{
		//IPrintLnBold( "node for attention_guys_scene is missing!" );
		return;
	}
	
	idle_anims = [];
	idle_anims[ idle_anims.size ] = "model_attentionguy_01_idle";
	idle_anims[ idle_anims.size ] = "model_attentionguy_02_idle";
	idle_anims[ idle_anims.size ] = "model_attentionguy_03_idle";
	
	action_anims = [];
	action_anims[ action_anims.size ] = "model_attentionguy_01_action";
	action_anims[ action_anims.size ] = "model_attentionguy_02_action";
	action_anims[ action_anims.size ] = "model_attentionguy_03_action";
	
	attention_guys = [];
	for( i = 0; i < 3; i++ )  // 3 guys
	{	
		attention_guys[ i ] = maps\river_anim::make_animated_character_model( "american", "m16_sp" );
		attention_guys[ i ].script_noteworthy = "aftermath_model_guys";
		attention_guys[ i ].animname = idle_anims[ i ];
	}
	
	node thread anim_loop_aligned( attention_guys, "aftermath", undefined, "attention_guys_action" );
	
	if( IsDefined( trigger ) )
	{
		trigger waittill( "trigger" );  // trigger sends out notify "attention_guys_action" 
	}
	else
	{
		return;
	}
	
	maps\river_util::print_debug_message( "attention_guys_action", true );
	
	for( i = 0; i < 3; i++ )  // 3 guys
	{	
		attention_guys[ i ].animname = action_anims[ i ];
	}
	
	node anim_single_aligned( attention_guys, "aftermath" );  // acknowledge the player's presence
	
	for( i = 0; i < 3; i++ )
	{
		attention_guys[ i ].animname = idle_anims[ i ];
	}
	
	node anim_loop_aligned( attention_guys, "aftermath" );
	
}

setup_boat_stop_points()
{	
	// get friendly pbrs
	AssertEx((level.friendly_boats.size > 0), "friendly boats missing");
//	
//	start_nodes = GetVehicleNodeArray("friendly_pbr_start_node", "script_noteworthy");
//	AssertEx((start_nodes.size > 0), "start nodes for friendly boats are missing");
//	
	// loop through pbrs so they move and go on rails
	for(i=0; i<level.friendly_boats.size; i++)
	{
		//if(level.friendly_boats[i].script_int != 3)  // boat#3 is scripted to die early; don't monitor speed.
		//{
		path = GetVehicleNode( level.friendly_boats[ i ].target, "targetname" );
		if( !IsDefined( path ) )
		{
			//IPrintLnBold( level.friendly_boats[i].script_noteworthy + " IS BROKEN! NO PATH!" );
			continue;
		}
		
		level.friendly_boats[ i ] maps\_vehicle::getonpath(path);
		level.friendly_boats[ i ].drivepath = 1;
		level.friendly_boats[ i ] thread go_path( path );			
		level.friendly_boats[ i ] thread armada_wait_for_player( "initial_engagement", "missile_launcher_engagement_started" );  
		level.friendly_boats[ i ] thread armada_wait_for_player( "stop_before_initial_engagement", "initial_engagement_started" );
		level.friendly_boats[ i ] thread armada_wait_for_player( "stop_for_missile_engagement", "helicopter_bridge_destroyed" );			
		
		if( level.friendly_boats[ i ].script_int == 2 )
		{
			level.friendly_boats[ i ] thread armada_wait_for_player( "stop_at_second_tower", "quad50_2_dead" );	
			level.friendly_boats[ i ] thread boat_slows_down_to_fire( "boat2_slows_down_to_fire" );
		}
		else if( level.friendly_boats[ i ].script_int == 3 )
		{
			level.friendly_boats[ i ] thread armada_wait_for_player( "missile_launcher_bowl_stop", "helicopter_bridge_destroyed" );			
			level.friendly_boats[ i ] thread armada_wait_for_player( "stop_at_dual_towers", "quad50_2_dead" );	
			level.friendly_boats[ i ] thread armada_wait_for_player( "stop_at_first_tower", "boats_move_up_for_missile_engagement" );
			level.friendly_boats[ i ] thread boat_slows_down_to_fire( "boat3_slows_down_to_fire" );
			level.friendly_boats[ i ] thread boat_toggle_speed_check( "mortar_path_start", "mortar_path_stop" );
		}		
		//}		
	}
}

/*==========================================================================
FUNCTION: armada_wait_for_player
SELF: friendly npc boat or helicopter
PURPOSE: pass this function in on vehicles to 

ADDITIONS NEEDED:
==========================================================================*/
armada_wait_for_player( vehicle_node_notify, resume_speed_flag, ender ) 
{
	if( IsDefined( ender ) )
	{
		level endon( ender );
	}
	
	if( !IsDefined( vehicle_node_notify ) )
	{
		maps\river_util::print_debug_message( self.targetname + " is missing a vehicle_node_notify", true );
	}
	
	self waittill( vehicle_node_notify );
	
	PrintLn( self.script_noteworthy + " hit " + vehicle_node_notify );
	
	//self notify( "stop_speed_check" );
	self SetSpeedImmediate( 0, 30 );
	if( IsDefined( self.ent_flag[ "can_move" ]  ))
	{
		self ent_flag_clear( "can_move" );  // can NOT move
	}
	
	if( IsDefined( resume_speed_flag ) )
	{
		flag_wait( resume_speed_flag );  // this is a flag so if notify is missed, it won't break
		PrintLn( self.script_noteworthy + " can move again" );
		//self ResumeSpeed( 30 );
		self ent_flag_set( "can_move" );
	}
	else
	{
		//IPrintLnBold( self.script_noteworthy + " is stopping indefinitely." );
	}
}

// boat3_slows_down_to_fire
boat_slows_down_to_fire( fire_notify )  // self = boat
{
	if( !IsDefined( fire_notify ) )
	{
		//IPrintLnBold( "fire_notify is missing for " + self.targetname );
		return;
	} 
	
	if( !IsDefined( self.ent_flag[ "ignore_speed_check" ] ) )
	{
		self ent_flag_init( "ignore_speed_check" );
	}
	
	self.turret_audio_override = true;
	self.turret_audio_ring_override_alias = true;
  self.turret_audio_override_alias = "wpn_btr_fire_loop_npc";
  self.turret_audio_ring_override_alias = "wpn_btr_fire_loop_ring_npc";
	
	self maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );
	
	fire_time = 4;
	
	while( IsAlive( self ) )
	{
		self waittill( fire_notify );
		
		if( IsDefined( self.currentnode ) && IsDefined( self.currentnode.script_string ) )
		{
			start_pos = getstruct( self.currentnode.script_string, "targetname" );
			if( !IsDefined( start_pos ) )
			{
				//IPrintLnBold( self.targetname + " couldn't fire at " + self.currentnode.script_string );
				continue;
			}
			

			if( self ent_flag( "ignore_speed_check" ) )
			{
				self SetSpeedImmediate( 0, 10, 10 );
//				wait( 5 );
//				self ResumeSpeed( 1 );
			}
			
			self maps\_vehicle_turret_ai::set_forced_target();  // instantiate target index but don't use it			
			
			start_target = Spawn( "script_origin", start_pos.origin );
			
			PrintLn( self.script_noteworthy + " is firing at start_target" );
			self gunner_focus_fire( start_target, fire_time, 0 );
			
			self maps\_vehicle_turret_ai::clear_forced_target( start_target );
			
			if( IsDefined( start_pos.target ) )
			{
				end_pos = getstruct( start_pos.target, "targetname" );
				
				if( IsDefined( end_pos ) )
				{
					end_target = Spawn( "script_origin", end_pos.origin );
					
					PrintLn( self.script_noteworthy + " is firing at end_target" );
					self gunner_focus_fire( end_target, fire_time, 0 );
										
					self maps\_vehicle_turret_ai::clear_forced_target( end_target );
					
					end_target Delete();
				}					
			}					
			
			start_target Delete();			
			
			self maps\_vehicle_turret_ai::clear_forced_target( );  // clear all forced targets
			
			if( self ent_flag( "ignore_speed_check" ) )
			{
				self ResumeSpeed( 1 );
			}
		}
	}
}

gunner_focus_fire( target, time, seat_num )  // self = boat 
{
	self endon( "death" );

	if( !IsDefined( seat_num ) )
	{
		seat_num = 0;
	}
	
	weapon = self seatgetweapon( seat_num + 1 );  // always zero for front gunner
	
	sound_ent = spawn( "script_origin" , self.origin);
	self thread audio_ent_fakelink( sound_ent );
	sound_ent thread audio_ent_fakelink_delete();
	
	if( !IsDefined( weapon ) )
	{
		PrintLn( "Invalid turret_num passed to gunner_focus_fire. Returning." );
		return;		
	}

	if( self.vehicletype == "heli_huey_assault_river" )
	{
		firetime = 0.1;  // special case since GDT firetime value looks like a laser
	}
	else
	{
		firetime = WeaponFireTime( weapon );
	}
	
	// number of bullets fired = ( fire_rate/sec ) * seconds
	shots_fired_total = Ceil( ( 1 / firetime ) * time );  // using ceiling since we divide by this number; should never be zero

	for( shots_fired = 0; shots_fired < shots_fired_total; shots_fired++ )
	{
		self SetGunnerTargetEnt( target, ( 0, 0, 0 ), seat_num );  // reposition the turret before firing so it doesn't fire a high shot immediately		
		self FireGunnerWeapon( seat_num );
		if( self.vehicletype == "heli_huey_assault_river" )
		{
			sound_ent playloopsound( "wpn_m60_turret_fire_loop_npc" );
		}
		else
		{
			sound_ent playloopsound( "wpn_btr_fire_loop_npc" );
		}
		wait( firetime );
	}	
	
	if( self.vehicletype == "heli_huey_assault_river" )
	{
		sound_ent stoploopsound();
		sound_ent playsound( "wpn_m60_turret_fire_loop_ring_npc" );
	}
	else
	{
		sound_ent stoploopsound();
		sound_ent playsound( "wpn_btr_fire_loop_ring_npc" );
	}
	self stopfireweapon();
	//self clearturretyaw();
	self ClearTurretTarget();

	
	PrintLn( self.targetname + " fired " + shots_fired_total + " shots with gunner_focus_fire" );
}

/*==========================================================================
FUNCTION: armada_resume_speed
SELF: level. all vehicles are dealth with within the function; no thread required
PURPOSE: make all boats resume their spline speeds 

ADDITIONS NEEDED:
==========================================================================*/
armada_resume_speed()
{
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		level.friendly_boats[i] ResumeSpeed();
	}
}


/*===========================================================================
Bowman - needs to interact with platoon leader, then go to boat
Woods - just goes to boat. Reach -> Loop -> Single -> Idle
Reznov - just goes to boat. NO ANIMS YET
Kid - loops in on boat. Single -> enter turret
===========================================================================*/
move_squad_to_boat()
{
	//autosave_by_name( "river" );
	
	// get all reference nodes for anims
	village_animation_struct = getstruct( "village_animation_node", "targetname" );
	dock_animation_struct2 = getstruct( "player_boat_intro_node", "targetname" );
	
	// hero preparation
	level.reznov.animname = "reznov";
	level.woods.animname = "woods";
	level.bowman.animname = "bowman";
	
	// player lowers weapons
	player = get_players()[0];
	player SetLowReady( 1 );
	player AllowSprint( false );
	player AllowMelee( false );
	player AllowAds( false );
	//player SetMoveSpeedScale( 0.6 ); 
	
	playsoundatposition( "evt_num_num_02_r" , (0,0,0) );

	level.reznov useweaponhidetags( "commando_acog_sp" );
	
	// temp
	level.reznov forceteleport( ( -33473.6, -65404.4, 21.7 ), ( 0, 0, 0 ) );
	level.reznov SetGoalPos( level.reznov.origin );
	
	level.woods forceteleport( ( -33689.6, -65404.3, 27.8 ), ( 0, 0, 0 ) );
	level.woods SetGoalPos( level.woods.origin );
	
	level.bowman forceteleport( ( -33569.6, -65300.4, 24.4 ), ( 0, 0, 0 ) );
	level.bowman SetGoalPos( level.bowman.origin );
	
	level.woods animscripts\shared::detachAllWeaponModels();
	level.bowman animscripts\shared::detachAllWeaponModels();
	level.woods.weapon = "none";
	level.bowman.weapon = "none";
	//level.woods custom_ai_weapon_loadout( undefined, undefined, "m1911_sp" );
	//level.bowman custom_ai_weapon_loadout( undefined, undefined, "m1911_sp" );
	/*
	level.woods gun_remove();
	level.woods gun_switchto( "m1911_sp", "right" );
	level.bowman gun_remove();
	level.bowman gun_switchto( "m1911_sp", "right" );
	*/
	
	// redshirt preparation
	bow_gun_redshirt = simple_spawn_single( "bow_gun_redshirt", maps\river_util::init_hero_ent_flags );
	level.kid = bow_gun_redshirt;
	level.kid ent_flag_init( "anim_done" );
	bow_gun_redshirt.overrideActorDamage = maps\river_util::reduce_friendly_fire_damage;
	bow_gun_redshirt.animname = "kid";		
	bow_gun_redshirt LinkTo( level.boat, "tag_gunner_turret1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.boat thread anim_loop_aligned( bow_gun_redshirt, "pre_board_pbr_loop", "tag_gunner_turret1" );
	
	// Bowman does the seen-worse anim first
	//level thread seen_worse_vignette( village_animation_struct );
	//level.bowman ent_flag_wait( "anim_done" );
	
	// board boat squad
	squad = [];
	squad[ squad.size ] = level.woods;
	squad[ squad.size ] = level.bowman;
	squad[ squad.size ] = level.reznov;

	dock_animation_struct2 anim_reach_aligned( squad, "pre_board_pbr" );
	
	// now the aquad is in position, waiting for boat and the player to be ready
	flag_wait( "boat_drop_done" );					// BOAT DROP DONE
	flag_wait( "sog_right_begins" );				// PLAYER IN POSITION
	level notify( "start_squad_boarding" );
	
	PrintLn( "sog_right starting" );

	// Woods boarding VO	
	level.woods thread maps\river_vo::playVO_proper( "thats_us_lets_go", 0.1 );
		
	//level thread time_counter();
	
	// link the AIs to the boat and animate
	level.bowman linkto( level.boat, "tag_gunner3" );
	level.woods linkto( level.boat, "tag_passenger10" );
	
	level thread delete_boarding_clips();
	level thread allow_player_drive_early();
	
	// add the redshirt to the squad and animate them all
	level thread redshirt_get_on_pbr( bow_gun_redshirt );
	level thread reznov_get_on_pbr_delay( dock_animation_struct2 );
	level thread bowman_get_on_pbr();
	level thread woods_get_on_pbr();
	
	// Create a target for Woods to ALWAYS aim at
	level.boat thread player_aim_entity_update();
}

time_counter()
{
	timer = 0;
	while( 1 )
	{
		wait( 1 );
		timer++;
		//iprintlnbold( timer );
	}
}

#using_animtree ("generic_human");

woods_get_on_pbr()
{
	if( !level.woods.ignoreall )
	{
		level.woods set_ignoreall( true );
	}
	level.boat anim_single_aligned( level.woods, "board_pbr", "tag_passenger10" );
	level.woods animscripts\anims::clearAnimCache();
	level.woods rpg_turret_ai_set_anims();
	level notify( "intro_animation_finished" );
	level.woods thread setup_RPG_turret( "tag_passenger10", true );	
	
	flag_wait("player_driving_boat");
	level.woods animscripts\anims::setIdleAnimOverride();
}

bowman_get_on_pbr()
{
	if( !level.bowman.ignoreall )
	{
		level.bowman set_ignoreall( true );
	}	
	level.boat anim_single_aligned( level.bowman, "board_pbr", "tag_gunner3" );
	level.bowman animscripts\anims::clearAnimCache();
	level.bowman rpg_turret_ai_set_anims();
	level.bowman thread setup_RPG_turret( "tag_gunner3", true );	
	
	flag_wait("player_driving_boat");
	level.bowman animscripts\anims::setIdleAnimOverride();
}

redshirt_get_on_pbr( bow_gun_redshirt )
{
	bow_gun_redshirt disable_react();
	bow_gun_redshirt disable_pain();
		
	level.boat anim_single_aligned( bow_gun_redshirt, "board_pbr", "tag_gunner_turret1" );
	//bow_gun_redshirt unlink();
	//wait( 0.1 );
	bow_gun_redshirt maps\river_util::put_actor_on_bow_gun( level.boat, true );	
}

reznov_get_on_pbr_delay( dock_animation_struct )
{
	wait( 6.7 );
	level.reznov linkto( level.boat, "tag_passenger12" );
	level.boat anim_single_aligned( level.reznov, "board_pbr", "tag_passenger12" );
	level.reznov AllowedStances("stand");
}

allow_player_drive_early()
{
	wait( 10 );
//	iprintlnbold( "BOAT DRIVABLE" );
	flag_set( "ready_for_boat_drive" );
}

delete_boarding_clips()
{
	wait( 0.5 );
	shore_clip = getent( "player_shore_clip_woods", "targetname" );
	if( isdefined( shore_clip ) )
	{
		shore_clip delete();
	}  
	
	wait( 5.0 );
	shore_clip = getent( "player_shore_clip_bowman", "targetname" );
	if( isdefined( shore_clip ) )
	{
		shore_clip delete();
	}  
	
	wait( 2 );
	shore_clip = getent( "player_shore_clip_redshirt", "targetname" );
	if( isdefined( shore_clip ) )
	{
		shore_clip delete();
	}  
	

	shore_clip = getent( "player_shore_clip_reznov", "targetname" );
	if( isdefined( shore_clip ) )
	{
		shore_clip delete();
	}  
}

notetrack_geton_pbr_weapon_on_back( guy )
{
	/*
	// put his weapon on his back
	guy animscripts\shared::placeWeaponOn( guy.weapon, "back" );
	guy.weapon = "none";
	guy.bulletsInClip = 0;
	guy animscripts\anims::clearAnimCache();
	*/
	//guy gun_remove();
}

notetrack_geton_pbr_spawn_fake_m202( guy )
{
	wait( 0.1 );
	// spawn a fake M202 at his tag_weapon_right position
	guy.fake_m202 = spawn( "script_model", guy GetTagOrigin( "tag_weapon_right" ) );
	guy.fake_m202.angles = guy GetTagAngles( "tag_weapon_right" );
	guy.fake_m202 SetModel( "t5_weapon_m202_world" );
	guy.fake_m202 linkto( level.boat );
	
	//iprintlnbold( guy.animname + " spawns m202" );
	//level thread debug_fake_m202( guy.fake_m202 );
	//guy gun_remove();
}

debug_fake_m202( m202 )
{
	while( isdefined( m202 ) )
	{
		print3d( m202.origin, "M202" );
		wait( 0.05 );
	}	
}

notetrack_geton_pbr_grab_m202( guy )
{
	if( isdefined( guy.fake_m202 ) )
	{
		guy.fake_m202 delete();
	}
	
	//guy gun_remove();
	//guy gun_switchto( "m202_flash_sp_river", "right" );
	//guy gun_remove();
	//guy animscripts\anims::clearAnimCache();
	//guy animscripts\shared::attachWeapon( "m202_flash_sp_river", "right" );
	guy Attach( getWeaponModel( "commando_acog_sp" ), "tag_stowed_back" );
	guy Attach( getWeaponModel( "m202_flash_sp_river" ), "tag_weapon_right" );
	guy custom_ai_weapon_loadout( "m202_flash_sp_river", undefined, "m1911_sp" );
	//guy gun_switchto( "m202_flash_sp_river", "right" );
}

seen_worse_vignette( village_animation_struct )
{
	platoon_leader = maps\river_anim::make_animated_character_model( "american", undefined );
	platoon_leader.animname = "platoon_leader";
	
	// thread Bowman. Platoon leader deleted when he is done
	village_animation_struct anim_reach_aligned( level.bowman, "seen_worse" );
	level.bowman thread anim_single_then_flag( village_animation_struct, "seen_worse" );
	village_animation_struct anim_single_aligned( platoon_leader, "seen_worse" );
	
	platoon_leader Delete();
}

reach_then_single( reference_node, scene, node )
{
	self endon( "death" );
	
	if( !IsDefined( reference_node ) )
	{
		PrintLn( "reference_node is missing for reach_then_single " + self.targetname );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		PrintLn( "scene is missing for reach_then_single " + self.targetname );
		return;
	}
	
	if( IsDefined( node ) )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
	}
	
	reference_node anim_reach( self, scene );
//	IPrintLnBold( "anim reach done: " + self.targetname );
	reference_node anim_single( self, scene );	
//	IPrintLnBold( "anim single done: " + self.targetname );
}

reach_and_set_flag_aligned( reference_node, scene )  // self = AI
{
	if( !IsDefined( reference_node ) )
	{
		//IPrintLnBold( "reach_and_set_flag is missing reference_node" );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		//IPrintLnBold( "scene is missing reach_and_set_flag" );
		return;
	}
	
	if( !IsDefined( self.ent_flag[ "reach_done" ] ) )
	{
		self ent_flag_init( "reach_done" );
	}
	else
	{
		self ent_flag_clear( "reach_done" );
	}
	
	reference_node anim_reach_aligned( self, scene );
	self ent_flag_set( "reach_done" );
}

anim_single_then_flag( reference_node, scene, tag )
{
	if( !IsDefined( reference_node ) )
	{
		//IPrintLnBold( "reach_and_set_flag is missing reference_node" );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		//IPrintLnBold( "scene is missing reach_and_set_flag" );
		return;
	}
	
	if( !IsDefined( self.ent_flag[ "anim_done" ] ) )
	{
		self ent_flag_init( "anim_done" );
	}
	else
	{
		self ent_flag_clear( "anim_done" );
	}
	
	reference_node anim_single_aligned( self, scene, tag );
	self ent_flag_set( "anim_done" );	
}

reach_then_single_aligned( reference_node, scene, node )
{
	self endon( "death" );
	
	if( !IsDefined( reference_node ) )
	{
		PrintLn( "reference_node is missing for reach_then_single_aligned " + self.targetname );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		PrintLn( "scene is missing for reach_then_single_aligned " + self.targetname );
		return;
	}
	
	if( IsDefined( node ) )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
	}
	
	reference_node anim_reach_aligned( self, scene );
//	IPrintLnBold( "anim reach aligned done: " + self.targetname );
	reference_node anim_single_aligned( self, scene );	
//	IPrintLnBold( "anim single aligned done: " + self.targetname );
}



reach_then_loop( reference_node, scene, loop_ender, node )
{
	self endon( "death" );
	
	if( !IsDefined( reference_node ) )
	{
		PrintLn( "reference_node is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		PrintLn( "scene is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( !IsDefined( loop_ender ) )
	{
		PrintLn( "loop_ender is missing for reach_then_loop on " + self.targetname );
		return;
	}
	
	if( IsDefined( node ) )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
	}	
	
	reference_node anim_reach( self, scene );
//	IPrintLnBold( "anim reach done: " + self.targetname );
//	IPrintLnBold( "anim loop started: " + self.targetname );
	reference_node anim_loop( self, scene, loop_ender );
}



reach_then_loop_aligned( reference_node, scene, loop_ender, node )  // self = AI
{
	self endon( "death" );
	
	if( !IsDefined( reference_node ) )
	{
		PrintLn( "reference_node is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		PrintLn( "scene is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( !IsDefined( loop_ender ) )
	{
		PrintLn( "loop_ender is missing for reach_then_loop on " + self.targetname );
		return;
	}
	
	if( !IsDefined( self.ent_flag[ "reach_done" ] ) )
	{
		self ent_flag_init( "reach_done" );
	}
	else
	{
		self ent_flag_clear( "reach_done" );
	}
	
	if( IsDefined( node ) )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
		//IPrintLnBold( "goal hit: " + self.targetname );
	}	
	
	reference_node anim_reach_aligned( self, scene );
	self ent_flag_set( "reach_done" );
	reference_node anim_loop_aligned( self, scene, undefined, loop_ender );
}

reach_then_first_frame( reference_node, scene, node )
{
	self endon( "death" );
	
	if( !IsDefined( reference_node ) )
	{
		PrintLn( "reference_node is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( !IsDefined( scene ) )
	{
		PrintLn( "scene is missing for reach_then_loop " + self.targetname );
		return;
	}
	
	if( IsDefined( node ) )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
	//	IPrintLnBold( "goal hit: " + self.targetname );
	}	
	
	reference_node anim_reach_aligned( self, scene );
//	IPrintLnBold( "anim reach aligned done: " + self.targetname );
//	IPrintLnBold( "anim first frame started: " + self.targetname );
	reference_node anim_first_frame( self, scene );
}

/*==========================================================================
FUNCTION: move_to_node_then_teleport
SELF: AI doing the running and teleporting
PURPOSE: temp function to make friendly squad run to the player boat, then 
	use temp "traversal" to put them in correct positions

ADDITIONS NEEDED: replace temp "traversals" with real ones, or anims
==========================================================================*/
move_to_node_then_teleport( node_targetname, teleport_targetname, wait_flag ) 
{
	AssertEx( IsDefined( node_targetname ), "node_targetname is missing in move_to_node_then_teleport" );
	AssertEx( IsDefined( teleport_targetname ), "teleport_targetname is missing in move_to_node_then_teleport" );
	
	goal_node = GetNode( node_targetname, "targetname" );
	if( !IsDefined( goal_node ) )
	{
		PrintLn( "goal_node is undefined in move_to_node_then_teleport" );
		return;
	}
	
	teleport_point = getstruct( teleport_targetname, "targetname" );
	if( !IsDefined( teleport_point ) )
	{
		PrintLn( "teleport_point is undefined in move_to_node_then_teleport" );
		return;
	}
	
	self SetGoalNode( goal_node );
	self waittill( "goal" );
	
	if( IsDefined( wait_flag ) )
	{
		flag_wait( wait_flag );
	}
	
	self maps\river_util::actor_moveto( teleport_point );
	
	self ent_flag_set( "ready_for_boat_drive" );
}

boat_drop()
{		
	flag_set("player_inside_boat");
//	
//	/#
//		level thread update_billboard("E1 B2: boat_drag", "vignette", "TEMP: 10-15 seconds", "roughout");
//		level thread maps\river_util::event_timer("boat_drag", "boat_drop_done");
//	#/
	
	player_control_of_boat_starts();
	maps\river_util::keep_player_in_boat();
	level thread setup_boat_stop_points();	
			
	flag_set("boat_drop_done");
	
	// Start off the drones on the island
	// Turning off for now - too easy to shoot friendlies here
	//level thread maps\river_features::first_island_drones();

	cleanup_boat_drop();
}


cleanup_boat_drop()
{
	maps\river_util::print_debug_message( "===== BOAT DROP CLEANUP STARTING =====" );
	
	ents_saved = 0;
	ents_saved += maps\river_util::cleanup_spawners( "aftermath_vignette_guys" );	
	ents_saved += maps\river_util::cleanup_triggers( "aftermath_triggers" );
	ents_saved += maps\river_util::cleanup_guys( "aftermath_huey1_passenger" );
	ents_saved += maps\river_util::cleanup_guys( "aftermath_huey2_passenger" );
	ents_saved += maps\river_util::cleanup_guys( "aftermath_huey3_passenger" );
	
	huey1 = GetEnt( "aftermath_landing_huey1", "targetname" );
	if( IsDefined( huey1 ) )
	{
		huey1 Delete();
		ents_saved++;
	}
	huey2 = GetEnt( "aftermath_landing_huey2", "targetname" );
	if( IsDefined( huey2 ) )
	{
		huey2 Delete();
		ents_saved++;
	}	
	huey3 = GetEnt( "aftermath_landing_huey3", "targetname" );
	if( IsDefined( huey3 ) )
	{
		huey3 Delete();
		ents_saved++;
	}
	
	animated_guys = GetEntArray( "aftermath_model_guys", "script_noteworthy" );
	ents_saved += animated_guys.size;
	for( i = 0; i < animated_guys.size; i++ )
	{
		animated_guys[ i ] Delete();
	}
	
	maps\river_util::print_debug_message( "===== BOAT DROP CLEANUP DONE. " + ents_saved + " ENTS FREE =====" );
}

player_control_of_boat_starts()
{			
//	level thread maps\river_util::put_reznov_on_player_controlled_gun();
	level thread maps\river_features::print_boat_controls();
	
	// Add the grenade launcher to the PBR
	level.boat thread PBR_grenade_launcher();

	// Setup a gun overheating thread
	level.boat thread player_control_of_boat_weapon_overheating();
}



// Completely restore boat health after death

//*****************************************************************************
// self = player boat
//*****************************************************************************

restore_boat_health()
{
	self.boat_health = level._player_boat_health;  //fix for dmg overlay showing up -jc
	if( isdefined(self.max_missiles) )
	{
		level.woods.bulletsInClip = self.max_missiles;
		level.bowman.bulletsInClip = self.max_missiles;
		level.player maps\river_features::hud_rocket_reset_m202();
	}
}

//*****************************************************************************
// self = player boat
//*****************************************************************************

player_control_of_boat_weapon_overheating()
{
	self endon( "death" );
	
	// Becasue we don't have a consistent boat startup function (that includes checkpoints)
	// I'm adding a boat flip check function here
	self thread mission_fail_if_boat_flips();
		
	// Kevin running a custom loop sound audio function on the gun
	self thread player_turret_audio();

	player = get_players()[0];

	wep_xpos = -90;		// -90
	wep_ypos = -2;		// 2

	//bar_shader = "white";
	//bar_width = 58;		// 58
	//bar_height = 7;		// 7

	// Weapon icon
	player maps\river_features::hud_minigun_create( wep_xpos, wep_ypos );
	//hud_icon = player.minigun_hud["gun"];
	//hud_icon_alpha = player.minigun_hud["gun"].alpha;

	// Weapon overheat bar
	//bar_start_xpos = wep_xpos - 60;
	//bar_start_ypos = -10;
	
	//overheat_bar = player maps\river_features::hud_create_bar( bar_start_xpos, bar_start_ypos, bar_width, bar_height, bar_shader );

	last_bar_width = 0;
	while ( 1 )
	{
		player = get_players()[0];

		disable_firing = is_pbr_firing_disabled();

		weapon_overheating = player isWeaponOverheating();
		
		if( disable_firing )
		{
			weapon_overheating = 0;
		}
		else if( player attackbuttonPressed() )
		{
			if( !weapon_overheating )
			{
				Earthquake( 0.15, 0.2, player.origin, (42*2)*10 );
			}
		}
		
		// Get the over heat value (0 to 100)
		overheat_val = (player isWeaponOverheating(1));
		
		if( disable_firing )
		{
			overheat_val = 0;
		}
		if( overheat_val < 0 )
		{
			overheat_val = 0;
		}
		else if ( overheat_val > 100 )
		{
			overheat_val = 100;
		}
		
		// OAA 9/15/2010...a bit haxxor but we set this value on the server to be fished out by the client
		// to use for rendering the overheat bar. we are commandeering this value because it is networked
		// properly and we no longer use it for its originally inteded purpose
		frac = (overheat_val / 100);
		self SetHealthPercent(frac);

		//// Set the overheat bar width
		//frac = (overheat_val / 100);
		//overheat_bar.width = bar_width * frac;
		//if( overheat_bar.width < 0 )
		//{
		//	overheat_bar.width = 0;
		//}
		//
		//// Set the over heat bar color
		//
		//if( disable_firing )
		//{
		//	hud_icon.color = ( 0.0, 0.0, 0.0 );
		//	overheat_bar.color = ( 0.0, 0.0, 0.0 );
		//}
		//else if( !weapon_overheating )
		//{
		//	hud_icon.color = ( 1.0, 1.0, 1.0 );
		//	overheat_bar.color = ( frac, 1.0-frac, 0.0 );
		//}
		//else
		//{
		//	hud_icon.color = ( 1.0, 0.0, 0.0 );
		//	overheat_bar.color = ( 1.0, 0.0, 0.0 );
		//}

		//// Has the overheat bar changed size?
		//if( overheat_bar.width != last_bar_width )
		//{
		//	width = int(overheat_bar.width);
		//	if( !width )
		//	{
		//		width = 1;
		//	}
		//	overheat_bar setShader( bar_shader, width, bar_height );
		//	last_bar_width = overheat_bar.width;
		//}

		//// Don't draw the bar if there is no overheat
		//if( overheat_bar.width == 0 )
		//{
		//	overheat_bar.alpha = 0;
		//	last_bar_width = 0;
		//}
		//else
		//{
		//	overheat_bar.alpha = 1;
		//}
				
		// HIDE THE HUD ELEMENTS IF FIRING IS DISABLED
		if( disable_firing )
		{
			level.player.minigun_hud["button"] SetText("");
			SetSavedDvar("cg_hideWeaponHeat", true);
		}
		else
		{
			level.player.minigun_hud["button"] SetText("^3[{+attack}]^7");
			SetSavedDvar("cg_hideWeaponHeat", false);
		}
						
		// Has the player exited the boat?
		if( player isinvehicle() == false )
		{
			break;
		}

		wait( 0.01 );
	}
	
	player maps\river_features::hud_minigun_destroy();
	//overheat_bar maps\river_util::destroy_hud_elem();
}


//*****************************************************************************
// self 
//*****************************************************************************

mission_fail_if_boat_flips()
{
	self endon( "death" );
	level endon( "river_pacing_done" );

	wait( 1 );
	
	world_up_vector = ( 0, 0, 1 );
	
	num_flipped = 0;
	
	while( 1 )
	{
		boat_up_vector = AnglesToUp( self.angles );
		dot = vectordot( world_up_vector, boat_up_vector );
	
		// Is the boat in thr process of flipping?
		if( dot < -0.3)
		{
			num_flipped++;
		}
		else
		{
			num_flipped = 0;
		}
		
		if( num_flipped >= 10 )
		{
			maps\_utility::missionFailedWrapper();
			return;
		}
	
		//IPrintLnBold( "Boat Flip Dot: " + dot );

		wait( 0.1 );
	
	}
}


//*****************************************************************************
//*****************************************************************************

is_pbr_firing_disabled()
{
	if( flag("movie_playing") == true )
	{
		return( 1 );
	}

	return( 0 );
}


//*****************************************************************************
// Kevin custom turret audio functions
//*****************************************************************************

player_turret_audio()
{
	level endon( "stop_turret_audio" );
	player = get_players()[0];
	self thread turret_audio_failsafe( player );

	while( 1 )
	{
		weapon_overheating = player isWeaponOverheating();
		while(weapon_overheating || !is_attack_button_pressed())
		{
			weapon_overheating = player isWeaponOverheating();
			wait( 0.05 );
		}
		while(!weapon_overheating && is_attack_button_pressed())
		{
			weapon_overheating = player isWeaponOverheating();
			player playloopsound( "wpn_pbr_turret_fire_loop_plr" );
			wait( 0.05 );
		}
		if( weapon_overheating )
		{
			player playsound( "wpn_turret_overheat_plr" );
		}
		player stoploopsound();
		player playsound( "wpn_pbr_turret_fire_loop_ring_plr" );
	}
	
}

audio_ent_fakelink( sound_ent )
{
	level endon("stop_turret_audio" );
	self endon ("death");
	
	while(1)
	{
		sound_ent moveto( self.origin, .1 );
		sound_ent waittill("movedone");
	}
}

audio_ent_fakelink_delete()
{
	level waittill( "stop_turret_audio" );
	
	self delete();
}


//*****************************************************************************
//*****************************************************************************

turret_audio_failsafe( player )
{
	self waittill_any( "death" , "disconnect" , "end_player_heli", "player_not_using_boat" );  // added boat_docked so sound won't play during land section - TravisJ
	//IPrintLnBold("AUDIO ENNND");
	level notify( "stop_turret_audio" );
	if( is_attack_button_pressed() )
	{
		player stoploopsound();
		player playsound( "wpn_pbr_turret_fire_loop_ring_plr" );
	}
}


//*****************************************************************************
//*****************************************************************************

is_attack_button_pressed()
{
	if( is_pbr_firing_disabled() )
	{
		return( 0 );
	}
	if( level.player AttackButtonPressed() )
	{
		return( 1 );
	}
	return( 0 );
}


//*****************************************************************************
//*****************************************************************************

boat_drag_beat_cleanup()
{
	// clean up fake tag for objective
	boat_drag_fake_tag_origin = GetEnt("boat_drag_fake_tag_origin", "targetname");  
	AssertEx(IsDefined(boat_drag_fake_tag_origin), "boat_drag_fake_tag_origin is missing");
	boat_drag_fake_tag_origin Unlink();
	boat_drag_fake_tag_origin Delete();	
}

boat_drive()
{
//	/#
//		level thread update_billboard("E1 B3: boat_drive", "player controlled boat", "100-120 seconds", "blockout");
//		level thread maps\river_util::event_timer("boat_drive", "boat_drive_done");
//	#/
	
	level.boat thread maps\river_util::monitor_boat_damage_state();
	
	initial_island_engagement();
	missile_launcher_engagement();
	helicopters_fly_in_and_destroy_bridge();
	american_forces_move_into_NVA_base();
	AA_gun_encounter();
}

initial_island_engagement()
{
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		level.friendly_boats[ i ] ent_flag_set( "can_move" );
	}
	
	level thread initial_combat_area();
	
	wait( 0.1 );

	// Add friendly fire functions to the PBR boats
	friendly_fire_checks_on_friendly_boats();
	
	boat3 = GetEnt( "friendly_boat_3", "script_noteworthy" );
	AssertEx( IsDefined( boat3 ), "boat3 is missing for missile_launcher_engagement" );
	//boat3 thread vehicle_alternate_path( "missile_area_path_start", "boat3_mortar_path_1", "boat3_path_18" ) ;			
	
	level thread init_mortor_vehicle_movement(); // Start the mortar vehicles moving down paths - wait on flag 
	
	level.boat thread maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );
	
	helicopter_trigger = GetEnt( "initial_engagement_helicopter_flyby_trigger", "targetname" );
	AssertEx( IsDefined( helicopter_trigger ), "helicopter_trigger is missing in initial_island_engagement" );
	helicopter_trigger waittill( "trigger" );
		
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 33 );

	level thread maps\river_vo::vo_initial_island();
	
	trigger = GetEnt( "initial_island_engagement_starts", "targetname" );
	AssertEx( IsDefined( trigger ), "trigger missing in initial_island_engagement" );
	trigger waittill( "trigger" );
	
	level thread maps\river_util::flag_wait_then_func( "boat3_pass_player", ::move_boats_with_player, undefined, undefined, undefined, undefined, 2000, true );

	// Player VO Callouts
	delaythread( 0.5, maps\river_features::player_shoots_left_start_building_1 );
	delaythread( 0.8, maps\river_features::player_shoots_left_start_building_2 );

	flag_set( "initial_engagement_started" );
}


//*****************************************************************************
//*****************************************************************************

friendly_fire_checks_on_friendly_boats()
{
	for(i=0; i<level.friendly_boats.size; i++)
	{
		boat = level.friendly_boats[i];
		boat thread maps\river_util::friendly_fire_checker();
	}
}


/*==========================================================================
FUNCTION: vehicle_shootat_target
SELF: vehicle with guns on it
PURPOSE: make vehicles fire at static locations in an easy way
----------------------------------------------------------------------------
THINGS YOU NEED: 
	vehicle_node needs:	script_string with targetname of start struct
						script_int with turret number on it
	start struct needs: to point at end struct

ADDITIONS NEEDED:
==========================================================================*/
vehicle_shootat_target( time_scaler, burst_wait )
{
	self endon( "death" );
	
	if( !IsDefined( time_scaler ) )
	{
		time_scaler = 1; 
	}
	
	if( !IsDefined( burst_wait ) )
	{
		burst_wait = 1;
	}	
	
	while( IsAlive( self ) )
	{
		self waittill( "line_fire" );
		
		maps\river_util::print_debug_message( self.targetname + "is using line fire", true );
		
		node = self.currentnode;
		
		if( IsDefined( node.script_float ) )  // can set individual time_scalers from node itself if needed
		{
			time_scaler = node.script_float;
		}
		
		maps\river_util::print_debug_message( self.targetname + " reached " + node.targetname );
		
		if( IsDefined( node.script_string ) &&  ( IsDefined( node.script_int ) ) )
		{
			turret_num = node.script_int;
			
			start_struct = getstruct( node.script_string, "targetname" );
			if( IsDefined( start_struct ) )
			{
				if( IsDefined( start_struct.target ) )
				{
					end_struct = getstruct( start_struct.target, "targetname" );
					if( !IsDefined( end_struct ) )
					{
						PrintLn( "end_struct is missing in vehicle_shootat_target on " + self.targetname );
						return;
					}
					
					dist = Distance( end_struct.origin, start_struct.origin );
					speed = self GetSpeed();
					
					if( ( speed > 0 ) && ( dist > 0 ) )
					{
						time = time_scaler / ( speed / dist );  
						//time = 1.5;
						
						target = Spawn( "script_origin", start_struct.origin );
						target2 = Spawn( "script_origin", end_struct.origin );
						
						if( IsDefined( node.script_float ) )
						{
							time = node.script_float;
						}
						
						// this is threaded in case two guns need to fire independently from the same vehicle
						self gunner_focus_fire( target, time, turret_num );
						
						wait( burst_wait );
						
						self gunner_focus_fire( target2, time, turret_num );
						
						target Delete();
						target2 Delete();
					}
				}
			}
		}
		else
		{
			maps\river_util::print_debug_message( self.targetname + " wanted to fire at something, but no script_string exists at " + node.targetname );
		}
	}
}

/*==========================================================================
FUNCTION: vehicle_windowdressing
SELF: vehicle
PURPOSE: automate simple task of bringing in a vehicle, making sure it doesn't
	die unintentionally, and deleting it when it's at the end of its spline

ADDITIONS NEEDED:
==========================================================================*/
vehicle_windowdressing( do_drivepath, vehicle_avoidance, dont_delete )
{
	self endon( "death" );

	self.takedamage = true;

	if( IsDefined( do_drivepath ) && ( do_drivepath == true ) )
	{
		self.drivepath = 1;
	}	
	
	if( IsDefined( vehicle_avoidance ) )
	{
		self.vehicleavoidance = vehicle_avoidance;
	}
	
	if( IsDefined( dont_delete ) && ( dont_delete == true ) )
	{
		self.dontunloadonend = true;
	}
	else
	{
		self waittill_either( "reached_end_node", "near_goal" );  // need "near goal" if drivepath is used
	
		if( isdefined(self.targetname) )
		{
			maps\river_util::print_debug_message( self.targetname + " is at the end of its spline. Deleting!" );
		}
		
		self Delete();
	}
}

american_forces_move_into_NVA_base()
{
	trigger = GetEnt( "chinook_comes_over_mountainside_trigger", "targetname" );
	AssertEx( IsDefined( trigger ), "trigger is missing for american_forces_move_into_NVA_base" );
	trigger waittill( "trigger" );
	
	// Start the Drones as the bridge blows up
	level thread maps\river_features::bridge_destroyed_by_helicopters_drones_start();
	wait( 0.1 );
	
	// Delete these drones, they are too easy to hit with friendly fire
	//level thread maps\river_features::aa_gun_destroys_friendly_drones_start();
	wait( 0.1 );
	
	level thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 12 );
	wait( 0.1 );
	
	// VO for blowuping up selected stuff
	level thread maps\river_features::player_shoots_right_of_base_island();
	level thread maps\river_features::player_shoots_vorkuta_building();
	level thread maps\river_features::player_shoots_vorkuta_building_nextto();
	
	//simple_spawn("american_convoy_troops_1", maps\river_util::NVA_go_to_target, true);
	//simple_spawn("american_convoy_troops_2", maps\river_util::NVA_go_to_target, true);	
	
	wait( 0.1 );
	
	for( i = 0; i < 8; i++ )
	{
		simple_spawn( "after_bridge_sideline_battle_NVA_guy", maps\river_util::NVA_go_to_target, true );
	}
	
	// Adding headlights to vehicles
	// Add friendly fire thread to vehicles
	
	wait( 0.2 );
	for( lp=0; lp<2; lp++ )
	{
		name = "american_convoy_truck_" + (lp+1);
		
		trucks = GetEntArray( name, "targetname" );
		if( isdefined(trucks) )
		{
			for( i=0; i<trucks.size; i++ )
			{
				ent = trucks[ i ];
				playfxOnTag( level._effect["truck_headlight"], ent, "tag_headlight_left" );
				playfxOnTag( level._effect["truck_headlight"], ent, "tag_headlight_right" );
				path = GetVehicleNode( trucks[i].target, "targetname" );

				trucks[i].health = 999999;
				trucks[i] thread maps\river_util::friendly_fire_checker();
				
				//trucks[i] thread go_path();
				
				trucks[i] thread maps\river_features::vehicle_drive_and_die_at_path_end();
				
				wait( 0.1 );
			}
		}
	}
}

initial_combat_area()
{
	wait( 0.2 );

	level thread tower_spawner_setup( undefined, "tower1_guys", 1 );
	
	boat3 = GetEnt( "friendly_boat_2", "script_noteworthy" );
	AssertEx( IsDefined( boat3 ), "boat3 is missing" ); 
	boat3 maps\_vehicle_turret_ai::set_forced_target();
	boat3 maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );  // 0.75, 2
	level thread left_side_guys();
	level thread island_guys();
}

post_bridge_guys()
{
	simple_spawn_single( "after_bridge_tower_guy1", maps\river_util::RPG_fire_prediction, 5000, undefined, undefined, true );
	simple_spawn_single( "after_bridge_tower_guy2", maps\river_util::RPG_fire_prediction, 3000, undefined, undefined, true );
	simple_spawn( "after_bridge_right_side_rpg_guy", maps\river_util::fallback_behavior, "post_bridge_rpg_fallback_trigger", "base_rpg_fallback_node" );
	
	tower1_guy = GetEnt( "after_bridge_tower_guy1_ai", "targetname" );
	tower1_guy.takedamage = false;
	
//	trigger = GetEnt( "initial_bridge_destroyed_trigger", "targetname" );
//	trigger waittill( "trigger" );
//	
//	if( IsDefined( tower1_guy ) )
//	{
//		tower1_guy.takedamage = true;
//	}
	
}

/*==========================================================================
FUNCTION: setup_all_guard_towers
SELF: level
PURPOSE: make all guard towers set up in an easy way

ADDITIONS NEEDED:
==========================================================================*/
setup_all_guard_towers()
{
	towers = GetEntArray( "river_guard_tower", "targetname" );
	maps\river_util::print_debug_message( towers.size + " towers found for setup_all_guard_towers" );
	array_thread( towers, ::setup_guard_tower_individually );
	array_thread( towers, ::high_value_target );  // counts towards achievement
}

/*==========================================================================
FUNCTION: setup_guard_tower
SELF: trigger_damage ( the thing that triggers the guard tower's death )
PURPOSE: put together a guard tower in an easy way so they all act the same 

ADDITIONS NEEDED:
==========================================================================*/
setup_guard_tower_individually()
{
	self endon( "boat_drive_done" );
	
	if( !IsDefined( self.target ) )  // target is the script_model tower
	{
		maps\river_util::print_debug_message( "guard tower is missing a target at " + self.origin, true );
		return;
	}
	
	if( isdefined( self.target ) )
	{
		look_trigger = GetEnt( self.target, "targetname" );
		self thread guard_tower_red_cursor( look_trigger );
	}
	
	self.tower_broken = false;
	
	total_health = 800; //
	damage_taken = 0;
	
	if( IsDefined( self.script_string ) )  // tj25 - not hooked up to actual engagement distances yet
	{
		self thread spotlight_think( self.script_string, level.boat, 4500, self.script_noteworthy );
	}
	
	while( true )  
	{
		self waittill( "damage", amount, who, direction_vec, damage_ori, type, modelName );
		
		if( IsDefined( who ) )  
		{
			if( IsDefined( who.targetname ) &&
				( who.targetname == "player_controlled_boat" 
					|| who.targetname == "woods_ai"
					|| who.targetname == "bowman_ai" )
					|| ( IsPlayer( who ) ) )
				{
					// Should kill tower from 1 second of continuous fire
					if( (type == "MOD_RIFLE_BULLET" ) || ( type == "MOD_IMPACT" ) )
					{
						if( ( amount >= 12 ) && ( amount <= 22 ) )  // there's no way to differentiate the AI turret from player turret - use damage range of bow turret as hacky fix
						{
							amount = 0;  // no AI turret damage.
						}
						else
						{
							amount = 22;	// 36
						}
						
						damage_taken += amount;
					}
					// Intentional amount over max total_health to guarantee one hit kill
					else if( ( type == "MOD_PROJECTILE" ) || ( type == "MOD_PROJECTILE_SPLASH" ) || ( type == "MOD_EXPLOSIVE" ) )
					{
						amount = 1000;
						damage_taken += amount;
					}
					else
					{
						continue; // do no damage from other sources
					}
				}
				
				if( damage_taken >= total_health )
				{
					break;
					self.tower_broken = true;
				}
		}
	}
	
	
//IPrintLnBold("TOWER ACTIVATED!!!");
	if( IsDefined( self.script_int ) )
	{
		clip_name = "tower_" + self.script_int + "_clip";
		clip = GetEnt( clip_name, "targetname" );
		if( IsDefined( clip ) )
		{
			clip Delete();
		}
	}
		
	if( IsDefined( self.script_noteworthy ) )
	{
		level notify( self.script_noteworthy );
	}
	else
	{	
		//IPrintLnBold( "BUG: tower at " + self.origin + " is missing explosion fx!" );
	}
	
	self notify( "player_hits_tower" );
	
	maps\river_util::launch_guys_near_point( self, 400, 125, 250, "axis", ( 0, 0, -100 ) );  // launch tower guys
	RadiusDamage( self.origin, 500, 600, 600, get_players()[0], "MOD_EXPLOSIVE", "m202_flash_sp_river" );  // kill surrounding guys
//	model RotatePitch( 90, 3, 1 );  // rotate tower "fall"
//	
	// turn off the red cursor, if it was on
	if( isdefined( self.target ) )
	{
		SetSavedDvar( "player_forceRedCrosshair", "0" );
		look_trigger = GetEnt( self.target, "targetname" );
		look_trigger Delete();
	}

	self maps\river_vo::vo_guard_tower();
	
//	model waittill( "rotatedone" );
//
//	PlayFX( level._effect[ "guard_tower_death" ], model.origin );
	
	self notify( "death" ); // in case delete call doesn't get it done
	wait( 5 ); // make sure everything associated with this trigger can finish
	self Delete();  // don't need trigger any more
}

// show red cursor on guard tower when player looks at it
guard_tower_red_cursor( look_trigger )
{
	self endon( "boat_drive_done" );
	self endon( "player_hits_tower" );

	is_looking_at_tower = false;
	while( 1 )
	{
		player = get_players()[0];
		if( player IsLookingAt( look_trigger ) == true && is_looking_at_tower == false )
		{
			// set cursor to red
			SetSavedDvar( "player_forceRedCrosshair", "1" );
			is_looking_at_tower = true;
		}
		else if( player IsLookingAt( look_trigger ) == false && is_looking_at_tower == true )
		{
			// restore normal cursor
			SetSavedDvar( "player_forceRedCrosshair", "0" );
			is_looking_at_tower = false;
		}
		wait( 0.05 );
	}
}


/*==========================================================================
FUNCTION: left_side_guys
SELF: level
PURPOSE: spawn guys in waves until spawners are exhausted, or player leaves
		 the area

ADDITIONS NEEDED:
==========================================================================*/
left_side_guys()
{
	level endon( "helicopters_destroy_bridge" );
	level endon( "island_guys_left_done" );
	
	if( !IsDefined( level.island_guys_killed ) )
	{
		level.island_guys_killed = 0;
	}	
	
	if( !IsDefined( level.island_guys_spawned ) )
	{
		level.island_guys_spawned = 0;
	}	
	
	if( !IsDefined( level.island_guys_spawned_rpgs ) )
	{
		level.island_guys_spawned_rpgs = 0;
	}
	
	level thread left_side_cave_spawner();  // trigger based
	
	max_spawn_count = 999;  // total number of guys that can possibly be spawned here
	group_size = 5;  // number of guys to spawn in a wave
	delay_min = 1.5;  // time between waves
	delay_max = 3;
	
	wait( RandomFloatRange( 0.2, 0.8 ) );
	
	while( ( level.island_guys_spawned < max_spawn_count ) || ( flag( "player_passed_split_bridge_area" ) == true ) )
	{
		wait( RandomFloatRange( delay_min, delay_max ) );	// wait until wave is dead, then wait to spawn next group
		
		while( get_ai_group_sentient_count( "left_initial_island_guys") < group_size )
		{
			if( ( level.island_guys_spawned % 2 ) == 0 )  // every fourth guy, spawn rpg guy
			{
				wait( RandomFloatRange( 0.1, 0.3 ) );
				simple_spawn_single( "left_initial_island_guys_rpg" );
				level.island_guys_spawned_rpgs++;
			}
			else
			{
				simple_spawn_single( "left_initial_island_guys" );	
			}
			
			wait( RandomFloatRange( 0.5, 1.0 ) );
		}
	}	
	
	guys = GetEntArray( "left_initial_island_guys_ai", "targetname" );
	array_thread( guys, maps\river_util::kill_me );
	
	
}

/*==========================================================================
FUNCTION: missile_launcher_engagement
SELF: level
PURPOSE: 

ADDITIONS NEEDED:
==========================================================================*/
missile_launcher_engagement()
{
//	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
//	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
//	for( i = 0; i < missile_launchers.size; i++ )
//	{
//		add_spawn_function_veh( missile_launchers[ i ].targetname, ::high_value_target );  // counts towards achievement
//	}	
	
	//maps\river_util::print_debug_message( "missile_launcher_engagement started", true );
	//move_boats_with_player( start_notify, end_point_notify, boat_1_offset, boat_2_offset, boat_3_offset, update_only )

	helicopter_1_RPG_struct = getstruct( "missile_launcher_helicopter_RPG_fire", "targetname" );

	//level thread bridge_hint_dialogue();
	
	// Wait for player to hit this, then start engagement
	trigger = GetEnt("helicopter_entrance_trigger", "targetname");  // old = helicopter_entrance_trigger
	AssertEx( IsDefined( trigger ), "trigger is missing in missile_launcher_engagement" );
	trigger waittill("trigger");
	flag_set( "missile_launcher_engagement_started" );  // set this flag so objectives know to update
	level thread move_boats_with_player( undefined, undefined, -1300, -2200, 1200, true );	
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 34 );
	
	level thread maps\river_jungle::trigger_radius_damage( "missile_launcher_helicopter_large_building", 99999, 500, true, "missile_launcher_big_house_struct" );
	
	// Start the River Mortat attack on the Boats Event
	missile_launcher_guy_engagement_distance = 3600;
	missile_launcher_guy_min_wait = 3;
	missile_launcher_guys_max_wait = 5;

	guy_south = simple_spawn_single( "missile_launcher_rpg_guy_south", maps\river_util::RPG_fire_prediction, missile_launcher_guy_engagement_distance, missile_launcher_guy_min_wait, missile_launcher_guys_max_wait, true );
	guy_south2 = simple_spawn_single( "missile_launcher_rpg_guy_south_2", maps\river_util::RPG_fire_prediction, missile_launcher_guy_engagement_distance, missile_launcher_guy_min_wait, missile_launcher_guys_max_wait, true );
	//simple_spawn_single( "missile_launcher_rpg_guy_east", maps\river_util::RPG_fire_prediction,  missile_launcher_guy_engagement_distance, missile_launcher_guy_min_wait, missile_launcher_guys_max_wait, true );
	guy_east = simple_spawn_single( "missile_launcher_rpg_guy_east_2", maps\river_util::RPG_fire_prediction, missile_launcher_guy_engagement_distance, missile_launcher_guy_min_wait, missile_launcher_guys_max_wait, true );
	guy_hidden = simple_spawn_single( "missile_launcher_rpg_guy_hidden", maps\river_util::RPG_fire_prediction, missile_launcher_guy_engagement_distance, missile_launcher_guy_min_wait, missile_launcher_guys_max_wait, true );
	
	guy_array = [];
	guy_array[ guy_array.size ] = guy_south;
	guy_array[ guy_array.size ] = guy_south2;
	guy_array[ guy_array.size ] = guy_east;
	guy_array[ guy_array.size ] = guy_hidden;
	
	for( i = 0; i < guy_array.size; i++ )
	{
		guy_array[ i ].overrideActorDamage = maps\river_util::reduce_vehicle_damage;
	}
	
	level thread river_mortar_attack_boats_event();

	// Start up the drones in the missile attack area
	level thread maps\river_features::missile_attack_drones_group1();
	level thread maps\river_features::missile_attack_drones_group2();
	
	// Warning to player not to shoot the bridge
	level thread maps\river_features::dont_shoot_enter_base_trigger();
	
	// If the player stays close to the bridge while the mortars are alive, tell them to go and attack the mortors
	level thread maps\river_features::attack_the_mortars_reminder();
	
	level waittill( "river_mortar_objective_complete" );


	//IPrintLnBold( "missile sequence ends" );
	// when it's done, set flag for objectives
	flag_set( "helicopters_destroy_bridge" );
	
	cleanup_missile_launcher_event();
}

cleanup_missile_launcher_event()
{
	maps\river_util::print_debug_message( "===== MISSILE LAUNCHER CLEANUP STARTING =====" );
	
	ents_saved = 0;
	ents_saved += maps\river_util::cleanup_spawners( "left_initial_island_guys" );	
	ents_saved += maps\river_util::cleanup_spawners( "missile_launcher_rpg_guys" );
	ents_saved += maps\river_util::cleanup_spawners( "tower1_guys", true );
	ents_saved += maps\river_util::cleanup_triggers( "initial_engagement_triggers" );
	
	enemies = GetAIArray( "axis" );
	ents_saved += enemies.size;
	array_thread( enemies, maps\river_util::kill_me );	
	
	maps\river_util::print_debug_message( "===== MISSILE LAUNCHER CLEANUP DONE. " + ents_saved + " ENTS FREE =====" );
	
}

// 
cleanup_helicopter_bridge_area()
{
	maps\river_util::print_debug_message( "===== HELICOPTER BRIDGE AREA CLEANUP STARTING =====" );
	
	ents_saved = 0;

	ents_saved += maps\river_util::cleanup_spawners( "tower2_guys", true );
	ents_saved += maps\river_util::cleanup_triggers( "post_helicopter_bridge_triggers" );
	ents_saved += maps\river_util::cleanup_spawners( "after_bridge_sideline_battle_NVA_guy", true );
	
	// CLEAN UP TREES: (SCRIPT_INT 1)
	maps\river_features::cleanup_destructable_trees( 1 );
	
	village_trucks = GetEntArray( "opening_village_trucks", "script_noteworthy" );
	ents_saved += village_trucks.size;
	array_delete( village_trucks );
	
	maps\river_util::print_debug_message( "===== HELICOPTER BRIDGE AREA CLEANUP DONE. " + ents_saved + " ENTS FREE =====" );
}

// 
cleanup_AA_guns_area()
{
	wait( 0.5 );
	
	maps\river_util::print_debug_message( "===== AA GUNS AREA CLEANUP STARTING =====" );
	
	ents_saved = 0;

	ents_saved += maps\river_util::cleanup_spawners( "split_bridge_west_bank_guys", true );
	ents_saved += maps\river_util::cleanup_spawners( "first_turn_dock_house_guys", true );
	ents_saved += maps\river_util::cleanup_spawners( "first_turn_west_bank_3_guys", true );
	ents_saved += maps\river_util::cleanup_spawners( "after_bridge_sideline_battle_NVA_guy", true );
	ents_saved += maps\river_util::cleanup_triggers( "AA_guns_triggers" );
	
	bridge_trucks = GetEntArray( "helicopter_bridge_trucks", "script_noteworthy" );
	ents_saved += bridge_trucks.size;
	array_delete( bridge_trucks );
	
	maps\river_util::print_debug_message( "===== AA GUNS AREA CLEANUP DONE. " + ents_saved + " ENTS FREE =====" );
}

cleanup_sampan_area()
{
	maps\river_util::print_debug_message( "===== SAMPAN AREA CLEANUP STARTING =====" );
	
	ents_saved = 0;

	ents_saved += maps\river_util::cleanup_spawners( "s_curve_bridge_rpg_guys", true );
	ents_saved += maps\river_util::cleanup_spawners( "s_curve_bridge_house_guys", true );
	ents_saved += maps\river_util::cleanup_spawners( "s_curve_embankment_guys", true );
	ents_saved += maps\river_util::cleanup_triggers( "sampan_area_triggers" );
	
	// CLEAN UP TREES: (SCRIPT_INT 2)
	maps\river_features::cleanup_destructable_trees( 2 );
	
	maps\river_util::print_debug_message( "===== SAMPAN AREA CLEANUP DONE. " + ents_saved + " ENTS FREE =====" );
}

/*==========================================================================
FUNCTION: move_boats_with_player
SELF: level
PURPOSE: make boats move a predefined distance behind player boat. if "update_only"
		 is true, it won't run a new speed check function on the boats, only 
		 update the offset distance within the same function that's already running

ADDITIONS NEEDED: figure out what end_point_notify is supposed to do.
==========================================================================*/
move_boats_with_player( start_notify, end_point_notify, boat_1_offset, boat_2_offset, boat_3_offset, update_only )
{
	if( !IsDefined( start_notify ) )
	{
		maps\river_util::print_debug_message( "start_notify is missing in move_boats_with_player", true );
	}
	else
	{
		level waittill( start_notify );
	}
	
	if( !IsDefined( end_point_notify ) )
	{
		maps\river_util::print_debug_message( "end_point_notify is missing", true );
	}
	else
	{
		level endon( end_point_notify );
	}
	
	level.friendly_boats = remove_dead_from_array( level.friendly_boats ); 
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		if( level.friendly_boats[ i ].script_int == 1 )
		{
			if( IsDefined( boat_1_offset ) )
			{
				offset = boat_1_offset;
			}
			else
			{
				continue;
			}
		}
		else if( level.friendly_boats[ i ].script_int == 2 )
		{
			if( IsDefined( boat_2_offset ) )
			{
				offset = boat_2_offset;
			}
			else
			{
				continue;
			}
		}
		else //( level.friendly_boats[ i ].script_int == 3 )
		{
			if( IsDefined( boat_3_offset ) )
			{
				offset = boat_3_offset;
			}
			else
			{
				continue;
			}
		}

		
		if( IsDefined( update_only ) && ( update_only == true ) )
		{
			level.friendly_boats[ i ].player_boat_offset = offset;
			
			if( offset > 0 )
			{
				if( level.friendly_boats[ i ].script_int == 1 )  // never do this for boat #1, special case 
				{
					continue;
				}
				
				level.friendly_boats[ i ].try_to_pass_player = true;
			}
			else
			{
				level.friendly_boats[ i ].try_to_pass_player = false;
			}
		}
		else
		{
			level.friendly_boats[ i ] ent_flag_set( "can_move" );
			level.friendly_boats[ i ] thread maps\river_util::snider_convoy_speed_check( offset );
		}
	}
}

vehicle_alternate_path( breakoff_notify, path_start, rejoin_path, ender )  // self = vehicle 
{	
	if( !IsDefined( breakoff_notify ) )
	{
		PrintLn( "breakoff_notify is missing for vehicle_alternate_path on " + self.targetname );
		return;
	}
	
	if( !IsDefined( path_start ) )
	{
		PrintLn( "path_start is missing for vehicle_alternate_path on " + self.targetname );
		return;
	}
	
	if( !IsDefined( rejoin_path ) )
	{
		PrintLn( "rejoin_path is missing for vehicle_alternate_path on " + self.targetname );
		return;
	}		
	
	if( IsDefined( ender ) )
	{
		level endon( ender );
	}		
	
	path = GetVehicleNode( path_start, "targetname" );
	if( !IsDefined( path ) )
	{
		PrintLn( "path is missing for alternate_vehicle_path for " + self.targetname );
		return;
	}

	return_path  = GetVehicleNode( rejoin_path, "targetname" );
	if( !IsDefined( return_path ) )
	{
		PrintLn( "return_path is missing for alternate_vehicle_path for " + self.targetname );
		return;
	}	
	
	if( !IsDefined( self.ent_flag[ "ignore_speed_check" ] ) )
	{
		self ent_flag_init( "ignore_speed_check" );
	}
	
	self waittill( breakoff_notify );

	self ent_flag_set( "ignore_speed_check" );
	
	PrintLn( self.targetname + " hit breakoff_notify" );
	
	if( self.drivepath == 0 )
	{
		self.drivepath = 1;
	}	
	
	self AttachPath( path );
	self thread go_path( path );
	
	self waittill( "path_end" );

	self ent_flag_clear( "ignore_speed_check" );
	
	PrintLn( self.targetname + " finished alternate path" );
	
	self AttachPath( return_path );
	self thread go_path ( return_path );
}

boat_toggle_speed_check( start_notify, stop_notify )
{
	if( !IsDefined( self.ent_flag[ "ignore_speed_check" ] ) )
	{
		self ent_flag_init( "ignore_speed_check" );
	}
	
	self waittill( start_notify );
	
	self ent_flag_set( "ignore_speed_check" );  // turns off scripted speed scaling 
	
	self ResumeSpeed( 15 );
	node = self.currentnode;
	self AttachPath( node );
	self.drivepath = 1;
	self thread go_path( node );
	
	self waittill( stop_notify );
	
	self ent_flag_clear( "ignore_speed_check" );
}

helicopter_speed_scale( front_offset )  // self = friendly helicopter
{
	self endon("death");
	
	if(self maps\_vehicle::is_corpse() == false)
	{

		threshold_distance = 8000;	
		max_threshold = 10000;	
		vehicle_type = "helicopter";
				
		PrintLn(vehicle_type + " #" + self.targetname + " is running helicopter_speed_scale");				
		
		new_speed = 30; // arbitrary -  to keep variables in scope
		if( !IsDefined( front_offset ) )
		{
			self.helicopter_distance_offset = 3000;
		}
		else
		{
			self.helicopter_distance_offset = front_offset;
		}
		
		heli_max_speed = 80;
		node_speed = self GetSpeed();  // initialize this value
		conversion = 17.6; // this is used to convert units/sec into mph
		
		while( true )
		{
			//current_distance = Distance(self.origin, level.boat.origin);
			boat_speed = level.boat GetSpeedMPH();
			current_speed = self GetSpeedMPH();
			
			if( IsDefined( self.currentnode.speed ) )
			{
				node_speed = self.currentnode.speed  / conversion;
			}
			
			vector_to_player_boat = level.boat.origin - self.origin;

			if( !isdefined(self.pathlookpos) )
			{
				forward = AnglesToForward( self.angles );
			}
			else
			{
				forward = vectornormalize( self.pathlookpos - self.origin );
			}
			
			current_distance = VectorDot(vector_to_player_boat, forward);

			current_distance += self.helicopter_distance_offset;
			
			max_goal_dist_away = 600;
			
			current_distance = clamp( current_distance, max_goal_dist_away * -1, max_goal_dist_away );

			speed_scale = 1 + (current_distance / max_goal_dist_away);

			//new_speed = boat_speed * speed_scale;
			new_speed = current_speed * speed_scale;
			new_speed = clamp( new_speed, node_speed, heli_max_speed ); 
			self SetSpeed( new_speed );
			maps\river_util::print_debug_message( self.targetname + " changing speed to " + new_speed + ". Distance = " + current_distance);				
	
			wait(0.3);
		}
	}
}



left_side_cave_spawner()
{
	level endon( "helicopters_destroy_bridge" );
	
	wait( 0.5 );
	
	fx_struct = getstruct( "cave_fx_origin", "targetname" );
	Assert( IsDefined( fx_struct ), "fx_struct is missing in left_side_cave_spawner" );
	damage_trigger = GetEnt( "right_side_cave_spawner_kill_trigger", "targetname" );
	AssertEx( IsDefined( damage_trigger ), "damage_trigger is missing for left_side_cave_spawner" );
	damage_trigger waittill( "trigger" );
	
	PlayFX( level._effect[ "temp_destructible_building_fire_large" ], fx_struct.origin );
	
	level notify( "island_guys_left_done" );
}

island_guys_function( count_deaths )
{
	if( !IsDefined( level.island_guys_killed ) )
	{
		level.island_guys_killed = 0;
	}
	
	if( !IsDefined( level.island_guys_spawned ) )
	{
		level.island_guys_spawned = 0;
	}
	

	
	if( ( self.classname == "actor_VC_e_RIVER_RPG_AK47" ) || ( self.classname == "actor_VC_e_RIVER_RPG_AK74u" ) )
	{
		self.accuracy = 10;
		self.ignoresuppression = true;
		if( IsDefined( self.a.rockets ) )
		{
			self.a.rockets = 200;	
		}
		
		//self thread only_fire_in_range_of_boat();
		self thread maps\river_util::RPG_fire_prediction( undefined, undefined, undefined, undefined, true );
		// damage callback
		self.overrideActorDamage =  maps\river_util::reduce_vehicle_damage;
	}
	else
	{
		self SetEntityTarget(level.boat, 1);	
	}
	
	self.goalradius = 64;
	self set_ignoresuppression( true );
	level.island_guys_spawned++;
	
	boat3 = GetEnt( "friendly_boat_2", "script_noteworthy" );
	if( IsDefined( boat3 ) && ( ( self.classname != "actor_VC_e_RIVER_RPG_AK47" ) || ( self.classname != "actor_VC_e_RIVER_RPG_AK74u" ) ) )
	{
		boat3 maps\_vehicle_turret_ai::set_forced_target( self );  // make boat on left fire on these guys
	}
	
	
	if( IsDefined( self.target ) )
	{
		nodes = GetNodeArray( self.target, "targetname" );
		AssertEx( ( nodes.size > 0 ), "nodes missing for island_guys_function" );
		goal = random( nodes );
		
		self SetGoalNode( goal );
	}
	else
	{
		//IPrintLnBold( self.targetname + " is missing a target node" );
	}
	
	self waittill( "death" );
	
	if( IsDefined( count_deaths ) && ( count_deaths == false ) )
	{
		level.island_guys_killed++;
	}
}


reduce_NPC_PBR_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if( sWeapon == "gaz_quad50_turret" )
	{
		iDamage = iDamage / 4;
	}
	
	return iDamage;
}



/*==========================================================================
FUNCTION: only_fire_in_range_of_boat
SELF: AI - these will always have RPGs
PURPOSE: make select RPG engagements distance based rather than timing based

ADDITIONS NEEDED:
==========================================================================*/
only_fire_in_range_of_boat( override_dist )
{
	if( IsDefined( override_dist ) )
	{
		engagement_dist = override_dist;	
	}
	else
	{
		engagement_dist = 6000;
	}
	
	engagement_dist_squared = engagement_dist * engagement_dist;  // used in range calculation
	
	ent_num = self GetEntityNumber();
	
	while( IsAlive( self ) )
	{
		current_dist = DistanceSquared( level.boat.origin, self.origin );
		if( current_dist <= engagement_dist_squared )
		{
			self set_ignoreall( false );
			maps\river_util::Print_debug_message( ent_num + " is FIRING AT THE BOAT" );
			self Shoot_at_target( level.boat, "tag_driver" );
		}
		else
		{
			self set_ignoreall( true ); // don't fire when boat is out of range
			maps\river_util::Print_debug_message( ent_num + " is waiting until the boat is in range" );
		}
		
		wait( RandomIntRange( 2, 4 ) );  // temp: "forgiving" times
	}
}

island_guys()
{
	level endon( "helicopters_destroy_bridge" );
	level endon( "island_guys_right_done" );
	
	group_size = 4;
	count = 0;
	
	wait( RandomFloatRange( 0.1, 0.5 ) );
	
	while( flag( "helicopter_bridge_destroyed" ) == false )
	{
		if( get_ai_group_sentient_count( "island_guys" ) < group_size )
		{
//			if( count % 5 == 0 ) // every fourth guy is a AK47 guy
//			{
//				simple_spawn_single( "first_island_guys", ::island_guys_function );
//			}
//			else
//			{
				simple_spawn_single( "first_island_guys_rpg" );
//			}
		}
		
		wait( RandomFloatRange( 0.5, 0.9 ) );
	}
}

// rewrote to be modular - TODO: delete once you know it works
put_bowman_on_bow_gun()
{
	level.bowman maps\river_util::put_actor_on_bow_gun();
	maps\river_util::enable_bow_turret_fire();
}

//*****************************************************************************
// self = Entity with rocket launcher (Woods or Bowman)
//*****************************************************************************

setup_RPG_turret( tag_name, no_link )  
{
	// Entity, don't react to the environment
	self disable_react();
	self.ignoreall = true;
	self disable_pain(); 
	self.grenadeawareness = 0;

	// Move entity to his action node
	if( !IsDefined( level.boat GetTagOrigin( tag_name ) ) )
	{
		AssertMsg( "no tag found on boat with name " + tag_name );
	}
	
	if( !isdefined( no_link ) )
	{
		// temporary solution until anims match up - TJanssen
		tag_pos = Spawn( "script_origin", level.boat GetTagOrigin( tag_name ) );
		self maps\river_util::actor_moveto( tag_pos, 0.1 );
		tag_pos Delete();
	
//	self Unlink();
//	self Teleport( level.boat GetTagOrigin( tag_name ), level.boat GetTagAngles( tag_name ) );
	
	//action_node = GetNode( node_targetname, "targetname" );			// old = "bow_action_node" for Woods
	//AssertEx( IsDefined( action_node ), "action_node missing for " + self.targetname );
	//self.goalradius = 12;
	//self SetGoalNode( action_node );
	//self waittill( "goal" );
	
		self LinkTo( level.boat, tag_name );
	}

	self AllowedStances( "stand" );

	flag_wait( "player_inside_boat" );

	self AnimCustom( ::rpg_turret_ai );
}

//*****************************************************************************
//*****************************************************************************

#using_animtree( "generic_human" );
rpg_turret_ai()
{	
	level endon( "death" );
	self endon("death");
	self endon("start_ragdoll");
	self endon("stop_rpg_turret_ai");

	// set the turn threshold
	turnThreshold = 35;
	turnSpeed = 5;

	// anim speed
	reloadRate = 1.25;		// 1.75
	fireRate = 2.0;			// 2.0
	
	// force enemy
	self SetEntityTarget( level.player_aim_ent );

	// force override for animArray calls
	self.a.script = "combat";

	// set to single shot
	self.shootStyle = "single";
	self.fastBurst = false;

	// make sure the AI shoots it, even if not visible
	self.cansee_override = true;

	// set clip size
	self.bulletsInClip = level.boat.max_missiles;

	// set the m202 anims
	self rpg_turret_ai_set_anims();

	// set the idle pose and aiming anims
	transTime = 0.2;
	self SetAnimKnobAllRestart( animArray("straight_level"), %body, 1, transTime, 1 );

	self SetAnim( %aim_2, 1, transTime );
	self SetAnim( %aim_4, 1, transTime );
	self SetAnim( %aim_6, 1, transTime );
	self SetAnim( %aim_8, 1, transTime );

	self SetAnimKnobLimited( animArray("add_aim_up"   ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_down" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_left" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_right"), 1, transTime );

	self SetAnim( %add_idle );
	self thread animscripts\combat::idleThread();

	// only rotate when necessary
	self OrientMode("face current");

	// start aiming
	self animscripts\shared::trackLoopStart();

	player = get_players()[0];

	while(1)
	{
		if( IsDefined(self.enemy) )
		{
			// Force the shoot pos now
			self animscripts\shoot_behavior::setShootEnt( self.enemy );

			// Turn, if necessary
			yawDiff = AngleClamp180( self.angles[ 1 ] - VectorToAngles( self.shootPos - self.origin )[1] );
			if( abs( yawDiff ) > turnThreshold )
			{
				if( abs( yawDiff ) > turnSpeed )
				{
					yawDiff = turnSpeed * sign(yawDiff);
				}

				newAngle = self.angles[1] - yawDiff;
				self OrientMode( "face angle", newAngle );
			}

			// Check for a Shoot Command
			if( self player_commands_ai_to_fire(player) )
			{
				savedAimPos = level.player_aim_ent.origin;

				start_pos = self GetTagOrigin( "tag_flash" );

				/# 
				//recordEntText( "request shoot", self, (1,0,0), "Script");
				//recordLine( start_pos, level.player_aim_ent.origin, (1,0,0), "Script", self ); 
				#/

				// if it hasn't come around yet, just shoot where it's aiming now
				if( !aimedAtShootEntOrPos() )
				{
					forward = AnglesToForward( self GetTagAngles( "tag_weapon" ) );
					aim_pos = start_pos + vector_scale( forward, 500 );

					self.shootPos = aim_pos;
					level.player_aim_ent.origin = self.shootPos;

					/# 
					//recordEntText( "fake shoot", self, (1,1,0), "Script");
					//recordLine( start_pos, self.shootPos, (1,1,0), "Script", self ); 
					#/
				}

				self thread rpg_turret_ai_shoot_watch();

				// most of this is from FireUntilOutOfAmmo
				fireAnim = animArray( "fire", "combat" );

				self SetAnim( %add_fire, 1, .1, 1 );
				self SetFlaggedAnimKnobRestart( "fire", fireAnim, 1, .2, fireRate );

				self FireUntilOutOfAmmoInternal( "fire", fireAnim, true, 1 );

				self ClearAnim( %add_fire, .2 );

				//FireUntilOutOfAmmo( animArray( "fire", "combat" ), true, 1 );

				level.player_aim_ent.origin = savedAimPos;

				/#
				self animscripts\debug::debugPopState( "FireUntilOutOfAmmo" );
				//recordEntText( "done shooting", self, (1,0,0), "Script");
				#/
			}

			// reload, if necessary
			if( self.bulletsInClip <= 0 )
			{
				// Relaoding VO
				self play_reloading_vo();
			
				swap_missile_guy_on_boat( self );
			
				reloadAnim = animArrayPickRandom( "reload" );
				self SetAnim( %reload,1,.2 );
				self ClearAnim( %add_fire,0 );

				//self animscripts\combat::doReloadAnim( reloadAnim, false );

				self SetFlaggedAnimKnobAllRestart( "reload", reloadAnim, %root, 1, .2, reloadRate );
				self SetAnim( %exposed_aiming, 1, 0 ); // re-enable aiming since the knob part above kills it
				self animscripts\shared::DoNoteTracks( "reload" );

				self ClearAnim(%reload, 0.1);

				self.bulletsInClip = level.boat.max_missiles;
			}
		}

		wait(0.05);
	}
}


//*****************************************************************************
//*****************************************************************************

swap_missile_guy_on_boat( guy_out_of_missiles )
{
	if( guy_out_of_missiles == level.woods )
	{
		level.missile_ai_guy = "bowman";
	}
	else if( guy_out_of_missiles == level.bowman )
	{
		level.missile_ai_guy = "woods";
	}
	
	// Put a delay in firing when swapping characters
	delay_time = 200;	// 1000 = 1 second
	level.missile_pbr_delay_time = GetTime() + delay_time;
}


//*****************************************************************************
//*****************************************************************************

play_reloading_vo()
{
	// if the boss boat has been killed, no need to say this anymore
	if( flag( "boss_boat_killed" ) == true )
	{
		return;
	}


	//*************************
	// Choose some reloading VO
	//*************************

	reloading_vo_max = 5;
	if( !isdefined(self.reload_vo_index) )
	{
		self.reload_vo_index = randomint( reloading_vo_max );
		self.num_reload_calls = 0;
		level.vo_reloading_last_time = -10000;
	}
	
	time = GetTime();
	
	// If we've played the reload vo more than once, limit it
	if( self.num_reload_calls >= 1 )
	{
		// If we've just had a vo, so skip this background vo
		last_vo_time = (time - level.vo_reloading_last_time) / 1000;
		if( last_vo_time < 2 )
		{	
			return;
		}
		
		// If we've played the vo recently, no need to play again so soon
		last_vo_time = (time - level.vo_reloading_last_time) / 1000;
		if( last_vo_time < 12 )
		{	
			return;
		}
	}

	// WOODS Reloading VO
	if( self == level.woods )
	{
		if( self.reload_vo_index == 0 )
		{
			level.woods thread maps\river_vo::playVO_proper( "reloading", 0.1 );
		}
		else if( self.reload_vo_index == 1 )
		{
			level.woods thread maps\river_vo::playVO_proper( "reload", 0.1 );
		}
		else if( self.reload_vo_index == 2 )
		{
			level.woods thread maps\river_vo::playVO_proper( "wait_reloading", 0.1 );
		}
		else if( self.reload_vo_index == 3 )
		{
			level.woods thread maps\river_vo::playVO_proper( "im_out", 0.1 );
		}
		else
		{
			level.woods thread maps\river_vo::playVO_proper( "out_of_ammo", 0.1 );
		}
	}
	// BOWMAN Reloading VO
	else
	{
		if( self.reload_vo_index == 0 )
		{
			level.bowman thread maps\river_vo::playVO_proper( "reloading", 0.1 );
		}
		else if( self.reload_vo_index == 1 )
		{
			level.bowman thread maps\river_vo::playVO_proper( "need_more_ammo", 0.1 );
		}
		else if( self.reload_vo_index == 2 )
		{
			level.bowman thread maps\river_vo::playVO_proper( "gotta_reload", 0.1 );
		}
		else if( self.reload_vo_index == 3 )
		{
			level.bowman thread maps\river_vo::playVO_proper( "out_reloading", 0.1 );
		}
		else
		{
			level.bowman thread maps\river_vo::playVO_proper( "out", 0.1 );
		}
	}
	
	self.reload_vo_index++;
	if( self.reload_vo_index >= reloading_vo_max )
	{
		self.reload_vo_index = 0;
	}
	
	level.vo_reloading_last_time = time;
	self.num_reload_calls++;
}


//*****************************************************************************
//*****************************************************************************

rpg_turret_ai_set_anims()
{
	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array					= [];
	}

	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["straight_level"]			= %ai_m202_heat_stand_aim_5;
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["add_aim_up"]				= %ai_m202_heat_stand_aim_8;
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["add_aim_down"]				= %ai_m202_heat_stand_aim_2;
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["add_aim_left"]				= %ai_m202_heat_stand_aim_4;
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["add_aim_right"]			= %ai_m202_heat_stand_aim_6;  

	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["fire"]						= %ai_m202_heat_stand_fire;
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["single"]					= array( %ai_m202_heat_stand_fire );
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["reload"]					= array( %ai_m202_heat_stand_reload );
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["reload_crouchhide"]		= array();


	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["exposed_idle"]				= array( %ai_m202_heat_stand_idle, %ai_m202_heat_stand_twitch_a, %ai_m202_heat_stand_twitch_b );
	self.anim_array[self.animType]["combat"]["stand"]["rocketlauncher"]["exposed_idle_noncombat"]	= array( %ai_m202_heat_stand_idle_scan_a, %ai_m202_heat_stand_idle_scan_b );
	
	self animscripts\anims::setIdleAnimOverride( %ai_m202_heat_stand_aim_5 );
	//self.anim_array[self.animType]["stop"]["stand"]["rocketlauncher"]["idle"] 			= array( %ai_m202_heat_stand_idle );
	self.anim_array[self.animType]["stop"]["stand"]["rocketlauncher"]["idle_trans"] = %ai_m202_heat_stand_aim_5;
}


//*******************************************************************************
// self = AI Entity, wither Woods or Bowman
//*******************************************************************************
player_commands_ai_to_fire( player )
{
	//***************************************************
	// Is there a delay before the AI Character can fire?
	//***************************************************
	
	time = GetTime();
	if( level.missile_pbr_delay_time > time )
	{
		return( 0 );
	}


	//********************************
	// Is this entity allowed to fire?
	//********************************
	
	if( (level.missile_ai_guy == "woods") && (self != level.woods) )
	{
		return( 0 );
	}
	if( (level.missile_ai_guy == "bowman") && (self != level.bowman) )
	{
		return( 0 );
	}


	//**************************************************
	// self is allowed to fire, so check the fire button
	//**************************************************
	
	//SecondaryOffhandButtonPressed()
	//FragButtonPressed()
	
	//if( (player AdsButtonPressed()) && (player is_not_looking_at_friendly()) )
	if( (player ThrowButtonPressed()) && (player is_not_looking_at_friendly()) )
	{
		// We are allowing fire, if the Ai has no missiles left swap characters
		return( 1 );
	}
		
	return( 0 );
}


//*******************************************************************************
// self = player. Used to prevent firing at friendly units, drones, and vehicles
//*******************************************************************************
is_not_looking_at_friendly()
{
	// cannot fire if looking at player's own boat
	// NOTE: This currently does not work. Code disables play look at his own boat,
	// and this is unlikely to change without breaking everything.
	if( self IsLookingAt( level.boat ) )
	{
		return false;
	}
	
	// cannot fire on friendly drones
	drones = GetEntArray( "drone", "targetname" );
	for( i = 0; i < drones.size; i++ )
	{
		if( drones[i].team == "allies" && self IsLookingAt( drones[i] ) )
		{
			return false;
		}
	}
	
	// cannot fire on friendly vehicles
	all_vehicles = level.vehicles[ "allies" ];
	for( i = 0; i < all_vehicles.size; i++ )
	{
		if( isdefined( all_vehicles[i] ) && isdefined( all_vehicles[i].vehicletype ) )
		{
			if( ( all_vehicles[i].vehicletype == "boat_pbr" || all_vehicles[i].vehicletype == "boat_heli_huey_heavyhogpbr" ||
						all_vehicles[i].vehicletype == "truck_eve" ) && self IsLookingAt( all_vehicles[i] ) )
			{
				return false;
			}
		}
	}
	
	return true;
}


//*******************************************************************************
// self = Woods or Bowman, the guyso n the boat firing rockets
//*******************************************************************************

rpg_turret_ai_shoot_watch()
{
	self endon("death");

	self waittill("shoot");

	player = get_players()[0];

	// Use "huey_rockets" weapon fire as an override for now
	player playsound( "wpn_river_artillery_fire" );

	//player PlayRumbleOnEntity("grenade_rumble");
	player PlayRumbleOnEntity("tank_fire");

	Earthquake( 0.35, 0.3, player.origin, 500 );	// power, time, origin, radius

	self.num_missiles_fired++;
}


//*******************************************************************************
// self = boat
//
// Position the entity ahead of the boat in the direction the boats gun is aiming
//*******************************************************************************
player_aim_entity_update()
{
	self endon( "death" );
	self endon( "stop_player_aim_entity_update" );

	// if level.player_aim_ent doesn't exist, create it
	if( !IsDefined( level.player_aim_ent ) ) 
	{
		level.player_aim_ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	}

	player = get_players()[0];
	
	kid = GetEnt( "bow_gun_redshirt_ai", "targetname" );
	
	while( !IsDefined( kid ) )
	{
		kid = GetEnt( "bow_gun_redshirt_ai", "targetname" );	
		wait( 1 );
	}

	while( 1 )
	{
		angles = player getplayerangles();

		// Limit the players firing angle so that they don't shoot their own boat
		xang = angles[0];
		if( xang > 4 )
		{
			xang = 4;
		}

		angles = ( xang, angles[1], angles[2] );
		forward = anglestoforward( angles );

		forward_vector = vector_scale(forward, 5000);
			
		start_pos = player geteye();
		
		aim_pos = start_pos + forward_vector;

		aim_tracer = BulletTrace( start_pos, aim_pos, true, player );
		
		if( ( IsDefined( aim_tracer[ "entity" ] ) ) && ( aim_tracer[ "entity" ] == kid ) )
		{
			aim_tracer = BulletTrace( aim_tracer[ "position" ], aim_pos, true, kid );
		}
		
		aim_pos = aim_tracer["position"];
		
		level.player_aim_ent.origin = aim_pos;
			
		wait( 0.01 );
	}
}


//*****************************************************************************
// self = player Boat
//
// btr60_grenade_gunner, tag_gunner_barrel4
// left_launcher = self GetTagOrigin("tag_rocket_left") + (AnglesToForward(self.angles) * scale_forward) + (AnglesToRight(self.angles) * scale_forward * -1);
//*****************************************************************************

dont_turn()
{
	self endon("death");
	self endon("stop_dont_turn");

	while(1)
	{
		// stop turning immediately
		self notify( "can_stop_turning" );
		self notify( "turn", "end" );

		wait(0.05);
	}
}

//#using_animtree ("generic_human")
PBR_grenade_launcher()
{
	self PRB_init_missiles();
}


//*****************************************************************************
// self = player boat
//*****************************************************************************

PRB_init_missiles()
{
	self.max_missiles = 4;
	level.woods.num_missiles_fired = 0;
	level.bowman.num_missiles_fired = 0;
}


//*****************************************************************************
//*****************************************************************************

helicopters_fly_in_and_destroy_bridge()
{
	fly_in_distance = 8000;
	
	flag_wait( "helicopters_destroy_bridge" );
	
	level thread move_boats_with_player( undefined, undefined, 1000, 2000, -1200, true );
	bridge = GetEnt( "bridge_blocker_helicopters", "targetname" );
	AssertEx( IsDefined( bridge ), "bridge is missing for helicopters_fly_in_and_destroy_bridge!" );
	
	lookat_bridge_trigger = GetEnt( "lookat_bridge_trigger", "targetname" );
	AssertEx( IsDefined( lookat_bridge_trigger ), "lookat_bridge_trigger is missing in helicopters_fly_in_and_destroy_bridge!" );
	
	lookat_bridge_trigger waittill( "trigger" );
	lookat_bridge_trigger Delete();  // don't need it again. just triggers helicopter flyin
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 27 );	 // old = 12
	huey1 = GetEnt("boat_drive_helicopter_1", "targetname");
	huey2 = GetEnt("boat_drive_helicopter_2", "targetname");
//	truck1 = GetEnt("american_convoy_truck_1", "targetname");
//	truck2 = GetEnt("american_convoy_truck_2", "targetname");
	
	
//	for( i = 0; i < 12; i++ )
//	{
//		simple_spawn_single( "helicopter_bridge_guy_east", maps\river_util::NVA_go_to_target, true );
//		wait( 0.1 );
//	}

	west_target = GetEnt("helicopter_missile_target_3", "targetname");
	island_target = GetEnt("helicopter_missile_target_1", "targetname");
	shore_target = GetEnt("helicopter_missile_target_2", "targetname");
	bridge_west = GetEnt( "helicopter_bridge_shot_point_2", "targetname" );
	bridge_east = GetEnt( "helicopter_bridge_shot_point_1", "targetname" );
	huey1 thread maps\river_util::helicopter_fires_rockets_at_target("fire_rockets_at_bridge", bridge_west, undefined, 1 );
	huey2 thread maps\river_util::helicopter_fires_rockets_at_target("fire_rockets_at_bridge", bridge_east, undefined, 1 );
	huey1 thread maps\river_util::helicopter_fires_rockets_at_target("fire_first_volley", shore_target, undefined, 1 );
//	huey2 thread maps\river_util::helicopter_fires_rockets_at_target("fire_first_volley", shore_target);
	huey1 thread maps\river_util::helicopter_fires_rockets_at_target("fire_missiles1", island_target, undefined, 1);
//	huey1 thread maps\river_util::helicopter_fires_rockets_at_target("fire_missiles2", west_target);
//	huey2 thread maps\river_util::helicopter_fires_rockets_at_target("fire_missiles", shore_target);
	
//	bridge_destruction_trigger = GetEnt( "helicopter_bridge_destruction_trigger", "targetname" );
//	bridge_destruction_trigger waittill( "trigger" );

	wait( 8.5 );
	
	level.bowman thread maps\river_vo::playVO_proper( "yeah", 0.2 );
	
	struct_200 = getstruct( "helicopter_bridge_explosion_200_struct", "targetname" );
	struct_201 = getstruct( "helicopter_bridge_explosion_201_struct", "targetname" );
	struct_202 = getstruct( "helicopter_bridge_explosion_202_struct", "targetname" );
	physics_struct = getstruct( "helicopter_bridge_physics explosion_struct", "targetname" );
	AssertEx( ( ( IsDefined(struct_200 ) ) || ( IsDefined( struct_201 ) ) || ( IsDefined( struct_202 ) ) ), "one of the helicopter bridge explision structs are missing" );
	AssertEx( IsDefined( physics_struct ), "physics_struct is missing" );

	bridge_clip = GetEnt( "helicopter_bridge_clip", "targetname" );
//	PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], bridge_clip.origin );
	bridge_clip Delete();
	
	dynent_spawn_points = [];
	dynent_spawn_points[ 0 ] = struct_200;
	dynent_spawn_points[ 1 ] = struct_201;
	dynent_spawn_points[ 2 ] = struct_202;
	
//	level thread dyn_ent_group( 25, dynent_spawn_points, "phys_floats_p_jun_wood_plank_large02",
//															"phys_floats_p_jun_wood_plank_small02",
//															"phys_floats_p_glo_corrugated_metal1",
//															 "phys_floats_p_glo_wood_crate_sml" );
	
	//exploder( 200 );
	PlayFX( level._effect[ "woodbridge_explosion" ], struct_200.origin, AnglesToForward( struct_200.angles ) );
	
	// Play the kaboom
	PlaySoundAtPosition("evt_bridge_lg_explo" , struct_200.origin);
	exploder( 1 );
	
	//PlayFX( level._effect[ "woodbridge_splash" ], struct_200.origin );
	
	wait( 0.3 );
	//PhysicsExplosionSphere( physics_struct.origin, 500, 499, 1.5 );
//	guys = GetEntArray( "helicopter_bridge_guy_east_ai", "targetname" );
//	for( i = 0; i < guys.size; i++ )
//	{
//		x = RandomIntRange( 300, 400 );
//		guys[ i ] StartRagdoll();
//		guys[ i ] Launchragdoll( x * VectorNormalize( guys[ i ].origin - physics_struct.origin ) );
//		guys[ i ] starttanning();
//		guys[ i ] DoDamage( 2000, guys[ i ].origin );
//		//PhysicsExplosionSphere( guys[ i ].origin, 32, 30, 6 );
//		
//		//guys[ i ] kill_me();
////		PlayFXOnTag( level._effect[ "temp_destructible_building_fire_medium" ], guys[ i ], "tag_eye" );
//	}
	
	//exploder( 202 );
	//PlayFX( level._effect[ "woodbridge_explosion" ], struct_202.origin, AnglesToForward( struct_202.angles ) );
	
	// Play the kaboom
	PlaySoundAtPosition("evt_big_explof", struct_202.origin);
	//IPrintLnBold("DAM EXPLO");
	
	//PlayFX( level._effect[ "woodbridge_splash" ], struct_202.origin );
	
	
	wait( 0.2 );
	//exploder( 201 );
	//PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], struct_201.origin );
//	PlayFX( level._effect[ "woodbridge_splash" ], struct_201.origin );
	
	bridge = GetEnt( "bridge_blocker_helicopters", "targetname" );
//	PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], bridge.origin );
	bridge Delete();
	
	flag_set( "helicopter_bridge_destroyed" );
	
	trigger = GetEnt( "initial_bridge_destroyed_trigger", "targetname" );	
	AssertEx( IsDefined( trigger ), "trigger is missing for helicopters_fly_in_and_destroy_bridge" );

	level thread tower_spawner_setup( "initial_bridge_destroyed_trigger", "tower2_guys", 2 );	
	
	wait( 0.25 );
	
	trigger notify( "trigger" );
	
	american_forces_move_into_NVA_base();
}


/*==========================================================================
FUNCTION: bridge_hint_dialogue
SELF: level
PURPOSE: provide some hint lines to play to direct players better

ADDITIONS NEEDED: -make this a general function that takes in:
						- hint dialogue lines
						- time between lines
						- if you want to play off a trigger; if so, what trigger
						- if there's no trigger, how often you want hints to play (range)
==========================================================================*/
bridge_hint_dialogue()
{
	level endon( "helicopter_bridge_destroyed" );
	
	bridge_destruction_trigger = GetEnt( "helicopter_bridge_destruction_trigger", "targetname" );
	AssertEx( IsDefined( bridge_destruction_trigger ), "bridge_destruction_trigger is missing in bridge_hint_dialogue" );
	
	dialogue = [];
	dialogue[ dialogue.size ] = "That's a reinforced blockade, Mason. We need AirCav support to destroy it!";
	dialogue[ dialogue.size ] = "Don't even try it, Mason. Let AirCav do its job.";
	dialogue[ dialogue.size ] = "Our weapons aren't powerful enough to punch through that armor. We need gunship support!";
	dialogue[ dialogue.size ] = "Quit wasting your missiles. We'll never be able to take out that bridge with our weapons.";
	
	last_dialogue_line_played = 0;
	
	current_line = 9999;
	last_line_played = 9999;  // arbitrary number outside the number of dialogue lines
	
	last_time_played = 0;  
	Line_frequency_s = 10;
	Line_frequency = Line_frequency_s * 1000; // convert to ms for GetTime
	
	while( true )
	{
		bridge_destruction_trigger waittill( "trigger" );	
		
		current_time = GetTime();
		
		if( ( current_time - last_time_played ) > Line_frequency )
		{
			while( current_line == last_line_played )
			{
				current_line = RandomInt( dialogue.size );
			}
			
			level thread add_dialogue_line( "Woods", dialogue[ current_line ] );
			last_time_played = GetTime();
			last_line_played = current_line;
		}
		else
		{
			wait( 0.1 );
		}
	}
}

/*==========================================================================
FUNCTION: dyn_ent_group
SELF: level
PURPOSE: create a bunch of dyn ents to float in the water
	*** models must be precached before use ***

ADDITIONS NEEDED:
==========================================================================*/
dyn_ent_group( dynent_count, Spawnpoints, modelname1, modelname2, modelname3, modelname4, modelname5 )
{ 
	if( ( dynent_count == 0 ) || !IsDefined( dynent_count ) )
	{
		return;
	}
	
	if( !IsDefined( modelname1 ) )
	{
		maps\river_util::Print_debug_message( "need at least one modelname for dyn_ent_group function to work" , true );
		return;
	}
	
	model_array = [];
	model_array[ model_array.size ] = modelname1;
	
	if( IsDefined( modelname2 ) )
	{
		model_array[ model_array.size ] = modelname2;
	}
	
	if( IsDefined( modelname3 ) )
	{
		model_array[ model_array.size ] = modelname3;
	}
	
	if( IsDefined( modelname4 ) )
	{
		model_array[ model_array.size ] = modelname4;
	}
	
	if( IsDefined( modelname5 ) )
	{
		model_array[ model_array.size ] = modelname5;
	}
	
	if( !IsArray( Spawnpoints ) )
	{
		dynent_spawn_points = [];
		dynent_spawn_points[ dynent_spawn_points.size ] = Spawnpoints;
	}
	else
	{
		dynent_spawn_points = [];
		dynent_spawn_points = Spawnpoints;
	}
	
	for( i = 0; i < dynent_count; i++ )
	{		
		model = random( model_array );
		pos = random( dynent_spawn_points ).origin;
		angles = random( dynent_spawn_points ).angles;
		hitpos = random( dynent_spawn_points ).origin;
		force = ( 1, 1, 1 );
		CreateDynEntAndLaunch( model, pos, angles, hitpos, force );  // level.boat.origin - random( dynent_spawn_points ).origin
	}
}

kill_me()  // self = ai
{
	self die();
}


// shoot_at_target_untill_dead(target, tag, fireDelay)  // 2,3 = optional
// setentitytarget( entity, threat, tag_name) // 2,3 = optional
generic_shore_guys_function()  // self = AI in boat_drive beat
{
	self endon("death");
	
	if( ( self.classname == "actor_VC_e_AK47" ) || ( self.classname == "actor_VC_e_AK74u" ) )
	{
		//self.weapon = "creek_big_flash_ak47_sp";
		self.accuracy = 0.50;
		//self.overrideActorDamage = maps\river_util::reduce_vehicle_damage;
	}
	else if( ( self.classname == "actor_VC_e_RIVER_RPG_AK47" ) || ( self.classname == "actor_VC_e_RIVER_RPG_AK74u" ) ) // most likely RPG
	{
		// Give the RPG guys a bunch of rockets
		if( IsDefined( self.a.rockets ) )
		{
			self.a.rockets = 200;
		}
		self set_ignoreme( true ); // so friendly AI infantry don't fire on enemies with RPGs
		self thread maps\river_util::RPG_fire_prediction( undefined, undefined, undefined, true, undefined, 21, 100 );	
		self.overrideActorDamage = maps\river_util::actor_player_damage_only;
	}
	
	self.health = 1;
	self.goalradius = 64;
	
	if(IsDefined(self.target))
	{		
		goal = GetNode(self.target, "targetname");
		//self set_pacifist(true);	
		
		self SetGoalNode( goal );
		self waittill("goal");
		
		//self set_pacifist(false);
	}
	else
	{
		// act normal
	}
	
	self SetEntityTarget(level.boat, 1, "tag_driver" );
}

tower_guy_function()  // self = guy in destructible tower
{
	clip_brush = GetEnt(self.targetname + "_clip_brush", "targetname");  // get clip brush for delete
	AssertEx(IsDefined(clip_brush), "clip brush for tower guy is missing");
	
	self waittill("death");
	
	clip_brush Delete();
}

vehicle_stop_on_notify( notify_to_wait_for )
{
	if( !IsDefined( notify_to_wait_for ) )
	{
		maps\river_util::Print_debug_message( "notify_to_wait_for is missing in vehicle_stop_on_notify", true );
		return;
	}
	
	self waittill( notify_to_wait_for );
	
	self SetSpeedImmediate( 0, 10 );
}

AA_gun_encounter()
{
	level endon( "boat_drive_done" );
	
	delaythread( 1, ::boats_resume_pathing );
	
	level thread move_boats_with_player( undefined, undefined, 2000, 1000, -1200, true );

	level thread tower_spawner_setup( undefined, "tower3_guys", 3 );  // "post_bridge_rpg_fallback_trigger"

	boat = GetEnt( "friendly_boat_1", "script_noteworthy" );
	boat.health = 1000;
	boat.takedamage = true;		

	// make AA guns matter for achievement

	trigger = GetEnt("post_bridge_rpg_fallback_trigger", "targetname");
	trigger waittill("trigger");
	
	level thread tower_3_4_5_spawner();
	
	level thread vo_young_kid_aa_encounter();

	// guys are being cleaned up at the end of the missile launcher engagement; no need to do this again after we've just spawned more
//	enemies = GetAIArray( "axis" );
//	array_thread( enemies, maps\river_util::kill_me );
	
	AA_gun_guys = simple_spawn( "split_bridge_west_bank_guys" );
	for( i = 0; i < AA_gun_guys.size; i++ )
	{
		if( AA_gun_guys[ i ].classname == "actor_VC_e_RIVER_RPG_AK47" )
		{ 
			AA_gun_guys[ i ] thread maps\river_util::RPG_fire_prediction( 7000, 0.5, 1.1, undefined, undefined, 0, 20, boat );

		}
		else
		{
			if( IsDefined( boat ) )
			{
				AA_gun_guys[ i ] thread shoot_at_target_untill_dead( boat );
			}
		}
		
		AA_gun_guys[ i ].accuracy = 10;
	}	
	
	cleanup_helicopter_bridge_area();
	
	level thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 13 );	
	
	wait( 0.1 );
	
	
	quad50_1 = GetEnt( "boat_drive_left_path_quad50", "targetname" );
	quad50_1.takedamage = false;  // don't kill quad50_1 until friendly boat is dead
	quad50_1.left_light = add_mortar_light( quad50_1, "tag_headlight_left" );
	quad50_1.right_light = add_mortar_light( quad50_1, "tag_headlight_right" );
	level thread maps\river_util::flag_wait_then_func( "boat3_pass_player_dual_towers", ::move_boats_with_player, undefined, undefined, undefined, undefined, 1200, true );

	boat thread foreshadow_death( quad50_1 );	

	quad50_1 waittill( "open_fire" );

	// As ZPU emerges	
	level.woods thread maps\river_vo::playVO_proper( "fuck_zpu_to_the_left", 0 );
	level.reznov thread maps\river_vo::playVO_proper( "mason_what_are_you_waiting", 2.2 );
	
	boat notify( "start_death_sequence" );

	flag_set( "AA_gun_objective_started" );	
	
	quad50_1 maps\river_util::vehicle_static_line_fire( 0, level.boat.origin, boat.origin, 1 );
	quad50_1 thread maps\river_util::quad50_fires_guns( boat );

//	quad50_2 thread maps\river_util::quad50_fires_guns( level.boat, "open_fire" );
	

//	quad50_3 thread maps\river_util::quad50_fires_guns( level.boat, "open_fire" );

	boat waittill( "death" );
	
	level thread boat_driver_cleanup();
	
	delaythread( 1, ::boats_resume_pathing );
	
	level thread maps\river_jungle::trigger_radius_damage( "first_AA_gun_helicopters_large_building", 99999, 500, true, "helicopter_AA_gun_big_house_struct" );
	
//	if( IsDefined( AA_gun_guys ) && ( AA_gun_guys.size > 0 ) )
//	{
//		array_notify( AA_gun_guys, "stop_firing" );
//		array_thread( AA_gun_guys, maps\river_util::RPG_fire_prediction );
//	}
	
	//PlayFXOnTag( level._effect[ "friendly_boat_death" ], boat, "tag_origin" );

	
	// temp fix for physics problem on death launch 6/18/2010 - TJanssen
//	crew = GetEntArray( "friendly_pbr_crew_1_ai", "targetname" );
//	for (i = 0; i < crew.size; i++ )
//	{
//		scale = RandomIntRange( 150, 200 );
//		crew[ i ] Unlink();
//		crew[ i ] StopAnimScripted();
//		crew[ i ].isonvehicle = false;
//		crew[ i ] StartRagdoll();
//		crew[ i ] Launchragdoll( scale * VectorNormalize( crew[ i ].origin - ( boat.origin + ( 0, 0, -200 ) ) ) );
//		crew[ i ].takedamage = true;
//		crew[ i ] DoDamage( crew[ i ].health + 1, crew[ i ].origin );
//	}
	
	quad50_1.takedamage = true;
	if( IsDefined( quad50_1 ) )
	{
		quad50_1 notify( "stop_firing" );
//		quad50_1 ResumeSpeed( 30 );
//		wait( 1.0 );
		quad50_1 thread maps\river_util::quad50_fires_guns( level.boat );
	}
	
	// By now we can delete the mortar vehicles as an optimization
	cleanup_mortor_vehicles();
		
	// Quad50 VO
	level thread maps\river_vo::vo_aa_guns();	
		
	quad50_1 waittill( "death" );
	
	level thread move_boats_with_player( undefined, undefined, undefined, -1000, -2000, true );
	
	wait( 2.5 );
	
	level thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 32 );
	
	wait( 0.1 );
	
	huey1 = GetEnt( "helicopter_AA_gun_1", "targetname" );
	huey2 = GetEnt( "helicopter_AA_gun_2", "targetname" );
	AssertEx( IsDefined( huey1 ), "huey1 is missing in AA_gun_encounter" );
	huey1.takedamage = false;
	quad50_3 = GetEnt( "quad50_3", "targetname" );
	//huey1 thread maps\river_util::helicopter_fires_rockets_at_target("open_fire", quad50_3 );
//	huey1_start_point = getstruct( "huey_AA_gun_1_line_fire_1_start", "targetname" );
//	huey1_end_point = getstruct( "huey_AA_gun_1_line_fire_1_end", "targetname" );
//	huey1_start_point_2 = getstruct( "huey1_fire_at_AA_gun_start", "targetname" );
//	huey1_end_point_2 = getstruct( "huey1_fire_at_AA_gun_end", "targetname" );
//	
//	huey1 thread maps\river_util::vehicle_line_fire( 0, huey1_start_point.origin, huey1_end_point.origin, 12, "chainguns_open_fire" );
//	huey1 thread maps\river_util::vehicle_line_fire( 1, huey1_start_point_2.origin, huey1_end_point_2.origin, 10, "fire_at_AA_gun" );
//	
//	huey2_start_point = getstruct( "huey_AA_gun_2_line_fire_1_start", "targetname" );
//	huey2_end_point = getstruct( "huey_AA_gun_2_line_fire_1_end", "targetname" );
//	huey2_start_point_2 = getstruct( "huey2_fire_at_AA_gun_start", "targetname" );
//	huey2_end_point_2 = getstruct( "huey2_fire_at_AA_gun_end", "targetname" );
//	
//	huey2 thread maps\river_util::vehicle_line_fire( 0, huey2_start_point.origin, huey2_end_point.origin, 12, "chainguns_open_fire" );
//	huey2 thread maps\river_util::vehicle_line_fire( 1, huey2_start_point_2.origin, huey2_end_point_2.origin, 10, "fire_at_AA_gun" );
//	

	huey1 thread vehicle_shootat_target( 1, 1 );
	huey2 thread vehicle_shootat_target( 2 );

//	huey1 waittill( "done_line_firing" );
//	
//	quad50_2 = GetEnt( "quad50_2", "targetname" );
//	quad50_2_start = getstruct( "AA_gun_2_fires_at_huey1_start", "targetname" );
//	quad50_2_end = getstruct( "AA_gun_2_fires_at_huey1_end", "targetname" );

	quad50_2 = GetEnt( "quad50_2", "targetname" );
	quad50_2 thread maps\river_util::set_flag_on_death( "quad50_2_dead" );
	quad50_2.left_light = add_mortar_light( quad50_2, "tag_headlight_left" );
	quad50_2.right_light = add_mortar_light( quad50_2, "tag_headlight_right" );
	

//	quad50_2.takedamage = false;
//	quad50_2 maps\river_util::vehicle_line_fire( 0, quad50_2_start.origin, quad50_2_end.origin, 5, undefined );
//	quad50_2.takedamage = true;
//	level notify( "quad50_2_aim_at_player" );


	// Drones running to and over the woodenbridge
	level thread maps\river_features::run_to_bridge_drones_drones_start();
	level thread maps\river_features::bridge_drones_start();
	level thread maps\river_features::aa_gun2_friendly_drones_start();

	level thread third_AA_gun_encounter();  // this is threaded so sampans come in at the correct time
}


//driver not deleting for some reason -jc
boat_driver_cleanup()
{
	
	boat_driver = GetEnt( "driver_friendly_boat_1", "targetname" ); 
	if( IsDefined( boat_driver) )
	{
		PlayFXOnTag( level._effect[ "fx_river_fire_lg" ], boat_driver, "tag_origin" );
		wait 2; 
		boat_driver Delete();
	}	
}


// bug fix function - boats would sometimes just miss notifies randomly or something, so reset pathing here.
boats_resume_pathing()
{
	level.friendly_boats = remove_dead_from_array( level.friendly_boats );
	
	wait( 0.5 );
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		level.friendly_boats[ i ] ent_flag_set( "can_move" );
		
		wait( 0.1 );
		
		level.friendly_boats[ i ] ent_flag_clear( "ignore_speed_check" );
		
		wait( 0.1 );
	}
}


tower_3_4_5_spawner()
{
	level thread tower_spawner_setup( "first_turn_land_house_trigger", "tower4_guys", 4 );
	level thread tower_spawner_setup( "first_turn_land_house_trigger", "tower5_guys", 5 );
}

tower_spawner_setup( trigger_name, spawner_name, tower_num )
{
	level endon( "boss_boat_killed" );
	
	if( !IsDefined( tower_num ) )
	{
		tower_num = 1337;
	}
	
	spawners = GetEntArray( spawner_name, "targetname" );
	if( spawners.size == 0 )
	{
		PrintLn( "tower " + tower_num + " is missing guys!" );
		return;
	}	
	
	if( IsDefined( trigger_name ) )
	{	
		trigger = GetEnt( trigger_name, "targetname" );
		if( !IsDefined( trigger ) )
		{
			PrintLn( "tower " + tower_num + " is missing a trigger!" );
			return;
		}
		
		trigger waittill( "trigger" );	
	}

	tower_name = "tower_" + tower_num + "_clip";
	clip = GetEnt( tower_name, "targetname" );
	if( IsDefined( clip ) )
	{	
		simple_spawn( spawners );
	}
	else 
	{
		PrintLn( "tower " + tower_num + " was killed before it could spawn guys" );
	}
}

//*****************************************************************************
//*****************************************************************************

vo_young_kid_aa_encounter()
{
	// Young kid spots the 2nd tower
	maps\river_vo::vo_targatname( "bow_gun_redshirt_ai", "another_tower", 0, undefined );
	
	level waittill( "quad50_2_moves" );
	wait( 1.5 );
	maps\river_vo::vo_targatname( "bow_gun_redshirt_ai", "sergent_another_zpu", 0, undefined );
}


//*****************************************************************************
// self = boat
//*****************************************************************************

foreshadow_death( attacker )
{	
	//self waittill( "start_death_sequence" );
	total_damage = 0;
	
	while( total_damage < 100 )
	{
		self waittill( "damage", amount, who, direction, point, type, modelName, tagName );
				
		if( type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
		{
//			amount = 1000;
		}
		
		total_damage = total_damage + amount;
	}
	
	
	player = get_players()[0];
	
	playfxOnTag( level._effect[ "temp_destructible_building_fire_medium" ], self, "tag_passenger12" );		// med right in/mid
	playfxOnTag( level._effect[ "temp_destructible_building_fire_large" ], self, "tag_passenger13" );		// med left in/mid
	
	self ClearVehGoalPos();
			
	// Create a physics force
	force = ( 620, 8, 372 );
	hitpos = ( 76, 2, 18 );
	relative = true;
	destabalize = true;
	self LaunchVehicle( force, hitpos, true, true );

	player playsound( "exp_shell_hit_boat" );
	self Detach( "t5_veh_boat_pbr_waterbox", "tag_origin_animate" );	
	
	wait( 0.9 );
	
	playfxOnTag( level._effect[ "temp_destructible_building_fire_large" ], self, "tag_passenger3" );		// high right in/hi
	playfxOnTag( level._effect[ "temp_destructible_building_fire_medium" ], self, "tag_passenger5" );		// med left out/med

	player playsound( "exp_shell_hit_boat" );

//	if( IsDefined( self.attachedguys ) )
//	{
//		for( j = 0; j < self.attachedguys.size; j++ )
//		{
//			self.attachedguys[ j ] Delete();
//		}
//	}
	
	self thread sink_boat();
}


//*****************************************************************************
// self = boat
//*****************************************************************************

sink_boat()
{
	wait( 0.02 );	// 0.2
	
//	IPrintLnBold("SINKING BOAT");

	buoyancy_scale = 1.0;

	dec = 0.0021;	// 0.0025
	delay = 0.1;

	self SetSpeedImmediate( 0, 30 );

	for( i=0; i<40; i++ )
	{
		buoyancy_scale -= dec;
		if( buoyancy_scale < 0.9 )
		{
			buoyancy_scale = 0.9;
		}

		if( i == 5 )
		{
			PlayFXOnTag( level._effect[ "quad50_temp_death_effect" ], self, "tag_origin" );
		}

		// Create a physics force
		if( i == 20 )
		{
			force = ( 620/2, 8/2, 372/2 );
			hitpos = ( -76, 2, 18 );
			self LaunchVehicle( force, hitpos, true, true );
			level.player playsound( "exp_shell_hit_boat" );
		}

		self scalebuoyancy( buoyancy_scale );
	
		wait( delay );
	}

	wait( 4.5 );		// 2.5
		
//	IPrintLnBold("DELETING BOAT");

	self delete();
}



third_AA_gun_encounter()
{
	level thread helicopter_destruction_set_piece();
	
	quad50_3 = GetEnt( "quad50_3", "targetname" );
	quad50_3.left_light = add_mortar_light( quad50_3, "tag_headlight_left" );
	quad50_3.right_light = add_mortar_light( quad50_3, "tag_headlight_right" );
	
	quad50_3 thread maps\river::notification_on_death( "quad50_3_dead" );	
	
	trigger = GetEnt("quad50_3_trigger", "targetname");  // used to have level notify "quad50_3_moves" on it
	AssertEx( IsDefined( trigger ), "trigger is missing in third_AA_gun_encounter" );
	trigger waittill( "trigger" );
	
	level notify( "quad50_3_moves" );
	
	level waittill( "quad50_3_dead" );
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 40 );
//	quad50_3 thread maps\river_util::quad50_fires_guns( level.boat, "wait_here", true, "quad50_3_moves" );	
}

helicopter_destruction_set_piece()
{
	// trigger_radius_damage( trigger_name, damage, radius, to_delete, offset_struct_name )
	level thread maps\river_jungle::trigger_radius_damage( "helicopter_AA_gun_3_trigger", 99999999, 600, false, "helicopter_AA_gun_3_tree_struct" );
	
	trigger = GetEnt( "helicopter_AA_gun_3_trigger", "targetname" );
	if( !IsDefined( trigger ) )
	{
		PrintLn( "trigger is missing for helicopter_destruction_set_piece" );
		return;
	}
	
	struct = getstruct( "helicopter_AA_gun_3_struct", "targetname" );
	if( !IsDefined( struct ) )
	{
		PrintLn( "struct is missing for helicopter_destruction_set_piece" );
		return;
	}
	
	trigger waittill( "trigger" );
	
	level thread maps\river_util::PlayFxTimed( level._effect["quad50_temp_death_effect"], struct.origin, 3 );
}

// self = vehicle
Delete_at_end_of_spline()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	wait( 1 );
	self Delete();
	
}

fuel_depot_truck()
{
	level endon( "boat_drive_done" );	
	
	add_spawn_function_veh("fuel_depot_truck", maps\river_util::vehicle_setup);
	add_spawn_function_veh("fuel_depot_truck_2", maps\river_util::vehicle_setup);
	
	trigger = GetEnt("fuel_depot_guys_b_trigger", "targetname");
	AssertEx(IsDefined(trigger), "trigger for fuel_depot_truck is missing");
	trigger waittill("trigger");
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );	
}

quad_50_before_fuel_depot()
{
	level endon( "boat_drive_done" );	
		
	add_spawn_function_veh("s_curve_bombed_truck", maps\river_util::vehicle_setup);
	
	trigger = GetEnt("s_curve_bend_3_trigger", "targetname");
	trigger waittill("trigger");
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 5 );	

}

// script_vehiclespawngroup = 2
first_turn_sampans_arrive()
{
	level endon( "boat_drive_done" );	
	
	start_trigger = GetEnt("first_turn_land_house_trigger", "targetname");
	AssertEx(IsDefined(start_trigger), "start_trigger is not defined in first_turn_sampans_arrive boat_drive beat");
	start_trigger waittill("trigger");	
	
	for(i=1; i<5; i++)  // 4 sampans
	{
		add_spawn_function_veh("first_turn_sampan_" + i, maps\river_util::vehicle_setup);
	}
	
//	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 2 );
}

// script_vehiclespawngroup = 3
first_sampan_encounter()
{
	level endon( "boat_drive_done" );
	
	start_trigger = GetEnt("s_curve_bend_2_trigger", "targetname");
	AssertEx(IsDefined(start_trigger), "start_trigger is missing in first_sampan_encounter function in boat_drive beat");
	start_trigger waittill("trigger");
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 3 );	
	
	wait( 0.1 );
	
	// 2nd wave sampan VO
	level thread maps\river_vo::vo_second_sampans_wave();
	flag_set( "bunker_ZPU_objectives_start" );
	
	sampan_1 = GetEnt( "s_turn_bend_2_sampan_1", "targetname" ); 
	sampan_2 = GetEnt( "s_turn_bend_2_sampan_2", "targetname" );
	sampan_1 thread maps\river_fx::sampan_spotlight();
	sampan_2 thread maps\river_fx::sampan_spotlight();
	
	wait( 0.1 );
	
	//add_spawn_function_veh("truck_with_gun_north", maps\river_util::vehicle_setup);
	Single50_truck = GetEnt( "truck_with_gun_north", "targetname" );
	Single50_truck.left_light = add_mortar_light( Single50_truck, "tag_headlight_left" );
	Single50_truck.right_light = add_mortar_light( Single50_truck, "tag_headlight_right" );
	
	AssertEx( IsDefined( Single50_truck ), "Single50_truck is missing" );
	//Single50_truck thread maps\river_util::vehicle_gunner_fire( 0, level.boat );
	single50_truck thread maps\river_util::quad50_fires_guns( level.boat );
	Single50_truck thread flag_set_on_death( "ZPU_dead" );
	
	wait( 0.1 );
	
	// thread this so boss boat stuff will progress properly if player tries to skip something
	level thread MG_bunker_fires( "split_bridge_island_mg", level.boat, 6500, "single50_dead" );	// 5500
	level thread MG_bunker_damage_states();
	level thread ZPU_encounter(); 
}

ZPU_encounter()
{
	flag_wait( "ZPU_dead" );
	
	// in case you need this later... turn off ZPU firing with notify( "stop_firing" )
	
	level.mason thread maps\river_vo::playVO_proper( "thats_gotta_be_the_last", 0.1 );
	Single50_truck = GetEnt( "truck_with_gun_north", "targetname" );
	Single50_truck.left_light delete();
	Single50_truck.right_light delete();	
}

/*==========================================================================
FUNCTION: spotlight_think
SELF: spotlight ent (script_origin for now)
PURPOSE: when player is within engagement distance of a spotlight's AI, it 
	focuses on the player's boat. when it's outside that distance, it scans
	the area in a 90 degree cone

ADDITIONS NEEDED:
==========================================================================*/
spotlight_think( spotlight_name, focus_target, focus_distance, ender )  // self = spotlight ent
{	
	self endon( "death" );
	
	if( !IsDefined( spotlight_name ) )
	{
		PrintLn( "spotlight_think is missing spotlight_name. returning." );
		return;
	}
	else
	{
		spotlight_ent = getstruct( spotlight_name, "targetname" );
		if( !IsDefined( spotlight_ent ) )
		{
			PrintLn( "spotlight_think couldn't find spotlight with name " + spotlight_name );
			return; 
		}
		
		spotlight = Spawn( "script_model", spotlight_ent.origin );
		spotlight SetModel( "tag_origin" );
		PlayFXOnTag( level._effect[ "tower_spotlight" ], spotlight, "tag_origin" );
	}
	
	if( IsDefined( ender ) )
	{
		level endon( ender );
		spotlight thread delete_on_level_notify( ender );
	}	
	
	if( !IsDefined( focus_target ) )
	{
		focus_target = get_players()[0];  // player is default target
	}
	
	if( !IsDefined( focus_distance ) )
	{
		default_distance = 4000;
		PrintLn( self.targetname + " is missing a focus distance. defaulting to " + default_distance );
		focus_distance = default_distance;
	}
	
	if( IsDefined( spotlight_ent.targetname ) )
	{
		switch( spotlight_ent.targetname )
		{
			case "river_guard_tower_1_spotlight":
				focus_distance = 6500;
				break;
			
			case "river_guard_tower_2_spotlight":
				focus_distance = 7000;
				break;
			
			case "river_guard_tower_3_spotlight":
				focus_distance = 4500;
				break;

			case "river_guard_tower_4_spotlight":
				focus_distance = 4500;  // MIGHT CHANGE - tj25 
				break;

			case "river_guard_tower_5_spotlight":
				focus_distance = 7000;
				break;															
		}
	}
	
	original_angles = spotlight_ent.angles;  // need these for a reset condition
	scale_forward = 100;
	scan_vector = scale_forward * VectorNormalize( AnglesToForward( original_angles ) );
		
	if( !IsDefined( self.tower_broken ) )
	{
		self.tower_broken = false;
	}	
	
	focus_dist_squared = focus_distance * focus_distance;
	//x_offset = ( 2000, 0, 0 );
	y_offset_range = ( 0, 1500, 0 ); // horizontal offset for scan
	z_offset = ( 0, 0, 2 * ( spotlight.origin[2] - focus_target.origin[2] ) );  
	scan_position = 0;  // 0 = left, 1 = right
		
	while( true)  // TBD here: supposed to work on towers and bunker, which are both triggers
	{
		current_dist_squared = DistanceSquared( focus_target.origin, spotlight.origin );
		
		if( current_dist_squared > focus_dist_squared )  // scan behavior
		{
			//IPrintLnBold( "spotlight scanning" );
			// toggle which offset to go to: 0 = left, 1 = right
			if( scan_position == 0 )
			{
				aim_angles = VectorToAngles( scan_vector + y_offset_range - z_offset);
				scan_position = 1;
			}
			else
			{
				aim_angles = VectorToAngles( scan_vector - y_offset_range - z_offset );
				scan_position = 0;
			}
			
			spotlight RotateTo( aim_angles, 2.5 );
			spotlight waittill( "rotatedone" );
			wait( 0.5 );
		}
		else  // focus behavior
		{
			angles_to_target = VectorToAngles(focus_target.origin - spotlight.origin);
			//vec_to_target = scale_forward * VectorNormalize( vec_to_target );
			//lookat_point = vec_to_target + focus_target.origin;
			spotlight RotateTo( angles_to_target, 0.5 );
			spotlight waittill( "rotatedone" );
		}
	}
	
	spotlight Delete();	
}

delete_on_level_notify( ender )
{
	if( !IsDefined( ender ) )
	{
		return;
	}
	
	level waittill( ender );
	
	if( IsArray( self ) )
	{
		for( i = 0; i < self.size; i++ )
		{
			self[ i ] Delete();
		}
	}
	else
	{
		self Delete();
	}
}

flag_set_on_death( flag_name )  // self = entity capable of dying
{
	if( !IsDefined( flag_name ) )
	{
		PrintLn( "flag_name missing for flag_set_on_death for " + self.targetname );
		return;
	}
	
	self waittill( "death" );
	
	flag_set( flag_name );
}

MG_bunker_damage_states()
{
	level endon( "boat_drive_done" );
	
	MG = GetEnt( "split_bridge_island_mg", "targetname" );
	AssertEx( IsDefined( MG ), "MG is missing for MG_bunker_damage_states" );
	
	trigger = GetEnt( "concrete_MG_bunker_damage_trigger", "targetname" );
	AssertEx( IsDefined( trigger ), "trigger for MG_bunker_damage_states is missing" );
	
	pristine_state = true;
	half_damage = false;
	full_damage = false;
	
	half_damage_amount = 800;
	full_damage_amount = 2400;
	
	total_damage = 0;
	
	trigger thread high_value_target();
	trigger thread spotlight_think( "bunker_spotlight", level.boat, 6000, "bunker_dead" );
	trigger.tower_broken = false;	
	
	while( true )
	{
		trigger waittill( "damage", amount, who, direction_vec, damage_ori, type );
//		IPrintLnBold( amount + " damage taken by bunker" );
		
		if( IsDefined( who ) )
		{		
			if( ( type == "MOD_PROJECTILE" ) || ( type == "MOD_PROJECTILE_SPLASH" ) || ( type == "MOD_EXPLOSIVE" ) || ( type == "MOD_RIFLE_BULLET" ) )
			{

				if( ( who == get_players()[0] ) || ( ( IsDefined( who.targetname ) && ( ( who.targetname == "player_controlled_boat" ) || ( who.targetname == "woods_ai" ) || ( who.targetname == "bowman_ai" ) ) ) ) )  // tj25 - add bowman when he's off the bow gun
				{
					total_damage = total_damage + amount;
				}
				else
				{
					continue;
				}
			}
			else
			{
//				if( who == get_players()[0] )
//				{
//					//amount = Int( amount * 0.75 ); // 75% damage from bullets, etc
//				
//				}
//				else if( IsDefined( who.targetname ) )
//				{
//					if( who.targetname == "player_controlled_boat" )
//					{
//						amount = amount;
//					}
//					else
//					{
//						continue;
//					}
//				}
//				else
//				{
					continue;
//				}
				
				total_damage = total_damage + amount;
			}
		}
		else
		{
			continue;
		}
		
		if( total_damage < half_damage_amount )
		{
			// do nothing. this is set up by default
	
		}
		else if( ( total_damage >= half_damage_amount ) && ( total_damage < full_damage_amount ) )
		{
			if( half_damage == false )
			{
				half_damage = true;
				level notify( "bunker01_start" );
				//PlayFX( level._effect[ "temp_destructible_building_smoke_black" ], trigger.origin );
			}
		}
		else if( total_damage >= full_damage_amount )
		{
			if( full_damage == false )
			{
				// VO: Bunker Destroyed
				level.woods thread maps\river_vo::playVO_proper( "that_was_their_stronghold", 0.3 );
				
				clip = GetEnt( "bunker_roof_clip", "targetname" );
				if( IsDefined( clip ) )
				{
					clip Delete(); // roof collapses in animated model, can't have guys standing up there
				}
				else
				{
					//IPrintLnBold( "roof clip missing for bunker!" );
				}
				
				full_damage = true;
				level notify( "bunker02_start" );
				//PlayFX( level._effect[ "temp_destructible_building_embers" ], trigger.origin );
				//PlayFX( level._effect[ "temp_destructible_building_fire_large" ], trigger.origin );
				//maps\river_util::launch_guys_near_point( trigger, 300, 100, 200, "axis", ( 0, 0, -100 ) );
				MG_guy = MG GetTurretOwner();
				if( IsDefined( MG_guy ) )
				{
					//IPrintLnBold( "killing MG guy" );
					MG_guy DoDamage( MG_guy.health + 100, MG_guy.origin, get_players()[0] );
				}
				flag_set( "bunker_dead" );
				trigger notify( "death" );
				self.tower_broken = true;
				break;
			}
		}
	}
}

MG_bunker_fires( MG_targetname, target, engagement_distance, start_firing_notify )
{
	if( !IsDefined( MG_targetname ) )
	{
		PrintLn( "MG_bunker_fires is missing MG_targetname" );
		return;
	}
	
	MG = GetEnt( MG_targetname, "targetname" );
	if( !IsDefined( MG ) )
	{
		PrintLn( "MG is missing in MG_bunker_fires" );
		return;
	}
	
	if( !IsDefined( MG.weaponinfo ) )
	{
		PrintLn( "Invalid weaponinfo on MG, returning" );
		return;
	}
	
	if( !IsDefined( target ) )
	{
		target = get_players()[0];
	}	
	
	
	MG_type = MG.weaponinfo;
	
	firetime = WeaponFireTime( MG_type );
	
	MG_guy = MG GetTurretOwner();
	
	while( !IsDefined( MG_guy ) )
	{
		MG_guy = MG GetTurretOwner();
		wait( 0.5 );
	}
	
	MG_guy._damage_source = MG;
	MG_guy.overrideActorDamage = maps\river_util::actor_player_damage_only;
	
	// cases: 1 is defined, other is defined, both are defined, neither are defined
	if( IsDefined( engagement_distance ) &&  !IsDefined( start_firing_notify ) )
	{
		level thread notify_when_within_distance( target, MG, engagement_distance, "MG_engaged" );
		MG TurretFireDisable();
		level waittill( "MG_engaged" );
	}
	else if( !IsDefined( engagement_distance ) && IsDefined( start_firing_notify ) )
	{
		MG TurretFireDisable();
		level waittill( start_firing_notify );
	}
	else if( IsDefined( engagement_distance ) && IsDefined( start_firing_notify ) )
	{
		level thread notify_when_within_distance( get_players()[0], MG, engagement_distance, "MG_engaged" );
		MG TurretFireDisable();
		level waittill_either( "MG_engaged", start_firing_notify );

		// Make sure we are within engagement distance
		dist = 9999999;
		while( dist > engagement_distance )
		{
			dist = Distance( level.player.origin, MG.origin );
			wait( 0.1 );
		}

		// VO: Bunker starts firing
		level.woods thread maps\river_vo::playVO_proper( "what_the_hell_is_that", 0.5 );
		level.mason thread maps\river_vo::playVO_proper( "give_it_all_youve_got", 1.75 );
	}
	else
	{
		// do nothing! there's no waiting to be done
		MG TurretFireDisable();
	}	

	MG TurretFireEnable();
	
	sound_ent = spawn( "script_origin" , MG.origin);
	
	while( IsDefined( MG_guy ) )
	{
		MG_guy = MG GetTurretOwner();  // this is probably very inefficient. see about alternate setups here
		MG SetTargetEntity( target );
		MG ShootTurret();
		sound_ent playloopsound( "wpn_pbr_turret_fire_loop_npc" );
		wait( firetime );
	}	
	sound_ent stoploopsound();
	sound_ent playsound( "wpn_pbr_turret_fire_loop_ring_npc" );
	sound_ent thread sound_entmg_delete();
}
sound_entmg_delete()
{
	wait 1;
	self Delete();
}

/*==========================================================================
FUNCTION: notify_when_within_distance
SELF: whatever it's threaded on. This can be level, a particular ent, or anything.
PURPOSE: send out a notify when two things get to be a certain distance from each
	other. If no specific notify is specified, it will sound the generic "within_range" 
	notify to self. 

ADDITIONS NEEDED:
==========================================================================*/
notify_when_within_distance( ent1, ent2, dist, special_notify )
{	
	if( !IsDefined( ent1 ) || !IsDefined( ent2 ) || !IsDefined( dist ) )
	{
		PrintLn( "notify_when_within_distance is missing parameters ent1, ent2, or dist. returning." );
		return;
	}
	
	dist_squared = dist * dist;
	
	current_dist = DistanceSquared( ent1.origin, ent2.origin );
	
	while( current_dist >= dist_squared )
	{
		wait( 0.25 );
		current_dist = DistanceSquared( ent1.origin, ent2.origin );
		val = sqrt( current_dist );
	}
	
	if( IsDefined( special_notify ) )
	{
		self notify( special_notify );
	}
	else
	{
		self notify( "within_range" );
	}
}


boss_boat_encounter()
{
	wait( 0.2 );
	add_spawn_function_veh( "boss_boat_1", ::high_value_target );
	
	start_trigger = GetEnt( "boss_boat_start_trigger", "targetname" );
	AssertEx( IsDefined( start_trigger ), "start_trigger for boss_boat_encounter is missing!" );
	start_trigger waittill( "trigger" );
	
	// set these flags so objectives update appropriately. they will NOT count towards achievement kill count this way
	flag_set( "bunker_dead" );
	flag_set( "ZPU_dead" );
	
	autosave_by_name( "river_boss_boat" );

	level notify ("kill_the_radio");	
	//TUEY start Battle Post Blocker
	setmusicstate ("BATTLE_POST_BLOCKER");

	level thread cleanup_sampan_area();

	wait( 0.2 );
	
	// Start the boss boat!!!
	level thread maps\river_features::boss_boat_fight();
	
	level thread kill_off_young_soldier();
	
	level waittill( "boss_boat_killed" );
	flag_clear( "show_directional_marker" );  // make sure 3d objective markers are off for movie
	level.boat notify( "young_soldier_dies" ); // failsafe in case player takes zero damage from boss boat
	
	// Let the boss boat sink before we check the kid
	wait( 5 );
	
	//TUEY set music state POST FLASHBACK
	setmusicstate ("POST_FLASHBACK");	
	
	//TUEY sets the client notify to return to the default snapshot.
	clientNotify ("pbto");
	
	
	// give achievement if player has killed all high value targets
	if( !IsDefined( level._high_value_targets ) )
	{
		level._high_value_targets = 0;
	}
	
	if( !IsDefined( level._high_value_targets_killed ) )
	{
		level._high_value_targets_killed = 0;
	}
	
	if( level._high_value_targets == level._high_value_targets_killed )
	{
		player = get_players()[0];
	//	IPrintLnBold( "achievement unlocked: Lord Nelson" );
		player giveachievement_wrapper( "SP_LVL_RIVER_TARGETS" );
	}	
	
/*===========================================================================
	level.scr_anim[ "woods" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_woods;
	level.scr_anim[ "bowman" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_bowman;
	level.scr_anim[ "kid" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_youngsoldier;
===========================================================================*/	

	level.movie_fade_in_time = .5;	
	level.movie_fade_out_time = .5;

	enemies = GetAIArray( "axis" );
	array_thread( enemies, maps\river_util::kill_me );

	level notify( "young_soldier_dead_starts" );

	if( flag( "playing_boat_death" ) )  // this is guarding an assert. if the boat's death anim is playing, Woods and Bowman are killed and show up as undefined.
	{
		wait( 10 );  // the wait is here so we don't need to do this check in other functions
		return;
	}	

	kid = GetEnt( "bow_gun_redshirt_ai", "targetname" );
	
	if( !IsDefined( kid ) )  // means player boat has died after boss boat has died... somehow.
	{
		return;
	}
	
	kid.animname = "kid";

	kid ent_flag_wait( "anim_done" );  // make sure kid is finished playing his death anim before playing scene

	reset_turret_ai();

	level.boat thread anim_single_aligned( kid, "young_soldier_dead", "tag_gunner_turret1" );
	level.boat thread anim_single_aligned( level.woods, "young_soldier_dead", "tag_passenger10" );
	level.boat thread anim_single_aligned( level.bowman, "young_soldier_dead", "tag_gunner3" );
	
	
	wait( 8 );
	
	SetSavedDvar( "r_streamFreezeState", 1 );
	
	wait( 3 );
	
	
////	if( level.reznov islinkedto( level.boat ) )
////	{
//		level.reznov Unlink();
////	}
//	
//	// restore crosshair settings on drones
//	if( isdefined( level.old_friendly_fire_dist ) )
//	{
//		SetSavedDvar( "g_friendlyfireDist", level.old_friendly_fire_dist );
//	}
//	/*
//	if( isdefined( level.old_friendly_name_dist ) )
//	{
//		SetSavedDvar( "g_friendlyNameDist", level.old_friendly_name_dist );
//	}
//	*/
//	
//	

	// Woods and Bowman, back to normal
	level.woods.ignoreall = false;
	level.bowman.ignoreall = false;
	
	start_movie_scene();
	add_scene_line(&"river_vox_riv1_s01_800A_maso", 5, 8.5);		//That young kid didn't make it. I swear to God that Woods was crying, but he never let us see no tears.
	level thread play_movie( "mid_river_1", false, false, "start_flashback", true, "flashback_done", 1 );		

	flashback();
	
	kid Delete();	
}

kill_off_young_soldier()
{
	level.boat thread notify_after_damage( 2000, "young_soldier_dies", "tag_gunner_turret1", 300 );
	
	level.boat waittill( "young_soldier_dies" );
	
	if( flag( "playing_boat_death" ) )  // this is guarding an assert. if the boat's death anim is playing, Woods and Bowman are killed and show up as undefined.
	{
		wait( 10 );  // the wait is here so we don't need to do this check in other functions
		return;
	}		
	
	level.boat thread maps\_vehicle_turret_ai::disable_turret( 0 );	
	
	kid = GetEnt( "bow_gun_redshirt_ai", "targetname" );	
	kid.animname = "kid";

	// take out kid from turret
	kid notify( "animontag_thread" );  // kill _vehicle_aianim thread so animation plays

	kid Unlink();
	wait( 0.1 );  // have to wait a frame or he'll be offset when anim begins
	kid LinkTo( level.boat, "tag_gunner_turret1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	level.kid anim_single_then_flag( level.boat, "young_soldier_dead_death", "tag_gunner_turret1" );
	//level.boat anim_single_aligned( kid, "young_soldier_dead_death", "tag_gunner_turret1" );
	level.boat anim_loop_aligned( kid, "young_soldier_dead_death_idle", "tag_gunner_turret1", "young_soldier_dead_starts" );
}

notify_after_damage( total_damage, self_notify, tag_name, dist_threshold )
{
	if( !IsDefined( total_damage ) || !IsDefined( self_notify ) )
	{
		PrintLn( "can't run check_damage on " + self.targetname + ", missing parameters" );
		return;
	}
	
	damage_taken = 0;
	
	while( 1 )
	{
		self waittill( "damage", amount, who, direction, point, type, modelName, tagName );
		
		if( ( type == "MOD_EXPLOSIVE" ) || ( type == "MOD_PROJECTILE" ) || ( type == "MOD_PROJECTILE_SPLASH" ) )
		{
			if( IsDefined( tag_name ) && IsDefined( dist_threshold ) )
			{
				tag_pos = self GetTagOrigin( tag_name );
				dist = Distance( tag_pos, point );
				
				if( dist < dist_threshold )
				{
					amount = total_damage + 1;  // instant kill 
				}
			}
		}
		
		damage_taken += amount;
		
		if( damage_taken > total_damage )
		{
			break;
		}
	}
	
	self notify( self_notify );
}

reset_turret_ai()
{
	if( flag( "playing_boat_death" ) )  // this is guarding an assert. if the boat's death anim is playing, Woods and Bowman are killed and show up as undefined.
	{
		wait( 10 );  // the wait is here so we don't need to do this check in other functions
		return;
	}
	
	// put woods back into a normal AI state
	level.woods AllowedStances( "stand", "crouch", "prone" );
	//level.woods gun_switchto( "commando_acog_sp", "right" );  // gun given back in drop_m202 function now
	//level.woods useweaponhidetags( "commando_acog_sp" );
	level.woods notify( "stop_rpg_turret_ai" );
	level.woods ClearEntityTarget();	
	level.woods enable_react();
	level.woods.ignoreall = false;
	level.woods enable_pain(); 
	level.woods.grenadeawareness = 1;
	
	// put bowman back into normal AI state
	level.bowman AllowedStances( "stand", "crouch", "prone" );
	//level.bowman gun_switchto( "commando_acog_sp", "right" );  // gun given back in drop_m202 function now
	//level.bowman useweaponhidetags( "commando_acog_sp" );
	level.bowman notify( "stop_rpg_turret_ai" );	
	level.bowman ClearEntityTarget();
	level.bowman enable_react();
	level.bowman.ignoreall = false;
	level.bowman enable_pain(); 
	level.bowman.grenadeawareness = 1;	
	
	// clear boat turret aiming ent 
	level.boat notify( "stop_player_aim_entity_update" );	
	level thread maps\river_util::look_forward_on_boat( level.woods, level.bowman );
	
	flag_set( "woods_bowman_m202_ended" );
}

drop_m202( guy )
{
	if( guy.weapon == "m202_flash_sp_river" )
	{
		guy DropWeapon( guy.weapon, "right", 1 );
		
		flag_wait( "boat_drive_done" );
		
		guy gun_switchto( "commando_acog_sp", "right" );
		guy useweaponhidetags( "commando_acog_sp" );
	}
	else
	{
		PrintLn( "guy isn't holding a m202!" );
	}
}

fade_out_for_user_test()
{
	/#  // if using a dev build, don't fade out.
		IPrintLnBold( "DEV BUILD DETECTED. Demo build scripting ends here." );
		return;
	#/
	
	// if ship build is being used, fade out here
	
	wait( 3 );
	
	//IPrintLnBold( "TEMP: current scripting ends here. Transitioning to next mission." );
	
	level thread fade_to_black( 4, 5 );
	
	wait( 5 );
	
	nextmission();	
}

first_turn_sampans_2_arrive()
{
	level endon( "boat_drive_done" );	

	start_trigger = GetEnt("quad50_3_trigger", "targetname");
	AssertEx(IsDefined(start_trigger), "start_trigger is missing in first_sampan_encounter function in boat_drive beat");
	start_trigger waittill("trigger");

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 10 );	

	level thread cleanup_AA_guns_area();
	
	level thread maps\river_vo::vo_first_turn_sampans();	
	
	wait( 0.2 );
	
	level thread maps\river_features::sanpan_fallback_drones_start();
	
	wait( 0.2 );
}

// script_vehiclespawngroup = 6
fuel_depot_sampans_arrive()
{
	level endon( "boat_drive_done" );	
	
	start_trigger = GetEnt("fuel_depot_start_trigger", "targetname");
	AssertEx(IsDefined(start_trigger), "start_trigger is missing in fuel_depot_sampans_arrive function in boat_drive beat");
	start_trigger waittill("trigger");	
	
	autosave_by_name("river_drive_fuel_depot");
	
	for(i=1; i<4; i++)  // 3 sampans
	{
		add_spawn_function_veh("fuel_depot_sampan_" + i, maps\river_util::vehicle_setup);
	}
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 6 );
}

setup_explosive_structures(scene_ender)
{
	triggers = GetEntArray("explosive_structure_trigger", "targetname");
	if(triggers.size == 0)
	{
		PrintLn("explosive_structure_triggers are missing");
		return;
	}
	array_thread(triggers, ::explode_when_triggered);
	
	if(!IsDefined(scene_ender))
	{
		return;
	}
	else
	{
		flag_wait(scene_ender);
		triggers = GetEntArray("explosive_structure_trigger", "targetname");
		for(i=0; i<triggers.size; i++)
		{
			triggers[i] Delete();
		}
	}
}


/*===========================================================================
wait to be triggered, then get guys close by and ragdoll launch them if 
they're close enough
-----------------------------------------------------------------------------
THINGS YOU NEED:
script:
Radiant: 
===========================================================================*/
explode_when_triggered(scene_ender)  // self = trigger
{
	level endon("death");
	
	if(IsDefined(scene_ender))
	{
		level endon(scene_ender);  // end when flag is hit		
	}
	
	AssertEx((self.classname == "trigger_damage"), "explosive_structure_trigger must be trigger_damage");
	
	explosive_distance = 1000;
	
	if(IsDefined(self.script_int))  // script_int will be the distance to launch from 
	{								// when the explosion happens
		explosive_distance = self.script_int;
	}
	else  // default case
	{
		explosive_distance = 1000;  
	}	
	
	explosive_damage = 200;  // arbitrary. a lot of damage.
	explosion_strength = 1; // default for physicsexplosionsphere = 1
//	damager = "explosive_structure_explosion";  // try to make this a unique eAttacker for callback
	
	self waittill("trigger");
	
	if(IsDefined(self.target))  // if you want explosion to happen from particular point, it's set here
	{
		explosion_origin = getstruct(self.target, "targetname");
		AssertEx(IsDefined(explosion_origin), "explosion_origin for explosion_structure_trigger is missing");		
	}
	else  // default case
	{
		explosion_origin = self.origin;
	}
	
	
	player = get_players()[0];
//	RadiusDamage(explosion_origin.origin, explosive_distance, explosive_damage, explosive_damage-1, player);	
	
	NVA_guys = GetEntArray("NVA_spawners_ai", "targetname");
	about_to_die = get_within_range(explosion_origin.origin, NVA_guys, explosive_distance);
	
	for(i=0; i<about_to_die.size; i++)
	{
		about_to_die[i] DoDamage(about_to_die[i].health+100, explosion_origin.origin, player);
		PhysicsExplosionSphere(explosion_origin.origin, explosive_distance+1, explosive_distance, explosion_strength);
	}
	//IPrintLnBold("exploding_structure_trigger hit");
}

boat_drag()
{
	level.reznov Unlink();
	level.woods Unlink();
	level.bowman Unlink();
	
	maps\river_boat_drag::main();
	
	// call this instead if we want to skitp the boat drag.
	//maps\river_boat_drag::dev_skip_boat_drag();
}


//*****************************************************************************
// This is where flashback occurs. player will be teleported here as well.
//*****************************************************************************

flashback()
{
	flashback_fade_out_time = 6;
	flashback_fade_in_time = 5;
	
	// Disable Boat weapons	
	for( i=0; i<6; i++)
	{
		level.boat DisableGunnerFiring( i, true );
	}

	flag_set( "movie_playing" );
	
	// Fade out HUD Icons
	level.player thread maps\river_util::fade_cross_hair( 0.0, 2.0 );
	
//	flashback_hud = fullscreen_shader_fade( "white", flashback_fade_out_time, 0, 1 );
	flag_clear( "show_directional_marker" );  // make sure 3d objective markers are off for movie
	
	level notify( "start_flashback" );
	
	wait( level.movie_fade_in_time );
	
	level.woods anim_stopanimscripted();
	level.woods Unlink();
	
	wait( 0.05 );
	
	woods_pos = GetStartOrigin( level.boat.origin, level.boat.angles, level.scr_anim["woods"]["binocs_up"] );
	woods_angles = GetStartAngles( level.boat.origin, level.boat.angles, level.scr_anim["woods"]["binocs_up"] );
	//level.woods forceteleport( woods_pos, woods_angles );
	level.woods linkto( level.boat, "tag_passenger10", ( 0, 0, 0 ), ( 0, 0, 0 ) );  // , ( 0, 0, 0 ), ( 0, 0, 0 )
	level.boat thread anim_first_frame( level.woods, "binocs_up", "tag_passenger10" );
	
	level.bowman anim_stopanimscripted( 0.2 );
	level.bowman Unlink();
	wait( 0.05 );
	level.bowman LinkTo( level.boat, "tag_gunner3", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	level.boat vehicle_toggle_sounds( 0 );
	level.woods set_ignoreall( true );
	level.bowman set_ignoreall( true );
	
	level waittill( "flashback_done" );
	SetSavedDvar("r_streamFreezeState",0);
	level thread flag_set_delayed( "show_directional_marker" , level.movie_fade_out_time ); // turn 3d objective markers back on after movie
	
	level.boat vehicle_toggle_sounds( 1 );
	level.woods set_ignoreall( false );
	level.bowman set_ignoreall( false );
	
	// Enable Boat weapons	
	for( i=0; i<6; i++)
	{
		level.boat DisableGunnerFiring( i, false );
	}

	level thread set_flag_movie_finished( 2 );

	// Fade in HUD Icons
	level.player thread maps\river_util::fade_cross_hair( 1.0, 2.0 );

//	flashback_hud thread fullscreen_shader_fade( "white", flashback_fade_in_time, 1, 0 );
}


//*****************************************************************************
//*****************************************************************************

set_flag_movie_finished( delay )
{
	if( delay )
	{
		wait( delay );
	}
	flag_clear( "movie_playing" );
}

river_pacing()
{
	// VO - Pacing introduction
//	level.woods thread maps\river_vo::playVO_proper( "charlies_gone_for_now", 4 );
//
//	// tj25 - end of event stuff - clean up. 
//	river_pacing_beat_begins_trigger = GetEnt("river_pacing_begins_trigger", "targetname");
//	AssertEx(IsDefined(river_pacing_beat_begins_trigger), "river_pacing start trigger is missing");
//	river_pacing_beat_begins_trigger waittill("trigger");
	maps\river_util::vehicle_cleanup( level.boat ); // delete all vehicles except player boat here

//	level.bowman maps\river_util::put_actor_on_bow_gun( level.boat, false );	

	// CLEAN UP TREES: (SCRIPT_INT 3)
	maps\river_features::cleanup_destructable_trees( 3 );

	flag_set("boat_drive_done");
	
	level.reznov useweaponhidetags( "commando_acog_sp" );
	
//	/#
//		level thread update_billboard("E1 B4: river_pacing", "pacing, no combat", "TEMP: 45-60 seconds", "roughout");
//		level thread maps\river_util::event_timer("river_pacing", "river_pacing_done");
//	#/
	
	//level thread move_boats_with_player( undefined, undefined, -1200, 1200, -2000 );
	
//	helicopter_flyby_trigger = GetEnt( "river_pacing_helicopter_flyby_trigger", "targetname" );
//	AssertEx( IsDefined( helicopter_flyby_trigger ), "helicopter_flyby_trigger is missing in river_pacing" );
//	helicopter_flyby_trigger waittill( "trigger" );
	
	// farthest node = boat_landing_rail_start
	
	rail_start = GetVehicleNode( "boat_landing_rail_100c", "targetname" );
	AssertEx( IsDefined( rail_start ), "rail_start missing for river_pacing" );
		
	// player is using boat at this point
	player = get_players()[0];
//	player LinkTo( level.boat );
	level.boat AttachPath( rail_start );	
	level.boat.origin = rail_start.origin;	
	level.boat.angles = rail_start.angles;
	get_players()[0] SetPlayerAngles( rail_start.angles );

	wait( 1 );
	
//	player Unlink();
	
	// start boat on rail
//	level.boat.drivepath = 1;
//	level.boat SetDrivePathPhysicsScale( 3.0 );
//	level.boat thread go_path(rail_start);	
//
//	// kick player out of boat 
//	level.boat MakeVehicleUsable();
//	level.boat UseBy( player );	
//	level.boat MakeVehicleUnusable();		
	
	level.bowman enable_cqbwalk();
	level.bowman enable_heat();
	
	maps\river_util::Print_debug_message( "flyby helicopter trigger hit" );
	
	for( i = 1; i < 4; i++ )
	{
		add_spawn_function_veh( "pacing_flyby_helicopter_" + i, ::vehicle_windowdressing, true, false );
		add_spawn_function_veh( "pacing_flyby_helicopter_" + i, maps\river_util::huey_cone_light );
	}
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 37 ); // helicopter trio for flyby
	
	crashed_huey_trigger = GetEnt( "pacing_crashed_huey_trigger", "targetname" );
	AssertEx( IsDefined( crashed_huey_trigger ), "crashed_huey_trigger is missing in river_pacing" );

	// Pacing helicopter VO	- the helicopter that looks at the crashed helicopter
	copter = GetEnt( "pacing_flyby_helicopter_3", "targetname" );
	copter.animname = "us_pilot_1";
//	copter thread maps\river_vo::playVO_proper( "no_movement_anywhere", 3 );
//
//	level.woods thread maps\river_vo::playVO_proper( "roger_that_stay_in_touch", 8.5 );
//	level.mason thread maps\river_vo::playVO_proper( "dont_like_the_look_of_this", 10.7 );
//	level.woods thread maps\river_vo::playVO_proper( "dont_blink", 14.0 );
//	
//	copter thread maps\river_vo::playVO_proper( "all_clear_here", 15.2 );
//	
//	crashed_huey_trigger waittill( "trigger" );

	// Add floating guy 	
	floater_spawner = GetEnt( "pacing_crashed_huey_floater", "targetname" );
	floater = simple_spawn_single( "pacing_crashed_huey_floater" );
	floater floatlonger(); 
	floater ragdoll_death();
	floater_spawner Delete();	

	// AI on boat use the binoculars
	level thread binoculars_anim();

	level.woods thread maps\river_vo::playVO_proper( "nothing_so_far_wait", 0.5 );			// 2

	level.bowman thread maps\river_vo::playVO_proper( "whatever_happened", 3.5 );			// 3.5
		
	level.woods thread maps\river_vo::playVO_proper( "we_got_a_downed_bird", 7.0 );			// 6.5

	copter thread maps\river_vo::playVO_proper( "theres_nothing_out_here", 9.5 );
	level.woods thread maps\river_vo::playVO_proper( "bullshit", 11.0 );
	

	// too much, not needed
	//copter thread maps\river_vo::playVO_proper( "im_at_a_canyon", 16.5 );
	//level.woods thread maps\river_vo::playVO_proper( "im_not_buying_it", 15.5 );
	
	
	// Start the buffalo grazing
	buffalo_array = GetStructArray( "buffalo", "targetname" );
	if( isdefined( buffalo_array ) )
	{
		for( i=0; i<buffalo_array.size; i++ )
		{
			struct = buffalo_array[ i ];
			ent = spawn( "script_model", struct.origin );
			ent.targetname = "buffalo";
			ent setModel( "anim_asian_water_buffalo" );
			ent SetCanDamage( true ); 
			
			ent.health = 99999;
			ent thread maps\river_anim::buffalo_grazing( struct );
		}
	}
	
	
	cattle_scatter_trigger = GetEnt( "cattle_scatter_trigger", "targetname" );
	AssertEx( IsDefined( cattle_scatter_trigger ), "cattle_scatter_trigger is missing in river_pacing" );
	cattle_scatter_trigger waittill( "trigger" );
	
	//IPrintLnBold( "wildlife scatter by waterfall" );
	
	// Dialogue after the cattle
	level.mason thread maps\river_vo::playVO_proper( "bowman_what_happened", 0 );
	level.bowman thread maps\river_vo::playVO_proper( "theres_nothing_here", 2.5 );
	level.woods thread maps\river_vo::playVO_proper( "right", 4.3 );

	level.reznov thread maps\river_vo::playVO_proper( "the_plane_must_be_close", 7.5 );	
	playsoundatposition( "evt_num_num_10_r" , (0,0,0) );
	
	//copter thread maps\river_vo::playVO_proper( "im_at_a_canyon", 8.0 );
	
	hover_heli_trigger = GetEnt( "pacing_hovering_helicopter_trigger", "targetname" );
	AssertEx( IsDefined( hover_heli_trigger ), "hover_heli_trigger is missing in river_pacing" );
	
	hover_heli_trigger waittill( "trigger" );
	
//	level thread add_dialogue_line( "Woods", "Narrow canyon up ahead. If there's going to be an ambush, it'll be here." );
	maps\river_util::Print_debug_message( "hovering huey trigger hit", true );
	
	add_spawn_function_veh( "pacing_hover_huey", ::vehicle_windowdressing, undefined, undefined, true );	
	add_spawn_function_veh( "pacing_hover_huey", maps\river_util::huey_cone_light );	
	add_spawn_function_veh( "pacing_hover_huey", maps\river_jungle::heli_hover );
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 38 );
	
	wait( 0.1 );
	
	hover_huey = GetEnt( "pacing_hover_huey", "targetname" );
	hover_huey.takedamage = false;

	
	copter = hover_huey;
	copter.animname = "us_pilot_1";

	// Welcome to paradise
	copter thread maps\river_vo::playVO_proper( "i_see_you_wolf_10", 5.5 );
	
	// Reznov VO
	level.reznov thread maps\river_vo::playVO_proper( "i_feel_it", 8.5 );
	level.bowman thread maps\river_vo::playVO_proper( "come_again", 13.75 );
	
	
// NOT PLAYING ????????????
	//copter thread maps\river_vo::playVO_proper( "nothing_behind_you", 9.5 );

	// Kill off the buffalo
	level thread buffalo_kill_all();

	// Wait......
	kravckenko_vo_trigger = GetEnt( "kravchenko_is_near_vo", "targetname");
	kravckenko_vo_trigger waittill("trigger");
	
// Why doesn't tha anim work?
//	level thread reznov_anim_krav_near( 0 );

	level.mason thread maps\river_vo::playVO_proper( "kravchenko_he_must_be_near_by", 1.5 );
	level.woods thread maps\river_vo::playVO_proper( "i_fucking_hope_so", 3.2 );


	//wait( 5 );
	
//	boat_dock_trigger = GetEnt("jungle_approach_begins_trigger", "targetname");
//	boat_dock_trigger waittill("trigger");
	
	//transition_to_laos();	
	//flag_set("boat_docked");
	//autosave_by_name("river_river_pacing");	
}


//*****************************************************************************
//*****************************************************************************

reznov_anim_krav_near( delay )
{
	wait( delay );
	
	//IPrintLnBold("KRAV NEAR ANIMATION");
	
	maps\river_anim::play_reznov_anim( "krav_near" );
}


//*****************************************************************************
//*****************************************************************************

binoculars_anim()
{
	wait( 5 );
//	IPrintLnBold("STARTING BINOCULARS ANIM");
	
	level thread maps\river_drive::boat_binocular_look();
                                
	wait( 10 );
	
	flag_set( "binocular_look_end" );
//	IPrintLnBold("STARTING BINOCULARS ANIM");
}


//*****************************************************************************
// Start the buffalo grazing
//*****************************************************************************
	
buffalo_kill_all()
{
	buffalo_array = GetEntArray( "buffalo", "targetname" );
	if( isdefined( buffalo_array ) )
	{
		for( i=0; i<buffalo_array.size; i++ )
		{
			ent = buffalo_array[ i ];
			ent delete();
		}
	}
}


//*****************************************************************************
//*****************************************************************************

impending_mortar_death_function()
{
	self endon("player_passed_fuel_depot_area");
	
	mortar_line = []; // TODO: add functionality
	
	explosion_range = 500;
	explosion_inner = 1;
	explosion_damage_max = 75;
	explosion_damage_min = 50;
	explosion_magnitude = 3;
	
	while(true)
	{
		//player = get_players()[0];
		
		forward = AnglesToForward(level.boat.angles);
		right = AnglesToRight(level.boat.angles);
		
		scale_forward = RandomIntRange(1200, 1650);
		scale_right = RandomIntRange(650, 850);
		
		x = RandomInt(100);
		
		if(x > 50)
		{
			scale_right = scale_right * (-1); // put explosion on left side
		}
		
		view_position = level.boat.origin + (forward * scale_forward) + (right * scale_right);
		explosion_position = (view_position[0], view_position[1], level.boat.origin[2]);  // take X and Y but keep Z on ground level
		
		PlayFX(level._effect["water_mortar"], explosion_position);
		RadiusDamage(explosion_position, explosion_range, explosion_damage_max, explosion_damage_min);
		PlaySoundAtPosition("wpn_rocket_explode_water", explosion_position);
		PhysicsExplosionSphere(explosion_position, explosion_range*2, explosion_inner, explosion_magnitude);
		
		wait_time = RandomIntRange(5, 7);
		wait(wait_time);
	}
}


notify_on_trigger_death()
{
	self waittill("trigger");
	
	level notify("bridge_blockade_cleared");
	PrintLn("bridge blockade " + self.targetname + " cleared");
	
	PlayFX(level._effect["friendly_boat_death"], self.origin);
	
	self Delete();
}

transition_to_laos()
{
	level thread fade_to_black(3, 3);
	
	wait(3);
	flag_set("friendly_boat_speed_checks_done");	
	
	level.friendly_boats = remove_dead_from_array( level.friendly_boats );
	
	friendly_boat = undefined;
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		if( level.friendly_boats[i].script_int == 1 )
		{
			friendly_boat = level.friendly_boats[i];
		}
	}
	
	if( !IsDefined( friendly_boat ) )
	{
		//IPrintLnBold( "friendly_boat missing" );
	}
			
	maps\river_util::vehicle_cleanup( level.boat, friendly_boat );
	
	player = get_players()[0];
	if(player isinvehicle() == true)
	{
		//IPrintLnBold("a while later...");
		level.boat MakeVehicleUsable();
		level.boat UseBy(player);  // take player out of drivers seat
		level.boat MakeVehicleUnusable();
	}
	
	level.woods maps\river_util::put_actor_in_drivers_seat(level.boat);
	level.boat maps\_vehicle_turret_ai::disable_turret( 0 );		
}

fade_to_black( fade_out_time, fade_in_time, wait_time )
{
	if( !isdefined(wait_time) )
	{
		wait_time = 5;
	}

    black_bg = NewHudElem(); 
    black_bg.x = 0; 
    black_bg.y = 0; 
    black_bg.alpha = 0; 
    black_bg.horzAlign = "fullscreen"; 
    black_bg.vertAlign = "fullscreen"; 
    black_bg SetShader( "black", 640, 480 ); 

    // Fade in
    black_bg FadeOverTime(fade_out_time); 
    black_bg.alpha = 1;

 	wait( wait_time );
 	 
	// Fade out
	black_bg FadeOverTime( fade_in_time ); 
	black_bg.alpha = 0; 
}


/*==========================================================================
FUNCTION: fullscreen_shader_fade
SELF: level (not used)
PURPOSE: quick way to make a fullscreen shader; white out, black out, etc, with 
	customizable fade times and alpha levels

ADDITIONS NEEDED:
==========================================================================*/
fullscreen_shader_fade( shader_name, fade_time, alpha_start, alpha_end )
{
	if( self == level )
	{
		hud_elem = NewHudElem();   // use a new hud element
	}
	else
	{
		hud_elem = self;  // already have a hud element, so use that one
	}
	
    hud_elem.x = 0; 
    hud_elem.y = 0; 
    hud_elem.alpha = alpha_start; 
    hud_elem.horzAlign = "fullscreen"; 
    hud_elem.vertAlign = "fullscreen"; 
    hud_elem SetShader( shader_name, 640, 480 ); 

    // Fade in
    hud_elem FadeOverTime( fade_time ); 
    hud_elem.alpha = alpha_end;  // 1 = full, 0 = removed
 	
 	wait( fade_time );  // FadeOverTime is effectively threaded - wait until fade is actually done

 	return hud_elem;  // only fade one way - return hud_elem for manipulation
}

camera_flash(fade_out_time, fade_in_time)
{
    black_bg = NewHudElem(); 
    black_bg.x = 0; 
    black_bg.y = 0; 
    black_bg.alpha = 0; 
    black_bg.horzAlign = "fullscreen"; 
    black_bg.vertAlign = "fullscreen"; 
    black_bg SetShader( "white", 640, 480 ); 

    // Fade in
    black_bg FadeOverTime(fade_out_time); 
    black_bg.alpha = 1;

 	 wait(1);
	// Fade out
	black_bg FadeOverTime( fade_in_time ); 
	black_bg.alpha = 0; 
}


/////////////////////////////////
// FUNCTION: mortar_model_init
// CALLED ON: Level Initialization
// PURPOSE: Pre caches the model
// ADDITIONS NEEDED: 
/////////////////////////////////

mortor_model_init()
{
	precacheModel( "projectile_cbu97_clusterbomb" );
}


//*****************************************************************************
// FUNCTION: river_mortar_attack_boats_event()
// CALLED ON: level
// PURPOSE: Objective for the player to destroy X number of mortor firing guns
// ADDITIONS NEEDED: 
//*****************************************************************************

river_mortar_attack_boats_event()
{
	player = get_players()[0]; 

	// Get the active missile launcher(s)

	// VO for the morttar attack area
	level thread maps\river_vo::vo_mortar_attack_trucks();
		
	// Set off a warning threat to the players
	self thread mortar_warning_intro();
	self waittill( "missile threat sent" );

		
	//****************************************************
	// While we have enemy guns alive , fire at the player
	//****************************************************

	level thread mortar_missile_firing_update();

	while( level.mortar_guns.size )
	{
		// If any of the guns have been killed, remove them
		for( i=0; i<level.mortar_guns.size; i++ )
		{
			if( level.mortar_guns[i].ent.health <= 0 )
			{
				// Delete the effects on the mortar
				level.mortar_guns[i].left_light delete();
				level.mortar_guns[i].right_light delete();
				
				// Remove the mortar from the array
				level.mortar_guns = array_remove( level.mortar_guns, level.mortar_guns[i] );
				level notify( "mortar_gun_destroyed" );		// used by VO
				break;
			}
		}
		
		wait( 0.1 );
	}

	wait( 2.25 );
		
	// Remove the message to head to the bridge	
	//level thread message_about_helicopters();

	level notify( "river_mortar_objective_complete" );	
}

init_mortar_headlights()
{
	level.mortar_guns = [];
	level.mortar_guns[0] = spawnstruct();
	level.mortar_guns[0].ent = GetEnt( "rocket_launcher_1", "targetname" );
	level.mortar_guns[0].ent.health = 500;
	level.mortar_guns[0].left_light = add_mortar_light( level.mortar_guns[0].ent, "tag_headlight_left" );
	level.mortar_guns[0].right_light = add_mortar_light( level.mortar_guns[0].ent, "tag_headlight_right" );
	
	level.mortar_guns[1] = spawnstruct();
	level.mortar_guns[1].ent = GetEnt( "rocket_launcher_2", "targetname" );
	level.mortar_guns[1].ent.health = 500;
	level.mortar_guns[1].left_light = add_mortar_light( level.mortar_guns[1].ent, "tag_headlight_left" );
	level.mortar_guns[1].right_light = add_mortar_light( level.mortar_guns[1].ent, "tag_headlight_right" );
	
	level.mortar_guns[2] = spawnstruct();
	level.mortar_guns[2].ent = GetEnt( "rocket_launcher_3", "targetname" );
	level.mortar_guns[2].ent.health = 500;
	level.mortar_guns[2].left_light = add_mortar_light( level.mortar_guns[2].ent, "tag_headlight_left" );
	level.mortar_guns[2].right_light = add_mortar_light( level.mortar_guns[2].ent, "tag_headlight_right" );
	
}

//*****************************************************************************
//*****************************************************************************

add_mortar_light( ent, tag_name )
{
	link_origin = spawn( "script_model", ent GetTagOrigin( tag_name ) );
	link_origin.angles = ent GetTagAngles( tag_name );
	link_origin SetModel( "tag_origin" );
	link_origin linkto( ent, tag_name );
	playfxontag( level._effect["truck_headlight"], link_origin, "tag_origin" );
	return( link_origin );
}


//*****************************************************************************
//*****************************************************************************

mortar_missile_firing_update()
{
	player = get_players()[0]; 

	while( level.mortar_guns.size )
	{
		index = randomintrange( 0, level.mortar_guns.size );
		
		gun = level.mortar_guns[index].ent;
		
		gun thread maps\river_vo::vo_mortar_fired_at_player();
		level thread fire_river_missile( gun.origin, player.origin, 1.0, 1.0, 42*8 );

		// Delay between missile attacks		
		wait RandomFloatRange( 3.9, 6.5 );	// 4.2, 7
	}	
}


//*****************************************************************************
//*****************************************************************************

init_mortor_vehicle_movement( guns )
{
	wait( 0.5 );
	
	ent1 = getent( "rocket_launcher_1", "targetname" );
	node1 = GetVehicleNode( "vehicle_mortar_path_1", "targetname" );	
	ent1 AttachPath( node1 );

	ent2 = getent( "rocket_launcher_2", "targetname" );
	node2 = GetVehicleNode( "vehicle_mortar_path_2", "targetname" );
	ent2 AttachPath( node2 );
	
	ent3 = getent( "rocket_launcher_3", "targetname" );
	node3 = GetVehicleNode( "vehicle_mortar_path_3", "targetname" );		
	ent3 AttachPath( node3 );

	ent1.takedamage = false;
	ent2.takedamage = false;
	ent3.takedamage = false;

	ent1 thread go_path( node1 );
	ent2 thread go_path( node2 );
	ent3 thread go_path( node3 );
	
	wait( 1 );
	
	ent1 SetSpeed( 0 );
	ent2 SetSpeed( 0 );
	ent3 SetSpeed( 0 );
	
	flag_wait( "missile_launcher_engagement_started" );
//	IPrintLnBold( "MORTAR PATH STARTING" );

	init_mortar_headlights();  // turns on missile launcher headlights so they don't seem to pop in

	ent1.takedamage = true;
	ent2.takedamage = true;
	ent3.takedamage = true;
	
	if( ent1.health > 0 )
	{
		ent1 ResumeSpeed( 10 );
	}
	
	if( ent2.health > 0 )
	{
		ent2 ResumeSpeed( 10 );
	}
	
	if( ent3.health > 0 )
	{
		ent3 ResumeSpeed( 10 );
	}
}


//*****************************************************************************
//*****************************************************************************

cleanup_mortor_vehicles()
{
	mortar1 = getent( "rocket_launcher_1", "targetname" );
	if( isdefined(mortar1) )
	{
		mortar1 delete();
	}

	mortar2 = getent( "rocket_launcher_2", "targetname" );
	if( isdefined(mortar2) )
	{
		mortar2 delete();
	}

	mortar3 = getent( "rocket_launcher_3", "targetname" );
	if( isdefined(mortar3) )
	{
		mortar3 delete();
	}
}


//*****************************************************************************
//*****************************************************************************

message_about_helicopters()
{
	screen_message_create( &"RIVER_HEAD_TO_BRIDGE" );
	
	wait( 4 );
	
	screen_message_delete();	
}


/////////////////////////////////
// mortar_warning_intro()
/////////////////////////////////

mortar_warning_intro()
{
	level.woods thread maps\river_vo::playVO_proper( "look_out_mortars", 0 );
	level.bowman thread maps\river_vo::playVO_proper( "there_on_the_move", 5 );
	
	wait( 1 );

	targets = [];
	targets[ targets.size ] = getstruct( "rocket_target_1", "targetname" );
	targets[ targets.size ] = getstruct( "rocket_target_2", "targetname" );
	targets[ targets.size ] = getstruct( "rocket_target_3", "targetname" );

	level thread fire_river_missile( level.mortar_guns[0].ent.origin, targets[0].origin, 1.25, 1.4, 42, 1 );	// medium one
	level thread fire_river_missile( level.mortar_guns[1].ent.origin, targets[1].origin, 1.5,  1.2, 42, 1 );		// far one
	level thread fire_river_missile( level.mortar_guns[2].ent.origin, targets[2].origin, 1.0,  1.0, 42, 1 );		// near one
	
	wait( 2 );
	
	self notify( "missile threat sent" );
}


/////////////////////////////////
// FUNCTION: fire_river_missile
// CALLED ON: Vehicle (TBD)
// PURPOSE: Targets a player or friendly boat and inflicts a lot of damage
// ADDITIONS NEEDED: 
//
// spawn_pos: 
// aim_pos:
// speed_scale: <optional>				Changes the speed of the missiles
// height_scale: <optional>				Changes the default height of the missiles
// randomize_target_radius: <optional>	The bigger the value, the less accurate the missile
// effect_type: <optional>				0=dirt effect, 1=big water effect, 2=small water effect
/////////////////////////////////

fire_river_missile( spawn_pos, aim_pos, speed_scale, height_scale, randomize_target_radius, effect_type )
{
	//
	big_impact_effect = 0;

	// Create the missile and make visible with a trail
	missile = Spawn_a_model( "tag_origin", spawn_pos );
	PlayFXOnTag(level._effect["smoketrail"], missile, "tag_origin");
	missile setModel( "projectile_cbu97_clusterbomb" ); 

	// Get a position to aim for, with a little randomness
	//aim_pos = target GetOrigin();
	
	if( isdefined( randomize_target_radius ) )
	{
		dx = RandomFloatRange( -1*randomize_target_radius, randomize_target_radius );			// 42*8
		dy = RandomFloatRange( -1*randomize_target_radius, randomize_target_radius );
		aim_pos = aim_pos + ( dx, dy, 0 );
	}

	// Set the speed and height of the arc based on the distance to the target
	speed = 42*40;			// 42*38
	if( isdefined( speed_scale ) )
	{
		speed = speed * speed_scale;
	}
	
	min_height = 42*3;
	max_height = 42*26;			// 42*16
	height = max_height;

	dz = ( missile.origin[2] - aim_pos[2] ) / 100;
	height -= ( dz * 16 );
	if( height < min_height )
	{
		height = min_height;
	}

	if( isdefined( height_scale ) )
	{
		height = height * height_scale;
		big_impact_effect = 1;
	}
	
	// Fire that misssile
	missile thread river_mortor_move( aim_pos, speed, height );
	missile playsound ( "wpn_river_artillery_fire" );
	missile playloopsound( "wpn_river_rocket_loop" );

	// Wait for the Impact		
	missile waittill("mortor_strike");
		
	wait( 0.01 );

	// Process the Impact
	// TODO: Do a bullet trace to find the effect type to play, BulletTrace(org, org+(0,0,-2000), false, undefined);


	if( isdefined( effect_type ) )
	{
		if( effect_type == 0 )
		{
			PlayFX( level._effect["airstrike_hit"], missile.origin );
		}
		else if (effect_type == 1 )
		{
			PlayFX( level._effect["water_large_hit"], missile.origin );
		}
		else
		{
			PlayFX( level._effect["water_rpg_hit"], missile.origin );
		}
	}
	else
	{
		if( (RandomInt(100) < 40) || (big_impact_effect) ) 
		{
			PlayFX( level._effect["water_large_hit"], missile.origin );
		}
		else
		{
			PlayFX( level._effect["water_rpg_hit"], missile.origin );
		}
	}
	
	RadiusDamage( missile.origin, 42*27, 1800, 950 );	// 42*25, 1600, 750
	
	Earthquake( 0.6, 1.2, missile.origin, 3000 );
		
	// Push the boats around
	missile_impact_push_boats( missile.origin, 42*20, 42*40 );
	
	missile playsound( "exp_shell_hit_boat" );
	wait( 0.1 );
	missile Delete();
}


/////////////////////////////////
// FUNCTION: missile_impact_push_boats
// CALLED ON: 
// PURPOSE: Makes all the boats within range wobble on impact
// ADDITIONS NEEDED: 
/////////////////////////////////

missile_impact_push_boats( hit_pos, inner_radius, outer_radius )
{
	vehicles = getentarray( "script_vehicle", "classname" );

	for( i=0; i<vehicles.size; i++ )
	{
		veh = vehicles[i];
				
		dist = Distance( veh.origin, hit_pos );
		if( dist <= outer_radius )
		{
			fx = RandomFloatRange( 70, 150 );
			fy = RandomFloatRange( 70, 150 );
			force = ( fx, fy, 320 );
			hitpos = ( 0.5, 0.5, 1 );
		
			// should we reduce the force?
			if( dist > inner_radius )
			{
				mag = (800 - 200);
				frac = 1.0 - ((dist - inner_radius) / mag);
				force = ( force[0]*frac, force[1]*frac, force[2]*frac );
			}

			veh LaunchVehicle( force, hitpos, true, true );	
		}
	}
}


/////////////////////////////////
// FUNCTION: river_mortor_move
// CALLED ON: mortor
// PURPOSE: Fires mortars with arc's throught rhe air at targets
// ADDITIONS NEEDED: 
/////////////////////////////////

river_mortor_move( target_position, speed, height )
{
	self endon ("death");

	start_position = self.origin;

	start_time = gettime() / 1000;

	// Calculate the distance to travel (in 2d)
	dist_travelled = 0;
	total_dist = (	(self.origin[0]-target_position[0]) * (self.origin[0]-target_position[0]) + 
					(self.origin[1]-target_position[1]) * (self.origin[1]-target_position[1]) + 
					(self.origin[2]-target_position[2]) * (self.origin[2]-target_position[2]));
	total_dist = sqrt( total_dist );

	// Get the 2d direction delta
	dir = vectornormalize( target_position - self.origin );

	// Now we have the direction vector, play the muzzle flash
//	PlayFX( level._effect["artillery_muzzle"], self.origin, AnglesToForward(self.angles) );
	PlayFX( level._effect["artillery_muzzle"], self.origin, dir );
 
	// Mortor travels to target
	last_time = start_time;
	last_pos = self.origin;
	
	frac = 0.0;
	last_frac = 0.0;
	audio_incomming_played = 0;
	while( dist_travelled < total_dist )
	{
		wait( 0.01 );
		
		// Get the time delta
		time = gettime() / 1000;
		dt = time - last_time;
		last_time = time;
	
		// Slow down the speed of the missile as we are near the arc of the curve
		
		slow_start = 0.38;					// 0.38
		slow_mid = 0.55;					// 0.65
		slow_end = 0.75;					// 0.8
		slow_amount = speed * 0.45;			// 0.65
		end_speedup = speed * 3.0;			// 3.0
				
		if( last_frac < slow_start )
		{
			current_speed = speed;
		}
		// Slow down on the way up
		else if( (last_frac >= slow_start) && (last_frac <= slow_mid) )
		{
			mag = slow_mid - slow_start;
			diff_frac = 1.0 - ((slow_mid - last_frac) / mag);
			current_speed = speed - (slow_amount*diff_frac);
		}
		// Start to gain speed back down
		else if( (last_frac > slow_mid) && (last_frac <= slow_end) )
		{
			mag = slow_end - slow_mid;
			diff_frac = (slow_end - last_frac) / mag;
			current_speed = speed - (slow_amount*diff_frac);
		}
		// Last bit really fast
		else
		{
			mag = 1.0 - slow_end;
			diff_frac = 1.0 - ((1.0 - last_frac) / mag);
			current_speed = speed + (end_speedup*diff_frac);
		}
		
		// Get the distance travelled
		inc = dt * current_speed;
	
		// Add the base movement
		add_vec = ( dir[0]*inc, dir[1]*inc, dir[2]*inc );
		
		missile_height = self.origin[2] + dir[2]*inc;
		missile_pos = self.origin + add_vec;
		
		dist_travelled += inc;
	
		last_frac = frac;
		frac = dist_travelled / total_dist;
		if( frac > 1.0 )
		{
			frac = 1.0;
		}
		
		// Sin curves go from 0 to 180 degrees for an arc
		angle = 180 * frac;
		sinx = sin( angle );
		
		height_offset = height * sinx;
			
		base_height = start_position[2] + ((target_position[2]-start_position[2])*frac);
		self.origin = ( missile_pos[0], missile_pos[1], base_height+height_offset );
		
		self.angles = VectorToAngles( self.origin - last_pos ); 
		last_pos = self.origin;
		
		// Check for final audio "woosh"
		if( (!audio_incomming_played) && (frac > 0.6) )
		{
			self playsound ( "exp_river_artillery_incoming" );
			audio_incomming_played = 1;
		}
	}

	self notify( "mortor_strike" );	
}


//-------------------------------------------------------------
// ANIMATE BINOCULAR LOOK
// 
// End binocular look with flag: binocular_look_end
//
#using_animtree ("generic_human");
boat_binocular_look()
{	
	// gets the AIs to look foward. This function returns in 1 second
	// NOTE: Add more parameters to include more AIs. Ex: ( level.woods, level.bowman, ... )
	//maps\river_util::look_forward_on_boat( level.woods );
	
	// link self to the boat, so he cannot rotate anymore
	/*
	boat_linker = spawn( "script_model", level.woods.origin );
	boat_linker.angles = level.woods.angles;
	boat_linker SetModel( "tag_origin" );
	boat_linker linkto( level.boat );
	*/
	//level.woods linkto( level.boat, "tag_passenger10" );
	
	// start with binocular up
	level.boat anim_single_aligned( level.woods, "binocs_up", "tag_passenger10" );
	
	// at this point, we run a loop
	// Up Idle -> Up to Lower -> Lower Idle -> Lower to Up -> LOOP
	while( !flag( "binocular_look_end" ) )
	{
		level.woods StopAnimScripted();
		level.woods ClearAnim( %root, 0 );
		// This idle is 6 seconds long. So 1 iteration is more than enough
		level.boat anim_single_aligned( level.woods, "binocs_up_idle", "tag_passenger10"  );
		
		// at this point, if flag is set, we should exit the loop and put the binocs down
		if( flag( "binocular_look_end" ) )
		{
			break;
		}
		
		level.woods StopAnimScripted();
		level.woods ClearAnim( %root, 0 );
		// lowers the binocs
		level.boat anim_single_aligned( level.woods, "binocs_up_to_half", "tag_passenger10"  );
		
		// at this point, if flag is set, we should pick up the binocs immediately and then down
		if( flag( "binocular_look_end" ) )
		{
			level.woods StopAnimScripted();
			level.woods ClearAnim( %root, 0 );
			level.boat anim_single_aligned( level.woods, "binocs_half_to_up", "tag_passenger10"  );
			break;
		}
		
		level.woods StopAnimScripted();
		level.woods ClearAnim( %root, 0 );
		// idle at lowered position. This is almost 4 seconds long
		level.boat anim_single_aligned( level.woods, "binocs_half_idle", "tag_passenger10"  );
		
		level.woods StopAnimScripted();
		level.woods ClearAnim( %root, 0 );
		// we will put the binocs up no matter what, at this point
		level.boat anim_single_aligned( level.woods, "binocs_half_to_up", "tag_passenger10"  );
	}

	level.woods StopAnimScripted();
	level.woods ClearAnim( %root, 0 );
	// finally, put the binocs down
	level.boat anim_single_aligned( level.woods, "binocs_down", "tag_passenger10"  );
	
	level.woods enable_cqbwalk();
	level.woods enable_heat();
	
//	level.woods unlink();
//	level.woods LinkTo( level.boat );
	//boat_linker delete();
}

binocs_attach( guy )
{
	//iprintlnbold( "attach" );
	/*
	guy.binocs = spawn( "script_model", guy GetTagOrigin( "tag_weapon_left" ) );
	guy.binocs.angles = guy GetTagAngles( "tag_weapon_left" );
	guy.binocs SetModel( "t5_weapon_static_binoculars" );
	guy.binocs LinkTo( guy, "tag_weapon_left" );
	*/
	
	guy attach( "t5_weapon_static_binoculars", "tag_weapon_left" );
}

binocs_detach( guy )
{
	//iprintlnbold( "detach" );
	//guy.binocs Delete();
	
	guy detach( "t5_weapon_static_binoculars", "tag_weapon_left" );
	guy useweaponhidetags( "commando_acog_sp" );
}



//*****************************************************************************
// self = level
//*****************************************************************************

check_if_player_jumps_in_copter_blades()
{
	copter_pos = ( -34760, -64117, 0 );

	// Check for the player jumping into the helicopter blased in the intro
	while( 1 )
	{
		player_height = level.player.origin[2];
		
		// jump seems to move from -10 to 27 units
		// 27 world units seems to he the top of the jump unless the geo changes ;0)
		
		if( player_height > 10 )
		{
			player_pos = ( level.player.origin[0], level.player.origin[1], 0 );
			dist = Distance( player_pos, copter_pos );
			if( dist < 80 )
			{
				//IPrintLnBold( &"RIVER_WATCH_YOUR_HEAD" );
				maps\_utility::missionFailedWrapper( &"RIVER_WATCH_YOUR_HEAD" );
			}
		}

		if( flag("aftermath_done") == true )
		{
			return;
		}
	
		wait( 0.01 );
	}
}


