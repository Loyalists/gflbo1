
#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\flamer_util;
#include maps\_civilians;
#include maps\_music;
#include maps\hue_city;

#using_animtree("generic_human");
hue_city_anim_main()
{
	init_notetracks();
	init_player_anims();
	init_macv_ai_anims();
	init_ai_anims();
	init_vehicle_anims();
	init_prop_anims();
	
	init_macv_dialogue();
	init_street_dialogue();


	level thread alley_civ_mourning();
	
	level thread streets_intro_vignettes();
	
	//level thread brutalization_scene();
	level thread execution_scene();
	//level thread tankcrush_scene();
	level thread crosby_scene();
	level thread breach_alley_gate_vignette();
	level thread wounded_into_chopper();

	level thread maps\hue_city_fx::aa_gun_fall_anim();
}

init_macv_dialogue()
{
	// 	level.scr_sound["generic"]["negative"]		= "vox_hue1_s01_001A_usc2_f";		// Negative, negative. RT-Texas is not in the sector.
// 	level.scr_sound["generic"]["air_support"]	= "vox_hue1_s01_002A_mar3_f";		// We need immediate air support!
// 	level.scr_sound["generic"]["were_hit"]		= "vox_hue1_s01_003A_uss1_f";		// We're hit! We're hit!
// 	level.scr_sound["generic"]["macv_is_lost"]	= "vox_hue1_s01_004A_usc2_f";		// Sitrep. November Victor Charlie has taken MacV East. Repeat MacV East is lost.
// 	level.scr_sound["generic"]["apc"]			= "vox_hue1_s01_005A_uss1_f";	 	// Get that god damned APC over here now! I have wounded men here.
// 	level.scr_sound["generic"]["hitting_hard"]	= "vox_hue1_s01_006A_usc2_f";	 	// Charlie's hitting us hard from the north. Our boys are down there.
// 	level.scr_sound["generic"]["dont_care"]		= "vox_hue1_s01_007A_mar3_f";	 	// I don't care what your orders are soldier. You WILL divert to sector Tango Lima Five immediately.
// 	level.scr_sound["generic"]["pull_back"]		= "vox_hue1_s01_008A_uss1_f";	 	// Pull back! We need to retreat!

	level.scr_sound["generic"]["major_shit"]																= "vox_hue1_s01_009A_usc1_f"; 	// MacV compound in sight. You are dropping into some major shit, Woods.
	level.scr_sound["generic"]["here_to_extract"] 													= "vox_hue1_s01_400A_maso"; //We're here to extract a defector with vital intel on Soviet involvement in 'Nam...
  level.scr_sound["generic"]["lost_contact"] 															= "vox_hue1_s01_401A_maso"; //We lost contact with his protection team - But they may be holed up in the MACV's safe room.
  level.scr_sound["generic"]["well_find_him"] 													  = "vox_hue1_s01_402A_wood"; //If he's still alive, we'll find him.
  level.scr_sound["generic"]["hook_up"]  																	= "vox_hue1_s01_403A_usc1_f"; //SOG Xray team, hook up.
  level.scr_sound["generic"]["squad_on_wire"] 							 /*animated*/ = "vox_hue1_s01_013A_usc1_f"; //Xray squad is on the wire.
  level.scr_sound["generic"]["team_on_wire"] 							 	 /*animated*/ = "vox_hue1_s01_404A_usc1_f"; //Xray team is on the wire.
  level.scr_sound["generic"]["shit_were_hit"] 							 /*animated*/ = "vox_hue1_s01_014A_usc1_f"; //Shit! Quad 50! We're hit!
  level.scr_sound["generic"]["we_goin_down"] 							 	 /*animated*/ = "vox_hue1_s01_015A_usc1_f"; //Lima 9 we are going down!
  level.scr_sound["generic"]["oh_shiiit"] 							 		 /*animated*/ = "vox_hue1_s01_016A_maso"; //OH SHIIIIT!
  level.scr_sound["generic"]["look_out"]							 			 /*animated*/ = "vox_hue1_s01_405A_wood"; //LOOK OUT!!!
  //level.scr_sound["generic"]["hold_on"]							 										= "vox_hue1_s01_017A_usc1_f"; //Hold on!...
  level.scr_sound["generic"]["h6_come_back"]					    	 /*animated*/ = "vox_hue1_s01_018A_usc2_f"; //Hotel Six come back. Hotel Six do you copy?
	level.scr_sound["generic"]["h6_gone"]					    	 			 /*animated*/ = "vox_hue1_s01_019A_usc2_f"; //Lima 9, Hotel Six is gone.
  level.scr_sound["generic"]["spas12_hold"]					    	 	 /*animated*/ = "vox_hue1_s01_020A_wood_m"; //Here. Spas 12. It'll hold your incendiaries. Where we headed Mason?


	//level.scr_sound["generic"]["well_find_him"]		= "vox_hue1_s01_012A_wood_m"; 	// All right Mason. We'll work down from the roof. If your contact's alive, we'll find him.

	//level.scr_sound["generic"]["safe_room"] ="vox_hue1_s01_022A_wood_m"; // alright, lets go find your agent


  level.scr_sound["generic"]["lets_move"] 					    	 	 							= "vox_hue1_s01_406A_wood"; //Let's move.
  level.scr_sound["generic"]["watch_corners"] 					    	 	 					= "vox_hue1_s01_023A_maso"; //Watch the corners!
  level.scr_sound["generic"]["visual_conf"] 					    	 	 						= "vox_hue1_s01_407A_bowm_f"; //Lima 9, I have visual confirmation on Xray.
  level.scr_sound["generic"]["got_nva_northwing"] 					    	 	 			= "vox_hue1_s01_408A_bowm_f"; //You got NVA all over the North wing.
  level.scr_sound["generic"]["light_em_up"] 					    	 	 						= "vox_hue1_s01_409A_wood"; //Light 'em up Bowman!
  level.scr_sound["generic"]["lima9_inbound"]  					    	 	 					= "vox_hue1_s01_029A_usc2_f"; //Lima 9 is inbound.
  level.scr_sound["generic"]["heads_down"]  					    	 	 						= "vox_hue1_s01_030A_bowm_f"; //Xray, keep your heads down!
  level.scr_sound["generic"]["xray_clear"] 					    	 	 							= "vox_hue1_s01_031A_bowm_f"; //Xray, you are clear.
  level.scr_sound["generic"]["move_up"]  					    	 	 								= "vox_hue1_s01_032A_wood"; //Move up!
  level.scr_sound["generic"]["out_of_way"] 					    	 	 							= "vox_hue1_s01_033A_wood"; //Move out of the way!
  level.scr_sound["generic"]["ne_corner"]  					    	 	 							= "vox_hue1_s01_350A_wood"; //Bowman! North East corner!
  level.scr_sound["generic"]["on_our_way"] 					    	 	 							= "vox_hue1_s01_410A_bowm_f"; //On our way.
  level.scr_sound["generic"]["breaching_roof"] 					    	 	 					= "vox_hue1_s01_411A_bowm_f"; //Xray we are breaching the roof.

  level.scr_sound["generic"]["overrun"] 					    	 	 	 						  = "vox_hue1_s01_038A_bowm"; //The whole damn building's overrun!
	level.scr_sound["generic"]["dispatch_next_floor"]  					    	 	 	 	= "vox_hue1_s01_412A_wood"; //Dispatch is next floor down.
  level.scr_sound["generic"]["defec_survive"] 					    	 	 	 				= "vox_hue1_s01_413A_bowm"; //You think the defector survived the attack?!
  level.scr_sound["generic"]["tough_sonb"]  					    	 	 	 					= "vox_hue1_s01_414A_wood"; //If he did, then he's one tough son of a bitch!
  level.scr_sound["generic"]["viet_squak1"]  					    	 	 	 					= "vox_hue1_s01_039A_nva3"; //(Translated) The People's Army of Vietnam has found you guilty of treason. You have been sentenced to death for crimes against the state.
  level.scr_sound["generic"]["b_translate"]  					    	 	 	 					= "vox_hue1_s01_040A_wood"; //Bowman, translate!
  level.scr_sound["generic"]["roundup"]  					    	 	 	 						  = "vox_hue1_s01_041A_bowm"; //They're rounding up civilians for execution.
  level.scr_sound["generic"]["collaboration_with"] 					    	 	 	 		= "vox_hue1_s01_042A_nva3"; //Your collaboration with the Americans is proof of your guilt. In accordance with party tradition, the punishment is to be carried out immediately.
  level.scr_sound["generic"]["viet_squak2"] 					    	 	 	 				 	= "vox_hue1_s01_042B_nva3"; //(Translated) Your collaboration with the Americans is proof of your guilt. In accordance with party tradition, the punishment is to be carried out immediately.
  level.scr_sound["generic"]["get_down"] 					    	 	 	 					 	  = "vox_hue1_s01_044A_bowm"; //Get down!
  level.scr_sound["generic"]["evil_mfuckers"] 					    	 	 	 				= "vox_hue1_s01_045A_bowm"; //Evil mother fuckers!
  level.scr_sound["generic"]["anyone_doesnt_wont"] 					    	 	 	 		= "vox_hue1_s01_415A_usc2_f"; //Xray this is Lima 9. Anyone who doesn't get out soon, isn't going to; the NVA have overwhelmed the entire North Wing.
  level.scr_sound["generic"]["moving_on"]  					    	 	 	 						= "vox_hue1_s01_416A_wood"; //Roger that Lima 9. We are moving on.
  level.scr_sound["generic"]["safe_room_ahead"] 					    	 	 	 			= "vox_hue1_s01_417A_maso"; //Safe room is just ahead.
  level.scr_sound["generic"]["molotov"] 					    	 	 	 						  = "vox_hue1_s01_049A_wood"; //Molotov!
  level.scr_sound["generic"]["at_the_window"]  					    	 	 	 				= "vox_hue1_s01_050A_bowm"; //At the window!
  level.scr_sound["generic"]["clear"] 					    	 	 	 							  = "vox_hue1_s01_051A_bowm"; //Clear!
  level.scr_sound["generic"]["other_side_of_war_room"] 										= "vox_hue1_s01_545A_wood"; //The safe rooms are on the other side of the war room.

  level.scr_sound["generic"]["safe_room_down"] 					    	 	 	 				= "vox_hue1_s01_418A_maso"; //The safe room is down there.
  level.scr_sound["generic"]["safe_room_compramised"]  					    	 	 	= "vox_hue1_s01_419A_maso"; //Safe room's been comprimised.
  level.scr_sound["generic"]["been_compramised"]  					    	 	 	 		= "vox_hue1_s01_420A_maso"; //It's been comprimised.

  level.scr_sound["generic"]["wheres_contact"]  					    	 	 		 		= "vox_hue1_s01_421A_bowm"; //So where's your contact?
  level.scr_sound["generic"]["chance_nva"]   					    	 	 	 					= "vox_hue1_s01_422A_maso"; //There's a chance the NVA attack forced them to fall back to the command room... He may still be alive.
  level.scr_sound["generic"]["lets_move2"]  					 				   	 	 	 		= "vox_hue1_s01_423A_maso"; //Let's move.
  level.scr_sound["generic"]["lima9_sitrep"]  					 				   	 	 	 	= "vox_hue1_s01_424A_wood"; //Lima 9 - sitrep!
  level.scr_sound["generic"]["nva_retaken_south"]  					 				   	 	= "vox_hue1_s01_425A_usc2_f"; //Xray - The NVA has retaken the MACV South. You are cut off.
  level.scr_sound["generic"]["shit"]   					 				   	 	 	 		   		= "vox_hue1_s01_058A_wood"; //Shit.
  level.scr_sound["generic"]["yeah_copy_l9"]   					 				   	 	 	 	= "vox_hue1_s01_059A_bowm"; //Yeah.. Copy that Lima 9.
  level.scr_sound["generic"]["move_your_asses"]  					 				   	 	 	= "vox_hue1_s01_060A_usc2_f"; //You better move your asses right now if you want an evac.
  level.scr_sound["generic"]["move_on_me"]   					 				   	 	 	 		= "vox_hue1_s01_426A_maso"; //Let's move - on me.
  level.scr_sound["generic"]["rpg"] 																			= "vox_hue1_s01_559A_wood"; //RPG!!!
  level.scr_sound["generic"]["command_central"]  					 				   	 	 	= "vox_hue1_s01_067A_wood"; //We're in Command Central. The exit's on the other side.
  level.scr_sound["generic"]["should_be_in_rooms"]  					 				   	= "vox_hue1_s01_427A_maso"; //He should be in one of these rooms.
  level.scr_sound["generic"]["door_at_end"]  					 				   	 	 	 		= "vox_hue1_s01_428A_wood"; //Mason - Take the door at the end of the hall.
  level.scr_sound["generic"]["bowman_on_me"]  					 				   	 	 	 	= "vox_hue1_s01_429A_wood"; //Bowman - On me.

	level.scr_sound["generic"]["rh_nag_overkill1"]  					 				   	 	= "vox_hue1_s01_554A_wood"; //Mason, breach that door!
  level.scr_sound["generic"]["rh_nag_overkill2"]  					 				   	 	= "vox_hue1_s01_555A_wood"; //You need to breach that door, Mason.
  level.scr_sound["generic"]["rh_nag_overkill3"]  					 				   	 	= "vox_hue1_s01_556A_wood"; //Are going to breach that God damn door?
  level.scr_sound["generic"]["rh_nag_overkill4"]  					 				   	 	= "vox_hue1_s01_557A_wood"; //We have to get moving. Breach that door.
  level.scr_sound["generic"]["rh_nag_overkill5"]   					 				   	 	= "vox_hue1_s01_558A_wood"; //We are running out of time Mason.

 level.scr_sound["generic"]["mason?"] 											 /*animated*/ = "vox_hue1_s01_430A_rezn"; //Mason?
 //level.scr_sound["generic"]["reznov"] 											 /*animated*/ = "vox_hue1_s01_431A_maso"; //Reznov.
 level.scr_sound["generic"]["never_thought_see_u"] 					 /*animated*/ = "vox_hue1_s01_432A_maso"; //Never thought I'd see you alive...
 level.scr_sound["generic"]["nor_i_u"] 											 /*animated*/ = "vox_hue1_s01_433A_rezn"; //Nor I you, my friend.
 level.scr_sound["generic"]["ur_defector"] 									 /*animated*/ = "vox_hue1_s01_434A_maso"; //You're our defector?
 level.scr_sound["generic"]["here_with_warning"] 						 /*animated*/ = "vox_hue1_s01_435A_rezn"; //I am here with a warning your government would do well to heed...
 level.scr_sound["generic"]["drago_planning"] 							 /*animated*/ = "vox_hue1_s01_436A_rezn"; //Dragovich is planning an attack on the West.
 level.scr_sound["generic"]["get_what_came_for"]   					 				   	  = "vox_hue1_s01_437A_wood_f"; //Mason!... You get what you came for?
 level.scr_sound["generic"]["good_2_go"]    					 				   	 	 	 		= "vox_hue1_s01_438A_maso"; //We're good to go.
 level.scr_sound["generic"]["drago_havent_seen_last"]   					 				= "vox_hue1_s01_439A_maso"; //Dragovich... I knew we hadn't seen the last of him.
 level.scr_sound["generic"]["influence_like_cancer"]   					 				  = "vox_hue1_s01_440A_rezn"; //His influence spreads like a cancer... Even the Kremlin does not know what he is truly planning.
 level.scr_sound["generic"]["must_b_stopped"]   					 				   	 	  = "vox_hue1_s01_441A_rezn"; //He must be stopped, Mason.
 level.scr_sound["generic"]["dsk_all_must_die"]   					 				   	  = "vox_hue1_s01_442A_rezn"; //Dragovich... Steiner... Kravchenko... All must die.
 level.scr_sound["generic"]["these_ur_men"]   					 				   	 	 	  = "vox_hue1_s01_443A_rezn"; //Are these your men?
 level.scr_sound["generic"]["woods_bow"]    					 				   	 	 	 		= "vox_hue1_s01_444A_maso"; //Woods. Bowman.
 level.scr_sound["generic"]["im_reznov"]   					 				   	 	 	 		  = "vox_hue1_s01_445A_rezn"; //I am Reznov... Viktor.
 level.scr_sound["generic"]["your_intel"]    					 				   	 	 	 		= "vox_hue1_s01_446A_wood"; //Your intel better be worth it... Sounds like a shitstorm up ahead.
 //level.scr_sound["generic"]["see_no_chopper"]   					 				   	 	 	= "vox_hue1_s01_447A_rezn"; //I see no chopper... Where is our extraction?!
 level.scr_sound["generic"]["wheres_our_lz"]   					 				   	 	 	 	= "vox_hue1_s01_448A_wood"; //Lima 9... Where the Hell's our LZ?!!
 level.scr_sound["generic"]["marine_force_engaged"]    					 				  = "vox_hue1_s01_449A_usc2_f"; //Xray - Be advised... Marine forces are engaged in heavy fighting West of the MACV.
 level.scr_sound["generic"]["push_through"]   					 				   	 	 	 	= "vox_hue1_s01_450A_usc2_f"; //Push through to Rally Point Delta - 2 clicks North on the River.
 level.scr_sound["generic"]["find_way_through"]   					 				   	 	= "vox_hue1_s01_451A_wood"; //We'll find a way through... Just be there...
}

