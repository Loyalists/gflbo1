////////////////////////////////////////////////////////////////////////////////////////////
// FLASHPOINT LEVEL SCRIPTS
//
//
// Script for event 2 - this covers the following scenes from the design:
//		Slides 15-21
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

    
////////////////////////////////////////////////////////////////////////////////////////////
// EVENT2 FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////


attractChopperDialog()
{
	trigger_wait( "trigger_run_to_pipe", "targetname" );
	
	level.woods thread playVO_proper( "heli_inbound", 0.0 );	//Chopper's inbound - move it!
	
	Objective_Set3D( level.obj_num, false);
	level.obj_num++;
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_HIDE_AT_PIPE" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, ( -1878, -6644, 300.9 ) );
}


attractChopper()
{
	level endon( "PLAYER_SPOTTED" );
	//level endon( "PIPE_HELI_DANGER_OVER" );
	self thread attractChopperDialog();
	
	level.pipe_chopper_02 heli_toggle_rotor_fx(1);
	//Kevin starting heli sounds
	level.pipe_chopper_02 vehicle_toggle_sounds( 1 );
	
	//FLASHPOINT_OBJ_STEALTH
	set_event_objective( 0, "active" );
	
	trigger_wait( "trigger_run_to_pipe_chopper", "targetname" );
	pipe_chopper_start_node = GetVehicleNode( "pipe_chopper_start_node", "targetname" );
	
	//Spawn a 2nd helicopter to look menacing
	pipe_chopper_02_start_node = GetVehicleNode( "pipe_chopper_02_start", "targetname" );
	//level.pipe_chopper_02 = SpawnVehicle( "t5_veh_helo_mi8_woodland", "pipe_chopper_02", "heli_hip", pipe_chopper_02_start_node.origin, (0,0,0) );
	//maps\_vehicle::vehicle_init( pipe_chopper_02 );
	//level.pipe_chopper_02 thread go_path( pipe_chopper_02_start_node );

	//Swap out the node 2 ahead - makes it smoother if we are too close to the transitioning node
	current_node = GetVehicleNode( level.pipe_chopper.currentNode.target ,"targetname" );
	//current_node_2 = GetVehicleNode( current_node.target ,"targetname" );
	//current_node_3 = GetVehicleNode( current_node_2.target ,"targetname" );
	//level.pipe_chopper SetSwitchNode( current_node, pipe_chopper_start_node );
	level.pipe_chopper DrivePath( pipe_chopper_start_node );
	
	wait( 2.0 );
	
	level.pipe_chopper_02 thread go_path( pipe_chopper_02_start_node );
	
	//level.pipe_chopper_02 thread go_path( pipe_chopper_02_start_node );
}

player_is_wimp()
{	
	level endon( "PIPE_HELI_DANGER_OVER" );
	self endon( "death" );
	
	self waittill( "damage" );
	self Die();
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
		
		wait( 2.0 );
	}
}

heli_flight_path( player )
{
	level endon( "PIPE_HELI_SPOTTED_DANGER_OVER" );
	self endon( "death" );
	
	heli_tracker_triggers_array = getentarray( "heli_tracker_triggers_pipe", "targetname" );
	
	self thread heli_direction( player );
	
	//self SetSpeed( 20, 10, 10 );
	
	self.goalradius = 512;
	
	while( 1 )
	{
		//Which one is the player in!
		self SetSpeed( 20, 10, 10 );
	
		for( i=0; i<heli_tracker_triggers_array.size; i++ )
		{
			if( player isTouching ( heli_tracker_triggers_array[i] ) )
			{
				//Found it - move the helicopter to this point
				heli_pos_struct = getstructarray( heli_tracker_triggers_array[i].target );
				
				self SetVehGoalPos( heli_pos_struct[self.myindex].origin );
				self.current_index = i;
				self waittill( "goal" );
				
				self SetSpeed( 0, 10, 10 );
				
				//self ClearVehGoalPos();
				
				break;
			}
		}
		wait( 6.0 );
	}
}
/*
attack_player_when_close( chopper )
{
	level endon( "PIPE_HELI_DANGER_OVER" );
	self endon ( "death" );
	chopper endon( "delete" );

	while( 1 )
	{
		//Are we close to the player
		//cansee = SightTracePassed( chopper.origin, level.player.origin, false, undefined );
		
		if (distance( chopper.origin, level.player.origin) < 1024.0 )
		{
			//Oh dear - attack the player
			playVO( "CLOSE", "Woods" );
			
			cansee = SightTracePassed( chopper.origin, level.player.origin, false, undefined );
			if( cansee )
			{
				playVO( "CANSEE", "Woods" );
			}
		}
		
		wait( 0.05 );
	}
}
*/
attack_player( chopper )
{
	//kdrew - if the chopper has been removed prior to calling this
	if(!IsDefined(chopper))
	{
		return;
	}

	level endon( "PIPE_HELI_DANGER_OVER" );
	self endon ( "death" );
	chopper endon( "delete" );
	
	chopper heli_toggle_rotor_fx(1);
	chopper vehicle_toggle_sounds( 1 );

	
	level.woods.ignoreall = false;
	level.player thread player_is_wimp();
	chopper thread heli_flight_path( level.player );
	//level.player thread attack_player_when_close( chopper );
		
	//Dump guards will attack as well
	if( isdefined( level.dumpguard1 ) )
	{
		level.dumpguard1.ignoreall = false;
		level.dumpguard1 setgoalpos( level.player.origin );
	}
	if( isdefined( level.dumpguard2 ) )
	{
		level.dumpguard2.ignoreall = false;
		level.dumpguard2 setgoalpos( level.player.origin );
	}
	
	wait( 1.0 );
	
	
	SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_PIPE_FAIL" ); 
	//missionFailedWrapper();


	
	level.woods StopAnimScripted();
	level.woods.ignoreall = false;
	
	//make sure both player and chopper both exist before firing
	while( IsDefined( self ) && IsDefined( chopper ) )
	{
		//Go to player	
	//	target = ( self.origin[0], self.origin[1], chopper.origin[2] );
	//	chopper.goalradius = 512;
	//	chopper SetVehGoalPos( target );
	
	//	chopper waittill( "goal" );
		//chopper waittill_notify_or_timeout( "goal", 2.0 );
		
		trace_fraction = self SightConeTrace(level.player.origin, level.player);

		if( trace_fraction > 0)
		{
			//kevin adding minigun sounds
			ent = spawn( "script_origin" , (0,0,0));
			chopper thread maps\flashpoint_e7::audio_ent_fakelink( ent );
			ent thread maps\flashpoint_e7::audio_ent_fakelink_delete();
			
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
			wait( 1.0 );// cool down
			
			//Fire
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

			wait( 2.0 );// cool down
		}
		else
		{
			wait( 0.1 );
		}
	}
}

vehicle_takes_damage()
{
	//level endon( "PLAYER_SPOTTED" );
	level endon( "PIPE_HELI_DANGER_OVER" );
	
	while( isdefined( self ) )
	{
		self waittill( "damage" );
		level.woods thread player_breaks_stealth_vo();
		level.player thread attack_player( level.pipe_chopper );
		level.player thread attack_player( level.pipe_chopper_02 );
		flag_set( "PLAYER_SPOTTED" );
		flag_set( "BREAKS_STEALTH" );
	}
}

kill_player_in_x_sec( sec_to_wait )
{
	wait( sec_to_wait );
	
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_KARAMBIT_BROKESTEALTH");		
}

player_breaks_stealth_heli()
{	
	level endon( "PLAYER_SPOTTED" );
	level endon( "PIPE_HELI_DANGER_OVER" );
	
	//while( isdefined( self ) )
	{
		self waittill_any( "weapon_fired", "grenade_fire" );
		level.woods thread player_breaks_stealth_vo();
		level.player thread attack_player( level.pipe_chopper );
		level.player thread attack_player( level.pipe_chopper_02 );
		level.player thread kill_player_in_x_sec( 4.0 );
		flag_set( "PLAYER_SPOTTED" );
		flag_set( "BREAKS_STEALTH" );
	}
}

