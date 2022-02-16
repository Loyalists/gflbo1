 /*
	Rebirth: Mason Stealth Event - 
		
	The start of the level; this event starts with the player in a shipping crate with Reznov.  The player 
	sneaks through the docks on the island and climbs up towards the lab.  This event ends when the player 
	starts the sequence in the elevator.  

*/

#include maps\_utility;
#include common_scripts\utility; 
#include maps\_vehicle;
#include maps\rebirth_anim;
#include maps\rebirth_utility;
#include maps\_anim;
#include maps\_music;



/*------------------------------------------------------------------------------------------------------------
																								Event:  Mason Stealth
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Main event thread.  Controls the flow of the event.  
// Waits for the proper flag to be set to move on.
event_mason_stealth() 
{	
	flag_wait( "all_players_connected" );
	level thread play_intro_vo();
	
	flag_wait( "starting final intro screen fadeout" ); 
	
	exploder( 10 );	// start the fog over the water
	exploder( 15 ); // start the fog on top of the lab  
	
	level thread maps\rebirth_portals::rb_portals_level_start();
	
	// Update bilboard
	level thread mason_stealth_objectives();
	level thread mason_stealth_checkpoints();
	level thread mason_stealth_fog();
	level thread mason_stealth_water();
	
	if( !IsDefined( level.scan_tuning_funcs ) )
	{
		level.scan_tuning_funcs = [];
	}
	
	// Script tuning funcs to speed iteration
	level.scan_tuning_funcs[ "crate_check" ] = ::crate_check_tuning;
	level.scan_tuning_funcs[ "do_1st_pass" ] = ::do_1st_pass_tuning;
	level.scan_tuning_funcs[ "do_3rd_pass"]	 = ::do_3rd_pass_tuning;
	
	get_players()[0].animname = "mason";
	
	// Init the hatchet (viewarm weapon, throwable, and contextual melee)
	level thread melee_hatchet_init();
	
	level.seagull_ang_offset = ( 0, 0, 0 );
	
	// Ambient vignettes
	level thread rb_init_ambient_vignettes();
	level thread seagull_init();
	
	// Stealth Functions
	level thread dock_stealth_trigger_check();
	level thread dock_stealth_listener();
	level thread patrol_manager();
	level thread dock_stealth_ensurance();
	
	// Event Functions
	level thread ambient_crates();
	level thread ambient_radio_noise();
	level thread ladder_blocker();
	level thread crate_start_event();
	level thread crate_kill_event();
	level thread first_heli_hide_event();
	level thread hatchet_kill_event();
	level thread third_heli_hide_event();
	level thread lab_approach_event();
	level thread distant_explosion_event();
	level thread elevator_event();
	
	// Helicopter Functions
	level thread stealth_heli_setup();
	
	//////////////////
	// Tuning values
	//////////////////
	
	//Timescaling 
	
	// ************IMPORTANT***************
	// If you change hatchet_throw_scale, you MUST change the fire timer in grenades.gdt for hatchet_rebirth_sp
	// to 0.55 / level.hatchet_throw_scale
	level.hatchet_throw_scale = 0.4;
	// </IMPORTANT>
	level.pull_down_scale = 0.5;
	
	flag_wait( "event_mason_stealth_done" );
}

/*
=============================================
                 VIGNETTES
=============================================
*/

play_intro_vo()
{
	//TUEY Set Music state to INTRO
	setmusicstate("INTRO");
	
	wait( 8 );
	
	playsoundatposition( "evt_num_num_13_d" , (0,0,0) );
	
	player = get_players()[0];
	vo_ent = Spawn( "script_model", player.origin );
	vo_ent SetModel( "tag_origin" );
	vo_ent.animname = "mason_vo_ent";
	vo_ent anim_single( vo_ent, "intro_vo" );
	vo_ent Delete();
}

/////////////////////////
// UTILITY
/////////////////////////
move_to_player( endon_signal )
{
	self endon( endon_signal );
	player = get_players()[0];
	
	while( true )
	{
		self.origin = player.origin;
		self.angles = player.angles;
		
		wait( 0.05 );
	}
}



/////////////////////////
// AMBIENT
/////////////////////////
rb_cleanup_all_ambient_vignettes()
{
	if( !IsDefined( level.rb_vignette_structs ) )
	{
		return;
	}
	
	for( i = 0; i < level.rb_vignette_structs.size; i++ )
	{
		level.rb_vignette_structs[i] notify( "cleanup_vignette" );
	}
	
	level.rb_vignette_structs = undefined;
}

rb_ambient_vignette_death_watcher()
{
	self endon( "death" );
	self endon( "cleanup_vignette" );
	
	while( true )
	{
		if( !IsDefined( self.vig_ai ) )
		{
			self notify( "cleanup_vignette" );
			return;
		}
		
		some_alive = false;
		for( i = 0; i < self.vig_ai.size; i++ )
		{
			if( IsAlive( self.vig_ai[i] ) )
			{
				some_alive = true;
			}
		}
		if( !some_alive )
		{
			self notify( "cleanup_vignette" );
			return;
		}
		
		wait( 0.05 );
	}
}

rb_cleanup_ambient_vignette()
{
	self endon( "death" );
	
	self thread rb_ambient_vignette_death_watcher();
	
	self waittill( "cleanup_vignette" );
	if( IsDefined( self.vig_ai ) )
	{
		for( i = 0; i < self.vig_ai.size; i++ )
		{
			if( IsDefined( self.vig_ai[i] ) && IsAlive( self.vig_ai[i] ) )
			{
				self.vig_ai[i] Delete();
			}
		}
	}
}

rb_delete_after_scene()
{
	self endon( "death" );
	
	self waittillmatch( "single anim", "end" );
	
	self Delete();
}

rb_do_ambient_vignette()
{
	scene_name = self.script_string+"_";
	vig_spawners = GetEntArray( self.target, "targetname" );
	self.vig_ai = simple_spawn( vig_spawners );
	
	if( !IsDefined( level.rb_vignette_structs ) )
	{
		level.rb_vignette_structs = [];
	}
	level.rb_vignette_structs = array_add( level.rb_vignette_structs, self );
	
	self thread rb_cleanup_ambient_vignette();
	
	for( i = 0; i < self.vig_ai.size; i++ )
	{
		self.vig_ai[i].animname = "ambient_worker";
		if( IsDefined( level.scr_anim["ambient_worker"][scene_name+(i+1)].size ) )
		{
			self thread anim_loop_aligned( self.vig_ai[i], scene_name+(i+1) );
		}
		else
		{
			self thread anim_single_aligned( self.vig_ai[i], scene_name+(i+1) );
			self.vig_ai[i] thread rb_delete_after_scene();
		}
	}
}

rb_ambient_trigger_listener()
{
	level endon( "event_mason_stealth_done" );
	
	self waittill( "trigger" );
	
	vig_struct = getstruct( self.target, "targetname" );
	
	vig_struct notify( "cleanup_vignette" );
}


rb_init_ambient_vignettes()
{
	vig_structs = getstructarray( "vignette_sync", "script_noteworthy" );
	for( i = 0; i < vig_structs.size; i++ )
	{
		vig_structs[i] thread rb_do_ambient_vignette();
	}
	
	vig_triggers = GetEntArray( "vignette_trigger", "script_noteworthy" );
	for( i = 0; i < vig_triggers.size; i++ )
	{
		vig_triggers[i] thread rb_ambient_trigger_listener();
	}
}

patrol_manager()
{
	level endon( "player_stealth_fail" );
	level endon( "event_mason_stealth_done" );
	
	second_read_trigger = GetEnt( "second_read_trigger", "targetname" );
	third_read_trigger = GetEnt( "third_read_trigger", "targetname" );
	
	second_read_trigger waittill( "trigger" );
	
	first_patrol_array = get_ai_array( "dock_patrol_read_1_ai", "targetname" );
	for( i = 0; i < first_patrol_array.size; i++ )
	{
		first_patrol_array[i] thread delete_when_noone_looking();
	}
	
	level thread rb_cleanup_all_ambient_vignettes();
	
	vig_structs = getstructarray( "vignette_sync_2", "script_noteworthy" );
	for( i = 0; i < vig_structs.size; i++ )
	{
		vig_structs[i] thread rb_do_ambient_vignette();
	}
	
	flag_wait( "hatchet_kill_success" );
	
	third_read_trigger notify( "trigger" );
}

ambient_crates()
{
	level thread drop_crate_before_heli();
	level thread drop_cover_crate();
	level thread drop_crate_before_alley();
}

ambient_radio_noise()
{
	level endon( "player_stealth_fail" );

	player = get_players()[0];

	radio_distance_min 	= 100;
	radio_distance_max 	= 2000;
	radio_delay_min 		= 5;
	radio_delay_max			= 10;

	flag_wait( "start_crate_stopped" );
	
	while( true )
	{
		wait( RandomFloatRange( radio_delay_min, radio_delay_max ) );
		
		sound_played = false;
		
		patrollers = GetEntArray( "dock_patroller", "script_noteworthy" );
		workers = GetEntArray( "dock_workers", "script_noteworthy" );
		guys = array_combine( patrollers, workers );
		guys = array_randomize( guys );
		
		for( i = 0; i < guys.size && !sound_played; i++ )
		{
			dist = DistanceSquared( guys[i].origin, player.origin );
			if( dist >= (radio_distance_min * radio_distance_min) && dist <= (radio_distance_max * radio_distance_max) )
			{
				playsoundatposition( "vox_russian_radio", guys[i].origin ); 
				sound_played = true;
				// actual_dist = Distance( guys[i].origin, player.origin );
				// IPrintLn( "Radio: " + actual_dist );
			}
		}	
	}
}

ladder_blocker()
{
	blocker = GetEnt( "pulldown_player_clip", "targetname" );
	blocker.origin += (0, 0, 512);
	
	flag_wait( "pull_down_success" );
	blocker.origin -= (0, 0, 512);
}

crate_drop_kill_trigger_think()
{
	level endon( "crate_kill_trig_stop" );
	
	level notify( "crate_kill_trig_started" );
	level endon( "crate_kill_trig_started" );
	
	kill_trig = GetEnt( "crate_drop_kill_trig", "targetname" );
	
	while( true )
	{
		kill_trig.origin = self GetTagOrigin( "container_jnt" );
		kill_trig.angles = self GetTagAngles( "container_jnt" );
		wait( .05 );
	}
}

dock_stealth_ensurance()
{
	level waittill( "player_stealth_fail" );
	
	trigger_wait( "stealth_broken_check" );
	
	missionfailedwrapper( &"REBIRTH_STEALTH_FAIL" );
}

/////////////////////////
// CRATE_DROP
/////////////////////////
crate_investigate_reznov( start_crate )
{	
	start_crate thread anim_single_aligned( self, "reznov_crate_intro" );
	
	wait( 0.05 );
	

	clientnotify( "crane_moves" );

	self DisableClientLinkTo();
	self LinkTo( start_crate );
	
	self waittillmatch( "single anim", "end" );
	
	start_crate thread anim_loop_aligned( self, "reznov_crate_idle" );
	
	flag_wait( "crate_dialogue_done" );
	
	//TUEY Set Music state to STEALTH_PART_ONE
	setmusicstate("STEALTH_PART_ONE");
	
	// wait( 2 );
	//self anim_single( self, "crate_kill" );
	
	// self LookAtEntity(get_players()[0]);
	
	start_crate anim_single_aligned( self, "reznov_kill_him" );
	start_crate thread anim_loop_aligned( self, "reznov_crate_idle" );
	
	self.crate_align = start_crate;
}

crate_investigate_worker( anim_node )
{
	level waittill( "start_worker_crate_investigate" );
	
	anim_node thread anim_single_aligned( self, "crate_investigate" );
	
	//flag_wait( "crate_dialogue_done" );
	
	if( self.animname != "crate_kill_worker" )
	{
		animtime = GetAnimLength( level.scr_anim[self.animname]["crate_investigate"] );
		wait( animtime );
		
		self Delete();
	}
	else
	{
		animtime = GetAnimLength( level.scr_anim[self.animname]["crate_investigate"] );
		wait( animtime - 5 );		
		
		flag_set( "crate_dialogue_done" );
		
		self waittillmatch( "single anim", "end" );
		anim_node anim_loop_aligned( self, "container_worker_idle" );
	}
}