init_street_dialogue()
{

  
	level.scr_sound["generic"]["gonna_need"] 																= "vox_hue1_s01_452A_wood"; //We're gonna need some air support for this shit.

 	level.scr_sound["generic"]["we_luv_you"] 																= "vox_hue1_s02_068A_nva3"; //(Translated) American soldiers! Put down your weapons! This is not your war. We wish you no harm. The Peoples Army of Vietnam is here to liberate you!
 	level.scr_sound["generic"]["we_luv_you_native"] 												= "vox_hue1_s02_068B_nva3"; //(Translated) American soldiers! Put down your weapons! This is not your war. We wish you no harm. The Peoples Army of Vietnam is here to liberate you!
  level.scr_sound["generic"]["hurry_up_get_radio"]  											= "vox_hue1_s02_453A_wood"; //Hurry up and get the radio!
	level.scr_sound["generic"]["grab_damn_radio"]  													= "vox_hue1_s02_454A_wood"; //Mason! Grab that damn radio!
	level.scr_sound["generic"]["what_waiting_for"] 													= "vox_hue1_s02_455A_wood"; //What are you waiting for?... We need that radio, Mason.
 	level.scr_sound["generic"]["we_need_air"] 						/*animated*/      = "vox_hue1_s02_069A_cros_m";//RT-Texas this is One Five. We need immediate air support at grid seven Quebec November Bravo!
	level.scr_sound["generic"]["negative"] 								/*animated*/		  = "vox_hue1_s02_070A_usc3_f";//Negative One Five. Our primary objective is MacV south. Stay with your company.
	level.scr_sound["generic"]["dont_have_company"] 			/*animated*/		  = "vox_hue1_s02_071A_cros_m";//We don't have a company! We were cut off in the attack!
	level.scr_sound["generic"]["everyones_shit_son"] 			/*animated*/		  = "vox_hue1_s02_072A_usc3_f";//One Five we do not have authorization in that grid. Everyone's in the shit, son.
	level.scr_sound["generic"]["sob_1"]	 									/*animated*/		  = "vox_hue1_s02_073A_cros_m";//Son of a bitch�
	level.scr_sound["generic"]["give_me_radio"]	 					/*animated*/			= "vox_hue1_s02_074A_maso";//Marine, give me that radio.
	level.scr_sound["generic"]["your_sog"]	 							/*animated*/			= "vox_hue1_s02_075A_cros_m";//Who the hell� you're SOG?
	level.scr_sound["generic"]["give_me_radio_son"]	 			/*animated*/	    = "vox_hue1_s02_076A_maso";//Give me the radio son.
	level.scr_sound["generic"]["gluck_w_shit"]	 					/*animated*/			= "vox_hue1_s02_077A_cros_m";//Good luck with that shit.
	level.scr_sound["generic"]["authorization_operation"] /*animated*/			= "vox_hue1_s02_078A_maso"; //RT-Texas this is Sierra Oscar Golf Xray. Authorization Operation Delta. Your orders are now superseded. Priority one ordnance on my command�
	level.scr_sound["generic"]["affirmative_xray"] 				/*animated*/		  = "vox_hue1_s02_079A_usc3_f";//Affirmative Xray. Let us know where you need us.
	level.scr_sound["generic"]["holy_shit"]		 						/*animated*/			= "vox_hue1_s02_080A_cros_m";//on of a bitch... Holy shit!
	level.scr_sound["generic"]["xray_move_up_perch"] 												= "vox_hue1_s02_456A_wood"; //Xray - Move up!
	level.scr_sound["generic"]["neg_rpgs_roofs"] 														= "vox_hue1_s02_457A_usc3_f"; //That's a negative Xray - We see RPGs on the rooftops.
	level.scr_sound["generic"]["xray_too_hot"]  														= "vox_hue1_s02_458A_usc3_f"; //Xray - its too hot! Clear out those RPGs!
	level.scr_sound["generic"]["clear_team_from_area"]  										= "vox_hue1_s02_459A_usc3_f"; //Understood Xray. Clear your team from the area.
  level.scr_sound["generic"]["mason_use"]	 							/*implemented*/   = "vox_hue1_s02_088A_wood";//Mason, use that air support on the buildings!
	level.scr_sound["generic"]["not_going_to_use_it"]							 		    	= "vox_hue1_s02_090A_bowm";//Mason, give ME the damned radio if "you're not going to use it.
	level.scr_sound["generic"]["texas_standing_by"]				/*implemented*/	  = "vox_hue1_s02_091A_usc3_f";//Xray, RT-Texas is standing by for orders.
	level.scr_sound["generic"]["waiting_for_command"]			/*implemented*/   = "vox_hue1_s02_092A_usc3_f";//RT-Texas, waiting for ordnance command, over.
	level.scr_sound["generic"]["requesting_coordinates"]	/*implemented*/   = "vox_hue1_s02_093A_usc3_f";//Xray, we have no visual on targets. Requesting coordinates, over.
	level.scr_sound["generic"]["copy_2_story"]						/*implemented*/		= "vox_hue1_s02_094A_usc3_f";//Copy that Xray, targeting the 2 story building.
	level.scr_sound["generic"]["copy_3_story"]						/*implemented*/		= "vox_hue1_s02_095A_usc3_f";//Roger Xray, engaging the 3 story building.
	level.scr_sound["generic"]["copy_4_story"]						/*implemented*/		= "vox_hue1_s02_096A_usc3_f";//Roger that. Wild fire on the 4 story building.
	level.scr_sound["generic"]["copy_5_story"]						/*implemented*/		= "vox_hue1_s02_097A_usc3_f";//We copy Xray. Firing on the 5 story building.
	level.scr_sound["generic"]["copy_6_story"]						/*implemented*/		= "vox_hue1_s02_098A_usc3_f";//Coordinates received. Contact at the 6 story building.
	level.scr_sound["generic"]["i_need_heat"]							/*implemented*/		= "vox_hue1_s02_099A_maso";//RT-Texas, I need some heat.
	level.scr_sound["generic"]["we_are_inbound"]					/*implemented*/		= "vox_hue1_s02_100A_usc3_f";//Roger that, we are inbound.
	level.scr_sound["generic"]["ordinance_my_mark"]				/*implemented*/	  = "vox_hue1_s02_101A_maso";//RT-Texas, ordinance on my mark.
	level.scr_sound["generic"]["copy_hold_tight"]					/*implemented*/		= "vox_hue1_s02_102A_usc3_f";//We copy Xray, hold tight.
	level.scr_sound["generic"]["marking_coordinates"]			/*implemented*/	  = "vox_hue1_s02_103A_maso";//Marking coordinates. Take 'em out
	level.scr_sound["generic"]["understood_engaging"]			/*implemented*/   = "vox_hue1_s02_104A_usc3_f";//Understood Xray. We are engaging.
	level.scr_sound["generic"]["hit_danger_close"]				/*implemented*/	  = "vox_hue1_s02_105A_maso";//RT-Texas hit that nest right now. Danger close!
	level.scr_sound["generic"]["affirmative_heads_down"]	/*implemented*/   = "vox_hue1_s02_106A_usc3_f";//Affrimative Xray. Keep your heads down.
	level.scr_sound["generic"]["target_marked"]						/*implemented*/		= "vox_hue1_s02_107A_maso";//Target marked. Hit 'em hard.
	level.scr_sound["generic"]["texas_on_its_way"]				/*implemented*/		= "vox_hue1_s02_108A_usc3_f";//Copy. RT-Texas is on its way.
	level.scr_sound["generic"]["target_is_tagged"]				/*implemented*/		= "vox_hue1_s02_109A_maso";//RT-Texas, your target is tagged.
	level.scr_sound["generic"]["support_on_its_way"] 			/*implemented*/   = "vox_hue1_s02_110A_usc3_f";//We see you Xray. Support on its way.
	level.scr_sound["generic"]["negative_friendlies"]			/*implemented*/   = "vox_hue1_s02_111A_usc3_f";//Negative Xray we see friendlies on your mark.
	level.scr_sound["generic"]["coordinates_on_friendlies"]/*implemented*/	= "vox_hue1_s02_112A_usc3_f";//Xray those coordinates are on friendlies. Confirm, over?
	level.scr_sound["generic"]["negative_invalid_target"]	/*implemented*/ 	= "vox_hue1_s02_113A_usc3_f";//Negative Xray, that is not a valid target.
	level.scr_sound["generic"]["understood_clear_squad"]	/*implemented*/   = "vox_hue1_s02_114A_usc3_f";//Understood Xray. Clear your squad from the area.
	level.scr_sound["generic"]["clear_area_danger_close"]	/*implemented*/   = "vox_hue1_s02_115A_wood";//Clear the area! Danger close!
	level.scr_sound["generic"]["affirmative_clear_area"]	/*implemented*/   = "vox_hue1_s02_116A_usc3_f";//Affirmative Xray. Clear the area.
	level.scr_sound["generic"]["first_squad_get_out"]			/*implemented*/   = "vox_hue1_s02_117A_wood";//First squad, get out of there! Inbound on our position
	
	level.scr_sound["generic"]["strafe_will_be_late"]												= "vox_hue1_s99_800A_usc2_f"; //Roger X-Ray - Standby for strafing run.
  level.scr_sound["generic"]["late_strafe_ready"]													= "vox_hue1_s99_801A_usc2_f"; //X-Ray - We're coming in hot.
	
	level.scr_sound["generic"]["you_have_roof_contact"]							      	= "vox_hue1_s02_118A_usc3_f";//Xray you have contact on the roof of the 4 story building.
	level.scr_sound["generic"]["enemy_roof_rpg"]										      	= "vox_hue1_s02_119A_usc3_f";//Xray, enemy RPG on the roof.
	level.scr_sound["generic"]["target_eliminated"]				/*implemented*/	  = "vox_hue1_s02_120A_usc3_f";//Target eliminated.
	level.scr_sound["generic"]["enemy_down"]							/*implemented*/		= "vox_hue1_s02_121A_usc3_f";//Enemy down.
	level.scr_sound["generic"]["multiple_kha"]						/*implemented*/		= "vox_hue1_s02_122A_usc3_f";//Multiple KHA. Zero is clear.
	level.scr_sound["generic"]["t55_on_us"]								/*implemented*/		= "vox_hue1_s02_123A_bowm";//APC's down! We got a T-55 on us!
	level.scr_sound["generic"]["mason_tag_sob"]						/*implemented*/		= "vox_hue1_s02_124A_wood";//Mason! Tag that son of a bitch right now!
	level.scr_sound["generic"]["texas_on_t55"]						/*implemented*/		= "vox_hue1_s02_125A_maso";//RT-Texas, I need all you've got on that T-55 in front of us.
	level.scr_sound["generic"]["enemy_armor"]							/*implemented*/		= "vox_hue1_s02_126A_maso";//RT-Texas we have enemy armor at grid Victor Zulu Seven Foxtrot.
	level.scr_sound["generic"]["t55_killing_us"]					/*implemented*/		= "vox_hue1_s02_128A_bowm";//That T-55 is killing us! Mason, put the birds on it!
	level.scr_sound["generic"]["rain_down_hell"]					/*implemented*/		= "vox_hue1_s02_129A_usc3_f";//Affirmative Xray. RT-Texas will rain down hell.
	level.scr_sound["generic"]["coming_strafing_run"]			/*implemented*/   = "vox_hue1_s02_130A_usc3_f";//Roger that Xray. Coming in for a strafing run.
	level.scr_sound["generic"]["building_is_secure"] 												= "vox_hue1_s02_300A_usc3_f"; //Xray, the building is secure, over.
	level.scr_sound["generic"]["mul_conf_kill"]  														= "vox_hue1_s02_301A_usc3_f"; //We have multiple confirmed kills at zero. Area secure.
	level.scr_sound["generic"]["free_to_proceed"]  													= "vox_hue1_s02_302A_usc3_f"; //Xray you are free to proceed. You have superiority.
	level.scr_sound["generic"]["control_of_building"]  											= "vox_hue1_s02_303A_usc3_f"; //Xray we have control of the building. Move up.
	level.scr_sound["generic"]["excellent"]  																= "vox_hue1_s02_460A_rezn"; //Excellent!!!
	level.scr_sound["generic"]["rain_fire"]  																= "vox_hue1_s02_461A_rezn"; //Rain fire!
	level.scr_sound["generic"]["keep_on_them"]  														= "vox_hue1_s02_462A_rezn"; //Keep on them, Mason!
	level.scr_sound["generic"]["fight_by_side_once_more"] 									= "vox_hue1_s02_463A_rezn"; //It is good to fight by your side once more!
	level.scr_sound["generic"]["what_are_u_waitin_4"]  											= "vox_hue1_s02_464A_rezn"; //Mason! What are you waiting for?!
	level.scr_sound["generic"]["armor_destroyed"]  													= "vox_hue1_s02_465A_usc3_f"; //Armor destroyed - Xray you are clear to proceed.
	level.scr_sound["generic"]["xray_move_up"]  														= "vox_hue1_s02_466A_wood"; //Xray, move up!
  
	level.scr_sound["generic"]["lz_half_click"] 														= "vox_hue1_s02_467A_wood"; //The LZ's half a click away; end of the street.
	level.scr_sound["generic"]["get_gate_open"] 														= "vox_hue1_s02_469A_wood"; //Get that gate open! We've got an AA gun in the area.

	level.scr_sound["generic"]["evasive_action"]	 				/*implemented*/	  = "vox_hue1_s02_133A_usc3_f";//Shit... evasive action� Xray we are under heavy fire!
	level.scr_sound["generic"]["texas_pulling_out"]	 			/*implemented*/   = "vox_hue1_s02_134A_usc3_f";//Xray the grid is hot. RT-Texas is pulling out. Take down that anti-air and we will return support, over.
  level.scr_sound["generic"]["understood_texas"]  												= "vox_hue1_s02_468A_maso"; //Understood Texas.  
  
  level.scr_sound["generic"]["zsu_second_floor"]	 			/*implemented*/	  = "vox_hue1_s02_137A_bowm";//There it is. ZSU on the second floor, end of the street.	
	level.scr_sound["generic"]["street_beating_zone"] 											= "vox_hue1_s02_470A_wood"; //We need to find another way - that street's a beating zone.
	level.scr_sound["generic"]["use_building_flank"] 												= "vox_hue1_s02_471A_rezn"; //We can use this building to flank around!
	level.scr_sound["generic"]["help_me_clear"]											      	= "vox_hue1_s02_140A_wood";//This will do. Help me clear it.
 	level.scr_sound["generic"]["got_a_t55"]  																= "vox_hue1_s02_472A_bowm"; //We got a T-55!
	level.scr_sound["generic"]["get_off_street"]  													= "vox_hue1_s02_473A_bowm"; //Get off the street!
	level.scr_sound["generic"]["jesus.."]  																	= "vox_hue1_s02_150A_maso_m"; //Jesus...
	level.scr_sound["generic"]["still_1_piece"] 														= "vox_hue1_s02_474A_rezn"; //Still in one piece, my friend?
	level.scr_sound["generic"]["im_good"]  																	= "vox_hue1_s02_475A_maso"; //I'm good.
	level.scr_sound["generic"]["lets_move_to_zsu"] 													= "vox_hue1_s02_476A_wood"; //Mason, let's move up to that ZSU... Bowman, keep these guys safe.
	level.scr_sound["generic"]["got_it"]														     		= "vox_hue1_s02_157A_bowm";//Got it.	
	level.scr_sound["generic"]["blocked_up_stairs"]									     		= "vox_hue1_s02_158A_wood";//Blocked. Up the stairs.
 	level.scr_sound["generic"]["were_on_it"]  															= "vox_hue1_s02_477A_wood"; //We're on it!
	level.scr_sound["generic"]["mason!!"] 																	= "vox_hue1_s02_478A_wood"; //Mason!!!
	level.scr_sound["generic"]["u_ok_bro"] 																	= "vox_hue1_s02_479A_wood"; //You okay, brother?
	level.scr_sound["generic"]["still_breathing"] 													= "vox_hue1_s02_480A_maso"; //Still breathing.
	level.scr_sound["generic"]["we_meet_u_at_rp"] 													= "vox_hue1_s02_481A_maso"; //We'll meet you at the RP.
	
	level.scr_sound["generic"]["zsu_above_us"]  														= "vox_hue1_s02_482A_maso"; //The ZSU is right above us.
	level.scr_sound["generic"]["charge_ceiling"]  													= "vox_hue1_s02_483A_rezn"; //Put a charge on the ceiling - blow the floor from beneath them.
	level.scr_sound["generic"]["charlie_in_pocket"]  												= "vox_hue1_s02_164A_bowm_f"; //I got Charlie in my pocket here one zero. How much longer?
	level.scr_sound["generic"]["3_seconds"]  																= "vox_hue1_s02_484A_maso"; //About 3 seconds.
	level.scr_sound["generic"]["get_safe_distance"]  												= "vox_hue1_s02_485A_rezn"; //Get to a safe distance!
	level.scr_sound["generic"]["clear_ready"]  															= "vox_hue1_s02_486A_maso"; //We're clear! Ready, Reznov?
	level.scr_sound["generic"]["good_work_mason"] 													= "vox_hue1_s02_487A_rezn"; //Good work, Mason!



	level.scr_sound["generic"]["air_support_offline"] 											= "vox_hue1_s03_488A_usc3_f"; //Xray - Air support is offline while we evacuate the wounded.
	level.scr_sound["generic"]["copy_that"]  																= "vox_hue1_s03_489A_wood"; //Copy that.
	level.scr_sound["generic"]["theres_our_ride"]  													= "vox_hue1_s03_490A_wood"; //There's our ride.
	level.scr_sound["generic"]["not_so_sure"]  															= "vox_hue1_s03_491A_maso"; //I'm not so sure...
	level.scr_sound["generic"]["get_wounded_first"] 												= "vox_hue1_s03_492A_usc3_f"; //We have to get the wounded first.
	level.scr_sound["generic"]["more_birds_on_way"] 												= "vox_hue1_s03_493A_usc3_f"; //More birds are on their way - sit tight.
	level.scr_sound["generic"]["american_soldiers"] 												= "vox_hue1_s03_494A_nva3"; //American soldiers! Your aggression towards the People's Republic of Vietnam will not un punished.
	level.scr_sound["generic"]["we_gotta_wait"] 														= "vox_hue1_s03_495A_wood"; //Looks like we goota wit - Everyone load up - I want this LZ secure!
	level.scr_sound["generic"]["mason_set_up_charges"]  										= "vox_hue1_s03_496A_wood"; //Mason - set up charges around the perimeter!
	level.scr_sound["generic"]["returning_to_your_own_country"] 						= "vox_hue1_s03_497A_nva3"; //Instead of returning to your own country - you will die in ours.
	level.scr_sound["generic"]["loudspeaker_squak1"] 												= "vox_hue1_s03_498A_nva3"; //(Translated) Soldiers of the Republic of Vietnam - Today we must seize the chance to repel our American aggressors.
	level.scr_sound["generic"]["loudspeaker_squak2"] 												= "vox_hue1_s03_499A_nvac"; //(Translated) For the Party!!
	level.scr_sound["generic"]["here_they_come"]  													= "vox_hue1_s03_500A_wood"; //Here they come!

	level.scr_sound["generic"]["loudspeaker_squak3"]  											= "vox_hue1_s03_517A_nva3"; //(Translated) Today the People's Republic of Vietnam has shown their strength!
	level.scr_sound["generic"]["loudspeaker_squak4"]  											= "vox_hue1_s03_518A_nva3"; //(Translated) The Americans endure a crushing defeat at our hands... This city is ours!
	level.scr_sound["generic"]["loudspeaker_squak5"]  											= "vox_hue1_s03_519A_nva3"; //(Translated) Kill all Americans!!!
	level.scr_sound["generic"]["loudspeaker_squak6"]  											= "vox_hue1_s03_520A_nva3"; //(Translated) Chaaarge!!!
	level.scr_sound["generic"]["loudspeaker_squak7"]  											= "vox_hue1_s03_521A_nvac"; //(Translated) Chaaarge!!!

	level.scr_sound["generic"]["grab_scoped_rifle"]  											  = "vox_hue1_s03_546A_bowm"; //Mason, grab that scoped commando and take out those spotters!
	level.scr_sound["generic"]["need_take_out_spotters"]  									= "vox_hue1_s03_547A_bowm"; //You need to take out the spotters!
	
	level.scr_sound["generic"]["maintain_fire"]  													  = "vox_hue1_s03_501A_wood"; //Maintain fire!
	level.scr_sound["generic"]["hold_them_back"]   													= "vox_hue1_s03_503A_wood"; //Hold them back!
	level.scr_sound["generic"]["they_closing_in"]   												= "vox_hue1_s03_504A_wood"; //They're closing in!
	level.scr_sound["generic"]["from_northeast"]   													= "vox_hue1_s03_507A_wood"; //From the North East!
	level.scr_sound["generic"]["to_east"]   																= "vox_hue1_s03_508A_wood"; //To the East!
	level.scr_sound["generic"]["from_southeast"]   													= "vox_hue1_s03_509A_wood"; //From the South East!
	level.scr_sound["generic"]["coming_from_south"]  												= "vox_hue1_s03_510A_wood"; //Coming in from the South!
	level.scr_sound["generic"]["eyes_southwest"]   													= "vox_hue1_s03_511A_wood"; //Eyes South West!
	level.scr_sound["generic"]["they_retreating"]  												  = "vox_hue1_s03_515A_bowm"; //They're retreating!
	level.scr_sound["generic"]["not_retreating_regroup"] 										= "vox_hue1_s03_516A_rezn"; //They're not retreating - They are regrouping!
	level.scr_sound["generic"]["they_all_around"]   												= "vox_hue1_s03_505A_bowm"; //They're all around!
	level.scr_sound["generic"]["bastards_wont_quit"]   											= "vox_hue1_s03_506A_wood"; //These bastards won't quit!
	level.scr_sound["generic"]["on_the_rooftop"]  													= "vox_hue1_s03_502A_wood"; //On the rooftop!
	level.scr_sound["generic"]["artillery!"]  													 		= "vox_hue1_s03_512A_wood"; //Artillery!!!
	level.scr_sound["generic"]["take_out_spotters"]   											= "vox_hue1_s03_513A_wood"; //Mason! Take out the spotters!
	level.scr_sound["generic"]["there_on_roof"]  													  = "vox_hue1_s03_514A_rezn"; //There! On the roof!

  level.scr_sound["generic"]["pbr_minute_away"]   												= "vox_hue1_s99_802A_usc4_f"; //X-Ray, our PBR is a minute out from your position. Hold tight
  level.scr_sound["generic"]["evac_on_way"]   													 	= "vox_hue1_s99_803A_usc4_f"; //X-Ray, your EVAC is on it's way.
  level.scr_sound["generic"]["eta_2_min"]   													 		= "vox_hue1_s99_804A_usc4_f"; //ETA: 2 minutes
  level.scr_sound["generic"]["eta_1_min"]  													 		 	= "vox_hue1_s99_805A_usc4_f"; //ETA: 1 minute

	level.scr_sound["generic"]["command_this_is_sog"]  											= "vox_hue1_s03_522A_wood"; //Command! - This is SOG Xray one zero!
	level.scr_sound["generic"]["praririe_fire"]  														= "vox_hue1_s03_523A_wood"; //We got a prairie fire down here - Where's our goddamn evac?!!
	level.scr_sound["generic"]["citys_falling"]  														= "vox_hue1_s03_524A_comm_f"; //This city's falling to the NVA - They're picking our birds right out of the sky. You're not the only ones trying to get out!
	level.scr_sound["generic"]["priority_one"]  														= "vox_hue1_s03_525A_wood"; //We have a priority one package to extract - We need that evac!
	level.scr_sound["generic"]["find_another_way"]  												= "vox_hue1_s03_526A_comm_f"; //We'll find another way - hold your position.
	level.scr_sound["generic"]["trying_to_wrangle"]  												= "vox_hue1_s03_527A_comm_f"; //Xray - We're trying to wrangle you a Navy boat, but it's going to take some time. Hold your position.
	level.scr_sound["generic"]["stay_on_it"]  															= "vox_hue1_s03_528A_wood"; //Stay on it!
	level.scr_sound["generic"]["pbr_on_way"]  															= "vox_hue1_s03_529A_comm_f"; //Xray - Check your six. We have a Navy PBR on its way.
	level.scr_sound["generic"]["copy_that_amen"]  													= "vox_hue1_s03_530A_wood"; //Copy that! Amen, brother.
	level.scr_sound["generic"]["direct_fire_support"]  											= "vox_hue1_s03_531A_comm_f"; //Direct fire support to cover arrival. Delta squadron is on station.
	level.scr_sound["generic"]["got_it_xray_out"] 													= "vox_hue1_s03_532A_wood"; //Got it. Xray out.
	level.scr_sound["generic"]["mason_mark_target"] 												= "vox_hue1_s03_533A_wood"; //Mason! - Mark that target!
	level.scr_sound["generic"]["marking_coord"]  														= "vox_hue1_s03_534A_maso"; //Marking coordinates. Delta Squadron - Burn 'em up.
	level.scr_sound["generic"]["get_people_back"]  													= "vox_hue1_s03_535A_usp1_f"; //Copy Xray. Moving in. You may want to get your people back.
	level.scr_sound["generic"]["pbr_here"]  																= "vox_hue1_s03_536A_bowm"; //PBR's here!!!
	level.scr_sound["generic"]["have_incoming"] 														= "vox_hue1_s03_537A_wood"; //We have incoming - Danger close!
	level.scr_sound["generic"]["get_asses_to_boat"]  												= "vox_hue1_s03_538A_wood"; //Get your asses to the boat!
	level.scr_sound["generic"]["move_move"]  																= "vox_hue1_s03_539A_bowm"; //Move! Move!
	level.scr_sound["generic"]["go_get_to_boat"]  													= "vox_hue1_s03_540A_maso"; //Go! Get to the boat!
	level.scr_sound["generic"]["get_in"]  																	= "vox_hue1_s03_541A_wood"; //Get in!
	level.scr_sound["generic"]["so_much_for_tet"] 													= "vox_hue1_s03_542A_bowm"; //So much for the Tet cease fire.
	level.scr_sound["generic"]["dragovich"]  																= "vox_hue1_s03_544A_maso"; //Dragovich.
	//level.scr_sound["generic"]["boat_jump"] 																= "vox_hue1_s03_543A_rezn_m";
	
}

