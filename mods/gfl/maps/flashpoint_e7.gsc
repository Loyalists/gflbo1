////////////////////////////////////////////////////////////////////////////////////////////
// FLASHPOINT LEVEL SCRIPTS
//
//
// Script for event 7 - this covers the following scenes from the design:
//		Slides 39-42
////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
////////////////////////////////////////////////////////////////////////////////////////////
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\flashpoint_util;
#include maps\_music;
#include maps\_flyover_audio;



////////////////////////////////////////////////////////////////////////////////////////////
// EVENT7 FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////


scientist_takes_damage()
{
	self endon("death");
	
	//Not very strong......
	self waittill( "damage" );
	self Die();
}

setup_sniper_scientist()
{
	self endon("death");

	self.goalradius = 32;
	self.ignoreall = true;
	self.dropweapon = false;
	self.animname = "scientist";
	
	self thread scientist_takes_damage();
}

count_alive_scientists( timeLeft )
{
	level endon( "ALL_SCIENTISTS_ARE_DEAD" );
	
	startTime = GetTime();
	
	while( (GetTime() - startTime) < (timeLeft*1000.0) )
	{
		anyscientistsleft = false;
		for( i=0;i<11;i++ )
		{
			if( isalive( level.sniper_scientist[i] ) )
			{
				anyscientistsleft = true;
				break;
			}
		}
		if( anyscientistsleft==false )
		{
			//playVO( "You got them all, good!", "Woods" );
			level.all_scientists_dead = true;
			//Objective_Set3D(level.obj_scientist, false);
			//Objective_State(level.obj_scientist, "done");
			flag_set( "ALL_SCIENTISTS_ARE_DEAD" );
		}
		wait( 0.1 );
	}
	
	//playVO( "You let some get away! Crap", "Woods" );
	level.all_scientists_dead = false;
	
	//Objective_Set3D(level.obj_scientist, false);
	//Objective_State(level.obj_scientist, "done");
}

// go_over_wall()
// {
// 	//Tell the squad to move it over the wall
// 	woods_sniper_spot = getnode( "woods_sniper_spot", "targetname" );
// 	hudson_sniper_spot = getnode( "hudson_sniper_spot", "targetname" );
// 	lewis_sniper_spot = getnode( "lewis_sniper_spot", "targetname" );
// 	weaver_sniper_spot = getnode( "weaver_sniper_spot", "targetname" );
// 	level.woods SetGoalPos( woods_sniper_spot.origin );	
// 	level.brooks SetGoalPos( hudson_sniper_spot.origin );
// 	level.bowman SetGoalPos( lewis_sniper_spot.origin );
// 	level.weaver SetGoalPos( weaver_sniper_spot.origin );
// }

///////////////////////////////////////////////////////////////////////////////////////
// Open rocket stabilizer
///////////////////////////////////////////////////////////////////////////////////////
open_rocket_stabilizer()
{
	//trigger_wait( "trigger_open_stabilizer", "targetname" );
	
	//autosave_by_name( "launchpad_elevator" );
	
	//-- turn off the lights on the Gantries
	stop_exploder(120);
	
	stab_big = getent( "rocket_stabilizer_big", "targetname" );
	
	stab_big BypassSledgehammer();
	
	//Kevin adding a notify for audio
	level notify( "stabilizer_audio" );
	
	stab_big rotateroll( -55, 5.0, 0.5, 1.0 );
	stab_big waittill("rotatedone");
	flag_set("GANTRIES_STABILIZER_OPEN");
}


///////////////////////////////////////////////////////////////////////////////////////
// Open rocket gantry
///////////////////////////////////////////////////////////////////////////////////////
open_rocket_gantry()
{
	exploder( 667 );
	
	//TUEY Set music to POST BASE FIGHT - back to underscore.
	setmusicstate ("POST_BASE_FIGHT");
	
	//-- turn off the lights on the Gantries
	stop_exploder(120);
	
	level notify( "open_gantry" );
	//kevin audio notify to prevent sound from triggering when player checkpoints
	level notify( "open_gantry_audio" );
	
	//Kevin putting in wait for audio intro to finish
	wait( 5.0 );//Kevin added 2 more seconds so that it times out with audio.
	
	stop_exploder( 666 );
	stop_exploder( 667 );
	
	gantry_1 = getent( "gantry_1", "targetname" );
	gantry_2 = getent( "gantry_2", "targetname" );
	gantry_1_arm = getent( "gantry_1_arm", "targetname" );
	gantry_2_arm = getent( "gantry_2_arm", "targetname" );
	
	gantry_1 BypassSledgehammer();
	gantry_2 BypassSledgehammer();
	gantry_1_arm BypassSledgehammer();
	gantry_2_arm BypassSledgehammer();
	
	exploder( 201 );
	
	gantry_1 rotatepitch( -80, 45.0 );
	gantry_2 rotatepitch( 80, 45.0 );
	gantry_1_arm rotatepitch( 80, 45.0 );
	gantry_2_arm rotatepitch( 80, 45.0 );

	level thread open_rocket_stabilizer();
}

play_up_the_stairs_start( animname )
{
	self endon( "death" );
	anim_node = get_anim_struct( "13" );
	anim_node anim_first_frame( self, animname );
	self setgoalpos( self.origin );
}

play_up_the_stairs_run( animname )
{
	
	self endon( "death" );
	
	/*
	anim_node = get_anim_struct( "13" );
	anim_node thread anim_single_aligned( self, animname);
	anim_node waittill( animname );
	*/
	
	goal_node = GetNode("scientist_end_node", "targetname");
	self.goalradius = 12;
	self SetGoalPos( goal_node.origin );
	self waittill("goal");
	
	self setgoalpos( self.origin );
	//playVO( "ONE GOT AWAY!!!!!!!!!!!!!!!!!!", "Woods" );
	flag_set( "ALL_SCIENTISTS_ARE_DEAD" ); //stop keeping track - you failed
	//Objective_State(level.obj_scientist, "done");
	//Objective_Set3D(level.obj_scientist, false);
	level.all_scientists_dead = false;
	self Delete(); //Deleting notifies death
}

// start_scientist_anims()
// {	
// 	wait( 1.0 );
// 	//if( isdefined(level.sniper_scientist[0]) )
// 	{
// 		level.sniper_scientist[0] thread play_up_the_stairs_start( "up_the_stairs1" );
// 	}
// 	//if( isdefined(level.sniper_scientist[1]) )
// 	{
// 		level.sniper_scientist[1] thread play_up_the_stairs_start( "up_the_stairs2" );
// 	}
// 	//if( isdefined(level.sniper_scientist[2]) )
// 	{
// 		level.sniper_scientist[2] thread play_up_the_stairs_start( "up_the_stairs3" );
// 	}
// 	//if( isdefined(level.sniper_scientist[3]) )
// 	{
// 		level.sniper_scientist[3] thread play_up_the_stairs_start( "up_the_stairs4" );
// 	}
// 	//if( isdefined(level.sniper_scientist[4]) )
// 	{
// 		level.sniper_scientist[4] thread play_up_the_stairs_start( "up_the_stairs5" );
// 	}
// }
// 

