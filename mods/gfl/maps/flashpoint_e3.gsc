////////////////////////////////////////////////////////////////////////////////////////////
// FLASHPOINT LEVEL SCRIPTS
// 
//
// Script for event 3 - this covers the following scenes from the design:
//		Slides 22-26
////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
////////////////////////////////////////////////////////////////////////////////////////////
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\flashpoint_util;


////////////////////////////////////////////////////////////////////////////////////////////
// EVENT3 FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////
// Intro anim - self = player
///////////////////////////////////////////////////////////////////////////////////////
#using_animtree("flashpoint");
disguise_anim()
{
	anim_node = get_anim_struct( "6" );
	
	self DisableWeapons();
	self FreezeControls( true );
	
	
	self GiveWeapon( "ak47_acog_sp" );
	self SwitchToWeapon( "ak47_acog_sp" );
	self TakeWeapon( "mp5k_elbit_extclip_sp" );

	//spawn the player body
	self.body = spawn_anim_model( "player_body", anim_node.origin );
	anim_node thread anim_single_aligned( self.body, "in_disguise" );
	
	self StartCameraTween(.2);
	self PlayerLinktoAbsolute(self.body, "tag_player");
	
	anim_node waittill("in_disguise");
	
	self Unlink();
	self.body Unlink();
	self.body Delete();

	level.player thread playVO_proper( "fucking_better" );

	self thread waitThenGiveControlToPlayer( 0.5 );
	
	//Woods pointer changed!
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_OBJ_FOLLOW" );
}


playWoodsInDisgiuseAnim()
{
	self gun_switchto( "ak47_acog_sp", "right" );
	
	level.woods.name = "";

	anim_node = get_anim_struct( "6" );
	anim_node thread anim_single_aligned( level.woods, "in_disguise" );
	anim_node waittill( "in_disguise" );
	level.woods setgoalpos( level.woods.origin );

	level.woods.name = "Woods";

	//flag_set( "PAST_INVESTIGATION_GUARDS" );
}


stop_player_at_jeep_trig()
{
	stop_player_at_jeep_trig = getent( "stop_player_at_jeep", "targetname" );
	stop_player_at_jeep_trig waittill( "trigger" );
	
	self.body = spawn_anim_model( "player_body", self.origin );
	self.body Hide();
	self StartCameraTween(.2);
	self PlayerLinkToDelta(self.body, "tag_player", 1, 180, 180, 90, 30, false);

	flag_wait( "WOODS_ANIM_COMPLETED" );
	self FreezeControls( false );
	self Unlink();
	self.body Unlink();
	self.body Delete();
}


distance_to_ai( ai_to_stay_close_to )
{
	self endon( "death" );
	level endon( "BASE_ALERT" );
	
	cycle_lines = 0;
	level.play_warning_lines = 0;
	
	//Better stay with Woods!
	while( 1 )
	{
		current_distance = distance( ai_to_stay_close_to.origin, self.origin );
			
		if( distance( ai_to_stay_close_to.origin, self.origin ) > 960 )
		{
			//FAIL!
			maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_STAY_WITH_WOODS");		
		}
		
		if( (level.play_warning_lines==1) && (current_distance > 725) )
		{
			//Warning!
			if( cycle_lines==0 )
			{
				level.woods thread playVO_proper_adhoc( "stay1" );//Where the Hell are you goin'?
				cycle_lines = 1;
			}
			else if( cycle_lines==1 )
			{
				level.woods thread playVO_proper_adhoc( "stay2" );//Mason! Stay with me!
				cycle_lines = 2;
			}
			else if( cycle_lines==2 )
			{
				level.woods thread playVO_proper_adhoc( "stay3" );//Get back here, Mason
				cycle_lines = 0;
			}
			wait( 5.0 );
		}
		wait( 0.05 );	
	}
}


squad_fail_trigger()
{
	level endon( "WOODS_ANIM_COMPLETED" );
	
	squad_fail_trigger = getent( "squad_fail_trigger", "targetname" );
	squad_fail_trigger waittill( "trigger" );
	
	//FAIL!
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_STAY_WITH_WOODS");		
}


