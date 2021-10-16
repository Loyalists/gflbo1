/*
//-- Level: Full Ahead
//-- Level Designer: Christian Easterly
//-- Scripter: Jeremy Statz
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_utility_code;
#include maps\fullahead_util;
#include maps\fullahead_drones;
#include maps\fullahead_anim;
#include maps\_anim;
#include maps\_music;

// The level-skip shortcuts go here, the main level flow goes straight to run()
run_skipto()
{
	// misc setup necessary to make the skipto work goes here
	objective_add( 0, "done", &"FULLAHEAD_OBJ_NAZIBASE_STEINER" );
	level thread objectives(1);
	
	maps\fullahead_p2_nazibase::cleanup();
	
	//level thread fade_out( 0.1, "white" );
	disable_trigger_with_targetname( "ship_kill_trigger" );	//so skipto works -jc

	run();
}

run()
{
	intro_narration();
	init_event();
	
	wait(0.05);	//just in case -jc

	//start earlier-jc
	level.patrenko thread anim_single_aligned( level.patrenko, "ship_point", undefined, "petrenko" );

	//fix for player oriented wrong way - jc
	p = get_player();
	struct = getstruct("p2shiparrival_playerstart", "targetname" );
	p SetPlayerAngles( struct.angles );

	level thread short_intro_dialogue(); // to get the audio timing to work with the anims being player

	level thread fade_in( 3, "white", undefined, undefined, true );
	
	//autosave_by_name( "fullahead" );
	wait 2.5;
	//level thread first_enemyattack_thread();

	shiparrival_outside(); // goes up to the first door
//	shiparrival_inside();
//
//	flag_wait( "P2SHIPARRIVAL_AMBUSH_COMPLETE" );
//
//	level thread shiparrival_front_two_to_nodes( "door7", true, "p2shiparrival_door7_steiner" );
//	level thread post_ambush_panel_fall();
////	level thread post_ambush_squad();
//	
//	trigger_wait( "p2shiparrival_door7_reached" );
//	level thread shiparrival_vip_to_nodes( "door7" );
//	level thread shiparrival_back_two_to_nodes( "door7", true, 6.0 ); // just past the ambush area

	cleanup();
	maps\fullahead_p2_shipcargo::run();
}

init_event()
{
	fa_print( "init p2 shiparrival\n" );
	
	add_global_spawn_function( "axis", ::spawnfunc_ikpriority );
	add_global_spawn_function( "allies", ::spawnfunc_ikpriority );

	ghostship_fog();

	fa_visionset_shipstart();
	setup_visionset_triggers();
	containment_trigger_startup( "shiparrival_containment" );

	// relocate player to correct position
	player_to_struct( "p2shiparrival_playerstart" );
	get_player() fa_take_weapons();

	p = get_player();
	p setstance( "stand" );

	spawn_ship_squad(); // sets up arrays level.shipvip, level.shipsquad

	level thread shiparrival_execution();

	ship_door_setup( 1 );
	ship_door_setup( 2 );
	ship_door_setup( "cargo" );
	ship_door_setup( "black" );

	get_player() set_move_speed( 0.00 );

	shiparrival_spawn_crowd();
	maps\fullahead_drones::spawn_hanging_guys( "shiparrival_hanging_guys" );
	maps\fullahead_drones::spawn_frozen_guys( "ship_frozen_guy" );
	hud_utility_hide("white");

	get_player() SetClientDvar( "sm_sunSampleSizeNear", 1.9 );
	get_player() AllowSprint( false );

	//p giveweapon( "frag_grenade_russian_sp" );

	blocker = getent( "p2shiparrival_door1_blocker", "targetname" );
	blocker notsolid();

	blocker = getent( "p2shiparrival_door0c_blocker", "targetname" );
	blocker notsolid();

	//blocker = getent( "p2shiparrival_door1c_blocker", "targetname" );
	//blocker notsolid();

	//blocker = getent( "p2shiparrival_door2_blocker", "targetname" );
	//blocker notsolid();

	level.flashlight_ambush_spawner_death_count = 0;
	level.flashlight_ambush_spawner_death_max = 1;
}

// gets run through at start of level
init_flags()
{
	flag_init( "P2SHIPARRIVAL_EXECUTION_STARTED" );
	flag_init( "P2SHIPARRIVAL_EXECUTION_FINISHED" );
	flag_init( "P2SHIPARRIVAL_OUTSIDE_CONVERSATION_DONE" );
	flag_init( "P2SHIPARRIVAL_REZNOV_MOVING_OUT");
	flag_init( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL");	
	flag_init( "P2SHIPARRIVAL_SNOW_FELL" );
	flag_init( "P2SHIPARRIVAL_SHIP_ENTERED" );

	flag_init( "P2SHIPARRIVAL_SHIP_DOOR1_ARRIVAL" );
	flag_init( "P2SHIPARRIVAL_SHIP_DOOR1_DIALOGUE_DONE" );
	flag_init( "P2SHIPARRIVAL_SHIP_DOOR1_OPENED" );

	flag_init( "P2SHIPARRIVAL_BLOCKER1_DIALOGUE_DONE" );
	flag_init( "P2SHIPARRIVAL_PATRENKO_READY_FOR_BARRICADE" );
	flag_init( "P2SHIPARRIVAL_NEVSKI_READY_FOR_BARRICADE" );
	flag_init( "P2SHIPARRIVAL_PATRENKO_AT_BARRICADE" );
	flag_init( "P2SHIPARRIVAL_NEVSKI_AT_BARRICADE" );
		
	flag_init( "P2SHIPARRIVAL_BLOCKER1_CLEAR" );

	flag_init( "P2SHIPARRIVAL_TRAVERSEROOM_ARRIVAL" );

	flag_init( "P2SHIPARRIVAL_2NDATTACK_TRIGGER" );
	flag_init( "P2SHIPARRIVAL_BOILER_AT_REST" );
	
	flag_init( "P2SHIPARRIVAL_PLAYER_AT_TORCH_DOOR" );

	flag_init( "P2SHIPARRIVAL_1STATTACK_RETREATING" );
	flag_init( "P2SHIPARRIVAL_1STATTACK_FINISHED" );
	flag_init( "P2SHIPARRIVAL_2NDATTACK_FINISHED" );
	flag_init( "P2SHIPARRIVAL_DOOR4_REACHED" );
	
	flag_init( "P2SHIPARRIVAL_3RDATTACK_FINISHED" );

	flag_init( "P2SHIPARRIVAL_AMBUSH_BEGIN" );
	flag_init( "P2SHIPARRIVAL_AMBUSH_STARTED" );
	flag_init( "P2SHIPARRIVAL_AMBUSH_COMPLETE" );

	maps\fullahead_p2_shipcargo::init_flags();
}

cleanup()
{
	fa_print( "cleanup p2 shiparrival\n" );
	
	containment_trigger_shutdown( "shiparrival_containment" );

	drones = getentarray( "dogsled_crowd_patrol_drone", "targetname" );
	for( i=0; i<drones.size; i++ )
	{
		drones[i] delete();
	}

	drones = getentarray( "shiparrival_hanging_guys", "targetname" );
	for( i=0; i<drones.size; i++ )
	{
		drones[i] delete();
	}
	
	drones = getentarray( "ship_frozen_guy", "targetname" );
	for( i=0; i<drones.size; i++ )
	{
		drones[i] delete();
	}
	
	//cleanup outside guys
	drones = getentarray( "shiparrival_outside_drone", "script_noteworthy" ); // just in case
	for( i=0; i<drones.size; i++ )
	{
		if( isdefined(drones[i]) )
			drones[i] delete();	
	}
	
	remove_outside_ai();
}

objectives( starting_obj_num )
{
	level waittill( "fade_in_complete" );
	
	//TUEY Set Music State to BOAT_ARRIVE
	setmusicstate ("BOAT_ARRIVE");

	main_obj_num = starting_obj_num;
	curr_obj_num = starting_obj_num+1;

	
	objective_add( main_obj_num, "active", &"FULLAHEAD_OBJ_SECURE_WEAPON" );
	
	// secondary objective
	objective_add( curr_obj_num, "active", &"FULLAHEAD_OBJ_SHIPARRIVAL_REGROUP" );
	objective_position( curr_obj_num, ent_origin("shiparrival_conversation_objective") + (0,0,48) );
	objective_set3d( curr_obj_num, true );
	flag_wait( "P2SHIPARRIVAL_REZNOV_MOVING_OUT" );
	// removing secondary objective
	Objective_State( curr_obj_num, "done" );
	Objective_Delete( curr_obj_num );
	
	objective_position( main_obj_num, ent_origin("shiparrival_door0d_reached") );
	objective_set3d( main_obj_num, true );
	trigger_wait( "shiparrival_door0d_reached" );

	objective_position( main_obj_num, ent_origin("shiparrival_door1_use") );
	objective_set3d( main_obj_num, true );
	flag_wait( "P2SHIPARRIVAL_SHIP_DOOR1_OPENED" );

//	objective_position( main_obj_num, ent_origin("shiparrival_door1c_reached") );
//	objective_set3d( main_obj_num, true );
//	trigger_wait( "shiparrival_door1c_reached" );
//	
//	objective_set3d( main_obj_num, false );
//	flag_wait( "P2SHIPARRIVAL_BLOCKER1_DIALOGUE_DONE" );
//	flag_wait( "P2SHIPARRIVAL_PATRENKO_AT_BARRICADE" );
//	
//	objective_position( main_obj_num, ent_origin("shiparrival_blocker1_lookat") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BLOCKER1_CLEAR" );
//	
//	// the breadcrumb flags are set by the triggers themselves, thus no 'init' up ahead
//	objective_position( main_obj_num, ent_origin("shiparrival_breadcrumb0") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB0" );
//
//	objective_position( main_obj_num, ent_origin("shiparrival_breadcrumb1") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB1" );
//
//	objective_position( main_obj_num, ent_origin("shiparrival_breadcrumb2") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB2" );
//
//	objective_position( main_obj_num, ent_origin("shiparrival_breadcrumb3") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB3" );
//	flag_wait( "P2SHIPARRIVAL_PLAYER_AT_TORCH_DOOR" );
//	
//	objective_position( main_obj_num, ent_origin("ambush_grenadethrow_start") );
//	objective_set3d( main_obj_num, true );
//
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB4" );	
//		
//	objective_position( main_obj_num, ent_origin("shiparrival_ambush_objective") );
//	objective_set3d( main_obj_num, true );
//	flag_wait( "P2SHIPARRIVAL_BREADCRUMB5" );	
////	flag_wait( "P2SHIPARRIVAL_AMBUSH_COMPLETE" );

	maps\fullahead_p2_shipcargo::objectives( main_obj_num );
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// self is the reznov script_model
#using_animtree("animated_props");
intro_narration_callback( camera_ent )
{

	player = get_players()[0];
	player DisableClientLinkTo();
	player DisableWeapons();
	if(IsDefined(level.current_hands_ent))
	{
		level.current_hands_ent delete();
	}
	level.current_hands_ent = spawn_anim_model( "playerbody" );	
	level.current_hands_ent.animname = "playerbody";
	level.current_hands_ent.origin = self.origin;
	level.current_hands_ent.angles = self.angles;
	self anim_first_frame( level.current_hands_ent, "narr_3", undefined, "playerbody" );	
	player PlayerLinkToAbsolute( level.current_hands_ent, "tag_player");
	wait(1.5);
	self thread anim_single(self, "narr_3" );
	self thread	anim_single_aligned( level.current_hands_ent, "narr_3", undefined, "playerbody" );
	wait(0.5);
	hud_utility_hide("white", 1.5);
	level waittill("start_fade_out");
	flag_set( "reznov_cutscene_startfade" );
	playsoundatposition("evt_blizzard_gust",(0,0,0));	
	clientnotify( "snapshot_default_3" );

	wait 5;	

	level.current_hands_ent delete();
	player unlink();
	player EnableWeapons();

	flag_set( "reznov_cutscene_done" );
	level.streamHintEnt delete();
	show_friendly_names( 1 );
	level.steiner_nazibase.ignoreall = false;

}

intro_narration()
{
	p = get_player();
    
  p freezecontrols(true);
	do_reznov_cutscene( ::intro_narration_callback );
}

spawn_ship_squad()
{
	guy1 = simple_spawn_single( "p2shiparrival_patrenko_spawner" );
	guy1.animname = "generic";
	guy1.name = "Petrenko";
	guy1 thread make_hero();
	guy1.walk = true;
	guy1.targetname = "patrenko";
	guy1.script_noteworthy = "arrival_friendly";
	guy1.ikpriority = 5;

	guy2 = simple_spawn_single( "p2shiparrival_nevski_spawner" );
	guy2.animname = "generic";
	guy2.name = "Nevski";
	guy2 thread make_hero();
	guy2.walk = true;
	guy2.targetname = "nevski";
	guy2.script_noteworthy = "arrival_friendly";
	guy2.ikpriority = 5;

	guy3 = simple_spawn_single( "p2shiparrival_squad3_spawner" );
	guy3.animname = "generic";
	guy3.name = "Belov";
	guy3 thread magic_bullet_shield();
	guy3.walk = true;
	guy3.targetname = "belov";
	guy3.script_noteworthy = "arrival_friendly";
	guy3.ikpriority = 5;

	guy4 = simple_spawn_single( "p2shiparrival_squad4_spawner" );
	guy4.animname = "generic";
	guy4.name = "Vikharev";
	guy4 thread magic_bullet_shield();
	guy4.walk = true;
	guy4.targetname = "vikharev";
	guy4.script_noteworthy = "arrival_friendly";
	guy4.ikpriority = 5;

	
	// guy5 and guy6 are not actually part of the player's squad.  They are just there to make the player feel less alone.
	guy5 = simple_spawn_single( "p2shiparrival_squad5_spawner" );
	guy5.animname = "generic";
	guy5 thread magic_bullet_shield();
	guy5.script_noteworthy = "arrival_friendly";	
	guy5.disableArrivals = true;
	guy5.disableExits = true;
	guy5.disableTurns = true;
	
		
	guy6 = simple_spawn_single( "p2shiparrival_squad6_spawner" );
	guy6.animname = "generic";
	guy6 thread magic_bullet_shield();
	guy6.script_noteworthy = "arrival_friendly";
	guy6.disableArrivals = true;
	guy6.disableExits = true;
	guy6.disableTurns = true;	
	
	// guy7 and guy8 exist only to hold dragovich and steiner's weapons.  how noble...  but futile.
	// guy7 is Dragovich's guy
	guy7 = simple_spawn_single( "p2shiparrival_squad7_spawner" );
	guy7.animname = "generic";
	guy7 thread magic_bullet_shield();
	guy7.script_noteworthy = "arrival_friendly";
	guy7.disableArrivals = true;
	guy7.disableExits = true;
	guy7.disableTurns = true;
	
	// guy8 is Steiner's guy
	guy8 = simple_spawn_single( "p2shiparrival_squad8_spawner" );
	guy8.animname = "generic";
	guy8 thread magic_bullet_shield();
	guy8.script_noteworthy = "arrival_friendly";
	guy8.disableArrivals = true;
	guy8.disableExits = true;
	guy8.disableTurns = true;	
	
	level.patrenko = guy1;
	level.nevski = guy2;
	level.shipsquad[0] = guy1;
	level.shipsquad[1] = guy2;
	level.shipsquad[2] = guy3;
	level.shipsquad[3] = guy4;
	level.shipsquad[4] = guy5;
	level.shipsquad[5] = guy6;
	level.shipsquad[6] = guy7;
	level.shipsquad[7] = guy8;	
	
	level.steiner = simple_spawn_single( "p2shiparrival_steiner_spawner" );
	level.steiner.name = "Steiner";
	level.steiner.targetname = "steiner";
	level.steiner.animname = "steiner";
//	level.steiner enable_cqbwalk();
	level.steiner thread make_hero();
//	level.steiner hidepart( "tag_weapon" );
	level.steiner.script_noteworthy = "arrival_friendly";
	level.steiner.walk = true;
	level.steiner set_run_anim( "ship_point_walk" );
	level.steiner.disableArrivals = true;
	level.steiner.disableExits = true;
	level.steiner.disableTurns = true;
	weaponModel = GetWeaponModel( "mosin_sp" ); 
	level.steiner Attach( weaponModel, "tag_weapon_right" );
	level.steiner.ikpriority = 5;

	level.dragovich = simple_spawn_single( "p2shiparrival_dragovich_spawner" );
	level.dragovich.name = "Dragovich";
	level.dragovich.targetname = "Dragovich";
	level.dragovich.animname = "dragovich";
//	level.dragovich enable_cqbwalk();
	level.dragovich thread make_hero();
//	level.dragovich hidepart( "tag_weapon" );
	level.dragovich.script_noteworthy = "arrival_friendly";
	level.dragovich.walk = true;
	level.dragovich set_run_anim( "ship_point_walk" );
	level.dragovich.disableArrivals = true;
	level.dragovich.disableExits = true;
	level.dragovich.disableTurns = true;
	level.dragovich.ikpriority = 5;
	
	level.kravchenko = simple_spawn_single( "p2shiparrival_kravchenko_spawner" );
	level.kravchenko.name = "Kravchenko";
	level.kravchenko.targetname = "kravchenko";
	level.kravchenko.animname = "kravchenko";
//	level.kravchenko enable_cqbwalk();
	level.kravchenko thread make_hero();
	level.kravchenko.script_noteworthy = "arrival_friendly"; // used for the traversal room
	level.kravchenko.walk = true;
	level.kravchenko set_run_anim( "ship_point_walk" );
	level.kravchenko.disableArrivals = true;
	level.kravchenko.disableExits = true;
	level.kravchenko.disableTurns = true;
	level.kravchenko.ikpriority = 5;
		
	//insure no dupe heads on these guys.
	heads = array( level.shipsquad[5], level.shipsquad[6], level.shipsquad[7] );
	//remove random head and replace with linear head - from vorkuta mine
	// head_array = xmodelalias\c_rus_fullahead_head_alias::main();
	// for( i = 0; i < heads.size; i++ )
	// {
	// 	heads[i] detach(heads[i].headModel);
	// 	heads[i].headModel = head_array[i];
	// 	heads[i] attach(heads[i].headModel, "", true);
	// }
	
}

shiparrival_spawn_crowd()
{
	patrol_starts = getstructarray( "shiparrival_crowd_patrol", "targetname" );

	for( i=0; i<patrol_starts.size; i++ )
	{
		struct = patrol_starts[i];
		drone = fa_drone_spawn( struct, "allieshigh" );
		drone.script_noteworthy = "shiparrival_outside_drone";
		drone thread fa_drone_move( struct );
	}
	
/*	 THE RADIO MODEL HAS BEEN CUT, THEREFORE, NO RADIO MANS
	// Add radiomen
	radio_spots = getstructarray( "shiparrival_crowd_radio", "targetname" );
	for( i=0; i<radio_spots.size; i++ )
	{
		node = radio_spots[i];
		drone = fa_drone_spawn( node, "allieshigh" );
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "dock_workers_radio" );
	}
*/
	
