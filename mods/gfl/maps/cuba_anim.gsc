#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\cuba_util;

// --------------------------------------------------------------------------------
// ---- Bar scene animations main ----
// --------------------------------------------------------------------------------

#using_animtree("generic_human");
main()
{
	setup_driving_anims();

	setup_player_anims();	// player

	setup_bowman_anims();	// bowman
	
	setup_woods_anims();	// woods

	setup_carlos_anims();	// carlos

	setup_ai_anims();		// ai

	setup_prop_anims();
	
	setup_airfield_trucks();

	setup_dialogues();		// setup all non-animation dialogues here

	setup_car_anims();
	
	//setup_dialogue_loops();
}


// --------------------------------------------------------------------------------
// ---- patrol animation override ----
// we are only using few animations for patrol to save memory
// --------------------------------------------------------------------------------
cuba_patrol_anims()
{
	AssertEx( IsDefined( level._patrol_init ), "Keep this function call after maps\_patrol::init function" );

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk;
}

// --------------------------------------------------------------------------------
// ---- Player ----
// --------------------------------------------------------------------------------
#using_animtree("cuba");
setup_player_anims()
{
	// player full animated body
	level.scr_animtree["player_hands"] 	        	= #animtree;
	level.scr_model["player_hands"] 		    	= "t5_gfl_ump45_viewbody";

	// zipline
	level.scr_anim["player_hands"]["zipline_entry"]		= %int_zip_entry_player;
	level.scr_anim["player_hands"]["zipline_idle"][0]	= %int_zip_entry_loop_player;
	level.scr_anim["player_hands"]["zipline_exit"]		= %int_zip_exit_player;
	addnotetrack_customfunction( "player_hands", "snap_AI", maps\cuba_zipline::start_ai_exit, "zipline_exit" ); 
	addnotetrack_customfunction( "player_hands", "ground_impact", maps\cuba_zipline::player_on_ground, "zipline_exit" ); 

	// door breach before assasination
	level.scr_anim["player_hands"]["door_breach_big_room"]	 = %ch_cuba_b02_door_breach_player;
	addnotetrack_customfunction( "player_hands", "give_gun", maps\cuba_assasination::big_room_lowready_off, "door_breach_big_room" ); 
	
	// assasination
	level.scr_anim["player_hands"]["assasination_part1"]	 = %ch_cuba_b02_castro_assassination_part1_player;
	addnotetrack_customfunction( "player_hands", "give_gun", maps\cuba_assasination::assasin_lowready_off, "assasination_part1" ); 
	level.scr_anim["player_hands"]["assasination_part2a"]	 = %ch_cuba_b02_castro_assassination_part2a_player;
	level.scr_anim["player_hands"]["assasination_part2b"]	 = %ch_cuba_b02_castro_assassination_part2b_player;

	level.scr_anim["player_hands"]["player_caught"]		 	 = %ch_b04_getting_caught_player;
	level.scr_anim["player_hands"]["get_on_plane"] 			 = %ch_b04_get_on_plane_player;
	level.scr_anim["player_hands"]["launch"]				 = %ch_b04_launch_from_plane_player;
	level.scr_anim["player_hands"]["your_dead"] 			 = %ch_b04_youre_dead_player;
	
	level.scr_animtree["rappel_hands"] = #animtree;	
	level.scr_model["rappel_hands"]							= "t5_gfl_ump45_viewmodel_player";	
	level.scr_anim["rappel_hands"]["forward_rappel"] 		 = %int_forward_rappel;
	
	level.scr_animtree["rope"] = #animtree;
	
	//idles
	level.scr_anim["left_rope"]["rappel_idle"][0] 	 	 =	%o_forward_rappel_leftguy_rope_idle;
	level.scr_anim["right_rope"]["rappel_idle"][0] 		 =	%o_forward_rappel_rightguy_rope_idle;
	level.scr_anim["rope"]["rappel_idle"][0] 			 =	%o_forward_rappel_rope_idle;
	
	//forward rappel
	level.scr_anim["rope"]["forward_rappel"] 		 	 =	%o_forward_rappel_rope;
	level.scr_anim["left_rope"]["forward_rappel"] 		 =	%o_forward_rappel_leftguy_rope;
	level.scr_anim["right_rope"]["forward_rappel"] 		 =	%o_forward_rappel_rightguy_rope;
	
	addnotetrack_customfunction( "rappel_hands", "land", maps\cuba_airfield::player_rappel_land, "forward_rappel" ); 
	addnotetrack_customfunction( "player_hands", "impact", maps\cuba_airfield::player_caught_impact, "player_caught" ); 
	
}

setup_prop_anims()
{
	// crossbow
	level.scr_animtree["crossbow"]  = #animtree;
	//level.scr_model["crossbow"] = "tag_origin_animate";
	level.scr_anim["crossbow"]["bowman_setup"][0]  = %o_zipline_crossbow_align_bowman;
	level.scr_anim["crossbow"]["woods_setup"][0]   = %o_zipline_crossbow_align_woods;

	level.scr_animtree["woman_gun"]  = #animtree;
	level.scr_model["woman_gun"] = "tag_origin_animate";
	level.scr_anim["woman_gun"]["setup"][0]  = %o_cuba_b02_castro_assassination_shotgun_idle;
	
	level.scr_animtree["cabinet"]  = #animtree;
	level.scr_anim["cabinet"]["make_cover_left"] = %o_cuba_b02_make_cover_l_cabinet;
	level.scr_anim["cabinet"]["make_cover_right"] = %o_cuba_b02_make_cover_r_cabinet;

	level.scr_anim["table"]["shot_hit_table"] 	= %o_cuba_b02_shot_hit_table_prop;
}

#using_animtree("fxanim_props");
setup_airfield_trucks()
{
	level.scr_animtree["airfield_truck"]  = #animtree;
	level.scr_anim["airfield_truck"]["explode1"] = %fxanim_cuba_truck_gaz63_flip_anim;
	level.scr_anim["airfield_truck"]["explode2"] = %fxanim_cuba_truck_gaz63_flip_01_anim;
	level.scr_anim["airfield_truck"]["explode3"] = %fxanim_cuba_truck_gaz63_flip_02_anim;
}	

// --------------------------------------------------------------------------------
// ---- bowman ----
// --------------------------------------------------------------------------------
#using_animtree("generic_human");
setup_bowman_anims()
{
	level.scr_anim["bowman"]["dodge_car"] = %ch_cub_out_of_way_woods;

	level.scr_anim["bowman"]["heat_180"]	= %heat_stand_turn_180;

	//level.scr_anim["bowman"]["leapfrog1"]	= %ai_cuba_bowman_leapfrog_01;
	//level.scr_anim["bowman"]["leapfrog2"]	= %ai_cuba_bowman_leapfrog_02;

	// zipline idle
	level.scr_anim["bowman"]["zipline_in"] 		= %ch_zip_entry_bowman;
	addnotetrack_customfunction( "bowman", "crossbow_attach", maps\cuba_zipline::crossbow_attach, "zipline_in" ); 
	addnotetrack_customfunction( "bowman", "crossbow_detach", maps\cuba_zipline::crossbow_detach, "zipline_in" ); 
	addnotetrack_customfunction( "bowman", "carbiner_attach", maps\cuba_zipline::hook_attach, "zipline_in" ); 
	addnotetrack_customfunction( "bowman", "zip_fire", maps\cuba_zipline::rope_shoot_think, "zipline_in" ); 

	level.scr_anim["bowman"]["zipline_loop"][0] 	= %ch_zip_entry_idle_bowman;
	level.scr_anim["bowman"]["zipline_start"] 		= %ch_zip_entry2_line_bowman;
	level.scr_anim["bowman"]["zipline_idle"][0] 	= %ch_zip_idle_bowman;

	level.scr_anim["bowman"]["zipline_exit"] 		= %ch_zip_exit_bowman;

	addnotetrack_customfunction( "bowman", "detach_knife", maps\cuba_zipline::hook_detach, "zipline_exit" );
	addnotetrack_customfunction( "bowman", "ground_impact", maps\cuba_zipline::ai_on_ground, "zipline_exit" );

	// compound breach
	level.scr_anim["bowman"]["compound_breach_part1"] 	= %ch_cuba_b02_cuba_door_breach_1_bowman_reshoot;
	level.scr_anim["bowman"]["compound_breach_idle"][0] = %ch_cuba_b02_cuba_door_breach_1_bowman_reshoot_idle;
	level.scr_anim["bowman"]["compound_breach_part2"] 	= %ch_cuba_b02_cuba_door_breach_1_bowman_reshoot_crouch;
	addnotetrack_customfunction( "bowman", "anim_movement = \"DoorOpen\"", maps\cuba_compound::compound_breach_door_open, "compound_breach_part2" ); 
	
	// parking breach
	level.scr_anim["bowman"]["parking_breach"]	 	= %ch_cuba_b02_cuba_door_breach_2_bowman;
	addnotetrack_customfunction( "bowman","anim_movement = \"DoorOpen\"", maps\cuba_compound::parking_breach_door_open, "parking_breach" ); 
	addnotetrack_customfunction( "bowman","fire", maps\cuba_compound::parking_door_friendly_kill, "parking_breach" ); 
	
	// mansion breach
	level.scr_anim["bowman"]["mansion_breach"] 		= %ch_cuba_b02_climb_out_window_bowman_002;
	addnotetrack_customfunction( "bowman", "anim_movement = \"RightDoorOpen\"", maps\cuba_mansion::mansion_right_door, "mansion_breach" );	
	

	//temp riddled with bullets
	level.scr_anim["bowman"]["showdown"] 	 		 = %ch_b03_guard_riddled_bowman; 
	level.scr_anim["bowman_victim"]["showdown"] 	 = %ch_b03_guard_riddled_guard; 
	
	level.scr_anim["bowman"]["forward_rappel"] = %ai_forward_rappel_leftguy_rappel;	
	level.scr_anim["bowman"]["rappel_idle"][0] = %ai_forward_rappel_leftguy_idle;
	level.scr_anim["bowman"]["forward_rappel_arrive"] = %ai_forward_rappel_leftguy_trans_2_idle;
	


}

