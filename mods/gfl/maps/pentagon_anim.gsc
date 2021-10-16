//[ChrisE]

#include maps\_anim; //Needed for addNotetrack_customFunction()

#include common_scripts\utility;
#include maps\_utility;
#include maps\pentagon_code;

main()
{
	level init_generic_anims();
	level init_player_anims();
	level init_vehicle_anims();
	level init_door_anims();
	level init_prop_anims();
	level init_voiceovers();
}

#using_animtree( "generic_human" );
init_generic_anims()
{
	//ANIMTREES
	level.scr_animtree[ "hudson" ]   = #animtree;
	level.scr_animtree[ "mcnamara" ] = #animtree;
	level.scr_animtree[ "general" ]  = #animtree;
	level.scr_animtree[ "kennedy" ]  = #animtree;
	level.scr_animtree[ "generic" ]  = #animtree;
	
	//Test
	level.scr_anim[ "hudson" ][ "root" ] = %root;
  level.scr_anim[ "mcnamara" ][ "root" ] = %root;
	
	//RAIL ANIMATIONS
	level.scr_anim[ "hudson" ][ "helipad_landing" ] 	 = %ch_pentagon_intro_hudson2;
	level.scr_anim[ "hudson" ][ "helipad_rail_tarmac" ]		= %ch_pentagon_tarmack_hudson;
	level.scr_anim[ "generic" ][ "helipad_rail_tarmac" ]  = %ch_pentagon_limo_passenger_first;
	level.scr_anim[ "hudson" ][ "helipad_rail_limo" ]     = %ch_pentagon_limo_hudson_first;
	level.scr_anim[ "mcnamara" ][ "helipad_rail_limo" ]   = %ch_pentagon_limo_mcnamara_first;
	level.scr_anim[ "general" ][ "helipad_rail_limo" ]		= %ch_pentagon_limo_general_first;
	
	level.scr_anim[ "hudson" ][ "motorcade_rail_limo" ]   = %ch_pentagon_limo_hudson_second;
	level.scr_anim[ "mcnamara" ][ "motorcade_rail_limo" ] = %ch_pentagon_limo_mcnamara_second;
	level.scr_anim[ "general" ][ "motorcade_rail_limo" ]	= %ch_pentagon_limo_general_second;
	
	level.scr_anim[ "generic" ][ "security_rail_vip" ]  = %ch_pentagon_rail_the_vip_clerk;
	level.scr_anim[ "hudson" ][ "security_rail_vip" ]   = %ch_pentagon_rail_the_vip_hudson;
	level.scr_anim[ "mcnamara" ][ "security_rail_vip" ] =	%ch_pentagon_rail_the_vip_mcnamara;
	//TODO: Better distinguish from clerk's anim alias!
	level.scr_anim[ "generic" ][ "security_rail_vip_guya" ]  = %ch_pentagon_rail_open_door_assist_guard01;
	level.scr_anim[ "generic" ][ "security_rail_vip_guyb" ]  = %ch_pentagon_rail_open_door_assist_guard02;
	level.scr_anim[ "hudson" ][ "security_rail_exit" ]   =	%ch_pentagon_rail_s_curve_hudson;
	level.scr_anim[ "mcnamara" ][ "security_rail_exit" ] =	%ch_pentagon_rail_s_curve_mcnamara;
	
	level.scr_anim[ "hudson" ][ "pool_rail_marvel" ]   = %ch_pentagon_rail_finest_people_hudson;
	level.scr_anim[ "mcnamara" ][ "pool_rail_marvel" ] = %ch_pentagon_rail_finest_people_mcnamara;
	level.scr_anim[ "generic" ][ "pool_rail_checkin_guya" ] =	%ch_pentagon_rail_we_are_ready_clerk01; //Clerk
	level.scr_anim[ "generic" ][ "pool_rail_checkin_guyb" ] =	%ch_pentagon_rail_we_are_ready_clerk02; //Guard
	level.scr_anim[ "hudson" ][ "pool_rail_checkin" ] 			=	%ch_pentagon_rail_we_are_ready_hudson;
	level.scr_anim[ "mcnamara" ][ "pool_rail_checkin" ] 		=	%ch_pentagon_rail_we_are_ready_mcnamara;
	level.scr_anim[ "hudson" ][ "pool_rail_hall" ] = %ch_pentagon_rail_heroes_leaders_hudson;
	level.scr_anim[ "mcnamara" ][ "pool_rail_hall" ] = %ch_pentagon_rail_heroes_leaders_mcnamara;
	level.scr_anim[ "generic" ][ "pool_rail_elevator_guya" ] = %ch_pentagon_rail_elevator_guard01;
	level.scr_anim[ "generic" ][ "pool_rail_elevator_guyb" ] = %ch_pentagon_rail_elevator_guard02;
	level.scr_anim[ "hudson" ][ "pool_rail_elevator" ] 			  = %ch_pentagon_rail_elevator_hudson;		//CODEWORD INTO BOARDING
	level.scr_anim[ "mcnamara" ][ "pool_rail_elevator" ] 			= %ch_pentagon_rail_elevator_mcnamara;  //CODEWORD INTO BOARDING
	level.scr_anim[ "hudson" ][ "pool_rail_elevator_idle" ]		=	%ch_pentagon_rail_elevator_loop_hudson;
	level.scr_anim[ "mcnamara" ][ "pool_rail_elevator_idle" ] 	=	%ch_pentagon_rail_elevator_loop_mcnamara;
	
	level.scr_anim[ "hudson" ][ "warroom_rail_enter" ] 		= %ch_pentagon_rail_nerve_center_hudson;
	level.scr_anim[ "mcnamara" ][ "warroom_rail_enter" ] 		= %ch_pentagon_rail_nerve_center_mcnamara;
	level.scr_anim[ "hudson" ][ "warroom_rail_midlanding" ] 		= %ch_pentagon_rail_first_time_hudson;
	level.scr_anim[ "mcnamara" ][ "warroom_rail_midlanding" ] 		= %ch_pentagon_rail_first_time_mcnamara;
	level.scr_anim[ "hudson" ][ "warroom_rail_exit" ] 			= %ch_pentagon_rail_rarely_use_hudson;
	level.scr_anim[ "mcnamara" ][ "warroom_rail_exit" ] 		= %ch_pentagon_rail_rarely_use_mcnamara;
	level.scr_anim[ "generic" ][ "warroom_rail_exit_guya" ] = %ch_pentagon_rail_door_guards_guy01;
	level.scr_anim[ "generic" ][ "warroom_rail_exit_guyb" ] = %ch_pentagon_rail_door_guards_guy02;
	
	level.scr_anim[ "hudson" ][ "briefing_rail_entrance" ] 		= %ch_pentagon_rail_jfk_entrance_hudson;
	level.scr_anim[ "kennedy" ][ "briefing_rail_entrance" ] 		= %ch_pentagon_rail_jfk_entrance_jfk;
	level.scr_anim[ "mcnamara" ][ "briefing_rail_entrance" ] 		= %ch_pentagon_rail_jfk_entrance_mcnamara;
	level.scr_anim[ "generic" ][ "briefing_rail_entrance_guya" ] = %ch_pentagon_rail_generals_leaving_guy01;
	level.scr_anim[ "generic" ][ "briefing_rail_entrance_guyb" ] = %ch_pentagon_rail_generals_leaving_guy02;
	level.scr_anim[ "hudson" ][ "briefing_rail_mission" ] 		= %ch_pentagon_rail_take_care_hudson;
	level.scr_anim[ "kennedy" ][ "briefing_rail_mission" ] 		= %ch_pentagon_rail_take_care_jfk;
	level.scr_anim[ "mcnamara" ][ "briefing_rail_mission" ] 		= %ch_pentagon_rail_take_care_mcnamara;

	//Important Animations (specifically called out for in design documents).
	level.scr_anim[ "generic" ][ "helipad_landing_guya" ] = %ch_pentagon_intro_fbi;
	level.scr_anim[ "generic" ][ "helipad_tarmac_guya" ] = %ch_pentagon_tarmack_fbi;
	level.scr_anim[ "generic" ][ "helipad_landing_guyb" ] = %ch_pentagon_intro_fbi2;
	level.scr_anim[ "generic" ][ "helipad_landing_guyc" ] = %ch_pentagon_intro_fbi3;
	level.scr_anim[ "generic" ][ "helipad_tarmac_guyc" ] = %ch_pentagon_tarmack_fbi3;
	level.scr_anim[ "generic" ][ "helipad_arrive_0" ]  = %ch_pentagon_bikedriver01;
	level.scr_anim[ "generic" ][ "helipad_arrive_1" ]  = %ch_pentagon_bikedriver02;
	level.scr_anim[ "generic" ][ "helipad_arrive_2" ]  = %ch_pentagon_bikedriver03;
	level.scr_anim[ "generic" ][ "helipad_arrive_3" ]  = %ch_pentagon_bikedriver04;
	level.scr_anim[ "generic" ][ "helipad_peelout_0" ]   = %ch_pentagon_bikedriver05;
	level.scr_anim[ "generic" ][ "helipad_peelout_1" ]   = %ch_pentagon_bikedriver06;
	level.scr_anim[ "generic" ][ "helipad_peelout_2" ]   = %ch_pentagon_bikedriver07;
	level.scr_anim[ "generic" ][ "helipad_peelout_3" ]   = %ch_pentagon_bikedriver08;
	level.scr_anim[ "generic" ][ "security_patdown_guya" ]  = %ch_pentagon_patdown01; //Frisks guyb
	level.scr_anim[ "generic" ][ "security_patdown_guyb" ]  = %ch_pentagon_patdown02; //Frisked by guya
	level.scr_anim[ "generic" ][ "security_detector_wait" ]	= %ch_pentagon_checkpoint_waiting;
	level.scr_anim[ "generic" ][ "pool_rail_marvel" ]				= %ch_pentagon_rail_finest_people_woman;
	level.scr_anim[ "generic" ][ "pool_conference_shut" ] 	 = %ch_pentagon_npc_door_close;
	level.scr_anim[ "generic" ][ "warroom_paper_rush_guya" ] = %ch_pentagon_npc_paper_rush01;
	level.scr_anim[ "generic" ][ "warroom_paper_rush_guyb" ] = %ch_pentagon_npc_paper_rush02;
	level.scr_anim[ "generic" ][ "warroom_alarm_idle_guya" ] = %ch_pentagon_npc_screen_alarm_startloop01; //Guy who runs to console.
	level.scr_anim[ "generic" ][ "warroom_alarm_idle_guyb" ] = %ch_pentagon_npc_screen_alarm_startloop02; //Guy at console.
	level.scr_anim[ "generic" ][ "warroom_alarm_guya" ] 		 = %ch_pentagon_npc_screen_alarm01;
	level.scr_anim[ "generic" ][ "warroom_alarm_guyb" ]			 = %ch_pentagon_npc_screen_alarm02;
	level.scr_anim[ "generic" ][ "warroom_moonwalk_guya" ] = %ch_pentagon_npc_moon_walk01; //Sits on left
	level.scr_anim[ "generic" ][ "warroom_moonwalk_guyb" ] = %ch_pentagon_npc_moon_walk02; //Sits on right, stressed out
	level.scr_anim[ "generic" ][ "warroom_moonwalk_guyc" ] = %ch_pentagon_npc_moon_walk03; //Stands behind both, walks to alarmed guys

	//Decorative Animations (not specifically called for in design documents).
	//level.scr_anim[ "generic" ][ "briefcase_walk" ] 				   = %civilian_briefcase_walk;
	//level.scr_anim[ "generic" ][ "briefcase_walk_shoelace" ]	 = %civilian_briefcase_walk_shoelace;
	//level.scr_anim[ "generic" ][ "briefcase_walk_turn_left" ]  = %civilian_briefcase_walk_turn_L;
	//level.scr_anim[ "generic" ][ "briefcase_walk_turn_right" ] = %civilian_briefcase_walk_turn_R;
	level.scr_anim[ "generic" ][ "brisk_walk" ] 							 = %ch_pentagon_npc_warroom_walk01;
	level.scr_anim[ "generic" ][ "brisk_walk_2" ] 							 = %ch_pentagon_general_walk;
	level.scr_anim[ "generic" ][ "cartpush_hurry" ] 					 = %ch_pentagon_npc_cartpush_hurry;
	//level.scr_anim[ "generic" ][ "casual_walk" ] 					  = %ch_pentagon_npc_casual_walk;
	//level.scr_anim[ "generic" ][ "casual_walk_turn_left" ]  = %ch_pentagon_npc_casual_walk_turn90l;
	//level.scr_anim[ "generic" ][ "casual_walk_turn_right" ] = %ch_pentagon_npc_casual_walk_turn90r;
	level.scr_anim[ "generic" ][ "chat_legup_guya" ] = %civilian_sitting_talking_A_1;
	level.scr_anim[ "generic" ][ "chat_legup_guyb" ] = %civilian_sitting_talking_B_1;
	level.scr_anim[ "generic" ][ "coffee_walk" ] 					 = %civilian_walk_coffee;
	level.scr_anim[ "generic" ][ "directions_guya" ] = %civilian_directions_1_A; //Points and talks to guyb.
	level.scr_anim[ "generic" ][ "directions_guyb" ] = %civilian_directions_1_B; //Listens to guya.
	level.scr_anim[ "generic" ][ "discuss_phoenix_guya" ] = %ch_pentagon_npc_operation_phoenix01;
	level.scr_anim[ "generic" ][ "discuss_phoenix_guyb" ] = %ch_pentagon_npc_operation_phoenix02;
	level.scr_anim[ "generic" ][ "intersection_meetup_guya" ] = %ch_pentagon_npc_pool03; //Walks along align node (ie, from south).
	level.scr_anim[ "generic" ][ "intersection_meetup_guyb" ] = %ch_pentagon_npc_pool04; //Walks from due east of align node.
	level.scr_anim[ "generic" ][ "paper_walk" ] 					 = %civilian_walk_paper;
	level.scr_anim[ "generic" ][ "secretary_walk" ]			 = %ch_pentagon_npc_secretary_walk01;
	level.scr_anim[ "generic" ][ "smoking_guya" ] = %civilian_smoking_A;
	level.scr_anim[ "generic" ][ "smoking_guyb" ] = %civilian_smoking_B;
	level.scr_anim[ "generic" ][ "stand_loop" ][ 0 ] = %ai_civ_gen_casual_stand_idle;
	level.scr_anim[ "generic" ][ "stand_loop" ][ 1 ] = %ai_civ_gen_casual_stand_idle_twitch_01;
	level.scr_anim[ "generic" ][ "stand_loop" ][ 2 ] = %ai_civ_gen_casual_stand_idle_twitch_02;

	level.scr_anim[ "generic" ][ "security_stand_loop_1" ][0] = %ch_pentagon_casual_idle_01;
	level.scr_anim[ "generic" ][ "security_stand_loop_2" ][0] = %ch_pentagon_casual_idle_02;
	level.scr_anim[ "generic" ][ "security_stand_loop_3" ][0] = %ch_pentagon_casual_idle_03;




	level.scr_anim[ "generic" ][ "stepaside_behind_left" ]	 = %ch_pentagon_npc_stepaside_back_l02;	 //Gawk
	level.scr_anim[ "generic" ][ "stepaside_behind_right" ]  = %ch_pentagon_npc_stepaside_back_r02;	 //Gawk
	level.scr_anim[ "generic" ][ "stepaside_forward_left" ]	 = %ch_pentagon_npc_stepaside_front_l02; //Gawk
	level.scr_anim[ "generic" ][ "stepaside_forward_right" ] = %ch_pentagon_npc_stepaside_front_r02; //Gawk
	level.scr_anim[ "generic" ][ "stepaside_side_left" ]	   = %ch_pentagon_npc_stepaside_side_l02;	 //Gawk
	level.scr_anim[ "generic" ][ "stepaside_side_right" ]    = %ch_pentagon_npc_stepaside_side_r02;	 //Gawk
	//level.scr_anim[ "generic" ][ "type_chat_front_guya" ] = %ch_pentagon_npc_pool07; 	//guya is stationary
	//level.scr_anim[ "generic" ][ "type_chat_front_guyb" ] = %ch_pentagon_npc_pool08; 	//guyb slides back to guya
	//level.scr_anim[ "generic" ][ "type_chat_side_guya" ] = %ch_pentagon_npc_pool01;		//guya is stationary
	//level.scr_anim[ "generic" ][ "type_chat_side_guyb" ] = %ch_pentagon_npc_pool02;		//guyb slides over to guya
	
	//TEST
	level.scr_anim[ "generic" ][ "type_chat_side_loop_guya" ][0]  = %ch_pentagon_npc_pool01; //guya is stationary
	level.scr_anim[ "generic" ][ "type_chat_side_loop_guyb" ][0]  = %ch_pentagon_npc_pool02; //guyb slides over to guya
	level.scr_anim[ "generic" ][ "type_chat_front_loop_guya" ][0] = %ch_pentagon_npc_pool07; //guya is stationary
	level.scr_anim[ "generic" ][ "type_chat_front_loop_guyb" ][0] = %ch_pentagon_npc_pool08; //guyb slides back to guya
	
	level.scr_anim[ "generic" ][ "type_loop" ][ 0 ] = %ch_pentagon_npc_typing_01;
	level.scr_anim[ "generic" ][ "type_loop" ][ 1 ] = %ch_pentagon_npc_typing_02;
	level.scr_anim[ "generic" ][ "watercooler_guya" ] = %ch_pentagon_npc_pool05; //Fills cup. DOES NOT INTERACT WITH GUYB.
	level.scr_anim[ "generic" ][ "watercooler_guyb" ] = %ch_pentagon_npc_pool06; //Hollers at someone, rounds corner, chats with someone at desk. DOES NOT INTERACT WITH GUYA.

	level.scr_anim[ "generic" ][ "motorcycle_driver" ][0] 	 = %ch_pentagon_bike_ride_generic;
	level.scr_anim[ "generic" ][ "limousine_driver" ] 	 = %crew_jeep1_driver_drive_idle;
	level.scr_anim[ "generic" ][ "limousine_passenger" ] = %crew_jeep1_passenger1_drive_idle;


	level.scr_anim[ "generic" ]["fullbody_rail"] = %ch_pentagon_rail_the_vip_player_full;

	
	//------------------
	//NOTETRACKS
	//------------------
	addNotetrack_customFunction( "generic", "elevator_open",  maps\pentagon_code::elevator_open_doors_top,  "pool_rail_elevator_guya" );
	addNotetrack_customFunction( "generic", "elevator_close", maps\pentagon_code::elevator_close_doors_top,	"pool_rail_elevator_guya" );
	addNotetrack_customFunction( "generic", "fill_cup", maps\pentagon_fx::watercooler_start, "watercooler_guya" );
	addNotetrack_customFunction( "generic", "smoke_exhale", maps\pentagon_fx::smoking_lady, "pool_rail_marvel" );
	addNotetrack_flag( "mcnamara", "limo_scn_2_end", "notetrack_start_camera_cuts", "motorcade_rail_limo" );
	addNotetrack_flag( "kennedy", "start_bloom", "notetrack_start_bloom", "briefing_rail_mission" );
}

