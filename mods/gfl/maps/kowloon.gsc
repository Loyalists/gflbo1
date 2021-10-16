/*

KOWLOON Escape

A HK action-inspired escape through the high-rise slums of Kowloon.
Listen all y'all, it's a SABOTAGE!

kowloon_interrogate::event1();
kowloon_gas_leak::event2();
kowloon_cache_run::event3();
kowloon_rooftop_battle::event4();
kowloon_slide_in_and_out::event5();
kowloon_defend::event6();
kowloon_platform::event7();

NOTES:
wind/eye effects - projX devraw\maps\prototype_wind_effects
*/
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\_civilians;
#include maps\_music;


main()
{
	//This MUST be first for CreateFX!
	maps\kowloon_fx::main();

	precache_models();
	precache_string();
	precache_rumble();
	init_flags();
	init_thundergun();

	//-- Event Starts
	add_start( "e7_platform",		::platform_jumpto,			&"E7PLATFORM" );
	add_start( "e6_defend",			::defend_jumpto,			&"E6_DEFEND" );
	add_start( "e5_slide",			::slide_jumpto,				&"E5_SLIDE" );
	add_start( "e4b_pipe",			::pipe_jumpto,				&"E4B_PIPE" );
	add_start( "e4_rooftop_battle", ::rooftop_battle_jumpto,	&"E4_ROOFTOP_BATTLE" );
	add_start( "e3_cache_room",		::cache_run_jumpto,			&"E3_CACHE_RUN" );
	add_start( "e2_gas_leak",		::gas_leak_jumpto,			&"E2_GAS_LEAK" );
	add_start( "e1_interrogate",	::interrogate_jumpto,		&"E1_INTERROGATE" );
	default_start( ::delayed_default_start );
	//overrides default introscreen function
	//level.custom_introscreen = ::kowloon_introscreen_redact_delay;

	maps\_load::main();
	maps\_civilians::init_civilians();
	maps\_rusher::init_rusher();

	maps\kowloon_amb::main();
	maps\kowloon_anim::main();

	OnFirstPlayerConnect_Callback(::on_first_player_connect);
	OnPlayerConnect_Callback(::on_player_connect);
}

delayed_default_start()
{
	wait(1);

	//rain zfeather setting

	SetSavedDvar("r_outdoorFeather", 100);

	spawn_heroes();
	
	level.end_vo = false;

	// Threads
	level thread maps\_color_manager::color_manager_think();
	level thread maps\createart\kowloon_art::lightning_states();
	level thread maps\createart\kowloon_art::turn_lightning_on_indoor();
	
	level thread init_level_specific_stuff();

	//look at system init - shabs
	array_thread(GetEntArray("trigger_point", "script_noteworthy"), maps\kowloon_util::trigger_point);

	//shabs - turning this off until its time for the jump
	trig_force_clarke_jump = GetEnt( "trig_force_clarke_jump", "targetname");
	trig_force_clarke_jump trigger_off();

	level thread interrogate_jumpto();
}

kowloon_onsaverestored()
{
	player = get_players()[0];
	player DisableInvulnerability();
}

on_player_connect()
{
	OnSaveRestored_Callback( ::kowloon_onsaverestored );
}

on_first_player_connect()
{
	self.animname = "player";
	self dds_set_player_character_name("hudson");

	maps\createart\kowloon_art::main();

	self vault_wait();
}

//
//	STRINGS
//
precache_string()
{
	PreCacheString( &"KOWLOON_OBJECTIVE_ESCAPE");
	PreCacheString( &"KOWLOON_OBJECTIVE_DEFEND_CLARK");
	PreCacheString( &"KOWLOON_OBJECTIVE_DEFEND");
}

//
//
precache_rumble()
{
	PreCacheRumble("kowloon_rooftop_plane_1");
	PreCacheRumble("kowloon_awning_rumble");
	PreCacheRumble("damage_light");
	PreCacheRumble("damage_heavy");
}

