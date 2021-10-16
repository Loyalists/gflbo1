#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\creek_1_util;

#using_animtree ("generic_human");
main()
{
	level.drone_marine_model_index = 0;
	level.drone_vc_model_index = 0;

//---------------------------------------------------------------------------------------------------------
// TEMP STUFF

	level.scr_anim["generic"]["huey_pilot_loop"][0] 				= %ai_huey_pilot1_idle_loop1;
	level.scr_anim["generic"]["huey_gunner_1_loop"][0]			= %ai_huey_gunner1;	
	level.scr_anim["generic"]["huey_gunner_2_loop"][0]			= %ai_huey_gunner2;	
	level.scr_anim["generic"]["huey_passenger_fl_loop"][0]	= %ai_huey_passenger_f_lt;	
	level.scr_anim["generic"]["huey_passenger_fr_loop"][0]	= %ai_huey_passenger_f_rt;	
	level.scr_anim["generic"]["huey_passenger_bl_loop"][0]	= %ai_huey_passenger_b_lt;	
	level.scr_anim["generic"]["huey_passenger_br_loop"][0]	= %ai_huey_passenger_b_rt;	
	
	level.scr_anim["generic"]["idle_crouch"][0]	= %crouch_aim_straight;	
	level.scr_anim["generic"]["idle_stand"][0]	= %stand_aim_straight;	
	level.scr_anim["generic"]["death_explosive_side_1"]	= %death_explosion_left11;	
	level.scr_anim["generic"]["death_explosive_side_2"]	= %death_explosion_right13;	
	level.scr_anim["generic"]["death_explosive_side_3"]	= %death_explosion_forward13;	
	level.scr_anim["generic"]["death_explosive_side_4"]	= %death_explosion_back13;	

	// generic patrol anims (TEMP)
	level.scr_anim[ "generic" ][ "patrol_walk" ]					= %patrol_bored_patrolwalk;
	level.scr_anim[ "b2_vc_drop_water" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "b2_vc_drop_water" ][ "patrol_walk_2_idle" ]	= %patrol_bored_walk_2_bored;
	level.scr_anim[ "b2_vc_drop_water" ][ "patrol_turn180" ]		= %patrol_bored_2_walk_180turn;
	level.scr_anim[ "b2_vc_bridge_1" ][ "patrol_walk" ]				= %patrol_bored_patrolwalk;
	level.scr_anim[ "b2_vc_bridge_2" ][ "patrol_walk" ]				= %patrol_bored_patrolwalk;

	// WWILLIAMS: Civilian animations
	level.scr_anim[ "generic" ][ "idle_smoke" ][0]	= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "surprise_react" ] = %patrol_bored_react_look_v1;
	// some idle anims
	level.scr_anim[ "generic" ][ "idle_stand" ][0]	= %casual_stand_v2_idle;
	level.scr_anim[ "generic" ][ "idle_stand" ][1]	= %casual_stand_v2_twitch_shift;
	level.scr_anim[ "generic" ][ "idle_stand" ][2]	= %casual_stand_v2_twitch_talk;
	level.scr_anim[ "generic" ][ "idle_stand" ][3]	= %casual_stand_v2_idle;
	

	//level.scr_anim[ "reznov" ][ "unarmed_run" ]	= %ai_civ_gen_run_01;
	level.scr_anim[ "reznov" ][ "unarmed_run" ]	= %unarmed_run_delta;
	level.scr_anim[ "generic" ][ "unarmed_run" ]	= %ai_civ_gen_run_01;

	level.scr_anim[ "hudson" ][ "grenade_throw" ]	= %crouch_grenade_throw;

	level.scr_anim[ "balcony_guy" ][ "balcony_fall_1" ]	= %ai_deathbalcony_b;
	level.scr_anim[ "balcony_guy" ][ "balcony_fall_2" ]	= %ai_deathbalcony_c;


