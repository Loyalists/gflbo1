#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree ("generic_human");
main()
{
	precache_actor_anims();
	precache_player_anims();
	precache_vehicle_anims();
	precache_object_anims();
	precache_critter_anims();
	precache_fx_anims();
	
	precache_vo();
}



precache_vo()
{
	//////////////////////
	// FINAL DIALOGUE
	//////////////////////
	
	// Docks
	level.scr_sound["mason_vo_ent"]["intro_vo"] = "vox_reb1_s01_700A_maso"; //I arrived with Reznov at Rebirth Island. Finally. Steiner was ours.
	level.scr_sound["crate_kill_worker"]["crate_drop_1"] = "vox_reb1_s01_001A_sgu2_m"; //"(Translated) A little more....";
  level.scr_sound["reznov"]["look_docks_1"] = "vox_reb1_s01_002A_rezn_m"; //"We are here.";
  level.scr_sound["crate_kill_worker"]["crate_drop_2"] = "vox_reb1_s01_003A_sgu2_m"; //"(Translated) Yes... Keep coming...";
  level.scr_sound["reznov"]["look_docks_2"] = "vox_reb1_s01_004A_rezn_m"; //"Rebirth Island... Source of Dragovich's poison.";
  level.scr_sound["crate_kill_worker"]["crate_drop_3"] = "vox_reb1_s01_005A_sgu2_m"; //"(Translated) You're good.";
  level.scr_sound["reznov"]["look_docks_3"] = "vox_reb1_s01_006A_rezn_m"; //"They are preparing to deliver Nova six.";
  level.scr_sound["mason"]["not_on_my_watch"] = "vox_reb1_s01_706A_maso"; //Not on my watch.
  level.scr_sound["crate_kill_worker"]["crate_investigate_1"] = "vox_reb1_s01_007A_sgu1_m"; //"(Translated) More fucking Monkeys... Don't we have enough?";
  level.scr_sound["worker"]["crate_investigate_2"] = "vox_reb1_s01_008A_sgu2_m"; //"(Translated) Just get it unloaded, Yuri.  Our orders are to make room for equipment.";
  level.scr_sound["crate_kill_worker"]["crate_investigate_3"] = "vox_reb1_s01_009A_sgu1_m"; //"(Translated) Shit...";
  level.scr_sound["worker"]["crate_investigate_4"] = "vox_reb1_s01_010A_sgu2_m"; //"(Translated) Quit complaining and get the cages on the dock... I have to check the rest of the Cargo.";
  level.scr_sound["reznov"]["crate_kill"] = "vox_reb1_s01_011A_rezn_m"; //"Kill him, Mason.";
  level.scr_sound["reznov"]["take_hatchet"] = "vox_reb1_s99_308A_rezn"; //Take the hatchet.
  level.scr_sound["reznov"]["first_run_1"] = "vox_reb1_s01_012A_rezn"; //"We are outnumbered, Mason.";
  level.scr_sound["reznov"]["first_run_2"] = "vox_reb1_s01_013A_rezn"; //"We must not attract attention.";
  level.scr_sound["reznov"]["first_cover_1"] = "vox_reb1_s01_014A_rezn"; //"Stick to the shadows - avoid the helicopter's spotlight.";
  level.scr_sound["crate_kill_worker"]["crate_spotted_player"] = "vox_reb1_s99_314A_sgu2"; //(Translated) Who are you? INTRUDERS!
  // level.scr_sound["reznov"]["first_cover_2"] = "vox_reb1_s01_015A_rezn"; //"Wait until it passes.";
  level.scr_sound["reznov"]["second_run"] = "vox_reb1_s01_016A_rezn"; //"Go - Quickly.";
  level.scr_sound["loudspeaker"]["second_cover_1"] = "vox_reb1_s01_021A_rus1_f"; //"(Translated) Attention! All personnel with level three clearance - proceed to dock two.  Ship will depart in five minutes.";
  level.scr_sound["loudspeaker"]["second_cover_2"] = "vox_reb1_s01_022A_rus1_f"; //"(Translated) Levels one and two personnel - await further announcements.";
  level.scr_sound["loudspeaker"]["second_cover_3"] = "vox_reb1_s01_023A_rus1_f"; //"(Translated) Lockdown of sector E begins in three minutes.";
  level.scr_sound["reznov"]["second_cover_4"] = "vox_reb1_s01_024A_rezn"; //"They are beginning to evacuate the facility...";
  level.scr_sound["mason"]["second_cover_5"] = "vox_reb1_s01_025A_maso"; //"They know we're here...";
  level.scr_sound["hatchet_chop_guard"]["hatchet_kill_1"] = "vox_reb1_s01_026A_sgu3"; //"(Translated) Are we certain it is the Americans?";
  level.scr_sound["hatchet_chop_guard"]["hatchet_kill_2"] = "vox_reb1_s01_027A_sgu3"; //"(Translated) I see... Yes, Sir - Understood.  I will relay the message.";
  level.scr_sound["reznov"]["hatchet_kill_3"] = "vox_reb1_s01_028A_rezn"; //"Mason... Silence him.";
  level.scr_sound["reznov"]["hatchet_kill_4"] = "vox_reb1_s01_029A_rezn"; //"Mason!";
  level.scr_sound["reznov"]["third_run_1"] = "vox_reb1_s01_030A_rezn"; //"Good my friend. Follow me.";
  level.scr_sound["reznov"]["third_run_2"] = "vox_reb1_s01_031A_rezn"; //"The chopper is coming around again.";
  level.scr_sound["reznov"]["third_run_3"] = "vox_reb1_s01_032A_rezn"; //"We must find another hiding place.";
  level.scr_sound["reznov"]["third_run_4"] = "vox_reb1_s01_033A_rezn"; //"Avoid the light.";
  // level.scr_sound["reznov"]["third_run_5"] = "vox_reb1_s01_034A_rezn"; //"Wait... stay where you are.";
  level.scr_sound["reznov"]["lab_approach_1"] = "vox_reb1_s01_035A_rezn"; //"It did not see us.";
  level.scr_sound["reznov"]["lab_approach_2"] = "vox_reb1_s01_036A_rezn"; //"This way, up the stairs.";
  level.scr_sound["radio_guard"]["pull_down_1"] = "vox_reb1_s01_037A_sgu2_f"; //"(Translated) Bolonksi - Why aren't you at your post?";
  level.scr_sound["pull_down_guard"]["pull_down_2"] = "vox_reb1_s01_038A_sgu4"; //"(Translated) I'll be there in a minute... We're all leaving anyway.";
  level.scr_sound["pull_down_guard"]["pull_down_3"] = "vox_reb1_s01_039A_sgu4"; //"(Translated) Wait a second... I need to check on something.";
  level.scr_sound["reznov"]["pull_down_4"] = "vox_reb1_s01_040A_rezn"; //"Good... Very good.";
  level.scr_sound["reznov"]["distant_explosion_1"] = "vox_reb1_s01_041A_rezn"; //"We should be able to access Steiner's lab from the roof...";
  level.scr_sound["reznov"]["distant_explosion_2"] = "vox_reb1_s01_042A_rezn"; //"We are getting close, Mason.";
  level.scr_sound["loudspeaker"]["distant_explosion_3"] = "vox_reb1_s01_043A_rus1_f"; //"(Translated) All teams we have a security breach at the north east perimeter. Report to your commanding officer immediately.";
  level.scr_sound["reznov"]["distant_explosion_4"] = "vox_reb1_s01_044A_rezn"; //"They are on full alert.";
  level.scr_sound["mason"]["distant_explosion_5"] = "vox_reb1_s01_045A_maso"; //"It's the CIA... They want Steiner alive.";
  level.scr_sound["reznov"]["distant_explosion_6"] = "vox_reb1_s01_046A_rezn"; //"Then we must make sure we reach him first.";
  // level.scr_sound["reznov"]["distant_explosion_7"] = "vox_reb1_s01_047A_rezn"; //"A target of opportunity Mason. Aim true.";
  level.scr_sound["loudspeaker"]["distant_explosion_8"] = "vox_reb1_s01_048A_rus1_f"; //"(Translated) Security personnel have been instructed to escort non-combatant individuals to the assembly areas.";
  level.scr_sound["reznov"]["elevator_1"] = "vox_reb1_s01_049A_rezn"; //"Follow me. We will use the elevator shaft.";
  level.scr_sound["loudspeaker"]["elevator_2"] = "vox_reb1_s02_050A_rus1_f"; //"(Translated) All laboratory personnel are to proceed to their designated areas. This facility is now under military protocol. Any personal not following procedure will be arrested immediately.";
  level.scr_sound["reznov"]["elevator_3"] = "vox_reb1_s02_051A_rezn"; //"This way...";
  //level.scr_sound["elevator_talk_guard"]["elevator_4"] = "vox_reb1_s02_052A_sgu1_m"; //"(Translated) There has been an incident.  Steiner has ordered the evacuation of the site.";
  //level.scr_sound["elevator_talk_scientist"]["elevator_5"] = "vox_reb1_s02_053A_svsc_m"; //"(Translated) Incident?  We have not seen any sensors go off in the labs.";
  //level.scr_sound["elevator_talk_guard"]["elevator_6"] = "vox_reb1_s02_054A_sgu1_m"; //"(Translated) The problem is in the town.";
  //level.scr_sound["elevator_talk_scientist"]["elevator_7"] = "vox_reb1_s02_055A_svsc_m"; //"(Translated) My family is there... What about them?";
  level.scr_sound["reznov"]["elevator_8"] = "vox_reb1_s02_056A_rezn_m"; //"Shoot now...";
  // level.scr_sound["elevator_talk_guard"]["elevator_9"] = "vox_reb1_s02_057A_sgu1_m"; //"(Translated) My orders are to escort key staff to the boats... Another team is taking care of the civilians.";
  level.scr_sound["loudspeaker"]["elevator_10"] = "vox_reb1_s02_058A_rus1_f"; //"(Translated) This is a priority one alert. All security teams are to report to their commanding officers. This facility is now under military protocol.";
	level.scr_sound["reznov"]["stealth_warn_1"] = "vox_reb1_s01_017A_rezn"; //"Mason, stay with me!";
  level.scr_sound["reznov"]["stealth_warn_2"] = "vox_reb1_s01_018A_rezn"; //"Mason, you will be seen! Keep close!";
  level.scr_sound["reznov"]["stealth_warn_3"] = "vox_reb1_s01_019A_rezn"; //"Where are you going? Stick to the plan!";
  level.scr_sound["reznov"]["stealth_warn_4"] = "vox_reb1_s01_020A_rezn"; //"We cannot allow ourselves be seen! Stay low!";
  level.scr_sound["reznov"]["stealth_broken"] = "vox_reb1_s99_311A_rezn"; //"You've been spotted!"

  // Mason Lab
  level.scr_sound["base_loudspeaker"]["priority_one_alert"] = "vox_reb1_s02_058A_rus1_f"; //(Translated) This is a priority one alert. All security teams are to report to their commanding officers. This facility is now under military protocol.
  level.scr_sound["reznov"]["get_door_open"] = "vox_reb1_s02_059A_rezn"; //We need to get this door open.
  level.scr_sound["mason"]["i_got_it"] = "vox_reb1_s02_060A_maso"; //I got it.
  level.scr_sound["reznov"]["be_cautious"] = "vox_reb1_s02_061A_rezn"; //Be cautious my friend...
  level.scr_sound["mason"]["mason_this_is_hudson"] = "vox_reb1_s01_707A_huds_f"; //Mason, this is Hudson. We know you're on Rebirth Island. Talk to me Mason.
  level.scr_sound["hudson"]["hudson_this_is_hudson"] = "vox_reb1_s03_707A_huds"; //Mason, this is Hudson. We know you're on Rebirth Island. Talk to me Mason.
  level.scr_sound["base_loudspeaker"]["remain_calm"] = "vox_reb1_s02_062A_rus1_f"; //(Translated) Remain calm. The Rebirth Island security forces will assist you in evacuating the facility. Any personnel not following procedure will be arrested immediately.
  level.scr_sound["reznov"]["lets_end_this"] = "vox_reb1_s02_063A_rezn_m"; //Let us end this...
  level.scr_sound["steiner"]["yes_dragovich"] = "vox_reb1_s02_064A_stei_m"; //Yes Dragovich, the Americans believe Rebirth is the real threat...
  level.scr_sound["steiner"]["taken_necessary_steps"] = "vox_reb1_s02_065A_stei_m"; //We have taken all necessary steps.
  level.scr_sound["steiner"]["see_you_at_rusalka"] = "vox_reb1_s02_066A_stei_m"; //I will see you at the Rusalka in time for the broadcast.
  level.scr_sound["mason"]["friedrich_steiner"] = "vox_reb1_s02_067A_huds_f_m"; //Friedrich Steiner
  level.scr_sound["steiner"]["you"] = "vox_reb1_s02_068A_stei_m"; //You..?!!!
  level.scr_sound["steiner"]["aaaack"] = "vox_reb1_s02_069A_stei_m"; //Aaaack!
  level.scr_sound["steiner"]["i_know_you"] = "vox_reb1_s02_070A_stei_m"; //I know you... Vorkuta!
  level.scr_sound["steiner"]["you_dont_know"] = "vox_reb1_s02_071A_stei_m"; //You don't know...
  level.scr_sound["steiner"]["what_we_did"] = "vox_reb1_s02_072A_stei_m"; //What we did to you...
  level.scr_sound["steiner"]["how_broken_you_are"] = "vox_reb1_s02_073A_stei"; //You don't know how broken you are!
  level.scr_sound["hudson"]["mason_talk_to_me"] = "vox_reb1_s02_074A_huds_f_m"; //Mason, talk to me!
  level.scr_sound["reznov"]["your_evil"] = "vox_reb1_s02_075A_rezn_m"; //Your evil has claimed the lives of many good men...
  level.scr_sound["reznov"]["no_longer"] = "vox_reb1_s02_076A_rezn_m"; //No longer.
  level.scr_sound["steiner"]["wont_stop_nova"] = "vox_reb1_s02_077A_stei_m"; //Killing me won't stop Nova!
  level.scr_sound["reznov"]["dont_care_nova"] = "vox_reb1_s02_078A_rezn_m"; //I do not care about Nova.
  level.scr_sound["reznov"]["my_name_is"] = "vox_reb1_s02_079A_rezn_m"; //My name is Viktor Reznov.
  level.scr_sound["steiner"]["no"] = "vox_reb1_s02_080A_stei_m"; //No...
  level.scr_sound["reznov"]["have_my_revenge"] = "vox_reb1_s02_081A_rezn_m"; //And I will have my revenge.
  level.scr_sound["mason_flashback"]["i_swear"] = "vox_reb1_s01_701A_maso"; //I swear to God, that's how Steiner died. Reznov killed him right in front of me!
  level.scr_sound["interrogator_flashback"]["you_killed_steiner_a"] = "vox_reb1_s01_702A_inte"; //You're lying Mason. You killed Steiner. We know you did.
  //level.scr_sound["interrogator_flashback"]["you_killed_steiner_b"] = "vox_reb1_s01_702B_inte"; //You're lying Mason. You killed Steiner. We know you did.
  level.scr_sound["mason_flashback"]["reznov_got_revenge"] = "vox_reb1_s01_703A_maso"; //Reznov got exactly what he wanted. Revenge.
  level.scr_sound["interrogator_flashback"]["hudson_filed_his_report_a"] = "vox_reb1_s01_704A_inte"; //Jason Hudson filed his report Mason. Viktor Reznov did not kill Friedrich Steiner. Hudson saw what happened.
  //level.scr_sound["interrogator_flashback"]["hudson_filed_his_report_b"] = "vox_reb1_s01_704B_inte"; //Jason Hudson filed his report Mason. Viktor Reznov did not kill Friedrich Steiner. Hudson saw what happened.
  
 	
  /*
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_140A_weav"; //All right. That's the bio-lab. Looks like they're waiting for us.
  level.scr_sound["Hudson"]["anime"] = "vox_reb1_s03_141A_huds"; //Move out. Stay low.
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_142A_weav"; //Weapons free! Weapons free!
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_143A_weav"; //Hudson, flank left with me. There is cover!
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_144A_weav"; //In here. This is where Steiner will be.
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_145A_weav"; //This way. The bio-lab is below us.
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_146A_weav"; //We need to pass through decontamination.
  level.scr_sound["Weaver"]["anime"] = "vox_reb1_s03_147A_weav"; //Let's go find Steiner.
  level.scr_sound["Hudson"]["anime"] = "vox_reb1_s03_148A_huds"; //Mason, this is Hudson. Are you there?
  */
  //Event 5
  level.scr_sound["hudson"]["its_him"] = "vox_reb1_s03_149A_huds"; //It's him...
  level.scr_sound["weaver"]["what_the_hell"] = "vox_reb1_s03_150A_weav"; //What the Hell is he doing?
  level.scr_sound["hudson"]["killing_everyone"] = "vox_reb1_s03_151A_huds"; //Killing everyone between him and Steiner.
  level.scr_sound["weaver"]["what_the_hell_was_that"] = "vox_reb1_s99_316A_weav_f"; //What the hell was that?
  level.scr_sound["hudson"]["it_is_steiner"] = "vox_reb1_s99_317A_huds"; //It's Steiner - he's trying to contact us. Steiner, what's the situation?
  level.scr_sound["hudson"]["what_is_the_situtation"] = "vox_reb1_s99_317B_huds"; //* Steiner! What's the situation?
  level.scr_sound["hudson"]["drag_round_up"] = "vox_reb1_s03_300A_stei_f"; //Dragovich's men are rounding up everyone on the island...
  level.scr_sound["hudson"]["those_no_longer"] = "vox_reb1_s03_301A_stei_f"; //Those no longer essential to his plans are being executed!
  level.scr_sound["hudson"]["you_must_hurry"] = "vox_reb1_s03_302A_stei_f"; //You must hurry, before they kill me too!
  level.scr_sound["mason"]["this_is_the_end"] = "vox_reb1_s03_303A_maso_f"; //* Friedrich Steiner. This is the end.
  //level.scr_sound["Hudson"]["anime"] = "vox_reb1_s03_152A_huds"; //Mason, talk to me!
  level.scr_sound["weaver"]["where_are_they_going"] = "vox_reb1_s99_313A_weav"; //Hudson, where are they going?
  level.scr_sound["hudson"]["did_not_see_us"] = "vox_reb1_s99_314A_weav"; //They didn't see us.
  //level.scr_sound["Hudson"]["anime"] = "vox_reb1_s03_153A_huds"; //MASON!
  level.scr_sound["weaver"]["hudson_stop_carter"] = "vox_reb1_s03_154A_weav"; //We have to stop him NOW!
  //level.scr_sound["Hudson"]["what_are_you_doing"] = "vox_reb1_s03_155A_huds"; //Mason! What are you doing! We need him alive!
  level.scr_sound["weaver"]["weaver_help_break_window"] = "vox_reb1_s03_156A_weav_m"; //Help me!
  //level.scr_sound["Mason"]["will_have_my_revenge"] = "vox_reb1_s03_157A_maso"; //I will have my revenge!
  //level.scr_sound["Hudson"]["mason_no"] = "vox_reb1_s03_158A_huds"; //Mason - NO!
  //level.scr_sound["Weaver"]["fine_check_steiner"] = "vox_reb1_s03_159A_weav_m"; //I'm fine, check Steiner!
  //level.scr_sound["US Marine"]["dead"] = "vox_reb1_s03_160A_red2_m"; //Dead.
 // level.scr_sound["Weaver"]["what_about_reznov"] = "vox_reb1_s03_161A_weav_m"; //What about Reznov, the defector? We need to find him.
  level.scr_sound["hudson"]["we_wont"] = "vox_reb1_s03_162A_huds_m"; //We won't. He was never here.
  level.scr_sound["hudson"]["didnt_believe_it"] = "vox_reb1_s03_163A_huds_m"; //I didn't believe till I saw with my own eyes...
  level.scr_sound["hudson"]["it_was_vorkuta"] = "vox_reb1_s03_164A_huds_m"; //It was Vorkuta... Where project Nova began...
  //level.scr_sound["Weaver"]["hes_our_only_link"] = "vox_reb1_s03_165A_weav_m"; //He's our only link to the numbers broadcasts.
  level.scr_sound["hudson"]["bring_him_back"] = "vox_reb1_s03_166A_huds_m"; //We need to bring him back...
  //level.scr_sound["Weaver"]["then_lets_go"] = "vox_reb1_s03_167A_weav_m"; //Then let's go.
  level.scr_sound["weaver"]["this_way_to_dock"] = "vox_reb1_s03_168A_weav"; //This way. It will take us to the dock. This is Weaver. We have the package.... We are on our way.
  level.scr_sound["us pilot"]["taking_the_docks_now"] = "vox_reb1_s03_169A_usp1_f"; //Copy that Weaver. We are taking the docks now.
  level.scr_sound["us pilot"]["you_are_clear"] = "vox_reb1_s03_170A_usp1_f"; //You are clear Weaver.
  level.scr_sound["weaver"]["on_our_way"] = "vox_reb1_s03_171A_weav"; //On our way. Let's go.
  level.scr_sound["weaver"]["watch_him"] = "vox_reb1_s03_172A_weav"; //Watch him...
  level.scr_sound["hudson"]["what_did_they_do"] = "vox_reb1_s03_173A_huds"; //What did they do to you, Mason?
	
	// Docks - Context specific stealth lines
	level.scr_sound["reznov"]["reznov_warn1"]								= "Mason, stay with me!";
	level.scr_sound["reznov"]["reznov_warn2"]								= "Mason, you will be seen! Keep close!";
	level.scr_sound["reznov"]["reznov_warn3"]								= "Where are you going? Stick to the plan!";
	level.scr_sound["reznov"]["reznov_warn4"]								= "We cannot allow ourselves be seen! Stay low!";
	level.scr_sound["reznov"]["reznov_cover_warn"]					= "Wait... stay where you are.";
	level.scr_sound["reznov"]["reznov_stealth_broken"] 		 	= "We've been spotted, it's over";
	
	// Deprecated Dock lines, keeping for reference for the moment
	level.scr_sound["reznov"]["reznov_wait_for_crane"] 		 	= "Helicopter on the left.  Quick, under here";
	level.scr_sound["reznov"]["reznov_crane_done"] 				 	= "Ok, lets move";
	level.scr_sound["reznov"]["reznov_do_stealth_kill"] 		= "There is a guard ahead.  Sneak up and use your knife";
	level.scr_sound["reznov"]["reznov_good_kill"] 					= "Good.  Grab his gun and get over to the catwalk, lets move";
	level.scr_sound["reznov"]["reznov_another_heli"]				= "Another helicopter.  Quick, this way";
	level.scr_sound["reznov"]["reznov_heli2_passed"]				= "Clear, lets go";
	level.scr_sound["reznov"]["reznov_climb_cliff"] 				= "Up the ladder";	
	level.scr_sound["reznov"]["reznov_climb_pipe"] 					= "I'll move this box so we can reach the ladder";
	level.scr_sound["reznov"]["reznov_heli_takeoff"] 				= "Looks like we aren't the only ones after Steiner.";
	level.scr_sound["reznov"]["reznov_top_of_elevator"] 		= "Use these elevator cables to get down";
	level.scr_sound["reznov"]["reznov_elevator_top"] 				= "Climb down these cables.  Be Quiet";
	level.scr_sound["reznov"]["reznov_in_elevator"] 				= "Now we must find Steiner's Office";	
	
	// BTR Rail
	level.scr_sound["hudson"]["btr_weaver"] = "vox_reb1_s03_082A_huds"; //Weaver!
	level.scr_sound["weaver"]["go_ahead"] = "vox_reb1_s03_083A_weav_f_m"; //Go ahead Hudson.
//	level.scr_sound["hudson"]["research_facility"] = "vox_reb1_s03_084A_huds"; //We need to work our way through to the research facility. Protect our six!
	level.scr_sound["hudson"]["research_facility"] = "vox_reb1_s03_085A_huds"; //Mason's still dark. We work our way through to the research facility and extract Steiner.  Watch your backs.
//	level.scr_sound["hudson"]["anime"] = "vox_reb1_s03_085A_huds"; //We need to work our way through to the research facility. Keep us covered.
	level.scr_sound["weaver"]["were_moving"] = "vox_reb1_s03_086A_weav_f"; //Yankee Squad, we're moving!
	level.scr_sound["hudson"]["lets_roll"] = "vox_reb1_s03_087A_huds"; //Alpha Squad, let's roll.
	level.scr_sound["redshirt_1"]["on_the_move"] = "vox_reb1_s03_088A_uss1_f"; //Copy that we are on the move.
	level.scr_sound["weaver"]["evacuate"] = "vox_reb1_s03_089A_weav_f"; //They've already begun to evacuate.
	level.scr_sound["hudson"]["massacre"] = "vox_reb1_s03_090A_huds"; //It's not an evacuation... It's a massacre.
	level.scr_sound["hudson"]["noone_alive"] = "vox_reb1_s03_091A_huds"; //Making sure no one's alive to tell us anything.
	level.scr_sound["weaver"]["hard_right"] = "vox_reb1_s03_092A_weav_f"; //Hard right! That leads to the bio-lab.
	level.scr_sound["weaver"]["twelve_oclock"] = "vox_reb1_s03_093A_weav_f"; //Enemy vehicle 12 o'clock.
	level.scr_sound["weaver"]["main_drive"] = "vox_reb1_s03_094A_weav_f"; //That's the main drive up to the laboratories. Yankee Squad will flank west and meet you there.
	level.scr_sound["hudson"]["understood"] = "vox_reb1_s03_095A_huds"; //Understood. Alpha squad, move up!
	level.scr_sound["redshirt_1"]["were_moving"] = "vox_reb1_s03_096A_uss1_f"; //We're moving.
	level.scr_sound["redshirt_2"]["balcony"] = "vox_reb1_s03_097A_uss1_f"; //Enemy targets, on the balcony.
	level.scr_sound["weaver"]["moltovs"] = "vox_reb1_s03_098A_weav_f"; //Molotovs! On the roof!
	level.scr_sound["hudson"]["moltovs"] = "vox_reb1_s03_099A_huds"; //Mason!  Take out those Molotovs!
	level.scr_sound["hudson"]["rpgs"] = "vox_reb1_s03_100A_huds"; //RPGS!!!
	level.scr_sound["hudson"]["damn_rpgs"] = "vox_reb1_s03_101A_huds"; //Take out those damn RPGs!
	level.scr_sound["weaver"]["left_side"] = "vox_reb1_s03_102A_weav_f"; //Left side!!
	level.scr_sound["weaver"]["right_side"] = "vox_reb1_s03_103A_weav_f"; //Right side!!
	level.scr_sound["redshirt_1"]["on_road"] = "vox_reb1_s03_104A_uss1_f"; //Multiple contacts on the road.
	level.scr_sound["redshirt_2"]["inbound"] = "vox_reb1_s03_105A_uss1_f"; //Hudson, recon reports MI-24's inbound on our position.
	level.scr_sound["hudson"]["pick_it_up"] = "vox_reb1_s03_106A_huds"; //Understood. Let's pick it up.
	level.scr_sound["redshirt_1"]["dead_ahead"] = "vox_reb1_s03_107A_uss1_f"; //MI-24 dead ahead!
	level.scr_sound["redshirt_2"]["cover"] = "vox_reb1_s03_108A_red1"; //Take cover!
	level.scr_sound["redshirt_1"]["locked_on"] = "vox_reb1_s03_109A_uss1_f"; //He's locked on! Move! Move!
	level.scr_sound["redshirt_2"]["incoming"] = "vox_reb1_s03_110A_uss1_f"; //Incoming!
//	level.scr_sound["redshirt_1"]["anime"] = "vox_reb1_s03_111A_red2"; //Nova 6! Hazmat suits, NOW!
//	level.scr_sound["redshirt_2"]["anime"] = "vox_reb1_s03_112A_red1_m"; //Shit! shit! Help me! No!

	// Gas Attack
	level.scr_sound["hudson"]["protect_suit_1"] = "vox_reb1_s03_113A_huds"; //Alpha Squad! we are moving forward! Protect your Hazmat suits!
	level.scr_sound["hudson"]["protect_suit_2"] = "vox_reb1_s03_114A_huds"; //You rupture your suit - you'll be dead in minutes!
	level.scr_sound["hazmat_redshirt_1"]["suit_tight"] = "vox_reb1_s03_115A_red2"; //You heard him! Keep those suits tight! Let's go!
	level.scr_sound["hazmat_redshirt_1"]["speztnaz"] = "vox_reb1_s03_116A_red2"; //Spetsnaz!
	level.scr_sound["hazmat_redshirt_2"]["copy_that"] = "vox_reb1_s03_117A_red3"; //Copy, we see 'em.
	level.scr_sound["hazmat_redshirt_1"]["check_six"] = "vox_reb1_s03_118A_red3"; //Check your six!
	level.scr_sound["hazmat_redshirt_2"]["got_it"] = "vox_reb1_s03_119A_red3"; //I got it.
	level.scr_sound["hazmat_redshirt_1"]["off_streets"] = "vox_reb1_s03_120A_red2"; //It's killing us! Get off the street!
	level.scr_sound["weaver"]["moving_north"] = "vox_reb1_s03_121A_weav_f"; //Yankee Squad has cleared the west perimeter. Moving north.
	level.scr_sound["hazmat_redshirt_1"]["moving_west"] = "vox_reb1_s03_122A_red2"; //Keep moving to the west! Down that alley!
	level.scr_sound["hudson"]["keep_north"] = "vox_reb1_s03_123A_huds"; //We're moving up on the flank. Keep heading north!
	level.scr_sound["weaver"]["heavy_fire"] = "vox_reb1_s03_124A_weav_f"; //Understood. We are taking some heavy fire from the helicopters.
	level.scr_sound["hudson"]["half_click"] = "vox_reb1_s03_125A_huds"; //Stay with it, we're about half a click south of the lab.
	level.scr_sound["weaver"]["request_backup"] = "vox_reb1_s03_126A_weav_f"; //Alpha squad, we are taking direct fire from the enemy. Requesting back up, over.
	level.scr_sound["hudson"]["almost_there"] = "vox_reb1_s03_127A_huds"; //Almost there Weaver, hang on!
	level.scr_sound["weaver"]["get_out"] = "vox_reb1_s03_128A_weav_f"; //Yankee squad get out of the BTR! We're going to get...
	level.scr_sound["hudson"]["calls_weaver"] = "vox_reb1_s03_129A_huds"; //Weaver!
	level.scr_sound["weaver"]["were_alive"] = "vox_reb1_s03_130A_weav_f"; //We're alive Hudson. We're pinned down. They're on our east flank.
	level.scr_sound["hudson"]["got_it_1"] = "vox_reb1_s03_131A_huds"; //Got it.
	level.scr_sound["weaver"]["cant_move"] = "vox_reb1_s03_132A_weav_f"; //God damn it! Hudson!  We can't move until we take out those choppers.
	level.scr_sound["hudson"]["got_it_2"] = "vox_reb1_s03_133A_huds"; //Yeah, I got it.
	level.scr_sound["weaver"]["use_strela"] = "vox_reb1_s03_134A_weav_f"; //Hudson! Use the Strela on the choppers!
	level.scr_sound["weaver"]["take_out_choppers"] = "vox_reb1_s03_135A_weav_f"; //Hudson, you need to take down those helicopters!
	level.scr_sound["hudson"]["lock_hint_1"] = "vox_reb1_s03_136A_huds"; //I need to be locked on before I shoot.
	level.scr_sound["hudson"]["lock_hint_2"] = "vox_reb1_s03_137A_huds"; //I need a lock on first.
	level.scr_sound["weaver"]["one_more"] = "vox_reb1_s03_138A_weav_f"; //There you go you son of a bitch! One more Hudson!
	level.scr_sound["weaver"]["this_way"] = "vox_reb1_s03_139A_weav"; //This way. We are almost at Steiner's labs.

	
	//level.scr_sound["Hudson"]["hudson_stop_carter"] 				= "Carter, stop!  Don't do it, we need him";
	//level.scr_sound["Weaver"]["weaver_help_break_window"] 	= "Hudson, here, we'll break the window";	
	level.scr_sound["Carter"]["carter_keep_out"] 						= "Stay out!";		
	level.scr_sound["Hudson"]["hudson_tackled_carter"] 			= "Weaver, are you ok?";
	level.scr_sound["Weaver"]["hudson_tackled_carter"] 			= "Yeah, i'll be fine, he just caught my arm";
	level.scr_sound["Weaver"]["hudson_tackled_carter2"] 		= "One of you grab Carter, we'll need to bring him back with us";
	level.scr_sound["Weaver"]["weaver_save_carter"] 				= "Bring Carter Outside, the docks should be secured by now.";
		
	//level.scr_sound["hudson"]["its_him"] 			= "It's him...";		
	//level.scr_sound["weaver"]["what_the_hell"] 			= "What the Hell is he doing?";	
	//level.scr_sound["hudson"]["killing_everyone"] 			= "Killing everyone between him and Steiner.";	
	level.scr_sound["steiner"]["dragovich_round_up"] 			= "Drogovich's men are rounding up everyone on the island...";		//Steiner into radio
	level.scr_sound["steiner"]["no_longer_essential"] 			= "Those no longer essential to his plans are being executed!";		//Steiner into radio
	level.scr_sound["steiner"]["hurry_before_they_kill"] 			= "You must hurry, before they kill me too!";		//Steiner into radio
	level.scr_sound["hudson"]["friedrich_steiner_h"] 			= "Friedrich Steiner.";		//Mason into Steiner radio
	//level.scr_sound["Weaver"]["this_way_to_dock"] 			= "This way.  It will take us to the dock.";	
	//level.scr_sound["Weaver"]["we_have_the_package"] 			= "This is Weaver. We have the package.... We are on our way.";	
	//level.scr_sound["Weaver"]["taking_the_docks_now"] 			= "Copy that Weaver.  We are taking the docks now.";//Pilot line	
	//level.scr_sound["Weaver"]["you_are_clear"] 			= "You are clear Weaver.";//Pilot line
	//level.scr_sound["Weaver"]["on_our_way"] 			= "On our way.";
	//level.scr_sound["Weaver"]["lets_go"] 			= "Let's go.";
	//level.scr_sound["Weaver"]["watch_him"] 			= "Watch him...";
	//level.scr_sound["Hudson"]["what_did_they_do"] 			= "What did they do to you, Mason?";
	level.scr_sound["loudspeaker"]["security_backup"] 			= "Security breach in the labs, hazmat teams please respond";

	// Hudson Lab
	level.scr_sound["weaver"]["almost_at"] = "vox_reb1_s03_139A_weav"; //This way. We are almost at Steiner's labs.
	level.scr_sound["weaver"]["all_right"] = "vox_reb1_s03_140A_weav"; //All right. That's the bio-lab. Looks like they're waiting for us.
	level.scr_sound["hudson"]["move_out"] = "vox_reb1_s03_141A_huds"; //Move out. Stay low.
  level.scr_sound["weaver"]["weapons_free"] = "vox_reb1_s03_142A_weav"; //Weapons free! Weapons free!
  level.scr_sound["weaver"]["flank_left"] = "vox_reb1_s03_143A_weav"; //Hudson, flank left with me. There is cover!
  level.scr_sound["weaver"]["in_here"] = "vox_reb1_s03_144A_weav"; //In here. This is where Steiner will be.
  level.scr_sound["weaver"]["this_way"] = "vox_reb1_s03_145A_weav"; //This way. The bio-lab is below us.
  level.scr_sound["weaver"]["pass_through_decontamination"] = "vox_reb1_s03_146A_weav"; //We need to pass through decontamination.
  level.scr_sound["weaver"]["find_steiner"] = "vox_reb1_s03_147A_weav"; //Let's go find Steiner.
  level.scr_sound["hudson"]["are_you_there"] = "vox_reb1_s03_148A_huds"; //Mason, this is Hudson. Are you there?
}