start_scientist_run_anims()
{
	for( i=0;i<11;i++ )
	{
		if(  isdefined(level.sniper_scientist[i]) && isalive( level.sniper_scientist[i] ) )
		{
			level.sniper_scientist[i] thread play_up_the_stairs_run( "up_the_stairs1" );
		}
	}
}

// 	if( isdefined(level.sniper_scientist[0]) )
// 	{
// 		level.sniper_scientist[0] thread play_up_the_stairs_run( "up_the_stairs1" );
// 	}
// 	
// 	wait(0.25);
// 	
// 	if( isdefined(level.sniper_scientist[1]) )
// 	{
// 		level.sniper_scientist[1] thread play_up_the_stairs_run( "up_the_stairs2" );
// 	}
// 	
// 	wait(0.25);
// 	
// 	if( isdefined(level.sniper_scientist[2]) )
// 	{
// 		level.sniper_scientist[2] thread play_up_the_stairs_run( "up_the_stairs3" );
// 	}
// 	
// 	wait(0.25);
// 	
// 	if( isdefined(level.sniper_scientist[3]) )
// 	{
// 		level.sniper_scientist[3] thread play_up_the_stairs_run( "up_the_stairs4" );
// 	}
// 	
// 	wait(0.5);
// 	
// 	if( isdefined(level.sniper_scientist[4]) )
// 	{
// 		level.sniper_scientist[4] thread play_up_the_stairs_run( "up_the_stairs5" );
// 	}
// }

delete_me_after( sec )
{
	self endon( "delete" );
	self endon( "removed" );
	wait( sec );
	self destroy();
	self notify ( "removed" );
}

takeoff_when_timer_is_out( waittime )
{
	self endon( "delete" );
	self endon( "removed" );
	level endon( "CHECKPOINT_RESTART" );
	level endon( "STOP_COUNTDOWN" );
	
	wait( waittime );
	
	level.woods thread playVO_proper( "toolate" );
	level thread maps\flashpoint_e8::rocket_takeoff( false );
	
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_ROCKET_TAKEOFF");
}

flash_when_low( time_to_wait )
{
	self endon( "delete" );
	self endon( "removed" );
	level endon( "CHECKPOINT_RESTART" );
	
	wait( time_to_wait ); //should leave 10 secs left on clock!
	self thread delete_me_after( 10.0 );
		
	while( isdefined( self ) )
	{
		self.color = ( 1.0, 0.0, 0.0 );  
		self.fontScale = 2.4;
		wait( 0.1 );
		self.color = ( 1.0, 1.0, 1.0 );  
		self.fontScale = 2.0;
		wait( 0.1 );
	}
}

cleanup_rocket_takedown()
{
	self endon( "delete" );
	level endon( "CHECKPOINT_RESTART" );
	
	flag_wait( "STOP_COUNTDOWN" );
	self destroy();
	self notify ( "removed" );
}

cleanup_on_restart()
{
	self endon( "delete" );
	flag_wait( "CHECKPOINT_RESTART" );
	self destroy();
	self notify ( "removed" );
}

startCountDownTimer( time )
{
	if( level.console )
		yoffset = 0;
	else
		yoffset = 20;
		
	level.countdownTimerElem = NewHudElem();
	level.countdownTimerElem.hidewheninmenu = true;
	level.countdownTimerElem.horzAlign = "center";
	level.countdownTimerElem.vertAlign = "top";
	level.countdownTimerElem.alignX = "center";
	level.countdownTimerElem.alignY = "middle";
	level.countdownTimerElem.x = 0;
	level.countdownTimerElem.y = yoffset;
	level.countdownTimerElem.foreground = true;
	level.countdownTimerElem.font = "default";
	level.countdownTimerElem.fontScale = 2.0;
	level.countdownTimerElem.color = ( 1.0, 1.0, 1.0 );        
	level.countdownTimerElem.alpha = 1.0;
	level.countdownTimerElem SetTimer( time );       // 5 minutes seems fair ...Go!

	level.countdownTimerElem thread flash_when_low( time - 10.0 );	//10 secs of red flashing!!!!!
	
	//Start the rocket launch!!!!
	level thread takeoff_when_timer_is_out( time );
	
	level.countdownTimerElem thread cleanup_rocket_takedown();
	level.countdownTimerElem thread cleanup_on_restart();
}


is_player_over_wall_thread()
{
	level endon( "PLAYER_OVER_WALL" );
	self waittill( "trigger" );
	
	//battlechatter_on( "axis" );
	//battlechatter_on( "allies" );
			
	//playVO( "PLAYER IS OVER WALL!!!!", "Woods" );
	player_over_sniper_blocker = getentarray( "player_over_sniper_blocker", "targetname" );
	for( i=0; i<player_over_sniper_blocker.size; i++ )
	{
		player_over_sniper_blocker[i] Solid();
	}
				
	flag_set( "PLAYER_OVER_WALL" );
	level notify( "set_portal_override_flame_trench" );
}


is_player_over_wall()
{
	player_over_sniper_blocker = getentarray( "player_over_sniper_blocker", "targetname" );
	for( i=0; i<player_over_sniper_blocker.size; i++ )
	{
		player_over_sniper_blocker[i] NotSolid();
	}
	
	player_over_sniper_wall_trig = getentarray( "player_over_sniper_wall", "targetname" );
	
	//Once over the wall disable then way back
	for( i=0; i<player_over_sniper_wall_trig.size; i++ )
	{
		player_over_sniper_wall_trig[i] thread is_player_over_wall_thread();
	}
}

/*
	level.woods thread playVO_proper( "overwall" );		//Here - over the wall.
	level.woods thread playVO_proper( "100yards" );		//Targets, 100 yards, stay low!
	level.woods thread playVO_proper( "asc_group" );	//There's the Ascension group scientists!
	level.woods thread playVO_proper( "cardnazi" );		//Every one of them - a card carrying Nazi.
	level.player thread playVO_proper( "killthem" );	//Kill them where they stand.
*/


event7_on_save_restored()
{
 	flag_set( "CHECKPOINT_RESTART" );	
 	wait( 0.1 );
 	flag_clear( "CHECKPOINT_RESTART" );
 	startCountDownTimer( level.timeLEFT );
	level thread preparing_rocket_launch_VO( level.timeLEFT );
}


over_wall_anim( animnode, animname )
{
	animnode anim_single_aligned( self, animname );
	animnode waittill( animname );
}

