#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_clientfaceanim;
#include maps\int_escape_util;

#using_animtree ("generic_human");
main()
{
	init_player_anims();
	init_ai_anims();
	init_notetracks();
	init_prop_anims();
	
	init_dialogue();
}

init_notetracks()
{
	addNotetrack_customFunction( "generic", "cam_lock",	  ::player_cam_lock, "unstrapped" );
	addNotetrack_customFunction( "generic", "cam_unlock",  ::player_cam_unlock, "unstrapped" );
	
	addNotetrack_customFunction( "mason", "first_person",	  ::first_person_notify, "brainwash_room" );
	addNotetrack_customFunction( "mason", "third_person",  ::third_person_notify, "brainwash_room" );
	
	addNotetrack_customFunction( "player", "hudson_punch",  ::hudson_punch_notify, "hudson_punch" );

	addNotetrack_customFunction( "generic", "play_dks_bink",  ::play_dks_must_die, "reznov_brainw_2" );

	addNotetrack_customFunction( "generic", "start_fade",  ::end_level, "outro_flashback" );

	addNotetrack_customFunction( "generic", "smash_tv",  ::smash_tv_notify, "unstrapped" );
	addNotetrack_customFunction( "generic", "smash_tv",  ::tv_wall_notify, "unstrap_punch" );
	addNotetrack_customFunction( "generic", "tray_start",  ::e1_cart_props, "unstrap_punch" );


	addNotetrack_customFunction( "fxanim_props", "tv_06_impact",  ::tv_06_impact, "a_tv_wall" );
	addNotetrack_customFunction( "fxanim_props", "tv_04_impact",  ::tv_04_impact, "a_tv_wall" );
	addNotetrack_customFunction( "fxanim_props", "tv_01_impact",  ::tv_01_impact, "a_tv_wall" );

	addNotetrack_customFunction( "castro", "sndnt#vox_cub1_s04_124A_cast_m",  ::new_relationship_said, "your_dead" );
}


init_ai_anims()
{
			// event 	1
	
	level.scr_anim["generic"]["fake_player_chair_loop"][0]	= %ch_interrogation_chair_idle_full_char;

	level.scr_anim["generic"]["unstrapped"] 		= %ch_int_b01_hudson_unstraps_plyr_hudson;
	level.scr_anim["generic"]["weaver_chill"] 	= %ch_int_b01_hudson_unstraps_plyr_weaver;
	level.scr_anim["generic"]["weaver_idle"][0] 	= %ch_int_b01_hudson_unstraps_plyr_weaver_idle;
		
	level.scr_anim["generic"]["unstrap_loop"][0] 		= %ch_int_b01_plyr_punches_hudson_loop_hudson;
	level.scr_anim["generic"]["unstrap_punch"] 		= %ch_int_b01_plyr_punches_hudson_hudson;

	level.scr_anim["generic"]["passed_out_loop"][0] 		= %ch_int_b01_plyr_punches_hudson_hudson_idle;
	
			// event 3
	level.scr_anim["dragovich"]["brainwash_room"] 			= %ch_int_b03_plyr_view_brainwash_dragovich;
	level.scr_anim["kravchenko"]["brainwash_room"] 			= %ch_int_b03_plyr_view_brainwash_kravchenko;
	level.scr_anim["dragovich"]["brainwash_loop"][0] 		= %ch_int_b03_plyr_view_brainwash_loop_dragovich;
	level.scr_anim["kravchenko"]["brainwash_loop"][0] 	= %ch_int_b03_plyr_view_brainwash_loop_kravchenko;
	level.scr_anim["mason"]["brainwash_loop"][0] 				= %ch_int_b03_plyr_view_brainwash_loop_mason;
	level.scr_anim["steiner"]["brainwash_loop"][0]		 	= %ch_int_b03_plyr_view_brainwash_loop_steiner;
	level.scr_anim["mason"]["brainwash_room"] 					= %ch_int_b03_plyr_view_brainwash_mason;
	level.scr_anim["steiner"]["brainwash_room"] 				= %ch_int_b03_plyr_view_brainwash_steiner;

	
	
			// event 8
	
	level.scr_anim["generic"]["reznov_brainw_1"] 			= %ch_int_b08_reznov_brainwash_pt1_reznov;
	level.scr_anim["generic"]["reznov_brainw_2"] 			= %ch_int_b08_reznov_brainwash_pt2_reznov;
	
	level.scr_anim["generic"]["hudson_punch"] 			= %ch_int_b08_hudson_punch_hudson;
	level.scr_anim["generic"]["hudson_cleared_u"] 	= %ch_int_b08_i_cleared_you_hudson;
	level.scr_anim["generic"]["intro_flashback"] 		= %ch_int_b08_hudson_comm_room_hudson;
	level.scr_anim["generic"]["outro_flashback"] 		= %ch_int_b08_hudson_comm_room_end_hudson;
	
	
	level.scr_anim["generic"]["intro_flashback1"] 		= %ch_int_b08_hudson_comm_room_pt1_hudson;
	level.scr_anim["generic"]["intro_flashback2"] 		= %ch_int_b08_hudson_comm_room_pt2_hudson;
	level.scr_anim["generic"]["intro_flashback3"] 		= %ch_int_b08_hudson_comm_room_pt3_hudson;
	level.scr_anim["generic"]["intro_flashback4"] 		= %ch_int_b08_hudson_comm_room_pt4_hudson;

	level.scr_anim["castro"]["your_dead"]					 = %ch_int_b09_rusalka_castro;
	level.scr_anim["dragovich"]["your_dead"]			 = %ch_int_b09_rusalka_dragovich;
	level.scr_anim["kravchenko"]["your_dead"]			 = %ch_int_b09_rusalka_kravchenko;	
	
	level.scr_anim["steiner"]["u_dont_know"] = %ch_int_b09_blackroom_steiner;	


}

#using_animtree("player");
init_player_anims()
{
	level.scr_animtree[ "player" ] 	= #animtree;
	level.scr_model[ "player" ] = level.player_interactive_model;
	level.scr_anim["player"]["idle_player"][0] = %int_interrogation_chair_idle;

			// Event 1
	level.scr_anim["player"]["unstrapped"] 		= %ch_int_b01_hudson_unstraps_plyr_player;
	level.scr_anim["player"]["unstrap_loop"][0]  = %ch_int_b01_plyr_punches_hudson_loop_player;
	level.scr_anim["player"]["unstrap_punch"] = %ch_int_b01_plyr_punches_hudson_player;
	level.scr_anim["player"]["intro_loop"][0] 		= %ch_int_b01_hudson_unstraps_plyr_player_idle;
		
			// event 2
	level.scr_anim["player"]["stumble_wall_l"] 					= %ch_int_b02_corridor_stumble_left;
	level.scr_anim["player"]["stumble_wall_r"] 					= %ch_int_b02_corridor_stumble_right;
	level.scr_anim["player"]["stumble_double_doors"] 		= %ch_int_b02_open_double_doors_player;
	level.scr_anim["player"]["stumble_cart"] 						= %ch_int_b02_corridor_stumble_cart;
	level.scr_anim["player"]["enter_morgue"] 						= %ch_int_b02_plyr_enter_morgue_player;

	
			// Event 8
			
	level.scr_anim["player"]["reznov_brainw_1"] 			= %ch_int_b08_reznov_brainwash_pt1_player;
	level.scr_anim["player"]["reznov_brainw_2"] 			= %ch_int_b08_reznov_brainwash_pt2_player;
			
	level.scr_anim["player"]["hudson_punch"] 			= %ch_int_b08_hudson_punch_player;
	level.scr_anim["player"]["hudson_cleared_u"] 	= %ch_int_b08_i_cleared_you_player;
	level.scr_anim["player"]["intro_flashback"] 		= %ch_int_b08_hudson_comm_room_player;
	level.scr_anim["player"]["outro_flashback"] 		= %ch_int_b08_hudson_comm_room_end_player;
	
	
	level.scr_anim["player"]["intro_flashback1"] 		= %ch_int_b08_hudson_comm_room_pt1_player;
	level.scr_anim["player"]["intro_flashback2"] 		= %ch_int_b08_hudson_comm_room_pt2_player;
	level.scr_anim["player"]["intro_flashback3"] 		= %ch_int_b08_hudson_comm_room_pt3_player;
	level.scr_anim["player"]["intro_flashback4"] 		= %ch_int_b08_hudson_comm_room_pt4_player;
	
	level.scr_anim["player"]["u_dont_know"] 			 = %ch_int_b09_blackroom_player;
	level.scr_anim["player"]["your_dead"] 			 = %ch_int_b09_rusalka_player;
}