//
//
precache_models()
{
	// E1 Interrogation
	PreCacheModel("anim_glo_melee_chair_01");
	PreCacheModel("c_usa_clark_fb_bleeder");
	PreCacheModel("c_usa_clark_fb_bruised_getwet");
	PreCacheModel("t5_gfl_rfb_body");
	PreCacheModel("t5_gfl_rfb_head");

	// E2 Burn shader for Nova 6 guys
	PreCacheModel( "c_rus_spetsnaz_undercover_bodya_1_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_bodya_2_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_1_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_2_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_3_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_1_cap_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_2_cap_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_3_cap_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_bala1hole_char" );
	PreCacheModel( "c_rus_spetsnaz_undercover_head_bala3hole_char" );

//	//shabs - added this one 
//	PreCacheModel( "c_rus_spetsnaz_undercover_bodya_2_char" );
//	PreCacheModel( "c_rus_spetsnaz_undercover_bodya_2_w_char" );

	// E2, E4, E5 Used in various places for flyovers
	PreCacheModel( "p_kow_airplane_747" );

	//	E5 Clarke destroy anim
	PreCacheModel( "weapon_claymore_detonator" );

	// Used in E7 end event
	PreCacheModel( "p_kow_garage_door_dmg" );
	PreCacheModel( "t5_vehicle_v_van" );

	PreCacheModel( "t5_veh_helo_mi8_att_spotlight" );

	PreCacheModel( "t5_gfl_m16a1_viewmodel" );
	PreCacheModel( "t5_gfl_m16a1_viewmodel_player" );
	PreCacheModel( "t5_gfl_m16a1_viewbody" );

	//nova 6 death shader
	PreCacheShader( "hud_obit_nova_gas" );
}


//
//
init_flags()
{
	flag_init("delete_fake");
	
	// 	flag_init( "event1" );
	flag_init( "event2" );
	flag_init( "event3" );
	flag_init( "event4" );
	flag_init( "event5" );
	flag_init( "event6" );
	flag_init( "event7" );

	// objective start
    flag_init( "obj_start" );
	flag_init( "sprint_jump_check" );
	flag_init( "player_start_pipe_slide" );
	flag_init( "Weaver_cache_done" );
	flag_init( "Clarke_cache_done" );
	flag_init( "e2_player_inhaled" );
	flag_init( "e2_gas_escape_dialog_done" );
	flag_init( "e3_cache_anim_done" );
	flag_init( "e4_pipe_down" );
	flag_init( "e4_start_clark_animation" );
	flag_init( "e5_player_slide" );
	flag_init( "e5_player_slide_timeout" );
	flag_init( "e5_clark_detonation_done" );
	flag_init( "e6_start_defending" );
	flag_init( "e6_clark_unlock_done" );
	flag_init( "e7_start_clark_jump" );
	flag_init( "e7_clark_jump" );
	flag_init( "e7_final_fall" );
	flag_init( "e7_enable_pistol" );
	flag_init( "e7_pistol_grabbed" );
	flag_init( "e7_van_crash" );

	//shabs - flag inits
	flag_init( "slide_slow_done" );
	flag_init( "start_fall_death_check" );
	flag_init( "teleport_weaver" );
	flag_init( "van_waiting" );
	flag_init( "hero_used_slide" );
	flag_init( "slide_rumble" );
	flag_init( "void_kowloon_achievement" );
	flag_init( "player_at_ending" );
	flag_init( "player_jumped" ); //for big jump
	flag_init( "stop_defend_spawners" );
	flag_init( "disable_rooftop_aim_assist" );
	flag_init( "hallway_door_open" );
	flag_init("flashback_audio");
	flag_init("flashback_done");
	flag_init("on_fridge");
	flag_init("weaver_on_fridge");
	flag_init("clarke_on_fridge");
	flag_init("started_player_van_ending");
	flag_init("started_timeout_ending");
	
	// Client flags
	level.CLIENT_FACE_BLEED_FLAG	= 2;	// blood dripping from clarke's face.
	level.CLIENT_NOVA6_FLAG			= 3;	// Nova 6 gas shader on spetsnaz
	level.CLIENT_WET_FLAG			= 4;	// Actor's wetness
}


