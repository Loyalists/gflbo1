/*
	
	KOWLOON E2 Gas Leak

	This starts after the player gains control after the interrogation.
	It ends after the player leaps into the cache room.
*/
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\_music;
#include maps\_audio;

event2()
{
	flag_init( "gas_released" );

	flag_wait( "event2" );

	//shabs - show ladder
//	player_ladder = GetEnt( "player_ladder", "targetname" );
//	player_ladder trigger_on();

	level thread event_2_dialog();
	
//	trig_force_breach = GetEnt( "trig_force_breach", "targetname" );
//	trig_force_breach waittill_notify_or_timeout( "trigger", 1.75 ); // wait a couple of seconds after the cutscene ends before starting breach

	level thread wall_breach();
	wait(10.0);	// Delay running everything else so you get some combat before gas can release

	level thread gas_leak();
	level thread hallways();
	level thread airplane_flyby();
	level thread rooftop();
	level thread awning_ripped();
	
	//shabs - adding flashback audio lines and setting new fog
	level thread flashback_audiO();

	level thread reduce_ai_accuracy_before_the_jump();
	level thread accuracy_timeout();
	level thread maps\kowloon_cache_run::event3();
	// Wait for the end of the event
	flag_wait( "event3" );

	// Cleanup outside guys
	ai = GetAIArray( "axis" );
	for ( i=0; i<ai.size; i++ )
	{	
		if( IsAlive( ai[i] ))
		{
			ai[i] Delete();
			wait_network_frame();
		}
	}
}

//
//
smoke_monster()
{
	level endon( "event3" );

	gas_start = GetStruct( "smoke_start", "targetname" );

	gas_ent = Spawn( "script_model", gas_start.origin );
	gas_ent SetModel( "tag_origin" );
 	fx = PlayFxOnTag( level._effect["fx_gas_nova6_room_filler"], gas_ent, "tag_origin" );
// 	fx = PlayFx( level._effect["fx_gas_nova6_room_filler"], gas_ent.origin, AnglesToForward(gas_ent.angles) );

	trig = GetEnt( "smoke_monster", "targetname" );
	trig EnableLinkTo();
	trig LinkTo( gas_ent );

	trig thread gas_hurt();

	next_target = GetStruct( gas_start.target, "targetname" );
	gas_ent MoveTo( next_target.origin, 20.0 );
	gas_ent waittill( "movedone" );

 	fx = PlayFx( level._effect["fx_gas_nova6_room_filler"], next_target.origin, (1, 0, 0) );

	next_target = GetStruct( next_target.target, "targetname" );
	gas_ent MoveTo( next_target.origin, 5.0 );
	gas_ent waittill( "movedone" );

}


gas_hurt()
{
	level endon( "event3" );

	while (1)
	{
		self waittill( "trigger", ent );

		if ( IsPlayer( ent ) )
		{
			flag_set( "e2_player_inhaled" );
			//ent DoDamage( 33, self.origin );
			//SOUND - Shawn J
			clientnotify ("gassed");
			wait( 2 );
		}
	}
}


