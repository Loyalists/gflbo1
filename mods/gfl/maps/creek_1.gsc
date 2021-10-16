/*
	UP A CREEK

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle_turret_ai;
#include maps\creek_1_util;
#include maps\_music;
#include maps\_civilians;
#include maps\_rusher;

#using_animtree ("generic_human");

main()
{
	// Keep this first for CreateFX!
	maps\creek_1_fx::main();
	
	level maps\_swimming::set_default_vision_set( "creek_1_helicopter" );
	level maps\_swimming::set_swimming_vision_set( "creek_1_helicopter" );
	
//////////////////////////////////////////////////////////////////////////
// INIT FLAGS

	flag_init( "hero_setup_done" );
	flag_init( "beat_2_starts" );	
	flag_init( "beat_3_starts" );	
	flag_init( "beat_4_starts" );	
	flag_init( "beat_5_starts" );	
	flag_init( "beat_6_starts" );	
	flag_init( "beat_7_starts" );	
	flag_init( "beat_8_starts" );	

	// beat specific flags
	
	// BEAT 2
	flag_init( "b2_hut_barnes_move_up" );
	flag_init( "b2_barnes_finish_swimming" );	
	flag_init( "b2_barnes_in_position" );	
	flag_init( "village_alerted" );
	flag_init( "village_pigs_alerted" );
	flag_init( "barnes_ready_for_kill" );	
	flag_init( "barnes_start_aiming" );	
	flag_init( "barnes_finish_aiming" );	
	flag_init( "barnes_kill_finished" );	
	flag_init( "gap_idle_loop_done" );
	
	flag_init( "b1to2_path_1_passed" );
	flag_init( "b1to2_path_2_passed" );
	flag_init( "b1to2_path_3_passed" );
	flag_init( "ready_to_move_from_gap" );
	flag_init( "knife_only_starts" );
	
	flag_init( "sampan_searches_for_player" );
	
	flag_init( "snipe_event_complete" );
	flag_init( "b2_ready_for_regroup" );
	flag_init( "event_2_objectives_complete" );
	
	flag_init( "village_stealth_fail" );
	
	// -- WWILLIAMS should fix a progression break
	flag_init( "vc_lookout_in_position" );
	
	flag_init( "player_out_of_hut_village" );
	
	// -- WWILLIAMS: PRESS DEMO FLAGS
	flag_init( "squad_at_aa_village" );
	flag_init( "beat2_ridge1_start" );
	flag_init( "beat2_ridge1_backup" );
	flag_init( "beat2_ridge1_clear" );
	flag_init( "beat2_ridge1_backup_clear" );
	flag_init( "beat2_river1_start" );
	flag_init( "beat2_river1_clear" );
	flag_init( "beat2_ridge2_clear" );
	flag_init( "beat2_river2_fight_activate" );
	flag_init( "beat2_river2_clear" );
	
	flag_init( "beat2_rice_vc_alert" );
	flag_init( "beat2_rice_attack_opportunity" );
	
	flag_init( "start_hey_charlie" );
	flag_init( "hut_kill_done" );
	
	flag_init( "head_to_rice_vc" );
	
	flag_init( "start_press_demo_fade_out" ); // -- WWILLIAMS: 4-19 PRESS DEMO
	flag_init( "stealth_fade_complete" ); // -- WWILLIAMS: 4-19 PRESS DEMO

	flag_init( "approaching_rice_eating_guy" );

	// beat 3
	flag_init( "player_on_boat" );
	// BEAT 3 - VILLAGE
	flag_init( "reveal_island_aa" );
	flag_init( "ambush_redshirt_move_up" );
	flag_init( "break_stealth" );
	flag_init( "ready_to_start_ambush" );
	flag_init( "plunger_to_player" );
	flag_init( "lewis_explosive_ready" );
	flag_init( "grenade_explode" );
	flag_init( "ambush_success" );
	flag_init( "ambush_fail" );
	flag_init( "demo_line_1_clear" );
	flag_init( "demo_line_1_backup_stop" );
	flag_init( "populate_line_2" );
	flag_init( "demo_line_2_clear" );
	flag_init( "demo_line_3_clear" );
	flag_init( "start_flamethrower" );
	flag_init( "demo_redshirt_burned" );
	flag_init( "rat_hole_1_started" );
	flag_init( "picked_up_flamethrower" );
	flag_init( "ridge_rat_hole_closed" );
	flag_init( "m202_can_die" );
	flag_init( "demo_line_4_clear" );
	flag_init( "get_on_mg" );
	flag_init( "waterhut_start" );
	flag_init( "demo_line_pre_5_clear" );
	flag_init( "demo_line_5_clear" );
	flag_init( "ridge_mg_start" );
	flag_init( "mg_eliminated" );
	flag_init( "ridge_spawning_stopped" );
	flag_init( "ridge_mg_cleared" );
	flag_init( "demo_line_6_clear" );
	flag_init( "mg_eliminated_by_m202" );
	flag_init( "player_exitted_last_hut" );
	
	flag_init( "first_village_area_cleared" );
	flag_init( "second_village_area_cleared" );
	flag_init( "village_aa_area_secured" );
	
	flag_init( "player_picks_up_m202_early" );
	flag_init( "aa_gunner_shot" );
	
	// BEAT 4
	flag_init( "b4_player_moved_forward" );
	flag_init( "b4_player_near_tunnel" );			
	flag_init( "b4_player_inside_tunnel" );	
	flag_init( "b4_room_1_cleared" );
	
	flag_init( "player_searched_entire_room" );
	flag_init( "recording_playback_finished" );
	flag_init( "player_escapes_war_room" );
	flag_init( "cave_fill_complete" );	
	flag_init( "cave_rock_swap" );
	
	flag_init( "rock_1_broken" );	
	flag_init( "rock_2_broken" );	
	flag_init( "rock_3_broken" );	
		
	flag_init( "tunnel_vc1_attack_end" );	
	flag_init( "tunnel_vc2_attack_end" );	
	
	flag_init( "barricade_pushed" );
	flag_init( "reznov_search_anim_should_finish" );
	flag_init( "reznov_search_anim_finish" );
	
	flag_init( "bomb_1_set" );
	flag_init( "player_give_knife_vo" );
	flag_init( "krav_lair_intro_done" );
	flag_init( "lair_explosion_starts" );
	flag_init( "escape_drop" );
	flag_init( "warroom_exit_door_kick" );
	
	flag_init( "creek_ending_fade" );
	
	flag_init( "escape_section_1" );
	flag_init( "escape_section_2" );
	flag_init( "escape_section_3" );
	flag_init( "escape_section_4" );
	
	SetSavedDvar( "phys_buoyancy", "1" );	
	SetSavedDvar( "phys_ragdoll_buoyancy", "1" );	
	
	level.CLIENT_SWIFT_BLEED = 2;
	
	// for achievement
	level.vc_stealth_killed = 0;
	level thread verify_knife_achievements();

// --------------------------------------------------------------------------------
// ---- EVENT 1 Helecopter Scene Setup ----
// --------------------------------------------------------------------------------
	maps\creek_1_start::event1_setup();

//////////////////////////////////////////////////////////////////////////
// FX INIT

	SetSavedDvar( "r_enableFlashlight","0" );
//////////////////////////////////////////////////////////////////////////
// PRECACHE

	PrecacheShader( "white" ); 
	level.introscreen_shader = "white";

	PrecacheModel( "viewmodel_usa_jungmar_wet_arms" );
	PreCacheModel( "viewmodel_usa_jungmar_wet_player" );
	PreCacheModel( "viewmodel_usa_jungmar_wet_player_fullbody" );
	level.player_viewmodel = "t5_gfl_ump45_viewmodel_player";
	// level.player_viewmodel = "viewmodel_usa_marine_arms";

	PreCacheModel( "c_usa_jungmar_mp_snip_fb" );

	// precache other models
	PrecacheModel( "tag_origin" );
	//PrecacheModel( "t5_veh_boat_pbr" );
	//PrecacheModel( "p_jun_sampan" );
	// PrecacheModel( "p_jun_sampan_large" );
	PreCacheModel( "t5_weapon_1911_world" );
	//PrecacheModel( "t5_weapon_bamboo_spear" );
	PreCacheModel( "t5_knife_sog" );
	//PrecacheModel( "p_glo_cigarette01" );
	PrecacheModel( "c_vtn_vc1_body" );
	PrecacheModel( "c_vtn_vc1_head" );
	PrecacheModel( "t5_weapon_viewmodel_flashlight" );

	PrecacheModel( "t5_weapon_commando_world" );
	PrecacheModel( "t5_weapon_ak47_world" );

	PreCacheString( &"CREEK_1_PRESS_MELEE");

	precacherumble( "damage_heavy" );
	precacherumble( "damage_light" );
	precacherumble( "grenade_rumble" );
	precacherumble( "tank_rumble" );
	precacherumble( "tank_fire" );
	precacherumble( "artillery_rumble" );
		
	// custom weapon attachments
	PreCacheItem( "ak47_acog_sp" );
	PreCacheItem( "ak47_extclip_sp" );
	PreCacheItem( "ak47_dualclip_sp" );
	PreCacheItem( "ak47_mk_sp" );
	PreCacheItem( "mk_ak47_sp" );
	PreCacheItem( "ak47_acog_extclip_sp" );
	PreCacheItem( "ak47_acog_dualclip_sp" );
	PreCacheItem( "ak47_acog_mk_sp" );
	PreCacheItem( "rpk_acog_sp" );
	PreCacheItem( "rpk_extclip_sp" );
	PreCacheItem( "rpk_acog_extclip_sp" );
	PreCacheItem( "skorpion_extclip_sp" );
	PreCacheItem( "commando_gl_sp" );
	PreCacheItem( "commando_acog_sp" );
	PreCacheItem( "commando_extclip_sp" );
	PreCacheItem( "commando_dualclip_sp" );
	PreCacheItem( "commando_mk_sp" );
	PreCacheItem( "mk_commando_sp" );
	PreCacheItem( "commando_silencer_sp" );
	PreCacheItem( "commando_acog_extclip_sp" );
	PreCacheItem( "commando_acog_dualclip_sp" );
	PreCacheItem( "commando_acog_mk_sp" );
	// PreCacheItem( "m8_white_smoke_sp" );
				
	// custom weapon for Woods
	// PreCacheItem( "commando_acog_gl_sp" );
	
	// Special
	PreCacheItem( "m202_flash_magic_bullet_sp" );
	PreCacheItem( "creek_satchel_charge_sp" );
	
	// M202 on marine's back
	PreCacheModel( "t5_weapon_m202_world" );
	PreCacheModel( "t5_weapon_m202_world_obj" );
	
	// knife for creek
	PreCacheItem( "creek_knife_sp" );
	PreCacheItem( "knife_creek_sp" );
	PreCacheModel( "t5_knife_animate" ); // used by AI
	PreCacheItem( "commando_silencer_sp" ); // -- WWILLIAMS: NEEDED FOR THE MAGICBULLET IN EVENT 2
	
	// Calvary
	PreCacheItem("huey_rockets");
	
	//script model guy in huey
	PreCacheModel("c_usa_huey_pilot1_fb");
	
	// precache throat cut head
	PreCacheModel( "c_vtn_vc3_head_neck_cut" );
	// hammock 1 head swap
	PreCacheModel( "c_vtn_vc2_head_sleeper_neck_cut" );
	// hammock 2 head swap
	// PreCacheModel( "c_vtn_vc3_head_neck_cut" ); // WWILLIAMS: SEEMS TO BE THE SAME AS THE GUY ON THE SAMPAN
	
	// precache satchel charge models
	//PreCacheModel( "weapon_satchel_charge_obj" );
	//PreCacheModel( "weapon_satchel_charge" );
	
	// hey charlie moment
	PreCacheModel( "t5_knife_animate" );
	
	PreCacheModel( "t5_veh_helo_huey_att_interior" );
	PreCacheModel( "t5_veh_helo_huey_att_rockets" );
	PreCacheModel( "t5_veh_helo_huey_att_decal_hvyhog" );
	PreCacheModel( "t5_veh_helo_huey_att_m60" );

	//PreCacheModel( "weapon_c4" );
	//PreCacheModel( "c_usa_jungmar_wet_bowman_backpack" );

	//character\c_usa_jungmar_assault::precache();
	//character\c_usa_jungmar_cqb::precache();
	//character\c_usa_jungmar_lmg::precache();
	//character\c_usa_jungmar_smg::precache();
	//character\c_usa_jungmar_snip::precache();
	character\c_vtn_vc1::precache();
	character\c_vtn_vc2::precache();
	character\c_vtn_vc3::precache();
	
	// allow AIs to use water trail wakes
	//SetDvar( "cg_ai_water_trails", 0 );
	
	// delete physics objects faster to help framerate
	//SetSavedDvar( "phys_buoyancyDistanceCutoff", 500 );
	//SetSavedDvar( "phys_piecesSpawnDistanceCutoff", 1200 );

//////////////////////////////////////////////////////////////////////////
// LEVEL PREP

	hut_door_closed = getent( "b2_hut_door_closed", "targetname" );
	hut_door_closed hide();
	hut_door_closed NotSolid();
	hut_door_closed ConnectPaths();
	
	flashlight = getent( "b4_flashlight_toss", "targetname" );
	flashlight SetModel( "t5_weapon_viewmodel_flashlight" );
	
	/*
	// hide temporary boats
	fake_boats = getentarray( "b2_pbr_drag_fakes", "targetname" );
	for( i = 0; i < fake_boats.size; i++ )
	{
		fake_boats[i] hide();
	}

	level thread test_melee_trigger();

	level.rope_1 = getent( "fxanim_creek_boatdrop_rope01_mod", "targetname" );
	level.rope_2 = getent( "fxanim_creek_boatdrop_rope02_mod", "targetname" );
	level.rope_1 hide();
	level.rope_2 hide();
	level.rope_end = getent( "fxanim_creek_boatdrop_rope01end_mod", "targetname" );
	level.rope_end Hide();
*/

	// hide the pbr sitting at the end
	//end_pbr = getent( "end_pbr", "targetname" );
	//end_pbr hide();