/*	WE DON'T HAVE DOGSLEDS ANYMORE -- THIS ANIMATION DOESN'T FIT THE SCENE
	// guys who unload the dogsleds
	unload_spots = getstructarray( "shiparrival_crowd_unload", "targetname" );
	for( i=0; i<unload_spots.size; i++ )
	{
		node = unload_spots[i];
		guy = simple_spawn_single( "p2shiparrival_loaders" );
		guy.animname = "generic";
		guy forceteleport( node.origin, node.angles );
		
		offset = node.script_noteworthy;
		guy thread unload_anim_sequence( node, offset );
	}
*/

	// Add guys talking
	talk_spots = getstructarray( "shiparrival_crowd_talk_e", "targetname" );
	for( i=0; i<talk_spots.size; i++ )
	{
		node = talk_spots[i];
		drone1 = fa_drone_spawn( node, "allieshigh" );
		drone2 = fa_drone_spawn( node, "allieshigh" );
		drone1.script_noteworthy = "shiparrival_outside_drone";
		drone2.script_noteworthy = "shiparrival_outside_drone";
		drone1 HidePart("tag_weapon");
		drone2 HidePart("tag_weapon");
		node thread anim_loop( drone1, "dock_workers_e_1" );
		node thread anim_loop( drone2, "dock_workers_e_2" );
	}
	
	talk_spots = getstructarray( "shiparrival_crowd_talk_f", "targetname" );
	for( i=0; i<talk_spots.size; i++ )
	{
		node = talk_spots[i];
		drone1 = fa_drone_spawn( node, "allieshigh" );
		drone2 = fa_drone_spawn( node, "allieshigh" );
		drone1.script_noteworthy = "shiparrival_outside_drone";
		drone2.script_noteworthy = "shiparrival_outside_drone";
		drone1 HidePart("tag_weapon");
		drone2 HidePart("tag_weapon");	
		node thread anim_loop( drone1, "dock_workers_f_1" );
		node thread anim_loop( drone2, "dock_workers_f_2" );
	}