check_squad_fail_trigger_persistent()
{
	level endon( "PLAYER_ON_ROOF" );

	self waittill( "trigger" );
	
	//FAIL!
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_STAY_WITH_WOODS");		

}
squad_fail_trigger_persistent()
{
	squad_fail_trigger_array = getentarray( "squad_fail_trigger_b", "targetname" );
	
	for( i=0;i<squad_fail_trigger_array.size; i++ )
	{
		squad_fail_trigger_array[i] thread check_squad_fail_trigger_persistent();
	}
}


event3_WoodsInDisguise()
{
	level thread autosave_after_delay( 2, "flashpoint_e3" );
	//autosave_by_name("flashpoint_e3");
	
	//FLASHPOINT_OBJ_MEET_SQUAD
	set_event_objective( 2, "active" );
	
	//level.default_run_speed = 190; 
	SetSavedDvar( "g_speed", 150 ); 
	
	body_tarp = getent( "body_tarp", "targetname" );
	body_tarp Show();
	
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;

	
	//play woods in disguise anim
	level.player thread distance_to_ai( level.woods );
	level.player thread disguise_anim();
	level.woods thread playWoodsInDisgiuseAnim();
	level.player thread spawnTheInvestigationGuards();
	level.player thread squad_fail_trigger();
	level.player thread squad_fail_trigger_persistent();

	event3_KillTheDogs();	
}

wait_for_damage()
{
	self endon( "death" );
	
	self waittill( "damage", amount, attacker );
	if( attacker == level.player )
	{
		flag_set( "INVESTIGATION_GUARDS_ALERT" );
	}
}

wait_for_death()
{
	level endon( "MIGS_TRIGGER" );
	self waittill( "death" );
	//flag_set( "INVESTIGATION_GUARDS_ALERT" );
}

player_takes_damage()
{
	level endon( "MIGS_TRIGGER" );
	
	self waittill( "damage" );
	wait( 2.0 );

	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_BLOODYUNIFORM");		
	
	//level_fail( "Bloody Uniform" );	
}

player_fires_weapon()
{
	level endon( "MIGS_TRIGGER" );
	
	self waittill_any( "weapon_fired", "grenade_fire" );
	flag_set( "INVESTIGATION_GUARDS_ALERT" );
}

player_kills_both_guards_cleanly()
{
	level endon( "PAST_INVESTIGATION_GUARDS" );
	self endon( "damage" );
	
	//Check the guards are dead
	while( 1 )
	{
		still_alive = false;
		if( isdefined(level.dumpguard3) && isalive(level.dumpguard3) )
		{
			still_alive = true;
		}
		if( isdefined(level.dumpguard4) && isalive(level.dumpguard4) )
		{
			still_alive = true;
		}
	
		if( still_alive==false )
		{
			wait( 2.0 );
			level.woods thread playVO_proper( "bloody" );
			//playVO( "Come on lets go, quickly, lucky you did not get all bloody!", "Woods" );
			level.woods.ignoreall = true;
			
			flag_set( "PAST_INVESTIGATION_GUARDS" );
		}
		wait( 0.05 );
	}
}
	
wait_for_alert()
{
	level endon( "MIGS_TRIGGER" );
	self endon( "death" );
	
	flag_wait( "INVESTIGATION_GUARDS_ALERT" );
	self stopanimscripted();
	level.woods stopanimscripted();
	level.woods.ignoreall = false;
	level.player SetLowReady( false );
	level.player AllowJump( true );
	level.player AllowAds( true );
	level.player AllowMelee( true );
	level.player AllowSprint( true );

	
	level.player thread player_takes_damage();
	level.player thread player_fires_weapon();
	level.player thread player_kills_both_guards_cleanly();
	
	self setgoalpos( self.origin );
	self.ignoreall = false;
	self.perfectAim = true;
	self.favoriteenemy = level.player;

	//while( IsAlive(enemy) )
	//{
	//	self shoot_at_target( level.player );
	//	wait(0.05);
	//}
	//self.perfectAim = false;
}