/*
	missile_base_d_1 = getent( "sam_1_base_d", "targetname" );
	missile_base_d_1 hide();

	missile_base_d_2 = getent( "sam_2_base_d", "targetname" );
	missile_base_d_2 hide();

	missile_base_d_3 = getent( "sam_3_base_d", "targetname" );
	missile_base_d_3 hide();
*/

	// block_pbr = getent( "pbr_final_block", "targetname" );
	// block_pbr NotSolid();
	// block_pbr Hide();

//////////////////////////////////////////////////////////////////////////
// SKIPTOS

	//-- Starts
	//add_start( "event_1_jumpto", ::event1_jumpto, &"CRASH" );
	add_start( "e2_stealth", ::event2a_jumpto, &"STEALTH" );
	add_start( "e3_village", ::event3_jumpto, &"VILLAGE" );
	add_start( "e4_tunnel", ::event4a_jumpto, &"TUNNELS" ); 
	add_start( "e5_warroom", ::event4b_jumpto, &"WAR_ROOM" ); 
	add_start( "e5_ending", ::event4c_jumpto, &"ENDING" ); 

	default_start( maps\creek_1_start::main, true );

	// USE THIS TO LAUNCH DIRECTLY TO PHASE 2
	//default_start( maps\creek_1::event5_jumpto, true );

