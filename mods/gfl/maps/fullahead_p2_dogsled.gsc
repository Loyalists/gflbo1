/*
//-- Level: Full Ahead
//-- Level Designer: Christian Easterly
//-- Scripter: Jeremy Statz
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_utility_code;
#include maps\fullahead_util;
#include maps\fullahead_anim;
#include maps\fullahead_drones;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_music;

// The level-skip shortcuts go here, the main level flow goes straight to run()
run_skipto()
{
	// misc setup necessary to make the skipto work goes here
	run();
}

run()
{

	

	//waiting for redact text to be long before starting the narration.
	intro_narration();
	init_event();
	level.streamHintEnt delete();
	//fade_out( 0.25, "white" );
	level thread fade_in( 1, "white", 5 );
	level thread show_redacted();

	p = get_players()[0];
	p DisableWeapons();
	p fa_show_hud( false ); // disable for redacted text -jc

	
	wait(5);
	level thread objectives(0);

	// first play the intro cinematic, whatever that may be
	level thread snowcat_spawn_crowd();

	// here player is frozen in place while looking over a cliff and people talk in front of you
	level thread snowcat_playintro();
	
	// wait until player approaches snowcat and gets in
	level thread snowcat_sequence();
	
	// wait until player hits trigger and set the cleanup flag
	level thread snowcat_exit();

	flag_wait( "P2SNOWCAT_EXIT_TRIGGERED" );
	
	outro_narration();
	
	cleanup();
	//clientnotify("end_superflare");
	maps\fullahead_p2_nazibase::run();
}

#using_animtree ("fakeShooters");
init_event()
{
	fa_print( "init p2 snowcat\n" );

	get_player() SetClientDvar( "sm_sunSampleSizeNear", 1.25 );
	
	dogsled_fog();
	fa_visionset_dogsled();
	
	tracks = GetEnt("snowcattracks", "targetname");
	tracks Hide();
	
	containment_trigger_startup( "dogsled_containment" );

	// relocate player to correct position
	player_to_struct( "p2dogsled_playerstart" );
	player = get_player();
	player thread cold_breath("plyr");
	//player SetLowReady(true);	
	player TakeWeapon("frag_grenade_russian_sp");


	level.snowcat_petrenko = simple_spawn_single( "p2snowcat_petrenko" );
	level.snowcat_petrenko.animname = "generic";
	level.snowcat_petrenko.name = "Petrenko";
	level.snowcat_petrenko thread cold_breath("guy");

	level.snowcat_nevski = simple_spawn_single( "p2snowcat_nevski" );
	level.snowcat_nevski.animname = "generic";
	level.snowcat_nevski.name = "Nevski";
	level.snowcat_nevski thread cold_breath("guy");

	level.snowcat_sniperguy = simple_spawn_single( "p2snowcat_sniperguy" );
	level.snowcat_sniperguy.animname = "generic";

	level.snowcat_dragovich = simple_spawn_single( "p2snowcat_dragovich" );
	level.snowcat_dragovich.targetname = "dragovich";
	level.snowcat_dragovich.animname = "dragovich";
	level.snowcat_dragovich set_run_anim( "brisk_walk", true );
	level.snowcat_dragovich.name = "Dragovich";
	level.snowcat_dragovich thread cold_breath("guy");
	//level.snowcat_dragovich HidePart( "tag_weapon" );
	level.snowcat_dragovich animscripts\shared::placeWeaponOn( level.snowcat_dragovich.primaryweapon, "none" ); 
	
	level.snowcat_guy1 = simple_spawn_single( "p2snowcat_guy1" );
	level.snowcat_guy1.animname = "generic";
	level.snowcat_guy1 set_run_anim( "patrol_walk", true );

	level.snowcat_krav = simple_spawn_single( "p2snowcat_kravchenko" );
	level.snowcat_krav.animname = "kravchenko";
	level.snowcat_krav set_run_anim( "brisk_walk", true );
	level.snowcat_krav.name = "Kravchenko";
	level.snowcat_krav.targetname = "Kravchenko";
	level.snowcat_krav thread cold_breath("guy");
	//level.snowcat_krav HidePart( "tag_weapon" );
	level.snowcat_krav animscripts\shared::placeWeaponOn( level.snowcat_krav.primaryweapon, "none" ); 
	
	level.snowcat_guy1 setgoalnode_tn( "p2snowcat_guy1_spot" );
	level.snowcat_guy1 thread play_idle( "p2snowcat_guy1_spot" );
	level.snowcat_player_vehicle = spawn_vehicle_from_targetname("snowcat_player_vehicle");
	level.snowcat_player_vehicle thread play_snowcat_fx();
	//level.snowcat_player_vehicle DisableClientLinkTo();
	level.snowcat_drag_vehicle = spawn_vehicle_from_targetname("snowcat_dragovich_vehicle");
	level.snowcat_drag_vehicle thread play_snowcat_fx();
	level.snowcat_krav_vehicle = spawn_vehicle_from_targetname("snowcat_kravchenko_vehicle");
	level.snowcat_krav_vehicle thread play_snowcat_fx();
	level.snowcat_npc1_vehicle = spawn_vehicle_from_targetname("snowcat_npc1_vehicle");
	level.snowcat_npc1_vehicle thread play_snowcat_fx();
	level.snowcat_npc2_vehicle = spawn_vehicle_from_targetname("snowcat_npc2_vehicle");
	level.snowcat_npc2_vehicle thread play_snowcat_fx();
	
	level.snowcat_player_vehicle thread play_snowcat_audio();
	//level.snowcat_drag_vehicle thread play_snowcat_audio();
	//level.snowcat_krav_vehicle thread play_snowcat_audio();
	//level.snowcat_npc1_vehicle thread play_snowcat_audio();
	//level.snowcat_npc2_vehicle thread play_snowcat_audio();	
	// play idle animations

	node_krak = getnode( "e1_krak_talk", "targetname" );
	node_dragovich = getnode( "e1_drag_talk", "targetname" );

	node_dragovich thread anim_loop( level.snowcat_dragovich, "we_must_hurry_idle", "stop_heroberlin_talk" );
	node_krak thread anim_loop( level.snowcat_krav, "we_must_hurry_idle", "stop_heroberlin_talk" );

	//fix same head problem -jc
	guys = array(level.snowcat_nevski,level.snowcat_sniperguy,level.snowcat_guy1,level.snowcat_smoker);
	
	//remove random head and replace with linear head - from vorkuta mine
	// head_array = xmodelalias\c_rus_fullahead_head_alias::main();
	// for( i = 0; i < guys.size; i++ )
	// {
	// 	guys[i] detach(guys[i].headModel);
	// 	guys[i].headModel = head_array[i];
	// 	guys[i] attach(guys[i].headModel, "", true);
	// }

}


#using_animtree ("vehicles");
play_snowcat_fx()
{
	PlayFXOnTag(level._effect["engine_heat"], self, "tag_engine_left");
	PlayFXOnTag(level._effect["engine_heat"], self, "tag_engine_right");
	PlayFXOnTag(level._effect["snowcat_exhaust"], self, "tag_exhaust");
	self.animname = "snowcat";
	self thread anim_loop(self, "idle");
}
play_idle( tn )
{
	level endon("start_dragovich_speach");
	//self waittill("goal");
	node = GetNode(tn, "targetname");
	while(1)
	{
		node anim_single_aligned(self, "idle_loop");
	}
	
}
// gets run through at start of level
init_flags()
{
	flag_init( "P2SNOWCAT_INTRO_FINISHED" );
	flag_init( "P2SNOWCAT_AREA_REACHED" );		
	flag_init( "P2SNOWCAT_GETON_CINEMA_START" );
	flag_init( "P2SNOWCAT_EXIT_TRIGGERED" );
	maps\fullahead_p2_nazibase::init_flags();
}

cleanup()
{
	fa_print( "cleanup p2 snowcat\n" );
	level notify( "P2DOGSLED_CLEANUP" );
	level notify( "DOGSLEDS_RESET" );

	get_player() unlink(); // force the player off the dogsled, we're about to teleport

	// aggressively remove anybody in the area
	ai = getaiarray( "axis", "allies", "neutral" );
	for( i=0; i<ai.size; i++ )
	{
		if( isdefined(ai[i]) )
		{
			if( ai[i].origin[0] < 0 && ai[i].origin[1] > 0 )
			{

				ai[i] delete();
			}
		}
	}
	
	// the snowcats
	delete_inside_dogsled_quadrant( "script_vehicle" );
	
	// general things that we no longer need
	delete_inside_dogsled_quadrant( "script_model" );
	delete_inside_dogsled_quadrant( "script_brushmodel" );
	delete_inside_dogsled_quadrant( "script_origin" );
	delete_inside_dogsled_quadrant( "dyn_model" );
	delete_inside_dogsled_quadrant( "dyn_brushmodel" );
	delete_inside_dogsled_quadrant( "trigger_multiple" );
	delete_inside_dogsled_quadrant( "trigger_radius" );
	
	player = get_player();
	player Unlink();
	player EnableWeapons();	
	player SetLowReady(false);
	player GiveWeapon("frag_grenade_russian_sp");

}

delete_inside_dogsled_quadrant( classname )
{
	array = getentarray( classname, "classname" );
	for( i=0; i<array.size; i++ )
	{
		if( isdefined(array[i]) )
		{
			if( array[i].origin[0] < 0 && array[i].origin[1] > 0 )
			{
				array[i] delete();
			}
		}
	}
}

objectives( starting_obj_num )
{
	flag_wait( "P2SNOWCAT_INTRO_FINISHED" );

	curr_obj_num = starting_obj_num;

	objective_add( curr_obj_num, "active", &"FULLAHEAD_OBJ_FOLLOW_PETRENKO" );
	objective_position( curr_obj_num, level.snowcat_petrenko );
	objective_set3d( curr_obj_num, true, "default", &"FULLAHEAD_MARKER_FOLLOW" );	
	Objective_Current(curr_obj_num);
	flag_wait( "P2SNOWCAT_AREA_REACHED" );
	
	objective_add( curr_obj_num, "active", &"FULLAHEAD_OBJ_REGROUP_VEHICLES" );
	objective_position( curr_obj_num, ent_origin("snowcat_geton_trigger") );
	objective_set3d( curr_obj_num, true );
	Objective_Current(curr_obj_num);
	flag_wait( "P2SNOWCAT_GETON_CINEMA_START" );
	Objective_State( curr_obj_num, "done" );
	Objective_Delete( curr_obj_num );
	
	flag_wait( "P2SNOWCAT_EXIT_TRIGGERED" );	
	
	// do not increment the number, let the next objective stomp over this one.
	maps\fullahead_p2_nazibase::objectives( curr_obj_num );
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

show_redacted()
{
	fa_print( "Playing redacted text" );
	
	level.introscreen_shader = "none";
	level.introscreen_dontfreezcontrols = true;

	level maps\_introscreen::introscreen_redact_delay( &"FULLAHEAD_INTROSCREEN_1", &"FULLAHEAD_INTROSCREEN_2", &"FULLAHEAD_INTROSCREEN_3", &"FULLAHEAD_INTROSCREEN_4", &"FULLAHEAD_INTROSCREEN_5" );
}

// self will be the reznov script_model
intro_narration_callback(  )
{
//     level.scr_sound["Reznov"]["intro9"] = "vox_ful1_s01_014A_rezn"; //NARRATION When the 3rd Shock Army became part of the Soviet Occupation Forces in Germany, it was clear that the end of the war did not herald our return to Russia...
//     level.scr_sound["Reznov"]["intro10"] = "vox_ful1_s02_015A_rezn"; //NARRATION No... Our leaders had other plans...
	flag_wait( "starting final intro screen fadeout" );
	
	wait(0.05);
	player = get_players()[0];
	//player DisableClientLinkTo();
	player DisableWeapons();
	assertex(!isdefined(level.current_hands_ent), "Player body already exists when it shouldn't.");
	level.current_hands_ent = spawn_anim_model( "playerbody" );	
	level.current_hands_ent.animname = "playerbody";
	level.current_hands_ent.origin = self.origin;
	level.current_hands_ent.angles = self.angles;
	
	self anim_first_frame( self, "narr_1", undefined, "generic" );
	self anim_first_frame( level.current_hands_ent, "narr_1", undefined, "playerbody" );	
	player PlayerLinkToAbsolute( level.current_hands_ent, "tag_player");
	
	wait(1.5);
	
		
	//TUEY Set music to INTRO
	setmusicstate ("INTRO");

	self thread anim_single(self, "narr_1" );
	self thread anim_single_aligned( level.current_hands_ent, "narr_1", undefined, "playerbody" );
	
	wait(0.05);
	hud_utility_hide("black", 1.5);
	
	level waittill("start_fade_out");
	flag_set( "reznov_cutscene_startfade" );
	//SOUND - Shawn J - snow gusts & snapshot notify
	playsoundatposition("evt_blizzard_gust",(0,0,0));
	level thread transition_smoother();
	clientnotify( "snapshot_default_1" );	
	
	wait(5);
	level.current_hands_ent delete();
	player unlink();
	//player EnableWeapons();
	flag_set( "reznov_cutscene_done" );
	autosave_by_name( "fullahead" );
}

intro_narration()
{
	player = get_player();
	player freezecontrols(true);
	player snowy_enter_vignette();
	//wait(10);
	do_reznov_cutscene( ::intro_narration_callback );
	player freezecontrols(false);		
}

outro_narration_callback( camera_ent )
{




	player = get_players()[0];
	//player DisableClientLinkTo();
	player DisableWeapons();
	//assertex(!isdefined(level.current_hands_ent), "Player body already exists when it shouldn't.");

	if(IsDefined(level.current_hands_ent))
	{
		level.current_hands_ent delete();
	}	
	level.current_hands_ent = spawn_anim_model( "playerbody" );	
	level.current_hands_ent.animname = "playerbody";
	level.current_hands_ent.origin = self.origin;
	level.current_hands_ent.angles = self.angles;
	setmusicstate ("NARRATION_POST_DOGSLED");
	wait(0.1);	// this is needed to play the first audio clip

	self thread anim_single(self, "narr_2");
	//TUEY Set music to INTRO
	//self anim_first_frame( level.current_hands_ent, "narr_2", undefined, "playerbody" );	
	
	self thread anim_single_aligned( level.current_hands_ent, "narr_2", undefined, "playerbody" );
	player PlayerLinkToAbsolute( level.current_hands_ent, "tag_player");
	wait(0.5);
	hud_utility_hide("white");


	level waittill("start_fade_out");
	flag_set( "reznov_cutscene_startfade" );
	//SOUND - Shawn J - snow gusts & snapshot notify
	playsoundatposition("evt_blizzard_gust",(0,0,0));	
	clientnotify( "snapshot_default_2" );
	wait(5);
	level.current_hands_ent delete();
	flag_set( "reznov_cutscene_done" );

	player unlink();
	//player EnableWeapons();
}

outro_narration()
{
	player = get_player();
	
	player thread snowy_enter_vignette( true );
	level.streamHintEnt = createStreamerHint((-1160, -1152, -152), 1.0 );
	//SOUND - Shawn J - snow gusts & snapshot notify
	playsoundatposition("evt_blizzard_gust",(0,0,0));	
	clientnotify( "snapshot_flashback_2" );
	
	level waittill( "reznov_cutscene_snow_to_fade" );
	StopAllRumbles();
	level thread fade_in( 5, "white" );
	player freezecontrols(true);
	
	// teleport player to prevent petrenko name from appearing in white room
	player_to_struct( "p2dogsled_playerstart" );

	//level fade_out( 2.8, "white", 0.66 );	
	
	do_reznov_cutscene( ::outro_narration_callback );
	player freezecontrols(false);
	level.streamHintEnt delete();
}

snowcat_spawn_crowd()
{
	dogsled_beckoner = getstruct( "dogsled_beckoner", "targetname" );
	drone = fa_drone_spawn( dogsled_beckoner, "allieshigh" );
	dogsled_beckoner thread anim_loop( drone, "wave_to_snowcats" );
	

	nodes = getstructarray( "dogsled_crowd_patrol", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		drone thread fa_drone_move( node );
		wait(0.05);
	}

	// Add radiomen
	nodes = getstructarray( "dogsled_crowd_radio", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		if( node.script_string == "low" )
		{
			drone = fa_drone_spawn( node, "allies" );
		}
		else if( node.script_string == "high" )
		{
			drone = fa_drone_spawn( node, "allieshigh" );
		}
		else
		{
			assert(0);	
		}
		 
		drone hidepart("tag_weapon");
		node thread anim_loop( drone, "dock_workers_radio" );
		drone thread delete_on_notify( "start_dragovich_speach" );
		wait(0.05);
	}
	
	// Add guys talking
	nodes = getstructarray( "dogsled_crowd_talk_e", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		
		drone1 = undefined;
		drone2 = undefined;
		if( node.script_string == "low" )
		{
		/*	drone1 = fa_drone_spawn( node, "allies" );
			drone2 = fa_drone_spawn( node, "allies" );*/
			drone1 = simple_spawn_single("drone_spawner");
			drone1.animname = "generic";
			drone2 = simple_spawn_single("drone_spawner");
			drone2.animname = "generic";

		}
		else if( node.script_string == "high" )
		{
			//drone1 = fa_drone_spawn( node, "allieshigh" );
			//drone2 = fa_drone_spawn( node, "allieshigh" );
			drone1 = simple_spawn_single("drone_spawner");
			drone1.animname = "generic";
			drone2 = simple_spawn_single("drone_spawner");
			drone2.animname = "generic";
		}
		else
		{
			assert(0);	
		}
		
		drone1 hidepart("tag_weapon");
		drone2 hidepart("tag_weapon");
		node thread anim_loop( drone1, "dock_workers_e_1" );
		node thread anim_loop( drone2, "dock_workers_e_2" );
		drone1 thread delete_on_notify( "start_dragovich_speach" );
		drone2 thread delete_on_notify( "start_dragovich_speach" );
		wait(0.05);
	}

	nodes = getstructarray( "dogsled_crowd_talk_f", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		
		drone1 = undefined;
		drone2 = undefined;		
		if( node.script_string == "low" )
		{
			//drone1 = fa_drone_spawn( node, "allies" );
			//drone2 = fa_drone_spawn( node, "allies" );
			drone1 = simple_spawn_single("drone_spawner");
			drone1.animname = "generic";
			drone2 = simple_spawn_single("drone_spawner");
			drone2.animname = "generic";
		}
		else if( node.script_string == "high" )
		{
			//drone1 = fa_drone_spawn( node, "allieshigh" );
			//drone2 = fa_drone_spawn( node, "allieshigh" );
			drone1 = simple_spawn_single("drone_spawner");
			drone1.animname = "generic";
			drone2 = simple_spawn_single("drone_spawner");
			drone2.animname = "generic";
		}
		else
		{
			assert(0);	
		}
				
		drone1 hidepart("tag_weapon");
		drone2 hidepart("tag_weapon");	
		node thread anim_loop( drone1, "dock_workers_f_1" );
		node thread anim_loop( drone2, "dock_workers_f_2" );
		drone1 thread delete_on_notify( "start_dragovich_speach" );
		drone2 thread delete_on_notify( "start_dragovich_speach" );
		wait(0.05);
	}
	
	// smoking idle
	level.snowcat_smoker = simple_spawn_single( "p2snowcat_smoker" );
	level.snowcat_smoker.animname = "generic";
	level.snowcat_smoker thread anim_loop( level.snowcat_smoker, "smoke", "stop_smoking" );
	level.snowcat_smoker thread stop_looping_anim( "stop_smoking", "start_dragovich_speach" );
	wait(0.05);
		
	nodes = getstructarray( "workingguard_loop", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		node thread anim_loop( drone, "workingguard_loop" );
		wait(0.05);
	}

	nodes = getstructarray( "lower_supplies_ground", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		node thread anim_loop( drone, "lower_supplies_ground" );
		wait(0.05);
	}

	nodes = getstructarray( "lower_supplies_ship", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "lower_supplies_ship" );
		wait(0.05);
	}

	nodes = getstructarray( "civilianwithclipboard", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		//if( node.script_string == "low" )
		//{
		//	drone = fa_drone_spawn( node, "allies" );
		//}
		//else if( node.script_string == "high" )
		//{
		//	drone = fa_drone_spawn( node, "allieshigh" );
		//}
		//else
		//{
		//	assert(0);	
		//}

		drone = simple_spawn_single("drone_spawner");
		drone.animname = "generic";
	
		
		drone hidepart("tag_weapon");
		node thread anim_loop( drone, "civilianwithclipboard" );
		drone thread delete_on_notify( "start_dragovich_speach" );
		wait(0.05);
	}

	nodes = getstructarray( "rail_prisoner5_loop", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "rail_prisoner5_loop" );
		wait(0.05);
	}

	nodes = getstructarray( "rail_prisoner6_loop", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "rail_prisoner6_loop" );
		wait(0.05);
	}

	nodes = getstructarray( "mortar_spotters_b", "targetname" );
	for( i=0; i<nodes.size; i++ )
	{
		node = nodes[i];
		drone = fa_drone_spawn( node, "allies" );
		drone HidePart("tag_weapon");
		node thread anim_loop( drone, "mortar_spotters_b" );
		wait(0.05);
	}
	
	// equiptment on snowcat
	boxes = GetEntArray( "snowcat_equiptment", "targetname" );
	for( i=0; i<boxes.size; i++ )
	{
		assert(isdefined(boxes[i].target));
		vehicle = GetEnt( boxes[i].target, "targetname" );
		boxes[i] linkto( vehicle );		
	}
	
	// snowcat drivers
	driver = GetStructArray( "snowcat_driver", "targetname" );
	for( i=0; i<driver.size; i++ )
	{
		driver[i] snowcat_driver_setup();
		wait(0.05);
	}

   	// Kravchenko's snowcat	
   	guys = getstructarray( "snowcat_riders_A", "targetname" );
   	for( i=0; i<guys.size; i++ )
   	{
		guys[i] snowcat_passenger_setup( "allieshigh" );
   	}
   	
   	// npc1 snowcat
   	guys = getstructarray( "snowcat_riders_B", "targetname" );
   	for( i=0; i<guys.size; i++ )
   	{
		guys[i] snowcat_passenger_setup( "allieshigh" );
   	}
   
   	// dragovich's snowcat passengers
   	guys = getstructarray( "snowcat_riders_C", "targetname" );
   	for( i=0; i<guys.size; i++ )
   	{
		guys[i] snowcat_passenger_setup( "allieshigh" );
   	}
   	
	// player's snowcat
   	guys = getstructarray( "snowcat_riders_D", "targetname" );
   	for( i=0; i<guys.size; i++ )
	{
		guys[i] snowcat_passenger_setup( "allieshigh" );
	}		
   				
}

