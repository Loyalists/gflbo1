#include maps\vorkuta_util;
#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;

main()
{
	precache_generic_anims();
	precache_player_anims();
	precache_model_anims();
	precache_vehicle_anims();
	precache_drone_anims();
	precache_prop_anims();

	init_voice();
}

#using_animtree ("generic_human");
precache_generic_anims()
{
	//ON FIRE!!
    level.scr_anim["on_fire_1"]["burning_fate"] = %ai_flame_death_a;
    level.scr_anim["on_fire_2"]["burning_fate"] = %ai_flame_death_b;
    level.scr_anim["on_fire_3"]["burning_fate"] = %ai_flame_death_c;
    level.scr_anim["on_fire_4"]["burning_fate"] = %ai_flame_death_d;

	//choking
	level.scr_anim["generic"]["gas_choke"] = %exposed_death_neckgrab;

	//shield push
	level.scr_anim["generic"]["shield_push"][0] = %ch_vor_b02_minecart_reznov_push; //walk_CQB_F;

	//shield shoot
	level.scr_anim["generic"]["shield_right_shoot_low"][0] = %ch_vor_b03_soldier1_crouchFire_loop;
	level.scr_anim["generic"]["shield_right_shoot_high"][0] = %ch_vor_b03_soldier1_standFire_loop;
	level.scr_anim["generic"]["shield_left_shoot_low"][0] = %ch_vor_b03_soldier2_crouchFire_loop;
	level.scr_anim["generic"]["shield_left_shoot_high"][0] = %ch_vor_b03_soldier2_standFire_loop;

	//bike dodging
	level.scr_anim["generic"]["roll_right"] = %ai_spets_rusher_roll_45l_2_run_a_02;
	level.scr_anim["generic"]["roll_left"] = %ai_spets_rusher_roll_45l_2_run_a_02;

	//cheering
	level.scr_anim["generic"]["cheer"][0] = %ch_wmd_b01_grdweldingstand_loop;
	level.scr_anim["generic"]["rail_cheer_1_exit"] = %ch_vor_b01_rail_prisoner1_exit;
	level.scr_anim["generic"]["rail_cheer_1_loop"][0] = %ch_vor_b01_rail_prisoner1_loop;
	level.scr_anim["generic"]["rail_cheer_2_exit"] = %ch_vor_b01_rail_prisoner2_exit;
	level.scr_anim["generic"]["rail_cheer_2_loop"][0] = %ch_vor_b01_rail_prisoner2_loop;
	level.scr_anim["generic"]["rail_cheer_3_exit"] = %ch_vor_b01_rail_prisoner3_exit;
	level.scr_anim["generic"]["rail_cheer_3_loop"][0] = %ch_vor_b01_rail_prisoner3_loop;
	level.scr_anim["generic"]["rail_cheer_4_exit"] = %ch_vor_b01_rail_prisoner4_exit;
	level.scr_anim["generic"]["rail_cheer_4_loop"][0] = %ch_vor_b01_rail_prisoner4_loop;
	level.scr_anim["generic"]["rail_cheer_5_exit"] = %ch_vor_b01_rail_prisoner5_exit;
	level.scr_anim["generic"]["rail_cheer_5_loop"][0] = %ch_vor_b01_rail_prisoner5_loop;
	level.scr_anim["generic"]["rail_cheer_6_exit"] = %ch_vor_b01_rail_prisoner6_exit;
	level.scr_anim["generic"]["rail_cheer_6_loop"][0] = %ch_vor_b01_rail_prisoner6_loop;

	//mine intro
	level.scr_anim["reznov"]["intro_player"] = %ch_vor_b01_intro_resnov;
	level.scr_anim["guard"]["intro_player"] = %ch_vor_b01_intro_guard;
	level.scr_anim["prisoner_1"]["intro_player"] = %ch_vor_b01_intro_prisoner1;
	level.scr_anim["prisoner_2"]["intro_player"] = %ch_vor_b01_intro_prisoner2;
	level.scr_anim["prisoner_3"]["intro_player"] = %ch_vor_b01_intro_prisoner3;
	level.scr_anim["prisoner_4"]["intro_player"] = %ch_vor_b01_intro_prisoner4;
	level.scr_anim["prisoner_5"]["intro_player"] = %ch_vor_b01_intro_prisoner5;
	level.scr_anim["prisoner_6"]["intro_player"] = %ch_vor_b01_intro_prisoner6;
	level.scr_anim["reznov"]["intro_player_punch"] = %ch_vor_b01_intro_resnov_punch;
	level.scr_anim["guard"]["intro_player_punch"] = %ch_vor_b01_intro_guard_punch;
	level.scr_anim["prisoner_1"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner1_punch;
	level.scr_anim["prisoner_2"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner2_punch;
	level.scr_anim["prisoner_3"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner3_punch;
	level.scr_anim["prisoner_4"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner4_punch;
	level.scr_anim["prisoner_5"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner5_punch;
	level.scr_anim["prisoner_6"]["intro_player_punch"] = %ch_vor_b01_intro_prisoner6_punch;
	level.scr_anim["reznov"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_resnov_beat_loop;
	level.scr_anim["guard"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_guard_beat_loop;
	level.scr_anim["prisoner_1"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner1_beat_loop;
	level.scr_anim["prisoner_2"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner2_beat_loop;
	level.scr_anim["prisoner_3"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner3_beat_loop;
	level.scr_anim["prisoner_4"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner4_beat_loop;
	level.scr_anim["prisoner_5"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner5_beat_loop;
	level.scr_anim["prisoner_6"]["intro_player_beat_loop"][0] = %ch_vor_b01_intro_prisoner6_beat_loop;
	level.scr_anim["reznov"]["intro_player_smash"] = %ch_vor_b01_intro_resnov_smash;
	level.scr_anim["guard"]["intro_player_smash"] = %ch_vor_b01_intro_guard_smash;
	level.scr_anim["prisoner_1"]["intro_player_smash"] = %ch_vor_b01_intro_prisoner1_smash;
	level.scr_anim["prisoner_2"]["intro_player_smash"] = %ch_vor_b01_intro_prisoner2_smash;
	level.scr_anim["prisoner_3"]["intro_player_smash"] = %ch_vor_b01_intro_prisoner3_smash;
	level.scr_anim["prisoner_4"]["intro_player_smash"] = %ch_vor_b01_intro_prisoner4_smash;
	level.scr_anim["guard"]["intro_player_dead"][0] = %ch_vor_b01_intro_guard_dead;
	addNotetrack_customFunction("reznov", "switch_baton", maps\vorkuta_mine::event_1_grab_baton, "intro_player_smash");
	addNotetrack_customFunction("reznov", "show key", maps\vorkuta_mine::event_1_grab_keys, "intro_player_smash");
	addNotetrack_flag("reznov", "end_loop", "flag_stop_intro_prisoner_loop", "intro_player_smash");

	addNotetrack_FXOnTag("guard", "intro_player_smash", "start_blood", "punch_blood", "J_Jaw");
	addNotetrack_FXOnTag("guard", "intro_player_smash", "start_dust", "fall_dust", "J_SpineLower");
	
	addNotetrack_customFunction( "reznov", "audio_cheer_1", ::audio_clientnotify_cheer1, "intro_player" );
	addNotetrack_customFunction( "reznov", "audio_cheer_2", ::audio_clientnotify_cheer2, "intro_player" );
	addNotetrack_customFunction( "reznov", "audio_cheer_3", ::audio_clientnotify_cheer3, "intro_player_punch" );
	addNotetrack_customFunction( "guard", "audio_cheer_4", ::audio_clientnotify_cheer4, "intro_player_smash" );

	//reznov guidance through mine
	level.scr_anim["reznov"]["guide_mine_start_01"] = %ch_vor_b01_resnov_yell_keepup1_start;
	level.scr_anim["reznov"]["guide_mine_loop_01"][0] = %ch_vor_b01_resnov_yell_keepup1_loop;
	level.scr_anim["reznov"]["guide_mine_end_01"] = %ch_vor_b01_resnov_yell_keepup1_end;
	level.scr_anim["reznov"]["guide_mine_start_02"] = %ch_vor_b01_resnov_yell_keepup2_start;
	level.scr_anim["reznov"]["guide_mine_loop_02"][0] = %ch_vor_b01_resnov_yell_keepup2_loop;
	level.scr_anim["reznov"]["guide_mine_end_02"] = %ch_vor_b01_resnov_yell_keepup2_end;	

	//mine vignettes between intro and sergei
	level.scr_anim["prisoner_1"]["mine_vig_first_encounter"][0] = %ch_vor_b01_stomp_prisoner1;
	level.scr_anim["prisoner_2"]["mine_vig_first_encounter"][0] = %ch_vor_b01_stomp_prisoner2;
	level.scr_anim["guard"]["mine_vig_first_encounter"][0] = %ch_vor_b01_stomp_guard;		
	level.scr_anim["prisoner_1"]["mine_vig_guard_attack_player_intro"][0] = %ch_vor_b01_tackle_prisoner1_idle;
	level.scr_anim["prisoner_2"]["mine_vig_guard_attack_player_intro"][0] = %ch_vor_b01_tackle_prisoner2_idle;
	level.scr_anim["prisoner_1"]["mine_vig_guard_attack_player"] = %ch_vor_b01_tackle_prisoner1;
	level.scr_anim["prisoner_2"]["mine_vig_guard_attack_player"] = %ch_vor_b01_tackle_prisoner2;
	level.scr_anim["guard_1"]["mine_vig_guard_attack_player"] = %ch_vor_b01_tackle_guard1;
	level.scr_anim["guard_2"]["mine_vig_guard_attack_player"] = %ch_vor_b01_tackle_guard2;
	level.scr_anim["prisoner_1"]["mine_vig_guard_attack_player_outro"][0] = %ch_vor_b01_tackle_prisoner1_loop;
	level.scr_anim["prisoner_1"]["mine_vig_guard_attack_player_exit"] = %ch_vor_b01_tackle_prisoner1_exit;
	level.scr_anim["guard_1"]["mine_vig_guard_attack_player_outro"][0] = %ch_vor_b01_tackle_guard1_loop;
	level.scr_anim["prisoner"]["mine_vig_pre_sergei_01"][0] = %ch_vor_b01_tunnel_prisoner_beat_loop1;
	level.scr_anim["guard"]["mine_vig_pre_sergei_01"][0] = %ch_vor_b01_tunnel_gaurd_beat_loop1;
	level.scr_anim["prisoner"]["mine_vig_pre_sergei_02_intro"] = %ch_vor_b01_tunnel_prisoner_drag_1;
	level.scr_anim["guard"]["mine_vig_pre_sergei_02_intro"] = %ch_vor_b01_tunnel_gaurd_drag_1;
	level.scr_anim["prisoner"]["mine_vig_pre_sergei_02"][0] = %ch_vor_b01_tunnel_prisoner_drag_loop1;
	level.scr_anim["guard"]["mine_vig_pre_sergei_02"][0] = %ch_vor_b01_tunnel_gaurd_drag_loop1;
	level.scr_anim["guard_1"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_guard1;
	level.scr_anim["guard_2"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_guard2;
	level.scr_anim["guard_3"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_guard3;
	level.scr_anim["prisoner_1"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_prisoner1;
	level.scr_anim["prisoner_2"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_prisoner2;
	level.scr_anim["prisoner_3"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_prisoner3;
	level.scr_anim["prisoner_4"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_prisoner4;
	level.scr_anim["prisoner_5"]["mine_vig_pre_sergei_wall"] = %ch_vor_b01_wall_fighting_prisoner5;
	level.scr_anim["guard_1"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_guard1;
	level.scr_anim["guard_2"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_guard2;
	level.scr_anim["guard_3"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_guard3;
	level.scr_anim["prisoner_1"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_prisoner1;
	level.scr_anim["prisoner_2"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_prisoner2;
	level.scr_anim["prisoner_3"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_prisoner3;
	level.scr_anim["prisoner_4"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_prisoner4;
	level.scr_anim["prisoner_5"]["mine_vig_pre_sergei_wall_exit"] = %ch_vor_b01_wall_break_prisoner5;
	
	//sergei intro
	level.scr_anim["sergei"]["intro_sergei"] = %ch_vor_b01_sergei_intro;
	level.scr_anim["sergei"]["intro_sergei_end"] = %ch_vor_b01_sergei_intro_exit_run;
	level.scr_anim["sergei"]["intro_sergei_end_loop"][0] = %ch_vor_b01_sergei_intro_exit_run_end_loop;
	level.scr_anim["victim_1"]["intro_sergei"] = %ch_vor_b01_sergei_intro_choke;
	level.scr_anim["victim_2"]["intro_sergei"] = %ch_vor_b01_sergei_intro_headlock;
	level.scr_anim["victim_3"]["intro_sergei"] = %ch_vor_b01_sergei_intro_tosed;
	level.scr_anim["reznov"]["intro_sergei"] = %ch_vor_b01_sergei_intro_reznov;
	level.scr_anim["prisoner_russian_1"]["intro_sergei_wall_start"] = %ch_vor_b01_sergei_wall_russian1_start_loop;
	level.scr_anim["prisoner_russian_2"]["intro_sergei_wall_start"] = %ch_vor_b01_sergei_wall_russian2_start_loop;
	level.scr_anim["prisoner_russian_3"]["intro_sergei_wall_start"] = %ch_vor_b01_sergei_wall_prsnr1_start_loop;
	level.scr_anim["victim_1"]["intro_sergei_wall_start"] = %ch_vor_b01_sergei_wall_victim1_backpeddle;
	level.scr_anim["victim_2"]["intro_sergei_wall_start"] = %ch_vor_b01_sergei_wall_victim2_backpeddle;
	level.scr_anim["prisoner_russian_1"]["intro_sergei_wall"][0] = %ch_vor_b01_sergei_wall_russian1_loop;
	level.scr_anim["prisoner_russian_2"]["intro_sergei_wall"][0] = %ch_vor_b01_sergei_wall_russian2_loop;
	level.scr_anim["prisoner_russian_3"]["intro_sergei_wall"][0] = %ch_vor_b01_sergei_wall_prsnr1_loop;
	level.scr_anim["victim_1"]["intro_sergei_wall"][0] = %ch_vor_b01_sergei_wall_victim1_loop;
	level.scr_anim["victim_2"]["intro_sergei_wall"][0] = %ch_vor_b01_sergei_wall_victim2_loop;
	level.scr_anim["prisoner_russian_1"]["intro_sergei_wall_exit"] = %ch_vor_b01_sergei_wall_russian1_exit;
	level.scr_anim["prisoner_russian_2"]["intro_sergei_wall_exit"] = %ch_vor_b01_sergei_wall_russian2_exit;
	level.scr_anim["prisoner_russian_3"]["intro_sergei_wall_exit"] = %ch_vor_b01_sergei_wall_prsnr1_exit;
	level.scr_anim["victim_1"]["intro_sergei_wall_death"] = %ch_vor_b01_sergei_wall_victim1_deathLoop;
	level.scr_anim["victim_2"]["intro_sergei_wall_death"] = %ch_vor_b01_sergei_wall_victim2_deathLoop;	
	addNotetrack_customFunction("reznov", "start_vox_vor1_s1_033A_maso", maps\vorkuta_mine::event_2_sergei_intro_player_vo, "intro_sergei");

	//mine vignettes between sergei intro and inclinator
	level.scr_anim["prisoner"]["mine_vig_post_sergei_01"][0] = %ch_vor_b01_mine_gaurd_beat_loop;
	level.scr_anim["guard"]["mine_vig_post_sergei_01"][0] = %ch_vor_b01_mine_prsnr_beat_loop;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_01_exit"] = %ch_vor_b01_mine_gaurd_beat_exit;
	level.scr_anim["guard"]["mine_vig_post_sergei_01_exit"] = %ch_vor_b01_mine_prsnr_beat_death;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_01_enter"] = %ch_vor_b01_inclinator_guy7_enter;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_01_loop"][0] = %ch_vor_b01_inclinator_guy7_idle;

	level.scr_anim["prisoner"]["mine_vig_post_sergei_02"][0] = %ch_vor_b01_mine_prsnr_dragging_loop;
	level.scr_anim["guard"]["mine_vig_post_sergei_02"][0] = %ch_vor_b01_mine_gaurd_dragged_loop;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_02_exit"] = %ch_vor_b01_mine_con_hit_AA_exit;
	level.scr_anim["guard"]["mine_vig_post_sergei_02_exit"] = %ch_vor_b01_mine_gaurd_hurt_AA_death;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_02_enter"] = %ch_vor_b01_inclinator_guy8_enter;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_02_loop"][0] = %ch_vor_b01_inclinator_guy8_idle;

	level.scr_anim["prisoner"]["mine_vig_post_sergei_03_entry"] = %ch_vor_b01_mines_punchout1_entry;
	level.scr_anim["guard"]["mine_vig_post_sergei_03_entry"] = %ch_vor_b01_mines_punchout2_entry;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_03"][0] = %ch_vor_b01_mines_punchout1;
	level.scr_anim["guard"]["mine_vig_post_sergei_03"][0] = %ch_vor_b01_mines_punchout2;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_03_exit"] = %ch_vor_b01_mines_punchout1_exit;
	level.scr_anim["guard"]["mine_vig_post_sergei_03_exit"] = %ch_vor_b01_mines_punchout2_exit;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_03_enter"] = %ch_vor_b01_inclinator_guy6_enter;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_03_loop"][0] = %ch_vor_b01_inclinator_guy6_idle;

	level.scr_anim["prisoner"]["mine_vig_post_sergei_04"][0] = %ch_vor_b01_mines_stand_punchout3;
	level.scr_anim["guard"]["mine_vig_post_sergei_04"][0] = %ch_vor_b01_mines_stand_punchout4;
	level.scr_anim["prisoner"]["mine_vig_post_sergei_04_exit"] = %ch_vor_b01_mines_standl_punchout3_death;
	level.scr_anim["guard"]["mine_vig_post_sergei_04_exit"] = %ch_vor_b01_mines_standl_punchout4_exit;

	//pre inclinator
	level.scr_anim["prisoner_cntrl"]["mine_control_loop"][0] = %ch_vor_b01_inclinator_guy_cntrl_box_loop1;
	level.scr_anim["prisoner_cntrl"]["mine_control_move"] = %ch_vor_b01_inclinator_guy_cntrl_box_run_from_box;
	level.scr_anim["prisoner_cntrl"]["mine_control_wait"][0] = %ch_vor_b01_inclinator_guy_cntrl_box_waiting_loop;
	level.scr_anim["prisoner_1"]["mine_wait_inclinator"][0] = %ch_vor_b01_inclinator_guy1;
	level.scr_anim["prisoner_2"]["mine_wait_inclinator"][0] = %ch_vor_b01_inclinator_guy2;
	level.scr_anim["prisoner_4"]["mine_wait_inclinator"][0] = %ch_vor_b01_inclinator_guy4;
	level.scr_anim["prisoner_5"]["mine_wait_inclinator"][0] = %ch_vor_b01_inclinator_guy5;
	level.scr_anim["prisoner_russian_1"]["approach_inclinator"] = %ch_vor_b01_approach_inclinator_russian1;
	level.scr_anim["prisoner_russian_2"]["approach_inclinator"] = %ch_vor_b01_approach_inclinator_russian2;
	level.scr_anim["sergei"]["approach_inclinator"] = %ch_vor_b01_approach_inclinator_sergei;
	level.scr_anim["prisoner_russian_1"]["unlock_inclinator"][0] = %ch_vor_b01_inclinator_russian1;
	level.scr_anim["prisoner_russian_2"]["unlock_inclinator"][0] = %ch_vor_b01_inclinator_russian2;
	level.scr_anim["reznov"]["unlock_inclinator_enter"] = %ch_vor_b01_inclinator_reznov_keys_enter;
	level.scr_anim["reznov"]["unlock_inclinator_loop"][0] = %ch_vor_b01_inclinator_reznov_keys_loop;
	level.scr_anim["reznov"]["unlock_inclinator"] = %ch_vor_b01_inclinator_reznov_keys;
	level.scr_anim["sergei"]["unlock_inclinator"][0] = %ch_vor_b01_inclinator_sergei;
	addNotetrack_flag("reznov", "start_door", "flag_inclinator_door_start", "unlock_inclinator");
	addNotetrack_flag("reznov", "start_board", "flag_front_board", "unlock_inclinator");
	addNotetrack_flag("reznov", "start_dooropen", "flag_inclinator_door_finish", "unlock_inclinator");
	addNotetrack_flag("reznov", "start_sergei", "flag_sergei_board", "unlock_inclinator");
	
	//boarding inclinator
	level.scr_anim["prisoner_1"]["mine_board_inclinator"] = %ch_vor_b01_inclinator_board_guy1;
	level.scr_anim["prisoner_2"]["mine_board_inclinator"] = %ch_vor_b01_inclinator_board_guy2;
	level.scr_anim["prisoner_5"]["mine_board_inclinator"] = %ch_vor_b01_inclinator_board_guy5;
	level.scr_anim["prisoner_cntrl"]["mine_board_inclinator"] = %ch_vor_b01_inclinator_board_guy_cntrl_box;
	level.scr_anim["sergei"]["mine_board_inclinator"] = %ch_vor_b01_inclinator_board_sergei;
	addNotetrack_customFunction("sergei","pickup axe", maps\vorkuta_mine::event_3_pick_up_axe, "mine_board_inclinator");

	//guy stays behind
	level.scr_anim["prisoner_4"]["mine_stay_behind"] = %ch_vor_b01_inclinator_board_guy4;
	level.scr_anim["prisoner_4"]["mine_stay_behind_loop"][0] = %ch_vor_b01_inclinator_board_guy4_idle;

	//ride inclinator
	level.scr_anim["prisoner_1"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_guy1;
	level.scr_anim["prisoner_2"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_guy2;
	level.scr_anim["prisoner_5"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_guy5;
	level.scr_anim["prisoner_cntrl"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_guy_cntrl_box;
	level.scr_anim["reznov"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_reznov;
	level.scr_anim["sergei"]["mine_ride_inclinator"][0] = %ch_vor_b01_inclinator_ride_sergei;

	//conversation in inclinator between reznov and guy
	level.scr_anim["reznov"]["mine_inclinator_talk"] = %ch_vor_b01_inclinator_brothers_reznov;
	level.scr_anim["reznov"]["mine_inclinator_talk_loop"][0] = %ch_vor_b01_inclinator_brothers_reznov_idle;
	level.scr_anim["prisoner_2"]["mine_inclinator_talk"] = %ch_vor_b01_inclinator_brothers_guy4;
	level.scr_anim["prisoner_2"]["mine_inclinator_talk_loop"][0] = %ch_vor_b01_inclinator_ride_guy2_idle2;

	//sergei vs guard
	level.scr_anim["sergei"]["mine_sergei_vs_guard"]= %ch_vor_b01_lobby_sergei_skewer;
	level.scr_anim["reznov"]["mine_sergei_vs_guard"] = %ch_vor_b01_lobby_reznov_skewer;
	level.scr_anim["guard"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_guard;
	level.scr_anim["prsnr1"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr1;
	level.scr_anim["prsnr2"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr2;
	level.scr_anim["prsnr3"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr3;
	level.scr_anim["prsnr4"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr4;
	level.scr_anim["prsnr5"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr5;
	level.scr_anim["prsnr6"]["mine_sergei_vs_guard"] = %ch_vor_b01_skewer_prsnr6;
	addNotetrack_flag("guard", "start_sergei", "flag_sergei_skewer", "mine_sergei_vs_guard");
	addNotetrack_customFunction("guard", "start_blood", maps\vorkuta_mine::event_3_bleed, "mine_sergei_vs_guard");
	addNotetrack_customFunction("sergei", "axe drop", maps\vorkuta_mine::event_3_drop_axe, "mine_sergei_vs_guard");

	//exit room skirmishes
	level.scr_anim["prsnr3"]["move_to_door"] = %ch_vor_b01_lobby_fight1_prsnr1;
	level.scr_anim["prsnr4"]["move_to_door"] = %ch_vor_b01_lobby_fight1_prsnr2;
	level.scr_anim["prsnr5"]["move_to_door"] = %ch_vor_b01_lobby_fight2_prsnr1;
	level.scr_anim["prsnr6"]["move_to_door"] = %ch_vor_b01_lobby_fight2_prsnr2;
	
	level.scr_anim["guard"]["exit_fight_05_exit"] = %ch_vor_b01_lobby_fight3_grd;
	level.scr_anim["guard"]["exit_fight_05_loop"][0] = %ch_vor_b01_lobby_fight3_grd_loop;
	level.scr_anim["fight3_prisoner_1"]["exit_fight_05_exit"] = %ch_vor_b01_lobby_fight3_prsnr;
	level.scr_anim["fight3_prisoner_1"]["exit_fight_05_loop"][0] = %ch_vor_b01_lobby_fight3_prsnr_loop;
	level.scr_anim["fight4_prisoner_1"]["exit_fight_06_exit"] = %ch_vor_b01_lobby_fight4_prsnr1;
	level.scr_anim["fight4_prisoner_1"]["exit_fight_06_loop"][0] = %ch_vor_b01_lobby_fight4_prsnr1_loop;
	level.scr_anim["fight4_prisoner_2"]["exit_fight_06_exit"] = %ch_vor_b01_lobby_fight4_prsnr2;
	level.scr_anim["fight4_prisoner_2"]["exit_fight_06_loop"][0] = %ch_vor_b01_lobby_fight4_prsnr2_loop;

	//exit inclinator
	level.scr_anim["prisoner_1"]["exit_inclinator"] = %ch_vor_b01_inc_exit_p1;
	level.scr_anim["prisoner_2"]["exit_inclinator"] = %ch_vor_b01_inc_exit_p2;
	level.scr_anim["prisoner_4"]["exit_inclinator"] = %ch_vor_b01_inc_exit_p4;
	level.scr_anim["prisoner_5"]["exit_inclinator"] = %ch_vor_b01_inc_exit_p5;
	level.scr_anim["prisoner_cntrl"]["exit_inclinator"] = %ch_vor_b01_inc_exit_ctrl;
	level.scr_anim["prisoner_russian_1"]["exit_inclinator"] = %ch_vor_b01_inc_exit_r1;
	level.scr_anim["prisoner_russian_2"]["exit_inclinator"] = %ch_vor_b01_inc_exit_r2;		

	//move to door
	level.scr_anim["prisoner_1"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_guy1_exit;
	level.scr_anim["prisoner_2"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_guy2_exit;
	level.scr_anim["prisoner_4"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_guy4_exit;
	level.scr_anim["prisoner_5"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_guy5_exit;
	level.scr_anim["prisoner_cntrl"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_guy_cntrl_box_exit;
	level.scr_anim["prisoner_russian_1"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_russian1_exit;
	level.scr_anim["prisoner_russian_2"]["mine_exit_inclinator"] = %ch_vor_b01_lobby_russian2_exit;
				
	//ready at the doors
	level.scr_anim["prisoner_1"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_guy1_loop;
	level.scr_anim["prisoner_2"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_guy2_loop;
	level.scr_anim["prisoner_4"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_guy4_loop;
	level.scr_anim["prisoner_5"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_guy5_loop;
	level.scr_anim["prisoner_cntrl"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_guy_cntrl_box_loop;
	level.scr_anim["prisoner_russian_1"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_russian1_loop;
	level.scr_anim["prisoner_russian_2"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_russian2_loop;
	level.scr_anim["prsnr3"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight1_prsnr1_loop;
	level.scr_anim["prsnr4"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight1_prsnr2_loop;
	level.scr_anim["prsnr5"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight2_prsnr1_loop;
	level.scr_anim["prsnr6"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight2_prsnr2_loop;
	level.scr_anim["fight3_prisoner_1"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight3_prsnr_loop;
	level.scr_anim["fight4_prisoner_1"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight4_prsnr1_loop;
	level.scr_anim["fight4_prisoner_2"]["mine_exit_ready"][0] = %ch_vor_b01_omaha_fight4_prsnr2_loop;
	
	level.scr_anim["prisoner_1"]["mine_exit_final"] = %ch_vor_b02_omaha_guy1_exit;
	level.scr_anim["prisoner_2"]["mine_exit_final"] = %ch_vor_b02_omaha_guy2_exit;
	level.scr_anim["prisoner_4"]["mine_exit_final"] = %ch_vor_b02_omaha_guy4_exit;
	level.scr_anim["prisoner_5"]["mine_exit_final"] = %ch_vor_b02_omaha_guy5_exit;
	level.scr_anim["prisoner_cntrl"]["mine_exit_final"] = %ch_vor_b02_omaha_guy_cntrl_box_exit;
	level.scr_anim["prisoner_russian_1"]["mine_exit_final"] = %ch_vor_b02_omaha_russian1_exit;
	level.scr_anim["prisoner_russian_2"]["mine_exit_final"] = %ch_vor_b02_omaha_russian2_exit;
	level.scr_anim["prsnr3"]["mine_exit_final"] = %ch_vor_b02_omaha_fight1_prsnr1_exit;
	level.scr_anim["prsnr4"]["mine_exit_final"] = %ch_vor_b02_omaha_fight1_prsnr2_exit;
	level.scr_anim["prsnr5"]["mine_exit_final"] = %ch_vor_b02_omaha_fight2_prsnr1_exit;
	level.scr_anim["prsnr6"]["mine_exit_final"] = %ch_vor_b02_omaha_fight2_prsnr2_exit;
	level.scr_anim["fight3_prisoner_1"]["mine_exit_final"] = %ch_vor_b02_omaha_fight3_prsnr_exit;
	level.scr_anim["fight4_prisoner_1"]["mine_exit_final"] = %ch_vor_b02_omaha_fight4_prsnr1_exit;
	level.scr_anim["fight4_prisoner_2"]["mine_exit_final"] = %ch_vor_b02_omaha_fight4_prsnr2_exit;
	addNotetrack_customFunction("prisoner_1", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_2", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_4", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_5", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_cntrl", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_russian_1", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prisoner_russian_2", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prsnr3", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prsnr4", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prsnr5", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("prsnr6", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("fight3_prisoner_1", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("fight4_prisoner_1", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");
	addNotetrack_customFunction("fight4_prisoner_2", "get_shot", maps\vorkuta_mine::event_4_notetrack_impacts, "mine_exit_final");

	//reznov exit mine
	level.scr_anim["reznov"]["exit_inclinator"] = %ch_vor_b01_lobby_reznov_exit;
	level.scr_anim["reznov"]["exit_door_loop"][0] = %ch_vor_b01_omaha_reznov_loop;
	level.scr_anim["reznov"]["exit_speech"] = %ch_vor_b01_omaha_reznov;
	level.scr_anim["reznov"]["exit_door_open_loop"][0] = %ch_vor_b02_omaha_reznov_idle;
	level.scr_anim["reznov"]["exit_warn"] = %ch_vor_b02_omaha_reznov_stayback;
	level.scr_anim["reznov"]["exit_final"] = %ch_vor_b02_omaha_reznov_exit;
	addNotetrack_flag("reznov", "start_door", "flag_exit_mine", "exit_speech");

	//sergei exit mine
	level.scr_anim["sergei"]["exit_inclinator"] = %ch_vor_b01_lobby_sergei_exit;
	level.scr_anim["sergei"]["exit_door_loop"][0] = %ch_vor_b01_omaha_sergei_loop;
	level.scr_anim["sergei"]["exit_flinch"] = %ch_vor_b02_omaha_sergei_flinch;
	level.scr_anim["sergei"]["exit_door_open_loop"][0] = %ch_vor_b02_omaha_sergei_idle;
	level.scr_anim["sergei"]["exit_final"] = %ch_vor_b02_omaha_sergei_exit;

	//omaha bridge
	//level.scr_anim["prisoner_1"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner1;
	level.scr_anim["prisoner_1"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner2;
	level.scr_anim["prisoner_2"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner3;
	//level.scr_anim["prisoner_4"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner4;
	level.scr_anim["prisoner_3"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner5;
	//level.scr_anim["prisoner_6"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner6;
	//level.scr_anim["prisoner_4"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner7;
	//level.scr_anim["prisoner_5"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner8;
	//level.scr_anim["prisoner_9"]["omaha_bridge"] = %ch_vor_b02_bridge_prisoner9;
	level.scr_anim["guard_1"]["omaha_bridge"] = %ch_vor_b02_bridge_guard1;
	level.scr_anim["guard_2"]["omaha_bridge"] = %ch_vor_b02_bridge_guard2;
	level.scr_anim["guard_3"]["omaha_bridge"] = %ch_vor_b02_bridge_guard3;
	addNotetrack_customFunction("guard_1", "start_panel_2", maps\vorkuta_mine::event_4_panel_2, "omaha_bridge");
	addNotetrack_customFunction("guard_2", "start_panel_1", maps\vorkuta_mine::event_4_panel_1, "omaha_bridge");

	//cart push on left side
	level.scr_anim["prisoner_1"]["left_cart_enter"] = %ch_vor_b02_minecart_prsnr1_enter;
	level.scr_anim["prisoner_2"]["left_cart_enter"] = %ch_vor_b02_minecart_prsnr2_enter;
	level.scr_anim["prisoner_3"]["left_cart_enter"] = %ch_vor_b02_minecart_prsnr3_enter;
	level.scr_anim["prisoner_1"]["left_cart_idle1"][0] = %ch_vor_b02_minecart_prsnr1_idle1;
	level.scr_anim["prisoner_2"]["left_cart_idle1"][0] = %ch_vor_b02_minecart_prsnr2_idle1;
	level.scr_anim["prisoner_3"]["left_cart_idle1"][0] = %ch_vor_b02_minecart_prsnr3_idle1;
	level.scr_anim["prisoner_1"]["left_cart_trans_push"] = %ch_vor_b02_minecart_prsnr1_trans2_push;
	level.scr_anim["prisoner_2"]["left_cart_trans_push"] = %ch_vor_b02_minecart_prsnr2_trans2_push;
	level.scr_anim["prisoner_3"]["left_cart_trans_push"] = %ch_vor_b02_minecart_prsnr3_trans2_push;
	level.scr_anim["prisoner_1"]["left_cart_push"][0] = %ch_vor_b02_minecart_prsnr1_push;
	level.scr_anim["prisoner_2"]["left_cart_push"][0] = %ch_vor_b02_minecart_prsnr2_push;
	level.scr_anim["prisoner_3"]["left_cart_push"][0] = %ch_vor_b02_minecart_prsnr3_push;
	level.scr_anim["prisoner_1"]["left_cart_trans_idle"] = %ch_vor_b02_minecart_prsnr1_trans2_idle2;
	level.scr_anim["prisoner_2"]["left_cart_trans_idle"] = %ch_vor_b02_minecart_prsnr2_trans2_idle2;
	level.scr_anim["prisoner_3"]["left_cart_trans_idle"] = %ch_vor_b02_minecart_prsnr3_trans2_idle2;
	level.scr_anim["prisoner_1"]["left_cart_sling"][0] = %ch_vor_b02_minecart_prsnr1_slingshot;
	level.scr_anim["prisoner_2"]["left_cart_sling"][0] = %ch_vor_b02_minecart_prsnr2_slingshot;
	level.scr_anim["prisoner_3"]["left_cart_sling"][0] = %ch_vor_b02_minecart_prsnr3_slingshot;
	level.scr_anim["prisoner_1"]["left_cart_exit"][0] = %ch_vor_b02_minecart_prsnr1_exit;
	level.scr_anim["prisoner_2"]["left_cart_exit"][0] = %ch_vor_b02_minecart_prsnr2_exit;
	level.scr_anim["prisoner_3"]["left_cart_exit"][0] = %ch_vor_b02_minecart_prsnr3_exit;
	//addNotetrack_customFunction("prisoner_1", "light_slingshot", maps\vorkuta_surface::tower_fireball_load, "left_cart_sling");
	addNotetrack_customFunction("prisoner_1", "start_sling", maps\vorkuta_surface::tower_fireball, "left_cart_sling");

	//cart push on right side
	level.scr_anim["sergei"]["right_cart_enter"] = %ch_vor_b02_minecart_sergei_enter;
	level.scr_anim["reznov"]["right_cart_enter"] = %ch_vor_b02_minecart_reznov_enter;
	level.scr_anim["sergei"]["right_cart_idle1"][0] = %ch_vor_b02_minecart_sergei_idle1;
	level.scr_anim["reznov"]["right_cart_idle1"][0] = %ch_vor_b02_minecart_reznov_idle1;
	level.scr_anim["sergei"]["right_cart_trans_push"] = %ch_vor_b02_minecart_sergei_trans2_push;
	level.scr_anim["reznov"]["right_cart_trans_push"] = %ch_vor_b02_minecart_reznov_trans2_push;
	level.scr_anim["sergei"]["right_cart_push"][0] = %ch_vor_b02_minecart_sergei_push;
	level.scr_anim["reznov"]["right_cart_push"][0] = %ch_vor_b02_minecart_reznov_push;
	level.scr_anim["sergei"]["right_cart_trans_idle"] = %ch_vor_b02_minecart_sergei_trans2_idle2;
	level.scr_anim["reznov"]["right_cart_trans_idle"] = %ch_vor_b02_minecart_reznov_trans2_idle2;
	level.scr_anim["sergei"]["right_cart_idle2"][0] = %ch_vor_b02_minecart_sergei_idle2;
	level.scr_anim["reznov"]["right_cart_idle2"][0] = %ch_vor_b02_minecart_reznov_idle2;
	level.scr_anim["sergei"]["right_cart_exit"] = %ch_vor_b02_minecart_sergei_leave;
	level.scr_anim["reznov"]["right_cart_exit"] = %ch_vor_b02_minecart_reznov_leave;
	
	//slingshot interior
	level.scr_anim["sergei"]["cover_left_enter"] = %ch_vor_b02_sergei_cover_l_enter;
	level.scr_anim["sergei"]["cover_left"][0] = %ch_vor_b02_sergei_cover_l;
	level.scr_anim["sergei"]["cover_left_exit"] = %ch_vor_b02_sergei_cover_l_exit;
	level.scr_anim["reznov"]["slingshot_door_enter"] = %ch_vor_b02_reznov_kickdoor_enter;
	level.scr_anim["reznov"]["slingshot_door_loop"][0] = %ch_vor_b02_reznov_kickdoor_loop;
	level.scr_anim["reznov"]["slingshot_door_exit"] = %ch_vor_b02_reznov_kickdoor_exit;
	level.scr_anim["reznov"]["reznov_start"] = %ch_vor_b02_instruction_a_reznov_start;
	level.scr_anim["reznov"]["reznov_instruct"] = %ch_vor_b02_instruction_a_reznov;
	level.scr_anim["sergei"]["reznov_instruct"]= %ch_vor_b02_instruction_a_sergei;
	level.scr_anim["sergei"]["reznov_instruct_loop"][0] = %ch_vor_b02_instruction_a_sergei_loop;
	level.scr_anim["reznov"]["reznov_radio"] = %ch_vor_b02_instruction_b_reznov_enter;
	level.scr_anim["reznov"]["reznov_radio_idle"][0] = %ch_vor_b02_instruction_b_reznov_idle;
	level.scr_anim["reznov"]["reznov_radio_talk"] = %ch_vor_b02_instruction_b_reznov;
	level.scr_anim["reznov"]["reznov_radio_idle2"][0] = %ch_vor_b02_instruction_b_reznov_idle2;
	addNotetrack_customFunction("reznov", "kick_door", maps\vorkuta_surface::slingshot_int_door_open, "slingshot_door_exit");
	addNotetrack_customFunction("sergei", "door_slam", maps\vorkuta_surface::slingshot_int_sergei_door);


	//Slingshot
	//Death Run
	level.scr_anim["slingshot_prisoner_left"]["death_run"] = %ai_slingshot_intro_leftguy;
	level.scr_anim["slingshot_prisoner_right"]["death_run"] = %ai_slingshot_intro_rightguy;	
	//Death React
	level.scr_anim["slingshot_prisoner_left"]["death_react"] = %ai_slingshot_intro_leftguy_death_reaction;
	level.scr_anim["slingshot_prisoner_right"]["death_react"] = %ai_slingshot_intro_rightguy_death_reaction;	
	//Wave Idle
	level.scr_anim["slingshot_prisoner_left"]["wave_idle"][0] = %ai_slingshot_intro_leftguy_wave_in;
	level.scr_anim["slingshot_prisoner_right"]["wave_idle"][0] = %ai_slingshot_intro_rightguy_idle;			
	//Pre-pull Idle
	level.scr_anim["slingshot_prisoner_left"]["start_idle"][0] = %ai_slingshot_leftguy_idle;
	level.scr_anim["slingshot_prisoner_right"]["start_idle"][0] = %ai_slingshot_rightguy_idle;	
	//Pull/hold
	level.scr_anim["slingshot_prisoner_left"]["pull_start"] = %ai_slingshot_leftguy_pull_start;
	level.scr_anim["slingshot_prisoner_right"]["pull_start"] = %ai_slingshot_rightguy_pull_start;
	level.scr_anim["slingshot_prisoner_left"]["pull_finish"] = %ai_slingshot_leftguy_pull_finish;
	level.scr_anim["slingshot_prisoner_right"]["pull_finish"] = %ai_slingshot_rightguy_pull_finish;	
	//Pull Idle
	level.scr_anim["slingshot_prisoner_left"]["pull_idle"][0] = %ai_slingshot_leftguy_pulled_idle;
	level.scr_anim["slingshot_prisoner_right"]["pull_idle"][0] = %ai_slingshot_rightguy_pulled_idle;	
	//Fire
	level.scr_anim["slingshot_prisoner_left"]["fire_release"] = %ai_slingshot_leftguy_release;
	level.scr_anim["slingshot_prisoner_right"]["fire_release"] = %ai_slingshot_rightguy_release;
	//Ending
	level.scr_anim["slingshot_prisoner_left"]["ending_idle"] = %ai_slingshot_ending_leftguy;
	level.scr_anim["slingshot_prisoner_right"]["ending_idle"] = %ai_slingshot_ending_rightguy;		
	
	//guard falling down the stairs left and right versions	
	level.scr_anim["stair_guy"]["stairdeath"] = %ch_vor_b03_gaurd1_roll_stairs;
	level.scr_anim["stair_guy"]["stairdeath_left"] = %ch_vor_b03_gaurd3_roll_stairs_left;
	
	//sergei death
	level.scr_anim["sergei"]["door_start"] = %ch_vor_b03_sergei_door_hold_up_enter;
	level.scr_anim["sergei"]["door_loop"][0] = %ch_vor_b03_sergei_door_holding_loop;
	level.scr_anim["sergei"]["door_end"] = %ch_vor_b03_sergei_door_death;
	level.scr_anim["sergei"]["door_end_loop"] = %ch_vor_b03_sergei_door_death_loop;
	addNotetrack_customFunction("sergei", "audio_sergei_doorhold_loop",     ::play_sergei_hold_loop, "door_loop");
	addNotetrack_customFunction("sergei", "audio_sergei_doorhold_loop_end", ::end_sergei_hold_loop, "door_end");

	//heavy guy entrance
	level.scr_anim["generic"]["active_patrol_walk1"]	= %ch_wmd_b01_patrol_guard01;
		
	//reznov welding
	level.scr_anim["reznov"]["weld_pickup"] = %ch_vor_b03_reznov_lift_welder;
	level.scr_anim["reznov"]["weld_enter"] = %ch_vor_b03_reznov_weld_enter;
	level.scr_anim["reznov"]["weld_idle"][0] = %ch_vor_b03_reznov_weld_loop;
	level.scr_anim["reznov"]["weld_exit"] = %ch_vor_b03_reznov_weld_exit;
	addNotetrack_customFunction("reznov", "attach_tank", maps\vorkuta_armory::attach_tank, "weld_pickup");
	addNotetrack_customFunction("reznov", "show_tank", maps\vorkuta_armory::detach_tank, "weld_exit");
	addNotetrack_customFunction("reznov", "attach_torch", maps\vorkuta_armory::attach_torch, "weld_enter");
	addNotetrack_customFunction("reznov", "detach_torch", maps\vorkuta_armory::detach_torch, "weld_exit");
	addNotetrack_flag("reznov", "start_fx", "flag_torch_on", "weld_enter");
	addNotetrack_flag("reznov", "stop_fx", "flag_torch_off", "weld_exit");

	//reznov carry player to warehouse
	level.scr_anim["reznov"]["player_gassed"] = %ch_vor_b03_gassed_reznov;

	//warehouse recovery
	level.scr_anim["reznov"]["warehouse_intro"] = %ch_vor_b04_step8_reznov;
	level.scr_anim["reznov"]["warehouse_intro_loop"][0]	= %ch_vor_b04_step8_reznov_loop;

	//motorycle event
	level.scr_anim["truck_driver"]["idle"][0] = %ch_vor_b04_driver_idle_in_truck;
	level.scr_anim["reznov"]["idle"][0] = %ch_vor_b04_driver_idle_in_truck;
	level.scr_anim["truck_driver"]["carjack"] = %ch_vor_b04_driver_from_truck;
	level.scr_anim["reznov"]["rez_carjack"] = %ch_vor_b04_reznov_jump_to_truck;
	addNotetrack_customFunction("reznov", "open_door", maps\vorkuta_event7::rez_carjack_open_door, "rez_carjack");
}

precache_model_anims()
{
	level.scr_animtree[ "prisoner_model" ] 	= #animtree;				
	level.scr_model[ "prisoner_model" ] = "c_rus_prisoner_body1"; 	
	character\c_rus_prisoner::precache();

	level.scr_animtree[ "guard_model" ] = #animtree;
	level.scr_model[ "guard_model" ] = "c_rus_prison_guard_body";
	character\c_rus_prison_guard::precache();

	level.scr_animtree[ "sergei_model" ] 	= #animtree;				
	level.scr_model[ "sergei_model" ] = "c_rus_prisoner_body1"; 	
	character\c_rus_sergei::precache();
}

#using_animtree ("fakeShooters");
precache_drone_anims()
{
	level.drone_spawnFunction["allies"] = character\c_rus_prisoner_drone::main;
	character\c_rus_prisoner_drone::precache();
	
	//level.drone_run_rate = 150;
	level.drone_run_cycle_override[0] = %ai_prisoner_run_upright;
	level.drone_run_cycle_override[1] = %ai_prisoner_run_hunched_A;
	level.drone_run_cycle_override[2] = %ai_prisoner_run_hunched_B;
	level.drone_run_cycle_override[3] = %ai_prisoner_run_hunched_C; 

	level.max_drones = [];
	level.max_drones["axis"] = 32; 
	level.max_drones["allies"] = 100; 

	level.drone_weaponlist_allies = [];
	level.drone_weaponlist_allies[0] = "unarmed";
}


#using_animtree ("vehicles");
precache_vehicle_anims()
{
	//level.scr_anim["helicopter"] 	= #animtree;				//-- Set the animtree
	level.scr_anim["helicopter"][ "hip_crash" ] = %v_pow_b03_hip_crash_right;

	level.scr_anim["truck"]["rez_carjack"] = %ch_vor_b04_jump2truck_truck;
}	
	

#using_animtree ("player");
precache_player_anims()
{
	level.scr_animtree[ "player_body" ] = #animtree;
	// level.scr_model[ "player_body" ] = "viewmodel_rus_prisoner_player_fullbody"; 	
	level.scr_model[ "player_body" ] = "t5_gfl_ump45_viewbody"; 

	//intro fight
	level.scr_anim[ "player_body" ][ "intro_player" ] = %ch_vor_b01_intro_player;	
	level.scr_anim[ "player_body" ][ "intro_player_punch" ] = %ch_vor_b01_intro_player_punch; 
	level.scr_anim[ "player_body" ][ "intro_player_smash" ] = %ch_vor_b01_intro_player_smash;
	addNotetrack_customFunction( "player_body", "freeze", maps\vorkuta_mine::event_1_intro_freeze, "intro_player" );
	addNotetrack_customFunction( "player_body", "audio_start_breathing", ::audio_player_breathing, "intro_player_punch" );
	addNotetrack_customFunction( "player_body", "audio_end_breathing", ::audio_player_breathing_end, "intro_player_punch" );
	addNotetrack_customFunction("player_body","start_camera", maps\vorkuta_mine::event_1_delta_camera, "intro_player_smash");
	addNotetrack_customFunction("player_body","script_vox_1", maps\vorkuta_mine::event_1_audio_01, "intro_player_smash");
	addNotetrack_customFunction("player_body","script_vox_2", maps\vorkuta_mine::event_1_audio_02, "intro_player_smash");

	//jump to truck
	level.scr_anim[ "player_body" ][ "player_jump_to_truck" ] = %int_vor_b04_jump_to_truck;	

	//jump to train
	level.scr_anim[ "player_body" ][ "player_train_setup" ] = %int_vor_b04_jump_to_train_leave_gun;	
	level.scr_anim[ "player_body" ][ "player_train_coming"][0] = %int_vor_b04_jump_to_train_player_loop;
	level.scr_anim[ "player_body" ][ "player_train_look"] = %int_vor_b04_jump_to_train_player_trans;
	level.scr_anim[ "player_body" ][ "player_train_idle" ][0] = %int_vor_b04_jump_to_train_cab_idle;	
	level.scr_anim[ "player_body" ][ "player_train_jump" ] = %int_vor_b04_jump_to_train;	
	addNotetrack_customFunction( "player_body", "jump_off_bike", ::event7_jump_off_bike_audio,  "player_jump_to_truck" );
	
	//Slingshot	
	level.scr_animtree[ "slingshot_body" ] 	= #animtree;				//-- Set the animtree
	level.scr_model[ "slingshot_body" ] = "t5_gfl_ump45_viewmodel_player"; 		//-- The player model used for the hands	
	//Pull/Hold
	level.scr_anim[ "slingshot_body" ][ "pull_start" ] = %int_slingshot_player_pull_start;
	level.scr_anim[ "slingshot_body" ][ "pull_finish" ] = %int_slingshot_player_pull_finish;	
	addNotetrack_customFunction("slingshot_body", "attach_ammo", maps\vorkuta_slingshot_util::attach_ammo, "pull_finish");
	//Pulled Idle
	level.scr_anim[ "slingshot_body" ][ "idle_straight" ][0] = %int_slingshot_player_pulled_idle_straight;
	level.scr_anim[ "slingshot_body" ][ "idle_left" ][0] = %int_slingshot_player_pulled_idle_left;
	level.scr_anim[ "slingshot_body" ][ "idle_right" ][0] = %int_slingshot_player_pulled_idle_right;	
	//Fire
	level.scr_anim[ "slingshot_body" ][ "fire_straight" ] = %int_slingshot_player_release_straight;//"fire" notetrack
	level.scr_anim[ "slingshot_body" ][ "fire_left" ] = %int_slingshot_player_release_left;
	level.scr_anim[ "slingshot_body" ][ "fire_right" ] = %int_slingshot_player_release_right;
	addNotetrack_customFunction("slingshot_body", "fire", maps\vorkuta_slingshot_util::fire_slingshot, "fire_straight");
	addNotetrack_customFunction("slingshot_body", "fire", maps\vorkuta_slingshot_util::fire_slingshot, "fire_left");
	addNotetrack_customFunction("slingshot_body", "fire", maps\vorkuta_slingshot_util::fire_slingshot, "fire_right");
	
	//rolling under door
	level.scr_anim[ "player_body" ][ "player_roll" ] = %ch_vor_b03_player_door_death;
	addNotetrack_customFunction( "player_body", "raise_gun", maps\vorkuta_armory::player_under_door_gun, "player_roll" );

	//reznov carry player to warehouse
	level.scr_anim["player_body"]["player_gassed"] = %ch_vor_b03_gassed_player;
	addNotetrack_flag("player_body", "start_fadeout", "flag_player_gas_fade", "player_gassed");
	
	//warehouse
	level.scr_anim[ "player_body"][ "warehouse_intro" ] = %ch_vor_b04_step8_player;
}

#using_animtree("animated_props");
precache_prop_anims()
{
	//Slingshot
	level.scr_animtree["slingshot"] = #animtree;
	level.scr_model["slingshot"] = "anim_rus_vork_slingshot_far";
	level.scr_animtree["slingshot_ammo"] = #animtree;
	level.scr_model["slingshot_ammo"] = "anim_rus_vork_slingshot_ammo";	

	//Destroy Tower
	level.scr_anim["slingshot"]["left_cart_sling"] = %ch_vor_b02_minecart_slingshot;
		//Death Run
	level.scr_anim["slingshot"]["death_run"]	=	%o_slingshot_thirdpers_intro;	
		//Death React
	level.scr_anim["slingshot"]["death_react"]	=	%o_slingshot_thirdpers_intro_death_reaction;	
		//Wave Idle
	level.scr_anim["slingshot"]["wave_idle"][0]	=	%o_slingshot_thirdpers_intro_wave_in;	
		//Pre-pull Idle
	level.scr_anim["slingshot"]["start_idle"][0]	=	%o_slingshot_thirdpers_idle;	
		//Pull/Hold
	level.scr_anim["slingshot"]["pull_start"]	= %o_slingshot_thirdpers_pull_start;
	level.scr_anim["slingshot"]["pull_finish"]	= %o_slingshot_firstpers_pull_finish;
	level.scr_anim["slingshot_ammo"]["pull_finish"]	= %o_slingshot_ammo_pull_finish;	
		//Pulled Idle
	level.scr_anim["slingshot"]["pull_idle_straight"][0]	= %o_slingshot_firstpers_pulled_idle_straight;
	level.scr_anim["slingshot_ammo"]["pull_idle_straight"][0]	= %o_slingshot_ammo_pulled_idle_straight;
	level.scr_anim["slingshot"]["pull_idle_left"][0]	= %o_slingshot_firstpers_pulled_idle_left;
	level.scr_anim["slingshot_ammo"]["pull_idle_left"][0]	= %o_slingshot_ammo_pulled_idle_left;
	level.scr_anim["slingshot"]["pull_idle_right"][0]	= %o_slingshot_firstpers_pulled_idle_right;
	level.scr_anim["slingshot_ammo"]["pull_idle_right"][0]	= %o_slingshot_ammo_pulled_idle_right;	
		//Fire
	level.scr_anim["slingshot"]["fire_straight"]	= %o_slingshot_firstpers_release_straight;
	level.scr_anim["slingshot_ammo"]["fire_straight"]	= %o_slingshot_ammo_release_straight;
	level.scr_anim["slingshot"]["fire_left"]	= %o_slingshot_firstpers_release_left;
	level.scr_anim["slingshot_ammo"]["fire_left"]	= %o_slingshot_ammo_release_left;
	level.scr_anim["slingshot"]["fire_right"]	= %o_slingshot_firstpers_release_right;
	level.scr_anim["slingshot_ammo"]["fire_right"]	= %o_slingshot_ammo_release_right;
		//End
	level.scr_anim["slingshot"]["ending_idle"] = %o_slingshot_thirdpers_ending;

	//intro keys
	level.scr_animtree["keys"] = #animtree;
	level.scr_model["keys"] = "anim_rus_inclinator_keys";
	level.scr_anim["keys"]["intro_player_smash"] = %ch_vor_b01_intro_key_smash;

	//inclinator
	level.scr_animtree["inclinator"] = #animtree;
	level.scr_model["inclinator"] = "p_rus_mine_inclinator";
	level.scr_anim["inclinator"]["front_door_loop"][0] = %ch_vor_b01_inclinator_door_idle;
	level.scr_anim["inclinator"]["front_door_open"] = %ch_vor_b01_inclinator_door_open;
	level.scr_anim["inclinator"]["back_door_open"] = %ch_vor_b01_inc_door_open;
	level.scr_anim["inclinator"]["back_door_close"] = %ch_vor_b01_inc_door_close;
		
	//welder
	level.scr_animtree["torch"] = #animtree;
	level.scr_model["torch"] = "anim_rus_torch_backpack";
	level.scr_anim["torch"]["weld_pickup"]	=	%ch_vor_b03_reznov_lift_welder_torch;
	level.scr_anim["torch"]["weld_exit"] = %o_vor_b03_reznov_weld_exit_torch;

	level.scr_animtree["weld_door"] = #animtree;
	level.scr_model["weld_door"] = "anim_rus_door_heavymetal";
	level.scr_anim["weld_door"]["weld_exit"] = %o_vor_b03_reznov_weld_exit_door;

	level.scr_animtree["omaha_door"] = #animtree;
	level.scr_model["omaha_door"] = "anim_rus_red_doors";
	level.scr_anim["omaha_door"]["omaha_exit"] = %ch_vor_b02_omaha_door;
		
	level.scr_animtree["roll_door"] = #animtree;
	level.scr_model["roll_door"] = "anim_rus_armory_door_tracks";

	level.scr_anim["roll_door"]["door_start"] = %ch_vor_b03_rolling_door_start;
	level.scr_anim["roll_door"]["door_loop"][0] = %ch_vor_b03_rolling_door_loop;
	level.scr_anim["roll_door"]["door_end"] = %ch_vor_b03_rolling_door_end;
	level.scr_anim["roll_door"]["door_close"] = %ch_vor_b03_rolling_door_close;
	level.scr_anim["roll_door"]["door_open"]	= %ch_vor_b03_rolling_door_open;

    //Sergei Anim Sound Functions
	addNotetrack_customFunction("roll_door", "audio_start_close",   ::play_door_kill_audio, "door_start");
	addNotetrack_customFunction("roll_door", "audio_sergei_stop_1", ::door_kill_notify1, "door_start");
	addNotetrack_customFunction("roll_door", "audio_cont_close",    ::door_kill_notify2, "door_start");
	addNotetrack_customFunction("roll_door", "audio_sergei_stop_2", ::door_kill_notify3, "door_start");
	addNotetrack_customFunction("roll_door", "audio_start_crush",   ::door_kill_notify4, "door_end");
	addNotetrack_customFunction("roll_door", "audio_ground_pound",  ::door_kill_notify5, "door_end");
	
	//Standard Door Open/Close Sound Functions
	addNotetrack_customFunction("roll_door", "audio_start_open",    ::play_door_looper, "door_open");
	addNotetrack_customFunction("roll_door", "audio_finish_open",   ::door_notify_done, "door_open");
	addNotetrack_customFunction("roll_door", "audio_start_close",   ::play_door_looper, "door_close");
	addNotetrack_customFunction("roll_door", "audio_finish_close",  ::door_notify_done, "door_close");

	level.scr_animtree["bike"] = #animtree;
	level.scr_model["bike"] = "t5_veh_bike_m72_whole";
	level.scr_anim["bike"]["warehouse_intro"] = %ch_vor_b04_step8_bike;
	level.scr_anim["bike"]["warehouse_intro_loop"][0] = %ch_vor_b04_step8_bike_loop;
	level.scr_anim["bike"]["player_jump_to_truck"] = %ch_vor_b04_jump2truck_bike_player;
	level.scr_anim["bike"]["rez_carjack"] = %ch_vor_b04_jump2truck_bike_reznov;
}

//****************************
//  AUDIO
//****************************

//Notifying the moto bike audio that the player is jumping to the truck
event7_jump_off_bike_audio( guy )
{
    clientnotify( "evM" );
    level notify( "evM" );
    wait(3);
    playsoundatposition( "evt_moto_crash_fnt", (0,0,0) );
}

init_voice()
{
	/*==============
			MINES
	===============*/

	level.scr_sound["mason"]["movie_1_01"] = "vox_vor1_s1_900A_inte"; //Viktor Reznov.
	level.scr_sound["mason"]["movie_1_02"] = "vox_vor1_s1_902A_maso"; //My friend.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s1_903A_maso"; //They used tear gas. Couldn't breathe.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s1_904A_inte"; //Was Viktor Reznov still with you?
	level.scr_sound["mason"]["anime"] = "vox_vor1_s1_906A_maso"; //He never left me.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s1_907A_inte"; //And that was the last you saw of Victor Reznov?
	level.scr_sound["mason"]["anime"] = "vox_vor1_s1_909A_maso"; //Yes. At least for while...
	
	level.scr_sound["reznov"]["intro_01"] = "vox_vor1_s1_001A_rezn"; //RRARRRGH!!!
	level.scr_sound["rrd1"]["intro_02"] = "vox_vor1_s1_002A_rrd1"; //(Translated) Do it! Kill him!
	level.scr_sound["rrd1"]["intro_03"] = "vox_vor1_s1_003A_rrd1"; //(Translated) Tear his heart out!
	level.scr_sound["rrd1"]["intro_04"] = "vox_vor1_s1_004A_rrd1"; //(Translated) Kill him Reznov!
	level.scr_sound["reznov"]["intro_05"] = "vox_vor1_s1_005A_rezn_m"; //You will break  American.
	level.scr_sound["guard"]["intro_06"] = "vox_vor1_s1_006A_sgu1_m"; //(Translated) Get back to work  you animals!
	level.scr_sound["reznov"]["intro_07"] = "vox_vor1_s1_007A_rezn_m"; //You hit like a child.
	level.scr_sound["guard"]["intro_08"] = "vox_vor1_s1_008A_sgu1_m"; //(Translated) Is pain the only thing you dogs understand?!
	level.scr_sound["reznov"]["intro_09"] = "vox_vor1_s1_009A_rezn_m"; //Hey - Svoloch!
	level.scr_sound["guard"]["intro_10"] = "vox_vor1_s1_010A_sgu1_m"; //(Translated) Always you  Reznov.
	level.scr_sound["mason"]["intro_11"] = "vox_vor1_s1_011A_maso"; //Reznov�
	level.scr_sound["reznov"]["intro_12"] = "vox_vor1_s1_012A_rezn_m"; //Mason�
	level.scr_sound["reznov"]["intro_13"] = "vox_vor1_s1_013A_rezn_m"; //Every journey begins with a single step�
	level.scr_sound["reznov"]["intro_14"] = "vox_vor1_s1_014A_rezn_m"; //This - is step one.
	level.scr_sound["crow"]["intro_15"] = "vox_vor1_s1_015A_crow_m"; //Secure the keys!
	level.scr_sound["reznov"]["intro_16"] = "vox_vor1_s1_016A_rezn_m"; //Every man knows what is expected of him� You must all play your part!
	level.scr_sound["reznov"]["intro_17"] = "vox_vor1_s1_017A_rezn_m"; //Now  we take Vorkuta!
	level.scr_sound["crow"]["intro_18"] = "vox_vor1_s1_018A_crow"; //URA!!!

	level.scr_sound["reznov"]["mine_steps_01"] = "vox_vor1_s1_019A_rezn"; //What is step Two?!
	level.scr_sound["crow"]["mine_steps_02"] = "vox_vor1_s1_020A_crow"; //Ascend from darkness!
	level.scr_sound["reznov"]["mine_steps_03"] = "vox_vor1_s1_021A_rezn"; //Three?!
	level.scr_sound["crow"]["mine_steps_04"] = "vox_vor1_s1_022A_crow"; //Rain fire!
	level.scr_sound["reznov"]["mine_steps_05"] = "vox_vor1_s1_023A_rezn"; //Four?!
	level.scr_sound["crow"]["mine_steps_06"] = "vox_vor1_s1_024A_crow"; //Unleash the horde!
	level.scr_sound["reznov"]["mine_steps_07"] = "vox_vor1_s1_025A_rezn"; //Five?!
	level.scr_sound["crow"]["mine_steps_08"] = "vox_vor1_s1_026A_crow"; //Skewer the winged beast!
	level.scr_sound["reznov"]["mine_steps_09"] = "vox_vor1_s1_027A_rezn"; //Six?!
	level.scr_sound["crow"]["mine_steps_10"] = "vox_vor1_s1_028A_crow"; //Wield a fist of iron!
	level.scr_sound["reznov"]["mine_steps_11"] = "vox_vor1_s1_029A_rezn"; //Seven?!
	level.scr_sound["crow"]["mine_steps_12"] = "vox_vor1_s1_030A_crow"; //Raise Hell!!!

	level.scr_sound["reznov"]["sergei_intro_01"] = "vox_vor1_s1_031A_rezn"; //Sergei!
	level.scr_sound["reznov"]["sergei_intro_02"] = "vox_vor1_s1_032A_rezn_m"; //Mason. Allow me to introduce - the monster of Magadan - Sergei Kozin to his friends.
	level.scr_sound["mason"]["sergei_intro_03"] = "vox_vor1_s1_033A_maso"; //Glad you're a friend  Sergei.
	level.scr_sound["mason"]["sergei_intro_04"] = "vox_vor1_s1_034A_maso"; //No English?
	level.scr_sound["reznov"]["sergei_intro_05"] = "vox_vor1_s1_035A_rezn_m"; //Sergei mocked Dragovich in front of the wrong people�
	level.scr_sound["reznov"]["sergei_intro_06"] = "vox_vor1_s1_036A_rezn_m"; //For his insolence  Dragovich cut out his tongue with a rusted sickle�

	level.scr_sound["rrd1"]["inclinator_panel_01"] = "vox_vor1_s2_037A_rrd4"; //(Translated) Do it Reznov!
	level.scr_sound["rrd1"]["inclinator_panel_02"] = "vox_vor1_s2_038A_rrd4"; //(Translated) Let's go! We need to hurry!
	level.scr_sound["reznov"]["inclinator_panel_03"] = "vox_vor1_s2_039A_rezn_m"; //Patience my comrades!... Everything is as Mason and I have planned!
	level.scr_sound["reznov"]["inclinator_panel_04"] = "vox_vor1_s2_040A_rezn_m"; //Step two?!
	level.scr_sound["crow"]["inclinator_panel_05"] = "vox_vor1_s2_041A_crow"; //Ascend from darkness!

	level.scr_sound["rrd2"]["inclinator_01"] = "vox_vor1_s2_042A_rrd2_m"; //Reznov, you sure you can trust this American?
	level.scr_sound["reznov"]["inclinator_02"] = "vox_vor1_s2_043A_rezn_m"; //With my life.
	level.scr_sound["reznov"]["inclinator_03"] = "vox_vor1_s2_044A_rezn_m"; //He and us  are not so different� We are all soldiers without an army�
	level.scr_sound["reznov"]["inclinator_04"] = "vox_vor1_s2_045A_rezn_m"; //Betrayed. Forgotten. Abandoned.
	level.scr_sound["reznov"]["inclinator_05"] = "vox_vor1_s2_046A_rezn_m"; //In Vorkuta  we are all brothers�

	level.scr_sound["reznov"]["mine_exit_01"] = "vox_vor1_s2_047A_rezn"; //Mason. With me!
	level.scr_sound["mason"]["mine_exit_02"] = "vox_vor1_s2_048A_maso"; //Your men realize that most of them will die?
	level.scr_sound["reznov"]["mine_exit_03"] = "vox_vor1_s2_049A_rezn"; //Victory cannot be achieved without sacrifice  Mason�
	level.scr_sound["reznov"]["mine_exit_04"] = "vox_vor1_s2_050A_rezn"; //We Russians know this better than anyone.
	level.scr_sound["reznov"]["mine_exit_05"] = "vox_vor1_s2_051A_rezn"; //Prepare yourselves  men!!!
	
	/*==============
	   OMAHA
	===============*/
	
	level.scr_sound["reznov"]["omaha_cheer"] = "vox_vor1_s2_052A_rezn"; //URA!!!
	level.scr_sound["crow"]["omaha_crowd"] = "vox_vor1_s2_053A_crow"; //URA!!!
	level.scr_sound["reznov"]["omaha_back"] = "vox_vor1_s2_054A_rezn_m"; //Stay back  Mason� Wait until the balcony has been cleared!
	level.scr_sound["rrd2"]["omaha_tower"] = "vox_vor1_s3_055A_rrd2"; //The tower's going to rip us to shreds!... You said Mason has a plan  Reznov!
	level.scr_sound["reznov"]["omaha_faith"] = "vox_vor1_s3_056A_rezn"; //Have faith  Comrade!
	level.scr_sound["reznov"]["omaha_mason"] = "vox_vor1_s3_057A_rezn"; //Mason! Over here!
	level.scr_sound["reznov"]["omaha_step3"] = "vox_vor1_s3_058A_rezn"; //Step three?
	level.scr_sound["mason"]["omaha_rain"] = "vox_vor1_s3_059A_maso"; //Rain fire!
	level.scr_sound["reznov"]["omaha_see"] = "vox_vor1_s3_060A_rezn"; //See what can be done with supplies scavenged from the infirmary and a little of Mason's ingenuity�
	level.scr_sound["crow"]["omaha_crowd2"] = "vox_vor1_s3_061A_crow"; //URA!!!
	level.scr_sound["reznov"]["omaha_lose"] = "vox_vor1_s3_062A_rezn"; //Never lose faith  my friends� Never!
	level.scr_sound["reznov"]["omaha_go"] = "vox_vor1_s3_063A_rezn"; //Go!
	level.scr_sound["reznov"]["omaha_cover"] = "vox_vor1_s3_064A_rezn"; //Mason! Stay in cover!
	level.scr_sound["reznov"]["omaha_moving"] = "vox_vor1_s3_065A_rezn"; //Keep moving!
	level.scr_sound["reznov"]["omaha_left"] = "vox_vor1_s3_066A_rezn"; //Left flank!
	level.scr_sound["reznov"]["omaha_right"] = "vox_vor1_s3_067A_rezn"; //Right flank!
	level.scr_sound["reznov"]["omaha_infirm"] = "vox_vor1_s3_068A_rezn"; //There! The infirmary!
	level.scr_sound["reznov"]["omaha_process"] = "vox_vor1_s3_069A_rezn"; //At the processing plant!
	level.scr_sound["reznov"]["omaha_unite"] = "vox_vor1_s3_070A_rezn"; //All across Vorkuta our Comrades unite in our cause!
	level.scr_sound["reznov"]["omaha_friends"] = "vox_vor1_s3_071A_rezn"; //Yes! Yes  my friends!!
	level.scr_sound["reznov"]["omaha_month"] = "vox_vor1_s3_072A_rezn"; //Months of planning  Mason.
	level.scr_sound["reznov"]["omaha_pause"] = "vox_vor1_s3_073A_rezn"; //We will not pause.
	level.scr_sound["reznov"]["omaha_falter"] = "vox_vor1_s3_074A_rezn"; //We will not falter.
	level.scr_sound["reznov"]["omaha_free"] = "vox_vor1_s3_075A_rezn"; //We will be free - or die trying!
	level.scr_sound["reznov"]["sling_go"] = "vox_vor1_s3_076A_rezn"; //Mason! This way.
	level.scr_sound["reznov"]["sling_break"] = "vox_vor1_s3_077A_rezn_m"; //Sergei! Break open the arms lockers!
	level.scr_sound["reznov"]["sling_climb"] = "vox_vor1_s3_078A_rezn_m"; //Mason - Climb the tower and support the uprising in the south!
	level.scr_sound["mason"]["sling_you"] = "vox_vor1_s3_079A_maso"; //What about you?
	level.scr_sound["reznov"]["sling_plan"] = "vox_vor1_s3_080A_rezn_m"; //For our plan to work  we need every man to play his part.
	level.scr_sound["mason"]["sling_four"] = "vox_vor1_s3_081A_maso"; //Step four� Unleash the horde.
	level.scr_sound["reznov"]["sling_rally"] = "vox_vor1_s3_082A_rezn_m"; //I will rally the men.

	//slingshot
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_083A_rezn_f"; //Brave Comrades of Vorkuta  the time has come to rise against our oppressors!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_084A_rezn_f"; //Today we show them the hearts of true Russians!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_085A_rezn_f"; //We have all given our blood for the motherland.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_086A_rezn_f"; //We have answered her calls without question.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_087A_rezn_f"; //We gave our youth  our hearts  our very souls for her protection..
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_088A_rezn_f"; //As brothers we fought side by side against the German fascists.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_089A_rezn_f"; //We crawled through dirt and blood and sand to achieve our glorious victory..
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_090A_rezn_f"; //Not for medals or glory� but for what was right.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_091A_rezn_f"; //We fought for revenge!!!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_092A_rezn_f"; //And when Berlin fell  how did our leaders repay us?
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_093A_rezn_f"; //We returned not to rapturous welcome... but to suspicion and persecution.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_094A_rezn_f"; //In the eyes of our leaders we were already tainted by the capitalist west.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_095A_rezn_f"; //Torn from the arms of our loved ones we found ourselves here -
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_096A_rezn_f"; //This place� This terrible place..
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_097A_rezn_f"; //Here we have languished... with no hope for release... No hope for Justice.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_098A_rezn_f"; //We have toiled in Dragovich's mines until the flesh peeled from our bones...
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_099A_rezn_f"; //We have watched our comrades succumb to sickness and disease�
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_100A_rezn_f"; //We have been starved. We have been beaten. But we will not be broken!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_101A_rezn_f"; //Today  we will send a message to our corrupt and arrogant leaders.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_102A_rezn_f"; //No more will they live in comfort built on the labors of the people!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_103A_rezn_f"; //No more will they crush the souls of good men.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_104A_rezn_f"; //They too will fall�
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_105A_rezn_f"; //We will not be forgotten.
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_106A_rezn_f"; //Today  Comrades�
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s3_107A_rezn_f"; //Vorkuta burns!!!
	level.scr_sound["rrd3"]["ready_slingshot"] = "vox_vor1_s3_108A_rrd3"; //Ready the slingshot!
	level.scr_sound["rrd3"]["mason_lets_go"] = "vox_vor1_s3_109A_rrd3"; //Mason! Let's go!
	level.scr_sound["rrd3"]["our_men_are_dying"] = "vox_vor1_s3_110A_rrd3"; //Our men are dying - HURRY!
	level.scr_sound["rrd3"]["mason_quickly_cant_hold_out"] = "vox_vor1_s3_111A_rrd3"; //Mason! Quickly! They can't hold out much longer!
	level.scr_sound["rrd3"]["come_one_mason_men_need_you"] = "vox_vor1_s3_112A_rrd3"; //Come on Mason! Our men need you!
	level.scr_sound["rrd3"]["fire"] = "vox_vor1_s3_113A_rrd3"; //Fire!!!
	level.scr_sound["rrd3"]["reload"] = "vox_vor1_s3_114A_rrd3"; //Reload!
	level.scr_sound["rrd3"]["target_1"] = "vox_vor1_s3_131A_rrd3"; //To the left!
	level.scr_sound["rrd3"]["target_2"] = "vox_vor1_s3_125A_rrd3"; //There's another! The window to the west!
	level.scr_sound["rrd3"]["target_3"] = "vox_vor1_s3_127A_rrd3"; //The factory! There  on the roof!
	level.scr_sound["rrd3"]["target_4"] = "vox_vor1_s3_119A_rrd3"; //There! In the guard tower!
	level.scr_sound["rrd3"]["target_5"] = "vox_vor1_s3_132A_rrd3"; //To the right!
	level.scr_sound["rrd3"]["fail_shot_1"] = "vox_vor1_s3_400A_rrd3"; //You need to pull it back further!
	level.scr_sound["rrd3"]["fail_shot_2"] = "vox_vor1_s3_401A_rrd3"; //It will not fire unless you pull!
	level.scr_sound["rrd3"]["fail_shot_3"] = "vox_vor1_s3_402A_rrd3"; //Pull it back!
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_115A_rrd3"; //To the south!
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_116A_maso"; //I got him.
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_117A_rrd3"; //Dead ahead! On the power station!
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_118A_maso"; //He's mine.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_120A_maso"; //I see him.
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_121A_rrd3"; //On the barracks  in front of us!
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_122A_maso"; //Not anymore.
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_123A_rrd3"; //I see one! On the fuel silos!
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_124A_maso"; //On it.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_126A_maso"; //Taking the shot.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_128A_maso"; //I got it.
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_129A_rrd3"; //Far end of the camp  the guard tower.
	level.scr_sound["mason"]["anime"] = "vox_vor1_s3_130A_maso"; //I got him.
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_133A_rrd3"; //Dead ahead!
	level.scr_sound["rrd3"]["our_men_are_trapped"] = "vox_vor1_s3_134A_rrd3"; //Our men are trapped!
	level.scr_sound["rrd3"]["clear_a_path"] = "vox_vor1_s3_135A_rrd3"; //Clear a path for them!
	level.scr_sound["rrd3"]["good_shot_mason"] = "vox_vor1_s3_136A_rrd3"; //Good shot Mason!
	level.scr_sound["rrd3"]["got_him_mason"] = "vox_vor1_s3_137A_rrd3"; //You got him Mason!
	level.scr_sound["rrd3"]["anime"] = "vox_vor1_s3_138A_rrd3"; //He's dead  but there may be more.
	level.scr_sound["rrd3"]["excellent_shot_friend"] = "vox_vor1_s3_139A_rrd3"; //Excellent shot my friend!
	level.scr_sound["rrd3"]["nice_work_mason"] = "vox_vor1_s3_140A_rrd3"; //Nice work Mason.
	level.scr_sound["rrd3"]["another_one_down"] = "vox_vor1_s3_141A_rrd3"; //Another one down!
	level.scr_sound["rrd3"]["you_got_him"] = "vox_vor1_s3_142A_rrd3"; //You got him.
	level.scr_sound["rrd3"]["impressive"] = "vox_vor1_s3_143A_rrd3"; //Impressive!
	level.scr_sound["crow"]["success_slingshot_ura"] = "vox_vor1_s3_144A_crow"; //URA!!!
	
	level.scr_sound["reznov"]["sling_exit"] = "vox_vor1_s4_145A_rezn"; //Mason! This way!
	level.scr_sound["reznov"]["sling_arm"] = "vox_vor1_s4_146A_rezn"; //Arm yourselves  Comrades!
	level.scr_sound["reznov"]["sling_reinforce"] = "vox_vor1_s4_147A_rezn"; //Reinforcements will soon arrive to defend the main armory...
	level.scr_sound["mason"]["sling_anticip"] = "vox_vor1_s4_148A_maso"; //Just as anticipated.
	level.scr_sound["squad"]["sling_step5"] = "vox_vor1_s4_149A_rrd3"; //How do we achieve Step five?...
	level.scr_sound["reznov"]["sling_weapon"] = "vox_vor1_s4_150A_rezn"; //Mason's weapon will soon be ready�
	level.scr_sound["reznov"]["court_lock"] = "vox_vor1_s4_151A_rezn"; //Shoot the lock  Mason!
	level.scr_sound["reznov"]["court_forward"] = "vox_vor1_s4_152A_rezn"; //Forward men! We will burn this hell hole to the ground!
	level.scr_sound["reznov"]["court_intro_cheer"] = "vox_vor1_s4_153A_rezn"; //URA!
	level.scr_sound["mason"]["court_intro_cheer"] = "vox_vor1_s4_154A_crow"; //URA!!!
	level.scr_sound["reznov"]["court_spare"] = "vox_vor1_s4_155A_rezn"; //Spare no one!
	level.scr_sound["reznov"]["court_veng"] = "vox_vor1_s4_156A_rezn"; //Savor your vengeance  Comrades!
	level.scr_sound["reznov"]["court_paint"] = "vox_vor1_s4_157A_rezn"; //Paint the walls with their blood!
	level.scr_sound["reznov"]["court_bury"] = "vox_vor1_s4_158A_rezn"; //Bury these animals!
	level.scr_sound["reznov"]["court_tear"] = "vox_vor1_s4_159A_rezn"; //Tear them limb from limb!
	level.scr_sound["reznov"]["court_fight"] = "vox_vor1_s4_160A_rezn"; //Fight!!!
	
	level.scr_sound["reznov"]["chopper_here"] = "vox_vor1_s4_161A_rezn"; //The chopper is here! Good!!!
	level.scr_sound["rrd4"]["chopper_how"] = "vox_vor1_s4_162A_rrd4"; //How is this good?
	level.scr_sound["reznov"]["chopper_wish"] = "vox_vor1_s4_163A_rezn"; //Because it is as we wish.
	level.scr_sound["reznov"]["quickly"] = "vox_vor1_s4_164A_rezn"; //Quckly  Mason.
	level.scr_sound["reznov"]["rope_way"] = "vox_vor1_s4_165A_rezn"; //This way!
	level.scr_sound["reznov"]["rope_upstairs"] = "vox_vor1_s4_619A_rezn"; //* Upstairs!  Get to the harpoon!
	level.scr_sound["mason"]["rope_ready"] = "vox_vor1_s4_622A_maso"; //Let's hope this works!
	level.scr_sound["mason"]["rope_step"] = "vox_vor1_s4_168A_maso"; //Step five�
	level.scr_sound["reznov"]["rope_skewer"] = "vox_vor1_s4_169A_rezn"; //Skewer the winged beast!!
	level.scr_sound["mason"]["rope_secure"] = "vox_vor1_s4_170A_maso"; //Reznov� Secure the rope!
	level.scr_sound["reznov"]["rope_ready"] = "vox_vor1_s4_171A_rezn"; //Secure� Ready  Mason?
	level.scr_sound["mason"]["rope_always"] = "vox_vor1_s4_172A_maso"; //Always.
	level.scr_sound["reznov"]["rope_choose"] = "vox_vor1_s4_173A_rezn"; //Choose your moment.
	level.scr_sound["reznov"]["rope_harpoon"] = "vox_vor1_s4_620A_rezn"; //* Mason! Grab the harpoon!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s4_174A_rezn"; //Wait�
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s4_175A_rezn"; //Not yet!
	level.scr_sound["reznov"]["rope_aim"] = "vox_vor1_s4_176A_rezn"; //Your aim must be true!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s4_177A_rezn"; //No! We cannot waste the shot!
	level.scr_sound["reznov"]["anime"] = "vox_vor1_s4_178A_rezn"; //NOW!!
	level.scr_sound["reznov"]["rope_fire"] = "vox_vor1_s4_179A_rezn"; //FIRE!!!!!
	level.scr_sound["reznov"]["rope_ura"] = "vox_vor1_s4_180A_rezn"; //URA!!!
	level.scr_sound["crow"]["rope_cheer"] = "vox_vor1_s4_181A_crow"; //URA!!!
	
	
	/*==============
		ARMORY
	===============*/
	
	level.scr_sound["reznov"]["know_what"] = "vox_vor1_s4_182A_rezn"; //You all know what to do!
	level.scr_sound["reznov"]["push_forward"] = "vox_vor1_s4_183A_rezn"; //Push forward!
	level.scr_sound["reznov"]["no_fear"] = "vox_vor1_s4_184A_rezn"; //Have no fear!
	level.scr_sound["reznov"]["flank"] = "vox_vor1_s4_185A_rezn"; //Flank around!
	level.scr_sound["reznov"]["upstairs"] = "vox_vor1_s4_186A_rezn"; //Up the stairs! Go! Take no prisoners!
	level.scr_sound["rrd4"]["heard"] = "vox_vor1_s4_187A_rrd4"; //You heard him  Comrades!
	level.scr_sound["rrd4"]["lockdown"] = "vox_vor1_s4_188A_rrd4"; //They are trying to lock down the armory!
	level.scr_sound["reznov"]["donotletthem"] = "vox_vor1_s4_189A_rezn"; //Do not let them!
	level.scr_sound["reznov"]["keep_firing"] = "vox_vor1_s4_190A_rezn"; //Keep firing!
	level.scr_sound["reznov"]["fight"] = "vox_vor1_s4_191A_rezn"; //Fight!
	level.scr_sound["reznov"]["seal"] = "vox_vor1_s4_192A_rezn"; //They're trying to seal the door from the inside!
	level.scr_sound["mason"]["sergei_hold"] = "vox_vor1_s4_623A_maso"; //Sergei!
	level.scr_sound["reznov"]["sergei_hold"] = "vox_vor1_s4_193A_rezn"; //Sergei cannot hold it for much longer!
	level.scr_sound["reznov"]["hurry"] = "vox_vor1_s4_194A_rezn"; //Hurry Mason!
	level.scr_sound["reznov"]["nooo"] = "vox_vor1_s4_195A_rezn"; //Nooo!!!
	level.scr_sound["mason"]["nooo2"] = "vox_vor1_s4_195A_rezn"; //Nooo!!!(2)
	level.scr_sound["reznov"]["open_door"] = "vox_vor1_s4_196A_rezn"; //Mason! Open the door!
	level.scr_sound["reznov"]["get_door_open"] = "vox_vor1_s4_197A_rezn"; //Mason! Get the door open!
	level.scr_sound["reznov"]["more_door_open"] = "vox_vor1_s4_198A_rezn"; //Mason  more guards are coming! Get this door OPEN!
	//level.scr_sound["reznov"]["moment"] = "vox_vor1_s4_199A_rezn_m"; //Your death is not in vain  my friend� Your sacrifice will not be forgotten.
	level.scr_sound["reznov"]["upstairs_go"] = "vox_vor1_s4_200A_rezn_m"; //Upstairs  let's go
	level.scr_sound["rrd4"]["roof"] = "vox_vor1_s4_201A_rrd4"; //The roof! I hear them on the roof!
	level.scr_sound["reznov"]["lambs"] = "vox_vor1_s4_202A_rezn"; //They too will be lambs to the slaughter!
	level.scr_sound["rrd4"]["sealed"] = "vox_vor1_s4_203A_rrd4"; //Reznov! They have sealed the vault!
	level.scr_sound["reznov"]["consequence"] = "vox_vor1_s4_204A_rezn"; //Such matters are of little consequence.
	level.scr_sound["mason"]["step_six"] = "vox_vor1_s4_205A_maso"; //Step six.
	level.scr_sound["reznov"]["wield_iron"] = "vox_vor1_s4_206A_rezn_m"; //Wield a fist of iron.
	level.scr_sound["reznov"]["secure_equip"] = "vox_vor1_s4_207A_rezn_m"; //Mason and I will secure the equipment needed to open the vault.
	level.scr_sound["reznov"]["this_way"] = "vox_vor1_s5_208A_rezn"; //This way.
	level.scr_sound["reznov"]["come_on"] = "vox_vor1_s5_209A_rezn"; //Come on Mason!
	level.scr_sound["reznov"]["reinforcements"] = "vox_vor1_s5_210A_rezn"; //More reinforcements!
	level.scr_sound["reznov"]["little_time"] = "vox_vor1_s5_211A_rezn"; //We have little time!
	level.scr_sound["reznov"]["blowtorch"] = "vox_vor1_s5_212A_rezn_m"; //There! The blowtorch will suit our needs!
	level.scr_sound["rrd4"]["breach"] = "vox_vor1_s5_213A_rrd4_m"; //They are trying to breach!
	level.scr_sound["reznov"]["not_let_them"] = "vox_vor1_s5_214A_rezn_m"; //Do not let them!
	level.scr_sound["reznov"]["keep_covered"] = "vox_vor1_s5_215A_rezn_m"; //Keep me covered!
	level.scr_sound["reznov"]["clear_path"] = "vox_vor1_s5_216A_rezn"; //You must clear a path for me  Mason!
	level.scr_sound["reznov"]["stay_with_me"] = "vox_vor1_s5_217A_rezn"; //Stay with me Mason!
	level.scr_sound["reznov"]["keep_them_off"] = "vox_vor1_s5_218A_rezn"; //Mason  keep them off me!
	level.scr_sound["reznov"]["where_going"] = "vox_vor1_s5_219A_rezn"; //Where are you going?!!!
	level.scr_sound["reznov"]["keep_off_mason"] = "vox_vor1_s5_220A_rezn"; //Keep them off me  Mason!
	
	level.scr_sound["reznov"]["almost_there"] = "vox_vor1_s5_221A_rezn"; //Almost there�
	level.scr_sound["reznov"]["armor_here"] = "vox_vor1_s5_222A_rezn"; //The armor is here!
	level.scr_sound["reznov"]["almost_again"] = "vox_vor1_s5_223A_rezn"; //Almost there�
	
	level.scr_sound["Russian Prisoner"]["pullback"] = "vox_vor1_s5_224A_rrd4"; //They're here! Pull back! Pull back!
	
	level.scr_sound["reznov"]["stand_ground"] = "vox_vor1_s5_225A_rezn"; //Stand your ground!
	
	level.scr_sound["Russian Prisoner"]["away_windows"] = "vox_vor1_s5_226A_rrd4"; //Stay away from the windows!
	
	level.scr_sound["reznov"]["more_time"] = "vox_vor1_s5_227A_rezn"; //I need more time!
	level.scr_sound["reznov"]["concentrate_fire"] = "vox_vor1_s5_228A_rezn"; //Concentrate your fire!
	
	level.scr_sound["mason"]["need_open"] = "vox_vor1_s5_229A_maso"; //We need that vault open - NOW!
	level.scr_sound["reznov"]["yesss"] = "vox_vor1_s5_230A_rezn"; //Yes!!!
	level.scr_sound["reznov"]["grab_minigun"] = "vox_vor1_s5_231A_rezn"; //Mason! Grab that Mini-gun! Take out those BTRs!
	level.scr_sound["mason"]["where_from"] = "vox_vor1_s5_232A_maso"; //Where the fuck did this come from?!
	level.scr_sound["reznov"]["trophy"] = "vox_vor1_s5_233A_rezn"; //A trophy  pried from the hands of your fallen comrades�
	level.scr_sound["reznov"]["coveted"] = "vox_vor1_s5_234A_rezn"; //Such weapons are coveted amongst the wretched bureaucrats that control Vorkuta.
	level.scr_sound["reznov"]["tear_btrs"] = "vox_vor1_s5_235A_rezn"; //Tear those BTRs to pieces!
	level.scr_sound["mason"]["onit"] = "vox_vor1_s5_236A_maso"; //On it!
	level.scr_sound["mason"]["still_one"] = "vox_vor1_s5_237A_maso"; //Still one more!
	level.scr_sound["reznov"]["good_work"] = "vox_vor1_s5_238A_rezn"; //Good work Mason!
	level.scr_sound["reznov"]["step_seven"] = "vox_vor1_s6_239A_rezn"; //Step Seven Comrades?!
	level.scr_sound["crow"]["raise_hell"] = "vox_vor1_s6_240A_crow"; //Raise HELL!!!
	level.scr_sound["reznov"]["burn_place"] = "vox_vor1_s6_241A_rezn"; //Burn this place to the ground comrades!
	level.scr_sound["reznov"]["diescum"] = "vox_vor1_s6_242A_rezn"; //Die Scum!
	level.scr_sound["reznov"]["unleash_fury"] = "vox_vor1_s6_243A_rezn"; //Unleash fury!
	level.scr_sound["reznov"]["kill_all"] = "vox_vor1_s6_244A_rezn"; //Kill all who stand in our way.
	level.scr_sound["reznov"]["no_mercy"] = "vox_vor1_s6_245A_rezn"; //Show NO mercy!!!
	level.scr_sound["reznov"]["kill_them"] = "vox_vor1_s6_246A_rezn"; //Kill them all!
	level.scr_sound["reznov"]["for_honor"] = "vox_vor1_s6_247A_rezn"; //For honor!
	level.scr_sound["reznov"]["for_vengeance"] = "vox_vor1_s6_248A_rezn"; //For vengeance!
	level.scr_sound["reznov"]["for_russia"] = "vox_vor1_s6_249A_rezn"; //For Russia!!!
	level.scr_sound["crow"]["uraaa"] = "vox_vor1_s6_250A_crow"; //URA!!!!
	level.scr_sound["reznov"]["tear_gas"] = "vox_vor1_s6_251A_rezn"; //They are using tear gas!
	level.scr_sound["reznov"]["masonnn"] = "vox_vor1_s6_252A_rezn"; //MASON!!!!
	level.scr_sound["mason"]["help_others"] = "vox_vor1_s6_253A_maso"; //Wait! We have to help the others!
	level.scr_sound["reznov"]["nothing_do"] = "vox_vor1_s6_254A_rezn_m"; //There is nothing we can do!
	level.scr_sound["reznov"]["too_close"] = "vox_vor1_s6_255A_rezn_m"; //We are too close to our goal  Mason� You will survive� You have to!
	
	
	/*==============
		BIKE EVENT
	===============*/
	
	level.scr_sound["reznov"]["door_nag"] = "vox_vor1_s6_256A_rezn_m"; //The door will not hold them forever� We do not have much time�
	
	level.scr_sound["reznov"]["step_eight"] = "vox_vor1_s6_257A_rezn_m"; //Within this shrine to the hypocritical decadence of Vorkuta's leaders  lays the key to step eight.
	
	level.scr_sound["mason"]["freedom"] = "vox_vor1_s6_258A_maso"; //Freedom.
	level.scr_sound["reznov"]["not_over"] = "vox_vor1_s7_259A_rezn"; //This is not over yet.
	level.scr_sound["reznov"]["faster"] = "vox_vor1_s7_260A_rezn"; //Come on Mason! Faster!
	level.scr_sound["reznov"]["there_is_train"] = "vox_vor1_s7_261A_rezn"; //There is the train! Hurry Mason!
	level.scr_sound["mason"]["without_fight"] = "vox_vor1_s7_262A_maso"; //They are not letting us go without a fight!
	
	level.scr_sound["reznov"]["M_G"] = "vox_vor1_s7_263A_rezn"; //M - G!!!!!
	level.scr_sound["reznov"]["jump_truck"] = "vox_vor1_s7_264A_rezn"; //Jump onto the truck!
	level.scr_sound["reznov"]["mason_jump"] = "vox_vor1_s7_265A_rezn"; //Mason! Jump!
	level.scr_sound["reznov"]["on_mg"] = "vox_vor1_s7_266A_rezn"; //Get on the MG!
	level.scr_sound["reznov"]["keep"] = "vox_vor1_s7_267A_rezn"; //Keep on them!
	level.scr_sound["mason"]["where_train"] = "vox_vor1_s7_268A_maso"; //Where the fuck's the train?!!!
	
	level.scr_sound["reznov"]["there"] = "vox_vor1_s7_269A_rezn"; //There!!!
	level.scr_sound["reznov"]["go_mason_go"] = "vox_vor1_s7_270A_rezn"; //Go  Mason! Go!
	level.scr_sound["reznov"]["jump_mason_jump"] = "vox_vor1_s7_271A_rezn"; //Jump Mason! Jump!
	level.scr_sound["mason"]["your_turn"] = "vox_vor1_s7_272A_maso"; //Your turn!!!
	level.scr_sound["mason"]["come_on"] = "vox_vor1_s7_273A_maso"; //Come on!!!
	level.scr_sound["mason"]["step8_freedom"] = "vox_vor1_s7_274A_maso"; //Step eight  Reznov - Freedom!
	level.scr_sound["reznov"]["for_you_mason"] = "vox_vor1_s7_275A_rezn_m"; //For you Mason�
	level.scr_sound["reznov"]["not_for_me"] = "vox_vor1_s7_276A_rezn_m"; //Not for me�
	level.scr_sound["mason"]["reznov"] = "vox_vor1_s7_277A_maso"; //Reznov!!!!
}

audio_clientnotify_cheer1( guy )
{
    level clientnotify( "ch1" );
}

audio_clientnotify_cheer2( guy )
{
	//iprintlnbold ("CH2");
    level clientnotify( "ch2" );
}

audio_clientnotify_cheer3( guy )
{
    level clientnotify( "ch3" );
}

audio_clientnotify_cheer4( guy )
{
    level clientnotify( "ch4" );
}

audio_player_breathing( player )
{
    player PlayLoopSound( "vox_player_breath_loop", 1 );
    level waittill( "end_player_breath_audio" );
    player StopLoopSound( 1 );
}

audio_player_breathing_end( guy )
{
    level notify( "end_player_breath_audio" );
}

audio_crowd_vox_1( guy )
{
    level thread play_prisoner_crowd_vox( "vox_vor1_s99_300A_rrd5", "vox_vor1_s99_301A_rrd6", "vox_vor1_s99_302A_rrd7" );
}

audio_crowd_vox_2( guy )
{
    level thread play_prisoner_crowd_vox( "vox_vor1_s99_321A_rrd5", "vox_vor1_s99_322A_rrd6", "vox_vor1_s99_323A_rrd7" );
}

play_door_kill_audio( door )
{
    playsoundatposition( "evt_armory_door_start", door.origin );
    door PlayLoopSound( "evt_armory_door_loop", .25 );
    door waittill( "sound_notify_1" );
    door PlayLoopSound( "evt_armory_door_malf_loop", .25 );
    playsoundatposition( "evt_armory_door_sergei", door.origin );
    door waittill( "sound_notify_2" );
    door PlayLoopSound( "evt_armory_door_loop", .25 );
    door waittill( "sound_notify_3" );
    door PlayLoopSound( "evt_armory_door_malf_loop", .25 );
    playsoundatposition( "evt_armory_door_sergei", door.origin );
    door waittill( "sound_notify_4" );
    door PlayLoopSound( "evt_armory_door_loop", .25 );
    door waittill( "sound_notify_5" );
    door StopLoopSound( .25 );
    playsoundatposition( "evt_armory_door_slam", door.origin );
}

door_kill_notify1( door )
{
    door notify( "sound_notify_1" );
}

door_kill_notify2( door )
{
    door notify( "sound_notify_2" );
}

door_kill_notify3( door )
{
    door notify( "sound_notify_3" );
}

door_kill_notify4( door )
{
    door notify( "sound_notify_4" );
}

door_kill_notify5( door )
{
    door notify( "sound_notify_5" );
}

play_door_looper( door )
{
    playsoundatposition( "evt_armory_door_start", door.origin );
    door PlayLoopSound( "evt_armory_door_loop", .25 );
    door waittill( "audio_door_finished" );
    door StopLoopSound( .25 );
    playsoundatposition( "evt_armory_door_slam", door.origin );
}

door_notify_done( door )
{
    door notify( "audio_door_finished" );
}

play_sergei_hold_loop( sergei )
{
    sergei notify( "force_stop" );
    sergei endon( "force_stop" );
    
    if( !IsDefined( level.sergei_audio_ent ) )
        level.sergei_audio_ent = Spawn( "script_origin", sergei.origin );
        
    level.sergei_audio_ent PlayLoopSound( "evt_sergei_hold_door_loop" );
    
    sergei waittill( "end_sergei_loop" );
    
    level.sergei_audio_ent StopLoopSound( .5 );
    wait(1);
    level.sergei_audio_ent Delete();    
}

end_sergei_hold_loop( sergei )
{
    sergei notify( "end_sergei_loop" );
}