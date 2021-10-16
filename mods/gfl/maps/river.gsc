/*===========================================================================
Script: Travis Janssen
Build: Mike Madden
AP: Tyler Sparks
Production: Danny Donaho
-----------------------------------------------------------------------------
level flow:

EVENT 1 - boat_raid_event: river_drive.gsc
beat 1: aftermath (village raid aftermath)
beat 2: boat_drag
beat 3: boat_drive ("crash and burn" from doc)
beat 4: river_pacing ("in the thick" from doc)

EVENT 2 - pilot_rescue_event: river_jungle.gsc
beat 1: jungle_approach ("run through the jungle" from doc
beat 2: wounded_man
beat 3: sniper_duel

EVENT 3 - getaway_event: river_rail.gsc
beat 1: C5_approach ("wrecked" from doc)
beat 2: recapture_pbr
beat 3: getaway_rail_beat
-----------------------------------------------------------------------------
script_vehiclespawngroup:
2 - boat_drive - sampans coming around first turn after dual bridges plus non-threatening gaz63_troops
3 - boat_drive - two sampans and gaz63+quad50
4 - boat_drive - "dropoff truck"with guys in it (gaz63troops)
5 - boat_drive - gaz63 with quad50 that you can destroy with dyn_ent rocks 
6 - boat_drive - sampans from fuel depot area, plus background non-threatening trucks (2)
8 - river_pacing - boss boat and 2 other boats for foreshadowing
10 - boat_drive - first turn 2 (group of 3 sampans) + non-threatening gaz63_flatbed
12 - boat_drive - helicopters for entry battle 
13 - boat_drive - left side path single quad50
14 - boat_drive - first turn troop truck
15 - boat_drive - gaz63 flatbed as player enters s curve area
16 - getaway_rail - "initial sampans" after player is on bow gun
17 - getaway_rail - second group of sampans after player's on bow gun
18 - boat_landing - sampan that arrived before the player's boat at crash site
19 - helicopter_flyby - 2 helicopters land, 1 helicopter drops off rappelling guys
20 - friendly pbrs
21 - recapture_pbr - patrol boat
22 - recapture_pbr - sampans that drop off guys on shore to the east
23 - recapture_pbr - sampans that drop off guys on shore to the west
24 - recapture_pbr - sampans that go into alcove and kill friendly boat
25 - recapture_pbr - sampans that shoot down plane nose with rpg
26 - getaway_rail - "boss boat #2", which comes in before the actual boss boat in event 3
27 - boat_drive - helicopters coming from south in opening battle (replaced west ones, #12)
28 - boat drive - OLD HELICOPTERS from opening battle. probably safe to remove these
30 - boat_drive - left side path single quad50 #3
31 - boat_drive - quad50 # 3
32 - boat_drive - helicopter_assist helicopter #1 (fires at AA gun #2 )
33 - boat_drive - initial engagement flyby helicopters
34 - boat_drive - missile launcher helicopters
35 - boat_drive - aftermath village hueys
36 - boat_drive - third AA gun helicopters
37 - river pacing - flyby helicopter trio
38 - boat dropoff - survey/support hueys
39 - jungle section - support hueys
40 - boat drive - second helicopter in second sampan encounter
100 - old boat drag helicopter on spline; being replaced with an animated model
-----------------------------------------------------------------------------
script_exploders:
101 - 105 = pieces of blockade bridge, 101 = left, 105 = right
200 - 202 = pieces of helicopter attack bridge. 200 = left, 202 = right
===========================================================================*/