set_seat_occupied( seat_tag )	// self = vehicle 
{
	vehicleanim = self get_aianims();
	for( i=0; i<vehicleanim.size; i++ )
	{
		if( vehicleanim[i].sittag == seat_tag )
		{
			self.usedPositions[i] = true;
			return;
		}	
	}
	
	assertex( 0, "Seat tag not found in vehicle");
}

get_seat_tag_position( seat_tag )	// self = vehicle
{
	vehicleanim = self get_aianims();
	for( i=0; i<vehicleanim.size; i++ )
	{
		if( vehicleanim[i].sittag == seat_tag )
		{			
			return i;
		}	
	}
	
	assertex( 0, "seat tag not found in vehicle");	
}

snowcat_passenger_setup( drone_lod )	// self = struct
{
   	passenger = fa_drone_spawn( self, drone_lod );
   	passenger thread snowcat_passenger_cleanup();
	vehicle = GetEnt( self.target, "targetname" );	
   	assert(isdefined(self.target));
	assert(isdefined(self.script_string));   	
	
	seat_tag = "tag_guy" + self.script_string;
	vehicle set_seat_occupied( seat_tag );
	//Create a link ent for them.
	tag_origin = vehicle GetTagOrigin(seat_tag);
	tag_angles = vehicle GetTagAngles(seat_tag);
	
	//passenger DisableClientLinkTo();

	//Link them to the link ent.
	passenger LinkTo( vehicle, seat_tag );

	//Link the link ent to the snowcat.
	//passenger LinkTo( vehicle );   	
   	vehicle thread anim_single_aligned( passenger, "snowcat_guy" + self.script_string + "_sit_idle", seat_tag );
	passenger SetAnim(level.scr_anim[ "generic" ][ "blink_2"][0], 1);
   	wait(0.05);
}