#using_animtree( "rebirth" );
crate_investigate_crate()
{
	self.animname = "crate";
	self UseAnimTree( #animtree );
	
	flag_wait( "start_crate_stopped" );
	
	self anim_single( self, "outer_open" );
	self thread anim_loop( self, "outer_open_loop" );
	
	level waittill( "open_crate_door" );
	
	player=get_players()[0];
	playsoundatposition("evt_crate_open" , player.origin);
	
	self anim_single( self, "inner_open" );
	self thread anim_loop( self, "inner_open_loop" );
}

#using_animtree( "player" );
crate_investigate_player( anim_node )
{
	player_body = spawn_anim_model( "player_body", self.origin );
	player_body thread move_to_player( "open_door" );
	player_body Hide();
	player_body SetAnim( %ch_rebirth_b01_open_container_player, 1, 0, 0 );
	
	level waittill( "open_crate_door" );
	
	player_body notify( "open_door" );
	
	self DisableWeapons();
	self HideViewModel();	
	
	
	
	anim_node thread maps\_anim::anim_first_frame(player_body, "open_crate");
	wait(0.05);
	self StartCameraTween(0.1);
	self PlayerLinkToAbsolute(player_body, "tag_player");
	wait(0.2);
	anim_node thread anim_single_aligned( player_body, "open_crate" );
	wait( 0.05 );
	player_body Show();
	
	player_body waittillmatch( "single anim", "end" );
	
	self Unlink();
	player_body Delete();
	
	self EnableWeapons();
	self ShowViewModel();
	
	wait( .5 );
	reznov = level.heroes[ "reznov" ];
	reznov thread anim_single( reznov, "take_hatchet" );
}

do_flashlight_stuff( owner )
{
	flag_wait( "start_crate_stopped" );
	wait( 2 );
	
	PlayFXOnTag( level._effect["flashlight_beam"], self, "TAG_ANIM_FLASHLIGHT" );
	
	owner waittillmatch( "single anim", "end" );
	self Unlink();
	self Delete();
}

//#using_animtree( "generic_human" );
//crate_investigate_dialogue( reznov, hatchet_worker, other_worker )
//{
//	// Reznov talks about Rebirth Island while the workers get the crate in place
//	wait( 4 );
//	 hatchet_worker thread anim_single( hatchet_worker, "crate_drop_1" );
//	wait( 3);
//	 hatchet_worker thread anim_single( hatchet_worker, "crate_drop_2" );
//	
//	flag_wait( "start_crate_stopped" );
//	hatchet_worker thread anim_single( hatchet_worker, "crate_drop_3" );
//	
//	wait( 2 );
//	
//	// Workers investigate the crate
//	hatchet_worker thread anim_single( hatchet_worker, "crate_investigate_1" );
//	wait( 5 );
//	other_worker thread anim_single( other_worker, "crate_investigate_2" );
//	wait( 5 );
//	hatchet_worker thread anim_single( hatchet_worker, "crate_investigate_3" );
//	wait( 3 );
//	other_worker thread anim_single( other_worker, "crate_investigate_4" );
//	wait( 3 );
//}

draw_tag_angles( tagname )
{
/#
	while( 1 )
	{
		forward = AnglesToForward( self GetTagAngles( tagname ) );
		pos2 = self GetTagOrigin( tagname ) + vector_scale( forward, 48 );
		line( self GetTagOrigin( tagname ), pos2 );
		wait( 0.05 );
	}
#/
}

crate_investigate_vignette()
{
	crate = GetEnt( "mason_start_crate", "targetname" );
	crate_animate = Spawn( "script_model", crate.origin );
	crate_animate.angles = crate.angles;
	crate_animate LinkTo( crate );
	inner_crate_door = GetEnt( "mason_start_crate_inner_door", "targetname" );
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	hatchet_worker = level.intro_workers[0];
	other_worker = level.intro_workers[1];
	flashlight = Spawn( "script_model", hatchet_worker GetTagOrigin( "tag_weapon_right" ) );
	flashlight.angles = hatchet_worker GetTagAngles( "tag_weapon_right" );
	flashlight SetModel( "t5_weapon_viewmodel_flashlight" );
	flashlight LinkTo( hatchet_worker, "tag_weapon_right" );	
	flashlight thread do_flashlight_stuff( hatchet_worker );

	anim_node = getstruct( "anim_sync_dock_crate_1", "targetname" );
	open_trigger = GetEnt( "open_crate_trigger", "targetname" );
	
	// relax_ik_headtracking_limits();
	
	// Animator will turn on head-tracking manually for this animation on note tracks.
	
	//reznov thread draw_tag_angles("tag_origin");
	reznov thread crate_investigate_reznov( crate_animate );
	player thread crate_investigate_player( anim_node );
	hatchet_worker thread crate_investigate_worker( anim_node );
	other_worker thread crate_investigate_worker( anim_node );
	crate thread crate_investigate_crate();
	
	ang = getstruct( "intro_worker_struct", "targetname" ).angles;
	
	// level thread crate_investigate_dialogue( reznov, hatchet_worker, other_worker );
	
	// Wait until the crate is in place, and play corresponding worker dialogue
	flag_wait( "start_crate_stopped" );
	
	// open the door
	wait( 2 );
	
	flag_wait( "crate_dialogue_done" );
	
	// Wait for a moment, then have Reznov instruct the player to kill the remaining worker
	// wait( 1 );
	open_trigger trigger_on();//= spawn( "trigger_radius", inner_crate_door.origin, 0, 32, 60 );
	open_trigger SetHintString( &"REBIRTH_OPEN_CRATE" );
	//open_trigger SetCursorHint( "HINT_ACTIVATE" );
	open_trigger UseTriggerRequireLookAt();
	
	obj_struct = getstruct( "crate_exit_struct", "targetname" );
	Objective_Position( level.obj_iterator, obj_struct.origin + (0, 0, 16) );
	Objective_Set3d( level.obj_iterator, true );
	
	open_trigger waittill( "trigger" );
	
	level notify( "open_crate_door" );
	
	// restore_ik_headtracking_limits();
	// reznov LookAtEntity();
	
	open_trigger Delete();
	inner_crate_door Delete();
	
	flag_set( "crate_investigate_done" );
}

///////////////////////////////////
// FIRST_COVER
///////////////////////////////////
first_cover_reznov( anim_node, anim_node2 )
{
	flag_wait( "crate_kill_success" );
	
	self Unlink();
	
	self.crate_align Delete();
	
	anim_node thread anim_single_aligned( self, "reznov_exit_container" );
	wait( 4 );	
	self thread anim_single( self, "first_run_1" );
	wait( 2 );
	self thread anim_single( self, "first_run_2" );

	self waittillmatch( "single anim", "end" );

	//anim_node anim_reach_aligned( self, "reznov_idle_post_container" );
	anim_node thread anim_loop_aligned( self, "reznov_idle_post_container" );
	
	wait( 3 );
	flag_set( "crane_start" );
	
	//SOUND - Shawn J
	clientnotify ("container_a_moves");
	
	self thread anim_single( self, "first_cover_1" );
	
	anim_node2 anim_single_aligned( self, "reznov_moveto_first_cover" );
	level notify( "reznov_reached_first_cover" );
	anim_node2 thread anim_loop_aligned( self, "reznov_idle_first_cover" );
	
	hide_trig = GetEnt( "first_run_hiding_place", "script_noteworthy" );
	hide_trig waittill( "trigger" );	
	
	// self thread anim_single( self, "first_cover_2" ); 
}

first_cover_vignette()
{	
	self endon( "player_stealth_fail" );
	
	player = get_players()[0];
	reznov = level.heroes["reznov"];
	anim_node = getstruct( "anim_sync_dock_crate_1", "targetname" );
	anim_node2 = getstruct( "anim_sync_heli_cover_1", "targetname" );
	
	reznov thread first_cover_reznov( anim_node, anim_node2 );
	
	flag_wait( "crate_kill_success" );
	
	//-- Glocke: Re-enable the player's melee ability now that he has a weapon
	player AllowMelee(true);
	player TakeAllWeapons();
	player GiveWeapon( "rebirth_hatchet_sp", 0 );	
	player SwitchToWeapon( "rebirth_hatchet_sp" );
	
	level waittill( "reznov_reached_first_cover" );
	
	flag_set( "first_cover_done" );
}

////////////////////////////////
// SECOND_COVER
///////////////////////////////
watch_for_patrol_stealth_fail()
{
	level endon( "patrol_clear" );
	
	fail_trigger = GetEnt( "stealth_fail_infantry", "targetname" );
	
	fail_trigger waittill( "trigger" );
	
	level notify( "player_stealth_fail" );
}

second_cover_patrol()
{
	level endon( "player_stealth_fail" );
	
	// wait(2);
	
	spawn_trigger = GetEnt( "spawn_patrol", "targetname" );
	clear_trigger = GetEnt( "patrol_clear", "targetname" );
	
	old_patrol = GetEntArray( "truck_ai_ai", "targetname" );
	for( i = 0; i < old_patrol.size; i++ )
	{
		old_patrol[i] Delete();
	}
	
	// spawn_trigger notify( "trigger" );
	patrol_spawners = GetEntArray( spawn_trigger.target, "targetname" );
	for(i = 0; i < patrol_spawners.size; i++ )
	{
		patrol_spawners[i] StalingradSpawn();
		wait( RandomFloatRange( .2, .3 ) );
	}
	
	level thread watch_for_patrol_stealth_fail();
	level thread watch_for_player_backtrack_after_crate();
	
	while( true )
	{
		clear_trigger waittill( "trigger", trig_ent );
		if( IsDefined( trig_ent.script_string ) && trig_ent.script_string == "last_guy" )
		{
			flag_set( "patrol_clear" );
		}
	}
}



watch_for_player_backtrack_after_crate()
{
	level endon( "event_mason_stealth_done" );
	level endon( "player_stealth_fail" );
	
	player = get_players()[0];
	last_guy = undefined;
	patrol_array = GetEntArray( "infantry_patrol_ai", "targetname" );
	
	for( i = 0; i < patrol_array.size; i++ )
	{
		if( patrol_array[i].script_string == "crate_guy" )
		{
			last_guy = patrol_array[i];
			break;
		}
	}
	
	Assert( IsDefined( last_guy ) );
	
	backtrack_trig = GetEnt( "stealth_fail_backtrack", "targetname" );
	
	while( true )
	{
		backtrack_trig waittill( "trigger", trig_ent );
		if( IsDefined( trig_ent.script_string ) && trig_ent.script_string == "crate_guy" )
		{
			break;
		}
		wait( 0.05 );
	}
	
	while( true )
	{
		if( player IsTouching( backtrack_trig ) )
		{
			level notify( "player_stealth_fail" );
			return;
		}
		wait(.1);
	}
}



watch_for_player_backtrack()
{
	level endon( "event_mason_stealth_done" );
	
	player = get_players()[0];
	last_guy = undefined;
	patrol_array = GetEntArray( "infantry_patrol_ai", "targetname" );
	
	for( i = 0; i < patrol_array.size; i++ )
	{
		if( patrol_array[i].script_string == "last_guy" )
		{
			last_guy = patrol_array[i];
			break;
		}
	}
	
	Assert( IsDefined( last_guy ) );
	
	backtrack_trigs = [];
	close_trigger = GetEnt( "stealth_fail_infantry", "targetname" );
	backtrack_trigs = array_add( backtrack_trigs, GetEnt( "alley_backtrack", "targetname" ) );
	backtrack_trigs = array_add( backtrack_trigs, GetEnt( "stealth_fail_backtrack", "targetname" ) );
	backtrack_trigs = array_add( backtrack_trigs, close_trigger );
	
	close_patrol_trig = GetEnt( "patrol_turn", "targetname" );
	patrol_trig = GetEnt( "patrol_return", "targetname" );
	
	while( true )
	{
		close_patrol_trig waittill( "trigger", trig_ent );
		if( IsDefined( trig_ent.script_string ) && trig_ent.script_string == "last_guy" )
		{
			break;
		}
		wait( 0.05 );
	}
	
	while( true )
	{
		if( player IsTouching( close_trigger ) )
		{
			level notify( "player_stealth_fail" );
			return;
		}
		if( last_guy IsTouching( patrol_trig ) )
		{
			break;
		}
		
		wait( 0.05 );
	}
	
	while( true )
	{
		for( i = 0; i < backtrack_trigs.size; i++ )
		{
			if( player IsTouching( backtrack_trigs[i] ) )
			{
				level notify( "player_stealth_fail" );
				return;
			}
		}
		wait( 0.05 );
	}
}

second_cover_reznov( anim_node, anim_node2 )
{
	level endon( "player_stealth_fail" );
	
	flag_wait( "crate_drop_done" );
	
	self waittillmatch( "looping anim", "end" );
	
	// self thread anim_single( self, "second_run" ); //"Go - Quickly.";
	anim_node thread anim_single_aligned( self, "reznov_moveto_crate_pause" );
	// Assert( AnimHasNotetrack( level.scr_anim[ "reznov" ][ "reznov_moveto_crate_pause" ], "start_patrol" ) );
	// self waittillmatch( "single anim", "start_patrol" );
	self thread second_cover_patrol();
	self waittillmatch( "single anim", "end" );
	anim_node thread anim_loop_aligned( self, "reznov_crate_pause" );
	
	flag_wait( "patrol_clear" );
	
	level thread watch_for_player_backtrack();
	
	anim_node2 anim_single_aligned( self, "reznov_moveto_second_cover" );
	anim_node2 thread anim_loop_aligned( self, "reznov_idle_second_cover" );
	
	level notify( "reznov_arrived_second_cover" );
}

do_loudspeaker_dialog_second_cover( player, reznov, loudspeaker )
{
	level endon( "player_stealth_fail" );
	
	//SOUND - changed by Shawn J (moved PA calls to rebirth_amb.csc)
	flag_wait( "second_crate_drop_done" );
	clientNotify("start_dock_pa");
	//player thread anim_single( loudspeaker, "second_cover_1" );
	//player thread anim_single( loudspeaker, "second_cover_2" );
	//player thread anim_single( loudspeaker, "second_cover_3" );
	flag_wait( "patrol_clear" );
	// reznov thread anim_single( reznov, "second_cover_4" );
	wait( 4 );
	player thread anim_single( player, "second_cover_5" );
}

second_cover_vignette()
{
	level endon( "player_stealth_fail" );
	
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	loudspeaker = Spawn( "script_origin", player.origin );
	loudspeaker.animname = "loudspeaker";
	anim_node = getstruct( "anim_sync_dock_crate_2", "targetname" );
	anim_node2 = getstruct( "anim_sync_heli_cover_2", "targetname" );
	
	reznov thread second_cover_reznov( anim_node, anim_node2 );
	
	level thread do_loudspeaker_dialog_second_cover( player, reznov, loudspeaker );
	
	level waittill( "reznov_arrived_second_cover" );
	
	flag_set( "second_cover_done" );
	flag_set( "second_hatchet_kill_ready" );
	
	loudspeaker Delete();
}

///////////////////////////////////
// HATCHET_THROW
///////////////////////////////////

give_reznov_weapon()
{
	flag_wait( "hatchet_kill_success" );
	self gun_switchto( "ak74u_sp", "right" );
	self useweaponhidetags( "ak74u_sp" );
}

hatchet_throw_reznov( anim_node )
{
	self thread give_reznov_weapon();
	
	level waittill( "guard_done_talking" );
	
	anim_node anim_single_aligned( self, "motion_kill" );
	anim_node thread anim_loop_aligned( self, "reznov_idle_second_cover" );

	level waittill( "show_throw_prompt" );
	
	self anim_single( self, "hatchet_kill_4" );
}

far_guard_wait_for_throw()
{
	level endon( "speedup" );
	level waittill( "hatchet_thrown" );
	level notify( "speedup" );
}

far_guard_wait_for_end()
{
	level endon( "speedup" );
	self waittillmatch( "single anim", "end" );
	level notify( "speedup" );
}

resolve_hatchet_after_wait( wait_time )
{
	level endon( "hatchet_kill_resolve" );
	
	wait( wait_time );
	
	level notify( "hatchet_kill_resolve" );
}

hatchet_pickup_trigger( )
{
	player = get_players()[0];
	
	// pickup_trigger = Spawn( "trigger_radius", pos, 0, 64, 64 );
	// pickup_trigger SetCursorHint( "HINT_NOICON" );
	// pickup_trigger SetHintString( &"REBIRTH_RETRIEVE_HATCHET" );
	
//	while( !player IsTouching( pickup_trigger ) )
//	{
//		wait(.05);
//	}
	
	// player GiveWeapon( "hatchet_sp" );
	player GiveWeapon( "knife_sp" );
	if( !player HasWeapon( "ak74u_sp" ) )
	{
		player GiveWeapon( "ak74u_sp" );
	}
	player SwitchToWeapon( "ak74u_sp" );
	player GiveWeapon("frag_grenade_sp");
	player SetWeaponAmmoClip( "frag_grenade_sp", 0 );	
	player SetLowReady( true );
	
	// pickup_trigger waittill( "trigger" );
	
	// pickup_trigger Delete();
	
	// self Delete();
}

#using_animtree( "generic_human" );
hatchet_throw_far_guard( anim_node, hatchet )
{
//	flag_wait( "hatchet_kill_start" );
//	
//	self.a.nodeath = true;
//
//	self thread hatchet_throw_far_guard_prep_anims( anim_node );	
//	// anim_node thread anim_single_aligned( self, "hatchet_throw_prep" );
//	
//	level waittill( "start_slomo" );
//	
//	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ "hatchet_throw_prep" ], 1, 0, level.hatchet_throw_scale );
//
//	// self waittill( "prep_done" );
//	
//	self thread far_guard_wait_for_throw();
//	self thread far_guard_wait_for_end();
//
//	level waittill( "speedup" );
//				
//	self SetGoalPos( self.origin );
//
//	flag_set( "hatchet_kill_speedup" );
//	
//	// self thread anim_loop( self, "hatchet_resolve_wait" );
//	
//	level thread resolve_hatchet_after_wait( 1 );
//	
	level waittill( "hatchet_kill_resolve" );
	
	if( flag( "hatchet_kill_success" ) )
	{
		//Tuey set music state t
		setmusicstate("THROW_HATCHET_KILL");
//		self.deathanim = level.scr_anim[ self.animname ][ "dead_loop" ];
//		hatchet.origin = self GetTagOrigin( "tag_weapon_left" );
//		hatchet.angles = self GetTagAngles( "tag_weapon_left" );
//		hatchet LinkTo( self, "tag_weapon_left" );
//		if( is_mature() )
//		{
//			PlayFXOnTag( level._effect["hatchet_thrown_blood"], self, "J_spine4" );
//		}
//		self.allowdeath = 1;
//		self ClearAnim( %root, 0 );
//		self thread hatchet_throw_physics_objects();
//		anim_node anim_single_aligned( self, "hatchet_throw_death" );
			level thread hatchet_pickup_trigger(); //self.origin );
//		self.nodeathragdoll = true;
//		self.noragdoll = true;
//		self DoDamage( self.health+100, (0, 0, 1) );
	}
//	else
//	{
//		flag_set( "hatchet_kill_fail" );
//		self StopAnimScripted();
//		self SetGoalPos( self.origin );
//		self set_ignoreall( false );
//		
//		level notify( "player_stealth_fail" );
//		level notify( "hatchet_throw_fail" );
//	}
}

hatchet_throw_far_guard_prep_anims( anim_node )
{
//	fxaxis = Spawn( "script_model", self GetTagOrigin( "tag_weapon_left" ) );
//	fxaxis.angles = self GetTagAngles( "tag_weapon_left" );
//	fxaxis SetModel( "fx_axis_createfx" );
//	fxaxis LinkTo( self, "tag_weapon_left" );
	
	level endon( "hatchet_kill_success" );
	anim_node anim_single_aligned( self, "hatchet_throw_prep" );
	self notify( "prep_done" );
	self anim_loop( self, "hatchet_resolve_wait", "hatchet_kill_success" );
}

hatchet_throw_close_guard()
{
	self waittill("contextual_melee_start_anim");
	self.a.noragdoll = true;
	self.deathanim = level.scr_anim[ self.animname ][ "dead_loop" ];
	self waittillmatch( "contextual_melee_anim", "end" );
	self DoDamage( self.health+100, (0, 0, 1) );
}

hatchet_spin( time )
{
	local_time = 0;
	rotate_rate = 360;
	while( true )
	{
		wait( 0.05 );
		self.angles = (self.angles[0]+rotate_rate*0.05, self.angles[1], self.angles[2] );
		local_time = local_time + 0.05;
		if( local_time >= time )
		{
			break;
		}
	}
	
}

animate_hatchet_to_target( hatchet, hatchet_throw_guard, start_pos, start_ang )
{
	hatchet.origin = start_pos;
	hatchet.angles = start_ang;
	
	anim_time = 1 - hatchet_throw_guard GetAnimTime( level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_throw_prep" ] );
	time = anim_time * GetAnimLength( level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_throw_prep" ] );
	if( time < 0.2 )
	{
		time = 0.2;
	}
	
	target_point = hatchet_throw_guard GetTagOrigin( "tag_weapon_left" );
	
	hatchet thread hatchet_spin( time );
	hatchet moveto( target_point, time );
	
	hatchet waittill( "movedone" );
	
	level notify( "hatchet_kill_resolve" );
}

check_if_hatchet_will_hit( hatchet_throw_guard )
{
	level endon( "hatchet_throw_fail" );
	
//	viewpos = self GetEye();
//	// viewpos = self GetTagOrigin( "tag_camera" );  //self.origin + ( 0, 0, self GetPlayerViewHeight() );
//	aim_vec = 1000 * VectorNormalize( AnglesToForward( self GetTagAngles( "tag_camera" ) ) );
//	trace = BulletTrace( viewpos, viewpos+aim_vec, true, self, true, true );
	
	direction = self getPlayerAngles();
	direction_vec = anglesToForward( direction );
	eye = self getEye();
	
	trace = bullettrace( eye, eye + vector_scale( direction_vec , 1000 ), true, self, true, true );	
	
	if( IsDefined( trace["entity"] ) && trace["entity"] == hatchet_throw_guard )
	{
		return true;
	}
	else
	{
		return false;
	}
}

grenade_wait_for_stop()
{
	while( true )
	{
		old_origin = self.origin;
		wait( 0.05 );
		if( old_origin == self.origin )
		{
			level notify( "hatchet_resolve" );
			return;
		}
	}
}

listen_for_hatchet_fail( hatchet_throw_guard )
{
	level endon( "hatchet_kill_success" );
	
	level waittill( "hatchet_kill_fail" );
	
	self DoDamage( self.health+100, hatchet_throw_guard.origin, hatchet_throw_guard );
}

hatchet_throw_player( anim_node, hatchet_chop_guard, hatchet )
{
	level endon( "hatchet_throw_fail" );
	player = self;
	
	flag_wait( "hatchet_kill_start" );

	// Assert( AnimHasNotetrack( %int_contextual_melee_hatchet_to_throw, "start_slowmo" ) );
	// player.player_hands waittillmatch( "contextual_melee_anim", "start_slowmo" );
	
	// player.player_hands SetFlaggedAnimLimited( "contextual_melee_anim", %int_contextual_melee_hatchet_to_throw, 1, 0, level.hatchet_throw_scale );
	
	// player SetPlayerViewRateScale( level.hatchet_throw_scale * 100.0 );
	
	// level notify( "start_slomo" );
	
	player waittill( "contextual_melee_complete" );
	level notify( "hatchet_kill_resolve" );
	flag_set( "hatchet_kill_success" );
	
	player TakeAllWeapons();
	
//	wait( 0.05 );
//	
//	level notify( "show_throw_prompt" );
//	
//	player TakeAllWeapons();
//	player GiveWeapon( "hatchet_rebirth_sp" );
//	
//	player_link = Spawn( "script_model", player.origin );
//	player_link.angles = player.angles;
//	player_link SetModel( "tag_origin" );
//	player PlayerLinkToDelta( player_link, "tag_origin", 1, 30, 20, 20 );
//
//	player thread hatchet_throw_watch_no_throw( player_link );
//
//	player thread listen_for_hatchet_fail( hatchet_throw_guard );
//	player waittill( "grenade_fire", grenade );
//	
//	player TakeAllWeapons();
//	
//	level notify( "speedup" );
//	level notify( "hatchet_thrown" );
//	
//	player ResetPlayerViewRateScale();
//	will_hit = player check_if_hatchet_will_hit( hatchet_throw_guard );
//	
//	player PlaySound("wpn_hatchet_throw_plr");
//	
//	if( will_hit )
//	{
//		flag_set( "hatchet_kill_success" );
//		start_pos = grenade.origin;
//		start_ang = VectorToAngles( hatchet_throw_guard.origin - start_pos );
//		level thread animate_hatchet_to_target( hatchet, hatchet_throw_guard, start_pos, start_ang );
//		wait( 0.05 );
//		grenade Delete();
//		level waittill( "hatchet_kill_resolve" );
//		wait( 2 );
//		player Unlink();
//		player GiveWeapon( "knife_sp" );	// return the melee knife
//	}
//	else
//	{
//		player TakeAllWeapons();
//		player GiveWeapon( "rebirth_hands_sp", 0 );	
//		player SwitchToWeapon( "rebirth_hands_sp" );	
//		player Unlink();
//	
//		grenade thread grenade_wait_for_stop();
//		level waittill( "hatchet_kill_resolve" );
//		wait( 0.25 );
//		player DoDamage( player.health+100, hatchet_throw_guard.origin, hatchet_throw_guard );
//	}
}

hatchet_throw_watch_no_throw( player_link )
{
	level endon( "hatchet_thrown" );
	
	level waittill( "hatchet_throw_fail" );
	
	self Unlink();
	player_link Delete();
	self TakeAllWeapons();
	self ResetPlayerViewRateScale();
	self GiveWeapon( "rebirth_hatchet_sp", 0 );	
	self SwitchToWeapon( "rebirth_hatchet_sp" );
}

hatchet_throw_hud()
{
	level waittill( "show_throw_prompt" );
	
	screen_message_create( &"REBIRTH_HATCHET_THROW" );
	
  level waittill_either( "hatchet_thrown", "hatchet_kill_fail" );
	
	screen_message_delete();
}

hatchet_throw_dialogue( hatchet_hit_guard, reznov )
{
	level endon( "hatchet_kill_start" );
	
	flag_wait( "second_cover_done" );
	
	level thread hatchet_hit_dialog_killer( hatchet_hit_guard );
	hatchet_hit_guard thread anim_single( hatchet_hit_guard, "hatchet_kill_1" );
	wait( 2 );
	hatchet_hit_guard thread anim_single( hatchet_hit_guard, "hatchet_kill_2" );

	level notify( "guard_done_talking" );
}

hatchet_hit_dialog_killer( hatchet_hit_guard )
{
	level waittill( "hatchet_kill_start" );
	waittillframeend;
	hatchet_hit_guard StopSound( level.scr_sound[ hatchet_hit_guard.animname ][ "hatchet_kill_1" ] );
	hatchet_hit_guard StopSound( level.scr_sound[ hatchet_hit_guard.animname ][ "hatchet_kill_2" ] );
}

hatchet_throw_vignette()
{
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	hatchet_chop_guard = GetEnt( "dock_stealth_kill_ai", "targetname" );
	hatchet_chop_guard.animname = "hatchet_chop_guard";
	// hatchet_throw_guard = simple_spawn( "hatchet_throw_guard" )[0];
	// hatchet_throw_guard.animname = "hatchet_throw_guard";
	anim_node = getstruct( "anim_sync_heli_cover_2", "targetname" );
	anim_node2 = getstruct( "anim_sync_hatchet", "targetname" );
	hatchet = spawn_model( "t5_weapon_hatchet", player.origin, player.angles );
	
	// level thread hatchet_throw_hud();
	reznov thread hatchet_throw_reznov( anim_node );
	player thread hatchet_throw_player( anim_node, hatchet_chop_guard, hatchet );
	hatchet_chop_guard thread hatchet_throw_close_guard();
	level thread hatchet_throw_far_guard( anim_node2, hatchet );
	
	level thread hatchet_throw_dialogue( hatchet_chop_guard, reznov );
	
	flag_wait( "hatchet_kill_success" );
	
	flag_set( "hatchet_throw_done" );
	
	maps\_contextual_melee::contextual_melee_show_hintstring( true );
}

hatchet_throw_physics_objects()
{
	animtime = GetAnimLength( level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_throw_death" ] );
	wait( animtime - .75 );
	
	explosion_point = self GetTagOrigin( "tag_eye" );
	// PhysicsExplosionSphere( explosion_point, 45, 1, .01 );
	self RadiusDamage(explosion_point, 64, 50, 50, undefined, "MOD_EXPLOSIVE");
}

///////////////////////////////////
// THIRD_COVER
///////////////////////////////////
third_cover_vignette()
{
	self endon( "player_stealth_fail" );
	
	reznov = level.heroes["reznov"];
	anim_node = getstruct( "anim_after_hatchet", "targetname" );
	
	// reznov thread third_cover_reznov( anim_node );
	
	flag_wait( "hatchet_throw_done" );
	
	reznov StopAnimScripted();
	// trigger_use( "reznov_move_post_kill" );
	
	wait(1);
	reznov thread play_third_cover_vo();
	
	reznov thread anim_single( reznov, "third_run_1" );
	anim_node anim_single_aligned( reznov, "after_hatchet_run" );
	
	anim_node thread anim_loop_aligned( reznov, "after_hatchet_run_idle", undefined, "stop_run_idle" );
	
	hiding_trig = GetEnt( "third_run_hiding_place", "script_noteworthy" );
	hiding_trig waittill( "trigger" );	
	
	player = get_players()[0];
	if( !player IsTouching( hiding_trig ) )
	{
		reznov anim_single( reznov, "third_run_4" );
	}
	
	// hiding_trig waittill( "trigger" );
	reznov waittillmatch( "looping anim", "end" );
	
	while( !(player IsTouching( hiding_trig )) )
	{
		wait(.05);
	}
	anim_node notify( "stop_run_idle" );
	anim_node anim_single_aligned( reznov, "after_hatchet_run_idle_speak" );
	anim_node thread anim_loop_aligned( reznov, "after_hatchet_run_idle", undefined, "stop_run_idle" );
	
	flag_set( "third_cover_done" );
}

play_third_cover_vo()
{
	self endon( "player_stealth_fail" );
	
	// self anim_single( self, "third_run_2" );
	// self thread anim_single( self, "third_run_3" );
	
	wait(6);
	
	//TUEY set music to CHOPPER_HIDE
	setmusicstate("CHOPPER_HIDE");
}

///////////////////////////////////
// LAB_APPROACH
///////////////////////////////////
lab_approach_reznov( anim_node )
{
	level endon( "pull_down_start" );
	
	reznov = self;
	
	flag_wait( "third_pass_clear" );
	
	wait( 2 );
	
	reznov thread anim_single( reznov, "lab_approach_1" );
	wait( 1 );
	// reznov thread anim_single( reznov, "lab_approach_2" );
	
	//trigger_use( "move_after_pass_2" );
	
	//reznov waittill( "goal" );
	
	anim_node anim_reach_aligned( self, "reznov_ladder_arrive" );
	anim_node anim_single_aligned( self, "reznov_ladder_arrive" );
	
	anim_node thread anim_loop_aligned( self, "reznov_ladder_wait" );
	
	trigger_wait( "near_cliff" );
	
	anim_node anim_single_aligned( self, "reznov_point_up" );
	
	anim_node thread anim_loop_aligned( self, "reznov_ladder_wait" );
}

lab_approach_vignette()
{
	reznov = level.heroes["reznov"];
	anim_node = getstruct( "anim_sync_ladder_reznov", "targetname" );

	reznov thread lab_approach_reznov( anim_node );
	
	trigger_wait( "near_cliff" );	
	
	enemy = simple_spawn_single( "carter_climb_kill" );

	flag_set( "lab_approach_done" );
}

///////////////////////////////////
// PULL_DOWN
///////////////////////////////////
pull_down_reznov( anim_node, pull_down_guard )
{
	flag_wait( "pull_down_resolve" );
	
	if( flag( "pull_down_success" ) )
	{
		self StopAnimScripted();
		anim_node anim_single_aligned( self, "reznov_pulldown_respond" );
		
		wait( 2 );
		
		tele_targ = getstruct( "reznov_warpto_after_pulldown", "targetname" );
		tele_origin = Spawn( "script_model", self.origin );
		tele_origin SetModel( "tag_origin" );
		self StopAnimScripted();
		wait( 0.05 );
		self LinkTo( tele_origin, "tag_origin" );
		tele_origin.origin = tele_targ.origin;
		self notify( "killanimscript" );
		self ClearAnim( %root, 0 );
		self SetAnim( %casual_stand_idle, 1, 0, 1 );
	
		self thread anim_single( self, "pull_down_4" );
		wait(1);
		
		self Unlink();
		tele_origin Delete();		
		trigger_use( "after_pulldown_move_reznov" );
		wait( 1 );
		
		self anim_single( self, "distant_explosion_1" );
		
		// wait( 2 );
		
		self anim_single( self, "distant_explosion_2" );
	}
}


#using_animtree( "rebirth" );
move_shell_inside()
{
	self UseAnimTree( #animtree );
	self SetAnim( %o_contextual_melee_ladderpull_ks23, 1, 0 );
}

#using_animtree( "generic_human" );
pull_down_guard( anim_node )
{
	flag_wait( "pull_down_start" );
	
	//TUEY set music to CHOPPER_HIDE
	setmusicstate("PULL_GUY_LADDER");
	
	self gun_remove();
	
	shotgun = Spawn( "script_model", self GetTagOrigin( "tag_weapon_right" ) );
	shotgun.angles = self GetTagAngles( "tag_weapon_right" );
	shotgun SetModel( "t5_weapon_ks23_viewmodel" );
	shotgun thread move_shell_inside();
	shotgun LinkTo( self, "tag_weapon_right" );
	self.shotgun = shotgun;
	
	self.a.nodeath = true;
	
	anim_node thread anim_single_aligned( self, "guard_pulldown_prep" );
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ "guard_pulldown_prep" ], 1, 0, level.pull_down_scale );
	self waittillmatch( "single anim", "end" );
	
	flag_set( "pull_down_resolve" );
	
	if( flag( "pull_down_success" ) )
 	{
 		anim_node thread anim_single_aligned( self, "guard_pull_fall_death" );
 		wait(2);
 		exploder(120);
 	}
 	else
 	{
 		anim_node anim_single_aligned( self, "guard_pull_shoot_player" );
 	}
}

pull_down_failed_shot( guy )
{
	PlayFXOnTag( level._effect[ "ks23_muzzleflash" ], guy.shotgun, "tag_flash" );
	playsoundatposition ("wpn_ks23_fire_npc", guy.shotgun GetTagOrigin( "tag_flash" ) );
	
	player = get_players()[0];
	player DoDamage( (player.health / 2), player.origin );
}

pull_down_success_listener( pull_down_guard, anim_node )
{
	player = get_players()[0];
	
	pull_down_guard waittillmatch( "single anim", "show_prompt" );
	Assert( AnimHasNotetrack( level.scr_anim[ "pull_down_guard" ][ "guard_pulldown_prep" ], "show_prompt" ) );
	screen_message_create( &"REBIRTH_PULL_DOWN_GUARD" );
	
	while( true )
	{
		if( player MeleeButtonPressed() )
		{
			flag_set( "pull_down_success" );
			screen_message_delete();
			break;
		}
		
		wait( 0.05 );
	}
}

pull_down_player( anim_node, pull_down_guard )
{
	player_hands = spawn_anim_model( "player_hands", self.origin, self.angles );
	player_hands Hide();
	
	flag_wait( "pull_down_start" );
	
	self DisableWeapons();
	self HideViewModel();
	
	anim_node thread anim_loop_aligned( player_hands, "pull_down_idle" );
	
	self StartCameraTween( 0.2 );
	self PlayerLinkToAbsolute( player_hands, "tag_player" );
	
	level thread pull_down_success_listener( pull_down_guard, anim_node );
	
	flag_wait( "pull_down_resolve" );
	
	if( flag( "pull_down_success" ) )
	{
		player_hands Show();
		anim_node thread anim_single_aligned( player_hands, "pull_down_success" );
		Assert( AnimHasNotetrack( level.scr_anim[ "player_hands" ][ "pull_down_success" ], "attach_weapon" ) );
		player_hands waittillmatch( "single anim", "attach_weapon" );
		self.shotgun = pull_down_guard.shotgun;
		self.shotgun Unlink();
		self.shotgun.origin = player_hands GetTagOrigin( "tag_weapon" );
		self.shotgun.angles = player_hands GetTagAngles( "tag_weapon" );
		self.shotgun LinkTo( player_hands, "tag_weapon" );
		self GiveWeapon( "ks23_sp" );
		self SwitchToWeapon( "ks23_sp" );
		player_hands waittillmatch( "single anim", "end" );
		self Unlink();
		player_hands Delete();
		self.shotgun Delete();
		self EnableWeapons();
		self ShowViewModel();
		self SetLowReady( false );
	}
	else
	{
		player_hands Show();
		anim_node anim_single_aligned( player_hands, "pull_down_death" );
		missionfailedwrapper();
	}
}

pull_down_dialogue( radio_guard, pull_down_guard )
{
	level endon( "pull_down_start" );
	
	radio_guard thread anim_single( radio_guard, "pull_down_1" );
	wait( 2 );
	pull_down_guard thread anim_single( pull_down_guard, "pull_down_2" );
	wait( 2 );
	pull_down_guard thread anim_single( pull_down_guard, "pull_down_3" );
}

pull_down_vignette()
{
	flag_wait( "lab_approach_done" );
	
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	pull_down_guard = GetEnt( "carter_climb_kill_ai", "targetname" );
	pull_down_guard.animname = "pull_down_guard";
	pull_down_guard Detach(pull_down_guard.headModel);
	pull_down_guard Detach(pull_down_guard.gearModel);
	pull_down_guard character\gfl\character_gfl_saiga12::main();

	radio_guard = Spawn( "script_origin", pull_down_guard.origin );
	radio_guard.animname = "radio_guard";
	anim_node = getstruct( "anim_sync_ladder_pull", "targetname" );
	
	level thread pull_down_dialogue( radio_guard, pull_down_guard );
	
	reznov thread pull_down_reznov( anim_node, pull_down_guard );
	player thread pull_down_player( anim_node, pull_down_guard );
	pull_down_guard thread pull_down_guard( anim_node );
	
	pull_down_guard waittill( "death" );
	
	flag_set( "pull_down_done" );
	radio_guard Delete();
}

///////////////////////////////////
// DISTANT_EXPLOSION
///////////////////////////////////
watch_for_player_at_elevator()
{
	level endon( "elevator_slide_start" );
	
	trigger_wait( "at_elevator_shaft" );
	level.heroes["reznov"] thread anim_single( level.heroes["reznov"], "elevator_1" );
	
	flag_set( "player_at_elevator" );
}

distant_explosion_reznov( anim_node )
{
	level endon( "start_reznov_hatch_open" );
	
	flag_wait( "distant_explosion_triggered" );
	
	anim_struct = getstruct( "anim_struct_pipe_climb" );
	anim_struct anim_reach_aligned( self, "pipe_climb" );
	anim_struct thread anim_single_aligned( self, "pipe_climb" );
	
	level thread watch_for_player_at_elevator();
	
	self waittillmatch( "single anim", "end" );
	flag_wait( "player_at_elevator" );
	
	anim_struct = getstruct( "elevator_cable_slide_anim", "targetname" );
	anim_struct anim_reach_aligned( self, "cables_arrive" );
	anim_struct anim_single_aligned( self, "cables_arrive" );
	self.elevator_arrive = true;
	anim_struct anim_loop_aligned( self, "cables_idle" );
}

warp_reznov_rooftop()
{
	trigger_wait( "roof_trigger_1" );
	
	player = get_players()[0];
	reznov = level.heroes[ "reznov" ];
	
	while( reznov.origin[0] > 15655 )	// temp hax
	{
		player_forward = VectorNormalize( AnglesToForward( player.angles ) );
		rez_to_player = VectorNormalize( reznov.origin - player.origin );
		
		can_see_dot = VectorDot( player_forward, rez_to_player );
		if( can_see_dot < 0 )
		{	
			tele_targ = getstruct( "reznov_teleport", "targetname" );
			tele_origin = Spawn( "script_model", reznov.origin );
			tele_origin SetModel( "tag_origin" );
			reznov StopAnimScripted();
			wait( 0.05 );
			reznov LinkTo( tele_origin, "tag_origin" );
			tele_origin.origin = tele_targ.origin;
			reznov notify( "killanimscript" );
			reznov ClearAnim( %root, 0 );
			reznov SetAnim( %casual_stand_idle, 1, 0, 1 );
		
			wait( 0.05 );
			
			reznov Unlink();
			tele_origin Delete();
		}
		
		wait(.1);
	}
}

wait_for_roof_guard_death( roof_guard )
{
	roof_guard waittill_either( "pain", "death" );
	if( IsAlive( roof_guard ) )
	{
		roof_guard set_ignoreall( false );
	}
	
	flag_set( "roof_guard_died" );
}

distant_explosion_guard( anim_node )
{
	self endon( "death" );
	
	level thread wait_for_roof_guard_death( self );

	flag_wait( "distant_explosion_triggered" );
	
	self anim_single( self, "guard_explosion_response" );
	
	self thread notify_roof_guard_when_player_shoots( "roof_guard_died" );
	flag_wait( "roof_guard_died" );
	
	wait( 0.3 );
	self.goalradius = 512;
	self set_ignoreall( false );
}

//-- If the player shoots at all, notify the guards, they aren't that far anyways
notify_roof_guard_when_player_shoots( flag_to_set )
{
	level endon( flag_to_set );
	
	player = get_players()[0];
	player waittill_player_shoots();
	
	flag_set( flag_to_set );
}

distant_explosion_dialogue( player, reznov, loudspeaker )
{
	flag_wait( "distant_explosion_triggered" );
	level notify( "reznov_pipe_goto" );
	wait( 2 );
	//SOUND - changed by Shawn J (moved PA calls to rebirth_amb.csc)
	//player thread anim_single( loudspeaker, "distant_explosion_3" );
	clientNotify("start_dist_explo_pa");	
	reznov thread anim_single( reznov, "distant_explosion_4" );
	wait( 2 );
	player thread anim_single( player, "distant_explosion_5" );
	wait( 2 );
	reznov thread anim_single( reznov, "distant_explosion_6" );
	
	level notify( "dialogue_done" );
	
	// trigger_wait( "roof_opportunity_lookat_trigger" );
	// reznov thread anim_single( reznov, "distant_explosion_7" );
}

distant_explosion_helicopters()
{
	flag_wait( "distant_explosion_triggered" );
	wait( 2 );
	
	heli_lookat_trigger = GetEnt( "heli_lookat_trigger", "targetname" );
	heli_takeoff_trigger = GetEnt( "heli_takeoff_trigger", "targetname" );
	
	heli_lookat_trigger waittill( "trigger" );
	
	heli_takeoff_trigger notify( "trigger" );
	
	wait( 0.5 );
	
	heli_array = GetEntArray( "roof_heli", "targetname" );
	
	for( i = 0; i < heli_array.size; i++ )
	{
		heli_array[i] thread rb_heli_spotlight_enable();
	}
}

distant_explosion_vignette()
{
	level thread warp_reznov_rooftop();
	
	trigger_wait( "begin_roof_climb" );
	
	wait( 0.05 );
	
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	guard1 = get_ai( "explosion_guard_left", "script_noteworthy" );
	guard1.animname = "left_roof_guard";
	guard2 = get_ai( "explosion_guard_right", "script_noteworthy" );
	guard2.animname = "right_roof_guard";
	loudspeaker = Spawn( "script_origin", player.origin );
	loudspeaker.animname = "loudspeaker";
	hatch = GetEnt( "anim_elevator_hatch", "script_noteworthy" );
	hatch.animname = "hatch";
	hatch thread hatch_do_closed_loop();
	anim_node = getstruct( "elevator_cable_slide_anim", "targetname" );
	
	reznov thread distant_explosion_reznov( anim_node );
	guard1 thread distant_explosion_guard();
	guard2 thread distant_explosion_guard();
	level thread distant_explosion_helicopters();
	
	level thread distant_explosion_dialogue( player, reznov, loudspeaker );
	
	flag_wait( "distant_explosion_triggered" );
	
	level waittill( "dialogue_done" );
	
	flag_set( "distant_explosion_done" );
	
	loudspeaker Delete();
}

///////////////////////////////////
// ELEVATOR_SLIDE
///////////////////////////////////
elevator_slide_reznov_shortcircuit( anim_node, anim_node2 )
{
	level endon( "reznov_slide_started" );
	
	level waittill( "elevator_slide_started" );
	
	anim_node anim_single_aligned( self, "cable_slide" );
	anim_node2 anim_loop_aligned( self, "elevator_wait" );
}

elevator_slide_reznov( anim_node, anim_node2 )
{
	level endon( "elevator_slide_start" );
	level endon( "start_reznov_hatch_open" );
	
	self thread elevator_slide_reznov_idle(anim_node2);
	
	self thread elevator_slide_reznov_shortcircuit( anim_node, anim_node2 );
	
	reznov = self;
	
	while( true )
	{
		if( IsDefined( self.elevator_arrive ) && self.elevator_arrive )
		{
			break;
		}
		wait( 0.05 );
	}
	
	trigger_wait( "elevator_top" );
//	reznov thread anim_single( reznov, "elevator_3" );
	anim_node thread anim_single_aligned( reznov, "cable_slide" );
	level notify( "reznov_slide_started" );
 	reznov waittillmatch( "single anim", "end" );
	anim_node2 thread anim_loop_aligned( reznov, "elevator_wait" );
}

elevator_slide_reznov_idle(anim_node2)
{
	level waittill( "start_reznov_hatch_open" );
	anim_node = getstruct( "elevator_cab_anim", "targetname" );
	
	level.heroes[ "reznov" ] thread elevator_kill_reznov( anim_node );
}

elevator_slide_player( anim_node )
{
	loudspeaker = Spawn( "script_origin", self.origin );
	loudspeaker.animname = "loudspeaker";
	player_body = spawn_anim_model( "player_body", self.origin, self.angles );	
	player_body SetAnim( level.scr_anim["player_body"]["cable_slide"], 1, 0, 0 );
	player_body Hide();
	player_body thread move_to_player( "begin_slide" );
	self.player_body = player_body;
	
	//SOUND - changed by Shawn J (moved PA calls to rebirth_amb.csc)
	//self thread anim_single( loudspeaker, "elevator_2" );
		
	trigger_wait( "elevator_cable" );
	
	if( self GetStance() != "stand" )
	{
		while(self.divetoprone)
		{
			wait(0.2);
		}
	
		self FreezeControls(true);
		self SetStance( "stand" );
		wait(0.5);
		self FreezeControls(false);
	}	
	
	self FreezeControls(true);
	flag_set( "elevator_slide_start" );

	clientNotify("start_elevator_slide_pa");
			
	self DisableWeapons();
	wait( .5 );
	
	self FreezeControls(false);
	player_body notify( "begin_slide" );

	//SOUND - Shawn J
	clientnotify ( "bg_dock_notify" );
	clientnotify ( "outside_lab_alarms_off" );	
	//array_thread(GetEntArray("rebirth_helicopter", "script_noteworthy "), ::vehicle_toggle_sounds, 0);

	anim_node thread anim_single_aligned ( player_body, "cable_slide" );
	self StartCameraTween( 0.2 );
	self PlayerLinktoAbsolute( player_body, "tag_player");
	wait(0.2);
	player_body Show();
	
	len = GetAnimLength( level.scr_anim["player_body"]["cable_slide"] );
	
	wait( 6.8 ); // temp
	level notify( "start_reznov_hatch_open" );
	flag_set( "player_slide_done" );
	
	wait( len - 7 );
	
	self Unlink();
	player_body Delete();
	self EnableWeapons();	
	self GiveMaxAmmo( self GetCurrentWeapon() );
	
	loudspeaker Delete();
}

#using_animtree( "rebirth" );
hatch_do_closed_loop()
{
	self UseAnimTree( #animtree );
	self thread anim_loop( self, "closed_loop" );
}

hatch_do_open_loop()
{
	self UseAnimTree( #animtree );
	self thread anim_loop( self, "open_loop" );
}

#using_animtree( "generic_human" );
elevator_slide_vignette()
{
	flag_wait( "distant_explosion_triggered" );
	
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	anim_node = getstruct( "elevator_cable_slide_anim", "targetname" );
	anim_node2 = getstruct( "elevator_cab_anim", "targetname" );
	anim_node3 = getstruct( "anim_struct_elevator", "targetname" );
	
	reznov thread elevator_slide_reznov( anim_node, anim_node2 );
	player thread elevator_slide_player( anim_node3 );
	
	flag_wait( "player_slide_done" );
	
	flag_set( "elevator_slide_done" );
}

///////////////////////////////////
// ELEVATOR_KILL
///////////////////////////////////
#using_animtree( "rebirth" );
elevator_kill_hatch()
{
	hatch = self;
	hatch anim_single( hatch, "reznov_open" );
	hatch thread anim_loop( hatch, "shoot_wait" );
	
	level waittill( "hatch_jump" );
	
	//TUEY set music to CHOPPER_HIDE
	level thread maps\_audio::switch_music_wait("FIGHT_IN_BASE", 3);

	hatch anim_single( hatch, "reznov_jump" );
	hatch thread anim_loop( self, "open_loop" );
}



#using_animtree( "generic_human" );
elevator_kill_reznov( anim_node )
{
	level endon( "player_slid_first" );
	
	if( !flag( "elevator_kill_reznov_start" ) )
	{	
		flag_set( "elevator_kill_reznov_start" );
		self set_ignoreme( true );
		hatch = GetEnt( "anim_elevator_hatch", "script_noteworthy" );
		
		hatch thread elevator_kill_hatch();
		
		anim_node anim_single_aligned( self, "open_hatch_in" );
		anim_node thread anim_loop_aligned( self, "open_hatch_idle" );
		
		waittill_ai_group_cleared( "elevator_spetsnaz" );
		
		level notify( "hatch_jump" );
		
		anim_node thread anim_single_aligned( self, "open_hatch_out" );
		
		wait(2);
		
		block_brush = GetEnt( "elevator_hatch_blocker", "targetname" );
		block_brush Delete();	
		
		self waittillmatch( "single anim", "end" );
		
		trigger_use( "in_elevator" );
		self set_ignoreall( false );
		self set_ignoreme( false );
	}
}

elevator_kill_player( anim_node )
{
	player_body = self.player_body;
	
	// anim_node anim_single_aligned( player_body, "open_hatch_in" );
	
	// self PlayerLinkToDelta( player_body, "tag_origin", 1, 30, 30, 60, 70 );	
	
	waittill_ai_group_cleared( "elevator_spetsnaz" );
	
	// anim_node anim_single_aligned( player_body, "open_hatch_out" );
	
	// self Unlink();
	// player_body Delete();
}

elevator_kill_guard_response( anim_node )
{
	self endon( "death" );
	
	flag_wait( "elevator_vig_done" );
	anim_node anim_single_aligned( self, "elevator_react" );
	
	self StopAnimScripted();
	self set_ignoreall( false );
}

elevator_kill_guard( anim_node )
{
	self endon( "death" );
	
	self thread elevator_kill_guard_response( anim_node );
	anim_node anim_single_aligned( self, "elevator_idle" );
	
	flag_set( "elevator_vig_done" );
}

elevator_kill_scientist_response( anim_node )
{
	self endon( "death" );
	
	flag_wait( "elevator_vig_done" );
	// self thread 
	anim_node anim_single_aligned( self, "elevator_react" );
	
	self StopAnimScripted();
	goal_node = GetNode( "scientist_flee_node", "targetname" );
	
	self SetGoalNode( goal_node );
	
	self waittill_either( "goal", "hatch_jump" ); 
	
	self Delete();
}

elevator_kill_scientist( anim_node )
{
	self endon( "death" );
	
	self thread elevator_kill_scientist_response( anim_node );
	
	anim_node anim_single_aligned( self, "elevator_idle" );
	
	flag_set( "elevator_vig_done" );
}

player_fire_watcher()
{
	level endon( "elevator_vig_done" );
	
	while( true )
	{
		if( self IsFiring() )
		{
			flag_set( "elevator_vig_done" );
		}
		wait( 0.05 );
	}
}

elevator_dialogue( guard, scientist )
{
	level endon( "hatch_jump" );
	
	anim_node = getstruct( "elevator_cab_anim", "targetname" );
	reznov = level.heroes["reznov"];
	loudspeaker = Spawn( "script_origin", reznov.origin );
	loudspeaker.animname = "loudspeaker";
	
	wait( 8 );
	
	if( !flag( "elevator_vig_done" ) )
	{
		anim_node anim_single_aligned( reznov, "open_hatch_speak" );
		anim_node thread anim_loop_aligned( reznov, "open_hatch_idle" );
	}
	
	wait( 2 );
	
	//SOUND - changed by Shawn J (moved PA calls to rebirth_amb.csc)
	//reznov thread anim_single( loudspeaker, "elevator_10" );
	clientNotify("start_elevator_kill_pa");	
	wait( 2 );
	
	flag_set( "elevator_vig_done" );
}

elevator_kill_vignette()
{
	// trigger_wait( "elevator_roof" );
	flag_wait( "player_slide_done" );
	
	reznov = level.heroes["reznov"];
	player = get_players()[0];
	talk_guard = get_ai( "elevator_talk_guard", "script_noteworthy" );
	talk_guard.animname = "elevator_talk_guard";
	guard = get_ai( "elevator_guard", "script_noteworthy" );
	guard.animname = "elevator_guard";
	talk_scientist = get_ai( "elevator_talk_scientist", "script_noteworthy" );
	talk_scientist.animname = "elevator_talk_scientist";
	talk_scientist.team = "axis";
	scientist = get_ai( "elevator_scientist", "script_noteworthy" );
	scientist.animname = "elevator_scientist";
	scientist.team = "axis";
	anim_node = getstruct( "elevator_cab_anim", "targetname" );
	anim_node2 = getstruct( "anim_struct_elevator_bottom", "targetname" );
	hatch = GetEnt( "anim_elevator_hatch", "script_noteworthy" );
	// hatch thread hatch_do_open_loop();
	
	reznov thread elevator_kill_reznov( anim_node );
	player thread elevator_kill_player( anim_node2 );
	
	level thread elevator_dialogue( talk_guard, talk_scientist );
	player thread player_fire_watcher();
	
	talk_guard thread elevator_kill_guard( anim_node );
	guard thread elevator_kill_guard( anim_node );
	talk_scientist thread elevator_kill_scientist( anim_node );
	scientist thread elevator_kill_scientist( anim_node );
	
	flag_set( "elevator_kill_done" );
	flag_set( "event_mason_stealth_done" );
	
	level thread docks_clean_up();
}

//------------------------------------
// Link the player to the starting crate
crate_start_event()
{		
	start_crate = GetEnt( "mason_start_crate", "targetname" );
	inner_crate_door = GetEnt( "mason_start_crate_inner_door", "targetname" );
	open_trigger = GetEnt( "open_crate_trigger", "targetname" );
	open_trigger trigger_off();
	player 			= get_players()[0];
	player AllowJump( false );
	player AllowProne( false );
	allow_divetoprone( false );
	reznov = level.heroes["reznov"];
	reznov gun_remove();
	reznov set_ignoreme( true );
	reznov set_ignoreall( true );
	level.intro_workers = [];
	level.intro_workers[0] = simple_spawn( GetEnt( "intro_worker_garrote", "targetname" ) )[0]; 
	level.intro_workers[0] gun_remove();
	level.Intro_workers[0].team = "axis";
	level.intro_workers[1] = simple_spawn( GetEnt( "intro_worker", "targetname" ) )[0];
	level.intro_workers[1] gun_remove();
	level.Intro_workers[1].team = "axis";
	
	level.intro_workers[0].animname = "crate_kill_worker";
	level.intro_workers[1].animname = "worker";
	
	inner_crate_door LinkTo( start_crate );
	
	level thread drop_starting_crate();
	level thread crate_investigate_vignette();
	level thread monkeys_starting_crate();	
	
	flag_wait( "start_crate_stopped" ); // wait for the crate to reach the ground
	
	player AllowJump( true );
	player AllowProne( true );
	allow_divetoprone( true );
}

//------------------------------------
// Spawn and animate the monkeys in the starting crate
monkeys_starting_crate()
{
	start_crate 		= GetEnt( "mason_start_crate", "targetname" );
	monkey_structs 	= getstructarray( "struct_intro_monkey", "targetname" );
	monkeys		 			= [];

	wait(.1);

	for( i = 0; i < monkey_structs.size; i++)
	{
		anim_i = RandomIntRange( 1, 4 );
	
		monkeys[i] = Spawn( "script_model", monkey_structs[i].origin );
		monkeys[i].linker = Spawn( "script_model", monkey_structs[i].origin );
		monkeys[i].cage = Spawn( "script_model", monkey_structs[i].origin );
		monkeys[i].angles = monkey_structs[i].angles;
		monkeys[i].cage.angles = monkey_structs[i].angles + (0,0,45);
		monkeys[i] SetModel( "anim_monkey" );
		monkeys[i].linker SetModel( "tag_origin" );
		monkeys[i].cage SetModel( "p_rus_animal_cage_medium_01" );
		monkeys[i].animname = "monkey";
		monkeys[i] UseAnimTree( level.scr_animtree[ "monkey" ] );
		// monkeys[i] DisableClientLinkTo();
		monkeys[i].linker LinkTo( start_crate );
		monkeys[i] LinkTo( monkeys[i].linker );
		monkeys[i].cage LinkTo( monkeys[i].linker, "tag_origin", (0,0,18), (0, 120, 0) );
		
		monkeys[i] thread anim_loop( monkeys[i], "freaked_" + anim_i, "monkey_stop" );
		monkeys[i] SetAnimTime( level.scr_anim[ "monkey" ][ "freaked_" + anim_i][0], RandomFloat( 0.99 ) );
	}
	
	flag_wait( "hatchet_throw_done" );
	for( i = 0; i < monkeys.size; i++ )
	{
		monkeys[i] Delete();
	}
}



//------------------------------------
// Russian enters the shipping crate and is set up
// to be killed by Carter
crate_kill_stealth_listener( worker )
{
	level endon( "crate_kill_success" );
	
	crate_kill_stealth_trigger = GetEnt( "crate_kill_stealth_trigger", "script_noteworthy" );
	
	crate_kill_stealth_trigger waittill( "trigger" );
	
	level notify( "player_stealth_fail" );
	
	if(IsDefined(worker))
	{
		worker thread anim_single( worker, "crate_spotted_player");
	}
}

crate_kill_success_listener( worker )
{
	level endon( "player_stealth_fail" );
	
	player = get_players()[0];
	
	worker waittill( "melee_victim" );
	simple_spawn_single( "hatchet_kill_start_patroller" );	// spawn patroller 
	
	//TUEY Set Music state to STEALTH_PART_ONE
	setmusicstate("STEALTH_PART_TWO");
	
	worker.deathanim = level.scr_anim[ worker.animname ][ "dead_loop" ];
	
	flag_set( "crate_kill_success" );
	
	VisionSetNaked( "rebirth_docks", 1 );
	
	player waittill( "contextual_melee_complete" );
	worker DoDamage( worker.health+100, (0, 0, 1) );
	
	trigger_use( "spawn_first_kill_patroller" );
	flag_set( "crate_kill_done" );
}

crate_kill_event()
{
	flag_wait( "start_crate_stopped" );
	
	crate_kill_worker = GetEnt( "intro_worker_garrote_ai", "targetname" );
	crate_kill_worker.NoFriendlyfire = true;
	crate_kill_worker Detach(crate_kill_worker.headModel);
	crate_kill_worker Detach(crate_kill_worker.gearModel);
	crate_kill_worker character\gfl\character_gfl_p90::main();

	level thread crate_kill_success_listener( crate_kill_worker );
	level thread crate_kill_stealth_listener( crate_kill_worker );
	level thread first_cover_vignette();
	
	flag_wait( "crate_kill_done" );	
}

//------------------------------------
// Have reznov stop the player and wait for the 
// crate to be moved into place
first_heli_hide_event()
{
	level endon( "player_stealth_fail" );
	
	trigger_wait( "wait_for_crane" );

	level thread second_cover_vignette();
}

//------------------------------------
// Stealth kill between the buildings, spawn in 
// a russian patroller and do VO from Reznov
hatchet_kill_start_listener( hatchet_chop_guard )
{
	hatchet_chop_guard waittill( "melee_victim" );
	
	//TUEY sets music to throw hatchet
	setmusicstate("THROW_HATCHET");
	
	flag_set( "hatchet_kill_start" );
	

}

hatchet_kill_event()
{
	hatchet_guard_spawner = getent("dock_stealth_kill", "targetname");
	hatchet_guard_spawner add_spawn_function(::hatchet_guard_alerted);
	hatchet_guard_spawner Detach(hatchet_guard_spawner.headModel);
	hatchet_guard_spawner Detach(hatchet_guard_spawner.gearModel);
	hatchet_guard_spawner character\gfl\character_gfl_9a91::main();

	trigger_wait( "ready_stealth_kill" );
	flag_set( "second_hatchet_kill_ready" );
	
	maps\_contextual_melee::contextual_melee_show_hintstring( false );
	
	hatchet_chop_guard = GetEnt( "dock_stealth_kill_ai", "targetname" );
	hatchet_chop_guard Detach(hatchet_chop_guard.headModel);
	hatchet_chop_guard Detach(hatchet_chop_guard.gearModel);
	hatchet_chop_guard thread hatchet_kill_guard_anims();
	hatchet_chop_guard character\gfl\character_gfl_9a91::main();

	streamer_hint = createstreamerhint( hatchet_chop_guard.origin, 1.0 );
		
	level thread hatchet_kill_stealth_listener( hatchet_chop_guard );
	level thread hatchet_kill_start_listener( hatchet_chop_guard );
	level thread hatchet_kill_switch_reset_death_anim( hatchet_chop_guard );
	
	level thread hatchet_throw_vignette();
	
	hatchet_chop_guard waittill( "death" );
	streamer_hint Delete();
}


hatchet_guard_alerted()
{
	self endon("death");
	
	level waittill( "player_stealth_fail" );
	
	self.deathanim = undefined;
}


hatchet_kill_guard_anims()
{
	self endon( "melee_victim" );
	self endon( "death" );
	
	self.allowdeath = true;
	
	self waittill( "goal" );
	
	// self thread anim_single( self, "idle_loop" );
	
	player = get_players()[0];
//	while( !player maps\_contextual_melee::player_can_melee(self) )
//	{
//		wait( .1 );
//	}
	
	self anim_single( self, "idle_2_flinch" );
	
	level notify( "player_stealth_fail" );
	self anim_single( self, "flinch_to_ai" );
}

hatchet_kill_switch_reset_death_anim( hatchet_chop_guard )
{
	hatchet_chop_guard endon( "melee_victim" );
	hatchet_chop_guard endon("death");
	
	level waittill( "player_stealth_fail" );
	hatchet_chop_guard.deathanim = undefined;
}

hatchet_kill_stealth_listener( hatchet_chop_guard )
{
	hatchet_chop_guard endon( "melee_victim" );
	
	trigger_wait( "alley_kill_stealth_trigger" );
	
	level notify( "player_stealth_fail" );
}


third_heli_hide_event()
{
	level thread third_cover_vignette();
}

//------------------------------------
// move reznov up to the lab

wait_for_pulldown_trigger()
{
	trigger_wait( "pulldown_trigger" );
	
	flag_set( "pull_down_start" );
}

lab_approach_event()
{	
	player = get_players()[0];
	player endon( "disconnect" );
	player endon( "death" );	
	
	flag_wait( "third_pass_clear" );
	
	anim_node = getstruct( "anim_after_hatchet", "targetname" );
	
	anim_node notify( "stop_run_idle" );
	anim_node thread anim_single_aligned( level.heroes[ "reznov" ], "after_hatchet_run_exit" );
	trigger_use( "move_after_pass_2" );
	
	level thread wait_for_pulldown_trigger();
	level thread lab_approach_vignette();
	level thread pull_down_vignette();
	
	trig = trigger_wait( "trig_reznov_cqb_stairs" );
	trig.who enable_cqbwalk();
}

//------------------------------------
// Reznov and player reach rooftop
distant_explosion_event()
{
	level thread distant_explosion_vignette();
	
	trigger_wait( "distant_explosion_kickoff" );
	
	// Explosions in the distance, in the town area
	explosion_struct = getstruct( "explosion_roof", "targetname" );
	
	level thread maps\rebirth_amb::play_fake_battle(explosion_struct);
	
	// wait( 2 );
	
	flag_set( "distant_explosion_triggered" );
	
	// PlayFX( level._effect[ "distant_explosion" ], explosion_struct.origin );
	exploder( 150 );
	playsoundatposition ("evt_big_explof", (11276, 11472, 1199));
	clientnotify ("alarmz_trig");
}

//------------------------------------
// Reznov and player slide down cables, attack men
// inside elevator, then enter elevator
elevator_event()
{
	level thread move_unoccupied_elevator();
	
	level thread elevator_slide_vignette();
	level thread elevator_kill_vignette();
}

//------------------------------------
// Move the unoccupied elevator 
move_unoccupied_elevator()
{
	elevator = GetEnt( "elevator01", "targetname" );
	elevator_moveto = getstruct( "elevator_moveto", "targetname" );
	
	trigger_wait( "elevator_move" );
	
	exploder( 490 );
	
	elevator moveto( elevator_moveto.origin, 6, 1, 1 );
}

docks_trigger_cleanup()
{
	dock_triggers = GetEntArray( "hiding_place", "targetname" );
	
	dock_triggers = array_add( dock_triggers, GetEnt( "heli_spawn_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "start_ai_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "truck_ai_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "stealth_fail_backtrack", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "second_cover_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "wait_for_crane", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "heli_spawn_trigger", "targetname" ) );
	stealth_trigs = GetEntArray( "dock_stealth_trigger", "targetname" );
	for( i = 0; i < stealth_trigs.size; i++ )
	{
		dock_triggers = array_add( dock_triggers, stealth_trigs[i] );
	}
	dock_triggers = array_add( dock_triggers, GetEnt( "alley_backtrack", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "setup_hatchet_kill", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "stealth_fail_infantry", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "patrol_return", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "patrol_clear", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "patrol_turn", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "ready_stealth_kill", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "reznov_move_post_kill", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "alley_backtrack", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "run_heli_2", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "third_pass_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "near_cliff", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "alley_backtrack", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "reznov_up_ladder", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "begin_roof_climb", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "distant_explosion_kickoff", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "roof_trigger_1", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "at_elevator_shaft", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "roof_save_trigger", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "elevator_move", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "roof_trigger_2", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "elevator_top", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "elevator_cable", "targetname" ) );
	dock_triggers = array_add( dock_triggers, GetEnt( "elevaor_roof", "targetname" ) );
	
	for( i = 0; i < dock_triggers.size; i++ )
	{
		if( IsDefined( dock_triggers[i] ) )
		{
			dock_triggers[i] Delete();
		}
	}
}

docks_crate_cleanup()
{
	dock_crates = [];
	dock_crates = array_add( dock_crates, GetEnt( "mason_start_crate", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "dock_crate_intro", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "dock_crate_stealth", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "dock_crate", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "container_01", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "container_02", "targetname" ) );
	dock_crates = array_add( dock_crates, GetEnt( "container_03", "targetname" ) );
	
	for( i = 0; i < dock_crates.size; i++ )
	{
		dock_crates[i] Delete();
	}
}

//------------------------------------
// Remove any entities no longer needed on the docks
docks_clean_up()
{
	level notify( "docks_cleaned" );
	
	level thread docks_trigger_cleanup();
	level thread docks_crate_cleanup();
	
	dock_patrol_ai 	= GetEntArray( "dock_patroller", "script_noteworthy" );	
	dock_stealth_ai = GetEntArray( "stealth_broken_ai", "script_noteworthy" );
	roof_guys1		  = get_ai_array( "explosion_guard_left", "script_noteworthy" );
	roof_guys2 			= get_ai_array( "explosion_guard_right", "script_noteworthy" );
	
	dock_ai					= array_combine( dock_patrol_ai, dock_stealth_ai );
	dock_ai					= array_combine( dock_ai, roof_guys1 );
	dock_ai					= array_combine( dock_ai, roof_guys2 );
	
	dock_gulls1 = GetEntArray( "seagull_circle_01", "targetname" );	
	dock_gulls2 = GetEntArray( "seagull_circle_02", "targetname" );
	dock_gulls3 = GetEntArray( "seagull_circle_03", "targetname" );	
	
	dock_gulls = array_combine( dock_gulls1, dock_gulls2 );
	dock_gulls = array_combine( dock_gulls, dock_gulls3 );
	
	for( i = 0; i < dock_ai.size; i++ )
	{
		dock_ai[i] Delete();
	}
	
	for( i = 0; i < dock_gulls.size; i++ )
	{
		dock_gulls[i] Delete();
	}
	
	level thread rb_cleanup_all_ambient_vignettes();
	
	stop_exploder( 150 );
	stop_exploder( 10 );	
	stop_exploder( 15 ); 
}


/*------------------------------------------------------------------------------------------------------------
																								Crane/Crate movement
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Move the crate the player starts in to the ground
drop_starting_crate()
{
	wait( 4 );
	start_crate = GetEnt( "mason_start_crate", "targetname" );
	air_stop		= getstruct( "mason_crate_moveto_air" );
	dock_stop		= getstruct( "mason_crate_moveto_dock" );	
	
	// Move the crate to the dock
	start_crate moveto( air_stop.origin, 10, 2, 2 );
	wait(8);
	Earthquake( .2, 1, get_players()[0].origin, 128 ); // shake when stops
	start_crate waittill( "movedone" );
	wait( 1 );
	start_crate RotateTo( air_stop.angles, 8 );
	start_crate waittill( "rotatedone" );	
	
	start_crate moveto( dock_stop.origin, 6 );		
	start_crate RotateTo( dock_stop.angles, 6 );
	
	// wait(2);		// moveto speed - 6 (given by animator for dock worker anims)
	level notify( "start_worker_crate_investigate" );
	
	start_crate waittill( "movedone" );
	
	Earthquake( .3, 1, get_players()[0].origin, 128 ); // shake when crate hits the ground
	level thread maps\createart\rebirth_art::start_crate_lowered_fog();
	
	flag_set( "start_crate_stopped" );
	flag_clear("cargo_ropes_start");
}

//------------------------------------
// Move crate immediately to final pos for jumptos
snap_starting_crate()
{
	start_crate = GetEnt( "mason_start_crate", "targetname" );
	dock_stop = getstruct( "mason_crate_moveto_dock" );
	
	start_crate.origin = dock_stop.origin;
	start_crate.angles = dock_stop.angles;
}

//------------------------------------
// Lower the crate outside of the starting crate, during the first
// stealth kill
drop_crate_before_heli()
{
	crate							= GetEnt( "dock_crate_intro", "targetname" );
	struct_crate_move	= getstruct( "dock_crate_intro_moveto", "targetname" );

	crate_hook = GetEnt( "container_01", "targetname" );
	crate.origin = crate_hook GetTagOrigin( "container_jnt" );
	crate.angles = crate_hook GetTagAngles( "container_jnt" );
	crate LinkTo( crate_hook, "container_jnt" );
	
	crate Hide();
	
	flag_wait( "start_crate_stopped" );

	crate Show();
	level notify( "container_01_start" );
	crate_hook thread crate_drop_kill_trigger_think();
	
//	crate moveto( struct_crate_move.origin, 7 );
//	crate RotateTo( struct_crate_move.angles, 7 );
//	crate waittill( "movedone" );
}



//------------------------------------
// rotate the crane and then lower the crate it is carrying
drop_cover_crate()
{
	crane 						= GetEnt( "dock_crane", "targetname" );
	crate							= GetEnt( "dock_crate", "targetname" );
	crate_hook				= GetEnt( "container_02", "targetname" );
	crate_hook.animname = "fxanim_props";
	crate_hook UseAnimTree( level.scr_animtree["fxanim_props"] );
	crate_support			= GetEnt( "cranesupport", "targetname" );
	struct_rotate_to	= getstruct( "crane_rotate_to", "targetname" );
	struct_crate_move	= getstruct( "crate_drop_to", "targetname" );
	
	// crate_support LinkTo( crane );
	
	crane.origin = crate_hook GetTagOrigin( "crane_jnt" );
	crane.angles = crate_hook GetTagAngles( "crane_jnt" );
//	crane.animname = "fxanim_props";
//	crane UseAnimTree( level.scr_animtree["fxanim_props"] );
	crane LinkTo ( crate_hook, "crane_jnt" );
	
 	crate.origin = crate_hook GetTagOrigin( "container_jnt" );
	crate.angles = crate_hook GetTagAngles( "container_jnt" );
	crate LinkTo ( crate_hook, "container_jnt" );
	
 	crate_support.origin = crate_hook GetTagOrigin( "grabber_top_jnt" ) + (0, 0, 110 );
	crate_support.angles = crate_hook GetTagAngles( "grabber_top_jnt" ) + (0, 90, 0);
	crate_support LinkTo( crate_hook, "grabber_top_jnt" );	
	
	crate_hook anim_first_frame( crate_hook, "a_container_02" );
	
	flag_wait( "crane_start" );
	
	level notify( "container_02_start" );
	crate_hook thread crate_drop_kill_trigger_think();
	
	wait( 16 );
	
	flag_set( "crate_drop_done" );
}



//------------------------------------
// Drop the crate before the alley, after the cover crate
drop_crate_before_alley()
{
	crate				= GetEnt( "dock_crate_stealth", "targetname" );
	crate_hook 	= GetEnt( "container_03", "targetname" );
	
	crate_hook = GetEnt( "container_03", "targetname" );
	crate.origin = crate_hook GetTagOrigin( "container_jnt" );
	crate.angles = crate_hook GetTagAngles( "container_jnt" );
	crate LinkTo( crate_hook, "container_jnt" );
	
	flag_wait( "crate_drop_done" );
	
//	struct_crate_move	= getstruct( "dock_crate_stealth_moveto", "targetname" );
//	crate moveto( struct_crate_move.origin, 7 );
//	crate waittill( "movedone" );
	wait( 4 );
	level notify( "container_03_start" );
	crate_hook thread crate_drop_kill_trigger_think();

	//SOUND - Shawn J
	clientnotify ("container_b_moves");
	
	wait( 7 ); // TEMP, the time it takes for the crate to touch ground
	
	flag_set( "second_crate_drop_done" );
}															


/*------------------------------------------------------------------------------------------------------------
																								Event:  Carter Dock Stealth
------------------------------------------------------------------------------------------------------------*/

dock_stealth_listener()
{
	level endon( "event_mason_stealth_done" );
	
	level thread dock_stealth_watch_gunfire();
	
	level waittill( "player_stealth_fail" );
	flag_clear( "can_save" );	// we will no longer save
	level.heroes["reznov"] thread anim_single( level.heroes["reznov"], "stealth_broken" );
	
	player = get_players()[0];
//	if( player GetCurrentWeapon() == "rebirth_hands_sp" )
//	{
//		player TakeAllWeapons();
//	}
	
	trigger_use( "sm_stealth_broken" );
	
	Objective_Set3d( level.obj_iterator, false );
	
	patroller_guys = GetEntArray( "dock_patroller", "script_noteworthy" );
	array_thread( patroller_guys, ::dock_ai_attack_player );
	
	dock_workers = get_ai_group_ai( "dock_worker" );
	array_thread( dock_workers, ::dock_worker_run_from_player );	
	
	// turn off the contextual melee kills 
	contextual_melee_guys = [];
	contextual_melee_guys = array_merge( contextual_melee_guys, get_ai_array( "intro_worker_garrote_ai", "targetname" ) );
	contextual_melee_guys = array_merge( contextual_melee_guys, get_ai_array( "dock_stealth_kill_ai", "targetname" ) );
	
	for( i = 0; i < contextual_melee_guys.size; i++ )
	{
		if( IsDefined( contextual_melee_guys[i] ) && IsAlive( contextual_melee_guys[i] ) )
		{
			contextual_melee_guys[i] contextual_melee( false );
		}
	}
}



dock_stealth_watch_gunfire()
{
	level endon( "pull_down_start" );

	player = get_players()[0];	
	
	while( true )
	{
		player waittill("weapon_fired");
//		if( player IsFiring() && player GetCurrentWeapon() != "hatchet_rebirth_sp" )
		if( player GetCurrentWeapon() != "hatchet_rebirth_sp" )
		{
//			PrintLn("*** Cur weapon " + player GetCurrentWeapon());
			level notify( "player_stealth_fail" );
		}
		
		//wait( 0.05 );
	}
}



//------------------------------------
// Watch the player to see if he enters a place
// he shouldn't be
dock_stealth_trigger_check()
{
	level endon( "event_mason_stealth_done" );
	
	level thread stealth_crate_trigger_think();
	
	trigger_wait( "dock_stealth_trigger" );
	
	level notify( "player_stealth_fail" );
	
	/*
	
	*/
}



//------------------------------------
// Wait for the crate to drop, then remove the
// trigger to detect the player
stealth_crate_trigger_think()
{
	crate_trig = GetEnt( "crane_stealth_trigger", "script_noteworthy" );
	
	flag_wait( "crate_drop_done" );
	crate_trig trigger_off();
}



//------------------------------------
// tell all patrollers to stop ignoring the Player
// send them to attack player
dock_ai_attack_player()
{	
	player = get_players()[0];
	
	if( IsAI( self ) )
	{	
		wait( RandomFloatRange( .05, 1.5 ) ); 
		
		if( IsAlive( self ) )	// in case player kills before wait is done
		{		
			self notify( "end_patrol" );
			self set_ignoreall( false );
			self set_pacifist( false );
	
			self maps\_rusher::rush();
		}
	}
	else	// Change KVPs if stealth is broken to destroy the player
	{
		self.script_ignoreall = undefined;
		self.script_patroller = undefined;
		self.script_playerseek = 1;
	}
}



//------------------------------------
// have the dock workers run into the lab away from the player
dock_worker_run_from_player()
{
	self endon( "death" );
	
	self anim_stopanimscripted();
	
	wait( RandomFloatRange( 0.01, 0.5 ) );
	
	goto_struct = getstruct( "dock_worker_runto", "targetname" );
	self SetGoalPos( goto_struct.origin );
	self waittill( "goal" );
	self Delete();
}



/*------------------------------------------------------------------------------------------------------------
																								Mason Stealth Helicopters
------------------------------------------------------------------------------------------------------------*/

/////////////////////////////////////////////
// HELICOPTER CONTROL
/////////////////////////////////////////////

stealth_heli_setup()
{
	// trigger_use( "heli_spawn_trigger" );
	
	wait( 0.1 );
	
	heli_one = GetEnt( "stealth_heli_1", "targetname" );
	
	heli_one rb_heli_init();

	heli_one.engage_dist = 2000;
	heli_one.engage_height = 1000;

	heli_one thread first_heli_behavior();
}

heli_stealth_fail()
{
	level endon( "event_mason_stealth_done" );
	self endon( "death" );
	
	level waittill( "player_stealth_fail" );
	clientnotify ( "spotlight_kid" );
	
	player = get_players()[0];
	
	if( IsDefined( self.spotlight_target ) )
	{
		self rb_heli_spotlight_target_object( player );
	}
	
	self SetLookAtEnt( player );
	
	self SetGunnerTargetEnt( player, (0,0,32), 0 );
	
	self thread rb_heli_engage( get_players()[0], self.engage_dist, self.engage_height );
	
	while( true )
	{
		self rb_heli_fire_side_gun( player, RandomFloatRange( 0.5, 1.5 ) );
		wait( RandomIntRange( 2, 7 ) );
	}
}

heli_cover_detection()
{
	level endon( "stop_detection" );
	
	level waittill( "start_detection" );
	
	player = get_players()[0];
	
	hide_triggers = GetEntArray( "hiding_place", "targetname" );
	Assert( hide_triggers.size >= 1 );
	
	while( true )
	{
		hiding = false;
		for( i = 0; i < hide_triggers.size; i++ )
		{
			if( player IsTouching( hide_triggers[i] ) )
			{
				hiding = true;
			}
		}
		if( !hiding )
		{
			level notify( "player_stealth_fail" );
			self rb_heli_spotlight_target_point( player.origin, 2 );
			self rb_heli_spotlight_target_object( player );
			return;
		}
		wait( 0.05 );
	}
}

first_heli_behavior()
{
	level endon( "player_stealth_fail" );
	
	self thread heli_stealth_fail();
	
	self rb_heli_spotlight_enable( true );
	//self rb_heli_spotlight_shadow_enable( true );
	self rb_heli_set_speed( 10 );
	
	self thread rb_heli_idle( "crate_check", true, true, false );
	
	flag_wait( "start_crate_stopped" );
	//self rb_heli_spotlight_shadow_enable( false );
	flag_wait( "crate_kill_success" );
	wait( 6 );
	//self rb_heli_spotlight_shadow_enable( true );
	self rb_heli_spotlight_circle_enable( true );
	self thread heli_cover_detection();
	
	self thread rb_heli_path( "do_1st_pass", 10 );
	
	level waittill( "stop_detection" );
	self rb_heli_spotlight_circle_enable( false );
	self waittill( "path_complete" );
	flag_set( "first_pass_clear" );
	
	self thread rb_heli_idle( "idle_til_3rd_pass", false, false, true );
	
	trigger_wait( "third_pass_trigger" );
	self rb_heli_spotlight_circle_enable( true );
	self thread heli_cover_detection();
	
	self thread rb_heli_path( "do_3rd_pass", 15 );
	level thread catwalk_stealth_trig_delete();
	
	level waittill( "kill_spot_circle" );
	self rb_heli_spotlight_circle_enable( false );
	
	level notify( "heli_spotlight_stealth_done" );
	level waittill( "heli_stop_spotlight" );
	self rb_heli_spotlight_enable( false );
	//self rb_heli_spotlight_shadow_enable( false );
	flag_set( "third_pass_clear" );
	self waittill( "path_complete" );
	self rb_heli_delete();
}

catwalk_stealth_trig_delete()
{
	level waittill( "heli_spotlight_stealth_done" );
	
	trig = GetEnt( "stealth_catwalk", "script_noteworthy" );
	trig Delete();
}

/*------------------------------------------------------------------------------------------------------------
																								Objectives
------------------------------------------------------------------------------------------------------------*/
mason_stealth_objective_visibility()
{
	level endon( "event_mason_stealth_done" );
	
	flag_wait( "crate_investigate_done" );
	Objective_Set3d( level.obj_iterator, true );
	
	flag_wait( "crate_kill_success" );
	Objective_Set3d( level.obj_iterator, false );
	
	flag_wait( "crate_kill_done" );
	Objective_Set3d( level.obj_iterator, true, "default", &"REBIRTH_FOLLOW" );
	
	flag_wait( "second_hatchet_kill_ready" );
	Objective_Set3d( level.obj_iterator, true );
	
	flag_wait( "hatchet_kill_start" );
	Objective_Set3d( level.obj_iterator, false );
	
	flag_wait( "hatchet_throw_done" );
	Objective_Set3d( level.obj_iterator, true, "default", &"REBIRTH_FOLLOW" );
	
	flag_wait( "pull_down_start" );
	Objective_Set3d( level.obj_iterator, false );
	
	flag_wait( "pull_down_success" );
	Objective_Set3d( level.obj_iterator, true );
	
	flag_wait( "player_slide_done" );
	Objective_Set3d( level.obj_iterator, false );
}

mason_stealth_objectives()
{
	level endon( "event_mason_stealth_done" );
	
	level thread mason_stealth_objective_visibility();
	
	flag_wait( "start_crate_stopped" );
	
	Objective_Add( level.obj_iterator, "current", &"REBIRTH_OBJECTIVE_1", (0, 0, 0) );
	
	flag_wait( "crate_investigate_done" );
	
	dock_worker = GetEnt( "intro_worker_garrote_ai", "targetname" );
	Objective_Position( level.obj_iterator, dock_worker );
	
	flag_wait( "crate_kill_done" );
	Objective_Position( level.obj_iterator, level.heroes["reznov"] );
	
	flag_wait( "second_hatchet_kill_ready" );
	
	
	hatchet_guard = GetEnt( "dock_stealth_kill_ai", "targetname" );
	while(!IsDefined(hatchet_guard)) // If Reznov runs off, he triggers this
	{
		wait(0.05);
		hatchet_guard = GetEnt( "dock_stealth_kill_ai", "targetname" );
	}
	
	Objective_Position( level.obj_iterator, hatchet_guard );
	
	flag_wait( "hatchet_throw_done" );
	
	Objective_Position( level.obj_iterator, level.heroes["reznov"] );;
	
	flag_wait( "third_pass_clear" );
	
	level thread rb_objective_breadcrumb( level.obj_iterator, "obj_breadcrumb_mason_elevator" );
	trigger_use( "obj_breadcrumb_mason_elevator" );
}

/*------------------------------------------------------------------------------------------------------------
																								Checkpoint+
																								+
------------------------------------------------------------------------------------------------------------*/
mason_stealth_checkpoints()
{
	level endon( "event_mason_stealth_done" );
	level endon( "player_stealth_fail" );
	
	flag_wait( "crate_investigate_done" );
	autosave_by_name( "pre_crate_kill_save" );
	
	//-- removed because it causes bugs (55889)
	//flag_wait( "first_pass_clear" );
	//autosave_by_name( "first_pass_save" );
	
	//flag_wait( "hatchet_kill_start" );
	//autosave_by_name( "pre_hatchet_save" );
	
	// flag_wait( "hatchet_kill_success" );
	// autosave_by_name( "post_hatchet_save" );
	
	//flag_wait( "third_pass_clear" );
	//autosave_by_name( "third_pass_save" );
	
	flag_wait( "lab_approach_done" );
	autosave_by_name( "pull_down_save" );
	
	//flag_wait( "distant_explosion_done" );
	//autosave_by_name( "optional_kill_save" );
	
	//flag_wait( "elevator_slide_start" );
	//autosave_by_name( "elevator_kill_save" );
}


/*------------------------------------------------------------------------------------------------------------
																							 Lighting and Fog
------------------------------------------------------------------------------------------------------------*/																							

mason_stealth_fog()
{
	start_dist = 0;
	half_dist = 457.285;
	half_height = 690.436;
	base_height = -154.169;
	fog_r = 0.0784314;
	fog_g = 0.0901961;
	fog_b = 0.0901961;
	fog_scale = 3.35191;
	sun_col_r = 0.388235;
	sun_col_g = 0.168627;
	sun_col_b = 0;
	sun_dir_x = -0.854627;
	sun_dir_y = -0.393805;
	sun_dir_z = -0.338424;
	sun_start_ang = 0;
	sun_stop_ang = 117.187;
	time = 0;
	max_fog_opacity = 0.659332;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

                  
	VisionSetNaked( "rebirth_cargo_container", 0 );
               
}

mason_stealth_water()
{
	SetDvar( "r_waterWaveAngle", "36.5 92.4 6.85 215.4" );
	SetDvar( "r_waterWaveWavelength", "209.125 510.6 325.35 80.015" );
	SetDvar( "r_waterWaveAmplitude", "3.8 2.1 6.125 2.45" );
	SetDvar( "r_waterWavePhase", "0.0 0.0 0.0 0.0" );
	SetDvar( "r_waterWaveSteepness", "1.0 1.0 1.0 1.0" );
	SetDvar( "r_waterWaveSpeed", "0.85 1.0 0.78 1.2" );
}

/*------------------------------------------------------------------------------------------------------------
																								Spawn Functions
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Force the hatchet contextual melee
dock_patroller_spawnfunc()
{
	if( IsDefined( self.script_string ) && (self.script_string == "delete_at_end" || self.script_string == "last_guy") )
	{
		self waittill( "reached_path_end" );
		self thread delete_when_noone_looking();
	}
}



//------------------------------------
// Watch to see if this particular AI dies
roof_ai1_spawnfunc()
{
	level endon( "docks_cleaned" );
	
	self waittill( "death" );
	roofspawner = GetEnt( "roof_patroller3", "script_noteworthy" );
	roofspawner.count = 0;
}



//------------------------------------
// Watch to see if this particular AI dies
roof_ai2_spawnfunc()
{
	level endon( "docks_cleaned" );
	
	self waittill( "death" );
	roofspawner = GetEnt( "roof_patroller4", "script_noteworthy" );
	roofspawner.count = 0;
}



/*------------------------------------------------------------------------------------------------------------
																								Melee Hatchet
------------------------------------------------------------------------------------------------------------*/

#using_animtree( "generic_human" );
melee_hatchet_init()
{
	wait_for_first_player();
	
	player = get_players()[0];
	
	// Add hatchet-specific contextual melee kills
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetworker", "stand", "stand", %int_contextual_melee_hatchet_worker, %ai_contextual_melee_hatchet_worker );
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetworker", "crouch", "stand", %int_contextual_melee_hatchet_worker, %ai_contextual_melee_hatchet_worker );
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetworker", "prone", "stand", %int_contextual_melee_hatchet_worker, %ai_contextual_melee_hatchet_worker );
	maps\_contextual_melee::add_melee_weapon("default", "hatchetworker", "stand", "stand", "t5_weapon_hatchet_viewmodel");
	maps\_contextual_melee::add_melee_weapon("default", "hatchetworker", "crouch", "stand", "t5_weapon_hatchet_viewmodel");
	maps\_contextual_melee::add_melee_weapon("default", "hatchetworker", "prone", "stand", "t5_weapon_hatchet_viewmodel");
	
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetguard", "stand", "stand", %int_contextual_melee_hatchet_to_throw, level.scr_anim[ "hatchet_chop_guard" ][ "chop_contextual_melee"] );
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetguard", "crouch", "stand", %int_contextual_melee_hatchet_to_throw, level.scr_anim[ "hatchet_chop_guard" ][ "chop_contextual_melee"] );
	maps\_contextual_melee::add_melee_sequence( "default", "hatchetguard", "prone", "stand", %int_contextual_melee_hatchet_to_throw, level.scr_anim[ "hatchet_chop_guard" ][ "chop_contextual_melee"] );
	maps\_contextual_melee::add_melee_weapon("default", "hatchetguard", "stand", "stand", "t5_weapon_hatchet_viewmodel");
	maps\_contextual_melee::add_melee_weapon("default", "hatchetguard", "crouch", "stand", "t5_weapon_hatchet_viewmodel");
	maps\_contextual_melee::add_melee_weapon("default", "hatchetguard", "prone", "stand", "t5_weapon_hatchet_viewmodel");
	
	// Replace the player's weapon with a hatchet
	// player HideViewModel();
	player TakeAllWeapons();
	
	//-- GLocke: disable melee while the player only has hands and no hatchet
	player AllowMelee(false);
	player GiveWeapon( "rebirth_hands_sp" );
	player SwitchToWeapon( "rebirth_hands_sp" );
}

hatchet_kill_arm_blood(guy)
{
	PlayFXOnTag( level._effect["hatchet_arm_blood"], guy, "J_Wrist_LE" );
}

hatchet_kill_chest_blood(guy)
{
	PlayFXOnTag( level._effect["hatchet_thrown_blood"], guy, "J_spine4" );
}

//////////////////////////////////////////////////////////////////////////
// TUNING FUNCTIONALITY
//////////////////////////////////////////////////////////////////////////

crate_check_tuning()
{
	tuning_structs = [];
	for( i = 1;; i++ )
	{
		temp_struct = getstruct( "crate_check_scan_"+i );
		if( IsDefined( temp_struct ) )
		{
			tuning_structs = array_add( tuning_structs, temp_struct );
		}
		else
		{
			break;
		}
	}
	
	// Translation times
	tuning_structs[0].script_int = tuning_structs[0].script_int;
	tuning_structs[1].script_int = tuning_structs[1].script_int;
	tuning_structs[2].script_int = tuning_structs[2].script_int;
	tuning_structs[3].script_int = tuning_structs[3].script_int;
	tuning_structs[4].script_int = tuning_structs[4].script_int;
	tuning_structs[5].script_int = tuning_structs[5].script_int;
	tuning_structs[6].script_int = tuning_structs[6].script_int;
	tuning_structs[7].script_int = tuning_structs[7].script_int;
	tuning_structs[8].script_int = tuning_structs[8].script_int;
	
	// Pause times
	tuning_structs[0].script_float = tuning_structs[0].script_float;
	tuning_structs[1].script_float = tuning_structs[1].script_float;
	tuning_structs[2].script_float = tuning_structs[2].script_float;
	tuning_structs[3].script_float = 3;//tuning_structs[3].script_float;
	tuning_structs[4].script_float = 4;//tuning_structs[4].script_float;
	tuning_structs[5].script_float = 5;//tuning_structs[5].script_float;
	tuning_structs[6].script_float = tuning_structs[6].script_float;
	tuning_structs[7].script_float = tuning_structs[7].script_float;
	tuning_structs[8].script_float = tuning_structs[8].script_float;
	
}

do_1st_pass_tuning()
{
	for( i = 1;; i++ )
	{
		temp_struct = getstruct( "do_1st_pass_scan_"+i );
		if( IsDefined( temp_struct ) )
		{
			temp_struct.script_int = 2.8;
			temp_struct.script_float = undefined;
		}
		else
		{
			break;
		}
	}
}

do_3rd_pass_tuning()
{
	for( i = 1;; i++ )
	{
		temp_struct = getstruct( "do_3rd_pass_scan_"+i );
		if( IsDefined( temp_struct ) )
		{
			temp_struct.script_int = 1.5;
			temp_struct.script_float = undefined;
		}
		else
		{
			break;
		}
	}
}

idle_til_2nd_pass_tuning()
{
}

prepare_2nd_pass_tuning()
{
}

do_2nd_pass_tuning()
{
}

idle_til_explosion_tuning()
{
}

/////////////////////////////////////////////
// SEAGULL TECH
/////////////////////////////////////////////
#using_animtree( "critter" );
seagull_init()
{
	seagull_structs = getstructarray( "seagull_spawn", "targetname" );
	
	for( i = 0; i < seagull_structs.size; i++ )
	{
		seagull_structs[i] thread setup_seagull_position();
	}
}

seagull_do_idle_twitch()
{
	self endon( "death" );
	self endon( "takeoff" );
	
	while( true )
	{
		wait( RandomFloatRange( 2, 4 ) );
		self ClearAnim( %root, 0.2 );
		self SetAnim( %a_seagull_idle_twitch, 1, 0.2, 1 );
	}
}

seagull_fly_anims()
{
	self endon( "death" );
	
	self StopAnimScripted();
	
	while( true )
	{
		fly_time = RandomFloatRange( 4, 6 );
		glide_time = RandomFloatRange( 3, 4 );
		second_glide_time = RandomFloatRange( 2, 5 );
		twitch_time = GetAnimLength( %a_seagull_glide_twitch );
		self ClearAnim( %root, 0.2 );
		self SetAnim( %a_seagull_fly, 1, 0.2, 1 );
		wait( fly_time );
		self ClearAnim( %root, 0.2 );
		self SetAnim( %a_seagull_glide, 1, 0.2, 1 );
		wait( glide_time );
		self ClearAnim( %root, 0.2 );
		self SetAnim( %a_seagull_glide_twitch, 1, 0.2, 1 );
		wait( twitch_time );
		self ClearAnim( %root, 0.2 );
		self SetAnim( %a_seagull_glide, 1, 0.2, 1 );
		wait( second_glide_time );
	}
}

seagull_takeoff_and_fly( seagull_node )
{
	self endon( "death" );
	
	anim_length = GetAnimLength( %a_seagull_take_off );
	anim_rate = RandomFloatRange( 0.8, 1.0 );
	self playsound( "evt_gull_fly" );
	self thread anim_single( self, "takeoff" );
	
	wait( anim_length - 0.05 );
	self StopAnimScripted();
	
	orient = (seagull_node.angles[0], seagull_node.angles[1]+RandomFloatRange( -15, 15 ), seagull_node.angles[2]);
	vec = 10000 * VectorNormalize( AnglesToForward( orient ) );
	goal = self.origin + vec;
	
	self RotateTo( orient, 0.5 );
	self MoveTo( goal, RandomIntRange( 75, 100 ) );
	
	self thread seagull_fly_anims();
	
	self waittill( "movedone" );
	
	self Delete();
}

wait_for_takeoff()
{
	self.takeoff_trigger waittill( "trigger" );
	
	for( i = 0; i < self.seagull_models.size; i++ )
	{
		self.seagull_models[i] notify( "takeoff" );
		self.seagull_models[i] thread seagull_takeoff_and_fly( self );
		wait( RandomFloatRange( 0.5, 2 ) );
	}
}

setup_seagull_position()
{
	num_seagulls = 3;
	if( IsDefined( self.script_int ) )
	{
		num_seagulls = self.script_int;
	}
	self.takeoff_trigger = undefined;
	if( IsDefined( self.target ) )
	{
		self.takeoff_trigger = GetEnt( self.target, "targetname" );
	}

	right_vec = AnglesToRight( self.angles );
	right_vec = VectorNormalize( right_vec );

	self.seagull_models = [];

	seagull_width = 11;
	offset = 0;
	sign = 1;

	for( i = 0; i < num_seagulls; i++ )
	{
		spawn_org = self.origin + (right_vec * sign * offset);
		
		seagull = Spawn( "script_model", spawn_org );
		seagull.angles = self.angles + level.seagull_ang_offset;
		seagull SetModel( "fxanim_gp_seagull_mod" );
		seagull.animname = "seagull";
		seagull UseAnimTree( #animtree );
		seagull SetAnim( %a_seagull_idle, 1, 0, 1 );
		seagull SetAnimTime( %a_seagull_idle, RandomFloat( 0.99 ) );
		seagull thread seagull_do_idle_twitch();
		self.seagull_models = array_add( self.seagull_models, seagull );
		
		sign = sign * -1;
		offset = offset + RandomIntRange( seagull_width, 2*seagull_width );
	}
	
	if( IsDefined( self.takeoff_trigger ) )
	{
		self thread wait_for_takeoff();
	}
}

mason_not_on_my_watch(guy)
{
	player = get_players()[0];
	
	player anim_single( player, "not_on_my_watch" );
}