/*===========================================================================
		boat_landing();  // beat 1
		helicopter_flyby();  // beat 2
		fight_uphill();  // beat 3
		investigate_plane(); // beat 4
		plane_nose_section(); // beat 5
		run_to_boat(); // beat 6
===========================================================================*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_rusher;
#include maps\_music;

main()
{
	// Global flags
	flag_init( "binocular_look_end" ); // tell AI to stop looking around with binoculars
	
	// Keep this first for CreateFX
	maps\river_fx::main();	
	
	// no friendly fires
	//level.friendlyFireDisabled = 0;
	
	// Who is the guy on the boat that is allowed to fire missiles
	level.missile_ai_guy = "woods";
	level.missile_pbr_delay_time = 0;
	
	// -- STARTS/SKIPTOS --
	default_start( ::level_progression_function);
	
	// event 1 beats
	add_start("aftermath", ::start_aftermath, &"AFTERMATH");
	add_start("boat_drop", ::start_boat_drop, &"BOAT_DROP");
	add_start( "first_engagement", ::start_first_engagement, &"FIRST_ENGAGEMENT" );
	add_start( "helicopter_bridge", ::start_helicopter_bridge, &"HELICOPTER_BRIDGE" );
	add_start( "missile_launchers", ::start_missile_launchers, &"MISSILE_LAUNCHERS" );
	add_start( "AA_guns", ::start_AA_guns, &"AA_GUNS" );
	add_start( "first_sampan_encounter", ::start_first_sampan_encounter, &"FIRST_SAMPAN_ENCOUNTER" );
	add_start("boss_boat", ::start_boss_boat, &"BOSS_BOAT");
	add_start( "boat_drag", ::start_boat_drag, &"BOAT_DRAG_START" );
	add_start("boat_drive", ::start_boat_drive, &"BOAT_DRIVE");
	add_start("river_pacing", ::start_river_pacing, &"RIVER_PACING");
	
	// event 2 beats
	add_start("boat_landing", ::start_boat_landing, &"BOAT_LANDING");
	add_start("NVA_ambush", ::start_NVA_ambush, &"NVA_AMBUSH");
	add_start("fight_uphill", ::start_fight_uphill, &"FIGHT_UPHILL");
	add_start("investigate_plane", ::start_investigate_plane, &"INVESTIGATE_PLANE");
	add_start("plane_nose_section", ::start_nose_section, &"NOSE_SECTION");
	
	// event 3 beats

	
	precache_everything(); 
	
	maps\_load::main();

	maps\river_features::init_drones();
	level thread maps\_tree_snipers::main();  // turn on tree snipers


//	maps\river_fx::main();
	maps\river_amb::main();
	maps\river_anim::main();
	
	initializations();
	
	level thread objective_main();
	
	SetSavedDvar( "phys_buoyancy", "1" );	

	// global wind settings
	SetSavedDvar( "wind_global_vector", "-234 -100 0" );	
	
	// set sun sample size
	level.default_sun_samplesize = GetDvar( #"sm_sunSampleSizeNear");
	SetSavedDvar("sm_sunSampleSizeNear", 1.208);
	//player SetClientDvar( "dynEnt_sentientAutoActivate", 0 );

	// Reduce the force of impacts on physics objects
	// Makes it impossible to flip the boat	
	SetSavedDvar( "phys_vehicleDamageFroceScale", 0.22 );
	
	SetDvar( "r_waterwavespeed", "0.305 0.405 0.505 0.605" );
	SetDvar( "r_waterwaveamplitude", "1.7 3.3 0 7.6" );
	SetDvar( "r_waterwavewavelength", "1000 485 837 655" );
	
	// enable mitton water!
	WaterSimEnable( true );
	
	// no ragdoll on drones
	level.no_drone_ragdoll = true;

	//temp_struct = getstruct( "bowman_teleport_struct", "targetname" );
	//level.boat.origin = temp_struct.origin;
	//level.boat.angles = temp_struct.angles;


//	/#  //-- Roughout Billboard
//		level create_billboard();	
//		level thread update_billboard( "Map Start", "Event Type", "Event Size", "0" );
//	#/
	
//level thread mike_test();

}


//*****************************************************************************
//*****************************************************************************

mike_test()
{

level thread maps\river_features::run_to_bridge_drones_drones_start();
level thread maps\river_features::aa_gun2_friendly_drones_start();
	
	

//maps\river_features::bridge_drones_start();
	
//	IPrintLnBold("About to blow up bridge");
//	wait( 2 );
//	level notify("woodbridge_start");



	
//level thread maps\river_features::boss_boat_fight();
	

//	wait( 60 );
//	IPrintLnBold("DELETING TREES");
//	wait( 1 );
//	maps\river_features::cleanup_destructable_trees( 1 );


//	wait( 2 );
//	IPrintLnBold("STATING VEHICLE");
//	maps\river_features::intro_vehicles();

//	wait(2);
//	IPrintLnBold("STARTING DRONES");
//	level thread maps\river_features::missile_attack_drones_group2();
	
}


//*****************************************************************************
//*****************************************************************************

start_aftermath()
{
	level_progression_function("boat_raid_event", "aftermath");
	
    level thread audio_snapshot_override();
	
}

start_boat_drop()
{
	flag_set("player_inside_boat");
	flag_set("aftermath_done");
	
	level.reznov move_ai_for_skipto("stern_port_node");			
	//level.woods move_ai_for_skipto("bow_action_node");		
	level.woods move_ai_for_skipto_on_boat( "tag_passenger10" );
	//level.bowman move_ai_for_skipto("bow_action_node_right");
	level.bowman move_ai_for_skipto_on_boat( "tag_gunner3" );
	//level.bowman maps\river_util::put_actor_on_bow_gun( level.boat, true );

	start_teleport("boat_drag_start");
	
	level_progression_function("boat_raid_event", "boat_drop");
}

start_boat_drive()
{
	flag_set("aftermath_done");
	flag_set("player_inside_boat");
	flag_set("boat_drop_done");	
	flag_set( "helicopters_destroy_bridge" );
	trigger = GetEnt("helicopter_entrance_trigger", "targetname");  // old = chinook_comes_over_mountainside_trigger
	trigger notify("trigger");	
	
	//level.boat MakeVehicleUsable();
	player = get_players()[0];
	player EnableInvulnerability();  // to be removed when player leaves boat
	
	level.boat move_boat_for_skipto("boat_drive_boat_start", true);
	maps\river_util::move_friendly_boats("boat_drive_start_pbr");
	//maps\river_util::put_reznov_on_player_controlled_gun();
	
	start_teleport("boat_drive_start");

	level thread level_progression_function("boat_raid_event", "boat_drive");	
	
	wait( 2 );
	
	trigger notify("trigger");	
}

start_river_pacing()
{
	flag_set("aftermath_done");
	flag_set("player_inside_boat");
	flag_set("boat_drop_done");
	flag_set("boat_drive_done");
	flag_set("display_boat_hp");
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	

	level.boat MakeVehicleUsable();
		
	player = get_players()[0];
	level.boat usevehicle(player, 0);	
//	start_teleport("river_pacing_start");

	maps\_vehicle::scripted_spawn( 3 );

	level.boat move_boat_for_skipto("river_pacing_boat_start_new" );
	level.boat thread maps\river_util::monitor_boat_damage_state();	
	
	level thread audio_snapshot_override();

//	level.bowman maps\river_util::put_actor_on_bow_gun(level.boat);  // removed because of dialogue issues
//	level.bowman.animname = "bowman";
	//level.bowman move_ai_for_skipto_on_boat( "tag_gunner3" );
	
//	maps\river_util::put_reznov_on_player_controlled_gun();
//	level.woods move_ai_for_skipto_on_boat( "tag_passenger10" );

	level.woods LinkTo( level.boat, "tag_passenger10", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.bowman LinkTo( level.boat, "tag_gunner3", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.reznov LinkTo( level.boat, "tag_passenger12", ( 0, 0, 0 ), ( 0, 0, 0 ) );	
	
	level.woods gun_switchto( "commando_acog_sp", "right" );
	level.woods useweaponhidetags( "commando_acog_sp" );
	
	level.bowman gun_switchto( "commando_acog_sp", "right" );
	level.bowman useweaponhidetags( "commando_acog_sp" );	
	
	level thread level_progression_function("boat_raid_event", "river_pacing");
	
	wait( 5 );
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();	
}

start_boat_landing()
{
	flag_set("boat_drive_done");
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );		
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "boss_boat_started" );
	flag_set( "river_pacing_done" );
	flag_set( "boss_boat_killed" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 9200 );
	maps\_vehicle::scripted_spawn( 3 );
	
	level thread audio_snapshot_override();
	
	level.boat move_boat_for_skipto("boat_landing_boat_start", true);
	
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}
	
	// move boat #1 behind player boat
	for(i=0; i<level.friendly_boats.size; i++)
	{
		if(level.friendly_boats[i].script_int == 1)
		{
			level.friendly_boats[i] move_boat_for_skipto("boat_1_river_pacing");
			wait(1); 
			path = GetVehicleNode("boat_1_river_pacing", "targetname");
			level.friendly_boats[i] drivepath(path);
			level.friendly_boats[i] thread maps\_vehicle_turret_ai::disable_turret( 0 );
		}
		else
		{
			level.friendly_boats[i] Delete();
		}
	}	

	
//	start_teleport("jungle_approach_start");	
	level thread maps\river_drive::player_control_of_boat_starts();
	level.boat thread maps\river_features::boat_ads_control();
	level.player thread maps\river_features::boat_hud_init( level.boat );	
	
	level.woods LinkTo( level.boat, "tag_passenger10", ( 0, 0, 20 ), ( 0, 0, 0 ) );
	//level.woods move_ai_for_skipto_on_boat( "tag_passenger10" );
	level.bowman LinkTo( level.boat, "tag_gunner3", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.reznov LinkTo( level.boat, "tag_passenger12", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	level.boat UseBy(player);  // take player out of drivers seat	
//	level.bowman maps\river_util::put_actor_on_bow_gun(level.boat, true );
//	level.woods maps\river_util::put_actor_in_drivers_seat(level.boat);	
	
	player = get_players()[0];
	maps\river_util::keep_player_in_boat();
	level.boat usevehicle(player, 0);  // put player in drivers seat	
	
	level thread level_progression_function("land_event", "boat_landing");	
	
	level.woods maps\river_util::remove_rpg_firing();
	level.bowman maps\river_util::remove_rpg_firing();
	
	wait( 5 );
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();	
	
	boss_boat = GetEnt( "boss_boat_1", "targetname" );
	boss_boat notify( "death" );
}


start_NVA_ambush()
{
	flag_set("boat_drive_done");
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );		
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "boss_boat_started" );
	flag_set( "boss_boat_killed" );
	flag_set( "river_pacing_done" );
	flag_set( "boat_docked" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 9200 );
	maps\_vehicle::scripted_spawn( 3 );
	
	level.boat move_boat_for_skipto("boat_landing_boat_start", true);
	
	level thread audio_snapshot_override();
	
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}
	
	// move boat
	level.boat move_boat_for_skipto("player_boat_in_alcove");		

	// move boat #1 to alcove
	for(i=0; i<level.friendly_boats.size; i++)
	{
		if(level.friendly_boats[i].script_int == 1)
		{
			level.friendly_boats[i] thread move_boat_for_skipto("end_spline_friendly_pbr_1_alcove");
		//	level.friendly_boats[i] thread maps\river_util::redshirts_go_ashore_in_alcove();
			level.friendly_boats[i] thread maps\_vehicle_turret_ai::disable_turret( 0 );	
		}
		else
		{
			level.friendly_boats[i] Delete();
		}
	}

	reznov_shore_point = getstruct("jungle_approach_reznov_start", "targetname");
	AssertEx(IsDefined(reznov_shore_point), "reznov_shore_point is missing in friendly_squad_gets_off_boat in jungle_approach beat");
	
	bowman_shore_point = getstruct("jungle_approach_bowman_start", "targetname");
	AssertEx(IsDefined(bowman_shore_point), "bowman_shore_point is missing in friendly_squad_gets_off_boat in jungle_approach beat");

	woods_shore_point = getstruct("jungle_approach_woods_start", "targetname");
	AssertEx(IsDefined(woods_shore_point), "woods_shore_point is missing in friendly_squad_gets_off_boat in jungle_approach beat");	
	
	
	level.reznov maps\river_util::actor_moveto( reznov_shore_point );
	level.woods maps\river_util::actor_moveto( woods_shore_point );
	level.bowman maps\river_util::actor_moveto( bowman_shore_point );

	level.woods AllowedStances( "stand", "crouch", "prone" );
	level.woods gun_switchto( "commando_acog_sp", "right" );	
	level.bowman AllowedStances( "stand", "crouch", "prone" );
	level.bowman gun_switchto( "commando_acog_sp", "right" );

	level.woods maps\river_util::remove_rpg_firing();
	level.bowman maps\river_util::remove_rpg_firing();
	
	allies_nodes = GetNodeArray( "boat_landing_american_cover", "targetname" );
	AssertEx( ( allies_nodes.size > 0 ), "allies_nodes missing in boat_landing" );

	allies = GetAIArray( "allies" );
	
	for( i = 0; i < allies.size; i++ )
	{
		
		allies[ i ] SetGoalNode( random( allies_nodes ) );
	}

//	simple_spawn( "jungle_initial_ambush_guys", maps\river_jungle::ambush_spawner );	
		
		
	//start_teleport("jungle_approach_bowman_start");
	
	maps\_vehicle::scripted_spawn( 39 );
	
	huey3 = GetEnt( "jungle_support_huey_3", "targetname" );
	AssertEx( IsDefined( huey3 ), "huey3 is missing in start_NVA_ambush" );
	huey3 maps\river_jungle::populate_huey( 2, "support_huey_3_passenger" );
	huey3 notify( "dropoff_done" );
	
	// Used for VO dialogue lines
	level.us_pilot_2 = huey3;
	level.us_pilot_2.animname = "us_pilot_2";
	
	huey_dropoff_node = GetVehicleNode( "huey_dropoff_peeloff_rail_7", "targetname" );
	huey3.origin = huey_dropoff_node.origin;
	
	if( IsDefined( huey3.passengers ) )
	{
		offset = 4;  // this is used to get AI in the correct unload position. driver, copilot, gunner1 and gunner2 = original 4
		
		for( i = 0; i < huey3.passengers.size; i++ )
		{
			//self thread maps\_vehicle_aianim::guy_unload( self.passengers[ i ], i + offset );	
			//self thread vehicle_unload_single( self.passengers[ i ] );
			huey3 thread maps\river_jungle::vehicle_unload_single( huey3.passengers[ i ], i + offset );
		}
	}	
	
	
	player = getplayers()[0];
	level.boat usevehicle(player, 1);
	
	wait( 0.5 );
	
	level.boat UseBy( player );
	level.boat MakeVehicleUnusable();
	
	level thread level_progression_function("land_event", "NVA_ambush");	

	boss_boat = GetEnt( "boss_boat_1", "targetname" );
	boss_boat notify( "death" );

	wait( 4 );
	
	huey3 drivepath( huey_dropoff_node );	
	
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();	
}

start_fight_uphill()
{
	flag_set("boat_drive_done");
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );		
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "boss_boat_started" );
	flag_set( "boss_boat_killed" );
	flag_set( "river_pacing_done" );
	flag_set( "boat_docked" );
	flag_set( "begin_helicopter_support" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 39 );
	maps\_vehicle::scripted_spawn( 3 );
	
	// move boat
	level.boat move_boat_for_skipto("jungle_approach_boat_start");	
	
	level.woods move_ai_for_skipto( "woods_fight_uphill_start" );
	level.bowman move_ai_for_skipto( "bowman_fight_uphill_start" );
	level.reznov move_ai_for_skipto( "reznov_fight_uphill_start" );
	
	level thread audio_snapshot_override();
	
	start_teleport("sniper_duel_start");
	
	level thread level_progression_function("land_event", "fight_uphill");	
	
	wait( 4 );
	
	friendly_squad_relocator_for_skiptos( "friendly_hillside_cover_3" );

	level.woods maps\river_util::remove_rpg_firing();
	level.bowman maps\river_util::remove_rpg_firing();
	
	level.woods.animname = "woods";
	level.bowman.animname = "bowman";

	huey3 = GetEnt( "jungle_support_huey_3", "targetname" );
	huey3 maps\_vehicle_turret_ai::set_forced_target();
	
	level.bowman set_force_color( "p" );
	level.woods set_force_color( "b" );
	level.reznov set_force_color( "y" );	

	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();		
}

start_investigate_plane()
{
	flag_set("aftermath_done");
	flag_set("player_inside_boat");
	flag_set("boat_drop_done");
	flag_set("boat_drive_done");
	flag_set("river_pacing_done");
	flag_set("boat_docked");	
	flag_set("jungle_approach_done");
	flag_set("wounded_man_done");
	flag_set("sniper_duel_done");
	flag_clear("display_boat_hp");	
	flag_set( "boat_landing_sampan_engagement_done" );
	flag_set( "fight_uphill_done" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 3 );
	
	level thread audio_snapshot_override();
	
	// move boat
	level.boat move_boat_for_skipto("jungle_approach_boat_start");	
	
	//so start_teleport works
	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i].script_noteworthy = "squad";
	}
	
	start_teleport("plane_start", "squad" );
	
	level thread Level_Progression_Function("plane_event", "investigate_plane");
	
	
	wait( 5 );
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();	
	
	//get rid of rpgs for skipto
	level.woods thread maps\river_util::remove_rpg_firing();
	level.bowman thread maps\river_util::remove_rpg_firing();	
	
}

start_nose_section()
{
	flag_set("aftermath_done");
	flag_set("player_inside_boat");
	flag_set("boat_drop_done");
	flag_set("boat_drive_done");
	flag_set("river_pacing_done");
	flag_set("boat_docked");	
	flag_set("jungle_approach_done");
	flag_set("wounded_man_done");
	flag_set("sniper_duel_done");
	flag_clear("display_boat_hp");	
	flag_set( "boat_landing_sampan_engagement_done" );
	flag_set( "fight_uphill_done" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 3 );
	
	level thread audio_snapshot_override();
	
	// move boat
	level.boat move_boat_for_skipto("jungle_approach_boat_start");	
	
	//so start_teleport works
	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i].script_noteworthy = "squad";
	}
	
	start_pos = GetEnt( "nose_waypoint_6", "targetname" );
	
	//start_teleport("plane_start", "squad" );
	player = get_players()[0];
	player SetOrigin( start_pos.origin );
	
	level thread Level_Progression_Function("plane_event", "investigate_plane");
	
	wait( 2 );
	
	//get rid of rpgs for skipto
	level.woods thread maps\river_util::remove_rpg_firing();
	level.bowman thread maps\river_util::remove_rpg_firing();	

	//IPrintLnBold( "level notify: plane_hinds" );
	level notify( "plane_hinds" );
}


start_boss_boat()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );	
	flag_set( "bunker_dead" );	

	maps\river_util::keep_player_in_boat();

	maps\_vehicle::scripted_spawn( 3 );

	// get rid of bridge
	bridge = GetEnt( "bridge_blocker_helicopters", "targetname" );
	PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], bridge.origin );
	
	level thread audio_snapshot_override();
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "boss_boat_encounter_player_skipto", true );
	
//	angles = ( 0, 180, 0 );
//	level.boat.angles = angles;
//	get_players()[0] SetPlayerAngles( angles );
	
		// move boat armada
	move_boat_armada_for_skipto( "AA_gun_objective_boat_skipto" );
	maps\river_drive::move_boats_with_player( );
	
	// Add the grenade launcher to the PBR
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	level.boat thread maps\river_drive::player_aim_entity_update();
	level.woods thread maps\river_drive::setup_RPG_turret( "tag_passenger10" );
	level.bowman thread maps\river_drive::setup_RPG_turret( "tag_gunner3" );
	
	wait( 1 );
	
	level.boat usevehicle(get_players()[0], 0);	
	
	bow_gun_redshirt = simple_spawn_single( "bow_gun_redshirt" );
	level.kid = bow_gun_redshirt;
	bow_gun_redshirt enter_vehicle( level.boat );
//	bow_gun_redshirt LinkTo( level.boat, "tag_gunner_turret1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	// run main
	//bridge Delete();
//	level thread level_progression_function( "boat_raid_event", "first_sampan_encounter" );		
	
	wait( 5 );
	
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}
	
	level thread level_progression_function("boat_raid_event", "boss_boat_encounter");	
	
	wait( 5 );
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();	
}



// "initial_engagement_boat_skipto" / initial_engagement_player_boat_skipto
start_first_engagement()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "initial_engagement_started" );

	maps\river_util::keep_player_in_boat();
	
	level thread audio_snapshot_override();
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "initial_engagement_player_boat_skipto", true );
	level.boat usevehicle(get_players()[0], 0);
	
		// move boat armada
	move_boat_armada_for_skipto( "initial_engagement_boat_skipto" );
	maps\river_drive::move_boats_with_player( );
	
	
	// Add the grenade launcher to the PBR
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	
	// run main
	level_progression_function( "boat_raid_event", "initial_island_engagement" );
}

// "helicopter_bridge_boat_skipto" / helicopter_bridge_player_boat_skipto
start_helicopter_bridge()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	
	maps\river_util::keep_player_in_boat();
	level.boat thread maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );
	
	level thread audio_snapshot_override();
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "boat_skipto_missile_launchers", true );
	level.boat usevehicle(get_players()[0], 0);
	
		// move boat armada
	move_boat_armada_for_skipto( "helicopter_bridge_boat_skipto" );
	maps\river_drive::move_boats_with_player( );
	
	// Add the grenade launcher to the PBR
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();	
	level.boat thread maps\river_drive::player_aim_entity_update();
	level.woods thread maps\river_drive::setup_RPG_turret( "tag_passenger10" );
	level.bowman thread maps\river_drive::setup_RPG_turret( "tag_gunner3" );
	// run main
	level thread level_progression_function( "boat_raid_event", "helicopters_fly_in_and_destroy_bridge" );	
	
	wait( 2 );
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}	
	
	
	trigger = GetEnt("helicopter_entrance_trigger", "targetname");  // old = helicopter_entrance_trigger
	trigger notify( "trigger" );
}

// "helicopter_bridge_boat_skipto" / helicopter_bridge_player_boat_skipto
start_missile_launchers()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	
	maps\river_util::keep_player_in_boat();
	
	level thread audio_snapshot_override();
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "helicopter_bridge_player_boat_skipto", true );
	
		// move boat armada
	move_boat_armada_for_skipto( "boat_skipto_missile_launchers" );
	maps\river_drive::move_boats_with_player( );
	
	// Add the grenade launcher to the PBR
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	level.boat thread maps\river_drive::player_aim_entity_update();
	level.woods thread maps\river_drive::setup_RPG_turret( "tag_passenger10" );
	level.bowman thread maps\river_drive::setup_RPG_turret( "tag_gunner3" );
	
	level.boat thread maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );
		
	wait( 1 );
	level.boat usevehicle(get_players()[0], 0);	
		
	// run main
	level thread level_progression_function( "boat_raid_event", "missile_launcher_engagement" );	
	
	wait( 2 );
	
	trigger = GetEnt("helicopter_entrance_trigger", "targetname");  // old = helicopter_entrance_trigger
	trigger notify( "trigger" );
}

// AA_gun_objective_boat_skipto / AA_gun_objective_player_boat_skipto
start_AA_guns()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );

	maps\river_util::keep_player_in_boat();
	level.boat thread maps\_vehicle_turret_ai::enable_turret( 0, "fast_mg", "axis", 0.75, 2 );
	
	level thread audio_snapshot_override();
	
	// get rid of bridge
	bridge = GetEnt( "bridge_blocker_helicopters", "targetname" );
	PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], bridge.origin );
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "AA_gun_objective_player_boat_skipto", true );
	
		// move boat armada
	move_boat_armada_for_skipto( "AA_gun_objective_boat_skipto" );
	maps\river_drive::move_boats_with_player(  undefined, undefined, 2000, 1000, -1200 );
	
	// Add the grenade launcher to the PBR
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	level.boat thread maps\river_drive::player_aim_entity_update();
	level.woods thread maps\river_drive::setup_RPG_turret( "tag_passenger10" );
	level.bowman thread maps\river_drive::setup_RPG_turret( "tag_gunner3" );

	bow_gun_redshirt = simple_spawn_single( "bow_gun_redshirt" );
	level.kid = bow_gun_redshirt;
	bow_gun_redshirt enter_vehicle( level.boat );
	bow_gun_redshirt.animname = "kid";
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		if( level.friendly_boats[ i ].script_int == 2 )
		{
			level.friendly_boats[ i ] thread maps\river_drive::armada_wait_for_player( "stop_at_second_tower", "AA_gun_objective_started" );	
		}
	}
	
	level thread maps\river_drive::player_control_of_boat_starts();	
	level.boat thread maps\river_features::boat_ads_control();
	level.player thread maps\river_features::boat_hud_init( level.boat );
	
	wait( 1 );
	level.boat usevehicle(get_players()[0], 0);
		
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}
	
	// run main
	//bridge Delete();
	level thread level_progression_function( "boat_raid_event", "AA_gun_encounter" );	
	
	wait( 1 );
	
	trigger = GetEnt( "player_in_front_of_boats_trigger", "targetname" );
	trigger notify( "trigger" );
	
		
}

// first_boat_encounter_player_skipto
start_first_sampan_encounter()
{
	// set flags
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );

	maps\river_util::keep_player_in_boat();
	
	level thread audio_snapshot_override();

	level.friendlyFireDisabled = 1;

	// get rid of bridge
	bridge = GetEnt( "bridge_blocker_helicopters", "targetname" );
	PlayFX( level._effect[ "temp_destructible_building_smoke_white" ], bridge.origin );
	
	
	// move player boat with AI
	level.boat move_boat_for_skipto( "first_boat_encounter_player_skipto", true );
	
		// move boat armada
//	move_boat_armada_for_skipto( "AA_gun_objective_boat_skipto" );
//	maps\river_drive::move_boats_with_player( );
	
	// Add the grenade launcher to the PBR
	bow_gun_redshirt = simple_spawn_single( "bow_gun_redshirt" );
	level.kid = bow_gun_redshirt;
	bow_gun_redshirt enter_vehicle( level.boat );
	
	wait( 1 );
	level.boat usevehicle(get_players()[0], 0);
	
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	level.boat thread maps\river_drive::player_aim_entity_update();
	level.woods thread maps\river_drive::setup_RPG_turret( "tag_passenger10" );
	level.bowman thread maps\river_drive::setup_RPG_turret( "tag_gunner3" );
	
	
	//bridge Delete();
	level thread maps\river_drive::player_control_of_boat_starts();
	level.boat thread maps\river_features::boat_ads_control();
	level.player thread maps\river_features::boat_hud_init( level.boat );	
	// run main
	level thread level_progression_function( "boat_raid_event", "first_sampan_encounter" );		
	
	heli_rocket_target1 = getstruct( "third_AA_gun_helicopter_2_5_start", "targetname" );
	
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_drive::vehicle_shootat_target, 1.5, 0.5 );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_drive::vehicle_windowdressing );
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_util::huey_cone_light );	
//	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_drive::helicopter_speed_scale, 2000 );	
	add_spawn_function_veh( "third_AA_gun_helicopter_2", maps\river_util::helicopter_fires_rockets_at_target, "fire_rockets", heli_rocket_target1, undefined, 2 );
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 40 );  // REMOVE TEMP ONLY
	
	wait( 5 );
	
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	for( i = 0; i < missile_launchers.size; i++ )
	{
		missile_launchers[ i ] Delete();
	}
}

start_boat_drag()
{
	flag_set( "boat_drop_done" );
	flag_set( "aftermath_done" );
	flag_set( "player_inside_boat" );
	flag_set( "helicopters_destroy_bridge" );
	flag_set( "initial_engagement_started" );
	flag_set( "missile_launcher_engagement_started" );
	flag_set( "helicopter_bridge_destroyed" );
	flag_set( "AA_gun_objective_started" );
	flag_set( "AA_gun_objective_complete" );	
	flag_set( "boss_boat_killed" );
	flag_set( "ZPU_dead" );
	flag_set( "bunker_ZPU_objectives_start" );
	flag_set( "bunker_dead" );	
	
	maps\_vehicle::scripted_spawn( 3 );
	
	level.boat move_boat_for_skipto( "boat_drag_start_player_skipto_new" );
	
	level.boat thread maps\river_drive::PBR_grenade_launcher();
	level.boat thread maps\river_drive::player_control_of_boat_weapon_overheating();
	
	level.boat MakeVehicleUsable();
	level.boat thread maps\river_util::monitor_boat_damage_state();			
	player = get_players()[0];
	level.boat usevehicle(player, 0);	
	
	// attach AIs to the boat (only needed for the skipto)
	level.woods forceteleport( level.boat GetTagOrigin( "tag_passenger7" ) );
	level.bowman forceteleport( level.boat GetTagOrigin( "tag_passenger6" ) );
	level.reznov forceteleport( level.boat GetTagOrigin( "tag_passenger2" ) );
	
	level thread level_progression_function( "boat_raid_event", "boat_drag" );	
	
	wait( 5 );
	zpu = GetEnt( "truck_with_gun_north", "targetname" );
	zpu Delete();
}

precache_everything()
{
	// boat
	PreCacheModel("t5_veh_boat_pbr");
	PreCacheModel("t5_veh_boat_pbr_stuff");
	PreCacheModel("t5_veh_boat_pbr_set01");	
	PreCacheModel("t5_veh_boat_pbr_antenna_static");	
	PreCacheModel("weapon_c4_obj");
	//PreCacheModel("t5_veh_air_c5_crashed_forward_section");
//	PreCacheModel("anim_jun_sampan_large_a");
	PreCacheModel("dest_jun_sampan_large_d0");
//	PreCacheModel("t5_veh_boat_nvapbr_static_dead");
	
	// player model/viewarms
	PreCacheModel("viewmodel_usa_jungmar_wet_arms");
	PreCacheModel("viewmodel_usa_jungmar_wet_player");
	PreCacheModel("viewmodel_usa_jungmar_wet_player_fullbody");
	PreCacheModel("t5_gfl_ump45_viewbody");

	PreCacheItem("rpg_player_sp");
	PreCacheItem("dragunov_sp");	
	PreCacheModel( "p_rus_metal_crate" );  // hind crates
	
	// weapons 
	PreCacheItem( "commando_acog_sp" );
	PreCacheItem( "commando_extclip_sp" );
	PreCacheItem( "commando_dualclip_sp" );
	PreCacheItem( "mk_commando_sp" );
	PreCacheItem( "commando_mk_sp" );
	PreCacheItem( "commando_gl_sp" );
	PreCacheItem( "gl_commando_sp" );
	PreCacheItem( "commando_acog_gl_sp" );
	PreCacheItem("china_lake_sp");
	PreCacheItem("rpg_magic_bullet_sp");
	PreCacheItem("rpg_river_missile_sp");
	PreCacheItem( "m202_flash_sp_river" );  // m202s for woods and bowman
	PreCacheModel( "t5_weapon_m202_world" ); 
	PreCacheItem( "ak74u_sp" );
	PreCacheItem( "ak74u_extclip_sp" );
	PreCacheItem( "ak74u_dualclip_sp" );
	PreCacheItem( "gl_ak74u_sp" );
	PreCacheItem( "ak74u_gl_sp" );
	PreCacheItem( "ak74u_acog_sp" );
	PreCacheItem( "ak74u_reflex_sp" );
	PreCacheItem( "m16_sp" );
	PreCacheItem( "m16_acog_sp" );
	PreCacheItem( "m16_extclip_sp" );
	PreCacheItem( "m16_dualclip_sp" );
	PreCacheItem( "gl_m16_sp" );
	PreCacheItem( "mk_m16_sp" );
	PreCacheItem( "m16_gl_sp" );
	PreCacheItem( "m16_mk_sp" );	
	
//	PreCacheItem("creek_big_flash_ak47_sp");
//	PreCacheItem("m8_white_smoke_sp");
//	PreCacheModel( "t5_weapon_viewmodel_M16A1" );
	PreCacheItem( "hind_rockets_sp" );  // HIND magic rockets
	
	PreCacheModel( "P_rus_camera" );
	PreCacheModel( "anim_jun_map" );
	
	PreCacheModel( "c_usa_jungmar_head1" );
	PreCacheModel( "c_usa_jungmar_head2" );
	PreCacheModel( "c_usa_jungmar_head3" );
	PreCacheModel( "c_usa_jungmar_head4" );
	PreCacheModel( "c_usa_jungmar_head5" );
	
	// falling tree model type here. remember to update CSV for this
//	level.falling_tree_model = "t5_foliage_tree_aquilaria01v";
//	PreCacheModel(level.falling_tree_model);
	//PreCacheModel("t5_veh_boat_nvapatrolboat");
	//PreCacheItem("btr60_grenade_gunner");
	
	// dyn ent spawns
//	PreCacheModel( "phys_floats_p_jun_wood_plank_large02" );
//	PreCacheModel( "phys_floats_p_jun_wood_plank_small02" );
//	PreCacheModel( "phys_floats_p_glo_corrugated_metal1" );
//	PreCacheModel( "phys_floats_p_glo_wood_crate_sml" );
	
	// Model used for the mortor weapon
	maps\river_drive::mortor_model_init();
	
	// Vignettes
	PreCacheModel("vehicle_ch46e_expensive");

	PreCacheShellShock("default");

	// HUD ICONS
	precacheshader("hud_icon_m60e4");

	// HUD ROCKETS
	PreCacheShader( "hud_hind_rocket" );
	PreCacheShader( "hud_hind_rocket_border_left" );
	PreCacheShader( "hud_hind_rocket_border_right" );

		
	// MISSILE RUMBLE
	PrecacheRumble("tank_fire");
	
	// BUFFALO
	PreCacheModel( "anim_asian_water_buffalo" );
	PrecacheModel( "tag_origin" );
	
	PrecacheModel( "t5_weapon_static_binoculars" );
	
	PreCacheShader( "cinematic" );
	
	character\c_usa_jungmar_assault::precache(); // load stuff for animated models
	character\c_usa_jungmar_cqb::precache(); 
	character\c_usa_jungmar_lmg::precache(); 
	character\c_usa_jungmar_shotgun::precache(); 
	character\c_usa_jungmar_snip::precache(); 
	maps\river_plane::precache_nova_body();
	
	character\gfl\character_gfl_rpk16::precache();
	character\gfl\character_gfl_nyto::precache();
}


initializations()
{
	setnorthyaw(90);
	//player SetClientDvar( "ik_enable", 0 );  // temp workaround for IK crash - 4/9/2010
	
//	level thread maps\river_util::main();	
	
	flag_init("display_boat_hp");
	flag_init("aftermath_done");
	flag_init("player_inside_boat");
	flag_init("boat_drop_done");
	flag_init("boat_drive_done");
	flag_init("player_driving_boat");
	
	flag_init("player_passed_split_bridge_area");
	flag_init("player_passed_first_turn_area");
	flag_init("player_passed_s_curve_a_area");
	flag_init("player_passed_s_curve_b_area");
	flag_init("player_passed_fuel_depot_area");
	flag_init("player_passed_cave_area");
	flag_init("blockade_destroyed");
	
	flag_init("river_pacing_done");
	flag_init("friendly_boat_speed_checks_done");
	flag_init("boat_landing_sampan_engagement_done");
	flag_init("boat_docked");
	flag_init("sniper_foreshadowing_done");
	flag_init("jungle_approach_done");
	flag_init( "hillside_encounter_starts" );
	flag_init("hillside_encounter_done");
	flag_init("wounded_man_done");
	flag_init("sniper_duel_done");
	flag_init("C5_approach_done");
	flag_init("bowman_freed");
	flag_init("C5_nose_check");
	flag_init("C5_nose_knockdown_done");
	flag_init("sniper_support_done");
	flag_init("recapture_pbr_done");
	flag_init("getaway_rail_done");
	flag_init("rail_bunkers_started");
	flag_init("rail_bunkers_complete");
	flag_init("boss_boat_blocked");
	flag_init("squad_moving");
	flag_init( "boatjack_started" );
	flag_init( "boatjack_done" );
	flag_init( "run_to_boat_done" );
	flag_init( "patrol_boat_arrives" );
	flag_init( "patrol_boat_landed" );
	flag_init( "patrol_boat_dead" );
	flag_init( "patrol_boat_disabled" );
	flag_init( "fight_uphill_done" );
	flag_init( "plane_crash_search_done" );
	flag_init( "squad_stays_with_player" );
	flag_init( "west_shore_sampans_landed" );
	flag_init( "boatjackers_on_shore" );
	flag_init( "getaway_rail_started" );
	flag_init( "helicopters_destroy_bridge" );
	flag_init( "missile_launcher_engagement_started" );
	flag_init( "AA_gun_objective_started" );
	flag_init( "AA_gun_objective_complete" );
	flag_init( "helicopter_bridge_destroyed" );
	flag_init( "show_directional_marker" );
	flag_init( "mortar_attack_2" );
//	flag_init( "initial_engagement_started" );  // declared in radiant on trigger
	flag_init( "boss_boat_started" );
	flag_init( "boss_boat_killed" );
	flag_init( "jungle_ambush_begins" );
	flag_init( "bunker_ZPU_objectives_start" );	
	flag_init( "ZPU_dead" );
	flag_init( "bunker_dead" );
	flag_init( "ready_for_boat_drive" );
	flag_init( "crate_anim_done" );
	flag_init( "knockdown_rockets_fired" );
	flag_init( "player_fallen" );
	flag_init( "quad50_1_dead" );
	flag_init( "quad50_2_dead" );
	flag_init( "quad50_3_dead" );
	flag_init( "movie_playing" );
	flag_init( "playing_boat_death" );
	flag_init( "woods_bowman_m202_ended" );
	flag_init( "player_at_wing" );
	
//	/#  // debug only
//		level create_billboard(); // Roughout Billboard
//	#/
	
	maps\river_anim::setup_player_anims();
	maps\river_util::setup_player_boat();
	level thread maps\river_util::setup_hero_squad();
		
	maps\river_util::setup_friendly_npc_boats();
	maps\river_util::setup_C5_nose_section(); // hide nose model to fix sorting issues
	maps\_rusher::init_rusher();
	maps\river_util::difficulty_scale();
	maps\river_util::setup_boat_regen();	
	level thread maps\river_util::main();
	
	level.callbackVehicleDamage = maps\river_util::check_vehicle_damage;
	
	// we don't use m16s in river, so assign commandos to drones
	level.drone_weaponlist_allies = [];
	level.drone_weaponlist_allies[ 0 ] = "commando_sp";
	
	level.drone_weaponlist_axis = [];
	level.drone_weaponlist_axis[ 0 ] = "ak74u_sp";
}


/*==========================================================================
FUNCTION: objective_main
SELF: level (not used)
PURPOSE: this is where all the objectives are handled throughout the map

ADDITIONS NEEDED: make remaining objectives use auto_objective functions
==========================================================================*/
objective_main()
{
	/#
		level thread maps\river_util::event_timer("LEVEL", "getaway_rail_done");
	#/
	
	

	
	// Meet up at the dock
	// auto_objective_single( ent_targetname, track_ent, flag_to_wait_for, objective_text, display_3d, text_for_3d_objective, updated_text, flag_to_wait_for_2, offset_3d_pos )
	meet_up_obj = auto_objective_single( "waypoint_1", false, "ready_for_boat_drive", &"RIVER_OBJ_MEET_AT_DOCK", true, undefined, undefined, undefined, ( 0, 0, 0 ) );
	Objective_Delete( meet_up_obj );
	
	
//	flag_wait( "ready_for_boat_drive" );
	
	steering_origin = Spawn( "script_origin", ( level.boat GetTagOrigin( "tag_driver" ) + ( 0, 0, 25 ) ) );
	steering_origin.targetname = "boat_steering_origin";
	steering_origin LinkTo( level.boat );
	
	// Take control of the boat
	drive_boat_obj = auto_objective_single( "boat_steering_origin", false, "aftermath_done", &"RIVER_OBJ_AFTERMATH", true );  // old = player_controlled_boat
	
	steering_origin Unlink();
	steering_origin Delete();
	
	Objective_Delete( drive_boat_obj );
	
	// Start the boat
//	auto_objective_single( "player_controlled_boat", false, "player_inside_boat", "Start the boat", true, "START" );
	
	// Find the location of Kravchenko's crashed plane
	level thread nav_points_objective( "waypoint_1", &"RIVER_OBJ_DRIVE_BOAT", 1500 );
	
	// Seek out the enemy targets --> get to bend --> Neutralize the enemy targets
	//auto_objective_single( undefined, false, "initial_engagement_started", "Seek out the enemy targets", false, undefined, "Neutralize the enemy targets", "missile_launcher_engagement_started" );
	
	flag_wait( "initial_engagement_started" );
	
	// Engage enemy targets
//	engage_obj = auto_objective_single( undefined, false, "missile_launcher_engagement_started", &"RIVER_OBJ_ENGAGE_ENEMY", false );
//	Objective_Delete( engage_obj );
	//auto_objective_single( ent_targetname, track_ent, flag_to_wait_for, objective_text, display_3d, text_for_3d_objective, updated_text, flag_to_wait_for_2 )
	
	// Destroy the missile launchers
	missile_launcher_objective();
	
	level thread destroy_enemy_targets(); 
	
	// Regroup at the bridge
	//helicopter_bridge_obj_num = auto_objective_single( "bridge_blocker_helicopters", false, "helicopter_bridge_destroyed", &"RIVER_OBJ_REGROUP_BRIDGE", true, undefined, undefined, undefined, ( 0, 0, 100 ) );
	//Objective_Delete( helicopter_bridge_obj_num );  // this is just a breadcrumb objective. delete from list when it's done
	
	// Infiltrate the enemy base
	//auto_objective_single( "river_pacing_begins_trigger", false, "AA_gun_objective_started", &"RIVER_OBJ_BOAT_DRIVE" );
	
	// Destroy the Anti-Aircraft cannons ( 3 total )
	AA_gun_objective();
	
	flag_wait( "bunker_ZPU_objectives_start" );	

	// Destroy the concrete bunker
	level thread bunker_objective();
	wait( 0.1 );
	level.objective_number++;  // objective numbers get updated at the end of the function, so we need to manually update here
	
	// Destroy the ZPU. &"RIVER_OBJ_ZPU"
	
	level thread ZPU_objective();
	level.objective_number++;
	
	// wait until both ZPU and bunker are dead to show breadcrumbs again
	flag_wait( "ZPU_dead" );
	flag_wait( "bunker_dead" );
	
	flag_set( "show_directional_marker" );

	// Engage the armored patrol boat - &"RIVER_OBJ_BOSS_BOAT"
	flag_wait( "boss_boat_started" );
	boss_boat_obj = auto_objective_single( "boss_boat_1", true, "boss_boat_killed", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, (0, 0, 300), true );
	Objective_Delete( boss_boat_obj );
	
	delaythread( 0.1, ::turn_off_directional_marker );	//turn off nav mrkr -jc
	
	//boat_drag_objective();

	flag_wait( "river_pacing_done" );

	// Regroup with American forces up river
	//regroup_upriver_obj = auto_objective_single( undefined, false, "boat_docked", &"RIVER_OBJ_BOAT_LANDING", false );
	//Objective_Delete( regroup_upriver_obj );

	hill_obj = nav_points_objective( "jungle_waypoint_1", &"RIVER_OBJ_FIGHT_UPHILL", 128, "jungle_ambush_begins", 0.25, true );
	flag_wait( "crate_anim_done" );
	Objective_State( hill_obj, "done" );
	
	auto_objective_single( "attack_lookat_trig", false, "knockdown_rockets_fired", &"RIVER_OBJ_KILL_STREAM_GUYS", true, undefined );
	
	//regroup_land_obj = auto_objective_single( "boat_landing_rendezvous_objective_point", false, "jungle_ambush_begins", &"RIVER_OBJ_LAND_REGROUP", true, undefined );
//	Objective_Delete( regroup_land_obj );
	
	// Kill the NVA soldiers by the stream
//	jungle_approach_begins = GetEnt("squad_back_to_boat_trigger", "targetname");
//	AssertEx(IsDefined(jungle_approach_begins), "jungle_approach_begins objective position is missing");	
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_KILL_STREAM_GUYS", jungle_approach_begins.origin);
//	flag_wait("boat_landing_sampan_engagement_done");
//	Objective_State(level.objective_number, "done");
//	level.objective_number++;

	// Reach the plane crash site at the top of the hill (follow Woods uphill)
	//auto_objective_single( "woods_ai", true, "fight_uphill_done", &"RIVER_OBJ_FIGHT_UPHILL", true, &"RIVER_OBJ_FOLLOW" );

//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_FIGHT_UPHILL", level.woods);
//	objective_set3d( level.objective_number, true, "default", "Follow" );
//	flag_wait("fight_uphill_done");
//	objective_set3d( level.objective_number, false );
//	Objective_State(level.objective_number, "done");
//	level.objective_number++;	
	
// not working with skiptos so putting this in script file - jc	
//	//marker at plane wing
//	obj_mrkr = GetEnt( "plane_trig", "targetname" );
//	
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_PLANE_CRASH_SEARCH", obj_mrkr.origin);
//	objective_set3d( level.objective_number, true );
//	trigger_wait( "plane_trig" );
//	
//	//marker at crate
//	obj_mrkr = GetEnt( "plane_crate_trig", "targetname" );
//	Objective_Position (level.objective_number, obj_mrkr );
//	objective_set3d( level.objective_number, true );
//
//	
//	//marker at nose section
//	obj_mrkr = getstruct( "plane_nose_obj", "targetname" );
//	Objective_Position (level.objective_number, obj_mrkr );
//	objective_set3d( level.objective_number, true );


	
	
	// Search the plane crash site for intel on Kravchenko        
//	investigate_crash = GetEnt("important_information_trigger", "targetname");
//	AssertEx(IsDefined(investigate_crash), "recapture_pbr is missing");
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_PLANE_CRASH_SEARCH", investigate_crash.origin);
//	objective_set3d( level.objective_number, true, "default", "INVESTIGATE" );
//	flag_wait("plane_crash_search_done");
//	objective_set3d( level.objective_number, false );
//	Objective_State(level.objective_number, "done");
//	level.objective_number++;
//
//	level thread bowman_secondary_objective_marker();
//
//	//	cover woods/bowman as they get back to the boat
//	// NOTE: player must kill the patrol boat AND be done with sniper support to proceed
//	current_objective = level.objective_number;
//	Objective_Add(current_objective, "current", &"RIVER_OBJ_SNIPER_SUPPORT", level.woods);
//	objective_set3d( current_objective, true, "default", "DEFEND" );	
//	flag_wait("sniper_support_done");
//	flag_wait_either( "patrol_boat_dead", "patrol_boat_disabled" );
//	objective_set3d( current_objective, false );
//	Objective_State(current_objective, "done");
//	level.objective_number++;
//	
//	// kill escaping NVA in the boat
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_boatjack", level.boat );
//	objective_set3d(level.objective_number, true, "default", "KILL" );
//	flag_wait("boatjack_done");
//	objective_set3d(level.objective_number, false );
//	Objective_State(level.objective_number, "done");
//	level.objective_number++;	
//	
//	//get back into the boat!
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_RECAPTURE_PBR", level.boat);
//	objective_set3d( level.objective_number, true, "default", "ESCAPE" );
//	flag_wait("run_to_boat_done");
//	objective_set3d( level.objective_number, false );
//	Objective_State(level.objective_number, "done");
//	level.objective_number++;
//	
//	escape_rail = GetEnt("getaway_rail_ends_trigger", "targetname");
//	AssertEx(IsDefined(escape_rail), "escape_rail is missing");
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_GETAWAY_RAIL", escape_rail.origin);
//	flag_wait("rail_bunkers_started");
////	Objective_State(level.objective_number, "invisible"); // additional objective
//	escape_rail_obj = level.objective_number;
//	level.objective_number++;
//	
//	destroy_bunkers = GetEntArray("rail_bunker", "targetname");
//	Objective_Add(level.objective_number, "active", "Destroy all the bunkers so the boat can move up");
//	AssertEx((destroy_bunkers.size > 0), "destroy_bunkers are missing");
//	array_thread(destroy_bunkers, maps\river_rail::set_objective_on_bunker);  // objective completed by those threads
//	flag_wait("rail_bunkers_complete");
//	Objective_State(level.objective_number, "done");

//	flag_wait("getaway_rail_done");
//	Objective_State(escape_rail_obj, "done");	
}