setup_investigation_guard()
{
	self endon("death");
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.dofiringdeath = false;
	self.ignoreall = true;
	self.goalradius = 32;
	self.dropweapon = false;
	self.health = 200;
	
	self thread wait_for_damage();
	self thread wait_for_death();
}


// guard_runs_away_and_dies( nodename )
// {
// 	//Guards exit nodes (where the dogs are for now)
// 	dump_guard_goto = getnode( nodename, "targetname" );	
// 	self setgoalnode( dump_guard_goto );
// 	self waittill ("goal");
// 	self Delete();
// }

//Whats that noise sequence 
// whats_that_noise_anim_woods()
// {
// 	level endon( "INVESTIGATION_GUARDS_ALERT" );
// 	
// 	anim_node = get_anim_struct( "6" );
// 	anim_node thread anim_single_aligned( self, "whats_that_noise" );
// 	wait( 0.1 );
// 	println( "WOODS=" + self.origin );
// 	anim_node waittill( "whats_that_noise" );
// 	self setgoalpos( self.origin );
// 	flag_set( "PAST_INVESTIGATION_GUARDS" );
// }

whats_that_noise_anim_guards( exitnode, animname )
{
	level endon( "INVESTIGATION_GUARDS_ALERT" );
	
	self anim_set_blend_out_time( 0.2 );

	anim_node = get_anim_struct( "6" );
	//anim_node anim_reach_aligned( self, animname );
	anim_node thread anim_single_aligned( self, animname );
	anim_node waittill( animname );
	flag_set( "PAST_INVESTIGATION_GUARDS" );
	//self setgoalpos( self.origin );

	//Guards exit nodes (where the dogs are for now)
	dump_guard_goto = getnode( exitnode, "targetname" );	
	self setgoalnode( dump_guard_goto );
	self waittill ("goal");
	self Delete();
}

whats_that_noise_player()
{
	level endon( "INVESTIGATION_GUARDS_ALERT" );
	
	//wait( 6.0 );
	level.player SetLowReady( true );
	level.player AllowJump( false );
	level.player AllowAds( false );
	level.player AllowMelee( false );
	level.player AllowSprint( false );
}

spawnTheInvestigationGuards()
{
// 	spawn_investigation_guards_trig = getent( "spawn_investigation_guards", "targetname" );
// 	spawn_investigation_guards_trig waittill( "trigger" );
// 	debug_script( "HIT SPAWN INV GUARDS TRIGGER" );
// 	spawn_investigation_guards_trig Delete();
	
	
// 	woods_postdogs = getnode( "woods_postdogs", "targetname" );	
// 	level.woods setgoalnode( woods_postdogs );
// 	level.woods waittill( "goal" );
	
	//woods_event4_start = getnode( "event4_start", "targetname" );	
	//level.woods setgoalnode( woods_event4_start );
	//level.woods waittill( "goal" );
	
//  	level.woods.animname = "generic";
//  	level.woods set_run_anim( "patrol_walk" );
//  	level.woods.disablearrivals = true;
//  	level.woods.disableexits = true;
	
	
	//Spawn guards for next section
	level.dumpguard3 = simple_spawn_single( "dump_guard3", ::setup_investigation_guard );
	level.dumpguard4 = simple_spawn_single( "dump_guard4", ::setup_investigation_guard );
	level.dumpguard3.animname = "guard3";
	level.dumpguard4.animname = "guard4";
	
	level.dumpguard3 thread wait_for_alert();
	level.dumpguard4 thread wait_for_alert();

	//level.woods thread whats_that_noise_anim_woods();
	
	level waittill( "start_soldier_anim" );	
	level.dumpguard3 thread whats_that_noise_anim_guards( "dump_guard3_goto", "whats_that_noise_g3" );
	level.dumpguard4 thread whats_that_noise_anim_guards( "dump_guard4_goto", "whats_that_noise_g4" );
	level.player thread whats_that_noise_player();
	
	flag_wait( "PAST_INVESTIGATION_GUARDS" );
	
	player = get_players()[0];
	player enableoffhandweapons();

	level.play_warning_lines = 1;
	

	//level.player SetLowReady( false );
	//level.player AllowAds( true );
	
	//Guards exit nodes (where the dogs are for now)
	//level.dumpguard3 thread guard_runs_away_and_dies( "dump_guard3_goto" );
	//level.dumpguard4 thread guard_runs_away_and_dies( "dump_guard4_goto" );
	
	//wait( 4.0 );
	//playVO( "Come on lets go, quickly", "Woods" );
	//wait( 1.0 );
	//flag_set( "PAST_INVESTIGATION_GUARDS" );
	
//  	level.woods.animname = "woods";
//  	level.woods.disablearrivals = false;
//  	level.woods.disableexits = false;
//  	level.woods set_run_anim( "run_fast", true );

}