//	This is the gas leak even where the player has to shoot a gas tank
//
gas_leak()
{
	//trap_door_clip = GetEnt( "trap_door_clip", "targetname" );
	//trap_door_clip trigger_off();

	gas_tanks = GetEntArray( "sm_gas_barrel", "targetname" );

	
//	level thread maps\kowloon::Objective_Shoot_canister();
	array_thread( gas_tanks, ::gas_tank );
	level thread gas_rupture_failsafe();

	// Wait until the gas is shot
	flag_wait( "gas_released" );

	// Spawn a new victim in case the others were killed.
	ai = simple_spawn_single( "ai_e2_gas_victim", ::force_goal );
	level.ai_gas_room = add_to_array( level.ai_gas_room, ai );
	
	// Now Kill the guys when the gas is released
	level.ai_gas_room = array_randomize( level.ai_gas_room );
	for ( i=0; i<level.ai_gas_room.size; i++ )
	{
		if ( IsAlive( level.ai_gas_room[i] ) )
		{
			level.ai_gas_room[i] thread nova6_death();
		}
	}
	wait( 0.5 );

	level thread smoke_monster();

	// SOUND - Shawn J - gas
	playsoundatposition("evt_gas_leak",(1082, 944, 3486));

	exploder(2001);	// gas room filler
	battlechatter_on();
	//trap_door = GetEnt( "lab_hatch", "targetname" );
	//trap_door RotatePitch( -90, 1.0, 0.9 );

	//shabs - deleting player clip brush where closed hatch opens
	hatch_player_clip = GetEnt( "hatch_player_clip", "targetname" );
	hatch_player_clip Delete();

	player_ladder_clip = GetEnt( "player_ladder_clip", "targetname" );
	player_ladder_clip Delete();

	level thread maps\kowloon_anim::inter_hatch_setup();
	wait( 0.7 );

	exploder(2101);	// hatch light
	//trap_door_clip trigger_on();
	//SOUND - Shawn J
	playsoundatposition( "evt_trap_door", (1469, 1003, 3550) );
    flag_set( "obj_start" );

	trigger = GetEnt( "escape_dialog", "targetname" );
	trigger waittill_notify_or_timeout( "trigger", 8 );

	level thread move_weaver_up_timout();

//	// Move Weaver upstairs
//	level.heroes["weaver"].ignoreme = true;
//	level.heroes["weaver"].ignoreall = true;
//	level.heroes["weaver"].ignoresuppresion = true;
//	level.heroes["weaver"] disable_react();
//	level.heroes["weaver"] disable_pain();
//	level.heroes["weaver"].goalradius = 32;
//
//	node = GetNode( "n_above_lab", "targetname" );
//	level.heroes["weaver"] SetGoalNode( node );
//	level.heroes["weaver"] enable_cqbwalk();
//
//	level.heroes["weaver"] waittill_notify_or_timeout( "goal", 8 );
//
//	level.heroes["weaver"] disable_cqbwalk();
//	level.heroes["weaver"].goalradius = 2048;
//	level.heroes["weaver"].ignoreme = false;
//	level.heroes["weaver"].ignoreall = false;
//	level.heroes["weaver"].ignoresuppresion = false;
//	level.heroes["weaver"] enable_react();
//	level.heroes["weaver"] enable_pain();
}

move_weaver_up_timout()
{

	//level endon( "kill_force_move_weaver" );

	// Move Weaver upstairs
//	level.heroes["weaver"].ignoreme = true;
//	level.heroes["weaver"].ignoreall = true;
//	level.heroes["weaver"].ignoresuppresion = true;
//	level.heroes["weaver"] disable_react();
//	level.heroes["weaver"] disable_pain();
//	level.heroes["weaver"].goalradius = 32;

	node = GetNode( "n_above_lab", "targetname" );
	level.heroes["weaver"] enable_cqbwalk();
	level.heroes["weaver"] thread force_goal( node, 64 );
	//level.heroes["weaver"] waittill_notify_or_timeout( "goal", 8 );
	//level.heroes["weaver"] disable_cqbwalk();

	//level.heroes["weaver"] SetGoalNode( node );
	//goal_node = GetNode( self.target, "targetname" );

//	level.heroes["weaver"].goalradius = 2048;
//	level.heroes["weaver"].ignoreme = false;
//	level.heroes["weaver"].ignoreall = false;
//	level.heroes["weaver"].ignoresuppresion = false;
//	level.heroes["weaver"] enable_react();
//	level.heroes["weaver"] enable_pain();
}

gas_rupture_failsafe()
{
	trig = GetEnt( "smoke_monster", "targetname" );
	trig waittill( "trigger" );

	playsoundatposition( "exp_gas_tank_explo", trig.origin );
	flag_set( "gas_released" );
}