bunker_objective()  // &"RIVER_OBJ_BUNKER"
{
	bunker_obj = auto_objective_single( "concrete_MG_bunker_damage_trigger", false, "bunker_dead", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, ( 0, 0, 100 ), true );
	Objective_Delete( bunker_obj );	
}

ZPU_objective()
{
	ZPU_obj_num = auto_objective_single( "truck_with_gun_north", true, "ZPU_dead", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, ( 0, 0, 300 ), true );
	Objective_Delete( ZPU_obj_num );  // we only want to highlight this enemy with a 3d objective; delete the string after it's dead	
}

Destroy_enemy_targets()
{
	obj_num = auto_objective_single( undefined, false, "boss_boat_killed", &"RIVER_OBJ_DESTROY_TARGETS", false );
	Objective_Delete( obj_num );
}

missile_launcher_objective()
{
	flag_wait( "missile_launcher_engagement_started" );
	current_objective = level.objective_number;
	
	objective_text_array = [];  // TODO: replace with string references later
	objective_text_array[ 0 ] = &"RIVER_OBJ_MISSILES_DONE";
	objective_text_array[ 1 ] = &"RIVER_OBJ_MISSILES_1";
	objective_text_array[ 2 ] = &"RIVER_OBJ_MISSILES_2";
	objective_text_array[ 3 ] = &"RIVER_OBJ_MISSILES_3";
	
	missile_launchers = GetEntArray( "missile_launchers_group_1", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	array_thread( missile_launchers, ::notification_on_death, "missile_launcher_destroyed" );
	//array_thread( missile_launchers, ::remove_from_array_on_death, missile_launchers );
	
	obj_num = auto_objective_multiple( current_objective, objective_text_array, "helicopters_destroy_bridge", "missile_launcher_destroyed", missile_launchers, &"RIVER_OBJ_DESTROY", false, ( 0, 0, 250 ) );
	Objective_Delete( obj_num );
	level.objective_number++;
}

mortar_attack_2_objective()
{
	current_objective = level.objective_number;
	
	objective_text_array = [];  // TODO: replace with string references later
	objective_text_array[ 0 ] = "Destroy the missile launchers. ";
	objective_text_array[ 1 ] = "Destroy the missile launchers. 1 remaining.";
	objective_text_array[ 2 ] = "Destroy the missile launchers. 2 remaining.";
	objective_text_array[ 3 ] = "Destroy the missile launchers. 3 remaining.";
	
	missile_launchers = GetEntArray( "missile_launchers_group_2", "script_noteworthy" );
	AssertEx( ( missile_launchers.size > 0 ), "missile_launchers are missing" );
	array_thread( missile_launchers, ::notification_on_death, "missile_launcher_destroyed" );
	
	//auto_objective_multiple( objective_number, objective_text, flag_to_set_when_done, update_notification, array_ents, text_3d, display_closest_only )
	auto_objective_multiple( current_objective, objective_text_array, undefined, "missile_launcher_destroyed", missile_launchers );
	level.objective_number++;
}


AA_gun_objective()
{		
	flag_wait( "AA_gun_objective_started" );
	AA_1_obj = auto_objective_single( "boat_drive_left_path_quad50", true, "quad50_1_dead", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, (0, 0, 300) );
	Objective_Delete( AA_1_obj );
	
	flag_wait( "quad50_2_moves" );
	AA_2_obj = auto_objective_single( "quad50_2", true, "quad50_2_dead", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, (0, 0, 300) );
	Objective_Delete( AA_2_obj );	

	flag_wait( "quad50_3_moves" );
	AA_3_obj = auto_objective_single( "quad50_3", true, "quad50_3_dead", undefined, true, &"RIVER_OBJ_DESTROY", undefined, undefined, (0, 0, 300) );
	Objective_Delete( AA_3_obj );
}

AA_gun_objective_old()
{	
	flag_wait( "AA_gun_objective_started" );	
	level.objective_number++;
	
	current_objective = level.objective_number;
	
	objective_text = &"RIVER_OBJ_AA_GUNS";
	
	AA_guns = GetEntArray( "AA_guns", "script_noteworthy" );
	//AssertEx( ( AA_guns.size > 0 ), "AA_guns are missing" );
	array_thread( AA_guns, ::Notification_On_Death, "AA_gun_destroyed", level._effect[ "quad50_temp_death_effect" ] );
	
	obj_num = auto_objective_multiple( current_objective, undefined, "AA_gun_objective_complete", "AA_gun_destroyed", AA_guns, &"RIVER_OBJ_DESTROY", true, ( 0, 0, 250 ) );
	Objective_Delete( obj_num );
	
}

boat_drag_objective()
{
	level waittill( "obj_head_for_chinook" );
	
	// get under the chinook
	obj_marker = getstruct( "boat_drag_obj_under_chinook", "targetname" );
	Objective_Add( level.objective_number, "current", &"RIVER_OBJ_DRAG_TO_CHOPPER", obj_marker.origin );
	Objective_Set3D( level.objective_number, true );
	flag_wait( "player_in_position_for_drag" );
	Objective_State( level.objective_number, "done" );
	Objective_Delete( level.objective_number );
	
	// tie the rope 
	level waittill( "boat_drag_tell_player_grab_rope" );
	Objective_Add( level.objective_number, "current", &"RIVER_OBJ_DRAG_TIE_ROPE" );
	flag_wait( "player_pressed_rope_tie_button" ); 
	Objective_State( level.objective_number, "done" );
	Objective_Delete( level.objective_number );
	
	// cut the rope
	level waittill( "player_finished_drag_anim" );
	Objective_Add( level.objective_number, "current", &"RIVER_OBJ_CUT_ROPE" );
	flag_wait( "rope_cut_success" );
	Objective_State( level.objective_number, "done" );
	Objective_Delete( level.objective_number );
	
	flag_wait( "drag_end_vo_complete" );
	obj_origin = level.boat GetTagOrigin( "tag_steering" ) + ( 0, 0, 5 );
	Objective_Add( level.objective_number, "current", &"RIVER_OBJ_DRIVE_BOAT", obj_origin );
	Objective_Set3D( level.objective_number, true, "default", "USE" );
	level waittill( "player_driving_boat_again" );
	Objective_State( level.objective_number, "done" );
	Objective_Delete( level.objective_number );
}

bowman_secondary_objective_marker()
{
	flag_wait("patrol_boat_arrives");
	// destroy the NVA patrol boat
	level.objective_number++;
	bowman_objective = level.objective_number;
	Objective_Add( bowman_objective, "current", "", level.bowman);
	objective_set3d( bowman_objective, true, "default", "DEFEND");
	flag_wait( "sniper_support_done" );
	objective_set3d( bowman_objective, false );
	Objective_State( bowman_objective, "done");
	level.objective_number++;	
}

/*==========================================================================
FUNCTION: nav_points_objective
SELF: level (not used)
PURPOSE: create a string of 3d objective markers to give the player constant
		direction

ADDITIONS NEEDED: figure out a way to make this work with skiptos. skipto flag?
==========================================================================*/
nav_points_objective( origin_targetname, descriptive_text, update_distance, flag_set_on_completion, wait_time, no_complete )
{
	AssertEx( IsDefined( origin_targetname ), "origin_noteworthy is missing for nav_points_objective" );
	
	origin = GetEnt( origin_targetname, "targetname" );
	
	if( !IsDefined( level.objective_number ) )
	{
		level.objective_number = 0;
	}
	
	if( !IsDefined( wait_time ) )
	{
		wait_time = 1;
	}
	
	flag_set( "show_directional_marker" );
	old_distance = update_distance;
	current_objective = level.objective_number;
	level.nav_points_objective_num = current_objective;
	level.objective_number++;  // make sure no other objective can use this one so update it immediately	
	
	Objective_Add( current_objective, "current", descriptive_text );
	level thread nav_display_toggle( current_objective );
	
	while( true )
	{
		
		if( IsDefined( origin.target ) )
		{			
			next_origin = GetEnt( Origin.target, "targetname" );
			Objective_Position( current_objective, origin.origin );
		
			if( IsDefined( origin.radius ) ) // temporarily overwrite distance
			{
				update_distance = origin.radius;
			}		
			else if( IsDefined( origin.script_int ) )  
			{
				update_distance = origin.script_int;
			}			
			
			while( ( Distance( origin.origin, get_players()[0].origin ) > update_distance ) && ( IsDefined( origin ) ) )
			{
				wait( wait_time );
			}
			
			if( IsDefined( origin.radius ) )
			{
				update_distance = old_distance;
			}
			else if( IsDefined( origin.script_int ) )  // put original distance back if it was used
			{
				update_distance = old_distance;
			}
			
			if( IsDefined( origin.script_noteworthy ) )
			{
				level notify( origin.script_noteworthy );
			}
			
			origin Delete(); // clean up as we go
			
			origin = next_origin;  // go to next origin in line for next position
		}
		else
		{
			level notify( "stop_tracking_nav_points" );
			break;
		}
	}
	
	maps\river_util::Print_debug_message( "ran out of origins for nav_points_objective!", true );
	
	if( IsDefined( no_complete ) && ( no_complete == true ) )
	{
		// don't complete objective
	}
	else
	{
		Objective_State( current_objective, "done" );
	}
	
	return current_objective;
}

// only use this when nothing else is working.
turn_off_directional_marker()
{
	if( !IsDefined( level.nav_points_objective_num ) )
	{
		PrintLn( "no nav point objectives exist!" );
		return;
	}
	
	flag_clear( "show_directional_marker" );
	objective_set3d( level.nav_points_objective_num, false );  
}

turn_off_current_3d_objective()
{
	if( !IsDefined( level.objective_number ) )
	{
		PrintLn( "no objectives to turn off" );
		return;
	}
	
	objective_set3d( level.objective_number, false );
}

/*==========================================================================
FUNCTION: nav_display_toggle
SELF: level (not used)
PURPOSE: provides a way to turn nav display points on and off

ADDITIONS NEEDED:
==========================================================================*/
nav_display_toggle( current_objective )
{
	level endon( "stop_tracking_nav_points" );
	
	while( true )
	{
		flag_wait( "show_directional_marker" );
		objective_set3d( current_objective, true, "default" );
		
		// wait for flag to be cleared
		while( flag( "show_directional_marker" ) == true )
		{
			wait( 1 );
		}
		
		objective_set3d( current_objective, false );	
	}
}

/*===========================================================================
This function takes in the name of an event and the name of a beat that will
change where the playable section of the level begins. Error checking for 
beat names is done within the event functions themselves.
-----------------------------------------------------------------------------
ACCEPTABLE INPUT ARGUMENTS:
event_name: "boat_raid_event", "land_event", "getaway_event"
beat_name: "aftermath", "boat_drag", "boat_raid", "river_pacing", 
           "jungle_approach", "wounded_man", "sniper_duel", "C5_approach", 
           "recapture_pbr", "getaway_rail_beat". 
===========================================================================*/
level_progression_function(event_name, beat_name)
{	
	// default_start case will run here
	if(!IsDefined(event_name))  // done this way to prevent switch from using
	{							// an undefined "event_name" variable
		maps\river_drive::main();
		maps\river_jungle::main();
		maps\river_plane::main();		
	}
	else
	{   // skiptos will be run here
		switch(event_name)
		{
			case "boat_raid_event":  // event 1 
				maps\river_drive::main(beat_name);
				maps\river_jungle::main();
				maps\river_plane::main();
				break;
			case "land_event":  // event 2
				maps\river_jungle::main(beat_name);
				maps\river_plane::main();
				break;
			case "plane_event":  // event 3
				maps\river_plane::main();
				break;						
			default:  // normal progression; invalid input arguments go here
				maps\river_drive::main();
				maps\river_jungle::main();
				maps\river_plane::main();
				break;
		}
	}	
	
	nextmission();
}

move_boat_armada_for_skipto( node_array_name )
{
	if( !IsDefined( node_array_name ) )
	{
		//IPrintLnBold( "move_boat_armada_for_skipto is missing node_array_name. returning!" );
		return;
	}
	
	nodes = GetVehicleNodeArray( node_array_name, "script_noteworthy" );
	AssertEx( ( nodes.size >= level.friendly_boats.size ), "not enough nodes for a skipto in move_boat_armada_for_skipto" );
	AssertEx( ( nodes.size > 0 ), "nodes are missing in move_boat_armada_for_skipto" );
	
	for( i = 0; i < level.friendly_boats.size; i++ )
	{
		if( level.friendly_boats[ i ].script_int == 1 )
		{
			for( j = 0; j < nodes.size; j++ )
			{
				if( nodes[ j ].script_int == 1 )
				{
					level.friendly_boats[ i ] AttachPath( nodes[ j ] );
					level.friendly_boats[ i ].origin = nodes[ j ].origin;
					level.friendly_boats[ i ].angles = nodes[ j ].angles;
					level.friendly_boats[ i ] maps\_vehicle::getonpath( nodes[ j ] );
					level.friendly_boats[ i ] thread go_path( nodes[ j ] );
				}
			}
		}
		else if( level.friendly_boats[ i ].script_int == 2 )
		{
			for( j = 0; j < nodes.size; j++ )
			{
				if( nodes[ j ].script_int == 2 )
				{
					level.friendly_boats[ i ].origin = nodes[ j ].origin;
					level.friendly_boats[ i ].angles = nodes[ j ].angles;
					level.friendly_boats[ i ] maps\_vehicle::getonpath( nodes[ j ] );
					level.friendly_boats[ i ] thread go_path( nodes[ j ] );
				}
			}
		}
		else
		{
			for( j = 0; j < nodes.size; j++ )
			{
				if( nodes[ j ].script_int == 3 )
				{
					level.friendly_boats[ i ].origin = nodes[ j ].origin;
					level.friendly_boats[ i ].angles = nodes[ j ].angles;
					level.friendly_boats[ i ] maps\_vehicle::getonpath( nodes[ j ] );
					level.friendly_boats[ i ] thread go_path( nodes[ j ] );
				}
			}
		}
	}
}

move_boat_for_skipto(teleport_struct_name, teleport_ai, is_rail)  // self = boat
{
	AssertEx(IsDefined(teleport_struct_name), "teleport_struct_name is missing in move_boat_for_skipto function");
	teleport_struct = getstruct(teleport_struct_name, "targetname");
	if(!IsDefined(teleport_struct))
	{
		teleport_struct = GetVehicleNode(teleport_struct_name, "targetname");
		self AttachPath( Teleport_struct );
		self.origin = teleport_struct.origin;		
		self.angles = teleport_struct.angles;				
		
		//IPrintLnBold( "node used for move_boat_for_skipto" );
	}
	else 
	{
		AssertEx(IsDefined(self), "boat is missing in move_boat_for_skipto function");
		self.origin = teleport_struct.origin;		
		self.angles = teleport_struct.angles;				
		//IPrintLnBold( "struct used for move_boat_for_skipto" );
	}
	

	wait(0.5);
	
	if(self.targetname != "player_controlled_boat")  // not teleporting AI to specific positions for friendly boat squad
	{
		return;
	}
	
	// check to see if AI will teleport with boat. if so, link them to their positions in the boat before moving them
	if(IsDefined(teleport_ai))
	{
		if(teleport_ai == true)
		{
			if(IsDefined(is_rail))
			{
				if(is_rail == true)  // teleport to getaway_rail spots
				{
					level.reznov move_ai_for_skipto("stern_port_node");
					level.woods move_ai_for_skipto("boat_driver_node");
					level.bowman move_ai_for_skipto("bow_action_node_right");		
				}
			}
			else // teleport to generic boat spots
			{
				level.reznov move_ai_for_skipto_on_boat("tag_passenger12");
				level.woods move_ai_for_skipto_on_boat("tag_passenger10");
				level.bowman move_ai_for_skipto_on_boat("tag_gunner3");
			}	
		}
	}
}

// for use with move_boat_for_skipto function
move_ai_for_skipto(node_name)  // self = AI
{
	AssertEx(IsDefined(node_name), "node_name is missing in move_ai_for_skipto function");
	position = GetNode(node_name, "targetname");
	if(!IsDefined(position))
	{
		position = getstruct(node_name, "targetname");
		if(!IsDefined(position))
		{
			AssertMsg("node_name is not a node or a struct");
		}
		
		is_node = false;
	}
	else
	{
		is_node = true;
	}
	
	time_for_moveto = 0.5;
																	// TODO: change to teleport instead of actor_moveto
	self maps\river_util::actor_moveto(position, time_for_moveto);  // not threaded so move must be complete by linkto time
	
	if( is_node == true )
	{
		self SetGoalNode(position);
	}
	//self LinkTo(level.boat);
}

move_ai_for_skipto_on_boat( tag_name )  // nodes will be removed from the boat. use tags for reference.
{
	if( !IsDefined( tag_name ) )
	{
		AssertMsg( "tag_name is missing for move_ai_for_skipto_on_boat!" );
	}
	
	if( !IsDefined( level.boat GetTagOrigin( tag_name ) ) )
	{
		AssertMsg( "tag for " + self.targetname + " couldn't be found on the boat!" );
	}
	
	self Teleport( level.boat GetTagOrigin( tag_name ), level.boat GetTagAngles( tag_name ) );
	self LinkTo( level.boat, tag_name );
}

friendly_squad_relocator_for_skiptos( node_array_name )
{
	AssertEx( IsDefined( node_array_name ), "node_array_name is missing for friendly_squad_relocator_for_skiptos" );
	
	node_array = GetNodeArray( node_array_name, "targetname" );
	
	if( node_array.size < level.friendly_squad.size ) 
	{
		AssertMsg( "need more nodes for this skipto" );
	}
	
	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[ i ] Teleport( node_array[ i ].origin, node_array[ i ].angles );
	}
}

