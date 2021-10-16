#include maps\_utility;
#include maps\_anim; 
#include common_scripts\utility;
#include maps\_music;

main()
{	
	init_npc_animation();
	init_player_animation();
	init_vehicle_animation();
	init_object_animation();
	init_voice();

	level thread wait_til_fridge_move();
	level thread move_cache_fridge();
	level thread hide_heli();
	level thread init_clark_death();
	level thread init_clark_death_dof_and_fog();

	level thread platform_death_triggers();

}

precaches_anim_string()
{
	PreCacheString( &"KOWLOON_INTERROGATION_BREAK_GLASS");
	PreCacheString( &"KOWLOON_INTERROGATION_PUNCH");
}

/*
Notetracks
Landing- for both

On weavers push out
Switch then spawn

On clarks push out
Start_dust
Stop_dust

*/

#using_animtree("animated_props");
init_object_animation()
{
		
	level.scr_anim["fridge"]["cache_move"] = %o_kowloon_b01_fridge_push;

	level.scr_anim["fridge"]["cache_loop"] = %o_kowloon_b01_fridge_loop;
	level.scr_anim["door"]["cache_out"] = %o_kowloon_b01_fridge_push_door;
	level.scr_anim["chair"]["inter_chair"] = %o_kowloon_b01_intro_chair;
	level.scr_anim["table"]["inter_table"] = %o_kowloon_b01_intro_table;
	level.scr_anim["glass"]["inter_glass"] = %o_kowloon_b01_intro_glass;

	//shabs
	//level.scr_anim["glass"]["inter_chair_punch"] = %o_kowloon_b01_intro_chair_punch;

	level.scr_anim["hatch"]["inter_hatch"] = %o_kowloon_b01_intro_hatch;
	level.scr_anim["gutter"]["clark_death_gutter"] = %o_kowloon_b07_clarkdeath_gutter;

}

#using_animtree ("vehicles");
init_vehicle_animation()
{
	level.scr_anim["hip"]["heli_fly_in"] = %v_kowloon_b04_destroy_home_heli;
	addNotetrack_customFunction("hip", "start_clark", ::start_clark_animation_flag, "heli_fly_in");
	addNotetrack_customFunction("hip", "heli_build", ::heli_building_impact, "heli_fly_in");
	addNotetrack_customFunction("hip", "heli_roof", ::heli_roof_crash, "heli_fly_in");
	addNotetrack_customFunction("hip", "start_spetz", ::start_spetz_clark_home_explode, "heli_fly_in");
//	addNotetrack_customFunction("hip", "???", ::start_clark_animation_flag, "heli_fly_in");

	level.scr_anim["van"]["van_crash"] = %v_kowloon_b07_vancrash_van;
}

//
start_clark_animation_flag( hip )
{
	flag_set("e4_start_clark_animation");
}

loop_npc_idle_animation(sync_node, animation, endon_notify)
{
	level endon(endon_notify);	

	while(1)
	{
		sync_node anim_single_aligned(self, animation);
	}
}


#using_animtree ("generic_human");
init_npc_animation()
{
	//-------------------------------------------
	// CLARK
	//-------------------------------------------

	// Interrogation
	level.scr_anim["clarke"]["in"] = %ch_kowloon_b01_intro_clark_in;
	level.scr_anim["clarke"]["glass_idle"] = %ch_kowloon_b01_intro_clark_glass_idle;
	level.scr_anim["clarke"]["glass"] = %ch_kowloon_b01_intro_clark_glass;
	level.scr_anim["clarke"]["punch_idle"] = %ch_kowloon_b01_intro_clark_punch_idle;
	level.scr_anim["clarke"]["punch"] = %ch_kowloon_b01_intro_clark_punch;
	addNotetrack_customFunction("clarke", "punch", ::clarke_punched, "punch");
	level.scr_anim["clarke"]["out"] = %ch_kowloon_b01_intro_clark_out;
	addNotetrack_customFunction("clarke", "punch", ::clarke_punched, "out");
	addNotetrack_customFunction("clarke", "spit", ::clarke_spit, "out");
	addNotetrack_customFunction("clarke", "audio_loop_start", ::audio_start_idle_loop, "punch_idle");
	addNotetrack_customFunction("clarke", "punch", ::audio_stop_idle_loop, "punch");
	addNotetrack_customFunction("clarke", "punch", ::audio_stop_idle_loop, "out");

	level.scr_anim["clarke"]["table_idle"] = %ch_kowloon_b01_intro_clark_table_idle;
	level.scr_anim["clarke"]["escape"] = %ch_kowloon_b01_intro_clark_escape;
	
	// E2 Matress jump
	level.scr_anim["clarke"]["kowloon_mattress_jump"]	= %ch_kowloon_b01_first_jump_clark;
	level thread addNotetrack_customFunction("clarke", "Landing", ::landing_dust_fx, "kowloon_mattress_jump");

	// E3 Cache room
	level.scr_anim["clarke"]["fridge_loop"] = %ch_kowloon_b01_fridge_clark_loop;
	level.scr_anim["clarke"]["fridge_push"] = %ch_kowloon_b01_fridge_push_clark;
	level thread addNotetrack_customFunction("clarke", "Start_dust", ::play_fridge_dust, "fridge_push");
	level.scr_anim["clarke"]["fridge_wait"] = %ch_kowloon_b01_fridge_push_wait_clark;
	level.scr_anim["clarke"]["fridge_out"] = %ch_kowloon_b01_fridge_push_out_clark;

	// E4 Pipe slide
	level.scr_anim["clarke"]["pipe_slide"] = %ch_kowloon_b04_pipe_slide_clark;
	level.scr_anim["clarke"]["temple_roof"] = %ch_kowloon_b04_rooftop_traversal_b;

	// E5 Destroy apartment
	level.scr_anim["clarke"]["heli_clark"] = %ch_kowloon_b04_destroy_home_clark;
	level.scr_anim["clarke"]["heli_clark_loop"][0] = %ch_kowloon_b04_destroy_home_clark_loop;

	//addNotetrack_customFunction("clarke", "attach", ::play_detonator_light, "heli_clark");

	addNotetrack_attach( "clarke", "attach", "weapon_claymore_detonator", "TAG_WEAPON_LEFT", "heli_clark" );
	addNotetrack_detach( "clarke", "detach", "weapon_claymore_detonator", "TAG_WEAPON_LEFT", "heli_clark" );
	addNotetrack_customFunction("clarke", "drop", ::cache_door_open, "heli_clark");

	// E6 Clark unlock
	level.scr_anim["clarke"]["unlock_start"] = %ch_kowloon_b06_clark_move2lock;
	level.scr_anim["clarke"]["unlock_end"] = %ch_kowloon_b06_clark_open2stand;
	level.scr_anim["clarke"]["unlock_loop"] = %ch_kowloon_b06_clark_unlockloop;

	level.scr_anim["clarke"]["heli_clark"] = %ch_kowloon_b04_destroy_home_clark;

	// E7 Jump and death
	level.scr_anim["clarke"]["jump"] = %ch_kowloon_b07_clarkdeath_clark_jump;
	level.scr_anim["clarke"]["jump_loop"] = %ch_kowloon_b07_clarkdeath_clark_loop;
	level.scr_anim["clarke"]["jump_death"] = %ch_kowloon_b07_clarkdeath_clark;
	addNotetrack_customFunction("clarke", "shot", ::clarke_headshot, "jump_death");
	addNotetrack_customFunction("clarke", "sign", ::clarke_sign_hit, "jump_death");


/*
FRAME 447 "foot_rumble"
FRAME 450 "foot_rumble"
FRAME 458 "foot_rumble"
FRAME 467 "foot_rumble"
FRAME 506 "landing"
FRAME 650 "hand_grab"
FRAME 1136 "pull_up"
*/

	//-------------------------------------------
	// WEAVER
	//-------------------------------------------

	// E1 Interrogation
	level.scr_anim["weaver"]["in"] = %ch_kowloon_b01_intro_guy_in;
	level.scr_anim["weaver"]["glass_idle"] = %ch_kowloon_b01_intro_guy_glass_idle;
	level.scr_anim["weaver"]["glass"] = %ch_kowloon_b01_intro_guy_glass;
	level.scr_anim["weaver"]["punch_idle"] = %ch_kowloon_b01_intro_guy_punch_idle;
	level.scr_anim["weaver"]["punch"] = %ch_kowloon_b01_intro_guy_punch;
	level.scr_anim["weaver"]["out"] = %ch_kowloon_b01_intro_guy_out;

	// E2 Matress jump
	level.scr_anim["weaver"]["kowloon_mattress_jump"]	= %ch_kowloon_b01_first_jump_weaver;
	level thread addNotetrack_customFunction("weaver", "Landing", ::landing_dust_fx, "kowloon_mattress_jump");

	// E4 Pipe Slide
	level.scr_anim["weaver"]["pipe_slide"] = %ch_kowloon_b04_pipe_slide_weaver;
	level.scr_anim["weaver"]["temple_roof"] = %ch_kowloon_b04_rooftop_traversal_a;

	// fridge move for weaver
	level.scr_anim["weaver"]["fridge_loop"] = %ch_kowloon_b01_fridge_weaver_loop;
	level.scr_anim["weaver"]["fridge_push"] = %ch_kowloon_b01_fridge_push_weaver;
	addNotetrack_customFunction("weaver", "Switch", ::switch_weapon, "fridge_push");
	addNotetrack_customFunction("weaver", "Drop_left_gun", ::drop_left_gun, "fridge_push");
	addNotetrack_customFunction("weaver", "spawn", ::swap_weapons, "fridge_push");
	addNotetrack_customFunction("weaver", "sndnt#vox_kow1_s04_052A_huds_m.wav", ::vo_fridge, "fridge_push");



	level.scr_anim["weaver"]["fridge_wait"] = %ch_kowloon_b01_fridge_push_wait_weaver;
	level.scr_anim["weaver"]["fridge_out"] = %ch_kowloon_b01_fridge_push_out_weaver;

	// E6 Clark death
	level.scr_anim["weaver"]["clark_death"] = %ch_kowloon_b07_clarkdeath_weaver;


	//-------------------------------------------
	// SPETSNAZ
	//-------------------------------------------
	
	// Roll
	level.scr_anim["spetznaz"]["roll"][0] = %ai_spets_rusher_roll_forward_01;
	level.scr_anim["spetznaz"]["roll"][1] = %ai_spets_rusher_roll_forward_02;

	// Window breach
	level.scr_anim["spetznaz"]["rapel_1"] = %ch_kowloon_b02_spetz_rappel_breach_1;
	addNotetrack_customFunction("spetznaz", "glass_break", ::break_rappel_glass, "rapel_1");

	level.scr_anim["spetznaz"]["rapel_2"] = %ch_kowloon_b02_spetz_rappel_breach_2;
	addNotetrack_customFunction("spetznaz", "glass_break", ::break_rappel_glass, "rapel_2");

	// Heli fastrope
	level.scr_anim["spetznaz"]["heli_spet1"] = %ch_kowloon_b04_destroy_home_spetz1;
	level.scr_anim["spetznaz"]["heli_spet2"] = %ch_kowloon_b04_destroy_home_spetz2;

	// Spetz pushing civ
	level.scr_anim["spetznaz"]["civ_push"] = %ch_kowloon_b04_window_push_spetz1;

	//Spetz door breach
	level.scr_anim["spetznaz"]["door_breach"] 	= %ai_doorbreach_kick;

	// Van Crash
	level.scr_anim["spetznaz"]["van_crash_1"] 	= %ch_kowloon_b07_vancrash_spetz_01;
	level.scr_anim["spetznaz"]["van_crash_2"] 	= %ch_kowloon_b07_vancrash_spetz_02;

	level.scr_anim["spetznaz"]["van_crash_1_loop"][0] 	= %ch_kowloon_b07_vancrash_spetz_01_dead;
	level.scr_anim["spetznaz"]["van_crash_2_loop"][0] 	= %ch_kowloon_b07_vancrash_spetz_02_dead;



	// Rappel
	level.scr_anim["spetznaz"]["rappel_building"] = %ch_kowloon_b03_spetznaz_rappel;

	// ally
	level.scr_anim["sgt_1"]["van_crash_intro"] 			= %ch_kowloon_b07_vancrash_hero_01;
	level.scr_anim["sgt_1"]["sgt_1_van_crash_loop"][0] 	= %ch_kowloon_b07_vancrash_hero_01_loop;
	level.scr_anim["sgt_1"]["van_crash_out"] 		= %ch_kowloon_b07_vancrash_hero_01_out;

	level.scr_anim["sgt_2"]["van_crash_intro"] 			= %ch_kowloon_b07_vancrash_hero_02;
	level.scr_anim["sgt_2"]["sgt_2_van_crash_loop"][0] 	= %ch_kowloon_b07_vancrash_hero_02_loop;
	level.scr_anim["sgt_2"]["van_crash_out"] 		= %ch_kowloon_b07_vancrash_hero_02_out;

	level.scr_anim["sgt_3"]["van_crash_intro"] 			= %ch_kowloon_b07_vancrash_passenger;
	level.scr_anim["sgt_3"]["sgt_3_van_crash_loop"][0] 	= %ch_kowloon_b07_vancrash_passenger_loop;
	level.scr_anim["sgt_3"]["van_crash_out"] 		= %ch_kowloon_b07_vancrash_passenger_out;

	//-------------------------------------------
	// Civilian
	//-------------------------------------------
	level.scr_anim["civilian"]["civ_push"] = %ch_kowloon_b04_window_push_civ;

	//-------------------------------------------
	// General traversal
	//-------------------------------------------
	level.scr_anim[ "generic" ][ "kowloon_jump_down_136" ]				= %ch_kowloon_136_dropdown_a;
	level.scr_anim[ "generic" ][ "kowloon_jump_down_136_run_leap" ]		= %ch_kowloon_136_dropdown_run2run_leap;
	level.scr_anim[ "generic" ][ "kowloon_jump_down_136_run_run" ]		= %ch_kowloon_136_dropdown_run2run_roll;
	level.scr_anim[ "generic" ][ "kowloon_jump_down_136_stand_roll" ]	= %ch_kowloon_136_dropdown_run2stand_roll;
	level.scr_anim[ "generic" ][ "kowloon_jump_down_136_stand_stand" ]	= %ch_kowloon_136_dropdown_stand2stand;		
	level.scr_anim[ "generic" ][ "kowloon_dropdown_awnings_01" ]		= %ch_kowloon_dropdown_awnings_01;		
	level.scr_anim[ "generic" ][ "kowloon_dropdown_awnings_02" ]		= %ch_kowloon_dropdown_awnings_02;		

	//shabs - adding sprint animation for clarke jump
	level.scr_anim["generic"]["sprint_patrol_1"] = %ch_khe_E1B_troopssprint_1;

	//custom traversal
	level.scr_anim[ "generic" ][ "jump_down_kowloon" ] = %ai_jump_down_96_kowloon;
}

