////////////////////////////////////////////////////////////////////////////////////////////
// FLASHPOINT LEVEL SCRIPTS - Shabs
//
// Main Level script for Flashpoint - controls the main flow of the gameplay
// 
// Event1  - Slides  1-14	event01_Woods
// Event2  - Slides 15-21	event02_RunToPipe
// Event3  - Slides 22-26	event03_WoodsInDisguise
// Event4  - Slides 27-30	event04_WalkingRail
// Event5  - Slides 31-33	event05_InvertedDoorKick
// Event6  - Slides 34-38	event06_ZipLine
// Event7  - Slides 39-42	event07_HideOverWall
// Event8  - Slides 43-48	event08_ControlRoomBunkerBreach
// Event9  - Slides 49-58	event09_ComplexEngagement
// Event10 - Slides 59-66	event10_TearGasRoom
// Event11 - Slides 67-Init71	event11_AssassinateScientists
// Event12 - Slides 72-74	event12_HeadScientist
// Event13 - Slides 75-79	event13_Garage
// Event14 - Slides 80-85	event14_BTRDrive
// Event15 - Slides 86-90	event15_PlayerChoice
// Event16 - Slides 91-96	event16_DaveDevil
// Event17 - Slides 97-100	event17_InboundChopper
////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
////////////////////////////////////////////////////////////////////////////////////////////
#include maps\_utility;
#include common_scripts\utility; 
#include maps\_vehicle;
#include maps\_anim;
#include maps\_rusher;
#include maps\flashpoint_util;
#include maps\_music;
#include maps\_civilians;