// --------------------------------------------------------------------------------
// ---- woods ----
// --------------------------------------------------------------------------------
setup_woods_anims()	
{
	//level.scr_anim["woods"]["clear_them_out"]	= %ch_cuba_b02_troops_signal_3;
	level.scr_sound["woods"]["clear_them_out"] = "vox_cub1_s01_032A_wood"; //Clear 'em out!  Move up the street!

	//level.scr_anim["woods"]["keep_moving"]	= %ch_cuba_b02_troops_signal_1;
	level.scr_sound["woods"]["keep_moving"]	= "vox_cub1_s01_514A_wood"; //Go - Keep moving!

	//level.scr_anim["woods"]["clear_them_out"]	= %ai_cuba_woods_signal_01;
// 	level.scr_anim["woods"]["clear_them_out"] 	= %ch_cuba_b02_troops_signal_2;
// 	level.scr_anim["woods"]["clear_them_out"]	= %ch_cuba_b02_troops_signal_4;
	
	level.scr_anim["woods"]["shoot_up_car"]	= %ai_cuba_woods_police01_kill;

	//level.scr_anim["woods"]["leapfrog1"]	= %ai_cuba_woods_leapfrog_01;
	//addnotetrack_customfunction("woods", "grenade_throw", maps\cuba_street::woods_grenade_toss, "leapfrog1");

	//level.scr_anim["woods"]["leapfrog2"]	= %ai_cuba_woods_leapfrog_02;

	level.scr_anim["woods"]["signal_stop"]	= %CQB_stand_signal_stop;
	level.scr_anim["woods"]["signal_onme"]	= %CQB_stand_wave_on_me;
	
	level.scr_anim["woods"]["heat_180"]		= %heat_stand_turn_180;

	// zipline
	level.scr_anim["woods"]["zipline_in"] 		= %ch_zip_entry_woods;
	addnotetrack_customfunction( "woods", "flare_start", maps\cuba_zipline::invasion_flare, "zipline_in" ); 
	addnotetrack_customfunction( "woods", "sndnt#vox_cub1_s01_044A_wood_m", maps\cuba_zipline::invasion_start, "zipline_in" ); 
	addnotetrack_customfunction( "woods", "crossbow_attach", maps\cuba_zipline::crossbow_attach, "zipline_in" ); 
	addnotetrack_customfunction( "woods", "crossbow_detach", maps\cuba_zipline::crossbow_detach, "zipline_in" ); 
	addnotetrack_customfunction( "woods", "carbiner_attach", maps\cuba_zipline::hook_attach, "zipline_in" ); 
	addnotetrack_customfunction( "woods", "zip_fire", maps\cuba_zipline::rope_shoot_think, "zipline_in" ); 

	level.scr_anim["woods"]["zipline_loop"][0] 	= %ch_zip_entry_idle_woods;
	level.scr_anim["woods"]["zipline_start"] 	= %ch_zip_entry2_line_woods;
	level.scr_anim["woods"]["zipline_idle"][0] 	= %ch_zip_idle_woods;
	level.scr_anim["woods"]["zipline_exit"] 	= %ch_zip_exit_woods;
	addnotetrack_customfunction( "woods", "carbiner_detach", maps\cuba_zipline::hook_detach, "zipline_exit" ); 
	addnotetrack_customfunction( "woods", "ground_impact", maps\cuba_zipline::ai_on_ground, "zipline_exit" ); 

	// compound breach
	level.scr_anim["woods"]["compound_breach"] 		= %ch_cuba_b02_cuba_door_breach_1_woods_reshoot;
	addnotetrack_customfunction( "woods", "start_bowman", maps\cuba_compound::compound_breach_bowman_open_door, "compound_breach" ); 

	// parking breach
	level.scr_anim["woods"]["parking_breach"]	 	= %ch_cuba_b02_cuba_door_breach_2_woods;
	addnotetrack_customfunction( "woods","fire", maps\cuba_compound::parking_door_friendly_kill, "parking_breach" ); 
	
	// mansion breach
	level.scr_anim["woods"]["mansion_breach"] 		= %ch_cuba_b02_climb_out_window_woods;
	addnotetrack_customfunction( "woods", "anim_movement = \"LeftDoorOpen\"", maps\cuba_mansion::mansion_left_door, "mansion_breach" ); 
	addnotetrack_customfunction( "woods", "start_bowman", maps\cuba_mansion::mansion_door_breach_bowman, "mansion_breach" ); 

	// door breach before assasination
	level.scr_anim["woods"]["door_breach_big_room"] 		= %ch_cuba_b02_door_breach_woods;
	level.scr_anim["woods"]["door_breach_big_room_wait"][0] = %ch_cuba_b02_door_breach_woods_loop;
	addnotetrack_customfunction( "woods", "door_open", maps\cuba_assasination::big_room_open_door, "door_breach_big_room" ); 
	
	// assasination
	//level.scr_anim["woods"]["assasination_arrival"] 	= %ch_cuba_b02_castro_stack_up_woods_intro_to_loop;
	level.scr_anim["woods"]["assasination_wait"][0] 	= %ch_cuba_b02_castro_stack_up_woods_loop;
	level.scr_anim["woods"]["assasination_part1"] 		= %ch_cuba_b02_castro_assassination_part1_woods;
	addnotetrack_customfunction( "woods", "door_open", maps\cuba_assasination::assasination_open_door, "assasination_part1" ); 

	level.scr_anim["woods"]["assasination_part2a"] 		= %ch_cuba_b02_castro_assassination_part2a_woods;
	addnotetrack_customfunction( "woods", "door_open", maps\cuba_assasination::post_assasination_open_door, "assasination_part2a" ); 
	level.scr_anim["woods"]["assasination_part2b"] 		= %ch_cuba_b02_castro_assassination_part2b_woods;
	addnotetrack_customfunction( "woods", "door_open", maps\cuba_assasination::post_assasination_open_door, "assasination_part2b" ); 
	addnotetrack_customfunction( "woods", "door_open", maps\cuba_assasination::post_assasination_player_response, "assasination_part2b" ); 

	level.scr_anim["woods"]["dodge_car"] = %ch_cub_out_of_way_bowman;
	
	//woods radios carlos in courtyard
	level.scr_anim["woods"]["radio_carlos"] 	= %ch_b03_radio_carlos_woods;
		
	//forward rappel
	level.scr_anim["woods"]["forward_rappel"] = %ai_forward_rappel_rightguy_rappel;
	level.scr_anim["woods"]["rappel_idle"][0] = %ai_forward_rappel_rightguy_idle;
	level.scr_anim["woods"]["forward_rappel_arrive"] = %ai_forward_rappel_rightguy_trans_2_idle;
}