// Waits for a tank to be shot.
//	self is a script_model
gas_tank()
{
	self SetCanDamage( true );
	timeout = GetTime() + 500;

	level.gas_tanks_counter++;
	while ( !flag( "gas_released" ) )
	{
		self waittill( "damage", amount, attacker, dir, point, type );

		if ( attacker == get_players()[0] && type != "MOD_IMPACT" )
		{
			level.gas_tanks_counter--;	// Tanks shot, help unlock the thundergun
			if ( level.gas_tanks_counter == 0 )
			{
				level notify("thunder");
			}
		}

		if ( attacker == get_players()[0] || GetTime() >= timeout )
		{
			vector = dir * -1;
			playsoundatposition( "exp_gas_tank_explo", self.origin );
			PlayFX( level._effect["fx_gas_nova6_spray"], point, vector );
			flag_set( "gas_released" );
		}
	}
}

#using_animtree ("generic_human");
//	Swap the body and head models and initiate Nova6 shader effect
//	self is an AI
nova6_death()
{
	self endon( "death" );

	// Only have char for the "a" type right now.
	if ( IsSubStr( self.model, "bodya" ) )
	{
		self SetModel( self.model + "_char" );
	}

	//	Swap the head
	// size = self GetAttachSize();
	// for( i = 0; i < size; i++ )
	// {
	// 	model = self GetAttachModelName( i ); 
	// 	if( IsSubStr( model, "head" ) )
	// 	{
	// 		self Detach( model, "", true ); 
	// 		self Attach( model + "_char", "", true );
	// 		break;
	// 	}
	// }
	wait( RandomFloatRange( 0.05, 1.5 ) );

	self SetClientFlag(level.CLIENT_NOVA6_FLAG);	// start burn shader

	// Charge the player (so we can get a better look at them)
	self.goalradius = RandomFloatRange( 64, 100);
	self.ignoreall = 1;
	self disable_cqbwalk();
	player = get_players()[0];
	node = GetNode( "n_e2_gas_death", "targetname" );
	self SetGoalNode( node );
	self waittill_notify_or_timeout("goal", RandomFloatRange(2.0, 4.0) );

	self gas_shader_on();
	self DoDamage( self.health, self.origin, undefined, -1, "gas" );
}

//------------------------------------
// Turn on gas shader
gas_shader_on()
{
	if( is_mature() )
	{
		PlayFXOnTag(level._effect["gas_death_fumes"], self, "J_Head");
	}
	//self SetClientFlag( level.CLIENT_NOVA6_FLAG );
}

//
//	Spetsnaz blow open a door to the apartment and rush in
door_breach( ainame, doorname )
{
	ai = simple_spawn_single( ainame, maps\kowloon_util::indoor_force_goal );
	level.ai_gas_room = add_to_array( level.ai_gas_room, ai );
	wait( 1.0 );

	// Play some effects and delete the door
	door = GetEnt( doorname, "targetname" );
	door Delete();
}


//
//	Keep pouring guys in
enemy_replenish()
{
	level endon( "gas_released" );

	level.ai_gas_room = remove_undefined_from_array( level.ai_gas_room );
	while( 1 )
	{
		wait( RandomFloatRange( 0.5, 2.0 ) );

		level.ai_gas_room = remove_undefined_from_array( level.ai_gas_room );
		if ( level.ai_gas_room.size < 6 )
		{
			ai = simple_spawn_single( "ai_e2_replenish", ::enable_cqbwalk );
			level.ai_gas_room = add_to_array( level.ai_gas_room, ai );
		}
	}
}