snowcat_driver_setup()	// self = struct
{
	driver = fa_drone_spawn( self, "allieshigh", true );
	assert(isdefined(self.target));
	
	vehicle = GetEnt( self.target, "targetname" );
	
	// unused seats
	vehicle.usedPositions[ 0 ] = true;
	vehicle.usedPositions[ 1 ] = true;
	vehicle.usedPositions[ 2 ] = true;
	vehicle.usedPositions[ 6 ] = true;
	driver linkto(vehicle, "tag_driver");  	

	vehicle thread anim_loop_aligned( driver, "snowcat_driver_idle", "tag_driver", "generic" );
	driver thread snowcat_passenger_cleanup();
}

snowcat_passenger_cleanup()
{   	
   	level waittill( "P2DOGSLED_CLEANUP" );
   	if(isdefined(self))
   	{
   		self unlink();
   		self delete();
   	}
}

stop_looping_anim( notify_to_self, notify_from_level )
{
	level waittill( notify_from_level );
	self notify( notify_to_self );
}

delete_on_notify( notify_msg )	// self = entity to delete
{
	level waittill( notify_msg );
	self delete();
}

snowcat_playintro()
{
//    level.scr_sound["Soldier"]["loaded"] = "vox_ful1_s02_016A_sol1_f"; //Everything is loaded. They are waiting.
//    level.scr_sound["Petrenko"]["itistime"] = "vox_ful1_s02_017A_dimi"; 			//Viktor... It is time.
//    level.scr_sound["Reznov"]["lastremnants"] = "vox_ful1_s02_018A_rezn"; 			//Yes, Dimitri... Time to hunt down the last remnants of the fascist Reich.
//    level.scr_sound["Petrenko"]["grabthegear"] = "vox_ful1_s02_019A_dimi"; 			//Nevski... Grab the gear... We are moving out.

	level thread move_crane_thread();
	
	// fix the player in place right away
	player = get_player();
	player AllowJump(false);
	player AllowCrouch(false);
	player AllowProne(false);
	player AllowMelee(false);
	player set_move_speed( 0.00 );
	player FreezeControls( true );
	player SetClientDvar("cg_drawFriendlyNames", 0);
	//player thread player_look_down();
	//level thread anim_single( level.snowcat_sniperguy, "vista1" );
	//clientnotify("start_superflare");

	align_struct = getstruct( "new_anim_origin", "targetname" );
	//level thread itstime_dialogue_thread();
	

	//align_struct thread play_paused_animation_nev(level.snowcat_nevski);
	//align_struct play_paused_animation_pat(level.snowcat_petrenko);

	align_struct thread anim_single_aligned( level.snowcat_nevski, "itstime_anim", undefined, "nevski" );
	align_struct thread anim_single_aligned( level.snowcat_petrenko, "itstime_anim", undefined, "petrenko" );
	align_struct thread play_player_intro_anim();
	level thread hud_utility_hide("white", 1);
	align_struct waittill( "itstime_anim" );
	player FreezeControls( false );
	player SetLowReady(1);
	player AllowJump(true);
	player AllowCrouch(true);
	player AllowProne(true);
  player SetClientDvar("cg_drawFriendlyNames", 1);
  player fa_show_hud( true ); // 

	
	// send other 2 guys down there
	level.snowcat_nevski setgoalnode_tn( "p2snowcat_nevski_spot" );	
	//level.snowcat_sniperguy setgoalnode_tn( "p2snowcat_sniperguy_spot" );
	level.snowcat_sniperguy thread play_idle("p2snowcat_sniperguy_spot");
	flag_set( "P2SNOWCAT_INTRO_FINISHED" );
	level thread snowcat_area_reached();

	reznov_petrenko_dialog();
	
	// unattach the player


	
	wait(1);
	
}