#using_animtree( "player" );
init_player_anims()
{
	//FIRST-PERSON BODY
	level.scr_animtree[ "playerbody_firstperson" ] = #animtree;
	level.scr_model[ "playerbody_firstperson" ] = level.player_interactive_model;
	
	//Test
	level.scr_anim[ "playerbody_firstperson" ][ "root" ] = %root;
	
	level.scr_anim[ "playerbody_firstperson" ][ "helipad_landing" ] 				 		= %int_pentagon_intro_player;
	level.scr_anim[ "playerbody_firstperson" ][ "helipad_rail_tarmac" ]		 		= %int_pentagon_tarmack_player;
	level.scr_anim[ "playerbody_firstperson" ][ "helipad_rail_limo" ] 	 		 		= %int_pentagon_limo_player_first;
	level.scr_anim[ "playerbody_firstperson" ][ "motorcade_rail_limo" ] 		 		= %int_pentagon_limo_player_second;
	level.scr_anim[ "playerbody_firstperson" ][ "security_rail_vip" ]   		 		= %ch_pentagon_rail_the_vip_player;
	level.scr_anim[ "playerbody_firstperson" ][ "security_rail_exit" ] 		 		= %ch_pentagon_rail_s_curve_player;
	level.scr_anim[ "playerbody_firstperson" ][ "pool_rail_marvel" ]    		 		= %ch_pentagon_rail_finest_people_player;
	level.scr_anim[ "playerbody_firstperson" ][ "pool_rail_checkin" ]   		 		= %ch_pentagon_rail_we_are_ready_player;
	level.scr_anim[ "playerbody_firstperson" ][ "pool_rail_hall" ] 		 		 		= %ch_pentagon_rail_heroes_leaders_player;
	level.scr_anim[ "playerbody_firstperson" ][ "pool_rail_elevator" ] 		 		= %ch_pentagon_rail_elevator_player;
	level.scr_anim[ "playerbody_firstperson" ][ "pool_rail_elevator_idle" ]	 	= %ch_pentagon_rail_elevator_loop_player;
	level.scr_anim[ "playerbody_firstperson" ][ "warroom_rail_enter" ] 		 		= %ch_pentagon_rail_nerve_center_player;
	level.scr_anim[ "playerbody_firstperson" ][ "warroom_rail_midlanding" ] 		= %ch_pentagon_rail_first_time_player;
	level.scr_anim[ "playerbody_firstperson" ][ "warroom_rail_exit" ] 		   		= %ch_pentagon_rail_rarely_use_player;
	level.scr_anim[ "playerbody_firstperson" ][ "briefing_rail_entrance" ]  		= %ch_pentagon_rail_jfk_entrance_player;
	level.scr_anim[ "playerbody_firstperson" ][ "briefing_rail_mission" ] 	 		= %ch_pentagon_rail_take_care_player;
	level.scr_anim[ "playerbody_firstperson" ][ "briefing_rail_mission_loop" ][0] 	 		= %ch_pentagon_rail_take_care_player_loop;

	
	
	level.scr_animtree[ "playerbody_jfk_firstperson" ] = #animtree;
	level.scr_model[ "playerbody_jfk_firstperson" ] = level.player_interactive_model;
	
	level.scr_animtree[ "playerbody_jfk_pullgun" ] = #animtree;
	level.scr_model[ "playerbody_jfk_pullgun" ] = level.player_interactive_model;	
	
	level.scr_anim[ "playerbody_jfk_pullgun" ][ "pull_gun" ] 	 		= %int_pentagon_player_gunhand_fight;
	

	//effects during the final scene
	addNotetrack_customFunction( "playerbody_firstperson", "timescale_start", ::jfk_time_start, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "timescal_ end", 	::jfk_time_stop, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "movie_01", 				::jfk_movie_1, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "pulse", 					::jfk_pulse, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "gun_animation", 	::jfk_pull_gun, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "movie_02", 				::jfk_movie_2, "briefing_rail_mission" );
	addNotetrack_customFunction( "playerbody_firstperson", "pulse02", 					::jfk_pulse, "briefing_rail_mission" );
	

	//NOTETRACKS
	addNotetrack_customFunction( "playerbody_firstperson", "limo_flash_start", maps\pentagon_code::limo_flashback,	 "motorcade_rail_limo" );
	//addNotetrack_customFunction( "playerbody_firstperson", "speed_start", 		 maps\pentagon_code::timescale_fast, 	 "security_rail_exit" );
	//addNotetrack_customFunction( "playerbody_firstperson", "speed_stop",  		 maps\pentagon_code::timescale_normal, "security_rail_exit" );
	//addNotetrack_customFunction( "playerbody_firstperson", "speed_start", 		 maps\pentagon_code::timescale_fast_security, "security_rail_exit" );
	//addNotetrack_customFunction( "playerbody_firstperson", "speed_stop",  		 maps\pentagon_code::timescale_normal_pool,   "security_rail_exit" );
	//Test
	addNotetrack_customFunction( "playerbody_firstperson", "speed_start", 		 maps\pentagon_fx::set_security_fastforward_visuals, "security_rail_exit" );
	addNotetrack_customFunction( "playerbody_firstperson", "speed_stop",  		 maps\pentagon_fx::set_pool_visuals,   							 "security_rail_exit" );
	
	//THIRD-PERSON BODY
	level.scr_animtree[ "playerbody_thirdperson" ] = #animtree;
	level.scr_model[ "playerbody_thirdperson"	] = "t5_gfl_ump45_body";
	
	level.scr_anim[ "playerbody_thirdperson" ][ "root" ] = %root;

	addNotetrack_customFunction( "playerbody_firstperson", "start_cut", maps\pentagon::e3_security_replace_body_with_full,  "security_rail_vip" );
	
	//TODO: Add third-person animations here.
}