event3_KillTheDogs()
{
/*
 As Woods and Player approach the sewer area, they are surprised by a bunch of dogs drinking the dirty water down below
 The dogs (either strays or guard) start barking like crazy and all start running towards the Player and Woods
 Player must kill the dogs
*/

	debug_event( "event3_KillTheDogs", "start" );
	//flag_wait( "ALL_DOGS_ARE_DEAD" );
	level.woods.ignoreall = true;
	
	
	//playVO( "Shit lets go, someone might have heard that", "Woods" );
	level.woods.animname = "woods";
 	//level.woods.disablearrivals = false;
 	//level.woods.disableexits = false;
 	level.woods set_run_anim( "run_fast", true );

	//woods_postdogs = getnode( "woods_postdogs", "targetname" );	
	//level.woods setgoalnode( woods_postdogs );
	//level.woods waittill( "goal" );
	
	//level.player thread spawnTheInvestigationGuards();
	flag_wait( "PAST_INVESTIGATION_GUARDS" );
	
	level.woods thread playVO_proper( "upahead", 4.0 ); //Bowman should be right up ahead.
//	level.bowman thread playVO_proper( "hostiles", 4.0 ); //X-ray this is Whiskey. Hostiles in sight. Taking them out.
//	level.woods thread playVO_proper( "hustle", 4.0 ); //Hustle up.
	

	level.woods.ignoreall = true;
	
	//playVO( "Done, move on", "Woods" );
	
	level.player SetLowReady( false );
	level.player AllowJump( true );
	level.player AllowAds( true );
	level.player AllowMelee( true );
	level.player AllowSprint( true );
	
	event3_MigFlyover();
}
	
migs()
{
	trigger_migs = getent( "trigger_migs", "targetname" );
	trigger_migs waittill( "trigger" );
	flag_set( "MIGS_TRIGGER" );
	level notify ( "set_portal_override_migsoverhead" );
	debug_script( "HIT MIG TRIGGER" );
	
	//Mig flyover scene
	mig_flyover_01_node = GetVehicleNode( "mig_flyover_01_node", "targetname" );
	mig_flyover_02_node = GetVehicleNode( "mig_flyover_02_node", "targetname" );
	mig_flyover_01 = SpawnVehicle( "t5_veh_air_mig_21_ussr_flying", "mig_flyover_01", "plane_mig21_lowres", mig_flyover_01_node.origin, (0,0,0) );
	mig_flyover_02 = SpawnVehicle( "t5_veh_air_mig_21_ussr_flying", "mig_flyover_02", "plane_mig21_lowres", mig_flyover_02_node.origin, (0,0,0) );
	mig_flyover_01 thread maps\flashpoint_e1::check_play_vehicle_rumble( 4000.0 );
	mig_flyover_02 thread maps\flashpoint_e1::check_play_vehicle_rumble( 4000.0 );
	//kevin adding sound calls
	mig_flyover_01 thread maps\flashpoint_amb::mig_fake_audio(3);
	maps\_vehicle::vehicle_init( mig_flyover_01 );
	maps\_vehicle::vehicle_init( mig_flyover_02 );
	mig_flyover_01 thread go_path( mig_flyover_01_node );
	mig_flyover_02 thread go_path( mig_flyover_02_node );
	
	mig_flyover_01 thread playPlaneFx();
	mig_flyover_02 thread playPlaneFx();
	
	//Flashpoint effects for Mig flyby
	wait( 3.0 );
	exploder( 320 );
}