player_look_down()
{
	//self SetPlayerAngles((-90 ,106,0));
	//self StartCameraTween(6);
	//self SetPlayerAngles((0 ,106,0));
	self thread take_and_giveback_weapons("give_weapon_back");
	lookat = -90;
	while(1)
	{
		self SetPlayerAngles((lookat ,106,0));
		wait(0.05);
		lookat += 0.3;
		if(lookat >= 0)
		{
			self notify("give_weapon_back");		
			break;
		}
	}
}

//play_paused_animation_nev( guy )
//{
//	sync_node = self;
//	guy AnimScriptedSkipRestart( "climb_anim", sync_node.origin, sync_node.angles, %ch_full_b01_its_time_nevski, "normal", undefined, 1.0 );
//}
//
//play_paused_animation_pat( guy )
//{
//	sync_node = self;
//	guy AnimScriptedSkipRestart( "climb_anim", sync_node.origin, sync_node.angles, %ch_full_b01_its_time_petrenko, "normal", undefined, 1.0 );
//}


reznov_petrenko_dialog()
{
//    level.scr_sound["Petrenko"]["whathere"] = "vox_ful1_s02_023A_dimi"; //What is here that is so important?
//    level.scr_sound["Reznov"]["makename"] = "vox_ful1_s01_024A_rezn"; //General Dragovich wishes to make a name for himself. He believes this outpost houses something of great value to the motherland.
	
	// SetViewLockEnt works on tags so spawn a dummy tag and place it where we want it for now
	player = get_player();	
	//player thread gradiate_move_speed( 0.5, 0.1 );
	player thread gradiate_move_speed( 1.0 );
	level.snowcat_petrenko run_mode();
	//level.snowcat_petrenko headtracking_start( player );
	level.snowcat_petrenko setgoalnode_tn( "p2snowcat_petrenko_spot" );
	//level.snowcat_petrenko walk_mode();
	downhill_narration();

	// reznov and petrenko dialog	

	//level.snowcat_petrenko headtracking_stop();
	
		
}

