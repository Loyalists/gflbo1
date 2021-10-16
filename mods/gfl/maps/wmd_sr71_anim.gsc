#include maps\_utility;
#include maps\_anim;
#include maps\wmd_sr71_util;
#include common_scripts\utility;

#using_animtree ("generic_human");
main()
{
	precache_level_anims();
	precache_patrol_anims();
	sr71_intro_sounds();
}

#using_animtree("wmd_sr71");
precache_player_anims()
{
	// NEW SR-71 Intro
	
	// PLAYER
	level.scr_model["player_pilot_body"] = "viewmodel_usa_sr71_pilot_player_fullbody"; 
	level.scr_animtree[ "player_pilot_body" ] = #animtree;
	level.scr_animtree["player_body"] = #animtree;
	
	level.scr_model["player_pilot_hands"] = "viewmodel_usa_sr71_pilot_player";
	level.scr_animtree["player_pilot_hands"] = #animtree;
	
	level.scr_anim["player_body"]["intro"] = %ch_wmd_b01_sr71_intro_cam01;	
	level.scr_anim["player_body"]["intro_cam1_loop"][0] = %ch_wmd_b01_sr71_intro_cam01_loop;		
	level.scr_anim["player_body"]["intro_cam2"] = %ch_wmd_b01_sr71_intro_cam02;

	// Takeoff control anims
	level.scr_anim["player_pilot_body"]["sr71_intro"] = %ch_wmd_b01_sr71intro_player;
	addNotetrack_customFunction("player_pilot_body", "start_vo", ::start_vo, "sr71_intro");
	addNotetrack_customFunction("player_pilot_body", "rumble1", ::intro_rumble1, "sr71_intro");
	addNotetrack_customFunction("player_pilot_body", "rumble2", ::intro_rumble2, "sr71_intro");
		
	level.scr_anim["player_pilot_body"]["sr71_cockpit_idle"][0] = %ch_wmd_b01_sr71pilot_idle_player;
	level.scr_anim["player_pilot_body"]["sr71_cockpit_throttle"] = %ch_wmd_b01_sr71pilot_throttle_player;
	level.scr_anim["player_pilot_body"]["sr71_cockpit_pullback"] = %ch_wmd_b01_sr71pilot_pullback_player;
	level.scr_anim["player_pilot_body"]["sr71_cockpit_neutral"] = %ch_wmd_b01_sr71pilot_neutral_player;
	
	// RSO control anims 
	level.scr_anim["player_pilot_body"]["sr71_RSO_startup"] = %ch_wmd_b01_RSO_leadin_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_idle"] = %ch_wmd_b01_RSO_idle_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_move_down"] = %ch_wmd_b01_RSO_joystickDn_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_move_left"] = %ch_wmd_b01_RSO_joystickLe_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_move_right"] = %ch_wmd_b01_RSO_joystickRi_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_move_up"] = %ch_wmd_b01_RSO_joystickUp_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_twitch"] = %ch_wmd_b01_RSO_twitch_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_zoom_in"] = %ch_wmd_b01_RSO_zoomIn_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_zoom_out"] = %ch_wmd_b01_RSO_zoomOut_player;
	level.scr_anim["player_pilot_body"]["sr71_RSO_neutral"] = %ch_wmd_b01_RSO_neutral_player;

	level.scr_anim["player_pilot_body"]["trans_cam1"] = %ch_wmd_b01_sr71_trans_cam01;
	addNotetrack_customFunction("player_pilot_body", "jumpcut", ::space_snap2sr71, "trans_cam1");

	level.scr_anim["player_pilot_hands"]["trans_cam2"] = %ch_wmd_b01_sr71_trans_cam02;
	addNotetrack_customFunction("player_pilot_hands", "space2backin", ::space2backin, "trans_cam2");
	
	addNotetrack_customFunction("player_pilot_body", "canopy_shut_start", ::sr71_canopy_shut_start, "sr71_intro");
	addNotetrack_customFunction("player_pilot_body", "canopy_shut_end", ::sr71_canopy_shut_end, "sr71_intro");

	level.scr_model["player_sr71_3rdPerson_full_body"] = "c_usa_sr71_pilot_fb";
	level.scr_anim["player_sr71_3rdPerson_full_body"]["sr71_cockpit_idle"][0] = %ch_wmd_b01_sr71_pilotidle;
	level.scr_anim["player_sr71_3rdPerson_full_body"]["sr71_rso_idle"][0] = %ch_wmd_b01_sr71_copilotidle;
	level.scr_anim["player_sr71_3rdPerson_full_body"]["sr71_cockpit_look"] = %ch_wmd_b01_sr71_pilotLook;
	level.scr_animtree["player_sr71_3rdPerson_full_body"]  = #animtree;

	level.scr_anim["pilot"]["sr71_pilot_loop"][0] = %ch_wmd_b01_sr71_pilotidle;
	level.scr_anim["operator"]["sr71_operator_loop"][0] = %ch_wmd_b01_sr71_copilotidle;


	// SR71
	level.scr_animtree[ "sr71" ] = #animtree;
	
	// Non-control anims
	level.scr_anim["sr71"]["sr71_intro"] = %v_wmd_b01_sr71intro_sr71;
	level.scr_anim["sr71"]["sr71_idle"] = %v_wmd_b01_sr71intro_idleDials_sr71;
	level.scr_anim["sr71"]["sr71_thrust"] = %v_wmd_b01_sr71intro_thrustDials_sr71;
	level.scr_anim["sr71"]["sr71_liftoff_neutral"] = %v_wmd_b01_sr71intro_neutralDials_sr71;
	level.scr_anim["sr71"]["sr71_liftoff"] = %v_wmd_b01_sr71intro_liftoffDials_sr71;
	level.scr_anim["sr71"]["sr71_landing_gear_up"][0] = %v_wmd_sr71_landing_gear_up;
	
	// Takeoff control anims
	level.scr_anim["sr71"]["sr71_cockpit_throttle"] = %ch_wmd_b01_sr71pilot_throttle_player;

	// RSO control anims 
	level.scr_anim["sr71"]["sr71_RSO_startup"] = %ch_wmd_b01_RSO_leadin_sr71;
	level.scr_anim["sr71"]["sr71_RSO_idle"] = %ch_wmd_b01_RSO_idle_sr71;
	level.scr_anim["sr71"]["sr71_RSO_move_down"] = %ch_wmd_b01_RSO_joystickDn_sr71;
	level.scr_anim["sr71"]["sr71_RSO_move_left"] = %ch_wmd_b01_RSO_joystickLe_sr71;
	level.scr_anim["sr71"]["sr71_RSO_move_right"] = %ch_wmd_b01_RSO_joystickRi_sr71;
	level.scr_anim["sr71"]["sr71_RSO_move_up"] = %ch_wmd_b01_RSO_joystickUp_sr71;
	level.scr_anim["sr71"]["sr71_RSO_twitch"] = %ch_wmd_b01_RSO_twitch_sr71;
	level.scr_anim["sr71"]["sr71_RSO_zoom_in"] = %ch_wmd_b01_RSO_zoomIn_sr71;
	level.scr_anim["sr71"]["sr71_RSO_zoom_out"] = %ch_wmd_b01_RSO_zoomOut_sr71;
	level.scr_anim["sr71"]["sr71_RSO_neutral"] = %ch_wmd_b01_RSO_neutral_sr71;
	
	
	// RSO FPS prop anims
	level.scr_anim["door"]["safehouse_fps_intro"] = %o_wmd_b01_weaversignalkill_door;
	addNotetrack_exploder( "door", "snow_fx_on", 600, "safehouse_fps_intro" );
	addNotetrack_stop_exploder( "door", "snow_fx_off", 600, "safehouse_fps_intro" );
	
}