event3_MigFlyover()
{
/*
 Woods and Player now head for the Jeep area
 NOTE: there used to be (GL build) a nice MIG flyover here � let�s restore it
 AUDIO of the flyover should be crazy loud
 Woods VO: �Our SOG operatives are going in � watch this� � this will foreshadow the action on the next slide

*/
	debug_event( "event3_MigFlyover", "start" );

	level.player thread migs();
	level.player thread spawnSquadAtJeep();
	
	debug_event( "event3_MigFlyover", "end" );
	event3_MeetWithHudson();
}


///////////////////////////////////////////////////////////////////////////////////////
// Anim for UAZ in tire changing event
///////////////////////////////////////////////////////////////////////////////////////
// #using_animtree("animated_props");
// jeep_tire_anim()
// {
// 	jeep = getent( "jeep_tire_event", "targetname" );
// 	jeep UseAnimTree(#animtree);
// 	jeep.animname = "uaz_tire";
// 	self anim_single_aligned( jeep, "tirechange" );
// }

#using_animtree("generic_human");

jeep_ai_anim_spetz1( animnode )
{
	self.dieQuietly = true; //kevin avoid death sounds
	animnode thread anim_first_frame( self, "tirechange_spetz1" );
	flag_wait( "START_SQUAD_ANIMS" );
	
	animnode thread anim_single_aligned( self, "tirechange_spetz1" );
	animnode waittill( "tirechange_spetz1" );
	self startragdoll();
	self dodamage( self.health, self.origin );
	flag_set( "TIRE_CHANGERS_KILLED" );

}

jeep_ai_anim_spetz2( animnode )
{
	self.dieQuietly = true; //kevin avoid death sounds
	animnode thread anim_first_frame( self, "tirechange_spetz2" );
	flag_wait( "START_SQUAD_ANIMS" );
	
	animnode thread anim_single_aligned( self, "tirechange_spetz2" );
	animnode waittill( "tirechange_spetz2" );
	self startragdoll();
	self dodamage( self.health, self.origin );
	flag_set( "TIRE_CHANGERS_KILLED" );
}

jeep_ai_anim_brooks( animnode )
{
	animnode thread anim_first_frame( self, "tirechange_brooks" );
	flag_wait( "START_SQUAD_ANIMS" );
	
	animnode thread anim_single_aligned( self, "tirechange_brooks" );
	animnode waittill( "tirechange_brooks" );
	self SetGoalPos( self.origin );
}

jeep_ai_anim_bowman( animnode )
{
	animnode thread anim_first_frame( self, "tirechange_bowman" );
	flag_wait( "START_SQUAD_ANIMS" );
	
	animnode thread anim_single_aligned( self, "tirechange_bowman" );
	animnode waittill( "tirechange_bowman" );
	self SetGoalPos( self.origin );
}