checkForWonderingOff()
{
	level endon( "PIPE_HELI_DANGER_OVER" );
	level endon( "PLAYER_SPOTTED" );
	
	drop_down_border = getentarray( "drop_down_border", "targetname" ); 
	
	while( 1 )
	{
		for( i=0; i<drop_down_border.size; i++ )
		{
			trigger = drop_down_border[i];
			if( level.player istouching( trigger ) )
			{
// 				level.woods thread player_breaks_stealth_vo();
// 				level.player thread attack_player( level.pipe_chopper );
// 				level.player thread attack_player( level.pipe_chopper_02 );
// 				flag_set( "PLAYER_SPOTTED" );
// 				flag_set( "BREAKS_STEALTH" );
				
				//FAIL!
				maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_STAY_WITH_WOODS");		
				
				break;
			}
		}
		wait( 0.05 );
	}	
}

checkForBeingInsidePipeSafeZone_2( waitTime )
{
	level endon( "PIPE_HELI_DANGER_OVER" );
	level endon( "PLAYER_SPOTTED" );
	
	wait( waitTime );

	pipe_safe_zone = getentarray( "pipe_safe_zone_2", "targetname" ); 
	
	dangerStartTime = GetTime();
	
	while( 1 )
	{
		isInSafeZone = 0;
		for( i=0; i<pipe_safe_zone.size; i++ )
		{
			trigger = pipe_safe_zone[i];
			if( level.player istouching( trigger ) )
			{
				isInSafeZone = 1;
				break;
			}
		}
		
		if( isInSafeZone == 0 )
		{
			level.woods thread player_breaks_stealth_vo();
			level.player thread attack_player( level.pipe_chopper );
			level.player thread attack_player( level.pipe_chopper_02 );
			level.player thread kill_player_in_x_sec( 4.0 );
			flag_set( "PLAYER_SPOTTED" );
			flag_set( "BREAKS_STEALTH" );
		}
		
		wait( 0.05 );
	}
}

player_breaks_stealth_vo_stand_up()
{
	level endon( "PLAYER_SPOTTED" );
	
	if( !isdefined( level.woods.player_breaks_stealth_vo_stand_up ) )
	{
		level.woods.player_breaks_stealth_vo_stand_up = 1;
		level.woods thread playVO_proper( "head_down" );	//We got a chopper coming. Get your head down.
		wait( 2.0 );	
		//level.woods thread playVO_proper( "giveup_pos" );	//You're giving away our position!
		//wait( 1.0 );
		level.woods.player_breaks_stealth_vo_stand_up = undefined;
	}
}

player_breaks_stealth_vo_leaves_cover()
{
	level endon( "PLAYER_SPOTTED" );
	
	if( !isdefined( level.woods.player_breaks_stealth_vo_leaves_cover ) )
	{
		level.woods.player_breaks_stealth_vo_leaves_cover = 1;
		level.woods thread playVO_proper( "back_to_cover" );	//Get back to cover. They'll see you!
		wait( 2.0 );
		//level.woods thread playVO_proper( "giveup_pos" );		//You're giving away our position!
		//wait( 1.0 );	
		level.woods.player_breaks_stealth_vo_leaves_cover = undefined;
	}
}

player_breaks_stealth_vo()
{
	if( !isdefined( level.woods.player_breaks_stealth_vo ) )
	{
		level.woods.player_breaks_stealth_vo = 1;
		level.woods thread playVO_proper( "spotted" );
		level.woods thread playVO_proper( "spotted2", 1.0 );
		level.woods StopAnimScripted();
		level.woods.ignoreall = false;
		
	
	}
}

checkForBeingInsidePipeSafeZone( waitTime )
{
	level endon( "PIPE_HELI_SPOTTED_DANGER_OVER" );
	level endon( "PLAYER_SPOTTED" );
	
	wait( waitTime );

	pipe_safe_zone = getentarray( "pipe_safe_zone", "targetname" ); 
	
	dangerStartTime = GetTime();
	
	while( 1 )
	{
		isInSafeZone = 0;
		for( i=0; i<pipe_safe_zone.size; i++ )
		{
			trigger = pipe_safe_zone[i];
			if( level.player istouching( trigger ) )
			{
				isInSafeZone = 1;
				break;
			}
		}
		
		if( isInSafeZone==0 )
		{
			level.woods thread player_breaks_stealth_vo_leaves_cover();
				
			if( (GetTime() - dangerStartTime) > 2000.0 )
			{
				level.woods thread player_breaks_stealth_vo();
				level.player thread attack_player( level.pipe_chopper );
				level.player thread attack_player( level.pipe_chopper_02 );
				flag_set( "PLAYER_SPOTTED" );
				flag_set( "BREAKS_STEALTH" );
			}
		}
		else
		{
			level.woods.player_breaks_stealth_vo_leaves_cover = undefined;
			
			if( level.player GetStance() == "stand" )
			{
				level.woods thread player_breaks_stealth_vo_stand_up();
				
				if( (GetTime() - dangerStartTime) > 2000.0 )
				{
					level.woods thread player_breaks_stealth_vo();
					level.player thread attack_player( level.pipe_chopper );
					level.player thread attack_player( level.pipe_chopper_02 );
					flag_set( "PLAYER_SPOTTED" );
					flag_set( "BREAKS_STEALTH" );
				}
			}
			else
			{
				//Still safe! reset the start time
				dangerStartTime = GetTime();
				level.woods.player_breaks_stealth_vo_stand_up = undefined;
				level.woods.player_breaks_stealth_vo_leaves_cover = undefined;
			}
		}
		
		wait( 0.1 );
	}
}

play_extra_dust()
{
	wait( 8.0 );
	//playVO( "play_extra_dust", "Woods" );
	exploder( 210 );
}

woodsRunToPipe()
{
	level endon( "PLAYER_SPOTTED" );
	
	//TUEY set music state to END_BINOCULAR_SCENE (for jumpto, prior scriptcall to this state for timing with cinematic properly)
	setmusicstate("END_BINOCULAR_SCENE");
	
	// help with the blending in and out
	//level.woods anim_set_blend_in_time( 0.4 );
	//level.woods anim_set_blend_out_time( 0.5 );
	
	//Node for woods to run to
	hide_at_pipe_node = getnode( "hide_at_pipe", "targetname" );	
	//hide_at_pipe_node = getstruct("hide_at_pipe_align_struct", "targetname");
	//hide_at_pipe_node anim_reach_aligned( level.woods, "hide_at_pipe" );	
	
	level.woods SetGoalNode( hide_at_pipe_node );
	level.woods.goalradius = 4;
	level.woods waittill( "goal" );
	
	wait 0.2;
	
	hide_at_pipe_node thread anim_loop_aligned( level.woods, "hide_at_pipe_idle", undefined, "stop_pipe_idle" );
	//level.woods thread anim_loop_aligned( level.woods, "hide_at_pipe_idle", undefined, "stop_pipe_idle" );


	//level.woods setgoalnode( hide_at_pipe );
	//level.woods waittill( "goal" );
	
	level.woods LookAtEntity( level.pipe_chopper );		//Look at the helicopter
	flag_set( "WOODS_AT_PIPE" );
	level thread play_extra_dust();
	
	//level.woods LookAtEntity( level.pipe_chopper_02 );	//Look at the helicopter
	//level.woods LookAtEntity();					//Stop looking at the player
	

	
	level.player thread checkForBeingInsidePipeSafeZone( 4.0 );
}

