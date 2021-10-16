#include maps\_utility;
#include common_scripts\utility;

#using_animtree ("generic_human");
main()
{
	init_patrol_anims();
	init_helicopter_anims();
	init_russian_roulette_anims();
	init_traverse_anims();
	init_tunnel_anims();
	init_stolen_tunnel_anims(); //-- borrowed from other levels
	init_stolen_compound_anims(); //-- borrowed from other levels
	init_tunnel_player_anims();
	init_tunnel_prop_anims();
	init_clearing_player_anims();
	init_clearing_anims();
	init_takeoff_prop_anims();
	init_clearing_prop_anims();
	init_crashing_anims();
	init_meatshield_anims();
	init_compound_anims();
	init_helicopter_console_anims();
	init_VO();
}

init_compound_anims()
{
	init_compound_player_anims();
	init_compound_prop_anims();
	init_compound_vehicle_anims();
	
	level.scr_anim["barnes"]["playable_hind_climbout"] = %ch_pow_b03_barnes_cockpit_exit;
	maps\_anim::addNotetrack_customFunction( "barnes", "start_player", ::notify_player_landing_animation_start, "playable_hind_climbout");
	
	level.scr_anim[ "kravchenko" ][ "pacing" ][0] = %ch_pow_b04_kravchenko_pacing;
	level.scr_anim[ "kravchenko" ][ "endfight_enter" ] = %ch_pow_b04_endfight_krav_enter;
	level.scr_anim[ "kravchenko" ][ "endfight_firstattack" ] = %ch_pow_b04_endfight_krav_firstattack;
	level.scr_anim[ "kravchenko" ][ "endfight_gundraw" ] = %ch_pow_b04_endfight_krav_gundraw;
	level.scr_anim[ "kravchenko" ][ "endfight_gungrab" ] = %ch_pow_b04_endfight_krav_gungrab;
	level.scr_anim[ "kravchenko" ][ "endfight_kickblock" ] = %ch_pow_b04_endfight_krav_kickblock;
	level.scr_anim[ "kravchenko" ][ "endfight_shoot" ] = %ch_pow_b04_endfight_krav_shoot;
	
	
	
	maps\_anim::addNotetrack_customFunction( "kravchenko", "damage", ::damage_and_blur_player, "endfight_gungrab" );
	maps\_anim::addNotetrack_customFunction( "kravchenko", "damage", ::damage_and_blur_player, "endfight_kickblock" );
	
	level.scr_anim[ "reznov" ][ "reznov_rescue" ] = %ch_pow_b04_cells_rescue_reznov;
	maps\_anim::addNotetrack_customFunction( "reznov", "woods", ::play_woods_wtf_line, "reznov_rescue" );
	
	level.scr_anim[ "barnes" ][ "pow_button" ] = %ch_pow_b04_cells_woods_press_button;
	level.scr_anim[ "barnes" ][ "pow_wait_loop" ][0] = %ch_pow_b04_cells_woods_waitloop;
	
	level.scr_anim[ "barnes" ][ "endfight_enter" ] = %ch_pow_b04_endfight_woods_enter;
	level.scr_anim[ "barnes" ][ "endfight_firstattack" ] = %ch_pow_b04_endfight_woods_firstattack;
	level.scr_anim[ "barnes" ][ "endfight_gundraw" ] = %ch_pow_b04_endfight_woods_gundraw;
	level.scr_anim[ "barnes" ][ "endfight_gungrab" ] = %ch_pow_b04_endfight_woods_gungrab;
	level.scr_anim[ "barnes" ][ "endfight_kickblock" ] = %ch_pow_b04_endfight_woods_kickblock;
	level.scr_anim[ "barnes" ][ "endfight_shoot" ] = %ch_pow_b04_endfight_woods_shoot;
	level.scr_anim[ "barnes" ][ "morph" ] = %ch_pow_b04_morph;
	
	maps\_anim::addNotetrack_customFunction( "barnes", "blood", ::krav_blood, "endfight_gungrab" );
	maps\_anim::addNotetrack_customFunction( "barnes", "slo_start", ::start_slo_mo, "endfight_gungrab" );
	maps\_anim::addNotetrack_customFunction( "barnes", "slo_end", ::end_slo_mo, "endfight_gungrab" );
	
}

krav_blood( guy )
{
	if(is_mature())
	{
		PlayFXOnTag( level._effect["krav_stab"], level.krav, "J_spineupper");
	}
}

play_woods_wtf_line( guy )
{
	level.scr_sound["barnes"]["wtf"] = "vox_pow1_s04_418A_wood"; //Mason?!  What the fuck are you doing?!! We gotta get these guys out.
	level.woods maps\_anim::anim_single( level.woods, "wtf" );
}

start_slo_mo(guy)
{
	SetTimeScale(0.2);
}

end_slo_mo(guy)
{
	SetTimeScale(1.0);
}

notify_window_break()
{
	level notify("armored_window_start");
	exploder( 500 ); //-- the glass breaking
}

init_meatshield_anims()
{
	// AI
	level.scr_anim["_meatshield:ai"]["grab"] =						%ai_pow_meatshield_grab_intro; //-- this defaults to fail, but if the player succeeds, it becomes success!!
	level.scr_anim["_meatshield:ai"]["idle"][0] =					%ai_pow_meatshield_hostage_dead_idle;
	level.scr_anim["_meatshield:ai"]["idle_steady"][0] =	%ai_pow_meatshield_hostage_dead_idle_steady;
	level.scr_anim["_meatshield:ai"]["trans_2_dead"][0] =	%ai_pow_meatshield_hostage_trans_2_dead;
	level.scr_anim["_meatshield:ai"]["dead_idle"][0] =		%ai_pow_meatshield_hostage_dead_idle;
	level.scr_anim["_meatshield:ai"]["dead_idle_steady"][0] =	%ai_pow_meatshield_hostage_dead_idle_steady;
	level.scr_anim["_meatshield:ai"]["drop"] =								%ai_pow_meatshield_hostage_dead_drop;
	
	// PLAYER
	level.scr_anim["player_hands_contextual_melee"]["grab"] =			%int_pow_meatshield_grab_intro; //-- this defaults to fail, but if the player succeeds, it becomes success!!
	level.scr_anim["_meatshield:player"]["grab"] =								%int_pow_meatshield_grab_intro; //-- this defaults to fail, but if the player succeeds, it becomes success!!
	level.scr_anim["_meatshield:player"]["idle"][0] =							%int_pow_meatshield_hostage_dead_idle;
	level.scr_anim["_meatshield:player"]["idle_steady"][0] =			%int_pow_meatshield_hostage_dead_idle_steady;
	level.scr_anim["_meatshield:player"]["trans_2_dead"][0] =			%int_pow_meatshield_hostage_trans_2_dead;
	level.scr_anim["_meatshield:player"]["dead_idle"][0] =				%int_pow_meatshield_hostage_dead_idle;
	level.scr_anim["_meatshield:player"]["dead_idle_steady"][0] =	%int_pow_meatshield_hostage_dead_idle_steady;
	level.scr_anim["_meatshield:player"]["drop"] =								%int_pow_meatshield_hostage_dead_drop;

}

init_traverse_anims()
{
	//level.scr_anim[ "generic" ][ "woods_climb_over" ] = %ch_pow_b02_tunnel_traversal_2_woods;
	//level.scr_anim[ "generic" ][ "crouch_through" ] = %ai_woods_traverse_lowtunnel;
	level.scr_anim[ "generic" ][ "drop_down" ] = %ch_pow_b02_vc_tunnel_jump_down;
}

init_tunnel_anims()
{
	
	level.scr_anim[ "spetsnaz" ][ "escape" ] = %ch_pow_b02_end_spetz_escape;
	level.scr_anim[ "spetsnaz" ][ "escape_death_1" ] = %ch_pow_b02_end_spetz_escape_death_1;
	level.scr_anim[ "spetsnaz" ][ "escape_death_2" ] = %ch_pow_b02_end_spetz_escape_death_2;
	
	/*
	level.scr_anim[ "spetsnaz" ][ "getaway" ] = %ch_pow_b02_end_spetz_getaway;
	level.scr_anim[ "spetsnaz" ][ "legup" ] = %ch_pow_b02_end_spetz_legup;
	level.scr_anim[ "spetsnaz" ][ "legup_hit" ] = %ch_pow_b02_end_spetz_legup_hit;
	level.scr_anim[ "spetsnaz" ][ "pushdoor" ] = %ch_pow_b02_end_spetz_pushdoor;
	level.scr_anim[ "spetsnaz" ][ "pushdoor_hit" ] = %ch_pow_b02_end_spetz_pushdoor_hit;
	level.scr_anim[ "spetsnaz" ][ "roll2door" ] = %ch_pow_b02_end_spetz_roll2door;
	level.scr_anim[ "spetsnaz" ][ "roll2door_hit" ] = %ch_pow_b02_end_spetz_roll2door_hit;
	level.scr_anim[ "spetsnaz" ][ "startclimb" ] = %ch_pow_b02_end_spetz_startclimb;
	level.scr_anim[ "spetsnaz" ][ "startclimb_hit" ] = %ch_pow_b02_end_spetz_startclimb_hit;
	level.scr_anim[ "spetsnaz" ][ "deathstart" ][0] = %ch_pow_b02_end_spetz_deathstart;
	level.scr_anim[ "spetsnaz" ][ "deathwall" ][0] = %ch_pow_b02_end_spetz_dead;
	*/
	
	level.scr_anim[ "spetsnaz" ][ "walk" ][0] = %walk_CQB_F;
	
	level.scr_anim[ "barnes" ][ "to_climb_up" ] = %ch_pow_b02_end_barnes_run2wait;
	level.scr_anim[ "barnes" ][ "wait_climb_up" ][0] = %ch_pow_b02_end_barnes_wait;
	level.scr_anim[ "barnes" ][ "climb_up" ] = %ch_pow_b02_end_barnes_climb;
	maps\_anim::addNotetrack_customFunction( "barnes", "door_start_open", ::open_tunnel_door, "climb_up" );
	
	//level.scr_anim[ "barnes" ][ "climb_prep" ] = %ch_pow_b02_end_barnes_climbinstruct;
	
}

init_stolen_tunnel_anims()
{
	level.scr_anim[ "generic" ][ "relaxed_signal" ] = %ch_cuba_b02_troops_signal_4;
	level.scr_anim[ "generic" ][ "attack_crouch_through" ] = %ch_hue_b01_ib_entry3_nva1;
	level.scr_anim[ "generic" ][ "leap_off_ledge" ] = %ch_kowloon_136_dropdown_run2run_leap;
	level.scr_anim[ "generic" ][ "pulldown_table" ] = %ch_flaspoint_e11_rack_of_tapes;
	level.scr_anim[ "generic" ][ "machete_over" ] = %ai_covercrouch_hide_2_mantle_36;
	level.scr_anim[ "generic" ][ "strafe_tunnel" ] = %ch_creek_b04_vc_tunnel_strafe;
}