// --------------------------------------------------------------------------------
// ---- carlos ----
// --------------------------------------------------------------------------------
setup_carlos_anims()
{
	level.scr_anim["carlos"]["alley_wait"] = %ch_cub_b01_wave_carlos_intro;
	level.scr_anim["carlos"]["alley_wait_loop"][0] = %ch_cub_b01_wave_carlos;

	level.scr_sound["carlos"]["see_you"] = "vox_cub1_s01_034B_carl_m";

	level.scr_sound["carlos"]["weapons_ready"] = "vox_cub1_s01_019B_carl_m"; //* Your weapons are ready.

	level.scr_sound["carlos"]["hurry"]		= "vox_cub1_s04_106A_carl"; //Hurry!!!
	level.scr_sound["carlos"]["run"]		= "vox_cub1_s04_107A_carl";	//Run!
	level.scr_sound["carlos"]["lets_move"]	= "vox_cub1_s01_206A_carl";	//Okay, let's move!
}

setup_ai_anims()
{
	// zipline guards idle animations
	level.scr_anim["guard_left"]["zipline_idle"][0] 	= %ch_zip_idle_guard_left;
	level.scr_anim["guard_right"]["zipline_idle"][0] 	= %ch_zip_idle_guard_right;
	
	// zipline guards death animations
	level.scr_anim["guard_left"]["zipline_exit"] 	= %ch_zip_death_guard_left;
	level.scr_anim["guard_right"]["zipline_exit"] 	= %ch_zip_death_guard_right;

	// contextual melee guard
	level.scr_anim["contextual_melee_guard"]["idle"][0] 	= %ch_b02_guard_in_building_loop;
	level.scr_anim["contextual_melee_guard"]["exit"]	 	= %ch_b02_guard_in_building_exit;	

	// turck guards in the compound
	level.scr_anim[ "compound_truck_guard_1" ][ "unload_loop" ][ 0 ] = %ch_wmd_b05_truckguards_loop_grd01;
	level.scr_anim[ "compound_truck_guard_1" ][ "unload_react" ] 	= %ch_wmd_b05_truckguards_alert_grd01;
	addNotetrack_customFunction("compound_truck_guard_1", "attach_reel", ::guard1_attach_reel, "unload_loop");
	addNotetrack_customFunction("compound_truck_guard_1", "attach_papers", ::guard1_attach_papers, "unload_loop");
	addNotetrack_customFunction("compound_truck_guard_1", "detach", ::guard1_detach, "unload_loop");
	
	level.scr_anim[ "compound_truck_guard_2" ][ "unload_loop" ][ 0 ] = %ch_wmd_b05_truckguards_loop_grd02;
	level.scr_anim[ "compound_truck_guard_2" ][ "unload_react" ] 	= %ch_wmd_b05_truckguards_alert_grd02;
	addNotetrack_customFunction("compound_truck_guard_2", "attach_papers", ::guard2_attach_papers, "unload_loop");
	addNotetrack_customFunction("compound_truck_guard_2", "detach", ::guard2_detach, "unload_loop");

	// troop signal animation
	level.scr_anim[ "troop_signal_ai" ][ "signal" ] = [];
	level.scr_anim[ "troop_signal_ai" ][ "signal" ][0]	= %ch_cuba_b02_troops_signal_2;
	level.scr_anim[ "troop_signal_ai" ][ "signal" ][1] 	= %ch_cuba_b02_troops_signal_2;
	level.scr_anim[ "troop_signal_ai" ][ "signal" ][2]	= %ch_cuba_b02_troops_signal_3;
	level.scr_anim[ "troop_signal_ai" ][ "signal" ][3]  = %ch_cuba_b02_troops_signal_4;

	// deathanims for enemies on staircase
	level.scr_anim[ "staircase_enemy1" ][ "death_anim" ]    = %ai_roof_death_05;
	//level.scr_anim[ "staircase_enemy2" ][ "death_anim" ] 	= %ai_death_stair_a;
	
	// compound special sprint patrol anims
	level.scr_anim["generic"]["sprint_patrol_0"] = %Juggernaut_sprint;
	level.scr_anim["generic"]["sprint_patrol_1"] = %ch_khe_E1B_troopssprint_1;
	level.scr_anim["generic"]["sprint_patrol_2"] = %ch_khe_E1B_troopssprint_2;
	level.scr_anim["generic"]["sprint_patrol_3"] = %ch_khe_E1B_troopssprint_3;
	level.scr_anim["generic"]["sprint_patrol_4"] = %ch_khe_E1B_troopssprint_4;
	level.scr_anim["generic"]["sprint_patrol_5"] = %ch_khe_E1B_troopssprint_5;
	level.scr_anim["generic"]["sprint_patrol_6"] = %ch_khe_E1B_troopssprint_6;
	level.scr_anim["generic"]["sprint_patrol_7"] = %ch_khe_E1B_troopssprint_7;

	level.scr_anim["generic"]["alley_grenade_death"] = array(%death_explosion_stand_F_v1, %death_explosion_stand_F_v2, %death_explosion_stand_F_v3);

	level.scr_anim["generic"]["death_twist"] = %exposed_death_twist;
	level.scr_anim["generic"]["react_1"] = %ch_cuba_b05_rifle_guy1_reaction; //turn around to face car - crouch, 180
	level.scr_anim["generic"]["react_2"] = %ch_cuba_b05_rifle_guy2_reaction; //turn around to face car - stand, 90 right
	
	level.scr_anim["guard_cabinet"]["mansion_breach"] = %ch_cuba_b02_climb_out_window_cabinet_death_guard;	
	addnotetrack_customfunction( "guard_cabinet", "physics_pulse", maps\cuba_mansion::cabinet_guard_pulse, "mansion_breach" ); 	

	level.scr_anim["guard_window"]["mansion_breach"] = %ch_cuba_b02_climb_out_window_win_death_guard;
	//level.scr_anim["guard_window"]["mansion_breach_death"] = %ch_cuba_b02_climb_out_window_win_death_guard_no_align
	addnotetrack_customfunction( "guard_window", "window_hit", maps\cuba_mansion::window_guard_hit, "mansion_breach" ); 	

	// enemy animations for big room breach
	level.scr_anim["big_room_guard1"]["idle"][0] = %ch_cuba_b02_assig_pre_guard1_idle;
	level.scr_anim["big_room_guard1"]["attack"]	 = %ch_cuba_b02_assig_pre_guard1_attack;	

	level.scr_anim["big_room_guard2"]["idle"][0] = %ch_cuba_b02_assig_pre_guard2_idle;
	level.scr_anim["big_room_guard2"]["attack"]	 = %ch_cuba_b02_assig_pre_guard2_attack;

	level.scr_anim["big_room_guard3"]["idle"][0] = %ch_cuba_b02_assig_pre_guard3_idle;
	level.scr_anim["big_room_guard3"]["attack"]    = %ch_cuba_b02_assig_pre_guard3_attack;
	addnotetrack_customfunction( "big_room_guard3", "timescale_slow", maps\cuba_assasination::big_room_start_slowmo, "attack" ); 
	
	// animations for dudes burning to death
	level.scr_anim["fire_death"] = [];
	level.scr_anim["fire_death"][0] = %exposed_death_neckgrab;
	level.scr_anim["fire_death"][1] = %wounded_bellycrawl_forward;
	level.scr_anim["fire_death"][2] = %ai_flame_death_a;
	level.scr_anim["fire_death"][3] = %ai_flame_death_c;
	

	// assasination castro
	level.scr_anim["castro"]["assasination_part1"] 			= %ch_cuba_b02_castro_assassination_part1_castro;
	addnotetrack_customfunction( "castro", "miss_shot", maps\cuba_assasination::castro_miss_player, "assasination_part1" ); 
	addnotetrack_customfunction( "castro", "kill_shot", maps\cuba_assasination::castro_kill_player, "assasination_part1" ); 

	level.scr_anim["castro"]["assasination_part2a"] 		= %ch_cuba_b02_castro_assassination_part2a_castro;
	addnotetrack_customfunction( "castro", "feathers", maps\cuba_assasination::castro_bed_feathers, "assasination_part2a" ); 
	level.scr_anim["castro"]["assasination_part2b"] 		= %ch_cuba_b02_castro_assassination_part2b_castro;
	addnotetrack_customfunction( "castro", "feathers", maps\cuba_assasination::castro_bed_feathers, "assasination_part2b" ); 

	level.scr_anim["castro"]["death_loop"][0] 				= %ch_cuba_b02_castro_assassination_castro_death_loop;
	
	// assasination woman
	level.scr_anim["castro_woman"]["assasination_part1"]    = %ch_cuba_b02_castro_assassination_part1_woman;
	level.scr_anim["castro_woman"]["assasination_part2a"]   = %ch_cuba_b02_castro_assassination_part2a_woman;
	level.scr_anim["castro_woman"]["assasination_part2b"]   = %ch_cuba_b02_castro_assassination_part2b_woman;

	//2 guys that get shot through the door post assassination
	level.scr_anim["castro_guard1"]["door_death"]	 = %ch_cuba_b02_castro_assassination_guard_right_death;
	level.scr_anim["castro_guard2"]["door_death"]    = %ch_cuba_b02_castro_assassination_guard_left_death;
		
				
	level.scr_anim["generic"]["flash_death"][0] = %exposed_flashbang_v1;
	level.scr_anim["generic"]["flash_death"][1] = %exposed_flashbang_v2;
	level.scr_anim["generic"]["flash_death"][2] = %exposed_flashbang_v3;
	level.scr_anim["generic"]["flash_death"][3] = %exposed_flashbang_v4;
	level.scr_anim["generic"]["flash_death"][4] = %exposed_flashbang_v5;

	//zpu anims
	level.scr_anim["aa_gunner_fire"]["fire"][0] = %crew_zpu4_fire;
	level.scr_anim["aa_gunner_idle"]["idle"] = %crew_zpu4_idle;

	//walk anim
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;

	//-- TEMP Death anims for guys near napalm traps and bunker explosion
	level.scr_anim["civ_explode"]["death_explode1"] 				 = %death_explosion_up10;
	level.scr_anim["civ_explode"]["death_explode2"] 			   	 = %death_explosion_back13;
	level.scr_anim["civ_explode"]["death_explode3"] 				 = %death_explosion_forward13;
	level.scr_anim["civ_explode"]["death_explode4"] 				 = %death_explosion_left11;
	level.scr_anim["civ_explode"]["death_explode5"]					 = %death_explosion_right13;

	
	//woods & bowman get on the plane
	level.scr_anim["bowman"]["get_on_plane"] = %ch_b04_get_on_plane_bowman;
	level.scr_anim["woods"]["get_on_plane"] = %ch_b04_get_on_plane_woods;
	
	//carlos waving for squad to come then getting on plane
	level.scr_anim["carlos"]["get_on_plane"] = %ch_b04_get_on_plane_carlos_exit;
	level.scr_anim["carlos"]["wait_for_squad"][0] = %ch_b04_get_on_plane_carlos_loop;
	
	//player gets bashed w/a rifle 
	level.scr_anim["basher"]["player_caught"] = %ch_b04_getting_caught_enemy;
	level.scr_anim["basher2"]["player_caught"] = %ch_b04_getting_caught_enemy2;
	
	//player awakens by the peir
	level.scr_anim["castro"]["your_dead"] = %ch_b04_youre_dead_castro;
	level.scr_anim["dragovich"]["your_dead"] = %ch_b04_youre_dead_dragovich;
	level.scr_anim["kravchenko"]["your_dead"] = %ch_b04_youre_dead_kravchenko;	
	addNotetrack_customFunction("castro", "puff_cigar", Maps\cuba_airfield::castro_cigar_fx, "your_dead");

	// bookshelf and table cover guys
	level.scr_anim["guy"]["make_cover_left"]    = %ch_cuba_b02_make_cover_L;	
	level.scr_anim["guy_2"]["make_cover_right"]    = %ch_cuba_b02_make_cover_L;	

	//sumeet's section
	level.scr_anim["guy"]["shot_hit_table"]    	= %ch_cuba_b02_shot_hit_table;	
	
	level.scr_anim["generic"]["door_kick"]    	= %ch_scripted_tests_b0_coveralign;
	
	addNotetrack_customFunction("generic", "doorkick", Maps\cuba_escape::kick_door_open, "door_kick");
	
	
	level.scr_anim[ "hangar_guy" ][ "signal" ] = %ch_cuba_b02_troops_signal_1;
	level.scr_anim["hangar_guy2"]["signal2"]	= %ai_cuba_bowman_leapfrog_02;

}