event2_RunToPipe()
{
	level endon( "PLAYER_SPOTTED" );

	autosave_by_name("flashpoint_e2");
	debug_event( "event2_RunToPipe", "start" );
	
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_OBJ_FOLLOW" );
	
	pipe_return_blocker = getent( "pipe_return_blocker", "targetname" );
	pipe_return_blocker NotSolid();
	
	//Spawn a 2nd helicopter to look menacing
	pipe_chopper_02_start_node = GetVehicleNode( "pipe_chopper_02_start", "targetname" );
	//level.pipe_chopper_02 = SpawnVehicle( "t5_veh_helo_mi8_woodland", "pipe_chopper_02", "heli_hip", pipe_chopper_02_start_node.origin, (0,0,0) );
	//maps\_vehicle::vehicle_init( level.pipe_chopper_02 );
	//pipe_chopper_02 thread go_path( pipe_chopper_02_start_node );
	
	level.pipe_chopper.myindex=0;
	level.pipe_chopper_02.myindex=1;
	
	//Remove clip that blocks the way
	clip = getent( "clip_start", "targetname" );
	clip delete();
	level.player enableweapons();
	
	level.pipe_chopper thread vehicle_takes_damage();
	level.pipe_chopper_02 thread vehicle_takes_damage();
	level.player thread player_breaks_stealth_heli();
	
	//Make woods wait on the player dropping down
	woods_wait_on_player = getnode( "woods_wait_on_player", "targetname" );	
	level.woods setgoalnode( woods_wait_on_player );
	make_sure_player_drops = GetEnt("make_sure_player_drops", "targetname");
	make_sure_player_drops waittill( "trigger" );
	
	//Ok player has dropped down.... carry on 
	flag_set( "PLAYER_DROPPED_DOWN" );
	level.player thread checkForWonderingOff();
	level.woods thread attractChopper();
//	level.player thread player_breaks_stealth_heli();
	
	//Node for woods to run to
	level.woods thread woodsRunToPipe();
	
	pipe_safe_zone_trigger = GetEnt("pipe_safe_zone_trigger", "targetname");
	pipe_safe_zone_trigger waittill( "trigger" ); 
	flag_set( "PLAYER_AT_PIPE" );
	flag_wait( "WOODS_AT_PIPE" );
	debug_script( "PLAYER AT PIPE" );
	
	Objective_Set3D( level.obj_num, false );
	Objective_State( level.obj_num, "done" ); 
	level.obj_num--;
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_OBJ_FOLLOW" );
	
	debug_event( "event2_RunToPipe", "end" );
	event2_HideAtPipe();
}

setup_dump_guard()
{
	self endon("death");
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	
	self.dofiringdeath = false;
	self.ignoreall = true;
	self.dropweapon = false;
	self.noragdoll = false;
	self.maxhealth = 999999;
	self.health = 999999;
//	self.animname = "dump_guard";
	self.goalradius = 32;
	
	//self thread anim_loop( self, "standA" );
			
// 	self thread wait_for_enemy();
// 	self thread ai_anim_hit();
// 	self thread patrol_stealth_track_player();
// 	self thread check_compound();
// 	self thread alert_compound();
// 	self thread stop_anim();
}


///////////////////////////////////////////////////////////////////////////////////////
// Rocket stabilizers open when first rocket takes off
///////////////////////////////////////////////////////////////////////////////////////
rocket_stabilizer_distant()
{
	stab_big = getent( "rocket_stabilizer_big2", "targetname" );
	stab_small = getent( "rocket_stabilizer_small2", "targetname" );
	
	stab_big BypassSledgehammer();
	stab_small BypassSledgehammer();
	
	stab_big rotateroll( -55, 5.0, 0.5, 1.0 );
	wait( 4.0 );
	stab_small rotateroll( -40, 2.0, 0.1, 0.3 );
}

///////////////////////////////////////////////////////////////////////////////////////
// Rocket clamps open
///////////////////////////////////////////////////////////////////////////////////////
rocket_clamps_distant()
{
	clamps = getentarray( "distant_clamp", "script_noteworthy" );
	
	for( i=0; i<clamps.size; i++ )
	{
		clamps[i] BypassSledgehammer();
		clamps[i] rotateroll( -50, 2.0, 0.1, 0.3 );
	}	
}

///////////////////////////////////////////////////////////////////////////////////////
// Distant rocket takes off at the beginning
///////////////////////////////////////////////////////////////////////////////////////
play_fx_on_tag_check()
{
	self endon( "delete" );
	self endon( "death" );

	//self.temp_script_ent = Spawn( "script_model", self.origin );
	
	while( 1 )
	{
		//Check that we can see the fx
		cansee = false;
		
		trace = bullettrace( level.player.origin, self.origin, false, undefined);
		if( trace["fraction"] == 1 )		
		{
			cansee = true;
			break;
		}	

		if( cansee )
		{
			//iprintlnbold( "CAN SEE THE ROCKET" );
			
			if( !isdefined(self.temp_script_ent) )
			{
				self.temp_script_ent = Spawn( "script_model", self.origin );
				wait( 0.75 );
				self.temp_script_ent SetModel( "tag_origin" );
				self.temp_script_ent LinkTo( self );
				
				playfxontag(level._effect["rocket_glare"], self.temp_script_ent, "tag_origin" );	
			}
		}
		else
		{
			//iprintlnbold( "NO ROCKET IN SIGHT" );
			
			if( isdefined(self.temp_script_ent) )
			{
				self.temp_script_ent Delete();
				self.temp_script_ent = undefined;
			}
		}
		wait( 0.1 );
	}
}

	
rocket_rumble()
{
	level endon( "rocket_runble_end" );
	while( 1 )
	{
		level.player PlayRumbleOnEntity( "tank_rumble" );
		wait( 0.1 );
	}
}	
	

rocket_distant()
{
	rocket = getent( "dist_rocket", "targetname" );
	tag_trail = getent( "tag_rocket_trail", "targetname" );
	tag_exh = getent( "tag_dist_rocket", "targetname" );
	
	rocket BypassSledgehammer();
	tag_trail BypassSledgehammer();
	tag_exh BypassSledgehammer();
	
	//wait( 9.0 );
	
	//Kevin notify for rocket audio
	level notify ( "blast_off" );
	
	wait( 0.5 );
	
	level thread rocket_stabilizer_distant();
	
	wait( 0.5 );
	
	playfxontag(level._effect["rocket_launch_dist"], tag_exh, "tag_origin" );
	
	//tag_exh thread play_fx_on_tag_check();
	playfxontag(level._effect["rocket_glare"], tag_exh, "tag_origin" );
	tag_exh thread delete_on_flag( "BEGIN_EVENT3" );
	
	//flag_set( "end_binoculars" );
	
	wait( 1.0 );
	
	level thread rocket_clamps_distant();
	
	rocket movez( 46500, 30.0, 5.0, 0.1 );
	tag_exh movez( 46500, 30.0, 5.0, 0.1 );
	
	level thread rocket_rumble();
	
	//playfxontag(level._effect["rocket_launch_base_dist"], tag_trail, "tag_origin" );
	
	exploder( 110 );
	
	rocket waittill( "movedone" );
	level notify( "rocket_runble_end" );

	
	exploder( 112 );
	
	rocket delete();	
	if(IsDefined(tag_exh))
	{
		tag_exh delete();
	}
}

delete_on_flag( flag_msg )
{
	self endon("death");
	flag_wait( flag_msg );
	
	if(IsDefined(self))
	{
		self Delete();
	}
}


pipeObjective()
{
	level endon( "PLAYER_SPOTTED" );
	
	player_is_over_pipe = GetEnt("player_is_over_pipe", "targetname");
	if( isdefined( player_is_over_pipe ) )
	{
		player_is_over_pipe waittill( "trigger" );
	}

	level thread rocket_distant();

	flag_set( "PLAYER_OVER_PIPE" );
	//level.pipe_blocker Solid();
}



///////////////////////////////////////////////////////////////////////////////////////
// jump anim - self = player
///////////////////////////////////////////////////////////////////////////////////////
#using_animtree("flashpoint");
jumppipe_anim()
{
	self endon( "jump_done" );
	anim_node = get_anim_struct( "4" );
	
	while( 1 )
	{
		if ( self JumpButtonPressed() )
		{
			//anim_node = get_anim_struct( "6" );
			
			//self DisableWeapons();
			//self FreezeControls( true );

			//spawn the player body
			self.body = spawn_anim_model( "player_body", anim_node.origin, anim_node.angles );
			anim_node thread anim_single_aligned( self.body, "vault_over_pipe" );
			
			self StartCameraTween(.2);
			self PlayerLinktoAbsolute(self.body, "tag_player");
			
			self.body waittill("vault_over_pipe");
			
			self Unlink();
			self.body Unlink();
			self.body Delete();
			self notify( "jump_done" );
		}
		wait( 0.05 );
	}
}