//	The scene where Spetsnaz bust into the apartment
//
wall_breach()
{
	// Spawn the breachers.  Randomly make one a rusher
	level.ai_gas_room = simple_spawn( "ai_e1_breach", ::init_ai_e1_breach );	
	
	if( level.gameskill == 3 )
	{
		array_thread( level.ai_gas_room, maps\kowloon_util::reduce_accuracy_veteran );
	}

	level.ai_gas_room[ RandomInt(level.ai_gas_room.size) ] maps\_rusher::rush();

//	level.ai_gas_room[0] thread start_spetz_audio_lab();
	level thread door_breach( "ai_e1_lab_door_2", "lab_breach_door_2" );
	Exploder(1302);
	wait( 1.0 );

	level thread door_breach( "ai_e1_lab_door_1", "lab_breach_door_1" );
	Exploder(1301);
	wait( 2.0 );

	// SOUND - Shawn J - pre Wall Breach
	playsoundatposition("evt_pre_wall_breach",(689, 919, 3497));
	
	// Wait for the wall breachers to start
	wait( 2.0 );

	level thread enemy_replenish();

	// Boom!  Wall breach!
	// Play initial explosion fx
	exploder(1201);

	wall = GetEnt( "lab_breach_wall", "targetname" );

	// SOUND - Shawn J - Wall Breach
	wall playsound("evt_wall_breach");
	wait(1.0);

	wall MoveX( -25, 0.5 );
	wall RotatePitch( 90, 1.0, 0.5 );
	wall waittill( "movedone" );

	wall ConnectPaths();

	// Cleanup
	flag_wait( "event3" );

	wall Delete();
}

//shabs - making guys target their nodes and force goaling there
init_ai_e1_breach()
{
	self endon( "death" );

	self enable_cqbwalk();
	
	self thread maps\kowloon_util::force_goal_self();
}
 
//
//
roller()
{
	self endon( "death" );

	maps\kowloon_util::indoor_force_goal();

	sync_node = GetStruct( "ss_e2_roll_here", "targetname" );
	sync_node anim_reach_aligned( self, "roll", undefined, "spetznaz" );
	self.allowdeath = true;
	sync_node anim_single_aligned( self, "roll", undefined, "spetznaz" );
	self.deathfunction = undefined;
}

roller_deathfunc()
{
	self.deathfunction = animscripts\utility::do_ragdoll_death;
}

//
//	After leaving the room, we round a corner and see a civ run into an 
//	apartment, shutting the door behing him.  He is quickly followed by 
//	Spetsnaz
hallways()
{
	level thread hallway_battle_advance();

	trigger_wait( "trig_e2_hallway_start" );
	autosave_by_name( "kowloon_gas_escape_hallway" );

	trigger_wait( "trig_e2_civ_chase" );

	level thread maps\createart\kowloon_art::turn_lightning_off();

	// Spetsnaz
	ai = simple_spawn( "ai_e2_civ_chase", maps\kowloon_util::indoor_force_goal );

	if( level.gameskill == 3 )
	{
		array_thread( ai, maps\kowloon_util::reduce_accuracy_veteran );
	}

	ai[0] thread spez_civ_move_dialog();

	ai = simple_spawn( "ai_e2_civ_chase_roller", ::roller_deathfunc );
	array_thread( ai, ::roller );

	// Door civ
	civ = simple_spawn_single( "ai_e2_civ_door", ::force_goal );
	civ thread play_civilian_yells();

	// Kill the civ
	wait( 1.0 );

	civ.health = 1;
	civ.team = "allies";

	bullet_spawner = GetStruct( "e2_bullet_spawner", "targetname" );
	MagicBullet ( "kiparis_sp", bullet_spawner.origin, civ.origin+(0,0,45) );
	wait(0.10);
	MagicBullet ( "kiparis_sp", bullet_spawner.origin, civ.origin+(0,0,45) );
	wait(0.10);
	MagicBullet ( "kiparis_sp", bullet_spawner.origin, civ.origin+(0,0,45) );
	wait(0.10);
	civ DoDamage( civ.health, bullet_spawner.origin );

	// Stair guys
	trigger_wait( "trig_e2_stair_guys" );
	ai = simple_spawn( "ai_e2_stairs", ::init_ai_e2_stairs );

	//shabs
	ai_e2_stairs = simple_spawn_single( "ai_e2_stair_guy", ::roller_deathfunc );
	ai_e2_stairs.grenadeawareness = 0;

	e2_stairs_node = GetNode( "e2_stairs_node", "targetname" );
	ai_e2_stairs thread force_goal( e2_stairs_node, 32 );

	ai[0] thread spetz_stair_dialog();
	
	trigger_wait( "trig_e2_lightning" );

	//shabs - cleaning up extra rooftop guys
	level thread maps\kowloon_util::kill_aigroup( "ai_e2_rooftop_extras" );

	level notify("objective_pos_update" );	// Head to rooftop edge
	level thread lightning_strike_guy();
}