setup_idle_animation()
{
	sync_node = GetEnt("interrogation_chair", "targetname");
	level.player_hands = Spawn_anim_model( "player" );
	level.player_hands.angles = self.angles;
	level.player_hands.origin = self.origin;
	level.player_hands.animname = "player";

	self playerlinktodelta(level.player_hands, "tag_camera", 0, 1, 1, 1, 1);

	hide_viewmodel();

	align_struct = getstruct("player_release_align_struct", "targetname");
	align_struct anim_first_frame(level.player_hands, "unstrapped");

	align_struct thread anim_loop_aligned(level.player_hands, "intro_loop", undefined, "stoplooping");

	wait 1;
	self playerlinktodelta(level.player_hands, "tag_camera", 0, 60, 60, 60, 40);
}

#using_animtree ("animated_props");
init_prop_anims()
{
	level.scr_animtree["door_l"] 	        	 = #animtree;
	level.scr_animtree["door_r"] 	        	 = #animtree;
	
	level.scr_anim["door_l"]["e2_dooropen"]							 = %o_int_b02_open_double_doors_door_left;
	level.scr_anim["door_r"]["e2_dooropen"] 						 = %o_int_b02_open_double_doors_door_right;
	level.scr_anim["door_l"]["morgue_dooropen"]					 = %o_int_b02_plyr_enter_morgue_door_left;
	level.scr_anim["door_r"]["morgue_dooropen"] 				 = %o_int_b02_plyr_enter_morgue_door_right;

	level.scr_animtree["cart"] 	        		 = #animtree;
	level.scr_anim["cart"]["stumble_cart"]			 = %o_int_b02_corridor_stumble_cart;
	
	
	level.scr_animtree["int_door"] 	        		 = #animtree;
	level.scr_anim["int_door"]["int_door_open"]			 = %o_int_b01_hudson_unstraps_plyr_door;

	level.scr_animtree["int_straps"] 	        		 = #animtree;
	level.scr_anim["int_straps"]["int_straps_open_l"]			 = %o_int_b01_hudson_unstraps_plyr_leftstrap;
	level.scr_anim["int_straps"]["int_straps_open_r"]			 = %o_int_b01_hudson_unstraps_plyr_rightstrap;

	level.scr_anim["int_straps"]["brainwash_strap_l"]			 = %o_int_b03_plyr_view_brainwash_leftstrap;
	level.scr_anim["int_straps"]["brainwash_strap_r"]			 = %o_int_b03_plyr_view_brainwash_rightstrap;
}