spawn_guards( waittime )
{
	wait( waittime );
	
	//-- dumpguard1 - kneeling
	//-- dumpguard2 - standing
	
	level.dumpguard1 = simple_spawn_single( "dump_guard1", ::setup_dump_guard );
	level.dumpguard2 = simple_spawn_single( "dump_guard2", ::setup_dump_guard );
	level.dumpguard1.animname = "guard1";
	level.dumpguard2.animname = "guard2";
	level.dumpguard2._melee_ignore_angle_override = true;
	//level.dumpguard2 contextual_melee( "karambit" );
	level.dumpguard1 contextual_melee( false );
	level.dumpguard2 contextual_melee( false );
	
	level.dumpguard1 Detach(level.dumpguard1.headModel);
	level.dumpguard2 Detach(level.dumpguard2.headModel);
	level.dumpguard1 character\gfl\character_gfl_saiga12::main();
	level.dumpguard2 character\gfl\character_gfl_9a91::main();

	//Get woods into the first frame of the anim
	anim_node = get_anim_struct( "5" );
	level.dumpguard1 thread karambit_guard_killed_by_player( anim_node );							//causes a fail condition
	level.dumpguard2 thread karambit_guard_killed_by_player_before_woods_starts( anim_node );		//causes a fail condition
	level.dumpguard1 thread karambit_guard_1( anim_node );
	level.dumpguard2 thread karambit_guard_2( anim_node );
	
	level.player thread player_breaks_stealth_karambit_by_firing_gun();
	level.player thread gurads_attack_player_when_stealth_is_broken();
	
// 	level.dumpguard1 thread karambit_guard_player_fires_gun();
// 	level.dumpguard2 thread karambit_guard_player_fires_gun();
// 	
// 	level.player thread gurads_attack_player_when_stealth_is_broken();
}

woods_jump_over_pipe()
{	
	level endon( "PLAYER_SPOTTED" );
	
	//play woods over pipe anim
	//anim_node = get_anim_struct( "4" );
	anim_node = get_anim_struct( "4b" );
	//anim_node = get_anim_struct( "4c" );
	
	hide_at_pipe_03 = getnode( "hide_at_pipe_03", "targetname" );
	
	//playVO( "START", "Woods" );
	println( "woods vault_over_pipe=" + level.woods.origin );
	//level.woods LookAtEntity();
	
	
	level.woods anim_set_blend_in_time(0.3);
	anim_node thread anim_single_aligned( level.woods, "vault_over_pipe" );
	level.woods setgoalnode( hide_at_pipe_03 );
	anim_node waittill( "vault_over_pipe" );
	level.woods anim_set_blend_in_time(0);
	//level.woods setgoalpos( level.woods.origin );
	
	level thread take_disguise_vo(); 
	
	level.woods disable_cqbwalk();
	
	level.woods set_run_anim( "run_fast", true );
	level.woods AllowedStances( "stand", "crouch", "prone" );
}

take_disguise_vo()
{
	level.scr_sound["woods"]["need_uniforms"] = "vox_fla1_s02_049A_wood_m"; //We need those uniforms.
  level.scr_sound["woods"]["on_the_ground"] = "vox_fla1_s02_050A_wood_m"; //I'll take the one on the ground. You get the other.
  level.scr_sound["mason"]["got_it"] = "vox_fla1_s02_051A_maso"; //Got it.
    
  level.woods anim_single( level.woods, "need_uniforms" );
  level.woods anim_single( level.woods, "on_the_ground" );
  level.player anim_single( level.player, "got_it" );
}

event2_HideAtPipe()
{
/*
 The chopper is hovering about. It should not look like it is has seen you, it�s just patrolling around
 Woods shimmies along the pipe, Player should follow
 NOTE: If chopper sees you, it fires rockets and it�s all over
*/

	level endon( "PLAYER_SPOTTED" );
	debug_event( "event2_HideAtPipe", "start" );
	
	//Helicopter flys by
	wait( 14.0 );

	level thread spawn_guards( 2.0 );
	//level.player thread gurads_attack_player_when_stealth_is_broken();
	
	//Set objective to follow Woods
//	playVO( "Follow me, stay low!", "Woods" );
	//level.woods thread playVO_proper( "follow_me" );	//Follow me and keep moving
		
	//level.woods LookAtEntity( level.player);	//Stop looking at the helicopter + Look at the player
	//wait( 1.5 );
	//level.woods LookAtEntity();					//Stop looking at the player
	
	flag_set( "PIPE_HELI_SPOTTED_DANGER_OVER" );
	autosave_by_name("flashpoint_e2b"); //-- used to be at the beginning of the karambit
	hide_at_pipe_node = getnode( "hide_at_pipe", "targetname" );
	//level.woods notify("stop_pipe_idle");
	//wait(0.2);
	level.woods anim_set_blend_out_time( 0.5 );
	level.woods anim_single_aligned( level.woods, "hide_at_pipe" );
		
	//New node for woods to run to
	hide_at_pipe_02 = getnode( "hide_at_pipe_02b", "targetname" );
	
	level.player thread pipeObjective();
	level.woods setgoalnode( hide_at_pipe_02 );
	level.woods LookAtEntity();
	level.woods waittill( "goal" );
	debug_script( "WOODS AT PIPE 02" );
	wait( 1.0 );
	
	//Enable tatical walk on woods
	level.woods enable_cqbwalk();
	
	//Move helicopter over to player and woods
	//playVO( "They can�t see us anymore, lets go", "Woods" );
	//level.woods thread playVO_proper( "pick_it_up_2" );//We're good. Pick it up.

	//Helicopter has gone - chopper danger is over
//	flag_set( "PIPE_HELI_SPOTTED_DANGER_OVER" );
	level.player thread checkForBeingInsidePipeSafeZone_2( 4.0 );
 	
 	hide_at_pipe_03 = getnode( "hide_at_pipe_03", "targetname" );

	level.woods thread woods_jump_over_pipe();
	
	//level.woods.a.coverIdleOnly = true; //-- test
	level.woods thread force_goal( hide_at_pipe_03, 128 );
	
	//Get woods into the first frame of the anim
	anim_node = get_anim_struct( "5" );
	
	debug_script( "WOODS AT PIPE 03" );
	flag_wait( "PLAYER_OVER_PIPE" );
	
	//Check player is correct side of pipe
 	player_is_over_pipe = GetEnt("player_is_over_pipe", "targetname");
 	while( (level.player istouching( player_is_over_pipe )) == false )
 	{
 		wait( 0.05 );
 	}

	pipe_return_blocker = getent( "pipe_return_blocker", "targetname" );
	pipe_return_blocker Solid();
	
	flag_set( "PIPE_HELI_DANGER_OVER" );
	
	debug_event( "event2_HideAtPipe", "end" );
	event2_KarambitIntoduction();
}

karambit_music_stinger()
{
	level.player waittill ("do_contextual_melee");
	setmusicstate ("MELEE_GUARD");	
	
}
karambit_woods_should_die()
{
	level endon( "PLAYER_KILLED_GUARD" );
	level endon( "BREAKS_STEALTH" );
	level.player endon( "do_contextual_melee" );
	
	flag_wait( "SHOULD_WOODS_DIE" );
	
	//playVO( "END", "Woods" );
	self StopAnimScripted();
	self.dofiringdeath = false;
	self.takedamage = true;
	self unmake_hero();
 	//self Die();
}

kill_objective()
{
	wait( 3.0 );
	Objective_Set3D( level.obj_num, false );
	level.obj_num++;
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_STEALTH_KILL" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, level.dumpguard2.origin + (0.0, 0.0, 85.0) );
}