/*------------------------------------

------------------------------------*/
#using_animtree( "generic_human" );
precache_dock_actor_anims()
{
	// Ambient Dock Workers
	level.scr_anim[ "ambient_worker" ][ "argue_1" ][0] 										= %ch_rebirth_b01_dock_workers_f_1;
	level.scr_anim[ "ambient_worker" ][ "argue_2" ][0]										= %ch_rebirth_b01_dock_workers_f_2;
	level.scr_anim[ "ambient_worker" ][ "inspect_1" ][0]									= %ch_rebirth_b01_dock_workers_e_1;
	level.scr_anim[ "ambient_worker" ][ "inspect_2" ][0]									= %ch_rebirth_b01_dock_workers_g_2;
	level.scr_anim[ "ambient_worker" ][ "talk_1" ][0]											= %ch_rebirth_b01_dock_workers_g_1;
	level.scr_anim[ "ambient_worker" ][ "talk_2" ][0]											= %ch_rebirth_b01_dock_workers_g_2;
//	level.scr_anim[ "ambient_worker" ][ "walk_1" ] 												= %ch_rebirth_b01_dock_workers_h_1;
//	level.scr_anim[ "ambient_worker" ][ "walk_2" ] 												= %ch_rebirth_b01_dock_workers_h_2;
//	level.scr_anim[ "ambient_worker" ][ "crate_wave_1" ]									= %ch_rebirth_b01_dock_workers_c_1;
//	level.scr_anim[ "ambient_worker" ][ "crate_wave_2" ]									= %ch_rebirth_b01_dock_workers_c_2;
	
	// Crate Investigate
	level.scr_anim[ "crate_kill_worker" ]["crate_investigate"] 						= %ch_rebirth_b01_dock_container_worker_b;
	level.scr_anim[ "worker" ][ "crate_investigate" ] 										= %ch_rebirth_b01_dock_container_worker_a;
	level.scr_anim[ "crate_kill_worker" ][ "dead_loop" ]									= %ai_contextual_melee_hatchet_worker_deathpose;
	
	// Crate Kill
	level.scr_anim[ "crate_kill_worker" ][ "container_worker_idle" ][0] 	= %ch_rebirth_b01_container_worker_idle;
	
	// Alley Kill
	level.scr_anim[ "hatchet_chop_guard" ][ "idle_loop"]										= %ai_hatchet_to_throw_idle;
	level.scr_anim[ "hatchet_chop_guard" ][ "idle_2_flinch"]								= %ai_hatchet_to_throw_idle_2_flinch;
	level.scr_anim[ "hatchet_chop_guard" ][ "flinch_to_ai"] 								= %ai_hatchet_to_throw_flinch_2_ai;
	level.scr_anim[ "hatchet_chop_guard" ][ "chop_contextual_melee"]				= %ai_contextual_melee_hatchet_to_throw;
	addNotetrack_customFunction( "hatchet_chop_guard", "start_arm_blood", 	maps\rebirth_mason_stealth::hatchet_kill_arm_blood, "chop_contextual_melee" );
	addNotetrack_customFunction( "hatchet_chop_guard", "start_chest_blood", 	maps\rebirth_mason_stealth::hatchet_kill_chest_blood, "chop_contextual_melee" );
	
	// level.scr_anim[ "hatchet_chop_guard" ][ "radio_talk_loop" ][0] 					= %ch_rebirth_b01_dock_workers_radio;
	level.scr_anim[ "hatchet_chop_guard" ][ "dead_loop"]  									= %ai_contextual_melee_hatchet_to_throw_deathpose;
	level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_throw_prep" ] 				= %ai_contextual_melee_hatchet_patroller_walk_2_ai;
	level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_throw_death" ] 				= %ai_contextual_melee_hatchet_patroller_death;
	level.scr_anim[ "hatchet_throw_guard" ][ "hatchet_resolve_wait" ][0] 		= %exposed_aim_5;
	level.scr_anim[ "hatchet_throw_guard" ][ "dead_loop" ] 									= %ai_contextual_melee_hatchet_patroller_deathpose;
	
	// Pull Down Guard
	level.scr_anim[ "pull_down_guard" ][ "guard_pulldown_prep" ] 					= %ai_contextual_melee_ladderpull_peekover;
	level.scr_anim[ "pull_down_guard" ][ "guard_pull_fall_death" ]  			= %ai_contextual_melee_ladderpull;
	level.scr_anim[ "pull_down_guard" ][ "guard_pull_shoot_player" ] 			= %ai_contextual_melee_ladderpull_peekover_2_fire;
	addNotetrack_customFunction( "pull_down_guard", "fire", 	maps\rebirth_mason_stealth::pull_down_failed_shot, "guard_pull_shoot_player" );
	
	// Roof guard reacts
	level.scr_anim[ "left_roof_guard" ][ "guard_explosion_response" ] 		= %ch_rebirth_b01_explosion_reac_guard1;
	level.scr_anim[ "right_roof_guard" ][ "guard_explosion_response" ] 		= %ch_rebirth_b01_explosion_reac_guard2;
	
	// Solider and scientist in elevator
	level.scr_anim[ "elevator_talk_guard" ][ "elevator_idle" ] 			= %ch_rebirth_b01_inside_elevator_spetz1;
	level.scr_anim[ "elevator_talk_guard" ][ "elevator_react" ] 		= %ch_rebirth_b01_inside_elevator_spetz1_react;
	level.scr_anim[ "elevator_guard" ][ "elevator_idle" ]						= %ch_rebirth_b01_inside_elevator_spetz2;
	level.scr_anim[ "elevator_guard" ][ "elevator_react" ]					= %ch_rebirth_b01_inside_elevator_spetz2_react;
	level.scr_anim[ "elevator_talk_scientist" ][ "elevator_idle" ]	= %ch_rebirth_b01_inside_elevator_civ1;
	level.scr_anim[ "elevator_talk_scientist" ][ "elevator_react" ]	= %ch_rebirth_b01_inside_elevator_civ1_react;
	level.scr_anim[ "elevator_scientist" ][ "elevator_idle" ]				= %ch_rebirth_b01_inside_elevator_civ2;
	level.scr_anim[ "elevator_scientist" ][ "elevator_react" ]			= %ch_rebirth_b01_inside_elevator_civ2_react;
	
	
	// Reznov starts in container with player
	level.scr_anim[ "reznov" ][ "reznov_crate_intro" ] 						= %ch_rebirth_b01_docks_intro_reznov;
	addNotetrack_customFunction( "reznov", "player_not_on_my_watch", 	maps\rebirth_mason_stealth::mason_not_on_my_watch );
	level.scr_anim[ "reznov" ][ "reznov_crate_idle" ][0] 					= %ch_rebirth_b01_docks_intro_idle_reznov;
	level.scr_anim[ "reznov" ][ "reznov_kill_him"]								= %ch_rebirth_b01_docks_intro_kill_him_mason_reznov;
	// Reznov guides player through dock area
	level.scr_anim[ "reznov" ][ "reznov_exit_container" ] 				= %ch_rebirth_b01_dockrun_exit_container_reznov;
	level.scr_anim[ "reznov" ][ "reznov_idle_post_container" ][0] = %ch_rebirth_b01_dockrun1_idle_reznov;
	level.scr_anim[ "reznov" ][ "reznov_moveto_first_cover" ] 		= %ch_rebirth_b01_dockrun1_reznov;
	level.scr_anim[ "reznov" ][ "reznov_idle_first_cover" ][0] 		= %ch_rebirth_b01_dockrun2_idle_reznov;
	// reznov motions carter to stay put
	level.scr_anim[ "reznov" ][ "reznov_moveto_crate_pause" ] 		= %ch_rebirth_b01_dockrun2_reznov;
	level.scr_anim[ "reznov" ][ "reznov_crate_pause" ][0]					= %ch_rebirth_b01_dockrun3_idle_reznov;
	level.scr_anim[ "reznov" ][ "reznov_moveto_second_cover" ] 		= %ch_rebirth_b01_dockrun3_reznov;
	level.scr_anim[ "reznov" ][ "reznov_idle_second_cover" ] [0]	= %ch_rebirth_b01_dockrun4_idle_reznov;
	// reznov motions to kill the guard
	level.scr_anim[ "reznov" ][ "motion_kill" ] 									= %ch_rebirth_b01_dockrun4_kill_signal_reznov;
	// reznov runs to the next 
	level.scr_anim[ "reznov" ][ "after_hatchet_run" ]							= %ch_rebirth_b01_spotlight_run_reznov;
	level.scr_anim[ "reznov" ][ "after_hatchet_run_idle" ][0]			= %ch_rebirth_b01_spotlight_run_reznov_idle;
	level.scr_anim[ "reznov" ][ "after_hatchet_run_idle" ][1]			= %ch_rebirth_b01_spotlight_run_reznov_idle2;
	level.scr_anim[ "reznov" ][ "after_hatchet_run_idle" ][2]			= %ch_rebirth_b01_spotlight_run_reznov_idle2;	// weight this to play more often
	level.scr_anim[ "reznov" ][ "after_hatchet_run_idle_speak" ]	= %ch_rebirth_b01_spotlight_run_reznov_idle_speak;
	level.scr_anim[ "reznov" ][ "after_hatchet_run_exit" ]				= %ch_rebirth_b01_spotlight_run_reznov_exit;
	// Reznov motions for the player to climb up
	level.scr_anim[ "reznov" ][ "reznov_ladder_arrive"]						= %ch_rebirth_b01_reznov_motion_up_ladder_get_to;
	level.scr_anim[ "reznov" ][ "reznov_ladder_wait" ][0]					= %ch_rebirth_b01_reznov_motion_up_ladder_idle;
	level.scr_anim[ "reznov" ][ "reznov_point_up" ] 							= %ch_rebirth_b01_reznov_motion_up_ladder;
	level.scr_anim[ "reznov" ][ "reznov_pulldown_respond" ]				= %ch_rebirth_b01_reznov_motion_up_ladder_reaction;
	// Reznov climbs the pipes on the rooftop
	level.scr_anim[ "reznov" ][ "pipe_climb" ]										= %ch_rebirth_b01_reznov_climbspipes;
	// Reznov slides down cables
	level.scr_anim[ "reznov" ][ "cables_arrive" ]									= %ch_rebirth_b01_run_to_cable_reznov;
	level.scr_anim[	"reznov" ][ "cables_idle" ][0]								= %ch_rebirth_b01_idle_cable_reznov;
	level.scr_anim[ "reznov" ][ "cable_slide" ] 									= %ch_rebirth_b01_slide_down;
	level.scr_anim[ "reznov" ][ "elevator_wait" ][0]							= %ch_rebirth_b01_elevator_idle_reznov;
	// Reznov opens the hatch on the elevator
	level.scr_anim[ "reznov" ][ "open_hatch_in" ]									= %ch_rebirth_b01_open_hatch_reznov;
	level.scr_anim[ "reznov" ][ "open_hatch_idle" ][0]						= %ch_rebirth_b01_open_hatch_loop_reznov;
	level.scr_anim[ "reznov" ][ "open_hatch_out" ]								= %ch_rebirth_b01_drop_down_reznov;
	level.scr_anim[ "reznov" ][ "open_hatch_speak" ]							= %ch_rebirth_b01_open_hatch_speak_reznov;
}