/*==========================================================================
FUNCTION: auto_objective_single
SELF: level 
PURPOSE: streamline adding in objectives since it's done in a predictable way
		
ADDITIONS NEEDED: - switch flag wait to level wait since flag sends notify when set?
	- add argument for optional objectives ( will need to be threaded when called )
==========================================================================*/
auto_objective_single( ent_targetname, track_ent, flag_to_wait_for, objective_text, display_3d, text_for_3d_objective, updated_text, flag_to_wait_for_2, offset_3d_pos, breadcrumb_hide )
{	
	AssertEx( IsDefined( flag_to_wait_for ), "flag_to_wait_for is required for auto_objective_single" );
	
	if( !IsDefined( level.objective_number ) )
	{
		level.objective_number = 0;
	}

	if( !isdefined(offset_3d_pos) )
	{
		offset_3d_pos = ( 0, 0, 0 );
	}
	
	if( IsDefined( display_3d ) && ( display_3d == true ) )
	{
		flag_clear( "show_directional_marker" );
	}
	else
	{
		flag_set( "show_directional_marker" );
	}
	
	current_objective = level.objective_number;
	
	if( IsDefined( ent_targetname ) )  // decide whether or not to put the objective marker on something
	{
		ent = GetEnt( ent_targetname, "targetname" );
		AssertEx( IsDefined( ent ), "ent is missing in auto_objective_single" );
		
		if( IsDefined( track_ent ) && ( track_ent == true ) )  // pass in entity to follow 
		{
			if( IsDefined( objective_text ) )
			{
				Objective_Add( current_objective, "current", objective_text, ent );
			}
			else
			{
				Objective_Add( current_objective, "active" );
				Objective_Position( current_objective, ent );
			}
		}
		else  // means it's a static position (probably being used on a trigger)
		{
			if( IsDefined( objective_text ) )
			{
				Objective_Add( current_objective, "current", objective_text, ent.origin );
			}
			else
			{
				Objective_Add( current_objective, "active" );
				Objective_Position( current_objective, ent.origin );
			}
		}
		
		if( ( IsDefined( display_3d ) ) && ( display_3d == true ) )  // if you want to display a 3d objective, do it here
		{
			if( IsDefined( text_for_3d_objective ) )
			{
				objective_set3d( current_objective, true, "default", text_for_3d_objective, -1, offset_3d_pos );
			}
			else
			{
				objective_set3d( current_objective, true, "default", "", -1, offset_3d_pos );
			}
		}		
	}
	else
	{
		// 3d objectives aren't used since there's no position to draw them on
		if( IsDefined( objective_text ) )
		{
			Objective_Add( current_objective, "current", objective_text );
		}
		else
		{
			Objective_Add( current_objective, "active" );
		}
	}
	
	flag_wait( flag_to_wait_for );
	
	if( IsDefined( updated_text ) && IsDefined( flag_to_wait_for_2 ) )
	{
		Objective_String( current_objective, updated_text );
		
		flag_wait( flag_to_wait_for_2 );
	}
	
	if( !IsDefined( breadcrumb_hide ) || ( breadcrumb_hide == false ) )
	{
		flag_set( "show_directional_marker" );  // always show directional marker when objective is done. will be handled by next objective anyway
	}
	
	Objective_State( current_objective, "done" );
	level.objective_number++;
	
	//IPrintLnBold( "objective " + current_objective + " complete!" );
	
	return current_objective;  // if we want to keep the particular objective, return it here
}