karambit_woods( anim_node )
{
	self endon( "death" );
	level endon( "BREAKS_STEALTH" );
	
	self thread karambit_woods_should_die();
	
	level.woods waittill( "goal" );
	//wait(0.1);
	//level.woods.a.coverIdleOnly = false; //-- reset this value
	
	level thread karambit_music_stinger();
//	println( "woods karambit_intro_woods=" + level.woods.origin );
//	anim_node thread anim_single_aligned( self, "karambit_intro_woods" );
//	anim_node waittill( "karambit_intro_woods" );
//	self setgoalpos( self.origin );

//	println( "woods karambit_wait origin =" + level.woods.origin );
//	println( "woods karambit_wait angles =" + level.woods.angle );
	//anim_node thread anim_loop_aligned( self, "karambit_wait_woods" );

	flag_wait( "KARAMBIT_ATTACK_GO" );
	level.dumpguard2 contextual_melee( "karambit" );
	level thread kill_objective();
	
	/*
	animating_guys = [];
	animating_guys[0] = level.dumpguard1;
	animating_guys[1] = level.dumpguard2;
	animating_guys[2] = level.woods;
	*/
	
	// help with the blending in and out
	//level.woods anim_set_blend_in_time( 0.4 );
	//level.woods anim_set_blend_out_time( 0.1 );
	
	level.woods Attach("t5_knife_karambit", "TAG_WEAPON_LEFT");
	anim_node thread anim_single_aligned( self, "karambit_attack_woods" );
	
	//flag_set( "KARAMBIT_ATTACK_IN_PROGRESS" );
	
	/*
	level.woods anim_set_blend_in_time( 0.75 ); //-- helps blend from the cover arrival into the scripted animation
	level.woods anim_set_blend_out_time( 0.75 );
	level.woods Attach("t5_knife_karambit", "TAG_WEAPON_LEFT");
	anim_node anim_single_aligned( animating_guys, "karambit_attack" );
	level.woods anim_set_blend_in_time( 0 );
	level.woods anim_set_blend_out_time( 0 );
	level notify("synced_karambit_attack_done");
	level.woods Detach("t5_knife_karambit", "TAG_WEAPON_LEFT");
	*/
	
	anim_node waittill( "karambit_attack_woods" );
	level.woods Detach("t5_knife_karambit", "TAG_WEAPON_LEFT");
	self setgoalpos( self.origin );
	
 	anim_node thread anim_loop_aligned( self, "karambit_idle_woods" );
 	
 	// help with the blending in and out
	//level.woods anim_set_blend_in_time( 0.0 );
	//level.woods anim_set_blend_out_time( 0.0 );
 	
 	
 	//DIE HERE IS PLAYER HAS NOT KILLED GUARD 1
 	//wait( 0.5 );
 	flag_set( "SHOULD_WOODS_DIE" );
 	
 	//flag_wait( "PLAYER_KILLED_GUARD" );
 	
 	wait( 3.0 );
 	
 	level.woods thread playVO_proper( "outofsight" );	//Let's get them out of sight.

	//stop rumble on rocket if player does karambit kill
	level notify( "rocket_runble_end" );

 	flag_set( "WOODS_DRAGS_BODY" );
 	self SetAnimRateComplete(1.5);
	anim_node thread anim_single_aligned( self, "karambit_drag_woods" );
	anim_node waittill( "karambit_drag_woods" );
	self SetAnimRateComplete(1);
	self setgoalpos( self.origin );

 	anim_node thread anim_loop_aligned( self, "karambit_drag_wait_woods" );
}

guard_dialog( waittime )
{
	level endon( "BREAKS_STEALTH" );
	level endon( "PLAYER_KILLED_GUARD" );
	level endon( "WOODS_KILLED_GUARD" );
	level.dumpguard1 endon( "death" );
	level.dumpguard2 endon( "death" );
	level.player endon( "do_contextual_melee" );
	
	wait( waittime );
	
	level.dumpguard1 thread playVO_proper( "line1" ); //(Translated) A work of great Soviet ingenuity.
	wait( 2.0 );
	level.dumpguard2 thread playVO_proper( "line2" ); //(Translated) Made from Russian suffering.
	wait( 2.0 );
	level.dumpguard1 thread playVO_proper( "line3" ); //(Translated) Such courage to say that when Dragovich isn't here.
	wait( 2.0 );
	level.dumpguard2 thread playVO_proper( "line4" ); //(Translated) I'd say it in front of him.
	wait( 2.0 );
	level.dumpguard1 thread playVO_proper( "line5" ); //(Translated) Of course you would. But look at it! Tell me we cannot achieve great things.
}

karambit_guard_killed_by_player( anim_node )
{
	level endon( "BREAKS_STEALTH" );
	//self endon( "death" );
	
	self waittill( "damage", amount, attacker );
	if ( isplayer( attacker ) )
	{
		self StopAnimScripted();
		self  StartRagdoll();
		self dodamage( self.health, self.origin );
	
		println( "**************PLAYER KILLS WRONG GUARD*************" );
		flag_set( "BREAKS_STEALTH" );
	}
}


karambit_guard_killed_by_player_before_woods_starts( anim_node )
{
	level endon( "BREAKS_STEALTH" );
	level endon( "KARAMBIT_ATTACK_IN_PROGRESS" );
	//self endon( "death" );
	
	self waittill( "damage", amount, attacker );
	if ( isplayer( attacker ) )
	{
		self StopAnimScripted();
		self StartRagdoll();
		self dodamage( self.health, self.origin );
	
		//println( "**************PLAYER KILLS  GUARD BEFORE WOODS IS READY *************" );
		flag_set( "BREAKS_STEALTH" );
	}
}


karambit_guard_1( anim_node )
{
	level endon( "BREAKS_STEALTH" );
	self endon( "death" );
	
	
	level thread guard_dialog( 9.0 );
	
	anim_node thread anim_single_aligned( self, "karambit_intro_guard1" );
	anim_node waittill( "karambit_intro_guard1" );
	//self setgoalpos( self.origin );
	
	//level thread guard_dialog();
	
	println( "guard1 karambit_wait_guard1=" + level.woods.origin );
	anim_node thread anim_loop_aligned( self, "karambit_wait_guard1" );
	flag_set( "KARAMBIT_GUARDS_READY" );
	flag_wait( "KARAMBIT_ATTACK_GO" );
	
	
	
	anim_node thread anim_single_aligned( self, "karambit_attack_guard1" );
	anim_node waittill( "karambit_attack_guard1" );
	self setgoalpos( self.origin );
	
	
	//level waittill("synced_karambit_attack_done");
	
 	anim_node thread anim_loop_aligned( self, "karambit_dead_guard1" );
 
 	flag_wait( "WOODS_DRAGS_BODY" );
 	self SetAnimRateComplete(1.5);
	anim_node thread anim_single_aligned( self, "karambit_drag_guard1" );
	self thread karambit_guard_1_drag_fx( anim_node, "karambit_drag_guard1");
	anim_node waittill( "karambit_drag_guard1" );
	self SetAnimRateComplete(1);
	self Delete();
	/*
	self setgoalpos( self.origin );
	self Die();
	*/
}

karambit_guard_1_drag_fx( endon_ent, endon_notify )
{
	endon_ent endon(endon_notify);
	
	// "J_HIP_LE" - playing the effect off of the closer hip
	
	while(1)
	{
		fx_point = self GetTagOrigin( "J_HIP_LE" );
		PlayFX( level._effect["body_dragging_dust"], fx_point );
		wait(0.2);	
	}
}

shoot_and_kill( enemy )
{
	self endon( "death" );
	//enemy endon( "death" );

	self.perfectAim = true;
	//enemy.health = 1;
	while( IsAlive(enemy) )
	{
		self shoot_at_target( enemy,"J_head" );
		wait(0.05);
	}

	self.perfectAim = false;
	self notify( "enemy_killed" );
}


karambit_guard_2_back_to_ai_to_kill_woods( anim_node )
{
//	level endon( "BREAKS_STEALTH" );
	level endon( "PLAYER_KILLED_GUARD" );
	level.player endon( "do_contextual_melee" );
	//self endon("_contextual_melee_thread");
	//level.player endon("_contextual_melee_thread");
	self endon( "death" );
	
	flag_wait( "SHOULD_WOODS_DIE" );
	self StopAnimScripted();
	self setgoalpos( self.origin );
	self.ignoreall = false;
	
	//self thread shoot_and_kill( level.woods );
	level.dumpguard2 contextual_melee( false );
	playfxontag( level.fake_muzzleflash, self, "tag_flash" );
	MagicBullet("ak47_sp", self GetTagOrigin("tag_flash"), level.woods.origin, self );	
	
	level.woods thread ragdoll_death();
	level.dumpguard1 thread ragdoll_death();
	
	level.dumpguard2._melee_ignore_angle_override = undefined;
	
	
	//playfxontag( level.fake_muzzleflash, self, "tag_flash" );
	//MagicBullet("ak47_sp", self GetTagOrigin("tag_flash"), level.player.origin, self );	
	
	self StopAnimScripted();
	self.ignoreall = false;
	self thread shoot_and_kill( level.player );
	flag_set( "BREAKS_STEALTH" );
	screen_message_delete();
	
	player = get_players()[0];
	player EnableInvulnerability();
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_KARAMBIT_WOODSDEAD");			
	//level_fail( "Woods Died" ); 
}

karambit_guard_2_gets_killed( anim_node )
{
	level endon( "BREAKS_STEALTH" );
	
	flag_wait( "PLAYER_KILLED_GUARD" );
	anim_node thread anim_loop_aligned( self, "karambit_dead" );
	//self waittill( "karambit_dead" );
	//self Die();
}