precache_actor_anims()
{
	level thread precache_dock_actor_anims();
	
	// patrol anims pulled out of _patrol.gsc to save memory (not using idles)	
	level.scr_anim[ "generic" ][ "patrol_walk" ]					= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]					= %ai_spets_patrolwalk_2_stand;
	level.scr_anim[ "generic" ][ "patrol_start" ]					= %ai_spets_patrolstand_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %ai_spets_patrolwalk_180turn;	
		
	// ai_spets_patrolstand_idle
		
	level.scr_anim[ "generic" ][ "cower_idle" ][0]			= %ai_civ_gen_cower_stand_idle;	
	level.scr_anim[ "generic" ][ "cower_react" ]				= %ai_civ_gen_cower_stand_idle_2_react_stand_f;	
		
	// lead up to steiner's office
	level.scr_anim[ "reznov"][ "to_steiner_idle" ][0]				= %ch_rebirth_b02_lead_to_steiner_door_idle;
	level.scr_anim[ "reznov"][ "to_steiner_intro" ]					= %ch_rebirth_b02_lead_to_steiner_intro;
	level.scr_anim[ "reznov"][ "to_steiner_intro_idle" ][0]	= %ch_rebirth_b02_lead_to_steiner_intro_idle;
	level.scr_anim[ "reznov"][ "to_steiner_walk" ]					= %ch_rebirth_b02_lead_to_steiner_walk;
		
	// Mason/Steiner at Steiner's Office
	level.scr_anim[ "steiner" ][ "confront_steiner" ] = %ch_rebirth_b02_confront_steiner_steiner;
	level.scr_anim[ "reznov" ][ "confront_steiner" ]  = %ch_rebirth_b02_confront_steiner_reznov;
	level.scr_anim[ "hudson" ][ "confront_steiner" ]  = %ch_rebirth_b02_confront_steiner_hudson;
	level.scr_anim[ "weaver" ][ "confront_steiner" ]  = %ch_rebirth_b02_confront_steiner_weaver;
	addNotetrack_customFunction( "weaver", "hit_window 1", 	maps\rebirth_steiners_office::steiners_office_hit_glass );
	addNotetrack_customFunction( "weaver", "hit_window 2",		maps\rebirth_steiners_office::steiners_office_hit_glass2 );
	addNotetrack_customFunction( "weaver", "hit_window 3", 	maps\rebirth_steiners_office::steiners_office_break_glass );
	
	 //addNotetrack_customFunction( <animname>, <notetrack> , <function> , <scene> );
 	 level thread addNotetrack_customFunction( "reznov", "start_music", maps\rebirth_amb::play_resolution_music, "confront_steiner" ); 	
	
	addNotetrack_customFunction( "reznov", "fade out", 	maps\rebirth_mason_lab::confront_steiner_fade_out );
	addNotetrack_customFunction( "steiner", "hit", maps\rebirth_mason_lab::confront_steiner_slam );
	addNotetrack_customFunction( "steiner", "spit", maps\rebirth_mason_lab::confront_steiner_spit );
	addNotetrack_customFunction( "steiner", "punch", maps\rebirth_mason_lab::confront_steiner_punch );
		
	// Hudson's BTR crashes
	level.scr_anim[ "crash_guy0" ][ "btr_crash" ]				= %ch_rebirth_b03_btr_crash_troop01;
	level.scr_anim[ "crash_guy1" ][ "btr_crash" ]				= %ch_rebirth_b03_btr_crash_troop02;

	// AIs push car into place
	// level.scr_anim[ "push_guy0" ][ "push" ]				= %ch_rebirth_b02_push_car_spez1;
	// level.scr_anim[ "push_guy1" ][ "push" ]				= %ch_rebirth_b02_push_car_spez2;

	// Civilian Massacre