itstime_dialogue_thread()
{
	player = get_player();
	
	wait(12);
	
//    level.scr_sound["Soldier"]["loaded"] = "vox_ful1_s02_016A_sol1_f";   	//Everything is loaded. They are waiting.
	//level thread anim_single( level.snowcat_sniperguy, "loaded", "Soldier" );

	wait(6);	
//	wait(18);
	
// 	level.snowcat_sniperguy anim_single( level.snowcat_sniperguy, "loaded", "Soldier" );
// 	level.snowcat_petrenko anim_single( level.snowcat_petrenko, "itistime", "Petrenko" );
	//player anim_single( player, "lastremnants", "Reznov" );
// 	level.snowcat_petrenko anim_single( level.snowcat_petrenko, "grabthegear", "Petrenko" );	
}

snowcat_sequence()
{
	fa_print( "waiting for player to get on the snowcat" );
	player = get_player();
	trigger_wait("snowcat_geton_trigger");
	level notify("player_reached_snowcat");	// turn off any audio playing while going downhill
	flag_set( "P2SNOWCAT_GETON_CINEMA_START" );
 	containment_trigger_shutdown( "dogsled_containment" ); // no messages or deaths when riding away!
	player stopsounds();
	player AllowMelee(true);

	// stop looping dragovich and kravchenko animations
	level.snowcat_player_vehicle notify("stop_heroberlin_talk");
	level notify( "start_dragovich_speach" );	// delete drones
	
	// player and petrenko gets on snowcat while dragovich and kravchenko talk to them from ground


	// special player animation played here for snowcat sequence
	level.snowcat_player_vehicle thread play_player_snowcat_anims();	

	//TUEY set music to SLE
	setmusicstate("SLED");
	level.snowcat_petrenko linkto(level.snowcat_player_vehicle, "tag_guy8");  
	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_sniperguy, "heroberlin", "tag_origin", "guy1" );
	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_nevski, "heroberlin", "tag_origin", "guy2" );
	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_guy1, "heroberlin", "tag_origin", "guy3" );
	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_smoker, "heroberlin", "tag_origin", "guy4" );
	

	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_petrenko, "heroberlin", "tag_origin", "petrenko" );   	// petrenko gets on snowcat	
	
	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_krav, "heroberlin", "tag_origin", "kravchenko" );
	level.snowcat_player_vehicle anim_single_aligned( level.snowcat_dragovich, "heroberlin", "tag_origin", "dragovich" );
	
   	// link player and petrenko to the snowcat
  		
	level thread play_petrenko_player_snowcat_idle();
	level thread wait_for_notify();
	// playing temp animation for now
	//level.snowcat_player_vehicle thread anim_loop_aligned( level.snowcat_petrenko, "snowcat_guy8_sit_idle", "tag_guy8", undefined, "generic" );	// TODO - remove when we get upated petrenko anims
	
	// send everyone to their snowcats
	level send_crowd_to_snowcats();   	
  	
   	// start vehicle movement once everyone's on vehicle
   	level.snowcat_drag_vehicle thread start_vehicle_on_pathname( "p2snowcat_dragovich_path_start" );
   	level.snowcat_krav_vehicle thread start_vehicle_on_pathname( "p2snowcat_krav_path_start" );
   	
   	level.snowcat_drag_vehicle notify( "start_movement_audio" );
   	level.snowcat_krav_vehicle notify( "start_movement_audio" );
	