karambit_guard_2( anim_node )
{			
	level endon( "PLAYER_KILLED_GUARD" );
	level endon( "BREAKS_STEALTH" );	
	self endon( "_contextual_melee_thread" );
	
	self thread karambit_guard_2_back_to_ai_to_kill_woods( anim_node );
	//self thread karambit_guard_2_gets_killed( anim_node );
	
	anim_node thread anim_single_aligned( self, "karambit_intro_guard2" );
	anim_node waittill( "karambit_intro_guard2" );
	//self setgoalpos( self.origin );
	
	anim_node thread anim_loop_aligned( self, "karambit_wait_guard2" );
	flag_wait( "KARAMBIT_ATTACK_GO" );

		
	anim_node thread anim_single_aligned( self, "karambit_attack_guard2" );
	anim_node waittill( "karambit_attack_guard2" );
	self setgoalpos( self.origin );
	
	anim_node thread anim_loop_aligned( self, "karambit_attack_wait_guard2" );
	
}

wait_for_player_to_kill_guard( guard, anim_node )
{	
// 	level endon( "BREAKS_STEALTH" );
// 	level endon( "PLAYER_KILLED_GUARD" );
// 	guard endon( "death" );
// 	
// 	guard waittill( "damage" );
	//flag_set( "PLAYER_KILLED_GUARD" );
}

wait_for_player_to_meleekill_guard( guard, anim_node )
{	
	level endon( "BREAKS_STEALTH" );
	level endon( "PLAYER_KILLED_GUARD" );
	guard endon( "death" );
	
	self waittill( "melee_done" );
	flag_set( "PLAYER_KILLED_GUARD" );
}

attack_trigger_wait()
{	
	level endon( "BREAKS_STEALTH" );
	
	//Wait till player gets beside Woods
	//start_knife_attack_trigger = GetEnt("start_knife_attack", "targetname");
	//start_knife_attack_trigger waittill( "trigger" ); 
	flag_wait( "KARAMBIT_GUARDS_READY" );
	flag_set( "KARAMBIT_ATTACK_GO" );
	level.woods enable_cqbwalk();
}

gurads_attack_player_when_stealth_is_broken()
{
	level endon( "PAST_INVESTIGATION_GUARDS" );
	self endon("death");
	
	flag_wait( "BREAKS_STEALTH" );
	level.dumpguard2 contextual_melee( false );

	level.dumpguard1 anim_stopanimscripted();
	level.dumpguard1 setgoalpos( level.dumpguard1.origin );
	level.dumpguard1.ignoreall = false;
	level.dumpguard2 anim_stopanimscripted();
	level.dumpguard2 setgoalpos( level.dumpguard2.origin );
	level.dumpguard2.ignoreall = false;
	
	level.woods anim_stopanimscripted();
	level.woods setgoalpos( level.woods.origin );
	level.woods.ignoreall = false;
	
	flag_wait( "PIPE_HELI_DANGER_OVER" );
	screen_message_delete();
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_KARAMBIT_BROKESTEALTH");				
	//level_fail( "You Broke Stealth" ); 
}

player_breaks_stealth_karambit_by_firing_gun()
{	
	//level endon( "PLAYER_KILLED_GUARD" );
	level endon( "KARAMBIT_ATTACK_IN_PROGRESS" );
	self endon("death");
	
	self waittill_any( "weapon_fired", "grenade_fire" );
	flag_set( "BREAKS_STEALTH" );
}

is_ai_facing_player( ai )
{
	// check to see where the ai is facing
	vec1 = AnglesToForward( ai.angles );// this is the direction the ai is facing
	vec2 = VectorNormalize( self.origin - ai.origin );// this is the direction from him to us
	
//	scale = 100;
//	fwd = vector_scale( vec2, scale );
//	level thread maps\_debug::drawDebugLine( ai.origin, (ai.origin + fwd), (1,1,1) ,10 );
	
	// comparing the dotproduct of the 2 will tell us if he's facing us and how much so..
	// 0 will mean his direction is exactly perpendicular to us, 
	// 1 will mean he's facing directly at us
	// - 1 will mean he's facing directly away from us 
	vecdot = vectordot( vec1, vec2 );	

	// is the ai facing us?
	if ( vecdot > .3 )
	{
		return true;
	}
	return false;
}

player_breaks_stealth_karambit_by_being_spotted()
{	
	level endon( "PLAYER_KILLED_GUARD" );
	level endon( "BREAKS_STEALTH" );
	level endon( "KARAMBIT_ATTACK_IN_PROGRESS" );
	self endon("death");
	self endon( "do_contextual_melee" );
	
	flag_wait( "KARAMBIT_ATTACK_GO" );
	
	//Check to see if we ever run round the front of the guards
	while( 1 )
	{
		if( isdefined( level.dumpguard1 ) && self is_ai_facing_player( level.dumpguard1 ) && level.dumpguard1 CanSee( self ) )
		{
			flag_set( "BREAKS_STEALTH" );
		}
		
		if( isdefined( level.dumpguard2 ) && self is_ai_facing_player( level.dumpguard2 ) && level.dumpguard2 CanSee( self ) )
		{
			flag_set( "BREAKS_STEALTH" );
		}
		wait( 0.05 );
	}
}


// karambit_melee_message_cleanup()
// {
// 	flag_wait( "BREAKS_STEALTH" );
// 	if( isdefined(level.melee_attack_msg) && (level.melee_attack_msg==1) )
// 	{
// 		level.melee_attack_msg = 0;
// 		screen_message_delete();
// 	}
// }
// 
// karambit_melee_message_cleanup2()
// {
// 	//wait 3 sec
// 	wait( 3.0 );
// 	if( isdefined(level.melee_attack_msg) && (level.melee_attack_msg==1) )
// 	{
// 		level.melee_attack_msg = 0;
// 		screen_message_delete();
// 	}
// }


// karambit_melee_message()
// {
// 	level endon( "BREAKS_STEALTH" );
// 	level endon( "PLAYER_KILLED_GUARD" );
// 	self endon( "death" );
// 	self endon( "do_contextual_melee" );
// 	
// 	level thread karambit_melee_message_cleanup();
// 	level thread karambit_melee_message_cleanup2();
// 	
// 	screen_message_create(&"FLASHPOINT_MELEE_ATTACK");
// 	level.melee_attack_msg = 1;
// 
// 	//now wait until player presses this button
// 	while(1)
// 	{
// 		if( level.player MeleeButtonPressed() )
// 		{
// 			level.melee_attack_msg = 0;
// 			screen_message_delete();
// 		}
// 		wait( 0.05 );
// 	}
// }


bring_out_knife()
{
	level endon( "BREAKS_STEALTH" );
	level endon( "PLAYER_KILLED_GUARD" );
	self endon( "death" );
	self endon( "do_contextual_melee" );
	
	screen_msg_active = false;
	self.prevweapon = self getcurrentweapon();
	
	level.player GiveWeapon( "karambit_knife_sp", 0 );
	self SwitchToWeapon( "karambit_knife_sp", 0 );
	//SOUND - Shawn J
	self playsound ("fly_karam_draw_plr");
	//level.player thread karambit_melee_message();
	
	self AllowSprint( false );
	self AllowJump( false );
	
	level.player SetMoveSpeedScale( 0.6 );
	SetSavedDvar( "player_runbkThreshhold", 0.0 ); //Fix for rapid footsteps
	level.player thread allow_run();
	
	level.player DisableWeaponCycling();
	level.player DisableOffhandWeapons();
			
	//Wait till the weapon has switched
// 	wait( 4.0 );
// 			
// 	while( 1 )
// 	{
// 		if( self getcurrentweapon() != "karambit_knife_sp" )
// 		{
// 			if( screen_msg_active == false )
// 			{
// 				level.player TakeWeapon( "karambit_knife_sp", 0 );
// 				screen_message_create(&"FLASHPOINT_USE_KNIFE_PRESS_X");
// 				screen_msg_active = true;
// 				self AllowSprint( true );
// 				self AllowJump( true );	
// 			}
// 			
// 			if( self UseButtonPressed() )
// 			{
// 				level.player GiveWeapon( "karambit_knife_sp", 0 );
// 				self SwitchToWeapon( "karambit_knife_sp", 0 );
// 				screen_message_delete();
// 				screen_msg_active = false;
// 				self AllowSprint( false );	
// 				self AllowJump( false );
// 				wait( 2.0 );
// 			}
// 		}
// 		wait( 0.05 );
	//}
}