#using_animtree( "vehicles" );
init_vehicle_anims()
{
	//------------------
	//HELICOPTER
	//------------------
	level.scr_animtree[ "helicopter" ] = #animtree;
	level.scr_model[ "helicopter" ] = "vehicle_ch46e_interior";
	
	level.scr_anim[ "helicopter" ][ "helipad_landing" ] = %v_pentagon_chopper_intro;
	level.scr_anim[ "helicopter" ][ "helipad_tarmac" ] = %v_pentagon_chopper_tarmack;
	
	//------------------
	//MOTORCYCLE
	//------------------
	level.scr_animtree[ "motorcycle" ] = #animtree;
	level.scr_model[ "motorcycle" ] = "t5_veh_bike_pentagon";
	
	level.scr_anim[ "motorcycle" ][ "helipad_arrive_0" ] = %v_pentagon_bike01;
	level.scr_anim[ "motorcycle" ][ "helipad_arrive_1" ] = %v_pentagon_bike02;
	level.scr_anim[ "motorcycle" ][ "helipad_arrive_2" ] = %v_pentagon_bike03;
	level.scr_anim[ "motorcycle" ][ "helipad_arrive_3" ] = %v_pentagon_bike04;
	
	level.scr_anim[ "motorcycle" ][ "helipad_peelout_0" ] = %v_pentagon_bike05;
	level.scr_anim[ "motorcycle" ][ "helipad_peelout_1" ] = %v_pentagon_bike06;
	level.scr_anim[ "motorcycle" ][ "helipad_peelout_2" ] = %v_pentagon_bike07;
	level.scr_anim[ "motorcycle" ][ "helipad_peelout_3" ] = %v_pentagon_bike08;
	
	level.scr_anim[ "motorcycle" ][ "bike_ride" ][0] = %v_pentagon_bike_ride_generic;

	//------------------
	//LIMOUSINE
	//------------------
	level.scr_animtree[ "limousine" ] = #animtree;
	level.scr_model[ "limousine" ] = "t5_veh_us_limo"; 

	level.scr_anim[ "limousine" ][ "helipad_arrive" ]  		 = %v_pentagon_limo_arrival;
	level.scr_anim[ "limousine" ][ "helipad_rail_tarmac" ] = %v_pentagon_limo_first;
	level.scr_anim[ "limousine" ][ "helipad_peelout" ] 		 = %v_pentagon_limo_accelerate;
	
	//------------------
	//CAR
	//------------------
	level.scr_animtree[ "car" ] = #animtree;
	level.scr_model[ "car" ] = "t5_veh_military_police_car";
	
	level.scr_anim[ "car" ][ "helipad_arrive_cara" ] = %v_pentagon_sedan_arrival01;
	level.scr_anim[ "car" ][ "helipad_arrive_carb" ] = %v_pentagon_sedan_arrival02;
	level.scr_anim[ "car" ][ "helipad_peelout_cara" ] = %v_pentagon_sedan_accelerate01;
	level.scr_anim[ "car" ][ "helipad_peelout_carb" ] = %v_pentagon_sedan_accelerate02;
}

