// river_plane: script for plane crash section
// to access prefab for this section, open river.map -> enter "river_script_prefab" -> "river_script_plane_section"
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;

/*==========================================================================
FUNCTION: main
SELF: level (not used)
PURPOSE: set up beat progression and skiptos in an easily modifiable way

ADDITIONS NEEDED:
==========================================================================*/
main( beat_name )
{
	level thread setup_event_wide_functions();
	
//	// array of function pointers that should be run in sequential order
//	beats = [];
//	beats[ "investigate_plane" ] 			= ::investigate_plane;
//	beats[ "VC_counterattack" ] 			= ::VC_counterattack; 
//	beats[ "nose_knockdown" ] 				= ::nose_knockdown;
//	beats[ "last_stand"] 					= ::last_stand;
//	//beats[ "last_stand"] 						= ::plane_capture;
//
//
//	keys = maps\river_util::get_array_keys_in_order( beats );
//
//	beat_num = 0;
//
//	if( IsDefined( beat_name ) )
//	{
//		for( i = 0; i < beats.size; i++ )
//		{
//			if( keys[ i ] == beat_name )
//			{
//				beat_num = i;
//				break;
//			}
//		}
//	}
//	
//	for( i = beat_num; i < beats.size; i++ )
//	{
//		current_beat = [[ beats[ keys[ i ] ] ]]();
//		
//		if( i == beats.size )
//		{
//			break;
//		}
//		
//		autosave_by_name( "river_autosave" );
//	}
	
	//debug test -comment out
//	wait 5;
	//level thread plane_hind();

	maps\_patrol::patrol_init();
	
	flag_init( "plane_attack" );
	flag_init( "plane_captured" );
	flag_init("start_crate_anim");
	
	level thread jumper_kill_trigger_think();
	level thread plane_begin();
	level thread plane_search();
	level thread plane_attack();
	level thread plane_fall();
	level thread plane_capture();
	level thread plane_objectives();
	level thread plane_escape_failsafe();

	//comment out before every checkin
	//level thread debug_test();
	

	//so mission doesn't end prematurely
	flag_wait("plane_captured" );
	
}

debug_test()
{
	
//	//warp player to groundpos
//	org_pos = GetEnt( "plane_fall_pos", "targetname" );
//	player = get_players()[0];
//	player SetOrigin( org_pos.origin );
//	player SetPlayerAngles( org_pos.angles );
//	player PlayerLinkToDelta (org_pos, undefined, 0, 45, 45, 45 );
//	
//
//	//to test end
//	level notify( "player_fallen" );

	//to test cockpit battle
	//level notify("start_plane_vc" );
	
	//test hind entrance
	wait 10;
	level thread plane_hind();
	
	//IPrintLnBold( "using debug comment out" );
}

plane_escape_failsafe()
{
	clip = GetEnt( "run_out_of_plane_clip", "targetname" );
	if( !IsDefined( clip ) )
	{
		PrintLn( "clip missing for plane_escape_failsafe!" );
		return;
	}
	
	offset = -500;
	
	clip MoveZ( offset, 1 );  // move clip now just in case trigger check fails
	
	nose_trigger = GetEnt( "plane_nose_trig", "targetname" );
	
	if( !IsDefined( nose_trigger ) )
	{
		PrintLn( "nose_trigger missing! can't run plane_escape_failsafe" );
		return;
	}
	
	nose_trigger waittill( "trigger" );
	
	while( level.player IsTouching( nose_trigger ) )
	{
		wait( 1 );
	}
	
	level notify( "plane_blocker_02_start" );  // play fx anim for blocker
	clip MoveZ( offset * ( -1 ), 0.5 );  // put clip into place
}

setup_event_wide_functions()
{
	// spawn functions, global variables, etc
	
	plane_vc = GetEntArray( "plane_vc", "script_noteworthy" );
	array_thread( plane_vc, ::add_spawn_function, ::plane_nva_guys_monitor );
	
	plane_vc_rpg = GetEntArray( "plane_vc_rpg", "targetname" );
	array_thread( plane_vc_rpg, ::add_spawn_function, ::plane_nva_guys_monitor_rpg );  // same for now until we determine behavior
	
	add_spawn_function_veh( "west_shore_sampan_1", maps\river_util::vehicle_setup );
	add_spawn_function_veh( "west_shore_sampan_2", maps\river_util::vehicle_setup );
//	add_spawn_function_veh( "west_shore_sampan_1", maps\river_fx::sampan_spotlight );
//	add_spawn_function_veh( "west_shore_sampan_2", maps\river_fx::sampan_spotlight );

	add_spawn_function_veh( "knockdown_hind_1", maps\river_util::ent_name_visible );
	add_spawn_function_veh( "knockdown_hind_2", maps\river_util::ent_name_visible );
}

investigate_plane()
{
	//maps\river_drive::fade_out_for_user_test();  // fade out in ship build for now
	
	// CLEAN UP TREES: (SCRIPT_INT 4)
	maps\river_features::cleanup_destructable_trees( 4 );

	
	trigger = GetEnt( "player_inside_plane_trigger", "targetname" );
	trigger waittill( "trigger" );
	
	//IPrintLnBold( "player investigates plane crash - vignette" );
}


VC_counterattack()
{
	wait( 10 );
	
	//IPrintLnBold( "counterattack" );
}


nose_knockdown()
{
	wait( 10 );
	//IPrintLnBold( "plane nose is knocked down!" );
}

last_stand()
{
	wait( 10 );
	//IPrintLnBold( "last stand" );
}


//*****************************************************************************
//*****************************************************************************

plane_begin()
{
	//hinds take off
	//use rope tech to crates?
	
	//set color
	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[ i ] clear_force_color();
		level.friendly_squad[ i ] set_force_color( "p" );
		level.friendly_squad[ i ] enable_ai_color();
		//level.friendly_squad[i] enable_cqbwalk();
	}
	
	trigger_use( "plane_begin" );
	
	level.reznov thread aim_at_closest_cqb_target();
	
	//TUEY set music state to INVESTIGATE PLANE
	setmusicstate ("INVESTIGATE_PLANE");

	// ALL THE REMAININT SPETZNAZ ARE DEAD
	level thread wing_climb_dialogue();
	
	battlechatter_off();
}