/*==========================================================================
FUNCTION: auto_objective_multiple
SELF: level
PURPOSE: because the objective system cannot remove individual indicies by
		itself, we need to update the array every time something would be
		removed. 
		-if objective_text is an array, the string and number of things left
		alive must be the same as the array index. 
		--> example: objective_text[ 1 ] = "One guy remaining"

ADDITIONS NEEDED: display_closest_only
==========================================================================*/
auto_objective_multiple( objective_number, objective_text, flag_to_set_when_done, update_notification, array_ents, text_3d, display_closest_only, offset_3d_pos )
{
	AssertEx( IsDefined( objective_number ), "objective_number for update_objective_on_death is missing." );
	if( !isdefined( flag_to_set_when_done ) )
	{
		maps\river_util::print_debug_message( "flag_to_set_when_done is missing in update_objective_on_death."  );
	}	
//	AssertEx( ( array_ents.size > 0 ), "array_ents for update_objective_on_death are missing" );
	AssertEx( ( array_ents.size <= 8 ), "array_ents can't be larger than 8, as that's the maximum the objective system supports." );

	flag_clear( "show_directional_marker" );

	if( !IsDefined( offset_3d_pos ) )
	{
		offset_3d_pos = ( 0, 0, 0 );
	}

	while( array_ents.size > 0 )
	{	
		if( IsDefined( objective_text ) && IsArray( objective_text ) )
		{
			AssertEx( ( objective_text.size >= array_ents.size ), "Not enough text strings to cover all entities. ");
			Objective_Add( objective_number, "current", objective_text[ array_ents.size ] );
		}
		else
		{
			if( IsDefined( objective_text ) )
			{
				Objective_Add( objective_number, "current", objective_text );
			}
			else
			{
				Objective_Add( objective_number, "current" );
			}
		}
		
		if( IsDefined( text_3d ) )
		{
			objective_set3d( objective_number, true, "default", text_3d, -1, offset_3d_pos );  
		}
		else
		{
			objective_set3d( objective_number, true, "default", "", -1, offset_3d_pos );
		}		
				
		if( ( IsDefined( display_closest_only ) ) && ( display_closest_only == true ) )	
		{
			closest_ent_num = 9999;  // arbitrarily high and outside range
			closest_distance = 99999;
			for( i = 0; i < array_ents.size; i++ )
			{
				current_distance = Distance( array_ents[ i ].origin, get_players()[ 0 ].origin );
				
				if( current_distance < closest_distance )
				{
					closest_ent_num = i;
					closest_distance = current_distance;
				}
			}
			
			if( closest_ent_num == 9999 )
			{
				break;
			}
			else
			{
				Objective_AdditionalPosition( objective_number, 0, array_ents[ closest_ent_num ] );
			}
		}
		else
		{			
			for( i = 0; i < array_ents.size; i++ )
			{
				if( array_ents[ i ].health > 0 )  // paranoia check
				{
					Objective_AdditionalPosition( objective_number, i, array_ents[ i ] );
				}
			}
		}
		
		level waittill( update_notification );  // when you get this, the number of objectives has changed
		
		array_ents = remove_dead_ents( array_ents );
		//array_ents = array_removedead( array_ents );
		
		if( ( IsDefined( array_ents ) ) && ( array_ents.size > 0 ) )
		{
			if( IsArray( objective_text ) )
			{
				Objective_Delete( objective_number );
			}
			
			// don't do anything here if it's a single objective string
		}
		else
		{
			if( IsDefined( objective_text ) && IsArray( objective_text ) )
			{
				Objective_String( objective_number, objective_text[ array_ents.size ] );
			}
			
			// don't do anything here if it's a single objective string or missing string
		}
	}
	
	Objective_State( objective_number, "done" );
	if( IsDefined( flag_to_set_when_done ) && ( IsDefined( level.flag[ flag_to_set_when_done ] ) ) )
	{
		flag_set( flag_to_set_when_done );
	}
	
	flag_set( "show_directional_marker" );
	
	return objective_number;
}