//////////////////////////////////////////////////////////////////////////
// OTHER INITS

	// -- WWILLIAMS: Hiding Door
	// level maps\_hiding_door::door_main();
	level maps\_hiding_door::window_main();

	maps\_load::main();
	maps\_compass::setupMiniMap("compass_map_sp_creek_1"); 
	
	enable_random_alt_weapon_drops(); 
	set_random_alt_weapon_drops( "ft", false ); // disable the flamethrower alt weapon
	set_random_alt_weapon_drops( "gl", true ); // enable the grenade launcher alt weapon
	set_random_alt_weapon_drops( "mk", true ); // enable the masterkey alt weapon
	
	// door breach init
	level thread maps\_door_breach::door_breach_init( "t5_gfl_ump45_viewmodel_player" );
	
// --------------------------------------------------------------------------------
// ---- EVENT 1 Helecopter Scene Meatshield Setup ----
// --------------------------------------------------------------------------------
	maps\creek_1_start::event1_extra_setup();

	// civilians init function. // -- WWILLIAMS: Turning this back on for the civs in the village assault
	maps\_civilians::init_civilians();
	
	//maps\_contextual_melee::add_scripted_melee("creeksampanmelee", %int_sampan_melee, %ai_sampan_melee);

	level thread maps\creek_1_fx::initModelAnims_delay();
	
	maps\creek_1_amb::main();
	maps\creek_1_anim::main();
	maps\creek_1_spawn_func::main();
	maps\creek_1_livestock::critters_init();
	
	// -- WWILLIAMS: Rusher init
	level maps\_rusher::init_rusher();

	// turn water simulation on
	//WaterSimEnable(true); 

	// slow down swim speed
	SetDvar( "player_waterSpeedScale", 0.65 );
	
	// wait for new executables before doing this
	//SetDvar( "cg_waterTrailRipple", 0 );

	
	// make the player not bob too much in water
	//SetDvar( "bg_viewBobAmplitudeSwimming", 3, 2 );

	// no revive
	disable_ai_revive();

	// roughout Billboard
	//level create_billboard();

	// for sun brightness fade in and out
	level thread alternating_vision_set();

	// wait until players are all connected
	flag_wait( "all_players_connected" );
	flag_wait( "all_players_spawned" );

	// configure boats with triggers
	level pbrs_setup();

	level global_creek_heroes_setup();
	
	level thread maps\creek_1_fx::player_show_hide_rain_fx();

	//TUEY - Defaulting BC to "OFF" due to stealth sections.
	battlechatter_off();

	// hatch setup for b4
	hatch = getent( "rat_tunnel_door", "targetname" );
	if( isdefined( hatch ) )
	{
		hatch delete();
	}
	
	// force the mountain to draw
	mountain = getent( "mountain", "targetname" );
	if( isdefined( mountain ) )
	{
		mountain SetForceNoCull();
	}
	
	//backpack = GetEnt( "mdl_bowman_packback", "targetname" );
	//backpack Delete();
	
	// clean up entities
	level thread clean_up_after_intro();
	level thread clean_up_after_regroup();
	level thread clean_up_after_drop_into_water();
	level thread clean_up_after_drop_into_village_battle();
	level thread clean_up_after_mg_dropdown();
	level thread clean_up_after_village_battles();
}
needledrop()
{
	wait(1);	
	if(!IsDefined ( level.music_ent ) )
	{				
		level.music_ent = spawn ("script_origin", (	-33632, 37368, 128));
		level.music_ent playsound ("mus_the_letter");
	}									
//playsoundatposition ("mus_the_letter", (-33632, 37368, 128));
	level waittill("water_coming");
	level.music_ent stopsounds();
	level.music_ent delete();
	playsoundatposition ("evt_electrical_spark", (0,0,0));
	

	
}