#using_animtree( "door" );
init_door_anims()
{
	level.scr_animtree[ "door" ] = #animtree;
	
	//level.scr_anim[ "door" ][ "pool_conference_open_idle" ] = %o_pentagon_npc_door_open_loop;
	level.scr_anim[ "door" ][ "pool_conference_shut" ] 		  = %o_pentagon_npc_door_close;
	//level.scr_anim[ "door" ][ "pool_conference_shut_idle" ] = %o_pentagon_npc_door_close_loop;
	
	level.scr_anim[ "door" ][ "security_rail_exit_first_door_left" ]  = %o_pentagon_rail_open_door_assist_door01; //Left door
	level.scr_anim[ "door" ][ "security_rail_exit_first_door_right" ] = %o_pentagon_rail_open_door_assist_door02; //Right door
	level.scr_anim[ "door" ][ "security_rail_exit_second_door_left" ]  = %o_pentagon_rail_s_curve_door01;
	level.scr_anim[ "door" ][ "security_rail_exit_second_door_right" ] = %o_pentagon_rail_s_curve_door02;
	
	level.scr_anim[ "door" ][ "warroom_open_door_left" ]  = %o_pentagon_rail_rarely_use_door01;
	level.scr_anim[ "door" ][ "warroom_open_door_right" ] = %o_pentagon_rail_rarely_use_door02;
}