//	level.scr_anim[ "civ_death_a_civ" ][ "civ_death_a" ][0]		= %ch_rebirth_b02_civ_shot_a_civ;
//	level.scr_anim[ "civ_death_a_spetz" ][ "civ_death_a" ][0]	= %ch_rebirth_b02_civ_shot_a_spez;
//	level.scr_anim[ "civ_death_b_civ" ][ "civ_death_b" ][0]		= %ch_rebirth_b02_civ_shot_b_civ;
//	level.scr_anim[ "civ_death_b_spetz" ][ "civ_death_b" ][0]	= %ch_rebirth_b02_civ_shot_b_spez;
//	level.scr_anim[ "civ_death_c_civ" ][ "civ_death_c" ][0]		= %ch_rebirth_b02_civ_shot_c_civ;
//	level.scr_anim[ "civ_death_c_spetz" ][ "civ_death_c" ][0]	= %ch_rebirth_b02_civ_shot_c_spez;
//	level.scr_anim[ "civ_death_d_civ" ][ "civ_death_d" ][0]		= %ch_rebirth_b02_civ_shot_d_civ;
//	level.scr_anim[ "civ_death_d_spetz" ][ "civ_death_d" ][0]	= %ch_rebirth_b02_civ_shot_d_spez;
//	level.scr_anim[ "civ_death_e_civ" ][ "civ_death_e" ][0]		= %ch_rebirth_b02_civ_shot_e_civ;
//	level.scr_anim[ "civ_death_e_spetz" ][ "civ_death_e" ][0]	= %ch_rebirth_b02_civ_shot_e_spez;
	
	// weaver presses the button for the elevator, then opens the clean room
	level.scr_anim[ "weaver" ][ "button_press" ]				= %ch_rebirth_b04_buttonpress_weaver;
	level.scr_anim[ "weaver" ][ "clean_room_exit" ]				= %ch_rebirth_b04_clean_room_exit_weaver;
	level.scr_anim[ "weaver" ][ "clean_room_idle" ][0]				= %ch_rebirth_b04_clean_room_idle_weaver;
	
	// weaver finds the knife left by carter
	level.scr_anim[ "weaver" ][ "find_knife_in" ]				= %ch_rebirth_b04_knife_find_weaver_in;
	level.scr_anim[ "weaver" ][ "find_knife_idle" ][0]	= %ch_rebirth_b04_knife_find_weaver_idle;
	level.scr_anim[ "weaver" ][ "find_knife_out" ]			= %ch_rebirth_b04_knife_find_weaver_out;	
	
	//Security Room
	//level.scr_anim["weaver"]["security_door_open"] 	= %ch_cuba_b02_cuba_door_breach_1_bowman;
	//addnotetrack_customfunction( "weaver", "start anim = \"bowman_opens_door\"", maps\rebirth_steiners_office::security_door_open, "security_door_open" ); 	
	
	// Steiner's Office Breakin
	/*level.scr_anim[ "mason" ][ "office_breakin1" ]			= %ch_rebirth_b05_officebreakin_windowApproach_mason;
	level.scr_anim[ "mason" ][ "office_breakin2" ]			= %ch_rebirth_b05_officebreakin_fuseLift_mason;
	level.scr_anim[ "mason" ][ "office_breakin3" ]			= %ch_rebirth_b05_officebreakin_windowHit01_mason;
	level.scr_anim[ "mason" ][ "office_breakin4" ]			= %ch_rebirth_b05_officebreakin_backAway01_mason;
	level.scr_anim[ "mason" ][ "office_breakin5" ]			= %ch_rebirth_b05_officebreakin_windowHit02_mason;
	level.scr_anim[ "mason" ][ "office_breakin6" ]			= %ch_rebirth_b05_officebreakin_backAway02_mason;
	level.scr_anim[ "mason" ][ "office_breakin7" ]			= %ch_rebirth_b05_officebreakin_windowHit03_mason;
	level.scr_anim[ "mason" ][ "office_breakin8" ]			= %ch_rebirth_b05_officebreakin_mantleOver_mason;
	level.scr_anim[ "mason" ][ "office_breakin9" ]			= %ch_rebirth_b05_officebreakin_punchMason_mason;*/
	
	level.scr_anim[ "mason" ][ "office_intro" ]							= %ch_rebirth_b05_officebreakin_intro_mason;
	level.scr_anim[ "mason" ][ "office_window_break" ]			= %ch_rebirth_b05_officebreakin_break_window_mason;
	//level.scr_anim[ "mason" ][ "office_fail" ]							= %ch_rebirth_b05_officebreakin_fail_mason;
	//level.scr_anim[ "mason" ][ "office_success" ]						= %ch_rebirth_b05_officebreakin_success_mason;
	level.scr_anim[ "mason" ][ "office_fuse_idle" ]					= %ch_rebirth_b05_officebreakin_idle_at_fuse_mason;
	level.scr_anim[ "mason" ][ "office_downloop" ][0]					= %ch_rebirth_b05_officebreakin_downloop_mason;
	//addNotetrack_customFunction( "mason", "success_begin", 	maps\rebirth_steiners_office::mason_transition, "office_window_break" );
	addNotetrack_customFunction( "mason", "spit", maps\rebirth_steiners_office::mason_spit, "office_window_break" );
	
	level.scr_anim[ "steiner" ][ "office_window_break" ]			= %ch_rebirth_b05_officebreakin_break_window_steiner;
	level.scr_anim[ "steiner" ][ "office_fuse_idle" ]					= %ch_rebirth_b05_officebreakin_idle_at_fuse_steiner;
	level.scr_anim[ "steiner" ][ "office_intro" ]							= %ch_rebirth_b05_officebreakin_intro_steiner;	
	level.scr_anim[ "steiner" ][ "dead_steiner" ][0]							= %ch_rebirth_b05_officebreakin_dead_steiner;
	
	level.scr_anim[ "weaver" ][ "office_intro" ]							= %ch_rebirth_b05_officebreakin_intro_weaver;
	level.scr_anim[ "weaver" ][ "office_window_break" ]				= %ch_rebirth_b05_officebreakin_break_window_weaver;
	//level.scr_anim[ "weaver" ][ "office_fail" ]								= %ch_rebirth_b05_officebreakin_fail_weaver;
	level.scr_anim[ "weaver" ][ "office_fuse_idle" ]					= %ch_rebirth_b05_officebreakin_idle_at_fuse_weaver;	
	level.scr_anim[ "weaver" ][ "office_success" ]						= %ch_rebirth_b05_officebreakin_success_weaver;
	addNotetrack_customFunction( "weaver", "script_sound vox_reb1_s03_162A_huds_m", 	maps\rebirth_steiners_office::office_success_hudson_vo1, "office_success" );
	addNotetrack_customFunction( "weaver", "script_sound vox_reb1_s03_163A_huds_m", 	maps\rebirth_steiners_office::office_success_hudson_vo2, "office_success" );
	addNotetrack_customFunction( "weaver", "script_sound vox_reb1_s03_164A_huds_m", 	maps\rebirth_steiners_office::office_success_hudson_vo3, "office_success" );
	addNotetrack_customFunction( "weaver", "script_sound vox_reb1_s03_166A_huds_m", 	maps\rebirth_steiners_office::office_success_hudson_vo4, "office_success" );
	addNotetrack_customFunction( "weaver", "weapon_swap", 	maps\rebirth_steiners_office::weaver_weapon_swap, "office_success" );
	
	// level.scr_model["weaver_weapon"] = "t5_weapon_enfield_world";
	level.scr_model["weaver_weapon"] = "ak12_world_model";
	level.scr_anim["weaver_weapon"]["office_success"] = %ch_rebirth_b05_officebreakin_success_weaver_gun;
	level.scr_animtree["weaver_weapon"] = #animtree;
	
	level.scr_anim[ "mason" ][ "mason_pickup" ]					= %ch_rebirth_b05_masoncarry_mason;
	level.scr_anim[ "carrier" ][ "mason_pickup" ] 			= %ch_rebirth_b05_masoncarry_guy01;
	level.scr_anim[ "carrier" ][ "mason_pickup_loop" ][0]  = %ch_rebirth_b05_masoncarry_guy01_loop;
	level.scr_anim[ "mason" ][ "mason_pickup_idle" ][0]		= %ai_firemans_carry_carried_stand_loop;
	level.scr_anim[ "carrier" ][ "mason_pickup_idle" ][0]	= %ai_firemans_carry_carrier_stand_loop;	
	
	level.scr_anim[ "carrier" ][ "office_success" ] 				= %ch_rebirth_b05_officebreakin_success_redshirt2;
	level.scr_anim[ "redshirt2" ][ "office_success" ] 			= %ch_rebirth_b05_officebreakin_success_redshirt1;
	
	//level.scr_anim[ "weaver" ][ "this_way_to_dock" ]				= %ch_rebirth_b05_radio_talk_weaver;
	
	// Steiner's Office Breakin - Notetracks
	// addNotetrack_customFunction( "mason", "mason fire", 	maps\rebirth_lab::steiners_office_hudson_vo, "office_breakin" );
	
	// AI carries Mason out
	level.scr_anim[ "mason" ][ "mason_carry" ][0]				= %ai_firemans_carry_carried_walk_loop;
	level.scr_anim[ "generic" ][ "mason_carry" ]				= %ai_firemans_carry_carrier_walk_loop;
	
	level.scr_anim[ "weaver" ][ "security_react" ]			= %ch_rebirth_05_hudson_weaver_reaction_1;	
	addNotetrack_customFunction( "weaver", "door_open", 	maps\rebirth_steiners_office::security_door_open );
	// Gas Deaths
	level.scr_anim["generic"]["gas_death_1"] 						= %ch_rebirth_b03_gas_death_1;
	// level.scr_anim["generic"]["gas_death_2"] 				= %ch_rebirth_b03_gas_death_2;
	// level.scr_anim["generic"]["gas_death_3"] 				= %ch_rebirth_b03_gas_death_3;
	// level.scr_anim["generic"]["gas_death_4"] 				= %ch_rebirth_b03_gas_death_4;
	level.scr_anim["generic"]["gas_death_5"] 						= %ch_rebirth_b03_gas_death_5;
	level.scr_anim["generic"]["gas_death_6"] 						= %ch_rebirth_b03_gas_death_6;

	// BTR Rail Anims
	level.scr_anim["weaver"]["btr_talk"] 								= %ch_rebirth_b03_weaver_talk;
	level.scr_anim["weaver"]["btr_idle"][0] 						= %ch_rebirth_b03_btr_motion_loop_weaver;
	level.scr_anim["weaver"]["btr_motion_left"] 				= %ch_rebirth_b03_btr_motion_left_weaver;
	level.scr_anim["weaver"]["btr_motion_right"] 				= %ch_rebirth_b03_btr_motion_right_weaver;
	// level.scr_anim["weaver"]["btr_motion_right"] 		= %ch_rebirth_b03_btr_motion_forward_weaver;

	// Gas Attack Anims
	// level.scr_anim["gas_worker_1"]["gas_death"][0] 	= %ch_rebirth_b03_worker_gas_death_1;
	// level.scr_anim["gas_worker_2"]["gas_death"][0] 	= %ch_rebirth_b03_worker_gas_death_2;
	
	level.scr_anim["hazmat_redshirt_1"]["crouch_window_mantle"] 	= %ai_covercrouch_hide_2_mantle_36_rebirth;
	level.scr_anim["hazmat_redshirt_2"]["crouch_window_mantle"] 	= %ai_covercrouch_hide_2_mantle_36_rebirth;
}