init_level_specific_stuff()
{
	ripped_awning = GetEnt("fxanim_kowloon_awning01_mod", "targetname");
	ripped_awning hide();

	light = GetEnt( "wall_shadow", "targetname" );
	light SetLightIntensity(0.0);

	level.indoor_volumes = GetEntArray( "info_indoors", "targetname" );
	level thread check_for_falling_death();
	level thread player_wetness();
	level.heroes[ "clarke" ] thread hero_wetness();
	level.heroes[ "weaver" ] thread hero_wetness();

//	player = get_players()[0];
//	player SetClientDvar("cg_drawfriendlynames", 0);

	level.heroes[ "clarke" ] maps\kowloon_util::remove_clarke_set_friendname();
	level.heroes[ "weaver" ]  maps\kowloon_util::remove_weaver_set_friendname();

	level thread john_woo_achievement();

	level thread force_death_trig();

	add_global_spawn_function( "axis", ::enemy_wetness );

	//shabs - rooftop guys spawn func
	roof_top_ai = GetEntArray("roof_top_ai", "script_noteworthy");
	array_thread ( roof_top_ai, ::add_spawn_function, maps\kowloon_gas_leak::roller_deathfunc );

	// Tanks shot, help unlock the thundergun
	level.gas_tanks_counter = 0;	// Will count up and then count down as they are shot

	//for lightning vision sets
	level.lightning_vision_set = 1;

	//killspawns 2 guys if player enters the room
	defend_event_killspawner = GetEnt( "defend_event_killspawner", "targetname" );
	defend_event_killspawner trigger_off();

	//clip for the entrance, just in case
	endslider_entrance_clip = GetEnt( "endslider_entrance_clip", "targetname" );
	endslider_entrance_clip NotSolid();
	endslider_entrance_clip Hide();

	//weavers shotgun
	weaver_cache_shotty = GetEnt( "weaver_cache_shotty", "script_noteworthy" );
	weaver_cache_shotty Hide();

	trig_room_enforcer = GetEnt( "trig_room_enforcer", "targetname" );
	trig_room_enforcer trigger_off();

}

force_death_trig()
{
	force_fall_death_trig = GetEntArray( "force_fall_death_trig", "targetname" );
	array_thread( force_fall_death_trig, ::do_force_death );
}

do_force_death() //self = the death trigger
{
	self waittill( "trigger" );

	player = get_players()[0];

	//level notify( "falling_death" );
	player TakeAllWeapons();
	
	//SOUND - Shawn J
	player playsound ("evt_falling_death");
	
	player thread player_looks_up();
	//	SetTimeScale(0.5);	
	level thread fade_to_black();
	player setblur(15, 2);
	Earthquake( 0.3, 2, player.origin, 30000 );
	wait(1);
	//	SetTimeScale(1);
	
	if ( flag( "sprint_jump_check" ) )
	{
		level notify( "new_quote_string" );
	
		missionFailedWrapper(&"KOWLOON_JUMP_DEATH");
		return;
	}
	
	missionFailedWrapper();
}