/*

FRAME 953 "glass_break"
FRAME 1000 "pull_glass"
FRAME 1035 "sndnt#vox_kow1_s01_004A_huds_m"
FRAME 1049 "break_glass"
FRAME 1088 "touch_head"
FRAME 1119 "shove_glass"


PIPE SLIDE
NUMKEYS 12
FRAME 17 "PlayerPipeSlideAnim"
FRAME 41 "LandOnPipe"
FRAME 53 "startSlide"
FRAME 73 "pipeClamp"
FRAME 81 "pipeClamp"
FRAME 99 "pipeClamp"
FRAME 126 "pipeClamp"
FRAME 135 "pipeClamp"
FRAME 139 "endSlide"
FRAME 154 "footstep_right_large"
FRAME 159 "footstep_left_large"
FRAME 177 "anim_pose = \"crouch\""


*/



#using_animtree("player");
init_player_animation()
{
	//	E1 Interrogation
	level.scr_animtree[ "player_body" ] 	= #animtree;	
	level.scr_model[ "player_body" ] = "t5_gfl_m16a1_viewbody";
	level.scr_anim["player"]["in"] = %int_kowloon_b01_intro_player_in;
	level.scr_anim["player"]["glass_idle"] = %int_kowloon_b01_intro_player_glass_idle;
	level.scr_anim["player"]["glass"] = %int_kowloon_b01_intro_player_glass;
	level thread addNotetrack_customFunction("player", "glass_break", ::break_glass_interrogation, "glass");
	level thread addNotetrack_customFunction("player", "pull_glass", ::player_pull_glass, "glass");
	level thread addNotetrack_customFunction("player", "break_glass", ::player_snap_glass, "glass");
	level thread addNotetrack_customFunction("player", "touch_head", ::player_touch_head, "glass");
	level thread addNotetrack_customFunction("player", "shove_glass", ::player_shove_glass, "glass");

	level.scr_anim["player"]["punch_idle"] = %int_kowloon_b01_intro_player_punch_idle;
	level.scr_anim["player"]["punch"] = %int_kowloon_b01_intro_player_punch;
	level.scr_anim["player"]["out"] = %int_kowloon_b01_intro_player_out;

	level thread addNotetrack_customFunction("player", "bullets", ::interrogation_bullets, "out");

	// E4 Pipe slide
	level.scr_anim["player"]["pipe_slide"] = %int_kowloon_b04_pipe_slide;
	level thread addNotetrack_customFunction("player", "LandOnPipe", ::pipe_heavy_rumble, "pipe_slide");
	level thread addNotetrack_customFunction("player", "startSlide", ::start_pipe_slide, "pipe_slide");
	level thread addNotetrack_customFunction("player", "pipeClamp", ::pipe_bump, "pipe_slide");
	level thread addNotetrack_customFunction("player", "endSlide", ::end_pipe_slide, "pipe_slide");
	level thread addNotetrack_customFunction("player", "footstep_left_large", ::pipe_bump, "pipe_slide");
	level thread addNotetrack_customFunction("player", "footstep_right_large", ::pipe_bump, "pipe_slide");

	// E7 Clarke death
	level.scr_anim["player"]["clark_death"] = %int_kowloon_b07_clarkdeath_player;
	level thread addNotetrack_customFunction("player", "foot_rumble", ::foot_rumbles, "clark_death");
	level thread addNotetrack_customFunction("player", "landing", ::weaver_landing, "clark_death");
	level thread addNotetrack_customFunction("player", "hand_grab", ::weaver_player_hand, "clark_death");
	level thread addNotetrack_customFunction("player", "pull_up", ::weaver_pull_up, "clark_death");

	// E7 Van Out - shabs
	level.scr_anim["player_body"]["van_crash_out"] = %int_kowloon_b07_vancrash_player_out;


	level.scr_animtree[ "player_hands" ] 	= #animtree;	
	level.scr_model[ "player_hands" ] = "t5_gfl_m16a1_viewmodel_player";

	//player gas death from rebirth - shabs
	level.scr_anim[ "player_hands" ][ "gas_death" ]			= %int_player_gas_death;
}