////////////////////////////////////////////////////////////////////////////////////////////
// MAIN FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////
main()
{
	//This MUST be first for CreateFX!
	maps\flashpoint_fx::main();
	
	if( GetDvar( #"debug_script" ) == "" )
	{
		SetDvar( "debug_script", "0" );
	}
	
	//Level flag init
	level_flag_init();
	
	//Precache level stuff
	main_precache();

	//Development start functions
	add_start( "e02_RunToPipe", ::event2_jumpto, &"FLASHPOINT_EVENT2" );
	add_start( "e03_WoodsInDisguise", ::event3_jumpto, &"FLASHPOINT_EVENT3" );
	add_start( "e04_WalkingRail", ::event4_jumpto, &"FLASHPOINT_EVENT4" );
	add_start( "e05_InvertedDoorKick", ::event5_jumpto, &"FLASHPOINT_EVENT5" );
	add_start( "e06_ZipLine", ::event6_jumpto, &"FLASHPOINT_EVENT6" );
	add_start( "e07_HideOverWall", ::event7_jumpto, &"FLASHPOINT_EVENT7" );
	add_start( "e08_ControlRoomBunkerBreach", ::event8_jumpto, &"FLASHPOINT_EVENT8" );
	add_start( "e09_ComplexEngagement", ::event9_jumpto, &"FLASHPOINT_EVENT9" );
	//add_start( "e10_TearGasRoom", ::event10_jumpto, &"FLASHPOINT_EVENT10" );
	//add_start( "e11_AssassinateScientists", ::event11_jumpto, &"FLASHPOINT_EVENT11" );
	//add_start( "e12_HeadScientist", ::event12_jumpto, &"FLASHPOINT_EVENT12" );
	add_start( "e13_EndSlides", ::event13_jumpto, &"FLASHPOINT_EVENT13" );
	//add_start( "e14_BTRDrive", ::event14_jumpto, &"FLASHPOINT_EVENT14" );
	//add_start( "e15_PlayerChoice", ::event15_jumpto, &"FLASHPOINT_EVENT15" );
	//add_start( "e16_DaveDevil", ::event16_jumpto, &"FLASHPOINT_EVENT16" );
	//add_start( "e17_InboundChopper", ::event17_jumpto, &"FLASHPOINT_EVENT17" );
	default_start( maps\flashpoint_e1::event1_Woods );
	
	maps\_load::main();
//	maps\_gasmask::main();
//	maps\_heatseekingmissile::init();
	maps\flashpoint_amb::main();
	maps\flashpoint_anim::main();
	maps\flashpoint_portal::main();
	maps\_rusher::init_rusher();
	patrol_init_custom();
	maps\_heatseekingmissile::init();
	maps\_civilians::init_civilians();
	
	//animscripts\dog_init::initDogAnimations();

	//shabs - deleting vehicles need for createfx
	fx_slide_vehicles = GetEntArray( "fx_slide_vehicles", "targetname" );
	array_func( fx_slide_vehicles, ::self_delete );	

	//Events Go; Event1 kicks off automatically
	level thread Event2();
	level thread Event3();
	level thread Event4();
	level thread Event5();
	level thread Event6();
	level thread Event7();
	level thread Event8();
	level thread Event9();
	level thread Event10();
	level thread Event11();
	level thread Event12();
	level thread Event13();
	//level thread Event14();
	//level thread Event15();
	//level thread Event16();
	//level thread Event17();

	//shabs - Disable BTR Triggers
	trigger_off( "btr_trigger", "script_noteworthy" ); //old
//	maps\flashpoint_e14::lower_btr_jeeps();
}

//Custom patrol init function
#using_animtree("generic_human");
patrol_init_custom()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %ai_spets_patrolwalk_2_stand;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %ai_spets_patrolstand_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %ai_spets_patrolwalk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %ai_spets_patrolstand_idle;

	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %ai_spets_patrolstand_idle;

	level._patrol_init = true;
}

// #using_animtree( "animated_props" );
// contextual_melee_karambit_props_init()
// {
// 	maps\_contextual_melee::add_melee_prop_anim( "quick", "floor3green", "stand", "stand", %prop_contextual_melee_comms_floor3_green_chair);
// 	maps\_contextual_melee::add_melee_prop_anim( "quick", "floor3green", "crouch", "stand", %prop_contextual_melee_comms_floor3_green_chair);
// 
// }

#using_animtree( "generic_human" );
contextual_melee_karambit_init()
{
	maps\_contextual_melee::add_melee_sequence( "default", "karambit", "stand", "stand", %int_contextual_melee_karambit, %ai_contextual_melee_karambit );
	maps\_contextual_melee::add_melee_sequence( "default", "karambit", "crouch", "stand", %int_contextual_melee_karambit, %ai_contextual_melee_karambit );
	maps\_contextual_melee::add_melee_weapon( "default", "karambit", "stand", "stand", "t5_knife_karambit" );
	maps\_contextual_melee::add_melee_weapon( "default", "karambit", "crouch", "stand", "t5_knife_karambit" );

	//Custom Contextual melee's for the communications building	
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor2purple", "stand", "stand",	%int_contextual_melee_comms_floor2_purple, %ai_contextual_melee_comms_floor2_purple);
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor2purple", "crouch", "stand",	%int_contextual_melee_comms_floor2_purple, %ai_contextual_melee_comms_floor2_purple);
// 	
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3green", "stand", "stand",	%int_contextual_melee_comms_floor3_green, %ai_contextual_melee_comms_floor3_green);
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3green", "crouch", "stand",	%int_contextual_melee_comms_floor3_green, %ai_contextual_melee_comms_floor3_green);
// 	//maps\_contextual_melee::add_melee_callback( "quick", "floor3green", "stand", "stand", maps\flashpoint_e5::do_floor3green);
// 	//maps\_contextual_melee::add_melee_callback( "quick", "floor3green", "crouch", "stand", maps\flashpoint_e5::do_floor3green);
// 	//maps\_contextual_melee::add_melee_prop_anim( "quick", "floor3green", "stand", "stand", %prop_contextual_melee_comms_floor3_green_chair);
// 	//maps\_contextual_melee::add_melee_prop_anim( "quick", "floor3green", "crouch", "stand", %prop_contextual_melee_comms_floor3_green_chair);
// 
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3orange", "stand", "stand",	%int_contextual_melee_comms_floor3_orange, %ai_contextual_melee_comms_floor3_orange);
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3orange", "crouch", "stand",	%int_contextual_melee_comms_floor3_orange, %ai_contextual_melee_comms_floor3_orange);
// 
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3blue", "stand", "stand",	%int_contextual_melee_comms_floor3_blue, %ai_contextual_melee_comms_floor3_blue);
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor3blue", "crouch", "stand",	%int_contextual_melee_comms_floor3_blue, %ai_contextual_melee_comms_floor3_blue);
// 
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor4blue", "stand", "stand",	%int_contextual_melee_comms_floor4_blue, %ai_contextual_melee_comms_floor4_blue);
// 	maps\_contextual_melee::add_melee_sequence( "quick", "floor4blue", "crouch", "stand",	%int_contextual_melee_comms_floor4_blue, %ai_contextual_melee_comms_floor4_blue);
// 	maps\_contextual_melee::add_melee_weapon( "quick", "floor4blue", "stand", "stand", "t5_knife_karambit" );
// 	maps\_contextual_melee::add_melee_weapon( "quick", "floor4blue", "crouch", "stand", "t5_knife_karambit" );
// 
 	maps\_contextual_melee::add_melee_sequence( "quick", "floor1new", "stand", "stand",	%int_contextual_melee_comms_floor1_tapemachine, %ai_contextual_melee_comms_floor1_tapemachine);
 	maps\_contextual_melee::add_melee_sequence( "quick", "floor1new", "crouch", "stand",	%int_contextual_melee_comms_floor1_tapemachine, %ai_contextual_melee_comms_floor1_tapemachine);
 	
 	//ai_contextual_melee_comms_floor4_orange_deathpose
 	maps\_contextual_melee::add_melee_sequence( "quick", "floor4orange", "stand", "stand",	%int_contextual_melee_comms_floor4_orange, %ai_contextual_melee_comms_floor4_orange, undefined, %ai_contextual_melee_comms_floor4_orange_deathpose);
 	maps\_contextual_melee::add_melee_sequence( "quick", "floor4orange", "crouch", "stand",	%int_contextual_melee_comms_floor4_orange, %ai_contextual_melee_comms_floor4_orange, undefined, %ai_contextual_melee_comms_floor4_orange_deathpose);
// 	
// 	contextual_melee_karambit_props_init();
}

// rocket_workers( endon_flag, timeout )
// {
// 	self endon("death");
// 
// 	if( !IsAlive( self ) )
// 		return;
// 
// 	self.a.allow_weapon_switch = false;
// 	self.a.allow_sideArm = false;
// 	self.a.allow_shooting = false;
// 	self.weapon = "none";
// 	self.primaryweapon = "none";
// 	self.secondaryweapon = "none";
// 	self.weapondrop = false;
// 	self.disableidlestrafing = 1;
// 	
// 	self gun_remove();
// }


disable_idle_strafing( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;

	// if this guy is a rusher already dont do this again
	if( IsDefined( self.disableidlestrafing ) && (self.disableidlestrafing==1) )
		return;
		
	self.disableidlestrafing = 1;
}

roof_minigame( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;
		
	self.disableidlestrafing = 1;
	self.ignoreall = true;
}

snipers( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;
		
	self.dropweapon = true;
	self set_drop_weapon( "dragunov_sp" );
}

delete_at_goal()
{
	self endon("death");
	
	self waittill( "goal" );
	self Delete();
}


go_fast_1( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;
		
	self.disableidlestrafing = 1;
	self.ignoreall = true;
	self.goalradius = 64;
	
	self thread magic_bullet_shield();
	
	self.moveplaybackrate = ( 1.8 );
	self.sprint = true;
	self.animname = "generic";
	self set_run_anim( "run_fast", true );
	
	self thread delete_at_goal();
}

stop_at_goal()
{
	self endon("death");
	
	self waittill( "goal" );
	self.ignoreall = false;
	self thread stop_magic_bullet_shield();
	self.moveplaybackrate = ( 1.0 );
}


go_fast_2( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;
		
	self.disableidlestrafing = 1;
	self.ignoreall = true;
	self.goalradius = 64;
	
	self thread magic_bullet_shield();
	
	self.moveplaybackrate = ( 1.8 );
	self.sprint = true;
	self.animname = "generic";
	self set_run_anim( "run_fast", true );
	
	self thread stop_at_goal();
}


grenade_on_spawn( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;
		
	grenade_aim_pt = getstruct( "grenade_aim_pt", "targetname" );	
 	self.grenadeWeapon = "frag_grenade_sp";
 	self.grenadeammo = 2;
 	self.disableidlestrafing = 1;

 	//grenade_aim_pt = getstruct( "grenade_aim_pt", "targetname" );
 	
 	
 	// Save the pos to throw the grenade at.
// 	self.force_grenade_throw_tag = throw_tag;
// 	self.force_grenade_pos = pos;
// 	self.force_grenade_explod_time = explode_time;
// 	
// 	guy MagicGrenade( guy GetTagOrigin( guy.force_grenade_throw_tag ), guy.force_grenade_pos, guy.force_grenade_explod_time );
// 	
// 	guy.grenadeammo--;	
// 
// 	guy.force_grenade_pos = undefined;
// 	guy.force_grenade_explod_time = undefined;
// 	guy.force_grenade_throw_tag = undefined;
// 	
 	
 	self maps\_grenade_toss::force_grenade_toss( grenade_aim_pt.origin, "frag_grenade_sp", 3.0, undefined, undefined );
 //	self maps\_grenade_toss::force_grenade_toss( grenade_aim_pt.origin, "frag_grenade_sp", 3.0, undefined, undefined );


	// if this guy is a rusher already dont do this again
//	if( IsDefined( self.disableidlestrafing ) && (self.disableidlestrafing==1) )
//		return;
		
	self.disableidlestrafing = 1;
}

//Common event setup routines
common_event_startup()
{
	wait_for_all_players();
	level.player = get_players()[0];
	level.player.animname = "mason";
	
	level.allow_rumbles = true;
	
	//SetSavedDvar( "maxShardSplit", "400" );
	
	SetSavedDvar("vehicle_riding", false); // Allows player to die when hit by vehicles
	
	level._dont_look_at_player = true;
	level._disable_all_long_deaths = true;
	
	SetSavedDvar( "sm_sunSampleSizeNear", "0.5" );
	
	//Give the player a custom knife
	//level.player GiveWeapon( "karambit_knife_sp", 0 );
	
	//Level objective logic
	//level.level_obj = 0;  //Main level objective
	//level.event_obj = 1;  //Main event objective
	level.obj_num = 0;
	
	//FLASHPOINT_OBJ_STOP_ROCKET
	set_level_objective( 0, "active" );
	
	//Hide the objective model till we need them
	//level.over_pipe_obj = getent( "over_pipe_obj", "targetname" );
	level.crossbow_target_pt = getent( "crossbow_target_pt", "targetname" );
	//level.glow_window = getent( "glow_window", "targetname" );
	//level.over_ledge_obj = getent( "over_ledge_obj", "targetname" );
	//level.over_pipe_obj hide();
	level.crossbow_target_pt hide();
	//level.over_ledge_obj hide();
	//level.glow_window hide();
	
	//Hide the destroyed blastdoor's
	blastdoor = getentarray( "blastdoor", "targetname" );
	for (i = 0; i < blastdoor.size; i++)
	{
		blastdoor[i] hide();
	}
	
	tow_hide_damaged = getent( "tow_hide_damaged", "targetname" );
	tow_hide_damaged hide();

	
	//Use blocker to stop player backtracking through rocket
	launchpad_blocker = getentarray( "launchpad_blocker", "targetname" );
	for( i=0; i<launchpad_blocker.size; i++ )
	{
		launchpad_blocker[i] NotSolid();
	}
	tunnel_door_blocker = getent( "tunnel_door_blocker", "targetname" );
	tunnel_door_blocker Solid();
	
	c4_area_blocker = getent( "c4_area_blocker", "targetname" );
	c4_area_blocker NotSolid();
	
// 	tablecoll_pre = getent( "tablecoll_pre", "targetname" );
// 	tablecoll_pre NotSolid();
	tablecoll_post = getent( "tablecoll_post", "targetname" );
	tablecoll_post NotSolid();
	
	
	//Damaged c4 building hole
	c4_d = getentarray( "c4_d", "targetname" );
	for (i = 0; i < c4_d.size; i++)
	{
		c4_d[i] hide();
	}
	
	
	struct_gate_front_1l_blocker = getent( "struct_gate_front_1l_blocker", "targetname" );
	struct_gate_front_1l_blocker NotSolid();
	struct_gate_front_1r_blocker = getent( "struct_gate_front_1r_blocker", "targetname" );
	struct_gate_front_1r_blocker NotSolid();
	
	
	body_tarp = getent( "body_tarp", "targetname" );
	body_tarp Hide();
	
	
	//Hide the light model that will fall over
	fxanim_flash_lighttower_mod = getent( "fxanim_flash_lighttower_mod", "targetname" );
	fxanim_flash_lighttower_mod hide();
		
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	damaged1 = getent( "breach_window_damaged_1", "targetname" );
	cracked1 hide();
	damaged1 hide();
	
	explosive_charge = getent( "b2_satchel", "targetname" );
	explosive_charge_flashy = getent( "b2_satchel_old", "targetname" );
	explosive_charge hide();
	explosive_charge_flashy hide();
	
	rocket_dyn_top = getent( "rocket_top_piece", "targetname" );
	rocket_dyn_bottom = getent( "rocket_bottom_piece", "targetname" );
	if( isdefined(rocket_dyn_top) )
	{
		rocket_dyn_top hide();
	}
	
	if( isdefined(rocket_dyn_bottom) )
	{
		rocket_dyn_bottom hide();
	}
	
	rocket_dyn_top_orig = getent( "rocket_top_piece_orig", "targetname" );
	rocket_dyn_bottom_orig = getent( "rocket_bottom_piece_orig", "targetname" );
	if( isdefined(rocket_dyn_top_orig) )
	{
		rocket_dyn_top_orig hide();
	}
	
	if( isdefined(rocket_dyn_bottom_orig) )
	{
		rocket_dyn_bottom_orig hide();
	}
	
	//array_thread( GetEntArray("rocket_workers","script_noteworthy"), ::add_spawn_function, maps\flashpoint::rocket_workers);
	array_thread( GetEntArray("rusher","script_noteworthy"), ::add_spawn_function, maps\_rusher::rush);
	array_thread( GetEntArray("disableidlestrafing","script_noteworthy"), ::add_spawn_function, maps\flashpoint::disable_idle_strafing);
	array_thread( GetEntArray("grenadeonspawn","script_noteworthy"), ::add_spawn_function, maps\flashpoint::grenade_on_spawn);
	//array_thread( GetEntArray("roofminigame","script_noteworthy"), ::add_spawn_function, maps\flashpoint::roof_minigame);
	array_thread( GetEntArray("snipers","script_noteworthy"), ::add_spawn_function, maps\flashpoint::snipers);
	array_thread( GetEntArray("go_fast_1","script_noteworthy"), ::add_spawn_function, maps\flashpoint::go_fast_1);
	array_thread( GetEntArray("go_fast_2","script_noteworthy"), ::add_spawn_function, maps\flashpoint::go_fast_2);

	//force goal guys
	array_thread( GetEntArray("force_goal_self_guys","script_noteworthy"), ::add_spawn_function, maps\flashpoint_util::force_goal_self_util );

	//smaller goal radius guy
	array_thread( GetEntArray("shrink_goalradius","script_noteworthy"), ::add_spawn_function, maps\flashpoint_util::shrink_goalradius_util );

	//hide limo
	burnt_limo_stream = GetEnt( "burnt_limo_stream", "targetname" );
	burnt_limo_stream Hide();
	burnt_limo_stream NotSolid();

	//shabs - turn off scorched script terrain patch and burned limo
	limo_burn = GetEntArray( "limo_burn", "targetname" );
	array_func( limo_burn, ::hide_limo_burn );

	crashed_limo = GetEnt( "crashed_limo", "targetname" );
	crashed_limo Hide();

	level notify("set_default_fog");
	level notify( "set_portal_override_start" );
	contextual_melee_karambit_init();
}

hide_limo_burn()
{
	self Hide();
}

spawn_woods( node, ignoreall )
{
	level.woods = simple_spawn_single( "woods" );
	level.woods make_hero();
	level.woods.ignoreall = ignoreall;
	level.woods.goalradius = 32;
	level.woods.animname = "woods";
	level.woods.team = "allies";
	level.woods set_force_color( "r" );
	level.woods set_run_anim( "run_fast", true );
	
	if( isdefined( node ) )
	{
		level.woods forceTeleport( node.origin );
		level.woods SetGoalPos( node.origin );
	}
}	

spawn_weaver( node, ignoreall )
{
	level.weaver = simple_spawn_single( "weaver" );
	level.weaver make_hero();
	level.weaver.ignoreall = ignoreall;
	level.weaver.goalradius = 32;
	level.weaver.animname = "weaver";
	level.weaver.team = "allies";
	level.weaver set_force_color( "g" );
	level.weaver set_run_anim( "run_fast", true );
	
	if( isdefined( node ) )
	{
		level.weaver forceTeleport( node.origin );
		level.weaver SetGoalPos( node.origin );
	}
}

spawn_woods_undercover( node, ignoreall )
{
	level.woods = simple_spawn_single( "woods_undercover" );
	level.woods make_hero();
	level.woods.ignoreall = ignoreall;
	level.woods.goalradius = 32;
	level.woods.animname = "woods";
	level.woods.team = "allies";
	level.woods set_force_color( "r" );
	level.woods set_run_anim( "run_fast", true );
	
	if( isdefined( node ) )
	{
		level.woods forceTeleport( node.origin );
		level.woods SetGoalPos( node.origin );
	}
}

spawn_bowman_undercover( node, ignoreall )
{	
	level.bowman = simple_spawn_single( "bowman" );
	level.bowman make_hero();
	level.bowman.ignoreall = ignoreall;
	level.bowman.goalradius = 32;
	level.bowman.animname = "bowman";
	level.bowman.team = "allies";
	level.bowman set_force_color( "y" );
	level.bowman set_run_anim( "run_fast", true );
	//level.bowman Attach( "t5_weapon_strela_stow", "tag_stowed_back" );
	
	if( isdefined( node ) )
	{
		level.bowman forceTeleport( node.origin );
		level.bowman SetGoalPos( node.origin );
	}
}

spawn_brooks_undercover( node, ignoreall )
{	
	level.brooks = simple_spawn_single( "brooks" );
	level.brooks make_hero();
	level.brooks.ignoreall = ignoreall;
	level.brooks.goalradius = 32;
	level.brooks.animname = "brooks";
	level.brooks.team = "allies";
	level.brooks set_force_color( "b" );	
	level.brooks set_run_anim( "run_fast", true );
	
	if( isdefined( node ) )
	{
		level.brooks forceTeleport( node.origin );
		level.brooks SetGoalPos( node.origin );
	}
}

spawn_kravchenko( node, ignoreall )
{
	level.kravchenko = simple_spawn_single( "kravchenko" );
	level.kravchenko.ignoreall = ignoreall;
	level.kravchenko.goalradius = 32;
	level.kravchenko.animname = "krav";
	level.kravchenko.team = "axis";
	level.kravchenko gun_remove();
	//level.kravchenko SetModel("c_rus_kravchenko_fb");

	if( isdefined( node ) )
	{
		level.kravchenko forceTeleport( node.origin );
		level.kravchenko SetGoalPos( node.origin );
	}
}

event8_triggers( enable )
{
	trig_array = getentarray( "event8_triggers", "targetname" );
	
	for( i=0;i<trig_array.size;i++ )
	{
		if( enable )
		{
			trig_array[i] trigger_on();
		}
		else
		{
			trig_array[i] trigger_off();
		}
	}
}

event9_triggers( enable )
{
	trig_array = getentarray( "event9_triggers", "targetname" );
	
	for( i=0;i<trig_array.size;i++ )
	{
		if( enable )
		{
			trig_array[i] trigger_on();
		}
		else
		{
			trig_array[i] trigger_off();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////
// Open rocket gantry QUICKLY (for skip to)
///////////////////////////////////////////////////////////////////////////////////////
open_rocket_stabilizer_quickly()
{
	stab_big = getent( "rocket_stabilizer_big", "targetname" );
	stab_big BypassSledgehammer();
	stab_big rotateroll( -55, 2.0, 0.5, 1.0 );
}



open_rocket_gantry_quickly()
{
	level notify( "open_gantry" );
	
	//TUEY Set music to POST BASE FIGHT - back to underscore (for JUMP TO)
	setmusicstate ("POST_BASE_FIGHT");
	
	gantry_1 = getent( "gantry_1", "targetname" );
	gantry_2 = getent( "gantry_2", "targetname" );
	gantry_1_arm = getent( "gantry_1_arm", "targetname" );
	gantry_2_arm = getent( "gantry_2_arm", "targetname" );
	
	gantry_1 BypassSledgehammer();
	gantry_2 BypassSledgehammer();
	gantry_1_arm BypassSledgehammer();
	gantry_2_arm BypassSledgehammer();
	
	gantry_1 rotatepitch( -80, 2.0 );
	gantry_2 rotatepitch( 80, 2.0 );
	gantry_1_arm rotatepitch( 80, 2.0 );
	gantry_2_arm rotatepitch( 80, 2.0 );

	level thread open_rocket_stabilizer_quickly();
}


give_crossbow()
{
	weaponOptions = level.player calcweaponoptions( 6 );
	
	//Give the player crossbow weapon
	level.player GiveWeapon( "crossbow_vzoom_alt_sp", 0, weaponOptions );
	level.player SwitchToWeapon( "crossbow_vzoom_alt_sp" );
	level.player GiveMaxAmmo("crossbow_vzoom_alt_sp");
	level.player GiveMaxAmmo("crossbow_explosive_alt_sp");
}


give_crossbow_expolsive()
{
	weaponOptions = level.player calcweaponoptions( 6 );
	
	//Give the player crossbow weapon
	level.player GiveWeapon( "crossbow_vzoom_alt_sp", 0, weaponOptions );
	level.player SwitchToWeapon( "crossbow_vzoom_alt_sp" );
	level.player GiveMaxAmmo("crossbow_vzoom_alt_sp");
	level.player GiveMaxAmmo("crossbow_explosive_alt_sp");

	level.player TakeWeapon( "python_speed_sp" );

}



	
////////////////////////////////////////////////////////////////////////////////////////////
// PRECACHE
////////////////////////////////////////////////////////////////////////////////////////////
main_precache()
{
	PreCacheString( &"FLASHPOINT_INTROSCREEN_TITLE" ); 
	PreCacheString( &"FLASHPOINT_INTROSCREEN_DATE" ); 
	PreCacheString( &"FLASHPOINT_INTROSCREEN_PLACE" ); 
	
	//-- These get precached in _loadout.gsc
	PreCacheModel( "viewmodel_usa_blackops_spetsnaz_arms" );
	PreCacheModel( "viewmodel_usa_blackops_spetsnaz_fullbody" );
	PreCacheModel( "viewmodel_usa_blackops_spetsnaz_player" );
	PreCacheModel( "viewmodel_hands_no_model" );
	PreCacheModel( "viewmodel_binoculars" );
	PreCacheModel( "t5_weapon_crossbow_world" );
	
	PreCacheModel("c_usa_blackops_weaver_disguise_body" );
	PreCacheModel("c_usa_blackops_weaver_disguise_head" );
	PreCacheModel("c_rus_kravchenko_fb" );
	PreCacheModel("c_usa_specop_barnes_fb" );
	
	//PreCacheModel( "t5_veh_helo_mi8_bloody_glass" );
	PreCacheModel( "c_rus_spetznaz_assault_fb" );
	PreCacheModel( "tag_origin" );
	//PreCacheModel( "t5_weapon_strela_stow" );
	PreCacheModel( "t5_knife_karambit" );
	PreCacheModel( "t5_knife_karambit_world" );
	PreCacheModel( "anim_rus_zipline_hook" );
	PreCacheModel( "t5_weapon_radio_world" );
	//PreCacheModel( "t5_weapon_garrot_wire" );
	//PreCacheModel( "p_rus_headset" );
	
	PreCacheModel("p_rus_rb_lab_warning_light_01");
	PreCacheModel("p_rus_rb_lab_warning_light_01_off");
	PreCacheModel("p_lights_cagelight01_on");
	PreCacheModel("p_lights_cagelight01_off");
	PreCacheModel("p_rus_rb_lab_light_core_on");
	PreCacheModel("p_rus_rb_lab_light_core_off");	
	
	PreCacheRumble( "explosion_generic" );
	PreCacheShellShock( "explosion" );
	PreCacheShellShock( "quagmire_window_break" );
	PreCacheRumble( "damage_heavy" );

	//Weapons
	PreCacheItem( "ak47_sp" );
	PreCacheItem( "ak47_acog_sp" );
	PreCacheItem( "ak47_extclip_sp" );
	PreCacheItem( "ak47_dualclip_sp" );
	PreCacheItem( "ak47_gl_sp" );
	PreCacheItem( "gl_ak47_sp" );

	PreCacheItem( "mp5k_sp" );
	PreCacheItem( "mp5k_elbit_sp" );
	PreCacheItem( "mp5k_extclip_sp" );
	//PreCacheItem( "mp5k_silencer_sp" );
	PreCacheItem( "mp5k_elbit_extclip_sp" );

	PreCacheItem( "pm63_sp" );
	PreCacheItem( "pm63_extclip_sp" );

	PreCacheItem( "makarov_sp" );
	PreCacheItem( "dragunov_sp" );
	PreCacheItem( "huey_rockets" );
	PreCacheItem( "karambit_knife_sp" );
	PreCacheItem( "crossbow_vzoom_alt_sp" );
	PreCacheItem( "crossbow_explosive_alt_sp" );
	//PreCacheItem( "flashpoint_strela_sp" );
	PreCacheItem( "satchel_charge_sp" );
	PreCacheItem( "explosive_bolt_sp" );
	PreCacheItem( "flashpoint_m220_tow_sp" );

	//shabs - for magic bullet purposes
	//PreCacheItem("spas_sp");
	 
	//Heads
	PreCacheModel("c_usa_blackops_weaver_disguise_headb");
	PreCacheModel("c_usa_blackops_weaver_disguise_headm");
	PreCacheModel("c_usa_jungmar_barnes_disguise_headm");
	
	PreCacheModel("c_usa_jungmar_barnes_pris_head");
	PreCacheModel("c_usa_blackops_bowman_disguise_head");
	PreCacheModel("c_usa_jungmar_head3_nohat");
	PreCacheModel("c_usa_mason_disguise_fb"); //shabs - mason head for slides
//	PreCacheModel("c_usa_mason_disguise"); //shabs - mason head for slides


// Woods - 'c_usa_jungmar_barnes_disguise_head', just switch out 'c_usa_jungmar_barnes_disguise_headb' with this.
// Bowman - 'c_usa_blackops_bowman_disguise_head', just switch out 'c_usa_blackops_bowman_disguise_headb' with this.
// Brooks - 'c_usa_jungmar_head3_nohat', just switch out 'c_usa_blackops_bowman_disguise_headb' with this. 

	//vehicle gibs
	PreCacheModel("t5_veh_gaz66_tire_low");
	PreCacheModel("t5_veh_gaz66_door_dest");
	PreCacheModel("t5_veh_gaz66_bumper_dest");

	//PreCacheItem("rpg_magic_bullet_sp");

	PreCacheModel("vehicle_uaz_wheel_RF");
	PreCacheModel("vehicle_uaz_door_RB");
	PreCacheModel("vehicle_uaz_door_LF");
	PreCacheModel("vehicle_uaz_mirror_L");
	PreCacheModel("vehicle_uaz_mirror_R");

	//character\c_rus_helicopter_pilot::precache();
	
	//PreCacheShader("e3_slate");
	PreCacheShader("cinematic");
	PreCacheShader("tow_filter_overlay_no_signal");
}


////////////////////////////////////////////////////////////////////////////////////////////
// FLAG SETUP
////////////////////////////////////////////////////////////////////////////////////////////
level_flag_init()
{
	flag_init( "BEGIN_EVENT2" );
	flag_init( "BEGIN_EVENT3" );
	flag_init( "BEGIN_EVENT4" );
	flag_init( "BEGIN_EVENT5" );
	flag_init( "BEGIN_EVENT6" );
	flag_init( "BEGIN_EVENT7" );
	flag_init( "BEGIN_EVENT8" );
	flag_init( "BEGIN_EVENT9" );
	flag_init( "BEGIN_EVENT10" );
	flag_init( "BEGIN_EVENT11" );
	flag_init( "BEGIN_EVENT12" );
	flag_init( "BEGIN_EVENT13" );
//	flag_init( "BEGIN_EVENT14" );
// 	flag_init( "BEGIN_EVENT15" );
// 	flag_init( "BEGIN_EVENT16" );
// 	flag_init( "BEGIN_EVENT17" );
	
	//Event 1 flags
	flag_init( "WOODS_AT_FIRST_STOP" );
	flag_init( "WOODS_IS_UP_HILL" );
	flag_init( "PLAYER_READY_TO_TAKE_BINOC" );
	flag_init( "WOODS_READY_TO_HAND_BINOC" );
	flag_init( "START_BINOC_ANIM" );
	flag_init( "binocular_done" );
	flag_init( "end_binoculars" );
	flag_init( "PLAYER_DROPPED_DOWN" );
	
	//Event 2 flags
	flag_init( "PIPE_HELI_DANGER_OVER" );
	flag_init( "PIPE_HELI_SPOTTED_DANGER_OVER" );
	flag_init( "PLAYER_SPOTTED" );
	flag_init( "PLAYER_AT_PIPE" );
	flag_init( "WOODS_AT_PIPE" );
	flag_init( "PLAYER_OVER_PIPE" );
	flag_init( "KARAMBIT_GUARDS_READY" );
	flag_init( "KARAMBIT_ATTACK_GO" );
	flag_init( "KARAMBIT_ATTACK_IN_PROGRESS" );
	flag_init( "BREAKS_STEALTH" );
	flag_init( "SHOULD_WOODS_DIE" );
	flag_init( "WOODS_DRAGS_BODY" );
	
	flag_init( "PLAYER_KILLED_GUARD" );
	flag_init( "PLAYER_KILLS_GUARD" );
	flag_init( "PLAYER_HIDES_BODY" );
	flag_init( "WOODS_KILLS_GUARD" );
	
	//Event 3 flags
	flag_init( "ALL_DOGS_ARE_DEAD" );
	flag_init( "PAST_INVESTIGATION_GUARDS" );
	flag_init( "INVESTIGATION_GUARDS_ALERT" );
	flag_init( "MIGS_TRIGGER" );
	flag_init( "TIRE_CHANGERS_KILLED" );
	flag_init( "START_SQUAD_ANIMS" );
	flag_init( "WOODS_ANIM_STARTED" );
	flag_init( "WOODS_ANIM_COMPLETED");
	flag_init( "WHATSTHATNOISE_SCENE_ENDED" );
	
	//Event 4 flags
	flag_init( "PLAYER_MUST_DIE" );
	flag_init( "BASE_ALERT" );
	flag_init( "DISTRACTION_SCENE_BOWMAN_AT_STAIRS" );
	flag_init( "DISTRACTION_SCENE_BROOKS_AT_STAIRS" );
	flag_init( "DISTRACTION_SCENE_BOWMAN_AT_GOAL" );
	flag_init( "DISTRACTION_SCENE_BROOKS_AT_GOAL" );
	flag_init( "READY_FOR_DISTRACTION_ANIM" );
	flag_init( "COMMS_BUILDING_DOOR_OPEN" );
	flag_init( "DOOR_GUARD_DEAD" );
	
	//Event 5 flags
	flag_init( "COMMS_ON_ALERT" );
	flag_init( "START_COMMS_AI" );
	flag_init( "FLOOR1_AI_DOWN_STAIRS" );
	flag_init( "ROOF_AI_STAGE1_DEAD" );
	flag_init( "ROOF_AI_STAGE2_DEAD" );
	flag_init( "PLAYER_ON_ROOF" );
	flag_init( "COMMS_BUILDING_CLEARED" );
	//flag_init( "CLOSE_COMMS_DOOR" );
	
	//Event 6 flags
	flag_init( "PLAYER_BESIDE_WOODS" );
	flag_init( "PLAYER_TAKES_CROSSBOW" );
	flag_init( "READY_TO_SHOOT" );
	flag_init( "START_TRUCKS" );
	flag_init( "BOWMAN_BROOKS_RESCUED" );
	flag_init( "BOWMAN_BROOKS_MOVE_FWD" );
	flag_init( "HIT_TARGET" );
	flag_init( "ROPE_READY" );
	flag_init( "END_OF_ROPE" );
	flag_init( "window_breached" );
	flag_init( "CLEANUP_BASE_ON_ROOF" );
	flag_init( "CLEANUP_BASE_AFTER_ZIPLINE" );
	flag_init( "WEAVER_IS_RESCUED" );
	flag_init( "start_rescue_anims" );
	flag_init( "restore_time" );
	flag_init( "START_WEAVER_RESCUE_MOVIE" );
	flag_init( "start_gunner_fire" );
	
	//Event 7 flags
	flag_init( "ALL_SCIENTISTS_ARE_DEAD" );
	flag_init( "MOVE_THROUGH_LAUNCHPAD" );
	flag_init( "LAUNCHPAD_HELI_DEAD" );
	flag_init( "GANTRIES_STABILIZER_OPEN" );
	flag_init( "PLAYER_OVER_WALL" );
	flag_init( "STOP_COUNTDOWN" );
	flag_init( "CHECKPOINT_RESTART" );
	
	//Event 8 flags
	flag_init( "BOMB_PLANT_READY" );
	flag_init( "bomb_plant" );
	flag_init( "C4_DETONATED" );
	flag_init( "TAKE_WEAPON_FROM_BOWMAN" );
	flag_init( "TAKE_ROCKET" );
	flag_init( "ROCKET_DESTROYED" );
	flag_init( "ROCKET_HITS_GROUND" );
	flag_init( "TOW_FIRED" );
	
	//Event 9 flags
	flag_init( "NOSYMPATHY_SCENE_WOODS_AT_GOAL" );
	flag_init( "NOSYMPATHY_SCENE_WEAVER_AT_GOAL" );
	flag_init( "DROP_LIFT" );
	flag_init( "GO_INTO_TUNNEL" );
	
	//Event 10 flags
	flag_init( "gasmask_done" );
	flag_init( "PLAYER_MOVES_FWD" );
	flag_init( "PLAYER_THROUGH_WND" );
	flag_init( "WOODS_AT_WND" );
	flag_init( "PLAYER_EXIT_GAS_ROOM" );
	
	//Event 13
	flag_init( "WOODS_ON_BTR" );
	flag_init( "WEAVER_ON_BTR" );
	flag_init( "BROOKS_ON_BTR" );
	flag_init( "BOWMAN_ON_BTR" );

	//shabs
	flag_init( "diorama01_go" );
	flag_init( "diorama02_go" );
	flag_init( "diorama03_go" );
	flag_init( "diorama04_go" );
	flag_init( "diorama05_go" );
	flag_init( "diorama06_go" );

	flag_init( "limo_gone" );
	flag_init( "player_in_btr" );
	flag_init( "limo_2_start_driving" );
	flag_init( "hijack_the_btr" );
	flag_init( "limo_escaped_fail" );
	flag_init( "start_dioramas" );
	flag_init( "setup_slides" );

	//Event 14 flags
	flag_init("vehicles_collided");

	flag_init("first_collision");
	flag_init("final_collision");
	flag_init("limo_damage_destroyed");
	flag_init( "spawn_heli_uaz_2" );
	flag_init( "spawn_first_gate_truck" );
	flag_init( "rpg_btr_ownage" );
	flag_init( "end_limo_escaped_fail" );
	flag_init( "stop_animating_limo" );
	flag_init( "limo_half_damaged" );
	flag_init( "limo_fully_damaged" );

	//tunnnel engagements
	flag_init( "start_weaver_vomit" );
	flag_init( "end_weaver_vomit" );
	flag_init( "player_door_anim_done" );
	flag_init( "start_glass_room" );
	flag_init( "start_slide_vo" );

	flag_init( "comm_room_burnt" );


			// FLAMER flags
			
	flag_init("after_drago_go");

	//scriptmover client flag
	//= 0 is used by sound for heli crash in event 3
	level.SCRIPTMOVER_CHARRING = 1;
	level.ACTOR_CHARRING = 2;	
}

////////////////////////////////////////////////////////////////////////////////////////////
// EVENT THREADS
////////////////////////////////////////////////////////////////////////////////////////////
Event2()
{
	level endon( "BEGIN_EVENT3" );
	flag_wait( "BEGIN_EVENT2" );
	level thread maps\flashpoint_e2::event2_RunToPipe();
}
Event3()
{
	level endon( "BEGIN_EVENT4" );
	flag_wait( "BEGIN_EVENT3" );
	level thread maps\flashpoint_e3::event3_WoodsInDisguise();
}
Event4()
{
	level endon( "BEGIN_EVENT5" );
	flag_wait( "BEGIN_EVENT4" );
	level thread maps\flashpoint_e4::event4_WalkingRail();
}
Event5()
{
	level endon( "BEGIN_EVENT6" );
	flag_wait( "BEGIN_EVENT5" );
	level thread maps\flashpoint_e5::event5_InvertedDoorKick();
}
Event6()
{
	level endon( "BEGIN_EVENT7" );
	flag_wait( "BEGIN_EVENT6" );
	level thread maps\flashpoint_e6::event6_ZipLine();
}
Event7()
{
	level endon( "BEGIN_EVENT8" );
	flag_wait( "BEGIN_EVENT7" );
	level thread maps\flashpoint_e7::event7_HideOverWall();
}
Event8()
{
	level endon( "BEGIN_EVENT9" );
	flag_wait( "BEGIN_EVENT8" );
	level thread maps\flashpoint_e8::event8_ControlRoomBunkerBreach();
}
Event9()
{
	level endon( "BEGIN_EVENT10" );
	flag_wait( "BEGIN_EVENT9" );
	level thread maps\flashpoint_e9::event9_SceneFromHell();
}
Event10()
{
	level endon( "BEGIN_EVENT11" );
	flag_wait( "BEGIN_EVENT10" );
	level thread maps\flashpoint_e10::event10_TearGasRoom();
}
Event11()
{
	level endon( "BEGIN_EVENT12" );
	flag_wait( "BEGIN_EVENT11" );
	level thread maps\flashpoint_e11::event11_AssassinateScientists();
}
Event12()
{
	level endon( "BEGIN_EVENT13" );
	flag_wait( "BEGIN_EVENT12" );
	level thread maps\flashpoint_e12::event12_HeadScientist();
}
Event13()
{
	level endon( "END_MISSION" );
	flag_wait( "BEGIN_EVENT13" );
	level thread maps\flashpoint_e13::event13_Garage();

}
//Event14()
//{
	//level endon( "BEGIN_EVENT15" );
//	flag_wait( "BEGIN_EVENT14" );
//	level thread maps\flashpoint_e14::event14_BTRDrive();
//
//}
// Event15()
// {
// 	level endon( "BEGIN_EVENT16" );
// 	flag_wait( "BEGIN_EVENT15" );
// 	level thread maps\flashpoint_e15::event15_PlayerChoice();
// }
// Event16()
// {
// 	level endon( "BEGIN_EVENT17" );
// 	flag_wait( "BEGIN_EVENT16" );
// 	level thread maps\flashpoint_e16::event16_DaveDevil();
// }
// Event17()
// {
// 	level endon( "END_MISSION" );
// 	flag_wait( "BEGIN_EVENT17" );
// 	level thread maps\flashpoint_e17::event17_InboundChopper();
// }



////////////////////////////////////////////////////////////////////////////////////////////
// JUMP TO - This section contains all the level jump to setup calls
////////////////////////////////////////////////////////////////////////////////////////////
event2_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event2_jumpto();
	set_level_objective( 0, "active" );
	
	player_binoculars_point = getnode( "player_binoculars_point", "targetname" );
	woods_binoculars_point_2 = getnode( "woods_binoculars_point_2", "targetname" );
	
	//Player
	level.player setorigin( player_binoculars_point.origin );
	level.player setplayerangles( player_binoculars_point.angles );
	
	//Squad	
	spawn_woods( woods_binoculars_point_2, true );

	//binoculars_trigger = GetEnt("binoculars_trigger", "targetname");
	//binoculars_trigger trigger_off();

	//Spawn a 2nd helicopter to look menacing
	pipe_chopper_02_start_node = GetVehicleNode( "pipe_chopper_02_start", "targetname" );
	level.pipe_chopper_02 = SpawnVehicle( "t5_veh_helo_mi8_woodland", "pipe_chopper_02", "heli_hip", pipe_chopper_02_start_node.origin, (0,0,0) );
	maps\_vehicle::vehicle_init( level.pipe_chopper_02 );
	level.pipe_chopper_02.health = 999999;
	level.pipe_chopper_02.drivepath = 1;
	
	//Spawn the helicopter we need in this section
	level thread maps\flashpoint_e1::helicopter2_flyby();
	
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	Objective_Set3D( level.obj_num, false );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	
	//Got to wait the same time as the proper scripts to let the helicopter get to the same spot
 	wait( 2.3 );
 	wait( 4.9 );
	wait( 5.0 );
			
	level._start = "event_2";
	flag_set( "BEGIN_EVENT2" );
}
event3_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event3_jumpto();
	set_level_objective( 0, "active" );
	//level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
	//level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";

	player_at_dogs = getnode( "player_at_dogs", "targetname" );	
	woods_at_dogs = getnode( "woods_at_dogs", "targetname" );
	
	//Player
	level.player setorigin( player_at_dogs.origin );
	level.player setplayerangles( player_at_dogs.angles );
	level.player FreezeControls( true );
	
	//Squad
	spawn_woods_undercover( woods_at_dogs, true );
	
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	Objective_Set3D( level.obj_num, false );
	level.obj_num++;
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_HIDE_GUARD" );
	level.obj_num--;
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	level._start = "event_3";
	flag_set( "BEGIN_EVENT3" );
}
event4_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event4_jumpto();
	
	set_level_objective( 0, "active" );
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	
	event4_start = getnode( "event4_start", "targetname" );
	woods_post_jeepmeetup = getnode( "woods_post_jeepmeetup", "targetname" );
	bowman_post_jeepmeetup = getnode( "bowman_post_jeepmeetup", "targetname" );	
	brooks_post_jeepmeetup = getnode( "brooks_post_jeepmeetup", "targetname" );	
	
	//Player
	level.player setorigin( event4_start.origin );
	level.player setplayerangles( event4_start.angles );
	
	level.player GiveWeapon( "ak47_acog_sp" );
	level.player SwitchToWeapon( "ak47_acog_sp" );
	level.player TakeWeapon( "mp5k_elbit_extclip_sp" );
	
	//Squad
	spawn_woods_undercover( woods_post_jeepmeetup, true );
	spawn_brooks_undercover( brooks_post_jeepmeetup, true );
	spawn_bowman_undercover( bowman_post_jeepmeetup, true );
	
	level.player thread maps\flashpoint_e3::distance_to_ai( level.woods );
	
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_OBJ_FOLLOW" );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	level._start = "event_4";
	flag_set( "BEGIN_EVENT4" );
}
#using_animtree("animated_props");
event5_opendoor()
{
	anim_node = get_anim_struct( "9" );
	comms_door_ent = getent( "comms_door", "targetname" );
	comms_door_ent.animname = "door";
	comms_door_ent useAnimTree( #animtree ); 
	anim_node thread anim_single_aligned( comms_door_ent, "comms_open" );
	anim_node waittill( "comms_open" );
}
event5_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event5_jumpto();
	
	set_level_objective( 0, "active" );
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	
	player_start = getstruct( "node_player_comms", "targetname" );
	woods_start = getnode( "node_woods_comms_start", "targetname" );	
	lewis_start = getnode( "node_lewis_comms_attack", "targetname" );	
	hudson_start = getnode( "node_hudson_comms_attack", "targetname" );	
		
	//Player
	level.player setorigin( player_start.origin );
	level.player setplayerangles( player_start.angles );
	
	level.player GiveWeapon( "ak47_acog_sp" );
	level.player SwitchToWeapon( "ak47_acog_sp" );
	level.player TakeWeapon( "mp5k_elbit_extclip_sp" );
	
	//Squad
	spawn_woods_undercover( woods_start, false );
	spawn_brooks_undercover( lewis_start, true );
	spawn_bowman_undercover( hudson_start, true );
	
	//Bring up pipe blocker script_brushmodel
	level.door_blocker = getent( "door_blocker", "targetname" );
	level.door_blocker NotSolid();
	level.door_blocker connectpaths();
	
	//spawn 3 roof snipers
	trigger_base_distant_helis_trig = getent( "trigger_base_distant_helis", "targetname" );
	trigger_base_distant_helis_trig activate_trigger();
	
	level thread event5_opendoor();
	
	level thread maps\flashpoint_e5::spawnguards_in_room();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	level._start = "event_5";
	flag_set( "BEGIN_EVENT5" );
}
event6_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event6_jumpto();
	
	set_level_objective( 0, "active" );
	level notify("set_commsbuildingroof_fog");
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	
	player_onroof_point = getstruct( "zipline_moveto", "targetname" );
	woods_onroof_point = getnode( "woods_onroof_point", "targetname" );	
	node_lewis_comms_attack = getnode( "brooks_comms_wait", "targetname" );	
	node_hudson_comms_attack = getnode( "bowman_comms_wait", "targetname" );	
		
	//Player
	level.player setorigin( player_onroof_point.origin );
	level.player setplayerangles( player_onroof_point.angles );
	
	level.player GiveWeapon( "ak47_acog_sp" );
	level.player SwitchToWeapon( "ak47_acog_sp" );
	level.player TakeWeapon( "mp5k_elbit_extclip_sp" );
	
	//Squad
	spawn_woods_undercover( woods_onroof_point, true );
	spawn_brooks_undercover( node_lewis_comms_attack, true );
	spawn_bowman_undercover( node_hudson_comms_attack, true );
	
	
	//Diable sniper trigger (skipto)
//	comms_spawner_roofminigame_2_trig = getent( "comms_spawner_roofminigame_2_trig", "targetname" );
//	comms_spawner_roofminigame_2_trig Delete();
	
//	level thread open_rocket_gantry_quickly();
	level thread maps\flashpoint_e6::spawnExplosiveBoltFriendlyCover();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
	
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	level._start = "event_6";
	flag_set( "BEGIN_EVENT6" );
}
event7_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event7_jumpto();
	
	set_level_objective( 0, "active" );
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	level.player give_crossbow();
	level.player TakeWeapon( "python_speed_sp" );
	
	player_breachroom_after = getnode( "player_breachroom_after", "targetname" );
	woods_breachroom_after = getnode( "woods_breachroom_after", "targetname" );
	hudson_breachroom_after = getnode( "hudson_breachroom_after", "targetname" );
	lewis_breachroom_after = getnode( "lewis_breachroom_after", "targetname" );
	weaver_breachroom_after = getnode( "weaver_breachroom_after", "targetname" );	
	
	//Player
	level.player setorigin( player_breachroom_after.origin );
	level.player setplayerangles( player_breachroom_after.angles );
	
	//Squad
	spawn_woods_undercover( woods_breachroom_after, true );
	spawn_brooks_undercover( lewis_breachroom_after, true );
	spawn_bowman_undercover( hudson_breachroom_after, true );
	spawn_weaver( weaver_breachroom_after, true );
	
	flag_wait("introscreen_complete");
	