//////////////////////////////////////////////////////////////////////////
// SKIPTOS



event1_jumpto() 
{
	level.skipped_to_event_1 = true;
	start_teleport( "beat_1_jumpto", "friendly_squad" );
	level thread maps\creek_1_start::main();
}

event2a_jumpto()
{
	flag_wait( "hero_setup_done" );
	level.skipped_to_event_2 = true;
	level.section2 = "start";
	
	player = get_players()[0];
	player TakeAllWeapons();
	player GiveWeapon( "knife_sp", 0 );
	player GiveWeapon( "ak47_sp", 0 );
	player SwitchToWeapon( "ak47_sp" );
	
	teleport_first_player( "b2_player_start" );
	teleport_ai_single( "barnes_ai", "b2_barnes_start_0" );
	teleport_ai_single( "hudson", "b2_hudson_start" );
	teleport_ai_single( "reznov_ai", "b2_reznov_start" );
	level thread maps\creek_1_stealth::main();
}

event2b_jumpto()
{
	level.skipped_to_event_2 = true;
	level.section2 = "2b";
	
	teleport_first_player( "b2_player_start2" );
	teleport_ai_single( "barnes_ai", "b2_barnes_start2" );
	teleport_ai_single( "hudson", "b2_hudson_start2" );
	teleport_ai_single( "reznov_ai", "b2_reznov_start2" );
	level thread maps\creek_1_stealth::main();
}