//
//	Kowloon Intro fade-in
// modified copy of _introscreen::introscreen_redact_delay
//kowloon_introscreen_redact_delay( string1, string2, string3, string4, string5 )
//{
//	skipIntro = false; 
//	if( IsDefined( level.start_point ) && level.start_point != "default" )
//	{
//		return; 
//	}
//
//	pausetime1 = 1;
//	pausetime2 = 6;
//	timebeforefade = 1;
//
//	// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
//	// the briefing menu will be displayed for network co-op in synchronize_players()
//	flag_wait( "all_players_connected" );
//
//	level.introwhite = NewHudElem(); 
//	level.introwhite.x = 0; 
//	level.introwhite.y = 0; 
//	level.introwhite.horzAlign = "fullscreen"; 
//	level.introwhite.vertAlign = "fullscreen"; 
//	level.introwhite.foreground = true;
//	level.introwhite SetShader( "white", 640, 480 );
//
//	// SCRIPTER_MOD
//	// MikeD( 3/16/200 ): Freeze all of the players controls
//	//	level.player FreezeControls( true ); 
//	freezecontrols_all( true ); 
//
//	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
//	level._introscreen = true;
//	
//	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
// 
//	level.introstring = []; 
//	
//	
//	if( IsDefined( pausetime1 ) )
//	{
//		waitlen = pausetime1; 
//		mswaitlen = pausetime1*1000;
//	}
//	else
//	{
//		waitlen = 0.5;
//		mswaitlen = 500; 	
//	}
//	
//	if( IsDefined( string1 ) )
//	{
//		maps\_introscreen::introscreen_create_redacted_line( string1, 500, 0, undefined, undefined, undefined, (0,0,0) );
//
//		wait( waitlen ); 	
//	}
//
//	if( IsDefined( string2 ) )
//	{
//		maps\_introscreen::introscreen_create_redacted_line( string2, 1000, mswaitlen, undefined, undefined, undefined, (0,0,0) );
//
//		wait( waitlen ); 	
//	}
//
//	if( IsDefined( string3 ) )
//	{
//		maps\_introscreen::introscreen_create_redacted_line( string3, 1500, mswaitlen*2, undefined, undefined, undefined, (0,0,0) );
//
//		wait( waitlen ); 	
//	}
//	
//	if( IsDefined( string4 ) )
//	{
//		maps\_introscreen::introscreen_create_redacted_line( string4, 2000, mswaitlen*3, undefined, undefined, undefined, (0,0,0) );
//
//		wait( waitlen ); 	
//	}		
//	
//	if( IsDefined( string5 ) )
//	{
//		maps\_introscreen::introscreen_create_redacted_line( string5, 2500, mswaitlen*4, undefined, undefined, undefined, (0,0,0) );
//	
//		wait( waitlen ); 	
//	}
//
//
//	if( IsDefined( pausetime2) )
//	{
//		wait( pausetime2 ); 
//	}
//	else
//	{
//		wait( 10-(waitlen*4) ); 	
//	}
//
//	level notify( "finished final intro screen fadein" );
//	
//	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
//	if( IsDefined( level.introscreen_waitontext_flag ) )
//	{
//		level notify( "introscreen_blackscreen_waiting_on_flag" );
//		flag_wait( level.introscreen_waitontext_flag );
//	}
//	
//	if( IsDefined( timebeforefade ) )
//	{
//		wait( timebeforefade ); 
//	}
//	else
//	{
//		wait( 3 ); 
//	}
//
//	// Fade out black
//	level.introwhite FadeOverTime( 1.5 ); 
//	level.introwhite.alpha = 0; 
//
//// 	flag_set( "starting final intro screen fadeout" );
//// 	
//	// Restore player controls part way through the fade in
//	level thread freezecontrols_all( false, 0.75 ); // 0.75 delay, since the autosave does a 0.5 delay
//
//	level._introscreen = false;
//
//	level notify( "controls_active" ); // Notify when player controls have been restored
//
//	// Fade out text
//	maps\_introscreen::introscreen_fadeOutText(); 
//
//// 	flag_set( "introscreen_complete" ); // Notify when complete
//// 	
//// 	/#
//// 	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - COMPLETE\n");
//// 	#/
//}


//
//	Spawn the Hero characters for the level.
//
spawn_heroes()
{
	level.heroes = [];
	level.heroes[ "weaver" ]		= simple_spawn_single( "ai_weaver" );
	level.heroes[ "clarke" ]		= simple_spawn_single( "ai_clarke" );

	array_thread( level.heroes, ::make_hero);

	level.heroes[ "weaver" ] ent_flag_init("pipe_traversed");
	level.heroes[ "weaver" ] ent_flag_init("temple_traversed");

	level.heroes[ "clarke" ] ent_flag_init("pipe_traversed");
	level.heroes[ "clarke" ] ent_flag_init("temple_traversed");
	
	//spawn head so that the textures are already streamed in when we switch the head
	if (is_mature())
	{
		level.clarke_head = spawn("script_model", level.heroes[ "clarke" ].origin + (0, 0, 0));
		level.clarke_head setmodel("t5_gfl_rfb_head");
	
		level.clarke_head thread delete_clarke_head();
	}
}


delete_clarke_head()
{
	flag_wait("delete_fake");
	
	if (isdefined(self))
	{
		self delete();
	}
}


//
// Give initial weapon loadouts (before cache room)
heroes_initial_loadout()
{
	//
	// level.heroes[ "weaver" ] custom_ai_weapon_loadout( "spas_sp", undefined, "cz75_sp" );
	level.heroes[ "weaver" ] custom_ai_weapon_loadout( "ak12_zm", undefined, "cz75_sp" );
	level.heroes[ "clarke" ] custom_ai_weapon_loadout( "cz75_auto_sp", undefined, "cz75_sp" );
}


//
//	Objective handler 
kowloon_objectives( start_location )
{
    flag_wait( "obj_start" );

	level.obj_num = 0;
	obj = getstruct( start_location, "targetname" );
	Objective_Add( level.obj_num, "current", &"KOWLOON_OBJECTIVE_ESCAPE", obj.origin );
	Objective_Set3D( level.obj_num, true, "default" );
	level waittill("objective_pos_update" );

	while (1)
	{
		// Keep updating position
		obj = getstruct( obj.target, "targetname" );
		Objective_Position(level.obj_num, obj.origin );	
		level waittill("objective_pos_update" );
	}
}