swap_heads()
{
	//-- replace Woods
	// level.woods Detach(level.woods.headmodel, "");
	// level.woods.headmodel = "c_usa_jungmar_barnes_pris_head";
	// level.woods Attach(level.woods.headmodel, "", true);
	
	//-- replace Bowman
	// level.bowman Detach(level.bowman.headmodel, "");
	// level.bowman.headmodel = "c_usa_blackops_bowman_disguise_head";
	// level.bowman Attach(level.bowman.headmodel, "", true);
	
	//-- replace Brooks
	// level.brooks Detach(level.brooks.headmodel, "");
	// level.brooks.headmodel = "c_usa_jungmar_head3_nohat";
	// level.brooks Attach(level.brooks.headmodel, "", true);
	
	//-- replace weaver's head with the bandaged one
	// level.weaver Detach(level.weaver.headmodel, "");
	// level.weaver.headmodel = "c_usa_blackops_weaver_disguise_headb";
	// level.weaver Attach(level.weaver.headmodel, "", true);
}

new_objective_once_up_ladder()
{
	//Squad should run to heli nodes	
	launchpad_moveinto_trig = getent( "launchpad_moveinto", "targetname" );
	launchpad_moveinto_trig waittill( "trigger" );
	
	level notify( "up_ladder" );
	
	//Objective_Set3D(level.obj_num, false);
	//level.obj_num++; //weaver rescue skip

	//level.obj_num++;
	explosive_charge = getent( "b2_satchel", "targetname" );
	//Objective_Add( level.obj_num, "current",  &"FLASHPOINT_OBJ_ABORT_THE_LAUNCH" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, explosive_charge.origin + ( 0, 0, 15 ) );
}




checkForWonderingOff()
{
	level endon( "C4_DETONATED" );
	
	drop_down_border = getentarray( "flame_trench_fail_barrier", "targetname" ); 
	
	while( 1 )
	{
		for( i=0; i<drop_down_border.size; i++ )
		{
			trigger = drop_down_border[i];
			if( level.player istouching( trigger ) )
			{
				//FAIL!
				maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_STAY_WITH_WOODS");
				return;
			}
		}
		wait( 0.05 );
	}	
}


save_point_1()
{
	level waittill( "up_ladder" );
	level.timeLEFT = 240.0;//4 mins
	level.timerSTAGE = 1;
	autosave_by_name("flashpoint_e7b");
}

save_point_2()
{
	heli_snip_trig = getent( "heli_snip_trig", "targetname" );
	heli_snip_trig waittill( "trigger" );
	level.timeLEFT = 180.0;//3 mins
	level.timerSTAGE = 2;
	autosave_by_name("flashpoint_e7c");
}


rocket_migs_flyby()
{
	flag_wait( "PLAYER_OVER_WALL" );
	
	
	mig_flyover_01_node = GetVehicleNode( "rocket_jet1_start", "targetname" );
	mig_flyover_02_node = GetVehicleNode( "rocket_jet2_start", "targetname" );
	mig_flyover_01 = SpawnVehicle( "t5_veh_air_mig_21_ussr_flying", "rocket_jet1", "plane_mig21_lowres", mig_flyover_01_node.origin, (0,0,0) );
	mig_flyover_02 = SpawnVehicle( "t5_veh_air_mig_21_ussr_flying", "rocket_jet2", "plane_mig21_lowres", mig_flyover_02_node.origin, (0,0,0) );
	
	maps\_vehicle::vehicle_init( mig_flyover_01 );
	maps\_vehicle::vehicle_init( mig_flyover_02 );
	mig_flyover_01 thread maps\flashpoint_e1::check_play_vehicle_rumble( 8000.0 );
	mig_flyover_02 thread maps\flashpoint_e1::check_play_vehicle_rumble( 8000.0 );
	
	mig_flyover_01 thread go_path( mig_flyover_01_node );
	mig_flyover_01 thread plane_position_updater (715, "evt_f4_long_wash", "null");	
	mig_flyover_01 veh_magic_bullet_shield( 1 );
	mig_flyover_01 thread playPlaneFx();
	mig_flyover_01 thread maps\flashpoint_amb::mig_fake_audio(2);
	
	wait( 1.5 );
	mig_flyover_02 thread go_path( mig_flyover_02_node );	
	mig_flyover_02 thread plane_position_updater (715, "evt_f4_long_wash", "null");	
	mig_flyover_02 veh_magic_bullet_shield( 1 );	
	mig_flyover_02 thread playPlaneFx();	
	mig_flyover_02 thread maps\flashpoint_amb::mig_fake_audio(2.5);
}

check_for_being_in_help_area()
{
	level endon( "BOMB_PLANT_READY" );
	
	help_the_player_area_trig = getent( "help_the_player_area", "targetname" );
	while( 1 )
	{
		if( level.player istouching( help_the_player_area_trig ) )
		{
			//Don't target me!
			level.player.ignoreme = true;
		}
		else
		{
			level.player.ignoreme = false;
		}
		wait( 0.05 );
	}
}


// check_for_damage_on_rocket_piece()
// {
// 	level endon( "BOMB_PLANT_READY" );
// 	
// 	while( 1 )
// 	{
// 		self waittill( "damage", amount, attacker, direction, point, method );
// 			
// 		//Check we were holding the correct weapon
// 		activeWeapon = level.player GetCurrentWeapon();
// 			
// 		if( method == "MOD_IMPACT" && (activeWeapon == "crossbow_explosive_alt_sp") )
//  		{
//  			wait( 2.0 );
// 
//  			SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_DONT_DAMAGE_ROCKET" );
// 			MissionFailed();
//  		}
//  		
//  		/*
//  		if( method == "MOD_GRENADE" || method == "MOD_GRENADE_SPLASH" )
//  		{
//  			SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_DONT_DAMAGE_ROCKET" );
// 			MissionFailed();
//  		}
//  		*/
//  	}	
// }

// hit_rocket_fail_check()
// {
// 	rocket_top = getentarray( "stationary_rocket_top", "targetname" );
// 	rocket_bottom = getentarray( "stationary_rocket_bottom", "targetname" );
// 		
// 	for( i=0; i<rocket_top.size; i++ )
// 	{
// 		rocket_top[i] SetCanDamage(true);
// 		rocket_top[i] thread check_for_damage_on_rocket_piece();
// 	}
// 	
// 	for( i=0; i<rocket_bottom.size; i++ )
// 	{
// 		rocket_bottom[i] SetCanDamage(true);
// 		rocket_bottom[i] thread check_for_damage_on_rocket_piece();
// 	}
// }