// --------------------------------------------------------------------------------
// ---- Dialogues ----
// --------------------------------------------------------------------------------
setup_dialogues()
{
	//-- STREET --//
	level.scr_sound["generic"]["enemies_of_the_revolution"]	= "vox_cub1_s01_027A_pol1_f"; //(Translated) Enemies of the revolution! Lay down your weapons!
	level.scr_sound["generic"]["your_only_warning"]			= "vox_cub1_s01_029A_pol1_f"; //(Translated) This is your only warning!

	level.scr_sound["generic"]["lay_down_your_weapons1"]	= "vox_cub1_s99_304A_pol1"; //(Translated) Lay down your weapons!
	level.scr_sound["generic"]["lay_down_your_weapons2"]	= "vox_cub1_s99_315A_pol2"; //(Translated) Lay down your weapons!
	//level.scr_sound["generic"]["your_only_warning"]		= "vox_cub1_s99_310A_pol2"; //(Translated) This is your only warning!

	level.scr_sound["woods"]["what_are_you_doing"] = "vox_cub1_s04_119A_wood"; //Mason! What are you doing?!!!
	level.scr_sound["woods"]["mason"] = "vox_cub1_s04_120A_wood"; //Mason!!!!
	level.scr_sound["woods"]["we_need_to_move"] = "vox_cub1_s99_403A_wood"; //Mason, we need to move!
	level.scr_sound["woods"]["over_here"] = "vox_cub1_s02_537A_wood"; //Mason. Over here.
	level.scr_sound["woods"]["what_are_you_waiting_for"] = "vox_cub1_s02_538A_wood"; //What are you waiting for? Come on.

	/////////// POLICE CHATTTER //////////////////////////////////////////////////////
	//C. Ayers: The chatter was a bit too repetitious, so I'm adding lines into the "Chatter" array in order to alleviate this

	// Police chatter - Normal
	level.police_chatter["normal"]["chatter"] =
		array(	"vox_cub1_s99_300A_pol1", /*(Translated) They have military weapons!*/
		"vox_cub1_s99_302A_pol1", /*(Translated) We need some assistance!*/
		"vox_cub1_s99_303A_pol1", /*(Translated) Call for back up!*/
		"vox_cub1_s99_307A_pol1", /*(Translated) We need backup!*/
		"vox_cub1_s99_308A_pol1", /*(Translated) They are too well armed!*/
		"vox_cub1_s99_306A_pol1", /*(Translated) Pull back!*/
		"vox_cub1_s99_305A_pol1", /*(Translated) Get Down!*/
		"vox_cub1_s99_311B_pol2", /*(Translated) They have military weapons!*/
		"vox_cub1_s99_313B_pol2", /*(Translated) We need some assistance!*/
		"vox_cub1_s99_314B_pol2", /*(Translated) Call for back up!*/
		"vox_cub1_s99_318B_pol2", /*(Translated) We need backup!*/
		"vox_cub1_s99_319B_pol2", /*(Translated) They are too well armed!*/
		"vox_cub1_s99_317B_pol2", /*(Translated) Pull back!*/
		"vox_cub1_s99_316B_pol2" /*(Translated) Get Down!*/
		);
	
	level.police_chatter["normal"]["get_down"] =
		array(	"vox_cub1_s99_305A_pol1" /*(Translated) Get Down!*/
		);

	level.police_chatter["normal"]["officer_down"] =
		array(	"vox_cub1_s99_301A_pol1" /*(Translated) Officer Down!*/
		);

	// Police chatter - Radio
	level.police_chatter["radio"]["chatter"] =
		array(	"vox_cub1_s99_311A_pol2_f", /*(Translated) They have military weapons!*/
		"vox_cub1_s99_313A_pol2_f", /*(Translated) We need some assistance!*/
		"vox_cub1_s99_314A_pol2_f", /*(Translated) Call for back up!*/
		"vox_cub1_s99_318A_pol2_f", /*(Translated) We need backup!*/
		"vox_cub1_s99_319A_pol2_f", /*(Translated) They are too well armed!*/
		"vox_cub1_s99_317A_pol2_f" /*(Translated) Pull back!*/
		);

	level.police_chatter["radio"]["get_down"] =
		array(	"vox_cub1_s99_316A_pol2_f" /*(Translated) Get Down!*/
		);

	level.police_chatter["radio"]["officer_down"] =
		array(	"vox_cub1_s99_312A_pol2_f" /*(Translated) Officer Down!*/
		);
	
	/////////// END POLICE CHATTTER ///////////////////////////////////////////////

 	level.scr_sound["carlos"]["thanks"]		= "vox_cub1_s01_206A_carl"; //Thanks, let�s move.
 	level.scr_sound["woods"]["behind_us"]	= "vox_cub1_s01_207A_wood"; //Behind us!

	level.scr_sound["woods"]["bowman_take_the_right"]	= "vox_cub1_s03_083A_wood"; //bowman! Take the right!
	level.scr_sound["bowman"]["on_it"]					= "vox_cub1_s01_513A_bowm"; //On it.

	level.scr_sound["bowman"]["reinforcements"]		= "vox_cub1_s01_515A_bowm_f"; //Reinforcements!
	level.scr_sound["woods"]["too_many_of_them"]	= "vox_cub1_s01_516A_wood"; //Shit... Too many of them!

	level.scr_sound["woods"]["into_the_alley"]	= "vox_cub1_s01_517A_wood"; //This way - into the alley.
	level.scr_sound["woods"]["cover_our_six"]	= "vox_cub1_s01_518A_wood"; //Bowman - Cover our six!
	level.scr_sound["woods"]["get_to_the_car"]	= "vox_cub1_s01_519A_wood"; //Get to the car!

	//driving
// 	level.scr_sound["mason"]["cmon_cmon"]		= "vox_cub1_s01_520A_maso"; //Come on... Come on.
// 	level.scr_sound["woods"]["make_it_quick"]	= "vox_cub1_s01_521A_wood"; //Make it quick, mason!
// 	level.scr_sound["mason"]["got_it"]			= "vox_cub1_s01_522A_maso"; //Got it!
	level.scr_sound["woods"]["dammit2"]			= "vox_cub1_s01_524A_wood"; //Dammit!
	level.scr_sound["woods"]["gtfo"]			= "vox_cub1_s01_525A_wood"; //Get the fuck out of our way!
	level.scr_sound["bowman"]["roadblock"]		= "vox_cub1_s01_526A_bowm"; //Roadblock!
	level.scr_sound["mason"]["i_see_it"]		= "vox_cub1_s01_527A_maso"; //I see it!
	level.scr_sound["woods"]["floor_it"]		= "vox_cub1_s01_528A_wood"; //Floor it, mason!

	level.scr_sound["bowman"]["take_him_out"]	= "vox_cub1_s99_427A_bowm"; //mason, take him out.

	level.scr_sound["bowman"]["air_raid"]			= "vox_cub1_s01_039A_bowm";	//There's the air raid siren.
 	level.scr_sound["woods"]["right_on_schedule"]	= "vox_cub1_s01_040A_wood";	//Right on schedule.
  	level.scr_sound["woods"]["cuban_pilots"]		= "vox_cub1_s01_041A_wood";	//Let's hope those Cuban pilots are up to job... Or this is gonna be one short revolution.
  	level.scr_sound["mason"]["distraction"]			= "vox_cub1_s01_042A_maso";	//Either way, it's all part of the distraction...
	level.scr_sound["bowman"]["take_him_out"] = "vox_cub1_s99_427A_bowm"; //mason, take him out.
	
	// zipline mansion
  	level.scr_sound["woods"]["compound"] = "vox_cub1_s01_043A_wood_m"; //There's the compound... carlos and his men should be hitting the airfield.... Any minute...
  	level.scr_sound["woods"]["carlos_now"] = "vox_cub1_s01_044A_wood_m"; //.... Now.
  
 	level.scr_sound["woods"]["mason_over_here"] = "vox_cub1_s01_529A_wood_m"; //mason, over here.
  	level.scr_sound["woods"]["aint_got"] = "vox_cub1_s01_530A_wood"; //We ain't got time to waste.
  	level.scr_sound["woods"]["hurry_it_up"] = "vox_cub1_s01_531A_wood"; //Hurry it up.
  
  	level.scr_sound["woods"]["hook_up"] = "vox_cub1_s01_045A_wood_m"; //Hook up... This is it.
  	level.scr_sound["woods"]["hook_up2"] = "vox_cub1_s99_402A_wood"; //Hook up!
  
  	level.scr_sound["woods"]["mason_grab_rope"] = "vox_cub1_s99_400A_wood"; //mason, grab that rope, let's go!
  	level.scr_sound["woods"]["mason_get_going"] = "vox_cub1_s99_401A_wood"; //mason, we have to get going!
    
	// compound
    level.scr_sound["contextual_melee_guard"]["guard_invasion"] = "vox_cub1_s02_046A_cgu1"; //(Translated) The invasion has begun!
    level.scr_sound["contextual_melee_guard"]["guard_under_attack"] = "vox_cub1_s02_047A_cgu1"; //(Translated) The airfield is under attack...
    level.scr_sound["contextual_melee_guard"]["guard_on_their_way"] = "vox_cub1_s02_048A_cgu1"; //(Translated) We have men on their way now...
    level.scr_sound["contextual_melee_guard"]["guard_reinforce"] = "vox_cub1_s02_049A_cgu1"; //(Translated) Hold position until reinforcements arrive.
    level.scr_sound["contextual_melee_guard"]["guard_repeat"] = "vox_cub1_s02_050A_cgu1"; //(Translated) I Repeat -
    level.scr_sound["woods"]["perfect_focus"] = "vox_cub1_s02_051A_wood"; //Perfect.  They're all focussed on the attack on the airfield.
    level.scr_sound["woods"]["sit_tight"] = "vox_cub1_s02_052A_wood"; //Sit tight... let them pass.
    level.scr_sound["woods"]["bowman_left_flank"] = "vox_cub1_s02_053A_wood"; //bowman - Take the left flank.
    level.scr_sound["woods"]["go_up"] = "vox_cub1_s02_055A_wood"; //Go.
	level.scr_sound["woods"]["up_the_stairs"] = "vox_cub1_s02_056A_wood"; //This way - up the stairs.
    level.scr_sound["woods"]["up_the_stairs_go"] = "vox_cub1_s99_422A_wood"; //Up the stairs. Go! Go! Go!
    level.scr_sound["bowman"]["expectating_us"] = "vox_cub1_s02_057A_bowm"; //Looks like they were expecting us.
    level.scr_sound["woods"]["castro_paranoid"] = "vox_cub1_s02_058A_wood"; //Castro's paranoid... With good reason... we've been trying to get to him for three years.
    level.scr_sound["mason"]["we_succeed"] = "vox_cub1_s02_059A_maso"; //Today's the day we succeed.


	// mansion
    level.scr_sound["woods"]["this_way"] = "vox_cub1_s02_060A_wood"; //This way - inside.
    level.scr_sound["woods"]["mason"] = "vox_cub1_s02_061A_wood"; //mason!
    level.scr_sound["woods"]["wake_up_mason"] = "vox_cub1_s02_062A_wood"; //Wake the fuck up, mason!

	level.scr_sound["woods"]["bowman_split"] = "vox_cub1_s02_063A_wood"; //Bowman - Take the roof.
    level.scr_sound["woods"]["trouble_yell"] = "vox_cub1_s02_064A_wood"; //Any trouble - give us a yell.
    level.scr_sound["bowman"]["got_it"] = "vox_cub1_s02_065A_bowm"; //Got it.
   

	level.scr_sound["woods"]["search_castro"] = "vox_cub1_s02_535A_wood"; //Mason - on me. We search room to room 'till we find Castro.
    level.scr_sound["woods"]["target_ahead"] = "vox_cub1_s02_066A_wood"; //Target's up ahead...
    level.scr_sound["mason"]["copy"] = "vox_cub1_s02_067A_maso"; //Copy.
    level.scr_sound["woods"]["what_the_fuck"] = "vox_cub1_s02_068A_wood"; //What the fuck was that?!!!
    level.scr_sound["woods"]["bowman_whats_happening"] = "vox_cub1_s02_069A_wood"; //bowman - what's happening?
    level.scr_sound["bowman"]["B26"] = "vox_cub1_s02_070A_bowm_f"; //It's the B26's!  I don't think they know what the hell they're bombing!
    level.scr_sound["woods"]["no_shit"] = "vox_cub1_s02_071A_wood"; //Yeah, no shit...
    level.scr_sound["woods"]["done_in_5"] = "vox_cub1_s02_072A_wood"; //Sit tight... We'll be done in five.
	level.scr_sound["woods"]["stack_up"] = "vox_cub1_s02_536A_wood"; //Okay - stack up.
	level.scr_sound["woods"]["waiting_for?"] = "vox_cub1_s02_538A_wood"; //What are you waiting for? Come on.

	level.scr_sound["woods"]["nest_empty"] = "vox_cub1_s02_541A_wood"; //Bowman - Nest is empty. We're moving on.
    level.scr_sound["bowman"]["bettermake_it_fast"] = "vox_cub1_s02_542A_bowm_f"; //Better make it fast. B26's are about to begin their bombing run.
    level.scr_sound["woods"]["target_should_be_ahead"] = "vox_cub1_s02_066A_wood"; //Target should be up ahead
    level.scr_sound["mason"]["roger"] = "vox_cub1_s02_067A_maso"; //Roger.
	
	level.scr_sound["woods"]["movement_inside"] = "vox_cub1_s02_073A_wood"; //Movement inside. Get in position.
    level.scr_sound["woods"]["get_in_position"] = "vox_cub1_s02_073A_wood_m"; //mason - get in position.
    level.scr_sound["woods"]["ready?"] = "vox_cub1_s02_074A_wood_m"; //Ready?
    level.scr_sound["mason"]["ready"] = "vox_cub1_s02_075A_maso"; //Ready.
    level.scr_sound["woods"]["crazy_bitch"] = "vox_cub1_s02_076A_wood_m"; //Crazy bitch... he uses her as a human shield and she still fights to protect him?!!
    level.scr_sound["mason"]["supporters_fanatics"] = "vox_cub1_s02_077A_maso_m"; //Castro's supporters are fanatical in their devotion to him...
    level.scr_sound["woods"]["communists!"] = "vox_cub1_s02_078A_wood_m"; //Communists... I'll never understand them.

	// escape
	level.scr_sound["woods"]["target_is_down"]= "vox_cub1_s03_079A_wood"; //bowman - The target is down... We're on our way.
    level.scr_sound["bowman"]["word_from_carlos"] = "vox_cub1_s03_080A_bowm_f"; //Word from carlos isn't good;  They're barely holding out... They got half the Cuban army down there!
    level.scr_sound["bowman"]["aint_hitting_anything"] = "vox_cub1_s03_081A_bowm_f"; //And those b26's ain't hitting anything!
    level.scr_sound["bowman"]["hallway"] = "vox_cub1_s03_543A_bowm_f"; //I'm moving to the main hallway.
    level.scr_sound["woods"]["on_our_way"] = "vox_cub1_s03_082A_wood"; //Okay, we're on our way.
    level.scr_sound["woods"]["mason_on_me"] 	= "vox_cub1_s03_084A_wood"; //mason - On me.
    level.scr_sound["woods"]["dammit"]	= "vox_cub1_s03_085A_wood"; //DAMMIT!!!
    level.scr_sound["woods"]["lets_get_the_fuck_out"] 						= "vox_cub1_s03_086A_wood"; //Let's get the fuck out of here before those damn planes blow us to pieces!
    level.scr_sound["woods"]["go_outside"] = "vox_cub1_s03_087A_wood"; //Go! Outside!
    
    level.scr_sound["bowman"]["theres_too_many_of_them"] 					= "vox_cub1_s03_088A_bowm"; //This don't look good!  There's too many of them!
    level.scr_sound["woods"]["50cal"] = "vox_cub1_s04_114a_wood"; //shit!  .50 cal!
    level.scr_sound["bowman"]["take_out_50cal_bowman"] = "vox_cub1_s99_421A_bowm"; //Take out that .50 cal!
    level.scr_sound["woods"]["take_out_50cal_woods"] = "vox_cub1_s99_420A_wood"; //Take out that .50 cal!
    level.scr_sound["bowman"]["should_be_here"] = "vox_cub1_s03_544A_bowm"; //carlos� men should be here!
    level.scr_sound["woods"]["carlos_whats_happening"] 						= "vox_cub1_s03_089A_wood"; //carlos... What's happening?!!
    level.scr_sound["woods"]["carlos_question"] 	= "vox_cub1_s03_090A_wood"; //carlos?!!
    level.scr_sound["bowman"]["east_wall"] = "vox_cub1_s03_545A_bowm"; //Here they come - over the East wall!
    level.scr_sound["carlos"]["think_id_let_you_down"] = "vox_cub1_s03_091A_carl_f"; //You think I'd let you down, woods?
    level.scr_sound["carlos"]["cover_escape"] = "vox_cub1_s03_546A_carl_f"; //My men will cover your escape.
    level.scr_sound["woods"]["btr!"] = "vox_cub1_s99_419A_wood"; //BTR!!
    level.scr_sound["carlos"]["now_hurry_my_friends"] = "vox_cub1_s03_092A_carl_f"; //Now... Hurry, my friends!
    level.scr_sound["woods"]["god_bless"] = "vox_cub1_s03_093A_wood"; //God bless you, carlos.
    level.scr_sound["bowman"]["this_way_into_the_sugar_field"]="vox_cub1_s03_094A_bowm"; //This way - into the sugar fields!
    level.scr_sound["woods"]["through_gate"] = "vox_cub1_s03_547A_wood"; //Through the gate! GO!
    level.scr_sound["woods"]["dont_have_time"] = "vox_cub1_s03_548A_wood"; //mason!!! We don't have time to wait!

	
	//airfield
	level.scr_sound["woods"]["theres_airfield"] = "vox_cub1_s03_095a_wood"; //there's the airfield.
	level.scr_sound["bowman"]["carlos_secured"] = "vox_cub1_s03_096a_bowm"; //let's hope carlos secured that evac.
	level.scr_sound["woods"]["aint_let_us_down"] = "vox_cub1_s03_097a_wood"; //he ain't let us down yet.
	level.scr_sound["bowman"]["rebels_asses_kicked"] = "vox_cub1_s03_098a_bowm"; //looks like the rebels are getting their asses kicked!
	level.scr_sound["woods"]["hook_up"] = "vox_cub1_s03_099a_wood"; //better get down there - hook up...
	level.scr_sound["woods"]["hook_up_go"] = "vox_cub1_s03_100a_wood"; //go!
	level.scr_sound["carlos"]["falling_apart"] = "vox_cub1_s04_101a_carl_f"; //woods!  it's all falling apart...  you need to get out of here!
	level.scr_sound["woods"]["did_secure_transport"] = "vox_cub1_s04_102a_wood"; //you secure our transport?
	level.scr_sound["carlos"]["plane_ready"] = "vox_cub1_s04_103a_carl_f"; //the plane is ready... but we'll be torn to pieces on take off!
	level.scr_sound["woods"]["one_thing"] = "vox_cub1_s04_104a_wood"; //on thing at a time, brother.
	level.scr_sound["woods"]["escape_nag0"] = "vox_cub1_s04_105a_wood"; //we're leaving... move!
	level.scr_sound["carlos"]["escape_nag1"] = "vox_cub1_s04_106a_carl"; //hurry!!!
	level.scr_sound["carlos"]["escape_nag2"] = "vox_cub1_s04_107a_carl"; //run!
	level.scr_sound["carlos"]["escape_nag3"] = "vox_cub1_s04_108a_carl"; //we can't wait any longer!!
	level.scr_sound["carlos"]["escape_nag4"] = "vox_cub1_s04_109a_carl"; //come on!!!
	level.scr_sound["woods"]["escape_nag5"] = "vox_cub1_s04_110a_wood"; //mason!  come on!!!
	
	level.scr_sound["woods"]["give_cover"] = "vox_cub1_s04_111a_wood"; //give us cover, mason!
	level.scr_sound["woods"]["keep_in_one_piece"] = "vox_cub1_s04_112a_wood"; //we need to keep this plane in one piece!
	level.scr_sound["bowman"]["trying_to_take_engines"] = "vox_cub1_s04_113a_bowm"; //they're trying to take out our engines!
	level.scr_sound["woods"]["zpus"] = "vox_cub1_s04_549A_wood"; //mason! Take out those ZPUs!
	level.scr_sound["woods"]["rpgs_tower"] = "vox_cub1_s04_551A_wood"; //RPGs in the tower!
	level.scr_sound["bowman"]["without_fight"] = "vox_cub1_s04_550A_bowm"; //They're not letting us go without a fight!
	level.scr_sound["bowman"]["shit_takin_damage"] = "vox_cub1_s04_552A_bowm"; //Shit! Takin' damage!
  	level.scr_sound["bowman"]["barely_holding"] = "vox_cub1_s04_553A_bowm"; //This hunk's barely holding together!
  	level.scr_sound["woods"]["mason_take_rpgs"] = "vox_cub1_s99_404A_wood"; //mason, take out the RPG's!
  	level.scr_sound["woods"]["mason_protect_plane"] = "vox_cub1_s99_405A_wood"; //mason, protect the plane!
  	level.scr_sound["woods"]["rpgs_tearing_us_up"] = "vox_cub1_s99_406A_wood"; //Those RPG's are tearing us up!
  	level.scr_sound["woods"]["cant_take_much_more"] = "vox_cub1_s99_407A_wood"; //We can't take much more mason!
  	level.scr_sound["woods"]["take_damned_rpgs"] = "vox_cub1_s99_408A_wood"; //Take out those damned RPG's mason!
 	level.scr_sound["woods"]["mason_rpg"] = "vox_cub1_s99_409A_wood"; //mason! RPG!
 	level.scr_sound["woods"]["were_getting_hit"] = "vox_cub1_s99_410A_wood"; //We're getting hit!
    
	level.scr_sound["bowman"]["we_got_problem"] = "vox_cub1_s04_115a_bowm"; //woods! we got a problem!
	level.scr_sound["bowman"]["vehicles_blocking"] = "vox_cub1_s04_116a_bowm"; //those fucking vehicles are blocking the runway!
	level.scr_sound["mason"]["I_hear_you"] = "vox_cub1_s04_554A_maso"; //I hear you, bowman.
	level.scr_sound["woods"]["not_enough_room"] = "vox_cub1_s04_117a_wood"; //We�re screwed. There�s not enough room for take off!
	level.scr_sound["mason"]["deal_with_it"] = "vox_cub1_s04_118a_maso"; //i'll deal with it!
	level.scr_sound["woods"]["chew_you_up"] = "vox_cub1_s04_555A_wood"; //mason, are you crazy? They�ll chew you up out there.
	level.scr_sound["woods"]["what_are_doing"] = "vox_cub1_s04_119a_wood"; //mason!  what are you doing?!!!
	level.scr_sound["woods"]["mason_no"] = "vox_cub1_s04_120a_wood"; //mason!!!!
	level.scr_sound["mason"]["no_choice"] = "vox_cub1_s04_556A_maso"; //No choice, woods. I knew what I signed up for.
	level.scr_sound["woods"]["dam_you"] = "vox_cub1_s04_557A_wood_f"; //Damn you, mason.
	level.scr_sound["mason"]["runways_clear"] = "vox_cub1_s04_558A_maso"; //Runway's clear.
	level.scr_sound["mason"]["ill_be_fine"] = "vox_cub1_s04_559A_maso"; //I'll be fine. Go - Get out of here!
		
	level.scr_sound["mason"]["we_killed_you"] = "vox_cub1_s04_121a_maso_m"; //you're dead... we killed you...
	level.scr_sound["castro"]["no_killed_double"] = "vox_cub1_s04_122a_cast_m"; //no... you killed a double... you think we didn't know of your plan?
	level.scr_sound["dragovich"]["we_always_know"] = "vox_cub1_s04_123a_drag_m"; //we always know...
	level.scr_sound["castro"]["do_as_you_wish"] = "vox_cub1_s04_124a_cast_m"; //do with him what you wish, general... he is my gift to you, in honor of our new relationship...
	level.scr_sound["castro"]["make_him_suffer"] = "vox_cub1_s04_125a_cast_m"; //just... make sure that he suffers...
	level.scr_sound["dragovich"]["he_will_suffer"] = "vox_cub1_s04_126a_drag_m"; //he will know suffering beyond his darkest fears...
	level.scr_sound["dragovich"]["i_have_plans"] = "vox_cub1_s04_127a_drag_m"; //i have plans for you, American...

	//generic woods
	level.scr_sound["woods"]["move_up"] = "vox_cub1_s99_702A_wood"; //Move up!
	level.scr_sound["woods"]["push_fwd"] = "vox_cub1_s99_703A_wood"; //Push forward!
	level.scr_sound["woods"]["cant_stay_push_fwd"] = "vox_cub1_s99_701A_wood"; //We can't stay here! Push forward!
	level.scr_sound["woods"]["pinned_down"] = "vox_cub1_s99_704A_wood"; //We're pinned down here!
	level.scr_sound["woods"]["cant_stay"] = "vox_cub1_s99_705A_wood"; //We can�t stay here.

	level.scr_sound["woods"]["mason_point"] = "vox_cub1_s99_708A_wood"; //mason take point
	level.scr_sound["woods"]["mason_need_to_move"] = "vox_cub1_s99_403A_wood"; //mason, we need to move!
	level.scr_sound["woods"]["move_quickly"] = "vox_cub1_s99_413A_wood"; //Move quickly!
	level.scr_sound["woods"]["keep_moving_woods"] = "vox_cub1_s99_415A_wood"; //Keep moving!
	level.scr_sound["woods"]["get_fuck_outta_here"] = "vox_cub1_s99_417A_wood"; //Let's get the fuck out of here. MOVE!
	level.scr_sound["woods"]["cover_me"] = "vox_cub1_s99_418A_wood"; //Cover me!
	level.scr_sound["woods"]["area_clear_woods"] = "vox_cub1_s99_426A_wood"; //Area clear.
	level.scr_sound["woods"]["keep_tight"] = "vox_cub1_s99_706A_wood"; //Keep it tight (quiet).
	level.scr_sound["woods"]["eyes_front"] = "vox_cub1_s99_700A_wood"; //eyes front (quiet)
	level.scr_sound["woods"]["move_up2"] = "vox_cub1_s99_425A_wood"; //Move up.(quiet)
	
	//generic bowman
	level.scr_sound["bowman"]["got_it"] = "vox_cub1_s02_065A_bowm"; //Got it.
	level.scr_sound["bowman"]["stay_close"] = "vox_cub1_s99_707A_bowm";//Stay close (quiet)
	level.scr_sound["bowman"]["cmon_mason"] = "vox_cub1_s99_412A_bowm"; //C'mon mason!
	level.scr_sound["bowman"]["keep_moving_bowman"] = "vox_cub1_s99_416A_bowm"; //Keep moving!
	level.scr_sound["bowman"]["area_clear_bowman"] = "vox_cub1_s99_423A_bowm"; //Area clear.
	level.scr_sound["bowman"]["roger_that"] = "vox_cub1_s99_424A_bowm"; //Roger that.
}