wing_climb_dialogue()
{
	flag_wait( "player_at_wing" );	
	
	level.woods maps\river_vo::playVO_proper( "well_have_to_climb", 1.6 );	// 1.6
	level.mason maps\river_vo::playVO_proper( "ill_go_first", 1.0 );			// 1.8	
		
}

//*****************************************************************************
//*****************************************************************************

plane_search()
{
	level thread plane_search_wing();
	level thread plane_search_warp();
	level thread plane_crate_anim();
}

aim_at_closest_cqb_target()  // self = AI
{
	points = getstructarray( "cqb_point_of_interest", "targetname" );
	if( points.size == 0 )
	{
		PrintLn( self.targetname + " can't find any CQB targets" );
		return;
	}
	
	dist = 99999;  // some arbitrarily high distance
	
	point = points[ 0 ];
	
	for( i = 0; i < points.size; i++ )  // find closest struct
	{
		current_dist = DistanceSquared( points[ i ].origin, self.origin );
		
		if( current_dist < dist )
		{
			dist = current_dist;
			point = points[ i ];
		}
	}
	
	self.cqb_target = point;
	
	// force aim - don't rely on CQB. 
	origin = Spawn( "script_origin", point.origin );
	
	self aim_at_target( origin );
	
	while( IsDefined( self.cqb_target ) )  // aim at this until cqb target is cleared (use cqb_aim without argument)
	{
		wait( 1 );
	}
	
	origin Delete();
}


//*****************************************************************************
//*****************************************************************************

plane_search_wing()
{
	wing_dmg = GetEntArray( "prop_section_dmg", "targetname");
	for( i = 0; i < wing_dmg.size; i++ )
	{
		wing_dmg[i] Hide();
	}
	
	trigger_wait( "plane_wing_trig" );
	
	//explosion
	org = GetEnt( "plane_wing_explosion", "targetname" );
	PlayFX(level._effect["vehicle_explosion"], org.origin);
	org playsound("evt_wing_explo");

	//swap to dmg
	wing = GetEntArray( "prop_section", "targetname");
	for( i = 0; i < wing.size; i++ )
	{
		wing[i] Delete();
	}

	for( i = 0; i < wing_dmg.size; i++ )
	{
		wing_dmg[i] Show();
	}
	
	//Earthquake	
	players = get_players();
	Earthquake( 0.8, 4, players[0].origin, 500 );
	//players[0] ShellShock( "explosion", 2 );
	players[0] SetStance("crouch");
	
	//push player
	players[0] thread plane_push();
			
	for( i = 0; i< 8; i++ )
	{
		players[0] PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.1 );
	}

	//propeller
	propeller = GetEnt( "plane_prop", "targetname");
	propeller MoveZ( -500, 2 );

	level.reznov cqb_aim();
	level.reznov thread goal_then_cqb_aim();

	// VO: MASON - Seems to make sense
	level.woods anim_single( level.woods, "mason" );
}

goal_then_cqb_aim( goal_name, pos )
{
	self endon( "stop_cqb_aim" );
	
	if( IsDefined( goal_name ) )
	{
		goal = GetNode( goal_name, "targetname" );
		self SetGoalNode( goal );
	}
	
	self waittill( "goal" );
	
	if( !IsDefined( pos ) )
	{
		aim_at_closest_cqb_target();
	}
	else 
	{
		origin = Spawn( "script_origin", pos );
		
		self.cqb_target = origin;
		
		self thread aim_at_target( origin );
		
		while( IsDefined( self.cqb_target ) )
		{
			wait( 1 );
		}
		
		origin Delete();
	}
}

//*****************************************************************************
//*****************************************************************************

plane_push()
{
	
	x = 0;
	while( x < 1.5 )
	{
		//push player
		vel = self GetVelocity();
		self  SetVelocity(vel + (30, 30, 0));
		wait( 0.05 );
		x = x + 0.05;
		
	}
	
}


//*****************************************************************************
// get guys into plane
//*****************************************************************************
plane_search_warp()
{
	trigger_wait( "plane_trig" );
	
	// VO as Mason gets on the wing
	level.bowman thread maps\river_vo::playVO_proper( "take_it_easy_mason", 0.1 );
	level.woods thread maps\river_vo::playVO_proper( "ill_stabilize_at_this_end", 1.3 );	// 1.2
	
	//slow player
	lerp_player_speed(1.0, 1.0, 0.6);

	//slow squad
	for( i=0; i<level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i] enable_cqbwalk();
	}
	
	players = get_players();
	Earthquake( 0.4, 2, players[0].origin, 500 );
	
	playsoundatposition ("evt_plane_shake_00", (0,0,0));
		
	for( i=0; i< 5; i++ )
	{
		players[0] PlayRumbleOnEntity( "damage_light" );
		wait( 0.1 );
	}

	trigger_wait( "plane_shake" );

	// Plane shakes a 2nd time VO	
	level.woods thread maps\river_vo::playVO_proper( "easy_easy", 0.25 );
	
	playsoundatposition ("evt_plane_shake_01", (0,0,0));
	
	Earthquake( 0.4, 2, players[0].origin, 500 );
	for( i = 0; i< 5; i++ )
	{
		players[0] PlayRumbleOnEntity( "damage_light" );
		wait( 0.1 );
	}

	trigger_wait( "plane_obj_wing" );
	
	//return player speed
	lerp_player_speed(1.0, 0.6, 1.0);

	trigger_wait( "plane_int_trig" );

	// VISION SET: Plane Section
	level thread maps\createart\river_art::plane_section( 0 );
	
}