init_voice()
{
	level.scr_sound["clarke"]["shoot_canister"] = "vox_kow1_s02_019A_clar"; //Gunfire's ruptured the canisters!
	level.scr_sound["weaver"]["escape_route"] = "vox_kow1_s02_022A_weav"; //If you're so paranoid - what's your escape route?!
	level.scr_sound["clarke"]["hatch_in_the_ceiling"] = "vox_kow1_s02_023A_clar"; //There's a hatch in the ceiling!
	level.scr_sound["clarke"]["this_way_here"] = "vox_kow1_s02_024A_clar"; //This way!
	level.scr_sound["clarke"]["quickly_move"] = "vox_kow1_s02_025A_clar"; //Quickly! Move.
	level.scr_sound["clarke"]["inhale_gas"] = "vox_kow1_s03_026A_clar"; //Did you inhale the gas?!!
	level.scr_sound["player"]["we_good"] = "vox_kow1_s03_027A_huds"; //No - We're good.
	level.scr_sound["clarke"]["you_lucky"] = "vox_kow1_s03_028A_clar"; //You are lucky��
	level.scr_sound["clarke"]["direct_exposure"] = "vox_kow1_s03_029A_clar"; //Only direct exposure is fatal.
	level.scr_sound["weaver"]["spetsnaz_inbound"] = "vox_kow1_s03_032A_weav"; //We got Spetsnaz inbound!
	level.scr_sound["weaver"]["west_hallway"] = "vox_kow1_s03_033A_weav"; //West hallway!
	level.scr_sound["weaver"]["which_way"] = "vox_kow1_s03_034A_weav"; //Which way?
	level.scr_sound["clarke"]["get_to_roof"] = "vox_kow1_s03_035A_clar"; //We need to get to the roof.
	level.scr_sound["clarke"]["up_stairs"] = "vox_kow1_s03_036A_clar"; //Up the stairs!
	level.scr_sound["weaver"]["right_window"] = "vox_kow1_s03_037A_weav"; //Right side window!
	level.scr_sound["clarke"]["on_roof"] = "vox_kow1_s03_038A_clar"; //Onto the roof!
	level.scr_sound["weaver"]["snipers"] = "vox_kow1_s03_039A_weav"; //Chyort! Snipers!
	level.scr_sound["clarke"]["opposite_tower"] = "vox_kow1_s03_040A_clar"; //We need to get to the opposite tower!
	level.scr_sound["weaver"]["How"] = "vox_kow1_s03_041A_weav"; //How?!!
	level.scr_sound["clarke"]["we_jump"] = "vox_kow1_s03_042A_clar"; //We jump!!
	level.scr_sound["clarke"]["jump!!!"] = "vox_kow1_s03_044A_clar"; //Jump!
	level.scr_sound["weaver"]["lets_go_hudson"] = "vox_kow1_s03_045A_weav"; //Let's go!
	level.scr_sound["player"]["kidding_me"] = "vox_kow1_s03_043A_huds"; //You gotta be kidding me!!

	level.scr_sound["weaver"]["what_are_waiting_for"] = "vox_kow1_s03_046A_weav"; //What are you waiting for?
	level.scr_sound["weaver"]["come_on_hudson_jump"] = "vox_kow1_s03_047A_weav"; //Come on, Hudson - JUMP!

	level.scr_sound["player"]["son_bitch"] = "vox_kow1_s03_048A_huds"; //Son of a bitch!!!!
	level.scr_sound["player"]["oomph"] = "vox_kow1_s03_049A_huds"; //Ooomph!

	level.scr_sound["clarke"]["help_me_move"] = "vox_kow1_s04_050A_clar"; //Here, help me move this!
	level.scr_sound["clarke"]["grab_what_you_need"] = "vox_kow1_s04_051A_clar"; //Okay. Grab what you need - They'll be here before you know it.
    level.scr_sound["player"]["well_prepared"] = "vox_kow1_s04_052A_huds_m"; //You are very well prepared for a dead man.

	level.scr_sound["clarke"]["this_way_clarke"] = "vox_kow1_s04_055A_clar"; //This way!

	level.scr_sound["player"]["on_me"] = "vox_kow1_s04_056A_huds"; //Okay�� On me.



	level.scr_sound["weaver"]["eye_left"] = "vox_kow1_s04_058A_weav"; //Eyes left  Hudson!
	

	level.scr_sound["weaver"]["window_breach"] = "vox_kow1_s04_060A_weav"; //They're breaching the windows!
	level.scr_sound["player"]["which_way"] = "vox_kow1_s04_061A_huds"; //Which way?
	level.scr_sound["clarke"]["left_door"] = "vox_kow1_s04_062A_clar"; //Left door.
	level.scr_sound["clarke"]["get_on_roof"] = "vox_kow1_s04_063A_clar"; //Onto the rooftops!
	level.scr_sound["weaver"]["where_you_going"] = "vox_kow1_s04_064A_weav"; //You sure you know where you're going?
	level.scr_sound["clarke"]["prepared_for_this"] = "vox_kow1_s04_065A_clar"; //You think I haven't prepared for this?!
	level.scr_sound["clarke"]["downstairs"] = "vox_kow1_s04_066A_clar"; //Quickly - Downstairs!
	level.scr_sound["clarke"]["down_the_pipe"] = "vox_kow1_s05_067A_clar"; //Down the pipe - Go!

	level.scr_sound["clarke"]["Hurry_it_up"] = "vox_kow1_s05_069A_clar"; //Hurry it up!
	level.scr_sound["clarke"]["Get_ass_down"] = "vox_kow1_s05_070A_clar"; //Get your arses down here!!!
	
	level.scr_sound["weaver"]["two_more_Asshole"] = "vox_kow1_s05_071A_weav"; //Two more assholes below.
	level.scr_sound["player"]["no_problem"] = "vox_kow1_s05_072A_huds"; //No problem.
	level.scr_sound["player"]["got_em"] = "vox_kow1_s05_073A_huds"; //I got 'em.

	level.scr_sound["weaver"]["shut_you_up"] = "vox_kow1_s05_074A_weav"; //Dragovich is going to a lot of trouble to shut you up... What are you not telling us?
	level.scr_sound["clarke"]["nova_6"] = "vox_kow1_s05_075A_clar"; //I told you about Nova 6��
	level.scr_sound["weaver"]["where_base"] = "vox_kow1_s05_076A_weav"; //Where is their base? Nam? Laos? Cambodia?
	
	level.scr_sound["clarke"]["yamantau"] = "vox_kow1_s05_077A_clar"; //Ha! You're way off�� Try the Ural Mountains - Yamantau.
	level.scr_sound["clarke"]["steiner"] = "vox_kow1_s05_078A_clar"; //That's where you'll find Steiner - In final preparations for Project Nova.
	level.scr_sound["player"]["whisper_rumor"] = "vox_kow1_s05_079A_huds"; //What else?... Whispers. Rumors�� ANYTHING?!
	level.scr_sound["clarke"]["steiner_dragovich"] = "vox_kow1_s05_080A_clar"; //Steiner talked with Dragovich about numbers��
	level.scr_sound["player"]["what_number"] = "vox_kow1_s05_081A_huds"; //What kind of numbers?
	level.scr_sound["clarke"]["kind_of_plan"] = "vox_kow1_s05_082A_clar"; //The kind that their plan relies on!
	
	level.scr_sound["weaver"]["Targets_at_12"] = "vox_kow1_s05_083A_weav"; //Targets! 12 o'clock - Low!


	level.scr_sound["clarke"]["balcony_left"] = "vox_kow1_s06_089A_clar"; //Balcony on the left!
	level.scr_sound["clarke"]["follow_hallway"] = "vox_kow1_s06_091A_clar"; //Follow the hallway - All the way to the end!
	level.scr_sound["weaver"]["breach_roof"] = "vox_kow1_s06_093A_weav"; //They're breaching the roof!!
	level.scr_sound["clarke"]["back_outside"] = "vox_kow1_s06_095A_clar"; //Back outside - Balcony on your right!
	

	
	level.scr_sound["clarke"]["onto_next_balcony"] = "vox_kow1_s06_097A_clar"; //Onto the next Balcony!
	level.scr_sound["clarke"]["not_far_now"] = "vox_kow1_s06_098A_clar"; //Not far now!
	level.scr_sound["clarke"]["More_weapons"] = "vox_kow1_s06_099A_clar"; //More weapons - Grab whatever you need.
	

	level.scr_sound["clarke"]["leap_of_faith"] = "vox_kow1_s06_108A_clar"; //Come on! Just one more leap of faith!
	level.scr_sound["clarke"]["Raarhhh"] = "vox_kow1_s07_109A_clar"; //Rarhhhh!!
	level.scr_sound["clarke"]["bollocks"] = "vox_kow1_s07_110A_clar"; //Hrrmph... Bollocks!
	level.scr_sound["weaver"]["hudson_grab_him"] = "vox_kow1_s07_111A_weav"; //Hudson, grab him - GO!
	level.scr_sound["clarke"]["i_m_slipping"] = "vox_kow1_s07_112A_clar"; //I'm slipping!
	level.scr_sound["weaver"]["jump_hudson"] = "vox_kow1_s07_113A_weav"; //Jump, Hudson!!
	level.scr_sound["weaver"]["i_got_you_clark"] = "vox_kow1_s07_114A_weav"; //I got you!
	level.scr_sound["player"]["what_about_the_number"] = "vox_kow1_s07_115A_huds"; //What about the numbers, Clarke!!

	level.scr_sound["weaver"]["Red_eye"] = "vox_kow1_s07_118A_weav"; //Tug boat this is Red Eye��
	level.scr_sound["weaver"]["immediate_distract"] = "vox_kow1_s07_119A_weav"; //Need immediate distraction - street level. Tower four. South side.
	level.scr_sound["sgt"]["on_our_way"] = "vox_kow1_s07_120A_agt1_f"; //Copy that Red Eye�� on our way.
	level.scr_sound["sgt"]["watching_firework"] = "vox_kow1_s07_121A_agt1_f"; //Been watching the fireworks down here... Did we extract the target?
	level.scr_sound["weaver"]["clark_dead"] = "vox_kow1_s07_122A_weav"; //Negative�� Clarke's dead.
	level.scr_sound["weaver"]["red_out"] = "vox_kow1_s07_123A_weav"; //Red Eye out.
	level.scr_sound["weaver"]["I_see_way_down"] = "vox_kow1_s07_124A_weav"; //Come on Hudson�� I see a way down.
	level.scr_sound["weaver"]["This_way"] = "vox_kow1_s07_125A_weav"; //This way.

	level.scr_sound["sgt"]["where_we_headed"] = "vox_kow1_s07_126A_agt1_m";	// Where we headed?
	level.scr_sound["player"]["yamantau"] = "vox_kow1_s07_127A_huds";	// Yamantau

	level.scr_sound["clarke"]["follow_clarke_1"] = "vox_kow1_s99_128A_clar"; //This way!
	level.scr_sound["clarke"]["follow_clarke_2"] = "vox_kow1_s99_129A_clar"; //Hurry!
	level.scr_sound["clarke"]["follow_clarke_3"] = "vox_kow1_s99_130A_clar"; //We have to keep moving!
	level.scr_sound["clarke"]["follow_clarke_4"] = "vox_kow1_s99_131A_clar"; //Where are you going?
	level.scr_sound["clarke"]["follow_clarke_5"] = "vox_kow1_s99_132A_clar"; //No! That's the wrong way!
	level.scr_sound["clarke"]["follow_clarke_6"] = "vox_kow1_s99_133A_clar"; //Stay with me!
	level.scr_sound["spz"]["take_the_shot"] = "vox_kow1_s99_134A_spz1"; //(Translated) Third window take the shot��.
	level.scr_sound["spz"]["back_on_left"] = "vox_kow1_s99_135A_spz2"; //(Translated) In the back  on the left��
	level.scr_sound["spz"]["go_go_go"] = "vox_kow1_s99_136A_spz1"; //(Translated) Go  go  go��
	level.scr_sound["spz"]["move_up"] = "vox_kow1_s99_137A_spz1"; //(Translated) Move up��
	level.scr_sound["spz"]["moving_up"] = "vox_kow1_s99_138A_spz2"; //(Translated) Moving up��
	level.scr_sound["spz"]["cant_get_a_shot"] = "vox_kow1_s99_139A_spz2"; //(Translated) Cannot get a clear shot��
	level.scr_sound["spz"]["fucking_rain"] = "vox_kow1_s99_140A_spz2"; //(Translated) Fucking rain��
	level.scr_sound["spz"]["keep_them_pinned"] = "vox_kow1_s99_141A_spz1"; //(Translated) Keep them pinned down..
	level.scr_sound["spz"]["they_are_moving_out"] = "vox_kow1_s99_142A_spz2"; //(Translated) They are moving out of the room�� top floor�� go.
	level.scr_sound["spz"]["move_out_of_way"] = "vox_kow1_s99_143A_spz1"; //(Translated) Move out of the way!
	level.scr_sound["spz"]["move"] = "vox_kow1_s99_144A_spz2"; //(Translated) Move!
	level.scr_sound["spz"]["stay_back"] = "vox_kow1_s99_145A_spz1"; //(Translated) Stay back��
	level.scr_sound["spz"]["Get_back_inside"] = "vox_kow1_s99_146A_spz2"; //(Translated) Get back inside��
	level.scr_sound["spz"]["they_down_here"] = "vox_kow1_s99_147A_spz1"; //(Translated) They're down here�� Keep looking��
	level.scr_sound["spz"]["Check_all_apartments"] = "vox_kow1_s99_148A_spz1"; //(Translated) Check all apartments! He's escaping through the walls.
	level.scr_sound["spz"]["team_7_breach"] = "vox_kow1_s99_149A_spz1"; //(Translated) Team 7  breach now!
	level.scr_sound["spz"]["intercept_at_4"] = "vox_kow1_s99_150A_spz1"; //(Translated) Intercept at Point 4 gamma.
	level.scr_sound["spz"]["Get_out_of_way"] = "vox_kow1_s99_151A_spz1"; //(Translated) Get out of the way!
	//level.scr_sound["civ"]["anime"] = "vox_kow1_s99_152A_can1"; //(Translated) Don't hurt me!
	//level.scr_sound["civ"]["anime"] = "vox_kow1_s99_153A_can2"; //(Translated) What's going on?!
	level.scr_sound["spz"]["tower_2"] = "vox_kow1_s99_154A_spz1"; //(Translated) Target sighted - Tower 2.
	//level.scr_sound["civ"]["anime"] = "vox_kow1_s99_155A_can1"; //(Translated) Why is this happening?
	//level.scr_sound["civ"]["anime"] = "vox_kow1_s99_156A_can2"; //(Translatedf) I'm telling you it's no the Triad!
	//level.scr_sound["civ"]["anime"] = "vox_kow1_s99_157A_can2"; //(Translated) Don't worry. It will be over soon.
	level.scr_sound["spz"]["no_sign_of_them"] = "vox_kow1_s99_158A_spz1"; //(Translated) No sign of them here.
	level.scr_sound["spz"]["Clarke_is_slippery"] = "vox_kow1_s99_159A_spz2"; //(Translated) This Clarke is a slippery one. No wonder we have so many people here.
	level.scr_sound["spz"]["his_body_guard"] = "vox_kow1_s99_160A_spz1"; //(Translated) His bodyguards were unexpected. Probably American CIA.
	level.scr_sound["spz"]["stay_alert"] = "vox_kow1_s99_161A_spz2"; //(Translated) Stay alert. They could be anywhere.

	//shabs - adding two lines to defend event
    level.scr_sound["clarke"]["watch_back"] = "vox_kow1_s06_306A_clar"; //Watch my back! I need to unlock this door.
    level.scr_sound["clarke"]["cover_me"] = "vox_kow1_s06_307A_clar"; //Cover me while I get this door open!

	//shabs - adding flashback sounds after jump
    level.scr_sound["interrogator"]["flashback_1"] = "vox_kow1_s01_700A_inte"; //flashback audio 1
    level.scr_sound["player"]["flashback_2"] = "vox_kow1_s01_701A_maso"; //flashback audio 2

	level.scr_sound["weaver"]["flashbang_anim"] = "vox_kow1_s99_308A_weav"; //Flashbang!

    level.scr_sound["weaver"]["combination"] = "vox_kow1_s06_105A_weav_m"; //You forgot your own combination?!!!
}