setup_driving_anims()
{
	level.scr_animtree["player"]	= #animtree;
	level.scr_model["player"]		= "t5_gfl_ump45_viewbody";

	level.scr_animtree["player_cam"]	= #animtree;
	level.scr_model["player_cam"]		= "t5_gfl_ump45_viewbody";
	
	level.scr_anim["bowman"]["drive_getin"] = %ch_cub_b01_carsequence_into_bowman;
	level.scr_anim["carlos"]["drive_getin"] = %ch_cub_b01_carsequence_into_carlos;
	level.scr_anim["woods"]["drive_getin"] = %ch_cub_b01_carsequence_into_woods;

	level.scr_anim["player"]["drive_player_getin"] = %ch_cub_b01_carsequence_into_player;
	level.scr_anim["player_cam"]["drive_player_getin"] = %ch_cub_b01_carsequence_into_player;
	addnotetrack_customfunction("player_cam", "start_bowman_anim", maps\cuba_street::start_bowman_anim, "drive_player_getin");
	addnotetrack_customfunction("player_cam", "start_woods", maps\cuba_street::woods_and_bowman_getin, "drive_player_getin");

	level.scr_anim["bowman"]["drive_lookback"] = %ch_cub_b01_carsequence_lookbwd_idle_bowman;
	level.scr_anim["bowman"]["drive_lookback2"][0] = %ch_cub_b01_carsequence_lookbwd_idle2_bowman;
	level.scr_anim["player_cam"]["drive_lookback"][0] = %ch_cub_b01_carsequence_lookbwd_idle_player;
	level.scr_anim["player"]["drive_lookback"][0] = %ch_cub_b01_carsequence_lookbwd_idle_player;
	level.scr_anim["woods"]["drive_lookback"][0] = %ch_cub_b01_carsequence_lookbwd_idle_woods;
	
	level.scr_anim["bowman"]["drive_backward"] = %ch_cub_b01_carsequence_drivebwd_bowman;
	level.scr_anim["player_cam"]["drive_backward"] = %ch_cub_b01_carsequence_drivebwd_player;
	level.scr_anim["player"]["drive_backward"] = %ch_cub_b01_carsequence_drivebwd_player;
	level.scr_anim["woods"]["drive_backward"] = %ch_cub_b01_carsequence_drivebwd_woods;

	level.scr_anim["bowman"]["drive_lookforward"][0] = %ch_cub_b01_carsequence_lookfwd_1hand_idle_bowman;
	level.scr_anim["player_cam"]["drive_lookforward"][0] = %ch_cub_b01_carsequence_lookfwd_1hand_idle_player;
	level.scr_anim["woods"]["drive_lookforward"][0] = %ch_cub_b01_carsequence_lookfwd_1hand_idle_woods;
	
	level.scr_anim["bowman"]["start_forward1"] = %ch_cub_b01_carsequence_drivefwd_1hand_bowman;
	level.scr_anim["player_cam"]["start_forward1"] = %ch_cub_b01_carsequence_drivefwd_1hand_player;
	level.scr_anim["woods"]["start_forward1"] = %ch_cub_b01_carsequence_drivefwd_1hand_woods;
	addnotetrack_customfunction("player_cam", "drive_fwd", maps\cuba_street::car_go, "start_forward1");

	level.scr_anim["bowman"]["drive_forward1"][0] = %ch_cub_b01_carsequence_drivefwd_idle_1hand_bowman;
	level.scr_anim["player_cam"]["drive_forward1"][0] = %ch_cub_b01_carsequence_drivefwd_idle_1hand_player;
	level.scr_anim["woods"]["drive_forward1"][0] = %ch_cub_b01_carsequence_drivefwd_idle_1hand_woods;

	level.scr_anim["bowman"]["drive_slomo"] = %ch_cub_b01_carsequence_slowmo_bowman;
	level.scr_anim["player_cam"]["drive_slomo"] = %ch_cub_b01_carsequence_slowmo_player;
	level.scr_anim["player"]["drive_slomo"] = %ch_cub_b01_carsequence_slowmo_player;
	level.scr_anim["woods"]["drive_slomo"] = %ch_cub_b01_carsequence_slowmo_woods;
	addnotetrack_customfunction("player_cam", "warp_car", maps\cuba_street::warp_car, "drive_slomo");

	level.scr_anim["bowman"]["drive_forward2"][0] = %ch_cub_b01_carsequence_drivefwd_2hands_bowman;
	level.scr_anim["player_cam"]["drive_forward2"][0] = %ch_cub_b01_carsequence_drivefwd_2hands_player;
	level.scr_anim["woods"]["drive_forward2"][0] = %ch_cub_b01_carsequence_drivefwd_2hands_woods;
}