allow_run()
{
	level waittill( "start_run_karambit" );
	flag_set( "KARAMBIT_ATTACK_IN_PROGRESS" );
	level.player SetMoveSpeedScale( 1.0 );
	SetSavedDvar( "player_runbkThreshhold", 60.0 ); //Resetting to default value
	level.player AllowSprint( true );
	level.player AllowJump( true );
}

putaway_knife()
{
	self endon( "do_contextual_melee" );
	
	//Waittill the player has killed the guard
	flag_wait( "PLAYER_KILLED_GUARD" );
	
	level.player SetMoveSpeedScale( 1.0 );
	SetSavedDvar( "player_runbkThreshhold", 60.0 ); //Resetting to default value
	screen_message_delete();
	level.player EnableWeaponCycling();
	level.player enableoffhandweapons();
	self SwitchToWeapon( self.prevweapon, 0 );
	self TakeWeapon( "karambit_knife_sp", 0 );
}

putaway_knife_2()
{
	level endon( "PLAYER_KILLED_GUARD" ); 

	//Waittill the player has killed the guard
	self waittill( "do_contextual_melee" );
	
	level.player SetMoveSpeedScale( 1.0 );
	SetSavedDvar( "player_runbkThreshhold", 60.0 ); //Resetting to default value
	Objective_State( level.obj_num, "done" );
	//level.obj_num--;
	
	screen_message_delete();
	level.player EnableWeaponCycling();
	level.player enableoffhandweapons();
	self SwitchToWeapon( self.prevweapon, 0 );
	self TakeWeapon( "karambit_knife_sp", 0 );
}


rumble_on_stab()
{
	level waittill( "karambit_stand_blood_now" );
	wait( 0.1 );
	level.player PlayRumbleOnEntity( "tank_fire" );
}

event2_KarambitIntoduction()
{
/*
 The Russians are chatting excitedly about the launch, waiting to witness it
 One is stood repeatedly pointing at the rocket, one is sat down with his gun vertical to the floor
 Woods VO: We can�t use our guns because we don�t want to damage the uniforms � we need them as our disguise � so we need to use a knife (next slide)

 This is a Karambit � a bad ass knife for a bad ass SOG soldier
 NOTE: This is wishlist. Initially use Reznov knife and we�ll figure out later if we have bandwidth to have this made
 Player goes weapons down and this knife appears in 1st Person view
 Woods VO: I�ll take the one sat down, you take the {more dangerous} one stood up
 *NOTE: Russian character models need to have most of face covered so SOG faces will not be visible when they wear the disguise
*/

	debug_event( "event2_KarambitIntoduction", "start" );
	//autosave_by_name("flashpoint_e2b");
	
	maps\_contextual_melee::contextual_melee_show_hintstring( false );
	maps\_contextual_melee::contextual_melee_allow_fire_button( true );
	level thread rumble_on_stab();
	
	level.player thread bring_out_knife();
	level.player thread putaway_knife();
	level.player thread putaway_knife_2();
	//level.player thread gurads_attack_player_when_stealth_is_broken();
	level.player thread player_breaks_stealth_karambit_by_firing_gun();
	level.player thread player_breaks_stealth_karambit_by_being_spotted();
	
	
	level.woods waittill( "goal" );
	
	wait( 2.0 );
	
	/*
	start_knife_scene_trigger = GetEnt("start_knife_scene", "targetname");
	if( isdefined( start_knife_scene_trigger ) )
	{
		start_knife_scene_trigger waittill( "trigger" );
	}
	*/
	
	//FLASHPOINT_OBJ_GET_DISGUISE
	set_event_objective( 1, "active" );
	
// 	level.dumpguard1 = simple_spawn_single( "dump_guard1", ::setup_dump_guard );
// 	level.dumpguard2 = simple_spawn_single( "dump_guard2", ::setup_dump_guard );
// 	level.dumpguard1.animname = "guard1";
// 	level.dumpguard2.animname = "guard2";
// 	level.dumpguard2 contextual_melee( "neckstab" );
	
	//Get woods into the first frame of the anim
	anim_node = get_anim_struct( "5" );

	level.player thread wait_for_player_to_kill_guard( level.dumpguard2, anim_node );
	level.player thread wait_for_player_to_meleekill_guard( level.dumpguard2, anim_node );
	level.player thread attack_trigger_wait();
	level.woods thread karambit_woods( anim_node );
	//level.dumpguard1 thread karambit_guard_1( anim_node );
	//level.dumpguard2 thread karambit_guard_2( anim_node );
	
	
	level thread move_body_trigger_spawn( level.dumpguard2 );
	
	//flag_wait( "PLAYER_KILLED_GUARD" );	
	
	//level thread move_body_trigger_spawn( level.dumpguard2 );
	
	event2_BodyDump();
}

event2_playerbodycarry()
{
	self endon( "carry_finished" );
	
	structs = [];
	//structs[0] = GetStruct("e2_bodycarry_a", "targetname");
	//structs[1] = GetStruct("e2_bodycarry_b", "targetname");
	//structs[2] = GetStruct("e2_bodycarry_c", "targetname");
	structs[0] = GetStruct("e2_bodycarry_d", "targetname");
	

	//Make sure player always moves towards the final node
	current_struct = 0;
	while (current_struct < 1)
	{
		//Make sure we always hit the first node in the chain
		if( current_struct==0 )
		{
			//Get angle to first node
			vecTo = vectorNormalize( structs[0].origin - self.origin );
			desired_angles = VectorToAngles( (vecTo[0], vecTo[1], 0.0 ) ); //cancel out vertical
			self RotateTo(desired_angles, 0.3, 0.2, 0.1);
		}
		struct_pos = structs[current_struct].origin;
		delta = Distance2DSquared(self.origin, struct_pos);
		if (delta < (32 * 32))
		{
			if (current_struct < 4)
			{
				desired_angles = structs[current_struct].angles;
				self RotateTo(desired_angles, 2.0, 1.0, 1.0);
			}
			current_struct++;
		}
		wait(0.05);
	}
	
	
// 	structs = [];
// 	structs[0] = GetStruct("e2_bodycarry_a", "targetname");
// 	structs[1] = GetStruct("e2_bodycarry_b", "targetname");
// 	structs[2] = GetStruct("e2_bodycarry_c", "targetname");
// 	structs[3] = GetStruct("e2_bodycarry_d", "targetname");
	
	
	//Get angle to first node
// 	vecTo = vectorNormalize( structs[0].origin - self.origin );
// 	desired_angles = VectorToAngles(vecTo);
// 	self RotateTo(desired_angles, 2.0, 1.0, 1.0);


	
// 	current_struct = 0;
// 	while (current_struct < 4)
// 	{
// 		//Make sure we always hit the first node in the chain
// 		if( current_struct==0 )
// 		{
// 			//Get angle to first node
// 			vecTo = vectorNormalize( structs[0].origin - self.origin );
// 			desired_angles = VectorToAngles( (vecTo[0], vecTo[1], 0.0 ) ); //cancel out vertical
// 			self RotateTo(desired_angles, 0.3, 0.2, 0.1);
// 		}
// 		struct_pos = structs[current_struct].origin;
// 		delta = Distance2DSquared(self.origin, struct_pos);
// 		if (delta < (32 * 32))
// 		{
// 			if (current_struct < 4)
// 			{
// 				desired_angles = structs[current_struct].angles;
// 				self RotateTo(desired_angles, 2.0, 1.0, 1.0);
// 			}
// 			current_struct++;
// 		}
// 		wait(0.05);
// 	}
}

move_to_player()
{
	self endon( "begin_carry" );
	
	while( true )
	{
		self.origin = level.player.origin;
		self.angles = level.player.angles;
		
		wait( 0.05 );
	}
}