#using_animtree ("generic_human");
plane_crate_anim_think( anim_node, node_name )
{
	anim_node anim_reach_aligned( self, "crate_loop" );
	anim_node thread anim_loop_aligned( self, "crate_loop" );
	self notify( "in_position" );

	flag_wait("start_crate_anim");
	anim_node anim_single_aligned( self, "crate_anim" );

	if( IsDefined( node_name ) )
	{
		node = GetNode( node_name, "targetname" );
		if( IsDefined( node ) )
		{
			self enable_cqbwalk();
			self SetGoalNode( node );
			return;
		}
	}
	
	//so guys don't walk back to old goal
	pos = self.origin;
	self SetGoalPos( pos );
		
}

plane_crate_anim()
{

	gun = GetEnt( "crate_china_lake", "targetname" );
	org = Spawn( "script_origin", gun.origin );
	gun LinkTo( org );
	org MoveZ( -500, 0.1 );
	
	structs = getstructarray( "plane_nova6", "targetname" );
	bodies = [];
	
	pilot = false;
	
	for( i = 0; i < structs.size; i++ )
	{
		if( i < 2 )
		{
			pilot = true;
		}
		else 
		{
			pilot = false;
		}
		
	  	bodies[i] =	create_nova_body( structs[i], pilot );
		bodies[i] StartRagdoll();
	}
	
	//setup anim
	
	anim_node = getstruct( "c130_anim_node", "targetname" );

	map_model = GetEnt( "crate_map", "targetname" );
	if( IsDefined( map_model ) )
	{
		map_model init_anim_model( "map", true );
		anim_node thread anim_loop_aligned( map_model, "map_loop");
	}
	
	nova_org = GetEnt( "dead_guy_model", "targetname" );
	dead_guy = create_nova_body( nova_org );
	dead_guy.animname = "generic";
	dead_guy UseAnimTree( #animtree );
	anim_node thread anim_loop_aligned( dead_guy, "crate_loop");
	
	level thread plane_crate_anim_obj();
	
	//player enters plane	
	trigger_wait( "plane_crate_trig" );
		
	//setup
	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i] disable_ai_color();
		level.friendly_squad[i].pacifist = true;
	}
	
	level.woods thread plane_crate_anim_think( anim_node, "woods_crate_end_node" );
	level.bowman thread plane_crate_anim_think( anim_node );
	
	//start crate anim when guys in spots
	waittill_multiple_ents( level.woods, "in_position", level.bowman, "in_position" );

	trigger_wait("start_crate_anim");
	flag_set("start_crate_anim");

	fuselage_vo_support();

	level.reznov thread goal_then_cqb_aim( "reznov_plane_guard_node", ( -12530, 31492, 1208 ) );  

	//crate anim, bowman and woods handled in think func
	anim_node thread anim_single_aligned( dead_guy, "crate_anim");
	
	if( IsDefined( map_model ) )
	{
		anim_node thread anim_single_aligned( map_model, "map_pickup" );
	}

	//spawn weapons
	level waittill( "spawn_china_lake" );

	// Delay needed so the china lake appears exactly as the box lid opens
	wait( 1.2 );
	
	org MoveZ( 500, 0.01 );
	org waittill( "movedone" );
	gun Unlink();
	org Delete();
	
	level waittill( "crate_anim_done" );
	
	//so dead guy doesn't pop up
	anim_node thread anim_loop_aligned( dead_guy, "crate_loop");
	
	
	//delete blocker collision	
	crate_blocker_col = GetEnt( "crate_blocker_col", "targetname" );
	crate_blocker_col ConnectPaths();
	crate_blocker_col Delete();
	
// legacy VO calls, replaced by animations
//	plane_crate_anim_vo();
	
	level notify("start_plane_vc" );

	cqb_aim_points = GetEntArray( "cqb_aim_origins_nose", "targetname" );
	if( cqb_aim_points.size > 0 )
	{
		for( i=0; i<level.friendly_squad.size; i++ )
		{
			level.friendly_squad[ i ] cqb_aim();
			level.friendly_squad[ i ] enable_cqbwalk();
			level.friendly_squad[ i ] aim_at_target( cqb_aim_points[ i ] );
		}
	}
		
	autosave_by_name( "river_plane_crate" );
	
	trigger_wait( "plane_nose_trig" );

	//cleanup ragdolls so available for battle
	for( i = 0; i < bodies.size; i++ )
	{
		bodies[i] Delete();
	}
}

fuselage_vo_support()
{
	// MASON VO: As we find the Chine Lake
	level.mason thread maps\river_vo::playVO_proper( "nova_6_must_have_dispersed", 8.0 );
	
	playsoundatposition( "evt_num_num_14_d" , (0,0,0) );
	
	// Difficult to time non anim dialogue VO
	rval = randomint( 100 );
	if( rval > 50 )
	{
		level.reznov thread maps\river_vo::playVO_proper( "kravchenko_he_must_die", 28.3 );
	}
	else
	{
		level.mason thread maps\river_vo::playVO_proper( "he_must_die", 28.3 );
	}
	
	level.woods thread maps\river_vo::playVO_proper( "look_down_there", 47 );
	level.woods thread maps\river_vo::playVO_proper( "bowman_sniper_rifle", 49.25 );
	
	level.mason thread maps\river_vo::playVO_proper( "you_got_it", 54.25 );
}