old_cut_good_lines()
{
		// say your prayers mason
	level.scr_sound["generic"]["coming_in_hot"] 														= "vox_hue1_s01_036A_bowm_f";	// Xray we are coming in hot!
	level.scr_sound["generic"]["nva_killing"]  															= "vox_hue1_s01_046A_usc2_f";	// Xray this is Lima 9. The NVA are killing every civilian in the compound. It's a slaughterhouse.
	level.scr_sound["generic"]["we_see_that"] 															= "vox_hue1_s01_047A_wood";	// Yeah we see that Lima 9. We'll help who we can. Mason, where to?
	level.scr_sound["generic"]["xray_pick_it_up"]									  		    = "vox_hue1_s02_159A_bowm_f";//Xray, Charlie's moving in on us. You might want to pick it up.
	level.scr_sound["generic"]["hold_ground"]													      = "vox_hue1_s02_160A_wood";//We're on it Bowman. Hold ground.
	level.scr_sound["generic"]["say_prayers"] ="vox_hue1_s01_011A_uss1"; // say your prayers, Mason
}

init_notetracks()
{
	addNotetrack_customFunction( "repel_hands", "detach_carabiner", ::remove_carabiner, "player_repel" );
	addNotetrack_customFunction( "repel_hands", "break_window_player", ::player_break_window, "player_repel" );
	addNotetrack_customFunction( "repel_hands", "attach_rope", ::play_other_ropeanim, "player_repel" );
	addNotetrack_customFunction( "repel_hands", "detach_rope", ::stop_other_ropeanim, "player_repel" );
	//addNotetrack_customFunction( "macv_repel_nva_1", "start_ragdoll", ::death_ragdoll, "single_anim" );
	//addNotetrack_customFunction( "macv_repel_nva_2", "start_ragdoll", ::death_ragdoll, "single_anim" );
	//addNotetrack_customFunction( "macv_repel_nva_3", "start_ragdoll", ::death_ragdoll, "single_anim" );
	addNotetrack_customFunction( "woods", "sndnt#vox_Qua1_083A_BARN", ::player_VO_response, "repel" );
	//addNotetrack_customFunction( "repel_redshirt", "start_ragdoll", ::death_ragdoll, "repel" );
	addNotetrack_customFunction( "woods", "break_window_barnes", ::notify_to_player, "repel" );
	addNotetrack_customFunction( "woods", "gun_position", ::get_repelgun_position, "repel" );

	addNotetrack_customFunction( "woods", "fire", ::notify_dead_guy_death, "door_breach" );
	addNotetrack_customFunction( "repel_hands", "civ_running", maps\hue_city_event1::event1_trigger_hallway_civs, "player_repel" );
	addNotetrack_customFunction( "rope", "start_rappel",maps\hue_city_event1::event1_repel_troop_ready, "troop_A" );
	addNotetrack_customFunction( "grenade_throw", "fire", maps\hue_city_event1::event1_grenade_throw, "stand_throw" );	
	addNotetrack_customFunction( "grenade_throw", "fire", maps\hue_city_event1::event1_grenade_throw, "crouch_throw" );

	addNotetrack_customFunction( "bowman", "fire", ::repel_fire, "repel_in" );
	addNotetrack_customFunction( "troop1", "fire", ::repel_fire, "repel_in" );



	//addNotetrack_customFunction( "playboy_hands", "fade_out", 	::playboy_fade_out, "playboy_blowthrough" );
	//addNotetrack_customFunction( "playboy_hands", "fade_in", 	::playboy_fade_in, 	"playboy_blowthrough" );
		
	//addNotetrack_customFunction( "crosby", "start_redshirt_anim",::crosbys_poor_friend, "crosby_intro" );
	addNotetrack_customFunction( "redshirt", "ragdoll",::killredshirt, "owned_on_perch" );
	addNotetrack_customFunction( "redshirt", "blood impact",::shootredshirt, "owned_on_perch" );
	addNotetrack_customFunction( "crosby", "player_vo2",::player_vo2, "crosby_question" );
	addNotetrack_customFunction( "woods", "explosion", ::explosion_flag, "playboy_explosion" );
	addNotetrack_customFunction( "playboy_hands", "explosion", ::reznov_reveal_explosion, "reznov_reveal" );

	addNotetrack_detach( "playboy_hands", "detach", "weapon_c4", "tag_weapon", "plant_c4" );
	

}