event7_HideOverWall()
{
/*
 Squad vault over the wall to get out of sight from patrolling soldiers
 NOTE: there needs to be a �drop down� on the other side so Player cannot vault back over
*/

	OnSaveRestored_Callback(::event7_on_save_restored);
	
	level thread autosave_after_delay( 8.0, "flashpoint_e7" );
	//autosave_by_name("flashpoint_e7");
	
	level.timerSTAGE = 0;
	level.timeLEFT = 300.0;//5 mins
	
	level thread save_point_1();
	level thread save_point_2();
	level thread rocket_migs_flyby();
	//level thread hit_rocket_fail_check();
	level.player thread check_for_being_in_help_area();
	
	level.obj_num++;
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_ABORT_THE_LAUNCH", level.woods );
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_OBJ_FOLLOW" );
	level thread new_objective_once_up_ladder();
	
	
	maps\flashpoint::event9_triggers( false );
	maps\flashpoint_e7::swap_heads();
	level.player thread checkForWonderingOff();
	
	//FLASHPOINT_OBJ_STOP_ROCKET
	set_level_objective( 1, "active" );

	//Spawn some target practice
// 	level.sniper_scientist[0] = simple_spawn_single( "sniper_scientist_01", ::setup_sniper_scientist );
// 	level.sniper_scientist[1] = simple_spawn_single( "sniper_scientist_02", ::setup_sniper_scientist );
// 	level.sniper_scientist[2] = simple_spawn_single( "sniper_scientist_03", ::setup_sniper_scientist );
// 	level.sniper_scientist[3] = simple_spawn_single( "sniper_scientist_04", ::setup_sniper_scientist );
// 	level.sniper_scientist[4] = simple_spawn_single( "sniper_scientist_05", ::setup_sniper_scientist );	
// 	
// 	level.sniper_scientist[5] = simple_spawn_single( "sniper_scientist_06", ::setup_sniper_scientist );
// 	level.sniper_scientist[6] = simple_spawn_single( "sniper_scientist_07", ::setup_sniper_scientist );
// 	level.sniper_scientist[7] = simple_spawn_single( "sniper_scientist_08", ::setup_sniper_scientist );
// 	level.sniper_scientist[8] = simple_spawn_single( "sniper_scientist_09", ::setup_sniper_scientist );
// 	level.sniper_scientist[9] = simple_spawn_single( "sniper_scientist_10", ::setup_sniper_scientist );	
	
	//FLASHPOINT_OBJ_C4_BUILDING
	set_event_objective( 6, "active" );
	
	//Set objective to follow Woods
	level.obj_breach_control = level.obj_num;
	//Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_BREACH_CONTROL", level.woods );
	//Objective_Set3D( level.obj_num, true, "default", "Follow" );
	
	level.player FreezeControls(false);
	
	//Wait till we hit the trigger
	player_post_breachroom_trig = getent( "player_post_breachroom", "targetname" );
	player_post_breachroom_trig waittill( "trigger" );
	
	
	
	//Over ledge vault
	anim_node = get_anim_struct( "12" );
	level.bowman thread over_wall_anim( anim_node, "vault_wall_bowman" );
	level.woods thread over_wall_anim( anim_node, "vault_wall_woods" );
	level.weaver thread over_wall_anim( anim_node, "vault_wall_weaver" );
	level.brooks thread over_wall_anim( anim_node, "vault_wall_brooks" );

	
	//player_post_breachroom_trig Delete();
	
	
	//Set objective to follow Woods
	//Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_FOLLOW_WOODS", level.woods );
	//Objective_Set3D( level.obj_num, true, "default", "Follow" );
	
	startCountDownTimer( level.timeLEFT );
	level thread preparing_rocket_launch_VO( level.timeLEFT );
	level thread open_rocket_gantry();
	
	//level thread start_scientist_anims();

	//level thread open_rocket_gantry();
	//level thread preparing_rocket_launch_VO();
	//go_over_wall();
	
	//Player jump over spot
	//Objective_Add( 0, "current", &"FLASHPOINT_OBJ_MANTLE_LEDGE", (-5739.0, 436.0, 325.8) );
	//Objective_Position(level.obj_num, (-5739.0, 436.0, 325.8) ); //TODO: make this an entity in the map
	//Objective_Set3D( level.obj_num, true, "default", "Jump Over" );
	//level.over_ledge_obj show();
	
	//level.woods thread playVO_proper( "overwall" );		//Here - over the wall.

	level.player thread is_player_over_wall();
	flag_wait( "PLAYER_OVER_WALL" );
//	level.woods thread playVO_proper( "100yards" );		//Targets, 100 yards, stay low!
	
	//Objective_State ( 0, "done" ); 	
	//Objective_Set3D( level.obj_num, false );
	//player_over_sniper_blocker Solid();
	//level.over_ledge_obj hide();
	
	event7_SniperEngineers();
}

getupladder()
{
	/*level endon( "MOVE_THROUGH_LAUNCHPAD" );
	
	
	ladder_top = getnode( "ladder_top", "targetname" );

	woods_after_ladder = getnode( "woods_after_ladder", "targetname" );
	hudson_after_ladder = getnode( "hudson_after_ladder", "targetname" );
	lewis_after_ladder = getnode( "lewis_after_ladder", "targetname" );
	weaver_after_ladder = getnode( "weaver_after_ladder", "targetname" );
	
	//Start the squad off in the direction of the ladder
	ladder_wait_weaver = getnode( "ladder_wait_weaver", "targetname" );
	ladder_wait_hudson = getnode( "ladder_wait_hudson", "targetname" );
	ladder_wait_lewis = getnode( "ladder_wait_lewis", "targetname" );
	level.weaver SetGoalPos( ladder_wait_weaver.origin );
	level.bowman SetGoalPos( ladder_wait_hudson.origin );
	level.brooks SetGoalPos( ladder_wait_lewis.origin );
	
	//Tell woods to get up the ladder
	level.woods SetGoalPos( ladder_top.origin );
	level.woods waittill( "goal" );
	level.woods SetGoalPos( woods_after_ladder.origin );
	
	//Tell weaver to move it now
	level.weaver SetGoalPos( ladder_top.origin );
	level.weaver waittill( "goal" );
	level.weaver SetGoalPos( weaver_after_ladder.origin );
	
	//Tell hudson to move it now
	level.bowman SetGoalPos( ladder_top.origin );
	level.bowman waittill( "goal" );
	level.bowman SetGoalPos( hudson_after_ladder.origin );
	
	//Tell lewis to move it now
	level.brooks SetGoalPos( ladder_top.origin );
	level.brooks waittill( "goal" );
	level.brooks SetGoalPos( lewis_after_ladder.origin );
	
	level.brooks waittill( "goal" );
	
	*/
}

launchpad_worker_takes_damage()
{
	self endon("death");
	
	//Not very strong......
	self waittill( "damage" );
	self Die();
}

setup_launchpad_worker()
{
	self endon("death");

	self.goalradius = 32;
	self.ignoreall = true;
	self.dropweapon = false;
	self.animname = "worker";
	
	self thread launchpad_worker_takes_damage();
}