//################################################################
//	EVENT 1 ANIMS : INTERROGATION
//################################################################

// Custom notetrack function
break_glass_interrogation(guy)
{
	exploder(1001);
	level notify( "glass_break_crows_start" );

	//shabs - added a slight rumble when player hits glass
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );

}

player_pull_glass( guy )
{
	//shabs - slight rumble when player pulls glass piece
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_light" );
}

player_snap_glass( guy )
{
	//shabs - slight rumble when player snaps glass piece in half
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_light" );
}

player_touch_head( guy )
{
	//shabs - slight rumble when player grabs clarke's head
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_light" );
}

player_shove_glass( guy )
{
	//shabs - slight rumble when player shoves glass in clarkes mouth
	player = get_players()[0];
	player PlayRumbleOnEntity( "kowloon_awning_rumble" );
}

start_pipe_slide( guy )
{
	//shabs - starts slide rumble
	flag_set( "slide_rumble" );

	level thread player_slide_rumble();
}

end_pipe_slide( guy )
{
	//shabs - kills slide rumble
	flag_clear( "slide_rumble" );
}

player_slide_rumble()
{
	self endon( "stop_slide_rumble" );

	player = get_players()[0];

	while(flag( "slide_rumble" ))
	{
		player PlayRumbleOnEntity( "damage_light" );
		wait( 0.05 );
	}
}

pipe_heavy_rumble( guy )
{
	player = get_players()[0];
	player PlayRumbleOnEntity( "kowloon_awning_rumble" );
}

pipe_bump( guy )
{
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
}


//	Anim callback
interrogation_bullets( guy )
{
	exploder( 1101 );
 
	//spawns 2 guys with kiparis across the rooftop
	ai_e2_rooftop_extras = simple_spawn( "ai_e2_rooftop_extras", maps\kowloon_interrogate::wait_for_action );

	//shabs - added a slight rumble when bullets hits glass
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
}

//
interrogation_setup()
{
	//clark = simple_spawn_single("ai_clark");
	//weaver = simple_spawn_single("ai_weaver");
	player = get_players()[0];

	sync_node = getstruct("anim_node_intro", "targetname");

	player thread take_and_giveback_weapons("give_weapon_back");
	level.heroes[ "clarke" ] thread start_interrogation_animation( sync_node );
	level.heroes[ "weaver" ] thread start_interrogation_animation( sync_node );
	player thread start_player_interrogation_animation( sync_node );
	level thread inter_chair_setup();
	
	//player first person gas death anim
	player thread player_gas_death();
}