init_ai_e2_stairs()
{
	self endon( "death" );

	self enable_cqbwalk();

	self thread maps\kowloon_util::force_goal_self();
	
}


//
//	Keeps the battle moving if the player hangs back
hallway_battle_advance()
{
	// shortcuts to advance the battle as people die
	waittill_ai_group_cleared( "e2_civ_chase" );
	trigger_use( "trig_e2_stair_guys" );
}


//
//
lightning_strike_guy()
{
	//ai = simple_spawn_single( "ai_e2_lightning", maps\kowloon_util::indoor_force_goal );
	ai = simple_spawn_single("ai_e2_lightning");
	
	level thread color_lightning_guy();

	ai.disableIdleStrafing = 1;
	
	wait( 0.1 );
	
	player = get_players()[0];
	ai GetPerfectInfo( player );

	light = GetEnt( "wall_shadow", "targetname" );

	for ( i=0; i<5; i++ )
	{
		light SetLightIntensity(15.0);
		wait( RandomFloatRange( 0.05, 0.2 ) );

		light SetLightIntensity(0.0);
		wait( RandomFloatRange( 0.05, 0.1 ) );
	}

	// Remove guy if you just ran past him
	trigger_wait( "trig_e2_rooftop" );
	if ( IsAlive( ai ) )
	{
		ai Delete();
	}

	level notify( "stop_lightning_color" );
}


color_lightning_guy()
{
	level endon( "stop_lightning_color" );

	waittill_ai_group_cleared( "ai_e2_lightning" );

	color_lightning_guy = GetEnt( "color_lightning_guy", "targetname" );
	if( IsDefined( color_lightning_guy ) )
	{
		trigger_use( "color_lightning_guy" );
	}
}

//
//	Spawns the airplane to come and fly overhead
airplane_flyby()
{

	//look at trigger
	trigger_wait( "spawn_rooftop_crows" );

	level notify( "airplane_crows_start" );

	trigger_wait( "trig_e2_airplane" );

	flag_set( "start_fall_death_check" );

	//TUEY Set music state to LIGHT_ACTION
	setmusicstate ("LIGHT_ACTION");

	// Save at the start
	autosave_by_name( "trig_e2_rooftop" );
	wait(0.05);

	level thread maps\kowloon_util::spawn_airplane( "ss_747", "evt_jet_flyover" );
}


//
//
rooftop()
{
	// Spawn near rooftop
	trigger_wait( "trig_e2_rooftop" );

	level thread clean_up_gas_room();

	level thread rooftop_exploder();
	
	// Clarke heads for the jump
	guys = simple_spawn( "ai_e2_rooftop" );
	level.heroes[ "clarke" ] thread mattress_jump_clark();

	// Near edge
	trigger_wait( "trig_e2_rooftop_far" );

	level notify("objective_pos_update" );	// Head to cache room
	level.heroes["weaver"]	thread mattress_jump_weaver();
	guys = simple_spawn( "ai_e2_rooftop_far", maps\kowloon_util::force_goal_self );
	array_thread( guys, ::turn_off_jump_aim_assist );

	// Player jumps
	trigger_wait("trig_e2_big_jump");
	
	level thread weaver_teleport_rooftop();

	flag_set( "disable_rooftop_aim_assist" );

	level thread maps\kowloon_util::sprint_jump_custom_death_message();

	player = get_players()[0];
	player magic_bullet_shield();	// Let the player survive the jump!  Turned off in cache_run::player_lands

	playsoundatposition ("evt_time_slow_start", (0,0,0));

	level thread rooftop_timescale();

	level waittill_either( "event3", "falling_death" );
}