#using_animtree ("generic_human");
init_dialogue()
{
	level.scr_sound["generic"]["been_here_hours"]					= "vox_int1_s01_001A_weav"; //It is no use... we are out of time!
	level.scr_sound["generic"]["cant_giveup_now"] 				= "vox_int1_s01_002A_inte"; //We can't give up now. He was at Vorkuta. He knows how to translate the codes. He's heard the broadcasts which we know contain the location. It's all in his head somewhere. He does know where it is!
  //level.scr_sound["generic"]["anime"] 					 			= "vox_int1_s01_002B_inte"; 					//We can't give up now. He was at Vorkuta. He knows how to translate the codes. He's heard the broadcasts which we know contain the location. It's all in his head somewhere. He does know where it is!
  level.scr_sound["generic"]["defcon2"] 					 			= "vox_int1_s01_003A_weav"; //We have to get to the bunker!  We are at DEFCON 2... You've tried everything...
  level.scr_sound["generic"]["not_yet"]					 				= "vox_int1_s01_004A_inte"; //Not yet...I have one more card to play.
  level.scr_sound["generic"]["leave_him_here"]					= "vox_int1_s01_005B_weav_m"; //Leave him here. He's not worth it.
  level.scr_sound["generic"]["anime"]					 					= "vox_int1_s01_006A_huds_m"; //Get out of here, Weaver.  You have to tell them we failed to locate the broadcast's source.
  level.scr_sound["generic"]["die_with_him"] 					  = "vox_int1_s01_007A_weav_m"; //You want to die with him?...Your choice.
  level.scr_sound["generic"]["anime"] 					 				= "vox_int1_s01_008A_huds_m"; //Dammit! Why can't you remember?!
  level.scr_sound["generic"]["hes_dead_mason"]					= "vox_int1_s01_009A_huds_m"; //Reznov's DEAD, Mason! Do you hear me?!!! He's dead!!! Weaver's right...we are out of time.
  level.scr_sound["generic"]["did_this_2_u"] 					  = "vox_int1_s01_010A_huds_m"; //The Russians fucked you up... I know you...you're not a traitor.
  level.scr_sound["generic"]["anime"] 					 				= "vox_int1_s01_010B_huds_s_m"; //The Russians messed you up... I know you...you�re not a traitor.

  level.scr_sound["generic"]["have_the_numbers"]				= "vox_fro2_s01_015A_inte"; //The numbers, Mason.  What do they mean?  Where are they broadcast from?
  level.scr_sound["generic"]["nums_what_they_say"] 			= "vox_int1_s01_200A_maso"; //Numbers...the numbers...what...are they saying?...
  level.scr_sound["generic"]["reznov_where_r_u"] 				= "vox_int1_s01_201A_maso"; //Reznov ... Where are you?... Reznov...
  level.scr_sound["generic"]["had_2_kill_steiner"] 			= "vox_int1_s01_202A_maso"; //I had...to kill...Steiner...
 
  level.scr_sound["generic"]["fucking_numbers"] 		 		= "vox_riv1_intro_09A_b"; //I...keep...hearing...the fucking...numbers...
  level.scr_sound["generic"]["fucking_numbers_s"] 		 	= "vox_riv1_intro_09A_s_b"; //* I...keep...hearing...numbers...

  level.scr_sound["generic"]["you_again"] 		 		 		 	= "vox_pow1_s04_426B_krav_m"; //You.... Again...
  level.scr_sound["generic"]["should_have_killed_u"]  	= "vox_pow1_s04_427B_krav_m"; //I should have killed you in Vorkuta!
  level.scr_sound["generic"]["wait_few_moments"]  			= "vox_int1_s01_015A_drag"; //Wait a few moments... Let him rest.
  level.scr_sound["generic"]["i_rem_vork"]  		 		 		= "vox_int1_s01_300A_maso"; //I remember. Vorkuta...What they did to me there --
 
  
  level.scr_sound["generic"]["regains_consc"]  		 		 	= "vox_int1_s01_016A_drag"; //When he regains consciousness - Double the voltage.
  level.scr_sound["generic"]["success_implanted"]  		 	= "vox_int1_s01_017A_stei_m"; //The subject has been successfully implanted with the knowledge to translate the number sequences.
  level.scr_sound["generic"]["wats_problem"] 		 		 		= "vox_int1_s01_018A_drag_m"; //So - what is the problem?
  level.scr_sound["generic"]["sporadic"] 		 		 		 		= "vox_int1_s01_019A_stei_m"; //His responses to our orders have been - sporadic.  Unpredictable.  He shows a remarkable resilience.
  level.scr_sound["generic"]["why"] 		 		 		 		 		= "vox_int1_s01_020A_drag_m"; //Why?
  level.scr_sound["generic"]["atypical"]  		 		 		 	= "vox_int1_s01_021A_stei_m"; //He is unusual... atypical.  Few men possess such will... Our other test subjects have been far more successful.
	
	level.scr_sound["generic"]["orders_embedded"]  		 		= "vox_int1_s01_022A_drag"; //If he will not follow the orders embedded in the numbers, then he is of no use to me...
  level.scr_sound["generic"]["he_can_rot"]  		 		 		= "vox_int1_s01_023A_drag"; //He can rot... Take him back to his cell.
  
  level.scr_sound["generic"]["anime"]										= "vox_int1_s01_205A_maso"; //Dragovich...Kravechenko...Steiner...the pain...oh my God, the pain...
  level.scr_sound["generic"]["anime"]									  = "vox_int1_s01_205B_maso"; //Dragovich...Kravechenko...Steiner...
  level.scr_sound["generic"]["dks_the_pain"] 						= "vox_int1_s01_205C_maso"; //The pain...oh my God, the pain...
    
  level.scr_sound["generic"]["proceed_to_target"]  		 	= "vox_int1_s01_206A_maso"; //Proceed...to...target...
  level.scr_sound["generic"]["oswald_compramised"] 		 	= "vox_int1_s01_207A_maso"; //Oswald...compromised.
  
  
  level.scr_sound["generic"]["were_all_bros"]  		 		 	= "vox_vor1_s2_046A_rezn_m_a"; //In Vorkuta, we are ALL brothers� Mason and I, we are the same!
  level.scr_sound["generic"]["sure_can_trust"] 		 		 	= "vox_vor1_s2_042A_rrd2_m"; //Are you sure you can trust this American?
  level.scr_sound["generic"]["with_my_life"]  		 		 	= "vox_vor1_s2_043A_rezn_m_a"; //With my life...
  level.scr_sound["generic"]["not_so_diff"]  		 		 		= "vox_vor1_s2_044A_rezn_m"; //He and us, are not so different... Trust Mason as you would trust me.
  level.scr_sound["generic"]["forgotton_abandoned"]  		= "vox_vor1_s2_045A_rezn_m"; //Betrayed.  Forgotten.  Abandoned.
	level.scr_sound["generic"]["you_will_survive"]  		 	= "vox_vor1_s6_400A_rezn"; //You will survive... You have to...
  level.scr_sound["generic"]["were_bros_mason"]  		 		= "vox_ful1_intro_08A"; //We are brothers Mason... We are the same.
  
  level.scr_sound["generic"]["grave_danger_commys"]  		= "vox_pen1_s01_039A_kenn_m"; //We are in grave danger from the communists. Our freedom and our very way of life is at risk.
	level.scr_sound["generic"]["dragovich"] 		 		 		 	= "vox_pen1_s01_040A_kenn_m"; //Nikita Dragovich.
  level.scr_sound["generic"]["when_i_kill_him"]  		 		= "vox_pen1_s01_011A_maso_m_b"; //When do I kill him?
  level.scr_sound["generic"]["j_fitz"]  		 		 		 		= "vox_int1_s01_208A_maso"; //Kennedy...John...Fitzgerald. I'm told you are the best we have. Anywhere.
  
  
  level.scr_sound["generic"]["guidance_interval"]  		 	= "vox_fla1_s02_066A_ruld_f"; //(Translated) 15 seconds, guidance internal, 13, 12, 11, 10, 9, 8, ignition sequence start.
  level.scr_sound["generic"]["engines_on"]  		 		 		= "vox_fla1_s02_067A_ruld_f"; //(Translated) Engines On. 5, 4... 3...
  level.scr_sound["generic"]["engines_running"]  		 		= "vox_fla1_s02_068A_ruld_f"; //(Translated) ...2, 1, all engines running.   Launch commit.
  level.scr_sound["generic"]["have_lift_off"] 		 		 	= "vox_fla1_s02_069A_ruld_f"; //(Translated) Lift-off. We have lift-off.
 
 
  level.scr_sound["generic"]["get_hell_out"]  		 		  = "vox_fla1_s09_255A_wood"; //Okay. Time we got the hell out of here.
  level.scr_sound["generic"]["not_yet..."]  		 		  	= "vox_fla1_s09_270A_maso"; //Not yet...
  level.scr_sound["generic"]["going_after_drago"]  		 	= "vox_fla1_s09_271A_maso"; //We're going after Dragovich.
 
  level.scr_sound["generic"]["noones_gettin_out"]   		= "vox_fla1_s09_316A_wood"; //No one's getting out.
  level.scr_sound["generic"]["satisfied"]   		 		 		= "vox_fla1_s09_317A_wood"; //Satisfied, Mason?
  level.scr_sound["generic"]["not_till_body"]  		 		 	= "vox_fla1_s09_318A_maso_b"; //Not yet... Not until I see the body.

  level.scr_sound["generic"]["had_kill_steiner"]   		 	= "vox_reb1_intro_03A_a";  //Steiner was at Rebirth Island. We had to kill Steiner.
  level.scr_sound["generic"]["we_viktor"]   		 		 		= "vox_reb1_intro_04A"; //We? Viktor Reznov?
  level.scr_sound["generic"]["need_closure"]   		 		 	= "vox_reb1_intro_05A_a";  //We wanted the same thing. The same.

  level.scr_sound["generic"]["hell_he_doing"]   		 		= "vox_reb1_s03_150A_weav"; //What the Hell is he doing?
  level.scr_sound["generic"]["killing_everyone"]   		 	= "vox_reb1_s03_151A_huds"; //Killing everyone between him and Steiner.
  level.scr_sound["generic"]["pain_is_difficult"]  		 	= "vox_int1_s01_050A_rezn"; //The pain is difficult isn't it?
 	level.scr_sound["generic"]["all_must_die"]  		 		 	= "vox_pow1_s04_440A_rezn"; //Dragovich.  Steiner. Kravchenko.  All must die...
  level.scr_sound["generic"]["i_wus_progrmd"]   		 		= "vox_int1_s01_209A_maso"; //Killing everyone between him and Steiner. I was programmed...to...kill...Steiner...Kravchenko and Dragovich!
 
  level.scr_sound["generic"]["anime"]  		 		 		  		= "vox_int1_s01_055B_huds_m"; //Dragovich brainwashed you, but Reznov had plans of his own...
  level.scr_sound["generic"]["defector_survived"]   		= "vox_hue1_s01_413A_bowm_b"; //You think the defector survived the attack?!
  level.scr_sound["generic"]["1_tuff_sob"]  		 		 		= "vox_hue1_s01_414A_wood"; //If he did, then he's one tough son of a bitch!
  level.scr_sound["generic"]["mason?"]   		 		 		  	= "vox_hue1_s01_430A_rezn_m_a"; //Mason?
  level.scr_sound["generic"]["reznov"]  		 		 		  	= "vox_hue1_s01_431A_maso_m"; //Reznov. How'd you get out of Vorkuta?
  level.scr_sound["generic"]["never_see_u_alive"]   		= "vox_hue1_s01_432A_maso_m"; //Never thought I'd see you alive...
  level.scr_sound["generic"]["real_defector_nova"]   		= "vox_int1_s01_063A_huds"; //He was never in Vietnam.  The real  defector with the Nova 6 dossier died during the attack on the MAC-V.
  level.scr_sound["generic"]["never_in_tunnels"]  		 	= "vox_int1_s01_302A_huds"; //He was never in the rat tunnels.
  level.scr_sound["generic"]["fucks_wrong_wit_u"]   		= "vox_cre1_s04_163A_swif_m"; //What the fuck's wrong with you?
	level.scr_sound["generic"]["kreavchenko_here"]   		 	= "vox_pow1_s04_416A_rezn"; //Kravchenko is here!
  level.scr_sound["generic"]["cant_let_him_slip"]   		= "vox_pow1_s04_417A_rezn"; //This way! We cannot let him slip through our grasp!
  level.scr_sound["generic"]["fuck_u_doin"]  		 		 		= "vox_pow1_s04_418A_wood"; //Mason?!  What the fuck are you doing?!! We gotta get these guys out.
  level.scr_sound["generic"]["too_close_to_goal"]   		= "vox_vor1_s6_255A_rezn"; //We are too close to our goal, Mason... You will survive... You have to!
  level.scr_sound["generic"]["never_at_rebirth"]  		 	= "vox_int1_s01_303A_huds"; //He was never at Rebirth Island.
  level.scr_sound["generic"]["names_reznov"]  		 		 	= "vox_reb1_s02_079A_rezn_m_b"; //My name is Viktor Reznov.
  level.scr_sound["generic"]["no.."]   		 		 		  		= "vox_reb1_s02_080A_stei_m"; //No...
  level.scr_sound["generic"]["mason!"]   		 		 		  	= "vox_reb1_s03_153A_huds"; //MASON!
  level.scr_sound["generic"]["will_have_revenge"]   		= "vox_reb1_s03_157A_maso_a"; //My name is Viktor Reznov. And I will have my revenge!
  level.scr_sound["generic"]["mason_no"]   		 		 			= "vox_reb1_s03_158A_huds"; //Mason - NO!
  level.scr_sound["generic"]["step_8_freedom"]   		 		= "vox_vor1_s7_274A_maso"; //Step eight, Reznov - Freedom!
  level.scr_sound["generic"]["4_you_mason"]  		 		 		= "vox_vor1_s7_275A_rezn_m_b"; //For you Mason...
  level.scr_sound["generic"]["not_4_me"]   		 		 			= "vox_vor1_s7_276A_rezn_m"; //Not for me...

  level.scr_sound["generic"]["reznov_been_dead"]  		 	= "vox_int1_s01_082B_huds_m";//Viktor Reznov�s been dead for 5 years. He died at Vorkuta during the escape! All the years you thought he was with you - that was just in your mind!
  level.scr_sound["generic"]["ded_4_years"]  		 		 		= "vox_int1_s01_210A_huds"; //Viktor Reznov's been dead for years.
  level.scr_sound["generic"]["no"]   		 		 		  		 	= "vox_int1_s01_211A_maso"; //No!
  level.scr_sound["generic"]["died_at_vorkuta"]  		 		= "vox_int1_s01_212A_huds"; //He died at Vorkuta during your escape!
  level.scr_sound["generic"]["cant_be_dead"]  		 		 	= "vox_int1_s01_213A_maso"; //He can't be dead!
  level.scr_sound["generic"]["all_years_u_thot"]  		 	= "vox_int1_s01_214A_huds"; //All the years you thought he was with you -
  level.scr_sound["generic"]["reznov_trusted_u"]  		 	= "vox_int1_s01_215A_maso"; //Reznov...I trusted you.
  level.scr_sound["generic"]["just_in_ur_mind"]  		 		= "vox_int1_s01_216A_huds"; //He was just in your mind!
  level.scr_sound["generic"]["trusted_him"]   		 		 	= "vox_int1_s01_083A_maso_m"; //I trusted him.


  level.scr_sound["generic"]["why_it_worked"]   		 		= "vox_int1_s01_084B_huds_m"; //That's why it worked... It was their attempt at MK-Ultra. Dragovich programmed you to kill Kennedy, but Reznov sabotaged you. He wanted revenge for all that Dragovich done to him. Dragovich. Kravchenko. Steiner. Three new victims.
  level.scr_sound["generic"]["gaps_in_memory"]   		 		= "vox_int1_s01_085B_huds_m"; //There are gaps in your memory. Periods where you went MIA and we couldn�t account for you. But now that the brainwashing�s been broken, all that lost time will come back.
  level.scr_sound["generic"]["strike_imminent"]  		 		= "vox_int1_s01_085C_huds_m"; //We need to leave... The Nova 6 strike is imminent. Hundreds of sleeper agents, hidden in every state capitol, are about to unleash this poison on your own countrymen.
  level.scr_sound["generic"]["lost_our_link"]  		 		 	= "vox_int1_s01_086B_huds_m"; 				//When Steiner died, we lost our key to unlocking the location of number broadcasts...you're all we have left.
  level.scr_sound["generic"]["brought_you_here"]   		 	= "vox_int1_s01_087B_huds_m"; //You were programmed at Vorkuta to translate the number codes. Only you can tell us what the codes mean. Nova 6 was just one of the sleeper operations. But I�m sure there were others...ones we didn�t even know about.
  level.scr_sound["generic"]["have_broadcasts"]  		 		= "vox_int1_s01_088B_huds_m"; //<font color="#000000">We have the bro</font>adcasts, we played them to you over and over again for hours, but we haven�t been able to break through your programming yet.
  level.scr_sound["generic"]["last_shot"]   		 		 		= "vox_int1_s01_088C_huds_m"; //Mason, this is our last shot. Listen, for God�s sake listen again.
  level.scr_sound["generic"]["mason_mason"]   		 		 	= "vox_int1_s01_089A_huds"; //Mason!... Mason!
  
  level.scr_sound["generic"]["reznov_could_override"]   = "vox_int1_s01_217A_huds"; //That�s why it worked... That�s why Reznov could override their programming. Vorkuta was the Russians� attempt at MK-Ultra - mind control. Dragovich programmed you to kill Kennedy, but Reznov turned the programming around. He wanted revenge for all that Dr
  
    
  level.scr_sound["generic"]["my_gift_2_u"]   		 		 	= "vox_cub1_s04_124A_cast_m"; //Do with him what you wish, General... He's my gift to you, in honor of our new relationship...

  level.scr_sound["generic"]["i_know_u_vorkuta"]   		 	= "vox_reb1_s02_070A_stei_m"; //I know you... Vorkuta!
  level.scr_sound["generic"]["you_dont_know"]  		 		 	= "vox_reb1_s02_071A_stei_m"; //You don't know...
  level.scr_sound["generic"]["did_2_u"]   		 		 		  = "vox_reb1_s02_072A_stei_m"; //What we did to you...

  level.scr_sound["generic"]["successfully_implanted"]  = "vox_int1_s01_017A_stei_m"; //The subject has been successfully implanted with the knowledge to translate the number sequences.
  level.scr_sound["generic"]["new_allies_in_cuba"]  		= "vox_int1_s01_094A_drag"; //...[indistinct] all agents.  Our new allies in Cuba have graciously permitted the construction of a new... and permanent... broadcast station within their borders.
  level.scr_sound["generic"]["from_now_until_nova"]   	= "vox_int1_s01_095A_drag"; //From now until Project Nova's initiation, all instructions will broadcast on this channel.
  level.scr_sound["generic"]["our_plan"]  		 		 		 	= "vox_int1_s01_096A_drag"; //Our plan to strike at the very heart of the West is now in motion.
  level.scr_sound["generic"]["further_instruction"]   	= "vox_int1_s01_097A_drag"; //Await further instructions.
	level.scr_sound["generic"]["make_sure_he_suffers"]   	= "vox_cub1_s04_125A_cast_m"; //Just... Make sure that he suffers...
  level.scr_sound["generic"]["suffering_beyond_fears"]  = "vox_cub1_s04_126A_drag_m"; //He will know suffering beyond his darkest fears...
  level.scr_sound["generic"]["plans_4_u"]  		 		 		  = "vox_cub1_s04_127A_drag_m"; //I have plans for you, American...

  level.scr_sound["generic"]["our_new_rel_short"]				= "vox_cub1_s04_124B_cast_m"; //...our new relationship...
  level.scr_sound["generic"]["perm_borad_short"]    		= "vox_int1_s01_094B_drag"; //...and permanent... broadcast station within their borders.
  level.scr_sound["generic"]["all_inst_short"]   		 		= "vox_int1_s01_095B_drag"; //...all instructions will broadcast from the Rusalka.

  level.scr_sound["generic"]["where_numers_station"] 		= "vox_int1_s01_104B_maso_m"; //I know where the numbers station is... It�s a ship... I saw it a long time ago... The Rusalka.
  level.scr_sound["generic"]["where"]   		 		 		  	= "vox_int1_s01_105A_huds_m"; //Where?
  level.scr_sound["generic"]["cuba"]  		 		 		  		= "vox_int1_s01_106A_maso_m"; //Cuba.
}