#using_animtree( "animated_props" );
init_prop_anims()
{
	level.scr_animtree[ "dossier" ] = #animtree;
	level.scr_model[ "dossier" ] = "p_pent_dossier";
	level.scr_anim[ "dossier" ][ "motorcade_rail_limo" ] 			= %o_pentagon_limo_doss_second;
	level.scr_anim[ "dossier" ][ "briefing_rail_entrance" ] 	= %o_pentagon_rail_take_care_dossier;
	
	level.scr_animtree[ "cart" ] = #animtree;
	level.scr_model[ "cart" ] = "anim_pent_av_cart"; //"p_pent_av_cart";
	level.scr_anim[ "cart" ][ "cartpush_hurry" ] = %o_pentagon_cart_cartpush_hurry;
	
	level.scr_animtree[ "chair" ] = #animtree;
	level.scr_model[ "chair" ] = "anim_pent_chair_office_simple";
	level.scr_anim[ "chair" ][ "type_loop" ][0] = %o_pentagon_chair_typing01;
	level.scr_anim[ "chair" ][ "type_loop" ][1] = %o_pentagon_chair_typing02;
	//level.scr_anim[ "chair" ][ "type_chat_side_guya" ] = %o_pentagon_chair_pool01;
	//level.scr_anim[ "chair" ][ "type_chat_side_guyb" ] = %o_pentagon_chair_pool02;
	//level.scr_anim[ "chair" ][ "type_chat_front_guya" ] = %o_pentagon_chair_pool07;
	//level.scr_anim[ "chair" ][ "type_chat_front_guyb" ] = %o_pentagon_chair_pool08;
	level.scr_anim[ "chair" ][ "warroom_moonwalk_guya" ] = %o_pentagon_chair_moon_walk01;
	level.scr_anim[ "chair" ][ "warroom_moonwalk_guyb" ] = %o_pentagon_chair_moon_walk02;
	
	//TEST
	level.scr_anim[ "chair" ][ "type_chat_side_loop_guya" ][0]  = %o_pentagon_chair_pool01;
	level.scr_anim[ "chair" ][ "type_chat_side_loop_guyb" ][0]  = %o_pentagon_chair_pool02;
	level.scr_anim[ "chair" ][ "type_chat_front_loop_guya" ][0] = %o_pentagon_chair_pool07;
	level.scr_anim[ "chair" ][ "type_chat_front_loop_guyb" ][0] = %o_pentagon_chair_pool08;
	
	
	level.scr_animtree[ "chair_mason" ] = #animtree;
	level.scr_model[ "chair_mason" ] = "anim_pent_chair_boardroom";
	level.scr_anim[ "chair_mason" ][ "briefing_rail_entrance" ]  = %o_pentagon_rail_take_care_chair01; //Mason's chair
	level.scr_animtree[ "chair_kennedy" ] = #animtree;
	level.scr_model[ "chair_kennedy" ] = "anim_pent_chair_boardroom";
	level.scr_anim[ "chair_kennedy" ][ "briefing_rail_entrance" ]  = %o_pentagon_rail_take_care_chair02; //Kennedy's chair
	
	level.scr_animtree[ "cigarette" ] = #animtree;
	level.scr_model[ "cigarette" ] = "p_glo_cigarette01";
	level.scr_anim[ "cigarette" ][ "pool_rail_marvel" ] = %o_pentagon_rail_finest_people_cig;

	level.scr_animtree[ "phone" ] = #animtree;
	level.scr_model[ "phone" ] = "anim_pent_phone_office";
	level.scr_anim[ "phone" ][ "security_rail_vip" ] 			= %o_pentagon_rail_the_vip_phone;
	level.scr_anim[ "phone" ][ "pool_rail_checkin_guya" ] = %o_pentagon_rail_we_are_ready_phone;

	level.scr_animtree[ "clipboard" ] = #animtree;
	level.scr_model[ "clipboard" ] = "p_glo_clipboard_wpaper";
	level.scr_anim[ "clipboard" ][ "pool_rail_checkin" ] = %o_pentagon_rail_we_are_ready_clipboard;

	level.scr_animtree[ "coffeemug" ] = #animtree;
	level.scr_model[ "coffeemug" ] = "p_pent_coffeemug";
	
	level.scr_animtree[ "m16" ] = #animtree;
	level.scr_model[ "m16" ] = "t5_weapon_M16A1_world_clean";
}