#using_animtree("vehicles");
setup_car_anims()
{
	// Car
	level.scr_animtree["car"]  = #animtree;
	level.scr_anim["car"]["drive_player_getin"]		= %v_cub_b01_carsequence_into_car;
	level.scr_anim["car"]["drive_lookback"][0]		= %v_cub_b01_carsequence_lookbwd_idle_car;
	level.scr_anim["car"]["drive_backward"]			= %v_cub_b01_carsequence_drivebwd_car;
	level.scr_anim["car"]["drive_lookforward"][0]	= %v_cub_b01_carsequence_lookfwd_1hand_idle_car;
	level.scr_anim["car"]["start_forward1"]			= %v_cub_b01_carsequence_drivefwd_1hand_car;
	level.scr_anim["car"]["drive_forward1"][0]		= %v_cub_b01_carsequence_drivefwd_idle_1hand_car;
	level.scr_anim["car"]["drive_slomo"]			= %v_cub_b01_carsequence_slowmo_car;

	level.scr_anim["car"]["turning_node"]			= %cuba_car_turning;
	//level.scr_anim["car"]["drive_forward2"][0]		= %v_cub_b01_carsequence_drivefwd_2hands_car;
}

// ----------------------------------------------------------------------------------
// ---- Nag lines specific to the event for woods, used in zipline and compound -----
// ----------------------------------------------------------------------------------