e1_weaver_idle()
{
	align_struct = getstruct("player_release_align_struct", "targetname");
	simple_spawn("weaver");
	level.weaver.animname = "generic";
	level.weaver gun_remove();
	
	align_struct thread anim_loop_aligned(level.weaver, "weaver_idle", undefined, "stoploop");
}

e1_cart_props(guy)
{
	fxanim_ent = GetEnt("fxanim_escape_tray_mod", "targetname");
	duped_cart_props = GetEntArray("cart_props_in_fxanim", "targetname");
	for (i=0; i < duped_cart_props.size; i++)
	{
		duped_cart_props[i] Delete();
	}
	
	cart_props = GetEntArray("cart_props", "script_noteworthy");
	for (i=0; i < cart_props.size; i++)
	{
		cart_props[i] LinkTo(fxanim_ent, cart_props[i].targetname+"_jnt");
	}

	level notify ("tray_start");
	stop_exploder(100);
	
}
	
	
e1_player_released_player_anims()
{
	old_sync_node = GetEnt("interrogation_chair", "targetname");
	old_sync_node notify ("stoplooping");
	
	align_struct = getstruct("player_release_align_struct", "targetname");
	align_struct notify ("stoplooping");
	
	
	level thread e1_shrink_viewclamp();
	align_struct anim_single_aligned(level.player_hands, "unstrapped");
	
	get_players()[0] startcameratween(0.3);
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	align_struct notify ("stoploop");
	
	animtime = GetAnimLength(level.scr_anim["player"]["unstrap_punch"]);
	align_struct thread anim_single_aligned(level.player_hands, "unstrap_punch");
	wait animtime - 1.8;
	
	flag_set("e1_punch_done");
	
	wait 1.6;
	
	hide_viewmodel();
	get_players()[0] unlink();
	get_players()[0] SetOrigin(level.player_hands.origin);
	level.player_hands Hide();
	wait 1;
	show_viewmodel();
	maps\int_escape_util::switch_interrogation_hands("interrogation_hands_sp");
	
	flag_set("out_of_int_chair");
	
}