//
//	Handles the defend objective
kowloon_defend_objective()
{
	// Hide the current objective
	Objective_Set3D( level.obj_num, false );

	level.obj_num++;
	Objective_Add( level.obj_num, "current", &"KOWLOON_OBJECTIVE_DEFEND_CLARK" );
	Objective_Set3D( level.obj_num, true, "default", &"KOWLOON_OBJECTIVE_DEFEND" );
	Objective_Position( level.obj_num, level.heroes[ "clarke" ] );
	flag_wait( "e6_clark_unlock_done");

	Objective_State( level.obj_num, "done" );
	level.obj_num--;

	// Show current objective again
	level notify("objective_pos_update" );	// Advance to Clarke jump scene
	Objective_Set3D( level.obj_num, true );
}


//
//	Pass in the name of a struct for the player to start at
set_player_start( targetname )
{
	start = GetStruct( targetname, "targetname" );
	player = get_players()[0];
	player.animname = "player";
	player dds_set_player_character_name( "hudson" );
	if ( IsDefined( start ) )
	{
		player SetOrigin(start.origin);
		player SetPlayerAngles( start.angles );
	}
}


//
//	Pass in the name of a NODE for the actor to start at
//		self is an actor
set_actor_start( targetname )
{
	start = GetNode( targetname, "targetname" );
	if ( IsDefined( start ) )
	{
		self ForceTeleport( start.origin, start.angles );
	}
}

//
//	JUMPTOS
//
// Event 1
interrogate_jumpto()
{
	set_player_start( "start_player_e2" );
	heroes_initial_loadout();

	level thread kowloon_objectives( "objective_start" );
	level thread maps\kowloon_interrogate::event1();
}
// Event 2
gas_leak_jumpto()
{
	set_player_start( "start_player_e2" );
	heroes_initial_loadout();

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	level thread kowloon_objectives( "objective_start" );
	level thread maps\kowloon_gas_leak::event2();
	flag_set( "event2" );

	ai_rooftops = simple_spawn( "ai_e1_rooftops" );
}
// Event 3
cache_run_jumpto()
{
	set_player_start( "start_player_e3" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e3" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e3" );
	heroes_initial_loadout();

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e3_matress" );
	level thread maps\kowloon_cache_run::event3();
	flag_set( "event3" );
	flag_set( "e3_cache_anim_done" );
	// play fridge anim
	level.heroes[ "clarke" ] thread maps\kowloon_anim::init_heroes_fridge_move();
	level.heroes[ "weaver" ] thread maps\kowloon_anim::init_heroes_fridge_move();

	wait( 0.5 );
	level notify("end_cache_loop");
	level.heroes[ "clarke" ] custom_ai_weapon_loadout( "g11_sp", undefined, "cz75_sp" );
}
// Event 4
rooftop_battle_jumpto()
{
	set_player_start( "start_player_e4" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e4" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e4" );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e4_balcony" );
	level thread maps\kowloon_rooftop_battle::event4();
}
// Event 4B
pipe_jumpto()
{
	set_player_start( "start_player_e4b" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e4b" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e4b" );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e4_pipe" );
	level thread maps\kowloon_rooftop_battle::event4();
	flag_set( "event4" );

	level notify( "head_to_the_pipe" );
	level.heroes[ "clarke" ] thread maps\kowloon_anim::npc_pipe_slide( "n_pipe_wait_clarke" );
	wait( 2.0 );
	level.heroes[ "weaver" ] thread maps\kowloon_anim::npc_pipe_slide(  "n_pipe_wait_weaver" );
	level.heroes[ "clarke" ] waittill("goal");

	lines[0] = "Hurry_it_up";
	lines[1] = "Get_ass_down";
	level thread maps\kowloon_util::nag_dialog( level.heroes[ "clarke" ], lines, 10, "player_start_pipe_slide" );
}
// Event 5 
slide_jumpto()
{
	set_player_start( "start_player_e5" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e5" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e5" );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	level.heroes[ "clarke" ] ent_flag_set("temple_traversed");
	level.heroes[ "weaver" ] ent_flag_set("temple_traversed");

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e5_cache" );
	level thread maps\kowloon_slide_in_and_out::event5();
}
// Event 6
defend_jumpto()
{
	set_player_start( "start_player_e6" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e6" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e6" );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e6_cache" );
	level thread maps\kowloon_defend::event6();
	flag_set( "event6" );
}
// Event 7
platform_jumpto()
{
	set_player_start( "start_player_e7" );
	level.heroes[ "clarke" ] set_actor_start( "n_start_clark_e7" );
	level.heroes[ "weaver" ] set_actor_start( "n_start_weaver_e7" );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();

	flag_set( "obj_start" );
	level thread kowloon_objectives( "obj_e7_platform" );
	level thread maps\kowloon_platform::event7();
	level notify("kill_falling_to_death");

//	trigger_use( "enable_clarke_jump_lookat" );
	trigger_use( "go_jump_clarke" );

	door = GetEnt( "defend_gate", "targetname" );
	door RotateYaw( -115, 0.05);
	door ConnectPaths();
}