//	level thread open_rocket_gantry_quickly();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE" );
	level.obj_num++;	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_RESCUE_WEAVER" );
	
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	
	//Play lights on the "stadium lights"
	exploder(121);

	level._start = "event_7";
	flag_set( "BEGIN_EVENT7" );
}
event8_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event8_jumpto();
	
	set_level_objective( 1, "active" );
	
	maps\flashpoint::event8_triggers( false );
	maps\flashpoint::event9_triggers( false );
	
	//FLASHPOINT_OBJ_C4_BUILDING
	set_event_objective( 6, "active" );
	
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	level.player give_crossbow();
	level.player TakeWeapon( "python_speed_sp" );
	
	control_room_A = getnode( "control_room_A", "targetname" );
	control_room_B = getnode( "control_room_B", "targetname" );
	control_room_C = getnode( "control_room_C", "targetname" );
	control_room_D = getnode( "control_room_D", "targetname" );
	control_room_PLAYER = getnode( "control_room_PLAYER", "targetname" );	
	
	//Player
	level.player setorigin( control_room_PLAYER.origin );
	level.player setplayerangles( control_room_PLAYER.angles );
	
	//Squad
	spawn_woods_undercover( control_room_A, false );
	spawn_weaver( control_room_B, false );
	spawn_bowman_undercover( control_room_C, false );
	spawn_brooks_undercover( control_room_D, false );
	
	flag_wait("introscreen_complete");
	wait( 2.0 );
	
	level.woods SetGoalPos( control_room_A.origin );
	level.weaver SetGoalPos( control_room_B.origin );
	level.bowman SetGoalPos( control_room_C.origin );
	level.brooks SetGoalPos( control_room_D.origin );
	
	level.woods enable_cqbwalk();
	level.weaver enable_cqbwalk();
	level.bowman enable_cqbwalk();
	level.brooks enable_cqbwalk();
	
	level thread open_rocket_gantry_quickly();
	level thread maps\flashpoint_e7::swap_heads();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE" );
	level.obj_num++;	
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_RESCUE_WEAVER" );
	level.obj_num++;
	
	explosive_charge = getent( "b2_satchel", "targetname" );
	Objective_Add( level.obj_num, "current",  &"FLASHPOINT_OBJ_ABORT_THE_LAUNCH", explosive_charge.origin + ( 0, 0, 15 ) );
	Objective_Set3D( level.obj_num, false );
	
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	
	level._start = "event_8";
	flag_set( "BEGIN_EVENT8" );
}
event9_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event9_jumpto();
	
	maps\flashpoint::event8_triggers( false );
	
	level.player setviewmodel( "t5_gfl_ump45_viewmodel" );
	level.player_interactive_model = "t5_gfl_ump45_viewbody";
	level.player_interactive_hands = "t5_gfl_ump45_viewmodel_player";
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_model["player_hands"] = level.player_interactive_hands;
	level.player give_crossbow();
	level.player TakeWeapon( "python_speed_sp" );
	
	control_room_A = getnode( "control_room_A", "targetname" );
	control_room_B = getnode( "control_room_B", "targetname" );
	control_room_C = getnode( "control_room_C", "targetname" );
	control_room_D = getnode( "control_room_D", "targetname" );
	control_room_PLAYER_2 = getnode( "control_room_PLAYER_2", "targetname" );	
	
	//Player
	level.player setorigin( control_room_PLAYER_2.origin );
	level.player setplayerangles( control_room_PLAYER_2.angles );
	
	//Squad
	spawn_woods_undercover( control_room_A, false );
	spawn_weaver( control_room_B, false );
	spawn_bowman_undercover( control_room_C, false );
	spawn_brooks_undercover( control_room_D, false );
	
	flag_wait("introscreen_complete");
	
	level.woods SetGoalPos( control_room_A.origin );
	level.weaver SetGoalPos( control_room_B.origin );
	level.bowman SetGoalPos( control_room_C.origin );
	level.brooks SetGoalPos( control_room_D.origin );
	
	level thread maps\flashpoint_e7::swap_heads();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE" );
	level.obj_num++;	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_RESCUE_WEAVER" );
	level.obj_num++;
	Objective_Add( level.obj_num, "done",  &"FLASHPOINT_OBJ_DESTROY_ROCKET" );
	
	//Play lights on the "stadium lights"
	exploder(121);
	
	level._start = "event_9";
	flag_set( "BEGIN_EVENT9" );

}
// event10_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event10_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	weaver_gas_room = getnode( "weaver_gas_room", "targetname" );
// 	woods_gas_room = getnode( "woods_gas_room", "targetname" );
// 	player_gas_room = getnode( "player_gas_room", "targetname" );
// 
// 	//Player
// 	level.player setorigin( player_gas_room.origin );
// 	level.player setplayerangles( player_gas_room.angles );
// 	
// 	//Squad
// 	spawn_woods_undercover( woods_gas_room, false );
// 	spawn_weaver( weaver_gas_room, false );
// 
// 	flag_wait("introscreen_complete");
// 	
// 	level.woods SetGoalPos( woods_gas_room.origin );
// 	level.weaver SetGoalPos( weaver_gas_room.origin );
// 	
// 	level thread maps\flashpoint_e7::swap_heads();
// 	
// 	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
// 	Objective_Set3D( level.obj_num, false );
// 
// 	level._start = "event_10";
// 	flag_set( "BEGIN_EVENT10" );
// }
// event11_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event11_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	weaver_postgas_room = getnode( "weaver_postgas_room", "targetname" );
// 	woods_postgas_room = getnode( "woods_postgas_room", "targetname" );
// 	player_postgas_room = getnode( "player_postgas_room", "targetname" );
// 
// 	//Player
// 	level.player setorigin( player_postgas_room.origin );
// 	level.player setplayerangles( player_postgas_room.angles );
// 	
// 	//Squad
// 	spawn_woods_undercover( woods_postgas_room, false );
// 	spawn_weaver( weaver_postgas_room, false );
// 
// 	flag_wait("introscreen_complete");
// 	
// 	level.woods SetGoalPos( woods_postgas_room.origin );
// 	level.weaver SetGoalPos( weaver_postgas_room.origin );
// 	
// 	level thread maps\flashpoint_e7::swap_heads();
// 	
// 	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
// 	Objective_Set3D( level.obj_num, false );
// 	
// 	level._start = "event_11";
// 	flag_set( "BEGIN_EVENT11" );
// }
// event12_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event12_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	weaver_headsci_start = getnode( "weaver_headsci_start", "targetname" );
// 	woods_headsci_start = getnode( "woods_headsci_start", "targetname" );
// 	player_headsci_start = getnode( "player_headsci_start", "targetname" );
// 
// 	//Player
// 	level.player setorigin( player_headsci_start.origin );
// 	level.player setplayerangles( player_headsci_start.angles );
// 	
// 	//Squad
// 	spawn_woods_undercover( woods_headsci_start, false );
// 	spawn_weaver( weaver_headsci_start, false );
// 
// 	flag_wait("introscreen_complete");
// 	
// 	level.woods SetGoalPos( woods_headsci_start.origin );
// 	level.weaver SetGoalPos( weaver_headsci_start.origin );
// 	
// 	level thread maps\flashpoint_e7::swap_heads();
// 
// 	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
// 	Objective_Set3D( level.obj_num, false );
// 	
// 	level._start = "event_12";
// 	flag_set( "BEGIN_EVENT12" );
// }
event13_jumpto()
{
	common_event_startup();
	level thread maps\flashpoint_portal::set_portal_override_event13_jumpto();
	//level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
	//level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
	//level.player give_crossbow();
	
	//Squad
	thread spawn_woods_undercover( undefined, false );
	//spawn_weaver( undefined, false );

	flag_wait("introscreen_complete");
	
	//level thread maps\flashpoint_e7::swap_heads();
	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_INFILTRATE_BASE" );
	level.obj_num++;	
	Objective_Add( level.obj_num, "done", &"FLASHPOINT_OBJ_RESCUE_WEAVER" );
	level.obj_num++;
	Objective_Add( level.obj_num, "done",  &"FLASHPOINT_OBJ_DESTROY_ROCKET" );
	level.obj_num++;
	Objective_Add( level.obj_num, "current",  &"FLASHPOINT_OBJ_FIND_DRAGOVICH" );
	
	level._start = "event_13";
	flag_set( "BEGIN_EVENT13" );
	flag_set( "setup_slides" );
	
	//FOR AUDIO
	clientNotify ("slides");
	setmusicstate ("SLIDES");

}
// event14_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event14_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	//Make sure the player is at the correct start position
// 	event14_start = getnode( "event14_start", "targetname" );
// 	level.player setorigin( event14_start.origin );
// 	level.player setplayerangles( event14_start.angles );
// 	
// 	//level.player thread maps\flashpoint_e13::spawn_player_BTR();
// 	level thread maps\flashpoint_e7::swap_heads();
// 	
// 	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_INFILTRATE_BASE", level.woods );
// 	Objective_Set3D( level.obj_num, false );
// 	
// 	level._start = "event_14";
// 	flag_set( "BEGIN_EVENT14" );
// }
// event15_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event15_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	level._start = "event_15";
// 	flag_set( "BEGIN_EVENT15" );
// }
// event16_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event16_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	level._start = "event_16";
// 	flag_set( "BEGIN_EVENT16" );
// }
// event17_jumpto()
// {
// 	common_event_startup();
// 	level thread maps\flashpoint_portal::set_portal_override_event17_jumpto();
// 	
// 	level.player setviewmodel( "viewmodel_usa_blackops_spetsnaz_arms" );
// 	level.player_interactive_model = "viewmodel_usa_blackops_spetsnaz_fullbody";
// 	level.player give_crossbow();
// 	
// 	level._start = "event_17";
// 	flag_set( "BEGIN_EVENT17" );
// }


////////////////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////////////////