#using_animtree("player");
init_player_anims()
{


	level.scr_animtree["repel_hands"] 														= #animtree;
	level.scr_model["repel_hands"] 																= "t5_gfl_ump45_viewbody";

	level.scr_anim["repel_hands"]["player_repel"] 								= %int_quag_b05_repeltomacv_player;		// repel animation of the player, ends in macv

	level.scr_animtree["playboy_hands"] 													= #animtree;
	level.scr_model["playboy_hands"] 															= "t5_gfl_ump45_viewbody";
	level.scr_anim["playboy_hands"]["playboy_blowthrough"]								 = %ch_hue_b02_tankblast_player_explosion;
	level.scr_anim["playboy_hands"]["playboy_ohshit"] 						= %ch_hue_b02_tankblast_player_ohshit;
	level.scr_anim["playboy_hands"]["jumpto_boat"]								=	%ch_hue_b02_jumponboat_player;
	level.scr_anim["playboy_hands"]["reznov_reveal"]								=	%ch_hue_b01_reznov_reveal_player;
	addNotetrack_customFunction( "playboy_hands", "tackle", ::player_tackled, "reznov_reveal" );

	
	level.scr_animtree["crosby_scene_hands"] 											= #animtree;
	level.scr_model["crosby_scene_hands"]													= "t5_gfl_ump45_viewbody";
	level.scr_anim["crosby_scene_hands"]["player_take_radio"]			= %ch_hue_b02_commandeerradio_a_player; // Player run's up to Crosby and delivers his lines, grabs the radio and brings it offscreen then ends his animation) 

	level.scr_animtree["c4_pant_hands"]														= #animtree;
	level.scr_model["c4_pant_hands"] 															= "t5_gfl_ump45_viewmodel_player";
	level.scr_anim["c4_pant_hands"]["plant_c4"] 									= %int_huecity_aa_building_c4_plant; // Player run's up to Crosby and delivers his lines, grabs the radio and brings it offscreen then ends his animation) 
}

player_tackled(guy)
{
	player = get_players()[0];
	Earthquake( .15, .15, player.origin, 500 ); 
	player PlayRumbleOnEntity("damage_heavy");
	level notify( "shell shock player", .75);
	maps\_shellshock::main( player.origin, .75);
}

shootredshirt(guy)
{
	spot = getstruct("chopperstrike_spot1_lookatspot", "targetname").origin;
	dest = guy.origin+(0,0,50);
	PlayFX(level._effect["heli_mowdown_multihit"], dest );
	vec = dest - spot;
	nvec = VectorNormalize(vec);
	dest = dest + (nvec*200); // extend vector so bullets go through guy
	ofs = 2;
	for (i=0; i < 4; i++)
	{
		MagicBullet("ak47_sp", spot, dest+random_offset(ofs,ofs,ofs) );
		BulletTracer( spot, dest+random_offset(ofs,ofs,ofs),1 );	
		wait 0.05;
	}
}

killredshirt(guy)
{	
	guy stop_magic_bullet_shield();
	guy SetCanDamage(true);
	guy.a.disablepain = false;
	
	guy ragdoll_death();
}

player_vo2(guy)
{
	get_players()[0] line_please("authorization_operation");
	flag_set("authorization_operation_said");
}

explosion_flag(guy)
{
	flag_set("alley_car_explosion");
	level notify ("playboy_tank_fire");
	//get_players()[0] PlayRumbleOnEntity("barrel_explosion");
}

#using_animtree("animated_props");
init_prop_anims()
{

		// morse code guy and his chair
	level.scr_anim["chair"]["chair_react"] 			 = %o_quag_b05_moris_code_chair;	

	// ropes in repel sequence
	level.scr_animtree["repel_rope"] 	        	 = #animtree;
	level.scr_model["repel_rope"]		 		   								  = "anim_jun_rappel_rope";

	level.scr_anim["rope"]["bowman_A"]										  = %o_hue_b02_rope_bowman_A;
	level.scr_anim["rope"]["bowman_B"] 										  = %o_hue_b02_rope_bowman_B;
	
	level.scr_anim["rope"]["troop_A"] 									 	  = %o_hue_b02_rope_troop1_A;
	level.scr_anim["rope"]["troop_B"] 										  = %o_hue_b02_rope_troop1_B;
	
	level.scr_anim["chair"]["brutalization_scene"]					=	%ch_hue_b02_killingcivilians1_chair;
	level.scr_anim["chair"]["brutalization_scene_loop"][0]	=	%ch_hue_b02_killingcivilians1_chair_idle;

	level.scr_anim["t55"]["playboy_blowthrough"]						=	%v_hue_b02_tankblast_tank;
	
	level.scr_animtree["dossier"] 	        							 = #animtree;
	level.scr_anim["dossier"]["reznov_reveal"]					=	%o_hue_b01_reznov_reveal_dossier;
	
	level.scr_animtree["spas"] = #animtree;
	level.scr_model["spas"] = "t5_weapon_spas_world";
	level.scr_anim["spas"]["single_anim"] = %p_quag_b05_repeltomacv_gun;
}

#using_animtree("vehicles");
init_vehicle_anims()
{
	level.scr_animtree["spirit"] = #animtree;
	level.scr_anim["spirit"]["spirit_shotdown"]					 = %v_quag_b05_repeltomacv_huey;
	
	level.scr_animtree["boat"] = #animtree;
	level.scr_anim["boat"]["jumpto_boat"]							 = %v_hue_b02_jumponboat_boat;
	
}