init_voiceovers()
{
	level.scr_sound["mason"]["mcnamara"] = "vox_pen1_s01_005A_maso_m"; //Secretary McNamara.
	level.scr_sound["mason"]["whendowekill"] = "vox_pen1_s01_011A_maso_m"; //When do I kill him?
	level.scr_sound["mason"]["Mr_president"] = "vox_pen1_s01_037A_maso_m"; //A great honor, Mr. President.

    level.scr_sound["mason"]["taketopentagon"] = "vox_pen1_s01_100A_inte"; //You were cleared for duty and summoned to the Pentagon.
	level.scr_sound["mason"]["hudson_handler"] = "vox_pen1_s01_102A_maso"; //Jason Hudson was my new handler.
	level.scr_sound["mason"]["whypentagon"] = "vox_pen1_s01_103A_inte"; //Why the Pentagon?
	level.scr_sound["mason"]["noclearance"] = "vox_pen1_s01_105A_maso"; //Hudson couldn't tell me. Didn't have clearance.
	level.scr_sound["mason"]["everyone_watching"] = "vox_pen1_s01_108A_maso"; //I felt like everyone was watching us. Watching me.
	level.scr_sound["mason"]["cant_trust"] = "vox_pen1_s01_109A_maso"; //Back then you couldn't trust anyone.
	level.scr_sound["mason"]["evenyourself"] = "vox_pen1_s01_110A_maso"; //Sometimes, even yourself.

	level.scr_sound["mason"]["whywehere"] = "vox_pen1_s01_111A_inte"; //That's why we're here, Mason. To see if we can trust you.
	level.scr_sound["mason"]["watchingyoualltime"] = "vox_pen1_s01_113A_inte"; //We were watching you the whole time.
	level.scr_sound["mason"]["notposssible"] = "vox_pen1_s01_115A_maso"; //That's not possible.
	level.scr_sound["mason"]["wasinpentagon"] = "vox_pen1_s01_116A_inte"; //I was in the Pentagon.

	level.scr_sound["mason"]["numberinhead"] = "vox_pen1_s01_118A_maso"; //I remember. I kept hearing numbers. Couldn't get them out of my head.
	level.scr_sound["mason"]["eatingme"] = "vox_pen1_s01_119A_maso"; //I felt something...eating at me.
	level.scr_sound["mason"]["whatmason"] = "vox_pen1_s01_120A_inte"; //What, Mason?
	level.scr_sound["mason"]["indream"] = "vox_pen1_s01_122A_maso"; //I don't know -- felt like I was in a dream -- -- Step Two, ascend from darkness -- -- Step Three, rain fire --
	level.scr_sound["mason"]["closetoobjective"] = "vox_pen1_s01_123A_inte"; //You were getting close to your objective.
	level.scr_sound["mason"]["wasworking"] = "vox_pen1_s01_125A_inte"; //It was working.
	level.scr_sound["mason"]["Iam"] = "vox_pen1_s01_130A_maso"; //I am.

}