#using_animtree ("generic_human");
e1_player_released()
{
	flag_set("player_realeased_anims_go");

	align_struct = getstruct("player_release_align_struct", "targetname");
	
	hudson = level.hudson;
	hudson.animname = "generic";
	hudson gun_remove();
	hudson HidePart( "J_Helmet");
	
	level.weaver.animname = "generic";
	
	
	align_struct thread e1_hudson_open_door();
	
	level thread e1_player_released_player_anims();
	
	align_struct thread anim_single_aligned (level.weaver, "weaver_chill");
	align_struct anim_single_aligned(hudson, "unstrapped");
	
	time = GetAnimLength(level.scr_anim[hudson.animname]["unstrap_punch"]);
	
	if(IsDefined(level.streamHintEnt))
	{
		level.streamHintEnt Delete();
	}
	
	align_struct thread anim_single_aligned(hudson, "unstrap_punch");
	level.weaver Delete();
	flag_set("release_untying");
	thread wait_and_rumble(0.5, "damage_light");
	
	wait time;
	
	align_struct anim_loop_aligned(hudson, "passed_out_loop");

}

e1_straps()
{
	align_struct = getstruct("player_release_align_struct", "targetname");
		
	strap1 = spawn_a_model("p_int_interrogation_chair_strap",  align_struct.origin);
	strap2 = spawn_a_model("p_int_interrogation_chair_strap",  align_struct.origin);
	
	strap1 UseAnimTree(level.scr_animtree["int_straps"] );
	strap1.animname = "int_straps";
	
	strap2 UseAnimTree(level.scr_animtree["int_straps"] );
	strap2.animname = "int_straps";
	
	align_struct thread anim_first_frame(strap1, "int_straps_open_l");
	align_struct thread anim_first_frame(strap2, "int_straps_open_r");
	
	flag_wait("player_realeased_anims_go");
	align_struct thread anim_single_aligned(strap1, "int_straps_open_l");
	
	flag_wait("mason_punch_go");
	align_struct thread anim_single_aligned(strap2, "int_straps_open_r");
}

e1_hudson_open_door()
{
	
	door = GetEnt("int_room_door", "targetname");
	door.animname = "int_door";
	self thread origin_animate_jnt_aligned(door, "int_door_open");
	level notify("out_of_chair_vision");
}

e1_shrink_viewclamp()
{
	target_clamp = 11;
	current_clamp = 60;
	counter = 0;
	while(current_clamp > target_clamp)
	{
		dclamp = current_clamp;
		if (current_clamp > 45)
		{
			dclamp = 45;
		}
		current_clamp -= .5;
		get_players()[0] playerlinktodelta(level.player_hands, "tag_camera", 0, current_clamp, current_clamp, current_clamp, dclamp);
		wait 0.05;
	}
}

e3_brainwash_vignette()
{
	align_struct = getstruct("brainwash_align_struct", "targetname");

	kravchenko = get_ai("kravchenko");
	dragovich = get_ai("dragovich");
	steiner = get_ai("steiner");
	mason = get_ai("mason");
	
	guys[0] =  kravchenko;
	guys[1] =  dragovich;
	guys[2] =  steiner;
	guys[3] =  mason;
	
	align_struct thread anim_loop_aligned( guys, "brainwash_loop", undefined, "stoploop");
	
	flag_wait("in_brainwash_room");
	align_struct notify ("stoploop");
	//thread e3_brainwash_straps();
	
	time = GetAnimLength(level.scr_anim[guys[0].animname]["brainwash_room"]);
	align_struct thread anim_single_aligned( guys, "brainwash_room");
	wait time - 4;
	flag_set("morgue_dialogue_done");
}

e3_brainwash_straps()
{
	align_struct = getstruct("brainwash_align_struct", "targetname");
		
	strap1 = spawn_a_model("p_int_interrogation_chair_strap",  align_struct.origin);
	strap2 = spawn_a_model("p_int_interrogation_chair_strap",  align_struct.origin);
	
	strap1 UseAnimTree(level.scr_animtree["int_straps"] );
	strap1.animname = "int_straps";
	
	strap2 UseAnimTree(level.scr_animtree["int_straps"] );
	strap2.animname = "int_straps";
	
	align_struct thread anim_single_aligned(strap1, "brainwash_strap_l");
	align_struct thread anim_single_aligned(strap2, "brainwash_strap_r");
}

e8_reznov_brainwash()
{
	align_struct = getstruct("brainwash_align_struct", "targetname");
	thread int_esc_play_movie("int_shocking_1");


	reznov = get_ai("brainwash_reznov_ai", "targetname");
	reznov.animname = "generic";
	
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.animname = "player";
	level.player_hands UseAnimTree( level.scr_animtree["player"] );
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	reznov2 = simple_spawn_single("brainwash_reznov2");
	reznov2 Hide();
	reznov2.animname = "generic";

	align_struct thread anim_first_frame_delayed(reznov2, "reznov_brainw_2", 2);

	align_struct thread anim_single_aligned(level.player_hands, "reznov_brainw_1");
	align_struct anim_single_aligned(reznov, "reznov_brainw_1");
	reznov2 Show();

	
	int_esc_play_movie("int_shocking_2");
	reznov Hide();
	
	align_struct thread anim_single_aligned(level.player_hands, "reznov_brainw_2");
	align_struct anim_single_aligned(reznov2, "reznov_brainw_2");
	get_players()[0] SetBlur (20, 0.1);
	
	if (!flag("playing_dks"))
	{
		get_players()[0] thread line_please("all_must_die");
		int_esc_play_movie("int_drag_krav_stein_flash", false, false);
		flag_set("e8_reznov_brainwash_done");
	}
	flag_wait("e8_reznov_brainwash_done");
	

	get_players()[0] SetBlur (0, 3.5);
}