/*	THIS ANIMATION DIDN'T LOOP WELL.  THE GUY WALKED TOO FAR AND ENDED UP TO FAR FROM HIS STARTING POINT - SO WE'RE NOT USING IT
	
	talk_spots = getstructarray( "shiparrival_crowd_talk_h", "targetname" );
	for( i=0; i<talk_spots.size; i++ )
	{
		node = talk_spots[i];
		drone1 = fa_drone_spawn( node, "allieshigh" );
		drone2 = fa_drone_spawn( node, "allieshigh" );
		node thread anim_loop( drone1, "dock_workers_h_1" );
		node thread anim_loop( drone2, "dock_workers_h_2" );
	}
*/
	
	// Add guys unloading snowcats
	level.crate_spawned = false; //for crate in anim
	unload_snowcat_spots = getstructarray( "shiparrival_unloader_drone", "targetname" );
	for( i=0; i<unload_snowcat_spots.size; i++ )
	{
		node = unload_snowcat_spots[i];
		unloader = fa_drone_spawn( node, "allieshigh" );
		unloader.script_noteworthy = "shiparrival_outside_drone";
		unloader HidePart("tag_weapon");
		
		// node has to target snowcat it's unloading
		assert(isdefined(node.target));		
		vehicle = GetEnt( node.target, "targetname" );
		assert(isdefined(vehicle));
		
		vehicle thread anim_loop_aligned( unloader, "unloading_snowcat1", "tag_origin", "stop_unloading_snowcat", "generic" );
	}
	
	
	// Add guys loading snowcats
	load_snowcat_spots = getstructarray( "shiparrival_loader_drone", "targetname" );
	for( i=0; i<load_snowcat_spots.size; i++ )
	{
		node = load_snowcat_spots[i];
		loader = fa_drone_spawn( node, "allieshigh" );
		loader.script_noteworthy = "shiparrival_outside_drone";
		loader HidePart("tag_weapon");
		
		// node has to target snowcat it's unloading
		assert(isdefined(node.target));
		vehicle = GetEnt( node.target, "targetname" );
		assert(isdefined(vehicle));
		
		vehicle thread anim_loop_aligned( loader, "unloading_snowcat2", "tag_origin", "stop_unloading_snowcat", "generic" );
	}	
		
	// Add crate carry
	crate_carry_spots = getstructarray( "shiparrival_crate_carry", "targetname" );
	for( i=0; i<crate_carry_spots.size; i++ )
	{
		node = crate_carry_spots[i];
		drone = fa_drone_spawn( node, "allieshigh" );
		drone.script_noteworthy = "shiparrival_outside_drone";
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "crate_carry" );
		wait(1.5);
	}	
	

	

	
	
}

// self should be an AI guy
unload_anim_sequence( node, offset )
{
	self endon( "death" );
	node anim_first_frame( self, "unloading_sleds_0" + offset + "_in" );
	
	while( isdefined(self) )
	{
		node anim_reach( self, "unloading_sleds_0" + offset + "_in" );
		node anim_single_aligned( self, "unloading_sleds_0" + offset + "_in" );
		node anim_single_aligned( self, "unloading_sleds_0" + offset );
		node anim_single_aligned( self, "unloading_sleds_0" + offset + "_out" );
	}
}

group_walk_to_officers()
{
	level.patrenko set_run_anim( "ship_point_walk" );
	level.patrenko.disableArrivals = true;
	level.patrenko.disableExits = true;
	level.patrenko.disableTurns = true;
	
	level.nevski set_run_anim( "ship_point_walk" );
	level.nevski.disableArrivals = true;
	level.nevski.disableExits = true;
	level.nevski.disableTurns = true;
	
	level.shipsquad[4] set_run_anim( "ship_point_walk" );
	level.shipsquad[4].disableArrivals = true;
	level.shipsquad[4].disableExits = true;
	level.shipsquad[4].disableTurns = true;
	
	level.shipsquad[5] set_run_anim( "ship_point_walk" );
	level.shipsquad[5].disableArrivals = true;
	level.shipsquad[5].disableExits = true;
	level.shipsquad[5].disableTurns = true;

//	level.patrenko thread anim_single_aligned( level.patrenko, "ship_point", undefined, "petrenko" );
	// - comment out speed things up -jc
	//wait( 2.0 ); // delay while Petrenko does his gesture.  Might actually want to time this to the anim...
	//level thread short_intro_dialogue(); // to get the audio timing to work with the anims being player

	level.shipsquad[5] setgoalnode_tn( "p2shiparrival_squad5_conversation_wait" );	
	wait(0.4);
	level.shipsquad[4] setgoalnode_tn( "p2shiparrival_squad4_conversation_wait" );
	wait(0.5);
	//level.nevski setgoalnode_tn( "p2shiparrival_nevski_conversation_wait" );
	level.nevski thread snowguy_sequence();
	wait(0.2);		
	level.patrenko setgoalnode_tn( "p2shiparrival_patrenko_conversation_wait" );	
	
	// patrenko gestures to Reznov at the start to come with him toward the ship
	//level thread short_intro_dialogue(); // to get the audio timing to work with the anims being player
//	wait(1);	//hack-jc
//	get_player() freezecontrols(false); // was frozen in intro_narration

}

short_intro_dialogue() // self is level
{
	p = GetPlayers()[0];

	//cold breath
	level.patrenko thread cold_breath( "guy" );
	
	//add reznov get over here
	level.scr_sound["Dragovich"]["bringmen"] = "vox_ful1_s03_057A_drag_m"; //Reznov...bring your men.
	level.dragovich anim_single( level.dragovich, "bringmen", "Dragovich" );
	
	//dialog
	level.patrenko anim_single( level.patrenko, "whathere", "Petrenko" );
	wait(0.5);
	p anim_single( p, "makename", "Reznov" );	
	wait(0.5);
	//	iprintlnbold("Dragovich and Steiner are talking like old friends... I do not like this, Reznov");
	level.patrenko anim_single( level.patrenko, "oldfriends", "Petrenko" );
	
	//	iprintlnbold("Nor I, Dimitri... Be on your guard.");		
	p anim_single( p, "oldfriends", "Reznov" );

	level.patrenko notify( "stop_breath" );
	
	autosave_by_name( "fullahead" );	//moved here b/c dialog

}

	// nevski dodges a falling block of ice between the conversation and the ship