//   	level.snowcat_player_vehicle JoltBody( (level.snowcat_player_vehicle.origin + (0,0,64)), 0.5 );
    player PlayRumbleLoopOnEntity("damage_light");
   	
   	// player snowcat movement
   	trigger = GetEnt("trigger_start_player_vehicle", "targetname");
   	trigger useby(player);

    level.snowcat_player_vehicle notify( "start_movement_audio" );
    
   	tracks = GetEnt("snowcattracks", "targetname");
	tracks delete();
	
	// play petrenko conversation
	level.snowcat_player_vehicle waittill( "play_petrenko_conversation_animation_done" );
	level thread start_rear_snowcats();	
		
// JMA - Temp comment out for now, until we get an updated animation with correct voice notetracks		
 	level.snowcat_player_vehicle thread anim_single_aligned( level.snowcat_petrenko, "snowcat_talk", "tag_guy8", "petrenko" );   	// petrenko talks on snowcat	
// JMA - for now play idle animation and script call VO
// JMA - TEMP AUDIO - playing reznov lines until we can get the audio notetracks for player animation
//	level thread temp_reznov_audio_2();
}

play_petrenko_player_snowcat_idle()
{

	//level.snowcat_petrenko DisableClientLinkTo();
	level.not_talking = true;
	while(level.not_talking)
	{
		level.snowcat_player_vehicle anim_single_aligned( level.snowcat_petrenko, "snowcat_idle", "tag_guy8" );
	}

	level.snowcat_player_vehicle notify("play_petrenko_conversation_animation_done");
	


}
wait_for_notify()
{
	level.snowcat_player_vehicle waittill( "play_petrenko_conversation" );

	level.not_talking = false;
	level.player_talking = false;
}