e8_hudson_vignette()
{
	get_players()[0] thread e8_hudson_vignette_playeranims();
	flag_wait("e8_hudson_grabbed_player");
	
	level.hudson.animname = "generic";
	level.hudson HidePart( "J_Helmet");
	
	align_struct = getstruct("e8_hudson_align_struct", "targetname");
	align_struct thread anim_single_aligned(level.hudson, "hudson_punch");
	
	wait 0.65;
	SetTimeScale (0.2);
	wait 0.1;
	SetTimeScale (1);
	
	align_struct thread anim_first_frame_delayed(level.hudson, "hudson_cleared_u", 2);
	
	flag_wait("e8_reznov_brainwash_done");
	
	level.hudson gun_remove();
	level.hudson gun_switchto( "m1911_sp", "right" );
	
	level thread int_esc_play_movie("int_shocking_1");
	wait .2;

	level.hudson gun_remove();
	level.hudson gun_switchto( "m1911_sp", "right" );
	level.hudson HidePart( "J_Helmet");

	flag_set("start_loading_reznov_movie");
	this_anim_length = GetAnimLength( level.scr_anim[level.hudson.animname]["hudson_cleared_u"] );
	align_struct thread anim_single_aligned(level.hudson, "hudson_cleared_u");
	wait(this_anim_length - 0.05);

	flag_wait("reznov_reveal_go");
	align_struct anim_first_frame_delayed(level.hudson, "intro_flashback1", 2);
	level.hudson gun_remove();
	level.hudson gun_switchto( "m1911_sp", "right" );
	level.hudson HidePart( "J_Helmet");

	flag_wait("reznov_reveal_vo_done");
	
	level.hudson gun_remove();
	level.hudson gun_switchto( "m1911_sp", "right" );
	level.hudson HidePart( "J_Helmet");
	
	align_struct anim_single_aligned(level.hudson, "intro_flashback1");
	align_struct anim_first_frame(level.hudson, "intro_flashback2");
	flag_wait("intro_flashback2_go");
	align_struct anim_single_aligned(level.hudson, "intro_flashback2");
	align_struct anim_first_frame(level.hudson, "intro_flashback3");
	flag_wait("intro_flashback3_go");
	align_struct anim_single_aligned(level.hudson, "intro_flashback3");
	align_struct anim_first_frame(level.hudson, "intro_flashback4");
	flag_wait("intro_flashback4_go");
	align_struct anim_single_aligned(level.hudson, "intro_flashback4");
	
	flag_wait("blackroom_vo_done");
	get_players()[0] SetClientDvar("cg_fov", 65);
	level.hudson ShowPart( "J_Helmet" );
	level notify("hudson_control_vision", 0);
	align_struct anim_single_aligned(level.hudson, "outro_flashback");
}

e8_hudson_vignette_playeranims()
{
	flag_wait("e8_hudson_grabbed_player");

	align_struct = getstruct("e8_hudson_align_struct", "targetname");

	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.angles = self.angles;
	level.player_hands.origin = self.origin;
	level.player_hands.animname = "player";
	align_struct anim_first_frame(level.player_hands, "hudson_punch");
	
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	align_struct anim_single_aligned(level.player_hands, "hudson_punch");
	
	level.player_hands Unlink();
	level.player_hands moveto(level.player_hands.origin + (0,0,-600), 3 );
	//get_players()[0] Unlink();
	
	flag_set("e8_brainwash_go");
	flag_wait("e8_reznov_brainwash_done");

	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	time = GetAnimLength(level.scr_anim["player"]["hudson_cleared_u"]);	
	align_struct thread anim_single_aligned(level.player_hands, "hudson_cleared_u");
	wait time - 0.05;
	flag_set("reznov_reveal_go");
	
	flag_wait("reznov_reveal_vo_done");

	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	
	time = GetAnimLength(level.scr_anim["generic"]["intro_flashback1"]);
	align_struct thread anim_single_aligned(level.player_hands, "intro_flashback1");
	wait time - 0.1;
	int_esc_play_movie("int_hudson_explains_1", false, false);
	flag_set("intro_flashback2_go");
	time = GetAnimLength(level.scr_anim["generic"]["intro_flashback2"]);
	align_struct thread anim_single_aligned(level.player_hands, "intro_flashback2");
	wait 1;
	level.fullscreen_cin_hud Destroy();
	level thread play_movie("int_hudson_explains_2", false, false, "hudson_explplains_2_go", false, "hudson_explplains_2_done");
	wait time - 1.1;
	flag_set("hudson_explplains_2_go");
	get_players()[0] FreezeControls(true);
	level waittill("hudson_explplains_2_done");
	flag_set("intro_flashback3_go");
	time = GetAnimLength(level.scr_anim["generic"]["intro_flashback3"]);
	align_struct thread anim_single_aligned(level.player_hands, "intro_flashback3");
	wait time - 0.1;
	create_fullscreen_cinematic_hud();
	int_esc_play_movie("int_hudson_explains_3", false, false);
	flag_set("intro_flashback4_go");
	time = GetAnimLength(level.scr_anim["player"]["intro_flashback4"]);
	align_struct thread anim_single_aligned(level.player_hands, "intro_flashback4");
	wait time - 1;
	thread cover_screen_in_black(1.5, 1, 0);
	//play some number audio
	playsoundatposition ("num_27", (0,0,0));	
	wait 1;
	
	get_players()[0] Unlink();
	flag_set("blackroom_go");
	//level thread e8_snd_number_wait();	
	flag_wait("blackroom_vo_done");

	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	align_struct anim_single_aligned(level.player_hands, "outro_flashback");
}
	
e9_skipto_animation()
{
	align_struct = getstruct("e8_hudson_align_struct", "targetname");

	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.angles = get_players()[0].angles;
	level.player_hands.origin = get_players()[0].origin;
	level.player_hands.animname = "player";
	align_struct anim_first_frame(level.player_hands, "hudson_punch");
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	level.hudson.animname = "generic";
	level.hudson HidePart( "J_Helmet");
	
	align_struct thread anim_single_aligned(level.player_hands, "intro_flashback4");
	time = GetAnimLength(level.scr_anim["generic"]["intro_flashback4"]);
	align_struct thread anim_single_aligned(level.hudson, "intro_flashback4");
	wait time - 1;
	thread cover_screen_in_black(0.5, 1, 0);
	wait 1;
	
	flag_set("blackroom_go");
	
	flag_wait("blackroom_vo_done");
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	align_struct thread anim_single_aligned(level.player_hands, "outro_flashback");

	get_players()[0] SetClientDvar("cg_fov", 65);
	level.hudson ShowPart( "J_Helmet" );
	align_struct anim_single_aligned(level.hudson, "outro_flashback");
}
	
	

player_cam_lock(guy)
{
	target_clamp = 0;
	current_clamp = 11;
	while(current_clamp > target_clamp)
	{
		current_clamp -= 1;
		get_players()[0] playerlinktodelta(level.player_hands, "tag_camera", 0, current_clamp, current_clamp, current_clamp, current_clamp, true);
		wait 0.05;
	}
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
}

player_cam_unlock(guy)
{
	target_clamp = 11;
	current_clamp = 0;
	while(current_clamp < target_clamp)
	{
		current_clamp += 1;
		get_players()[0] playerlinktodelta(level.player_hands, "tag_camera", 0, current_clamp, current_clamp, current_clamp, current_clamp, true);
		wait 0.05;
	}
}

e1_wall_stumble()
{
	trigger_wait("int_escape_obj1_trig1", "targetname");
	align_struct = getstruct("wall_stumble_1", "targetname");
	
	if (IsDefined(level.player_hands))
	{
	
		level.player_hands Delete();
	}
	
	level.player_hands = Spawn_anim_model( "player" );
	level.player_hands Hide();
		
	stop3DCinematic();	
	
	get_players()[0] DisableWeapons();
	wait 0.2;
	level.player_hands.animname = "player";
	align_struct anim_first_frame(level.player_hands, "stumble_wall_l");

	
	level.fullscreen_cin_hud.alpha = 0.7;
	thread play_random_shocking(0.15);
	
	get_players()[0] startcameratween(0.15);
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	time = GetAnimLength(level.scr_anim["player"]["stumble_wall_l"]);
	align_struct thread anim_single_aligned(level.player_hands, "stumble_wall_l");
	wait 0.1;
	level.player_hands Show();
	
	time = time-0.2;
	wait time - 1;
	//thread player_cam_unlock();
	wait 1;
	
	get_players()[0] Unlink();
	level.player_hands Delete();
	show_viewmodel();
}	