#using_animtree ("river");
//animated obj using diff animtree
plane_crate_anim_obj()
{
	anim_node = getstruct( "c130_anim_node", "targetname" );
			
	crate = GetEnt( "crate", "targetname" );
	crate init_anim_model( "crate", true );
	anim_node thread anim_loop_aligned( crate, "crate_loop");

	crate_lid = GetEnt( "crate_lid", "targetname" );
	crate_lid init_anim_model( "crate_lid", true );
	anim_node thread anim_loop_aligned( crate_lid, "crate_lid_loop");

	crate_blocker = GetEnt( "crate_blocker", "targetname" );
	crate_blocker.animname = "crate_blocker";
	crate_blocker UseAnimTree( #animtree );
	anim_node thread anim_loop_aligned( crate_blocker, "crate_blocker_loop");
	
	flag_wait("start_crate_anim");

	anim_node thread anim_single_aligned( crate_lid, "crate_lid_open");
	
	// MikeA: Not the best way to do it, but play the blocker dust fx after X amount of time of this animation
	level thread fuselage_blocker_fx();
	
	anim_node anim_single_aligned( crate_blocker, "crate_blocker_open");
	crate_blocker Delete();
	
	flag_set( "crate_anim_done" );
	
}

fuselage_blocker_fx()
{
	wait( 41.25 );
	exploder( 7 );
}

//plane_crate_anim_vo()
//{
//	level.bowman anim_single( level.bowman, "what_happened" );
//
//	level.woods anim_single( level.woods, "the_chemical_weapon" );
//	
//	level.woods anim_single( level.woods, "grenade_launchers_china_lakes" );
//	
//	level.bowman anim_single( level.bowman, "must_be_some_kind_of_setup" );
//	
//	level.bowman anim_single( level.bowman, "the_nova_6_is_all_gone" );
//	
//	player = get_players()[0];
//	player.animname = "mason";
//	
//	player anim_single( player, "he_must_die" );
//
//	level.bowman anim_single( level.bowman, "okay_mason_lets_go" );
//}




plane_attack()
{
	level waittill("start_plane_vc" );
	

	
	wait( 0.5 );	
	
	//move guys to front of plane
	delaythread( 1, ::move_squad_to_nose );

	//spawn vc
	plane_nva_guys = simple_spawn( "plane_nva_guy", ::plane_nva_guys_think);
	
	trigger_wait( "plane_nose_trig" );

	//level thread plane_attack_vo();
	//give bowman sniper rifle
	level.bowman gun_switchto( "dragunov_sp", "right" );

	//lookat trigger outside window
	trigger_wait( "attack_lookat_trig" );
	
	//TUEY set music to END BATTLE
	setmusicstate ("END_BATTLE");
	
	delaythread( 2, maps\river::turn_off_current_3d_objective );

	level thread plane_player_shoot();
	
	level waittill_notify_or_timeout( "player_shoot", 15 );	//change to flag

	for( i = 0; i < level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i].pacifist = false;
		level.friendly_squad[ i ] stop_aim_at_target();
	}
	
	
	//wake up enemies below
	wait 1;
	
	
	
	vo_struct = getstruct( "vc_attack_vo_struct", "targetname" );
	if( IsDefined( vo_struct ) )
	{
		PlaySoundatposition( "vc_ambusher_2", vo_struct.origin );
	}
	
	flag_set("plane_attack" );

	battlechatter_on();

	wait 5;
		
	//shoot flare
	level thread plane_flare();
	
	//reinforcements
	trigger_use("sm_plane_vc");
	trigger_use("sm_plane_vc_rpg");

	//spawn sampans
	level thread plane_attack_sampan();
	waittill_ai_group_count( "plane_vc", 12 );		
	level notify( "sampans_arrive" );
	
	//failsafe
	level thread plane_attack_failsafe();
	waittill_ai_group_count( "plane_vc", 2 );
	
	level notify( "plane_hinds" ); 

	enemies = GetAIArray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i].ignoreall = true;
	}

	level waittill( "knockdown_rockets_fired" );
	battlechatter_off();  // so woods doesn't call out targets while he's unconscious...

	level thread spawn_manager_disable( "sm_plane_vc");
	level thread spawn_manager_disable( "sm_plane_vc_rpg" );

//	enemies = GetAIArray( "axis" );
//	for( i = 0; i < enemies.size; i++ )
//	{
//		enemies[ i ] maps\river_util::kill_me();
//	}			
			
	//cleanup
	flag_wait( "player_fallen" );
}

move_squad_to_nose()
{
	nose_pos = GetEntArray( "plane_nose_pos", "targetname" );
	nodes = GetNodeArray( "nose_node", "targetname" );
	
	for( i=0; i <nose_pos.size ; i++ )
	{
		//level.friendly_squad[i] forceTeleport( nose_pos[i].origin, nose_pos[i].angles );
		//level.friendly_squad[i] SetGoalNode( nose_pos[i] );
		level.friendly_squad[ i].goalradius = 12;
		level.friendly_squad[ i ] enable_heat();
		level.friendly_squad[i] SetGoalPos( nodes[i].origin );
		level.friendly_squad[i].pacifist = true;

	}	
}

jumper_kill_trigger_think()
{
	level endon( "knockdown_rockets_fired" );  // player will hit this during fall animation if thread is still running. this is bad.
	
	trigger = GetEnt( "jumper_death_trigger", "targetname" );
	if( !IsDefined( trigger ) )
	{
		//IPrintLnBold( "trigger for jumper_kill_trigger_think is missing!" );
		return;
	}
	
	trigger waittill( "trigger", who );
	
	if( IsPlayer( who ) )
	{
		player = getplayers()[0];
		//IPrintLnBold( "you die from jumping out of the plane." );
		player DoDamage( 1024, player.origin );  // 1024 is arbitrarily large. player has 100 hp.
	}
}


plane_flare( guy )
{
	level thread notify_delay( "plane_hinds", 38 );		// 37  send in Hinds
	
	flare = maps\_vehicle::spawn_vehicle_from_targetname( "invasion_flare" );
	flare thread go_path();

	//playsoundatposition ("evt_flare_launch", (-5712, -3776, -56));

	// play regualar trail
	model = spawn( "script_model", (0,0,0) );
	model SetModel( "tag_origin" );
	model LinkTo( flare, "tag_origin", (0,0,0), (0,0,0) );
	PlayFXOnTag( level._effect["flare_trail"], model, "tag_origin" );
	flare waittill( "flare_intro_node" );
	model delete();

	// swap to a burst
	model = spawn( "script_model", (0,0,0) );
	model SetModel( "tag_origin" );
	model LinkTo( flare, "tag_origin", (0,0,0), (0,0,0) );
	PlayFXOnTag( level._effect["flare_trail"], model, "tag_origin" );
	PlayFXOnTag( level._effect["flare_burst"], model, "tag_origin" );
	
	playsoundatposition ("evt_flare_burst", model.origin);
	flare waittill("flare_off");
	model delete();
}