// spawns the trigger used for the player to get revived
move_body_trigger_spawn( guardToCarry )
{
	
	// spawn the player body
	level.player.body = spawn_anim_model("player_body", level.player.origin, level.player.angles);
	level.player.body.animname = "player_body";
	level.player.body Hide();
	level.player.body SetAnim( level.scr_anim["player_body"]["carry_idle"][0], 1, 0, 0 );
	
	linker_object = Spawn("script_model", level.player.body.origin);
	linker_object SetModel("tag_origin");
	linker_object.angles = level.player.body.angles;
	level.player.body LinkTo( linker_object, "tag_origin" );
	level.player.linker_object = linker_object;
	
	level.player.linker_object thread move_to_player();
	
	level.hide_body_trigger = GetEnt("hide_bodies", "targetname");
	level.hide_body_trigger trigger_off();
	
	flag_wait( "PLAYER_KILLED_GUARD" );	
	
	level.player.linker_object notify( "begin_carry" );
	
	// setup the player
	level.player DisableWeapons();
	//level.player PlayerLinkTo(level.player.body, "tag_player", 1, 0, 0, 0, 0);
	//level.player PlayerLinktoAbsolute(level.player.body, "tag_camera");
	
	drag_idle = level.scr_anim["player_body"]["carry_idle"][0];
	drag_loop = level.scr_anim["player_body"]["carry_walk"][0];
	drag_idle_ai = level.scr_anim["guard2"]["carry_idle_guard2"][0];
	drag_loop_ai = level.scr_anim["guard2"]["carry_walk_guard2"][0];

	anim_node = get_anim_struct( "5" );
	animated_ents = [];
	animated_ents[0] = level.player.body;
	animated_ents[1] = guardToCarry;
	
	//level.player.body thread event2_playerbodycarry();
	level.player.linker_object thread event2_playerbodycarry();
	
	level.player.trench_walk = false;
	level.player.body.velocity = 0;
	
	guardToCarry LinkTo(level.player.linker_object, "tag_origin", (0,0,0), (0,0,0));
	
	//Wait till we have killed our guard then Set objective to pickup the guard
	//level.obj_num++;
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_HIDE_GUARD" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, (-1926.5, -4591.0, 301.5) );
	
	level.player.linker_object thread anim_loop(guardToCarry, "carry_idle_guard2");
	level.player.linker_object thread anim_loop(level.player.body, "carry_idle");
	level.player.body Show();
	
	wait(0.05);
	
	level.player PlayerLinkTo(level.player.body, "tag_camera", 0.75, 0, 0, 0, 0);
	
	wait( 1.0 );

	//Wait till the player has hidden the body
	while( !flag("PLAYER_HIDES_BODY") )
	{
		stick = level.player GetNormalizedMovement();
		//IPrintLn("Stick X: " + stick[0] + " Stick Y: " + stick[1]);

		if (stick[0] > 0.5)
		{
			if (!level.player.trench_walk)
			{
				level.player.linker_object thread anim_loop(guardToCarry, "carry_walk_guard2");
				level.player.linker_object thread anim_loop(level.player.body, "carry_walk");
				level.player.trench_walk = true;
			}
			else
			{
				angles = level.player.linker_object.angles;
				forward = AnglesToForward(angles);
				//level.player.linker_object.origin = level.player.linker_object.origin + (forward * 64 * 0.05);
				//level.player.linker_object.origin = level.player.linker_object.origin + (forward * 64 * 1.5 * 0.05);
				
				//-- keep you from hitting Woods
				
				dist_between = Distance2DSquared( level.woods.origin, level.player.linker_object.origin );
				
				if(  dist_between > 200*200 )
				{
					speed_multiplier = 1.5;
				}
				else if(  dist_between > 120*120 )
				{
					speed_multiplier = 1.2;
				}
				else if( dist_between > 90*90)
				{
					speed_multiplier = 0.85;
				}
				else
				{
					speed_multiplier = 0.65;
				}
				
				level.player.linker_object.origin = level.player.linker_object.origin + (forward * 64 * speed_multiplier * 0.05);
			}
			//excessive rumble
			//level.player PlayRumbleOnEntity( "damage_light" );
		}
		else
		{
			if(level.player.trench_walk)
			{
				level.player.linker_object thread anim_loop(guardToCarry, "carry_idle_guard2");
				level.player.linker_object thread anim_loop(level.player.body, "carry_idle");
				level.player.trench_walk = false;
			}
		}

		wait(0.05);
	}
	
	//carry_drop
	//level.player.body SetAnim("carry_drop", 1, 0.1, 1);
	level.player.linker_object thread anim_single(guardToCarry, "carry_drop_guard2");
	level.player.linker_object thread anim_single(level.player.body, "carry_drop");
				
	wait( 0.5 );

	wait(2);
	
	level.player UnLink();
	
	level.player.linker_object notify( "carry_finished" );
	level.player.linker_object Delete();
	
	level.player EnableWeapons();
	level.player.body delete();
}


watch_for_body_dump()
{
	level endon( "PLAYER_HIDES_BODY" );
	
	level thread watch_for_woods_through_tarp();
	
	level.hide_body_trigger trigger_on();
	level.hide_body_trigger waittill( "trigger" ); 
	level.hide_body_trigger Delete();
	flag_set( "PLAYER_HIDES_BODY" );
}

watch_for_woods_through_tarp()
{
	level endon( "PLAYER_HIDES_BODY" );
	
	level waittill( "hide_body_tarp_start" );
	if(Distance2DSquared(level.woods.origin, level.player.origin) < 64*64 )
	{
		flag_set( "PLAYER_HIDES_BODY" );
	}
}

event2_BodyDump()
{
/*
 Once they are down, Woods VO: �Let�s get them out of sight and change clothes�
 Woods drags the corpse to the area highlighted above � if cloth covered the entrance, could do an animation of Woods brushing the cloth aside as he enters
 Player needs to drag his one to a nearby point of cover (there is one in direction of arrow)
 NOTE: Bond had some tech where in first person you could drag a body (using rag doll) by grabbing its leg � perhaps use this
 Once Player reaches cover point, fade out
*/

	debug_event( "event2_BodyDump", "start" );
	
	//Wait till the player goes over to the 
	
	level thread watch_for_body_dump();
	flag_wait( "PLAYER_HIDES_BODY" );
	
	maps\_contextual_melee::contextual_melee_show_hintstring( true );
	maps\_contextual_melee::contextual_melee_allow_fire_button( false );
	
	

	start_movie_scene();
	add_scene_line(&"flashpoint_vox_fla1_s01_800A_inte", 1.5, 4);		//Was saving Weaver more important to you than your objective to kill Dragovich?
	add_scene_line(&"flashpoint_vox_fla1_s01_802A_maso", 5.5, 4);		//Weaver was Russian. But he was alright.	
	//Queue up the movie to play
	level.movie_trans_in = "white";
	level.movie_trans_out = "black";
	level thread play_movie("mid_flashpoint_1", false, false, "movie_start", true, "movie_end", 3);
	
	debug_script( "HIT HIDE BODIES TRIGGER" );
	Objective_State ( level.obj_num, "done" );
	Objective_Set3D( level.obj_num, false );
	level.obj_num--;
	
	//Remove the guards that we stealth killed
//	level.dumpguard1 Delete();
//	level.dumpguard2 Delete();

//	level.dumpguard1.animname = "guard1";
//	level.dumpguard2.animname = "guard2";
	
	wait( 0.5 );
	level.player FreezeControls(true);
	level thread fade_in_black( 2, 2, true, true );
	
	SetSavedDvar("r_streamFreezeState",1);
	
	wait 2;
	
	level notify( "movie_start" );
	
	//Movie is playing
	
	level waittill( "movie_end" );
	SetSavedDvar("r_streamFreezeState",0);
	
	wait( 2.0 );
	
	//Delete woods and spawn "woods_undercover"
	level.woods Delete();
	
	if( isdefined(level.dumpguard1) )
	{
		level.dumpguard1 Delete();
	}
	if( isdefined(level.dumpguard2) )
	{
		level.dumpguard2 Delete();
	}
	
	woods_at_dogs = getnode( "woods_at_dogs", "targetname" );
	maps\flashpoint::spawn_woods_undercover( woods_at_dogs, true );
	
	player_at_dogs = getnode( "player_at_dogs", "targetname" );
	level.player setorigin( player_at_dogs.origin );
	level.player setplayerangles( player_at_dogs.angles );

	level.player AllowStand( true );
	level.player AllowSprint( true );
	level.player AllowJump( true );
	level.player SetStance( "stand" );
	level.player enableweapons();
	
	//wait( 2.0 );
	
	debug_event( "event2_BodyDump", "end" );
	
	//Goto next event
	flag_set("BEGIN_EVENT3");
}


////////////////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////////////////