e4_wall_stumble()
{
	trigger_wait("e4_wall_stumble_trig", "targetname");
	align_struct = getstruct("e4_wall_stumble_spot", "targetname");
	
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	get_players()[0] DisableWeapons();
	wait 0.2;
	level.player_hands.animname = "player";
	align_struct anim_first_frame(level.player_hands, "stumble_wall_r");
	level.player_hands Hide();
	
	level.fullscreen_cin_hud.alpha = 0.7;
	thread play_random_shocking(0.15);
	
	get_players()[0] startcameratween(0.2);
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	time = GetAnimLength(level.scr_anim["player"]["stumble_wall_r"]);
	wait 0.1;
	
	flag_set("e4_wall_stumble_go");
	align_struct thread anim_single_aligned(level.player_hands, "stumble_wall_r");
	wait 0.1;
	level.player_hands Show();
	
	time = time-0.1;
	wait time - 1;
	//thread player_cam_unlock();
	wait 1;
	
	get_players()[0] Unlink();
	level.player_hands Delete();
	show_viewmodel();
	
	flag_set("e4_wall_stumble_done");
}	



#using_animtree("player");
e2_hall_doors_stumble_playeranim()
{
	hide_viewmodel();
	
	align_struct = getstruct("e2_stumble_1_start", "targetname");
	align_struct thread e2_hall_doors_stumble_objectanim();
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.animname = "player";
	
	align_struct anim_first_frame(level.player_hands, "stumble_double_doors");
	level.player_hands Hide();
	get_players()[0] startcameratween(0.1);
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	//get_players()[0] PlayerLinkToDelta(level.player_hands, "tag_camera", 0, 0, 0, 0, 0);
	
	time = GetAnimLength(level.scr_anim["player"]["stumble_double_doors"]);
	align_struct thread anim_single_aligned(level.player_hands, "stumble_double_doors");
	wait 0.2;
	level.player_hands Show();
	
	wait time - 0.2;
	get_players()[0] Unlink();
	level.player_hands Delete();
	
	show_viewmodel();
}
	
	
#using_animtree("animated_props");
e2_hall_doors_stumble_objectanim()
{
	door_l = GetEnt("hall1_door_l", "targetname");
	door_r = GetEnt("hall1_door_r", "targetname");
	
	door_l.animname = "door_l";
	door_l UseAnimTree( #animtree );
	door_r.animname = "door_r";
	door_r UseAnimTree( #animtree );
	
	
	self thread anim_single_aligned(door_l, "e2_dooropen");
	self thread anim_single_aligned(door_r, "e2_dooropen");
}


e2_stumble_on_cart()
{
	cart = GetEnt("stumble_cart", "targetname");
	cart.animname = "cart";
	//cart UseAnimTree( #animtree );
	self origin_animate_jnt_aligned(cart, "stumble_cart");
	//align_struct thread anim_single_aligned(cart, "stumble_cart");
}

#using_animtree("player");
e2_stumble_on_cart_playeranim()
{
	wait 0.5;
	
	align_struct = getstruct("cart_stumble_align_struct", "targetname");
	
	hide_viewmodel();
	
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.animname = "player";
	
	align_struct anim_first_frame(level.player_hands, "stumble_cart");
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	flag_wait("e2_cart_fall_go");
	
	align_struct thread e2_stumble_on_cart();
	time = GetAnimLength(level.scr_anim["player"]["stumble_cart"]);
	align_struct anim_single_aligned(level.player_hands, "stumble_cart");
	
	get_players()[0] Unlink();
	level.player_hands Delete();
	
	show_viewmodel();
	flag_set("e2_cart_stumble_done");
}



e3_morgue_doors_playeranim()
{
	hide_viewmodel();
	
	align_struct = getstruct("morgue_doors_vin_spot", "targetname");
	align_struct thread e3_morgue_doors_objectanim();
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands.animname = "player";
	
	align_struct anim_first_frame(level.player_hands, "enter_morgue");
	level.player_hands Hide();
	get_players()[0] startcameratween(0.1);
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	time = GetAnimLength(level.scr_anim["player"]["enter_morgue"]);
	align_struct thread anim_single_aligned(level.player_hands, "enter_morgue");
	wait 0.2;
	level.player_hands Show();
	
	wait time - 0.2;
	get_players()[0] Unlink();
	level.player_hands Delete();
	
	show_viewmodel();
	
	flag_set("through_morgue_doors");
}
	
	
#using_animtree("animated_props");
e3_morgue_doors_objectanim()
{
	//level waittill ("open_morgue_doors");
	door_l = GetEnt("morgue_entrance_door_r", "targetname");
	door_r = GetEnt("morgue_entrance_door_l", "targetname");
	
	door_l.animname = "door_l";
	door_l UseAnimTree( #animtree );
	door_r.animname = "door_r";
	door_r UseAnimTree( #animtree );
	
	door_l._org = door_l.origin;
	door_l._ang = door_l.angles;
	
	door_r._org = door_r.origin;
	door_r._ang = door_r.angles;
	
	//self thread origin_animate_jnt_aligned(door_l, "morgue_dooropen");
	//self thread origin_animate_jnt_aligned(door_r, "morgue_dooropen");
	
	self thread anim_single_aligned(door_l, "morgue_dooropen");
	self anim_single_aligned(door_r, "morgue_dooropen");

	wait 10;
	
	door_l Delete();
	door_r Delete();
	
	doors = GetEntArray("morgue_entrance_door_doubles", "targetname");
	doors[0] Show();
	doors[1] Show();
}

first_person_notify(guy)
{
	level notify ("switch_to_FPV");
}

third_person_notify(guy)
{
	level notify ("switch_to_TPV");
}

hudson_punch_notify(guy)
{
	get_players()[0] DoDamage(90, level.hudson GetEye() );
	clientnotify("e8_punch_fov_out");
	Earthquake(1, 0.4, get_players()[0].origin, 500); 
	get_players()[0] PlayRumbleOnEntity("damage_light");
	
	wait 0.8;
	level.fall_to_bed_crossfade FadeOverTime(0.85);
	level.fall_to_bed_crossfade.alpha = 1;	
}

play_dks_must_die(guy)
{
	flag_set("playing_dks");
	get_players()[0] thread line_please("all_must_die");
	int_esc_play_movie("int_drag_krav_stein_flash", false, false);
	flag_set("e8_reznov_brainwash_done");
}

end_level(guy)
{
	level.end_level_hud					 = NewClientHudElem(get_players()[0]);
	level.end_level_hud.x 				 = 0;
	level.end_level_hud.y 			   = 0;
	level.end_level_hud.horzAlign  = "fullscreen";
	level.end_level_hud.vertAlign  = "fullscreen";
	level.end_level_hud.foreground = false; //Arcade Mode compatible
	level.end_level_hud.sort			 = 0;

	level.end_level_hud setShader( "black", 640, 480 );
	level.end_level_hud.alpha = 0;
	
	level.end_level_hud FadeOverTime(1);
	level.end_level_hud.alpha = 1;
	
	wait 1;
	nextmission();
}

e9_short_waco_paco()
{
	if (!IsDefined(level.player_hands_waco))
	{
		level.player_hands_waco = Spawn_anim_model( "player" );
	}
	level.player_hands_waco UseAnimTree(level.scr_animtree["player"] );
	
	player = get_players()[0];
	player.ignoreme = true;
	
	node = getstruct("your_dead_align","targetname");	
	
	kravchenko = simple_spawn_single("airfield_Kravchenko");
	dragovich = simple_spawn_single("airfield_dragovitch");
	castro = simple_spawn_single("airfield_cuba");	
	
	//simple_spawn ("cutscene_extra", ::cutscene_extra_logic); //guys on the ship
		
	castro.animname = "castro";
	dragovich.animname = "dragovich";
	kravchenko.animname = "kravchenko";

	castro.cigar = Spawn( "script_model", ( 0,0,0 ) );
	castro.cigar SetModel("p_glo_cuban_cigar01");
	castro.cigar LinkTo( castro, "tag_weapon_left", ( 0,0,0 ), ( 0,0,0 ) );

	ents = array(castro,dragovich,kravchenko);	
	
	node anim_first_frame(ents,"your_dead");

	node anim_first_frame(level.player_hands_waco, "your_dead");
	
	flag_wait("short_waco_paco_go");
	node thread anim_single_aligned(ents,"your_dead");
	castro SetAnimLimited(level.scr_anim[castro.animname]["your_dead"], 1, 0, 1);
	dragovich SetAnimLimited(level.scr_anim[dragovich.animname]["your_dead"], 1, 0, 1);
	kravchenko SetAnimLimited(level.scr_anim[kravchenko.animname]["your_dead"], 1, 0, 1);
	
	get_players()[0] PlayerLinkToAbsolute(level.player_hands_waco);
	
	wait 5;

	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_flash(0.3, 1.1);
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 1;
	
	wait 0.55;
	
	for (i=0; i < ents.size; i++)
	{
		ents[i] Delete();
	}
	
	level.player_hands_waco StopAnimScripted();
	get_players()[0] Unlink();
	get_players()[0] maps\_art::setdefaultdepthoffield();
	flag_set("short_waco_paco_done");
	thread waco_paco();
	
}


waco_paco()
{
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	level.player_hands UseAnimTree(level.scr_animtree["player"] );
	
	player = get_players()[0];
	player.ignoreme = true;
	
	node = getstruct("your_dead_align","targetname");	
	
	kravchenko = simple_spawn_single("airfield_Kravchenko");
	dragovich = simple_spawn_single("airfield_dragovitch");
	castro = simple_spawn_single("airfield_cuba");	
	
	//simple_spawn ("cutscene_extra", ::cutscene_extra_logic); //guys on the ship
		
	castro.animname = "castro";
	dragovich.animname = "dragovich";
	kravchenko.animname = "kravchenko";

	castro.cigar = Spawn( "script_model", ( 0,0,0 ) );
	castro.cigar SetModel("p_glo_cuban_cigar01");
	castro.cigar LinkTo( castro, "tag_weapon_left", ( 0,0,0 ), ( 0,0,0 ) );

	ents = array(castro,dragovich,kravchenko);	
	
	level._waco_paco_array = ents;
	
	node anim_first_frame(ents,"your_dead");

	
	node thread e9_player_wabo_paco();
	
	/*
	node thread anim_single_aligned(ents,"your_dead");
	
	animtime = GetAnimLength(level.scr_anim[castro.animname]["your_dead"]);
	
	wait 10;
	
	castro SetAnimLimited(level.scr_anim[castro.animname]["your_dead"], 1, 0, 0);
	dragovich SetAnimLimited(level.scr_anim[dragovich.animname]["your_dead"], 1, 0, 0);
	kravchenko SetAnimLimited(level.scr_anim[kravchenko.animname]["your_dead"], 1, 0, 0);
	*/
	animtime = GetAnimLength(level.scr_anim[castro.animname]["your_dead"]);
	flag_wait("waco_paco_full_go");
	wait 1.1;
	node thread anim_single_aligned(ents,"your_dead");
	
	castro SetAnimLimited(level.scr_anim[castro.animname]["your_dead"], 1, 0, 1);
	dragovich SetAnimLimited(level.scr_anim[dragovich.animname]["your_dead"], 1, 0, 1);
	kravchenko SetAnimLimited(level.scr_anim[kravchenko.animname]["your_dead"], 1, 0, 1);
	
	near_blur = 4;
	far_blur = 0.53;
	near_start = 0;
	near_end = 6;
	far_start = 190;
	far_end = 415;
	get_players()[0] SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur );
	
	wait animtime - 1;
	
	for (i=0; i < ents.size; i++)
	{
		ents[i] Delete();
	}
	

		
	wait 1.8;

	thread cover_screen_in_black(0.5, 0.7, 0.2);
	
	wait 0.7;

	player = get_players()[0];
	player maps\_art::setdefaultdepthoffield();


	wait 0.2;
	
	flag_set("blackroom_vo_done");
	
	get_players()[0] Unlink();
}

e9_player_wabo_paco()
{
	flag_wait("waco_paco_full_go");
	self anim_first_frame(level.player_hands,"your_dead");
	wait 1;
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	self anim_single_aligned(level.player_hands,"your_dead");
}

e9_steiner_emit_numbers()
{
	PlayFXOnTag (level._effect["steiner_numbers"], self, "J_Shoulder_LE");
	PlayFXOnTag (level._effect["steiner_numbers"], self, "J_Elbow_LE");
	PlayFXOnTag (level._effect["steiner_numbers"], self, "J_Neck");
}


e9_brainwash_vignette()
{
	guys = simple_spawn("blackroom_brainwash_spawners");
	align_struct = getstruct("blackroom_brainwash_align_struct", "targetname");

	table = GetEnt("blackroom_brainwash_table", "targetname");
	table Show();
	
	steiner = get_ai("br_steiner");
	mason = get_ai("br_mason");
	
	guys[0] =  mason;
	guys[1] =  steiner;
	
	steiner thread e9_steiner_emit_numbers();
	
	align_struct thread anim_loop_aligned( guys, "brainwash_loop", undefined, "stoploop");
	
	wait 1;
	align_struct notify ("stoploop");
	
	time = GetAnimLength(level.scr_anim[guys[0].animname]["brainwash_room"]);
	align_struct thread anim_single_aligned( guys, "brainwash_room");
	
	
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 0.3;
	wait 0.45;
	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_bink(0.3, "stop_numbers_bink");
	
	wait 6.5;
	
	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_flash(0.3, undefined, "stop_numbers_bink");
	level.fullscreen_cin_hud FadeOverTime(1);
	level.fullscreen_cin_hud.alpha = 1;
	
	wait 1;
	
	for (i=0; i < guys.size; i++)
	{
		guys[i] StopAnimScripted();
		guys[i] Delete();
	}
	table Delete();
	level.player_hands Hide();
	thread warpto_blackroom_spot();
	
	wait 0.3;
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 0.3;
	
	wait 0.45;
	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_bink(0.3, "stop_numbers_bink");
}


smash_tv_notify(guy)
{
	fxtv = GetEnt("fxanim_escape_ui_throw_mod", "targetname");
	uitv = GetEnt("monitor_ui3d_01", "targetname");
	uitv LinkTo(fxtv, "monitor_menu_jnt");
	level notify ("ui_throw_start");
	
	ents = GetEntArray("left_tv_anim_extra_props", "targetname");
	for (i=0; i < ents.size; i++)
	{
		ents[i] Delete();
	}
	
	exploder(101);
}

tv_wall_notify(guy)
{
	tvmod = GetEnt("fxanim_escape_wall_fall_mod", "targetname");
	
	for (i=1; i < 7; i++)
	{
		tv = GetEnt("monitor_0"+i, "targetname");
		tv LinkTo(tvmod, tv.targetname+"_jnt");
	}
	
	level notify ("tv_wall_start");
	exploder(102);
	thread tv_02_impact();
	
	ents = GetEntArray("tv_wall_anim_extra_props", "targetname");
	for (i=0; i < ents.size; i++)
	{
		ents[i] Delete();
	}
}

tv_06_impact(guy)
{
	tv = GetEnt("monitor_06", "targetname");
	tv SetModel("p_dest_int_monitors01_b");
}
	
tv_04_impact(guy)
{
	exploder(103);
	tv = GetEnt("monitor_04", "targetname");
	tv SetModel("p_dest_int_monitors01_c");
}

tv_01_impact(guy)
{
	exploder(104);
	tv = GetEnt("monitor_01", "targetname");
	tv SetModel("p_dest_int_monitors01_a");
}

	
tv_02_impact(guy)
{
	tv = GetEnt("monitor_02", "targetname");
	tv SetModel("p_dest_int_monitors01_c");
}

new_relationship_said(guy)
{
	level notify("new_relationship_said");
}