//
//
check_for_falling_death()
{
	
	// kill this thread once get to the e7 platform.
	level endon("kill_falling_to_death");

	flag_wait( "start_fall_death_check" );

	player = get_players()[0];
	count = 0;

	while(1)
	{

	/*	/#
			break;
		#/*/

		if( IsDefined( player isinmovemode("ufo", "noclip") )) 
		{
			wait(0.05);
			continue;
		}

		if( player IsOnGround() )
		{

			wait(0.05);
			count = 0;
			continue;
		}

		trace_end = player.origin + (0,0,-10000);
		trace_number = bullettrace(player.origin, trace_end, 0, self);
		org = trace_number["position"];
		dist_to_ground = DistanceSquared(player.origin, org);
		check = 500 * 500;

		if( dist_to_ground < check )
		{
			count = 0;
		}
		else
		{
			count += 0.05;
		}
		if(count > 1.5)
		{
			level notify( "falling_death" );
			player TakeAllWeapons();
			
			//SOUND - Shawn J
			player playsound ("evt_falling_death");
			
			player thread player_looks_up();
		//	SetTimeScale(0.5);	
			level thread fade_to_black();
			player setblur(15, 2);
			Earthquake( 0.3, 2, player.origin, 30000 );
			wait(2);
		//	SetTimeScale(1);

			if ( flag( "sprint_jump_check" ) )
			{
				level notify( "new_quote_string" );
				missionFailedWrapper(&"KOWLOON_JUMP_DEATH");
				return;

			}

			missionFailedWrapper();

		}
		wait(0.05);
	}
}
fade_to_black()
{
	fadeToBlack = NewHudElem(); 
	fadeToBlack.x = 0; 
	fadeToBlack.y = 0;
	fadeToBlack.alpha = 0;
	fadeToBlack.horzAlign = "fullscreen"; 
	fadeToBlack.vertAlign = "fullscreen"; 
	fadeToBlack.foreground = false; 
	fadeToBlack.sort = 50; 
	fadeToBlack SetShader( "black", 640, 480 );        
	fadeToBlack FadeOverTime( 1 );
	fadeToBlack.alpha = 1; 
}
player_looks_up()
{
	self StartCameraTween(0.5);
	self SetPlayerAngles( (-90,0,0) );
}


//
//	Keep track of player getting wet
player_wetness()
{
	wait_for_first_player();

	player = get_players()[0];
	player ClearClientFlag(level.CLIENT_WET_FLAG);

	old_state = "indoors";
	while (1)
	{	
		if(IsDefined(player._hiding_model))
		{
			wait(.05);
			continue;
		}
		state = "outdoors";
		for ( i=0; i<level.indoor_volumes.size; i++ )
		{
			if ( player IsTouching(level.indoor_volumes[i] ) )
			{
				state = "indoors";
				break;
			}
		}

		// Always keep the player dry if he has the Thundergun, otherwise the weapon 
		//	will cloak and light weirdly since it has a different shader
		if ( player HasWeapon( "thundergun_zm" ) )
		{
			state = "indoors";
		}

		// Do we need to change water drops?
		if ( state != old_state )
		{
			if ( state == "indoors" )
			{
				player SetWaterDrops(0);
				player ClearClientFlag(level.CLIENT_WET_FLAG);
			}
			else
			{
				player SetWaterDrops(50);	// 50 is the hard-coded max.
				player SetClientFlag(level.CLIENT_WET_FLAG);
			}
			old_state = state;
		}

		wait( 1.0 );
	}
}