/*------------------------------------

------------------------------------*/
#using_animtree( "player" );
precache_player_anims()
{
	level.scr_model[ "player_body" ] 										= "t5_gfl_ump45_viewbody";
	level.scr_animtree["player_body"] 									= #animtree;
	
	level.scr_model["player_hands"] 										= "t5_gfl_ump45_viewmodel_player";
	level.scr_animtree["player_hands"] 									= #animtree;
	
	// Crate Open
	level.scr_anim[ "player_body" ][ "open_crate" ]	 		= %ch_rebirth_b01_open_container_player;
	
	// Pull Down Contextual Melee
	level.scr_anim[ "player_hands" ][ "pull_down_success" ] = %int_contextual_melee_ladderpull;
	level.scr_anim[ "player_hands" ][ "pull_down_idle" ][0] = %int_contextual_melee_ladderpull_idle;
	level.scr_anim[ "player_hands" ][ "pull_down_death" ] 	= %int_contextual_melee_ladderpull_death;
	
	// gas death for mason
	level.scr_anim[ "player_hands" ][ "gas_death" ]			= %int_player_gas_death;

	level.scr_anim[ "player_body"][ "confront_steiner" ]		= %ch_rebirth_b02_confront_steiner_player;

	level.scr_anim[ "player_body" ][ "cable_slide" ]		= %ch_rebirth_b01_elevatordescent_player;
	
	// Player when the hatch is opened
	level.scr_anim[ "player_body" ][ "open_hatch_in" ]	= %ch_rebirth_b01_open_hatch_in_player;
	level.scr_anim[ "player_body" ][ "open_hatch_out" ]	= %ch_rebirth_b01_open_hatch_end_player;
	
	// reznov takes player's knife to open the security panel
	// level.scr_anim[ "player_body" ][ "use_knife" ]			= %ch_rebirth_b01_useknife_player;
	
	// Steiner's Office Breakin
	// level.scr_anim[ "player_body" ][ "office_breakin" ]	= %ch_rebirth_b05_officebreakin_player;
	/*level.scr_anim[ "player_body" ][ "office_breakin1" ]	= %ch_rebirth_b05_officebreakin_windowApproach_player;
	level.scr_anim[ "player_body" ][ "office_breakin2" ]	= %ch_rebirth_b05_officebreakin_fuseLift_player;
	level.scr_anim[ "player_body" ][ "office_breakin3" ]	= %ch_rebirth_b05_officebreakin_windowHit01_player;
	level.scr_anim[ "player_body" ][ "office_breakin4" ]	= %ch_rebirth_b05_officebreakin_backAway01_player;
	level.scr_anim[ "player_body" ][ "office_breakin5" ]	= %ch_rebirth_b05_officebreakin_windowHit02_player;
	level.scr_anim[ "player_body" ][ "office_breakin6" ]	= %ch_rebirth_b05_officebreakin_backAway02_player;
	level.scr_anim[ "player_body" ][ "office_breakin7" ]	= %ch_rebirth_b05_officebreakin_windowHit03_player;
	level.scr_anim[ "player_body" ][ "office_breakin8" ]	= %ch_rebirth_b05_officebreakin_mantleOver_player;
	level.scr_anim[ "player_body" ][ "office_breakin9" ]	= %ch_rebirth_b05_officebreakin_punchMason_player;	*/
	
	level.scr_anim[ "player_body_hazmat" ][ "office_intro" ]			= %ch_rebirth_b05_officebreakin_intro_player;
	level.scr_anim[ "player_body_hazmat" ][ "office_window_break" ]			= %ch_rebirth_b05_officebreakin_break_window_player;
	//level.scr_anim[ "player_body_hazmat" ][ "office_fail" ]					= %ch_rebirth_b05_officebreakin_fail_player;
	//level.scr_anim[ "player_body_hazmat" ][ "office_success" ]					= %ch_rebirth_b05_officebreakin_success_player;
	level.scr_anim[ "player_body_hazmat" ][ "office_fuse_idle" ]				= %ch_rebirth_b05_officebreakin_idle_at_fuse_player;	
	
	
	
	// Steiner's Office Breakin - Notetracks
	// addNotetrack_customFunction( "player_body_hazmat", "player approach", 	maps\rebirth_steiners_office::steiners_office_hudson_vo );
	// addNotetrack_customFunction( "player_body_hazmat", "look at weaver",		maps\rebirth_steiners_office::steiners_office_weaver_vo );
	addNotetrack_customFunction( "player_body_hazmat", "window smash 1", 	maps\rebirth_steiners_office::steiners_office_hit_glass );
	addNotetrack_customFunction( "player_body_hazmat", "window smash 2",		maps\rebirth_steiners_office::steiners_office_hit_glass2 );
	addNotetrack_customFunction( "player_body_hazmat", "window smash 3", 	maps\rebirth_steiners_office::steiners_office_break_glass );
	addNotetrack_customFunction( "player_body_hazmat", "hit mason", 	maps\rebirth_steiners_office::hit_rumble );
	//addNotetrack_customFunction( "player_body_hazmat", "start timescale 1", 	maps\rebirth_steiners_office::hit_success_listener );
	//addNotetrack_customFunction( "player_body_hazmat", "end timescale 1", 	maps\rebirth_steiners_office::timescale_fail );
	
	//addNotetrack_customFunction( "mason", "fire", 	maps\rebirth_steiners_office::mason_fire );
	addNotetrack_customFunction( "weaver", "fire", maps\rebirth_steiners_office::weaver_fire );

	// Hazmat Hands
	level.scr_model["player_hands_hazmat"]								= "t5_gfl_m16a1_viewmodel_player";
	level.scr_animtree["player_hands_hazmat"] 							= #animtree;

	// Gas Death
	level.scr_anim[ "player_hands_hazmat" ][ "gas_death" ]			= %int_player_gas_death;

	// BTR Rail
	level.scr_anim[ "player_hands_hazmat" ][ "btr_idle" ][0]			= %int_btr60_idle;
	level.scr_anim[ "player_hands_hazmat" ][ "btr_mg_fire_in" ] 	= %int_btr60_fire_right_hand_in;
	level.scr_anim[ "player_hands_hazmat" ][ "btr_mg_fire_loop" ] 	= %int_btr60_fire_right_hand_loop;
	level.scr_anim[ "player_hands_hazmat" ][ "btr_mg_fire_out" ] 	= %int_btr60_fire_right_hand_out;
	level.scr_anim[ "player_hands_hazmat" ][ "btr_grenade_fire" ] 	= %int_btr60_fire_left_hand;

	// Hazmat Full Body
	level.scr_model["player_body_hazmat"]								= "t5_gfl_m16a1_viewbody";
	level.scr_animtree["player_body_hazmat"] 							= #animtree;

	// Hudson's BTR crashes
	level.scr_anim[ "player_body_hazmat" ][ "btr_crash" ]			= %ch_rebirth_b03_btr_crash_player;
}