jeep_ai_anim()
{
	//org = getent( "org_tire", "targetname" );
	animnode = get_anim_struct("7");
	
	level.tirechanger01 thread jeep_ai_anim_spetz1( animnode );
	level.tirechanger02 thread jeep_ai_anim_spetz2( animnode );
	level.brooks thread jeep_ai_anim_brooks( animnode );
	level.bowman thread jeep_ai_anim_bowman( animnode );
	
	spawn_squad_trig = getent( "spawn_squad", "targetname" );
	spawn_squad_trig waittill( "trigger" );
	flag_set( "START_SQUAD_ANIMS" );
	
	//Guards idle at gate
//	level.base_guard_idle_gate_1 = simple_spawn_single( "base_guard_idle_gate_1", maps\flashpoint_e4::setup_base_guard );
//	level.base_guard_idle_gate_2 = simple_spawn_single( "base_guard_idle_gate_2", maps\flashpoint_e4::setup_base_guard );
//	level.base_guard_idle_gate_3 = simple_spawn_single( "base_guard_idle_gate_3", maps\flashpoint_e4::setup_base_guard );
//	level.base_guard_idle_gate_1 set_generic_run_anim( "patrol_walk" );
//	level.base_guard_idle_gate_2 set_generic_run_anim( "patrol_walk" );
//	level.base_guard_idle_gate_3 set_generic_run_anim( "patrol_walk" );
//	level.base_guard_idle_gate_1.disableTurns = true;
//	level.base_guard_idle_gate_2.disableTurns = true;
//	level.base_guard_idle_gate_3.disableTurns = true;
//
//	level.base_guard_idle_gate_1 thread maps\flashpoint_e4::base_guard_anim_single_then_loop( "soldier", "base_start_a", "base_start_idle_a", "8" );
//	level.base_guard_idle_gate_2 thread maps\flashpoint_e4::base_guard_anim_single_then_loop( "soldier", "base_start_b", "base_start_idle_b", "8" );
//	level.base_guard_idle_gate_3 thread maps\flashpoint_e4::base_guard_anim_single_then_loop( "soldier", "base_start_c", "base_start_idle_c", "8" );
//	//level.base_guard_idle_gate_3 thread base_guard_anim_reach_then_loop( "soldier", "base_spetz_idle3", "8" );//bend
//	
//	level.base_guard_idle_gate_1 thread maps\flashpoint_e4::got_to_exit_on_alert( "gate_exitnode" );//bend
//	level.base_guard_idle_gate_2 thread maps\flashpoint_e4::got_to_exit_on_alert( "gate_exitnode" );//bend
//	level.base_guard_idle_gate_3 thread maps\flashpoint_e4::got_to_exit_on_alert( "gate_exitnode" );//bend

	
	
// 	brooks_org = SpawnStruct();
// 	brooks_org.origin = org.origin;
// 	brooks_org.angles = org.angles;
// 	

		
// 	org thread anim_single_aligned( level.tirechanger01, "tirechange_spetz1" );
// 	org thread anim_single_aligned( level.tirechanger02, "tirechange_spetz2" );
// 	brooks_org thread anim_single_aligned( level.brooks, "tirechange_brooks" );
// 	org thread anim_single_aligned( level.bowman, "tirechange_bowman" );
	
	
	//println( "TIRECHANGE - " + level.brooks.animname + " = " +level.brooks.origin );
	//println( "TIRECHANGE - " + level.bowman.animname + " = " +level.bowman.origin );
	//level.brooks setgoalpos( GetNode("brooks_patrol", "targetname").origin );
	//level.bowman setgoalpos( GetNode("bowman_patrol", "targetname").origin );
// 	org waittill( "tirechange" );
// 	
// 	level.tirechanger01 startragdoll();
// 	level.tirechanger01 dodamage( level.tirechanger01.health, level.tirechanger01.origin );
// 	level.tirechanger02 startragdoll();
// 	level.tirechanger02 dodamage( level.tirechanger02.health, level.tirechanger02.origin );
// 	
//	flag_set( "TIRE_CHANGERS_KILLED" );
	
//	brooks_org waittill( "tirechange" );
//	level.brooks SetGoalPos( level.brooks.origin ); //-- Brooks ends his animation first, but the patrol waits for Woods to finish his
}