// check_for_launchpad_spawn_required()
// {
// 	spawn_launchpad_ai_trig = getent( "spawn_launchpad_ai", "targetname" );
// 	spawn_launchpad_ai_trig waittill( "trigger" );
// 
// 	//engineers
// 	if( level.all_scientists_dead==true )
// 	{
// 		level.launchpad_worker[0] = simple_spawn_single( "launchpad_worker_01", ::setup_launchpad_worker );
// 		level.launchpad_worker[1] = simple_spawn_single( "launchpad_worker_02", ::setup_launchpad_worker );
// 		level.launchpad_worker[2] = simple_spawn_single( "launchpad_worker_03", ::setup_launchpad_worker );
// 		level.launchpad_worker[3] = simple_spawn_single( "launchpad_worker_04", ::setup_launchpad_worker );
// 		//level.launchpad_worker[4] = simple_spawn_single( "launchpad_worker_05", ::setup_launchpad_worker );
// 		//level.launchpad_worker[5] = simple_spawn_single( "launchpad_worker_06", ::setup_launchpad_worker );
// 		
// 		// "14a" - animnode
// 		
// 		//Workers under rocket
// // 		level.scr_anim["worker"]["busy1"]					= %ch_flash_b07_rocketpad_worker_a;
// // 		level.scr_anim["worker"]["busy2"]					= %ch_flash_b07_rocketpad_worker_b1;
// // 		level.scr_anim["worker"]["busy3"]					= %ch_flash_b07_rocketpad_worker_b2;
// // 		level.scr_anim["worker"]["busy4"]					= %ch_flash_b07_rocketpad_worker_c;
// // 		level.scr_anim["worker"]["busy5"]					= %ch_flash_ev07_workers_e;
// // 		level.scr_anim["worker"]["busy6"]					= %ch_flash_ev07_workers_f;
// 	}
// }


launchpad_chopper_battle()
{
	start_heli_snipe_trig = getent( "start_heli_snipe", "targetname" );
	start_heli_snipe_trig waittill( "trigger" );
	
	//Set objective to follow Woods
	//Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_TAKE_OUT_CHOPPER" );
	//Objective_Set3D( level.obj_num, false );
	
	launchpad_heli_start = GetVehicleNode( "launchpad_heli_start", "targetname" );
	launchpad_heli = SpawnVehicle( "t5_veh_helo_mi8_woodland", "launchpad_heli", "heli_hip", launchpad_heli_start.origin, (0,0,0) );
	//launchpad_heli.health = 999999;
	//launchpad_heli.takedamage = true;
	//launchpad_heli setspeed( 50, 5, 30 );
	launchpad_heli.is_at_goal = 0;
	launchpad_heli.evasive_move = 0;
	launchpad_heli SetSpeed(40,20,20);
	
	maps\_vehicle::vehicle_init( launchpad_heli );
	launchpad_heli thread go_path( launchpad_heli_start );
	//launchpad_heli.drivepath = 1;
	launchpad_heli.current_index = 0;
	launchpad_heli.health = 999999;
	launchpad_heli.dontunloadonend = 1;
		
	//Setup Pilot
	launchpad_heli spawn_and_attach_pilot();
	
	//level.player thread player_is_wimp();
	launchpad_heli thread check_for_death();
	launchpad_heli thread heli_flight_path( level.player, 10.0 );
	

	//launchpad_heli thread go_path( launchpad_heli_start );
	
	timeoutValue = 10.0; //secs to kill helicopter pilot
	level.player thread attack_player( launchpad_heli );
	level.player thread attack_player_timout( launchpad_heli, timeoutValue );
	launchpad_heli thread vehicle_takes_damage();
}

event7_SniperEngineers()
{
/*
 Woods points out the engineers down below who are alarmed at the sight of a group of soldiers in this area
 They start running for the stairs � Woods tell Player to use his Sniper rifle to take out the engineers before 
 they reach the doorway and are able to call for help
 If any of them reach the door, this should make the next section v.v.hard
 NOTE: there should be a ladder at the end of the gantry so Player can climb up to next section
*/
	
	//player_sniper_trig = getent( "player_sniper_trig", "targetname" );
	//level.woods waittill( "goal" );
	//player_sniper_trig waittill( "trigger" );
	
	level.all_scientists_dead = false;
	//level.player thread check_for_launchpad_spawn_required();
	
	//level thread launchpad_chopper_battle();
	
	
	wait( 1.0 );
	//level.woods thread playVO_proper( "asc_group" );			//There's the Ascension group scientists!
	//level.woods thread playVO_proper( "cardnazi", 1.0 );		//Every one of them - a card carrying Nazi.
	//level.woods thread playVO_proper( "afterthem", 3.0 );		//Bowman! After them!
	
	level.woods thread playVO_proper( "masononme", 0.0 );		//Mason - on me!
	level.weaver thread playVO_proper( "grabass", 5.0 );		//Grab your ass, we got a fight on our hands!
	
	//TUEY set music back to the fight song
	setmusicstate("GANTRY_FIGHT");	
    
	//level.obj_num++;
	//level.obj_scientist = level.obj_num;
	//Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_SNIPER_SCIENTISTS", (-6021.9, 3424.1, 28.5) );
	//Objective_Set3D( level.obj_num, true, "default", "Kill" );
	
	//level thread start_scientist_run_anims();
	
	//timeToKillAllScientists = 20.0;
	//level thread count_alive_scientists( timeToKillAllScientists );
	//wait( timeToKillAllScientists );
	
	
	//autosave_by_name("flashpoint_e7b");
	

	
	//playVO( "Lets go, quickly!!!", "Woods" );
	
	level.woods.ignoreall = false;
	level.weaver.ignoreall = false;
	level.brooks.ignoreall = false;
	level.bowman.ignoreall = false;
	
	//Set objective to follow Woods
	//Objective_Add( 0, "current", &"FLASHPOINT_OBJ_FOLLOW_WOODS", level.woods );
	//Objective_Position( level.obj_breach_control, level.woods );
	//Objective_Set3D( level.obj_breach_control, true, "default", "Follow" );

	thread getupladder();
	
	event7_WeaponsDown();
}

trigger_deflector_start()
{
	//Wait till we hit a trigger then start this effect	
	deflector_start_trig = getent( "deflector_start", "targetname" );
	deflector_start_trig waittill( "trigger" );

	level notify( "deflector_start" );
}

event7_WeaponsDown()
{
/*
 There are a bunch of workers milling about, who don�t appear concerned by your presence
 Woods VO: �Chatter coming over the radio � we might have been made, they figured out we�re in disguise�
 Woods VO: �Weapons down, they�re not a threat�
 The workers will not react unless Player decides to shoot
 NOTE: If Player �failed� last event, then there will also be Russian soldiers here and this will be a tough combat event
*/

// launchpad_reinforce_01
// launchpad_reinforce_02


	//Squad should run to heli nodes	
	//launchpad_moveinto_trig = getent( "launchpad_moveinto", "targetname" );
	//launchpad_moveinto_trig waittill( "trigger" );
	
	//Trigger spawned enemies?
	//launchpad_spawn_guards = getent( "launchpad_spawn_guards", "targetname" );
	
	if( level.all_scientists_dead==false )
	{
		//We have a fight!
		//launchpad_spawn_guards activate_trigger();
		level.woods.ignoreall = false;
		level.weaver.ignoreall = false;
		level.brooks.ignoreall = false;
		level.bowman.ignoreall = false;
	}
	
	level thread trigger_deflector_start();
	
	flag_set( "MOVE_THROUGH_LAUNCHPAD" );
	level notify( "set_portal_override_gantry_battle" );
	


	event7_RussianChopper();
}