//#using_animtree ("fakeShooters");
//plane_attack_drones()
//{
//	
//	level.drone_run_cycle_override[0] = %patrol_bored_patrolwalk;
//	//level.drone_run_cycle_override[1] = %patrol_bored_patrolwalk_twitch;
//
//	level.plane_drones = maps\river_features::get_drone_spawn_trigger( "plane_drones" );
//	level.plane_drones activate_trigger();
//	
//	level waittill( "player_shoot" );	//change to flag
//	
//	//change run cycle
//	level.drone_run_cycle_override = undefined;
//	
//	drones = GetEntArray("drone", "targetname");
//	for( i = 0; i < drones.size; i++ )
//	{
//		drones[i].droneRunRate = 100;
//		drones[i] thread maps\_drones::drone_set_run_cycle();
//		wait( RandomFloat(0.2) );
//	}
//}

plane_attack_vo()
{
	level.woods anim_single( level.woods, "look_down_there" );

	level.woods anim_single( level.woods, "bowman_sniper_rifle" );
	
}

plane_player_shoot()
{
//	while (!get_players()[0] AttackButtonPressed())
//	{
//		wait .1;
//	}
//	
//	level notify( "player_shoot" ); 

	gun = level.player waittill_player_shoots();
	
	if( IsDefined( gun ) && ( gun == "china_lake_sp" ) )
	{
		wait( 1 );
	}

	level notify( "player_shoot" );
}


plane_nva_guys_think()
{
	self endon( "death" );
	
	self.disableArrivals = true;
	self.disableExits = true;
	self.disableTurns = true;

	self.goalradius = 8;
	
	self.pacifist = true;
	self.ignoreall = true;
	//self.animname = "generic";
	//self set_generic_run_anim( "patrol_walk" );
	self.moveplaybackrate = RandomFloatRange( 0.7, 1.4 );
	self thread plane_nva_guys_monitor();
	
	flag_wait("plane_attack" );
	
	self clear_run_anim();
	self.pacifist = false;
	self.goalradius = 1024;
	self.disableArrivals = false;
	self.disableExits = false;
	self.disableTurns = false;


	wait( RandomFloatRange( 1,3 ) );
	
	//wait(2);
	
	self.ignoreall = false;

	//try stopping shooting or using aimattarget
	
}


//launches guys in the air
plane_nva_guys_monitor()
{
	self waittill( "damage", amount, attacker, direction, point, dmg_type );

	flag_set("plane_attack" );
	
	if( IsPlayer( attacker ) )
	{
		if( ( dmg_type == "MOD_GRENADE" ) || ( dmg_type == "MOD_GRENADE_SPLASH" ) )
		{
			self Launchragdoll( 0,0,128);
		}
	}
}

plane_nva_guys_monitor_rpg()
{
	if( self.weapon != "rpg_sp" )  // if RPG isn't main hand, switch to it instead of whatever else he's carrying
	{
		self gun_switchto( "rpg_sp", "right" );
		self waittill( "weapon_switched" );
	}	
	
	self.a.gun_switchto = false;   // .. then disable weapon switching
	self.a.rockets = 200; // arbitrarily high number. "infinite" rocket ammo basically
	
	self set_ignoreall( false );
	
	self thread plane_nva_guys_monitor();
}

//in case player leaves too many ai alive
plane_attack_failsafe()
{
	level endon( "plane_hinds" ); 
	
	waittill_ai_group_count( "plane_vc", 5 );

	wait 5;
	
	guys = get_ai_group_ai( "plane_vc" );
	
	while( guys.size > 2 )
	{
		i = RandomInt(guys.size );
		if( IsAlive( guys[i] ))
		{
			guys[i] DoDamage( guys[i].health + 50, guys[i].origin );
			
		}
		wait 5;
				
	}
}


plane_attack_sampan()
{
	level.sampan_kill_index = randomint( 2 );

	level waittill_notify_or_timeout( "sampans_arrive", 16 );  // waittill either AI count is appropriate OR 18 seconds, whichever is first
	
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 23 );
	
	sampan1 = GetEnt( "west_shore_sampan_1", "targetname" );
	sampan1 thread plane_attack_sampan_think();
	sampan1 thread maps\river_fx::sampan_spotlight();
		
	sampan2 = GetEnt( "west_shore_sampan_2", "targetname" );
	sampan2 thread plane_attack_sampan_think();
	sampan2 thread maps\river_fx::sampan_spotlight();

	//vo callout
	wait 2;
	//level.woods thread anim_single( level.woods, "two_more_sampans" );
	level.woods thread anim_single( level.woods, "incoming" );
}


plane_attack_sampan_think()
{
	self.health = 100;
	
	self waittill( "death" );
	
	PlayFX( level._effect[ "vehicle_explosion" ], self.origin );
	
	wait 1;

	if( level.sampan_kill_index == 0 )
	{
		level.bowman maps\river_vo::playVO_proper( "bulls_eye", 0 );
	}
	else
	{
		level.bowman maps\river_vo::playVO_proper( "yeah", 0 );
	}	
		
	level.sampan_kill_index++;
	if( level.sampan_kill_index >= 2 )
	{
		level.sampan_kill_index = 0;
	}
}