/*------------------------------------

------------------------------------*/
#using_animtree( "vehicles" );
precache_vehicle_anims()
{
	level.scr_model["crash_btr"] = "t5_veh_apc_btr60";
	level.scr_animtree["crash_btr"] = #animtree;
	level.scr_anim["crash_btr"]["btr_crash"] = %v_rebirth_b03_btr_crash;

	// Setup Chinook
	//level.scr_model["support_chopper"] = "t5_veh_ch46e_tailgun";
	//level.scr_animtree["support_chopper"] = #animtree;
	//level.scr_anim["support_chopper"]["unload"][0] = %v_khe_E1B_chinookdropoff_helo;	

	// BTR Rail Pushed Car
	// level.scr_model[ "push_car" ] = "t5_veh_civ_tiara";
	// level.scr_anim[ "push_car" ][ "push" ] = %v_rebirth_b02_push_car;
	// level.scr_animtree[ "push_car" ] = #animtree;
}

#using_animtree( "rebirth" );
precache_object_anims()
{
	// gas attack heli crash
	level.scr_model["rebirth_heli"] = "t5_veh_helo_mi8_woodland";
  level.scr_animtree["rebirth_heli"] = #animtree;
  level.scr_anim["rebirth_heli"]["heli_crash"] = %v_rebirth_b03_helicopter_crash;
	
	level.scr_anim[ "crate" ][ "outer_open" ] 					= %p_rebirth_b01_dock_crate_outer_door_anim;
	level.scr_anim[ "crate" ][ "outer_open_loop" ][0]		= %p_rebirth_b01_dock_crate_outer_door_openloop;
	level.scr_anim[ "crate" ][ "inner_open" ] 					= %p_rebirth_b01_dock_crate_inner_door_anim;
	level.scr_anim[ "crate" ][ "inner_open_loop" ][0] 	= %p_rebirth_b01_dock_crate_inner_door_openloop;
	
	level.scr_anim[ "hatch" ][ "closed_loop" ][0] 		= %p_rebirth_b01_slide_down_hatch_closed;
	level.scr_anim[ "hatch" ][ "reznov_open" ]				= %p_rebirth_b01_open_hatch;
	level.scr_anim[ "hatch" ][ "shoot_wait" ][0] 			= %p_rebirth_b01_open_hatch_loop;
	level.scr_anim[ "hatch" ][ "reznov_jump" ] 				= %p_rebirth_b01_drop_down_hatch_fullyopen;
	level.scr_anim[ "hatch" ][ "open_loop" ][0] 			= %p_rebirth_b01_hatch_idle;
	level.scr_animtree["hatch"] = #animtree;

	level.scr_anim[ "fuse" ][ "confront_steiner" ]    = %p_rebirth_b02_confront_steiner_fuse;
	
	level.scr_animtree["chair"] = #animtree;
	level.scr_anim[ "chair" ][ "confront_steiner" ]		= %p_rebirth_b02_confront_steiner_chair;
	
	level.scr_model["rebirth_radio"] = "t5_weapon_radio_hold";
  level.scr_animtree["rebirth_radio"] = #animtree;

	level.scr_model["fuse"] = "p_rus_large_battery";	
	level.scr_anim[ "fuse" ][ "office_intro" ]								= %p_rebirth_b05_officebreakin_intro_fuse;
	level.scr_anim[ "fuse" ][ "office_window_break" ]					= %p_rebirth_b05_officebreakin_break_window_fuse;
	level.scr_anim[ "fuse" ][ "office_fuse_end" ][0]					= %p_rebirth_b05_officebreakin_break_window_endidle_fuse;
	level.scr_anim[ "fuse" ][ "office_fuse_start_idle" ][0]		= %p_rebirth_b05_officebreakin_idle_at_fuse_fuse;
	level.scr_anim[ "fuse" ][ "office_fuse_idle" ]						= %p_rebirth_b05_officebreakin_break_window_startidle_fuse;		
	level.scr_animtree["fuse"] = #animtree;

	level.scr_anim[ "door" ][ "confront_steiner_door" ]	= %p_rebirth_b02_confront_steiner_door_anim;
	level.scr_anim[ "door" ][ "lead_to_steiner_door" ]	= %p_rebirth_b02_lead_to_steiner_door_anim;
	level.scr_animtree["door"] = #animtree;
	
	/*
	level.scr_model["weaver_weapon"] = "t5_weapon_enfield_world";
	level.scr_anim["weaver_weapon"]["office_success"] = %ch_rebirth_b05_officebreakin_success_weaver_gun;
	level.scr_animtree["weaver_weapon"] = #animtree;
	*/
}