snowguy_sequence() // self is nevski
{
	snownode = getnode( "shiparrival_snowfall_node", "targetname" );
	snow = getent( "shiparrival_snowfall_snow", "targetname" );
	goal = getnode( "p2shiparrival_door0_02", "targetname" );

	assert(isdefined(snownode));
	assert(isdefined(snow));
	assert(isdefined(goal));
	
	snow notsolid(); 
	
	//send nevski straight here -jc
	snownode anim_reach( self, "falling_ice" );

	// We now want the snow fall to be triggered by either Nevski OR the player
	flag_wait( "P2SHIPARRIVAL_REZNOV_MOVING_OUT");
////	if( !flag( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL" ) )
////	{
////		snownode anim_reach_aligned( self, "falling_ice", "generic" );
////	}
//	if( !flag( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL" ) )
//	{
//		flag_set( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL" );
//		snownode thread anim_single_aligned( self, "falling_ice", undefined, "generic" );
//		level.nevski AnimMode( "gravity" );
//		snownode waittill( "falling_ice" );
//	}
	snow thread snow_fall_monitor( snownode );

	flag_wait( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL" );
	snownode anim_single_aligned( self, "falling_ice", undefined, "generic" );

	level.nevski run_mode();
	level.nevski enable_cqbwalk();	
	self setgoalnode( goal );
}

snow_fall_monitor( snownode ) // self is the snow object
{
	fall_time = 1.5;
	flag_wait( "P2SHIPARRIVAL_TRIGGER_SNOW_FALL" );
	wait(0.5); // small delay so the snow falls closer to Nevski/player
	self moveto( snownode.origin, fall_time, 1.0 );
	wait( fall_time );
	flag_set( "P2SHIPARRIVAL_SNOW_FELL" );	
}

shiparrival_outside()
{
	door1node = getnode( "shiparrival_door1_goto", "targetname" );
	assert( isdefined(door1node) );

// 	disable_triggers_with_targetname("shiparrival_door0b_reached");

	level thread dragovich_steiner_outside_talk();
	level thread entryway_trigger_thread();
	level thread shiparrival_outside_conversation();
	
	level thread group_walk_to_officers(); // the walk to Steiner and Dragovich
	
	// These two squad members initially function as blockers.  They then bring up the rear, begin the Triumvirate.
	level.shipsquad[2] setgoalnode_tn( "p2shiparrival_door0_03" );
	level.shipsquad[3] setgoalnode_tn( "p2shiparrival_door0_04" );
		
	p = get_player();
	
	p AllowJump(false);
	p AllowCrouch(false);
	p AllowProne(false);
	p freezecontrols(false); // was frozen in intro_narration
		
	get_player() thread gradiate_move_speed( 0.33 );

//	flag_wait( "P2SHIPARRIVAL_OUTSIDE_CONVERSATION_DONE" );
	flag_wait( "P2SHIPARRIVAL_REZNOV_MOVING_OUT");
	
	
	//wait( 1.0 );	
	
	//moved earlier so it's like they're reacting to reznov command, also makes player wait less -jc
	level.patrenko run_mode();
	level.patrenko enable_cqbwalk();
		
	belov = GetEnt( "belov", "targetname" );
	belov run_mode();
	belov enable_cqbwalk();	

	level.patrenko setgoalnode_tn( "p2shiparrival_patrenko_conversation_done" );

	level.steiner.goalradius = 32;
	level.steiner setgoalnode_tn( "shiparrival_steiner_dest" );
	wait( 1.5 );
	level.dragovich.goalradius = 32;
	level.dragovich setgoalnode_tn( "shiparrival_drago_dest" );	

	//start earlier so it doesn't overlap with v2 -jc
	level thread shiparrival_tellmemore_conversation();	

	wait( 8.0 ); // block player if he goes too far -jc

	flag_wait( "P2SHIPARRIVAL_SNOW_FELL" );
			
	// Because of the need to block the player with the p2shiparrival_entryway_blocker, we now have a situation where
	// squad members 2 and 3 are ahead of 0 and 1 (patrenko and nevski).  Unfortunately, this means shiparrival_squad_to_nodes
	// won't really work.  So, we send them manually.   
	level.shipsquad[2] setgoalnode_tn( "p2shiparrival_door0a_03" );
	level.shipsquad[3] setgoalnode_tn( "p2shiparrival_moveaside_04" );
	level.shipsquad[3] waittill( "goal" );
	

	// put the guys who will lag the VIPs into "walk mode", and no cqb for them for now
	level.shipsquad[2] walk_mode();
	level.shipsquad[3] walk_mode();	
	
	get_player() thread gradiate_move_speed( 0.45, 0.05 );
	
//	level.patrenko run_mode();
//	level.patrenko enable_cqbwalk();
//	
//	level.nevski run_mode();
//	level.nevski enable_cqbwalk();	
	
	p AllowJump(true);
	p AllowCrouch(true);
	p AllowProne(true);
	
	level.patrenko setgoalnode_tn( "p2shiparrival_door0_01" );	
	level.patrenko waittill( "goal" );

	level thread shiparrival_front_two_to_nodes( "door0a" ); 
	
	getent( "p2shiparrival_entryway_blocker", "targetname") delete();
	trigger_wait( "shiparrival_door0a_reached" );
	level notify( "override_front_two_to_nodes" );
//	enable_triggers_with_targetname("shiparrival_door0b_reached");
	
	level thread shiparrival_front_two_to_nodes( "door0b", true, "0a_to_0b" );

	trigger_wait( "shiparrival_door0a_vip_advance" );
	
	//level thread shiparrival_tellmemore_conversation();
	level thread shiparrival_vip_to_nodes( "door0b" ); // this gets the VIP group ahead of the "back" two squad members

	trigger_wait( "shiparrival_door0b_reached" );
	
	level thread shiparrival_front_two_to_nodes( "door0c", true, "0b_to_0c" );
	
	trigger_wait( "shiparrival_door0b_vip_advance" );

	level thread shiparrival_vip_to_nodes( "door0c", true, "shiparrival_door0c_reached" );

	trigger_wait( "shiparrival_door0c_reached" );

	level.shipsquad[4] delete();
	level.shipsquad[5] delete();	
	level thread shiparrival_back_two_to_nodes( "door0b" );
	level thread shiparrival_front_two_to_nodes( "door0d", true, "p2shiparrival_door0d_03" );

	trigger_wait( "shiparrival_door0d_reached" );

	level thread shiparrival_front_two_to_nodes( "door1", true, "0d_to_1" );
	level thread shiparrival_vip_to_nodes( "door0cd" );
	
	flag_wait( "P2SHIPARRIVAL_SHIP_DOOR1_ARRIVAL" ); // done on trigger with targetname p2shiparrival_door1_safetycheck
	
	//end convo if player rushes -jc
	level notify( "end_tellmemore_conversation" );

	level thread shiparrival_vip_to_nodes( "door1", true, "p2shiparrival_door1_safetycheck", 3.0 );	
	level thread shiparrival_back_two_to_nodes( "door0c" );
	
	//warp to cargo bay door here -jc
	trigger = getent( "shiparrival_door1_use", "targetname" );
	trigger trigger_use_button( &"FULLAHEAD_USE_OPEN" );
	
//warp to cargo door
	
//	player_open_door( 1 );
//	
//	// While the player's staring at the door, teleport your guys to wherever we want them to be.
//	patrenko_door_node = getnode( "p2shiparrival_door1_01", "targetname" );
//	level.patrenko forceteleport( patrenko_door_node.origin, patrenko_door_node.angles );
//	
//	nevski_door_node = getnode( "p2shiparrival_door1_02", "targetname" );
//	level.nevski forceteleport( nevski_door_node.origin, nevski_door_node.angles );
//	
//	kravchenko_door_node = getnode( "p2shiparrival_door1_krav", "targetname" );
//	level.kravchenko forceteleport( kravchenko_door_node.origin, kravchenko_door_node.angles );
//	
//	steiner_door_node = getnode( "p2shiparrival_door1_steiner", "targetname" );
//	level.steiner forceteleport( steiner_door_node.origin, steiner_door_node.angles );
//	
//	dragovich_door_node = getnode( "p2shiparrival_door1_vertov",x "targetname" );
//	level.dragovich forceteleport( dragovich_door_node.origin, dragovich_door_node.angles );
//
//	belov_door_node = getnode( "p2shiparrival_door0d_03", "targetname" );
//	level.shipsquad[2] forceteleport( belov_door_node.origin, belov_door_node.angles );
//	level.shipsquad[2] SetGoalNode( belov_door_node );
//	
//	vikharev_door_node = getnode( "p2shiparrival_door0d_04", "targetname" );
//	level.shipsquad[3] forceteleport( vikharev_door_node.origin, vikharev_door_node.angles );
//	level.shipsquad[3] SetGoalNode( vikharev_door_node );
//	
flag_set( "P2SHIPARRIVAL_SHIP_DOOR1_OPENED" );
	// continues in shiparrival_inside...
}

patrenko_open_first_door_anim( tag )
{
	tag anim_reach( level.patrenko, "open_first_door_approach", "petrenko" );

	tag anim_single_aligned( level.patrenko, "open_first_door_approach", undefined, "petrenko"  );
	tag thread anim_loop_aligned( level.patrenko, "open_first_door_wait_loop", undefined, "patrenko_open_first_door", "petrenko" );
	
//	level.scr_sound["Petrenko"]["lightsteady"] = "vox_ful1_s04_063A_dimi"; //Keep the light steady, Viktor...
	level.patrenko anim_single( level.patrenko, "lightsteady", "Petrenko" ); //Keep the light steady, Viktor...

	flag_set( "P2SHIPARRIVAL_SHIP_DOOR1_DIALOGUE_DONE" );	
}

post_ambush_panel_fall()
{
	panel = getent( "grating_panel_physics_1", "targetname" );

	trigger_wait( "p2shiparrival_door7_reached" );
	wait(2);
	
	panel physicslaunch( panel.origin + (64,64,64), (0,0,-8) );
}

// self should be level
entryway_trigger_thread()
{
	trigger_wait( "p2shiparrival_entryway" );
	flag_set( "P2SHIPARRIVAL_SHIP_ENTERED" );
	get_player() player_flashlight_pistol();
}

// self should be level
dragovich_steiner_outside_talk()
{
	dragovich = level.dragovich;
	steiner = level.steiner;
	node_steiner = getnode( "shipoutside_steiner_talk", "targetname" );
	node_dragovich = getnode( "shipoutside_dragovich_talk", "targetname" );

	assert( isdefined(node_steiner) );
	assert( isdefined(node_dragovich) );
	assert( isdefined(dragovich) );
	assert( isdefined(steiner) );

	dragovich forceteleport( node_dragovich.origin, node_dragovich.angles );
	steiner forceteleport( node_steiner.origin, node_steiner.angles );	
	
	node_dragovich thread anim_loop( dragovich, "idle_stand", "stoptalking" );
	node_steiner thread anim_loop( steiner, "idle_stand", "stoptalking" );

	flag_wait( "P2SHIPARRIVAL_OUTSIDE_CONVERSATION_DONE" );
	
}

shiparrival_outside_conversation()
{
//     level.scr_sound["Steiner"]["must'"] = "vox_ful1_s03_052A_stei"; //We must hurry... There are Germans who would sooner see it destroyed than captured...
//     level.scr_sound["Dragovich"]["assuredme"] = "vox_ful1_s03_053A_drag"; //You assured me that there would be no problems...
//     level.scr_sound["Steiner"]["cannotcontrol"] = "vox_ful1_s03_054A_stei"; //I cannot control the actions of the SS, General Dragovich...  They are sworn to fight for the Reich till their last breath...
//     level.scr_sound["Dragovich"]["futile"] = "vox_ful1_s03_055A_drag"; //Noble... but futile.
//     level.scr_sound["Dragovich"]["finishup"] = "vox_ful1_s03_056A_drag"; //Kravchenko, finish up here.
//     level.scr_sound["Dragovich"]["bringmen"] = "vox_ful1_s03_057A_drag"; //Reznov...bring your men.
//     level.scr_sound["Reznov"]["movingout"] = "vox_ful1_s03_058A_rezn"; //Petrenko, Nevski, Belov, Vikharev... We are moving out!
//     level.scr_sound["Dragovich"]["leadway"] = "vox_ful1_s03_059A_drag"; //Reznov, you and your men will lead the way.
//     level.scr_sound["Reznov"]["yessir"] = "vox_ful1_s03_060A_rezn"; //Yes, Sir.

	tag = GetStruct( "shiparrival_conversation_objective", "targetname" );
	
	tag thread anim_reach_aligned( level.steiner, "we_must_hurry" );
	tag thread anim_reach_aligned( level.dragovich, "we_must_hurry" );
	tag thread anim_reach_aligned( level.shipsquad[6], "we_must_hurry_russ1" );
	tag anim_reach_aligned( level.shipsquad[7], "we_must_hurry_russ2" );

	tag thread anim_loop_aligned( level.steiner, "we_must_hurry_idle" );
	tag thread anim_loop_aligned( level.dragovich, "we_must_hurry_idle" );
	tag thread anim_loop_aligned( level.shipsquad[6], "we_must_hurry_russ1_idle" );
	tag thread anim_loop_aligned( level.shipsquad[7], "we_must_hurry_russ2_idle" );	
	
	trigger_wait( "ship_outside_conversation_trigger" );

	p = get_player();
	
	level.steiner thread cold_breath( "guy" );
	level.dragovich thread cold_breath( "guy" );

	fa_print( "shiparrival_outside_conversation starting" );

	level.steiner notify( "stoptalking" );
	level.dragovich notify( "stoptalking" );
	
	flag_set( "P2SHIPARRIVAL_OUTSIDE_CONVERSATION_DONE" );

	tag thread anim_single_aligned( level.steiner, "we_must_hurry" );
	tag thread anim_single_aligned( level.shipsquad[6], "we_must_hurry_russ1" );
	tag thread anim_single_aligned( level.shipsquad[7], "we_must_hurry_russ2" );
	//tag thread anim_single_aligned( level.dragovich, "we_must_hurry" );
	tag anim_single_aligned( level.dragovich, "we_must_hurry" );

	//wait( 21.5 ); // so kravchenko can start executing people	
	//lower wait to start execution sooner -jc
	//wait 5;
	
	//flag_set( "P2SHIPARRIVAL_OUTSIDE_CONVERSATION_DONE" );
	//wait( 3.5 );
		//wait 15; //should be end of dragovich anim -jc
			
//	level.steiner anim_single( level.steiner, "musthurry", "Steiner" );
//	level.dragovich anim_single( level.dragovich, "assuredme", "Dragovich" );
//	level.steiner anim_single( level.steiner, "cannotcontrol", "Steiner" );
//	level.dragovich anim_single( level.dragovich, "futile", "Dragovich" );
//  level.dragovich anim_single( level.dragovich, "finishup", "Dragovich" );
//	level.dragovich anim_single( level.dragovich, "bringmen", "Dragovich" );
	//level.dragovich anim_single( level.dragovich, "leadway", "Dragovich" );
	p anim_single( p, "yessir", "Reznov" );
	p anim_single( p, "movingout", "Reznov" );

//	level.steiner.goalradius = 32;
//	level.steiner setgoalnode_tn( "shiparrival_steiner_dest" );
//	wait( 1.5 );
//	
//	level.dragovich.goalradius = 32;
//	level.dragovich setgoalnode_tn( "shiparrival_drago_dest" );	
	flag_set( "P2SHIPARRIVAL_REZNOV_MOVING_OUT");

}

shiparrival_tellmemore_conversation()
{
// 	   level.scr_sound["Dragovich"]["tellmemore"] = "vox_ful1_s04_064A_drag"; //Tell me more about your association with the Giftiger Sturm project, Steiner.
//     level.scr_sound["Steiner"]["fuhrer"] = "vox_ful1_s04_065A_stei"; //In '43, the Fuhrer realized the allies could not be held back for much longer.
//     level.scr_sound["Steiner"]["unconventional"] = "vox_ful1_s04_066A_stei"; //We began to look for more 'unconventional' solutions.
//     level.scr_sound["Steiner"]["throughout"] = "vox_ful1_s04_067A_stei"; //Throughout the war, my own research was focussed on chemical weapons... It was meticulous and frustrating work...
//     level.scr_sound["Steiner"]["whatwefinally"] = "vox_ful1_s04_068A_stei"; //However, what we finally developed was a weapon more effective than we had ever dared to imagine... The weapon now housed within this vessel.
//     level.scr_sound["Dragovich"]["nova6"] = "vox_ful1_s04_069A_drag"; //Nova 6.

	level endon( "end_tellmemore_conversation" );

	level.dragovich anim_single( level.dragovich, "tellmemore", "Dragovich" );
	level.steiner anim_single( level.steiner, "fuhrer", "Steiner" );
	level.steiner anim_single( level.steiner, "unconventional", "Steiner" );
	level.steiner anim_single( level.steiner, "throughout", "Steiner" );
	level.steiner anim_single( level.steiner, "whatwefinally", "Steiner" );
	level.dragovich anim_single( level.dragovich, "nova6", "Dragovich" );
	
	
}

remove_outside_ai()
{
	krav_buddy = getent( "p2shiparrival_otherguy_spawner_ai", "targetname" );
	krav_buddy delete(); // remove Kravchenko's AI friend
	
	guys = getentarray( "p2shiparrival_loaders_ai", "targetname" );
	for( i=0; i<guys.size; i++ )
	{
		guys[i] delete();
	}
	
	
	guy = GetEnt( "p2shiparrival_squad5_spawner_ai", "targetname");
	if( IsDefined( guy ))
	{
		guy Delete();
	}
	
	guy = GetEnt( "p2shiparrival_squad6_spawner_ai", "targetname");
	if( IsDefined( guy ))
	{
		guy Delete();
	}
	
	guy = GetEnt( "p2shiparrival_squad7_spawner_ai", "targetname");
	if( IsDefined( guy ))
	{
		guy Delete();
	}
	guy = GetEnt( "p2shiparrival_squad8_spawner_ai", "targetname");
	if( IsDefined( guy ))
	{
		guy Delete();
	}
}

shiparrival_inside() // after first door
{
//	get_player() SetClientDvar( "sm_sunSampleSizeNear", 0.5 );
//	
//	//trig = getent( "player_at_torch_door", "targetname" );
//	trig thread player_at_torch_door_thread();
//
//	remove_outside_ai();
//	level thread shiparrival_front_two_to_nodes( "door1b", true, "p2shiparrival_door1_04" );
//	
//	//trigger_wait( "shiparrival_door1a_vip_advance" );
//	
//	level thread shiparrival_vip_to_nodes( "door1ab" ); // ab is between a and b, of course
//
//	//trigger_wait( "shiparrival_door1b_reached" );
//
//	level thread shiparrival_front_two_to_nodes( "door1c", true, "p2shiparrival_door1c_krav" );
//	level thread shiparrival_vip_to_nodes( "door1b" ); //, true, "shiparrival_door1b_reached" );
//	level thread shiparrival_back_two_to_nodes( "door1" );		
//	
//	//trigger_wait( "shiparrival_door1c_vip_advance" );
//	
//	level thread shiparrival_vip_to_nodes( "door1c", true, "shiparrival_door1c_reached" );
//	level thread shiparrival_back_two_to_nodes( "door1b" );
//
//	//trigger_wait( "shiparrival_door1c_reached" );
//
//	level thread shiparrival_blocker1_sequence();
//	level thread shiparrival_vip_to_nodes( "door1d" );
//	
//	flag_wait( "P2SHIPARRIVAL_BLOCKER1_CLEAR" );
//	
//	level.shipsquad[0] setgoalnode_tn( "p2shiparrival_door1e_04" );
//	level.shipsquad[1] setgoalnode_tn( "shiparrival_nevski_after_barricade_node" ); // to avoid Nevsky from running back to the player while Petrenko goes to his next node
//	level thread shiparrival_front_two_to_nodes( "door2", true, "p2shiparrival_door1e_03" );
//															
//	//trigger_wait( "shiparrival_door2_vip_advance" );
//	
//	//level thread shiparrival_vip_to_nodes( "door2", true, "p2shiparrival_door2_safety" ); // FIXME?
//	level thread shiparrival_back_two_to_nodes( "door1e", true, 6.0 );	
//	
//	//trigger_wait( "p2shiparrival_door2_reached" );
//	
//	// when the player crosses the stairs threshold, the back two guys go out of walk into cqb
//	level.shipsquad[2] enable_cqbwalk();
//	level.shipsquad[3] enable_cqbwalk();	
//	level.shipsquad[2] setgoalnode_tn( "p2shiparrival_door2_01" );
//	wait (1.0);
//	level.shipsquad[3] setgoalnode_tn( "p2shiparrival_door2_02" );
//	level thread shiparrival_front_two_to_nodes( "door2b", true, "2a_to_2b" );
//	
//	level.kravchenko enable_cqbwalk();
//	level.steiner enable_cqbwalk();
//	level.dragovich enable_cqbwalk();	
//		
//	flag_wait( "P2SHIPARRIVAL_1STATTACK_RETREATING" );
//
//	level thread shiparrival_front_two_to_nodes( "door2c", true, "p2shiparrival_door2c_01" );
//	wait( 4.0 );
//	level thread shiparrival_back_two_to_nodes( "door2b" );
//			
//	flag_wait( "P2SHIPARRIVAL_1STATTACK_FINISHED" );
//	
//	level thread shiparrival_front_two_to_nodes( "door3", true, "2c_to_3" );
//	level thread shiparrival_vip_to_nodes( "door3" );	
//	level thread shiparrival_back_two_to_nodes( "door3", true, 6.0 );
//	
//	//trigger_wait( "p2shiparrival_door3_reached" );
//
//	level thread shiparrival_front_two_to_nodes( "door4", true, "3_to_4" );
//
//	// wait till the "retreat" has begun
//	trigger_wait( "2ndattack_fallback_trigger" );
//	
//	level thread shiparrival_front_two_to_nodes( "door4a", true, "4_to_4a" );
//	
//	flag_wait( "P2SHIPARRIVAL_2NDATTACK_FINISHED" ); // the guy who pushes the boiler down the stairs and his retreaty friends are now dead
//	flag_wait( "P2SHIPARRIVAL_DOOR4_REACHED" ); // AND the player has moved forward enough
//	flag_wait( "P2SHIPARRIVAL_3RDATTACK_FINISHED" ); // and the guy up in the room who throws the grenade
//
//	level thread shiparrival_vip_to_nodes( "door4" );
//	level thread shiparrival_back_two_to_nodes( "door4", true, 5.0 );
//			
//	shiparrival_ambush_sequence();
}

blocker1_conversation()
{
//     level.scr_sound["Petrenko"]["fordays"] = "vox_ful1_s04_070A_dimi"; //He's been dead for days... Before we attacked.
//     level.scr_sound["Petrenko"]["why?"] = "vox_ful1_s04_071A_dimi"; //Why?
//     level.scr_sound["Reznov"]["tothesemen"] = "vox_ful1_s04_072A_rezn"; //What happened to these men?
//     level.scr_sound["Steiner"]["casualties"] = "vox_ful1_s04_073A_stei"; //Casualties of War...
//     level.scr_sound["Petrenko"]["feelright"] = "vox_ful1_s04_074A_dimi"; //Something doesn't feel right.
//     level.scr_sound["Dragovich"]["focused"] = "vox_ful1_s04_075A_drag"; //Keep your men focused, Reznov...
//     level.scr_sound["Dragovich"]["wishanything"] = "vox_ful1_s04_076A_drag"; //We would not wish anything to happen to 'The Hero of Berlin'...

	level notify( "end_tellmemore_conversation" );
	level endon( "end_blocker1_conversation" );

	flag_wait( "P2SHIPARRIVAL_PATRENKO_READY_FOR_BARRICADE" ); // so we know the animation has started
	p = get_player();
	wait(3);
	
	level.patrenko anim_single( level.patrenko, "fordays", "Petrenko" );
	level.patrenko headtracking_start(p);
	level.patrenko anim_single( level.patrenko, "why?", "Petrenko" );
	p anim_single( p, "tothesemen", "Reznov" );
	level.patrenko headtracking_stop();
	level.steiner anim_single( level.steiner, "casualties", "Steiner" );
	level.patrenko anim_single( level.patrenko, "feelright", "Petrenko" );
	level.dragovich anim_single( level.dragovich, "focused", "Dragovich" );
	level.dragovich anim_single( level.dragovich, "wishanything", "Dragovich" );

	flag_set( "P2SHIPARRIVAL_BLOCKER1_DIALOGUE_DONE" );
}

//shiparrival_blocker1_sequence() // the barricade sequence
//{
//	node = getnode( "shiparrival_blocker1_node", "targetname" );
//	//blocker = getent( "shiparrival_blocker1", "targetname" );
//	//blockerclip = getent( "shiparrival_blocker1_clip", "targetname" );
//
//	assert( isdefined(node) );
//	assert( isdefined(blocker) );
//	assert( isdefined(blockerclip) );
//	
//	level thread blocker1_conversation(); // the barricade
//
//	tag = GetStruct( "barricade_anim_origin", "targetname" );
//	
//	level.patrenko thread patrenko_barricade_anim( tag );
//	level.nevski thread nevski_barricade_anim( tag );
//	
//	flag_wait( "P2SHIPARRIVAL_BLOCKER1_DIALOGUE_DONE" );
//	flag_wait( "P2SHIPARRIVAL_PATRENKO_AT_BARRICADE" );
//	flag_wait( "P2SHIPARRIVAL_NEVSKI_AT_BARRICADE" );
//	
//	level thread barricade_nodes_thread();
//	
//	//trigger_wait( "shiparrival_blocker1_lookat" );
//	level.patrenko notify( "push_barricade" );
//	level.nevski notify( "push_barricade" );
//	wait(8.6); // barricade needs to be timed with the anims!
//	blocker rotateto( (0,0,-80), 0.5 );
//	wait(0.5);
//	blocker notsolid();
//	blocker connectpaths();
//	blockerclip delete();
//	flag_set( "P2SHIPARRIVAL_BLOCKER1_CLEAR" );
//	
//	autosave_by_name( "fullahead" );	
//
////   level.scr_sound["Reznov"]["shh"] = "vox_ful1_s04_346A_rezn"; //Shhh... Be on your guard.
////   level.scr_sound["Reznov"]["placereeks"] = "vox_ful1_s04_347A_rezn"; //This place reeks of despair.
////   level.scr_sound["Petrenko"]["whathappened"] = "vox_ful1_s04_348A_dimi"; //What do you think happened here, Reznov?
////   level.scr_sound["Reznov"]["betternotknow"] = "vox_ful1_s04_349A_rezn"; //Perhaps it is better we do not know...
//
//	p = GetPLayers()[0];
////	iprintlnbold( "Shhh... Be on your guard." );
//	p anim_single( p, "shh", "Reznov" );
////	iprintlnbold( "This place reeks of despair." );
//	p anim_single( p, "placereeks", "Reznov" );
////	iprintlnbold( "What do you think happened here, Reznov?" );
//	level.patrenko anim_single( level.patrenko, "whathappened", "Petrenko" );
////	iprintlnbold( "Perhaps it is better we do not know..." );
//	p anim_single( p, "betternotknow", "Reznov" );
//
//}

barricade_nodes_thread()
{
	level.shipsquad[3] SetGoalNode( GetNode( "p2shiparrival_barricade_04", "targetname" ) );
	wait( 1.5 );
	level.shipsquad[2] SetGoalNode( GetNode( "p2shiparrival_barricade_03", "targetname" ) );
}

patrenko_barricade_anim( tag ) // left side
{
	tag anim_reach( level.patrenko, "walk_through_hall_guy02", "generic" );
	flag_set( "P2SHIPARRIVAL_PATRENKO_READY_FOR_BARRICADE" );
	flag_wait( "P2SHIPARRIVAL_NEVSKI_READY_FOR_BARRICADE" );

	tag anim_single_aligned( level.patrenko, "walk_through_hall_guy02", undefined, "generic" );
	tag thread anim_generic_loop( level.patrenko, "walk_through_hall_loop_guy02", "push_barricade" );
	flag_set( "P2SHIPARRIVAL_PATRENKO_AT_BARRICADE" );
	level.patrenko waittill( "push_barricade" );

	tag anim_single_aligned( level.patrenko, "push_debris_guy02", undefined, "generic" );		
}

nevski_barricade_anim( tag ) // right side
{
	
	wait( 1.5 );
	tag anim_reach( level.nevski, "walk_through_hall_guy01", "generic" );
	flag_set( "P2SHIPARRIVAL_NEVSKI_READY_FOR_BARRICADE" );
	flag_wait( "P2SHIPARRIVAL_PATRENKO_READY_FOR_BARRICADE" );
		
	tag anim_single_aligned( level.nevski, "walk_through_hall_guy01", undefined, "generic" );	
	tag thread anim_generic_loop( level.nevski, "walk_through_hall_loop_guy01", "push_barricade" );
	flag_set( "P2SHIPARRIVAL_NEVSKI_AT_BARRICADE" );
	level.nevski waittill( "push_barricade" );
		
	tag anim_single_aligned( level.nevski, "push_debris_guy01", undefined, "generic" );
}

// self should be level
//first_enemyattack_thread()
//{
//	// this needs to be nonsolid so our mans can spawn
////	boiler_clip = getent( "boiler_clip", "targetname" );
////	boiler_clip notsolid();
////	boiler_clip connectpaths();
//	
//	spawner1 = getent( "p2shiparrival_traverse_enemy", "targetname" );
//	spawner2 = getent( "p2shiparrival_traverse_enemy2", "targetname" );
//	spawner3 = getent( "p2shiparrival_traverse_enemy3", "targetname" );
//	spawner4 = getent( "p2shiparrival_traverse_enemy4", "targetname" );
//	spawner5 = getent( "p2shiparrival_traverse_enemy5", "targetname" );
//	
//	turret_node = getnode( "p2shiparrival_traverse_enemyspot", "targetname" );
//	noderun = getnode( "p2shiparrival_traverse_enemyrunto", "targetname" );
//	
//	turret = getent( turret_node.target, "targetname" );
//	grenade_target = getnode( "traverse_room_grenade_target", "targetname" );
//
//	assert( isdefined(spawner1) );
//	assert( isdefined(spawner2) );
//	assert( isdefined(spawner3) );
//	assert( isdefined(spawner4) );
//	assert( isdefined(spawner5) );		
//	
//	assert( isdefined(turret_node) );
//	assert( isdefined(noderun) );
//	
//	assert( isdefined(turret) );
//	assert( isdefined(grenade_target) );
//
//	//trigger_wait( "shiparrival_1stattack_trigger" );
//	
//	level.shipsquad[2] stop_magic_bullet_shield();
//	level.shipsquad[3] stop_magic_bullet_shield();
//	
////	guy = simple_spawn_single( "p2shiparrival_traverse_enemy" );
////	guy thread magic_bullet_shield();
////	guy setgoalnode( turret_node );
////	guy.goalradius = 32;
////	guy.ignoreme = true;
//	
////	guy2 = simple_spawn_single( "p2shiparrival_traverse_enemy2" );
////	guy3 = simple_spawn_single( "p2shiparrival_traverse_enemy3" );
////	guy4 = simple_spawn_single( "p2shiparrival_traverse_enemy4" );
//// 	guy5 = simple_spawn_single( "p2shiparrival_traverse_enemy5" );
//	
////	guy waittill( "goal" );
////	guy stop_magic_bullet_shield();
////	guy thread use_turret_thread( turret );
////
////	if( isdefined( guy3) && isalive( guy3) )
////	{
////		guy3 thread maps\_grenade_toss::force_grenade_toss( grenade_target.origin, "frag_grenade_german_sp", 3.0, undefined, undefined );
////	}
////	
////	if( isdefined(guy5) && isalive(guy5) )
////	{
////		guy5 thread maps\_grenade_toss::force_grenade_toss( grenade_target.origin, "frag_grenade_german_sp", 3.0, undefined, undefined );
////	}
//		
//	get_player() giveweapon( "knife_sp" );
//	get_player() AllowSprint( true );
//	get_player() thread gradiate_move_speed( 1.0, 0.03 );
//
//	// returns when the guy successfully shoots
//	// guy shoot_at_target( get_player(), undefined, undefined, 0.5 );
//
//	// wait for some guys to die
//	dead_guy_threshold = 2;
//	deadcount = 0;
//	while( deadcount <= dead_guy_threshold )
//	{
//		wait( 1.0 );
//		deadcount = 0;
//		
//		if( !isdefined(guy) || !isalive(guy) )
//			deadcount++;
//		if( !isdefined(guy2) || !isalive(guy2) )
//			deadcount++;
//		if( !isdefined(guy3) || !isalive(guy3) )
//			deadcount++;
//		if( !isdefined(guy4) || !isalive(guy4) )
//			deadcount++;
//		if( !isdefined(guy5) || !isalive(guy5) )
//			deadcount++;
//
//	}
//	
////	level notify( "stop_traverse_turret" );
//	
//	// once dead_guy_threshold has died, the rest retreat
////	level thread run_and_delete( guy, noderun );  - brave turret guy is brave
//	level thread run_and_delete( guy2, noderun );
//	level thread run_and_delete( guy3, noderun );
//	level thread run_and_delete( guy4, noderun );
//	level thread run_and_delete( guy5, noderun );
//	flag_set( "P2SHIPARRIVAL_1STATTACK_RETREATING" );
//	
//	// once the turret guy is dead, the attack is "finished"
//	while( isdefined(guy) && isalive(guy) && !flag( "P2SHIPARRIVAL_2NDATTACK_TRIGGER" ) ) // the flag check is in case the player tries to bypass the mg guy
//	{
//		wait( 1.0 );
//	}
//	
//	if( isdefined(guy) && isalive(guy) )
//	{
//		level thread run_and_delete( guy, noderun );
//	}
//	
//	flag_set( "P2SHIPARRIVAL_1STATTACK_FINISHED" );
//	level thread second_enemyattack_thread();
//}

use_turret_thread( turret )
{
	self endon( "death" );
	level endon( "stop_traverse_turret" );
	
	while( true )
	{
		self useTurret( turret );	
		wait(3);
	}
}

run_and_delete( guy, node )
{
	if( isdefined(guy) && isalive(guy) )
	{
		guy endon( "death" );
		
		guy force_goal( node, 32 );
		guy waittill( "goal" );
		guy delete();
	}
}


// self should be level
//second_enemyattack_thread()
//{
//	spn_targetname = "p2shiparrival_2ndattack_enemy_1";
//	spawner = getent( spn_targetname, "targetname" );
//	node = getnode( "p2shiparrival_2ndattack_enemyspot", "targetname" );
//	noderun = getnode( "p2shiparrival_2ndattack_enemyrunto", "targetname" );
//
//	//object = getent( "stairwell_object", "targetname" );
//	objectdest = getstruct( "stairwell_object_dest", "targetname" );
//
//	assert( isdefined(spawner) );
//	assert( isdefined(node) );
//	assert( isdefined(noderun) );
//
//	flag_wait( "P2SHIPARRIVAL_2NDATTACK_TRIGGER" );
//
//	level thread fakefire_thread( "fake_fire_stairwell_origin", "stairwell_object_dest", "stop_fake_fire" );
//		
//	guy = simple_spawn_single( spn_targetname );
//	guy magic_bullet_shield();
//	guy setgoalnode( node );
//	guy.goalradius = 32;
//	guy.ignoreme = true;
//	guy.script_noteworthy = "2ndattack_ai";
//	guy.animname = "generic";
//		
//	//trigger_wait( "p2shiparrival_2ndattack_playerpos"); // wait till the player hits the trigger
//		
//	tag = GetStruct( "kicking_equipment_anim_origin", "targetname" );	
//	tag anim_reach( guy, "kicking_equipment" );
//	
//	// kick equipment down the stairs bit
//	object.origin = guy GetTagOrigin( "tag_weapon_left" );
//	object.angles = guy GetTagAngles( "tag_weapon_left" );
//	object linkto( guy, "tag_weapon_left" );
//	
//	object thread touching_player_monitor();
//	level notify( "stop_fake_fire" );	
//	tag anim_single_aligned( guy, "kicking_equipment" );
//	guy stop_magic_bullet_shield();
//	
//	if( isalive(guy) )
//	{
//		guy.ignoreme = false;
//		guy thread force_goal( noderun );
//	}
//	level thread second_enemyattack_backupguy1();
//	level thread second_enemyattack_backupguy2();
//
//	autosave_by_name( "fullahead" );
//
//	level thread check_if_second_enemyattack_done();
//	level thread third_enemyattack_thread();
//}

touching_player_monitor() // self is the boiler
{
	player = getplayers()[0];
	
	while(!flag("P2SHIPARRIVAL_BOILER_AT_REST"))
	{
		if( self istouching(player) )
		{
			destination = GetStruct( "boiler_hits_player_dest", "targetname" );
		
			Earthquake(	0.5, 0.5, player.origin, 1000 );
			get_player() shellshock( "default", 5 );
						
			anchor = spawn("script_origin", player.origin);
			anchor.angles = player.angles;
			player linkto(anchor);
			anchor moveto(destination.origin, 0.2);
			anchor rotateto( destination.angles, 0.2 );
			anchor waittill("movedone");
			player SetStance( "prone" );
			wait( 4.8 );
			player unlink();
			anchor delete();
			self notify( "at_rest" );
			break;		
		}
		wait(0.05);
	}
}

//second_enemyattack_backupguy1()
//{
//	node1 = getnode( "2ndattack_backupguy1_a", "targetname" );
//	node2 = getnode( "2ndattack_backupguy1_b", "targetname" );
//
//	//guy = simple_spawn_single( "p2shiparrival_2ndattack_enemy_2" );
//	guy.script_noteworthy = "2ndattack_ai";
//	guy endon( "death" );
//
//	guy.goalradius = 32;
//	guy force_goal( node1 );
//
//	//trigger_wait( "2ndattack_fallback_trigger" );
//	guy.goalradius = 32;
//	guy force_goal( node2 );
//}

//second_enemyattack_backupguy2()
//{
//	node1 = getnode( "2ndattack_backupguy2_a", "targetname" );
//	node2 = getnode( "2ndattack_backupguy2_b", "targetname" );
//
//	//guy = simple_spawn_single( "p2shiparrival_2ndattack_enemy_3" );
//	guy.script_noteworthy = "2ndattack_ai";
//	guy endon( "death" );
//
//	guy.goalradius = 32;
//	guy force_goal( node1 );
//
//	trigger_wait( "2ndattack_fallback_trigger" );
//	guy.goalradius = 32;
//	guy force_goal( node2 );
//}
//
//check_if_second_enemyattack_done()
//{
//	guys = getentarray( "2ndattack_ai", "script_noteworthy" );
//	if( isdefined(guys) )
//	{
//		for( i=0; i<guys.size; i++ )
//		{
//			if( isdefined(guys[i]) && isalive(guys[i]) )
//			{
//				guys[i] waittill( "death" );
//			}
//		}
//	}
//
//	flag_set( "P2SHIPARRIVAL_2NDATTACK_FINISHED" );
//}

// self should be level
//third_enemyattack_thread()
//{
//	spawner = getent( "3rdattack_enemy", "targetname" );
//	node = getnode( "3rdattack_enemyspot", "targetname" );
//	noderun = getnode( "3rdattack_enemyrunto", "targetname" );
//	grenade_target = getstruct( "3rdattack_grenade_target", "targetname" ).origin;
//
//	assert( isdefined(spawner) );
//	assert( isdefined(node) );
//	assert( isdefined(noderun) );
//	assert( isdefined(grenade_target) );
//
//	//trigger_wait( "3rdattack_player_in_position" );
//
//	guy = simple_spawn_single( "3rdattack_enemy" );
//	guy thread magic_bullet_shield();
//	guy setgoalnode( node );
//	guy forceteleport( node.origin, node.angles );
//	guy.ignoreme = true;
//
//	//trigger_wait( "3rdattack_player_in_position" );
//
//	g_vel = ( grenade_target - guy.origin ) * 1.5;
//	g_vel = g_vel + (0,0,250);
//	guy MagicGrenadeType( "frag_grenade_german_sp", guy.origin + (0,0,48), g_vel );
//	guy shoot_at_target( get_player(), undefined, undefined, 0.5 );
//	guy stop_magic_bullet_shield();
//	guy.ignoreme = false;
//
//	guy waittill( "death" );
//
//	flag_wait( "P2SHIPARRIVAL_2NDATTACK_FINISHED" );
//
//	ship_door_open( 2 );
//
//	flag_set( "P2SHIPARRIVAL_3RDATTACK_FINISHED" );
//
//	level thread shiparrival_front_two_to_nodes( "door5", true, "4a_to_5" );
//	level thread shiparrival_vip_to_nodes( "door5", false, undefined, 6.0 );
//	level thread shiparrival_back_two_to_nodes( "door5", true, 12.0 );
//	
//	autosave_by_name( "fullahead" );
//}

// self should be the script_origin with the guy (client) attached
shiparrival_fakeanimate( client, chain, dest_node_targetname )
{
	// play "animations" appropriately based on the origin's current state
	self follow_struct_chain( chain, 65, 65 );
}

// self should be the script_origin with the guy (client) attached
shiparrival_fakeanimate_loop( client, struct_name )
{
	client endon( "stoploop" );

	struct = getstruct( struct_name, "targetname" );

	// play "animations" appropriately based on the origin's current state
	self moveto( struct.origin, 0.1 );

	while( true )
	{
		wait( 0.1 );
	}
}


shiparrival_flashlight_reminder()
{
	self endon( "death" );
	self endon( "stop_flashlight_reminder" );

	while( true )
	{
		wait(5);

		i = randomint( 5 );
		key = "fremind" + i;
		self anim_single( self, key, "Petrenko" );
	}
}

player_at_torch_door_thread()
{
	self waittill( "trigger" );
	flag_set( "P2SHIPARRIVAL_PLAYER_AT_TORCH_DOOR" );
}

// self should be level
shiparrival_ambush_sequence()
{
//	array_thread( getentarray( "flashlight_ambush_spawner", "script_noteworthy" ), ::add_spawn_function,::flashlight_ambush_spawner_death_counter );
//	//simple_spawn( "p2shiparrival_flashlight_ambush" );
//	//iprintlnbold("flashlight_ambush_spawned");
//	level thread flashlight_ambush_spawner_death_watcher();
//	
//	//flag_wait( "P2SHIPARRIVAL_AMBUSH_BEGIN" );
//		
//	// throw fake grenade
//	g_start = getent( "ambush_grenadethrow_start", "targetname" );
//	g_target = getstruct( "ambush_grenadethrow_target", "targetname" );
//	g_vel = ( g_target.origin - g_start.origin ) * 1.5;
//	g_vel = g_vel + (0,0,250);
//	g_start MagicGrenadeType( "frag_grenade_german_sp", g_start.origin, g_vel );
//	
//	// start ambush
//	flag_set( "P2SHIPARRIVAL_AMBUSH_STARTED" );
//	level notify("activate_flashlight_ambush_spawners");
//	wait( 0.25 );
//	get_player() thread gradiate_move_speed( 1.0 );
//
//	wait( 3 ); // a bit of a delay so Patrenko doesn't end up standing on the grenade
//	level thread shiparrival_front_two_to_nodes( "door6", true, "5_to_6" );
//	level thread shiparrival_vip_to_nodes( "door6", false, undefined, 5.0 );	
//	level thread shiparrival_back_two_to_nodes( "door6", true, 10.0 );
//	
//	//flag_wait( "P2SHIPARRIVAL_BREADCRUMB4" );
//	
//	level thread shiparrival_front_two_to_nodes( "door6a", true, "6_to_6a" );
//	
//	
//	// back to run() and then on to maps\fullahead_p2_shipcargo::run();
	
	
	
	

}

flashlight_ambush_spawner_death_counter()	// self = ai
{
	self thread activate_upon_notify("activate_flashlight_ambush_spawners");	
	self waittill("death");
	
	level.flashlight_ambush_spawner_death_count++;
	if( level.flashlight_ambush_spawner_death_count > level.flashlight_ambush_spawner_death_max )	
	{
		level notify( "ambush_spawner_death_count_reached" );	
	}	
}

flashlight_ambush_spawner_death_watcher()	// self = level
{
	level waittill( "ambush_spawner_death_count_reached" );
	flag_set( "P2SHIPARRIVAL_AMBUSH_COMPLETE" );
	send_to_retreat_node( "flashlight_ambush_spawner", "script_noteworthy", "p2shiparrival_flashlight_ambush_retreat_node");	
}

// post ambush squad only has 2 spawners.  The first one that dies sends a notify for the other to retreat
/*
post_ambush_squad()
{
	// spawning 2 guys, so after first is killed we set off pre 4thattack squad
	array_thread( getentarray( "post_ambush_backup_spawner", "script_noteworthy" ), ::add_spawn_function,::post_ambush_backup_retreat_notify );
	simple_spawn( "p2shiparrival_flashlight_ambush_backup" );

	level waittill("post_ambush_backup_retreat");
	send_to_retreat_node( "post_ambush_backup_spawner", "script_noteworthy", "p2shiparrival_flashlight_ambush_backup_retreat_node");		
}

post_ambush_backup_retreat_notify()	// self = ai
{
	// backup should have target their nodes
	node = GetNode( self.target, "targetname" );
	self thread force_goal( node, 128 );
	
	self waittill("death");
	level notify("post_ambush_backup_retreat");
}
*/
 