init_stolen_compound_anims()
{
	level.scr_anim[ "generic" ][ "flame_over" ] = %ai_covercrouch_hide_2_mantle_36;
	level.scr_anim[ "generic" ][ "sit_guard_idle" ][0] = %ch_wmd_b01_chairbreach_guards_idle_grd01;
	level.scr_anim[ "generic" ][ "sit_guard_react" ] = %ch_wmd_b01_chairbreach_guards_grd01;
	
	level.scr_anim[ "generic" ][ "stand_guard_idle" ][0] = %ch_pow_b03_clearing_spetz_guard1; //-- This is actually a POW anim
	level.scr_anim[ "generic" ][ "rpg_rollout" ] = %ai_spets_run_2_stand_cover_hide_6;
	level.scr_anim[ "generic" ][ "mantle_on_box" ] = %ai_mantle_on_56;
}

init_clearing_anims()
{
	level.scr_anim[ "fuel" ][ "combat" ] = %ch_pow_b03_clearing_rus_fuel2combat;
	level.scr_anim[ "fuel" ][ "loop" ][0] = %ch_pow_b03_clearing_rus_fuelcheck_loop;
	level.scr_anim[ "fuel" ][ "walk" ] = %ch_pow_b03_clearing_rus_fuelcheck_walk;
	
	level.scr_anim[ "inventory1" ][ "kneel" ][0] = %ch_pow_b03_clearing_rus_inventory1_kneel;
	level.scr_anim[ "inventory1" ][ "kneel2combat" ] = %ch_pow_b03_clearing_rus_inventory1_kneel2combat;
	
	level.scr_anim[ "inventory2" ][ "check" ][0] = %ch_pow_b03_clearing_rus_inventory2_check;
	level.scr_anim[ "inventory2" ][ "check2combat" ] = %ch_pow_b03_clearing_rus_inventory2_check2combat;
	
	level.scr_anim[ "pilot" ][ "out2combat" ] = %ch_pow_b03_clearing_rus_pilot_out2combat;
	level.scr_anim[ "pilot" ][ "outsidetent" ][0] = %ch_pow_b03_clearing_rus_pilot_outsidetent;
	level.scr_anim[ "pilot" ][ "tentidle" ][0] = %ch_pow_b03_clearing_rus_pilot_tentidle;
	level.scr_anim[ "pilot" ][ "walktent" ] = %ch_pow_b03_clearing_rus_pilot_walktent; 
	level.scr_anim[ "pilot" ][ "runtohind" ] = %ch_pow_b03_clearing_rus_pilot_run4hind;
	maps\_anim::addNotetrack_customFunction( "pilot", "hit_tent_flap", ::notify_tent, "runtohind" );
	
	level.scr_anim[ "radio" ][ "start" ] = %ch_pow_b03_clearing_rus_radio_start;
	level.scr_anim[ "radio" ][ "talk2combat" ] = %ch_pow_b03_clearing_rus_radio_talk2combat;
	level.scr_anim[ "radio" ][ "talkloop" ][0] = %ch_pow_b03_clearing_rus_radio_talkloop;
	level.scr_anim[ "radio" ][ "walk" ] = %ch_pow_b03_clearing_rus_radio_walk;
	
	level.scr_anim[ "truck" ][ "gone2combat" ] = %ch_pow_b03_clearing_rus_truckgone2combat;
	level.scr_anim[ "truck" ][ "wave2combat" ] = %ch_pow_b03_clearing_rus_truckwave2combat;
	level.scr_anim[ "truck" ][ "walk_by_truck" ] = %ch_pow_b03_clearing_rus_walkbytruck;
	level.scr_anim[ "truck" ][ "watch_fuel" ][0] = %ch_pow_b03_clearing_rus_watchfuel;
	maps\_anim::addNotetrack_customFunction( "truck", "truck_drive_normal_start", ::notify_clearing_truck, "walk_by_truck" );
	
	level.scr_anim[ "spetz1" ][ "guard" ][0] = %ch_pow_b03_clearing_spetz_guard1;
	
	level.scr_anim[ "spetz2" ][ "guard" ][0] = %ch_pow_b03_clearing_spetz_guard2;
	
	// woods intro
	level.scr_anim[ "barnes" ][ "run_to_hind" ] = %ch_pow_b03_clearing_woods_chopper_runto;
	level.scr_anim[ "barnes" ][ "wait_at_hind" ][0] = %ch_pow_b03_clearing_woods_chopper_waitloop;
	level.scr_anim[ "barnes" ][ "clearing" ] = %ch_pow_b03_clearing_barnes_intro;
	level.scr_anim[ "barnes" ][ "clearing_loop" ][0] = %ch_pow_b03_clearing_barnes_pre_intro;
	
	maps\_anim::addNotetrack_customFunction( "barnes", "start_radioman_pilot", ::notify_pilot_and_radioman, "clearing" );
	maps\_anim::addNotetrack_customFunction( "barnes", "start_truckguy", ::notify_truckguy, "clearing" );
	maps\_anim::addNotetrack_customFunction( "barnes", "start_fuelguy", ::notify_fuelguy, "clearing" );
	maps\_anim::addNotetrack_customFunction( "barnes", "play_dialog_s03_004A_wood_m", ::start_woods_clearing_VO, "clearing");
}

start_woods_clearing_VO( guy )
{
	//temp_woods = Spawn("script_model", (0,0,0));
	//temp_woods SetModel("tag_origin");
	//temp_woods LinkTo( level.woods, "tag_eye", (0,0,0), (0,0,0));
	//temp_woods.animname = "temp_woods";
	
	//temp_woods maps\_anim::anim_single( temp_woods, "see_that_hind" );
	//temp_woods Delete();
	//level.scr_sound[ "temp_woods" ][ "see_that_hind" ] = "vox_pow1_s03_004A_wood_m";
	
	level thread maps\_anim::anim_single( level.woods, "see_that_hind" );
	flag_set("woods_already_started_VO");
	//battlechatter_on();
}

notify_clearing_truck( guy )
{
	level notify("truck_waved_off");
}

init_patrol_anims()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %ai_spets_patrolwalk_2_stand;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %ai_spets_patrolstand_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %ai_spets_patrolwalk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;

	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
	
	level._patrol_init = true;
}

init_helicopter_anims()
{
	init_helicopter_player_anims();
	
	level.scr_anim[ "barnes" ][ "crash" ] = %ch_pow_b03_cockpit_crash_barnes;
	
	level.scr_anim[ "barnes" ][ "idle_in_hind" ] = %ch_pow_b03_barnes_cockpit_sit;
	level.scr_anim[ "barnes" ][ "flinch_l" ] = %ch_pow_b03_barnes_cockpit_flinch_l;
	level.scr_anim[ "barnes" ][ "flinch_r" ] = %ch_pow_b03_barnes_cockpit_flinch_r;
	level.scr_anim[ "barnes" ][ "glance_l" ] = %ch_pow_b03_barnes_cockpit_glance_l;
	level.scr_anim[ "barnes" ][ "glance_r" ] = %ch_pow_b03_barnes_cockpit_glance_r;
	level.scr_anim[ "barnes" ][ "look2sit_l" ] = %ch_pow_b03_barnes_cockpit_look2sit_l;
	level.scr_anim[ "barnes" ][ "look2sit_r" ] = %ch_pow_b03_barnes_cockpit_look2sit_r;
	level.scr_anim[ "barnes" ][ "look_l" ] = %ch_pow_b03_barnes_cockpit_look_l;
	level.scr_anim[ "barnes" ][ "look_r" ] = %ch_pow_b03_barnes_cockpit_look_r;
	level.scr_anim[ "barnes" ][ "point_l" ] = %ch_pow_b03_barnes_cockpit_point_l;
	level.scr_anim[ "barnes" ][ "point_r" ] = %ch_pow_b03_barnes_cockpit_point_r;
	level.scr_anim[ "barnes" ][ "sit2look_l" ] = %ch_pow_b03_barnes_cockpit_sit2look_l;
	level.scr_anim[ "barnes" ][ "sit2look_r" ] = %ch_pow_b03_barnes_cockpit_sit2look_r;
	
	//-- animations for tracking another object
	level.scr_anim[ "barnes" ][ "arm_d" ] = %ch_pow_b03_barnes_cockpit_arm_d;
	level.scr_anim[ "barnes" ][ "arm_l" ] = %ch_pow_b03_barnes_cockpit_arm_l;
	level.scr_anim[ "barnes" ][ "arm_r" ] = %ch_pow_b03_barnes_cockpit_arm_r;
	level.scr_anim[ "barnes" ][ "arm_u" ] = %ch_pow_b03_barnes_cockpit_arm_u;
	
	level.scr_anim[ "barnes" ][ "head_d" ] = %ch_pow_b03_barnes_cockpit_head_d;
	level.scr_anim[ "barnes" ][ "head_l" ] = %ch_pow_b03_barnes_cockpit_head_l;
	level.scr_anim[ "barnes" ][ "head_r" ] = %ch_pow_b03_barnes_cockpit_head_r;
	level.scr_anim[ "barnes" ][ "head_u" ] = %ch_pow_b03_barnes_cockpit_head_u;
	
	level.scr_anim[ "barnes" ][ "headarm_d" ] = %ch_pow_b03_barnes_cockpit_headarm_d;
	level.scr_anim[ "barnes" ][ "headarm_l" ] = %ch_pow_b03_barnes_cockpit_headarm_l;
	level.scr_anim[ "barnes" ][ "headarm_r" ] = %ch_pow_b03_barnes_cockpit_headarm_r;
	level.scr_anim[ "barnes" ][ "headarm_u" ] = %ch_pow_b03_barnes_cockpit_headarm_u;
	
	//-- idle animations
	level.scr_anim[ "barnes" ][ "scan_left_high" ] = %ch_pow_b03_barnes_cockpit_scan_lh;
	level.scr_anim[ "barnes" ][ "scan_left_low" ] = %ch_pow_b03_barnes_cockpit_scan_ll;
	level.scr_anim[ "barnes" ][ "scan_right_high" ] = %ch_pow_b03_barnes_cockpit_scan_rh;
	level.scr_anim[ "barnes" ][ "scan_right_low" ] = %ch_pow_b03_barnes_cockpit_scan_rl;
	
	//-- fidgets
	level.scr_anim[ "barnes" ][ "dmgcheck1"] = %ch_pow_b03_barnes_cockpit_dmgcheck1;
	level.scr_anim[ "barnes" ][ "dmgcheck2"] = %ch_pow_b03_barnes_cockpit_dmgcheck2;
			
	//-- turning and talking to player
	level.scr_anim[ "barnes" ][ "talk_long_line" ] = %ch_pow_b03_barnes_cockpit_talk_longline;
	
	level.scr_anim[ "barnes" ][ "head_up" ] = %ch_pow_b03_barnes_cockpit_talkblend_u;
	level.scr_anim[ "barnes" ][ "head_down" ] = %ch_pow_b03_barnes_cockpit_talkblend_d;
	level.scr_anim[ "barnes" ][ "head_left" ] = %ch_pow_b03_barnes_cockpit_talkblend_l;
	level.scr_anim[ "barnes" ][ "head_right" ] = %ch_pow_b03_barnes_cockpit_talkblend_r;

	//-- spotted something
	level.scr_anim[ "barnes" ][ "spot_left_back" ] = %ch_pow_b03_barnes_cockpit_spot_lb;
	level.scr_anim[ "barnes" ][ "spot_left_front_high" ] = %ch_pow_b03_barnes_cockpit_spot_lfh;
	level.scr_anim[ "barnes" ][ "spot_left_front_low" ] = %ch_pow_b03_barnes_cockpit_spot_lfl;
	level.scr_anim[ "barnes" ][ "spot_left_side_high" ] = %ch_pow_b03_barnes_cockpit_spot_lsh;
	level.scr_anim[ "barnes" ][ "spot_left_side_low" ] = %ch_pow_b03_barnes_cockpit_spot_lsl;
	
	level.scr_anim[ "barnes" ][ "spot_right_back" ] = %ch_pow_b03_barnes_cockpit_spot_rb;
	level.scr_anim[ "barnes" ][ "spot_right_front_high" ] = %ch_pow_b03_barnes_cockpit_spot_rfh;
	level.scr_anim[ "barnes" ][ "spot_right_front_low" ] = %ch_pow_b03_barnes_cockpit_spot_rfl;
	level.scr_anim[ "barnes" ][ "spot_right_side_high" ] = %ch_pow_b03_barnes_cockpit_spot_rsh;
	level.scr_anim[ "barnes" ][ "spot_right_side_low" ] = %ch_pow_b03_barnes_cockpit_spot_rsl;
	
	level.scr_anim[ "barnes" ][ "spot_left_back_idle" ] = %ch_pow_b03_barnes_cockpit_lb_idl;
	level.scr_anim[ "barnes" ][ "spot_left_back_spin" ] = %ch_pow_b03_barnes_cockpit_lb_spin;
	level.scr_anim[ "barnes" ][ "spot_left_back_spin2idle" ] = %ch_pow_b03_barnes_cockpit_lb_spin2idl;
	level.scr_anim[ "barnes" ][ "spot_left_back_idle2out" ] = %ch_pow_b03_barnes_cockpit_lb_idl2out;
	level.scr_anim[ "barnes" ][ "spot_left_tail_check" ] = %ch_pow_b03_barnes_cockpit_tailcheck_lb;
	
	level.scr_anim[ "barnes" ][ "spot_right_back_idle" ] = %ch_pow_b03_barnes_cockpit_rb_idl;
	level.scr_anim[ "barnes" ][ "spot_right_back_spin" ] = %ch_pow_b03_barnes_cockpit_rb_spin;
	level.scr_anim[ "barnes" ][ "spot_right_back_spin2idle" ] = %ch_pow_b03_barnes_cockpit_rb_spin2idl;
	level.scr_anim[ "barnes" ][ "spot_right_back_idle2out" ] = %ch_pow_b03_barnes_cockpit_rb_idl2out;
	level.scr_anim[ "barnes" ][ "spot_right_tail_check" ] = %ch_pow_b03_barnes_cockpit_tailcheck_rb;
	
	level.scr_anim[ "barnes" ][ "explosion_react_l_big" ] = %ch_pow_b03_barnes_cockpit_explosionreact_l_big;
	level.scr_anim[ "barnes" ][ "explosion_react_l_head" ] = %ch_pow_b03_barnes_cockpit_explosionreact_l_head;
	level.scr_anim[ "barnes" ][ "explosion_react_l_small" ] = %ch_pow_b03_barnes_cockpit_explosionreact_l_small;
	level.scr_anim[ "barnes" ][ "explosion_react_r_big" ] = %ch_pow_b03_barnes_cockpit_explosionreact_r_big;
	level.scr_anim[ "barnes" ][ "explosion_react_r_head" ] = %ch_pow_b03_barnes_cockpit_explosionreact_r_head;
	level.scr_anim[ "barnes" ][ "explosion_react_r_small" ] = %ch_pow_b03_barnes_cockpit_explosionreact_r_small;
	
	//-- get in helicopter
	level.scr_anim[ "barnes" ][ "climb_in" ] = %ch_pow_b03_barnes_cockpit_climbin;
	level.scr_anim[ "barnes" ][ "takeoff" ] = %ch_pow_b03_cockpit_takeoff_barnes;
	
	level.scr_anim[ "barnes" ][ "climb_in_and_takeoff" ] = %ch_pow_b03_barnes_cockpit_inandup;
	
}