#using_animtree("fxanim_props");
precache_fx_anims()
{
	level.scr_model[ "crash_heli" ] = "t5_veh_helo_mi8_woodland";
	level.scr_animtree[ "crash_heli" ] = #animtree;
	level.scr_anim[ "crash_heli" ][ "crash" ] = %fxanim_rebirth_heli01_crash_anim;

	addNotetrack_customFunction( "crash_heli", "rotors_hit_ground", maps\rebirth_btr_rail::btr_rail_hip_1_crash_rotor_hit, "crash" );
	addNotetrack_customFunction( "crash_heli", "swap_rotors", maps\rebirth_btr_rail::btr_rail_hip_1_crash_rotor_swap, "crash" );
	addNotetrack_customFunction( "crash_heli", "heli_explode", maps\rebirth_btr_rail::btr_rail_hip_1_crash_explode, "crash" );
	addNotetrack_customFunction( "crash_heli", "heli_impact_01", maps\rebirth_btr_rail::btr_rail_hip_1_crash_impact, "crash" );
	addNotetrack_exploder("crash_heli", "rotors_hit_car", 321, "crash");
	addNotetrack_exploder("crash_heli", "rotors_hit_ground", 322, "crash");
	addNotetrack_exploder("crash_heli", "heli_explode", 323, "crash");
	addNotetrack_exploder("crash_heli", "heli_impact_02", 324, "crash");
}