event3_jumpto() 
{
	flag_wait( "hero_setup_done" );
	
	door = getent( "b2_large_hut_door_left", "targetname" );
	door ConnectPaths();
	door RotateYaw( 85, 0.5 );	

	level.skipped_to_event_3 = true;
	level.section = "continue";
	level.barnes thread hold_fire();
	level.hudson thread hold_fire();
	level.reznov thread hold_fire();
	teleport_ai_single( "barnes_ai", "node_barnes_start_beat_3" );
	teleport_ai_single( "hudson", "b3_lewis_ambush_teleport" );
	// teleport_ai_single( "reznov_ai", "node_reznov_start_beat_3" );
	start_teleport( "beat_3_jumpto" );
	
	level thread maps\creek_1_assault::main();
}

event3b_jumpto()
{
	start_teleport( "beat_3b_jumpto" );
	level.skipped_to_event_3 = true;
	flag_set( "ridge_rat_hole_closed" );
}

event4a_jumpto() 
{
	flag_wait( "hero_setup_done" );
	level.skipped_to_event_4 = true;
	level.section4 = "start";
	teleport_first_player( "player_b4_tunnel_start" );
	teleport_ai_single( "reznov_ai", "reznov_b4_tunnel_start" );
	teleport_ai_single( "barnes_ai", "b4_barnes_gate_start" );
	teleport_ai_single( "hudson", "b4_hudson_gate_start" );
	level thread maps\creek_1_tunnel::main();
}

event4b_jumpto() 
{
	flag_wait( "hero_setup_done" );
	level.skipped_to_event_4 = true;
	level.section4 = "4b";
	teleport_first_player( "player_outside_warrromm" );
	teleport_ai_single( "reznov_ai", "reznov_b4_tunnel_room2" );
	flag_set( "b4_room_1_cleared" ); 
	
	level thread maps\creek_1_tunnel::main();
}

event4c_jumpto() 
{
	door = getent( "war_room_exit", "targetname" );
	door delete();
	
	flag_wait( "hero_setup_done" );
	level.skipped_to_event_4 = true;
	level.section4 = "4b";
	teleport_first_player( "player_b4_tunnel_room2" );
	teleport_ai_single( "reznov_ai", "reznov_b4_tunnel_room2" );
	flag_set( "b4_room_1_cleared" ); 
	
	level thread maps\creek_1_tunnel::main();
}


//////////////////////////////////////////////////////////////////////////
// PBR SETUP