//
//	Keep track of heroes getting wet
hero_wetness()
{
	self endon( "death" );

	old_state = "indoors";
	self ClearClientFlag(level.CLIENT_WET_FLAG);

	while (1)
	{
		state = "outdoors";
		for ( i=0; i<level.indoor_volumes.size; i++ )
		{
			if ( self IsTouching(level.indoor_volumes[i] ) )
			{
				state = "indoors";
				break;
			}
		}

		// Do we need to change water drops?
		if ( state != old_state )
		{
			if ( state == "indoors" )
			{
				self ClearClientFlag(level.CLIENT_WET_FLAG);
			}
			else
			{
				self SetClientFlag(level.CLIENT_WET_FLAG);
			}
			old_state = state;
		}

		wait( 1.0 );
	}
}

//
//	Make enemies wet!
enemy_wetness()
{
	self endon( "death" );

	if ( IsSubStr( self.classname, "wet" ) )
	{
		self SetClientFlag(level.CLIENT_WET_FLAG);
	}
}

john_woo_achievement()
{
	wait_for_first_player();
	
	player = get_players()[0];
	player thread monitor_weapon_fire();

	level thread give_john_woo_achievement();
}

monitor_weapon_fire() //self = player
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "started_player_van_ending" );

	while( 1 )
	{
		self waittill( "weapon_fired", current_weapon );
	
		//current_weapon = self GetCurrentWeapon(); // get his current weapon
	
		if( current_weapon != "pm63dw_sp" && current_weapon != "kiparisdw_sp" && current_weapon != "cz75dw_sp" && current_weapon != "cz75dw_auto_sp" )
		{
			flag_set( "void_kowloon_achievement" );
		}
		else
		{

		}
		wait( 0.05 );
	}
}

give_john_woo_achievement()
{
	trigger_wait("trig_e7_finale");

	player = get_players()[0];
	if( !flag( "void_kowloon_achievement" ) )
	{
		player giveachievement_wrapper( "SP_LVL_KOWLOON_DUAL" );
	}

}

#using_animtree ("generic_human");
//	Initialize the thundergun!!!
init_thundergun()
{
	// THUNDERGUN
	maps\kowloon_thundergun::init();

	// thundergun knockdowns and getups
	if( !isDefined( level._zombie_knockdowns ) )
	{
		level._zombie_knockdowns = [];
	}
	level._zombie_knockdowns["zombie"] = [];
	level._zombie_knockdowns["zombie"]["front"] = [];

	level._zombie_knockdowns["zombie"]["front"]["no_legs"] = [];
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][0] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][1] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["no_legs"][2] = %ai_zombie_thundergun_hit_forwardtoface;

	level._zombie_knockdowns["zombie"]["front"]["has_legs"] = [];

	level._zombie_knockdowns["zombie"]["front"]["has_legs"][0] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][1] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][2] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][3] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][4] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][5] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][6] = %ai_zombie_thundergun_hit_stumblefall;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][7] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][8] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][9] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][10] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][11] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][12] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][13] = %ai_zombie_thundergun_hit_deadfallknee;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][14] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][15] = %ai_zombie_thundergun_hit_doublebounce;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][16] = %ai_zombie_thundergun_hit_upontoback;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][17] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][18] = %ai_zombie_thundergun_hit_armslegsforward;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][19] = %ai_zombie_thundergun_hit_forwardtoface;
	level._zombie_knockdowns["zombie"]["front"]["has_legs"][20] = %ai_zombie_thundergun_hit_flatonback;

	level._zombie_knockdowns["zombie"]["left"] = [];
	level._zombie_knockdowns["zombie"]["left"][0] = %ai_zombie_thundergun_hit_legsout_right;

	level._zombie_knockdowns["zombie"]["right"] = [];
	level._zombie_knockdowns["zombie"]["right"][0] = %ai_zombie_thundergun_hit_legsout_left;

	level._zombie_knockdowns["zombie"]["back"] = [];
	level._zombie_knockdowns["zombie"]["back"][0] = %ai_zombie_thundergun_hit_faceplant;

	if( !isDefined( level._zombie_getups ) )
	{
		level._zombie_getups = [];
	}
	level._zombie_getups["zombie"] = [];
	level._zombie_getups["zombie"]["back"] = [];

	level._zombie_getups["zombie"]["back"]["early"] = [];
	level._zombie_getups["zombie"]["back"]["early"][0] = %ai_zombie_thundergun_getup_b;
	level._zombie_getups["zombie"]["back"]["early"][1] = %ai_zombie_thundergun_getup_c;

	level._zombie_getups["zombie"]["back"]["late"] = [];
	level._zombie_getups["zombie"]["back"]["late"][0] = %ai_zombie_thundergun_getup_b;
	level._zombie_getups["zombie"]["back"]["late"][1] = %ai_zombie_thundergun_getup_c;
	level._zombie_getups["zombie"]["back"]["late"][2] = %ai_zombie_thundergun_getup_quick_b;
	level._zombie_getups["zombie"]["back"]["late"][3] = %ai_zombie_thundergun_getup_quick_c;

	level._zombie_getups["zombie"]["belly"] = [];

	level._zombie_getups["zombie"]["belly"]["early"] = [];
	level._zombie_getups["zombie"]["belly"]["early"][0] = %ai_zombie_thundergun_getup_a;

	level._zombie_getups["zombie"]["belly"]["late"] = [];
	level._zombie_getups["zombie"]["belly"]["late"][0] = %ai_zombie_thundergun_getup_a;
	level._zombie_getups["zombie"]["belly"]["late"][1] = %ai_zombie_thundergun_getup_quick_a;
}