destroy_launchpad_chopper_hitground()
{
	self endon( "delete" );
	level endon( "heli_down" );
	
	while( 1 )
	{
		if( self.origin[2] < -500.0 )
		{
			//hits ground
			//playVO( "Heli hits the ground!", "Woods" );
			
			exploder( 701 );
			
			earthquake( 0.5, 2.0, self.origin, 500 );
			playfx( level._effect["vehicle_explosion"], self.origin );
			level.player PlayRumbleOnEntity( "explosion_generic" );
			wait( 1.0 );
			earthquake( 0.5, 2.0, self.origin, 500 );
			playfx( level._effect["vehicle_explosion"], self.origin );
			level.player PlayRumbleOnEntity( "explosion_generic" );
			self Delete();
			level notify( "heli_down" );
		}
		wait( 0.1 );
	}
}

/*
	self endon( "delete" );
	level endon( "top_rocket_end" );
	
	while( 1 )
	{
		top_tag_origin = self GetTagOrigin( "top_rocket_jnt" );

		if( top_tag_origin[2] < 0.0 )
		{
			//hits ground
			//playVO( "Rocket hits the ground! = top_tag_origin", "Woods" );
			
			earthquake( 0.5, 2.0, top_tag_origin, 500 );
			level.player PlayRumbleOnEntity( "explosion_generic" );
			exploder( 810 );
			
			wait( 5.0 );
			flag_set( "ROCKET_HITS_GROUND" );
			level notify( "top_rocket_end" );
		}
		wait( 0.1 );
	}
	*/

destroy_launchpad_chopper()
{
	level.woods thread playVO_proper( "chopperdown" );
	
	self thread destroy_launchpad_chopper_hitground();
	
	//Set objective to follow Woods
	//Objective_State( level.obj_num, "done" );

	//For now assume good all the time
	self.lockpath = 1;
	self.rollingdeath = 1;

	//For now assume good all the time
	launchpad_heli_crash_start = GetVehicleNode( "launchpad_heli_crash_start", "targetname" );
	//self thread go_path( launchpad_heli_crash_start );
	self DrivePath( launchpad_heli_crash_start );

	//CRASH	
	heli_speed = 30+randomInt(50);
	heli_accel = 10+randomInt(25);

	// movement change due to damage
	self setspeed( heli_speed, heli_accel );	
			
	// fly to crash path
	//self thread heli_fly( crashPath, 2.0 );

	//rateOfSpin = 45 + randomint(90);

	// helicopter losing control and spins
	//heli thread heli_spin( rateOfSpin );
		
	flag_set( "LAUNCHPAD_HELI_DEAD" );	
}

vehicle_evasive_move()
{
	level endon ( "LAUNCHPAD_HELI_DEAD" );
	
	self.evasive_move = 1;
	
	heli_tracker_triggers_array = getentarray( "heli_tracker_triggers", "targetname" );

	if( self.heli_current_index==(heli_tracker_triggers_array.size-1) )
		self.heli_current_index = self.current_index - 1;
	if( self.heli_current_index==0 )
		self.heli_current_index = self.current_index + 1;
				
				
	self.is_at_goal = 0;
		
	//Found it - move the helicopter to this point
	heli_pos_struct = getstruct( heli_tracker_triggers_array[self.heli_current_index].target );
	self SetSpeed(20,10,10);
	self SetVehGoalPos( heli_pos_struct.origin );
	//self.current_index = heli_current_index;
			
	//When at goal stop
	self waittill( "goal" );
	self SetSpeed(0,10,10);
	//level.woods thread playVO_proper( "nail_pilot", 3.0 );	//Mason! Nail that pilot!
			
	self.is_at_goal = 1;		
			
	self.evasive_move = 0;
}


vehicle_takes_damage()
{
	level endon ( "LAUNCHPAD_HELI_DEAD" );
	self endon ( "death" );
	
	while( isdefined( self ) )
	{
		//self waittill( "damage" );
		self waittill( "damage", amount, attacker, direction, point, method );
		
		//Check we were holding the correct weapon
		activeWeapon = level.player GetCurrentWeapon();

		if( method == "MOD_GRENADE" || method == "MOD_GRENADE_SPLASH" )
		{
			//destroy it!
			//wait( 2.0 );
			destroy_launchpad_chopper();
		}
		
		if( method == "MOD_IMPACT" && (activeWeapon == "crossbow_explosive_alt_sp") )
		{
			wait( 2.0 );
			destroy_launchpad_chopper();
		}

		//Move it - move the helicopter to this point
		if( (self.is_at_goal == 1) && (self.evasive_move == 0) )
		{
			self thread vehicle_evasive_move();
		}
		
		//playVO( "Its moving away - shoot the pilot with the sniper weapon!!!!", "Woods" );
	}
}



attack_player( chopper )
{
	level endon ( "LAUNCHPAD_HELI_DEAD" );
	
	
	start_heli_snipe_trying_to_run_trig = getent( "start_heli_snipe_trying_to_run", "targetname" );
	start_heli_snipe_trying_to_run_trig waittill( "trigger" );

	while( isdefined( self ) )
	{
		//start_heli_snipe_trying_to_run_trig = getent( "start_heli_snipe_trying_to_run", "targetname" );
		//start_heli_snipe_trying_to_run_trig waittill( "trigger" );
		 
		//chopper waittill( "fire_at_player" );
		
		if( chopper.is_at_goal == 1 )
		{
			level.woods thread playVO_proper( "kill_pilot" );	//That chopper is hammering us. Kill the pilot!
		
			//Fire rockets
			rocket_weapon = "huey_rockets";
			forward = AnglesToForward( chopper.angles );
			start_point = chopper GetTagOrigin( "tag_rocket1" ) + (60 * forward);
 			MagicBullet( rocket_weapon, start_point, self.origin, chopper, self );
  			wait 0.3;
  			start_point = chopper GetTagOrigin( "tag_rocket2" ) + (60 * forward);	
  			MagicBullet( rocket_weapon, start_point, self.origin, chopper, self );
  			wait 0.3; 
  			start_point = chopper GetTagOrigin( "tag_rocket3" ) + (60 * forward);
  			MagicBullet( rocket_weapon, start_point, self.origin, chopper, self );
  			wait 0.3;
  			start_point = chopper GetTagOrigin( "tag_rocket4" ) + (60 * forward);
  			MagicBullet( rocket_weapon, start_point, self.origin, chopper, self );
  			wait( 10.0 );// cool down
		}
		else
		{
			wait( 3.0 );// cool down
		}
	}
}