//	Broken glass piece
#using_animtree("animated_props");
inter_glass_setup()
{
	sync_node = getstruct("anim_node_intro", "targetname");

	glass = GetEnt("interrogation_glass", "targetname");
	glass.animname = "glass";
	glass useanimtree(#animtree);
	
	sync_node thread anim_single_aligned(glass, "inter_glass");

	player = get_players()[0];

	wait(1.5);
	exploder(10051);
	//SOUND - Shawn J
   playsoundatposition( "evt_crow_1", (1585,577,3473) );

}

//	Clarke's Chair
#using_animtree("animated_props");
inter_chair_setup()
{
	sync_node = getstruct("anim_node_intro", "targetname");

	chair = GetEnt("interrogation_chair", "targetname");
	linker = Spawn( "script_model", chair.origin );
	linker.angles = chair.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "chair";
	linker useanimtree(#animtree);
	chair linkto( linker, "origin_animate_jnt" );

	linker thread loop_idle_animation(sync_node, "inter_chair", "interrogation_over");
}

//	Kick table
#using_animtree("animated_props");
inter_table_setup()
{
	sync_node = getstruct("anim_node_intro", "targetname");

	table = GetEnt("interrogation_table", "targetname");
	linker = Spawn( "script_model", table.origin );
	linker.angles = table.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "table";
	linker useanimtree(#animtree);
	table linkto( linker, "origin_animate_jnt" );

	// Put the table in place
	sync_node anim_first_frame( linker, "inter_table" );
	level waittill("interrogation_midway_through");

	sync_node anim_single_aligned(linker, "inter_table");
	linker delete();
}

#using_animtree ("generic_human");
start_interrogation_animation( sync_node )
{
	show_glass = true;
	
	if(is_gib_restricted_build())
	{
		show_glass = false;
	}
	
	if(!is_mature())
	{
		show_glass = false;
	}
	
	if(show_glass)
	{
		sync_node anim_single_aligned(self, "in");

		self loop_npc_idle_animation(sync_node, "glass_idle", "window_break");
		level thread inter_glass_setup();
		sync_node anim_single_aligned(self, "glass");
		self loop_npc_idle_animation(sync_node, "punch_idle", "punch_to_face");
		if( self == level.heroes[ "clarke" ] )
		{
			self setmodel("t5_gfl_rfb_body");
			self setclientflag(level.CLIENT_FACE_BLEED_FLAG);
			flag_set("delete_fake");
		}
		sync_node anim_single_aligned(self, "punch");
	
		self loop_npc_idle_animation(sync_node, "punch_idle", "punch_to_face");
	}
	else
	{
		if(is_mature())		// Germany gets blood - !mature turns blood off.
		{
			if( self == level.heroes[ "clarke" ] )              	
			{                                                   	
				self setmodel("t5_gfl_rfb_body");          	
				self setclientflag(level.CLIENT_FACE_BLEED_FLAG); 	
				flag_set("delete_fake");
			}
		}
	}
	
	sync_node anim_single_aligned(self, "out");
	//self detach(self.attach_model, self.attach_tag);

	if( self == level.heroes[ "clarke" ] )
	{
		
		self loop_npc_idle_animation(sync_node, "table_idle", "gas_released");

		self setmodel("t5_gfl_rfb_body");
		//self thread wait_for_gas();
		sync_node anim_single_aligned(self, "escape");
	}
}


//
//	Clarke punched by player
//	guy = Clarke
clarke_punched( guy )
{
	if( is_mature() )
	{
		fx = PlayFxOnTag( level._effect["fx_blood_punch"], guy, "J_Lip_Top_RI" );
	}

	//shabs - added a slight rumble when player punches clarke
	player = get_players()[0];
	player PlayRumbleOnEntity( "kowloon_awning_rumble" );
}

//
//	Clarke spits out blood and glass
//	guy = Clarke
clarke_spit( guy )
{
	if( is_mature() )
	{
		fx = PlayFxOnTag( level._effect["fx_blood_spit"], guy, "J_Lip_Top_RI" );
	}
}

//	Player's interrogation sequence
#using_animtree("player");
start_player_interrogation_animation( sync_node )
{
	player_hands = Spawn_anim_model( "player_body", self.origin );	
	player_hands.angles = self.angles;
	player_hands.animname = "player";

	// turn off HUD
	self SetClientDvar( "compass", "0" );

	self.player_hands = player_hands;
	self PlayerlinktoAbsolute(player_hands, "tag_player");
	
	player_hands SetVisibleToPlayer( self );
	self HideViewModel();
	level thread inter_table_setup();

	show_glass = true;
	
	if(is_gib_restricted_build())
	{
		show_glass = false;
	}
	
	if(!is_mature())
	{
		show_glass = false;
	}
	
	if(show_glass)
	{
		sync_node anim_single_aligned(player_hands, "in");
		screen_message_create(&"KOWLOON_INTERROGATION_BREAK_GLASS");
		player_hands loop_player_idle_animation(sync_node, "glass_idle", "window_break");
		wait( 0.05 );
		level notify("idle_done");
		screen_message_delete();
		sync_node anim_single_aligned(player_hands, "glass");
		screen_message_create(&"KOWLOON_INTERROGATION_PUNCH");
		player_hands loop_player_idle_animation(sync_node, "punch_idle", "punch_to_face");
		wait( 0.05 );
		level notify("idle_done");
		screen_message_delete();
		sync_node anim_single_aligned(player_hands, "punch");
		screen_message_create(&"KOWLOON_INTERROGATION_PUNCH");
		player_hands loop_player_idle_animation(sync_node, "punch_idle", "punch_to_face");
		wait( 0.05 );
		level notify("idle_done");
		screen_message_delete();
	}
	else
	{
		wait(0.1);	// let other threads get into position before sending this notify.
	}
	
	level notify("interrogation_midway_through");
	//self thread free_player_camera(player_hands);

	sync_node anim_single_aligned(player_hands, "out");
	
	autosave_by_name("interrogation_over");
	
	self Unlink();
	self ShowViewModel();
	player_hands delete();
	
	//setting back default player DOF settings
//	Default_Near_Start = 0;
//	Default_Near_End = 1;
//	Default_Far_Start = 8000;
//	Default_Far_End = 10000;
//	Default_Near_Blur = 6;
//	Default_Far_Blur = 0;
//
//	self SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
	VisionSetNaked( "kowloon", 2.0 );

	level.heroes[ "weaver" ] maps\kowloon_util::weaver_set_friendname();
	level.heroes[ "clarke" ] maps\kowloon_util::clarke_set_friendname();
	
	self notify("give_weapon_back");
	// Weapon isn't switching back for some reason, so we're doing it manually
	//wait(0.05);
	wait(0.05);
	self SwitchToWeapon("cz75dw_sp");

	self SetClientDvar( "compass", "1" );
}

//shabs - player gas death
player_gas_death() //self = player
{
	level endon( "event3" );
	self endon( "disconnect" );

	flag_wait( "e2_player_inhaled" );

	self DisableWeapons();
	self StartPoisoning();	

	self thread maps\_load_common::special_death_indicator_hudelement( "hud_obit_nova_gas", 64, 64, undefined, 0, 15 );
	SetDvar( "ui_deadquote", &"KOWLOON_NOVA6_DEATH" ); 	

	player_hands = spawn_anim_model("player_hands", self.origin, self.angles);
	self PlayerLinkToAbsolute(player_hands, "tag_player");

	level thread mission_fail();

	self SetBlur( 15, 2 );
	player_hands anim_single(player_hands, "gas_death");

}

mission_fail()
{
	wait( 2 );
	maps\kowloon::fade_to_black();
	missionFailedWrapper();
}

//temp animation until custom notetrack
free_player_camera( player_hands )
{
	self startcameratween(1);
	wait(3);
	self PlayerlinktoDelta(player_hands, "tag_player", 0.5, 35, 35, 45, 45);
}

//
//	Keep looping player idle until we get input
loop_player_idle_animation(sync_node, animation, endon_notify )
{
	level endon(endon_notify);
	get_players()[0] thread get_player_input( endon_notify );
	while(1)
	{
		sync_node anim_single_aligned(self, animation);
	}
}

//
//	Keep looping until we're told to end
loop_idle_animation(sync_node, animation, endon_notify)
{
	level endon(endon_notify);
	while(1)
	{
		sync_node anim_single_aligned(self, animation);
	}
}


//
//	Interrogation Prompts
get_player_input( timeout_notify )
{
	level endon("idle_done");
	timeout = GetTime() + 10000;

	while(1)
	{
		if(self AttackButtonPressed())
		{
			
			level notify("punch_to_face");
			wait(0.1);
			continue;
		}
		if(self AdsButtonPressed() )
		{
			level notify("window_break");			
			wait(0.1);
			continue;
		}

		if ( GetTime() > timeout )
		{
			level notify( timeout_notify );
		}
		wait(0.05);
	}

}


//################################################################
//	EVENT 2 ANIMS : GAS LEAK AND ESCAPE, JUMP TO CACHE ROOM
//################################################################


//
wait_for_gas()
{
	flag_wait( "gas_released" );
	wait( 2.0 );
	level notify("start_escape");
}


// Escape Hatch
#using_animtree("animated_props");
inter_hatch_setup()
{
	sync_node = getstruct("anim_node_intro", "targetname");

//	player = get_players()[0];
//	player SetClientDvar("cg_drawfriendlynames", 1);

	hatch = GetEnt("lab_hatch", "targetname");
	linker = Spawn( "script_model", hatch.origin );
	linker.angles = hatch.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "hatch";
	linker useanimtree(#animtree);
	hatch linkto( linker, "origin_animate_jnt" );
	sync_node anim_single_aligned(linker, "inter_hatch");

	linker delete();

}



//################################################################
//	EVENT 3 ANIMS : CACHE ROOM
//################################################################

#using_animtree("animated_props");
move_cache_fridge()
{
	sync_node = getstruct("fridge_sync", "targetname");
	fridge = GetEnt("cache_fridge", "targetname");
	linker = Spawn( "script_model", fridge.origin );
	linker.angles = fridge.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "fridge";
	linker useanimtree(#animtree);
	fridge linkto( linker, "origin_animate_jnt" );

	clip = GetEnt( "clip_e3_fridge", "targetname" );
	clip linkto( fridge );

	linker loop_npc_idle_animation(sync_node, "cache_loop", "end_cache_loop" );
	sync_node anim_single_aligned(linker, "cache_move");
	linker delete();

}

play_fridge_dust( guy )
{
	exploder(3103);
}

#using_animtree ("generic_human");
//
//	self is Weaver or Clarke
// TODO: Add weapon switching
init_heroes_fridge_move()
{
	sync_node = getstruct("fridge_sync", "targetname");
	
	level notify("on_fridge");
	
	if (self.targetname == "ai_weaver_ai")
	{
		flag_set("weaver_on_fridge");
	}
	else
	{
		flag_set("clarke_on_fridge");
	}
		
	self loop_npc_idle_animation(sync_node, "fridge_loop", "end_cache_loop");
	
	sync_node anim_single_aligned(self, "fridge_push");
	
	//sync_node anim_single_aligned(self, "fridge_wait");
	
	flag_set( self.name + "_cache_done" );
	
	self thread finish_cache_animation();
	
	self loop_npc_idle_animation(sync_node, "fridge_wait", "end_weapon_grab");	
	
	sync_node anim_single_aligned(self, "fridge_out");
	
	self.grenadeawareness = 1;
}

switch_weapon( guy )
{
	if ( guy == level.heroes[ "weaver" ] )
	{

		//switch to spas_sp
		// level.spas = GetWeaponModel( "spas_sp" );
		level.spas = GetWeaponModel( "ak12_zm" );
		//spas useweaponhidetags( "spas_sp" );
		guy Attach( level.spas, "TAG_WEAPON_LEFT");
		guy gun_remove();

	}
}

//weaver drops his shotty
drop_left_gun( guy )
{
	//guy animscripts\shared::DropAIWeapon();
//	guy gun_remove();
//	level.spas Delete();
	guy Detach( level.spas, "TAG_WEAPON_LEFT");

	weaver_cache_shotty = GetEnt( "weaver_cache_shotty", "script_noteworthy" );
	weaver_cache_shotty Show();
}

// Change weapons
swap_weapons( guy )
{
	if ( guy == level.heroes[ "weaver" ] )
	{
		//guy custom_ai_weapon_loadout( "spas_sp", "kiparis_sp", "cz75_sp" );

		//guy animscripts\shared::DropAIWeapon();
				
		// guy gun_switchto( "kiparis_sp", "right" );
		guy gun_switchto( "ak12_zm", "right" );

		wait( 11 );

		//guy Detach( level.spas, "TAG_WEAPON_LEFT");
	}
}


vo_fridge(guy)
{
	player = get_players()[0];
	player.animname = "player";
	player thread anim_single(player, "well_prepared");
}


//
finish_cache_animation()
{
	sync_node = getstruct("fridge_sync", "targetname");

	//wait(2);

	flag_wait("Clarke_cache_done");
	flag_wait("Weaver_cache_done");
	trigger_wait( "trig_e3_hallway");
	
	level notify("end_weapon_grab");
}


//
//	Waits for the player, Clarke and Weaver to make the jump into the cache room
wait_til_fridge_move()
{
	//level waittill("on_fridge");
	flag_wait("on_fridge");
	
	//flag_set("flashback_audio");
	
	//level waittill("on_fridge");
	//level waittill("on_fridge");
	flag_wait("weaver_on_fridge");
	flag_wait("clarke_on_fridge");
	
	//flag_wait("flashback_done");
	
	level notify("end_cache_loop");

	level.heroes[ "clarke" ] custom_ai_weapon_loadout( "g11_sp", undefined, "cz75_sp" );
}


#using_animtree("animated_props");
move_cache_door()
{
	door = GetEnt("cache_room_door", "targetname");
	door UseAnimTree(#animtree);
	door.animname = "door";

	door_clip = GetEnt( "cache_room_door_clip", "targetname" );
	door_clip RotateYaw( 92, 2.0, 1.0 );

	sync_node = getstruct("fridge_door_sync", "targetname");
	sync_node anim_single_aligned(door, "cache_out");

	door_clip ConnectPaths();
}


#using_animtree ("generic_human");
door_breach_1( delay )
{
	self endon( "death" );

	self.animname = "spetznaz";
	sync_node = getstruct("door_breach_struct", "targetname");
	sync_node anim_reach_aligned(self, "door_breach");

	// Wait until the door opens
	flag_wait( "e3_door_open" );

// 	sync_node anim_first_frame( self, "door_breach" );
//	wait( delay );

	level thread wait_notify_door();

	self.allowdeath = 1;
	sync_node anim_single_aligned(self, "door_breach");
}

wait_notify_door()
{
	wait( 0.58 );

	flag_set( "hallway_door_open" );
}

//  Spetsnaz rappel through the windows
#using_animtree ("generic_human");
rappel_window_breach( anim_name )
{
	self endon( "death" );

	self enable_cqbwalk();
	self.animname = "spetznaz";	
	self.allowdeath = 1;
	self.deathfunction = animscripts\utility::do_ragdoll_death;

//	struct_1 = getstruct("anim_node_window_rappel_indoor", "targetname"); //first wave guys
//	struct_2 = getstruct("anim_node_window_rappel", "targetname"); //second wave

	first_rappel_guy_1_sync = getstruct("first_rappel_guy_1_sync", "targetname");
	first_rappel_guy_2_sync = getstruct("first_rappel_guy_2_sync", "targetname"); 

	second_guy_1_sync = getstruct("second_guy_1_sync", "targetname"); 
	second_guy_2_sync = getstruct("second_guy_2_sync", "targetname"); 

	if( self.script_noteworthy == "first_rappel_guy_1" )
	{
		self thread play_rappel_anim( first_rappel_guy_1_sync, "rapel_1" );
	}
	else if( self.script_noteworthy == "first_rappel_guy_2" )
	{
		self thread play_rappel_anim( second_guy_2_sync, "rapel_2" );
	}
	else if( self.script_noteworthy == "first_rappel_guy_3" )
	{
		wait( 1 );
		self thread play_rappel_anim( first_rappel_guy_2_sync, "rapel_1" );
	}
	else if( self.script_noteworthy == "second_rappel_guy_1" )
	{
		//wait( RandomFloatRange(0.50, 0.75) );
		self thread play_rappel_anim( second_guy_1_sync, "rapel_2" );
	}
	else if( self.script_noteworthy == "second_rappel_guy_2" )
	{
		//wait( RandomFloatRange(0.05, 0.15) );
		self thread play_rappel_anim( second_guy_2_sync, "rapel_2" );
	}
}

play_rappel_anim( sync_node, rappel_anim )
{
	self endon( "death" );

	sync_node anim_single_aligned(self, rappel_anim);	
	self.deathfunction = undefined;
	self thread maps\kowloon_util::force_goal_self();

}

play_rappel_2_anim( sync_node, rappel_anim )
{
	self endon( "death" );

	sync_node anim_single_aligned(self, rappel_anim);	
	self.deathfunction = undefined;
}

break_rappel_glass( guy )
{
	//guy endon( "death" );

	if( guy.script_noteworthy == "first_rappel_guy_1" ) //kiparis
	{
		first_rappel_guy_1_sync = getstruct("first_rappel_guy_1_sync", "targetname"); 
		//guy thread magic_bullet_shield();
		exploder( 3501 );

		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );

		//maybe a wait here
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_1_sync.origin );
	}
	else if( guy.script_noteworthy == "first_rappel_guy_3" ) //kiparis
	{
		first_rappel_guy_2_sync = getstruct("first_rappel_guy_2_sync", "targetname"); 
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );

		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
	}
	else if( guy.script_noteworthy == "second_rappel_guy_1" ) //kiparis
	{
		second_guy_1_sync = getstruct("second_guy_1_sync", "targetname"); 
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );

		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_1_sync.origin );
	}
	else if( guy.script_noteworthy == "second_rappel_guy_2" ) //spas
	{
		second_guy_2_sync = getstruct("second_guy_2_sync", "targetname");
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );

		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), second_guy_2_sync.origin );
	}
	else // sn: first_rappel_guy_3 - kiparis
	{
		first_rappel_guy_2_sync = getstruct("first_rappel_guy_2_sync", "targetname");

		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );
		PlayFXOnTag( level.fake_muzzleflash, guy, "tag_flash" );

		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
		MagicBullet ( "kiparis_sp", guy GetTagOrigin( "tag_weapon_right" ), first_rappel_guy_2_sync.origin );
	}

}


//################################################################
//	EVENT 4 ANIMS : SPETSNAZ RAPPEL, PIPE SLIDE, ROOFTOP TRAVERSE
//################################################################

//	spetznaz rappel down the side of a building
#using_animtree ("generic_human");
rooftop_rappel()
{
	sync_node = getstructarray("anim_node_rappel", "targetname");
	spetz = simple_spawn_single("rappel_spetz");
	spetz.allowdeath = true;
	sync_node[0] thread anim_single_aligned(spetz, "rappel_building");
	wait(1);
	spetz = simple_spawn_single("rappel_spetz");
	spetz.allowdeath = true;
	sync_node[1] thread anim_single_aligned(spetz, "rappel_building");

}

background_rappel()
{
	self endon( "death" );

	self.allowdeath = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.animname = "spetznaz";	

	if( self.script_noteworthy == "background_rappel_right_guy" )
	{
		background_rappel_right_sync = getstruct( "background_rappel_right_sync", "targetname" );
		background_rappel_right_sync anim_single_aligned(self, "rappel_building");
		self Delete();

	}
	else //background_rappel_left_guy
	{
		background_rappel_left_sync = getstruct( "background_rappel_left_sync", "targetname" );
		background_rappel_left_sync anim_single_aligned(self, "rappel_building");
		self Delete();
	}

}