// Add BOAT BOAT triggers to the sides of each pbr
// Add NO JUMP trigger on the deck of each pbr
// Prevent pbrs from dying
pbrs_setup()
{
	boats = GetEntArray("player_boat","script_noteworthy");
	players = get_players();

	for(i=0; i < boats.size; i++)
	{

		jump_trigger = GetEnt(boats[i].targetname+"_attach", "targetname");
		jump_trigger enablelinkto();
		jump_trigger linkto(boats[i]);

		board_left = GetEnt(jump_trigger.target,"targetname");
		board_left enablelinkto();
		board_left linkto(boats[i]);

		board_right = GetEnt(board_left.target,"targetname");
		board_right enablelinkto();
		board_right linkto(boats[i]);

		trigger_origin = GetEnt(board_right.target,"targetname");
		trigger_origin linkto(boats[i]);

		boats[i].target = trigger_origin.targetname;
		board_left.target = trigger_origin.targetname;
		board_right.target = trigger_origin.targetname;

		board_left thread pbr_board_left_side();
		board_right thread pbr_board_right_side();

		boats[i] thread pbr_magic_bullet_shield();
	}
}

pbr_board_left_side()
{
	origin = GetEnt(self.target,"targetname");
	while(1)
	{
		self waittill("trigger",player);
		player setorigin(origin.origin);
		player setplayerangles(origin.angles ); 
	}
}

pbr_board_right_side()
{
	origin = GetEnt(self.target,"targetname");
	while(1)
	{
		self waittill("trigger",player);
		player setorigin(origin.origin);
		player setplayerangles(origin.angles ); 
	}
}

pbr_magic_bullet_shield()
{
	self endon("death");

	while(1)
	{
		self.health = 99999;
		wait(.1);
	}
}

//////////////////////////////////////////////////////////////////////////
// PBR SETUP

// This is shared by all the events in creek
global_creek_heroes_setup()
{
	// HUdson is already in the level
	level.hudson = getent( "hudson", "targetname" );
	
	// Reznov and Barnes need to be spawned, in creek_1_start prefab
	level.reznov = simple_spawn_single( "reznov" );
	level.barnes = simple_spawn_single( "barnes" );

	level.barnes make_hero();
	level.hudson make_hero();
	level.reznov make_hero();
	
	// Since it's possible (Bugged) to kill magic bullet shield guys with M202
	// we need to do this to prevent them from getting killed randomly
	// level.barnes.takedamage = false;
	// level.hudson.takedamage = false;
	// level.reznov.takedamage = false;
	
	level.barnes hold_fire();
	level.hudson hold_fire();
	level.reznov hold_fire();
	
	level.barnes.animname = "barnes";
	level.hudson.animname = "hudson";
	level.reznov.animname = "reznov";
	
	// Need to wait a little before name change can occur
	level.barnes.name = "Woods";
	level.hudson.name = "Bowman";
	level.reznov.name = "Reznov";
	
	level.reznov wont_disable_player_firing();

	//level.reznov thread maps\creek_1_anim::reznov_unarmed_anims_setup();
	//level.barnes gun_switchto( "commando_acog_gl_sp", "right" );
	
	/*
	// give Woods new weapon (We really need a better way to handle this in the future)
	level.barnes animscripts\shared::detachAllWeaponModels();
  level.barnes animscripts\shared::detachWeapon( level.barnes.primaryweapon );
	level.barnes.primaryweapon = "commando_acog_gl_sp";
	level.barnes animscripts\init::initWeapon( level.barnes.primaryweapon );
	level.barnes animscripts\shared::placeWeaponOn( level.barnes.primaryweapon, "right");
	level.barnes.weapon = level.barnes.primaryweapon;
	level.barnes animscripts\weaponList::RefillClip();
	*/
	
	flag_set( "hero_setup_done" );
}



//////////////////////////////////////////////////////////////////////////
// VISIONSET


alternating_vision_set()
{
	vision_set_bright_duration_min = 7;
	vision_set_bright_duration_max = 7;
	vision_set_dark_duration_min = 7;
	vision_set_dark_duration_max = 7;

	while( true )
	{		
		//iprintlnbold( "bright" );
		//SetSavedDvar( "r_lightTweakSunLight", 18 );
		// start with bright vision set
		duration = randomfloat( vision_set_bright_duration_max - vision_set_bright_duration_min ) + vision_set_bright_duration_min;
		wait( duration );

		// change to dark vision set
		clientNotify( "change_vision_set" ); 

		//SetSunLight( 0.1, 0.1, 0.1 );

		//iprintlnbold( "dark" );
		//SetSavedDvar( "r_lightTweakSunLight", 5 );
		duration = randomfloat( vision_set_dark_duration_max - vision_set_dark_duration_min ) + vision_set_dark_duration_min;
		wait( duration );

		// change back to bright
		clientNotify( "change_vision_set" ); 

		//SetSunLight( 0.8, 0.8, 0.8 );
	}
}


// Level entities clean up

clean_up_after_intro()
{
	flag_wait( "beat_2_starts" );
		
	clear_entities( "meatshield_start" );
	clear_entities( "trig_lookat_woods_grab" );
}