create_woods_nag_array( event )
{
	level.woods_nag_lines = [];

	switch ( event )
	{
		case "woods_alley":
		{
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"what_are_you_doing";	// Mason! What are you doing?!!!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason"; 				// Mason!!!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"we_need_to_move";		// Mason, we need to move!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"over_here"; 			// Mason. Over here.
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"what_are_you_waiting_for"; // What are you waiting for? Come on.

			break;
		}

		case "zipline":
		{
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hook_up"; 			// Hook up... This is it.		
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hook_up2"; 		// Hook up!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_over_here"; 	// mason, over here.			
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"aint_got"; 		// We ain't got time to waste.		
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hurry_it_up"; 		// Hurry it up.
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_grab_rope"; 	// mason, grab that rope, let's go!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_get_going"; 	// mason, we have to get going!
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_need_to_move"; 	//mason, we need to move!
		
			break;
		}

		case "door_breach":
		{
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_over_here"; 	// mason, over here.			
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hurry_it_up"; 		// Hurry it up.
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_need_to_move"; 	//mason, we need to move!
			break;
		}

		case "pre_assasination":
		{
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_over_here"; 	// mason, over here.			
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"waiting_for?"; 	//What are you waiting for? Come on.
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"aint_got"; 		// We ain't got time to waste.		
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hurry_it_up"; 		// Hurry it up.
			break;
		}
		
		case "assasination":
		{
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"mason_over_here"; 	// mason, over here.			
			level.woods_nag_lines[level.woods_nag_lines.size] = 	"hurry_it_up"; 		// Hurry it up.
			break;
		}

		case "default":
		{
			Assert( "Undefined nag event" );
			break;
		}
	}

	return level.woods_nag_lines;
}