spawnSquadAtJeep()
{
	level.woods.ignoreall = true;
	
	flag_wait( "MIGS_TRIGGER" );
	
	//spawn_squad_trig = getent( "spawn_squad", "targetname" );
	//spawn_squad_trig waittill( "trigger" );
	debug_script( "HIT SPAWN SQUAD TRIGGER" );
	
	bowman_post_jeepmeetup = getnode( "bowman_post_jeepmeetup", "targetname" );	
	brooks_post_jeepmeetup = getnode( "brooks_post_jeepmeetup", "targetname" );	
	maps\flashpoint::spawn_bowman_undercover( bowman_post_jeepmeetup, true );
	maps\flashpoint::spawn_brooks_undercover( brooks_post_jeepmeetup, true );
	
	level.tirechanger01 = simple_spawn_single( "spawner_tirechanger01_ai" );
	level.tirechanger01.ignoreall = true;
	level.tirechanger01.goalradius = 32;
	level.tirechanger01.dofiringdeath = false;
	level.tirechanger01.animname = "rus1_tire";
	level.tirechanger01.dropweapon = false;
	
	level.tirechanger02 = simple_spawn_single( "spawner_tirechanger02_ai" );
	level.tirechanger02.ignoreall = true;
	level.tirechanger02.goalradius = 32;
	level.tirechanger02.dofiringdeath = false;
	level.tirechanger02.animname = "rus2_tire";
	level.tirechanger02.dropweapon = false;
	
	level.bowman thread playVO_proper( "hostiles", 1.0 ); //X-ray this is Whiskey. Hostiles in sight. Taking them out.
	level.woods thread playVO_proper( "hustle", 5.0 ); //Hustle up.
	
	//Play anim on the 4 AI
	jeep_ai_anim();
}

//Fail conditions
// check_leave_area( triggername )
// {
// 	level endon( "COMMS_BUILDING_DOOR_OPEN" );
// 	
// 	leave_trigger = getent( triggername, "targetname" );
// 	leave_trigger waittill( "trigger" );
// 	
// 	//FAIL!
// 	SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_STAY_WITH_WOODS" ); 
// 	MissionFailed();
// 	
// 	/*
// 	//playVO( "We've been spotted!!!!", "Woods" );
// 	level.woods thread playVO_proper( "spotted" );
// 	level.woods thread playVO_proper( "spotted2", 1.0 );
// 	
// 	//iprintlnbold( "triggername=" + triggername + "\n" );
// 	
// 	//Send everyone to the player position (+ TODO some helicopters)
// 	flag_set( "PLAYER_MUST_DIE" );
// 	
// 	
// 	level.player SetLowReady( false );
// 	level.player AllowJump( true );
// 	level.player AllowAds( true );
// 	level.player AllowMelee( true );
// 	level.player AllowSprint( true );
// 	
// 	
// 	SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_SQUADMEETUP_STAYINAREA" ); 
// 	//MissionFailed();
// 	
// 	if( isdefined(level.tirechanger01) )
// 	{
// 		level.tirechanger01 stopanimscripted();
// 		level.tirechanger01.ignoreall = false;	
// 	}
// 	if( isdefined(level.tirechanger02) )
// 	{
// 		level.tirechanger02 stopanimscripted();
// 		level.tirechanger02.ignoreall = false;
// 	}
// 	
// 	level.bowman stopanimscripted();
// 	level.brooks stopanimscripted();
// 	level.bowman.ignoreall = false;
// 	level.brooks.ignoreall = false;
// 	
// 	level.woods.ignoreall = false;
// 	
// 	//Spawn helicopters to kill the player
// 	base_heli_01_start = GetVehicleNode( "base_heli_01_start", "targetname" );
// 	base_heli_02_start = GetVehicleNode( "base_heli_02_start", "targetname" );
// 	base_heli_01 = SpawnVehicle( "t5_veh_helo_mi8_woodland", "base_heli_01", "heli_hip", base_heli_01_start.origin, (0,0,0) );
// 	base_heli_02 = SpawnVehicle( "t5_veh_helo_mi8_woodland", "base_heli_02", "heli_hip", base_heli_02_start.origin, (0,0,0) );
// 	base_heli_01 thread maps\flashpoint_e1::check_play_vehicle_rumble();
// 	base_heli_02 thread maps\flashpoint_e1::check_play_vehicle_rumble();
// 	maps\_vehicle::vehicle_init( base_heli_01 );
// 	maps\_vehicle::vehicle_init( base_heli_02 );
// 	base_heli_01.health = 99999;
// 	base_heli_02.health = 99999;
// 	base_heli_01.drivepath = 1;
// 	base_heli_02.drivepath = 1;
// 	
// 	base_heli_01.myindex = 0;
// 	base_heli_02.myindex = 1;
// 	
// 	level.player thread attack_player_2( base_heli_01, "COMMS_BUILDING_DOOR_OPEN" );
// 	level.player thread attack_player_2( base_heli_02, "COMMS_BUILDING_DOOR_OPEN" );
// 	*/
// }