turn_off_jump_aim_assist()
{
	self endon( "death" );

	flag_wait( "disable_rooftop_aim_assist" );

	self DisableAimAssist();
}

rooftop_timescale()
{
	//TUEY set the music to SUPER JUMP
	setmusicstate("SUPER_JUMP");

	ClientNotify ("smsj");
	wait(0.25);

	// slow down
	time = 0.15;
	old_fov = GetDvarFloat( #"cg_fov" );
	level timescale_tween( 0.1, 0.15, time );	
	wait(0.25);

	playsoundatposition ("evt_time_slow_stop", (0,0,0));
	ClientNotify ("smsjo");

	// come back to normal
	time = 0.05;
	level timescale_tween( 0.15, 1.0, time );
}

clean_up_gas_room()
{

	//shabs - deleting gas and gas death trigs
	trigger_wait( "trig_clean_up_gas" );
	
	smoke_monster = GetEnt( "smoke_monster", "targetname" );
	smoke_monster Delete();

}


rooftop_exploder()
{
	level endon( "event3" );

	trig = GetEnt( "trig_e2_roof_exploder", "targetname" );
	player = get_players()[0];
	while ( 1 )
	{
		trig waittill( "trigger", ent );
		if ( ent == player )
		{
			trig RadiusDamage( trig.origin, 300, 1000, 1000, player );
			physicsExplosionCylinder( trig.origin, 300, 100, 1 );
			return;
		}
	}
}

//
//	jump across
mattress_jump_clark()
{
	anim_struct = GetStruct( "anim_align_first_jump", "targetname" );
		
	anim_struct anim_reach_aligned( self, "kowloon_mattress_jump" );
	anim_struct anim_single_aligned( self, "kowloon_mattress_jump" );
	
	level thread e2_roof_clark_jump_dialog();
	self thread maps\kowloon_anim::init_heroes_fridge_move();
}


//
//	jump across
mattress_jump_weaver()
{
	flag_init("weaver_jump_hack");
	
	anim_struct = GetStruct( "anim_align_first_jump", "targetname" );
	
	anim_struct thread weaver_jump_hack();
	
	anim_struct anim_reach_aligned( self, "kowloon_mattress_jump" );
	
	flag_set("weaver_jump_hack");
}


weaver_jump_hack()
{
	flag_wait("weaver_jump_hack");
	
	self anim_single_aligned( level.heroes["weaver"], "kowloon_mattress_jump" );
	
	level thread e2_roof_weaver_jump_dialog();
	level.heroes["weaver"] thread maps\kowloon_anim::init_heroes_fridge_move();
}


//ensure that Weaver gets to the rooftop jump
weaver_teleport_rooftop()
{
	wait(5.0);
	
	flag_set("weaver_jump_hack");
}


//
//	Awning tears when someone jumps through
awning_ripped()
{
	trigger_wait("rip_awning");

	ripped_awning = GetEnt("fxanim_kowloon_awning01_mod", "targetname");
	ripped_awning show();
	non_ripped_awning = GetEnt("anim_glo_awning04", "targetname");
	non_ripped_awning delete();
	exploder(3101);
	level notify("awning_tear_start");

}

flashback_audiO() //setting new fog settings
{
	trigger_wait("player_rip_awning");

	flag_set( "player_jumped" );

	//setting new fog settings
	start_dist		= 171.651;
	half_dist 		= 359.066;
	half_height 	= 4048.05;
	base_height 	= 3001.12;
	fog_r 			= 0.0666667;
  	fog_g 			= 0.101961;
	fog_b 			= 0.113725;
	fog_scale 		= 3.14083;
	sun_col_r 		= 0.109804;
	sun_col_g 		= 0.243137;
	sun_col_b 		= 0.286275;
	sun_dir_x 		= 0.163263;
	sun_dir_y 		= -0.944148;
	sun_dir_z 		= 0.286235;
	sun_start_ang 	= 0;
	sun_stop_ang 	= 99.2932;
	time 			= 5;
	max_fog_opacity = 0.857762;
	
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale, sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, sun_stop_ang, time, max_fog_opacity);

	player = get_players()[0];
	player.animname = "player";

	player anim_single(player, "oomph");
	
	//flag_wait("flashback_audio");

	//flashback audio
	//interrogator_ent = Spawn("script_origin", player.origin);
	//interrogator_ent LinkTo(player );
	//interrogator_ent.animname = "interrogator";

	//interrogator_ent anim_single(interrogator_ent, "flashback_1");
	//player thread anim_single(player, "flashback_2");
	
	//wait(4.0);
	
	//flag_set("flashback_done");
}