attack_player_timout( chopper, timeoutValue )
{
	level endon ( "LAUNCHPAD_HELI_DEAD" );
	ent = spawn( "script_origin" , (0,0,0));
	
	chopper thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete();
	
	dangerStartTime = GetTime();
	
	line_switch = 0;

	while( isdefined( self ) )
	{
		if( (GetTime() - dangerStartTime) > (timeoutValue*1000.0) )
		{
			//chopper waittill( "fire_at_player" );
			
			//level.woods thread playVO_proper( "shoot_pilot" );	//Shoot that goddam chopper pilot, Mason!

			if( chopper.is_at_goal == 1 )
			{
				if( line_switch==0 )
				{
					level.woods thread playVO_proper( "shoot_pilot" );	//Shoot that goddam chopper pilot, Mason!
					line_switch = 1;
				}
				else
				{
					level.woods thread playVO_proper( "pinned" );	//Shoot that goddam chopper pilot, Mason!
					line_switch = 0;
				}	
				

				
				chopper SetGunnerTargetEnt( level.player, (0,0,0), 1 );		
				for (j=0; j<8; j++)
				{
					chopper FireGunnerWeapon( 1 );
					//kevin adding chopper firing sound
					ent playloopsound( "wpn_huey_toda_minigun_fire_npc_loop" );
					wait 0.25;
				}
				ent stoploopsound(.1);
				ent playsound( "wpn_huey_toda_minigun_fire_npc_end" );
				wait( 5.0 );// cool down
			}
			else
			{
				wait( 3.0 );// cool down
			}
		}
		wait( 0.1 );// cool down
	}
}

//kevin addin functions to play the loop on the chopper
audio_ent_fakelink( ent )
{
	level endon("LAUNCHPAD_HELI_DEAD" );
	//self endon ("death");
	
	while(1)
	{
		ent moveto( self.origin, .1 );
		ent waittill("movedone");
	}
}

audio_ent_fakelink_delete()
{
	level waittill( "LAUNCHPAD_HELI_DEAD" );
	
	self delete();
}