intro_rumble1(guy)
{
	get_players()[0] PlayRumbleOnEntity("reload_small");
}


intro_rumble2(guy)
{
	get_players()[0] PlayRumbleOnEntity("reload_small");
}


start_vo(guy)
{
	level thread do_pre_engine_dialog();
}


do_pre_engine_dialog()
{
	level endon( "engines_hit" );
	
	//wait(1);
	
	sr71 = GetEnt("sr71", "targetname");
	
	sr71 anim_single(sr71, "001A_usc1_f" );
	sr71 anim_single(sr71, "002A_usc3_f" );
//	sr71 anim_single(sr71, "003A_usc2_f" );
	sr71 anim_single(sr71, "004A_usc1_f" );
	sr71 anim_single(sr71, "005A_usc3_f" );
	sr71 anim_single(sr71, "006A_usc3_f" );
	sr71 anim_single(sr71, "007A_usc1_f" );
//	sr71 anim_single(sr71, "008A_usc2_f" );
//	sr71 anim_single(sr71, "009A_usc1_f" );
	
	get_players()[0] notify( "dialog_done" );
	
	flag_set( "pre_engine_dialog_done" );
}

#using_animtree( "generic_human" );
precache_level_anims()
{
	precache_player_anims();

	level.scr_model["sr71_rso"] = "c_usa_sr71_pilot_fb";
	level.scr_animtree["sr71_rso"] = #animtree;
	
	level.scr_model["sr71_crew1"] = "t5_gfl_p90_body";
	level.scr_model["sr71_crew2"] = "t5_gfl_m1903_body";
	level.scr_model["sr71_crew3"] = "t5_gfl_rfb_body";
	level.scr_model["sr71_crew4"] = "t5_gfl_suomi_body";
	level.scr_model["sr71_crew5"] = "t5_gfl_9a91_body";
	level.scr_model["sr71_crew6"] = "t5_gfl_ppsh41_body";
	level.scr_model["sr71_crew7"] = "t5_gfl_type97_body";
	level.scr_model["sr71_crew8"] = "t5_gfl_9a91_body";

	for( i = 1; i < 9; i++ )
	{
		// level.scr_model["sr71_crew"+i] = "c_usa_sr71_groundcrew_body";
		level.scr_animtree["sr71_crew"+i] = #animtree;
	}

	level.scr_anim["sr71_rso"]["sr71_intro"]	= %ch_wmd_b01_sr71intro_rso;
	level.scr_anim["sr71_crew1"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew01;
	level.scr_anim["sr71_crew2"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew02;
	level.scr_anim["sr71_crew3"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew03;
	level.scr_anim["sr71_crew4"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew04;
	level.scr_anim["sr71_crew5"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew05;
	level.scr_anim["sr71_crew6"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew06;
	level.scr_anim["sr71_crew7"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew07;
	level.scr_anim["sr71_crew8"]["sr71_intro"] = %ch_wmd_b01_sr71intro_crew08;
	
	//vehicle pilot
//	level.scr_anim["pilot"]["sr71_pilot_loop"][0] = %ch_wmd_b01_sr71_pilotidle;
//	level.scr_anim["operator"]["sr71_operator_loop"][0] = %ch_wmd_b01_sr71_copilotidle;
	
	//door kick
	level.scr_anim["generic"]["kick_door1"] = %ch_scripted_tests_b0_coveralign;
	level.scr_anim["generic"]["kick_door2"] = %ch_scripted_tests_b0_coveralign;
	addNotetrack_customFunction("generic", "doorkick", ::kick_door1, "kick_door1");
	addNotetrack_customFunction("generic", "doorkick", ::kick_door2, "kick_door2");
	
	level.scr_anim["generic"]["door_kick"] = %ai_doorbreach_kick;
	
		// NEW SR-71 Intro
	level.scr_anim["barracks"]["sleep_0"][0] = %ch_incubator_wounded_guy_resting;
	
	level.scr_anim["left_breach_guy"]["door_breach"] 		= %ch_quag_b06_doorbreach_guy1;
	level.scr_anim["right_breach_guy"]["door_breach"] 	= %ch_quag_b06_doorbreach_guy2;	
	
	// Patroller deaths
	
	level.scr_anim["generic"]["first_death"] = %ai_death_fallforward;
	level.scr_anim["generic"]["first_death_loop"][0] = %ch_wmd_b01_dead_fallforward_loop;
	level.scr_anim["generic"]["second_death"] = %ai_death_fallforward_b;
	level.scr_anim["generic"]["second_death_loop"][0] = %ch_wmd_b01_dead_fallforward_b_loop;
	
	level.scr_anim["generic"]["cqb_patrol_1"] = %run_CQB_F_search_v1;
	level.scr_anim["generic"]["cqb_patrol_2"] = %run_CQB_F_search_v2;

	// safehouse fps anims
	
	level.scr_model["fps_player_body"] = level.player_interactive_model;
	level.scr_animtree["fps_player_body"] = #animtree;
	level.scr_anim["fps_player_body"]["safehouse_fps_setup"][0] = %ch_wmd_b01_weaversignalkill_loop_player;
	level.scr_anim["weaver"]["safehouse_fps_setup"][0] = %ch_wmd_b01_weaversignalkill_loop_weaver;
	
	level.scr_anim["fps_player_body"]["safehouse_fps_intro"] = %ch_wmd_b01_weaversignalkill_player;
	addNotetrack_customFunction("fps_player_body", "reset_dof", ::reset_dof, "safehouse_fps_intro");

	level.scr_anim["weaver"]["safehouse_fps_intro"] = %ch_wmd_b01_weaversignalkill_weaver;
	addNotetrack_customFunction("weaver", "door_open", ::weaver_door_snow, "safehouse_fps_intro");
	level.scr_anim["soldier1"]["safehouse_fps_intro"] = %ch_wmd_b01_weaversignalkill_sld01;
	level.scr_anim["soldier2"]["safehouse_fps_intro"] = %ch_wmd_b01_weaversignalkill_sld02;
	
	// barracks fps anims
	
	level.scr_model["fps_player_body"] = level.player_interactive_model;
	level.scr_animtree["fps_player_body"] = #animtree;	
	level.scr_anim["fps_player_body"]["weaver_player_breach"] = %ch_wmd_b01_weaverdoorbreach_player;
	level.scr_anim["weaver"]["weaver_player_breach"] = %ch_wmd_b01_weaverdoorbreach_weaver;
	addNotetrack_customFunction("weaver", "kill_smoker", ::weaver_kill_smoker, "weaver_player_breach");
	level.scr_anim["brooks"]["brooks_harris_breach"] = %ch_wmd_b01_brooksdoorbreach;
	level.scr_anim["harris"]["brooks_harris_breach"] = %ch_wmd_b01_harrisdoorbreach;

	level.scr_anim["generic"]["first_chair"] = %ch_wmd_b01_chairbreach_guards_grd01;
	level.scr_anim["generic"]["first_chair_loop"][0] = %ch_wmd_b01_chairbreach_guards_idle_grd01;
	level.scr_anim["generic"]["second_chair"] = %ch_wmd_b01_chairbreach_guards_grd02;
	level.scr_anim["generic"]["second_chair_loop"][0] = %ch_wmd_b01_chairbreach_guards_idle_grd02;
	
	level.scr_anim["generic"]["bunk1"] = %ch_wmd_b01_sleepguards_grd01;
	level.scr_anim["generic"]["bunk2"]	= %ch_wmd_b01_sleepguards_grd02;
	level.scr_anim["generic"]["bunk3"] = %ch_wmd_b01_sleepguards_grd03;
	
	level.scr_anim["redshirt1"]["first_reenforcements"] = %ch_wmd_b01_barracksentry_A_grd01;
	level.scr_anim["redshirt2"]["first_reenforcements"] = %ch_wmd_b01_barracksentry_A_grd02;
	
	level.scr_anim["redshirt1"]["second_reenforcements"] = %ch_wmd_b01_barracksentry_B_grd01;
	level.scr_anim["redshirt2"]["second_reenforcements"] = %ch_wmd_b01_barracksentry_B_grd02;
	
	level.scr_anim["generic"]["talking_guard_1"] = %ch_wmd_b01_talkingguards_grd01;
	level.scr_anim["generic"]["talking_guard_2"] = %ch_wmd_b01_talkingguards_grd02;

	level.scr_model["player_sabotage_hands"] = "t5_gfl_m16a1_viewmodel_player";
	level.scr_animtree["player_sabotage_hands"] = #animtree;
	
	level.scr_anim["player_sabotage_hands"]["plant_semtex"] = %ch_wmd_b01_plant_explosive;
	addNotetrack_customFunction("player_sabotage_hands", "plant_grenade", ::plant_semtex, "plant_semtex");

	// grenade thrower
	level.scr_anim["generic"]["stand_throw"]							= %stand_grenade_throw;


	// idle at console
	level.scr_anim["generic"]["idle_at_console"] = %ai_technician_console_idle;
}


debug_bomb()
{
	self endon("death");
	
	while(1)
	{
		debugstar(self.origin, 20, (0,1,0));
		wait(1);
	}
}

plant_semtex(guy)
{
	player = get_players()[0];
	
	if(IsDefined(player.player_body))
	{
		player.player_body Detach("weapon_semtex_grenade", "tag_weapon");
		
		real_bomb = Spawn("script_model", player.player_body GetTagOrigin("tag_weapon"));
		real_bomb.angles = player.player_body GetTagAngles("tag_weapon");
		real_bomb SetModel("weapon_semtex_grenade");		
		
		flag_wait("detonation");
		
		clip = GetEnt("comms_clip", "targetname");
		clip Delete();
	
		RadiusDamage(real_bomb.origin, 200, 200, 100);
		
		real_bomb Delete();
	}
}

reset_dof(guy)
{
	level notify("reset_dof");
}

weaver_kill_smoker(guy)
{
	level notify("kill_smoker");
}

precache_patrol_anims()
{
		//patrol stuff
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "handler_walk" ]			= %ch_wmd_b01_dogHandler_walk_handler;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
			
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
		level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;

	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;	
	
	level.scr_anim[ "generic" ][ "patrol_idle_9" ][0]			= %patrol_bored_idle;
	
	//active patrol walk
	level.scr_anim[ "generic" ][ "patrol_leader_walk" ]			= %ch_wmd_b01_patrol_leader;
	level.scr_anim[ "generic" ][ "active_patrol_walk1" ]			= %ch_wmd_b01_patrol_guard01;
	level.scr_anim[ "generic" ][ "active_patrol_walk2" ]			= %ch_wmd_b01_patrol_guard02;
	level.scr_anim[ "generic" ][ "active_patrol_walk3" ]			= %ch_wmd_b01_patrol_guard03;
	level.scr_anim[ "generic" ][ "active_patrol_walk4" ]			= %ch_wmd_b01_patrol_guard04;
	level.scr_anim[ "generic" ][ "active_patrol_walk5" ]			= %ch_wmd_b01_patrol_guard05;
}

sr71_canopy_shut_start(guy)
{
		clientnotify("canopy_shut_start");
}

sr71_canopy_shut_end(guy)
{
		clientnotify("canopy_shut_end");
}

space_snap2sr71(guy)
{
     clientnotify("sic");
}

space2backin(guy)
{
     clientnotify("space_backin");
}

kick_door1(guy)
{	

	door = GetEnt("house1_door1", "targetname");
	door connectpaths();
	door notsolid();
	door rotateyaw(-130,.4);	
	array_notify(level.rts_house_guys,"enemy");
	wait(.5);
	guy anim_stopanimscripted();
}


kick_door2(guy)
{	
	
	door = GetEnt("house1_door2", "targetname");
	door connectpaths();
	door notsolid();
	door rotateyaw(130,.4);	
	wait(.5);
	guy anim_stopanimscripted();
}	

weaver_door_snow(guy)
{
	level thread exploder_for_period(600, 7.5, 610, 1.0);
}

init_rts_sounds()
{

	//
	//  New section derived from wmd_voice.gsc.  anime is filled in, and line uncommented when
	//  put to use.
	//

	level.scr_sound["weaver"]["flashbang_grenade"] = "vox_wmd1_s99_813A_weav"; //Flashbang!

	level.scr_sound["player_pilot_body"]["030A_huds"] = "vox_wmd1_s01_030A_huds_f"; //Bigeye this is Kilo One requesting tactical recon  over. Repeat  we can't see anything down here.
	level.scr_sound["operator"]["032A_usc2_f"] = "vox_wmd1_s01_032A_usc2_f"; //Affirmative. I have them.
	level.scr_sound["operator"]["034A_usc2_f"] = "vox_wmd1_s01_034A_usc2_f"; //Kilo One this is Bigeye 6  I have you on the TRP.
	level.scr_sound["hudson"]["035A_huds"] = "vox_wmd1_s01_403A_huds_f"; //Copy that Bigeye 6. We have zero visibility on the ground. We need you to guide us to the insertion point  over.
	level.scr_sound["operator"]["036A_usc2_f"] = "vox_wmd1_s01_036A_usc2_f"; //Copy that Kilo One. We are your eyes. Stand by.
	level.scr_sound["operator"]["move_north"] = "vox_wmd1_s01_037A_usc2_f"; //Kilo move north.
	level.scr_sound["operator"]["039A_usc2_f"] = "vox_wmd1_s01_039A_usc2_f"; //Kilo  proceed to the north.*/
	level.scr_sound["hudson"]["040A_huds"] = "vox_wmd1_s01_040A_huds_f"; //Roger that  we're moving.
	level.scr_sound["operator"]["head_north"] = "vox_wmd1_s01_041A_usc2_f"; //Kilo head north  over.
	level.scr_sound["operator"]["043A_usc2_f"] = "vox_wmd1_s01_043A_usc2_f"; //To the south  Kilo.
	level.scr_sound["hudson"]["044A_huds"] = "vox_wmd1_s01_044A_huds_f"; //Copy.
	level.scr_sound["operator"]["045A_usc2_f"] = "vox_wmd1_s01_045A_usc2_f"; //South coordinates marked.
	level.scr_sound["operator"]["047A_usc2_f"] = "vox_wmd1_s01_047A_usc2_f"; //Kilo move south.
	level.scr_sound["hudson"]["048A_huds"] = "vox_wmd1_s01_048A_huds_f"; //On our way  over. */
	level.scr_sound["operator"]["049A_usc2_f"] = "vox_wmd1_s01_049A_usc2_f"; //Kilo you need to move east.
	level.scr_sound["hudson"]["050A_huds"] = "vox_wmd1_s01_050A_huds_f"; //We're moving.
	level.scr_sound["operator"]["051A_usc2_f"] = "vox_wmd1_s01_051A_usc2_f"; //Move east.
	level.scr_sound["hudson"]["052A_huds"] = "vox_wmd1_s01_052A_huds_f"; //Roger that.
	level.scr_sound["operator"]["053A_usc2_f"] = "vox_wmd1_s01_053A_usc2_f"; //Kilo  head to the east.
	level.scr_sound["hudson"]["054A_huds"] = "vox_wmd1_s01_054A_huds_f"; //Copy that Bigeye.
	level.scr_sound["operator"]["055A_usc2_f"] = "vox_wmd1_s01_055A_usc2_f"; //Move west  Kilo one.
	level.scr_sound["operator"]["057A_usc2_f"] = "vox_wmd1_s01_057A_usc2_f"; //Kilo I need you moving west.
	level.scr_sound["hudson"]["058A_huds"] = "vox_wmd1_s01_058A_huds_f"; //Copy that. Moving.
	level.scr_sound["operator"]["059A_usc2_f"] = "vox_wmd1_s01_059A_usc2_f"; //Kilo move west.
	level.scr_sound["operator"]["061A_usc2_f"] = "vox_wmd1_s01_061A_usc2_f"; //One target marked. Take him out.
	level.scr_sound["hudson"]["062A_huds"] = "vox_wmd1_s01_062A_huds_f"; //Copy. Engaging target.
	level.scr_sound["operator"]["063A_usc2_f"] = "vox_wmd1_s01_063A_usc2_f"; //One target in range. Kill him.
	level.scr_sound["hudson"]["064A_huds"] = "vox_wmd1_s01_064A_huds_f"; //Understood. Taking him down.
	level.scr_sound["operator"]["065A_usc2_f"] = "vox_wmd1_s01_065A_usc2_f"; //Two targets sighted. Kill them.
	level.scr_sound["operator"]["067A_usc2_f"] = "vox_wmd1_s01_067A_usc2_f"; //Kilo I have two targets on Tac. Lose them.
	level.scr_sound["operator"]["069A_usc2_f"] = "vox_wmd1_s01_069A_usc2_f"; //Three enemies in range. Eliminate them.*/
	level.scr_sound["hudson"]["070A_huds"] = "vox_wmd1_s01_070A_huds_f"; //Copy. Initiating contact.
	level.scr_sound["operator"]["071A_usc2_f"] = "vox_wmd1_s01_071A_usc2_f"; //Contact. Three targets. Drop them.
	level.scr_sound["operator"]["073A_usc2_f"] = "vox_wmd1_s01_073A_usc2_f"; //Multiple contacts in sight. Fire at will. */
	level.scr_sound["hudson"]["074A_huds"] = "vox_wmd1_s01_074A_huds_f"; //We got it Bigeye.
	level.scr_sound["operator"]["075A_usc2_f"] = "vox_wmd1_s01_075A_usc2_f"; //Multiple targets. Engage the enemy.
	level.scr_sound["hudson"]["076A_huds"] = "vox_wmd1_s01_076A_huds_f"; //Roger that  moving in.
	level.scr_sound["hudson"]["078A_huds"] = "vox_wmd1_s01_078A_huds_f"; //Copy. We got 'em.
	level.scr_sound["hudson"]["084A_huds"] = "vox_wmd1_s01_084A_huds_f"; //Understood Bigeye. Stand by.
	level.scr_sound["operator"]["085A_usc2_f"] = "vox_wmd1_s01_085A_usc2_f"; //Kilo I see a barracks up ahead. Clear it out.
	level.scr_sound["hudson"]["086A_huds"] = "vox_wmd1_s01_086A_huds_f"; //Copy  clearing the barracks.
	level.scr_sound["operator"]["087A_usc2_f"] = "vox_wmd1_s01_087A_usc2_f"; //The barracks are in range. That's your target.
	level.scr_sound["hudson"]["106A_huds"] = "vox_wmd1_s01_106A_huds_f"; //On the move  Bigeye.
	level.scr_sound["hudson"]["anime"] = "vox_wmd1_s01_110A_huds_f"; //Copy  we're gone.*/
	level.scr_sound["hudson"]["112A_huds"] = "vox_wmd1_s01_112A_huds_f"; //On it.
	level.scr_sound["operator"]["117A_usc2_f"] = "vox_wmd1_s01_117A_usc2_f"; //Good job Kilo.
	level.scr_sound["operator"]["119A_usc2_f"] = "vox_wmd1_s01_119A_usc2_f"; //Area's clear. Good work.
	level.scr_sound["operator"]["120A_usc2_f"] = "vox_wmd1_s01_120A_usc2_f"; //You're in the clear. Nice job.
	level.scr_sound["operator"]["122A_usc2_f"] = "vox_wmd1_s01_122A_usc2_f"; //Objective complete.
	level.scr_sound["operator"]["123A_usc2_f"] = "vox_wmd1_s01_123A_usc2_f"; //Nice work Kilo One.
	level.scr_sound["pilot"]["303A_usc2_f"] = "vox_wmd1_s01_303A_usc1_f"; //C.P.   watch those patrols.
	level.scr_sound["pilot"]["127A_usc1_f"] = "vox_wmd1_s01_127A_usc1_f"; //Tac Recon I see enemy vehicles inbound. Get the squad off the road.
	level.scr_sound["pilot"]["305A_usc1_f"] = "vox_wmd1_s01_305A_usc1_f"; //C.P. They're heading towards the squad. Get them out of there.
	level.scr_sound["pilot"]["128A_usc1_f"] = "vox_wmd1_s01_128A_usc1"; //C.P.the main entrance is too hot. Find another way in. Watch those searchlights.
	level.scr_sound["pilot"]["129A_usc1_f"] = "vox_wmd1_s01_129A_usc1"; //Kilo needs to get off the road. Find another way into the base. Keep them away from the searchlights.
	level.scr_sound["pilot"]["356A_usc1_f"] = "vox_wmd1_s01_356A_usc1_f"; //Use your target indicator to find Kilo 1 on the tac  C.P.
	level.scr_sound["pilot"]["358A_usc1_f"] = "vox_wmd1_s01_358A_usc1_f"; //Looks like there's a structure to the north. Get them inside  C.P.
	level.scr_sound["operator"]["365A_usc2_f"] = "vox_wmd1_s01_365A_usc2_f"; //They're passing by the house.
	level.scr_sound["operator"]["366A_usc2_f"] = "vox_wmd1_s01_366A_usc2_f"; //Wait  no. Enemy has stopped in front of the house.
	level.scr_sound["operator"]["road_is_clear"] = "vox_wmd1_s01_416A_usc2_f";				//* Move your squad on to the barracks. First objective is inside.
	level.scr_sound["operator"]["like_ninjas"] = "vox_wmd1_s01_413A_usc2_f";					//Confirmed Kilo One - You are out of sight.
	level.scr_sound["operator"]["death1"] = "vox_wmd1_s01_424A_usc2_f";
	level.scr_sound["operator"]["death2"] = "vox_wmd1_s01_425A_usc2_f";
	level.scr_sound["operator"]["death3"] = "vox_wmd1_s01_426A_usc2_f";
	level.scr_sound["operator"]["patrol_clear"] = "vox_wmd1_s01_415A_usc2_f";					//* All clear, Kilo One.
	level.scr_sound["operator"]["objective_complete"] = "vox_wmd1_s01_118A_usc2_f";
	level.scr_sound["operator"]["road_is_hot"] = "vox_wmd1_s01_405A_usc2_f"; 
	level.scr_sound["operator"]["infantry_take_out"] = "vox_wmd1_s01_404A_usc2_f";		// Enemy infantry incoming - take them out.

	level.scr_sound["pilot"]["pilot_patrol_inbound"] = "vox_wmd1_s01_411B_usc1_f"; // CP - I see a large patrol inbound.
	level.scr_sound["operator"]["patrol_inbound"] = "vox_wmd1_s01_115A_usc2_f";	// Kilo - Stop and Drop.
	level.scr_sound["hudson"]["acknowledge_prone"] = "vox_wmd1_s01_116A_huds_f"; //Holding position.

	level.scr_sound["operator"]["barracks_breach"] = "vox_wmd1_s01_418A_usc2_f"; // Coming up on the barracks...
	level.scr_sound["hudson"]["barracks_going_in"] = "vox_wmd1_s01_102A_huds_f"; // Copy that, Bigeye.

	level.scr_sound["operator"]["multiple_targets"] = "vox_wmd1_s01_075A_usc2_f";	// multiple targets, engage the enemy.
	level.scr_sound["operator"]["in_the_clear"] = "vox_wmd1_s01_120A_usc2_f";	// In the clear - nice job.

	level.scr_sound["hudson"]["comms_down"] = "vox_wmd1_s01_419A_huds_f"; // Internal comms down - moving to second objective.
	level.scr_sound["operator"]["copy_that"] = "vox_wmd1_s01_420A_usc2_f";	// Copy that.

	level.scr_sound["operator"]["second_patrol_inc"] = "vox_wmd1_s01_421A_usc2_f"; //Kilo 1 we have Infantry inbound - I count at least six targets. Too hot.
	level.scr_sound["operator"]["second_patrol_inc2"] = "vox_wmd1_s01_422A_usc2_f"; //Stop and drop.  Stay out of sight.
	level.scr_sound["hudson"]["avoiding_second_patrol"] = "vox_wmd1_s01_423A_huds_f"; //Copy that, Bigeye... digging in.

	level.scr_sound["pilot"]["nocpthatsabadcp1"] = "vox_wmd1_s01_504A_usc1_f"; //That’s a negative CP
	level.scr_sound["pilot"]["nocpthatsabadcp2"] = "vox_wmd1_s01_505A_usc1_f"; //Belay that CP
	level.scr_sound["pilot"]["nocpthatsabadcp3"] = "vox_wmd1_s01_506A_usc1_f"; //Negative

  //level.scr_sound["pilot"]["road_is_hot_2"] = "Instruct Kilo to exit rear of structure."; 

	level.scr_sound["pilot"]["ambient_convoy_1"] = "vox_wmd1_s01_134A_usc1_f"; //C.P. multiple targets on the road! Get Kilo out of there!
	level.scr_sound["pilot"]["ambient_convoy_2"] = "vox_wmd1_s01_135A_usc2_f"; //Kilo, you have hostiles inbound. You need to vanish right now!
	level.scr_sound["pilot"]["ambient_convoy_3"] = "vox_wmd1_s01_081A_usc2_f"; //Vehicle inbound. Looks like a jeep.
	
	level.scr_sound["scroll_x_loop"] = "evt_sr71_camera_scroll_x_loop";
	level.scr_sound["scroll_y_loop"] = "evt_sr71_camera_scroll_y_loop";
	level.scr_sound["zoom_out_loop"] = "evt_sr71_camera_zoom_out_loop";
	level.scr_sound["zoom_in_loop"] = "evt_sr71_camera_zoom_in_loop";
	level.scr_sound["camera_highlight"] = "evt_sr71_camera_highlight";
	level.scr_sound["camera_mark"] = "evt_sr71_camera_mark";
	level.scr_sound["camera_invalid"] = "evt_sr71_camera_invalid";
}

sr71_intro_sounds()
{
	level.scr_sound["sr71"]["001A_usc1_f"] = "vox_wmd1_s01_001A_usc1_f"; //K.A.D  this is BigEye 6 requesting take off.
	level.scr_sound["sr71"]["002A_usc3_f"] = "vox_wmd1_s01_400A_usc3_f"; //BigEye 6  cleared for takeoff runway four. Traffic is a C-130 three miles south of K.A.D. northwest-bound  climbing out of two thousand.
//	level.scr_sound["sr71"]["003A_usc2_f"] = "vox_wmd1_s01_003A_usc2_f"; //Traffic in sight.
	level.scr_sound["sr71"]["004A_usc1_f"] = "vox_wmd1_s01_401A_usc1_f"; //K.A.D.  traffic in sight. Confirm refuel with KC-135 in Sector Bravo   Six Niner.
	level.scr_sound["sr71"]["005A_usc3_f"] = "vox_wmd1_s01_402A_usc3_f"; //Affirmative BigEye 6  KC-135 is in the sector. They will meet you there.
	level.scr_sound["sr71"]["006A_usc3_f"] = "vox_wmd1_s01_006A_usc3_f"; //BigEye 6  you have the sky.
	level.scr_sound["sr71"]["007A_usc1_f"] = "vox_wmd1_s01_007A_usc1_f"; //Copy K.A.D. My sky.
//	level.scr_sound["sr71"]["008A_usc2_f"] = "vox_wmd1_s01_008A_usc2_f"; //Systems check complete. Takeoff power... Mark. Your aircraft sir.
//	level.scr_sound["sr71"]["009A_usc1_f"] = "vox_wmd1_s01_009A_usc1_f"; //Copy.
	level.scr_sound["sr71"]["010A_usc1_f"] = "vox_wmd1_s01_010A_usc1_f"; //K.A.D.  we are rolling.
	level.scr_sound["sr71"]["011A_usc3_f"] = "vox_wmd1_s01_011A_usc3_f"; //Copy BigEye.
	level.scr_sound["sr71"]["012A_usc1_f"] = "vox_wmd1_s01_012A_usc1_f"; //V-1. Rotate.
	level.scr_sound["sr71"]["013A_usc2_f"] = "vox_wmd1_s01_013A_usc2_f"; //V-1. Check.
	level.scr_sound["sr71"]["014A_usc1_f"] = "vox_wmd1_s01_014A_usc1_f"; //And� we have velocity.
	level.scr_sound["sr71"]["015A_usc1_f"] = "vox_wmd1_s01_015A_usc1_f"; //Gear away.
	level.scr_sound["sr71"]["016A_usc2_f"] = "vox_wmd1_s01_016A_usc2_f"; //Gear away. Check.
	level.scr_sound["sr71"]["017A_usc1_f"] = "vox_wmd1_s01_017A_usc1_f"; //K.A.D. this is BigEye  we are away.

}