create_carlos_nag_array( event )
{
	level.carlos_nag_lines = [];

	switch ( event )
	{
		case "carlos_alley":
		{
			level.carlos_nag_lines[level.carlos_nag_lines.size] = 	"hurry";	// Hurry!!!
			level.carlos_nag_lines[level.carlos_nag_lines.size] = 	"run"; 		// Run!

			break;
		}

		case "default":
		{
			Assert( "Undefined nag event" );
			break;
		}
	}

	return level.carlos_nag_lines;
}

guard1_attach_reel(guy)
{
	guy = get_ai("truck_guard1", "script_noteworthy");
	
	if (isAlive(guy) && !level.disc)
	{
		guy Attach("p_rus_reel_disc", "tag_inhand");
		level.disc = true;
	}
}


guard1_attach_papers(guy)
{
	guy = get_ai("truck_guard1", "script_noteworthy");
	
	if (isAlive(guy) && !level.paper1)
	{
		guy Attach("dest_glo_paper_01_d0", "tag_inhand");
		level.paper1 = true;
	}
}


guard1_detach(guy)
{
	guy = get_ai("truck_guard1", "script_noteworthy");
	
	if (isAlive(guy) && level.disc)
	{
		guy Detach("p_rus_reel_disc", "tag_inhand");
		level.disc = false;
	}
	
	else if (isAlive(guy) && level.paper1)
	{
		guy Detach("dest_glo_paper_01_d0", "tag_inhand");
		level.paper1 = false;
	}
}
	
	
guard2_attach_papers(guy)
{
	guy = get_ai("truck_guard2", "script_noteworthy");
	
	if (isAlive(guy) && !level.paper2)
	{
		guy Attach("dest_glo_paper_02_d0", "tag_inhand");
		level.paper2 = true;
	}
}
	

guard2_detach(guy)
{
	guy = get_ai("truck_guard2", "script_noteworthy");
	
	if (isAlive(guy) && level.paper2)
	{
		guy Detach("dest_glo_paper_02_d0", "tag_inhand");
		level.paper2 = false;
	}
}
 