// check_squadmeetup_disturb()
// {
// 	level endon( "WOODS_ANIM_STARTED" );
// 	
// 	squadmeetup_disturb = getent( "squadmeetup_disturb", "targetname" );
// 	squadmeetup_disturb waittill( "trigger" );
// 	
// 	//playVO( "You alerted the tire changers!!!!", "Woods" );
// 	
// 	//Send everyone to the player position (+ TODO some helicopters)
// 	flag_set( "PLAYER_MUST_DIE" );
// 	
// 	level.tirechanger01 stopanimscripted();
// 	level.tirechanger02 stopanimscripted();
// 	level.tirechanger01.ignoreall = false;
// 	level.tirechanger02.ignoreall = false;
// 	
// 	level.bowman stopanimscripted();
// 	level.brooks stopanimscripted();
// 	level.bowman.ignoreall = false;
// 	level.brooks.ignoreall = false;
// 	
// 	level.woods.ignoreall = false;
// 	
// 	SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_SQUADMEETUP_DISTURB" ); 
// 	MissionFailed();
// }

woods_tirechange( guy )
{
	flag_set( "WOODS_ANIM_STARTED" );
	org = get_anim_struct("7");
	org anim_single_aligned( level.woods, "tirechange_woods" );
	//org waittill( "tirechange" );
	//level.woods setgoalpos( level.woods.origin );
	println( "TIRECHANGE - " + level.woods.animname + " = " +level.woods.origin );
	flag_set( "WOODS_ANIM_COMPLETED");
}

event3_MeetWithHudson()
{
/*
 Restore this vignette from the GL build
 Trigger sooner so that it is over by the time the Player/Woods reach it (Woods should not stop and wait)
 Trigger so it is a simultaneous strike
 We have now met up with Brooks and Bowman who are also in disguise
 Woods updates hudson and Brooks about Weaver�s unfortunate fate- the undercover was blown and he�s in deep trouble and will need rescuing
*/


	level endon( "PLAYER_MUST_DIE" );
	debug_event( "event3_MeetWithHudson", "start" );
	
//	level.player thread check_leave_area( "squad_meetup_container_A" );
//	level.player thread check_leave_area( "squad_meetup_container_B" );
//	level.player thread check_leave_area( "squad_meetup_container_C" );
//	level.player thread check_squadmeetup_disturb();
	
	
	/*
	woods_event4_start = getnode( "event4_start", "targetname" );	
	level.woods setgoalnode( woods_event4_start );
	*/
	//-- send Woods to where he needs to be for the next animation
	
	org = get_anim_struct("7");
	org anim_reach_aligned( level.woods, "tirechange_woods" );
	level.woods waittill( "goal" );
	
	level.play_warning_lines = 0;
	
	debug_script( "WOODS PRE JEEP LOCATION" );
	
	level.woods.ignoreall = true;

	level.player SetLowReady( true );
	level.player AllowJump( false );
	level.player AllowAds( false );
	level.player AllowMelee( false );
	level.player AllowSprint( false );
	
	//Wait here till hudson and lewis have killed the tire changers
	flag_wait( "WOODS_ANIM_STARTED" );
	
	//wait( 4.0 );
	
		
	flag_wait( "WOODS_ANIM_COMPLETED");
	
	//playVO( "Ok lets go, stay together..", "Woods" );
	//woods_post_jeepmeetup = getnode( "woods_post_jeepmeetup", "targetname" );	
	//level.woods waittill( "goal" );
	
	debug_event( "event3_MeetWithHudson", "end" );
	
	SetSavedDvar( "g_speed", level.default_run_speed ); 
	
	//Goto next event
	flag_set("BEGIN_EVENT4");
}




////////////////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////////////////
 