/*==========================================================================
FUNCTION: notification_on_death
SELF: an entity, probably AI or vehicle
PURPOSE: send out a custom notification when self dies
		originally for use in conjunction with update_objective_on_death, 
		but can be used elsewhere.

ADDITIONS NEEDED: move to river_util
==========================================================================*/
notification_on_death( level_notification_to_send, death_effect )
{
	AssertEx( IsDefined( level_notification_to_send ), "level_notification_to_send is missing. required for notification_on_death" );
	
	self waittill( "death" );
	
	level notify( level_notification_to_send );
	
	if( IsDefined( death_effect ) )
	{
		PlayFX( level._effect[ "quad50_temp_death_effect" ], self.origin, AnglesToForward( self.angles ) );
	}
}

remove_from_array_on_death( array )  // self = thing to wait for death that will be removed from an array once it dies
{
	AssertEx( ( IsDefined( array ) && IsArray( array ) ), "array is missing in remove_from_array_on_death" );
	
	self waittill( "death" );
	
	array = array_remove( array, self );
}

remove_dead_ents( array )
{
	AssertEx( IsDefined( array ), "array is missing in remove_dead_ents" );
	
	new_array = [];
	
	for( i = 0; i < array.size; i++ )
	{
		if( IsDefined( array[ i ] ) )
		{
			if( array[ i ].health <= 0 )
			{
				continue; // don't add to array
			}
			else
			{
				new_array[ new_array.size ] = array[ i ];
			}
		}
	}
	
	return new_array;
}

audio_snapshot_override()
{
    wait(2);
    clientnotify( "snpov" );
}