clean_up_after_regroup()
{
	flag_wait( "hut_kill_done" );
		
	clear_entities( "trig_start_beat2_ridge1_vc" );
	clear_entities( "b2_get_on_shore" );
	clear_entities( "b2_move_barnes_begin_0" );
	clear_entities( "trigger_setup_beat2_river2" );
	clear_entities( "b2_move_barnes_begin" );
	clear_entities( "trigger_overlooking_river2" );
	clear_entities( "b2_move_barnes_begin_2" );
	clear_entities( "trigger_give_knife" );
	clear_entities( "start_rain" );
	clear_entities( "b2_player_no_weapons" );
	clear_entities( "b2_close_to_gap" );
	clear_entities( "b2_reveal_player_start_trig" );
	clear_entities( "b2_drag_vc_in_water" );
	clear_entities( "b2_vc_sampan_stealth_broken" );
	clear_entities( "b2_hut_barnes_move_up" );
	clear_entities( "trig_player_in_charlie_hut" );
	clear_entities( "b2_player_enters_hut" );
	clear_entities( "b2_start_light_rain" );
	clear_entities( "b2_start_heavy_rain" );
	
	// spawners
	clear_entities( "meatshield_vc" );
	clear_entities( "ai_meatshield" );
	clear_entities( "b2_ridge_vc_top" );
	clear_entities( "beat2_ridge1_backup_spawners" );
	clear_entities( "beat2_river1_battle" );
}

clean_up_after_drop_into_water()
{
	trigger_wait( "b2_obj_trigger_1" );
	
	clear_entities( "objective_b2_1b" );
	clear_entities( "b2_stealth_trigger_1e" );
	clear_entities( "b2_satchel_set" );
	clear_entities( "b2_satchel" );
	clear_entities( "b2_satchel_old" );
	clear_entities( "b2_player_cleared_window" );
	//clear_entities( "b2_player_get_on_island" );
	clear_entities( "b2_chicken_island" );
	clear_entities( "b2_curtains_trigger" );
	clear_entities( "b2_vc_sleeping_1_ai" );
	clear_entities( "b2_vc_sleeping_2_ai" );
	clear_entities( "objective_b2_1c" );
	clear_entities( "b2_rice_contextual" );
	clear_entities( "sampan1" );
	clear_entities( "sampan2" );
	clear_entities( "sampan3" );
	clear_entities( "sampan4" );
	clear_entities( "b2_sampan_kill_detected" );
	
	clear_entities( "b2_vc_sampan_1" );
	clear_entities( "b2_vc_sampan_2" );
	clear_entities( "b2_vc_hut_1" );
	clear_entities( "b2_vc_hut_2" );
	clear_entities( "b2_vc_sleeping_1" );
	clear_entities( "b2_vc_sleeping_2" );
	//clear_entities( "b2_vc_chef_1" );
	//clear_entities( "b2_vc_chef_2" );	
	
	if( isdefined( level.temp_vo_origin_pos ) )
	{
		level.temp_vo_origin_pos delete();
	}
}

clean_up_after_drop_into_village_battle()
{
	trigger_wait( "end_rain" );
	
	clear_entities( "b2_vc_rice_gun" );
	clear_entities( "b2_vc_rice_ai" );
	clear_entities( "b2_vc_sniped_1_ai" );
	clear_entities( "b2_vc_sniped_2_ai" );
	clear_entities( "b2_obj_trigger_1" );
	clear_entities( "b2_satchel_set_2" );
	clear_entities( "b2_satchel_2" );
	clear_entities( "b2_satchel_old_2" );
	clear_entities( "objective_b2_1d" );
	clear_entities( "b2_window_pop_trigger" );
	clear_entities( "b2_stealth_trigger_7b" );
	clear_entities( "b2_stealth_trigger_7c" );
	clear_entities( "beat2_drop_body_trigger" );
	clear_entities( "b2_stealth_trigger_8" );
	clear_entities( "b2_stealth_trigger_8_ladder" );
	clear_entities( "trigger_spawn_intro_vcs" );
	clear_entities( "b2_stealth_trigger_10" );
	clear_entities( "be_inside_of_regroup_hut" );
	clear_entities( "b2_chicken_group_0" );
	clear_entities( "b2_fish_move1" );
	clear_entities( "b2_bridge_look" );
	clear_entities( "start_village_visionset" );
	clear_entities( "b2_vc_drop_water_look" );
	clear_entities( "b2_vc_drop_water_look_2" );
	
	clear_entities( "b2_vc_rice" );
	clear_entities( "b2_vc_sniped_1" );	
	clear_entities( "b2_vc_sniped_2" );		
	clear_entities( "b2_vc_sniped_3" );	
	clear_entities( "b2_vc_drop_water" );	
}