//
//
//	Access the key!
vault_wait()
{
	// Setup the betamaxes!
	//	Giver
	trig = GetEnt( "trig_beta", "targetname" );
	trig SetInvisibleToPlayer( self, true );
	trig UseTriggerRequireLookAt();
	trig SetCursorHint( "HINT_NOICON" );

	beta_door = GetEnt( "beta_door", "targetname" );
	beta = GetEnt( "beta", "targetname" );
	beta LinkTo( beta_door );

	// Receiver
	trig2 = GetEnt( "trig_beta2", "targetname" );
	trig2 SetInvisibleToPlayer( self, true );
	trig2 UseTriggerRequireLookAt();
	trig2 SetCursorHint( "HINT_NOICON" );

	beta2_door = GetEnt( "beta2_door", "targetname" );
	beta2 = GetEnt( "beta2", "targetname" );
	beta2 LinkTo( beta2_door );
	beta2 Hide();
	beta2_door MoveZ( 1.0, 0.05 );
	beta2_door RotateRoll( 15, 0.05 );

	// Weapon model
	secret = GetEnt( "beta_secret", "targetname" );
	secret Hide();

	// Shot all tanks
	level waittill( "thunder" );

	// THUNDER!
	self Playsound ("amb_thunder_clap" );	
	Earthquake( 0.75, 2.0, self.origin, 100 );

	beta_door MoveZ( 1.0, 1.0 );
	beta_door RotateRoll( 15, 1.0 );

	trig SetInvisibleToPlayer( self, false );
	trig waittill( "trigger" );

	// THUNDER!
	PlaysoundAtPosition ("amb_thunder_clap", self.origin );
	Earthquake( 0.75, 2.0, self.origin, 100 );

	// Grab beta
	trig Delete();
	beta Delete();

	trig2 SetInvisibleToPlayer( self, false );
	trig2 waittill( "trigger" );

	// "Insert" beta and close door
	time = 2.0;
	beta2 Show();
	wait( time );
	beta2_door MoveZ( -1.0, time );
	beta2_door RotateRoll( -15, time );
	wait( time * 2 );

	beta2_door Playsound( "evt_gkn6_tape" );
	wait( 10 );

	// THUNDERGUN, HOOOOOOOOOOOO!!!!
	self Playsound ("amb_thunder_clap" );
	Earthquake( 1.0, 2.0, beta2.origin, 100 );

	secret SetModel( "t5_weapon_thundergun_world" );
	secret MoveY( 32, 2.0 );
	secret Show();
	
	// Grab weapon
	trig2 waittill( "trigger" );

	// Check to see if we can grab it
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = self getCurrentWeapon(); // get his current weapon

	if( primaryWeapons.size > 1 && isdefined( current_weapon ) )
	{
		self TakeWeapon( current_weapon );
	} 
	self GiveWeapon( "thundergun_zm" );
	self SwitchToWeapon( "thundergun_zm" );
	secret Delete();
	trig2 Delete();
} 