send_crowd_to_snowcats()
{
	// sending riders
	level.snowcat_krav run_mode_special();
 	level.snowcat_dragovich run_mode_special();
	level.snowcat_nevski run_mode();
	level.snowcat_sniperguy run_mode();
	
	level.snowcat_dragovich thread run_to_snowcat( level.snowcat_drag_vehicle, 8 ); 	
 	level.snowcat_nevski thread run_to_snowcat( level.snowcat_npc1_vehicle, 8 );
// 	level.snowcat_sniperguy thread run_to_snowcat( level.snowcat_npc1_vehicle, 8 );	// no room for this guy
	
	// make sure krav gets on snowcat before starting, he's the farthest snowcat
 	level.snowcat_krav run_to_snowcat( level.snowcat_krav_vehicle, 8 );
}

run_to_snowcat( vehicle, tag_guy_num)	// self = ai
{
 	self.disableArrivals = true;
	self.disableExits = true;
	self.disableTurns = true;	
	
	pos = vehicle get_seat_tag_position( "tag_guy" + tag_guy_num );
	animpos = anim_pos( vehicle, pos );	
	assert( isdefined( animpos.getin ) );
	assert( isdefined( animpos.sittag ) );
	assert( isdefined( animpos.idle ) );
	
	org = vehicle gettagorigin( animpos.sittag );
	ang = vehicle gettagangles( animpos.sittag );
	origin = getstartorigin( org, ang, animpos.getin );
	angles = getstartangles( org, ang, animpos.getin );
	
	self.goalradius = 32;
	self SetGoalPos( origin );

	//temp for now until animation can be fixed
	//wait(5);
	//self waittill("goal");
	
	// play getin animation
//	wait(0.05);
	vehicle set_seat_occupied( animpos.sittag );
	self.animname = "generic";
	vehicle anim_single_aligned( self, "snowcat_guy" + tag_guy_num + "_getin", animpos.sittag, "generic" );

	//Link them to the link ent.
	self LinkTo( vehicle, animpos.sittag );

	//Link the link ent to the snowcat. 	
   	vehicle thread anim_loop_aligned( self, "snowcat_guy" + tag_guy_num + "_sit_idle", animpos.sittag );
   	wait(0.05);	
}

run_to_vehicle_send_notify( vehicle, tag, notify_msg )	// self = ai
{
 	self run_to_vehicle_load( vehicle, undefined, tag ); 
 	level notify( notify_msg );		
}

start_vehicle_on_pathname( pathname, start_notify )	// self = vehicle
{
	if( isDefined( start_notify ) )
	{
		level waittill( start_notify );	
	}
	
	start_node = GetVehicleNode( pathname, "targetname" );
	AssertEx( IsDefined(start_node), "Unknown start node for huey pathing: p2snowcat_player_path_start");
	self StartEngineSound();	
	self thread go_path(start_node);	
}

// TEMP AUDIO - playing reznov lines until we can get the audio notetracks for player animation
temp_reznov_audio_2()
{
//	wait(6);
	wait(4);
	
	// JMA - TEMP until we get updated anims with correct VO notetracks set
	//level.scr_sound["Petrenko"]["stalingrad"] = "vox_ful1_s02_030A_dimi_m"; //What happened in Stalingrad, between you and Dragovich?
	level.snowcat_petrenko anim_single( level.snowcat_petrenko, "stalingrad", "Petrenko" );
	
	wait(0.5);
	player = get_player();	
	player anim_single( player, "germanocc", "Reznov" );
	//( "When the German occupation began, he and his lap dog Kravchenko left my men and me hopelessly outnumbered..." )

	player anim_single( player, "promises", "Reznov" );
	//( "Promises of reinforcements were made. Made... But not kept." )

	player anim_single( player, "opportunists", "Reznov" );
	//( "Dragovich and Kravchenko are opportunists... Manipulators..." )

	player anim_single( player, "nottrusted", "Reznov" );
	//( "They are not to be trusted, Dimitri." )



}