clean_up_after_mg_dropdown()
{
	trigger_wait( "trigger_start_mg_ridge", "script_noteworthy" );
	
	clear_entities( "objective_b2_1e" );
	clear_entities( "b2_chicken_group_1_trigger" );
	clear_entities( "village_pigs_walk_trigger" );
	clear_entities( "b2_chicken_group_1" );
	clear_entities( "b2_pigs_group_1" );
	clear_entities( "trig_start_lewis_distraction" );
	clear_entities( "b2_chicken_group_2" );
	clear_entities( "objective_b2_2a" );
	clear_entities( "b2_break_stealth_1_force" );
	clear_entities( "b2_chicken_group_3a_trigger" );
	clear_entities( "objective_b2_4e" );
	clear_entities( "b2_chicken_group_3b_trigger" );
	clear_entities( "b2_chicken_group_3a" );
	clear_entities( "b2_chicken_group_3_trigger" );
	clear_entities( "objective_b2_2b" );
	clear_entities( "b2_chicken_group_3b" );
	clear_entities( "b2_chicken_group_3" );
	clear_entities( "trig_setup_beat_3_intro" );
	clear_entities( "end_rain" );
	clear_entities( "trigger_start_redshirts_for_ambush" );
	clear_entities( "trigger_reset_village_art" );
	clear_entities( "trigger_start_roof_rpg_box" );
	clear_entities( "b2_chicken_group_2_trigger" );
	clear_entities( "b2_pigs_group_1_trigger" );
	clear_entities( "b2_alert_vc_1" );
	clear_entities( "b3_ambush_fc_1" );
	clear_entities( "b3_move_up_to_bridge" );
	clear_entities( "line_1_backup_manager_start" );
	clear_entities( "b3_zone_0" );
	clear_entities( "b2_village_spawn_additional_ais" );
	clear_entities( "trigger_approach_shore" );
	clear_entities( "b3_zone_1" );
	clear_entities( "trigger_start_shoreline" );
	clear_entities( "line_1_backup_manager_stop" );
	clear_entities( "b2_village_fc4" );
	clear_entities( "b2_village_rathole_spawn_1new" );
	clear_entities( "b2_village_spawn_ridge" );
	clear_entities( "b3_zone_2" );
	clear_entities( "b3_zone_3b" );
	clear_entities( "trigger_objective_village_main_road" );
	clear_entities( "b3_zone_3" );
	clear_entities( "trigger_start_line_5" );
	clear_entities( "b3_close_to_drop_guy" );
	clear_entities( "trigger_window_shooter_line_3_lookat" );
	clear_entities( "trigger_drop_the_coop" );
	clear_entities( "trigger_overhang_collapse" );
	clear_entities( "trigger_window_shooter_line_3" );
	clear_entities( "trigger_last_hiding_door" );
	clear_entities( "trigger_rathole" );
	clear_entities( "b3_close_to_roof" );
	clear_entities( "rattunnel_2_explosion_damage" );
	clear_entities( "rattunnel_1_explosion_damage" );
	clear_entities( "village_aa_damage_trig" );
	clear_entities( "aa_island_cover" );
	clear_entities( "vehicle_sampan_attack" );
	clear_entities( "model_sampan_for_landing" );
	clear_entities( "water_explosion" );
	clear_entities( "huey5_inside_trigger" );
	clear_entities( "trigger_fire_surprise_shot" );
	clear_entities( "trigger_start_line_4" );
	clear_entities( "trigger_aa_dialogue" );
	clear_entities( "sm_after_calvary" );
	clear_entities( "trigger_calvary" );
	clear_entities( "trigger_damage_waterhut_aa" );
	clear_entities( "trigger_blow_wooden_island" );
	clear_entities( "aa_gun_dead" );
}

clean_up_after_village_battles()
{
	flag_wait( "b4_player_near_tunnel" );	
	
	clear_entities( "objective_b2_4d" );
	clear_entities( "objective_b2_2c" );
	clear_entities( "trig_to_last_door" );
	clear_entities( "trig_bottom_of_ridge_hill" );
	clear_entities( "b3_enter_single_hut" );
	clear_entities( "trigger_move_to_ridge_hut" );
	clear_entities( "trig_stop_ridge_spawning" );
	clear_entities( "b3_near_mg" );
	clear_entities( "trigger_move_to_ridge_hut_2" );
	clear_entities( "trigger_dmg_ridge_rathole" );
	clear_entities( "rathole_manager_line_3" );
	clear_entities( "b3_zone_ridge" );
	clear_entities( "trigger_start_line_6" );
	clear_entities( "trig_temp_beat_3_ending" );
	clear_entities( "trigger_auto_kill_ridge_roof" );
	clear_entities( "mg_area_clearing" );
}