#using_animtree("generic_human");
init_macv_ai_anims()
{
	// chopper mowdown animations for shoot loop and death
	level.scr_anim["chopper_mowdown_NVA1"]["shoot_loop"][0] 				= %ch_hue_b01_choppermowdown_loop_nva1;
	level.scr_anim["chopper_mowdown_NVA1"]["special_death"]     			= %ch_hue_b01_choppermowdown_death_noragdoll_nva1;

	level.scr_anim["chopper_mowdown_NVA2"]["shoot_loop"][0]					= %ch_hue_b01_choppermowdown_loop_nva2;
	level.scr_anim["chopper_mowdown_NVA2"]["special_death"]					= %ch_hue_b01_choppermowdown_death_ragdoll_nva2;

	level.scr_anim["chopper_mowdown_NVA3"]["shoot_loop"][0]					= %ch_hue_b01_choppermowdown_loop_nva3;
	level.scr_anim["chopper_mowdown_NVA3"]["special_death"]					= %ch_hue_b01_choppermowdown_death_ragdoll_nva3;

	level.scr_anim["chopper_mowdown_NVA4"]["shoot_loop"][0]					= %ch_hue_b01_choppermowdown_loop_nva4;
	level.scr_anim["chopper_mowdown_NVA4"]["special_death"]					= %ch_hue_b01_choppermowdown_death_ragdoll_nva4;

	// first two civilians after repel sequence
	level.scr_anim["hallway_civ1"]["hallway_civ_run"] 						= %ch_hue_b01_1sthallwaymowdown_civ1;
	level.scr_anim["hallway_civ2"]["hallway_civ_run"] 						= %ch_hue_b01_1sthallwaymowdown_civ2;

	// civilan in the main hallway cowering on the side
	level.scr_anim["hallway_civ_cower"]["hallway_civ_cower"]				= %ch_quag_b05_civscowering4_civ2;
	level.scr_anim["hallway_civ_cower"]["hallway_civ_cower_death"]			= %ch_quag_b05_civscowering4_civ2_death;
	level.scr_anim["hallway_civ_left_cower"]["hallway_civ_left_cower"]				= %ch_quag_b05_civscowering3_civ2;

	// civilians after the skydemon sequence
	level.scr_anim["macv_civ_corner_surprise_2"]["cower_come_in"] 			= %ch_hue_b05_civsaroundcornersurprisedleft_civ2;
	level.scr_anim["macv_civ_corner_surprise_2"]["cower_loop"][0] 			= %ch_hue_b05_civsaroundcornersurprisedleft_civ2_cowerloop;
	
	// SUMEET - THIS GUY IS DELETED
	//level.scr_anim["macv_civ_cower_1"]["single_anim"] 						= %ch_quag_b05_civscowering1_civ1;

			// civilians in mowdown room before mowdown
	level.scr_anim["pre_civ_mowdown_civ1"]["cower"] 			= %ch_quag_b05_civsaroundcornersurprisedleft2_civ1; //  // the run and fall down
	level.scr_anim["pre_civ_mowdown_civ2"]["cower"] 			= %ch_quag_b05_civscowerincorner1_civ2; //� sitting down backing up
	level.scr_anim["pre_civ_mowdown_civ3"]["cower"] 			= %ch_quag_b05_civscowerincorner2_civ2; // � standing up backing up


	// Beatdown in the passage - civilian
	level.scr_anim["passage_beatdown"]["macv_civ_beatdown_alert"]   		= %ch_quag_b05_beatenup_civ_alert;
	level.scr_anim["passage_beatdown"]["macv_civ_beatdown_idle"][0] 		= %ch_quag_b05_beatenup_civ_idle;
	level.scr_anim["passage_beatdown"]["macv_civ_beatdown_loop"][0] 		= %ch_quag_b05_beatenup_civ_loop;

	// Beatdown in the passage - nva
	level.scr_anim["passage_beatdown"]["macv_nav_beatdown_loop"][0] 		= %ch_quag_b05_beatenup_nva_loop;
	level.scr_anim["passage_beatdown"]["macv_nav_beatdown_alert"]   		= %ch_quag_b05_beatenup_nva_alert;
	
	// set ups an array of death animation for skydemon ai's
	level.scr_anim["special_death"][ "0" ]  = %death_explosion_stand_B_v1;
	level.scr_anim["special_death"][ "1" ]  = %death_explosion_stand_B_v3;
	level.scr_anim["special_death"][ "2" ]  = %death_explosion_stand_B_v4;
	
	// civilian mowdown NVA's
	level.scr_anim["macv_chasing_nva_mowdown1"]["macv_chasing_nva_mowdown"] = %ch_quag_b05_nvachasingafterncivs_nva1;
	level.scr_anim["macv_chasing_nva_mowdown2"]["macv_chasing_nva_mowdown"] = %ch_quag_b05_nvachasingafterncivs_nva2;

	
	// guys repeling in after skydemon
	level.scr_anim["bowman"]["repel_in"] 	 = %ch_hue_b01_repelthroughceiling_bowman;
	level.scr_anim["troop1"]["repel_in"] 	 = %ch_hue_b01_repelthroughceiling_troop1;
	level.scr_anim["repel_nva1"]["repel_in"] = %ch_hue_b01_repelthroughceiling_nva1;
	level.scr_anim["repel_nva2"]["repel_in"] = %ch_hue_b01_repelthroughceiling_nva2;
	
	// civilan mowdown
	level.scr_anim["crawling_civilian"]["macv_fleeing_civ_mowdown"] 		= %ch_quag_b05_nvachasingafterncivs_civ6;
	level.scr_anim["macv_fleeing_civ_mowdown1"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ2;
	level.scr_anim["macv_fleeing_civ_mowdown2"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ3;
	level.scr_anim["macv_fleeing_civ_mowdown3"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ4;
	level.scr_anim["macv_fleeing_civ_mowdown4"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ5;
	level.scr_anim["macv_fleeing_civ_mowdown5"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ1;
	level.scr_anim["macv_fleeing_civ_mowdown6"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ7;
	level.scr_anim["macv_fleeing_civ_mowdown7"]["macv_fleeing_civ_mowdown"] = %ch_quag_b05_nvachasingafterncivs_civ8;

	// NVA in stairs area tumbling down 
	level.scr_anim["stair_nva"]["tumble_back_death"] 						= %ch_hue_b01_stairtumbledeath_nva_back;

	// NVA in stairs in war room 
	level.scr_anim["stair_nva"]["tumble_front_death"] 						= %ch_hue_b01_stairtumbledeath_nva_front;


	// staircase scene for the civilians and NVA
	level.scr_anim["stair_mowdown_NVA1"]["stair_mowdown"]					= %ch_hue_b01_runningawaystairs_nva;
	level.scr_anim["stair_mowdown_NVA2"]["stair_mowdown"]					= %ch_hue_b01_runningawaystairs_nva2;
	level.scr_anim["stair_mowdown_CIV1"]["stair_mowdown"]					= %ch_hue_b01_runningawaystairs_civ1;
	level.scr_anim["stair_mowdown_CIV2"]["stair_mowdown"]					= %ch_hue_b01_runningawaystairs_civ2;				
	level.scr_anim["stair_mowdown_CIV3"]["stair_mowdown"]					= %ch_hue_b01_runningawaystairs_civ3;				

	// grenade thrower
	level.scr_anim["grenade_throw"]["stand_throw"]							= %stand_grenade_throw;
	
	level.scr_anim["grenade_throw"]["crouch_throw"]						    = %crouch_grenade_throw;

	// morse code guy
	level.scr_anim["rdoorbreach_deskguy3"]["guy3_react"] 					= %ch_quag_b05_moris_code_reaction;
}

#using_animtree("generic_human");
init_ai_anims()
{
	
	level.scr_anim["macv_civ_corner_surprise_1"]["civilian_run"] = %ai_civ_gen_run_01;
	

		// CHopper anims to be scripted	
	level.scr_anim["hueyspot0"]["idle"][0] = %ai_huey_pilot1_idle_loop1;
	level.scr_anim["hueyspot1"]["idle"][0]	= %ai_huey_pilot2_idle_loop1;	
	level.scr_anim["hueyspot2"]["idle"][0]	= %ai_huey_passenger_b_rt;	
	level.scr_anim["hueyspot3"]["idle"][0]	= %ai_huey_passenger_f_rt;	
	level.scr_anim["hueyspot4"]["idle"][0]	= %ai_huey_passenger_b_lt;	
	level.scr_anim["hueyspot5"]["idle"][0]	= %ai_huey_passenger_b_rt;	
	
	
		// BEAT 1  - MACV
	
	level.scr_anim["macv_repel_nva_1"]["single_anim"] = %ch_quag_b05_repeltomacv_nva1;
	level.scr_anim["macv_repel_nva_2"]["single_anim"] = %ch_quag_b05_repeltomacv_nva2;
	level.scr_anim["macv_repel_nva_3"]["single_anim"] = %ch_quag_b05_repeltomacv_nva3;

	level thread addNotetrack_customFunction("macv_repel_nva_1", "blood_impact", ::blood_impact, "single_anim");
	level thread addNotetrack_customFunction("macv_repel_nva_2", "blood_impact", ::blood_impact, "single_anim");
	level thread addNotetrack_customFunction("macv_repel_nva_3", "blood_impact", ::blood_impact, "single_anim");
	level thread addNotetrack_customFunction("macv_repel_nva_1", "switch_weapon", ::show_fake_spas, "single_anim" );
	
		// Repel Sequence
	level.scr_anim["woods"]["repel"] = %ch_quag_b05_repeltomacv_barnes;
	level.scr_anim["fake_player"]["repel"] = %ch_quag_b05_repeltomacv_player;
	level.scr_anim["repel_redshirt"]["repel"] = %ch_quag_b05_repeltomacv_soldier;
	
	level.scr_anim["fardude"]["repel"] = %ch_quag_b05_sldrrepel_sldr;

		// doorbreach surprise - currently these are commented out of csv, put in when determine whether to use em
	level.scr_anim["dead_guy1"]["door_breach"] 		= %ch_quag_b06_doorbreach_dead_guy_1;
	level.scr_anim["dead_guy2"]["door_breach"] 		= %ch_quag_b06_doorbreach_dead_guy_2;

	level.scr_anim["woods"]["door_breach"] 							= %ch_quag_b06_doorbreach_guy1;
	level.scr_anim["bowman"]["door_breach"] 						= %ch_quag_b06_doorbreach_guy2;

	level.scr_anim["woods"]["reznov_hallway_breach"] 					= %ch_hue_b01_reznov_hallway_breach;
	level.scr_anim["woods"]["reznov_hallway_breach_idle"][0] 	= %ch_hue_b01_reznov_hallway_breach_idle;

	level.scr_anim["nva"]["reznov_reveal"] 		= %ch_hue_b01_reznov_reveal_nva;
	level thread addNotetrack_customFunction("nva","blood_squirt",::blood_squirt,"reznov_reveal");
	
	level.scr_anim["reznov"]["reznov_reveal"] 	= %ch_hue_b01_reznov_reveal_reznov;
	level.scr_anim["deadguy"]["reznov_reveal"] = %ch_hue_b01_reznov_reveal_deadguy;
	//level.scr_sound["reznov"]["reznov_reveal"] = "vox_hue1_s01_439A_maso_m";
	
	
			// Beat 2 - MACV TRANSITION
			
	level.scr_anim["generic"]["patrolwalk"] 		= %patrol_bored_patrolwalk;

			// BEAT 3 - DEFEND
			
		
	level.scr_anim["mortarguy1"]["mortarguy_loop"][0] = %ch_hue_b02_mortar_spotters_a;
	level.scr_anim["mortarguy2"]["mortarguy_loop"][0] = %ch_hue_b02_mortar_spotters_b;
	level.scr_anim["mortarguy3"]["mortarguy_loop"][0] = %ch_hue_b02_mortar_spotters_c;
	

	level.scr_anim["hates_helicopters_guy1"]["hate_on_helis"] = %ch_hue_b02_nva_shoot_at_heli_a;
	level.scr_anim["hates_helicopters_guy2"]["hate_on_helis"] = %ch_hue_b02_nva_shoot_at_heli_a;

	
	level.scr_anim["radioguy"]["radio_reach"]	  = %ai_spawning_radio_crouched;
	level.scr_anim["radioguy"]["radio_loop"][0] = %ai_spawning_radio_crouched;
	
	
			// crosby radio scene
	level.scr_anim["crosby"]["crosby_intro_loop"][0]													=	%ch_hue_b02_commandeerradio_idle1_crosby; //( Looping animation of Crosby before Mason's arrival)
	level.scr_anim["crosby"]["crosby_intro"]																	=	%ch_hue_b02_commandeerradio_a_crosby; //( Crosby's delivers his lines)
	level.scr_anim["crosby"]["crosby_post_intro_loop"][0]											=	%ch_hue_b02_commandeerradio_idle2_crosby; //( Looping animation of Crosby without the radio after he delivers his lines)
	level.scr_anim["crosby"]["crosby_question"]																=	%ch_hue_b02_commandeerradio_b_crosby; //( Crosby's delivers his lines)
	level.scr_anim["crosby"]["crosby_hand_radio_loop"][0]											=	%ch_hue_b02_commandeerradio_idle3_crosby; //( Looping animation of Crosby without the radio after he delivers his lines)
	level.scr_anim["crosby"]["crosby_give_radio"]															=	%ch_hue_b02_commandeerradio_c_crosby; //( Crosby's delivers his lines)
	level.scr_anim["crosby"]["crosby_outro_loop"][0]													=	%ch_hue_b02_commandeerradio_idle4_crosby; //( Looping animation of Crosby without the radio after he delivers his lines)
	level.scr_anim["redshirt"]["owned_on_perch"]															=	%ch_hue_b02_commandeerradio_a_redshirt; //( Looping animation of Crosby without the radio after he delivers his lines)


			// open alley_gate scene - Currently temp
	level.scr_anim["woods"]["gate_breach"] 		= %ch_quag_b06_doorbreach_guy1;


			// playboy scene
	level.scr_anim["woods"]["playboy_prescene_idle"][0]													=	%ch_hue_b02_tankblast_woods_idle1;
	level.scr_anim["woods"]["playboy_push_loop"][0]															=	%ch_hue_b02_tankblast_woods_pushloop;
	level.scr_anim["woods"]["playboy_push_loop_reach"]													=	%ch_hue_b02_tankblast_woods_pushloop;
	level.scr_anim["woods"]["playboy_into_position"]														=	%ch_hue_b02_tankblast_woods_intoposition;
	level.scr_anim["woods"]["playboy_helpme_mason"]														=	%ch_hue_b02_tankblast_woods_helpmemason;
	level.scr_anim["woods"]["playboy_explosion"]														=	%ch_hue_b02_tankblast_woods_explosion;
	level.scr_anim["woods"]["playboy_ohshit"]														=	%ch_hue_b02_tankblast_woods_ohshit;

	level.scr_anim["playboy_redshirt1"]["playboy_prescene_idle"][0] 							 	=	%ch_hue_b02_tankblast_redshirt1_idle1;
	level.scr_anim["playboy_redshirt1"]["playboy_cover_idle"][0] 							 	=	%ch_hue_b02_tankblast_redshirt1_coveridle;
	level.scr_anim["playboy_redshirt1"]["playboy_cover_idle_reach"] 							 	=	%ch_hue_b02_tankblast_redshirt1_coveridle;
	level.scr_anim["playboy_redshirt1"]["playboy_into_position"] 							 	=	%ch_hue_b02_tankblast_redshirt1_intoposition;
	level.scr_anim["playboy_redshirt1"]["playboy_explosion"] 							 	=	%ch_hue_b02_tankblast_redshirt1_explosion;
	level.scr_anim["playboy_redshirt1"]["playboy_ohshit"] 							 	=	%ch_hue_b02_tankblast_redshirt1_ohshit;

	level.scr_anim["playboy_redshirt2"]["playboy_prescene_idle"][0] 							 	=	%ch_hue_b02_tankblast_redshirt2_idle1;
	level.scr_anim["playboy_redshirt2"]["playboy_cover_idle"][0] 							 	=	%ch_hue_b02_tankblast_redshirt2_coveridle;
	level.scr_anim["playboy_redshirt2"]["playboy_cover_idle_reach"] 							 	=	%ch_hue_b02_tankblast_redshirt2_coveridle;
	level.scr_anim["playboy_redshirt2"]["playboy_into_position"] 							 	=	%ch_hue_b02_tankblast_redshirt2_intoposition;
	level.scr_anim["playboy_redshirt2"]["playboy_death"] 							 	=	%ch_hue_b02_tankblast_redshirt2_death;
	level.scr_anim["playboy_redshirt2"]["playboy_ohshit"] 							 	=	%ch_hue_b02_tankblast_redshirt1_ohshit;


		// streets intro scene
	level.scr_anim["street_intro_redshirts"]["injured_idle1"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop1; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_idle2"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop2; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_idle3"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop3; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_idle4"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop4; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_intro5"]										=	%ch_hue_b02_badlyinjuredtroops_troop5; //( get into position and goes to the idle anim)
	level.scr_anim["street_intro_redshirts"]["injured_idle5"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop5_idle; //( Looping )
	level.scr_anim["street_intro_redshirts"]["medic_idle1"][0]										=	%ch_hue_b02_badlyinjuredtroops_medic1; //( Looping )
	level.scr_anim["street_intro_redshirts"]["medic_idle2"][0]										=	%ch_hue_b02_badlyinjuredtroops_medic2; //( Looping )
	level.scr_anim["street_intro_redshirts"]["medic_intro3"]											=	%ch_hue_b02_badlyinjuredtroops_medic3; //( get into position and goes to the idle anim)
	level.scr_anim["street_intro_redshirts"]["medic_idle3"][0]										=	%ch_hue_b02_badlyinjuredtroops_medic3_idle; //( Looping ) 
	level.scr_anim["street_intro_redshirts"]["medic_intro4"]											=	%ch_hue_b02_badlyinjuredtroops_medic4; //( Looping )
	level.scr_anim["street_intro_redshirts"]["medic_idle4"][0]										=	%ch_hue_b02_badlyinjuredtroops_medic4_idle; //( get into position and goes to the idle anim)

	level.scr_anim["street_intro_redshirts"]["injured_intro7"]								  	=	%ch_hue_b02_badlyinjuredtroops_troop7; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_idle7"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop7_idle; //( get into position and goes to the idle anim)
	level.scr_anim["street_intro_redshirts"]["injured_idle8"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop8; //( Looping )
	level.scr_anim["street_intro_redshirts"]["injured_idle9"][0]									=	%ch_hue_b02_badlyinjuredtroops_troop9; //( get into position and goes to the idle anim)

			// brutalized scene

	level.scr_anim["civilian"]["brutalization_scene"]															=	%ch_hue_b02_killingcivilians1_civ1;
	level.scr_anim["civilian"]["brutalization_scene_loop"][0]											=	%ch_hue_b02_killingcivilians1_civ1_idle;

	level.scr_anim["nva"]["brutalization_scene"]																	=	%ch_hue_b02_killingcivilians1_nva1;
	level.scr_anim["nva"]["brutalization_scene_loop"][0]													=	%ch_hue_b02_killingcivilians1_nva1_idle;

			// alley mourn sequence
	level.scr_anim["civilian"]["mourndead1"][0]																	=	%ch_hue_b02_mourndead_civ1;
	level.scr_anim["civilian"]["mourndead2"][0]																 	=	%ch_hue_b02_mourndead_civ2;

			// civ executions
	level.scr_anim["nva"]["executioner_1"]																			=	%ch_hue_b02_killingcivilians2_nva1;
	level.scr_anim["nva"]["executioner_2"]																			=	%ch_hue_b02_killingcivilians2_nva2;
	level.scr_anim["civilian"]["executed_1"]																		=	%ch_hue_b02_killingcivilians2_civ1;
	level.scr_anim["civilian"]["executed_2"]																		=	%ch_hue_b02_killingcivilians2_civ2;
	level.scr_anim["civilian"]["executed_3"]																		=	%ch_hue_b02_killingcivilians2_civ3;
	level.scr_anim["civilian"]["executed_4"]																		=	%ch_hue_b02_killingcivilians2_civ4;

	level.scr_anim["redshirt"]["tankcrush1"]																		=	%ch_hue_b02_crushedbytank_nva1;
	level.scr_anim["redshirt"]["tankcrush2"]																		=	%ch_hue_b02_crushedbytank_nva2;
	
					// EVENT 3 - DEFEND
		
		// wounded onto chopper
		
	level.scr_anim["redshirt1"]["wounded_b"]																		=	%ch_hue_b02_loading_wounded_b_troop1;
	level.scr_anim["redshirt2"]["wounded_b"]																		=	%ch_hue_b02_loading_wounded_b_troop2;
	level.scr_anim["redshirt3"]["wounded_b"]																		=	%ch_hue_b02_loading_wounded_b_troop3;
	level.scr_anim["redshirt1"]["idle1"][0]																			=	%ch_hue_b02_loading_wounded_idle1_troop1;
	level.scr_anim["redshirt2"]["idle1"][0]																			=	%ch_hue_b02_loading_wounded_idle1_troop2;
	level.scr_anim["redshirt3"]["idle1"][0]																			=	%ch_hue_b02_loading_wounded_idle1_troop3;
	level.scr_anim["redshirt1"]["idle2"][0]																			=	%ch_hue_b02_loading_wounded_idle2_troop1;
	level.scr_anim["redshirt2"]["idle2"][0]																			=	%ch_hue_b02_loading_wounded_idle2_troop2;
	level.scr_anim["redshirt3"]["idle2"][0]																			=	%ch_hue_b02_loading_wounded_idle2_troop3;

		// jumpto boat anims	
	level.scr_anim["pbr_driver"]["drive"][0]																		=	%ai_m113_gunner_aim;
	level.scr_anim["bowman"]["jumpto_boat"]																			=	%ch_hue_b02_jumponboat_bowman;
	level.scr_anim["reznov"]["jumpto_boat"]																			=	%ch_hue_b02_jumponboat_reznov;
	level.scr_anim["woods"]["jumpto_boat"]																			=	%ch_hue_b02_jumponboat_woods;
	//level.scr_sound["reznov"]["jumpto_boat"] 																		= "vox_hue1_s03_543A_rezn_m"; //The enemy's courage could be the result of their new found ally...
	

}


say_dialogue( theLine ) // self = entity talking
{  
	// check if the guy is alive to say the dialogue. Avoids a script error in the hut execution sequence.
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self anim_generic( self, theLine );
	}
}


crosby_scene()
{
	level endon ("get_chopper_now");
	level endon ("alleyskipto_start");
	
	flag_wait("event2_start_go");
	crosby = GetEnt("crosby", "targetname") StalingradSpawn();
	level.crosby = crosby;
	align_struct = getstruct("crosby_align_spot", "targetname");
	crosby.animname = "crosby";
	crosby.ignoreall = 1;
	
	crosby.radio = spawn("script_model",crosby gettagorigin("tag_weapon_right"));
	crosby.radio.angles = crosby gettagangles("tag_weapon_right");
	crosby.radio setmodel("prop_mp_handheld_radio");
	crosby.radio linkto(crosby, "tag_weapon_right");
	weap = crosby.weapon;
	crosby animscripts\shared::placeweaponOn(crosby.weapon, "none");
	//PlayFXOnTag(level._effect["radio_light"], crosby, "prop_mp_handheld_radio_lod0");

	align_struct thread anim_loop_aligned(crosby, "crosby_intro_loop", undefined, "crosby_stoploop");
	trigger_wait("player_approaching_perch");
	
	//level.crosby LookAtEntity(get_players()[0]);

	level thread crosby_scene_interupt(align_struct, crosby, weap);
	
	align_struct notify ("crosby_stoploop");
	align_struct anim_single_aligned(crosby, "crosby_intro");

	align_struct thread anim_loop_aligned(crosby, "crosby_post_intro_loop", undefined, "crosby_stoploop");
}

crosby_scene_interupt(align_struct, crosby, weap)
{
	flag_wait("get_chopper_now");
	crosby StopSounds();

	wait 0.1;
	get_players()[0] thread line_please("give_me_radio");
	wait 0.05;	
	crosby anim_set_blend_in_time( 0.2 );
	crosby StopAnimScripted();
	align_struct notify ("crosby_stoploop");


	level thread crosby_scene_playeranim(align_struct,crosby);
	flag_set("gimmie_son");
	
	//level thread crosbys_poor_friend();
	
	align_struct anim_single_aligned(crosby, "crosby_question");

	crosby anim_set_blend_in_time( 0.0 );


	level.crosby LookAtEntity();
	
	align_struct thread anim_loop_aligned(crosby, "crosby_outro_loop", undefined, "crosby_stoploop");
	//crosby Detach ("t5_weapon_radio_viewmodel", "tag_weapon_right");
	
	while(crosby player_can_see_me( get_players()[0] ) )
	{
		wait 0.05;
	}
	
	crosby animscripts\shared::placeweaponOn(weap, "right");
	align_struct notify ("crosby_stoploop");
	crosby StopAnimScripted();
	flag_wait("apcchain1_go");
	wait 1;
	crosby.radio delete();
	//crosby Detach("prop_mp_handheld_radio", "TAG_INHAND");

	crosby SetGoalNode(GetNode("crosby_node_radio_node", "targetname") );
	crosby.ignoreall = 0;
	crosby stop_magic_bullet_shield();
	crosby thread wait_and_kill(60);
}

#using_animtree("player");
crosby_scene_playeranim(align_struct,crosby)
{
	if (IsDefined(level.player_hands))
	{
		level.player_hands Delete();
	}

	level.player_hands = spawn_anim_model( "crosby_scene_hands" );
	level.player_hands UseAnimTree(#animtree);
	level.player_hands.animname = "crosby_scene_hands";
	level.player_hands thread hide_and_show(0.35);
	
	//get_players()[0] playerlinktodelta(level.player_hands, "tag_player", 1, 10,0,10,0); 
	level.player playerlinktoAbsolute(level.player_hands, "tag_player");
	get_players()[0] thread take_and_giveback_weapons("giveback_weapons", 1);
	align_struct anim_single_aligned(level.player_hands, "player_take_radio");
	get_players()[0] Unlink();
	level.player_hands Delete();
	crosby.radio hide();

	flag_set("chopper_vignette_over");
	
	flag_wait("authorization_operation_said");
	

	
	get_players()[0] notify("giveback_weapons");
}


crosbys_poor_friend(guy)
{
//	poorguy = GetEnt("guy_animated_shot_on_perch_ai", "targetname");
//	poorguy.animname = "redshirt";
//	wait 3.5;
//	align_struct = getstruct("poorfriend_align_struct", "targetname");
//	align_struct anim_single_aligned(poorguy, "owned_on_perch");
}
	

tankcrush_scene()
{
	flag_wait("alley_tank_trig_fired");
	align_struct = getstruct("playboy_script_anim", "targetname");
	
	guys = GetEntArray("tankcrush_guys", "targetname");
	for (i=0; i < guys.size; i++)
	{
		num = i+1;
		guy = guys[i] StalingradSpawn();
		guy.animname = "redshirt";
		align_struct thread anim_single_aligned(guy, "tankcrush"+num);
	}
}

execution_scene()
{
	flag_wait("execution_scene_go");
	level.reznov disable_cqbwalk();
		
	//align_struct = getstruct("civs_killed_by_aagun_spot", "targetname");
	align_struct = getstruct("execution_align", "targetname");
	
	nva = getstructarray("nva_executioners", "targetname");
	for (i=0; i < nva.size; i++)
	{
		num = i+1;
		guy = struct_spawn(nva[i])[0];
		guy.animname = "nva";
		
		align_struct thread anim_single_aligned(guy, "executioner_"+num);
	}
	
	civs = getstructarray("civilians_executed", "targetname");
	for (i=0; i < civs.size; i++)
	{
		num = i+1;
		guy = struct_spawn(civs[i], maps\hue_city_ai_spawnfuncs::executed_civs )[0];
		guy.animname = "civilian";
		align_struct thread anim_single_aligned(guy, "executed_"+num);
		animtime = GetAnimLength(level.scr_anim["civilian"]["executed_"+num]);
		guy thread special_damage_delay("damage", animtime-1.6, 50, level.reznov  );
	}
	wait 5;
	trigger_use("getting_near_aagun");
}

special_damage_delay(mynotify, delay, param1, param2)
{
	wait delay;
	self notify (mynotify, param1, param2);
}

brutalization_scene()
{
	flag_wait("player_on_alley_balcony");
	align_struct = getstruct("brutalize_align", "targetname");
	civ = struct_spawn("civ_brutalized")[0];
	civ.animname = "civilian";
	nva = struct_spawn("nva_brutalize")[0];
	nva.animname = "nva";
	
	align_struct thread anim_loop_aligned(civ, "brutalization_scene_loop", undefined, "stoploop");
	align_struct thread anim_loop_aligned(nva, "brutalization_scene_loop", undefined, "stoploop");
	flag_wait("brutalize_scene_go");
	align_struct notify ("stoploop");
	
	align_struct thread brutalization_chair();
	align_struct thread anim_single_aligned(civ, "brutalization_scene");
	align_struct anim_single_aligned(nva, "brutalization_scene");
	
	civ killme();
}

#using_animtree("animated_props");
brutalization_chair()
{
	align_struct = getstruct("brutalize_align", "targetname");

  linker = spawn_a_model( "tag_origin_animate", align_struct.origin, align_struct.angles );
  linker.animname = "chair";
  linker UseAnimTree( #animtree );
                
   // Grab the flashlight (in this case, already placed in map)
  chair = spawn_a_model("p_glo_plainchair", linker GetTagOrigin( "origin_animate_jnt"),  linker GetTagAngles( "origin_animate_jnt" ) );
	chair LinkTo( linker, "origin_animate_jnt" );
                
		// play the anim on the linking entity
	align_struct thread anim_loop_aligned(linker, "brutalization_scene_loop", undefined, "stoploop");
	flag_wait("brutalize_scene_go");
	align_struct anim_single_aligned( linker, "brutalization_scene" );  // animation: toss

	linker Delete();
}

woods_helpme(alignstruct)
{
	if (flag("playboy_blowthrough_go"))
	{
		return;
	}
	level endon ("playboy_blowthrough_go");
	flag_wait("street_beating_zone_said");
	


	looktrig = GetEnt("woods_helpme_lookat_trig", "targetname");
	touchtrig = GetEnt("woods_helpme_touch_trig", "targetname");
	
	alignstruct notify ("stopwoodsloop");
	alignstruct anim_single_aligned(level.woods, "playboy_helpme_mason");
	alignstruct thread anim_loop_aligned(level.woods,"playboy_push_loop", undefined, "stopwoodsloop");
	wait 10;
	
	while(1)
	{
		if (get_players()[0] IsTouching(touchtrig) && get_players()[0] IsLookingAt(looktrig) )
		{
			alignstruct notify ("stopwoodsloop");
			alignstruct anim_single_aligned(level.woods, "playboy_helpme_mason");
			alignstruct thread anim_loop_aligned(level.woods,"playboy_push_loop", undefined, "stopwoodsloop");
			wait 10;
		}
		wait 0.2;
	}
}
			
			

#using_animtree("generic_human");
playboy_blowthrough()
{
	align_struct = getstruct("playboy_script_anim", "targetname");
	playboy_intopositions(align_struct);
	
	flag_set("woods_at_playboy");
	level thread woods_helpme(align_struct);

	flag_wait("playboy_blowthrough_go");
	
	level thread playboy_rumbles();
	
	align_struct notify ("stopwoodsloop");
	align_struct notify ("stoploop");
	
	level thread playboy_blowthrough_objects(align_struct);
	
	playboy_pressed_x_anims(align_struct);
	level thread playboy_explosion_notetrack_anims(align_struct);
	playboy_ohshit_scene(align_struct);
	
	autosave_by_name("playboy_scene_done");
	level.reznov LookatEntity();
}
	
playboy_intopositions(align_struct)
{
	
	woods = level.woods;
	woods.animname = "woods";
	
	redshirt1 = GetEnt("tankblast_redshirt1", "targetname") StalingradSpawn();
	redshirt2 = GetEnt("tankblast_redshirt2", "targetname") StalingradSpawn();
	
	wait 0.05;

	redshirt1.animname = "playboy_redshirt1";
	redshirt2.animname = "playboy_redshirt2";
	redshirt1 thread magic_bullet_shield();
	redshirt2 thread magic_bullet_shield();
	
	//align_struct thread anim_reach_then_loop(redshirt2, "playboy_cover_idle_reach", "playboy_cover_idle");
	//align_struct thread anim_reach_then_loop(redshirt1, "playboy_cover_idle_reach", "playboy_cover_idle");
	
	level.woods StopAnimScripted();
	align_struct anim_reach_aligned(woods, "playboy_into_position");
	align_struct anim_single_aligned(woods, "playboy_into_position");
	//align_struct anim_reach_aligned(woods, "playboy_push_loop_reach");
	align_struct thread anim_loop_aligned(woods, "playboy_push_loop", undefined, "stopwoodsloop");

	level.woods enable_ai_color();
}

playboy_pressed_x_anims(align_struct)
{
	align_struct notify ("stoploop");
	
	level thread playboy_blowthrough_playeranim(align_struct);

	//kdrew - to sync the other animations with the player's camera tween in playboy_blowthrough_playeranim
	wait(0.25);

	time = GetAnimLength(level.scr_anim[level.woods.animname]["playboy_explosion"]);
	level thread flag_set_delayed("playboy_ohshit_go",time);

	align_struct thread anim_single_aligned(level.woods, "playboy_explosion");

	
	redshirt1 = GetEnt("tankblast_redshirt1_ai", "targetname");
	time = GetAnimLength(level.scr_anim[redshirt1.animname]["playboy_explosion"]);
	align_struct thread anim_single_aligned(redshirt1, "playboy_explosion");	
	//redshirt1 thread wait_and_kill(time);
}

playboy_explosion_notetrack_anims(align_struct)
{
	level waittill ("alley_car_explosion");
	
	//Tuey set music state to THROUGH_THE_DOOR
	setmusicstate("THROUGH_THE_DOOR");
	
	level thread playboy_timescale();

	
	redshirt2 = GetEnt("tankblast_redshirt2_ai", "targetname");
	align_struct anim_single_aligned(redshirt2, "playboy_death");
	redshirt2 thread stop_magic_bullet_shield();
	redshirt2 ragdoll_death();	
}

playboy_timescale()
{
	ts = 0.1;
	ts_time = 0.2;
	
	wait 0.15;
	SetTimeScale (0.5);
	wait 0.05;
	SetTimeScale (0.1);
	wait 0.15;

	SetTimeScale (0.3);
	wait 0.05;
	//SetTimeScale (0.5);
	//wait 0.05;
	//SetTimeScale (0.7);
	//wait 0.05;
	//SetTimeScale (0.9);
	//wait 0.05;
	SetTimeScale (1.1);
	wait 0.05;
	SetTimeScale (1.3);
	wait 0.5;

	SetTimeScale (0.2);
	
	timescale_fadeup( 1,  0.5);
	
//	if (level._total_button_press_counts < 3)
//	{
//		get_players()[0] stop_magic_bullet_shield();
//		get_players()[0] killme();
//	}
	
	/*
	timescale_fadedown(ts);
	timescale_fadeup(2, ts_time );
	timescale_fadedown(0.1,0.3 );
	timescale_fadeup( 1,  0.2);
	level thread wait_and_shake(0.2);
	*/
}

#using_animtree("player");
playboy_blowthrough_playeranim(align_struct)
{
	if (IsDefined(level.player_hands))
	{
		level.player_hands Delete();
	}
	

	level.player_hands = spawn_anim_model( "playboy_hands" );
	level.player_hands UseAnimTree(#animtree);
	level.player_hands.animname = "playboy_hands";
	level.player_hands hide();
	align_struct anim_first_frame(level.player_hands, "playboy_blowthrough");
	
	get_players()[0] StartCameraTween(0.25);
	
	//delaythread(4,::pulsing_hud,"alley_car_explosion");
	delaythread(3,::hue_city_button_prompt);

	hud_hide();	
	
	get_players()[0] playerlinktoAbsolute(level.player_hands, "tag_player");
	
	//wait for player camera to finish tween before animating
	wait(0.25);

	//wait an additional .1 seconds before showing hands
	level.player_hands thread wait_and_show(0.1);

	//fade out 2 seconds before the end of the animation
	delayThread( GetAnimLength(level.scr_anim["playboy_hands"]["playboy_blowthrough"]) - 2, ::playboy_fade_out);
	align_struct anim_single_aligned(level.player_hands, "playboy_blowthrough");
	level thread playboy_fade_in();

	align_struct anim_single_aligned(level.player_hands, "playboy_ohshit");
	
	level.player SetClientDvar( "hud_showStance", "1" ); 
	level.player SetClientDvar( "compass", "1" ); 
	level.player SetClientDvar( "ammoCounterHide", "0" );
	
	
	get_players()[0] Unlink();
	level.player_hands Delete();
	get_players()[0] EnableWeapons();
	get_players()[0] thread stop_magic_bullet_shield();
	
	flag_set("through_alley_door");
	
}

delay_link_player_to_hands(hands)
{
	wait(.2);
	get_players()[0] playerlinktoAbsolute(level.player_hands, "tag_player");

}

#using_animtree("animated_props");
playboy_blowthrough_objects(align_struct)
{
	tank = GetEnt("alley_tank", "targetname");
	tank Hide();
	
	faketank = spawn_a_model("t5_veh_tank_t55_lite", tank.origin, tank.angles);
	faketank UseAnimTree(#animtree);
	faketank.animname = "t55";
	
	align_struct thread anim_single_aligned(faketank, "playboy_blowthrough");
	wait 5.5;
	tank Show();
	faketank Delete();
}

tankfire_notify(guy)
{
	level notify ("playboy_tank_fire");
	
	GetEnt("playboy_door", "targetname") Delete();
	GetEnt("playboy_pooltable", "targetname") Delete();
	debris = GetEntArray("playboy_debris", "targetname");
	for (i=0; i < debris.size; i++)
	{
		debris[i] Delete();
	}
	//GetEnt("playboy_script_anim", "targetname") Delete();
}


#using_animtree("generic_human");
playboy_ohshit_scene(align_struct)
{
	flag_wait("playboy_ohshit_go");
	level thread playboy_props_delete();
	
	reznode = GetNode("reznov_post_playboy_node", "targetname");
	level.reznov forceteleport(reznode.origin, reznode.angles);
	level.reznov SetGoalNode(reznode);
	
	bownode = GetNode("bowman_post_playboy_node", "targetname");
	level.bowman forceteleport(bownode.origin, bownode.angles);
	level.bowman SetGoalNode(bownode);
	
	woodsnode = GetNode("woods_post_playboy_node", "targetname");
	level.woods forceteleport(woodsnode.origin, woodsnode.angles);
	level.woods SetGoalNode(woodsnode);

	//align_struct thread anim_single_aligned(level.woods, "playboy_ohshit");
	level.woods thread cut_ohshit();
	
	GetEnt("tankblast_redshirt1_ai", "targetname") killme();
	
	if(is_mature() && !is_gib_restricted_build() )
	{
		redshirt1 = GetEnt("headblown_guy", "targetname") StalingradSpawn();
		redshirt1 animscripts\shared::placeweaponon(redshirt1.weapon, "none");
	
	}
	else
	{
		redshirt1 = spawn("script_model",(0,0,0));
		redshirt1 useanimtree(#animtree);
		redshirt1 character\c_usa_jungmar_assault::main();
		if(isDefined(redshirt1.hatmodel))
		{
			redshirt1 detach(redshirt1.hatmodel);
		}
	}
	redshirt1.animname = "playboy_redshirt1";
	align_struct anim_single_aligned(redshirt1, "playboy_ohshit");
	redshirt1 stop_magic_bullet_shield();
	redshirt1 ragdoll_death();	
		
}

cut_ohshit()
{
	level.bowman disable_ai_color();
	level.reznov enable_cqbwalk();
	wait 3;
	self enable_cqbwalk();
	self StopAnimScripted();
	wait 6;
	trigger_use("reznov_in_alley_door_chain");
}

playboy_fade_in(guy)
{
	if(!flag("button_press_failed"))
	{
		level._playboy_fadehud fadeOverlay( 2, 0.4, 2 );
		level._playboy_fadehud fadeOverlay( 2, 0, 0 );
	}
}

playboy_fade_out(guy)
{
	if ( !IsDefined( level._playboy_fadehud ))
	{
		level._playboy_fadehud =	NewClientHudElem(get_players()[0]);

		level._playboy_fadehud.x = 0;
		level._playboy_fadehud.y = 0;
		level._playboy_fadehud setshader( "black", 640, 480 );
		level._playboy_fadehud.alignX = "left";
		level._playboy_fadehud.alignY = "top";
		level._playboy_fadehud.horzAlign = "fullscreen";
		level._playboy_fadehud.vertAlign = "fullscreen";
		level._playboy_fadehud.alpha = 0;
		level._playboy_fadehud.sort = 1;
		level._playboy_fadehud thread fadeOverlay(0.2, 1, 3);
	}
	if(flag("button_press_failed"))
	{
		player = get_players()[0];		
		player stop_magic_bullet_shield();
		player dodamage(player.health +1000, player.origin);
		missionFailedWrapper();	
	}
}

#using_animtree("generic_human");
alley_civ_mourning()
{
	flag_wait("player_ready_alley_door");
	
	align_struct = getstruct("mourn_play_spot", "targetname");
	civ1 = struct_spawn("alley_civ1_mourn_spawner", maps\hue_city_ai_spawnfuncs::executed_civs)[0];
	civ2 = struct_spawn("alley_civ2_mourn_spawner", maps\hue_city_ai_spawnfuncs::executed_civs)[0];
	wait 0.05;
	civ1.allowdeath = false;
	civ2.allowdeath = false;
	align_struct thread anim_loop_aligned(civ1, "mourndead1", undefined, "stoploop");
	align_struct thread anim_loop_aligned(civ2, "mourndead2", undefined, "stoploop");
	
	align_struct thread stopanim_and_kill(civ1, "c4_planted", "stoploop");
	align_struct thread stopanim_and_kill(civ2, "c4_planted", "stoploop");
}


streets_intro_vignettes()
{
	flag_wait("event2_start_go");
	align_struct = getstruct("streets_intro_vin_spot", "targetname");
	
	//troop1 = setup_street_intro_troop();
	//troop2 = setup_street_intro_troop();
	troop3 = setup_street_intro_troop();
	//troop4 = setup_street_intro_troop();
	troop5 = setup_street_intro_troop();
	troop7 = setup_street_intro_troop();
	troop8 = setup_street_intro_troop();
	//troop9 = setup_street_intro_troop();
	//medic1 = setup_street_intro_troop();
	medic2 = setup_street_intro_troop();
	medic3 = setup_street_intro_troop();
	medic4 = setup_street_intro_troop();
	
	//align_struct thread anim_loop_aligned(troop1, "injured_idle1", undefined, "stoploop");
	//align_struct thread anim_loop_aligned(troop2, "injured_idle2", undefined, "stoploop");
	//align_struct thread anim_loop_aligned(troop4, "injured_idle4", undefined, "stoploop");
	//troop4 thread wait_and_printme("injured_idle4");
	//align_struct thread anim_loop_aligned(troop9, "injured_idle9", undefined, "stoploop");
	//troop9 thread wait_and_printme("injured_idle9");		
	//align_struct thread anim_loop_aligned(medic1, "medic_idle1", undefined, "stoploop");
	//medic1 thread wait_and_printme("medic_idle1");	
	//align_struct thread anim_loop_aligned(troop3, "injured_idle3", undefined, "stoploop");
	//troop3 thread wait_and_printme("injured_idle3");
	//align_struct thread anim_loop_aligned(medic2, "medic_idle2", undefined, "stoploop");
	//medic2 thread wait_and_printme("medic_idle2");
		
		
	align_struct thread anim_intro_then_loop(troop5, "injured_intro5", "injured_idle5");
	//troop5 thread wait_and_printme("injured_idle5");
	
	align_struct thread anim_intro_then_loop(troop7, "injured_intro7", "injured_idle7");
	//troop7 thread wait_and_printme("injured_idle7");
	align_struct thread anim_loop_aligned(troop8, "injured_idle8", undefined, "stoploop");
	
	align_struct thread anim_intro_then_loop(medic3, "medic_intro3", "medic_idle3");
	//medic3 thread wait_and_printme("medic_idle3");
	
	align_struct thread anim_intro_then_loop(medic4, "medic_intro4", "medic_idle4");
	//medic4 thread wait_and_printme("medic_idle4");
}
	
setup_street_intro_troop()
{
	troop = spawn("script_model", (0,0,0) );
	troop character\c_usa_jungmar_assault::main();
	troop UseAnimTree(#animtree);
	troop.animname = "street_intro_redshirts";
	troop thread clear_street_intro_vignettes();
	
	troop.team = "allies";
	troop.voice = "american";
	troop maps\_names::get_name();
	troop setlookattext( troop.name, &"" );
	
	return troop;
}

wait_and_printme(animation)
{
	self endon ("death");
	while(1)
	{
		wait 1;
		Print3d( self.origin+(0,0,60), animation, (1,1,1) ,1, 0.3, 40 );
	}
}

clear_street_intro_vignettes()
{
	level waittill ("get_chopper_now");
	align_struct = getstruct("streets_intro_vin_spot", "targetname");
	self StopAnimScripted();
	align_struct notify ("stoploop");
	wait 0.05;
	self Delete();
}
	
		// TEMP TODO - temp implementation until we get new mocap
breach_alley_gate_vignette()
{
	flag_wait("street_end_go");
	//flag_wait("skydemon_taking_aa_fire");
	
	woods_node = GetNode("alley_gate_woods_node", "targetname");
	
	align_struct = getstruct("alley_gate_align_struct", "targetname");
	
	level.woods.goalradius = 16;
	level.woods.ignoreme = 1;
	
	level.woods SetGoalNode(woods_node);
	
	level.woods disable_ai_color();
	level.woods.animname = "woods";
	
	guys = [];
	guys[0] = level.woods;
	
	flag_wait("skydemon_taking_aa_fire");
	
	array_wait(guys, "goal");

	
	trig = GetEnt("near_alley_gate_trig", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	
	level.woods.ignoreme = 0;
	
	align_struct thread anim_single_aligned(level.woods, "gate_breach");
	
	trigger_use("aa_gun_street_sm_1");

	//gate = GetEnt("aa_gun_street_gate", "targetname");
	wait 1.05;
	level notify ("gate_kick_start");
	//gate RotateYaw(135, 1);
	//gate moveto (gate.origin + (0,-600,-150), 1 );
	wait 0.7;
	//gate Delete();
	clip = GetEnt("aagun_gate_player_clip", "targetname");
	clip ConnectPaths();
	clip Delete();
	
	
	level thread playboy_blowthrough();

	wait 1;

	GetEnt("guide_alley_chain_1", "targetname") trigger_on();
		
}

pilot_anims()
{
	pilot = spawn("script_model", level.spirit gettagorigin("tag_player"));
	pilot character\c_usa_jungmar_tanker::main();
	pilot UseAnimTree(#animtree);
	pilot linkto (level.spirit, "tag_driver", (0,0,0) );
	pilot.animname = "hueyspot0";
	level.spirit thread anim_loop_aligned( pilot, "idle", "tag_driver", "whatever");
}


#using_animtree("generic_human");	
notify_to_player(guy)
{
	level notify("woods_broke_window");
}

remove_carabiner(guy)
{
	level.player_hands DetachAll();
}

player_break_window(guy)
{
	//VisionSetNaked("quagmire_3",1);
	level.player shellshock("quagmire_window_break", 8);
	level notify ("broke_through_macv_window");
	get_players()[0] PlayRumbleOnEntity("explosion_generic");
	get_players()[0] PlayRumbleOnEntity("melee_garrote");
	wait 2.5;
	get_players()[0] StopRumble("melee_garrote");
}


#using_animtree ("generic_human");
notify_dead_guy_death(guy)
{
	dead_guy_1 = GetEnt( "dead_guy_1_ai", "targetname" );

	if( IsDefined( dead_guy_1 ) && IsAlive( dead_guy_1 ) )
	{
		dead_guy_1.deathFunction = ::kill_deadguy;
		dead_guy_1 DoDamage( dead_guy_1.health + 100, dead_guy_1.origin);
	}
}

kill_deadguy(guy)
{
	if (isdefined(guy))
	{
		guy StartRagdoll();
		return;
	}
	self StartRagdoll();
}

//
//death_ragdoll(guy)
//{
////	if (IsDefined(guy.primaryweapon))
////	{
//////		guy useweaponhidetags(guy.primaryweapon);
////		model = "t5_weapon_ak47_world";
////		fakegun= spawn_a_model(model, guy GetTagOrigin("tag_weapon_right"), guy GetTagAngles("tag_weapon_right") );
////		
////		if(isDefined(guy.script_noteworthy) && guy.script_noteworthy == "nva_repel_ak47")
////		{
////			fakegun thread delayed_delete(30);
////			return;
////		}
////		
////		gun = Spawn("weapon_"+guy.primaryweapon, guy GetTagOrigin("tag_weapon_right"));
////		gun.angles = guy GetTagAngles("tag_weapon_right");
////		guy animscripts\shared::placeweaponon(guy.primaryweapon, "none");
////		gun Hide();
////		
////		fakegun thread delete_on_delete(gun);
////	}
//}

delayed_delete(time)
{
	self endon("death");
	wait(time);
	self delete();
}

player_VO_response(guy)
{
	flag_set("still_with_me");
}

play_other_ropeanim(guy)
{
	rope = getent("fxanim_quag_rappelfix_mod", "targetname");
	rope linkto (guy, "tag_weapon", (0,0,0) );
	level notify ("rappelfix_start");
}

stop_other_ropeanim(guy)
{
	rope = getent("fxanim_quag_rappelfix_mod", "targetname");
	rope unlink();
	rope delete();
	wait 0.2;
	level.player_hands attach("t5_weapon_spas_world", "tag_weapon");
}


blood_impact(guy)
{
	if( IsDefined(guy) && is_mature() )
	{
		PlayFXOnTag(level._effect["shotgun_impact"], guy, "J_SpineUpper");
	}
}

show_fake_spas( guy )
{
	level.gun_guy gun_remove();
	
	if( IsDefined( level.spas ) )
	{
		level.spas Show();
		level.spas waittillmatch( "single anim", "end" );
		level.spas Delete();
	}
}

blood_squirt(guy)
{
	if( IsDefined(guy) && is_mature() )
	{
		PlayFxonTag(level._effect["neck_stab"],guy,"J_neck");
	}
}

#using_animtree("player");
plant_c4_on_roof()
{
	if (IsDefined(level.player_hands))
	{
		level.player_hands Delete();
	}
	
	ang = get_players()[0] GetPlayerAngles();
	
	align_struct = getstruct("c4_explosion_node", "targetname");
	
	level.player_hands = spawn_anim_model( "c4_pant_hands", get_players()[0].origin, get_players()[0].angles );
	level.player_hands UseAnimTree(#animtree);
	level.player_hands.animname = "c4_pant_hands";
	level.player_hands hide();

	get_players()[0] playerlinktoAbsolute(level.player_hands, "tag_player");
	//wait 0.2;
	
	weapon = get_players()[0] GetCurrentWeapon();
	weapon_model = "weapon_c4";
	level.player_hands Attach(weapon_model, "tag_weapon");
	level.player DisableWeapons();
	level.player_hands Show();
	
	align_struct anim_single_aligned(level.player_hands, "plant_c4");
	level.player Unlink();
	level.player_hands Delete();
	level.player EnableWeapons();
	get_players()[0] SetPlayerAngles( ang);
	
}

repel_fire(guy)
{
	if (!IsDefined(guy._repel_shots_fired))
	{
		guy._repel_shots_fired = 0;
	}
	guy._repel_shots_fired++;
	if (guy._repel_shots_fired > 2)
	{
			
		my_target = get_ai(guy.animname + "_repel_target");
		if (IsDefined(my_target) && IsAlive(my_target))
		{
			MagicBullet("commando_sp", guy GetTagOrigin("tag_flash"), my_target GetEye() );
			BulletTracer( guy GetTagOrigin("tag_flash"), my_target GetEye(), 1 );
		}
	}
}

playboy_props_delete()
{
	clips = array_combine(GetEntArray("playboy_debris", "targetname"), GetEntArray("playboy_pooltable", "targetname") );
	clips = array_combine(clips, GetEntArray("playboy_door", "targetname") );
	for (i=0; i < clips.size; i++)
	{
		clips[i] Delete();
	}
}

wounded_into_chopper()
{
	flag_wait("event3_go");
	node = GetVehicleNode("skydemon_landed_node", "script_noteworthy");
	align_struct = Spawn("script_origin", node.origin);
	align_struct.angles = node.angles;
	
	guys = struct_spawn("wounded_chopper_guys");
	
	for (i=0; i < guys.size; i++)
	{
		align_struct thread anim_loop_aligned (guys[i], "idle1", undefined, "stop_wounded_loop");
		if (guys[i].animname == "redshirt3")
		{
			guys[i] gun_remove();
		}
	}
	
	while(get_players()[0].origin[1] < -430)
	{
		wait 0.05;
	}
	
	node = GetVehicleNode("skydemon_landed_node", "script_noteworthy");
	while(DistanceSquared(level.skydemon.origin, node.origin) > (200*200) )
	{
		wait 0.05;
	}
	
	//flag_wait("player_near_landed_skydemon");
	align_struct notify ("stop_wounded_loop");
	
	for (i=0; i < guys.size; i++)
	{
		align_struct thread anim_intro_then_selfloop(guys[i], "wounded_b", "idle2", "stop_wounded_loop");
	}
	
	time = GetAnimLength(level.scr_anim["redshirt1"]["wounded_b"]);
	wait time;
	
	
	flag_set("wounded_on_skydemon");
	wait 10;
	align_struct Delete();
}

anim_intro_then_selfloop(guy, introanim, loopanim, ender)
{
	guy endon ("death");
	if (!IsDefined(ender))
	{
		ender = "stoploop";
	}
	self endon (ender);
	
	self anim_single_aligned(guy, introanim);
	
	if (guy.animname != "redshirt2") 
	{
		guy._linker = Spawn_a_model("tag_origin", guy.origin, guy.angles);
		guy LinkTo (guy._linker, "tag_origin", (0,0,0) );
		guy._linker LinkTo(level.skydemon);
		guy._linker thread wait_and_delete(20);
		guy._linker thread anim_loop_aligned(guy, loopanim, undefined, "death");
		flag_wait("e3_player_near_leaving_chopper");
		guy thread wait_and_kill(20);
	}
}

reznov_hall_quickanim()
{
	level endon ("in_reznov_room");
	align_struct = getstruct("reznov_hall_align_struct", "targetname");
	
	level.woods.animname = "woods";
	
	align_struct anim_reach_aligned(level.woods, "reznov_hallway_breach");
	flag_set("doing_rezhall_quickanim");
	align_struct anim_single_aligned(level.woods, "reznov_hallway_breach");
	align_struct anim_loop_aligned(level.woods, "reznov_hallway_breach_idle", undefined, "stoploop");
}


jumpto_boat(boat)
{
	align_struct = getstruct("boat_jumpto_align_struct", "targetname");	
	
	level.player_hands = spawn_anim_model( "playboy_hands" );
	level.player_hands UseAnimTree(level.scr_animtree["playboy_hands"]);
	level.player_hands.animname = "playboy_hands";

	level.player_hands hide();
	get_players()[0] startcameratween(.5);
	get_players()[0] playerlinktoAbsolute(level.player_hands, "tag_player");	
	level thread wait_and_rumble(0.8, "damage_heavy");	

	level.bowman.animname = "bowman";
	level.reznov.animname = "reznov";
	level.woods.animname = "woods";
	boat.animname = "boat";
	boat UseAnimTree(level.scr_animtree["boat"]);
	
	level.bowman.name = "";
	level.reznov.name = "";
	level.woods.name = "";
	
	level.reznov gun_remove();
		
	ents = array(level.bowman,level.reznov,level.woods,boat,level.player_hands);
	
	align_struct thread anim_single_aligned(ents, "jumpto_boat");	
	wait(.5);
	level.player_hands Show();	
}

get_repelgun_position(guy)
{
	//org = guy GetTagOrigin("tag_weapon_right");
	//ang = guy GetTagAngles("tag_weapon_right");
	
	GetEnt("woods_repel_gun", "targetname") Delete();
	wait 1;
}

#using_animtree("player");
reznov_reveal()
{
	align_struct = getstruct("reznov_room_align_struct", "targetname");
	
	nva = struct_spawn("nva_reznov_reveal_guy")[0];
	nva Detach(nva.headModel);
	nva Detach(nva.gearModel);
	nva character\gfl\character_gfl_nyto::main();
	nva gun_remove();
	nva attach("t5_knife_sog", "tag_weapon_right");
	nva attach("t5_knife_sog","tag_weapon_left");
	
		
	get_players()[0] DisableWeapons();
	
	level.player_hands = spawn_anim_model( "playboy_hands" );
	level.player_hands UseAnimTree(#animtree);
	level.player_hands.animname = "playboy_hands";
	level.player_hands hide();
	
	align_struct anim_first_frame(level.player_hands, "reznov_reveal");
	
	get_players()[0] startcameratween(0.2);
	
	get_players()[0] playerlinktoAbsolute(level.player_hands, "tag_player");
	
	wait 0.05;
	
	level thread reznov_reveal_aianim();
	level thread reznov_reveal_dossier();	
	level thread show_hands_delay();
	level thread reznov_reveal_remove_knife(nva);
	align_struct anim_single_aligned(level.player_hands, "reznov_reveal");	

	wait(3);
	get_players()[0] Unlink();
	get_players()[0] EnableWeapons();
	level.player_hands Delete();
}

reznov_reveal_remove_knife(nva)
{
	//wait until the NVA is out of the scene
	wait(5);

	//remove the knives
	nva Detach("t5_knife_sog", "tag_weapon_right");
	nva Detach("t5_knife_sog","tag_weapon_left");
}

show_hands_delay()
{
	wait(1.5);
	level.player_hands Show();
}
	
#using_animtree("generic_human");
reznov_reveal_aianim()
{
	align_struct = getstruct("reznov_room_align_struct", "targetname");
	
	level.reznov hide();
	
	nva = GetEnt("nva_reznov_reveal_guy_ai", "targetname");
	
	//Reznov is an illusion
	level.reznov thread wont_disable_player_firing();
	
	level.reznov.animname = "reznov";
	nva.animname = "nva";
	nva.ignoreme = 1;
	
	level.reznov.name = "";
	
	level thread wait_and_show_reznov();
	
	//align_struct thread anim_single_aligned(reznov, "reznov_reveal");
	align_struct anim_single_aligned(array(level.reznov,nva), "reznov_reveal");

	
	if (IsDefined(nva) && IsAlive(nva))
	{
		nva ragdoll_death();
	}
	level.reznov.name = "Reznov";
	level.reznov enable_cqbwalk();

	wait(4);
	level.reznov disable_cqbwalk();
}

wait_and_show_reznov()
{
	wait(1);
	level.reznov show();
}

reznov_reveal_deadguy()
{
	align_struct = getstruct("reznov_room_align_struct", "targetname");
	
	deadguy = spawn("script_model",align_struct.origin);
	deadguy.angles = align_struct.angles;
	
	// deadguy setmodel("c_usa_jungmar_fieldagent_fb");//character\c_vtn_nva1::main();
	deadguy Detach(deadguy.headModel);
	deadguy character\gfl\character_gfl_ak74m::main();
	deadguy.animname = "deadguy";	
	deadguy useanimtree(#animtree);
	align_struct thread anim_single_aligned(deadguy, "reznov_reveal");
	
	flag_wait("crossing_e1b_street");
	deadguy delete();	
	
	
	level.woods enable_cqbwalk();
	level.reznov enable_cqbwalk();
	level.bowman enable_cqbwalk();
	trigger_wait("street_transition_exit");
	
	level.woods disable_cqbwalk();
	level.reznov disable_cqbwalk();
	level.bowman disable_cqbwalk();
}



#using_animtree("animated_props");
reznov_reveal_dossier()
{
	align_struct = getstruct("reznov_room_align_struct", "targetname");
	
  linker = spawn_a_model( "tag_origin_animate", align_struct.origin, align_struct.angles );
	linker.animname = "dossier";
  linker UseAnimTree( #animtree );
                
   // Grab the flashlight (in this case, already placed in map)
  dossier = spawn_a_model("p_pent_manila_folder_1", linker GetTagOrigin( "origin_animate_jnt"),  linker GetTagAngles( "origin_animate_jnt" ) );
	dossier LinkTo( linker, "origin_animate_jnt" );
                
		// play the anim on the linking entity
	align_struct anim_single_aligned(linker, "reznov_reveal");
	linker Delete();
	dossier Delete();
}
	
reznov_reveal_explosion(guy)
{
	earthquake (0.4, 1, get_players()[0].origin, 500);
	get_players()[0] playrumbleonentity ("artillery_rumble");
	//SOUND - Shawn J
	//iprintlnbold ("Broznov Boom");
	playsoundatposition ("exp_mortar_dirt", (get_players()[0].origin));
	clientNotify ("exp_hit_rattle");
}



playboy_rumbles()
{
	thread wait_and_rumble(1, "barrel_explosion");
	
	thread wait_and_rumble(6.15, "damage_heavy");
	
	thread wait_and_rumble(7.35, "heavygun_fire");
	
	thread wait_and_rumble(9, "explosion_generic");
	
	thread wait_and_rumble(13.6, "damage_light");
}


hue_city_button_prompt()
{
	level thread wait_for_button_presses();
	if(level.console)
	{
		screen_message_create( &"HUE_CITY_PROMPT_PRESS_OPEN" );
	}
	else
	{
		screen_message_create( &"HUE_CITY_PUSH_DOOR" );
	}
	
	flag_wait("alley_car_explosion");
	screen_message_delete();	
}

wait_for_button_presses()
{
	presses = 0;
	flag_init("button_press_failed");
	player = get_players()[0];
	
	
	while(!flag("alley_car_explosion"))
	{
		
		if( player UseButtonPressed() )
		{
			while(player UseButtonPressed() )
			{
				wait(.05);
			}
			presses++;
		}	
		wait(.05);	
	}
	if(presses < 5)
	{
		flag_set("button_press_failed");
	}
	
}