jfk_time_start(guy)
{	
	player = get_players()[0];
	player clientnotify("start_bulging");
	player playsound( "evt_screen_bulge" );
	
	//player thread jfk_dof();
	
	wait(.05);
	
	Start3DCinematic( "kennedy_screens", false, true );
	level notify( "slow_mo_start" );//kevin
	SetTimeScale(0.05);


	//unhide the bink monitors
	for(i=0;i<level.bink_monitors.size;i++)
	{
		switch(level.bink_monitors[i].targetname)
		{
			case "jfk_monitor_1_bink": 		
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON1); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
				
			case "jfk_monitor_2_bink": 		
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON2); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
				
			case "jfk_monitor_3_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON3); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
				
			case "jfk_monitor_4_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON4); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
				
			case "jfk_monitor_5_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON5); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
				
			case "jfk_monitor_6_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON6); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
			case "jfk_monitor_7_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON7); 
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
			
			case "jfk_monitor_8_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON8); 
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
			
			case "jfk_monitor_9_bink":  	
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON9); 	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				break;
			
			case "jfk_monitor_10_bink":  	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON10); 
				break;
			
			case "jfk_monitor_11_bink":  	
				level.bink_monitors[i] show();
				level.static_monitors[i] hide();
				level.bink_monitors[i] setclientflag(level.CLIENT_JFK_MON11); 
				break;
		}
		//wait(.05);
	}
}

/*
jfk_dof()
{
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
	near_start = 10;
	near_end = 200;
	far_start = 1000;
	far_end = 7000;
	near_blur = 6;
	far_blur = 1.8;
	
	self SetDepthOfField(near_start, near_end, far_start, far_end, near_blur, far_blur);
	
	wait(1.0);
	
	lerp_dof_over_time(8.0, 0, 1, 8000, 10000, 6, 0);
	
	self maps\_art::setdefaultdepthoffield();
}
*/


jfk_time_stop(guy)
{
	
	currentTimescale = GetTimescale( "timescale" );
	targetTimescale	 = 1.00;
	lerpTime				 = 0;	
	
	
	//wait(0.5);
	
	player = get_players()[0];	
	wait(0.25);

	SetTimeScale(1);
	level notify( "slow_mo_stop" );//kevin
	player clientnotify("start_bulging");
	player playsound( "evt_screen_bulge" );
	//show the static monitors
	for(i=0;i<level.static_monitors.size;i++)
	{
		level.static_monitors[i] show();
	}
			
	//hide the bink monitors
	for(i=0;i<level.bink_monitors.size;i++)
	{
		level.bink_monitors[i] delete();
	}
	
	//Stop3DCinematic(); 
}

jfk_pulse(guy)
{
	
	level clientnotify("start_bulging");
	player = get_players()[0];
	player playsound( "evt_screen_bulge" );

}

jfk_movie_1(guy)
{
	//IPrintLnBold( "JFK MOV 1" );//kevin
	playsoundatposition ("evt_shocking_2", (0,0,0));
	pause_jfk_anim();
	
	//temp movie placeholder
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "jfk_flash_1", false, true );
	wait(.75);
	hud_utility_hide();
	Stop3DCinematic(); 
	//IPrintLnBold( "STOP JFK MOV 1" );//kevin
	
	unpause_jfk_anim();
	
}