//---------------------------------------------------------------------------------------------------------
// BEAT 2

	// barnes walk cycles
	level.scr_anim[ "barnes" ][ "run_fast" ]				= %ai_barnes_run_f_v2;
	level.scr_anim[ "barnes" ][ "run_look_around" ]	= %ai_barnes_walk_f;
	level.scr_anim[ "barnes" ][ "run_look_up" ]			= %ai_barnes_walk_f_aim_up;
	
	// -- WWILLIAMS: RIDGE1 INTRO ANIMATIONS
	level.scr_anim[ "b2_ridge1_vc1" ][ "ridge_intro_1" ] = %ch_creek_b02_vc1_ridge;
	level.scr_anim[ "b2_ridge1_vc2" ][ "ridge_intro_2" ] = %ch_creek_b02_vc2_ridge;
	
	// sampan kill
	level.scr_anim["b2_vc_sampan_2"]["search_near"] 	= %ai_sampan_melee_search_close;
	level.scr_anim["b2_vc_sampan_2"]["search_med"] 		= %ai_sampan_melee_search_medium;
	level.scr_anim["b2_vc_sampan_2"]["search_far"] 		= %ai_sampan_melee_search_distant;
	level.scr_anim["b2_vc_sampan_2"]["melee"] 				= %ai_sampan_melee;
	level.scr_anim["b2_vc_sampan_2"]["crouch_2_stand"] 	= %ai_sampan_melee_crouch_2_stand;
	level.scr_anim["b2_vc_sampan_2"]["crouch_idle"][0] 	= %ai_sampan_melee_crouch_idle;
	level.scr_anim["b2_vc_sampan_2"]["flinch_2_stand"] 	= %ai_sampan_melee_flinch_2_stand;
	level.scr_anim["b2_vc_sampan_2"]["stand_2_flinch"] 	= %ai_sampan_melee_stand_2_flinch;
	level.scr_anim["b2_vc_sampan_2"]["stand_idle"][0] 	= %ai_sampan_melee_stand_idle;
	addNotetrack_customFunction( "b2_vc_sampan_2", "water_hit", ::melee_sampan_water_hit, "melee" );  
	addNotetrack_customFunction( "b2_vc_sampan_2", "neck_stab", ::melee_sampan_neck_stab, "melee" );  
	addNotetrack_customFunction( "b2_vc_sampan_2", "bubbles", ::melee_sampan_bubbles, "melee" );
	addNotetrack_customFunction( "b2_vc_sampan_2", "head_swap", ::beat2_swap_vc_head_model, "melee" );
	addNotetrack_customFunction( "b2_vc_sampan_2", "start_ragdoll", ::beat2_vc_sampan_blood_in_the_water, "melee" );
	// -- WWILLIAMS: WOODS/BARNES KILLS SECOND VC_SAMPAN
	level.scr_anim["b2_vc_sampan_1"]["crouch_idle"][0] 		= %ai_sampan_melee_barnesvictim_crouch_idle;
	level.scr_anim["b2_vc_sampan_1"]["crouch_2_stand"] 	= %ai_sampan_melee_barnesvictim_crouch_2_stand;
	level.scr_anim["b2_vc_sampan_1"]["stand_idle"] 			= %ai_sampan_melee_barnesvictim_stand_idle;
	level.scr_anim["b2_vc_sampan_1"]["stand_2_flinch"] 	= %ai_sampan_melee_barnesvictim_stand_2_flinch;
	level.scr_anim["b2_vc_sampan_1"]["melee"] 					= %ai_sampan_melee_barnesvictim;
	addNotetrack_customFunction( "b2_vc_sampan_1", "start_ragdoll", ::beat2_vc_sampan_blood_in_the_water, "melee" );
			
	// Intro
	level.scr_anim["barnes"]["swim_to_shore"] 				= %ch_creek_b01_barnes_swim_ashore;
	level.scr_anim["barnes"]["rock_step"] 						= %ch_creek_b02_barnes_walk_jungle_path;
	level.scr_anim["barnes"]["gap_reach"] 						= %ch_creek_b02_barnes_start2gap;
	level.scr_anim["barnes"]["gap_idle"][0] 					= %ch_creek_b02_barnes_treadwatergap;
	level.scr_anim["barnes"]["gap_idle_single"] 			= %ch_creek_b02_barnes_treadwatergap;
	level.scr_anim["barnes"]["swim_gap_to_sampan"] 		= %ch_creek_b02_barnes_gap2sampan ;
	level.scr_anim["barnes"]["sampan_idle"][0] 				= %ch_creek_b02_barnes_tread_sampan2;
	level.scr_anim["barnes"]["swim_sampan_to_dock"] 	= %ch_creek_b02_sampan_barnes_swimtodock;
	level.scr_anim["barnes"]["swim_sampan_to_dock_idle"][0] 	= %ch_creek_b02_sampan_barnes_swimtodock_idle;
	// addNotetrack_customFunction( "barnes", "come_out_water", ::water_splash_exit, "swim_gap_to_sampan" );  
	// addNotetrack_customFunction( "barnes", "go_in_water", ::water_splash_enter, "swim_gap_to_sampan" );  
	addNotetrack_customFunction( "barnes", "come_out_water", ::water_splash_exit, "swim_sampan_to_dock" );  
	// barnes sampan kill
	level.scr_anim["barnes"]["sampan_melee"] 					= %ai_sampan_melee_barnes;
	
	// Lewis on bridge
	level.scr_anim["hudson"]["bridge_signal"] 	= %ch_creek_b02_lewis_signaling;
	
	// we are splitting up
	level.scr_anim["barnes"]["we_split_up"] 		= %ch_creek_b02_woods_splittingup;
	
	// window look
	level.scr_anim["barnes"]["look_out"] 		= %ch_creek_b02_windowlook_woods;
	level.scr_anim["b2_vc_look_out"]["look_out"] 		= %ch_creek_b02_windowlook_vc;
	addNotetrack_customFunction( "b2_vc_look_out", "safe", ::window_look_safe, "look_out" );  
	level.scr_anim["b2_vc_look_out2"]["look_out"] 	= %ch_creek_b02_windowlook_vc2;
	
	// window shimming
	level.scr_anim["barnes"]["swim_climb_dock"] 	= %ch_creek_b02_barnes_swim_dock;
	//addNotetrack_customFunction( "barnes", "spawn_gun", maps\creek_1_stealth::beat2_give_woods_back_a_gun, "swim_climb_dock" );
	
	level.scr_anim["barnes"]["climb_onto_dock"] 	= %ch_creek_b02_barnes_swim_climb_dock;	
	level.scr_anim["barnes"]["loop_swim_dock_idle"][0] 	= %ch_creek_b02_barnes_swim_climb_loop;	
	
	level.scr_anim["barnes"]["loop_left"] 			= %ch_creek_b02_barnes_window_loop_left;		
	level.scr_anim["barnes"]["loop_right"][0] 		= %ch_creek_b02_barnes_window_loop_right;		
	level.scr_anim["barnes"]["loop_right_single"] 		= %ch_creek_b02_barnes_window_loop_right;		
	level.scr_anim["barnes"]["window_shimy"] 			= %ch_creek_b02_barnes_window_shimy;		
	level.scr_anim["barnes"]["sneak_in"] 					= %ch_creek_b02_barnes_window_sneek_in;		
	level.scr_anim["b2_vc_sleeping_1"]["sleep"][0] 		= %ch_creek_b02_hammock_sleep_guy01;		
	level.scr_anim["b2_vc_sleeping_1"]["death"] 			= %ch_creek_b02_sleeping_guy_1_death;		
	level.scr_anim["b2_vc_sleeping_2"]["sleep"][0] 		= %ch_creek_b02_hammock_sleep_guy02;		
	level.scr_anim["b2_vc_sleeping_2"]["death"] 			= %ch_creek_b02_sleeping_guy_2_death;		
	//level.scr_anim["b2_vc_chef_1"]["talking"][0] 		= %ch_creek_b02_dock_gaurds_talking_guy_1_loop;		
	//level.scr_anim["b2_vc_chef_2"]["talking"][0] 		= %ch_creek_b02_dock_gaurds_talking_guy_2_loop;		
	
	// hammock kill
	level.scr_anim["b2_vc_sleeping_1"]["player_kill"] 		= %ai_creek_hammock_melee_guy01;		
	addNotetrack_customFunction( "b2_vc_sleeping_1", "head_swap", ::beat2_hammock_vc_1_head_swap, "player_kill" );
	level.scr_anim["b2_vc_sleeping_1"]["death_idle"][0] 	= %ai_creek_hammock_melee_guy01_dead_idle;		
	level.scr_anim["b2_vc_sleeping_1"]["woods_kill"] 			= %ai_creek_hammock_melee_woodsvictim_guy01;	
	level.scr_anim["barnes"]["woods_kill_1"] 								= %ai_creek_hammock_melee_woods_guy01;	
	addNotetrack_customFunction( "b2_vc_sleeping_1", "blood_fx", ::play_vc1_kill_blood_fx, "player_kill" );
	
	level.scr_anim["b2_vc_sleeping_2"]["player_kill"] 		= %ai_creek_hammock_melee_guy02;	
	addNotetrack_customFunction( "b2_vc_sleeping_2", "head_swap", ::beat2_hammock_vc_2_head_swap, "player_kill" );	
	level.scr_anim["b2_vc_sleeping_2"]["death_idle"][0] 	= %ai_creek_hammock_melee_guy02_dead_idle;		
	level.scr_anim["b2_vc_sleeping_2"]["woods_kill"] 			= %ai_creek_hammock_melee_woodsvictim_guy02;	
	level.scr_anim["barnes"]["woods_kill_2"] 								= %ai_creek_hammock_melee_woods_guy02;	
	addNotetrack_customFunction( "b2_vc_sleeping_2", "blood_fx", ::play_vc2_kill_blood_fx, "player_kill" );

	// falling into water guy
	level.scr_anim["b2_vc_drop_water"]["fall_death"] 			= %ai_viet_splash_death;		
	addNotetrack_customFunction( "b2_vc_drop_water", "hit_water", ::b2_falling_guy_hit_water, "fall_death" );
	
	// rice eating guy
	
	// -- WWILLIAMS: PRESS DEMO 4-19 VC EATING RICE ANIMATIONS
	level.scr_anim[ "b2_vc_rice" ][ "curtain_open" ] = %ai_vc_eating_melee_curtain_open;
	level.scr_anim[ "b2_vc_rice" ][ "attack_opportunity" ] = %ai_vc_eating_melee_attack_opportunity;
	level.scr_anim[ "b2_vc_rice" ][ "melee_kill" ] = %ai_vc_eating_melee;
	level.scr_anim[ "b2_vc_rice" ][ "melee_fail" ] = %ai_vc_eating_melee_fail_grabs_gun;
	addNotetrack_customFunction( "b2_vc_rice", "grab_gun", ::b2_rice_grab_gun, "melee_fail" );  
	addNotetrack_customFunction( "b2_vc_rice", "blood_fx", ::play_vc_rice_kill_blood_fx, "melee_kill" );
	// addNotetrack_customFunction( "b2_vc_rice", "sndnt#evt_b02_bowl_drop", ::b2_rice_drop_bowl, "melee_fail" );  
			
	// regroup
	level.scr_anim["barnes"]["regroup_hut_walk"] 	= %ch_creek_b02_regroup_before_village_barnes;		
	addNotetrack_customFunction( "barnes", "clear_door", ::delete_regroup_door, "regroup_hut_walk" );  

	// village patrols
	// -- RIVER WALK -- STEALTH OBJECTIVE
	
	// -- WWILLIAMS: NEW OPENING HUT -- level.scr_anim[ "" ][ "" ] = %;
	level.scr_anim[ "b2_vc_hut_1" ][ "hey_charlie_idle" ][0] = %ch_creek_b02_hey_charlie_nva_1_loop;
	level.scr_anim[ "b2_vc_hut_1" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_nva_1;
	level.scr_anim[ "b2_vc_hut_1" ][ "hey_charlie_death_loop" ][0] = %ch_creek_b02_hey_charlie_nva_1_death_loop;
	
	level.scr_anim[ "b2_vc_hut_2" ][ "hey_charlie_idle" ][0] = %ch_creek_b02_hey_charlie_nva_2_loop;
	level.scr_anim[ "b2_vc_hut_2" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_nva_2;
	
	level.scr_anim[ "barnes" ][ "hey_charlie_idle" ] = %ch_creek_b02_hey_charlie_woods_loop;
	addNotetrack_customFunction( "barnes", "attach", maps\creek_1_stealth::beat2_attach_knife_to_woods_hand, "hey_charlie_idle" );
	level.scr_anim[ "barnes" ][ "hey_charlie_approach" ] = %ch_creek_b02_hey_charlie_woods_approach;
	level.scr_anim[ "barnes" ][ "hey_charlie_approach_idle_loop" ] = %ch_creek_b02_hey_charlie_woods_approach_loop;
	level.scr_anim[ "barnes" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_woods;
	addNotetrack_customFunction( "barnes", "detach", maps\creek_1_stealth::beat2_detach_knife_from_woods_hand, "hey_charlie" );
	addNotetrack_customFunction( "barnes", "attach", maps\creek_1_stealth::beat2_attach_knife_to_woods_hand, "hey_charlie" );
	// -- TODO: WWILLIAMS: SET UP NOTE TRACKS FOR ATTACH AND DETACH THE KNIFE
	
	level.scr_anim[ "hudson_no_backpack" ][ "hey_charlie_idle" ] = %ch_creek_b02_hey_charlie_bowman_loop;
	level.scr_anim[ "hudson_no_backpack" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_bowman;
	//addNotetrack_customFunction( "hudson_no_backpack", "attach_c4", maps\creek_1_stealth::beat2_bowman_attach_c4, "hey_charlie" );
	//addNotetrack_customFunction( "hudson_no_backpack", "delete_c4", maps\creek_1_stealth::beat2_bowman_delete_c4, "hey_charlie" );
	//addNotetrack_customFunction( "hudson_no_backpack", "attach_knife", maps\creek_1_stealth::beat2_bowman_attach_knife, "hey_charlie" );
	addNotetrack_customFunction( "hudson_no_backpack", "detach_knife", maps\creek_1_stealth::beat2_bowman_delete_knife, "hey_charlie" );
	
	addNotetrack_customFunction( "hudson_no_backpack", "static", maps\creek_1_stealth::beat2_bowman_put_down_weapon, "hey_charlie" );
	addNotetrack_customFunction( "hudson_no_backpack", "static_pickup", maps\creek_1_stealth::beat2_bowman_take_back_weapon, "hey_charlie" );

	// -- WWILLIAMS THERE IS A RED SHIRT THAT REPLACED REZNOV IN THIS AREA, THEY BOTH SHARE THE ANIMNAME
	level.scr_anim[ "marine_redshirt" ][ "hey_charlie_idle" ] = %ch_creek_b02_hey_charlie_redshirt_loop;
	level.scr_anim[ "marine_redshirt" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_redshirt;
	
	level.scr_anim[ "reznov" ][ "hey_charlie" ] = %ch_creek_b02_hey_charlie_reznov;

	// -- WWILLIAMS: NEW OPENING HUT
	
	
//---------------------------------------------------------------------------------------------------------
// BEAT 3

	level.scr_anim["barnes"]["standard_run"]	 	= %run_lowready_f;
	level.scr_anim["barnes"]["custom_run"]	 		= %ai_barnes_run_f;
	
	// intro
	level.scr_anim["barnes"]["plunger_talk"] 			= %ch_creek_b02_distraction_pt1_woods;
	level.scr_anim["hudson"]["plunger_talk"] 			= %ch_creek_b02_distraction_pt1_bowman;
	level.scr_anim["barnes"]["plunger_idle"][0] 	= %ch_creek_b02_distraction_idle_woods;
	level.scr_anim["hudson"]["plunger_idle"][0] 	= %ch_creek_b02_distraction_idle_bowman;
	level.scr_anim["barnes"]["plunger_attack"] 		= %ch_creek_b02_distraction_pt2_woods;
	level.scr_anim["hudson"]["plunger_attack"] 		= %ch_creek_b02_distraction_pt2_bowman;
	
	// -- level.scr_anim[ "" ][ "" ] = %;
	// -- level.scr_sound[""][""] = "";
	// Village fight
	// Distraction Guys
	level.scr_anim[ "vc_distraction_1" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_explointro_a_vc1;
	level.scr_anim[ "vc_distraction_1" ][ "vc_distract_react_1" ] 		= %ch_creek_b02_village_explointro_b_vc1;
	level.scr_anim[ "vc_distraction_1" ][ "vc_distract_fail_1" ] 			= %ch_creek_b02_village_explointro_fail_vc1;
	addNotetrack_customFunction( "vc_distraction_1", "start_ragdoll", maps\creek_1_assault::beat_3_ariel_vc_deaths, "vc_distract_react_1" );
	addNotetrack_customFunction( "vc_distraction_1", "explosion", maps\creek_1_assault::beat_3_grenade_explosion, "vc_distract_react_1" );
	
	level.scr_anim[ "vc_distraction_2" ][ "patrol_idle" ][0]					= %ch_creek_b02_village_explointro_a_vc2;
	level.scr_anim[ "vc_distraction_2" ][ "vc_distract_react_2" ] 		= %ch_creek_b02_village_explointro_b_vc2;
	level.scr_anim[ "vc_distraction_2" ][ "vc_distract_fail_2" ] 			= %ch_creek_b02_village_explointro_fail_vc2;
	addNotetrack_customFunction( "vc_distraction_2", "start_ragdoll", maps\creek_1_assault::beat_3_ariel_vc_deaths, "vc_distract_react_2" );
	
	level.scr_anim[ "vc_distraction_3" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_explointro_a_vc3;
	level.scr_anim[ "vc_distraction_3" ][ "vc_distract_react_3" ] 		= %ch_creek_b02_village_explointro_b_vc3;
	level.scr_anim[ "vc_distraction_3" ][ "vc_distract_fail_3" ] 			= %ch_creek_b02_village_explointro_fail_vc3;
	addNotetrack_customFunction( "vc_distraction_3", "start_ragdoll", maps\creek_1_assault::beat_3_ariel_vc_deaths, "vc_distract_react_3" );
	
	// Catwalk guys
	level.scr_anim[ "vc_catwalk_lower" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_bridge_lower_idle;
	level.scr_anim[ "vc_catwalk_lower" ][ "lower_react" ] 						= %ch_creek_b02_village_bridge_lower_react;
	
	level.scr_anim[ "vc_catwalk_high" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_bridge_upper_idle;
	level.scr_anim[ "vc_catwalk_high" ][ "high_react" ] 							= %ch_creek_b02_village_bridge_upper_react;
	level.scr_anim[ "vc_catwalk_high" ][ "high_death" ] 							= %ch_creek_b02_village_bridge_upper_death;
	
	// Cook and friends
	level.scr_anim[ "vc_cook" ][ "patrol_idle" ][0] 									= %ch_creek_b02_village_cook_idle;
	level.scr_anim[ "vc_cook" ][ "cooking_react" ] 										= %ch_creek_b02_village_cookexplo_react;

	level.scr_anim[ "vc_crate" ][ "patrol_idle" ][0] 									= %ch_creek_b02_village_sitoncrate_idle;
	level.scr_anim[ "vc_crate" ][ "crate_react" ] 										= %ch_creek_b02_village_sitoncrateexplo_react;
			
	level.scr_anim[ "vc_catwalk_sit_1" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_sitting_bridge_vc1;
	level.scr_anim[ "vc_catwalk_sit_1" ][ "catwalk_sit_1_react" ] 		= %ch_creek_b02_village_sitting_bridge_exploreact_vc1;

	level.scr_anim[ "vc_catwalk_sit_2" ][ "patrol_idle" ][0] 					= %ch_creek_b02_village_sitting_bridge_vc2;
	level.scr_anim[ "vc_catwalk_sit_2" ][ "catwalk_sit_2_react" ] 		= %ch_creek_b02_village_sitting_bridge_exploreact_vc2;
	
	
	// RPG on rooftop
	level.scr_anim[ "roof_rpg_vc" ][ "rpg_death_from_above" ] 				= %ch_creek_b03_rpg_opens_flap;
	
	// Second fight main village road
	level.scr_anim[ "vc_second_fight_leader" ][ "signal_fight" ] 			= %ch_creek_b02_village_attack_signal;
	level.scr_anim[ "vc_second_fight_slider" ][ "hut_slide" ] 				= %ch_creek_b02_village_hut_corner_slide;
	level.scr_anim[ "vc_parkour_1" ][ "scale_to_roof" ] 							= %ch_creek_b02_village_parkour2roof;
	level.scr_anim[ "vc_hurdler" ][ "hurdle_to_rush" ] 								= %ch_creek_b02_village_hurdle2fight;
	level.scr_anim[ "vc_ridge_slider" ][ "slide_down_ridge" ]					= %ch_creek_b03_slope_slide_1;
	level.scr_anim[ "vc_shore_drop" ][ "shore_drop_down" ] 						= %ch_creek_b02_roof_traverse_A; 

	// Top of the Ridge
	level.scr_anim[ "vc_on_roof" ][ "roof_roll_death" ] 							= %ch_creek_b02_village_rooftop_rolloff_death;
	level.scr_anim[ "vc_jump_out_window" ][ "jump_into_intersection" ]= %ch_creek_b02_village_window_dive;
	
	level.scr_anim[ "vc_ridge_roof" ][ "ridge_roof_flap" ] 						= %ch_creek_b03_opens_flap;

	level.scr_anim[ "vc_tree_hugger" ][ "slide_down" ] 								= %ch_creek_b03_tree_slide_1;
	level.scr_anim[ "vc_mg_gunner" ][ "dive_for_mg" ] 								= %ch_creek_b02_vc_window_jump;

	// Sampan Landing
	level.scr_anim[ "sampan_driver" ][ "driver_death" ] 							= %ch_creek_b03_sampan_offload_driver_death;
	level.scr_anim[ "sampan_driver" ][ "driver_idle" ][0]							= %ch_creek_b03_sampan_offload_driver_idle;
	level.scr_anim[ "sampan_vc_1" ][ "vc_1_shore_depart" ] 						= %ch_creek_b03_sampan_offload_guy_1;
	level.scr_anim[ "sampan_vc_2" ][ "vc_2_shore_depart" ] 						= %ch_creek_b03_sampan_offload_guy_2;
	level.scr_anim[ "sampan_vc_3" ][ "vc_3_shore_depart" ] 						= %ch_creek_b03_sampan_offload_guy_3;
	
	// Suicide Bomber
	level.scr_anim[ "suicide_bomber" ][ "suicide_rush" ] 							= %ai_suicide_bomber_run;
	
	// Flamethrower death temp
	level.scr_anim[ "purp_shirt_die" ][ "fire_death" ] 								= %ai_flame_death_A;
	level.scr_anim[ "vc_flame_master" ][ "drop_that_thrower" ] 				= %exposed_death_nerve;
	
	// Waterhut rpg VC
	level.scr_anim[ "watergut_rpg" ][ "rpg_death" ] = %RPG_stand_death;
	
	// animations for variations in ratholes
	level.scr_anim[ "generic" ][ "rathole" ] = [];
	level.scr_anim[ "generic" ][ "rathole" ][0] = %ai_mantle_on_56;
	level.scr_anim[ "generic" ][ "rathole" ][1] = %ai_viet_rathole_mantle_on_56_2_crch;
	level.scr_anim[ "generic" ][ "rathole" ][2] = %ai_viet_rathole_mantle_on_56_2_run;
	level.scr_anim[ "generic" ][ "rathole" ][3] = %ai_viet_rathole_mantle_on_56_2_stnd;
	
//---------------------------------------------------------------------------------------------------------
// BEAT 4

	level.scr_anim["reznov"]["tunnel_crouch_walk"] 		= %ai_reznov_crouchwalk_f;
	level.scr_anim["swift"]["tunnel_crouch_walk"] 		= %ai_reznov_crouchwalk_f;
	
	// entrance
	level.scr_anim["barnes"]["tunnel_entrance_new"] 		= %ch_creek_b04_rat_tunnel_intro_woods;
	level.scr_anim["hudson"]["tunnel_entrance_new"] 		= %ch_creek_b04_rat_tunnel_intro_bowman;
	level.scr_anim["swift"]["tunnel_entrance_new"] 			= %ch_creek_b04_rat_tunnel_intro_swift;
	addNotetrack_customFunction( "barnes", "spawn_grenade", ::b4_tunnel_grenade_spawn, "tunnel_entrance_new" ); 
	addNotetrack_customFunction( "barnes", "grenade_explosion", ::b4_tunnel_grenade_explode, "tunnel_entrance_new" ); 
	level.scr_anim["barnes"]["tunnel_entrance_C"] 		= %ch_creek_b04_rat_tunnel_intro_C_barnes;
	level.scr_anim["hudson"]["tunnel_entrance_C"] 		= %ch_creek_b04_rat_tunnel_intro_C_lewis;

	// room 1
	level.scr_anim["reznov"]["vc_to_shelf"] 						= %ch_creek_b02_reznov_pushvc_walktoshelf;
	addNotetrack_customFunction( "reznov", "mason_line", ::tunnel_shelf_mason_vo, "vc_to_shelf" ); 
	level.scr_anim["reznov"]["shelf_loop"][0] 					= %ch_creek_b02_reznov_move_shelf_wait_loop;
	level.scr_anim["reznov"]["shelf_to_tunnel"] 				= %ch_creek_b02_reznov_move_shelf_enter_tunnel;
	level.scr_anim["vc_tunnel_room1_3"]["death_drop"] 	= %ch_creek_b02_vc_deathandrop;
	level.scr_anim["vc_tunnel_room1_3"]["fire_loop"][0] = %ch_creek_b02_vc_firingloop;

	// swift death
	level.scr_anim["swift"]["swift_death"]						= %ch_creek_b04_tunnel_swift_death;
	level.scr_anim["swift"]["swift_death_loop"][0]		= %ch_creek_b04_tunnel_swift_death_loop;
	level.scr_anim["vc_tunnel_trap"]["swift_death"]		= %ch_creek_b04_tunnel_VC_attack;
	addNotetrack_customFunction( "vc_tunnel_trap", "stab", ::b4_use_stab_death_anim, "swift_death" ); 
	addNotetrack_customFunction( "vc_tunnel_trap", "pull_out", ::b4_use_crouch_death_anim, "swift_death" ); 
	addNotetrack_customFunction( "swift", "blood_fx", ::play_swift_kill_blood_fx, "swift_death" ); 
	
	// ambush
	level.scr_anim["vc_tunnel_ambush_guy1"]["slash_attack"]	= %ch_creek_b04_ambush_1;
	level.scr_anim["vc_tunnel_ambush_guy2"]["slash_attack"]	= %ch_creek_b04_ambush_2;
	level.scr_anim["vc_tunnel_ambush_guy1"]["slash_idle"][0]	= %ch_creek_b04_ambush_1_idle;
	level.scr_anim["vc_tunnel_ambush_guy2"]["slash_idle"][0]	= %ch_creek_b04_ambush_2_idle;
	addNotetrack_customFunction( "vc_tunnel_ambush_guy1", "slash_death", ::b4_tunnel_slash_player, "slash_attack" ); 
	addNotetrack_customFunction( "vc_tunnel_ambush_guy2", "slash_death", ::b4_tunnel_slash_player, "slash_attack" ); 
	
	// strafe vc
	level.scr_anim["vc_tunnel_room1_2"]["strafe_attack"]	= %ch_creek_b04_vc_tunnel_strafe;
	
	// aa gun gunner
	level.scr_anim["aa_gunner"]["fire_loop"][0]	= %crew_flak1_tag1_idle_1;
	level.scr_anim["aa_gunner"]["death"]				= %crew_model3_driver_death;
	
	// m202 guy
	level.scr_anim["m202_guy"]["m202_run"]	= %ch_creek_b02_m202_guy_run_cycle;
	level.scr_anim["m202_guy"]["drop_m202"]	= %ch_creek_b02_m202_guy;
	level.scr_anim["m202_wingman"]["drop_m202"]	= %ch_creek_b02_m202_wingman;
	addNotetrack_customFunction( "m202_guy", "shot", maps\creek_1_assault::get_shot_to_death, "drop_m202" ); 
	addNotetrack_customFunction( "m202_wingman", "shot", maps\creek_1_assault::get_shot_to_death, "drop_m202" ); 
	addNotetrack_customFunction( "m202_guy", "blood_fx", ::play_m202_guy_kill_blood_fx, "drop_m202" );
	addNotetrack_customFunction( "m202_guy", "start_ragdoll", maps\creek_1_assault::play_m202_guy_drop_m202, "drop_m202" );

	level.scr_sound["calvary_chopper"]["sierra_at_north"] = "vox_cre1_s02_074A_mar1_f"; //Sierra is at the North perimeter.
	level.scr_sound["calvary_chopper"]["sierra_cleared"] = "vox_cre1_s02_079A_mar1_f"; //Sierra has cleared the North perimeter. Moving to the village.
	level.scr_sound["calvary_chopper"]["sierra_in_pos"] = "vox_cre1_s02_088A_mar1_f"; //Sierra in position.
	level.scr_sound["calvary_chopper"]["got_it"] = "vox_cre1_s03_110A_mar1_f"; //Got it!
	
	// reznov anims in tunnel
	level.scr_anim["reznov"]["blinded_idle"][0]		= %ch_creek_b04_tunnel_reznovblinded_idle;
	level.scr_anim["reznov"]["blinded"]						= %ch_creek_b04_tunnel_reznovblinded;
	level.scr_anim["reznov"]["drown_vc"]					= %ch_creek_b04_tunnel_reznovdrown_rez;
	level.scr_anim["drowned_vc"]["drown_vc"]			= %ch_creek_b04_tunnel_reznovdrown_vc;
	addNotetrack_customFunction( "reznov", "landing", ::b4_tunnel_reznov_landing, "blinded" ); 
	addNotetrack_customFunction( "reznov", "stab1", ::b4_tunnel_reznov_drown_stab1, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "stab2", ::b4_tunnel_reznov_drown_stab2, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "wall_hit_1", ::b4_tunnel_reznov_drown_wall1, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "wall_hit_2", ::b4_tunnel_reznov_drown_wall2, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "splash", ::b4_tunnel_reznov_drown_splash, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "swipe", ::b4_tunnel_reznov_drown_swipe, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "footstep_splash_left", ::b4_tunnel_splash_left_step, "drown_vc" ); 
	addNotetrack_customFunction( "reznov", "footstep_splash_right", ::b4_tunnel_splash_right_step, "drown_vc" ); 
	addNotetrack_customFunction( "drowned_vc", "footstep_left_small", ::b4_tunnel_splash_left_step, "drown_vc" ); 
	addNotetrack_customFunction( "drowned_vc", "footstep_right_small", ::b4_tunnel_splash_right_step, "drown_vc" ); 
	addNotetrack_customFunction( "drowned_vc", "footstep_splash_left", ::b4_tunnel_splash_left_step, "drown_vc" ); 
	addNotetrack_customFunction( "drowned_vc", "footstep_splash_right", ::b4_tunnel_splash_right_step, "drown_vc" ); 
	level.scr_anim["reznov"]["drown_vc_idle"][0]					= %ch_creek_b04_tunnel_reznovdrown_rez_loop;		
	level.scr_anim["drowned_vc"]["drown_vc_idle"][0]			= %ch_creek_b04_tunnel_reznovdrown_vc_loop;	
	
	// peeking VC
	level.scr_anim["b4_peek_vc"]["crouch_idle"][0]	= %covercrouch_hide_idle;
	level.scr_anim["b4_peek_vc"]["peek_up"]					= %covercrouch_hide_2_stand;
	level.scr_anim["b4_peek_vc"]["crouch_down"]			= %covercrouch_stand_2_hide;
	
	/*
	level.scr_anim["vc_tunnel_room2_1"]["jump_out_attack_1"]			= %ch_creek_b04_tunnel_popout_vc_shoot_1;
	level.scr_anim["vc_tunnel_room2_1"]["jump_out_attack_2"]			= %ch_creek_b04_tunnel_popout_vc_shoot_2;
	level.scr_anim["vc_tunnel_room2_7"]["jump_out_attack_1"]			= %ch_creek_b04_tunnel_topofincline_vc_shoot_1;
	level.scr_anim["vc_tunnel_room2_7"]["jump_out_attack_2"]			= %ch_creek_b04_tunnel_topofincline_vc_shoot_2;
	*/
	
	level.scr_anim["vc_tunnel_room2_7"]["jump_out_attack_1"]			= %ch_creek_b04_tunnel_popout_vc_shoot_1;
	level.scr_anim["vc_tunnel_room2_7"]["jump_out_attack_2"]			= %ch_creek_b04_tunnel_popout_vc_shoot_2;
	level.scr_anim["vc_tunnel_room2_1"]["jump_out_attack_1"]			= %ch_creek_b04_tunnel_topofincline_vc_shoot_1;
	level.scr_anim["vc_tunnel_room2_1"]["jump_out_attack_2"]			= %ch_creek_b04_tunnel_topofincline_vc_shoot_2;
	
	// ending
	level.scr_anim["barnes"]["crouch_aim"][0]						= %ai_huey_passenger_f_rt;
	
	level.scr_anim["barnes"]["ending_rescue"]	 			= %ch_creek_b04_end_rescue_barnes;
	level.scr_anim["hudson"]["ending_rescue"]	 			= %ch_creek_b04_end_rescue_bowman;
	
	// war room
	level.scr_anim["reznov"]["door_kick"]						= %door_kick_in;
	addNotetrack_customFunction( "reznov", "kick", ::wa_room_exit_kick_open, "door_kick" );

	// reznov in war room
	level.scr_anim["reznov"]["enter_war_room"]	 		= %ch_creek_b04_tunnel_kravlair_reznov_enter;
	level.scr_anim["reznov"]["exit_war_room"]	 			= %ch_creek_b04_tunnel_kravlair_reznov_exit;
	level.scr_anim["reznov"]["loop_war_room"]	 			= %ch_creek_b04_tunnel_kravlair_reznov_searchloop;
	addNotetrack_customFunction( "reznov", "gun_disappear", ::put_away_reznov_gun_lair, "enter_war_room" );
	addNotetrack_customFunction( "reznov", "gun_reappear", ::put_back_reznov_gun_lair, "exit_war_room" );
	addNotetrack_customFunction( "reznov", "turn_on_radio", ::turn_on_radio_reznov_lair, "enter_war_room" );

	
	// SOUND ---------------------------------------------------
	// ---------------------------------------------------------
	
	level.scr_sound["mason"]["steiner"] 	= "vox_cre1_s01_700A_rezn";
	
	// distraction
	level.scr_sound["barnes"]["create_distraction"] = "VOX_CRE1_071A_BARN"; 
	level.scr_sound["hudson"]["copy"] 				= "VOX_CRE1_072A_HUDS"; 
	level.scr_sound["barnes"]["hold_up"] 			= "VOX_CRE1_098A_BARN"; 

	// battles
	level.scr_sound["barnes"]["move_up"] 				= "VOX_CRE1_073A_BARN"; 
	level.scr_sound["barnes"]["flank_them"] 			= "VOX_CRE1_074A_BARN"; 
	level.scr_sound["barnes"]["on_the_ridge"] 			= "VOX_CRE1_075A_BARN"; 
	level.scr_sound["barnes"]["more_on_the_roof"] 		= "VOX_CRE1_076A_BARN"; 
	level.scr_sound["barnes"]["keep_on_them"] 			= "VOX_CRE1_077A_BARN"; 
	level.scr_sound["barnes"]["get_up_hill"] 			= "VOX_CRE1_078A_BARN"; 
	level.scr_sound["barnes"]["clear_move_up"] 			= "VOX_CRE1_048A_BARN"; 
	level.scr_sound["barnes"]["more_of_them"] 			= "VOX_CRE1_049A_BARN"; 
	level.scr_sound["barnes"]["far_side_of_water"] 		= "VOX_CRE1_050A_BARN"; 
	level.scr_sound["barnes"]["flank_around"] 			= "VOX_CRE1_051A_BARN"; 
	level.scr_sound["barnes"]["far_side_of_ridge"] 		= "VOX_CRE1_050B_BARN"; 

	level.scr_sound["barnes"]["due_west"] 				= "VOX_CRE1_099A_BARN"; 
	level.scr_sound["barnes"]["nearly_there"] 			= "VOX_CRE1_100A_BARN"; 
	level.scr_sound["barnes"]["eyes_open"] 				= "VOX_CRE1_101A_BARN"; 

	level.scr_sound["barnes"]["there_they_are"] 		= "VOX_CRE1_103A_BARN"; 
	level.scr_sound["barnes"]["blow_to_pieces"] 		= "VOX_CRE1_104A_BARN"; 
	level.scr_sound["barnes"]["keep_them_back"] 		= "VOX_CRE1_105A_BARN"; 
	level.scr_sound["barnes"]["one_down"] 				= "VOX_CRE1_106A_BARN"; 
	level.scr_sound["barnes"]["two_more"] 				= "VOX_CRE1_107A_BARN"; 
	level.scr_sound["barnes"]["take_the_last"] 			= "VOX_CRE1_108A_BARN"; 
	level.scr_sound["barnes"]["nice_shooting"] 			= "VOX_CRE1_109A_BARN"; 
	
	// VC lines
	level.scr_sound["vc1"]["rain_getting_worse"] 	= "VOX_CRE1_700A_VIC1"; 
	level.scr_sound["vc2"]["keep_disciplined"] 		= "VOX_CRE1_701A_VIC2"; 

	level.scr_sound["vc2"]["stay_watching"] 			= "VOX_CRE1_702A_VIC1"; 
	level.scr_sound["vc1"]["shoot_them_sky"] 		= "VOX_CRE1_703A_VIC2"; 

	level.scr_sound["vc"]["shhh"] 					= "VOX_CRE1_706A_VIC1"; 
	level.scr_sound["vc"]["hear_something"] 		= "VOX_CRE1_707A_VIC2"; 

	level.scr_sound["patrol_1"]["tired_of_waiting"] 		= "VOX_CRE1_716A_VIC1"; 
	level.scr_sound["patrol_2"]["maybe_never"] 			= "VOX_CRE1_717A_VIC2"; 
	level.scr_sound["patrol_3"]["im_hungry"] 				= "VOX_CRE1_718A_VIC1"; 
	level.scr_sound["patrol_4"]["all_hungry"] 			= "VOX_CRE1_719A_VIC2"; 

	level.scr_sound["village_patrol_1_2"]["wheres_an"] 				= "VOX_CRE1_709A_VIC1"; 
	level.scr_sound["village_patrol_1_3"]["lazy_loaf"] 				= "VOX_CRE1_710A_VIC2"; 

	level.scr_sound["patrol_3"]["Americans"] 				= "VOX_CRE1_714A_VIC1"; 
	level.scr_sound["patrol_4"]["under_the_huts"] 		= "VOX_CRE1_715A_VIC2"; 

	// B2 Intro
	// level.scr_sound["barnes"]["wrong_side_river"] 		= "vox_Cre1_s02_008A_BARN";  	// We are at the wrong side of the river
	// -- FISHING VC

	// -- FISHING VCF
	
	//ACB - no more woods VO at chef hut
	//Should remove these post demo
	level.scr_sound["barnes"]["get_down"] 						= "vox_Cre1_s02_037A_BARN";  	// Get down
	level.scr_sound["barnes"]["shhhh"] 								= "vox_Cre1_s02_038A_BARN";  	// Shhh
	
	level.scr_sound["barnes"]["splitting_up"] 				= "vox_Cre1_s02_039A_BARN";  	// We are splitting up (10s)
	level.scr_sound["carter"]["understood"] 					= "vox_Cre1_s02_040A_CART";  	// Understood
	
	
	
	
// audio when player gets onto shore after huey crash
	level.scr_sound["barnes"]["stay_sharp"] = "vox_cre1_s02_022A_wood";//	Stay sharp Mason. They're out there. This is Lima 9 Xray
	level.scr_sound["vc1_ridge1"]["by_the_river"] = "vox_cre1_s02_023A_vic1";//	//(Translated) There! By the river!
	level.scr_sound["vc1_ridge1"]["only_two_of_them"] = "vox_cre1_s02_024A_vic2";//(Translated) There's only two of them! Fire!
	level.scr_sound["reznov"]["left_flank_ridge"] = "vox_cre1_s01_404A_rezn"; //Left flank, Mason! On the ridge!
	level.scr_sound["barnes"]["dead_ahead"] = "vox_cre1_s02_025A_wood";//	Dead ahead! Take cover!
	
	
// after killing river walk VCs
	level.scr_sound["reznov"]["impressive"] = "vox_cre1_s02_029B_rezn_m"; //Sergeant Woods is very capable... You have chosen your men well, Mason...
	level.scr_sound["reznov"]["impressive_p2"] = "vox_cre1_s02_029C_rezn_m"; //I will move to higher ground to look for Kravchenko's compound.
	level.scr_sound["mason"]["stay_close"] = "vox_cre1_s02_030A_maso"; // Understood. Stay close Viktor.
	
// woods during river walk
	level.scr_sound["hudson"]["this_is_whiskey"] = "vox_cre1_s02_032A_bowm_f"; //	Lima 9 Xray, this is Whiskey. You out there? 
	level.scr_sound["barnes"]["this_is_xray"] = "vox_cre1_s02_033A_wood"; //	This is Xray. Whiskey, come back. 
	level.scr_sound["hudson"]["wed_lost_you"] = "vox_cre1_s02_034A_bowm_f"; //	Woods! Thought we'd lost you. What's the new plan? 
	level.scr_sound["barnes"]["meet_us_at_the_rp"] = "vox_cre1_s02_035A_wood"; // 	You clear the south east perimeter and meet us at the RP. 
	level.scr_sound["hudson"]["whiskey_on_the_job"] = "vox_cre1_s02_036A_bowm_f"; //	Understood. Whiskey is on the job, over. 
	level.scr_sound["barnes"]["knife_only"] = "vox_cre1_s02_040A_wood"; //	The RP is just ahead. Bowman should be waiting for us. Keep it quiet here - knife only.  
	
// near sampan melee
	level.scr_sound["barnes"]["shh_vc"] = "vox_cre1_s02_043A_wood";  	// Sshh. VC
	level.scr_sound["b2_vc_sampan_1"]["catch_anything"] 			= "vox_cre1_s02_045A_vic1"; // 	Anh Dung. Did you catch anything?
	level.scr_sound["b2_vc_sampan_2"]["not_biting_today"] 		= "vox_cre1_s02_046A_vic2"; //	Nothing. They're not biting today.
	level.scr_sound["b2_vc_sampan_1"]["but_for_me"] 					= "vox_cre1_s02_047A_vic1"; //	Maybe not for you, but for me...

// pre-hey-charlie event
	level.scr_sound["barnes"]["quiet"] = "vox_cre1_s02_048A_wood"; //	Quiet.  
	
// explosive set nag lines
  level.scr_sound["barnes"]["c4_nag_1"] = "vox_cre1_s01_489A_wood"; //Mason, you need to plant that charge.
  // Not sure about this one. Not implemented
  level.scr_sound["barnes"]["c4_nag_2"] = "vox_cre1_s01_490A_wood"; //Get back there and plant that charge...
  level.scr_sound["barnes"]["c4_nag_3"] = "vox_cre1_s01_491A_wood"; //We need to plant the C4 Mason...

// window shimming event
	level.scr_sound["hudson"]["cleared_east_bank"] = "vox_cre1_s02_073A_bowm_f"; //	Whiskey has cleared the east bank, moving to the bridge.  
	level.scr_sound["marine_redshirt"]["seirra_north_perimeter"] = "vox_cre1_s02_074A_mar1_f"; //	Sierra is at the north perimeter.  
	
// ???????? Notetrack
	level.scr_sound["barnes"]["down"] = "vox_cre1_s01_410A_wood"; //	Down!  
	level.scr_sound["barnes"]["ssh."] = "vox_cre1_s02_077A_wood"; //	Ssh.  

	level.scr_sound["b2_vc_chef_1"]["with_no_bait"] = "vox_cre1_s02_049A_vic2"; //	Tui d? anh Dung c�u m?h�ng c?m?i  
	level.scr_sound["b2_vc_chef_2"]["doesnt_know"] = "vox_cre1_s02_050A_vic3"; //	Anh h�ng bi?t h??  
	level.scr_sound["b2_vc_chef_1"]["an_empty_line"] = "vox_cre1_s02_051A_vic2"; //	H�ng. Anh ng?i canh c?n c�u tr?ng tron.  
	level.scr_sound["b2_vc_chef_2"]["a_little_stupid"] = "vox_cre1_s02_052A_vic3"; //	H�nh nhu anh hoi kh?.  
	level.scr_sound["b2_vc_chef_1"]["fish_are_smarter"] = "vox_cre1_s02_053A_vic2"; //	Hoi th�i h?? C?c�n kh�n hon anh.  
	level.scr_sound["b2_vc_chef_2"]["turn_on_you"] = "vox_cre1_s02_054A_vic3"; //	Mai m?t anh l?i choi l?i m�y d?Chi?n. Tao mong t?i ng�y d? 

// entering large hut above ladder
	level.scr_sound["mason"]["explosions_are_primed"] = "vox_cre1_s02_087A_maso"; //	Explosives are primed.  	
	level.scr_sound["mason"]["seirra_in_position"] = "vox_cre1_s02_088A_mar1_f"; //	Sierra is in position.  
	level.scr_sound["mason"]["whiskey_ready"] = "vox_cre1_s02_089A_bowm_f"; //	This is Whiskey. We're ready.  
	level.scr_sound["barnes"]["xray_is_inbound"] = "vox_cre1_s01_413A_wood"; //Copy, Xray inbound.

// given detonator
	level.scr_sound["barnes"]["detonator_ready"] = "vox_cre1_s01_414A_wood"; //You got that detonator handy?
  level.scr_sound["mason"]["right_here"] = "vox_cre1_s01_415A_maso"; //Right here.

// vcs in village
	level.scr_sound["generic"]["village_vc_line1"] 	= "vox_cre1_s03_091A_vic2"; 		// I need a new gun.
	level.scr_sound["generic"]["village_vc_line2"] 	= "vox_cre1_s03_092A_vic3"; 		// These are useless. Russian junk.
	level.scr_sound["generic"]["village_vc_line3"] 	= "vox_cre1_s03_093A_vic2"; 		// Chien got himself an M16.
	level.scr_sound["generic"]["village_vc_line4"] 	= "vox_cre1_s03_094A_vic3"; 		// Really? Nice!
	level.scr_sound["generic"]["village_vc_line5"] 	= "vox_cre1_s03_095A_vic2"; 		// He won't let you even touch it.
	
	
	
	
	level.scr_sound["barnes"]["semtex"] = "vox_cre1_s02_076A_wood"; //	Semtex.  
	level.scr_sound["reznov"]["always"] = "vox_cre1_s02_031A_rezn_m"; // Always.

	level.scr_sound["hudson"]["go_again"] = "vox_cre1_s02_027A_bowm_f"; // 	Xray go again, over.
	level.scr_sound["reznov"]["left_flank"] = "vox_cre1_s02_028A_rezn";//	Left flank Mason. In the trees.
	// -- RIVER WALK
	
	// -- RIVER WALK -- STEALTH OBJECTIVE
	level.scr_sound["barnes"]["all_it_does_here"] = "vox_cre1_s02_038A_wood"; //	That's all it does here. Rain.  
	level.scr_sound["barnes"]["carhlies_world"] = "vox_cre1_s02_039A_wood"; //	Keep your eyes open. This is Charlie's world.  
	level.scr_sound["barnes"]["knife_only"] = "vox_cre1_s02_040A_wood"; //	The RP is just ahead. Bowman should be waiting for us. Keep it quiet here - knife only.  
	level.scr_sound["reznov"]["treat_her_well"] = "vox_cre1_s02_041A_rezn"; //	Something to remember me by. Treat her well.  
	level.scr_sound["mason"]["not_a_problem"] = "vox_cre1_s02_042A_maso"; // Not a problem.  
	
	// -- POST VIGNETTE
	level.scr_sound["mason"]["hang_back"] = "vox_cre1_s02_069A_maso"; //	Hang back. Once we bring in the choppers, you can head across.  
	level.scr_sound["barnes"]["that_all_about"] = "vox_cre1_s02_071A_wood"; //	What was that all about?  
	level.scr_sound["mason"]["our_investment"] = "vox_cre1_s02_072A_maso"; //	Protecting our investment.  
	// -- POST VIGNETTE
	
	// -- COOKING HUT

	level.scr_sound["hudson"]["on_the_bridge"] = "vox_cre1_s02_078A_bowm_f"; //	Whiskey on the bridge. Moving north.  
	level.scr_sound["marine_redshirt"]["sierra_cleared_north"] = "vox_cre1_s02_079A_mar1_f"; //	Sierra has cleared the north perimeter. Moving to the village.  
	level.scr_sound["barnes"]["clearing_east_flank"] = "vox_cre1_s02_080A_wood_m"; //	Xray is clearing the east flank. ETA 3 minutes. We're splitting up. I'll take the high ground. Cross the river to the right and find a place for the Semtex.  
	level.scr_sound["mason"]["understood"] = "vox_cre1_s02_081A_maso"; //	Understood.  
	level.scr_sound["barnes"]["hold_on_mason"] = "vox_cre1_s02_082A_wood"; //	Hold on Mason.  
	level.scr_sound["barnes"]["second_boat_has_ammo"] = "vox_cre1_s02_086A_wood"; //	Clear. The second boat has ammo on it. Use it.  
	// -- COOKING HUT

	// Dialogue
	level.scr_sound["barnes"]["weapons_free"] 			= "vox_cre1_s03_493A_wood"; 		//Weapons free!
	level.scr_sound["barnes"]["keep_eye_open_aa"] 	= "vox_cre1_s01_416A_wood"; 		// Keep your eyes open for that AA gun!
	level.scr_sound["hudson"]["zpu_on_river"] 			= "vox_cre1_s03_102A_bowm_f"; 	// One zero, one zero, this is Bowman. We've got a ZPU on the river.
	level.scr_sound["barnes"]["thats_the_gun"] 			= "vox_cre1_s03_103A_wood"; 		// That's the gun! Mason, go take it out. Once their air defense is down we can bring in the Hornets.
	level.scr_sound["mason"]["on_my_way"] 					= "vox_cre1_s03_104A_maso"; 		// On my way.
	level.scr_sound["hudson"]["behind_that_hut"] 		= "vox_cre1_s01_417A_bowm"; 		// Right behind that hut on the river. You see it?
	level.scr_sound["mason"]["got_it!"] 						= "vox_cre1_s03_106A_maso"; 		// Got it!
	level.scr_sound["hudson"]["charles_dont_let"] 	= "vox_cre1_s03_107A_bowm"; 		// Charlie don't want to let that gun go! Look at those fuckers move!
	level.scr_sound["mason"]["lets_hit_it"] 				= "vox_cre1_s03_108A_maso"; 		// All right, let's hit it.
	level.scr_sound["hudson"]["need_more_firepwr"] 	= "vox_cre1_s01_418A_bowm"; 		// We need more firepower. Johnson! Bring in the M202. Hit that ZPU on the river.
	level.scr_sound["generic"]["marine_got_it"] 		= "vox_cre1_s03_110A_mar1"; 		// Got it!
	level.scr_sound["hudson"]["can_you_get_m202"] 	= "vox_cre1_s03_111A_bowm"; 		// Damn it! Mason - can you get to the 202? I'm pinned down.
	level.scr_sound["mason"]["yeah_i_got_it"] 			= "vox_cre1_s03_112A_maso"; 		// Yeah, I got it.
	level.scr_sound["hudson"]["use_m202_v1"] 				= "vox_cre1_s03_113A_bowm"; 		// Mason! Use the M202!
	level.scr_sound["hudson"]["use_m202_v2"] 				= "vox_cre1_s01_419A_bowm"; 		// Mason! Use the M202 on the AA gun!!
	level.scr_sound["hudson"]["nest_is_empty"] 			= "vox_cre1_s03_116A_bowm"; 		// One zero one zero the nest is empty. Objective complete.
	level.scr_sound["barnes"]["understood_dock"] 		= "vox_cre1_s03_117A_wood_f"; 	// Understood.
	level.scr_sound["barnes"]["bring_air_support"] 	= "vox_cre1_s03_118A_wood_f"; 	// RT-Kentucky this is Lima 9. Sierra 3 is clear. Bring in our air support.
	level.scr_sound["hudson"]["need_birds_now"] 		= "vox_cre1_s03_119A_bowm"; 		// Christ?we need those birds in here NOW!
	level.scr_sound["mason"]["hornets_inbound"] 	= "vox_cre1_s01_420A_usc3_f"; 	// Lima 9 this is RT-Kentucky. The Green Hornets are inbound. Hang in there boys.
	level.scr_sound["mason"]["coming_in_hot"] 		= "vox_cre1_s03_121A_usc2_f"; 	// Lima 9 keep your shit tucked. We are coming in hot!	usc2
	level.scr_sound["generic"]["who_told_you"] 			= "vox_cre1_s03_122A_uss1"; 		// Soldier, who the fuck told you?
	level.scr_sound["barnes"]["9_o_clock"] 					= "vox_cre1_s03_123A_wood"; 		// Vietcong! 9 o'clock.
	level.scr_sound["barnes"]["get_a_nade_in_v1"] 	= "vox_cre1_s03_124A_wood"; 		// Get a 'nade in that rat hole!
	level.scr_sound["barnes"]["rathole_ahead"] 			= "vox_cre1_s03_125A_wood"; 		// Rat hole dead ahead!
	level.scr_sound["hudson"]["get_a_nade_in_v2"] 	= "vox_cre1_s03_126A_bowm"; 		// Someone drop a 'nade in that hole!
	level.scr_sound["barnes"]["eyes_left_mason"] 		= "vox_cre1_s03_127A_wood"; 		// Eyes left Mason. Take those bastards out!
	level.scr_sound["barnes"]["charlies_on_right"] 	= "vox_cre1_s03_128A_wood"; 		// Charlie on the right!
	level.scr_sound["hudson"]["clear_move_move"] 		= "vox_cre1_s03_129A_bowm"; 		// We're clear - move move!
	level.scr_sound["barnes"]["area_clear!"] 				= "vox_cre1_s03_130A_wood"; 		// Area clear!
	level.scr_sound["hudson"]["dock_is_clear"] 			= "vox_cre1_s03_131A_bowm"; 		// Dock is clear, move up!
	level.scr_sound["barnes"]["push_through"] 			= "vox_cre1_s03_132A_wood"; 		// Push through! Let's go!
	level.scr_sound["barnes"]["make_sure_shack"] 		= "vox_cre1_s03_133A_wood"; 		// Mason! Make sure that shack is clear!
	level.scr_sound["hudson"]["keep_head_down"] 		= "vox_cre1_s03_134A_bowm"; 		// Kepp your head down!
	level.scr_sound["barnes"]["contact_on_roof"] 		= "vox_cre1_s03_135A_wood"; 		// Contact on the roof! Mason, drop 'em!
	level.scr_sound["hudson"]["vc_on_roof"] 				= "vox_cre1_s03_136A_bowm"; 		// Check high! VC on the roof!
	level.scr_sound["barnes"]["cut_through_hut"] 		= "vox_cre1_s03_137A_wood"; 		// Area clear! We're gonna cut through this hut. Mason, lead the way.
	level.scr_sound["barnes"]["mason_over_here"] 		= "vox_cre1_s03_138A_wood"; 		// Mason! Over here!
	level.scr_sound["barnes"]["lets_go_on_me"] 			= "vox_cre1_s03_139A_wood"; 		// Let's go Mason! On me!
	level.scr_sound["barnes"]["need_you_in_pos"] 		= "vox_cre1_s03_140A_wood"; 		// Mason I need you in position!
	level.scr_sound["hudson"]["move_it_brother"] 		= "vox_cre1_s03_141A_bowm"; 		// Mason, move it brother!
	level.scr_sound["mason"]["told_you_back"] 			= "vox_cre1_s03_142A_maso"; 		// Reznov. I told you to hang back.
	level.scr_sound["reznov"]["where_I_belong"] 		= "vox_cre1_s03_143A_rezn"; 		// This is where I belong Mason. You need me.
	level.scr_sound["mason"]["keep_head_down"] 			= "vox_cre1_s03_144A_maso"; 		// Just keep your goddamned head down.
	level.scr_sound["barnes"]["charlie_on_mg"] 			= "vox_cre1_s03_145A_wood"; 		// Charlie's getting on that MG?Shit! Take cover!
	level.scr_sound["hudson"]["take_sob_down"] 			= "vox_cre1_s03_146A_bowm"; 		// Someone take that son of a bitch down!
	level.scr_sound["barnes"]["got_eyes_on_him"] 		= "vox_cre1_s03_147A_wood"; 		// Mason! You got eyes on him?
	level.scr_sound["mason"]["hes_mine"] 						= "vox_cre1_s03_148A_maso"; 		// He's mine.
	level.scr_sound["generic"]["rathole_entran_1"] 	= "vox_cre1_s04_149A_vic1"; 		// Go! They're coming! Into the tunnel.
	level.scr_sound["generic"]["rathole_entran_2"] 	= "vox_cre1_s04_150A_vic2"; 		// Americans! Americans!

	level.scr_sound["barnes"]["targets_on_roof"] 		= "vox_cre1_s01_421A_wood"; //Left flank! Targets on the roof!
  level.scr_sound["barnes"]["rest_of_village"] 		= "vox_cre1_s01_422A_wood"; //Clear out the rest of the village!
  level.scr_sound["mason"]["tunnel_up_ahead"] 		= "vox_cre1_s01_426A_maso"; //Rat tunnel up ahead.
  level.scr_sound["barnes"]["i_see_it"] 					= "vox_cre1_s01_427A_wood"; //I see it.
    
	level.scr_sound["swift"]["keep_steady"] 					= "vox_cre1_s04_158A_swif"; 	// Keep that light steady Mason.
	level.scr_sound["mason"]["hold"] 									= "vox_cre1_s04_159A_maso"; //Hold.
	
	level.scr_sound["mason"]["xray_come_in"] = "vox_cre1_s01_432A_maso"; //X-Ray, come in.
  level.scr_sound["barnes"]["go_ahead_mason"] = "vox_cre1_s01_433A_wood_f"; //Go ahead, Mason.
  level.scr_sound["mason"]["swift_dead_vc"] = "vox_cre1_s01_434A_maso"; //Swift's dead... We got VC crawling all over.
  level.scr_sound["barnes"]["lama_9_sweep"] = "vox_cre1_s01_435A_wood_f"; //Lima 9 is sweeping the area. No sign of.... (static)
  level.scr_sound["mason"]["xray_copy"] = "vox_cre1_s01_436A_maso"; //X-ray - Do you copy?
  level.scr_sound["mason"]["xray_shit"] = "vox_cre1_s01_437A_maso"; //Shit...
    
    
	level.scr_sound["mason"]["swift_dead"] = "vox_cre1_s04_168A_maso_m"; //Dead.
 	level.scr_sound["swift"]["fighting_no_more"] = "vox_cre1_s04_156A_swif"; //This son of a bitch ain't fighting no more.
	
  level.scr_sound["mason"]["son_of_a_b"] = "vox_cre1_s01_445A_maso"; //Son of a bitch!
  level.scr_sound["reznov"]["careful_i_hear"] = "vox_cre1_s04_172A_rezn"; //Careful Mason... I hear the enemy.
  level.scr_sound["reznov"]["getting_close"] = "vox_cre1_s01_446A_rezn"; //We are getting close, Mason.
  level.scr_sound["reznov"]["this_is_it"] = "vox_cre1_s01_448A_rezn"; //This is it... Kravchenko's forward compound.
    
    
	level.scr_sound["mason"]["don't_breath"] 				= "vox_Cre1_s04_088A_CART";  	// Don't breath
	level.scr_sound["mason"]["shit"] 								= "vox_cre1_s01_444A_maso";  	// Shit!
	
	level.scr_sound["mason"]["which_way"] 	= "vox_cre1_s01_442A_maso"; //Which way, Reznov?
  level.scr_sound["reznov"]["follow_instincts"] 	= "vox_cre1_s01_443A_rezn"; //Follow your instincts, Mason.
  
  
  level.scr_sound["mason"]["looks_abandoned"] = "vox_cre1_s01_449A_maso"; //Looks abandoned.
  level.scr_sound["reznov"]["anticipate_arrival"] = "vox_cre1_s01_450A_rezn"; //He anticipated our arrival.
  level.scr_sound["mason"]["left_in_a_hurry"] = "vox_cre1_s01_451A_maso"; //...And left in a hurry.
  level.scr_sound["reznov"]["look_around"] = "vox_cre1_s01_452A_rezn"; //Look around.
  level.scr_sound["reznov"]["krav"] = "vox_cre1_s01_453A_rezn"; //Kravchenko...

	level.scr_sound["krav"]["recording_1"] = "vox_cre1_s01_454A_krav"; //February 4th, 1968. The stabilizing agents supplied by Doctor Clarke have met with much success.
  level.scr_sound["krav"]["recording_2"] = "vox_cre1_s01_455A_krav"; //Recent field tests on the local population have shown this to be the most effective strain of Nova 6 produced thus far.
  level.scr_sound["krav"]["recording_3"] = "vox_cre1_s01_456A_krav"; //As with previous animal tests at Rebirth, the onset of symptoms in human subjects is exactly in line with our expectations.
  level.scr_sound["krav"]["recording_4"] = "vox_cre1_s01_457A_krav"; //Within thirty seconds of inhaling the gas, subjects experience sudden and severe pain, quickly followed by significant drop in blood pressure, leading to fever, nausea and vomiting.
  level.scr_sound["krav"]["recording_5"] = "vox_cre1_s01_458A_krav"; //After sixty seconds, blistering of the skin begins - followed by scaling, peeling, and discoloration across the subject's entire body...  Effectively signaling the onset of epidermal necrosis.
  level.scr_sound["krav"]["recording_6"] = "vox_cre1_s01_459A_krav"; //At this stage we have had limited success - by way of aggressive surgical debridement - in keeping subjects alive for short periods.
  level.scr_sound["krav"]["recording_7"] = "vox_cre1_s01_460A_krav"; //But even the surgical removal of infected tissue is not enough to prevent further spread.
  level.scr_sound["krav"]["recording_8"] = "vox_cre1_s01_461A_krav"; //While the speed of infection appears to be consistent across adult males, we have observed a more aggressive rate of decay within infants - usually leading to mortality within thirty to forty five seconds.
  level.scr_sound["krav"]["recording_9"] = "vox_cre1_s01_462A_krav"; //We have every indication that we now have a workable formula which is effective - even in warmer climates.
  level.scr_sound["krav"]["recording_10"] = "vox_cre1_s01_463A_krav"; //Communicate our successes to Doctor Steiner. Kravchenko out.
    
	level.scr_sound["reznov"]["base_in_laos"] = "vox_cre1_s01_464A_rezn"; //These documents indicate that Kravchenko's primary base of operations is across the border - Laos.
	level.scr_sound["reznov"]["rebirth"] = "vox_cre1_s01_465A_rezn"; //There's flight plans to the base... supplies brought in from somewhere called... Rebirth?

	level.scr_sound["mason"]["search_1a"] = "vox_cre1_s01_466A_maso"; //How many people has this bastard killed?
	level.scr_sound["reznov"]["search_1b"] = "vox_cre1_s01_467A_rezn"; //More than you could ever count, Mason.
	level.scr_sound["mason"]["search_2"] = "vox_cre1_s01_468A_maso"; //He's using atrocities of the war as a smokescreen for his experiments...
	level.scr_sound["mason"]["search_3"] = "vox_cre1_s01_469A_maso"; //Kravchenko's trying make it look like the US is behind this.
	level.scr_sound["mason"]["search_4"] = "vox_cre1_s01_470A_maso"; //He must have had supplies lowered in through here.

	level.scr_sound["mason"]["grab_docs"] = "vox_cre1_s01_471A_maso"; //Grab those documents, Reznov - We're leaving!
	level.scr_sound["reznov"]["go_go_tunnel"] = "vox_cre1_s01_472A_rezn"; //GO! GO!
	level.scr_sound["mason"]["xray_copy_escape"] = "vox_cre1_s01_473A_maso"; //X-ray - do you copy?!
	level.scr_sound["mason"]["sammit"] = "vox_cre1_s01_474A_maso"; //Dammit!
	level.scr_sound["reznov"]["my_grave"] = "vox_cre1_s01_475A_rezn"; //Hurry Mason! I do not wish this rat hole to become my grave!
	level.scr_sound["mason"]["xray_copy_repeat"] = "vox_cre1_s01_476A_maso"; //Repeat - X-ray - Do you copy?!!
	level.scr_sound["barnes"]["fire_from_tunnel"] = "vox_cre1_s01_477A_wood_f"; //Mason?!! What the fuck happened?... We're seeing fire from the tunnels?
	level.scr_sound["mason"]["wired_to_blow"] = "vox_cre1_s01_478A_maso"; //Kravchenko had the place wired to blow!
	level.scr_sound["barnes"]["where_are_you"] = "vox_cre1_s01_479A_wood_f"; //Where the hell are you?!
	level.scr_sound["mason"]["one_click_north"] = "vox_cre1_s01_480A_maso"; //We followed the tunnels about one click North!
	level.scr_sound["barnes"]["north_ridge_out"] = "vox_cre1_s01_481A_wood_f"; //That should bring you out somewhere near the north ridge!
	level.scr_sound["reznov"]["claw_out_here"] = "vox_cre1_s01_482A_rezn"; //We will have to claw our way out of here!
	level.scr_sound["barnes"]["holding_pattern"] = "vox_cre1_s01_483A_wood_f"; //We'll maintain a holding pattern 'till we have eyes on.
	level.scr_sound["mason"]["come_on_come_on"] = "vox_cre1_s01_484A_maso"; //Come on! Come on!
	level.scr_sound["reznov"]["dig_mason"] = "vox_cre1_s01_485A_rezn"; //Dig, Mason. Dig!!!
	level.scr_sound["mason"]["shit_cliff"] = "vox_cre1_s04_188A_maso"; //Shit!
	level.scr_sound["reznov"]["mason_vc_cliff"] = "vox_cre1_s01_486A_rezn"; //VC, Mason!
	level.scr_sound["mason"]["where_is_woods"] = "vox_cre1_s01_487A_maso"; //Where are you, Woods?!
	level.scr_sound["barnes"]["get_out_here"] = "vox_cre1_s01_488A_wood_f"; //Let's get the fuck out of here!
    
//---------------------------------------------------------------------------------------------------------
// OTHERS

	player_anim_setup();
	vehicles_anim_setup();
	sampan_anim_setup();
	flashlight_anim_setup();
	rice_bowl_anim_setup();
	hatch_anim_setup();
	shelf_anim_setup();
	calvary_chopper();
	crrek_1_prop_setup();
	tunnel_breakout_rock_setup();
}

#using_animtree ("generic_human");
reznov_unarmed_anims_setup()
{
/*
	self.a.overrideIdleAnimArray = [];
	self.a.overrideIdleAnimArray[0] = %ai_civ_gen_casual_stand_idle;
	self.a.overrideIdleAnimArray[1] = %ai_civ_gen_casual_stand_idle_twitch_01;
	self.a.overrideIdleAnimArray[2] = %ai_civ_gen_casual_stand_idle_twitch_02;

	self set_run_anim( "unarmed_run" );

	self gun_remove();
*/
}

#using_animtree("creek_1");

calvary_chopper()
{
	level.scr_anim["calvary_chopper"]["drop_off"] = %v_huey_creek_hover;
}

crrek_1_prop_setup()
{
	level.scr_anim[ "roof_rpg_vc_door" ][ "rpg_death_from_above" ] 			= %o_creek_b03_roof_flap;
	level.scr_anim[ "vc_ridge_roof_door" ][ "ridge_roof_flap" ] 			= %o_creek_b03_roof_flap2;
}

player_say_dialog()
{
	players = get_players();
	players[0] PlaySound( "VOX_CRE1_069B_CART" );
}

tunnel_breakout_rock_setup()
{
	level.scr_anim[ "tunnel_rock" ][ "breakout1" ] 			= %o_rocks_creek_tunnel_melee_a;
	level.scr_anim[ "tunnel_rock" ][ "breakout2" ] 			= %o_rocks_creek_tunnel_melee_b;
	level.scr_anim[ "tunnel_rock" ][ "breakout3" ] 			= %o_rocks_creek_tunnel_melee_c;
}

#using_animtree ("vehicles");
vehicles_anim_setup()
{
	level.scr_anim["pbr"]["waiting_idle"][0]	 	= %v_pbr_upacreek_b03_landing_startidle;
	level.scr_anim["chinook"]["waiting_idle"][0]	= %v_chinook_upacreek_b03_landing_startidle;

	level.scr_anim["pbr"]["landing"]	 			= %v_pbr_upacreek_b03_landing;
	level.scr_anim["pbr"]["landing_loop"][0]	 	= %v_pbr_upacreek_b03_landing_loop;
	level.scr_anim["pbr"]["dragged"]	 			= %v_pbr_upacreek_b03_dragged;
	addNotetrack_customFunction( "pbr", "sndnt#evt_bd_pbr_pt4_boat1", ::pbr_hit_fx_1, "dragged" );  
	addNotetrack_customFunction( "pbr", "sndnt#evt_bd_pbr_pt5_boat2", ::pbr_hit_fx_2, "dragged" );  
	addNotetrack_customFunction( "pbr", "sndnt#evt_bd_pbr_pt6_boat3", ::pbr_hit_fx_3, "dragged" );  

	level.scr_anim["chinook"]["landing"]	 		= %v_chinook_upacreek_b03_landing;
	level.scr_anim["chinook"]["landing_loop"][0]	= %v_chinook_upacreek_b03_landing_loop;
	level.scr_anim["chinook"]["dragged"]	 		= %v_chinook_upacreek_b03_dragged;

	level.scr_anim["crash_pbr1"]["dragged"]	 		= %v_pbr_upacreek_b03_dragged_crash_1;
	level.scr_anim["crash_pbr2"]["dragged"]	 		= %v_pbr_upacreek_b03_dragged_crash_2;
	level.scr_anim["crash_pbr3"]["dragged"]	 		= %v_pbr_upacreek_b03_dragged_crash_3;

	level.scr_anim["pbr"]["released"]	 			= %v_pbr_upacreek_b03_boat_released;
	
	level.scr_anim["huey"]["ending_rescue"]	 			= %v_creek_b04_end_rescue_huey;
}

#using_animtree ( "player" );
player_anim_setup()
{
	level.scr_animtree["player_hands_2"] = #animtree;

	level.scr_model["player_hands_2"] = "t5_gfl_ump45_viewmodel_player";

	level.scr_animtree["player_body"] = #animtree;

	level.scr_model["player_body"] = "t5_gfl_ump45_viewbody";
	//level.scr_model["player_hands_2"] = "viewhands_sas_woodland";

	// player get on boat
	level.scr_anim["player_body"]["get_on_boat"] 		= %int_upacreek_b03_landing;

	level.scr_anim["player_body"]["get_on_pbr"] 		= %int_upacreek_b03_mantle_pbr;
	level.scr_anim["player_hands_2"]["dragged_on_pbr"] 	= %int_upacreek_b03_dragged;
	level.scr_anim["player_hands_2"]["rope_cut"] 			= %int_upacreek_b03_cut_rope_pbr;
	// -- addNotetrack_customFunction( "player_hands_2", "swap", maps\creek_1_drag::swap_boat, "rope_cut" ); // wwilliams: housekeeping, drag is no longer in creek_1

	// BEAT 2
	level.scr_anim["player_body"]["sampan_melee"] 		= %int_sampan_melee;
	addNotetrack_customFunction( "player_body", "attach_knife", ::melee_player_attach_knife, "sampan_melee" );  
	addNotetrack_customFunction( "player_body", "detach_knife", ::melee_player_detach_knife, "sampan_melee" );  

	level.scr_anim["player_body"]["rice_surprise"] 		= %ch_creek_b02_eating_grabs_gun_player;
	
	level.scr_anim["player_body"]["swim_gap"] 				= %int_creek_b02_swimthrugap;
	addNotetrack_customFunction( "player_body", "start_barnes", ::start_barnes_sampan_swim, "swim_gap" ); 
	
	level.scr_anim[ "player_body" ][ "melee_kill" ] = %int_vc_eating_melee; // -- WWILLIAMS: PLAYER ATTACK ON THE RICE VC
	
	// BEAT 4
	level.scr_anim["player_body"]["tunnel_entrance"] 	= %ch_creek_b04_rat_tunnel_intro_C_player;
	level.scr_anim["player_body"]["stabbed"] 					= %ch_creek_b04_traphole_stab_player;
	level.scr_anim["player_body"]["push_shelf"] 			= %ch_creek_b02_shelfpush_player;
	
	level.scr_anim["player_hands_2"]["tunnel_crawl"] 			= %int_creek_tunnel_crawl;
	level.scr_anim["player_hands_2"]["bomb_plant"] 			= %int_creek_water_bombplant;
	addNotetrack_customFunction( "player_hands_2", "detach", ::plant_bomb_detach, "bomb_plant" ); 
	level.scr_anim["player_hands_2"]["bomb_plant_2"] 			= %int_creek_2nd_c4_plant;
	addNotetrack_customFunction( "player_hands_2", "gate_open", ::open_water_gate, "bomb_plant_2" ); 
	
	// hammock kill
	level.scr_anim["player_body"]["b2_vc_sleeping_1_kill"] 			= %int_creek_hammock_melee_guy01;
	level.scr_anim["player_body"]["b2_vc_sleeping_2_kill"] 			= %int_creek_hammock_melee_guy02;
	
	// tunnel escape
	level.scr_anim["player_body"]["tunnel_crawl_and_get_up"] 			= %int_creek_tunnel_crawl_and_get_up;
	level.scr_anim["player_body"]["tunnel_melee_a"] 			= %int_creek_tunnel_melee_a;
	level.scr_anim["player_body"]["tunnel_melee_b"] 			= %int_creek_tunnel_melee_b;
	level.scr_anim["player_body"]["tunnel_melee_c"] 			= %int_creek_tunnel_melee_c_and_end ;
	addNotetrack_customFunction( "player_body", "rock_swap", ::tunnel_crawl_rock_swap, "tunnel_crawl_and_get_up" );  
	addNotetrack_customFunction( "player_body", "rock_melee_a", ::player_hit_rock_1, "tunnel_melee_a" );  
	addNotetrack_customFunction( "player_body", "rock_melee_b", ::player_hit_rock_2, "tunnel_melee_b" );  
	addNotetrack_customFunction( "player_body", "rock_melee_c", ::player_hit_rock_3, "tunnel_melee_c" );  
	addNotetrack_customFunction( "player_body", "sndnt#evt_tuco_melee3_grab", ::player_grabs_woods, "tunnel_melee_c" );  
	level.scr_anim["player_body"]["cliffhang_idle"][0] 			= %int_creek_tunnel_cliffhang_idle;
}

#using_animtree ( "creek_1" );
flashlight_anim_setup()
{
	level.scr_anim["flashlight"]["toss"]	 	= %ch_creek_b04_rat_tunnel_intro_C_light;
}

hatch_anim_setup()
{
	level.scr_anim["tunnel_hatch"]["open"]	 	= %ch_creek_b04_rat_tunnel_intro_A_hatch;
	
	level.scr_anim["window_l"]["open"]	 	= %o_creek_b02_windowlook_shade_l;
	level.scr_anim["window_r"]["open"]	 	= %o_creek_b02_windowlook_shade_r;
	level.scr_anim["window_l"]["idle"][0]	= %o_creek_b02_windowlook_shade_l_idle;
	level.scr_anim["window_r"]["idle"][0]	= %o_creek_b02_windowlook_shade_r_idle;
}

#using_animtree ( "creek_1" );
rice_bowl_anim_setup()
{
	// level.scr_anim["bowl"]["drop"]	 	= %ch_creek_b02_bowl;
	// level.scr_anim["chopstick1"]["drop"]	 	= %ch_creek_b02_chopstick_1;
	// level.scr_anim["chopstick2"]["drop"]	 	= %ch_creek_b02_chopstick_2;
	
	level.scr_animtree["bowl"] 	        		 			= #animtree;
	level.scr_animtree["chopstick1"] 	        		 = #animtree;
	level.scr_animtree["chopstick2"] 	        		 = #animtree;
	level.scr_animtree["hudson_backpack"] 	        		 = #animtree;
	
	level.scr_anim[ "hudson_backpack" ][ "hey_charlie" ] = %o_creek_b02_hey_charlie_backpack;
	
	// -- WWILLIAMS: NEW PROP ANIMS FOR THE CHOPSTICKS AND BOWL
	// -- CURTAIN OPEN
	level.scr_anim[ "bowl" ][ "curtain_open" ]	= %p_vc_eating_melee_curtain_open_bowl;
	level.scr_anim[ "chopstick1" ][ "curtain_open" ]	= %p_vc_eating_melee_curtain_open_chopstick_1;
	level.scr_anim[ "chopstick2" ][ "curtain_open" ]	= %p_vc_eating_melee_curtain_open_chopstick_2;
	
	// -- ATTACK OPPORTUNITY
	level.scr_anim[ "bowl" ][ "attack_opportunity" ]	= %p_vc_eating_melee_attack_opportunity_bowl;
	level.scr_anim[ "chopstick1" ][ "attack_opportunity" ]	= %p_vc_eating_melee_attack_opportunity_chopstick_1;
	level.scr_anim[ "chopstick2" ][ "attack_opportunity" ]	= %p_vc_eating_melee_attack_opportunity_chopstick_2;
	
	// -- MELEE KILL
	level.scr_anim[ "bowl" ][ "melee_kill" ]	= %p_vc_eating_melee_bowl;
	level.scr_anim[ "chopstick1" ][ "melee_kill" ]	= %p_vc_eating_melee_chopstick_1;
	level.scr_anim[ "chopstick2" ][ "melee_kill" ]	= %p_vc_eating_melee_chopstick_2;
	
	// -- MELEE FAIL
	level.scr_anim[ "bowl" ][ "melee_fail" ]	= %p_vc_eating_melee_fail_bowl;
	level.scr_anim[ "chopstick1" ][ "melee_fail" ]	= %p_vc_eating_melee_fail_chopstick_1;
	level.scr_anim[ "chopstick2" ][ "melee_fail" ]	= %p_vc_eating_melee_fail_chopstick_2;
	
	
	level.scr_anim["cig"]["talking_smoke"][0]	 	= %p_creek_b02_dock_gaurds_talking_guys_stogie;
	
	level.scr_anim["hammock"]["idle"][0]	 	= %p_creek_b02_hammock_sleep_hammock;
	
	level.scr_anim["hammock"]["hammock_kill"]	 	= %p_creek_hammock_melee_guy01_hammock;
	level.scr_anim["hammock"]["hammock_kill"]	 	= %p_creek_hammock_melee_guy02_hammock;
	
	level.scr_anim["water_gate"]["open"]	 	= %o_creek_2nd_c4_plant_gate_open;
	
	level.scr_anim["regroup_gate"]["open"]	 			= %o_creek_b02_regroup_before_village_door;
	level.scr_anim["regroup_gate"]["open_idle"][0]	 	= %o_creek_b02_regroup_before_village_door_openloop;
}

shelf_anim_setup()
{
	level.scr_anim["shelf"]["push_down"]	 	= %p_creek_b02_shelfpushover;
}

// -- WWILLIAMS: Needed for the animation of the Sampan landing.
sampan_anim_setup()
{
	level.scr_anim[ "b2_vc_sampan" ][ "sampan_kill" ] 								= %v_sampan_melee_sampan;
	level.scr_anim[ "b2_vc_sampan" ][ "idle_crouch" ][0] 							= %v_sampan_melee_crouch_idle_sampan;
	level.scr_anim[ "b2_vc_sampan" ][ "idle_stand" ][0] 							= %v_sampan_melee_stand_idle_sampan;
	level.scr_anim[ "landing_sampan" ][ "sampan_landing" ] 						= %v_creek_b03_sampan_offload_dock;
}


play_tunnel_hatch_open( anim_node )
{
	hatch = getent( "rat_tunnel_door", "targetname" );
	if( isdefined( hatch ) )
	{
		hatch delete();
	}
}

play_tunnel_shelf_fall( anim_node )
{
	wait( 1 );
	shelf = getent( "tunnel_blocker", "targetname" );
	shelf.animname = "shelf";
	shelf UseAnimTree( #animtree );

	anim_node anim_first_frame( shelf, "push_down" );

	level waittill( "shelf_pushed" ); 
	
	anim_node anim_Single_aligned( shelf, "push_down" );
	
	invisible_blocker = getent( "tunnel_blocker_invisible_before", "targetname" );
	invisible_blocker delete();
	
	// HACK: Turn off visionset 
	VisionSetNaked( "default", 0 );
	player = get_players()[0];
	player clientNotify( "reset_visionset_to_default" );
	level maps\_swimming::set_default_vision_set( "default" );
	player SetClientDvar(	"r_fog_disable", "1" );
}

#using_animtree ("vehicles");
vehicle_anim_init( vehicle, vehicle_animname )
{
	vehicle.animname = vehicle_animname;
	vehicle UseAnimTree( #animtree );
}

#using_animtree ("vehicles");
play_vehicle_anim_single_solo( vehicle, vehicle_animname, anim_node, animation )
{
	vehicle.animname = vehicle_animname;
	vehicle UseAnimTree( #animtree );
	//anim_node anim_single( vehicle, animation );

	anim_node thread anim_Single_aligned( vehicle, animation );
	//vehicle AnimScripted( "start_animation", anim_node.origin, anim_node.angles, level.scr_anim[vehicle_animname][animation] );
}

play_vehicle_anim_single_solo2( vehicle, vehicle_animname, anim_node, animation )
{
	vehicle.animname = vehicle_animname;
	vehicle UseAnimTree( #animtree );
	//anim_node anim_single( vehicle, animation );

	anim_node anim_Single_aligned( vehicle, animation );
	//vehicle AnimScripted( "start_animation", anim_node.origin, anim_node.angles, level.scr_anim[vehicle_animname][animation] );
}

#using_animtree ("vehicles");
play_vehicle_anim_loop_solo( vehicle, anim_node, animation )
{
	anim_node anim_loop_aligned( vehicle, animation );
}

#using_animtree ("creek_1");

play_creek_object_anim_firstframe( object, anim_node, animation )
{
	object UseAnimTree( #animtree );
	anim_node anim_first_frame( object, animation );
}

play_creek_object_anim_loop( object, anim_node, animation )
{
	object UseAnimTree( #animtree );
	anim_node anim_loop_aligned( object, animation );
}

play_creek_object_anim_single( object, anim_node, animation )
{
	object UseAnimTree( #animtree );
	anim_node anim_single_aligned( object, animation );
}

play_creek_object_anim_single_frameskip( object, anim_node, animation, start_frame, total_frame )
{
	object UseAnimTree( #animtree );
	anim_node thread anim_single_aligned( object, animation );
	wait( 0.05 );
	fraction_skip = start_frame / total_frame;
	
	anim_set_time( object, animation, fraction_skip );
}

beat2_play_animation_in_sync( anim_node, object, animation ) // -- WWILLIAMS: THREAD THIS FUNCTION TO HAVE MULTIPLE ITEMS PLAY ANIMATIONS "IN SYNC"
{
	object UseAnimTree( #animtree );
	anim_node thread anim_single_aligned( object, animation );
}

#using_animtree ("player");
play_player_anim( anim_node, animation, delay_time, tag )
{
	player = get_players()[0];

	player DisableWeapons();
	if( isdefined( delay_time ) &&  delay_time)
	{
		wait( delay_time );
	}

	hands = spawn_anim_model( "player_hands_2" );
	hands.animname = "player_hands_2";

	hands.origin = anim_node.origin;
	hands.angles = anim_node.angles;

	player PlayerLinkTo( hands, "tag_player", 1.75, 0, 0, 0, 0 );


	anim_node anim_single_aligned( hands, animation ); 

	player Unlink();

	hands Delete();

	player EnableWeapons();
}

#using_animtree ("player");
play_player_anim_2( vehicle, animation, delay_time, tag )
{
	player = get_players()[0];

	player DisableWeapons();

	hands = spawn_anim_model( "player_hands_2" );
	hands.animname = "player_hands_2";

	hands.origin = vehicle GetTagOrigin( tag );
	hands.angles = vehicle GetTagAngles( tag );
	hands linkto( vehicle, tag );

	// link player to hand
	player PlayerLinkToAbsolute( hands, "tag_player" );

	// animate hand
	hands anim_single( hands, animation ); 


	player Unlink();
	hands Unlink();
	hands Delete();

	player EnableWeapons();
}

#using_animtree ("player");
play_player_anim_3( vehicle, animation, delay_time, tag )
{
	player = get_players()[0];

	player DisableWeapons();

	hands = spawn_anim_model( "player_body" );
	hands.animname = "player_body";

	hands.origin = vehicle GetTagOrigin( tag );
	hands.angles = vehicle GetTagAngles( tag );
	hands linkto( vehicle, tag );

	// link player to hand
	player PlayerLinkToAbsolute( hands, "tag_player" );

	//vehicle hide();

	//wait( 5 );
	// animate hand
	hands anim_single( hands, animation ); 


	player Unlink();
	hands Unlink();
	hands Delete();

	player EnableWeapons();
}

play_player_fullbody_anim_simple( anim_node, animation, lerp_camera_time, use_delta )
{
	player = get_players()[0];
	//player DisableWeapons();

	hands = spawn_anim_model( "player_body" );
	hands.animname = "player_body";
	
	player.anim_hands = hands;

	if( isdefined( lerp_camera_time ) )
	{
		hands hide();
		anim_node thread anim_single_aligned( hands, animation ); 
		wait( 0.05 );
		if( isdefined( use_delta ) && use_delta == true )
		{
			player PlayerLinkToDelta( hands, "tag_player", 1, 30, 30, 20, 10, true );
		}
		else
		{
			player PlayerLinkToAbsolute( hands, "tag_player" );
		}
		player StartCameraTween( lerp_camera_time );
		wait( 0.05 );
		hands show();
	}
	else
	{
		//iprintlnbold( "TESTING" );
		anim_node thread anim_single_aligned( hands, animation ); 
		hands hide();
		wait( 0.05 );
		if( isdefined( use_delta ) && use_delta == true )
		{
			player PlayerLinkToDelta( hands, "tag_player", 1, 30, 30, 20, 10, true );
		}
		else
		{
			player PlayerLinkToAbsolute( hands, "tag_player" );
		}
		hands show();
	}

	anim_node waittill( animation );

	player Unlink();
	hands Delete();
	
	player notify( "anim_complete" );
}

play_demo_intro_anim( anim_node, animation, lerp_camera_time, use_delta )
{
	player = get_players()[0];
	
	player SetPlayerAngles( ( 0, -20, 0 ) );
	
	//player DisableWeapons();

	hands = spawn_anim_model( "player_body" );
	hands.animname = "player_body";
	hands hide();
	
	player.anim_hands = hands;

	hands hide();
	
	//SetDvar( "cg_cameraUseTagCamera", "0" );
	
	anim_node thread anim_single_aligned( hands, animation ); 
	
	//level thread print_angles( player );
	wait( 0.05 );
	anim_set_time( hands, animation, ( 420 - 390 ) / ( 880 - 390 ) ); // 450 is Barne's notetrack. 390 is first frame

	player PlayerLinkToDelta( hands, "tag_player", 1, 30, 30, 20, 10, true );
	player StartCameraTween( lerp_camera_time );
	
	anim_node waittill( animation );
	//iprintlnbold( "END" );
	player Unlink();
	hands Delete();
	
	player notify( "anim_complete" );
	//SetDvar( "cg_cameraUseTagCamera", "1" );
}

print_angles( player )
{
	while( 1 )
	{
		// iprintlnbold( player.angles );
		wait( 2 );
	}
}


play_player_fullbody_anim_special( anim_node, animation, lerp_camera_time, use_delta )
{
	player = get_players()[0];
	//player DisableWeapons();

	hands = spawn_anim_model( "player_body" );
	hands.animname = "player_body";
	
	player.anim_hands = hands;


	hands hide();
	//anim_node thread anim_single_aligned( hands, animation ); 
	hands AnimScripted( animation, anim_node.origin, anim_node.angles, %ch_creek_b02_eating_grabs_gun_player, "normal", undefined, 2.6 );
	wait( 0.05 );
	player PlayerLinkToAbsolute( hands, "tag_player" );
	player StartCameraTween( lerp_camera_time );
	hands show();

	hands waittill( animation );
	//iprintlnbold( "end" );
	
	player Unlink();
	hands Delete();
	
	player notify( "anim_complete" );
}

play_player_hands_anim_simple( anim_node, animation, lerp_camera_time, use_delta )
{
	player = get_players()[0];
	//player DisableWeapons();

	hands = spawn_anim_model( "player_hands_2" );
	hands.animname = "player_hands_2";
	
	player.anim_hands = hands;

	if( isdefined( lerp_camera_time ) )
	{
		hands hide();
		anim_node thread anim_single_aligned( hands, animation ); 
		wait( 0.05 );
		if( isdefined( use_delta ) && use_delta == true )
		{
			player PlayerLinkToDelta( hands, "tag_player", 1, 30, 30, 20, 10, true );
		}
		else
		{
			player PlayerLinkToAbsolute( hands, "tag_player" );
		}
		hands show();
		player StartCameraTween( lerp_camera_time );
	}
	else
	{
		anim_node thread anim_single_aligned( hands, animation ); 
		if( isdefined( use_delta ) && use_delta == true )
		{
			player PlayerLinkToDelta( hands, "tag_player", 1, 30, 30, 20, 10, true );
		}
		else
		{
			player PlayerLinkToAbsolute( hands, "tag_player" );
		}
	}

	anim_node waittill( animation );

	player Unlink();
	hands Delete();
	
	player notify( "anim_complete" );
}

play_player_fullbody_anim_lerp( anim_node, anim_name, time )
{
	/*
	start_org = GetStartOrigin( anim_node.origin, anim_node.angles, level.scr_anim["player_body"][anim_name] );
	start_ang = GetStartAngles( anim_node.origin, anim_node.angles, level.scr_anim["player_body"][anim_name] );
	*/
	player = get_players()[0];
	hands = spawn_anim_model( "player_body" );
	hands.animname = "player_body";
	player PlayerLinkToAbsolute( hands, "tag_player" );
	
	/*
	hands moveto( start_org, time, 0.05, 0.05 );
	hands rotateto( start_ang, time, 0.05, 0.05 );
	hands waittill( "movedone" );
	*/
	level notify( "player_ready_for_anim" );
	
	anim_node anim_single_aligned( hands, level.scr_anim["player_body"][anim_name] ); 

	player Unlink();
	hands Delete();
}


#using_animtree ("player");
play_player_anim_using_tags( anim_node, animation, tag, delay_time )
{
	player = get_players()[0];

	player DisableWeapons();
	if( isdefined( delay_time ) )
	{
		wait( delay_time );
	}

	hands = spawn_anim_model( "player_hands_2" );
	hands.animname = "player_hands_2";

	hands.origin = anim_node GetTagOrigin( tag );
	hands.angles = anim_node GetTagAngles( tag );
	hands linkto( anim_node, tag );

	player PlayerLinkTo( hands, "tag_player", 1.75, 0, 0, 0, 0 );

	anim_node anim_single( hands, animation ); 

	player Unlink();

	hands Delete();

	player EnableWeapons();
}


// Event specific anim functions:



#using_animtree ("generic_human");


change_shadow_sample_size()
{
	sample_size = 0.4;
	SetSavedDvar( "sm_sunSampleSizeNear", sample_size );

	trigger = getent( "b2_stealth_trigger_1c", "targetname" );
	trigger waittill( "trigger" );

	// lerp it back to 0.25
	while( sample_size > 0.25 )
	{
		sample_size -= 0.01;
		SetSavedDvar( "sm_sunSampleSizeNear", sample_size );
		wait( 0.1 );
	}
	SetSavedDvar( "sm_sunSampleSizeNear", 0.25 );
}

barnes_kill_hut_vcs( anim_node )
{
	anim_node thread anim_loop_aligned( level.barnes, "window_stealth_wait_loop" );
	flag_set( "barnes_ready_for_kill" );	

	flag_wait( "barnes_start_aiming" );
	level.barnes StopAnimScripted();
	level.barnes notify( "stop_loop" );
	anim_node anim_single_aligned( level.barnes, "window_stealth_aim" );
	anim_node thread anim_loop_aligned( level.barnes, "window_stealth_aim_loop" );

	flag_set( "barnes_finish_aiming" );	
	flag_wait( "barnes_kill_finished" );
	level.barnes StopAnimScripted();
	level.barnes notify( "stop_loop" );
	anim_node anim_single_aligned( level.barnes, "window_stealth_hop_over" );
	level.barnes force_go_to_node_by_name( "b2_barnes_stealth_node_4" );
}


play_hut_vc_dialog( vc1, vc2 )
{
	wait( 25 );
	vc1 say_dialogue( "rain_getting_worse" );
	wait( 4 );
	vc2 say_dialogue( "keep_disciplined" );
}

b2_village_animate_patrols( stop_msg )
{
	anim_node_1 = getstruct( "b2_village_anim_node_1", "targetname" );
	anim_node_2 = getstruct( "b2_village_anim_node_2", "targetname" );
	anim_node_3 = getstruct( "b2_village_anim_node_3", "targetname" );
	// WWILLIAMS: New alignment spot for the first animations
	anim_struct_1 = getstruct( "anim_struct_village_under_catwalk_1", "targetname" );

	guy1 = simple_spawn_single( "village_patrol_guy_1" );
	guy1 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_distraction_1" );

	guy2 = simple_spawn_single( "village_patrol_guy_2" );
	guy2 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_distraction_2" );

	guy3 = simple_spawn_single( "village_patrol_guy_3" );
	guy3 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_distraction_3" );

	guy4 = simple_spawn_single( "village_patrol_guy_4" );
	guy4 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_catwalk_lower" );
	// guy4 thread die_from_hudson_grenade();

	guy5 = simple_spawn_single( "village_patrol_guy_5" );
	guy5 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_catwalk_high" );

	guy6 = simple_spawn_single( "village_patrol_guy_6" );
	guy6 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_cook", "attack" );

	guy7 = simple_spawn_single( "village_patrol_guy_7" );
	guy7 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_crate" );

	guy8 = simple_spawn_single( "village_patrol_guy_8" );
	guy8 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_catwalk_sit_1" );

	guy9 = simple_spawn_single( "village_patrol_guy_9" );
	guy9 thread village_patrol_anims( stop_msg, anim_struct_1, "vc_catwalk_sit_2" );

	guy10 = simple_spawn_single( "village_patrol_guy_10" );
	guy10 thread village_patrol_anims( stop_msg, anim_node_3, "patrol_10" );
}

village_patrol_anims( stop_msg, anim_node, anim_name, attack )
{
	// WWILLIAMS: If no script_animname was set on the spawner make sure to put it in
	if( !IsDefined( self.animname ) )
	{
		self.animname = anim_name;
	}
	
	self thread b2_village_animate_patrol_single( anim_node, stop_msg, attack );
	self thread break_stealth_by_damage();
	self thread break_stealth_by_trigger();
}

b2_village_animate_patrol_single( anim_node, stop_msg, attack )
{
	self endon( "death" );

	self SetThreatBiasGroup( "enemies" );
	self hold_fire();

	self.grenadeammo = 0; 
	self.a.disableLongDeath = true;


	anim_node thread anim_loop_aligned( self, "patrol_idle" );
	level waittill( stop_msg );

	self stopanimscripted();
	
	if( isdefined( attack ) )
	{
		anim_node anim_single_aligned( self, "begin_attack" );
	}

	self resume_fire();
}


break_stealth_by_damage()
{
	while( 1 )
	{
		self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
		if( isPlayer( inflictor ) )
		{
			level notify( "attack_player" );
			return;
		} 
	}
}

break_stealth_by_trigger()
{
	wait_for_trigger_by_name( "stealth_broken" );
	level notify( "attack_player" );
}

// Spawn a drone AI who can be animated
#using_animtree ("generic_human");
spawn_fake_guy_to_anim( startpoint, anim_name, side, col_brush_name )
{
	guy = undefined;
	if( isdefined( startpoint ) )
	{
		guy = spawn( "script_model", startpoint.origin );
		guy.angles = startpoint.angles;
	}
	else
	{
		guy = spawn( "script_model", ( -25686, 34751, -46 ) );
		guy.angles = ( 0, 0, 0 );
	}

	if( side == "allies" )
	{
		/*
		guy.team = "allies";

		if( level.drone_marine_model_index == 0 )
		{
			guy character\c_usa_jungmar_assault::main();
		}
		else if( level.drone_marine_model_index == 1 )
		{
			guy character\c_usa_jungmar_cqb::main();
		}
		else if( level.drone_marine_model_index == 2 )
		{		
			guy character\c_usa_jungmar_lmg::main();
		}
		else if( level.drone_marine_model_index == 3 )
		{
			guy character\c_usa_jungmar_smg::main();
		}
		else if( level.drone_marine_model_index == 4 )
		{
			guy character\c_usa_jungmar_snip::main();
		}
		level.drone_marine_model_index++;
		level.drone_marine_model_index = level.drone_marine_model_index % 5;

		//weapon_name = maps\_drones::drone_allies_assignWeapon_american();
		//weaponModel_name = GetWeaponModel( weapon_name ); 
		guy.weapon_model = spawn( "script_model", guy GetTagOrigin( "tag_weapon_right" ) );
		guy.weapon_model.angles = guy GetTagAngles( "tag_weapon_right" );
		guy.weapon_model setmodel( "t5_weapon_M16A1_world" ); 
		guy.weapon_model useweaponhidetags( "m16_sp" );

		guy.weapon_model linkto( guy, "tag_weapon_right" );
		//guy Attach( "t5_weapon_M16A1_world", "tag_weapon_right" ); 
		*/
	}
	else
	{
		guy.team = "axis";

		if( level.drone_vc_model_index == 0 )
		{
			guy character\c_vtn_vc1::main();
		}
		else if( level.drone_vc_model_index == 1 )
		{
			guy character\c_vtn_vc2::main();
		}
		else if( level.drone_vc_model_index == 2 )
		{		
			guy character\c_vtn_vc3::main();
		}
		level.drone_vc_model_index++;
		level.drone_vc_model_index = level.drone_vc_model_index % 3;
	}
	guy UseAnimTree( #animtree );
	guy.animname = anim_name;
	guy makeFakeAI();			// allow it to be animated
	guy setcandamage( false );	
	guy.health = 5;				// can be killed easily

	if( isdefined( col_brush_name ) )
	{
		col_brush = getent( col_brush_name, "targetname" );
		col_brush linkto( guy );
	}

	return guy;
}

#using_animtree ("generic_human");
spawn_fake_guy_to_anim_player( anim_name )
{
	guy = spawn( "script_model", ( -25686, 34751, -800 ) );
	guy.angles = ( 0, 0, 0 );

	guy.team = "allies";

	//guy character\c_usa_jungmar_cqb::main();
	guy SetModel( "c_usa_jungmar_player_fullbody" );
	guy UseAnimTree( #animtree );
	guy.animname = anim_name;
	guy makeFakeAI();			// allow it to be animated

	return guy;
}


b2_epilogue_anim_set_1()
{
	anim_node = getstruct( "b2_village_anim_node_3b", "targetname" );
	struct_spawn = getstruct( "anim_fake_ai_spawn", "targetname" );

	guys = [];
	guys[0] = spawn_fake_guy_to_anim( struct_spawn, "captured_guard_1", "allies" );
	guys[1] = spawn_fake_guy_to_anim( struct_spawn, "captured_guard_2", "allies" );
	guys[2] = spawn_fake_guy_to_anim( struct_spawn, "captured_vc_1", "vc" );
	guys[3] = spawn_fake_guy_to_anim( struct_spawn, "captured_vc_2", "vc" );
	guys[4] = spawn_fake_guy_to_anim( struct_spawn, "captured_vc_3", "vc" );
	guys[5] = spawn_fake_guy_to_anim( struct_spawn, "captured_vc_4", "vc" );

	anim_node thread anim_loop_aligned( guys, "b2_epilogue" );

	level waittill( "end_b2_anim_loops" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "stop_loop" );
		guys[i] delete();
	}
}

b2_epilogue_anim_set_2()
{
	anim_node = getstruct( "b2_village_anim_node_4b", "targetname" );
	struct_spawn = getstruct( "anim_fake_ai_spawn", "targetname" );

	guys = [];
	guys[0] = spawn_fake_guy_to_anim( struct_spawn, "interrogation_guy_1", "allies", "fake_ai_clip_1" );
	guys[1] = spawn_fake_guy_to_anim( struct_spawn, "interrogation_guy_2", "allies", "fake_ai_clip_2" );
	guys[2] = spawn_fake_guy_to_anim( struct_spawn, "interrogation_vc", "vc", "fake_ai_clip_3" );

	anim_node thread anim_first_frame( guys, "b2_epilogue" );
	wait( level.epilogue_delay_interrogation );
	anim_node anim_single_aligned( guys, "b2_epilogue" );
	anim_node thread anim_loop_aligned( guys, "b2_epilogue_loop" );

	level waittill( "end_b2_anim_loops" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "stop_loop" );
		guys[i] delete();
	}
}

b2_epilogue_anim_set_3()
{
	anim_node = getstruct( "anim_node_top_hut", "targetname" );
	struct_spawn = getstruct( "anim_fake_ai_spawn", "targetname" );

	guys = [];
	guys[0] = spawn_fake_guy_to_anim( struct_spawn, "patrol_guy_1", "allies", "fake_ai_clip_4" );
	guys[1] = spawn_fake_guy_to_anim( struct_spawn, "patrol_guy_2", "allies", "fake_ai_clip_5" );
	guys[2] = spawn_fake_guy_to_anim( struct_spawn, "patrol_guy_3", "allies", "fake_ai_clip_6" );

	anim_node thread anim_first_frame( guys, "b2_epilogue" );
	wait( level.epilogue_delay_patrol );
	anim_node anim_single_aligned( guys, "b2_epilogue" );
	anim_node thread anim_loop_aligned( guys, "b2_epilogue_loop" );

	level waittill( "end_b2_anim_loops" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "stop_loop" );
		guys[i] delete();
	}
}

b2_epilogue_anim_set_4()
{
	anim_node = getstruct( "b2_village_anim_node_3b", "targetname" );
	struct_spawn = getstruct( "anim_fake_ai_spawn", "targetname" );

	guys = [];
	guys[0] = spawn_fake_guy_to_anim( struct_spawn, "prisoner_guy_1", "allies", "fake_ai_clip_7" );
	guys[1] = spawn_fake_guy_to_anim( struct_spawn, "prisoner_guy_2", "allies", "fake_ai_clip_8" );
	guys[2] = spawn_fake_guy_to_anim( struct_spawn, "prisoner_guy_vc", "vc", "fake_ai_clip_9" );

	anim_node thread anim_first_frame( guys, "b2_epilogue" );
	wait( level.epilogue_delay_prisoner );
	anim_node anim_single_aligned( guys, "b2_epilogue" );
	anim_node thread anim_loop_aligned( guys, "b2_epilogue_loop" );

	level waittill( "end_b2_anim_loops" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "stop_loop" );
		guys[i] delete();
	}
}

b2_epilogue_anim_set_5()
{
	anim_node = getstruct( "b2_village_anim_node_3b", "targetname" );
	struct_spawn = getstruct( "anim_fake_ai_spawn", "targetname" );

	guys = [];
	guys[0] = spawn_fake_guy_to_anim( struct_spawn, "search_guy_1", "allies", "fake_ai_clip_10" );
	guys[1] = spawn_fake_guy_to_anim( struct_spawn, "search_guy_2", "allies", "fake_ai_clip_11" );
	guys[2] = spawn_fake_guy_to_anim( struct_spawn, "search_guy_3", "allies", "fake_ai_clip_12" );

	anim_node thread anim_first_frame( guys, "b2_epilogue" );
	wait( level.epilogue_delay_search );
	anim_node anim_single_aligned( guys, "b2_epilogue" );
	anim_node thread anim_loop_aligned( guys, "b2_epilogue_loop" );

	level waittill( "end_b2_anim_loops" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] notify( "stop_loop" );
		guys[i] delete();
	}
}

character_wake_start( guy )
{
	//guy.keep_playing_wake_fx = true;
}


character_wake_stop( guy )
{
	//guy.keep_playing_wake_fx = false;
}

print_origin_pos()
{
	level endon( "intro_anim_done" );
	while( 1 )
	{
		// iprintlnbold( self.origin );
		wait( 0.05 );
	}
}

do_fx_and_model_swap( vc2 )
{

	// create new weapon
	//weapon = spawn( "script_model", level.hudson GetTagOrigin( "tag_weapon_left" ) );
	//weapon.angles = level.hudson GetTagAngles( "tag_weapon_left" );
	//weapon setmodel( "t5_weapon_1911_world" );
	//weapon Linkto( level.hudson, "tag_weapon_left" );

	wait( 1.7 );
	splash_struct = getstruct( "vc_opening_splash", "targetname" );
	PlayFx( level._effect["falling_water_splash"], splash_struct.origin );

/*
	wait( 0.4 );

	// fire
	PlayFxOnTag( level._effect["pistol_flash"], weapon, "tag_flash" );  // muzzleflash	
	PlayFxOnTag( level._effect["flesh_hit"], vc2, "J_Head" );  

	wait( 2 );
	weapon delete();
*/
}

play_im_watching_anim()
{
	anim_node = getstruct( "b3_watching_anim_node", "targetname" );
	//anim_node = getstruct( "boat_drag_node_2", "targetname" );
	guys = [];
	guys[0] = level.barnes;
	guys[1] = level.hudson;
	guys[2] = level.reznov;
	anim_node anim_reach_aligned( guys, "im_watching" );
	level waittill( "play_im_watching_anim" );
	anim_node anim_single_aligned( guys, "im_watching" );
	level notify( "im_watching_anim_done" );
}

hudson_take_out_pistol( guy )
{
	level notify( "hudson_take_out_pistol" );
	level.hudson gun_switchto( "m1911_sp", "right" );
}

hudson_fires_pistol( guy )
{
	level notify( "hudson_fires_pistol" );
	PlayFxOnTag( level._effect["pistol_flash"], level.hudson, "tag_flash" );
	PlayFxOnTag( level._effect["flesh_hit"], level.hudson_vc, "J_Head" );  
}

hudson_take_out_rifle( guy )
{
	level notify( "hudson_take_out_rifle" );
	level.hudson gun_switchto( "commando_sp", "right" );
}

die_from_hudson_grenade()
{
	self.health = 1;
}

pbr_hit_fx_1( boat )
{
	wait( .3 );
	playfxontag( level._effect["pbr_impact_left"], level.pbr, "tag_passenger10" );
}

pbr_hit_fx_2( boat )
{
	level notify( "pbr_hits_boat_2" );
	wait( .3 );
	playfxontag( level._effect["pbr_impact_right"], level.pbr, "tag_passenger11" );
}

pbr_hit_fx_3( boat )
{
	wait( .3 );
	playfxontag( level._effect["pbr_impact_left"], level.pbr, "tag_passenger10" );
}

kick_open_hut_door( guy )
{
	hut_door_closed = getent( "b2_hut_door_closed", "targetname" );
	rotateto_struct = getstruct( "b2_hut_door_open_struct2", "targetname" );

	hut_door_closed moveto( rotateto_struct.origin, 0.5, 0.1, 0.3 );
	hut_door_closed rotateto( rotateto_struct.angles, 0.5, 0.1, 0.3 );
}

blood_guy_falling( boat )
{
	if( is_mature() )
	{
		playfxontag( level._effect["guy_falling_blood"], level.ai_fall_from_chinook, "J_Neck" );
	}
}

play_jumping_into_water_fx()
{
	wait( 2.6 );
	playfx( level._effect["water_entry"], ( -27714, 37279, -52 ) );

	wait( 9.7 );
	playfx( level._effect["water_entry"], ( -27043, 37090, -52 ) );
	wait( 2.5 );
	playfx( level._effect["water_entry"], ( -27043, 37090, -52 ) );
	wait( 2.5 );
	playfx( level._effect["water_entry"], ( -27038, 37090, -52 ) );
}

	
// BEAT 2 New Anims -----------------------------------------------------------

#using_animtree ("generic_human");

barnes_intro_swim()
{
	//wait( 2 );
	anim_node_gap = getstruct( "anim_b2_gap", "targetname" );
	
	//level.barnes thread maps\creek_1_fx::water_splash_fx_handler();

// Part 1: Barne swim to gap and waits for player
// We separate this out since it's possible for player to run ahead and interrupt this

	level.barnes thread intro_swim_anim_gap( anim_node_gap ); // -- WWILLIAMS: PRESS DEMO 4-19 HACK REMOVING FUNCTION USED FOR THE GAP.
	
	trigger_wait( "b2_reveal_player_start_trig" );
	//autosave_by_name( "creek_1_bis" );
	player = get_players()[0];
	player DisableWeapons(); 
	
	//maps\_swimming::disable();
	
	/* player hide_swimming_arms();
	//player clientNotify( "hide_swimming_arms" );
	level thread play_player_fullbody_anim_simple( anim_node_gap, "swim_gap", 0.7, true );

	level waittill( "player_move_gap_done" );
	level notify( "end_gap_anim" );
	level thread animate_river_snake(); */
	
// Part 2: Player and barnes cross gap. Barnes goes to sampan and waits
// Again, it's possible for player to cut Barnes' anims short
	
	//play_player_fullbody_anim_simple( anim_node_gap, "player_over_gap" );
	//level waittill( "stealth_sampan_action_start" );
	
	// player waittill( "anim_complete" );
	// player show_swimming_arms();
	// player EnableWeapons();
	
	level notify( "reveal_anim_done" );
}

animate_river_snake()
{
	level notify( "snakeswim_start" );
}

player_takedown_sampan_vc()
{
	// everything is aligned to the sampan
	anim_node = getent( "b2_sampan_kill", "targetname" );
	anim_node_2 = Spawn( "script_model", anim_node GetTagOrigin( "tag_origin" ) );
	anim_node_2.angles = anim_node GetTagAngles( "tag_origin" );
	anim_node_2 SetModel( "tag_origin" );
	anim_node_2.origin = anim_node_2.origin + ( 0, 0, -14 );
	anim_node.animname = "b2_vc_sampan";
	
	// vc loops
	level.vc_sampan_2 thread loop_search_anims( anim_node );
	
	level waittill( "stealth_sampan_action_start" );

	players = get_players();
	players[0] DisableWeapons();
	players[0] HideViewModel();
	players[0] hide_swimming_arms();
	players[0] clientnotify( "force_hide_swimming_arms" );
	level thread play_player_fullbody_anim_simple( anim_node_2, "sampan_melee", 0.2 );
	//level waittill( "player_ready_for_anim" );
	level thread early_barnes_swim();
	level.vc_sampan_2 anim_set_blend_in_time( 0.2 );
	level.vc_sampan_2 anim_set_blend_out_time( 0.2 );
	anim_node_2 thread anim_single_aligned( level.vc_sampan_2, "melee" );
	// level.vc_sampan_2 thread beat2_swap_vc_head_model(); // -- WWILLIAMS: THIS SHOULD PLAY OFF A NOTETRACK!
	//anim_node anim_single_aligned( level.vc_sampan_1, "melee" );// -- WWILLIAMS: PLAY THE ANIM OF WOODS TAKING OUT THE OTHER GUY ON THE SAMPAN
	// level thread beat2_vc_sampan_1_killed_by_woods( anim_node );
	level thread teleport_kill_sampan_guy( level.vc_sampan_1 );
	anim_node anim_single_aligned( level.barnes, "sampan_melee" ); // -- WWILLIAMS: PLAY THE ANIM OF WOODS TAKING OUT THE OTHER GUY ON THE SAMPAN
	
	play_creek_object_anim_single( anim_node, anim_node, "sampan_kill" );
	//level.vc_sampan_2 ai_suicide();

	players = get_players();
	players[0] notify( "melee_done" );
	level notify( "stealth_sampan_complete" );
	players[0] show_swimming_arms();
	players[0] clientnotify( "force_show_swimming_arms" );
	players[0] EnableWeapons();
	// players[0] GiveWeapon( "commando_sp" );
	// players[0] SwitchToWeapon( "commando_sp" );
	players[0] ShowViewModel();
	
}

teleport_kill_sampan_guy( guy )
{
	wait( 3 );
	guy stopanimscripted();
	guy unlink();
	guy forceteleport( ( -28138, 38366, -28.5 ) );
	beat2_swap_vc_head_model( guy );
	guy ai_suicide();
}

beat2_swap_vc_head_model( guy ) // GUY == LEVEL.VC_SAMPAN_2 -- WWILLIAMS: SWAPS THE HEAD MODEL OF THE VC THE PLAYER KILLS
{	
	// swap the head
	if( is_mature() )
	{
		guy Detach( guy.headModel, "" );
		guy.headModel = "c_vtn_vc3_head_neck_cut";
		guy Attach( "c_vtn_vc3_head_neck_cut", "" );
	}
}

beat2_hammock_vc_1_head_swap( guy ) // GUY == level.vc_sleeping_1 -- WWILLIAMS: SWAP HEAD OF HAMMOCK VC CLOSEST TO ENTRANCE WINDOW
{
	// swap the head
	if( is_mature() )
	{
		guy Detach( guy.headModel, "" );
		guy.headModel = "c_vtn_vc2_head_sleeper_neck_cut";
		guy Attach( "c_vtn_vc2_head_sleeper_neck_cut", "" );
		
		if( !flag( "approaching_rice_eating_guy" ) )
		{
			level.vc_sleeping_2 Detach( level.vc_sleeping_2.headModel, "" );
			level.vc_sleeping_2.headModel = "c_vtn_vc3_head_neck_cut";
			level.vc_sleeping_2 Attach( "c_vtn_vc3_head_neck_cut", "" );
		}
	}
}

beat2_hammock_vc_2_head_swap( guy ) // GUY == level.vc_sleeping_2 -- WWILLIAMS: SWAP HEAD OF HAMMOCK VC FARTHEST TO ENTRANCE WINDOW
{
	if( is_mature() )
	{
		// swap the head
		guy Detach( guy.headModel, "" );
		guy.headModel = "c_vtn_vc3_head_neck_cut";
		guy Attach( "c_vtn_vc3_head_neck_cut", "" );
		
		if( !flag( "approaching_rice_eating_guy" ) )
		{
			level.vc_sleeping_1 Detach( level.vc_sleeping_1.headModel, "" );
			level.vc_sleeping_1.headModel = "c_vtn_vc2_head_sleeper_neck_cut";
			level.vc_sleeping_1 Attach( "c_vtn_vc2_head_sleeper_neck_cut", "" );
		}
	}
}

beat2_vc_sampan_1_killed_by_woods( anim_node ) // -- WWILLIAMS: SEEMS THAT WHEN I THREAD THE ANIMATION THERE IS AN SRE
{
	// level.vc_sampan_1 StopAnimScripted();
	anim_node anim_single_aligned( level.vc_sampan_1, "melee" );
}

beat2_vc_sampan_blood_in_the_water( sampan_vc ) // -- WWILLIAMS: WAITS FOR THE AI TO DIE THEN PLAYS THE FX
{
	// sampan_vc waittill( "death" );
	if( is_mature() )
	{
		PlayFXOnTag( level._effect["vc_blood_cloud"], sampan_vc, "J_spine4" );
	}
}

early_barnes_swim()
{
	wait( 7 );
	//iprintlnbold( "SWIM" );
	level notify( "barnes_starts_swimming_early" );
}

loop_search_anims( anim_node )
{
	level endon( "stealth_sampan_action_start" );
	level endon( "stealth_sampan_action_fail_water" );
	
	self thread sampan_stealth_fail_shoot();
	self thread sampan_stealth_fail_shoot_water();
	self thread sampan_stealth_fail_detection();
	
	player = get_players()[0];
	
	anim_node thread anim_loop_aligned( self, "crouch_idle" );
	anim_node thread anim_loop_aligned( level.vc_sampan_1, "crouch_idle" );
	level thread play_creek_object_anim_loop( anim_node, anim_node, "idle_crouch" );
	
	// when player gets close, switch
	while( distance( self.origin, player.origin ) > 450 )
	{
		wait( 0.05 );
	}
	
	flag_set( "sampan_searches_for_player" );
	
	// vc stands up and looks around
	anim_node stopanimscripted();
	anim_node anim_single_aligned( self, "crouch_2_stand" );
	level.vc_sampan_1 thread beat2_vc_sampan_search_anims( anim_node );
	anim_node thread anim_loop_aligned( self, "stand_idle" );
	level thread play_creek_object_anim_loop( anim_node, anim_node, "idle_stand" );
	
	// when player gets closer, switch again
	while( distance( self.origin, player.origin ) > 200 )
	{
		wait( 0.05 );
	}
	
	// vc sees player
	level thread player_is_close_enough_to_melee();
	anim_node thread anim_single_aligned( self, "stand_2_flinch" );
	anim_node anim_single_aligned( level.vc_sampan_1, "stand_2_flinch" );
	
	level notify( "stealth_sampan_action_fail" );
	
	anim_node anim_single_aligned( self, "flinch_2_stand" );
	
	anim_node thread anim_loop_aligned( self, "stand_idle" );
	level thread play_creek_object_anim_loop( anim_node, anim_node, "idle_stand" );
}

sampan_stealth_fail_shoot()
{
	level endon( "stealth_sampan_action_start" );
	level endon( "stealth_sampan_action_fail_water" );
	
	level waittill( "stealth_sampan_action_fail" );
	//screen_message_create( &"CREEK_1_FAIL_STAY_UNDER" );

	self StopAnimScripted();
	self.ignoreall = false;
	
	level.vc_sampan_1 StopAnimScripted();
	level.vc_sampan_1.ignoreall = false;
	
	setdvar( "ui_deadquote", "@CREEK_1_FAIL_STAY_UNDER" );
	player = get_players()[0];
	level thread sampan_fake_bullet_whizbies( self );
	player dodamage( player.health * 0.8, self.origin );
	wait( 0.4 );
	player dodamage( player.health * 0.8, self.origin );
	wait( 0.2 );
	player dodamage( player.health * 0.8, self.origin );
	wait( 0.1 );
	player dodamage( player.health * 0.8, self.origin );
	
	//RadiusDamage( player.origin, 1000, player.health + 100, player.health + 100 );

	// Increment persistant mission failed
	SetPersistentProfileVar( 3, GetPersistentProfileVar( 3, 0 ) + 1 ); 
	missionfailedwrapper( "@CREEK_1_FAIL_STAY_UNDER" );
}

sampan_fake_bullet_whizbies( guy )
{
	while( 1 )
	{
		start = guy GetTagOrigin("tag_flash");

		player = get_players()[0];
		direction = AnglesToForward( player GetPlayerAngles() );
		pos = player get_eye();
		end =  pos + vector_scale( direction, RandomIntRange( 20, 50 ) );

		bullet_dir = start - end;
		end = end + vector_scale( VectorNormalize( bullet_dir ), 100 );

		MagicBullet( guy.weapon, start, end, guy );

		wait( 0.1 );
	}	
}

sampan_stealth_fail_shoot_water()
{
	level endon( "stealth_sampan_action_start" );
	level endon( "stealth_sampan_action_fail" );
	
	level waittill( "stealth_sampan_action_fail_water" );
	//screen_message_create( &"CREEK_1_FAIL_STAY_UNDER" );

	self StopAnimScripted();
	self.ignoreall = false;
	
	level.vc_sampan_1 StopAnimScripted();
	level.vc_sampan_1.ignoreall = false;
	
	player = get_players()[0];
	//RadiusDamage( player.origin, 1000, player.health + 100, player.health + 100 );
	
	// Increment persistant mission failed
	SetPersistentProfileVar( 3, GetPersistentProfileVar( 3, 0 ) + 1 ); 
	missionfailedwrapper( "@CREEK_1_FAIL_STAY_UNDER" );
}

sampan_stealth_fail_detection()
{
	level endon( "stealth_sampan_action_start" );
	
	flag_wait( "sampan_searches_for_player" );
	
	// if player is above water and inside the trigger and don't kill VC in 1.5 sec he fails
	exposed_time = 0;
	player = get_players()[0];
	trigger = getent( "b2_sampan_kill_detected", "targetname" );
	while( 1 )
	{
		// player is above water and touching trigger
		if( isdefined( player._swimming ) && isdefined( player._swimming.is_underwater ) 
			&& player._swimming.is_underwater == false && player istouching( trigger ) )
		{
			exposed_time += 0.05;
			
			if( exposed_time >= 1.5 )
			{
				level.above_water_fail = true;
				level notify( "stealth_sampan_action_fail_water" );
				player = get_players()[0];
				player SetScriptHintString( "" );
				return;
			}
		}
		else
		{
			exposed_time = 0; // reset exposed time
		}
		wait( 0.05 );
	}
}

beat2_vc_sampan_search_anims( anim_node ) // SELF == LEVEL.VC_SAMPAN_2 -- WWILLIAMS: SECOND SAMPAN VC GETS TAKEN DOWN BY WOODS
{
	self endon( "death" );
	
	anim_node anim_single_aligned( self, "crouch_2_stand" ); 
	anim_node anim_single_aligned( self, "stand_idle" );
}

player_is_close_enough_to_melee()
{
	//wait( 1 );
	//level notify( "player_close_enough_to_sampan" );	
}

barnes_swim_sampan_to_dock()
{
	//level.barnes go_to_node_by_name( "b2_barnes_hut_kill_node" );
 //	level.barnes waittill( "goal" );

	//level thread test_timer();
	//level thread maps\creek_1_fx::barnes_get_in_out_water( 10 );
	anim_node = getstruct( "anim_b2_dock", "targetname" );
	anim_node anim_single_aligned( level.barnes, "swim_sampan_to_dock" );
	level notify( "sampan_to_dock_done" );
	
	//anim_node_hut = getstruct( "b2_huts_anim_node_2", "targetname" );
	//anim_node_hut thread anim_first_frame( level.barnes, "take_out_hut_vc" );

	level notify( "barnes_swim_to_dock_done" );
	
	if( !flag( "b2_hut_barnes_move_up" ) )
	{
		//anim_node_hut = getstruct( "b2_huts_anim_node_2", "targetname" );
		anim_node thread anim_loop_aligned( level.barnes, "swim_sampan_to_dock_idle" );
	}
}

b2_hut_kills_vc_reach()
{
	anim_node = getstruct( "b2_huts_anim_node_2", "targetname" );
	anim_node thread anim_loop_aligned( level.vc_hut_1, "hut_idle" );
	anim_node thread anim_loop_aligned( level.vc_hut_2, "hut_idle" );
	anim_node thread anim_loop_aligned( level.hudson, "hut_idle" );
	
	level.hudson hide();
}

temp_hut_dialogue()
{
	wait( 5 );
	level.hudson PlaySound( "vox_Cre1_s02_028A_LEWI" ); //Change of plans?
	wait( 2 );
	level.barnes PlaySound( "vox_Cre1_s02_029A_BARN" ); //Chopper went down.
	wait( 1.5 );
	level.hudson PlaySound( "vox_Cre1_s02_030A_LEWI" ); //Right...
	wait( 1 );
	level.barnes PlaySound( "vox_Cre1_s02_031A_BARN" ); //Carter and I will cross the river here ...
	wait( 11 );
	level.hudson PlaySound( "vox_Cre1_s02_032A_LEWI" ); //I have squads on the river bank ...
	wait( 5.5 );
	
	level notify( "time_to_resume_anim" );
	
	//level.barnes PlaySound( "vox_Cre1_s02_035A_BARN" ); //Carter, grab one off those silenced weapons.
	//wait( 3.5 );
	level.barnes PlaySound( "vox_Cre1_s02_036A_BARN" ); //Let's move.
}

temp_hide_hudson()
{
	wait( 0.3 );
	level.hudson show();
}

intro_swim_anim_gap( anim_node )
{
	level endon( "stealth_sampan_action_start" );
	level endon( "end_gap_anim" );
	
	if( !isdefined( level.skipped_to_event_2 ) || level.skipped_to_event_2 == false )
	{		
		//wait( 1 );
	}
	
	anim_node = getstruct( "anim_b2_pacing_start", "targetname" );
	anim_node_gap = getstruct( "anim_b2_gap", "targetname" );
	trigger_swim_to_sampan = GetEnt( "b2_close_to_gap", "targetname" );
	anim_node anim_single_aligned( level.barnes, "swim_to_shore" );
	level notify( "swim_to_shore_done" );
	
	level.barnes maps\creek_1_stealth::beat2_barnes_fight_ridge_1();
	
	// sprint to first cover and wait there
	// -- WWILLIAMS: REZNOV NOW MOVES WITH BARNES THROUGH THE AREA
	level.barnes go_to_node_by_name( "b2_barnes_opening_node_0" );
	level.reznov go_to_node_by_name( "b2_reznov_opening_node_0" );
	level.barnes set_run_anim( "run_fast", true );
	// level.reznov set_run_anim( "run_fast", true );
	level.barnes.goalradius = 16;
	level.reznov.goalradius = 16;
	//level.barnes.disableArrivals = true;
	level.barnes waittill( "goal" );
	
	// -- WWILLIAMS: PRESS DEMO 4-19 HACK ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// -- RESTORE THIS BLOCK AFTER THE DEMO
	//wait( 1 );
	flag_wait( "b1to2_path_1_passed" );
	
	// now barnes look around a bit before sprinting the to next cover
	level.barnes thread go_to_node_by_name( "b2_barnes_opening_node_1" );
	// level.reznov thread beat2_delay_reznov_before_river2_fight();
	level.reznov go_to_node_by_name( "b2_reznov_opening_node_1" ); // -- WWILLIAMS: ADD REZNOV

	//wait( 1 );
	flag_wait( "b1to2_path_2_passed" );
	
	// track death
	dvarName = "player" + self GetEntityNumber() + "downs";
	
	// track mission fails
	SetPersistentProfileVar( 3, 1 ); 
	autosave_by_name( "creek_1_isag" );
	
	// go to and cross rock barrier
	
	anim_node = getstruct( "anim_b2_rock_barrier", "targetname" );
	anim_node anim_reach_aligned( level.barnes, "rock_step" );

	// restore underwater fog
	player = get_players()[0];
	player clientnotify( "switch_water_for_rest_of_creek" );

//////////////////////////////////////////////////////
// ADDED FOR DEMO ONLY !!!!!!!!!
/*
	anim_node thread anim_single_aligned( level.barnes, "rock_step" );
	wait( 2 );
	maps\creek_1_fade_screen::custom_fade_screen_out( "white", 1.0 );
	wait( 1 );
	
	level notify( "demo_teleport_1" );
	
	// play the animation
	anim_node_gap = getstruct( "anim_b2_gap", "targetname" );
	level.barnes thread maps\creek_1_fx::water_splash_fx_handler();

	player = get_players()[0];
	player DisableWeapons();
	player hide_swimming_arms();
	level thread play_demo_intro_anim( anim_node_gap, "swim_gap", 0.1, true );
	
	wait( 1 );
	level thread maps\creek_1_fade_screen::custom_fade_screen_in( 1.0 );

	level waittill( "player_move_gap_done" );
	level notify( "end_gap_anim" );
	level thread animate_river_snake();
	
	
	
	player waittill( "anim_complete" );
	player show_swimming_arms();
	player EnableWeapons();
	
	level notify( "reveal_anim_done" );
	return;
*/
// END ADDITION TO DEMO
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// REMOVED FOR DEMO

	// help with the blending in and out
	level.barnes._anim_blend_in_time = 0.2;
	level.barnes._anim_blend_out_time = 0.1;
	anim_node anim_single_aligned( level.barnes, "rock_step" );
	
	level thread delayed_blending_restore();
// END REMOVED
//////////////////////////////////////////////////////

	// now look up
	level.barnes go_to_node_by_name( "b2_barnes_opening_node_2" );
	level.barnes waittill( "goal" );
	//wait( 1 );
	flag_wait( "b1to2_path_3_passed" );
	
	//level.barnes set_run_anim( "run_look_around", true );
	//level.barnes clear_run_anim();
	anim_node = getstruct( "anim_b2_log", "targetname" );

	//level.barnes go_to_node_by_name( "b2_barnes_reveal_node" );
	//level.barnes waittill( "goal" );
	//anim_node anim_reach_aligned( level.barnes, "swim_to_gap" );
	//anim_node anim_single_aligned( level.barnes, "swim_to_gap" );
	anim_node anim_reach_aligned( level.barnes, "gap_reach" );
	level notify( "gap_reach_starts" );
	anim_node anim_single_aligned( level.barnes, "gap_reach" );
	level.barnes notify( "gap_reached" );
	
	level thread loop_barnes_anim_at_gap( anim_node );
	
	flag_wait( "gap_idle_loop_done" );
	
	anim_node anim_single_aligned( level.barnes, "swim_gap_to_sampan" );
	anim_node thread anim_loop_aligned( level.barnes, "sampan_idle" );
	
	//level.barnes clear_run_anim();
	level.barnes.disableArrivals = false; 
	// -- WWILLIAMS: PRESS DEMO 4-19 HACK
	// -- RESTORE THIS BLOCK AFTER THE DEMO ////////////////////////////////////////////////////////////////////////////////////////////////////////////
}


loop_barnes_anim_at_gap( anim_node )
{
	while( !flag( "ready_to_move_from_gap" ) )
	{
		anim_node anim_single_aligned( level.barnes, "gap_idle_single" );
	}
	flag_set( "gap_idle_loop_done" );
}

delayed_blending_restore()
{
	wait( 0.2 );
	level.barnes._anim_blend_in_time = 0;
	level.barnes._anim_blend_out_time = 0;
}

beat2_delay_reznov_before_river2_fight() // -- WWILLIAMS: REZNOV TAKES OFF TO SOON SLOWING WOODS DOWN
{
	wait( 3.0 );
	
	self go_to_node_by_name( "b2_reznov_opening_node_1" );
}



test_timer()
{
	i = 0;
	while( 1 )
	{
		wait( 0.5 );
		i += 0.5;
		// iprintlnbold( i );
	}
}

lewis_bridge_anim()
{
	anim_node = getstruct( "anim_b2_bridge", "targetname" );
	anim_node anim_reach_aligned( level.hudson, "bridge_signal" );
	anim_node anim_single_aligned( level.hudson, "bridge_signal" );
	level.hudson go_to_node_by_name( "b2_hudson_stealth_node_5_2" );
}

idle_window_shutters()
{
	anim_node = getstruct( "anim_b2_lookout", "targetname" );
	window_ls = getentarray( "b2_shutter_open_r", "targetname" );
	window_rs = getentarray( "b2_shutter_open_l", "targetname" );
	for( i = 0; i < window_ls.size; i++ )
	{
		window_ls[i].animname = "window_l";
		level thread play_creek_object_anim_loop( window_ls[i], anim_node, "idle" );
	}
	for( i = 0; i < window_rs.size; i++ )
	{
		window_rs[i].animname = "window_r";
		level thread play_creek_object_anim_loop( window_rs[i], anim_node, "idle" );
	}
}

vc_look_out_window( vc, vc2 )
{
	anim_node = getstruct( "anim_b2_lookout", "targetname" );
	
	//anim_node anim_reach_aligned( vc, "look_out" );
	// level notify( "vc_lookout_in_position" );
	flag_set( "vc_lookout_in_position" ); // -- WWILLIAMS: should fix a prog break where the notify was hitting before the waittill
	
	//iprintlnbold( "Hold up" );
	player = get_players()[0];
	//playsoundatposition( "VOX_CRE1_059A_BARN", player.origin + ( 0, 0, 70 ) );
	
	window_ls = getentarray( "b2_shutter_open_r", "targetname" );
	window_rs = getentarray( "b2_shutter_open_l", "targetname" );
	for( i = 0; i < window_ls.size; i++ )
	{
		window_ls[i].animname = "window_l";
		level thread play_creek_object_anim_single( window_ls[i], anim_node, "open" );
		window_ls[i] PlaySound( "fly_window_open_00" );
	}
	for( i = 0; i < window_rs.size; i++ )
	{
		window_rs[i].animname = "window_r";
		level thread play_creek_object_anim_single( window_rs[i], anim_node, "open" );
		window_rs[i] PlaySound( "fly_window_open_01" );
	}
	
	level notify( "window_safe" ); // temp
	
	anim_node thread anim_single_aligned( level.barnes, "look_out" );
	anim_node thread anim_single_aligned( vc, "look_out" );
	anim_node anim_single_aligned( vc2, "look_out" );
	
	level notify( "vc_not_looking_out" );
	
	//level.barnes go_to_node_by_name( "b2_window_far" );
	
	vc Delete();
	vc2 Delete();
}

barnes_shim_over_window()
{
//	level thread play_jumping_into_water_fx();
		
	anim_node_swim = getstruct( "anim_b2_swim_hut", "targetname" );
	anim_node_island = getstruct( "anim_b2_island", "targetname" );
	
	sneak_in_hut_trigger = GetEnt( "b2_player_cleared_window", "targetname" );
	sneak_in_hut_trigger ent_flag_init( "barnes_sneak_in" );
	sneak_in_hut_trigger thread beat2_shimy_window_ent_flag( "barnes_sneak_in" );
	
	blocker = getent( "b2_hut_weapon_player_blocker", "targetname" );
	blocker delete();
	level notify( "player_has_silenced_weapon" );
	
	// barnes swims over first and waits
	//anim_node_swim anim_reach_aligned( level.barnes, "swim_climb_dock" );
	
	//level thread maps\creek_1_fx::barnes_get_in_out_water( 3 );
	//level thread maps\creek_1_fx::barnes_get_in_out_water( 10 );
	
	level notify( "swim_climb_dock_starts" );
	anim_node_swim anim_single_aligned( level.barnes, "swim_climb_dock" );
	
	// make some changes here. He will loop in water and come up only after player planted the charge
	anim_node_island thread anim_loop_aligned( level.barnes, "loop_swim_dock_idle" );
	flag_wait( "bomb_1_set" );
	level.barnes gun_recall();

	level thread delete_island_blocker();
	anim_node_island anim_single_aligned( level.barnes, "climb_onto_dock" );
	
	level.player_on_island = false;
	level thread wait_for_player_to_get_on_island();
	
	level notify( "swim_climb_dock_ends" );
	level.swim_climb_dock_ends = true;
	
	level notify( "no_more_barnes_fx" );
	level.barnes.keep_playing_wake_fx = false;
	
	while( level.player_on_island == false )
	{
		anim_node_island anim_single_aligned( level.barnes, "loop_right_single" );
	}
	
	level notify( "barnes_starts_window" );
	autosave_by_name( "creek_1_3" );
	//ACB barnes no longer says anything prior to window entrance at chef hut
	//level.barnes thread say_dialogue( "get_down", 1 );
	//level.barnes AllowedStances( "crouch" );
	
	//level thread beat2_hudson_team_checks_in(); // -- WWILLAIMS: MADE THE EVENT FEEL LIKE IT WAS TAKING LONGER THAN IT SHOULD;
	anim_node_island anim_single_aligned( level.barnes, "window_shimy" );
	
	// wait for player to get close, then go in
	// trigger_wait( "b2_player_cleared_window" );
	// level.barnes thread say_dialogue( "shhhh" );
	while( !sneak_in_hut_trigger ent_flag( "barnes_sneak_in" ) )
	{
		anim_node_island anim_single_aligned( level.barnes, "loop_left" );
	}
	
	level.barnes.ignoreall = true;
	anim_node_island anim_single_aligned( level.barnes, "sneak_in" );
	level notify( "barnes_enters_hut" );
	
	wait( 5 );
	
	level.barnes notify( "stop_water_fx" );
	//level.barnes AllowedStances( "stand", "crouch", "prone" );
}


wait_for_player_to_get_on_island()
{
	trigger_wait( "b2_player_get_on_island" );
	level.player_on_island = true;
}

delete_island_blocker()
{
	wait( 13.5 );
	island_blocker = getent( "island_player_blocker", "targetname" );
	island_blocker delete();
}

beat2_shimy_window_ent_flag( str_ent_flag ) // -- WWILLIAMS: SETS THE FLAG ON THE TRIGGER
{
	self waittill( "trigger" );
	self ent_flag_set( str_ent_flag );
}


beat2_bowman_checks_in() // -- WWILLIAMS: BOWMAN CHECKS IN RIGHT WHEN THE PLAYER GETS TO THE COOK VC HUT
{
	trigger_wait( "b2_player_get_on_island" );
	level.hudson say_dialogue( "cleared_east_bank" );
	level.b2_redshirt say_dialogue( "seirra_north_perimeter" );
}

beat2_hudson_team_checks_in() // -- WWILLIAMS: REMOVING THIS DIALOGUE CALL FROM THE SEQUENCE UNDER THE COOK WINDOW. 
{
	level.hudson say_dialogue( "cleared_east_bank" );
	level.b2_redshirt say_dialogue( "seirra_north_perimeter" );
}

b2_sleeping_vc( hammock_name, other_guy_name )
{
	// get the hammock model
	hammock = getent( hammock_name, "targetname" );
	
	// the origin od hammock is where we will create an anim_node
	anim_node = spawn( "script_origin", hammock.origin );
	anim_node.angles = hammock.angles;
	
	// for hammock, we link the hammock to the linker, then animate the linker
	linker = Spawn( "script_model", anim_node.origin );
	linker.angles = anim_node.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "hammock";
	hammock linkto( linker, "origin_animate_jnt" );
	
	// loop idle anim
	self linkto( anim_node );
	anim_node thread anim_loop_aligned( self, "sleep" );
	level thread play_creek_object_anim_loop( linker, anim_node, "idle" );
	
	wait( 1 );
	other_guy = getent( other_guy_name, "targetname" );
	
	// test:
	self.is_player_target = false;
	self thread hammock_detect_player_attack( other_guy );
	
	self thread hammock_killed_by_player( other_guy, anim_node, linker );
	self thread hammock_killed_by_woods( other_guy, anim_node, linker );
}
	
hammock_killed_by_player( other_guy, anim_node, linker )
{
	self endon( "killed_by_woods" );
	self waittill( "melee_kill" );
	
	// let woods kill the other guy
	if( !flag( "approaching_rice_eating_guy" ) )
	{
		other_guy notify( "killed_by_woods" );
	}
	
	player = get_players()[0];
	self thread beat2_hammock_vc_play_death_then_idle( anim_node );
	player thread temp_hammock_melee_death_audio();
	level thread play_player_fullbody_anim_simple( anim_node, self.animname + "_kill", 0.2 );
	level thread restore_player_weapon_at_end( player );
	
	// attach a knife to player's hands
	level thread delayed_add_knife_to_player_hands( 0.2 );
		
	// hammock anim align to the hammock node
	play_creek_object_anim_single( linker, anim_node, "hammock_kill" );
	
	self.activatecrosshair = false;
	
	level.vc_stealth_killed++;
}

restore_player_weapon_at_end( player )
{
	player waittill( "anim_complete" );
	player EnableWeapons();
	player ShowViewModel();
	player AllowMelee( true );
}

hammock_killed_by_woods( other_guy, anim_node, linker )
{
	self endon( "melee_kill" );
	self waittill( "killed_by_woods" );
	
	self thread temp_hammock_melee_death_audio_npc();
		
	// self's anim align to the hammock node
	anim_node thread anim_single_aligned( self, "woods_kill" );
	// woods' anim align to self
		
	if( self.animname == "b2_vc_sleeping_1" )
	{
		anim_node thread anim_single_aligned( level.barnes, "woods_kill_2" );
	}
	else
	{
		anim_node thread anim_single_aligned( level.barnes, "woods_kill_1" );
	}
	// hammock anim align to the hammock node
	play_creek_object_anim_single( linker, anim_node, "hammock_kill" );
		
	// now the AI is dead, play the idle anim
	anim_node thread anim_loop_aligned( self, "death_idle" );
	self.activatecrosshair = false;
	self SetContents( 0 );
	self.team = "allies";
	
	flag_set( "approaching_rice_eating_guy" );
	//flag_set( "head_to_rice_vc" );
}

beat2_hammock_vc_play_death_then_idle( anim_node ) // -- WWILLIAMS: 9-14 PRESS DEMO: FIX TO VC STANDING UP AFTER DEATH ANIM
{
	anim_node anim_single_aligned( self, "player_kill" );
	
	// now the AI is dead, play the idle anim
	anim_node thread anim_loop_aligned( self, "death_idle" );
	self.activatecrosshair = false;
	self SetContents( 0 );
	self.team = "allies";
}

delayed_add_knife_to_player_hands( timer )
{
	wait( timer );
	player = get_players()[0];
	if( isdefined( player.anim_hands ) )
	{
		player.anim_hands Attach( "t5_knife_sog", "tag_weapon", true );
	}
}

hammock_detect_player_attack( other_guy )
{
	self endon( "melee_kill" );
	
	self thread detect_player_melee_hammock_button();
	self thread delete_player_melee_hammock_button();
	self waittill( "player_pressed_melee" ); 
		
	self.is_player_target = true;
	//other_guy notify( "melee_kill" );
	self notify( "melee_kill" );
}

delete_player_melee_hammock_button()
{
	self endon( "melee_kill" );
	self endon( "death" );
	
	self waittill( "killed_by_woods" );
	players = get_players();
	players[0] SetScriptHintString( "" );
	//screen_message_delete();
}

detect_player_melee_hammock_button()
{
	self endon( "killed_by_woods" );
	self endon( "melee_kill" );
	self endon( "death" );
	
	// player has to be within this range
	message_displayed = false;
	player = get_players()[0];
	while( 1 )
	{
		distance_player = distance( self.origin, player.origin );
		if( distance_player <= 50 && message_displayed == false )
		{
			players = get_players();
			players[0] AllowMelee( false );
			//players[0] SetScriptHintString( &"CREEK_1_PRESS_L3" );
			players[0] SetScriptHintString( "" );
			//screen_message_create( &"CREEK_1_PRESS_L3" );
			message_displayed = true;
		}
		else if( distance_player > 50 && message_displayed == true )
		{
			players = get_players();
			players[0] AllowMelee( true );
			players[0] SetScriptHintString( "" );
			//screen_message_delete();
			message_displayed = false;
		}
		
		if( message_displayed == true && player meleeButtonPressed() == true )
		{
			// Hide the player's viewmodel before it swings
			player = get_players()[0];
			
			player HideViewModel();
			player DisableWeapons();
			self notify( "player_pressed_melee" );
			player SetScriptHintString( "" );
			//screen_message_delete();
			player AllowMelee( true );
			return;
		}

		wait( 0.05 );
	}
}
	
b2_talking_chef()
{
	anim_node = getstruct( "anim_b2_island", "targetname" );
	
	new_node = spawn( "script_origin", anim_node.origin + ( 0, 0, 11 ) );
	new_node.angles = anim_node.angles;
	
	new_node anim_loop_aligned( self, "talking" );
}

b2_talking_chef_hack()
{
	anim_node = getstruct( "anim_b2_island", "targetname" );
	
	new_node = spawn( "script_origin", anim_node.origin + ( 0, 0, 14 ) );
	new_node.angles = anim_node.angles;

	self thread b2_talking_chef_attach_smoke( new_node );
	new_node anim_loop_aligned( self, "talking" );
}

b2_talking_chef_attach_smoke( anim_node)
{
	self endon( "death" );
	
	/*
	org = self gettagorigin( "tag_weapon_left" );
	ang = self gettagangles( "tag_weapon_left" );
	
	linker = spawn( "script_model", org );
	linker.angles = ang;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "cig";
	
	org_animate = linker gettagorigin( "origin_animate_jnt" );
	ang_animate = linker gettagangles( "origin_animate_jnt" );
	
	cig = spawn( "script_model", org_animate );
	cig.angles = ang_animate;
	cig SetModel( "p_glo_cigarette01" );

	cig linkto( linker, "origin_animate_jnt" );
	
	//linker linkto( self, "tag_weapon_left" );
	level thread play_creek_object_anim_loop( linker, anim_node, "talking_smoke" );	
	
	*/
	
	self attach( "p_glo_cigarette01", "tag_weapon_left" );
	playfxontag( level._effect["cig_smoke"], self, "tag_weapon_left" );
}

// BEAT 4 New Anims -----------------------------------------------------------

#using_animtree ("generic_human");

b4_reznov_blinded()
{
	level.reznov Attach( "t5_knife_animate", "tag_weapon_right" );
	level.reznov gun_remove();
	wait( 0.5 );
	
	//teleport_ai_single( "reznov", "b4_tunnel_reznov_appears" );
	
	/*
	anim_node = getstruct( "anim_struct_swift_kill", "targetname" );
	anim_node_reznov = getstruct( "anim_b4_blind", "targetname" );
	*/
	anim_node_reznov = getstruct( "anim_struct_swift_kill", "targetname" );
	
	// start Reznov in a loop
	level.reznov LookAtEntity(get_players()[0]);
	anim_node_reznov thread anim_loop_aligned( level.reznov, "blinded_idle" );
	
	// break out of loop and play a single
	level waittill( "play_reznov_blinded_anim" );
	
	
	// we attach a knife to reznov's hand
	//level.reznov gun_remove();
	//level.reznov Attach( "t5_knife_animate", "tag_weapon_right" );
	
	//iprintlnbold( "drop" );
	level thread cut_reznov_blind_anim_short();
	anim_node_reznov anim_single_aligned( level.reznov, "blinded" );
	
	level.reznov Detach( "t5_knife_animate", "tag_weapon_right" );
	level.reznov gun_switchto( "m1911_sp", "right" );
	
	// we remove this knife and restore it
	//level.reznov Detach( "t5_knife_animate", "tag_weapon_right" );
	//level.reznov gun_switchto( "m1911_sp", "right" );
	level.reznov LookAtEntity();
	level notify( "reznov_blinded_anim_done" );
	
	level.reznov.ignoreme = true;
}

cut_reznov_blind_anim_short()
{
	wait( 0.05 );
	fraction_skip = 30 / 735;
	anim_set_time( level.reznov, "blinded", fraction_skip );
}

#using_animtree ("generic_human");

post_drown_lookat_player()
{
	time = GetAnimLength( level.scr_anim["reznov"]["drown_vc"] ); 
	wait time - 6.0;	
	
	self LookAtEntity(get_players()[0]);
}

b4_reznov_drowns_vc()
{
	vc_spawner = getent( "vc_tunnel_prone_guy", "targetname" );
	vc = spawn_fake_guy_to_anim( vc_spawner, "captured_vc_1", "vc" );
	vc hide();
	vc.animname = "drowned_vc";
	anim_node = getstruct( "anim_b4_drown", "targetname" );
	
	guys = [];
	guys[0] = level.reznov;
	guys[1] = vc;
	
	level.reznov anim_set_blend_in_time( 0.3 );
	anim_node anim_reach_aligned( level.reznov, "drown_vc" );
	
	//vc gun_remove();
	/*
	level.reznov gun_remove();
	
	weapon_pistol = getent( "b4_reznov_pistol", "targetname" );
	weapon_pistol.origin = level.reznov GetTagOrigin( "tag_weapon_right" );
	weapon_pistol.angles = level.reznov GetTagAngles( "tag_weapon_right" );
	weapon_pistol useweaponhidetags( "m1911_sp" );
	weapon_pistol Linkto( level.reznov, "tag_weapon_right" );
	*/
		
	weapon_reznov_knife = getent( "b4_reznov_knife", "targetname" );
	weapon_reznov_knife.origin = level.reznov GetTagOrigin( "tag_weapon_left" );
	weapon_reznov_knife.angles = level.reznov GetTagAngles( "tag_weapon_left" );	
	weapon_reznov_knife Linkto( level.reznov, "tag_weapon_left" );
	
	weapon_vc_knife = getent( "b4_vc_knife", "targetname" );
	weapon_vc_knife.origin = vc GetTagOrigin( "tag_weapon_right" );
	weapon_vc_knife.angles = vc GetTagAngles( "tag_weapon_right" );	
	weapon_vc_knife Linkto( vc, "tag_weapon_right" );
	weapon_vc_knife hide();
	
	level.reznov PlaySound( "evt_tunnel_rez_takedown" );
	
///////////////////////////////////////////////////////////
// REMOVED FOR DEMO

	level thread quick_show_models( vc, weapon_vc_knife );
	level thread drowned_vc_end_idle( vc, anim_node );

	//level.reznov thread post_drown_lookat_player();	
	anim_node anim_single_aligned( level.reznov, "drown_vc" );

	anim_node thread anim_loop_aligned( level.reznov, "drown_vc_idle" );
	
	//weapon_pistol delete();
	weapon_reznov_knife delete();
	weapon_vc_knife delete();
	//level.reznov gun_switchto( "m1911_sp", "right" );
	
	//maps\creek_1_fade_screen::custom_fade_screen_out( "black", 1 );
	//wait( 1.5 );
	//level.reznov LookAtEntity();
	//ChangeLevel( "" );

// END REMOVAL
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// ADDED FOR DEMO
/*
	level thread quick_show_models( vc, weapon_vc_knife );
	level thread drowned_vc_end_idle( vc, anim_node );
	anim_node thread anim_single_aligned( level.reznov, "drown_vc" );
	
	wait( 28 );
*/
// END REMOVAL
///////////////////////////////////////////////////////////

	//vc ai_suicide();
	//vc StartRagdoll();
	//vc DoDamage( vc.health + 100, level.reznov.origin, level.reznov );
	
	level notify( "reznov_drown_vc_anim_done" );
}

drowned_vc_end_idle( vc, anim_node )
{
	anim_node anim_single_aligned( vc, "drown_vc" );
	anim_node anim_loop_aligned( vc, "drown_vc_idle" );
}

quick_show_models( ent_1, ent_2 )
{
	wait( 0.1 );
	ent_1 show();
	ent_2 show();
}

#using_animtree ("generic_human");

b4_vc_ambush_slash()
{
	anim_node = getstruct( "anim_b4_ambush", "targetname" );
	anim_node anim_single_aligned( self, "slash_attack" );
	if( isdefined( self.machete ) )
	{
		self.machete delete();
	}
	self.goalradius = 64;
	player = get_players()[0];
	self.disableMelee = true;
	self setgoalentity( player );
}

b4_vc_ambush_idle()
{
	anim_node = getstruct( "anim_b4_ambush", "targetname" );
	anim_node thread anim_loop_aligned( self, "slash_idle" );
}

b4_tunnel_slash_player( guy )
{
	// check distance to the player to determine damage dealt
	// Tweak these values as we go
	
	kill_radius = 90; // if player is within this distance, he will be dealt 100% damage
	damage_radius = 140; 
	
	player = get_players()[0];
	distance_to_player = distance( player.origin, guy.origin );
	
	if( distance_to_player < damage_radius )
	{
		if( distance_to_player < kill_radius )
		{
			player PlayRumbleOnEntity( "damage_heavy" );
			player die();
		}
		else
		{
			distance_in = damage_radius - distance_to_player;
			damage_percent_dealt = distance_in / ( damage_radius - kill_radius );
			
			if( damage_percent_dealt > 0.5 )
			{
				player PlayRumbleOnEntity( "damage_heavy" );
			}
			else
			{
				player PlayRumbleOnEntity( "damage_light" );
			}		
			player dodamage( player.health * damage_percent_dealt + 1, guy.origin, guy );
		}
	}
}

#using_animtree ("generic_human");

b4_tunnel_entrance_anim()
{
	level endon( "player_entered_tunnel" );
		
	guys = [];
	guys[0] = level.barnes;
	guys[1] = level.hudson;
	
	anim_node = getstruct( "anim_b4_tunnel", "targetname" );
	level.barnes hold_fire();
	level.hudson hold_fire();
	level.swift hold_fire();
	
	// run to the gate first
	level.barnes thread go_to_node_by_name( "b4_gate_reach_l" );
	level.hudson thread go_to_node_by_name( "b4_gate_reach_r" );
	wait_for_all_guys_to_reach_goal( level.barnes, level.hudson, level.swift );
	//wait( 1 );
	//anim_node anim_reach_aligned( guys, "tunnel_entrance_A" );
	
	// barnes kicks door and runs to the tunnel, blowing it up
	level notify("cover_start");
	
	//level thread TEMP_notetracks();
	
	//level thread play_tunnel_hatch_open();
	level thread swift_tunnel_entrance_anim( anim_node );
	anim_node anim_single_aligned( guys, "tunnel_entrance_new" );
	level.barnes SetGoalPos( level.barnes.origin );
	level.hudson SetGoalPos( level.hudson.origin );
	
	/*
	// wait for the player
	anim_node thread anim_loop_aligned( guys, "tunnel_entrance_wait" );
	
	flag_wait( "b4_player_near_tunnel" );	
	
	// tells player to get down
	level thread vo_at_tunnel_entrance();
	anim_node anim_single_aligned( guys, "tunnel_entrance_B" );
	
	// wait for the player some more
	anim_node thread anim_loop_aligned( guys, "tunnel_entrance_wait" );
	*/
}

TEMP_notetracks()
{
	wait( 7 );
	// iprintlnbold( "grenade spawn" );
	level.barnes thread b4_tunnel_grenade_spawn( level.barnes );
	wait( 4 );
	// iprintlnbold( "grenade explode" );
	level.barnes thread b4_tunnel_grenade_explode( level.barnes );
}

swift_tunnel_entrance_anim( anim_node )
{
	anim_node anim_single_aligned( level.swift, "tunnel_entrance_new" );
	
	// now go to your node
	level notify( "swift_anim_done" );
}

wait_for_all_guys_to_reach_goal( guy1, guy2, guy3 )
{
	level.guys_reached_gate = 0;
	level thread wait_for_guys_gate( guy1 );
	level thread wait_for_guys_gate( guy2 );
	level thread wait_for_guys_gate_reach( guy3 );
	
	while( level.guys_reached_gate < 3 )
	{
		wait( 0.05 );
	}
}

wait_for_guys_gate( guy )
{
	guy endon( "death" );
	guy waittill( "goal" );
	level.guys_reached_gate++;
}

wait_for_guys_gate_reach( guy )
{
	guy endon( "death" );
	anim_node = getstruct( "anim_b4_tunnel", "targetname" );
	anim_node anim_reach_aligned( guy, "tunnel_entrance_new" );
	level.guys_reached_gate++;
}


b4_tunnel_room_1_barrier()
{
	anim_node = getstruct( "anim_b4_room_1", "targetname" );
	
	//level thread play_tunnel_shelf_fall( anim_node );

	// vc waits in idle
	vc = getent( "vc_tunnel_room1_3_ai", "targetname" );
	anim_node thread anim_loop_aligned( vc, "fire_loop" );
	vc.health = 10000;
	wait( 0.1 );
	vc.goalradius = 4;
	vc SetGoalPos( vc.origin );
	vc AllowedStances( "crouch" );
	vc StopAnimScripted();
	
	level.reznov AllowedStances( "stand" );
		
	// when the others are killed and the player is looking here
	level waittill( "hatch_opens_above" );
	
	level.reznov gun_switchto( "m1911_sp", "right" );
	
	// VC and Reznov both animate
	level thread room_1_vc_death( vc, anim_node );
	anim_node anim_single_aligned( level.reznov, "vc_to_shelf" );
	level notify( "reznov_at_shelf" );
	
	// When Reznov is in position, he idles
	anim_node thread anim_loop_aligned( level.reznov, "shelf_loop" );
	
	// When player uses the trigger, we play both anims for player and Reznov
	level waittill( "shelf_pushed" );

	// keep the light on
	player = get_players()[0];
	old_light_status = player.flashlight_on;
	level.restore_flashlight_function = false;
	
	level thread keep_some_light_on();
	
	screen_message_delete();

	player DisableWeapons();
	anim_node thread anim_single_aligned( level.reznov, "shelf_to_tunnel" );
	play_player_fullbody_anim_simple( anim_node, "push_shelf", 0.6 );
	
	if( old_light_status == true )
	{
		level.default_light = "on";
		//player.flashlight_on = true;
		player clientNotify( "flahslight_on" );
	}
	player EnableWeapons();
	
	level.reznov AllowedStances( "stand" );
	level.reznov go_to_node_by_name( "b4_room1_exit_reznov_temp" );
	wait( 1 );
	level.restore_flashlight_function = true;
}

keep_some_light_on()
{
	player = get_players()[0];
	old_light_status = player.flashlight_on;
	if( old_light_status == true )
	{
		player clientNotify( "flahslight_off" );
		// keep light on
		while( level.restore_flashlight_function == false )
		{
			maps\createart\creek_1_art::set_standard_flashlight_values();
			//iprintlnbold( "on" );
			wait( 0.05 );
		}
	}
}

room_1_vc_death( vc, anim_node )
{
	anim_node anim_single_aligned( vc, "death_drop" );	
	vc dodamage( vc.health + 1, level.reznov.origin, level.reznov );
	vc StartRagdoll();
}

b4_tunnel_player_drop_anim()
{
	player = get_players()[0];
	
	level thread delayed_trigger_use_tunnel();
	
	guys = [];
	guys[0] = level.barnes;
	guys[1] = level.hudson;
	
	player PlayRumbleOnEntity( "damage_heavy" );
	
	anim_node = getstruct( "anim_b4_tunnel", "targetname" );
	
	anim_node thread anim_single_aligned( guys, "tunnel_entrance_C" );
	// flashlight
	level thread flashlight_toss( anim_node );
	// player
	player DisableWeapons();
	level thread temp_change_tunnel_light();
	
	level thread maps\createart\creek_1_art::dof_change_looking_at_woods_from_hole();
	play_player_fullbody_anim_simple( anim_node, "tunnel_entrance" );
	
	// teleport AIs away
	teleport_node = getnode( "b4_barnes_gate_kick_node", "targetname" );
	level.barnes forceteleport( teleport_node.origin, teleport_node.angles );
	
	player take_player_weapons();
	player GiveWeapon( "creek_flashlight_pistol_sp", 0 );
	player GiveWeapon( "knife_sp", 0 );
	player GiveMaxAmmo( "creek_flashlight_pistol_sp" );
	player SwitchToWeapon( "creek_flashlight_pistol_sp" );
	player EnableWeapons();
	
	level notify( "tunnel_visionset_change" );
	
	flag_set( "b4_player_inside_tunnel" );
	
	//wait( 1 );
	//SetSavedDvar( "r_enableFlashlight","1" );          
}

delayed_trigger_use_tunnel()
{
	wait( 6 );
	trigger_use( "tunnel_entrance_hueys_2" );
}

temp_change_tunnel_light()
{
	wait( 12 );
	
	SetSavedDvar( "r_enableFlashlight","1" );   
	maps\createart\creek_1_art::set_dim_flashlight_values(); 
	player = get_players()[0];
	player maps\_art::setdefaultdepthoffield();
}

vo_at_tunnel_entrance()
{
	level endon( "player_entered_tunnel" );
}

b4_tunnel_door_kick( guy )
{
	//Exploder( 3004 );
	level notify( "b4_gate_kick_done" );	
	door = getent( "b4_village_end_gate", "targetname" );
	
	/*
	rotate_pos_1 = getstruct( "b4_gate_swing_1", "targetname" );
	rotate_pos_2 = getstruct( "b4_gate_swing_2", "targetname" );
	
	door rotateto( rotate_pos_1.angles, 0.7, 0.05, 0.4 );
	door moveto( rotate_pos_1.origin, 0.7, 0.05, 0.4 );
	door waittill( "rotatedone" );
	
	door rotateto( rotate_pos_2.angles, 0.3, 0.1, 0.2 );
	door moveto( rotate_pos_2.origin, 0.3, 0.1, 0.2 );
	*/
	autosave_by_name( "creek_1_b4tdk" );
}

b4_tunnel_grenade_spawn( guy )
{	
	// add choppers
	trigger_use( "tunnel_entrance_hueys" );
	
	grenade = getent( "b4_grenade_toss", "targetname" );
	// attach this to barnes' tag_weapon_left
	
	grenade.origin = level.barnes GetTagOrigin( "tag_weapon_left" );
	grenade.angles = level.barnes GetTagAngles( "tag_weapon_left" );
	grenade Linkto( level.barnes, "tag_weapon_left" );
}

b4_tunnel_grenade_explode( guy )
{
	
	Exploder( 3005 );
	grenade = getent( "b4_grenade_toss", "targetname" );
	grenade delete();
	
	hatch = getent( "fxanim_creek_cover_mod", "targetname" );
	//hatch hide();
	//hatch notsolid();
	
	if( isdefined( hatch ) )
	{
		hatch PlaySound( "evt_b04_tunnel_explo" );
	}
	
	//pos = getstruct( "b4_objective_pos_2", "targetname" );
	//playfx( level._effect["big_explosion"], pos.origin + ( 0, 0, -150 ) );
	
	// drop a dead VC inside
	vcs = simple_spawn( "vc_tunnel_gib" );
	for( i = 0; i < vcs.size; i++ )
	{
		vcs[i].force_gib = true;
		vcs[i].custom_gib_refs = [];
		vcs[i].custom_gib_refs[0] = vcs[i].script_noteworthy;
		vcs[i] ai_suicide();
	}
	
	//wait( 1 );
	wait( 0.5 );
	level notify( "tunnel_open" );
	level notify( "b4_tunnel_open" );
}

#using_animtree ( "creek_1" );
flashlight_toss( anim_node )
{
	linker = Spawn( "script_model", anim_node.origin );
	linker.angles = anim_node.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "flashlight";
	linker UseAnimTree( #animtree );
	
	flashlight = getent( "b4_flashlight_toss", "targetname" );
	flashlight show();
	flashlight.origin = linker GetTagOrigin( "origin_animate_jnt" );
	flashlight.angles = linker GetTagAngles( "origin_animate_jnt" );
	flashlight linkto( linker, "origin_animate_jnt" );
	
	anim_node anim_Single_aligned( linker, "toss" );
	flashlight unlink();
	flashlight delete();
	linker delete();
}

//player waittill( "grenade_fire", grenadeent, weaponname );
//grenadeent ResetMissileDetonationTime( 1 );

creek_rice_vc_object_anim_single( anim_node, animation ) // -- WWILLIAMS: RUNS ON A SCRIPT MODEL TO PLAY AN ANIM
{
	//self StopUseAnimTree();
	self UseAnimTree( #animtree );
	//self ClearAnim( %root, 0 );
	anim_node anim_single_aligned( self, animation );
}

#using_animtree ("generic_human");
b2_rice_surprise()
{
	level.vc_rice endon( "death" );
	
	anim_node = getstruct( "anim_b2_rice_guy", "targetname" );
	
	level.vc_rice_bowl = GetEnt( "b2_rice_bowl", "targetname" );
	level.vc_rice_bowl.animname = "bowl";

	level.vc_rice_chopstick1 = GetEnt( "b2_chopstick_1", "targetname" );
	level.vc_rice_chopstick1.animname = "chopstick1";

	
	level.vc_rice_chopstick2 = GetEnt( "b2_chopstick_2", "targetname" );
	level.vc_rice_chopstick2.animname = "chopstick2";
	

	level.vc_rice thread beat2_player_alerted_rice_vc( anim_node );
	
	level thread beat2_contextual_attack_message();	
	
	level endon( "rice_stop_looping" );
	
	while( 1 )
	{		
		level.vc_rice_bowl thread creek_rice_vc_object_anim_single( anim_node, "curtain_open" );
		level.vc_rice_chopstick1 thread creek_rice_vc_object_anim_single( anim_node, "curtain_open" );
		level.vc_rice_chopstick2 thread creek_rice_vc_object_anim_single( anim_node, "curtain_open" );
		anim_node anim_single_aligned( level.vc_rice, "curtain_open" );
	}
}

#using_animtree ("generic_human");
beat2_vc_rice_attack_opportunity( anim_node ) // -- WWILLIAMS: PLAYS THE REACTION ANIMATION TO THE PLAYER
{
	// level.vc_rice endon( "death" );
	
	AssertEx( IsDefined( anim_node ), "anim_node for rice react not defined" );
	
	// -- WWILLIAMS: ATTACK OPPORTUNITY
	level.vc_rice_bowl thread creek_rice_vc_object_anim_single( anim_node, "attack_opportunity" );
	level.vc_rice_chopstick1 thread creek_rice_vc_object_anim_single( anim_node, "attack_opportunity" );
	level.vc_rice_chopstick2 thread creek_rice_vc_object_anim_single( anim_node, "attack_opportunity" );
	anim_node anim_single_aligned( level.vc_rice, "attack_opportunity" );
	
	flag_clear( "beat2_rice_attack_opportunity" );
}

#using_animtree ("generic_human");
beat2_vc_rice_melee_kill( anim_node ) // -- WWILLIAMS: PLAYER HITS R3 BEFORE THE VC FINISHES ATTACK OPPORTUNITY
{
	// level.vc_rice endon( "death" );
	
	AssertEx( IsDefined( anim_node ), "anim_node for melee_kill not defined" );
	
	players = get_players();

	players[0] AllowMelee( false );
	players[0] DisableWeapons();
	players[0] HideViewModel();
	level.vc_rice_bowl thread creek_rice_vc_object_anim_single( anim_node, "melee_kill" );
	level.vc_rice_chopstick1 thread creek_rice_vc_object_anim_single( anim_node, "melee_kill" );
	level.vc_rice_chopstick2 thread creek_rice_vc_object_anim_single( anim_node, "melee_kill" );

	level thread play_player_fullbody_anim_simple( anim_node, "melee_kill", 0 );
	players[0].anim_hands Attach( "t5_knife_sog", "tag_weapon", true );
	
	anim_node anim_single_aligned( level.vc_rice, "melee_kill" );
	
	level.vc_stealth_killed++;
	
	players = get_players();
	players[0] AllowMelee( true );
	players[0] EnableWeapons();
	players[0] ShowViewModel();
}

#using_animtree ("generic_human");
beat2_vc_rice_melee_fail( anim_node ) // -- WWILLIAMS: PLAYER MISSES CONTEXTUAL MELEE CHANCE
{
	
	AssertEx( IsDefined( anim_node ), "anim_node for melee_kill not defined" );

	level.vc_rice_bowl thread creek_rice_vc_object_anim_single( anim_node, "melee_fail" );
	level.vc_rice_chopstick1 thread creek_rice_vc_object_anim_single( anim_node, "melee_fail" );
	level.vc_rice_chopstick2 thread creek_rice_vc_object_anim_single( anim_node, "melee_fail" );
	anim_node anim_single_aligned( level.vc_rice, "melee_fail" );
}

beat2_player_alerted_rice_vc( anim_node ) // -- WWILLIAMS: TRACKS THE PLAYER, IF HANGING AROUND TOO LONG RICE GUY REACTS
{
	self endon( "death" );
	level endon( "player_rice_melee_successful" );
	
	level thread delete_chopsticks_when_i_die( self );
	
	too_close_trigger = GetEnt( "b2_loiter_trigger", "targetname" );
	
	too_close_trigger waittill( "trigger" );
	
	players = get_players();
	players[0] SetScriptHintString( "" );
	//screen_message_delete();
	player = get_players()[0];
	player AllowMelee( true );
	
	flag_set( "beat2_rice_vc_alert" );
	
	level notify( "rice_stop_looping" );
	
	// -- PLAY ATTACK OPPORTUNITY ANIMATION
	level beat2_vc_rice_attack_opportunity( anim_node );
	
	// -- PLAYER MISSED CHANCE TO CONTEXTUAL MELEE
	level beat2_vc_rice_melee_fail( anim_node );
}

delete_chopsticks_when_i_die( guy )
{
	guy waittill( "death" );
	
	delete_chopsticks();
}

delete_chopsticks()
{
	if( isdefined( level.vc_rice_bowl ) )
	{
		level.vc_rice_bowl delete();
	}
	if( isdefined( level.vc_rice_chopstick1 ) )
	{
		level.vc_rice_chopstick1 delete();
	}
	if( isdefined( level.vc_rice_chopstick2 ) )
	{
		level.vc_rice_chopstick2 delete();
	}
}

beat2_contextual_attack_message() // -- WWILLIAMS: DISPLAYS THE MELEE SCREEN MESSAGE WHILE THE CONTEXTUAL IS STILL VALID
{
	level endon( "beat2_rice_vc_alert" );
	level.vc_rice endon( "death" );
	
	// objects
	contextual_trigger = GetEnt( "b2_rice_contextual", "targetname" );
	anim_node = getstruct( "anim_b2_rice_guy", "targetname" );
	message_created = false;
	players = get_players();
	
	level thread force_fail_after_timer( contextual_trigger );
	
	// display meesage while player is touching the trigger
	while( 1 )
	{
		if( players[0] IsTouching( contextual_trigger ) )
		{
			if( !message_created )
			{
				// -- WWILLIAMS: USING THE SAME STRING AS THE SAMPAN MELEE
				players = get_players();
				players[0] AllowMelee( false );
				//players[0] SetScriptHintString( &"CREEK_1_PRESS_L3" );
				players[0] SetScriptHintString( "" );
				//screen_message_create( &"CREEK_1_PRESS_L3" ); 
				message_created = true;
			}
		}
		else
		{
			if( message_created )
			{	
				players = get_players();
				players[0] SetScriptHintString( "" );
				//screen_message_delete();
				message_created = false;
				players[0] AllowMelee( true );
			}
		}

		if( message_created &&  players[0] MeleeButtonPressed() )
		{
			players = get_players();
			players[0] SetScriptHintString( "" );
			//screen_message_delete();
			level notify( "player_rice_melee_successful" );
			// -- THIS IS WHERE THE PASS ATTACK SCRIPT SHOULD FIRE
			level thread beat2_vc_rice_melee_kill( anim_node );
			players[0] AllowMelee( true );
			return;
		}
		
		wait(0.05);
	}
	
	// -- TODO: WWILLIAMS: CLEAN UP THE SPAWNER AND TRIGGER
}

force_fail_after_timer( contextual_trigger )
{
	contextual_trigger waittill( "trigger" );
	wait( 4 );
	trigger_use( "b2_loiter_trigger" );
}

beat2_play_rice_vc_prop_anim( anim_node, array_props, str_animation )
{
	array_thread( array_props, ::creek_rice_vc_object_anim_single, anim_node, str_animation );
}


#using_animtree ("generic_human");
anim_player_opening_curtain( anim_node )
{
	player = get_players()[0];
	player DisableWeapons();

	play_player_fullbody_anim_special( anim_node, "rice_surprise", 0.3 );
	player EnableWeapons();
}

b4_peek_vc()
{
	vc = simple_spawn_single( "b4_peek_vc" );
	vc thread flashlight_vc_behavior();
	
	vc.health = 1;
	vc.goalradius = 16;

	vc go_to_node_by_name( "b4_peek_cover" );

}

window_look_safe( guy )
{
	player = get_players()[0];
	level notify( "window_safe" );
}

play_rice_bowl_drop_anim( anim_node )
{
	bowl = getent( "b2_rice_bowl", "targetname" );
	chopstick1 = getent( "b2_chopstick_1", "targetname" );
	chopstick2 = getent( "b2_chopstick_2", "targetname" );
	bowl.animname = "bowl";
	chopstick1.animname = "chopstick1";
	chopstick2.animname = "chopstick2";
	
	anim_node = getstruct( "anim_b2_rice_guy", "targetname" );
	level thread play_creek_object_anim_single_frameskip( bowl, anim_node, "drop", 60, 161 );
	level thread play_creek_object_anim_single_frameskip( chopstick1, anim_node, "drop", 60, 161 );
	level thread play_creek_object_anim_single_frameskip( chopstick2, anim_node, "drop", 60, 161 );
	
	level waittill( "delete_chopsticks" );
	bowl delete();
	chopstick1 delete();
	chopstick2 delete();
}

barnes_hut_regroup_walk()
{
	level.barnes clear_run_anim();
	
	// make Woods use standard run anim here
	level.barnes set_run_anim( "standard_run" );

	end_node = GetNode( "b2_barnes_stealth_node_9", "targetname" );
	
	cover_node = getstruct( "anim_b2_regroup_hut_new", "targetname" );
	cover_node anim_reach_aligned( level.barnes, "regroup_hut_walk" );	

	// set cover as goal so he transitions smoothly into it after the scripted anim
	level.barnes SetGoalNode( end_node );

	level thread regrop_woods_communication();
	
	// animate first frame
	actual_door = getent( "regroup_hut_door_model", "targetname" );
	actual_door.animname = "regroup_gate";
	actual_door thread play_delayed_opening_audio();
	level thread maps\creek_1_anim::play_creek_object_anim_single( actual_door, cover_node, "open" );
	
	cover_node anim_single_aligned( level.barnes, "regroup_hut_walk" );	
	level thread maps\creek_1_anim::play_creek_object_anim_loop( actual_door, cover_node, "open_idle" );
	
	// delete the temp door
	blocker = getent( "regroup_hut_door_l_blocker", "targetname" );
	if( isdefined( blocker ) )
	{
		blocker delete();
	}
	
	flag_set( "b2_ready_for_regroup" );
}
play_delayed_opening_audio()
{
    wait(3);
    self PlaySound( "fly_window_open_00" );
}

regrop_woods_communication()
{
	wait( 1.5 );
	player = get_players()[0];
	player say_dialogue( "explosions_are_primed" );
	player say_dialogue( "seirra_in_position" );
	player say_dialogue( "whiskey_ready" );
	level.barnes say_dialogue( "xray_is_inbound" );
}

b2_rice_grab_gun( guy )
{
	guy.ignoreall = false;
	guy	gun_switchto( "ak47_sp", "right" );
	guy.script_nodropweapon = 0;
		
	gun_model = getent( "b2_vc_rice_gun", "targetname" );
	if( isdefined( gun_model ) )
	{
		gun_model delete();
	}
}

b2_rice_drop_bowl( guy )
{
	level notify( "delete_chopsticks" );
}

water_splash_enter( guy )
{
//	level thread maps\creek_1_fx::barnes_get_in_out_water( 0 );
}

water_splash_exit( guy )
{
//	level thread maps\creek_1_fx::barnes_get_in_out_water( 0 );
}

start_barnes_sampan_swim( guy )
{
	level notify( "player_move_gap_done" );
	autosave_by_name( "creek_1_sbss" );
}

melee_player_attach_knife( guy )
{
	player = get_players()[0];
	
	player.anim_hands Attach( "t5_knife_sog", "tag_weapon", true );
}

melee_player_detach_knife( guy )
{
	player = get_players()[0];
}

b2_falling_guy_hit_water( guy )
{
		guy thread maps\creek_1_fx::play_guy_falling_water_death_fx();
}

play_guy_falling_water_death( guy )
{
	guy gun_remove();
	
	anim_node = getstruct( "anim_b2_falling_guy_2", "targetname" );
	anim_node anim_single_aligned( guy, "fall_death" );	

}

melee_sampan_water_hit( guy )
{
	pos = level.vc_sampan_2 GetTagOrigin( "tag_stowed_back" );
	water_height = GetWaterHeight( pos );
	water_pos = ( pos[0], pos[1], water_height );

	playfx( level._effect["water_drop_splash"], water_pos );
	
	// play this at a bunch of places
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Wrist_LE" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Wrist_RI" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Elbow_LE" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Elbow_RI" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Ankle_LE" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Ankle_RI" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Knee_LE" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Knee_RI" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Hip_LE" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Hip_RI" );
	playfxontag( level._effect["falling_water_bubbles"], level.vc_sampan_2, "J_Head" );

}

melee_sampan_neck_stab( guy )
{
	get_players()[0] PlayRumbleOnEntity( "grenade_rumble" );
	if( is_mature() )
	{
		playfxontag( level._effect["neck_stab_blood"], level.vc_sampan_2, "J_NECK" );
	}
}

melee_sampan_bubbles( guy )
{
	
}

b4_tunnel_reznov_landing( guy )
{
	exploder( 3009 ); // want this changed
}

b4_tunnel_reznov_drown_stab1( guy )
{
	
}

b4_tunnel_reznov_drown_stab2( guy )
{
	// disable blood fx for mature
	if( is_mature() )
	{
		exploder( 3012 );
	}
}

b4_tunnel_reznov_drown_wall1( guy )
{
	exploder( 3013 );
}

b4_tunnel_reznov_drown_wall2( guy )
{
	exploder( 3014 );
}

b4_tunnel_reznov_drown_splash( guy )
{
	exploder( 3010 );
	wait( 0.5 );
	exploder( 3011 );
}

b4_tunnel_reznov_drown_swipe( guy )
{
	wait( 0.5 );
	blocker = getent( "drown_vc_clip", "targetname" );
	blocker delete();
}

b4_tunnel_splash_left_step( guy )
{
	tag_used = "J_ANKLE_LE";
	pos = guy GetTagOrigin( tag_used );
	water_height = GetWaterHeight( pos );
	pos = ( pos[0], pos[1], water_height );
	playfx( level._effect["tunnel_step_water"], pos );
}

b4_tunnel_splash_right_step( guy )
{
	tag_used = "J_ANKLE_RI";
	pos = guy GetTagOrigin( tag_used );
	water_height = GetWaterHeight( pos );
	pos = ( pos[0], pos[1], water_height );
	playfx( level._effect["tunnel_step_water"], pos );
}

plant_bomb_detach( guy )
{
	player = get_players()[0];
	player.explosive_charge_model unlink();
	//iprintlnbold( player.explosive_charge_model.origin );
	//iprintlnbold( player.explosive_charge_model.angles );
}

play_player_setting_bomb_anim( explosive_charge )
{
	player = get_players()[0];
	player DisableWeapons();
	player hide_swimming_arms();
	player clientnotify( "force_hide_swimming_arms" );

	wait( 0.1 );
	anim_node = spawn( "script_origin", ( -27015, 37002.3, -236.5 ) );
	anim_node.angles = ( 0, 289.1, 0 );
	
	level thread play_player_hands_anim_simple( anim_node, "bomb_plant", 0.6 );
	
	explosive_charge.origin = player.anim_hands GetTagOrigin( "tag_weapon" );
	explosive_charge.angles = player.anim_hands GetTagAngles( "tag_weapon" );
	explosive_charge LinkTo( player.anim_hands, "tag_weapon" );
	explosive_charge show();
	player.explosive_charge_model = explosive_charge;
	
	player waittill( "anim_complete" );
	player EnableWeapons();
	player show_swimming_arms();
	player clientnotify( "force_show_swimming_arms" );
}

play_player_setting_bomb_anim_2()
{
	explosive_charge_obj = getent( "b2_satchel_old_2", "targetname" );
	explosive_charge_obj delete();
	
	player = get_players()[0];

	player take_player_weapons();
	player DisableWeapons();

	player hide_swimming_arms();
	player clientnotify( "force_hide_swimming_arms" );
	wait( 0.1 );
	anim_node = getstruct( "anim_2nd_c4_node", "targetname" );
	
	level thread play_player_hands_anim_simple( anim_node, "bomb_plant_2", 0.6 );
	
	explosive_charge = getent( "b2_satchel_2", "targetname" );
	explosive_charge.origin = player.anim_hands GetTagOrigin( "tag_weapon" );
	explosive_charge.angles = player.anim_hands GetTagAngles( "tag_weapon" );
	explosive_charge LinkTo( player.anim_hands, "tag_weapon" );
	explosive_charge show();
	
	player waittill( "anim_complete" );
	
	player clientNotify( "set_creek_rain_visionset" );
	VisionSetNaked( "creek_1_rain", 0 );
	
	explosive_charge unlink();
	//iprintlnbold( explosive_charge.origin );
	//iprintlnbold( explosive_charge.angles );
	player giveback_player_weapons();
	player EnableWeapons();
	player show_swimming_arms();
	player clientnotify( "force_show_swimming_arms" );
}

b4_use_stab_death_anim( guy )
{
	self.health = 1;
	self.allowdeath = 1;
	self.deathanim = %ch_creek_b04_tunnel_VC_death2;
	
	guy.health = 1;
	guy.allowdeath = 1;
	guy.deathanim = %ch_creek_b04_tunnel_VC_death2;
}

b4_use_crouch_death_anim( guy )
{
	self.allowdeath = 1;
	self.deathanim = %ch_creek_b04_tunnel_VC_death1;	
	
	guy.allowdeath = 1;
	guy.deathanim = %ch_creek_b04_tunnel_VC_death1;
}

player_hit_rock_1( guy )
{
	level notify( "player_hit_breakout_1" );
	exploder( 5020 );
}

player_hit_rock_2( guy )
{
	level notify( "player_hit_breakout_2" );
	exploder( 5020 );
}

player_hit_rock_3( guy )
{
	level notify( "player_hit_breakout_3" );
	exploder( 5020 );
	exploder( 5021 );
}

player_grabs_woods( guy )
{
	flag_set( "creek_ending_fade" );
}


#using_animtree ("player");

//*****************************
//      AUDIO SCRIPTS
//*****************************

temp_hammock_melee_death_audio()
{
    self PlaySound( "fly_human_grab" );
    self PlaySound( "fly_quickmmt_cloth" );
    wait(.35);
    self PlaySound( "vox_ctxt_melee_hand_over_mouth" );
    wait(.25);
    self PlaySound( "fly_knife_stab" );
    self PlaySound( "vox_ctxt_melee_gack_lng" );
    self PlaySound( "fly_cloth_struggle" );
    wait(2);
    self PlaySound( "fly_knife_pull" );
    self PlaySound( "fly_quickmmt_cloth" );
}

temp_hammock_melee_death_audio_npc()
{
    wait(2.6);
    self PlaySound( "fly_human_grab_npc" );
    self PlaySound( "fly_quickmmt_cloth_npc" );
    self PlaySound( "vox_ctxt_melee_hand_over_mouth" );
    wait(.6);
    self PlaySound( "fly_knife_stab_npc" );
    self PlaySound( "vox_ctxt_melee_gack_sht" );
    self PlaySound( "fly_quickmmt_cloth_npc" );
    wait(.5);
    self PlaySound( "fly_knife_pull_npc" );
    self PlaySound( "fly_quickmmt_cloth_npc" );
}


// blood fx for contextual melees
play_vc1_kill_blood_fx( guy )
{
	if( is_mature() )
	{
		fx_tag = "J_Neck";
		playFxOnTag( level._effect["melee_blood"], guy, fx_tag );
	}
}

play_vc2_kill_blood_fx( guy )
{
	get_players()[0] PlayRumbleOnEntity( "grenade_rumble" );
	if( is_mature() )
	{
		fx_tag = "J_Neck";
		playFxOnTag( level._effect["melee_blood"], guy, fx_tag );
	}
}

play_vc_rice_kill_blood_fx( guy )
{
	get_players()[0] PlayRumbleOnEntity( "grenade_rumble" );
	if( is_mature() )
	{
		fx_tag = "J_Spine4";
		playFxOnTag( level._effect["melee_rice"], guy, fx_tag );
	}
}

play_m202_guy_kill_blood_fx( guy )
{
	if( is_mature() )
	{
		fx_tag = "J_Spine4";
		playFxOnTag( level._effect["m202_death"], guy, fx_tag );
	}
}

play_swift_kill_blood_fx( guy )
{
	//TUEY Play single shot music stinger
	playsoundatposition ("mus_hits04_swift", (0,0,0));
	
	if( is_mature() )
	{
		guy SetClientFlag(level.CLIENT_SWIFT_BLEED);
		
		fx_tag = "J_Neck";
		playFxOnTag( level._effect["swift_death"], guy, fx_tag );
	}
}

prepare_water_gate_idle()
{
	anim_node = getstruct( "anim_2nd_c4_node", "targetname" );
	level.water_gate = getent( "b2_underwater_gate", "targetname" );
	level.water_gate.animname = "water_gate";

	level thread play_creek_object_anim_firstframe( level.water_gate, anim_node, "open" );
}

open_water_gate( guy )
{
	gate_blocker = getent( "b2_underwater_gate_block", "targetname" );
	gate_blocker delete();
	
	anim_node = getstruct( "anim_2nd_c4_node", "targetname" );
	playsoundatposition( "evt_underwater_gate_open", (0,0,0) );
	play_creek_object_anim_single( level.water_gate, anim_node, "open" );
}

put_away_reznov_gun_lair( guy )
{
	level.reznov gun_remove();
}

put_back_reznov_gun_lair( guy )
{
	level.reznov animscripts\anims::clearAnimCache();
	level.reznov gun_switchto( "m1911_sp", "right" );
}

wa_room_exit_kick_open( guy )
{	
	door = getent( "war_room_exit", "targetname" );
	if( isdefined( door ) )
	{
		door delete();
	}
	level notify( "warroom_door_kick_start" );
}

tunnel_crawl_rock_swap( guy )
{
	flag_set( "cave_rock_swap" );
}

delete_regroup_door( guy )
{
	blocker = getent( "regroup_hut_door_l_blocker", "targetname" );
	if( isdefined( blocker ) )
	{
		blocker delete();
	}
	flag_set( "b2_ready_for_regroup" );
}

tunnel_shelf_mason_vo( guy )
{
	player = get_players()[0];
	player thread say_dialogue( "swift_dead" );
}

turn_on_radio_reznov_lair( guy )
{
	level notify( "turn_on_radio" );
}