init_russian_roulette_anims()
{
	init_russian_roulette_player_anims();
	init_russian_roulette_prop_anims();
	
	level.scr_anim[ "bookie" ][ "rr_1a" ] 				= %ch_pow_b01_1a_bookie;
	level.scr_anim[ "barnes" ][ "rr_1a" ] 					= %ch_pow_b01_1a_barnes;
	level.scr_anim[ "spetsnaz" ][ "rr_1a" ] 			= %ch_pow_b01_1a_spetz;
	level.scr_anim[ "vc1"][ "rr_1a" ] 						= %ch_pow_b01_1a_vc1;
	level.scr_anim[ "vc2"][ "rr_1a" ] 						= %ch_pow_b01_1a_vc2;
	level.scr_anim[ "vc3"][ "rr_1a" ] 						= %ch_pow_b01_1a_vc3;
	
	level.scr_anim[ "barnes" ][ "rr_1a_1" ] 			= %ch_pow_b01_1a_1_barnes;
	level.scr_anim[ "vc1" ][ "rr_1a_1" ] 					= %ch_pow_b01_1a_1_vc1;
	level.scr_anim[ "vc2" ][ "rr_1a_1" ] 					= %ch_pow_b01_1a_1_vc2;
	level.scr_anim[ "vc3" ][ "rr_1a_1" ] 					= %ch_pow_b01_1a_1_vc3;
			
	level.scr_anim[ "barnes" ][ "rr_1a_2" ] 			= %ch_pow_b01_1a_2_barnes;
	level.scr_anim[ "vc1" ][ "rr_1a_2" ] 					= %ch_pow_b01_1a_2_vc1;
	level.scr_anim[ "vc2" ][ "rr_1a_2" ] 					= %ch_pow_b01_1a_2_vc2;
	level.scr_anim[ "vc3" ][ "rr_1a_2" ] 					= %ch_pow_b01_1a_2_vc3;
	
	level.scr_anim[ "barnes" ][ "rr_1a_3" ] 			= %ch_pow_b01_1a_3_barnes;
	level.scr_anim[ "vc1" ][ "rr_1a_3" ] 					= %ch_pow_b01_1a_3_vc1;
	level.scr_anim[ "vc2" ][ "rr_1a_3" ] 					= %ch_pow_b01_1a_3_vc2;
	level.scr_anim[ "vc3" ][ "rr_1a_3" ] 					= %ch_pow_b01_1a_3_vc3;
	
	level.scr_anim[ "bookie" ][ "rr_1b" ] 				= %ch_pow_b01_1b_bookie;
	level.scr_anim[ "bowman" ][ "rr_1b" ] 				= %ch_pow_b01_1b_lewis;
	level.scr_anim[ "spetsnaz" ][ "rr_1b" ] 			= %ch_pow_b01_1b_spetz;
	level.scr_anim[ "barnes" ][ "rr_1b" ] 				= %ch_pow_b01_1b_barnes;
	level.scr_anim[ "vc1"][ "rr_1b" ] 						= %ch_pow_b01_1b_vc1;
	level.scr_anim[ "vc2"][ "rr_1b" ] 						= %ch_pow_b01_1b_vc2;
	level.scr_anim[ "vc3"][ "rr_1b" ] 						= %ch_pow_b01_1b_vc3;
	level.scr_anim[ "vc5"][ "rr_1b" ] 						= %ch_pow_b01_1b_vc5;
	level.scr_anim[ "vc6"][ "rr_1b" ] 						= %ch_pow_b01_1b_vc6;
	
	level.scr_anim[ "bookie" ][ "rr_1b2" ] 				= %ch_pow_b01_1b2_bookie;
	level.scr_anim[ "bowman" ][ "rr_1b2" ] 				= %ch_pow_b01_1b2_lewis;
	level.scr_anim[ "spetsnaz" ][ "rr_1b2" ] 			= %ch_pow_b01_1b2_spetz;
	level.scr_anim[ "barnes" ][ "rr_1b2" ] 				= %ch_pow_b01_1b2_barnes;
	level.scr_anim[ "vc1"][ "rr_1b2" ] 						= %ch_pow_b01_1b2_vc1;
	level.scr_anim[ "vc2"][ "rr_1b2" ] 						= %ch_pow_b01_1b2_vc2;
	level.scr_anim[ "vc3"][ "rr_1b2" ] 						= %ch_pow_b01_1b2_vc3;
	level.scr_anim[ "vc5"][ "rr_1b2" ] 						= %ch_pow_b01_1b2_vc5;
	level.scr_anim[ "vc6"][ "rr_1b2" ] 						= %ch_pow_b01_1b2_vc6;
	
	maps\_anim::addNotetrack_FXOnTag( "bowman", "rr_1b", "spit", "bowman_spit", "j_head");
	maps\_anim::addNotetrack_customFunction( "bowman", "spit", ::bowman_spit_func, "rr_1b" );
	maps\_anim::addNotetrack_customFunction( "bowman", "hit", ::bowman_head_bleed_start, "rr_1b2" );
	
	
	level.scr_anim[ "bookie" ][ "rr_1c" ] 				= %ch_pow_b01_1c_bookie;
	level.scr_anim[ "barnes" ][ "rr_1c" ] 				= %ch_pow_b01_1c_barnes;
	level.scr_anim[ "bowman" ][ "rr_1c" ] 				= %ch_pow_b01_1c_lewis;
	level.scr_anim[ "spetsnaz" ][ "rr_1c" ] 			= %ch_pow_b01_1c_spetz;
	level.scr_anim[ "vc1"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc1;
	level.scr_anim[ "vc2"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc2;
	level.scr_anim[ "vc3"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc3;
	level.scr_anim[ "vc4"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc4;
	level.scr_anim[ "vc5"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc5;
	level.scr_anim[ "vc6"][ "rr_1c" ] 						= %ch_pow_b01_1c_vc6;
	
	level.scr_anim[ "bookie" ][ "rr_1d" ] 				= %ch_pow_b01_1d_bookie;
	level.scr_anim[ "barnes" ][ "rr_1d" ] 				= %ch_pow_b01_1d_barnes;
	level.scr_anim[ "bowman" ][ "rr_1d" ] 				= %ch_pow_b01_1d_lewis;
	level.scr_anim[ "spetsnaz" ][ "rr_1d" ] 			= %ch_pow_b01_1d_spetz;
	level.scr_anim[ "vc1"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc1;
	level.scr_anim[ "vc2"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc2;
	level.scr_anim[ "vc3"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc3;
	level.scr_anim[ "vc4"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc4;
	level.scr_anim[ "vc5"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc5;
	level.scr_anim[ "vc6"][ "rr_1d" ] 						= %ch_pow_b01_1d_vc6;
	
	maps\_anim::addNotetrack_customFunction( "vc2", "hide_gun", ::take_vc2s_gun, "rr1d" );
	maps\_anim::addNotetrack_customFunction( "barnes", "switch_guns", ::give_woods_gun, "rr1d" );
	
}

give_woods_gun( guy )
{
	guy gun_recall();
}

take_vc2s_gun( guy )
{
	guy gun_remove();
}

bowman_spit_func( guy )
{
	level notify("hb_bowman_spit");
}

bowman_head_bleed_start( guy )
{
	if(is_mature())
	{
		PlayFXOnTag( level._effect["bowman_head_hit"], guy, "j_head" );
	}
	
	if(IsDefined(guy.pow_bleed))
	{
		return;
	}
	guy.pow_bleed = true;
	guy SetClientFlag(level.ACTOR_BLEEDING);
}

#using_animtree ("animated_props");

init_takeoff_prop_anims()
{
	level.scr_animtree["barnes_headset"] = #animtree;
	level.scr_model["barnes_headset"] = "anim_jun_radio_headset_b";
	level.scr_anim[ "barnes_headset" ][ "takeoff" ]	= %o_pow_b03_cockpit_headset_barnes;
	level.scr_anim[ "barnes_headset" ][ "landing" ]	= %o_pow_b03_cockpit_headset_barnes_exit;
	
	level.scr_animtree["player_headset"] = #animtree;
	level.scr_model["player_headset"] = "anim_jun_radio_headset_b";
	level.scr_anim[ "player_headset" ][ "takeoff" ]	= %o_pow_b03_cockpit_headset_player;
	level.scr_anim[ "player_headset" ][ "landing" ]	= %o_pow_b03_cockpit_headset_player_exit;
}

init_clearing_prop_anims()
{
	level.scr_animtree["clearing_tent"] = #animtree;
	level.scr_model["clearing_tent"] = "anim_jun_pow_tent";
	level.scr_anim["clearing_tent"]["loop"][0] = %o_pow_b03_clearing_tentloop;
}

init_compound_prop_anims()
{
	
	level.scr_anim[ "door_left" ][ "opening" ] = %o_pow_b04_cells_rescue_reznov_door2;
	level.scr_anim[ "door_right" ][ "opening" ] = %o_pow_b04_cells_rescue_reznov_door3;
	level.scr_anim[ "door_reznov" ][ "opening" ] = %o_pow_b04_cells_rescue_reznov_door;

	level.scr_animtree["roll_door"] = #animtree;
	level.scr_model["roll_door"] = "anim_rus_armory_door_tracks";

	level.scr_anim["roll_door"]["door_close"] = %ch_vor_b03_rolling_door_close;
	level.scr_anim["roll_door"]["door_open"]	= %ch_vor_b03_rolling_door_open;

	level.scr_animtree["krav_chair"] = #animtree;
	level.scr_model[ "krav_chair" ] = "anim_jun_chair_01";
	level.scr_anim[ "krav_chair" ][ "endfight_enter" ] = %o_pow_b04_endfight_chair_enter;
	level.scr_anim[ "krav_chair" ][ "endfight_firstattack" ] = %o_pow_b04_endfight_chair_firstattack;
	level.scr_anim[ "krav_chair" ][ "endfight_gundraw" ] = %o_pow_b04_endfight_chair_gundraw;
	level.scr_anim[ "krav_chair" ][ "endfight_gungrab" ] = %o_pow_b04_endfight_chair_gungrab;
	level.scr_anim[ "krav_chair" ][ "endfight_kickblock" ] = %o_pow_b04_endfight_chair_kickblock;
	level.scr_anim[ "krav_chair" ][ "endfight_shoot" ] = %o_pow_b04_endfight_chair_shoot;
	
	level.scr_animtree["krav_gun"] = #animtree;
	level.scr_model["krav_gun"] = "anim_cz75_world";
	level.scr_anim[ "krav_gun" ][ "endfight_enter" ] = %o_pow_b04_endfight_pistol_enter;
	level.scr_anim[ "krav_gun" ][ "endfight_firstattack" ] = %o_pow_b04_endfight_pistol_firstattack;
	level.scr_anim[ "krav_gun" ][ "endfight_gundraw" ] = %o_pow_b04_endfight_pistol_gundraw;
	level.scr_anim[ "krav_gun" ][ "endfight_gungrab" ] = %o_pow_b04_endfight_pistol_gungrab;
	level.scr_anim[ "krav_gun" ][ "endfight_kickblock" ] = %o_pow_b04_endfight_pistol_kickblock;
	level.scr_anim[ "krav_gun" ][ "endfight_shoot" ] = %o_pow_b04_endfight_pistol_shoot;
	
	level.scr_animtree["krav_knife"] = #animtree;
	level.scr_model["krav_knife"] = "t5_knife_animate";
	level.scr_anim[ "krav_knife" ][ "endfight_enter" ] = %o_pow_b04_endfight_knife_enter;
	level.scr_anim[ "krav_knife" ][ "endfight_firstattack" ] = %o_pow_b04_endfight_knife_firstattack;
	level.scr_anim[ "krav_knife" ][ "endfight_gundraw" ] = %o_pow_b04_endfight_knife_gundraw;
	level.scr_anim[ "krav_knife" ][ "endfight_gungrab" ] = %o_pow_b04_endfight_knife_gungrab;
	level.scr_anim[ "krav_knife" ][ "endfight_kickblock" ] = %o_pow_b04_endfight_knife_kickblock;
	level.scr_anim[ "krav_knife" ][ "endfight_shoot" ] = %o_pow_b04_endfight_knife_shoot;
}


init_russian_roulette_prop_anims()
{
	level.scr_animtree["rr_cleaver"] = #animtree;
	level.scr_model["rr_cleaver"] = "anim_jun_cleaver";
	level.scr_anim[ "rr_cleaver" ][ "rr_1a" ] 		= %o_pow_b01_1a_cleaver;
	level.scr_anim[ "rr_cleaver" ][ "rr_1b" ] 		= %o_pow_b01_1b_cleaver;
	level.scr_anim[ "rr_cleaver" ][ "rr_1b2"] 		= %o_pow_b01_1b2_cleaver;
	level.scr_anim[ "rr_cleaver" ][ "rr_1c" ] 		= %o_pow_b01_1c_cleaver;
	level.scr_anim[ "rr_cleaver" ][ "rr_1d" ] 		= %o_pow_b01_1d_cleaver;
	
	level.scr_animtree["rr_cage_lid"] = #animtree;
	level.scr_model["rr_cage_lid" ] = "p_pow_cage_lid";
	level.scr_anim[ "rr_cage_lid" ][ "rr_1a_2" ] 		= %o_pow_b01_1a_2_cage_lid;
	
	level.scr_animtree["rr_roulettegun"] = #animtree;
	level.scr_model["rr_roulettegun"] = "t5_weapon_coltpython_pow";
	level.scr_anim[ "rr_roulettegun" ][ "rr_1a" ] = %o_pow_b01_1a_roulettegun;
	level.scr_anim[ "rr_roulettegun" ][ "rr_1b" ] = %o_pow_b01_1b_roulettegun;
	level.scr_anim[ "rr_roulettegun" ][ "rr_1b2" ] = %o_pow_b01_1b2_roulettegun;
	level.scr_anim[ "rr_roulettegun" ][ "rr_1c" ] = %o_pow_b01_1c_roulettegun;
	level.scr_anim[ "rr_roulettegun" ][ "rr_1d" ] = %o_pow_b01_1d_roulettegun;
	
	level.scr_animtree["rr_ak47"] = #animtree;
	level.scr_model[ "rr_ak47" ] = "anim_jun_ak47";
	level.scr_anim[ "rr_ak47" ][ "rr_1c" ] = %o_pow_b01_1c_ak47;
	level.scr_anim[ "rr_ak47" ][ "rr_1d" ] = %o_pow_b01_1d_ak47;
	
	level.scr_animtree["rr_bookiegun"] = #animtree;
	level.scr_model[ "rr_bookiegun" ] = "t5_weapon_coltpython_pow";
	level.scr_anim[ "rr_bookiegun" ][ "rr_1c" ] = %o_pow_b01_1c_bookiegun;
	level.scr_anim[ "rr_bookiegun" ][ "rr_1d" ] = %o_pow_b01_1d_bookiegun;
	
	level.scr_animtree["rr_shovel"] = #animtree;
	level.scr_model[ "rr_shovel" ] = "anim_jun_pipe_weapon";
	//level.scr_anim[ "rr_shovel" ][ "rr_1a" ] = %o_pow_b01_1a_entrenchingtool;
	level.scr_anim[ "rr_shovel" ][ "rr_1b" ] = %o_pow_b01_1b_pipe;
	level.scr_anim[ "rr_shovel" ][ "rr_1b2" ] = %o_pow_b01_1b2_pipe;
	level.scr_anim[ "rr_shovel" ][ "rr_1c" ] = %o_pow_b01_1c_pipe;
	level.scr_anim[ "rr_shovel" ][ "rr_1d" ] = %o_pow_b01_1d_pipe;

	level.scr_animtree["rr_otherchair"] = #animtree;
	level.scr_model[ "rr_otherchair" ] = "anim_jun_chair_01";
	level.scr_anim[ "rr_otherchair" ][ "rr_1a" ] = %o_pow_b01_1a_otherchair;
	level.scr_anim[ "rr_otherchair" ][ "rr_1b" ] = %o_pow_b01_1b_otherchair;
	level.scr_anim[ "rr_otherchair" ][ "rr_1b2" ] = %o_pow_b01_1b2_otherchair;
	level.scr_anim[ "rr_otherchair" ][ "rr_1c" ] = %o_pow_b01_1c_otherchair;
	level.scr_anim[ "rr_otherchair" ][ "rr_1d" ] = %o_pow_b01_1d_otherchair;
	
	level.scr_animtree["rr_playerchair"] = #animtree;
	level.scr_model[ "rr_playerchair" ] = "anim_jun_chair_01";
	level.scr_anim[ "rr_playerchair" ][ "rr_1a" ] = %o_pow_b01_1a_playerchair;
	level.scr_anim[ "rr_playerchair" ][ "rr_1b" ] = %o_pow_b01_1b_playerchair;
	level.scr_anim[ "rr_playerchair" ][ "rr_1b2" ] = %o_pow_b01_1b2_playerchair;
	level.scr_anim[ "rr_playerchair" ][ "rr_1c" ] = %o_pow_b01_1c_playerchair;
	level.scr_anim[ "rr_playerchair" ][ "rr_1d" ] = %o_pow_b01_1d_playerchair;

	level.scr_animtree["rr_table"] = #animtree;
	level.scr_model[ "rr_table" ] = "anim_jun_folding_table";
	level.scr_anim[ "rr_table" ][ "rr_1a" ] = %o_pow_b01_1a_table;
	level.scr_anim[ "rr_table" ][ "rr_1b" ] = %o_pow_b01_1b_table;
	level.scr_anim[ "rr_table" ][ "rr_1b2" ] = %o_pow_b01_1b2_table;
	level.scr_anim[ "rr_table" ][ "rr_1c" ] = %o_pow_b01_1c_table;
	level.scr_anim[ "rr_table" ][ "rr_1d" ] = %o_pow_b01_1d_table;
	
}

init_tunnel_prop_anims()
{
	level.scr_animtree["spetz_table"] = #animtree;
	level.scr_model[ "spetz_table" ] = "anim_jun_folding_table";
	level.scr_anim[ "spetz_table" ][ "idle" ] = %o_pow_b02_end_table;
	
		//level.scr_anim[ "tunnel_door" ][ "closed" ][0]  = %o_pow_b02_end_door_closedloop;
	level.scr_anim[ "tunnel_door" ][ "opening" ] 		= %o_pow_b02_end_door_opening;
	//level.scr_anim[ "tunnel_door" ][ "open" ][0]	  = %o_pow_b02_end_door_openloop;
}

open_tunnel_door( guy )
{
	door = GetEnt("tunnel_door", "targetname");
	
	door_ent = Spawn("script_model", door.origin);
	door_ent SetModel("tag_origin_animate");
	door_ent.angles = door.angles;
	door_ent.animname = "tunnel_door";
	
	door_ent useAnimTree(#animtree);
	
	door LinkTo( door_ent, "origin_animate_jnt" );
	door_ent maps\_anim::anim_single( door_ent, "opening" );
	//door_ent maps\_anim::anim_loop( door_ent, "open" );
}

#using_animtree ("player");
init_russian_roulette_player_anims()
{
	level.scr_anim[ "player_hands" ][ "rr_1a_1" ] 	= %int_pow_b01_1a_1;
	level.scr_anim[ "player_hands" ][ "rr_1a_2" ] 	= %int_pow_b01_1a_2;
	level.scr_anim[ "player_hands" ][ "rr_1a_3" ] 	= %int_pow_b01_1a_3;
	
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_out_start", ::fade_to_black_rr, "rr_1a_1" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_in_start", ::fade_from_black_rr, "rr_1a_1" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_out_start", ::fade_to_black_rr, "rr_1a_2" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_in_start", ::fade_from_black_rr, "rr_1a_2" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_out_start", ::fade_to_black_rr, "rr_1a_3" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "fade_in_start", ::fade_from_black_rr, "rr_1a_3" );
	
	level.scr_anim[ "player_hands" ][ "rr_1a" ] 	= %int_pow_b01_1a;
	level.scr_anim[ "player_hands" ][ "rr_1b" ] 	= %int_pow_b01_1b;
	level.scr_anim[ "player_hands" ][ "rr_1b2" ] 	= %int_pow_b01_1b2;
	level.scr_anim[ "player_hands" ][ "rr_1c" ] 	= %int_pow_b01_1c;
	level.scr_anim[ "player_hands" ][ "rr_1d" ] 	= %int_pow_b01_1d;
}

fade_to_black_rr( guy )
{
	level notify("first_fade_to_black");
	
	if(!IsDefined(level.fadetoblackrr))
	{
		level.fadetoblackrr = NewHudElem();
	}
	
	level.fadetoblackrr.x = 0; 
	level.fadetoblackrr.y = 0;
	level.fadetoblackrr.alpha = 0;
	level.fadetoblackrr.horzAlign = "fullscreen"; 
	level.fadetoblackrr.vertAlign = "fullscreen"; 
	level.fadetoblackrr.foreground = false; 
	level.fadetoblackrr.sort = 50; 
	level.fadetoblackrr SetShader( "black", 640, 480 );        
	level.fadetoblackrr FadeOverTime( 1.5 );
	level.fadetoblackrr.alpha = 1; 
}

fade_from_black_rr( guy )
{
	if(!IsDefined(level.fadetoblackrr))
	{
		return;
	}
	
	level.fadetoblackrr FadeOverTime( 1.5 );
	level.fadetoblackrr.alpha = 0; 
}

init_helicopter_player_anims()
{
	//-- player flightstick animations	
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_model["player_hands"] = level.player_interactive_model;
	level.scr_anim["player_hands"]["flightstick_left"]	= %int_pow_b03_cockpit_hand_left;
	level.scr_anim["player_hands"]["flightstick_right"] = %int_pow_b03_cockpit_hand_right;
	level.scr_anim["player_hands"]["flightstick_away"] = 	%int_pow_b03_cockpit_hand_down;
	level.scr_anim["player_hands"]["flightstick_towards"] = %int_pow_b03_cockpit_hand_up;
	level.scr_anim["player_hands"]["flightstick_neutral"] = %int_pow_b03_cockpit_hand_neutral;
	level.scr_anim["player_hands"]["flightstick_handsoff"] = %int_pow_b03_cockpit_handsoff;
	level.scr_anim["player_hands"]["takeoff"] = %int_pow_b03_cockpit_takeoff;
	
	level.scr_anim["player_hands"]["playable_hind_climbout"] = %int_pow_b03_cockpit_exit;
	
	level.scr_anim["player_hands"]["crash"] = %int_pow_b03_cockpit_crash;
}

init_tunnel_player_anims()
{
	level.scr_anim[ "player_hands" ][ "climb_up" ] = %int_pow_b02_end_climb;
	//level.scr_anim[ "player_hands" ][ "climb_prep" ] = %int_pow_b02_end_climbinstruct;
}

init_compound_player_anims()
{
	level.scr_animtree["player_arms"] = #animtree;
	level.scr_model["player_arms"] = level.player_interactive_hands;
	
	level.scr_anim[ "player_hands" ][ "reznov_rescue" ] = %int_pow_b04_cells_rescue_reznov;
	maps\_anim::addNotetrack_customFunction( "player_hands", "door1_start", ::open_pow_door1, "reznov_rescue" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "door2_start", ::open_pow_door2, "reznov_rescue" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "door_reznov_start", ::open_pow_door3, "reznov_rescue" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "rolling_door_start", maps\pow_compound::animate_rolling_door_open, "reznov_rescue" );
	
	level.scr_anim[ "player_hands" ][ "endfight_enter" ] = %int_pow_b04_endfight_enter;
	level.scr_anim[ "player_hands" ][ "endfight_firstattack" ] = %int_pow_b04_endfight_firstattack;
	level.scr_anim[ "player_hands" ][ "endfight_gundraw" ] = %int_pow_b04_endfight_gundraw;
	level.scr_anim[ "player_hands" ][ "endfight_gungrab" ] = %int_pow_b04_endfight_gungrab;
	level.scr_anim[ "player_hands" ][ "endfight_kickblock" ] = %int_pow_b04_endfight_kickblock;
	level.scr_anim[ "player_hands" ][ "endfight_block" ][0] = %int_pow_b04_endfight_block_block;
	level.scr_anim[ "player_hands" ][ "endfight_rest" ][0] = %int_pow_b04_endfight_block_rest;
	level.scr_anim[ "player_hands" ][ "endfight_shoot" ] = %int_pow_b04_endfight_shoot;
	maps\_anim::addNotetrack_customFunction( "player_hands", "damage", ::player_hit_with_chair, "endfight_enter" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "explosion", maps\pow_compound::woods_explosion, "endfight_shoot");
	
	
	level.scr_anim[ "player_hands" ][ "morph" ] = %int_pow_b04_morph;
	maps\_anim::addNotetrack_customFunction( "player_hands", "blur", ::swap_to_reznov, "morph" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "swap", ::notify_swap_to_reznov, "morph" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "at_table", maps\createart\pow_art::set_vision_endtable, "morph" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "play_other_lines", maps\pow_compound::play_extra_lines_and_end, "morph" );
	
	level.scr_anim[ "player_hands" ][ "fade_corpse" ] = %int_pow_b04_scene_woods_corpse;
	level.scr_anim[ "player_hands" ][ "fade_cave" ] = %int_pow_b04_scene_cave_mouth;
	level.scr_anim[ "player_hands" ][ "fade_heli" ] = %int_pow_b04_scene_heli_takeoff;
}

start_blur_player( guy )
{
	player = get_players()[0];
	player SetBlur(10, 0.1);
}

stop_blur_player( guy )
{
	player = get_players()[0];
	player SetBlur(0, 8);
}

notify_swap_to_reznov( guy )
{
	level notify("swap_rez_now");
}

swap_to_reznov( guy )
{
	level thread set_swap_reznov_flag();
	player = get_players()[0];
	level.fadeToBlack SetShader( "black", 640, 480 );
	level.fadeToBlack FadeOverTime( 2.5 );
	level.fadeToBlack.alpha = 1.0; 
	
	wait(2.5);
	
	flag_wait("swap_rez");
	
	level.woods Detach(level.woods.headmodel);
	level.woods Detach("t5_gfl_hk416_v2_gear");
	level.woods character\gfl\character_gfl_ump40::main();
	level.fadeToBlack FadeOverTime( 5.0 );
	level.fadeToBlack.alpha = 0; 

	wait(0.3);

	player SetBlur(0, 2);
}

set_swap_reznov_flag()
{
	level waittill("swap_rez_now");
	flag_set("swap_rez");
}

player_hit_with_chair( guy ) //-- guy is the player's body
{
	max_blur = 0.12;
	min_blur = 0.11;
	
	VisionSetNaked( "flash_grenade", 0 );
	
	player = get_players()[0];
	player SetClientDvar("r_poisonFX_blurMin", min_blur);
	player SetClientDvar("r_poisonFX_blurMax", max_blur);
	player StartPoisoning();
	
	player ShellShock( "tankblast", 2.0);
	player PlayRumbleOnEntity( "damage_heavy" );
	
	level thread adjust_hit_vs_in(0.5);
	while( min_blur > 0)
	{
			
		player SetClientDvar("r_poisonFX_blurMin", min_blur);
		player SetClientDvar("r_poisonFX_blurMax", max_blur);
	
		wait(0.25);
		
		min_blur -= 0.01;
		max_blur -= 0.01;
	}
	
	player StopPoisoning();
}

adjust_hit_vs_in( delay )
{
	wait(delay);
	VisionSetNaked( "pow_office", 2.75 );
}

damage_and_blur_player( guy ) //- guy is kravchenko
{
	level notify("cutscene_damage");
	level endon("cutscene_damage");
	player = get_players()[0];
	
	kick_damage = 20;
	
	if(!IsDefined(level.poison_min_blur))
	{
		level.poison_min_blur = .1;
		player StartPoisoning();
	}
	
	if(!IsDefined(level.poison_max_blur))
	{
		level.poison_max_blur = .3;
	}
	
	
	if(player.health - kick_damage < 1)
	{
		max_damage = player.health - 1;
		player DoDamage( max_damage, player.origin );
		player PlayRumbleOnEntity( "damage_heavy" );
	}
	else
	{
		player DoDamage( kick_damage, player.origin );
		player PlayRumbleOnEntity( "damage_heavy" );
	}
	
	level.poison_min_blur += .3;
	level.poison_max_blur += .4;
	
	player SetClientDvar("r_poisonFX_blurMin", level.poison_min_blur);
	player SetClientDvar("r_poisonFX_blurMax", level.poison_max_blur);
	player thread manage_damage_blur();
	
	player SetBlur(3, 0.5);
	wait(0.5);
	player SetBlur(0, 3);
}

manage_damage_blur()
{
	level notify("new_blur_manager");
	level endon("new_blur_manager");
	
	while( level.poison_min_blur > 0)
	{
			
		self SetClientDvar("r_poisonFX_blurMin", level.poison_min_blur);
		self SetClientDvar("r_poisonFX_blurMax", level.poison_max_blur);
	
		wait(0.10);
		
		level.poison_min_blur -= 0.01;
		level.poison_max_blur -= 0.01;
	}
	
	self StopPoisoning();
}

init_clearing_player_anims()
{
	level.scr_anim["player_hands"]["clearing"] = %int_pow_b03_clearing_intro;
	/*
	maps\_anim::addNotetrack_customFunction( "player_hands", "start_radioman_pilot", ::notify_pilot_and_radioman, "clearing" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "start_truckguy", ::notify_truckguy, "clearing" );
	maps\_anim::addNotetrack_customFunction( "player_hands", "start_fuelguy", ::notify_fuelguy, "clearing" );
	*/
}

notify_pilot_and_radioman( guy )
{
	level notify("pilot_and_radio_go");
	level notify("tent_flap01_start"); //-- this is the first tent exit
}

notify_truckguy( guy )
{
	level notify("truck_go");
}

notify_fuelguy( guy )
{
	level notify("fuel_go");
}

notify_tent( guy )
{
	level notify("tent_flap02_start");
}

notify_player_landing_animation_start( guy )
{
	level notify("start_player_landed_animations");
}

#using_animtree ("vehicles");

init_compound_vehicle_anims()
{
	level.scr_anim["helicopter"][ "fade_heli" ] = %v_pow_b04_scene_heli_takeoff_cockpit;
}

init_crashing_anims()
{
	level.scr_anim["helicopter"][ "hip_left" ] = %v_under_b02_huey_hit_by_hind;
	level.scr_anim["helicopter"][ "hip_right" ] = %v_pow_b03_hip_crash_right;
	level.scr_anim["helicopter"][ "hind_left1" ] = %v_pow_b03_hind_crash_left1;
	level.scr_anim["helicopter"][ "hind_left2" ] = %v_pow_b03_hind_crash_left2;
	level.scr_anim["helicopter"][ "hind_right1" ] = %v_pow_b03_hind_crash_right1;
	level.scr_anim["helicopter"][ "hind_right2" ] = %v_pow_b03_hind_crash_right2;
	
	level.scr_anim["truck"]["idle"] = %v_pow_b03_clearing_truckstart;
}

init_helicopter_console_anims()
{
	level.scr_anim["helicopter"][ "horizon_left" ] = %v_pow_b03_cockpit_horizon_bankleft;
	level.scr_anim["helicopter"][ "horizon_right" ] = %v_pow_b03_cockpit_horizon_bankright;
	level.scr_anim["helicopter"][ "horizon_tiltdown" ] = %v_pow_b03_cockpit_horizon_tiltdown;
	level.scr_anim["helicopter"][ "horizon_tiltup" ] = %v_pow_b03_cockpit_horizon_tiltup;
	level.scr_anim["helicopter"][ "horizon_neutral" ] = %v_pow_b03_cockpit_horizon_neutral;
}

init_VO()
{
	init_russian_vo();
	
	init_VO_heli_dmg();
	init_VO_reloading();
	init_VO_nag_rockets();
	init_VO_nag_2nd_village();

	//-- The Line
	level.scr_sound["player"]["the_line"] = "vox_pow1_s03_034A_maso"; //Payback, you sons of bitches!

	//-- Narration 1 - during opening scene
	level.scr_sound["player"]["narration_1a"] = "vox_pow1_s01_704A_maso_m";
	level.scr_sound["player"]["narration_1"] = "vox_pow1_s01_700A_maso";
	
	//-- Narration 2 - during ending scene
	level.scr_sound["player"]["interrogator"] = "vox_pow1_s01_701A_inte"; //Where is the numbers station?
	level.scr_sound["player"]["reznov_all_must_die"] = "vox_pow1_s01_702A_rezn"; //Where is the numbers station?

	//-- In the Tunnels
  level.scr_sound["player"]["the_russian_now"] = "vox_pow1_s01_255A_maso"; //The Russian. Now.
  level.scr_sound["barnes"]["lets_go"] = "vox_pow1_s01_267A_wood_m"; //Let's go.

	level.scr_sound["barnes"]["nag_1"] = "vox_pow1_s01_268A_wood"; //Don't let that bastard get away!

  level.scr_sound["barnes"]["nag_2"] = "vox_pow1_s01_400A_wood"; //* If he makes it out - He'll warn Kravchenko!
  level.scr_sound["player"]["nag_2"] = "vox_pow1_s01_401A_maso"; //* He ain't getting out!
  
  level.scr_sound["barnes"]["nag_3"] = "vox_pow1_s01_269A_wood"; //Keep going!
  
  level.scr_sound["barnes"]["nag_4"] = "vox_pow1_s01_402A_wood"; //* The Russian's gonna die!
  level.scr_sound["player"]["nag_4"] = "vox_pow1_s01_403A_maso"; //* Damn right he is.
  
  level.scr_sound["barnes"]["nag_5"] = "vox_pow1_s01_404A_wood"; //* He'll pay for what he did!
  level.scr_sound["player"]["nag_5"] = "vox_pow1_s01_405A_maso"; //* Not just him. Kravchenko too.
  
  level.scr_sound["barnes"]["nag_6"] = "vox_pow1_s01_271A_wood"; //We're losing him, Mason!
  
  /*
  level.scr_sound["barnes"]["nag_7"] = "vox_pow1_s01_406A_wood"; // For Bowman.
  level.scr_sound["player"]["nag_7"] = "vox_pow1_s01_407A_maso"; // For Bowman.
  */
  
  level.scr_sound["barnes"]["nag_7"] = "vox_pow1_s01_408A_wood"; //* I want that Russian DEAD!
  level.scr_sound["player"]["nag_7"] = "vox_pow1_s01_409A_maso"; //* Stay on him, Woods!
  
  level.scr_sound["player"]["nag_8"] = "vox_pow1_s01_410A_maso"; //* I'm gonna kill him - For Bowman.
  
  level.scr_sound["barnes"]["nag_9"] = "vox_pow1_s01_272A_wood"; //He's getting away!
  
  level.scr_sound["player"]["nag_10"] = "vox_pow1_s01_411A_maso"; //* Damn VC are everywhere!
  level.scr_sound["barnes"]["nag_10"] = "vox_pow1_s01_412A_wood"; //* Clear 'em out... We only care about the Russian.


  level.scr_sound["barnes"]["trying_to_escape"] = "vox_pow1_s01_274A_wood"; //There! Piece of shit's trying to escape!
  level.scr_sound["barnes"]["bring_him_down"] = "vox_pow1_s01_275A_wood"; //Bring him down, Mason!
  level.scr_sound["barnes"]["wakeup"] = "vox_pow1_s03_505A_wood"; //Wake the fuck up, Mason!
  level.scr_sound["player"]["player_shot_russian"] = "vox_pow1_s01_276A_maso"; //You're not going anywhere!


	level.scr_sound["fake_dds"]["rus1"] = "dds_ru3_rspns_act"; 
	level.scr_sound["fake_dds"]["vc1"] = "dds_vc1_rspns_lm"; 
	level.scr_sound["fake_dds"]["vc2"] = "dds_vc2_rspns_act"; 
	level.scr_sound["fake_dds"]["vc3"] = "dds_vcr_rspns_lm"; 

	//-- In the clearing
	level.scr_sound["barnes"][ "see_that_hind" ] = "vox_pow1_s03_004A_wood_m";
	level.scr_sound["barnes"]["take_the_shot"] = "vox_pow1_s03_005A_wood"; //Take the shot.
  level.scr_sound["barnes"]["fire_when_ready"] = "vox_pow1_s03_006A_wood"; //Mason, fire when ready.
  level.scr_sound["barnes"]["ill_take_lead"] = "vox_pow1_s03_007A_wood"; //All right, I'll take the lead.


	//-- End of Hind Clearing
	level.scr_sound[ "barnes" ][ "clear_lets_fly"] = "vox_pow1_s03_011A_wood";	//Clear. Let's fly this bird.
	level.scr_sound["barnes"]["get_in_hind"] = "vox_pow1_s03_503A_wood"; //Get in the HIND.
  level.scr_sound["barnes"]["get_into_heli"] = "vox_pow1_s03_504A_wood"; //Get into the helicopter Mason.
	
	//-- Flying Section
	level.scr_sound[ "barnes" ][ "fly_kravchenko"] = "vox_pow1_s03_025A_wood_f";	//We have coordinates for Kravchenko's compound. We follow the river all the way.
	level.scr_sound[ "barnes" ][ "eyes_on_dirt"] = "vox_pow1_s03_026A_wood_f";	//	Keep your eyes on the dirt. I don't want to get shot in the balls.
	level.scr_sound[ "player_hands" ][ "got_you_woods"] = "vox_pow1_s03_027A_maso";		//	I got you Woods.
	level.scr_sound[ "player_hands" ][ "hell_yeah"] = "vox_pow1_s03_028A_maso";		//	Hell yeah!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_029A_wood_f";	//	Good eye, Mason!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_030A_wood_f";	//	We got them on the run!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_031A_wood_f";	//	Fuck yeah, run Charlie!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_032A_maso";		//	Come on� COME ON!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_033A_wood_f";	//	Look at those bastards run!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_034A_maso";		//	Payback, you sons of bitches!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_039A_wood_f";	//	We lost a generator! Switching to back up.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_040A_wood_f";	//	Anti collision system is dead!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_041A_wood_f";	//	We're losing stability!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_042A_wood_f";	//	Radar warning system is offline!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_043A_wood_f";	//	Shiiit! We're going down!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_044A_maso";		//	I'm losing it! I'm losing it! Hang on!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_045A_wood_f";	//	Rotor's shot. We're dropping!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_046A_maso";		//	Fuck! We're going to crash!
	level.scr_sound[ "barnes" ][ "sampans"] = "vox_pow1_s03_076A_wood_f";	//	Sampans in the river.  Looks like a 50cal on the bridge up ahead as well.
	level.scr_sound[ "barnes" ][ "bridge"] = "vox_pow1_s03_077A_wood_f";	//	Take that bridge out!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_078A_wood_f";	//	RPGs incoming! From the sampans!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_079A_wood_f";	//	We got 'em all, good work. Let's keep moving.
	level.scr_sound[ "barnes" ][ "truck_depot"] = "vox_pow1_s03_081A_wood_f";	//	Charlie's highway below. See that fueling station up ahead?
	level.scr_sound[ "player_hands" ][ "i_see_it"] = "vox_pow1_s03_082A_maso";		//	Yeah, I see it.
	level.scr_sound[ "barnes" ][ "zsu_rockets"] = "vox_pow1_s03_080A_wood_f";	//	50 cal on those trucks! And they got a ZSU! Use the rockets!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_083A_wood_f";	//	Time to do some damage brother!
	level.scr_sound[ "barnes" ][ "fuel_silo"] = "vox_pow1_s03_084A_wood_f";	//	Hit that fuel silo!
	level.scr_sound[ "barnes" ][ "fuck_yeah"] = "vox_pow1_s03_085A_wood_f";	//	Fuck yeah!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_086A_wood_f";	//	Hit the buildings too. Don't leave any of those bastards behind.
	level.scr_sound[ "barnes" ][ "depot_clear"] = "vox_pow1_s03_087A_wood_f";	//	Area's clear - keep following the river!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_088A_wood_f";	//	RPGs on the river. Take out the boats!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_089A_wood_f";	//	Shit! There's a 50 cal down there somewhere.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_090A_wood_f";	//	Careful through here Mason. Those Sampans must have a supply station near by.
	level.scr_sound[ "barnes" ][ "supply_station"] = "vox_pow1_s03_091A_wood_f";	//	That's an NVA supply station! We must be close to the Ho Chi Minh trail. Put 'em out of business, Mason!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_093A_wood_f";	//	I think we pissed someone off, Mason.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_095A_wood_f";	//	Fuck it, it's not like we're being subtle. Hey you communist piece of shit, we're coming to get you.
	level.scr_sound[ "barnes" ][ "mi8"] = "vox_pow1_s03_097A_wood_f";	//	Here it comes! Mi-8 attack helicopter, coming from the north.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_101A_wood_f";	//	We gotta take out that gunner!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_103A_wood_f";	//	He's got a bead on us!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_105A_wood_f";	//	You got him! Fire.
	level.scr_sound[ "barnes" ][ "mi8_dead"] = "vox_pow1_s03_107A_wood_f";	//	We got him. Keep heading north. Stay close to the river.
	level.scr_sound[ "barnes" ][ "napalm"] = "vox_pow1_s03_108A_wood_f";	//	Looks like Covey has been burning the trail here. Check out that Napalm strike. Even Charlie can't live through that shit.
	level.scr_sound[ "barnes" ][ "not_good"] = "vox_pow1_s03_109A_wood_f";	//	That's not good.
	level.scr_sound[ "player_hands" ][ "radar_lock"] = "vox_pow1_s03_110A_maso";		//	Radar lock!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_111A_wood_f";	//	SAM missle! Let it get close, then evade!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_112A_maso";		//	Come on you son of a�
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_113A_wood_f";	//	Nice flying! Must be a SAM launcher up river.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_114A_wood_f";	//	Incoming!
	//level.scr_sound[ "player_hands" ][ ""] = "vox_pow1_s03_115A_maso";		//	I got it!
	level.scr_sound[ "barnes" ][ "in_that_cave"] = "vox_pow1_s03_116A_wood_f";	//	We need to get closer. In that cave!
	
	level.scr_sound[ "barnes" ][ "clear_em_out"] = "vox_pow1_s03_120A_wood_f";	//	Clear 'em out!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_121A_wood_f";	//	Hit it again! Bring the whole god damn mountain down!
	level.scr_sound[ "barnes" ][ "last_bird"] = "vox_pow1_s03_122A_wood_f";	//	Good job! That's the last bird those bastards bring down.
	level.scr_sound[ "barnes" ][ "bridge_and_pipe"] = "vox_pow1_s03_123A_wood_f";	//	Charlie's built a pipeline right across the river. Take it down and hit the bridge!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_124A_wood_f";	//	Convoys on the move!
	level.scr_sound[ "barnes" ][ "nice_work"] = "vox_pow1_s03_125A_wood_f";	//	Nice work!
	level.scr_sound[ "barnes" ][ "ho_chi_minh"] = "vox_pow1_s03_126A_wood_f";	//	Holy shit Mason we hit the mother lode! That's the Ho Chi Minh trail down below us.
	level.scr_sound[ "barnes" ][ "ho_chi_description"] = "vox_pow1_s03_127A_wood_f";	//	We got a pipeline to the south and the main camp to the north! We take them both out!

	level.scr_sound[ "barnes" ][ "great_shot"] = "vox_pow1_s03_139A_wood_f";	//	Great shot Mason!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_140A_wood_f";	//	Woohoo! Yeah, that's clear!
	level.scr_sound[ "barnes" ][ "kravchenko_ahead"] = "vox_pow1_s03_143A_wood_f";	//	All right. Kravchenko's compound should be just ahead.
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_144A_wood_f";	//	RPG tower by the pipeline!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_145A_wood_f";	//	Krachenko's compound should be right here. Keep your eyes open.
	level.scr_sound[ "barnes" ][ "radar_blip"] = "vox_pow1_s03_146A_wood_f";	//	I got a blip on the radar Mason. You see any�
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_148A_wood_f";	//	ENEMY HIND! Coming right at us!
	level.scr_sound[ "barnes" ][ "running"] = "vox_pow1_s03_151A_wood_f";	//	He's running! Hit him in the ass!
	level.scr_sound[ "barnes" ][ "bitch_please"] = "vox_pow1_s03_152A_wood_f";	//	Put that son of a bitch down!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_153A_wood_f";	//	You got him Mason. One last shot!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_156A_wood_f";	//	Contact! Now we got two!
	//level.scr_sound[ "player" ][ ""] = "vox_pow1_s03_157A_maso";		//	Son of a�
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_158A_wood_f";	//	Do it Mason!
	level.scr_sound[ "player_hands" ][ "yeah"] = "vox_pow1_s03_160A_maso";		//	Yeah!
	level.scr_sound[ "barnes" ][ "one_down"] = "vox_pow1_s03_161A_wood_f";	//	One down, one to go!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_163A_wood_f";	//	He's got a lock on us! Evade! Evade!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_165A_wood_f";	//	Keep hitting him!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_167A_wood_f";	//	Son of a bitchm this guy knows how to fly!
	//level.scr_sound[ "barnes" ][ ""] = "vox_pow1_s03_169A_wood_f";	//	All right� We're good. Put her in that clearing.
	
	level.scr_sound["barnes"]["krav_just_to_the_south"] = "vox_pow1_s04_400A_wood"; //Kravchenko's compound's just to the South.
  level.scr_sound["barnes"]["im_setting_her_down"] = "vox_pow1_s04_502A_wood_f"; //I'm setting her down in the clearing.
	
	
	// COMPOUND - Lead up into the cave
	level.scr_sound["barnes"]["play_this_quiet"] = "vox_pow1_s04_403A_wood"; //No reason to play this quiet, Mason.
  level.scr_sound["barnes"]["lets_do_it"] = "vox_pow1_s04_404A_wood"; //Let's do it.
	level.scr_sound["barnes"]["get_ft"] = "vox_pow1_s04_405A_wood"; //Mason - Grab that flamethrower!
	level.scr_sound["barnes"]["burn_bastards"] = "vox_pow1_s04_406A_wood"; //We'll burn these bastards!
	
	// COMPOUND - POWs
	level.scr_sound["pow_door"]["whos_out_there"] = "vox_pow1_s04_407A_red3"; //Who's out there?!
  level.scr_sound["pow_door"]["help_us"] = "vox_pow1_s04_408A_red4"; //Help us!!!  Please!!
  level.scr_sound["barnes"]["mason_theyre_pows"] = "vox_pow1_s04_409A_wood"; //Mason!! They're POWs.
  level.scr_sound["pow_door"]["youre_here_for_us"] = "vox_pow1_s04_410A_red3"; //You're here for us?!
  level.scr_sound["barnes"]["sog_were_gonna"] = "vox_pow1_s04_411A_wood"; //SOG. We're gonna get you out!
  //level.scr_sound["barnes"]["anime"] = "vox_pow1_s04_412A_wood"; //Mason - get the other one. //-- LINE CUT
  level.scr_sound["pow_door"]["thank_god"] = "vox_pow1_s04_413A_red4"; //Thank God! Please... hurry!
  
  //-- During the scene
  level.scr_sound["reznov"]["mason_is_that_you"] = "vox_pow1_s04_414A_rezn"; //Mason!!! Is that you?!
  level.scr_sound["player"]["reznov_ill_get_you"] = "vox_pow1_s04_415A_maso"; //Reznov! I'll get you out!
  
  //-- Nag Lines
  level.scr_sound["barnes"]["cell_nag_1"] = "vox_pow1_s99_441A_wood"; //Open the cells Mason!
   level.scr_sound["barnes"]["cell_nag_2"] = "vox_pow1_s99_442A_wood"; //Hurry up, open the cells!
  level.scr_sound["barnes"]["cell_nag_3"] = "vox_pow1_s04_418A_wood"; //Mason?!  What the fuck are you doing?!! We gotta get these guys out.

	//-- As Reznov walks away after being freed
	level.scr_sound["reznov"]["returned_to_russia"] = "vox_pow1_s04_422A_rezn"; //I was to be returned to Russia - for Dragovich to decide my fate.
  level.scr_sound["player"]["our_destiny"] = "vox_pow1_s04_423A_maso"; //We're in charge of our own destiny now, Reznov.
  level.scr_sound["player"]["krav_must_die"] = "vox_pow1_s04_424A_maso"; //Kravchenko must die.
  
  //-- NEW VO FOR AFTER RUSSIAN'S DEATH: 9/21/10
  level.scr_sound["barnes"]["you_got_im"] = "vox_pow1_s11_001A_wood"; // You got him
  level.scr_sound["barnes"]["for_bowman"] = "vox_pow1_s01_406A_wood"; // For Bowman.
  level.scr_sound["player"]["for_bowman"] = "vox_pow1_s01_407A_maso"; // For Bowman.
  level.scr_sound["barnes"]["we_aint_got"] = "vox_pow1_s11_002A_wood"; //We ain't got time to waste
  //level.scr_sound["barnes"]["lets_go"] = "vox_pow1_s01_267A_wood_m"; //Let's go. //-- This line exists earlier, but is still in use for this scene

}

init_VO_reloading()
{
	//-- for any reloading
	level.scr_sound[ "barnes" ][ "reload_0"] = "vox_pow1_s03_047A_wood_f";	//	UV-32s, reloading.
	level.scr_sound[ "barnes" ][ "reload_1"] = "vox_pow1_s03_050A_wood_f";	//	Reloading!
	
	//-- when auto-reload kicks off
	level.scr_sound[ "barnes" ][ "reload_2"] = "vox_pow1_s03_048A_wood_f";	//	Out of rockets! Wait for the reload!
}

init_VO_heli_dmg()
{
	level.scr_sound[ "barnes" ]["nag_dmg_0"] = "vox_pow1_s03_035A_wood_f";	//	Damn it, we can't take this heavy  fire, pull back!
	level.scr_sound[ "barnes" ]["nag_dmg_1"] = "vox_pow1_s03_036A_wood_f";	//	Get us out of here Mason!
	level.scr_sound[ "barnes" ]["nag_dmg_2"] = "vox_pow1_s03_037A_wood_f";	//	Pull back! We're taking too much flak!
	level.scr_sound[ "barnes" ]["nag_dmg_3"] = "vox_pow1_s03_038A_wood_f";	//	Christ Mason get this fucking bird moving!
}

init_VO_nag_rockets()
{
	level.scr_sound[ "barnes" ]["nag_sam0"] = "vox_pow1_s03_117A_wood_f";	//	Incoming! Move!
	level.scr_sound[ "barnes" ]["nag_sam1"] = "vox_pow1_s03_118A_wood_f";	//	They're locked on!
	level.scr_sound[ "barnes" ]["nag_sam2"] = "vox_pow1_s03_119A_wood_f";	//	Here it comes!
}

init_VO_nag_2nd_village()
{
	level.scr_sound[ "barnes" ]["nag_zsu0"] = "vox_pow1_s03_128A_wood_f";	//	ZSU on the road!
	level.scr_sound[ "barnes" ]["nag_zsu1"] = "vox_pow1_s03_133A_wood_f";	//	Enemy ZSUs moving into position!
	
	level.scr_sound[ "barnes" ][ "nag_zsu2"] = "vox_pow1_s03_141A_wood_f";	//	Two anit-air on the bridge, you see them?
	
	level.scr_sound[ "barnes" ]["nag_oil_line"] = "vox_pow1_s03_129A_wood_f";	//	Blow that oil line Mason!
	
	level.scr_sound[ "barnes" ]["nag_radar"] = "vox_pow1_s03_131A_wood_f";	//	You see that radar tower? Take it out!
	
	level.scr_sound[ "barnes" ]["nag_building0"] = "vox_pow1_s03_130A_wood_f";	//	Charlie's hiding in those buildings! Use the rockets!
	level.scr_sound[ "barnes" ]["nag_building1"] = "vox_pow1_s03_135A_wood_f";	//	Charlie's trying to hide! Take out the buildings!
	
	level.scr_sound[ "barnes" ]["nag_tower"] = "vox_pow1_s03_132A_wood_f";	//	RPGs in the towers!
	
	level.scr_sound[ "barnes" ]["nag_charlie"] = "vox_pow1_s03_138A_wood_f";	//	Oh shit yeah look at Charlie run!
	
	level.scr_sound[ "barnes" ]["nag_bunker0"] = "vox_pow1_s03_136A_wood_f";	//	Ammo bunkers buried in the hill. Drop the Uvs on them!
	level.scr_sound[ "barnes" ]["nag_bunker1"] = "vox_pow1_s03_137A_wood_f";	//	You got to burn all those bunkers!
}

init_russian_vo()
{
	//-- takeoff
	level.scr_sound[ "player_hands" ][ "control_this_is" ] = "vox_pow1_s03_051A_svp1"; //Control, this is Nomsky-22. We're picking up unauthorized traffic in area RP-7. looks like a Soviet helicopter.
	level.scr_sound[ "player_hands" ][ "noted_signature" ] = "vox_pow1_s03_052A_sov1"; //Noted. Signature reads Gorky-63. Gorky-63, state your flight plan, over.
	level.scr_sound[ "player_hands" ][ "repeat_gorky" ] = "vox_pow1_s03_053A_sov1"; //Repeat, Gorky-63 state your flight plan, over.
	level.scr_sound[ "player_hands" ][ "negative_response" ] = "vox_pow1_s03_054A_sov1"; //Negative response. Nomsky-22 investigate.
	level.scr_sound[ "player_hands" ][ "understood_on" ] = "vox_pow1_s03_055A_svp1"; //Understood. On our way.
	level.scr_sound[ "player_hands" ][ "control_please" ] = "vox_pow1_s03_056A_svp1"; //Control please repeat coordinates on Gorky-63, over.
	level.scr_sound[ "player_hands" ][ "gorky_has_moved" ] = "vox_pow1_s03_057A_sov1"; //Nomsky-22, Gorky-63 has moved to area TK-4, over. He's moving fast.
	level.scr_sound[ "player_hands" ][ "understood_over" ] = "vox_pow1_s03_058A_svp1"; //Understood, over.

	//-- truck depot
	level.scr_sound[ "player_hands" ][ "we_are_under" ] = "vox_pow1_s03_059A_sov2"; //We are under attack! It's one of ours!
	level.scr_sound[ "player_hands" ][ "control_nomsky22" ] = "vox_pow1_s03_060A_svp1"; //Control, Nomsky-22. Ground chatter indicates unknown combatant. Please advise, over.
	level.scr_sound[ "player_hands" ][ "we_need_immediate" ] = "vox_pow1_s03_063A_sov2"; //We need immediate air support!
	level.scr_sound[ "player_hands" ][ "soldier_identify" ] = "vox_pow1_s03_064A_svp1"; //Soldier, identify yourself!
	level.scr_sound[ "player_hands" ][ "ground_force" ] = "vox_pow1_s03_065A_svp1"; //Ground force commander, identify your units.


	//-- bend village
	level.scr_sound[ "player_hands" ][ "ground_force_commander" ] = "vox_pow1_s03_068A_svp1"; //Ground force commander, identify your position and units, over.
	level.scr_sound[ "player_hands" ][ "no_response" ] = "vox_pow1_s03_069A_svp1"; //No response. Control Nomsky-22 is inbound.
	level.scr_sound[ "player_hands" ][ "combat_authorized" ] = "vox_pow1_s03_098A_svp1"; //Combat authorized Nomsky-22. Fire at will.

	//-- sam missile
	level.scr_sound[ "player_hands" ][ "we_are_locked_on" ] = "vox_pow1_s03_099A_svp1"; //We are locked on, FIRE FIRE!
	level.scr_sound[ "player_hands" ][ "say_your_prayers" ] = "vox_pow1_s03_100A_svp1"; //Say your prayers, American.
	
	//-- large village
	level.scr_sound[ "player_hands" ][ "we_see_him" ] = "vox_pow1_s03_066A_sov2"; //We see him! Here he comes!
	level.scr_sound[ "player_hands" ][ "clear_this_channel" ] = "vox_pow1_s03_067A_svp1"; //Clear this channel! Priority 1 communications only!
	level.scr_sound[ "player_hands" ][ "where_the_hell_is_our" ] = "vox_pow1_s03_073A_sov1"; //Where the hell is our air support? We need the Hind helicopters here now!
	level.scr_sound[ "player_hands" ][ "stand_your_ground" ] = "vox_pow1_s03_074A_sov2"; //Stand your ground comrade! You will NOT retreat.
	level.scr_sound[ "player_hands" ][ "all_personel" ] = "vox_pow1_s03_070A_sov2"; //All personel we are under attack. Battle stations!
	level.scr_sound[ "player_hands" ][ "man_the_quad" ] = "vox_pow1_s03_071A_sov1"; //Man the Quad-50! MOVE MOVE MOVE!
	level.scr_sound[ "player_hands" ][ "gorky63_compromised" ] = "vox_pow1_s03_072A_sov2"; //Gorky-63 has been compromised. Repeat, Gorky-63 is an enemy combatant.
	level.scr_sound[ "player_hands" ][ "gorky63_identify" ] = "vox_pow1_s03_092A_svp1"; //Gorky-63 identify yourself immediately!
	level.scr_sound[ "player_hands" ][ "final_warning" ] = "vox_pow1_s03_094A_svp1"; //Final warning! Gorky-63 identify yourself.
	level.scr_sound[ "player_hands" ][ "control_we_have" ] = "vox_pow1_s03_096A_svp1"; //Control we have a rogue element in our airspace! Gorky-63 is compromised! He has engaged us!
	
	//-- hind vs hind fight starts
	level.scr_sound[ "player_hands" ][ "enemy_evaded" ] = "vox_pow1_s03_149A_svp1"; //Enemy evaded, I need support.
	level.scr_sound[ "player_hands" ][ "bait_him_back_to" ] = "vox_pow1_s03_150A_svp2"; //Bait him back to me. I'll take care of him.
	level.scr_sound[ "player_hands" ][ "hes_all_over_me" ] = "vox_pow1_s03_154A_svp1"; //He's all over me! Where are you?
	level.scr_sound[ "player_hands" ][ "right_here" ] = "vox_pow1_s03_155A_svp2"; //Right here�
	level.scr_sound[ "player_hands" ][ "circle_around" ] = "vox_pow1_s03_164A_svp2"; //Circle around, moving target.
	level.scr_sound[ "player_hands" ][ "i_have_him_in" ] = "vox_pow1_s03_147A_svp1"; //I have him in my sights!
	
	//-- hind1 crash
	level.scr_sound[ "player_hands" ][ "were_taking_damage" ] = "vox_pow1_s03_166A_svp2"; //We're taking damage here!
	level.scr_sound[ "player_hands" ][ "chernov_one_three" ] = "vox_pow1_s03_159A_svp1"; //Chernov One-Three� We've lost power�. Stabilizers are shot� We're going to crash�
	level.scr_sound[ "player_hands" ][ "im_going_to" ] = "vox_pow1_s03_162A_svp2"; //I'm going to eat this bastard for breakfast.
	
	//-- hind2 crash	
	level.scr_sound[ "player_hands" ][ "control_this_is" ] = "vox_pow1_s03_168A_svp2"; //Control, this is Chernov-Seven. We are hit! We're going down! Argh�.

}


open_pow_door1( guy )
{
	door = GetEnt("pow_door_1", "targetname");
	door rotate_pow_door("struct_pow_door_1");
}

open_pow_door2( guy )
{
	door = GetEnt("pow_door_2", "targetname");
	door rotate_pow_door("struct_pow_door_2");
}

open_pow_door3( guy )
{
	door = GetEnt("pow_door_3", "targetname");
	door rotate_pow_door("struct_pow_door_3");
}

rotate_pow_door( struct_name )
{
	struct = getstruct( struct_name, "targetname");
	
	door_ent = Spawn("script_model", struct.origin);
	door_ent SetModel("tag_origin_animate");
		
	self LinkTo(door_ent);
	
	door_ent RotateYaw( -5, 0.2, 0.1, 0 );
	door_ent waittill("rotatedone");
	wait(0.1);
	door_ent RotateYaw( -80, 3, 1, 0 );
	door_ent waittill("rotatedone");
	self ConnectPaths();
} 