jfk_pull_gun(guy)
{
	pause_jfk_anim();

	level.fake_arms = spawn_anim_model("playerbody_jfk_pullgun");
	level.fake_arms.origin = level.playerbody_firstperson.origin;
	level.fake_arms.angles = level.playerbody_firstperson.angles;
	
	level.fake_arms.gun = spawn("script_model",level.fake_arms gettagorigin("tag_weapon") );
	level.fake_arms.gun.angles = level.fake_arms gettagangles("tag_weapon");
	level.fake_arms.gun setmodel("t5_weapon_1911_lh_world");
	
	level.fake_arms.gun linkto(level.fake_arms,"tag_weapon");
	player = get_players()[0];
	get_players()[0].playerbody_firstperson hide();
	
	player = get_players()[0];
	old_angles = player.angles;
	old_origin = player.origin;
	player playerlinktoabsolute(level.fake_arms,"tag_player");
	playsoundatposition ("mid_pentagon_jfk_flash_1", (0,0,0));	
	time = getanimlength(level.scr_anim[ "playerbody_jfk_pullgun" ][ "pull_gun" ]);
	level.anim_structs[ "warroom_rail" ] thread anim_single_aligned( level.fake_arms,  "pull_gun" );
	
	wait(time -.15);
	level clientnotify("start_bulging");
	player playsound( "evt_screen_bulge" );
	wait(.75);
	level.fake_arms hide();
	level.fake_arms.gun hide();
	player setplayerangles(old_angles);
	player setorigin(old_origin);
	player unlink();
	player player_linkto_delta( get_players()[0].playerbody_firstperson, "tag_player" );
	
	unpause_jfk_anim();
	
	//wait(.5);


}

jfk_movie_2(guy)
{
	
	level.fake_arms.gun delete();
	level.fake_arms delete();
	//get_players()[0].playerbody_firstperson show();
	//IPrintLnBold( "JFK MOV 2" );//kevin
	playsoundatposition ("evt_shocking_2", (0,0,0));
	pause_jfk_anim();
	
	//temp movie placeholder
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "jfk_flash_2", false, true );
	wait(.75);
	hud_utility_hide();
	Stop3DCinematic();
	//IPrintLnBold( "STOP JFK MOV 2" );//kevin
	
	unpause_jfk_anim();

}
	

pause_jfk_anim()
{
	
	level.kennedy SetFlaggedAnimLimited("single anim", level.scr_anim["kennedy"]["briefing_rail_mission"],1,0,0);
	level.playerbody_firstperson SetFlaggedAnimLimited("single anim", level.scr_anim["playerbody_firstperson"]["briefing_rail_mission"],1,0,0);
	level.chairMason SetFlaggedAnimLimited("single anim", level.scr_anim["chair_mason"]["briefing_rail_entrance"],1,0,0);
	level.chairKennedy SetFlaggedAnimLimited("single anim", level.scr_anim["chair_kennedy"]["briefing_rail_entrance"],1,0,0);
	level.dossier SetFlaggedAnimLimited("single anim", level.scr_anim["dossier"]["briefing_rail_entrance"],1,0,0);
	level.hudson  SetFlaggedAnimLimited("single anim", level.scr_anim["hudson"]["briefing_rail_mission"],1,0,0);
	level.mcnamara SetFlaggedAnimLimited("single anim", level.scr_anim["mcnamara"]["briefing_rail_mission"],1,0,0);
	
}

unpause_jfk_anim()
{
	level.kennedy SetFlaggedAnimLimited("single anim", level.scr_anim["kennedy"]["briefing_rail_mission"],1,0,1);
	level.playerbody_firstperson SetFlaggedAnimLimited("single anim", level.scr_anim["playerbody_firstperson"]["briefing_rail_mission"],1,0,1);
	level.chairMason SetFlaggedAnimLimited("single anim", level.scr_anim["chair_mason"]["briefing_rail_entrance"],1,0,1);
	level.chairKennedy SetFlaggedAnimLimited("single anim", level.scr_anim["chair_kennedy"]["briefing_rail_entrance"],1,0,1);
	level.dossier SetFlaggedAnimLimited("single anim", level.scr_anim["dossier"]["briefing_rail_entrance"],1,0,1);
	level.hudson  SetFlaggedAnimLimited("single anim", level.scr_anim["hudson"]["briefing_rail_mission"],1,0,1);
	level.mcnamara SetFlaggedAnimLimited("single anim", level.scr_anim["mcnamara"]["briefing_rail_mission"],1,0,1);
}

/*
lerp_dof_over_time( time, Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur )
{
	Default_Near_Start = 0;
	Default_Near_End = 1;
	Default_Far_Start = 8000;
	Default_Far_End = 10000;
	Default_Near_Blur = 6;
	Default_Far_Blur = 0;
	
	Near_Start = 0;
	Near_End = 115;
	Far_Start = 1000;
	Far_End = 9286;
	Near_Blur = 4;
	Far_Blur = 1.03;
	
	incs = int( time/.05 );
	
	incNearStart = ( Default_Near_Start - Near_Start ) / incs;
	incNearEnd = ( Default_Near_End - Near_End ) / incs;
	incFarStart = ( Default_Far_Start - Far_Start ) / incs;
	incFarEnd = ( Default_Far_End - Far_End ) / incs;
	incNearBlur = ( Default_Near_Blur - Near_Blur ) / incs;
	incFarBlur = ( Default_Far_Blur - Far_Blur ) / incs;
	
	current_NearStart = Near_Start;
	current_NearEnd = Near_End;
	current_FarStart = Far_Start;
	current_FarEnd = Far_End;
	current_NearBlur = Near_Blur;
	current_FarBlur = Far_Blur;
	
	for ( i = 0; i < incs; i++ )
	{
		self SetDepthOfField( current_NearStart, current_NearEnd, current_FarStart, current_FarEnd, current_NearBlur, current_FarBlur );	
		
		current_NearStart += incNearStart;
		current_NearEnd += incNearEnd;
		current_FarStart += incFarStart;
		current_FarEnd += incFarEnd;
		current_NearBlur += incNearBlur;
		current_FarBlur += incFarBlur;
		
		wait .05;
	}
}
*/