// Player slides down the pipe
#using_animtree("player");
player_pipe_slide()
{
	//shabs - turn off Weaver's DDS
	//maps\_dds::dds_disable( "allies" );

	//shabs - turning off falling death check
	level notify ("kill_falling_to_death");

	//TUEY Set music to PIPE SLIDE SECTION
	setmusicstate ("PIPE_SLIDE_SECTION");
	
	self SetClientDvars( "cg_drawCrosshair", 0 ); //turn off reticule

	//shabs - adding a rumble during the slide duration
//	self thread player_slide_rumble();

	self thread maps\kowloon_util::refill_ammo();

	//shabs = disabling offhand until after roof slide
	self disableoffhandweapons();

	sync_node = getstruct("anim_node_pipe_slide", "targetname");
	player_hands = Spawn_anim_model( "player_body", self.origin );	
	player_hands.angles = self.angles;
	player_hands.animname = "player";
	player_hands Hide();
	self PlayerlinktoAbsolute(player_hands, "tag_player");
	self._hiding_model = true;
	ClientNotify( "tgfx0" );	// Thundergun fx off
	self HideViewModel();

	self startcameratween(0.10);
	anim_time = GetAnimLength(level.scr_anim["player"]["pipe_slide"]);
	sync_node thread anim_single_aligned(player_hands, "pipe_slide");
	wait(.15);

	if( !flag( "hero_used_slide" ) )
	{
//		clarke_slide_teleport = getstruct( "clarke_slide_teleport", "targetname" );
//		weaver_slide_teleport = getstruct( "weaver_slide_teleport", "targetname" );
//
//		level.heroes[ "clarke" ] ForceTeleport( clarke_slide_teleport.origin, clarke_slide_teleport.angles );
//
//		level.heroes[ "weaver" ] ForceTeleport( weaver_slide_teleport.origin, weaver_slide_teleport.angles );

		level.heroes[ "weaver" ] notify( "player_slid_first" );	//ends old anim reach slide func
		level.heroes[ "clarke" ] notify( "player_slid_first" );	//ends old anim reach slide func

		level.heroes[ "weaver" ] thread npc_pipe_slide_reach();
		level.heroes[ "clarke" ] thread npc_pipe_slide_reach();

	}

	player_hands SetVisibleToPlayer( self );	
	player_hands Show();
	wait( anim_time - 0.15 );
	self notify( "stop_slide_rumble" ); //shabs - notify to stop the rumble thread
	self Unlink();
	self ShowViewModel();
	self._hiding_model = undefined;
	ClientNotify( "tgfx1" );	// Thundergun fx on
	player_hands delete();
	self SetClientDvars( "cg_drawCrosshair", 1 ); //turn on reticule

	//shabs - turning on falling death check
	level thread maps\kowloon::check_for_falling_death();

	//shabs - if player is in crouch, do nothing. if not, set to crouch
	if( self GetStance() == "stand" || self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}
}

// Clarke and Weaver slide down the pipe
#using_animtree("generic_human");
npc_pipe_slide( node_name )
{
	self endon( "player_slid_first" );

	sync_node = getstruct("anim_node_pipe_slide", "targetname");
	self disable_ai_color();
	sync_node anim_reach_aligned(self, "pipe_slide");
	flag_set( "hero_used_slide" );
	sync_node anim_single_aligned(self, "pipe_slide");
	self ent_flag_set("pipe_traversed");

	// Don't let the AI get too far ahead
	node = GetNode( node_name, "targetname" );
	self force_goal( node );
	
	self waittill( "goal" );
	if( self.targetname == "clarke" && flag( "e4_pipe_down" ) )
	{
		player = get_players()[0];

		//look at player
		self LookAtEntity(player);
	}

	//flag_wait( "e4_pipe_down" );

	// Keep colors off because the temple traverse is next
}

npc_pipe_slide_reach()
{
	if( self.targetname == "ai_clarke_ai" )
	{
		wait(0.25 );
		node = GetNode( "n_pipe_wait_clarke", "targetname" );
	}
	else
	{
		wait( 2 );
		node = GetNode( "n_pipe_wait_weaver", "targetname" );
	}	
	
	sync_node = getstruct("anim_node_pipe_slide", "targetname");
	self disable_ai_color();
	//sync_node anim_reach_aligned(self, "pipe_slide");
	
	flag_set( "hero_used_slide" );
	
	if (!ent_flag("pipe_traversed"))
	{
		sync_node anim_single_aligned(self, "pipe_slide");
	
		self ent_flag_set("pipe_traversed");
	}

	// Don't let the AI get too far ahead
//	node = GetNode( node_name, "targetname" );
	self thread force_goal();
	
	self setgoalnode(node);
	
	self waittill( "goal" );
	
	if( self.targetname == "clarke" && flag( "e4_pipe_down" ) )
	{
		player = get_players()[0];

		//look at player
		self LookAtEntity(player);
	}
}

//
temple_roof_traversal_setup()
{
	level.heroes[ "weaver" ] thread temple_roof_traverse();
	level.heroes[ "clarke" ] thread temple_roof_traverse();
}

//
temple_roof_traverse()
{
	sync_node = getstruct("anim_node_temple_roofs", "targetname");
	flag_wait("e4_pipe_down");

	// Colors off from pipe slide
//	self disable_ai_color();
	sync_node anim_reach_aligned(self, "temple_roof");
	sync_node anim_single_aligned(self, "temple_roof");
	self ent_flag_set("temple_traversed");
	self enable_ai_color();
}


//################################################################
//	EVENT 5 ANIMS : CLARKE APARTMENT DESTROY AND ROOM BREACHES
//################################################################

//
hide_heli()
{
	hip_heli = getent("heli_explode", "targetname");
	hip_heli hide();
}

//	Using a fake apartment building for the destruction
move_fake_buidling_and_sign()
{
	building = GetEnt("fake_lab", "targetname");
	sign = GetEnt("lab_sign", "targetname");
	anime_sign = GetEnt("fxanim_kowloon_neon_sign_mod", "targetname");
	fake_location = getstruct("fake_lab_location", "targetname");
	
	building moveto(fake_location.origin, 0.05);
	sign delete();
	anime_sign show();
//	sign moveto(fake_location.origin, 0.05);

}

// Helicopter flies in and gets caught in the blast
#using_animtree ("vehicles");
start_heli_exploding()
{

	hip_heli = getent("heli_explode", "targetname");
	sign = GetEnt("fxanim_kowloon_neon_sign_mod", "targetname");

	hip_heli thread heli_spotlight_enable();

	// shabs - adding spotlight to hip
//	hip_heli.spotlight = Spawn( "script_model", hip_heli GetTagOrigin( "tag_flash_gunner2" ) );
//	hip_heli.spotlight SetModel( "tag_origin" );
//	hip_heli.spotlight.angles = hip_heli GetTagAngles( "tag_flash_gunner2" );
//	hip_heli.spotlight LinkTo( hip_heli, "tag_flash_gunner2", (0,0,0), (0,0,-60) );
//	PlayFXOnTag( level._effect["spotlight"], hip_heli.spotlight, "tag_origin" );

	hip_heli.animname = "hip";
	hip_heli UseAnimTree( #animtree );
	sync_node = getstruct("anim_node_2nd_cache", "targetname");
	hip_heli show();

	//shabs - adding rumble to heli when it passes player
	hip_heli thread maps\kowloon_util::check_play_flyby();

	PlayFXOnTag(level._effect["rotor_full"], hip_heli, "main_rotor_jnt");
	playfxontag(level._effect["rotor_small"], hip_heli, "tail_rotor_jnt");

	sync_node thread anim_single_aligned(hip_heli, "heli_fly_in");

	wait(14);
	level notify("heli_explosion");
//	sync_node thread anim_single_aligned(hip_heli, "heli_explode");
	wait(1);
	//Kevin adding explo sound and starting crashing sound
	sign StopLoopSound(1);
	hip_heli PlaySound( "evt_explo3d" );
	exploder(5501);	// Roof explosion
	level notify("neon_sign_start");
	PlayFXOnTag(level._effect["fx_elec_sign_sparks_huge"], sign, "spark_fx_jnt");
	PlayFXOnTag(level._effect["heli_smoke"], hip_heli, "tag_deathfx");

	level.hip_heli_tail_fx = Spawn( "script_model", hip_heli GetTagOrigin( "tag_origin" ) );
	level.hip_heli_tail_fx SetModel( "tag_origin" );
	level.hip_heli_tail_fx LinkTo( hip_heli, "tail_rotor_jnt", (0,0,0), (0,0,0) );

	//shabs - adding trailing fx on tail rotor
	PlayFXOnTag(level._effect["chopper_burning"], level.hip_heli_tail_fx, "tag_origin");

 	wait(15);
 	hip_heli delete();

}

// Enables spotlight without shadowcasting
heli_spotlight_enable( should_enable )
{
	if( IsDefined( self.spotlight ) && !should_enable )
	{
	    self.spotlight Delete();
	    return;
	}
	else if( IsDefined( self.spotlight ) )
	{
	    return;
	}

	self Attach( "t5_veh_helo_mi8_att_spotlight", "origin_animate_jnt" );
	
	self.spotlight = Spawn( "script_model", self GetTagOrigin( "tag_flash_gunner3" ) );
	self.spotlight SetModel( "tag_origin" );
	self.spotlight.angles = self GetTagAngles( "tag_flash_gunner3" ) + (45,0,0 );

	//self.spotlight RotatePitch( -45, 0.05 );
	//self.spotlight waittill( "rotatedone" );

	self.spotlight LinkTo( self, "tag_flash_gunner3" );
	PlayFXOnTag( level._effect["spotlight"], self.spotlight, "tag_origin" );

	level waittill("neon_sign_start");

	self.spotlight Delete();
}

//
//
heli_building_impact( heli )
{
	exploder(5601);

	level.hip_heli_tail_fx Delete();

	//shabs - rumble and screenshake when heli crashes
	player = get_players()[0];
	player PlayRumbleOnEntity("kowloon_awning_rumble");

	Earthquake(1, 0.8, player.origin, 200);
}


//
//
heli_roof_crash( heli )
{
	exploder(5701);

	//shabs - rumble and screenshake when heli crashes
	player = get_players()[0];
	player PlayRumbleOnEntity("kowloon_awning_rumble");
	Earthquake(0.5, 0.5, player.origin, 200);
}


// Clarke detonates his apartment
#using_animtree ("generic_human");
start_clark_home_explode()
{
	self ent_flag_wait("temple_traversed");

	sync_node = getstruct("anim_node_2nd_cache", "targetname");

	sync_node anim_reach_aligned(self,"heli_clark");
	
	sync_node thread anim_loop_aligned(self,"heli_clark_loop");
	
	level thread start_heli_exploding();
	
	flag_wait("e4_start_clark_animation");
	
	sync_node anim_single_aligned(self,"heli_clark");
	
	flag_set( "e5_clark_detonation_done" );
}


//
start_spetz_clark_home_explode( guy )
{
	sync_node = getstruct("anim_node_2nd_cache", "targetname");

	spetznas_1 = simple_spawn_single("clark_home_explode_spetz");
	spetznas_2 = simple_spawn_single("clark_home_explode_spetz");

	spetznas_1 thread spetznas_fall_from_heli("heli_spet1");
	spetznas_2 thread spetznas_fall_from_heli("heli_spet2");
}

//
#using_animtree ("generic_human");
spetznas_fall_from_heli( animation_name )
{
	self.ignoreme = 1;
	sync_node = getstruct("anim_node_2nd_cache", "targetname");

	self.animname = "spetznaz";
	sync_node anim_single_aligned(self, animation_name);
	self delete();

}

//
start_clark_house_explosion()
{

	explosion_origin = getstructarray("clark_house_explosion", "targetname");

	for(i = 0; i < explosion_origin.size; i++)
	{
		PlayFx(level._effect["building_explosion"], explosion_origin[i].origin);
		wait(0.4);
	}
}

play_detonator_light( guy )
{
	PlayFXOnTag(level._effect["radio_light"], guy, "TAG_WEAPON_LEFT");
}

// Custom notetrack function
//
cache_door_open( guy )
{
	level notify( "weapon_cache_start" );
//
 	cache_door = GetEnt( "e5_cache_clip", "targetname" );
	PhysicsJolt( cache_door.origin, 40, 10, (-5, 0, 0) );
 	cache_door Delete();
}


//################################################################
//	EVENT 6 ANIMS : CLARKE UNLOCKS GATE
//################################################################
#using_animtree("generic_human");
clark_unlock_gate()
{
	sync_node = getstruct("anim_node_defendA_gate", "targetname");
	sync_node anim_reach_aligned(self, "unlock_start");
	sync_node anim_single_aligned(self, "unlock_start");
//	self loop_npc_idle_animation(sync_node, "unlock_loop", "unlock_complete");
//	sync_node anim_single_aligned(self, "unlock_end");

	//shabs - temp - deleting clip for now 
	clip = GetEnt( "e7_player_blocker", "targetname" );
	clip Delete();

	//turn on lookat trigger, and force trig
	trigger_use( "enable_clarke_jump_lookat" );
	
	trig_force_clarke_jump = GetEnt( "trig_force_clarke_jump", "targetname");
	trig_force_clarke_jump trigger_on();

	flag_set( "e6_clark_unlock_done");
	flag_set( "stop_defend_spawners" );

	//flag_set( "event7" );
	//trig_force_clarke_jump waittill( "trigger" );
}

//################################################################
//	EVENT 7 ANIMS : CLARKE DEATH
//################################################################
init_clark_death()
{
	sync_node = getstruct("anim_align_clarke_death", "targetname");

	flag_wait("event7");

	get_players()[0] thread clark_death_player(sync_node);
	level.heroes[ "weaver" ] thread clark_death_weaver(sync_node);

}

init_clark_death_dof_and_fog()
{
	flag_wait("event7");

	//setting new fog
	start_dist 		= 103.85;
	half_dist 		= 1467.46;
	half_height 	= 2830.47;
	base_height 	= 1275.21;
	fog_r 			= 0.0627451;
	fog_g 			= 0.101961;
	fog_b 			= 0.113725;
	fog_scale 		= 2.99699;
	sun_col_r 		= 0.211765;
	sun_col_g 		= 0.254902;
	sun_col_b 		= 0.294118;
	sun_dir_x 		= 0.163263;
	sun_dir_y 		= -0.944148;
	sun_dir_z		= 0.286235;
	sun_start_ang 	= 0;
	sun_stop_ang 	= 92.6172;
	time 			= 5;
	max_fog_opacity = 1;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity);

	//setting DOF for the last scene
	near_blur = 5;
	far_blur = 1.8;
	near_start = 0;
	near_end = 36;
	far_start = 290;
	far_end = 1563;

	player = get_players()[0];
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur );

}