start_rear_snowcats()
{	
	start_node = GetVehicleNode( "p2snowcat_npc1_path_start", "targetname" );
	AssertEx( IsDefined(start_node), "Unknown start node for huey pathing: p2snowcat_npc1_path_start" );
	origin_tag = level.snowcat_npc1_vehicle GetTagOrigin("tag_origin");
	level.snowcat_npc1_vehicle .origin = start_node.origin;
	level.snowcat_npc1_vehicle  thread go_path(start_node);
	level.snowcat_npc1_vehicle notify( "start_movement_audio" );

	wait(2);
	start_node = GetVehicleNode( "p2snowcat_npc2_path_start", "targetname" );
	AssertEx( IsDefined(start_node), "Unknown start node for huey pathing: p2snowcat_npc2_path_start");
	origin_tag = level.snowcat_npc2_vehicle GetTagOrigin("tag_origin");
	level.snowcat_npc2_vehicle .origin = start_node.origin;
	level.snowcat_npc2_vehicle  thread go_path(start_node);
	level.snowcat_npc2_vehicle notify( "start_movement_audio" );
}

snowcat_exit()
{
	trigger_wait( "p2snowcat_exit", "targetname" );
	
	wait(8);	// JMA - temp adjustment for audio

 	flag_set( "P2SNOWCAT_EXIT_TRIGGERED" );	
}

// self should be level
downhill_narration()
{
	level endon("player_reached_snowcat");
//     level.scr_sound["Reznov"]["bitter1"] = "vox_ful1_s02_020A_rezn"; //NARRATION My men and I had fought through the most bitter of winters on the Eastern front... We were no strangers to the cold?
//     level.scr_sound["Reznov"]["bitter2"] = "vox_ful1_s02_020B_rezn"; //NARRATION The men and I had fought through the most bitter of winters on the Eastern front - We were no strangers to the cold?
//     level.scr_sound["Reznov"]["bloodchills"] = "vox_ful1_s02_021A_rezn"; //NARRATION But even now, the blood in my veins chills when I think back to the events of that day...
//     level.scr_sound["Reznov"]["farfar"] = "vox_ful1_s02_022A_rezn"; //NARRATION Far, far from home...

	player = get_player();
	player anim_single( player, "bitter2", "Reznov" );
	player anim_single( player, "bloodchills", "Reznov" );
	player anim_single( player, "farfar", "Reznov" );
}

snowcat_area_reached()
{
	trigger_wait( "snowcat_area_reached_trigger", "targetname" );
	flag_set( "P2SNOWCAT_AREA_REACHED" );	
}

move_crane_thread()
{
	level endon( "P2DOGSLED_CLEANUP" );
	
	crane_arm = GetEnt("ship_crane_arm", "targetname");
	crane_body = GetEnt("ship_crane_body", "targetname");
	
 	crane_box = getent( "snowcat_crane_box", "targetname" );
 	crane_box_control = GetEnt( "snowcat_crane_box_control_point", "targetname" );
 	crane_box linkto( crane_box_control ); 
	
	while(1)
	{
		// box starts on ship and moves up
		crane_box_control moveto( crane_box_control.origin + (0, 0, 222), 5 );
		crane_box_control waittill("movedone");
		wait(3);
		
		// rotate box and crane off the ship to unload
		crane_arm RotateYaw(113,15);
		crane_body RotateYaw(113,15);
		
		crane_box_control RotateYaw(113,15);
		crane_box_control waittill("rotatedone");	
		wait(5);
		
		// lower box onto the ground
		crane_box_control moveto( crane_box_control.origin + (0, 0, -666), 10 );
		crane_box_control waittill("movedone");
		wait(3);
		crane_box Hide();
		
		// raise invisible box
		crane_box_control moveto( crane_box_control.origin + (0, 0, 666), 1 );
		crane_box_control waittill("movedone");
		
		// rotate back to the ship		
		crane_arm RotateYaw(-113,15);
		crane_body RotateYaw(-113,15);
		crane_box_control RotateYaw(-113,15);
		crane_arm waittill("rotatedone");
		wait(5);
		
		// lower invisible box
		crane_box_control moveto( crane_box_control.origin + (0, 0, -222), 1 );
		crane_box_control waittill("movedone");
		wait(3);
		crane_box Show();
		wait(5);
	}
}

play_snowcat_audio()
{
    sound_ent1 = Spawn( "script_origin", self.origin );
    sound_ent2 = Spawn( "script_origin", self.origin );
    sound_ent1 LinkTo( self, "tag_tail_light_right" );
    sound_ent2 LinkTo( self, "tag_bed_troops" );
    
    self waittill( "start_movement_audio" );
    
    sound_ent1 PlayLoopSound( "veh_snowcat_special_move_rear", 2 );
    sound_ent2 PlayLoopSound( "veh_snowcat_special_move_tracks", 2 );
    
    level waittill( "reznov_cutscene_snow_to_fade" );
    
    sound_ent1 StopLoopSound( 1.8 );
    sound_ent2 StopLoopSound( 1.8 );
    
    wait(2);
    
    sound_ent1 Delete();
    sound_ent2 Delete();
}

transition_smoother()
{
	sound_ent_smoov = spawn( "script_origin" , (0,0,0));
	realwait( 3 );	
	sound_ent_smoov playloopsound ("evt_transition_snow", 2);	
	realwait( 3 );
	sound_ent_smoov stoploopsound( 4 );			
	realwait (10);
	sound_ent_smoov delete();			
}