#using_animtree( "critter" );
precache_critter_anims()
{
	level.scr_anim[ "pig" ][ "panic_pig_idle_1" ][0]	= %a_rebirth_pig_idle_a;
	level.scr_anim[ "pig" ][ "panic_pig_idle_2" ][0]	= %a_rebirth_pig_idle_b;
	level.scr_anim[ "pig" ][ "panic_pig_idle_3" ][0]	= %a_rebirth_pig_idle_c;
	level.scr_anim[ "pig" ][ "pig_death_from_right" ]	= %a_pig_death_from_right;
	level.scr_anim[ "pig" ][ "pig_death_from_back" ]	= %a_pig_death_from_back;
	level.scr_anim[ "pig" ][ "pig_death_from_front" ]	= %a_pig_death_from_front;
	level.scr_anim[ "pig" ][ "pig_death_from_left" ]	= %a_pig_death_from_left;
	level.scr_anim[ "pig" ][ "pig_hoist_squirm" ][0]	= %a_rebirth_pig_hoist_squirm;
	level.scr_anim[ "pig" ][ "pig_hoist_death" ]	= %a_rebirth_pig_hoist_death;
	level.scr_anim[ "pig" ][ "pig_hoist_deathpose" ][0]	= %a_rebirth_pig_hoist_deathpose;
	// level.scr_anim[ "pig" ][ "panic_pig_gas_death" ]	= %a_rebirth_pig_gas_death;
	
//	level.scr_anim[ "monkey" ][ "calm_idle_1" ][0] 			= %a_monkey_calm_idle_01;
//	level.scr_anim[ "monkey" ][ "calm_idle_2" ][0] 			= %a_monkey_calm_idle_02;
//	level.scr_anim[ "monkey" ][ "calm_idle_2_pace" ][0] = %a_monkey_calm_idle_2_pace;
//	level.scr_anim[ "monkey" ][ "calm_pace" ][0] 				= %a_monkey_calm_pace;
//	level.scr_anim[ "monkey" ][ "calm_pace_2_idle" ][0] = %a_monkey_calm_pace_2_idle;
//	level.scr_anim[ "monkey" ][ "calm_idle_3" ][0] 			= %a_monkey_calm_idle_03;
	level.scr_anim[ "monkey" ][ "freaked_1" ][0] 				= %a_monkey_freaked_01;
	level.scr_anim[ "monkey" ][ "freaked_2" ][0] 				= %a_monkey_freaked_02;
	level.scr_anim[ "monkey" ][ "freaked_3" ][0] 				= %a_monkey_freaked_03;
	level.scr_animtree[ "monkey" ] = #animtree;
	
	level.scr_anim[ "monkey" ][ "gas_death_1" ] 					= %a_monkey_gas_death;
	//level.scr_anim[ "monkey" ][ "gas_death_2" ] 					= %a_monkey_gas_death_02;
	level.scr_anim[ "monkey" ][ "shot_death_1" ]		 			= %a_monkey_shot_death; 
	//level.scr_anim[ "monkey" ][ "shot_death_2" ]		 			= %a_monkey_shot_death_02; 
	
	// Seagulls
	level.scr_anim[ "seagull" ][ "takeoff" ] 	= %a_seagull_take_off;
	level.scr_anim[ "seagull" ][ "land"	]		 	= %a_seagull_land;
}


 