#using_animtree("animated_props");
clark_death_gutter_setup()
{
	sync_node = getstruct("anim_align_clarke_death", "targetname");

	gutter = GetEnt("e7_gutter", "targetname");
	linker = Spawn( "script_model", gutter.origin );
	linker.angles = gutter.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "gutter";
	linker useanimtree(#animtree);
	gutter linkto( linker, "origin_animate_jnt" );
	sync_node anim_single_aligned(linker, "clark_death_gutter");

}


#using_animtree ("generic_human");
loop_clark_death_idle_animation(sync_node, animation, endon_notify)
{
	level endon(endon_notify);
	
	while(!IsDefined(level.player_jumped))
	{
		sync_node anim_single_aligned(self, animation);
	}

}

//
//	Clark jumps and starts hanging on
//	self = level.heroes[ "clarke" ]
clark_death_in(sync_node)
{
	sync_node thread anim_single_aligned(self, "jump");
	sync_node waittill( "jump" );

	level endon( "event7" );

	if ( !flag("event7") )
	{
		level thread weaver_callout_dialog();
		self loop_clark_death_idle_animation(sync_node, "jump_loop", "player_jumps");
	}

}

clark_jump( sync_node )
{
	level endon( "event7" );

	sync_node anim_reach_aligned( self, "jump");
}

//
//	Player jumps to rescue Clark
clark_death_out(sync_node)
{
	//level waittill( "event7" );
	flag_wait( "event7" );

	self.ignoreme = 1;
	self BloodImpact("none");	// don't let him look like he gets shot by stray bullets

	level thread clark_death_gutter_setup();
	self PlaySound( "evt_clark_death_1" );
	sync_node anim_single_aligned(self, "jump_death");
}


/*
///ScriptDocBegin
"Name: timescale_tween(start, end, time, delay, step_time)"
"Summary: Tweens timescale from a starting value to an ending value over time."
"Module: Utility"
"MandatoryArg: start: Starting timescale."
"MandatoryArg: end: Ending timescale."
"MandatoryArg: time: Time to get form start to end."
"OptionalArg: delay: time delay before starting."
"OptionalArg: step_time: time delay between setting timescale values (how smoothly you want to step)."
"Example: level thread timescale_tween(.06, 1, tween_time);"
"SPMP: both"
///ScriptDocEnd

*/


//
//	guy = Clarke
clarke_headshot( guy )
{
	clientNotify ("cds");
	
	level thread timescale_tween( 1.0, 0.1, 0.1 );
	sound_origin = guy GetTagOrigin( "j_head" );
	playsoundatposition( "evt_clark_death_headshot", sound_origin );

	if( is_mature() )
	{
		fx = PlayFxOnTag( level._effect["head_shot"], guy, "j_head" );
	}

	//shabs - added a slight rumble when the headshot occurs
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_light" );

	wait( 0.3 );
	level thread timescale_tween( 0.1, 1.0, 2.0 );
}

weaver_pull_up( guy )
{
	//shabs - added a rumble when weaver pulls player up
	player = get_players()[0];
	player PlayRumbleOnEntity("kowloon_awning_rumble");
}

weaver_player_hand( guy )
{
	//shabs - slight rumble when weaver grabs players hand
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
}

weaver_landing( guy )
{
	//shabs - slight rumble when weaver lands next to player
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
}

foot_rumbles( guy )
{
	//shabs - added a slight rumble when the headshot occurs
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_light" );
}

//
//
clarke_sign_hit( guy )
{
	guy thread stop_magic_bullet_shield();

	level notify( "neon_sign_alley_start" );

	lit_sign = GetEnt( "sm_e7_fall_sign", "targetname" );
	lit_sign Hide();
	Exploder( 8201 );	// Sign impact

	level thread timescale_tween( 1.0, 0.1, 0.1 );
	wait( 0.2 );

	level thread timescale_tween( 0.1, 1.0, 0.5 );
	Exploder( 8501 );	// Bullets behind Weaver
}


//
weaver_callout_dialog()
{
	level endon("player_jumps");
	level.heroes[ "clarke" ] endon( "death" );

	wait( 5 );

	while(1)
	{
		level.heroes[ "weaver" ] thread anim_single( level.heroes[ "weaver" ], "hudson_grab_him");
		wait(10);
		level.heroes[ "weaver" ] thread anim_single( level.heroes[ "weaver" ], "jump_hudson");
		wait(10);
		level.heroes[ "clarke" ] thread anim_single( level.heroes[ "clarke" ], "i_m_slipping");
		wait(10);
	}
}

clark_death_weaver(sync_node)
{
	self.ignoreme = 1;
	
	//shabs - adding water drops when weaver jumps down
	player = get_players()[0];
	player SetWaterDrops(50);	// 50 is the hard-coded max.

	sync_node anim_single_aligned(self, "clark_death");

	self disable_react();
	self disable_pain();
	self.ignoreme = 0;
}

send_clark_ahead_to_jump()
{
	flag_set( "e7_start_clark_jump" );

	sync_node = getstruct("anim_align_clarke_death", "targetname");
	self disable_react();
	self.ignoreall = true;
	self.ignoreme = true;
	self.allowpain = false;
	//self disable_pain();
	self.sprint = true;
	self.ignoresuppression = 1; //shabs - adding another ignore attribute

	//self set_generic_run_anim( "sprint_patrol_1"); //shabs - have clarke sprint

	self clark_jump( sync_node );

	flag_set( "e7_clark_jump" );
	self thread clark_death_in(sync_node);
	self thread clark_death_out(sync_node);
}


#using_animtree("player");
clark_death_player(sync_node)
{
	level notify ("kill_falling_to_death");

	self EnableInvulnerability();
	self._hiding_model = true;
	self DisableWeapons();
//	self thread take_and_giveback_weapons("give_weapon_back");
	ClientNotify( "tgfx0" );	// Thundergun fx off

	// turn off HUD
	self SetClientDvar( "compass", "0" );

	//kevin sherwood commenting out this shock file.  It breaks the reverb.  We need a custom shock file for this
	//self shellshock("flashbang", 1);
	self PlayRumbleOnEntity("kowloon_awning_rumble");
	player_hands = Spawn_anim_model( "player_body", self.origin );	
	player_hands.angles = self.angles;
	player_hands.animname = "player";
	self PlayerlinktoAbsolute(player_hands, "tag_player");

	player_hands SetVisibleToPlayer( self );
	self HideViewModel();
    level.player_jumped = true;
	level notify("player_jumps");
	
	//Set music to CLARK_SCENE
	setmusicstate("CLARK_SCENE");
	
	exploder(8101);

	sync_node anim_single_aligned(player_hands, "clark_death");

	//shabs - adding one enemy on the rooftop we just jumped from
	ai = simple_spawn_single( "ai_e7_jump_spot_guy", ::setup_ai_e7_jump_spot_guy );

	//shabs - turning DTP back on
	allow_divetoprone( true );

	self Unlink();
	player_hands delete();
	self ShowViewModel();
	self._hiding_model = undefined;
	self SetClientDvar( "compass", "1" );
	self DisableInvulnerability();
	self EnableWeapons();
//	self notify("give_weapon_back");
	ClientNotify( "tgfx1" );	// Thundergun fx on
	wait( 0.05 );	// wait for weapons to come back
	level notify( "clark_death_done" );

	Objective_Add( level.obj_num, "active", &"KOWLOON_OBJECTIVE_ESCAPE_WEAVER" );

	gutter = GetEnt("e7_gutter", "targetname");
	gutter Delete();

	//saving default DOF for the last scene
//	Default_Near_Start = 0;
//	Default_Near_End = 1;
//	Default_Far_Start = 8000;
//	Default_Far_End = 10000;
//	Default_Near_Blur = 6;
//	Default_Far_Blur = 0;
//
//	self SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
	//player = get_players()[0];
	self maps\_art::setdefaultdepthoffield();
	//shabs - turn off Weaver's DDS
	maps\_dds::dds_disable( "allies" );

}

setup_ai_e7_jump_spot_guy()
{
	self endon( "death" );

	//shabs - makes sure the guys runs down
	ai_e7_jump_spot_guy_node = GetNode( "ai_e7_jump_spot_guy_node", "targetname" );
	self thread force_goal( ai_e7_jump_spot_guy_node, 64 );

	trigger_wait( "trig_e7_platform1" );

	if( IsAlive( self ) )
	{
		self die();
	}
}

platform_death_triggers()
{
	level thread second_ledge();
	level thread third_ledge();
	level thread alley_force_death();
	level thread jump_platform_force_death();

	trigger_wait( "trig_e7_platform1" );
	level notify( "stop_second_ledge_force_death" );

	trigger_wait( "trig_e7_platform2" );
	level notify( "stop_third_ledge_force_death" );

	//turn on the player entrance clip
	endslider_entrance_clip = GetEnt( "endslider_entrance_clip", "targetname" );
	endslider_entrance_clip Solid();
	endslider_entrance_clip Show();
}

jump_platform_force_death()
{
	level endon( "stop_second_ledge_force_death" );

	trigger_wait( "force_death_clarke_platform" );
	platform_force_death();	
}

alley_force_death()
{
	level endon("awning02_start");

	trigger_wait( "trig_alley_force_death" );
	platform_force_death();	
}

second_ledge()
{
	level endon( "stop_second_ledge_force_death" );

	trigger_wait( "second_ledge_force_death" );
	platform_force_death();	
}

third_ledge()
{
	level endon( "stop_third_ledge_force_death" );

	trigger_wait( "third_ledge_force_death" );
	platform_force_death();	
}

platform_force_death() //self = the death trigger
{
	player = get_players()[0];

	//level notify( "falling_death" );
	player TakeAllWeapons();
	player FreezeControls(true);

	//SOUND - Shawn J
	player playsound ("evt_falling_death");
	
	player thread maps\kowloon::player_looks_up();
	//	SetTimeScale(0.5);	
	level thread maps\kowloon::fade_to_black();
	player SetBlur(15, 10);
	Earthquake( 0.3, 2, player.origin, 30000 );
	//wait(2);
	//	SetTimeScale(1);
	
	if ( flag( "sprint_jump_check" ) )
	{
		level notify( "new_quote_string" );
	
		//SetDvar( "ui_deadquote", &"KOWLOON_JUMP_DEATH" );
		missionFailedWrapper(&"KOWLOON_JUMP_DEATH");
		return;
	}
	
	missionFailedWrapper();
}

//
//	End Sequence
//
#using_animtree("generic_human");
start_spetsnaz_van_crash()
{
	spetz = self;

	for(i = 0; i < spetz.size; i++ )
	{
		if ( IsAlive( spetz[i] ) )
		{
			spetz[i].animname = "spetznaz";
			spetz[i] thread magic_bullet_shield();
			spetz[i].disableIdleStrafing = 1;
			spetz[i] disable_pain();
			spetz[i].allowpain = false;
		}
	}

	num_waits = 0;
	if ( IsAlive( spetz[0] ) )
	{
		spetz[0] thread spetsnaz_van_crash( "van_crash_1", "van_crash_1_loop" );
		num_waits++;
	}
	if ( IsAlive( spetz[1] ) )
	{
		spetz[1] thread spetsnaz_van_crash( "van_crash_2", "van_crash_2_loop" );
		num_waits++;
	}

	while ( num_waits )
	{
		level waittill( "e7_spetsnaz_done" );
		num_waits--;
	}
	flag_set( "e7_van_crash" );

	level thread start_van_crash_allies();
	level thread start_van_crash();
}

// Get actors to their spots and wait for the van crash
spetsnaz_van_crash( scene, death_loop_scene )
{
	sync_node = getstruct("van_crash_sync", "targetname");
	sync_node thread anim_reach_aligned(self, scene);
	self waittill_string("goal", self);

	self.goalradius = 0;
	level notify( "e7_spetsnaz_done" );
	flag_wait( "e7_van_crash" );

	self.ignoreme = 1;
	self thread stop_magic_bullet_shield();
	sync_node anim_single_aligned(self, scene);
	sync_node anim_loop_aligned(self, death_loop_scene); //stay looping until van_out anim
}

//
start_van_crash_allies()
{
	sync_node = getstruct("van_crash_sync", "targetname");

	GetEnt("ally_sgt_1", "targetname").script_forcespawn = true;
	GetEnt("ally_sgt_2", "targetname").script_forcespawn = true;
	GetEnt("ally_sgt_3", "targetname").script_forcespawn = true;

	level.sgt_1 = simple_spawn_single("ally_sgt_1");
	level.sgt_1 magic_bullet_shield();

	level.sgt_2 = simple_spawn_single("ally_sgt_2");
	level.sgt_2 magic_bullet_shield();
	
	level.sgt_3 = simple_spawn_single("ally_sgt_3");
	level.sgt_3 magic_bullet_shield();

	level.sgt_1.name = "Kaylor"; //driver
	level.sgt_1.animname = "sgt_1";

	level.sgt_2.name = "Maestas"; //van door guy
	level.sgt_2.animname = "sgt_2";

//	level.sgt_3.name = "Shabs"; //passenger
	level.sgt_3.animname = "sgt_3";

	level.sgt_1.ignoreall = 1;
	level.sgt_2.ignoreall = 1;
	level.sgt_3.ignoreall = 1;


	level.van_guys = array( level.sgt_1, level.sgt_2, level.sgt_3 );

	//shabs - start intro animation
	sync_node anim_single_aligned(level.van_guys, "van_crash_intro");

	Objective_Set3D( level.obj_num, true );

	level thread player_enter_van_ending( sync_node );
	level thread timeout_van_ending( sync_node );

	//shabs - begin their loop
	//sync_node thread anim_loop_aligned( level.van_guys, "van_crash_loop" ); //, undefined, "start_player_van"

	sync_node thread anim_loop_aligned( level.sgt_1, "sgt_1_van_crash_loop" );
	sync_node thread anim_loop_aligned( level.sgt_2, "sgt_2_van_crash_loop" );
	sync_node thread anim_loop_aligned( level.sgt_3, "sgt_3_van_crash_loop" );

//	player_enter_van_trig = Spawn( "trigger_radius", end_struct.origin, 0, 128, 250 );
//	player_enter_van_trig waittill_notify_or_timeout( "trigger", 500 );

}

timeout_van_ending( sync_node )
{
	level endon( "started_player_van_ending" );
	//level endon("started_timeout_ending");

	wait( 8 );

	level thread maps\kowloon_util::fade_out(8.7);

	//kill player ending anim
	level notify( "started_timeout_ending" );

	player = get_players()[0];
	player FreezeControls( true );
	player SetClientDvars( "cg_drawCrosshair", 0 );

	array_notify( level.van_guys, "start_player_van" );

	level.van_guys = array_remove( level.van_guys, level.sgt_2 );
	array_thread( level.van_guys, ::gun_remove );

	//sync_node thread anim_loop_aligned( level.sgt_2, "van_crash_loop", undefined );

//	sync_node thread anim_loop_aligned( level.sgt_1, "sgt_1_van_crash_loop" );
//	sync_node thread anim_loop_aligned( level.sgt_2, "sgt_2_van_crash_loop" );
//	sync_node thread anim_loop_aligned( level.sgt_3, "sgt_3_van_crash_loop" );

	sync_node thread anim_single_aligned( level.van_guys, "van_crash_out" );

	//level notify("objective_pos_update" );	// Get to the van
	Objective_State( level.obj_num, "done" );

	level notify( "closing_dialog" );
	
	if (!level.end_vo)
	{
		player anim_single(player, "where_we_headed", "sgt");
		level.end_vo = true;
		wait( 0.2 );

		player thread anim_single(player, "yamantau");
	}

	wait( 8.7 );

	nextmission();
}

player_enter_van_ending( sync_node )
{
	level endon( "started_timeout_ending" );

	//flag_wait( "van_waiting" );

	end_struct = getstruct( "auto222", "targetname" );
	player_enter_van_trig = Spawn( "trigger_radius", end_struct.origin, 0, 128, 250 );
	player_enter_van_trig waittill( "trigger" );

	//kill timeout ending
	level notify( "started_player_van_ending" );
	flag_set("started_player_van_ending");

	array_notify( level.van_guys, "start_player_van" );

	Objective_State( level.obj_num, "done" );

	level notify( "closing_dialog" );

	player = get_players()[0];
	player startcameratween(0.10);
	player_hands = spawn_anim_model("player_body", player.origin );
	player_hands Hide();
	player PlayerLinkToAbsolute(player_hands,"tag_player");	
	player HideViewModel();
	player SetClientDvars( "cg_drawCrosshair", 0 ); //turn off reticule
//	player_hands SetVisibleToPlayer( player );	
//	player_hands Show();

	van_guys = array_add( level.van_guys, player_hands );

	sync_node thread anim_single_aligned( van_guys, "van_crash_out" );
	//wait(.30);
	//player_hands SetVisibleToPlayer( player );	
	//player_hands Show();
	
	level maps\kowloon_util::fade_out(8.7);

	nextmission();
}

#using_animtree ("vehicles");
start_van_crash()
{
	sync_node = getstruct("van_crash_sync", "targetname");
	van_start	= GetStruct( "van", "targetname" );
	van = Spawn( "script_model", van_start.origin );
	van.angles = van_start.angles;
	van SetModel( "t5_vehicle_v_van" );
	van.animname = "van";
	van UseAnimTree( #animtree );
	van thread van_push();

	sync_node thread anim_single_aligned(van, "van_crash");

	fx = PlayFXOnTag( level._effect["van_lights"], van, "tag_origin" );

	wait( 2.3 );	// waiting for van to hit the guys
	
	ClientNotify ("tsv");
	//TUEY set music state to VAN_INCOMING
	setmusicstate ("VAN_INCOMING");

	
	level thread timescale_tween( 1.0, 0.1, 0.1 );
	wait( 0.2 );
	exploder(9101);

	door = GetEnt( "sm_e7_garage_door", "targetname" );
	door SetModel( "p_kow_garage_door_dmg" );

	level thread timescale_tween( 0.1, 1.0, 0.3 );
	
	ClientNotify ("tvs");

	level notify("kill_rest");
}

// Van push
//	Hurl AI that get in the way.
//	self is the van ent
van_push()
{
	self endon( "van_stopped" );
	trig = GetEnt( "van_push", "targetname" );
	trig EnableLinkTo();
	trig LinkTo( self );
	vector = vector_scale( AnglesToForward(self.angles), 100 );	// Vector of the van

	while ( 1 )
	{
		trig waittill( "trigger", ent );

		if ( IsAlive(ent) && ent.team == "axis" && !IsDefined( ent.animname ) )
		{
			ent StartRagdoll();
			ent launchragdoll( vector );
			ent DoDamage( ent.health, self.origin );
		}
	}
}

audio_start_idle_loop( guy )
{
    guy notify( "force_stop" );
    guy endon( "force_stop" );
    
    if( !IsDefined( level.audio_idle_ent ) )
    {
        level.audio_idle_ent = Spawn( "script_origin", guy.origin );
    }
    
    level.audio_idle_ent PlayLoopSound( "evt_interr_struggle_loop", .5 );
    
    guy waittill( "end_audio_idle_loop" );
    
    level.audio_idle_ent StopLoopSound( .5 );
    wait(1);
    level.audio_idle_ent Delete();
}

audio_stop_idle_loop( guy )
{
    guy notify( "end_audio_idle_loop" );
}

landing_dust_fx( guy )
{
	//IPrintLnBold( "play dust now" );
	exploder(3101);
}
 