//***************
#using_animtree ("river");
plane_fall()
{
	nose = getent( "plane_nose", "targetname" );
//	nose Hide();  // now doing this in river_util at level start
	
	//temp comment out for debug
	level waittill( "plane_hinds" );
	
	level thread plane_hind();

	wait 2; //use node to notify for dialog
	
	//hinds come in and shoot
	level.woods thread anim_single( level.woods, "fuck_the_hinds_are_back" );
	
	player = get_players()[0];
	player EnableInvulnerability();
	
	level waittill( "knockdown_rockets_fired" );
	maps\_dds::dds_disable( "allies" );

	level.woods thread anim_single( level.woods, "look_out" );

	wait 1; //for rockets to hit
	
	//level.woods thread anim_single( level.woods, "fall_scream" );
	
	
	// Switch off the hud as the plane nose falls
	SetSavedDvar( "hud_drawhud", 0 );
	
	
	//audio snapshot to duck sounds during the plane slide event
	
	level clientNotify ("end");
	//TUEY set music to END BATTLE
	setmusicstate ("ENDING");
	
	
	
	level.reznov thread anim_single( level.reznov, "brace_yourself" );

	player PlaySound( "exp_screen_shake" );
	player PlayRumbleOnEntity( "damage_heavy" );
	player ShellShock( "explosion", 4 );
	
	//IPrintLnBold( "ANIM: Player falls to ground" );
	
	//pacify squad
	for( i=0; i<level.friendly_squad.size; i++ )
	{
		level.friendly_squad[i].pacifist = true;
		level.friendly_squad[i].ignoreall = true;
		level.friendly_squad[i].ignoreme = true;

	}
	level thread maps\river_amb::event_heart_beat("stressed");	
	//wait 2;
	

//	//warp player to groundpos
//	org_pos = GetEnt( "plane_fall_pos", "targetname" );
//	player SetOrigin( org_pos.origin );
//	player SetPlayerAngles( org_pos.angles );
//	player PlayerLinkToDelta (org_pos, undefined, 0, 45, 45, 45 );
		
	//setup player anim
	level.player_body = spawn_anim_model( "player_body" );
	level.player_body.angles = player GetPlayerAngles();
	level.player_body.origin = player.origin;
	player PlayerLinkToAbsolute(level.player_body,"tag_player");
	player HideViewModel();
	
	anim_node = getstruct( "c130_anim_node", "targetname" );

	//setup nose anim
	linker = Spawn( "script_model", nose.origin );
	linker.angles = nose.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "plane_nose";
	linker UseAnimTree( #animtree );
	nose linkto( linker, "origin_animate_jnt" );

	nose Show();
	
	//delete old nose
	cockpit = GetEntArray( "cockpit", "targetname" );
	for( i=0; i < cockpit.size; i++ )
	{
		cockpit[i] Delete();
	}
	
	
	//play nose fall anim - TODO: should make one call, name anim the same
	anim_node thread anim_single_aligned( linker, "plane_nose_fall" );
	anim_node anim_single_aligned( level.player_body, "player_nose_fall" );

	//blackout
	// NOTE: The fade top black is now done by a notetraclk "blackout" on the anim
	//custom_fade_screen_out( "black", .1 );
		
	// DepthofField changes for outro anim 
	player = get_players()[0];
	player SetDepthOfField( 0, 20, 100, 960, 6, 1.8 );

	//fade up
	flag_set( "player_fallen" );
	
	// Switch the hud back on
	SetSavedDvar( "hud_drawhud", 1 );
	
	wait 2;
	custom_fade_screen_in( 1 );
}


plane_fall_blackout( guy )
{
	//IPrintLnBold( "BLACKOUT SCREEN" );
	custom_fade_screen_out( "black", .25 );
	//maps\river_drive::fade_to_black( 1.5, 1.5, 1.5 );
}


plane_hind()
{
	//spawn hinds
	trigger_use( "plane_hind_trig" );
	
	wait 0.5;
	
	hinds = GetEntArray( "plane_hind", "script_noteworthy" );
	for( i=0; i<hinds.size; i++ )
	{
		hinds[i].takedamage = false;
		hinds[i] thread plane_hind_think();
		hinds[i] notify( "stop_turret_shoot" );
	}	
}



plane_hind_think()
{
	//place spotlight
	tag = "tag_turret_door";
	
	if( IsDefined( self GetTagOrigin( tag ) ) )
	{
		PlayFXOnTag( level._effect[ "Hind_spotlight" ], self, tag );
	}
	else
	{
		PrintLn( self.targetname + " couldn't play hind_spotlight effect since tag is missing" );
	}
	
	//move heli
	start_node = GetVehicleNode( self.target, "targetname" );
	
//	self drivepath( start_node );
//	self.drivepath = 1;

	wait 0.1;
	self StartPath();	//lock to spline
	self waittill( "reached_end_node" );

	//so heli doesn't stop
	org = Spawn( "script_origin", self.origin );
	org.angles = self.angles;
	self SetVehGoalPos( org.origin, 1);
	self SetTargetYaw( org.angles[1] );
	org Delete();
	
	wait( RandomFloatRange( 1,2 ) );
	forward = AnglesToForward(self.angles);
	//start_point = self GetTagOrigin(rocket_tag) + (60 * forward);
	//rocket = MagicBullet( rocket_weapon, start_point, self.hind_target.origin, self, self.hind_target );
	left_launcher = self GetTagOrigin("tag_rocket4");
	right_launcher = self GetTagOrigin("tag_rocket1");
	
	MagicBullet("hind_rockets_sp", right_launcher, level.woods.origin);
	
	MagicBullet("hind_rockets_sp", left_launcher, level.bowman.origin);

	flag_set( "knockdown_rockets_fired" );
	//level notify( "knockdown_rockets_fired" );
	

}



#using_animtree ("generic_human");
plane_capture()
{
	//hide capture models

	capture_dragovich = GetEnt( "capture_dragovich", "targetname" );
	capture_dragovich Hide();
	capture_kravchenko = GetEnt( "capture_kravchenko", "targetname" );
	capture_kravchenko Hide();
	
	flag_wait( "player_fallen" );
	
	playsoundatposition( "evt_num_num_15_r" , (0,0,0) );

	delaythread( 1, ::battlechatter_off, "axis" );


	enemies = GetAIArray( "axis" );
//	array_thread( enemies, maps\river_util::kill_me );	  // array thread may not complete in time to spawn guys
	for( i = 0; i < enemies.size; i++ )
	{
		//enemies[ i ] maps\river_util::kill_me();
		enemies[ i ] Delete();
	}
	
	hind_1 = GetEnt( "knockdown_hind_1", "targetname" );	
	hind_1 Delete();

	//setup player for capture
	player = get_players()[0];
	player allowprone( true );
	player SetStance( "prone" );
	player.ignoreme = true;
	player TakeAllWeapons();

	
	//spawn soldiers to shoot at - use spetznaz
	guys = simple_spawn( "capture_guy", ::capture_guy_think );
	
	//grab first guy to be in the anim
	for(i = 0; i<guys.size; i++ )
	{
		if( IsAlive( guys[i] ))
		{
			break;
		}
	}
	
	//setup player anim
//	player_body = spawn_anim_model( "player_body" );
//	//player SetClientDvar("cg_drawfriendlynames", 0);
//	player_body.angles = player GetPlayerAngles();
//	player_body.origin = player.origin;
//	player PlayerLinkToAbsolute(player_body,"tag_player");
	gun_model = Spawn( "script_model", level.player_body GetTagOrigin( "tag_weapon" ) );
	gun_model.angles = level.player_body GetTagAngles( "tag_weapon" );
	gun_model SetModel( "t5_weapon_1911_sp_world" );
	gun_model useweaponhidetags( "m1911_sp" );
	gun_model LinkTo( level.player_body,"tag_weapon");
	
	//level.player_body thread test_tags();

	player HideViewModel();

	guys[i].animname = "kicker";
	anim_node = getstruct( "end_capture_node", "targetname" );
	

	//player TakeAllWeapons();
	//level notify( "player_hit" );
	pickup_guys = simple_spawn( "pickup_guy" );

	wait 0.5;

	level thread plane_capture_shoot();
	
	//setup actors
	level.bowman.animname = "bowman";
	level.woods.animname = "woods";
	pickup_guys[0].animname = "guy1";
	pickup_guys[1].animname = "guy2";
	
	capture_dragovich Detach(capture_dragovich.headModel);
	capture_dragovich character\gfl\character_gfl_rpk16::main();
	capture_dragovich Show();
	capture_dragovich MakeFakeAI();
	capture_dragovich UseAnimTree( #animtree );
	capture_dragovich.animname = "dragovich";

	capture_kravchenko Detach(capture_kravchenko.headModel);
	capture_kravchenko character\gfl\character_gfl_nyto::main();
	capture_kravchenko Show();
	capture_kravchenko MakeFakeAI();
	capture_kravchenko UseAnimTree( #animtree );
	capture_kravchenko.animname = "kravchenko";


	//setup array of actors
	actors = array( level.bowman, pickup_guys[0], pickup_guys[1], capture_kravchenko, capture_dragovich );

	anim_node thread anim_single_aligned( level.player_body, "player_struggles" );
	anim_node thread anim_single_aligned( guys[i], "kick_gun" );
	anim_node thread anim_loop_aligned( level.woods, "pickup_loop" );

	level thread plane_capture_obj();

	//play the anim	
	
	level thread take_masons_weapons( 24.5 );
	
	anim_node anim_single_aligned(actors, "pickup_bowman");
	
	wait 1.5;
	//blackout
	custom_fade_screen_out( "black", .1 );
	
	//end level
	flag_set("plane_captured" );
}


take_masons_weapons( delay )
{
	wait( delay );
	level.player TakeAllWeapons();
}


test_tags()
{
	while( 1 )
	{
		Print3d( self GetTagOrigin( "tag_weapon" ), "WEAPON" );
		wait( 0.05 );
	}
}

#using_animtree ("river");
plane_capture_obj()
{
	
	anim_node = getstruct( "end_capture_node", "targetname" );

	plane_apple = GetEnt( "apple", "targetname" );
	plane_apple init_anim_model( "plane_apple", true );
	anim_node thread anim_single_aligned( plane_apple, "pickup_bowman");

	
}

capture_guy_think()
{
	self endon( "death" );
	
	player_pos = GetEnt("plane_fall_pos", "targetname" );
	
	self.goalradius = 64;
	self.ignoreall = true;
	self.pacifist = true;
	self enable_cqbwalk();
	
	//wait 2; //pause before walking towards player
	
	//self SetGoalPos( player_pos.origin + (0,0,32 ) );
	self waittill( "goal" );
	
	level notify( "player_reached" );
	
	//ai melee player
//	self.meleeAttackDist = 320;
//	self.ignoreall = false;
//	self.pacifist = false;

	//level waittill( "player_hit" );
	
	self.pacifist = true;
	self.ignoreall = true;


}

//fake shooting blanks
plane_capture_shoot()
{
	level endon( "gun_off" );
	
	player = get_players()[0];
	i = 0;

	level waittill( "gun_on" );
	
	while(1)
	{
		if( player AttackButtonPressed() )
		{
			level.player_body PlaySound ("wpn_colt45_dryfire_plr" );  //click sound
			//IPrintLn( "gun_click" );
			
			//after 1st press
			if( i == 0 )
			{
				player GiveWeapon("m1911_sp");
				player SwitchToWeapon("m1911_sp");
				player SetWeaponAmmoStock( "m1911_sp",0 );
				player SetWeaponAmmoClip ("m1911_sp", 0);
				i = 1;
			}
						
			while( player AttackButtonPressed() )
			{
				wait( 0.05 );
			}
		}
		wait( 0.05 );
	}
}


custom_fade_screen_out( shader, time )
{
	// define default values
	if( !isdefined( shader ) )
	{
		shader = "black";
	}

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( isdefined( level.fade_screen ) )
	{
		level.fade_screen Destroy();
	}

	level.fade_screen = NewHudElem(); 
	level.fade_screen.x = 0; 
	level.fade_screen.y = 0; 
	level.fade_screen.horzAlign = "fullscreen"; 
	level.fade_screen.vertAlign = "fullscreen"; 
	level.fade_screen.foreground = true;
	level.fade_screen SetShader( shader, 640, 480 );

	if( time == 0 )
	{
		level.fade_screen.alpha = 1; 
	}
	else
	{
		level.fade_screen.alpha = 0; 
		level.fade_screen FadeOverTime( time ); 
		level.fade_screen.alpha = 1; 
		wait( time );
	}
	level notify( "screen_fade_out_complete" );
}

custom_fade_screen_in( time )
{
	level notify( "screen_fade_in_begins" );

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( !isdefined( level.fade_screen ) )
	{
		// error: the screen was not faded in in the first place
		//        for now, simply do nothing.
		return;
	}

	if( time == 0 )
	{
		level.fade_screen.alpha = 0; 
	}
	else
	{
		level.fade_screen.alpha = 1; 
		level.fade_screen FadeOverTime( time ); 
		level.fade_screen.alpha = 0; 
	}
	
	wait( time );
	level notify( "screen_fade_in_complete" );
}

lerp_player_speed(time, current_speed, final_speed)
{
	player = get_players()[0];
	
	base_speed = current_speed;
	
	incs = int( time/.05 );
	
	inc_speed = (final_speed  -  base_speed) / incs;
	
	speed = base_speed;
	
	for (i=0; i<incs; i++)
	{
		speed += inc_speed;
		player SetMoveSpeedScale(speed);
		wait .05;
	}
}

plane_objectives()
{
	
	level.objective_number++;	
	
	//marker at plane wing
//	obj_mrkr = GetEnt( "plane_trig", "targetname" );
//	Objective_Add(level.objective_number, "current", &"RIVER_OBJ_PLANE_CRASH_SEARCH", obj_mrkr.origin);
//	objective_set3d( level.objective_number, true );
//	trigger_wait( "plane_trig" );
//	
//	//marker on wing
//	obj_mrkr = GetEnt( "plane_obj_wing", "targetname" );
//	Objective_Position (level.objective_number, obj_mrkr.origin );
//	objective_set3d( level.objective_number, true );
//	trigger_wait( "plane_obj_wing" );
//	
//	//marker at crate
//	obj_mrkr = GetEnt( "plane_int_trig", "targetname" );
//	Objective_Position (level.objective_number, obj_mrkr.origin );
//	objective_set3d( level.objective_number, true );
//	trigger_wait( "plane_crate_trig" );
//	objective_set3d( level.objective_number, false );
//
//	
//	//marker at nose section
//	level waittill("start_plane_vc" );

//	Objective_Position (level.objective_number, obj_mrkr.origin );
//	objective_set3d( level.objective_number, true );
//	

//	obj_mrkr = GetEnt( "nose_waypoint_5", "targetname" );
//	AssertEx( IsDefined( obj_mrkr ), "obj_mrkr is missing for plane nose objective" );
//
//	level thread maps\river::nav_points_objective( "nose_waypoint_1", &"RIVER_OBJ_PLANE_CRASH_SEARCH", 128, undefined, 0.25 );
//	wait( 0.1 );
//	nav_objective = level.objective_number;
//	level.objective_number++;

	level waittill( "player_at_crate" );  
	flag_clear( "show_directional_marker" );
	
//	level waittill( "crate_anim_done" );
//	Objective_State( nav_objective, "done" );

	nose_trigger = GetEnt( "plane_nose_trig", "targetname" );
	AssertEx( IsDefined( nose_trigger ), "nose_trigger is missing for plane_objectives" );
	nose_trigger waittill( "trigger" );
	
	
	
//	trigger_wait( "plane_nose_trig" );
	//plane_attack_vo();
//	Objective_Add( level.objective_number, "current", &"RIVER_OBJ_KILL_STREAM_GUYS" );
	
	
	level waittill("knockdown_rockets_fired" );
	objective_set3d( level.objective_number, false );

	
}

#using_animtree ("generic_human");
precache_nova_body()
{
	// bubly, nasty nova6 bodies
	character\c_rus_airplane_gassed_pilot::precache();
	character\c_rus_airplane_gassed_worker::precache();	
	
	// non-bubbly, mature-safe "nova6 bodies"
	precache_non_mature_nova_bodies();
	
	level.scr_animtree[ "nova_body" ] 	= #animtree;
	level.scr_animtree[ "nova_body_no_gas" ] = #animtree;

	level.scr_model[ "nova_body" ] = "c_rus_airplane_gassed_pilot_fb"; 	
	level.scr_model[ "nova_body_no_gas" ] = "c_rus_engineer1_body_blue";
}

create_nova_body( pos, pilot )
{
	if( is_mature() )
	{
		model = spawn_anim_model("nova_body");
		
		if( IsDefined( pilot ) && ( pilot == true ) )
		{
			model character\c_rus_airplane_gassed_pilot::main();
		}
		else
		{
			model character\c_rus_airplane_gassed_worker::main();
		}
	}
	else 
	{
		model = spawn_anim_model( "nova_body_no_gas" );
		
		model make_mature_safe_nova_body();
	}
	
	model.animname = "generic";
	model.origin = pos.origin;
	model.angles = pos.angles;
	
	model MakeFakeAI(); 
	
	return model;
		
}


precache_non_mature_nova_bodies()
{
	PreCacheModel( "c_rus_engineer1_body_blue" );
	PreCacheModel( "c_rus_engineer1_body_grey" );
	PreCacheModel( "c_rus_engineer1_body_orange" );
	PreCacheModel( "c_rus_engineer1_body_yellow" );


	PreCacheModel( "c_rus_engineer_head1" );
	PreCacheModel( "c_rus_engineer_head2" );
	PreCacheModel( "c_rus_engineer_head3" );
}

make_mature_safe_nova_body()
{
	// pick body 
	y = RandomInt( 4 );
	
	if( y == 0 )
	{
		body = "c_rus_engineer1_body_blue";
	}
	else if( y == 1 )
	{
		body = "c_rus_engineer1_body_grey";
	}
	else if( y == 2 )
	{
		body = "c_rus_engineer1_body_orange";
	}
	else 
	{
		body = "c_rus_engineer1_body_yellow";
	}		
	
	self setModel( body );
	
	// pick head
	x = RandomInt( 3 );
	
	if( x == 0 )
	{
		self.headModel = "c_rus_engineer_head1";
	}
	else if( x == 1 )
	{
		self.headModel = "c_rus_engineer_head2";
	}
	else 
	{
		self.headModel = "c_rus_engineer_head3";
	}
	
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";	
}