//
//
//
event_2_dialog()
{
	wait(0.1);

	flag_wait( "gas_released" );
	level notify("kill_old_dialog");
	level thread e2_lab_dialog();

	trigger_wait("escape_dialog");
	level notify( "kill_force_move_weaver" );
	level.heroes["weaver"] disable_cqbwalk();
	level notify("kill_old_dialog");
	level notify("objective_pos_update" );	// Head to stairs
	level thread e2_escape_gas_dialog();

	trigger_wait("trig_e2_civ_chase");
	level notify("kill_old_dialog");
	level thread e2_hallway_2_roof();

	trigger_wait("trig_e2_stair_guys");
	level notify("kill_old_dialog");
	level thread e2_up_stairs();

	trigger_wait("trig_e2_airplane");
	level notify("kill_old_dialog");
	level thread e2_roof_top();

	trigger_wait("trig_e2_big_jump");
	level notify("kill_old_dialog");
	level thread e2_player_jump();
}


//
//
e2_lab_dialog()
{
	level endon("kill_old_dialog");
	
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "shoot_canister");
	
	wait(0.1);
	
	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "escape_route");
	
	wait(0.1);
	
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "hatch_in_the_ceiling");
	
	wait(0.1);
	
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "this_way_here");
	
	wait( 3.0 );
	
	lines[0] = "quickly_move";
	lines[1] = "follow_clarke_2";
	lines[2] = "this_way_here";
	level.heroes[ "clarke" ] thread maps\kowloon_util::nag_dialog( level.heroes[ "clarke" ], lines, 4.0 );
}


//
//
e2_escape_gas_dialog()
{
	level endon("kill_old_dialog");
	
	wait(2.0);

	player = get_players()[0];
	player.animname = "player";
	
	level.heroes[ "clarke" ] anim_single(level.heroes[ "clarke" ], "inhale_gas");
		
	wait(0.5);
	
	if ( !flag( "e2_player_inhaled" ) )
	{
		player anim_single(player, "we_good");
	}
	else
	{
		// No comment!
		wait( 1.0 );
	}
	
	wait(0.1);
	
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "you_lucky");
	
	wait(0.1);
	
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "direct_exposure");

	flag_set( "e2_gas_escape_dialog_done" );
}


//
//
e2_hallway_2_roof()
{

	level endon("kill_old_dialog");

	wait( 1.0 );
	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "spetsnaz_inbound");
	wait(0.1);
// 	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "west_hallway");
// 	wait(0.1);
}

e2_up_stairs()
{

	level endon("kill_old_dialog");

	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "which_way");
	wait(0.1);
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "up_stairs");
	wait(0.1);
	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "get_to_roof");
	trigger_wait("trig_e2_lightning");

	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "right_window");
}

e2_roof_top()
{
	level endon("kill_old_dialog");

	player = get_players()[0];
	player.animname = "player";
	
	level.heroes[ "clarke" ] thread anim_single( level.heroes[ "clarke" ], "on_roof");
	
	wait(3);

	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "snipers");
	level.heroes[ "clarke" ]  anim_single( level.heroes[ "clarke" ], "opposite_tower");

	wait(2);
	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "How");
	level.heroes[ "clarke" ]  anim_single( level.heroes[ "clarke" ], "we_jump");

	trigger_wait("trig_e2_rooftop_far");

	player anim_single(player, "kidding_me");
}