// self spin at one rev per 2 sec
heli_spin( speed )
{
	self endon( "death" );
	
	// tail explosion that caused the spinning
//	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
	// play hit sound immediately so players know they got it
//	self playSound ( level.heli_sound[self.team]["hit"] );
	
	// play heli crashing spinning sound
//	self thread spinSoundShortly();
	
	// form smoke trails on tail after explosion
//	self thread trail_fx( level.chopper_fx["smoke"]["trail"], "tail_rotor_jnt", "stop tail smoke" );
	
	// spins until death
	self setyawspeed( speed, speed / 3 , speed / 3 );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

pilot_takes_damage( heli )
{
	self endon ( "death" );
	level endon ( "LAUNCHPAD_HELI_DEAD" );
	
	while( isdefined( self ) )
	{
		//self waittill( "damage" );
// 		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
// 		
// 		//Either we hit the pilot (good)
// 		
// 		//Or we missed (bad)
// 		
// 		playVO( "pilot_takes_damage!", "Woods" );
// 		
		
		//For now assume good all the time
		//launchpad_heli_crash_start = GetVehicleNode( "launchpad_heli_crash_start", "targetname" );
		//self thread go_path( launchpad_heli_crash_start );
		//self DrivePath( launchpad_heli_crash_start );
		
		
		//flag_set( "LAUNCHPAD_HELI_DEAD" );
		

		self waittill( "damage" );
		
		//Spawn blood on the window
		model = spawn( "script_model", (0,0,0) );
		model setModel( "t5_veh_helo_mi8_bloody_glass" );
		model linkto( heli, "tag_origin", (0,0,0), (0,0,0) );
		
//		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );	
		level.woods thread playVO_proper( "chopperdown" );


	//	playVO( "You got him, helicopter is crashing!!", "Woods" );
	
		heli thread destroy_launchpad_chopper_hitground();
		
		//wait( 2.0 );

		//For now assume good all the time
		heli.drivepath = 1;
		heli.rollingdeath = 1;
		
		//For now assume good all the time
		launchpad_heli_crash_start = GetVehicleNode( "launchpad_heli_crash_start", "targetname" );
		//self thread go_path( launchpad_heli_crash_start );
		heli DrivePath( launchpad_heli_crash_start );
		
		
		//CRASH	
		heli_speed = 30+randomInt(50);
		heli_accel = 10+randomInt(25);
		
		// movement change due to damage
		heli setspeed( heli_speed, heli_accel );	
				
		// fly to crash path
		//self thread heli_fly( crashPath, 2.0 );
		
		//rateOfSpin = 45 + randomint(90);
		
		// helicopter losing control and spins
		//heli thread heli_spin( rateOfSpin );
			
		
		flag_set( "LAUNCHPAD_HELI_DEAD" );
	}
}

#using_animtree("generic_human");
spawn_and_attach_pilot()
{
// 	//Setup Pilot
// 	self.pilot = spawn("script_model",self.origin + (0,40,0));
// 	self.pilot character\c_rus_helicopter_pilot::main();
// 	self.pilot UseAnimTree(#animtree);
// 	self.pilot enter_vehicle( self, "tag_passenger" );
// 	self.pilot.health = 9999999;
// 	//self.pilot.team = "axis"; 
// 	self.pilot.ignoreme = true;
// 	self.pilot thread pilot_takes_damage( self );
// 	self.pilot makeFakeAI();			// allow it to be animated
// 	self.pilot.drone_delete_on_unload = true; 
// 	self.pilot setcandamage( true );	
}

check_for_death()
{
	level endon( "LAUNCHPAD_HELI_DEAD" );
	self waittill( "death" );
	flag_set( "LAUNCHPAD_HELI_DEAD" );
}

heli_direction( player )
{
	level endon( "LAUNCHPAD_HELI_DEAD" );
	self endon( "death" );
	
	while( 1 )
	{
		vec_to_player = player.origin - self.origin;
		
		launch_yaw	= flat_angle( VectorToAngles( vec_to_player ) );
			
		self cleargoalyaw(); // clear this thing
		self settargetyaw( launch_yaw[1] );
		
		wait( 1.0 );
	}
}

/*
	level.bowman thread playVO_proper( "inbound" );	//Shit! Chopper inbound!
	level.woods thread playVO_proper( "pinned" );	//He's got us pinned!
	level.woods thread playVO_proper( "nail_pilot" );	//Mason! Nail that pilot!
	level.woods thread playVO_proper( "kill_pilot" );	//That chopper is hammering us. Kill the pilot!
	level.woods thread playVO_proper( "shoot_pilot" );	//Shoot that goddam chopper pilot, Mason!
*/

heli_flight_path( player, wait_time )
{
	level endon( "LAUNCHPAD_HELI_DEAD" );
	self endon( "death" );
	
	heli_tracker_triggers_array = getentarray( "heli_tracker_triggers", "targetname" );
	
	self thread heli_direction( player );
	
	self.goalradius = 512;
	
	level.bowman thread playVO_proper( "inbound" );			//Shit! Chopper inbound!
	//level.woods thread playVO_proper( "nail_pilot", 3.0 );	//Mason! Nail that pilot!

	//wait( wait_time );
	self waittill( "reached_end_node" );
	
	self.heli_current_index = -1;
	self.player_current_index = 0;
	
	//Which one is the player in!	
	self SetSpeed(20,10,10);
	
	while( 1 )
	{
		//Find out which array the player is in
		for( i=0; i<heli_tracker_triggers_array.size; i++ )
		{
			if( player isTouching ( heli_tracker_triggers_array[i] ) )
			{
				self.player_current_index = i;
				break;
			}
		}		
			
		if( (self.heli_current_index!=self.player_current_index) && (self.evasive_move == 0))
		{
			//iprintlnbold( "HELI MOVING [HELI=" + self.heli_current_index + ", PLAYER=" + self.player_current_index + "]" );
			self.heli_current_index = self.player_current_index;
			
			self.is_at_goal = 0;
		
			//Found it - move the helicopter to this point
			heli_pos_struct = getstruct( heli_tracker_triggers_array[self.heli_current_index].target );
			self SetSpeed(20,10,10);
			self SetVehGoalPos( heli_pos_struct.origin );
			//self.current_index = heli_current_index;
			
			//When at goal stop
			self waittill( "goal" );
			self SetSpeed(0,10,10);
			level.woods thread playVO_proper( "nail_pilot", 3.0 );	//Mason! Nail that pilot!
			
			self.is_at_goal = 1;
			
			//level.woods thread playVO_proper( "pinned" );	//He's got us pinned!
		}
		wait( 1.0 );
	}
}

player_is_wimp()
{	
	level endon( "LAUNCHPAD_HELI_DEAD" );
	self endon( "death" );
	
	self waittill( "damage" );
	self Die();
}

event7_RussianChopper()
{
/*
 The squad is now met with a Russian chopper right in their face
 Russian VO blares over the loudspeaker
 Woods VO: �We�ve been made, Mason take out the pilot when you get your shot�
 If Player shoots pilot, chopper goes snipping down and crashes
 If Player shoots but misses pilot, chopper loses control slightly but veers off to safety
 If Player does nothing, chopper mows down squad, game over
 If successful, Weaver VO: �We need to run to the control room {bunker}�, they�re launching the rocket early� � 
 squad starts running to control room (highlighted)
*/

// 	//Squad should run to heli nodes	
// 	launchpad_moveinto_trig = getent( "launchpad_moveinto", "targetname" );
// 	launchpad_moveinto_trig waittill( "trigger" );
// 	
// 	//Trigger spawned enemies?
// 	launchpad_spawn_guards = getent( "launchpad_spawn_guards", "targetname" );
// 	
// 	if( level.all_scientists_dead==false )
// 	{
// 		launchpad_spawn_guards activate_trigger();
// 	}
// 	
// 	flag_set( "MOVE_THROUGH_LAUNCHPAD" );
	
// 	heli_snipe_A_node = getnode( "heli_snipe_A", "targetname" );
// 	heli_snipe_B_node = getnode( "heli_snipe_B", "targetname" );
// 	heli_snipe_C_node = getnode( "heli_snipe_C", "targetname" );
// 	heli_snipe_D_node = getnode( "heli_snipe_D", "targetname" );
// 	
// 	level.woods SetGoalPos( heli_snipe_A_node.origin );
// 	level.weaver SetGoalPos( heli_snipe_B_node.origin );
// 	level.bowman SetGoalPos( heli_snipe_C_node.origin );
// 	level.brooks SetGoalPos( heli_snipe_D_node.origin );
	
	//autosave_by_name("flashpoint_e7b");
	

	
	//flag_wait( "LAUNCHPAD_HELI_DEAD" );
	
	
	//Objective_State(level.obj_num, "done");
	//Objective_Set3D(level.obj_num, false);
		
	//level thread playVO( "Get the the bunker now!!!, the rockets about to launch", "Woods", 2.0 );
	
	
//  	//Ok run to control room
//  	control_room_A_node = getnode( "control_room_A", "targetname" );
//  	control_room_B_node = getnode( "control_room_B", "targetname" );
//  	control_room_C_node = getnode( "control_room_C", "targetname" );
//  	control_room_D_node = getnode( "control_room_D", "targetname" );
//  	level.woods SetGoalPos( control_room_A_node.origin );
//  	level.weaver SetGoalPos( control_room_B_node.origin );
//  	level.bowman SetGoalPos( control_room_C_node.origin );
//  	level.brooks SetGoalPos( control_room_D_node.origin );


	//woods - wait at node "woods_wait_c4" till weaver hits this trigger "woods_wait_c4_trig"
	
//	level.weaver thread enable_cqbanim();
//	level.woods thread enable_cqbanim();
//	level.bowman thread enable_cqbanim();
//	level.brooks thread enable_cqbanim();
	
	//Waitill the player and woods get to the bunker
	at_bunker_trig = getent( "at_bunker", "targetname" );
	at_bunker_trig waittill( "trigger" );
	
	//Objective_Set3D( level.obj_num, false );
	
	OnSaveRestored_CallbackRemove(::event7_on_save_restored);
	
	//Goto next event
	flag_set("BEGIN_EVENT8");
}

enable_cqbanim()
{
	self endon( "cqb_on" );
	
	woods_wait_c4_trig = getent( "woods_wait_c4_trig", "targetname" );
	
	while( 1 )
	{
		woods_wait_c4_trig waittill( "trigger", ent );
	
		if( self == ent )
		{
			self enable_cqbwalk();
			self notify( "cqb_on" );
		}
		wait( 0.05 );
	}
}

preparing_rocket_launch_VO( timeleft )
{
	level.player endon( "detonate" );
	level endon( "CHECKPOINT_RESTART" );
	
	//flag_wait("GANTRIES_STABILIZER_OPEN");
	
	time_to_wait = timeleft - 120.0;
	wait( time_to_wait );
	
	// Hopefully this puts the VO somewhere over by the rocket
	fxanim_flash_rocket_mod = getent( "fxanim_flash_rocket_mod", "targetname" );
	top_tag_origin = fxanim_flash_rocket_mod GetTagOrigin( "top_rocket_jnt" );
	
	rocket_vo_obj = Spawn("script_model", (0,0,0));
	rocket_vo_obj SetModel("tag_origin");
	rocket_vo_obj.origin = top_tag_origin;
	rocket_vo_obj.animname = "ruld";
	
	//Start at 2 mins
	level thread anim_single( rocket_vo_obj, "2min" );		//2 mins
	wait(24);
	level thread anim_single( rocket_vo_obj, "1min36" );
	wait(6);
	level thread anim_single( rocket_vo_obj, "90sec" );
	wait(20);
	level thread anim_single( rocket_vo_obj, "70sec" );
	wait(5);
	level thread anim_single( rocket_vo_obj, "65sec" );
	wait(5);
	level thread anim_single( rocket_vo_obj, "60sec" );
	wait(10);
	level thread anim_single( rocket_vo_obj, "50sec" );
	wait(10);
	level thread anim_single( rocket_vo_obj, "40sec" );
	wait(10);
	level thread anim_single( rocket_vo_obj, "30sec" );
	
	rocket_vo_obj Delete();
}



////////////////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////////////////
