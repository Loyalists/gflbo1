#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_music;

#using_animtree ("creek_1");
main()
{

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter scene ----
// --------------------------------------------------------------------------------

	event1_setup_player_anims();
	event1_setup_ai_anims();
	event1_setup_prop_anims();

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Meatshield scene ----
// --------------------------------------------------------------------------------

	event2_setup_player_anims();
	event2_setup_ai_anims();
	event2_setup_prop_anims();

/#	
	//ACB DEBUG
	//debug_strength_test_anims();
#/	
}


// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter scene ----
// --------------------------------------------------------------------------------

event1_setup_player_anims()
{
	// player hands model
	level.scr_animtree["player_hands"] 	        		 = #animtree;
	level.scr_model["player_hands"] 		    		 = "t5_gfl_ump45_viewbody";

	// player
	level.scr_anim["player_hands"]["crash_wake_up"]		 = %int_creek_b01_huey_crash_player_start_loop;
	
	level.scr_anim["player_hands"]["crash"]        		 = %int_creek_b01_huey_crash_player;
	addNotetrack_customFunction( "player_hands", "touch_water", maps\creek_1_start_fx::event1_player_hand_touch_water,  "crash" );
	addNotetrack_customFunction( "player_hands", "start_firing_into_huey", maps\creek_1_start_fx::event1_player_hand_fire_into_huey, "crash" );
		
	level.scr_anim["player_hands"]["crash_fall"]         = %int_creek_b01_huey_crash_player_fall;
	addNotetrack_customFunction( "player_hands", "below_water_first", ::event1_player_below_water_first_time,  "crash_fall" );
	addNotetrack_customFunction( "player_hands", "above_water", ::event1_player_below_water_above_again,  "crash_fall" );
	addNotetrack_customFunction( "player_hands", "below_water", ::player_below_water,  "crash_fall" );
	
	//ACB DEBUG
	level.crash_fall = GetAnimLength(level.scr_anim["player_hands"]["crash_fall"]);
	
	level.scr_anim["player_hands"]["crash_at_door"]      = %int_creek_b01_huey_crash_player_at_door_loop;
	// -- WWILLIAMS: NEW ANIMATIONS FOR THE TWO STAGE DOOR PULL
	//level.scr_anim[ "player_hands" ][ "crash_huey_door_start" ] = %int_creek_b01_huey_crash_player_open_door_intro;
	level.scr_anim[ "player_hands" ][ "crash_huey_door_end" ] = %int_creek_b01_huey_crash_player_open_door_exit;
	level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_1" ] = %int_creek_b01_huey_crash_player_open_door_phase1;
	level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_1_loop" ] = %int_creek_b01_player_loop1;
	//level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_2" ] = %int_creek_b01_huey_crash_player_open_door_phase2;
	//level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_2_loop" ] = %int_creek_b01_player_loop2;
	addNotetrack_customFunction( "player_hands", "fog_switch", ::player_fog_switch,  "crash_huey_door_end" );
	
	//ACB DEBUG
	level.crash_huey_door_end = GetAnimLength(level.scr_anim[ "player_hands" ][ "crash_huey_door_end" ]);
	level.crash_huey_strength_test_1_loop = GetAnimLength(level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_1_loop" ]);
	level.crash_huey_strength_test_1 = GetAnimLength(level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_1" ]);
	//level.crash_huey_strength_test_2_loop = GetAnimLength(level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_2_loop" ]);
	//level.crash_huey_strength_test_2 = GetAnimLength(level.scr_anim[ "player_hands" ][ "crash_huey_strength_test_2" ]);
	
	// level.scr_anim["player_hands"]["crash_open_door"]    = %int_creek_b01_huey_crash_player_open_door; 
	// addNotetrack_customFunction( "player_hands", "open_door", ::player_open_door,  "crash_open_door" );
	// addNotetrack_customFunction( "player_hands", "fog_switch", ::player_fog_switch,  "crash_open_door" );

	// setup dialogue
	event1_player_notetrack_dialogue_and_sounds();
}

// this function tells the main level to let reznov open the door
// also plays some sounds for opening door for collin
player_open_door( guy )
{
	flag_set( "reznov_open_door" );
	
	player = get_players()[0];

	// enable swimming so that the visionset transition happens, but dont show the swimming arms yet.
	level enable_swimming();

	// sound changes
	player clientnotify( "hlo" );
	//playsoundatposition( "vox_carter_heli_door", (0,0,0) );
}

player_fog_switch( guy )
{
	// tell clientscript to change the fog settings
	player = get_players()[0];
	player clientnotify("change_heli_water_fog");
}

// this function tells the script that player is submerged below the water.
player_below_water( guy )
{
	flag_set( "player_below_water" );
}

#using_animtree ("generic_human");
event1_setup_ai_anims()
{
	// barnes 		
	level.scr_anim["barnes"]["crash"]         	 = %ch_creek_b01_huey_crash_barnes;
	level.scr_anim["barnes"]["crash_fall"]       = %ch_creek_b01_huey_crash_barnes_fall;
	level.scr_anim["barnes"]["crash_open_door_loop"][0]  = %ch_creek_b01_huey_woods_loop_at_door;
	level.scr_anim["barnes"]["crash_open_door"]  = %ch_creek_b01_huey_crash_barnes_exit;
	level.scr_anim["barnes"]["crash_open_door_swim"] = %ch_creek_b01_huey_woods_swim_away;			

	// reznov 
	//level.scr_anim["reznov"]["crash"] 			     = %ch_creek_b01_huey_crash_reznov;
	// level.scr_anim["reznov"]["crash_open_door"]      = %ch_creek_b01_huey_crash_reznov_open_door;
	// level.scr_anim["reznov"]["crash_open_door_exit"] = %ch_creek_b01_huey_crash_reznov_exit;
	level.scr_anim["reznov"]["crash_approach"]						= %ch_creek_b01_huey_crash_reznov_approach;
	//level.scr_anim["reznov"]["crash_door_loop"] 			     = %ch_creek_b01_huey_crash_reznov_door_loop;
	level.scr_anim["reznov"]["crash_door_open"] 			     = %ch_creek_b01_huey_crash_reznov_door_open;
	level.scr_anim["reznov"]["crash_door_exit"] 			     = %ch_creek_b01_huey_crash_reznov_door_exit;
	
	level.scr_anim["reznov"]["sampan_wait"] 			    	 	= %ch_creek_b01_huey_crash_reznov_sampan_wait;
	level.scr_anim["reznov"]["sampan_kill_sign"] 			     = %ch_creek_b01_huey_crash_reznov_killsign;
	
	//ACB DEBUG
	level.crash_door_open = GetAnimLength(level.scr_anim["reznov"]["crash_door_open"]);
	level.crash_door_exit = GetAnimLength(level.scr_anim["reznov"]["crash_door_exit"]);	
	
	
	// pilot
	level.scr_anim["pilot"]["start_loop"][0]     = %ch_creek_b01_huey_pilot_start_loop;
	level.scr_anim["pilot"]["crash"]         	 = %ch_creek_b01_huey_crash_pilot;
	level.scr_anim["pilot"]["crash_loop"][0]     = %ch_creek_b01_huey_crash_pilot_loop;
	
	// copilot 
	level.scr_anim["copilot"]["crash"]         	 = %ch_creek_b01_huey_crash_copilot;
	level.scr_anim["copilot"]["crash_loop"][0]   = %ch_creek_b01_huey_crash_copilot_loop;
	addNotetrack_customFunction( "copilot", "copilot_shot", maps\creek_1_start_fx::event1_copilot_shot,  "crash" );
	addNotetrack_customFunction( "copilot", "vox_Cre1_s01_208A_COP1", ::copilot_predeath_audio, "crash" );
		
	// VC1 
	level.scr_anim["vc1"]["crash"]         		 = %ch_creek_b01_huey_crash_VC1;
	level.scr_anim["vc1"]["crash_shoot_loop"][0] = %ch_creek_b01_huey_crash_VC1_shoot_loop;
	level.scr_anim["vc1"]["crash_death"]         = %ch_creek_b01_huey_crash_VC1_death;
	level.scr_anim["vc1"]["crash_death_loop"][0] = %ch_creek_b01_huey_crash_VC1_death_loop;	


	// VC2
	level.scr_anim["vc2"]["crash"]        	 	 = %ch_creek_b01_huey_crash_VC2;
	level.scr_anim["vc2"]["crash_shoot_loop"][0] = %ch_creek_b01_huey_crash_VC2_shoot_loop;
	level.scr_anim["vc2"]["crash_death"]         = %ch_creek_b01_huey_crash_VC2_death;
	level.scr_anim["vc2"]["crash_death_loop"][0] = %ch_creek_b01_huey_crash_VC2_death_loop;	

	// setup dialogue for copilot
	// setup dialogue for barnes
	event1_copilot_notetrack_dilogue();
	event1_barnes_notetrack_dialogue();
}

#using_animtree ("creek_1");
event1_setup_prop_anims()
{
	// huey
	level.scr_anim["chopper"]["fall"]			 = %v_creek_b01_huey_crash_chopper_fall;
	
	//level.scr_anim["chopper"]["crash_open_door"] = %v_creek_b01_huey_crash_chopper_open;
	
	
	//ACB DEBUG
	level.fall = GetAnimLength(level.scr_anim["chopper"]["fall"]);
	
	// huey door
	level.scr_anim[ "chopper" ][ "huey_door_open_stage_1" ] = %v_creek_b01_huey_crash_chopper_open_pz1;
	level.scr_anim[ "chopper" ][ "huey_door_open_stage_1_loop" ] = %v_creek_b01_huey_crash_chopper_open_pz1_loop;	
	//level.scr_anim[ "chopper" ][ "huey_door_open_stage_2" ] = %v_creek_b01_huey_crash_chopper_open_pz2;
	//level.scr_anim[ "chopper" ][ "huey_door_open_stage_2_loop" ] = %v_creek_b01_huey_crash_chopper_open_pz2_loop;
	//level.scr_anim[ "chopper" ][ "huey_door_open_stage_3" ] = %v_creek_b01_huey_crash_chopper_open_pz3;
	
	//ACB DEBUG
	level.huey_door_open_stage_1_loop = GetAnimLength(level.scr_anim[ "chopper" ][ "huey_door_open_stage_1_loop" ]);
	level.huey_door_open_stage_1 =GetAnimLength(level.scr_anim[ "chopper" ][ "huey_door_open_stage_1" ]);
	//level.huey_door_open_stage_2_loop = GetAnimLength(level.scr_anim[ "chopper" ][ "huey_door_open_stage_2_loop" ]);
	//level.huey_door_open_stage_2 = GetAnimLength(level.scr_anim[ "chopper" ][ "huey_door_open_stage_2" ]);

	// sampan 	
	level.scr_anim["sampan6"]["crash"]           = %v_creek_b01_huey_crash_sampan;
	level.scr_anim["sampan6"]["crash_loop"][0]   = %v_creek_b01_huey_crash_sampan_loop;
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Meatshield scene ----
// --------------------------------------------------------------------------------

event2_setup_player_anims()
{
	// player
	level.scr_animtree["player_meatshield_hands"] 	        	 = #animtree;
	level.scr_model["player_meatshield_hands"]			 		 = "t5_gfl_ump45_viewmodel_player";
	level.scr_anim["player_meatshield_hands"]["player_run_up_front"]	 = %int_creek_b01_ms_player_run_up_front;
	level.scr_anim["player_meatshield_hands"]["player_run_up_mid"]	 	 = %int_creek_b01_ms_player_run_up_mid_boat;
	level.scr_anim["player_meatshield_hands"]["player_run_up_behind"]	 = %int_creek_b01_ms_player_run_up_back_of_boat;
	
}


#using_animtree ("generic_human");
event2_setup_ai_anims()
{
	// vc1	
	level.scr_anim["vc1"]["search_loop"][0]     = %ch_creek_b01_ms_vc1;

	// vc2
	level.scr_anim["vc2"]["search_loop"][0]     = %ch_creek_b01_ms_vc2_search_loop;
	level.scr_anim["vc2"]["alerted"] 	  		= %ch_creek_b01_ms_vc2_alerted;
	level.scr_anim["vc2"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc2_shoot_loop;
	level.scr_anim["vc2"]["special_death"] 	  	= %ch_creek_b01_ms_VC2_death;

	// vc3
	level.scr_anim["vc3"]["search_loop"][0]     = %ch_creek_b01_ms_vc3_search_loop;
	level.scr_anim["vc3"]["alerted"] 	  		= %ch_creek_b01_ms_vc3_alerted;
	level.scr_anim["vc3"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc3_shoot_loop;
	level.scr_anim["vc3"]["special_death"] 	  	= %ch_creek_b01_ms_VC3_death;
	
	// vc4
	level.scr_anim["vc4"]["search_loop"][0]     = %ch_creek_b01_ms_vc4_search_loop;
	level.scr_anim["vc4"]["alerted"] 	  		= %ch_creek_b01_ms_vc4_alerted;
	level.scr_anim["vc4"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc4_shoot_loop;
	level.scr_anim["vc4"]["special_death"] 	  	= %ch_creek_b01_ms_VC4_death;

	// vc5
	level.scr_anim["vc5"]["search_loop"][0]     = %ch_creek_b01_ms_vc5_search_loop;
	level.scr_anim["vc5"]["alerted"] 	  		= %ch_creek_b01_ms_vc5_alerted;
	level.scr_anim["vc5"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc5_shoot_loop;
	level.scr_anim["vc5"]["special_death"] 	  	= %ch_creek_b01_ms_VC5_death;

	// vc6
	level.scr_anim["vc6"]["search_loop"][0]     = %ch_creek_b01_ms_vc6_search_loop;
	level.scr_anim["vc6"]["alerted"] 	  		= %ch_creek_b01_ms_vc6_alerted;
	level.scr_anim["vc6"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc6_shoot_loop;
	level.scr_anim["vc6"]["special_death"] 	  	= %ch_creek_b01_ms_VC6_death;

	// vc7
	level.scr_anim["vc7"]["search_loop"][0]     = %ch_creek_b01_ms_vc7_search_loop;
	level.scr_anim["vc7"]["alerted"] 	  		= %ch_creek_b01_ms_vc7_alerted;
	level.scr_anim["vc7"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc7_shoot_loop;
	level.scr_anim["vc7"]["special_death"] 	  	= %ch_creek_b01_ms_VC7_death;
	
	// vc10 - vc woods kills when player can see him
	level.scr_anim["vc10"]["search_loop"][0]     = %ch_creek_b01_ms_vc10_search_loop;
	level.scr_anim["vc10"]["shoot_loop"][0] 		= %ch_creek_b01_ms_vc10_shoot_loop;
	level.scr_anim["vc10"]["special_death"] 	  = %ch_creek_b01_ms_VC10_death;
	
	//woods grabbing and killing vc10
	level.scr_anim["barnes"]["special_death"]     = %ch_creek_b01_ms_woods_sampan_melee;
}

#using_animtree ("creek_1");
event2_setup_prop_anims()
{
	// sampan 1
	level.scr_anim["sampan1"]["meatshield"] 		  = %v_creek_b01_ms_sampan1;
	level.scr_anim["sampan1"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan1_loop;
	
	// sampan 2
	level.scr_anim["sampan2"]["meatshield"] 		  = %v_creek_b01_ms_sampan2;
	level.scr_anim["sampan2"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan2_loop;

	// sampan 3
	level.scr_anim["sampan3"]["meatshield"] 		  = %v_creek_b01_ms_sampan3;
	level.scr_anim["sampan3"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan3_loop;

	// sampan 4
	level.scr_anim["sampan4"]["meatshield"] 		  = %v_creek_b01_ms_sampan4;
	level.scr_anim["sampan4"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan4_loop;

	// sampan 5
	level.scr_anim["sampan5"]["meatshield"] 		  = %v_creek_b01_ms_sampan5;
	level.scr_anim["sampan5"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan5_loop;

	// sampan 6
	level.scr_anim["sampan6"]["meatshield"] 		  = %v_creek_b01_ms_sampan6;
	level.scr_anim["sampan6"]["meatshield_loop"][0]	  = %v_creek_b01_ms_sampan6_loop;	
}


// --------------------------------------------------------------------------------
// ---- EVENT 2 - Sound notetrack setup ----
// --------------------------------------------------------------------------------
event1_copilot_notetrack_dilogue()
{
	// Frame = When the CoPilot starts reaching out towards the Pilot
	addNotetrack_dialogue( "copilot", "vox_Cre1_s01_206A_COP1", "crash", "vox_cre1_s01_011A_usc1" );

	// Frame = As Carter drops the body and starts to turn around
	addNotetrack_dialogue( "copilot", "vox_Cre1_s01_208A_COP1", "crash", "vox_cre1_s01_017A_usc1" );
}


event1_barnes_notetrack_dialogue()
{
	// Frame = Directly before he motions towards the front. The second part of his line should fall on the hand movement
	addNotetrack_dialogue( "barnes", "vox_Cre1_s01_204A_BARN", "crash", "vox_cre1_s01_010A_wood" );
	
	// Frame = As Carter grabs the gun
	addNotetrack_dialogue( "barnes", "vox_Cre1_s01_210A_BARN", "crash", "vox_cre1_s01_019A_wood" );

	// Frame = As the helicopter begins to collapse
	addNotetrack_dialogue( "barnes", "vox_Cre1_s01_211A_BARN", "crash_fall", "vox_cre1_s01_021A_wood" );
}


event1_player_notetrack_dialogue_and_sounds()
{
	// Frame = As Carter is moving towards the front of the Helicopter. Right after the start of his move
	//addNotetrack_dialogue( "player_hands", "vox_Cre1_s01_205A_CART", "crash", "vox_cre1_s01_013A_maso" );
	addNotetrack_customFunction( "player_hands", "move_forward", ::level_notify_player_move_forward, "crash" );
	
	// Frame = As Carter is lifts the pilots body up
	//addNotetrack_dialogue( "player_hands", "vox_Cre1_s01_207A_CART", "crash", "vox_cre1_s01_015A_maso" );
	addNotetrack_customFunction( "player_hands", "grabs_pilot", ::level_notify_player_grabs_pilot, "crash" );
	
	// Frame = Directly after the CoPilot is shot
	//addNotetrack_dialogue( "player_hands", "vox_Cre1_s01_209A_CART", "crash", "vox_cre1_s01_018A_maso" );
	addNotetrack_customFunction( "player_hands", "pilot_shot", ::level_notify_pilot_shot, "crash" );
	
	//setmusicstate("INTRO");
}

level_notify_player_move_forward( guy )
{
	level notify( "player_move_to_huey_front" );
}

level_notify_player_grabs_pilot( guy )
{
	level notify( "player_grabs_pilot" );
}

level_notify_pilot_shot( guy )
{
	autosave_by_name( "creek_1_pilotshot" );
	level notify( "pilot_shot_in_head" );
}

event1_player_scripted_intro_dialogue()
{
	// Frame = Start of the scene, as Carter is looping his dazed animation
	wait(2);
	playsoundatposition( "vox_carter_start", (0,0,0) );
}

event1_copilot_scripted_intro_dialogue()
{
	// Frame = Start of the scene, as Carter is looping his dazed animation
	wait(4.5);
	pilot = level.pilots[0];
	pilot PlaySound( "vox_cre1_s01_005A_usc1", "sounddone" );
	pilot waittill( "sounddone" );
	wait(3);
	pilot PlaySound( "vox_cre1_s01_006A_usc1" );
}

event1_player_below_water_first_time( guy )
{
	// Collin, we should play below water sound here
	player = get_players()[0];

	flag_set("event1_player_below_water_first_time");
	player clientNotify( "s01uw1" );
}

event1_player_below_water_above_again( guy )
{
	// Collin, we should play above water sound here
	player = get_players()[0];

	player clientNotify( "s01aw1" );
}

event1_player_talk_to_barnes()
{
	flag_wait( "player_woke_up" );

	// Frame = Last � of the dazed loop anim, before he turns to look at Barnes
	playsoundatposition( "vox_cre1_s01_009A_maso", ( 0,0,0 ) );
}

copilot_predeath_audio( guy )
{
	clientNotify( "cop_str" );
}

/#

//acb 03.31.10 checks to make sure all strength test anims are correct
debug_strength_test_anims()
{
	//exits player and reznov
	//AssertEx( level.crash_huey_door_end == level.crash_door_exit, "crash_huey_door_end AND crash_door_exit are not the same length" );
	
	//chopper exit and player exit
	//AssertEx( level.huey_door_open_stage_1 == level.crash_huey_door_end, "huey_door_open_stage_1 AND crash_huey_door_end are not the same length" );
	
	//chopper exit and reznov exit
	//AssertEx( level.huey_door_open_stage_1 == level.crash_door_exit, "huey_door_open_stage_1 AND crash_door_exit are not the same length" );
	
	AssertEx( level.crash_fall == level.fall, "crash_fall AND fall are not the same length" );
	AssertEx( level.crash_huey_strength_test_1_loop == level.huey_door_open_stage_1_loop, "crash_huey_strength_test_1_loop AND huey_door_open_stage_1_loop are not the same length" );
	AssertEx( level.crash_huey_strength_test_1 == level.huey_door_open_stage_1, "crash_huey_strength_test_1 AND huey_door_open_stage_1 are not the same length" );
	//AssertEx( level.crash_huey_strength_test_2_loop == level.huey_door_open_stage_2_loop, "crash_huey_strength_test_2_loop AND huey_door_open_stage_2_loop are not the same length" );
	AssertEx( level.crash_huey_strength_test_2 == level.huey_door_open_stage_2, "crash_huey_strength_test_2 AND huey_door_open_stage_2 are not the same length" );
	
	
	//IPrintLnBold("DONE CHECKING ANIM LENGTHS");
}
#/