e2_roof_clark_jump_dialog()
{
	level endon("event3");

	if( flag("event3") )
		return;

	level.heroes[ "clarke" ] anim_single( level.heroes[ "clarke" ], "jump!!!");

}

e2_roof_weaver_jump_dialog()
{
	level endon("event3");

	if( flag("event3") )
		return;

	level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "lets_go_hudson");
	
	count = 1;

	while(1)
	{
		wait(20);
		
		if(count > 0)
			level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "what_are_waiting_for");
		else
			level.heroes[ "weaver" ] anim_single( level.heroes[ "weaver" ], "come_on_hudson_jump");

		count = count * -1;
	}

}


start_spetz_audio_lab()
{

	self endon("death");
	self.animname = "spz";

	self anim_single(self, "take_the_shot");
	self anim_single(self, "back_on_left");
	self anim_single(self, "go_go_go");
	self anim_single(self, "move_up");
	self anim_single(self, "moving_up");
	self anim_single(self, "cant_get_a_shot");
	self anim_single(self, "fucking_rain");
	self anim_single(self, "keep_them_pinned");
	self anim_single(self, "they_are_moving_out");

}

//	E2 Spetznaz tells civs to get out of the way
spez_civ_move_dialog()
{

	self endon("death");
	self.animname = "spz";

	line[0] = "move_out_of_way";
	line[1] = "move";

	self anim_single(self, line[ RandomInt( line.size ) ]);
}

//
spetz_stair_dialog()
{

	self endon("death");
	self.animname = "spz";

	self anim_single(self, "stay_back");
	self anim_single(self, "Get_back_inside");

}


e2_player_jump()
{
//	player = get_players()[0];
//	player.animname = "player";

//	player thread anim_single(player, "son_bitch");

//	player thread anim_single(player, "flashback_1");
//	player thread anim_single(player, "flashback_2");

}


//	Give players a chance to run through the gunfire and sprint-jump
//
reduce_ai_accuracy_before_the_jump()
{
	level endon("event3");
	//level endon( "accuracy_timeout" );	
 
	touch_trigger = GetEnt("accuracy_reduction_trigger", "targetname");

	player = get_players()[0];
	
	trigger_wait("accuracy_reduction_trigger");
	
	ai = getaiarray( "axis");
	
	for(i = 0; i < ai.size; i ++)
	{
		if(!IsDefined( ai[i] ) )
			continue;
				
		ai[i].script_accuracy = 0;
	}
	
	wait(5.0);

	while(1)
	{
		ai = getaiarray( "axis");

		if(player istouching(touch_trigger) && player IsSprinting(true))
		{
			if( !IsDefined( ai) )
				return;

			for(i = 0; i < ai.size; i ++)
			{
				if(!IsDefined( ai[i] ) )
					continue;
				
				ai[i].script_accuracy = 0;
			}
		}
		
		else
		{
			for(i = 0; i < ai.size; i ++)
			{
				if(!IsDefined( ai[i] ) )
					continue;

				ai[i].script_accuracy = 0.6;
			}
		}
		
		wait(0.1);
	}	
}


accuracy_timeout()
{

	touch_trigger = GetEnt("accuracy_reduction_trigger", "targetname");
	touch_trigger waittill( "trigger" );
	
	wait( 5 );

	level notify( "accuracy_timeout" );	

	wait( 1 );
	
	ai = GetAIArray( "axis");

	for(i = 0; i < ai.size; i ++)
	{
		if( IsDefined( ai[i] ) && IsAlive( ai[i] ) )
		{
			ai[i].script_accuracy = 1;
		}
	}

}

// SOUND - AI civilian ambient chatter
//self = civilian ai
play_civilian_yells()
{
	self endon( "death" );
	self endon( "goal" );
	
	//so they dont show up as friendlies
	self.team = "neutral";
	self.name = "";

	while(1)
	{
		rand = randomintrange( 0, 100 );
	
		if( rand > 87 )
		{
			self playsound( "amb_civilian_yell" );
		}
 		wait(randomfloatrange( 0.2, 0.5 ) );
	}
}
