////////////////////////////////////////////////////////////////////////////////////////////
// FLASHPOINT LEVEL SCRIPTS
//
//
// Script for event 6 - this covers the following scenes from the design:
//		Slides 34-38
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
#include maps\_audio;
#include maps\_vehicle_aianim;


////////////////////////////////////////////////////////////////////////////////////////////
// EVENT6 FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////


// check_for_fail( sec_to_wait )
// {
// 	level endon( "HIT_TARGET" );
// 	wait( sec_to_wait );
// 	
// 	//FAIL......
// 	//playVO( "MISS!!!!!!!!!!!!", "Woods" );
// 	
// 	SetDvar( "ui_deadquote", &"FLASHPOINT_DEAD_WEAVER_DEAD" ); 
// 	MissionFailed();
// }

player_looking_at_target()
{
	//zipline_endpoint_struct = GetStruct( "zipline_endpoint", "targetname" );
	
	
	//Figure out which way the player is facing
	playerAngles = level.player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );
		
	enemyPos = level.crossbow_target_pt.origin;//zipline_endpoint_struct.origin;
	playerPos = level.player GetOrigin();//GetCameraPos();
	playerPos = playerPos + (0.0,0.0,60.0);
	playerToEnemyVec = enemyPos - playerPos;
	playerToEnemyUnitVec = VectorNormalize( playerToEnemyVec );
	
	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToEnemyUnitVec );
	angleFromCenter = ACos( forwardDotBanzai ); 
		
	println( "Enemy is " + angleFromCenter + " degrees from straight ahead." );

	playerCanSeeMe = ( angleFromCenter <= 4.0 );
	
	return playerCanSeeMe;
}

// check_for_weaponfire()
// {
// 	level endon( "HIT_TARGET" ); 
// 	
// 	//Wait till we fire the cross bow
// 	self waittill ( "missile_fire", missile, weapon_name );
// 	
// 	//Then check for hitting the target within X Sec)
// // 	self thread check_for_fail( 1.0 );
// // 	
// // 	crossbow_target_trigger = getent( "crossbow_target_trigger", "targetname" );
// // 	crossbow_target_trigger waittill( "damage" );
// 	
// 	//playVO( "HIT!!!!!!!!!!!!", "Woods" );
// 	flag_set( "HIT_TARGET" );
// 
// }

check_for_targethit()
{
	level endon( "HIT_TARGET" ); 
	//level thread check_for_weaponfire();
	
	//Only allow us to fire the cross bow if we are looking at the target
 	while( 1 )
 	{
 		if( player_looking_at_target() == true )
 		{
 			//Allow shot
 			level.player EnableWeaponFire();	
 		}
 		else
 		{
 			//Disallow shot
 			level.player DisableWeaponFire();
 		}
 		wait( 0.05 );
 	}
}


create_crossbow_rope()
{
	level endon( "ROPE_READY" );
	
	self thread check_for_targethit();
	
	while( 1 )
	{		
		self waittill ( "missile_fire", missile, weapon_name );
		
		
// 		//Check for success/fail (all good for now)
 		flag_set( "HIT_TARGET" );
		
		
		//kevin adding sound call
		self thread maps\flashpoint_amb::rope_gun();
		
 		//zipline_endpoint_struct = GetStruct( "zipline_endpoint", "targetname" );
 		
 		zipline_endpoint_struct = GetStruct( "zipline_endpoint_gfx", "targetname" );
		
		
		zipline_startpoint_struct = GetStruct( "zipline_startpoint", "targetname" );

		len = length( zipline_startpoint_struct.origin - zipline_endpoint_struct.origin );
 		
		level.zipline_ropeid = createrope( zipline_startpoint_struct.origin, ( 0, 0, 0 ), len * 0.9, missile );
		
		missile waittill( "death" );	

		self disableweapons();
		
		//Check for success/fail (all good for now)
		//flag_wait( "HIT_TARGET" );
		RopeAddWorldAnchor( level.zipline_ropeid, 1.0, zipline_endpoint_struct.origin );
		
		
		flag_set( "ROPE_READY" );
		weaver_window_blocker = getent( "weaver_window_blocker", "targetname" );
		weaver_window_blocker NotSolid();
	}
}

getwoodsoutside()
{
	//Teleport woods to the bottom of the comms building
	node_woods_comms_start = getnode( "node_woods_comms_start", "targetname" );
	woods_zipline_attack = getnode( "woods_zipline_attack", "targetname" );
	level.woods StopAnimScripted();
	level.woods forceTeleport( node_woods_comms_start.origin );
	level.woods SetGoalPos( node_woods_comms_start.origin );
	level.woods.ignoreall = false;
	wait( 1.0 );
	level.woods setgoalnode( woods_zipline_attack );
}

do_player_hookup( node )
{
	//trucks = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath(36);
	//trucks = maps\_vehicle::scripted_spawn( 36 );
	
	//spawn the player body
	self.body = spawn_anim_model( "player_body", node.origin );
	self.body Hide();
	/# recordEnt( self.body ); #/
	node anim_first_frame(self.body, "zipline_hookup");
	
	self.body Attach("anim_rus_zipline_hook", "TAG_WEAPON");
	node thread anim_single_aligned( self.body, "zipline_hookup" );

	self StartCameraTween(2.0);
	
	self PlayerLinktoAbsolute(self.body, "tag_player");
	wait(1.5);
	anim_length = GetAnimLength( level.scr_anim[ "player_body" ][ "zipline_hookup" ] );
	self.body Show();
	level notify( "wnd_guard_in_pos" );
	
	wait( anim_length - 1.5 - 0.1 ); //-- anim time minus wait(1.5) minus blendtime
	//node waittill("zipline_hookup");
	
	level.woods thread anim_single( level.woods, "go_go_go" );

    //level.woods thread playVO_proper( "behindya", .0 );			//I'm right behind ya!
	//level.woods thread playVO_proper( "gogo", 0.0 );				//Go! GO!
	   
	level thread getwoodsoutside();
}

player_gets_weapons_back()
{
	//self setviewmodel(level.player_viewmodel);
	level.player_viewmodel = "t5_gfl_ump45_viewmodel";
	level.player setviewmodel( level.player_viewmodel );
	self enableweapons();
	self AllowAds(true);
	self SetLowReady(false);
	self AllowJump( true );
}

damage_everything()
{
	struct_targs = getstructarray( "weaver_rescue_damage_pt", "targetname" );
	wait( 0.5 );
	for (i = 0; i < struct_targs.size; i++)
	{
		radiusDamage(struct_targs[i].origin, 128, 100, 50);
		wait( 0.05 );
	}
}

wait_for_window_hit()
{
	//zipline_window_hit = getent( "zipline_window_hit", "targetname" );
	zipline_window_hit = getent( "zipline_windowtrigger", "targetname" );
	damageOrigin = zipline_window_hit.origin;
	zipline_window_hit waittill( "trigger" );
	

	
	flag_set( "window_breached" );
	//SetSavedDvar( "hud_drawhud", 1 );
	level.weaver.ignoreme = false;
	level.player.ignoreMe = false;
	
	level thread damage_everything();
	
	self thread breach_rumble();
	
	level thread check_for_weaver_damage();
	
// 	if(level.demo)
// 	{
// 		return;
// 	}
	
	if( isdefined( level.zipline_room_guard_01 ) )
	{
		level.zipline_room_guard_01.ignoreall = false;
		level.zipline_room_guard_01.allowDeath = true;
		level.zipline_room_guard_01.favoriteenemy = level.player;
		//level.zipline_room_guard_01 thread shoot_and_kill( level.weaver, 5.0 );
	}
	if( isdefined( level.zipline_room_guard_02 ) )
	{
		level.zipline_room_guard_02.ignoreall = false;
		level.zipline_room_guard_02.allowDeath = true;
		level.zipline_room_guard_02.favoriteenemy = level.player;
		//level.zipline_room_guard_02 thread shoot_and_kill( level.weaver, 3.0 );
	}
	if( isdefined( level.zipline_room_guard_03 ) )
	{
		level.zipline_room_guard_03.ignoreall = false;
		level.zipline_room_guard_03.allowDeath = true;
		level.zipline_room_guard_03.favoriteenemy = level.player;
		//level.zipline_room_guard_03 thread shoot_and_kill( level.weaver, 8.0 );
	}
	
	//level.player player_gets_weapons_back(); //-- moved to where the player actually plays the breach animation
	
	//Do damage on window - kill guard behind it
	//level.zipline_room_guard_01 Die();
}

breach_rumble()
{
	self PlayRumbleOnEntity("damage_light");
	
	wait(0.3);
	
	self PlayRumbleOnEntity("damage_heavy");
}


enable_breach_weapon()
{
	// so that it looks like the player is firing with one hand while breaching ;)
	wait(0.4);
	//self give_weapons(); //-- utility to give back weapons;
	self EnableWeapons();
	self setviewmodel("viewmodel_hands_no_model");
	self ShowViewModel();
	//self TakeWeapon( "crossbow_vzoom_alt_sp" );
}

do_player_zipline( node )
{
	
	//TUEY SET music state to WINDOW BREACH
	setmusicstate("WINDOW_BREACH");
	
	zipline_endpoint_struct = GetStruct( "zipline_endpoint", "targetname" );
	zipline_startpoint_struct = GetStruct( "zipline_startpoint", "targetname" );
	ziplineVecTo = vectorNormalize( zipline_endpoint_struct.origin - zipline_startpoint_struct.origin );
	
	self.player_zipline_2hands			= level.scr_anim["player_body"]["player_zipline_2hands"][0];
	self.player_zipline_1hand			= level.scr_anim["player_body"]["player_zipline_1hand"][0];
	self.player_zipline_crashwindow		= level.scr_anim["player_body"]["player_zipline_crashwindow"];
	
	//level.player thread refill_ammo();
	
	//node waittill("zipline_hookup"); //-- wait for the hookup animation to finish
	
	//self StartCameraTween(0.2);
	self PlayerLinktoDelta(self.body, "tag_player", 1, 15, 15, 0, 20 );
	//self PlayerLinkToAbsolute( self.body, "tag_player");
	
	//self DisableInvulnerability();
	self EnableInvulnerability();
	self AllowAds( false );
	self thread breach_rumble();
	
	level.player AllowMelee( false );

	//set the idle anim

	//self.body thread anim_loop(self.body, "player_zipline_2hands");
	//self thread delayed_sound_play_thread("evt_rappel_idle", 0.5 );
	//self PlayLoopSound("evt_rappel_idle");
	
	linkto_ent = Spawn("script_model", self.body.origin);
	linkto_ent SetModel("tag_origin");
	linkto_ent.angles = self.body.angles;
		
	// Not sure why but this fixes my initial "sticking" problem. 
	//self.body StopAnimScripted();
//	linkto_ent anim_first_frame( self.body, "player_zipline_2hands" );

	//self.body SetAnim( self.player_zipline_2hands, 1, 0.3);
		
	linkto_ent thread anim_loop( self.body, "player_zipline_2hands" );
	
	//-- the endpoint of the struct is the position of the animation
	anim_struct = get_anim_struct("11");
	//anim_struct = GetStruct( "zipline_startpoint", "targetname" );
	breach_anim_start_point = GetStartOrigin( anim_struct.origin, anim_struct.angles, level.scr_anim[ self.body.animname ][ "player_zipline_crashwindow" ]);
	wait(0.05);
	self.body LinkTo(linkto_ent, "tag_origin");
	
	//self thread movePlayerDownZipLine( zipline_startpoint_struct.origin, zipline_endpoint_struct.origin, ziplineVecTo, linkto_ent );
	self thread movePlayerDownZipLine_beta( zipline_startpoint_struct.origin, breach_anim_start_point, ziplineVecTo, linkto_ent );
 	self thread player_zipline_windfx(0.5);
 	//kevin adding zipline audio
 	self thread maps\flashpoint_amb::zipline();
	
	level thread breach_slowmo();
	self thread wait_for_window_hit();
 	
 	
 	//wait until we hit the weapons free trigger
 	/*
	zipline_allowgun_trig = getent( "zipline_allowgun", "targetname" );
	zipline_allowgun_trig waittill( "trigger" );
	*/
	
	
	level.player thread lerp_fov_over_time( 2.0, 75 );
	wait(0.15);
	

	
	//Hide right arm and show view arms with gun
	//self.body ClearAnim(self.player_zipline_2hands, 0.3);
	//self.body SetAnim( self.player_zipline_1hand, 1 );
	self.body anim_set_blend_in_time(0.4);
	self.body anim_set_blend_out_time(0.4);
	linkto_ent thread anim_loop( self.body, "player_zipline_1hand" );
	//self.body Show();
	self thread enable_breach_weapon();
	//level.player thread refill_ammo();
	
	level.brooks setgoalnode( getnode( "lewis_breachroom_start", "targetname" ) );
	level.bowman setgoalnode( getnode( "hudson_breachroom_start", "targetname" ) );
	
	//wait until we hit the weapons free trigger
	
	//zipline_windowtrigger = getent( "zipline_windowtrigger", "targetname" );
	//zipline_windowtrigger waittill( "trigger" );
	
	
	
	//Keep going until we hit the inside building trigger
	
	//self.body anim_single( self.body, "player_zipline_crashwindow" );
	//flag_wait( "window_breached" );
	
	level thread break_zipline_window();
	
	//self.body ClearAnim(self.player_zipline_1hand, 0.2);
	//self.body SetFlaggedAnim( "window_crash_anim", self.player_zipline_crashwindow, 1, 0.2, 1.0 );
	//self.body waittill( "window_crash_anim" );
	
	self.new_body = spawn_anim_model("player_body", breach_anim_start_point);
	anim_struct anim_first_frame( self.new_body, "player_zipline_crashwindow");
	/# recordEnt( self.new_body ); #/
	self.new_body Hide();
	
	level.player waittill("at_bottom_of_zipline");
		
	//level.player SetLowReady( true );
	level.player notify("stop_wind_fx");
		
	//self.body Unlink();
	//anim_node = get_anim_struct("11");
	//level.player StartCameraTween(0.05);
	level.player PlayerLinktoDelta(self.new_body, "tag_player", 1, 25, 25, 30, 30 );
	//level.player PlayerLinkToAbsolute(self.new_body, "tag_player");
	//self.body SetAnimRateComplete( 0.2 );
	self.body Detach("anim_rus_zipline_hook", "TAG_WEAPON");
	
	level.player thread lerp_fov_over_time( 1.0, 65 );
	self.new_body SetAnimRateComplete(2.0);
	level notify("breach_anim_started");
	anim_struct thread anim_single_aligned( self.new_body, "player_zipline_crashwindow" );
	self.body Hide();
	self.new_body Show();
	level thread zipline_return_weapon();
	wait(0.05);
	//level thread zipline_look_at_target();
	anim_struct waittill("player_zipline_crashwindow");
	//self.body SetAnimRateComplete( 1 );
	
	//self.body ClearAnim(self.player_zipline_crashwindow, 0.2);
		
	//wait until we hit the weapons free trigger
	/*
	zipline_inbuilding = getent( "zipline_inbuilding", "targetname" );
	zipline_inbuilding waittill( "trigger" );
	*/
	
	self.new_body Hide();
	
	self DisableInvulnerability();
	
	flag_set( "END_OF_ROPE" );
	weaver_window_blocker = getent( "weaver_window_blocker", "targetname" );
	weaver_window_blocker Solid();
		
	level notify("set_weaverbuilding_fog");
	
	//wait(0.3);
	//level.player player_gets_weapons_back();
}

zipline_return_weapon()
{
	level waittill( "raise_gun" );
	level.player player_gets_weapons_back();
}

zipline_look_at_target()
{
	//level.player ClearViewLockEnt();
	//level.player.player_lookat_ent Delete();
	
	player_lookat_ent = Spawn("script_model", (0,0,0) );
	player_lookat_ent SetModel("tag_origin");
	
	player_lookat_ent LinkTo( level.zipline_room_guard_02, "J_SpineUpper", (0,0,0), (0,0,0) );
	
	wait(0.1);
	level.player SetViewLockEnt( player_lookat_ent );
	
	flag_wait( "END_OF_ROPE" );
	level.player ClearViewLockEnt();
}

zipline_look_at_window()
{
	level.player.player_lookat_ent = Spawn("script_model", (0,0,0) );
	level.player.player_lookat_ent SetModel("tag_origin");
	level.player.player_lookat_ent.origin = GetEnt("breach_window_solid_1", "targetname").origin + (0,0,16);
	wait(.1);
	level.player SetViewLockEnt( level.player.player_lookat_ent );
}

delayed_sound_play_thread( alias, time )
{
	wait(time);
	self PlayLoopSound(alias);
}

player_zipline_windfx( time ) // self == player
{
	wait(time);
	
	fx_ent = Spawn("script_model", self get_eye());
	fx_ent SetModel("tag_origin");
	fx_ent.angles = self.angles;
	
	AssertEX( IsDefined(self.body), "Trying to play the wind fx on a player with no body" );
	fx_ent LinkTo( self.body );
	
	PlayFXOnTag(level._effect["zipline_whoosh"], fx_ent, "tag_origin");
	
	self waittill("stop_wind_fx");
	fx_ent Delete();
}

break_zipline_window()
{
	//trigger_wait("zipline_window_hit");
	level waittill("break_breach_window");
	exploder(601);
	
	//TODO: change this, but it temporarily deletes all the axis AI that aren't room guards.
	//level thread delete_axis_ai_during_weaver_scene();
}

delete_axis_ai_during_weaver_scene()
{
	ai_array = GetAIArray( "axis" );
	
	for(i = ai_array.size - 1; i >= 0; i-- )
	{
		if( IsDefined(ai_array[i].targetname) && !IsSubStr( ai_array[i].targetname, "zipline_room_guard" ) )
		{
			ai_array[i] Delete();
		}
	}
}

walkrope( ropeid )
{
	frac = 0;
	step = 0.01;
	
	while( 1 )
	{
		frac = frac + step;
		
		if( frac > 1 ) 
		{
			frac = 1;
			step = -0.01;
		}
		if( frac < 0 )
		{
			frac = 0;
			step = 0.01;
		}
	
		pos = ropegetposition( ropeid, frac );
		debugstar( pos, 10, ( 1, 1, 1 ) );
		
		wait .1;
	}
}

movePlayerDownZipLine_beta( startPoint, endpoint, direction, linkto_ent )
{
	level.player_zipline_time = 3.5;
	linkto_ent MoveTo(endpoint, level.player_zipline_time, 2.25, 0);
	linkto_ent endon("movedone");
	self thread notify_zip_end_when_move_done( linkto_ent, "at_bottom_of_zipline" );
}

movePlayerDownZipLine( startPoint, endpoint, direction, linkto_ent )
{
	//level endon( "END_OF_ROPE" );
		
	delta = 0.05;
	
	/*
	acceleration = 230.0;
	mass = 1.0;
	linkto_ent.origin_straightline = linkto_ent.origin;
	prevPos = linkto_ent.origin;
	*/
	
	startPoint = startPoint - vector_multiply(direction, 2.0); //push the start point back a little
	total_rope_length = length(endpoint - startPoint);
	
	
	//-- TODO: remember to delete this script origin later
	level.player_zipline_time = 10;
	moveto_ent = spawn( "script_origin", startPoint );
	moveto_ent MoveTo(endpoint, level.player_zipline_time, 3, 0);
	moveto_ent endon("movedone");
	self thread notify_zip_end_when_move_done( moveto_ent, "at_bottom_of_zipline" );
	

 	//Slide down rope
 	while( isdefined(self.body) )
 	{	
 		/*
 		//Verlet integration method
		temp = linkto_ent.origin_straightline;
		
		//Verlet integration method
		acceleration_vec = vector_multiply( direction, acceleration );
		
		new_pos_vec = vector_multiply( ((linkto_ent.origin_straightline - prevPos) + (vector_multiply(acceleration_vec, delta*delta))) , mass );
		*/
		
		/*
		new_pos_vec_length = Length(new_pos_vec);
		//iprintlnbold(new_pos_vec_length);
		*/
		
		/*
		linkto_ent.origin_straightline += new_pos_vec;
		
		prevPos=temp;	
		*/
		
		//Calculate current distance along rope
		//current_distance = (temp - startPoint);
		current_distance = (moveto_ent.origin - startPoint);
		
		//Calculate percentage
		percentage_along_rope = length(current_distance / total_rope_length);
		
		if( percentage_along_rope > 1 ) 
		{
			percentage_along_rope = 1;
		}
		if( percentage_along_rope < 0 )
		{
			percentage_along_rope = 0;
		}
		pos = ropegetposition( level.zipline_ropeid , percentage_along_rope );
		pos += (0, -11, -95);
		//debugstar( pos, 10, ( 1, 1, 1 ) );
		
		//self.body.origin = pos;
		linkto_ent.origin = pos;
		
		//self.body.origin = ( self.body.origin_straightline[0], self.body.origin_straightline[1], origin_straightline[2] );
		//self.body.origin = self.body.origin_straightline;
		//debugstar( self.body.origin_straightline, 10, ( 1, 1, 0 ) );
		//self.body.origin[2] = pos[2];
	
 		wait( delta ); 
 	}
}

notify_zip_end_when_move_done( moveto_ent, msg )
{
	moveto_ent waittill("movedone");
	self notify(msg);
}

cleanup_afterzipline()
{
	self endon( "death" );
	flag_wait( "CLEANUP_BASE_AFTER_ZIPLINE" );
	self Delete();
}


zipline_guard_takes_damage()
{
	self endon("death");
	
	//Not very strong......
	while( 1 )
	{
		self waittill( "damage", amount, attacker );
		
		if( attacker == level.player )
		{
			self Die();
		}
	}
}

setup_zipline_guard()
{
	self endon("death");
	
	//self.dofiringdeath = false;
	self.goalradius = 32;
	self.ignoreall = false;
	self.dropweapon = false;
	self.animname = "zipline_guard";
	
	self thread cleanup_afterzipline();
	self thread zipline_guard_takes_damage();
}

setup_zipline_room_guard()
{
	self endon("death");
	
	//self.dofiringdeath = false;
	self.goalradius = 32;
	self.ignoreall = true;
	//self.dropweapon = false;
	self.animname = "zipline_guard";
	self.allowDeath = true;
	
	//self thread cleanup_afterzipline();
	
	wait(0.1);
		
	if(self.targetname == "zipline_room_guard_01_ai")
	{
		/*
		goal_node = GetNode( self.target, "targetname" );
		self SetGoalPos( goal_node.origin, goal_node.angles );
		*/
		anim_node = get_anim_struct( "11" );	
		anim_node anim_reach_aligned( self, "weaver_breach_wait1" );
	}
	else if(self.targetname == "zipline_room_guard_02_ai")
	{
		anim_node = get_anim_struct( "11" );	
		//self gun_switchto( "makarov_sp", "right");
		anim_node anim_reach_aligned( self, "weaver_breach_wait2" );
	}
}

cleanup_vehicles_afterzipline()
{
	//Clean up all vehicles
	vehicles = GetEntArray("script_vehicle", "classname");
	for(i = vehicles.size - 1; i >= 0; i--)
	{
		vehicles[i] Delete();
	}
	
	//Clean up all vehicle corpses
	vehicle_corpse = GetEntArray("script_vehicle_corpse", "classname");
	for(i = vehicle_corpse.size - 1; i >= 0; i--)
	{
		vehicle_corpse[i] Delete();
	}
}

cleanup_sm_afterzipline()
{
	self endon( "death" );
	flag_wait( "CLEANUP_BASE_AFTER_ZIPLINE" );
	spawn_manager_disable( "zipline_spawn_mgr" );
	//spawn_manager_disable( "zipline_2_spawn_mgr" );
	kill_aigroup( "zipline_enemy_ai" );

	//Clean up prev AI
	ai_array = GetAIArray( "axis" );
	for(i = ai_array.size - 1; i >= 0; i-- )
	{	
		ai_array[i] Die();
	}
}


truck_destructionFX()
{
	self.takedamage = 1;
//	self physicslaunch( self.origin + (200,0,0), (0, 0, 400) );
	self DoDamage( self.health + 1000, self.origin );
	playfx( level._effect["vehicle_explosion"], self.origin );
	playsoundatposition( "exp_veh_large", self.origin );
	earthquake( 0.6, 1, level.player.origin,  500 );
	level.player PlayRumbleOnEntity( "damage_light");
	
	 //Take out the truck - take out the riders!!!!!!
	if( isdefined( self.script_vehicleride ) )
	{
		ai_for_truck = self vehicle_get_riders();
		for( i=0; i<ai_for_truck.size; i++ )
		{
			if( isdefined(ai_for_truck[i]) && isalive(ai_for_truck[i]) )
			{
				ai_for_truck[i] Die();
			}
		}
	}
	
	
	self notify ("death");
	//self vehicle_detachfrompath();
	
	wait( 2.0 );
 
 	spot = spawn ("script_model", self.origin);
 	spot setmodel("tag_origin");
 	//playfxontag(level._effect["fx_fire_sm_fuel"], spot, "tag_origin");	
}

wait_for_explosive_bolt_damage()
{	
	level endon( "CLEANUP_BASE_AFTER_ZIPLINE" );
	self.isdestroyed = false;
	while( 1 )
	{
		//self waittill( "damage" );//, damage, attacker, direction, point, method );
		self waittill( "damage", amount, attacker, direction, point, method );
		
		//Check we were holding the correct weapon
		activeWeapon = level.player GetCurrentWeapon();
	
		if( method == "MOD_IMPACT" && (activeWeapon == "crossbow_explosive_alt_sp") )
		{
			self.isdestroyed = true;
			wait( 1.5 );
			truck_destructionFX();
		}
		
		if( method == "MOD_GRENADE" || method == "MOD_GRENADE_SPLASH" )
		{
			self.isdestroyed = true;
			truck_destructionFX();
		}
	}
}


init_courtyard_gunner_truck( truck )
{
	//truck thread go_path( GetVehicleNode(truck.target,"targetname") );
	truck veh_magic_bullet_shield( 1 );

	level.truck_driver = simple_spawn_single ("gunner_truck_driver", ::init_truck_driver, truck );
	level.courtyard_gunner = simple_spawn_single ("courtyard_gunner", ::courtyard_gunner_think, truck);
	level.courtyard_gunner thread monitor_gunner_death( truck );

	gunner_start_firing_node = GetVehicleNode( "gunner_start_firing_node", "script_noteworthy" ); 
	gunner_start_firing_node waittill( "trigger" );

	truck waittill( "reached_end_node" );
	flag_set( "start_gunner_fire" );

	truck veh_magic_bullet_shield( 0 );
	truck.health = 400;
}

init_truck_driver( truck ) //self = ai_gunner 
{
	self endon( "death" );

	//self gun_remove();
	self.goalradius = 64;
	self.ignoreme = true;
	self.ignoreall = true;
	self.animname = "generic";
	self.truck = truck;
	//self thread Print3d_on_ent("aiming at player");
	self maps\_vehicle_aianim::vehicle_enter(truck, "tag_driver" ); 
}


courtyard_gunner_think( truck ) //self = ai_gunner 
{
	self endon( "death" );

	self gun_remove();
	self.ignoreme = true;
	self.ignoreall = true;
	self.animname = "generic";
	self.truck = truck;
	//self thread Print3d_on_ent("aiming at player");
	self maps\_vehicle_aianim::vehicle_enter(truck, "tag_gunner1" );

	//player = get_players()[0];
	//self.truck SetGunnerTargetEnt(player, (RandomIntRange(-50, 50), RandomIntRange(-50, 50), RandomIntRange(-50, 50)));

	flag_wait( "start_gunner_fire" );

	self.truck ClearTurretTarget(); 		
	//self.truck thread gunner_direct_fire_at_player(); 
	self.truck thread fire_at_targets( "zipline_targets" );
}


monitor_gunner_death( truck )
{
	self.truck = truck;
	self waittill( "death" );

	self.truck ClearGunnerTarget();
	self.truck notify("gunner_dead");
}

delete_gunner_sound_ent( ent )
{
    self waittill_any( "death", "gunner_dead" );
    ent Delete();
}


fire_at_targets( targets_name ) //self == btr
{
	self notify("stop_firing_at_targets");
	self endon( "stop_firing_at_targets" );
	self endon("gunner_dead");
	self endon( "death" );
	
	sound_ent = Spawn( "script_origin", self.origin );
	sound_ent LinkTo( self, "rear_hatch_jnt" );
	self thread delete_gunner_sound_ent( sound_ent );
	
	targets = getstructarray( targets_name,"targetname" );
	
	wait_time = RandomIntRange( 1, 2);
	bullet_count = RandomInt( 10, 20 );

	for( i=0; i < targets.size; i++ )
	{
		current_target = targets[RandomInt(targets.size)];

		self setGunnerTargetVec( current_target.origin );

		for(i = 0; i < bullet_count; i++)
		{
			self waittill_notify_or_timeout("gunner_turret_on_target", 2 );
			sound_ent PlayLoopSound( "wpn_50cal_fire_loop_npc" );
			self fireGunnerWeapon();
			wait (0.2);
			sound_ent StopLoopSound( .1 );
			self PlaySound( "wpn_50cal_fire_loop_ring_npc" );
		}
		wait( wait_time );
	}
}

gunner_direct_fire_at_player()
{
	self endon("death");
	self endon("gunner_dead");

	clip = 30;
	
	self SetGunnerTurretOnTargetRange( 0, 50 );
	
	player = level.player;
	
	while(IsDefined(player))
	{
		for(i=0; i<clip; i++)
		{
			if (IsDefined(player))
			{
				self SetGunnerTargetEnt(player, (RandomIntRange(-50, 50), RandomIntRange(-50, 50), RandomIntRange(-50, 50)));
				self waittill_notify_or_timeout("gunner_turret_on_target", 0.25);
				self fireGunnerWeapon();
				wait(0.1);
			}
		}
		wait(RandomFloatRange(2.5, 3.0));
	}
}


check_for_death()
{
	level endon( "BOWMAN_BROOKS_RESCUED" );
	level endon( "BOWMAN_BROOKS_MOVE_FWD" );

	self waittill_any( "death", "death_finished" );
	
	level.brooks thread stop_magic_bullet_shield();
	level.bowman thread stop_magic_bullet_shield();
	level.brooks Die();
	level.bowman Die();
	
	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_BROOKS_BOWMAN");	
}

spawnExplosiveBoltFriendlyCover()
{
	//Spawn vehicles
	level.bowman_brooks_cover_truck = maps\_vehicle::spawn_vehicles_from_targetname( "bowman_brooks_cover" )[0];
}


check_for_ai_being_killed( ai_targetname )
{
	self endon( "kill_this_thread" );
	
	//ai_for_truck = getentarray( ai_targetname, "targetname" );
	
	if( isdefined( self.script_vehicleride ) )
	{
		ai_for_truck = self vehicle_get_riders();

		while( 1 )
		{
			alldead = true;
			for( i=0; i<ai_for_truck.size; i++ )
			{
				if( isdefined(ai_for_truck[i]) && isalive(ai_for_truck[i]) )
				{
					alldead = false;
				}
			}
			
			if( alldead==true )
			{
				//Don't need to blow up truck if you kill all the AI
				self.isdestroyed = true;
				self notify( "kill_this_thread" );
			}
			wait( 0.1 );
		}
	}
}

spawnExplosiveBoltEnemies()
{
	//spawn_manager_enable( "zipline_spawn_mgr" );
	//spawn_manager_enable( "zipline_2_spawn_mgr" );
	
	//Spawn vehicles
	zipline_truck1_start = GetVehicleNode( "zipline_truck1_start", "targetname" );
	level.zipline_truck1 = maps\_vehicle::spawn_vehicles_from_targetname( "zipline_truck1" )[0];
	//level thread init_courtyard_gunner_truck( level.zipline_truck1 );
	level.zipline_truck1 thread wait_for_explosive_bolt_damage();
	level.zipline_truck1 thread check_for_ai_being_killed( "zipline_truck1_ai" );
	level.zipline_truck1 thread maps\_vehicle::getonpath( zipline_truck1_start );

	zipline_truck2_start = GetVehicleNode( "zipline_truck2_start", "targetname" );
	level.zipline_truck2 = maps\_vehicle::spawn_vehicles_from_targetname( "zipline_truck2" )[0];
	level thread init_courtyard_gunner_truck( level.zipline_truck2 );
	level.zipline_truck2 thread wait_for_explosive_bolt_damage();
	//level.zipline_truck2 thread check_for_ai_being_killed( "zipline_truck2_ai" );
	level.zipline_truck2 thread maps\_vehicle::getonpath( zipline_truck2_start );
	
	zipline_truck3_start = GetVehicleNode( "zipline_truck3_start", "targetname" );
 	level.zipline_truck3 = maps\_vehicle::spawn_vehicles_from_targetname( "zipline_truck3" )[0];
 	//level thread init_courtyard_gunner_truck( level.zipline_truck3 );
 	level.zipline_truck3 thread wait_for_explosive_bolt_damage();
 	level.zipline_truck3 thread check_for_ai_being_killed( "zipline_truck3_ai" );
 	level.zipline_truck3 thread maps\_vehicle::getonpath( zipline_truck3_start );
	
	//level.weaver_rescue_truck = getent( "weaver_rescue_truck", "targetname" );
	//level.weaver_rescue_truck thread wait_for_explosive_bolt_damage();
	
	
	flag_wait( "START_TRUCKS" );
	wait( 1.0 );
	level.zipline_truck1 thread maps\_vehicle::gopath();
	wait( 2.0 );
	level.zipline_truck3 thread maps\_vehicle::gopath();
	wait( 5.0 );
	//spawn_manager_enable( "zipline_spawn_mgr" );
	
	flag_wait( "BOWMAN_BROOKS_MOVE_FWD" );
	spawn_manager_enable( "zipline_spawn_mgr" );
	wait( 3.0 );
	level.zipline_truck2 thread maps\_vehicle::gopath();
	
	
	//TRUCK
	//level.woods thread playVO_proper( "truck1", 3.0 );	// That truck! Watch the truck!
	level.woods thread playVO_proper( "truck3", 6.0 ); //Check that MG!
	
// 	level.scr_sound["woods"]["truck1"] = "dds_woo_thrt_lm_truck"; // By the fucking truck!
// 	level.scr_sound["woods"]["truck2"] = "dds_woo_thrt_lm_truck"; // That truck! Watch the truck!
// 	level.scr_sound["woods"]["truck3"] = "dds_woo_thrt_lm_truck"; // Hostiles near that truck!
// 	level.scr_sound["woods"]["mgtruck1"] = "dds_woo_thrt_lm_mg"; // Check that MG!
// 	level.scr_sound["woods"]["mgtruck2"] = "dds_woo_thrt_lm_mg"; // I got one by the MG!	
// 	level.scr_sound["woods"]["mgtruck3"] = "dds_woo_thrt_lm_mg"; // Contacts by the MG!
// 	
	
	//level.zipline_truck3 thread maps\_vehicle::gopath();
}

spawnZipLineGuards()
{
//	spawn_manager_enable( "zipline_spawn_mgr" );
//	spawn_manager_enable( "zipline_2_spawn_mgr" );	
	
	level thread cleanup_sm_afterzipline();
	
	level.zipline_room_guard_01 = simple_spawn_single( "zipline_room_guard_01", ::setup_zipline_room_guard );
	level.zipline_room_guard_02 = simple_spawn_single( "zipline_room_guard_02", ::setup_zipline_room_guard );
	level.zipline_room_guard_03 = simple_spawn_single( "zipline_room_guard_03", ::setup_zipline_room_guard );
	
	level.zipline_room_guard_01 thread magic_bullet_shield();
	level.zipline_room_guard_02 thread magic_bullet_shield();
	level.zipline_room_guard_03 thread magic_bullet_shield();
	
	level.zipline_room_guard_01.animname = "guard1";
	level.zipline_room_guard_02.animname = "guard2";
	
	//Spawn a weaver
	weaver_start = getnode( "weaver_start", "targetname" );
	maps\flashpoint::spawn_weaver( weaver_start, true );
	level.weaver.ignoreme = true;
	
	level notify( "WEAVER_SPAWNED_INSEAT" );
	
	//zipline_room_guard_03 = simple_spawn_single( "zipline_room_guard_03", ::setup_zipline_room_guard );	
}

lerp_player()
{
	mover_ent = spawn( "script_origin", self.origin );
	mover_ent.angles = self.angles;
	self playerlinkto( mover_ent );
	endPoint = self.origin + ( 0.0, 0.0, 20.0 );
	mover_ent moveto( endPoint, 0.5 );
	mover_ent waittill( "movedone" );
	mover_ent Delete();
}


player_grabs_crossbow_anim( anim_node )
{
	flag_wait("PLAYER_BESIDE_WOODS");
	anim_node thread anim_single_aligned( self.body, "make_it_quick_player" );	
}

show_in_xsec( sec_to_wait )
{
	wait( sec_to_wait );
	self Show();
}

player_grabs_crossbow( anim_node )
{
	//spawn the player body
	//self disableweapons();
	
	//level.player take_weapons();
	//level.player disableweapons();
	
//	flag_set( "START_TRUCKS" );
	
	//self.body = spawn_anim_model( "player_body", anim_node.origin );
	//self.body Hide();
	
	flag_wait("PLAYER_BESIDE_WOODS");
	level.player disableweapons();
	self.body Attach("t5_weapon_crossbow_world", "TAG_WEAPON");;
	//anim_node thread anim_single_aligned( self.body, "make_it_quick_player" );
	flag_set( "START_TRUCKS" );
	self StartCameraTween(.3);
	self PlayerLinktoAbsolute(self.body, "tag_player");
	wait(0.05);
	self.body thread show_in_xsec( 0.3 );
	
	level.player maps\flashpoint::give_crossbow_expolsive();
	
	anim_node waittill("make_it_quick_player");
	
	self.body Detach("t5_weapon_crossbow_world", "TAG_WEAPON");
	//level.player enableweapons();
	self Unlink();
	self.body Unlink();
	self.body Delete();
	
	//self player_gets_weapons_back();
	//level.player.zip_currentweapon = level.player GetCurrentWeapon(); 
	
	level.player SetLowReady( false );
	level.player AllowJump( true );
	//level.player maps\flashpoint::give_crossbow_expolsive();
	level.player SwitchToWeapon( "crossbow_explosive_alt_sp" );
	level.player AllowAds(true);
	//level.player AllowMelee( true );

// 	
// 	level.player SwitchToWeapon( "crossbow_explosive_alt_sp" );
// 	level.player GiveMaxAmmo("crossbow_vzoom_alt_sp");
// 	level.player GiveMaxAmmo("crossbow_explosive_alt_sp");
	
	
	//Lerp the player up a little?
	wait( 0.1 );
	level.player lerp_player();
	
	//self give_weapons(); //-- utility to give back weapons;
	
	//level.player enableweapons();
	
// 	level.player SwitchToWeapon( "crossbow_explosive_alt_sp" );
// 	level.player GiveMaxAmmo("crossbow_vzoom_alt_sp");
// 	level.player GiveMaxAmmo("crossbow_explosive_alt_sp");

	level.player enableweapons();
		
	flag_set( "READY_TO_SHOOT" );

	//Objective_State( level.obj_num, "done" );
	Objective_Set3D( level.obj_num, false );  //cancel crossbow location
}

/*
  
	//Explosive crossbow event + zipline
	
	level.woods thread playVO_proper( "holdit", 3.0 ); //Hold it...
	
    level.scr_sound["woods"]["copythat"] = "vox_fla1_s06_108A_wood_m"; //Copy that. We're on our way.
    level.scr_sound["woods"]["breachbuilding"] = "vox_fla1_s06_331A_wood"; //Copy that. Mason gonna breach the building.
    level.scr_sound["woods"]["overhere"] = "vox_fla1_s06_109A_wood_m"; //Mason -  get over here.
    level.scr_sound["woods"]["gunfire"] = "vox_fla1_s06_110A_wood_m"; //Gunfire's drawin' attention.
    level.scr_sound["woods"]["assholes"] = "vox_fla1_s06_111A_wood_m"; //Those assholes are on the way back!
    level.scr_sound["woods"]["secureline"] = "vox_fla1_s06_112A_wood_m"; //I'll secure the line. You take the shot.
    level.scr_sound["woods"]["makeitquick"] = "vox_fla1_s06_113A_wood"; //Make it quick, Mason.
    level.scr_sound["woods"]["buytime"] = "vox_fla1_s06_114A_wood"; //I'll buy us some time.
    level.scr_sound["woods"]["gogo"] = "vox_fla1_s06_115A_wood"; //Go! GO!
    level.scr_sound["woods"]["behindya"] = "vox_fla1_s06_116A_wood"; //I'm right behind ya!
    
*/


woods_crossbow_anims_handover( anim_node )
{
	flag_wait("PLAYER_BESIDE_WOODS");
	
	self AllowedStances( "stand" );

	level.woods.name = "";

	anim_node thread anim_single_aligned( self, "make_it_quick_e" );
	anim_node waittill( "make_it_quick_e" );
	self AllowedStances( "stand", "crouch", "prone" );

	self SetGoalPos( self.origin );
}


woods_crossbow_anims()
{
	//Get woods into the first frame of the anim
	anim_node = get_anim_struct( "10" );
	  
	level.player thread player_crossbow_position( anim_node );
	//level.woods disable_cqbwalk(); //-- just to be sure
	level.woods SetAnimRateComplete(2.0);
	anim_node anim_reach_aligned( self, "make_it_quick_a" );
	level.woods SetAnimRateComplete(1.0);
	
	//level thread spawnExplosiveBoltFriendlyCover();
	level thread spawnExplosiveBoltEnemies();
	
//	level.woods thread playVO_proper( "commsdown", 0.0 );			//Comm links down.
//	level.bowman thread playVO_proper( "xray", 2.0 );				//X-ray come in, over.
//	level.woods thread playVO_proper( "goahead", 3.5 );				//Go ahead, Whiskey.
//	level.bowman thread playVO_proper( "bunkersouth", 4.5 );		//We just got a visual on Weaver... He's been taken to a bunker South of the Comms building.

	level.woods.ignoreall = true;
	
	level.woods thread woods_crossbow_anims_handover( anim_node );
	level.player thread player_grabs_crossbow( anim_node );
	level.player thread player_grabs_crossbow_anim( anim_node );
	
	woods_onroof_point = getnode( "woods_onroof_point", "targetname" );
	obj_point = woods_onroof_point.origin + (0.0, 0.0, 70.0 );

	//Mason get over here
	anim_node thread anim_single_aligned( self, "make_it_quick_a" );
	anim_node waittill( "make_it_quick_a" );
	level.woods thread playVO_proper( "overhere", 0.0 );

	//Woods idles waiting for you to grab crossbow
	anim_node thread anim_loop_aligned( self, "make_it_quick_d" );

	level notify("mason_said_to_get_over_here");
	level.obj_num++;
	Objective_Add(level.obj_num, "current", &"FLASHPOINT_OBJ_PROTECT" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, (-1810.0, 138.0, 890.0 ) );
	flag_wait("READY_TO_SHOOT");

	if(IsDefined(level.bowman_brooks_cover_truck))
	{
		level.bowman_brooks_cover_truck thread check_for_death();
	}
	
	//Woods will move to ladder idle spot and wait
 	anim_node anim_reach_aligned( self, "ladderidle" );
 	anim_node thread anim_loop_aligned( self, "ladderidle" );
}

player_crossbow_position( anim_node )
{
	level waittill("mason_said_to_get_over_here");
	
	anim_start_origin = GetStartOrigin( anim_node.origin, anim_node.angles, level.scr_anim["player_body"]["make_it_quick_player"] );
	radius = 100;
	spawn_position = anim_start_origin - ( 0.0, 0.0, 100.0 );
	//level.takecrossbow = spawn( "trigger_radius", spawn_position, 0, radius, 500 );
	//level.takecrossbow waittill( "trigger" );
 	//level.takecrossbow Delete();
 	
 	take_bow_from_woods = getent( "take_bow_from_woods", "targetname" );
 	take_bow_from_woods waittill( "trigger" );
 	take_bow_from_woods Delete();
 	
 	Objective_Set3D( level.obj_num, false );
 	
 	self SetLowReady(true);
 	self AllowJump( false );
 		
	self.body = spawn_anim_model( "player_body", anim_node.origin );
	self.body Hide();
	anim_node anim_first_frame( self.body, "make_it_quick_player" );
	self StartCameraTween(.2);
	self PlayerLinkToDelta(self.body, "tag_player", 1, 40, 20, 90, 30, false);
 	
 	self EnableInvulnerability();
 	
	flag_set("PLAYER_BESIDE_WOODS");
	
	//helicopters = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath(35);
	//helicopters = maps\_vehicle::scripted_spawn( 35 );
	
	//TUEY Setmusic state to ACQUIRE_CROSSBOW
	setmusicstate("ACQUIRE_CROSSBOW");
}


rescue_weaver_counter_remove_when_done( time_to_help_them )
{
	self endon( "delete" );
	wait( time_to_help_them );
	self destroy();
	self notify ( "removed" );
}

rescue_weaver_counter_flash_when_low( time_to_help_them )
{
	self endon( "delete" );
	self endon ( "removed" );
	
	wait( time_to_help_them - 5.0 ); //should leave 5 secs left on clock!
	
	while( 1 )
	{
		self.color = ( 1.0, 0.0, 0.0 );  
		self.fontScale = 2.4;
		wait( 0.1 );
		self.color = ( 1.0, 1.0, 1.0 );  
		self.fontScale = 2.0;
		wait( 0.1 );
	}
	
	self destroy();
	self notify ( "removed" );
}

rescue_weaver_counter( time_to_help_them )
{
	elem = NewHudElem();
	elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "top";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 2.0;
	elem.color = ( 1.0, 1.0, 1.0 );        
	elem.alpha = 1.0;
	elem SetTimer( time_to_help_them );
}
rescue_weaver_counter2( time_to_help_them )
{
	elem = NewHudElem();
	elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 2.0;
	elem.color = ( 1.0, 1.0, 1.0 );        
	elem.alpha = 1.0;
	elem SetTimer( time_to_help_them );
}




//shows screen message until player switched to explosive bolts
player_switch_explosive_bolts()
{
	level endon( "BOWMAN_BROOKS_RESCUED" );	
	level endon( "explosive_bolts_selected" );
	
	screen_message_create(&"FLASHPOINT_EXPLOSIVEBOLT_SWITCH"); //HUE_CITY_SPAS_SWITCH
	level.explosive_bolts_msg = 1;

	//now wait until player presses this button or the first encounter is done
	while(1)
	{
		//Keep checking to see if the player switched to explosive bolts
		if( level.player GetCurrentWeapon() == "crossbow_explosive_alt_sp" )
		{
			screen_message_delete();
			level.explosive_bolts_msg = 0;
			level notify( "explosive_bolts_selected" );
			break;		
		}
		wait(0.1);
	}
}


run_dontstop( node )
{	
	self setgoalnode( node );
	self.ignoreall = true;
	self waittill("goal");
	self.ignoreall = false;
}

move_bowman_brooks_forward()
{
	flag_wait( "BOWMAN_BROOKS_MOVE_FWD" );
	
	protect_location_struct = getstruct( "protect_location", "targetname" );
		
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_PROTECT", protect_location_struct.origin );
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_PROTECT" );
	
	level.brooks thread run_dontstop( getnode( "lewis_zipline_attack_2", "targetname" ) );
	level.bowman thread run_dontstop( getnode( "hudson_zipline_attack_2", "targetname" ) );

}

check_for_successful_save()
{
	level endon( "BOWMAN_BROOKS_RESCUED" );
	
	
	startTime = gettime();
	
	timeLeft = 30.0; // 30 sec to save brooks and bowman (hidden timer) STAGE 1
	stage2timerset = false;
	
//	level thread rescue_weaver_counter( timeLeft );
	
	
	while( (GetTime() - startTime) < (timeLeft*1000.0) )
	{
		
		stay_in_battle = false;
		
		if( isdefined(level.zipline_truck1) && isdefined(level.zipline_truck3) )
		{
			if( (level.zipline_truck1.isdestroyed==true) && (level.zipline_truck3.isdestroyed==true) ) 
			{
				wait( 3.0 );
				flag_set( "BOWMAN_BROOKS_MOVE_FWD" );
				
				if( stage2timerset == false )
				{
					startTime = gettime();
					timeLeft = 60.0; //STAGE 2
	//				level thread rescue_weaver_counter2( timeLeft );
					stage2timerset = true;
				}
			}
			else
			{
				stay_in_battle = true;
			}
		}
		
//  		if( isdefined(level.zipline_truck2) && (level.zipline_truck2.isdestroyed==false) )
//  		{
//  			stay_in_battle = true;
//  		}
//  		if( isdefined(level.truck_driver) && isalive(level.truck_driver) )
//  		{
//  			stay_in_battle = true;
//  		}
 		if( isdefined(level.courtyard_gunner) && isalive(level.courtyard_gunner) )
 		{
 			stay_in_battle = true;
 		}
		
		//Then check that we have only a couple of ai left
		if( stay_in_battle==false )
		{
			if( GetAIArray("axis").size >= 6 )  //3 in weaver building. 3 outside
			{
				stay_in_battle = true;
			}	
		}
		
		//if( isdefined(level.zipline_truck3) && (level.zipline_truck3.isdestroyed==false) )
		//{
		//	stay_in_battle = true;
		//}
		//if( isdefined(level.weaver_rescue_truck) && (level.weaver_rescue_truck.isdestroyed==false) )
		//{
		//	stay_in_battle = true;
		//}

		if( stay_in_battle == false )
		{
			wait( 3.0 );
			flag_set( "BOWMAN_BROOKS_RESCUED" );
		}
		
		wait( 0.1 );
	}
	
	//Brooks and Bowman dead

	level.brooks thread stop_magic_bullet_shield();
	level.bowman thread stop_magic_bullet_shield();
	level.brooks Die();
	level.bowman Die();

	maps\_utility::missionFailedWrapper(&"FLASHPOINT_DEAD_BROOKS_BOWMAN");	
}


help_bowman_and_brooks()
{
	level endon( "BOWMAN_BROOKS_RESCUED" );	
	//time_to_help_them = 60.0;
	//time_to_help_them = 6.0;
	
	
// 	level.scr_sound["woods"]["company"] = vox_fla1_s10_001A_wood"; //	We got Company!
// 	level.scr_sound["woods"]["explosivetips"] = vox_fla1_s10_002A_wood"; //	Switch to explosive tips!
// 	level.scr_sound["woods"]["pinned"] = vox_fla1_s10_003A_wood"; //	They're pinned down, take out those vehicles!
// 	level.scr_sound["woods"]["niceshot"] = vox_fla1_s10_004A_wood"; //	Nice shot Mason! They didn�t teach you that in basic!

	level.bowman anim_single( level.bowman, "pinned" );

	level.woods thread playVO_proper( "company", 0.0 );				//We got Company!
//	level.woods thread playVO_proper( "explosivetips", 1.0 );		//Switch to explosive tips!
	//iprintlnbold( "[DPAD LEFT] Activates explosive tips\n" );
	//level.player thread player_switch_explosive_bolts();
	level.woods thread playVO_proper( "pinned_veh", 4.0 );			//They're pinned down, take out those vehicles!

		
	//
	
	
	protect_location_1_struct = getstruct( "protect_location_1", "targetname" );
		
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_PROTECT", protect_location_1_struct.origin );
	Objective_Set3D( level.obj_num, true, "default", &"FLASHPOINT_PROTECT" );
	
	//flag_set( "START_TRUCKS" );
		
	//level thread rescue_weaver_counter( time_to_help_them );
	
	//while( 1 )
	//{
		//wait( time_to_help_them );
		
		level thread check_for_successful_save();
		level thread move_bowman_brooks_forward();
		flag_wait( "BOWMAN_BROOKS_RESCUED" );
		
		/*Objective_State( level.obj_num, "done" );
		Objective_Set3D( level.obj_num, false );	//rescued!
	
		level.player disableweapons();
		//level thread playVO( "TIME TO RESCUE WEAVER - USE THE ZIPLINE BOLT", "WOODS" );
	
		//level.player disableweapons();
		
		wait( 2.0 );
		level.player SwitchToWeapon( "crossbow_explosive_alt_sp" );
		level.player GiveMaxAmmo("crossbow_vzoom_alt_sp");
		level.player GiveMaxAmmo("crossbow_explosive_alt_sp");
		level.player enableweapons();
	
		if( isdefined(level.explosive_bolts_msg) && (level.explosive_bolts_msg==1) )
		{
			screen_message_delete();
			level.explosive_bolts_msg = 0;
		}
		autosave_by_name("flashpoint_e6b");
		//flag_set( "BOWMAN_BROOKS_RESCUED" );*/
	//}
}

player_can_see_woods( enemy )
{
	//Figure out which way the player is facing
	playerAngles = level.player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );
		
	enemyPos = enemy GetOrigin();
	playerPos = level.player GetOrigin();
	playerToEnemyVec = enemyPos - playerPos;
	playerToEnemyUnitVec = VectorNormalize( playerToEnemyVec );
	
	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToEnemyUnitVec );
	angleFromCenter = ACos( forwardDotBanzai ); 
		
	println( "Enemy is " + angleFromCenter + " degrees from straight ahead." );

	playerCanSeeMe = ( angleFromCenter <= 40.0 );
	
	return playerCanSeeMe;
}

setup_ladder_enemy()
{
	self endon("death");
	self.ignoreall = true;
}

badass_enemy_kicking_woods()
{
	level endon( "BOWMAN_BROOKS_RESCUED" );	
	
	//Get woods into the first frame of the anim
	anim_node = get_anim_struct( "10" );
	
	kicked_someone = false;
	
	//Move woods to ladder covering spot.
	while( 1 )
	{
		//Are we looking at Woods?
		if( (kicked_someone==false) && level.player player_can_see_woods( self ) )
		{
			level.setup_ladder_enemy = simple_spawn_single( "comms_spawner_ladder_enemy", ::setup_ladder_enemy );
			level.setup_ladder_enemy.animname = "enemy";
			anim_node thread anim_single_aligned( self, "ladderkick" );
			anim_node thread anim_single_aligned( level.setup_ladder_enemy, "ladderkick" );
			anim_node waittill( "ladderkick" );
			anim_node thread anim_loop_aligned( self, "ladderidle" );
			
			level.setup_ladder_enemy Die();
			kicked_someone = true;
			
			wait( 2.0 );
		}
		
	//	playfxontag( level.fake_muzzleflash, self, "tag_flash" );
		
		wait( 0.2 );
	}
}	


refill_ammo() //self = player
{
	self endon( "disconnect" );
	self endon( "death" );

	primary_weapons = self GetWeaponsList();

	for( i=0; i < primary_weapons.size; i++ )
	{
		clip_size = WeaponClipSize( primary_weapons[i] );
		self SetWeaponAmmoClip( primary_weapons[i], clip_size );
	//	self AddWeaponAmmoToClip( primary_weapons[i], clip_size );

		self GiveMaxAmmo( primary_weapons[i] );
	}
}

give_player_max_ammo() //self = player
{
	player = get_players()[0];
	weapList =  player GetWeaponsListPrimaries();
	for (i=0; i < weapList.size; i++)
	{
		clip_size = WeaponClipSize(weapList[i]);
		player SetWeaponAmmoClip(weapList[i], clip_size);                       
		player GiveMaxAmmo(weapList[i]);
	}              
}

keep_ammo_full_down_zipline( )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "window_breached" );
	
	//SetSavedDvar( "hud_drawhud", 0 );
	
	while( 1 )
	{
		clip_size = WeaponClipSize( "mp5k_elbit_extclip_sp" );
		level.player SetWeaponAmmoClip( "mp5k_elbit_extclip_sp", clip_size); 
		wait( 0.05 );
	}
}

check_breach_reload()
{
	level endon( "restore_time" );
	
	while( 1 )
	{
		if ( self isplayerreloading() )
		{
			flag_set( "restore_time" );
		}
		wait( 0.05 );
	}
}

check_breach_timeout( timeout )
{
	level endon( "restore_time" );
	
	wait( timeout );
	println( "timescale_tween d" );
	level timescale_tween( 0.45, 1.0, 0.25 );
	flag_set( "restore_time" );
}


check_breach_grenade()
{
	level endon( "restore_time" );
	self waittill( "grenade_fire" );
	flag_set( "restore_time" );
}

building_breach_anims()
{
	level waittill( "WEAVER_SPAWNED_INSEAT" );
	
	//Start the breach anims
	weaver_breachroom_after = getnode( "weaver_breachroom_after", "targetname" );
	level.weaver thread breach_anim_weaver( weaver_breachroom_after );
	if( isdefined( level.zipline_room_guard_01 ) && isalive( level.zipline_room_guard_01 ) )
	{
		level.zipline_room_guard_01 thread breach_anim_guard_at_wnd();
	}
	if( isdefined( level.zipline_room_guard_02 ) && isalive( level.zipline_room_guard_02 ) )
	{
		level.zipline_room_guard_02 thread breach_anim();
	}	
	if( isdefined( level.zipline_room_guard_03 ) && isalive( level.zipline_room_guard_03 ) )
	{
		level.zipline_room_guard_03 thread rush_at_player();
	}
}

	
event6_ZipLine()
{
/*
 Now base is on full alert, as the snipers managed to radio in before they were killed
 Clamps holding rocket start to open � they�re launching early
 Weaver�s location highlighted above is next target � he is a prisoner held captive here
 Chopper and jeep (and foot soldiers) are hurtling past ahead, scouting around for the intruders
 Woods VO � (translating radio transmisisons) they�re about to execute Weaver � we have 10 seconds to get there
 Player must run, and engage in light combat (next slide), to get to the Weaver location
*/
	autosave_by_name("flashpoint_e6");
	debug_event( "event6_ZipLine", "start" );
	
	level.woods.ignoreme = true;
	level.player.ignoreme = true;
	level.woods disable_cqbwalk();
	
	level.brooks setgoalnode( getnode( "lewis_zipline_attack", "targetname" ) );
	level.bowman setgoalnode( getnode( "hudson_zipline_attack", "targetname" ) );
	level thread spawnZipLineGuards();
	level thread building_breach_anims();
	
	// Kill the random radio chatter from flashpoint_util
	level notify("kill_russian_chatter");
	
// 	//Wait for the "zipline_trig" use trigger to be activated
// 	zipline_trig = getent( "zipline_trig", "targetname" );
// 	zipline_trig waittill( "trigger" );
// 	

	
	//Woods should run up here now
	/*
	woods_onroof_point = getnode( "woods_onroof_point", "targetname" );
	level.woods setgoalnode( woods_onroof_point );
	level.woods waittill( "goal" );
	*/

	//Start the woods anims
	level.woods thread woods_crossbow_anims();
	
	flag_wait( "READY_TO_SHOOT" );
	//Objective_State( level.obj_num, "done" );
	
	//level thread spawnExplosiveBoltEnemies();
	



 	level.player thread help_bowman_and_brooks();
 //	flag_wait( "BOWMAN_BROOKS_RESCUED" );
	

	level.woods thread badass_enemy_kicking_woods();
	
	//Limit players headlook range and lock player in place
	level.linker = spawn( "script_origin", level.player.origin );
	
	//Get angle to target
	zipline_endpoint_struct = GetStruct( "zipline_endpoint", "targetname" );
	zipline_startpoint_struct = GetStruct( "zipline_startpoint", "targetname" );
	
	level.ziplineVecTo = vectorNormalize( zipline_endpoint_struct.origin - level.player.origin );
	desired_angles = VectorToAngles( level.ziplineVecTo );
	level.linker.angles = desired_angles;
	level.player PlayerLinkToDelta( level.linker, "", 1, 135, 115, 25, 45, true );
	
	//Force player to crouch
	level.player AllowStand( true );
	level.player AllowSprint( false );
	level.player SetStance( "stand" );

	/*
	level.player.zip_currentweapon = level.player GetCurrentWeapon(); 
	level.player GiveWeapon( "crossbow_vzoom_alt_sp" );
	level.player SwitchToWeapon( "crossbow_vzoom_alt_sp" );
	*/
	
	
	flag_wait( "BOWMAN_BROOKS_RESCUED" );
	
	level.player SwitchToWeapon( "crossbow_vzoom_alt_sp" );
	level.player SetActionSlot( 3, "" );	// toggles between attached grenade launcher
	level.player DisableWeaponCycling();
	level.player DisableOffhandWeapons();
	//level.player SetActionSlot( 3, "" );	// toggles between attached grenade launcher
	
	//level.player Unlink();
	//level.linker Delete();
		
	level.woods thread playVO_proper( "gunfire", 0.0 );				//Gunfire's drawin' attention.
    level.woods thread playVO_proper( "assholes", 1.0 );			//Those assholes are on the way back!
    level.woods thread playVO_proper( "secureline", 3.0 );			//I'll secure the line. You take the shot.
    level.woods thread playVO_proper( "makeitquick", 4.0 );			//Make it quick, Mason.
   // level.woods thread playVO_proper( "buytime", 0.0 );				//I'll buy us some time.
   // level.woods thread playVO_proper( "gogo", 0.0 );				//Go! GO!
   // level.woods thread playVO_proper( "behindya", 0.0 );			//I'm right behind ya!
    
    
	
	//Get angle to target
	zipline_endpoint_struct = GetStruct( "zipline_endpoint", "targetname" );
	zipline_startpoint_struct = GetStruct( "zipline_startpoint", "targetname" );
	
	level.ziplineVecTo = vectorNormalize( zipline_endpoint_struct.origin - level.player.origin );
	desired_angles = VectorToAngles( level.ziplineVecTo );
	level.linker.angles = desired_angles;
	level.player PlayerLinkToDelta( level.linker, "", 1, 15, 15, 15, 15, true );
		
		
	//FLASHPOINT_OBJ_RESCUE_WEAVER
	set_event_objective( 5, "active" );
	
	//autosave_by_name("flashpoint_e6b");
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_FIRE_AT_TARGET" );
	Objective_Set3D( level.obj_num, true );
	Objective_Position( level.obj_num, level.crossbow_target_pt.origin );
	
	level.crossbow_target_pt show();
	
	level.player.ignoreMe = true;
	
	// crossbow_target_pt "targetname" - flashing target
	
	
	level.player thread create_crossbow_rope();
	
	//-- switch woods weapon back
	//level.woods gun_switchto( "ak47_sp", "right");
	
	flag_wait( "ROPE_READY" );
	
	battlechatter_off( "allies" );
	
	level.player thread check_breach_reload();
	level.player thread check_breach_grenade();
	level thread keep_ammo_full_down_zipline();
	
	//-- turn off the Fire Zipline 3D objective marker
	Objective_State( level.obj_num, "done" );
	Objective_Set3D( level.obj_num, false );
	
	level.crossbow_target_pt hide();
	
	level.player Unlink();
	level.linker Delete();

	weaponOptions = level.player calcweaponoptions( 1 );
	level.player GiveWeapon( "mp5k_elbit_extclip_sp", 0, weaponOptions );
	level.player SwitchToWeapon( "mp5k_elbit_extclip_sp" );
	
	//Take them all just in case
	level.player TakeWeapon( "ak47_sp" );
	level.player TakeWeapon( "ak47_acog_sp" );
	level.player TakeWeapon( "ak47_extclip_sp" );
	level.player TakeWeapon( "ak47_dualclip_sp" );
	level.player TakeWeapon( "ak47_gl_sp" );
	level.player TakeWeapon( "gl_ak47_sp" );
	
	level.player TakeWeapon( "python_speed_sp" );
	
	level.player TakeWeapon( "pm63_sp" );
	level.player TakeWeapon( "pm63_extclip_sp" );
	
// 	level.player DisableWeaponCycling();
// 	level.player DisableOffhandWeapons();
// 	level.player SetActionSlot( 3, "" );	// toggles between attached grenade launcher
	level.player give_player_max_ammo();
	
	Objective_Add( level.obj_num, "current", &"FLASHPOINT_OBJ_RESCUE_WEAVER" );
	Objective_Set3D( level.obj_num, true );
	
	Objective_Position( level.obj_num, level.zipline_room_guard_02.origin + (0.0, 0.0, 80.0) );
	//Objective_Position( level.obj_num, level.weaver.origin );

	//Anim of player attacking to zip line and starting to slide down
	level thread window_swap();
	
	
	level.zipline_room_guard_01 stop_magic_bullet_shield();
	level.zipline_room_guard_02 stop_magic_bullet_shield();
	level.zipline_room_guard_03 stop_magic_bullet_shield();
	
// 	//Start the breach anims
// 	weaver_breachroom_after = getnode( "weaver_breachroom_after", "targetname" );
// 	level.weaver thread breach_anim_weaver( weaver_breachroom_after );
// 	if( isdefined( level.zipline_room_guard_01 ) && isalive( level.zipline_room_guard_01 ) )
// 	{
// 		level.zipline_room_guard_01 thread breach_anim();
// 	}
// 	if( isdefined( level.zipline_room_guard_02 ) && isalive( level.zipline_room_guard_02 ) )
// 	{
// 		level.zipline_room_guard_02 thread breach_anim();
// 	}	
// 	if( isdefined( level.zipline_room_guard_03 ) && isalive( level.zipline_room_guard_03 ) )
// 	{
// 		level.zipline_room_guard_03 thread rush_at_player();
// 	}
	
	level.woods.ignoreme = false;
	//level.player.ignoreme = true;
	
	level.player do_player_hookup( zipline_startpoint_struct );
	level.player thread do_player_zipline( zipline_startpoint_struct );
	
// 	if(IsDefined(level.demo))
// 	{
// 		level thread event6_RescueWeaverDemo();
// 	}
// 	else
// 	{
		level thread event6_RescueWeaver();
//	}
	
	flag_wait( "END_OF_ROPE" );
	
	//Back to normal
	level.player unlink();	
	level.player.body delete();	
	
	level.player thread playVO_proper( "weaver_breach", 0.0 );

	level.woods.name = "Woods";

	//Force player to crouch
	level.player AllowStand( true );
	level.player AllowSprint( true );
	level.player SetStance( "stand" );
	level.player AllowMelee( true );

	//level.player SwitchToWeapon( "ak47_sp" );
	//level.player GiveMaxAmmo( "ak47_sp" );
	level.player EnableWeaponCycling();
	level.player EnableOffhandWeapons();
	level.player SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
		
	debug_event( "event6_ZipLine", "end" );
}

rush_at_player()
{
	self endon("death");
	
	level waittill( "break_breach_window" );
	self.goalradius = 4;
	self SetGoalPos( level.player.origin );
	//self SetCanDamage(false);
}

breach_anim_weaver_res( node ) //-- self == weaver
{
	flag_wait( "start_rescue_anims" );
	anim_node = get_anim_struct( "11" );
	anim_node thread anim_single_aligned( self, "weaver_rescue" );
	anim_node waittill( "weaver_rescue" );
	self setgoalnode( node );
}
	
breach_anim_weaver( node ) //-- self == weaver
{
	self endon( "death" );
	level endon( "start_rescue_anims" );
	
	//todo: remove
//	self SetCanDamage( false );

	self thread breach_anim_weaver_res( node );
	
	//-- replace weaver's head with the bandaged one
	// self Detach(self.headmodel, "");
	// self.headmodel = "c_usa_blackops_weaver_disguise_headb";
	// self Attach(self.headmodel, "", true);
	
	anim_node = get_anim_struct( "11" );
	
	//Play loop and wait for player to breach window and kill the 2 guards
	anim_node thread anim_loop_aligned( self, "weaver_breach_wait" );
	
	flag_wait( "window_breached" );
	anim_node thread anim_single_aligned( self, "weaver_breach" );
	anim_node waittill( "weaver_breach" );
	
	anim_node thread anim_loop_aligned( self, "weaver_breach_wait" );
	
// 	flag_wait( "start_rescue_anims" );
// 	
// 	anim_node thread anim_single_aligned( self, "weaver_rescue" );
// 	anim_node waittill( "weaver_rescue" );
// 	self setgoalnode( node );
}

breach_anim_guard_at_wnd()
{
	self endon( "death" );
	self endon("damage");
	
	anim_node = get_anim_struct( "11" );
	
	/*
	//Weaver building pre-rescue
	level.scr_anim["guard1"]["wnd_idle"][0]				= %ch_flash_ev06_stunnedguard_guardbywindow_idle;
	level.scr_anim["guard1"]["looptoidle"][0]			= %ch_flash_ev06_stunnedguard_guardbywindow_looptoidle;
	level.scr_anim["guard1"]["pacingloop"][0]			= %ch_flash_ev06_stunnedguard_guardbywindow_pacingloop;
	level.scr_anim["guard1"]["reaction"]				= %ch_flash_ev06_stunnedguard_guardbywindow_reaction;
	*/
	
	anim_node thread anim_loop_aligned( self, "pacingloop" );
	
	
	level waittill( "wnd_guard_in_pos" );
	//wait( 5.0 );
	//anim_node thread anim_single_aligned( self, "looptoidle" );
	//anim_node waittill("looptoidle");
	anim_node thread anim_loop_aligned( self, "wnd_idle" );
	
	//wait( 5.0 );
	
	flag_wait( "window_breached" );
	//level.player GiveMaxAmmo( "mp5k_elbit_extclip_sp" );
	
	//Play loop and wait for player to breach window and kill the 2 guards	
	if(IsAlive(self))
	{
//		level waittill( "break_breach_window" );
		self SetAnimRateComplete(3.0);
		anim_node thread anim_single_aligned( self, "reaction" );
		anim_node waittill("reaction");
		self.ignoreall = false;
		self setgoalpos( self.origin );		
	}
	
}

breach_anim()
{
	self endon( "death" );
	
	flag_wait( "window_breached" );
	level.player GiveMaxAmmo( "mp5k_elbit_extclip_sp" );
	anim_node = get_anim_struct( "11" );
	anim_node thread anim_single_aligned( self, "weaver_breach2" );
	anim_node waittill("weaver_breach2");
	self.ignoreall = false;
	self setgoalpos( self.origin );	
}

rescue_anim_woods( node )
{
	anim_node = get_anim_struct( "11" );
	
	//level waittill("notify_weaver_rescue_start_woodsbowman");	
	anim_node thread anim_single_aligned( self, "weaver_rescue_woods" );
	anim_node waittill( "weaver_rescue_woods" );
	self setgoalnode( node );
}

rescue_anim_bowman( node )
{
	anim_node = get_anim_struct( "11" );
	
	//level waittill("notify_weaver_rescue_start_woodsbowman");	
	anim_node thread anim_single_aligned( self, "weaver_rescue_bowman" );
	anim_node waittill( "weaver_rescue_bowman" );
	self setgoalnode( node );
}

rescue_anim_brooks( node )
{
	anim_node = get_anim_struct( "11" );
	anim_node thread anim_single_aligned( self, "weaver_rescue_brooks" );
	anim_node waittill( "weaver_rescue_brooks" );
	self setgoalnode( node );
}

checkForRoomCleared()
{
	self endon( "death" );
	level endon( "WEAVER_IS_RESCUED" );
	
	zipline_guards = array(level.zipline_room_guard_01,level.zipline_room_guard_02,level.zipline_room_guard_03);
	array_thread(zipline_guards, ::increase_accuracy_after_delay, 4);
	array_thread(zipline_guards, ::zipline_infinite_ammo);
	
	level.overridePlayerDamage = ::zipline_room_damage_ramp;
	
	while( 1 )
	{
		isclear = true;
		
		if( isdefined( level.zipline_room_guard_01 ) && isalive( level.zipline_room_guard_01 ) )
		{
			isclear = false;
		}
		if( isdefined( level.zipline_room_guard_02 ) && isalive( level.zipline_room_guard_02 ) )
		{
			isclear = false;
		}
		if( isdefined( level.zipline_room_guard_03 ) && isalive( level.zipline_room_guard_03 ) )
		{
			isclear = false;
		}	
		
		if( isclear==true )
		{
			flag_set( "WEAVER_IS_RESCUED" );
			flag_set( "restore_time" );
			level.overridePlayerDamage = undefined;
		}
		wait( 0.05 );
	}
}

//-- keep the guards from switching to their pistol
zipline_infinite_ammo()
{
	self endon("death");
	
	while(1)
	{
		if(self.weapon != "none")
		{
			self.bulletsinclip = WeaponClipSize(self.weapon);
		}
		wait(0.05);
	}
}

//-- ramp up the damage so that you can die in recruit as well
zipline_room_damage_ramp(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime)
{
	if(IsDefined(level.zipline_room_damage))
	{
		if(eInflictor == level.zipline_room_guard_01 || eInflictor == level.zipline_room_guard_02 || eInflictor == level.zipline_room_guard_03)
		{
			iDamage = iDamage + level.zipline_room_damage;	
		}
	}
	
	return iDamage;
}

increase_accuracy_after_delay( delay )
{
	self endon("death");
	wait(delay);
	
	level.zipline_room_damage = 0;
	while(self.script_accuracy < 100)
	{
		level.zipline_room_damage += 10;
		self.script_accuracy += self.script_accuracy + 0.5;
		wait(0.5);
	}
}

stop_slowmo()
{
	flag_wait( "restore_time" );
	playsoundatposition ("evt_time_slow_stop", (0,0,0));
	clientnotify ("Breach_sound_stop");
	println( "timescale_tween a" );
	level timescale_tween( 0.45, 1.0, 0.25 );
}

breach_slowmo()
{
	level endon ( "restore_time" );
	
	wait(level.player_zipline_time - 1 - 0.2);
	
	//timescale_tween(start, end, time, delay, step_time)
	//wait( 0.5 );
	//kevin adding sounds for slowmo
	
	level thread stop_slowmo();
	
	//level timescale_tween( 1.0, 0.65, 0.15 );
	level waittill("breach_anim_started");
	ClientNotify ("wbr"); //Change the Reverb here
	playsoundatposition ("evt_time_slow_start", (0,0,0));
	println( "timescale_tween b" );
	level timescale_tween( 1.0, 0.1, 0.05 );
	//level waittill( "break_breach_window" );
	wait(0.15);
	println( "timescale_tween c" );
	level timescale_tween( 0.1, 0.45, 0.25 );
	//playsoundatposition ("evt_time_slow_stop", (0,0,0));
	//clientnotify ("Breach_sound_stop");
	
	flag_wait_or_timeout( "WEAVER_IS_RESCUED", 3.0 );
	check_breach_timeout( 1.0 );
	flag_set( "restore_time" );
	
	
	//playVO( "TIMESCALE BACK TO NORM", "DEBUG" );
}

shoot_and_kill( enemy, waittime )
{
	level endon( "WEAVER_IS_RESCUED" );
	self endon( "death" );

	self.perfectAim = true;
	wait( waittime );
	while( IsAlive(enemy) )
	{
		self shoot_at_target( enemy,"J_head" );
		wait(0.05);
	}

	self.perfectAim = false;
	self notify( "enemy_killed" );
	level.weaver stopanimscripted();
	level.weaver die();
	level_fail( "weaver was killed" );  
}

check_for_weaver_damage()
{
	level endon( "WEAVER_IS_RESCUED" );
	
	//Enemy is going to try to kill weaver - need to move quick!
	
	level.weaver waittill( "damage" );
	//playVO( "WEAVER TOOK DAMAGE!!! - ", "DEBUG" );
}


window1_damaged()
{
	level endon( "end_window" );
	
	solid1 = getent( "breach_window_solid_1", "targetname" );
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	
	solid1 setcandamage( true );
	
	solid1 waittill( "damage" );
	
	solid1 delete();
	cracked1 show();
}

window_swap()
{
	level thread window1_damaged();
		
	solid1 = getent( "breach_window_solid_1", "targetname" );
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	damaged1 = getent( "breach_window_damaged_1", "targetname" );
		
	//flag_wait( "window_breached" );
	level waittill( "break_breach_window" ); //-- from the animation
	clientnotify ("breach_sound_go");
	
	level notify("end_window");
	
	if (isdefined(solid1))
	{
		solid1 delete();
	}
	
	cracked1 show();
	
	//wait(0.05);
	
	cracked1 delete();
	damaged1 show();
	
	//-- grab and destroy all the paper around the player
	/*
	destructibles = GetEntArray( "destructible", "targetname" );
	paper = [];
	
	for( i = 0; i < destructibles.size; i++ )
	{
		if(destructibles[i].model == "dest_glo_paper_02_d0")
		{
			paper[paper.size] = destructibles[i];
		}
	}
	
	for(i = 0; i < paper.size; i++ )
	{
		paper[i] DoDamage( 1000, paper[i].origin );
	}
	*/
	
	wait(0.1);
	RadiusDamage( (-4648, -304, 376), 120, 500, 499, level.player );
	wait(0.1);
	RadiusDamage( (-4816, -408, 376), 120, 500, 499, level.player );
	wait(0.1);
	RadiusDamage( (-4776, -224, 376), 120, 500, 499, level.player );

}


/*
	//anim of door knocked down
	door = ent_get("door_lower");		
	
	//alignment node for the anim
	node = GetNode("anim_node_knife_throw", "targetname" );
	
	model = spawn("script_model",door.origin);	
	model setmodel("tag_origin_animate");
	model.animname = "door";	
	model useanimtree(level.scr_animtree["door"]);

	// link the door to the 'tag_origin_animate' model
	door linkto( model,"origin_animate_jnt" );
*/

#using_animtree("animated_props");

waittill_notify_weaver_rescue_door_close( anim_node )
{
	//Close door behind woods
	level waittill( "notify_weaver_rescue_door_close" );
	anim_node thread anim_single_aligned( self, "close" );
}

rescue_anim_doors()
{
	anim_node = get_anim_struct( "11" );
	
	//Open door trigger and the doors to open
	weaver_door_in = getent( "weaver_door_1", "targetname" );
	weaver_door_in_model = spawn("script_model",weaver_door_in.origin);
	weaver_door_in_model.angles = weaver_door_in.angles;
	weaver_door_in_model setmodel("tag_origin_animate");
	weaver_door_in_model.animname = "weaver_door_in";	
	weaver_door_in_model useanimtree(level.scr_animtree["weaver_door_in"]);
	
	// link the door to the 'tag_origin_animate' model
	weaver_door_in linkto( weaver_door_in_model,"origin_animate_jnt" );
	
	weaver_door_out = getent( "weaver_door", "targetname" );
	weaver_door_out_model = spawn("script_model",weaver_door_out.origin);	
	weaver_door_out_model.angles = weaver_door_out.angles;
	weaver_door_out_model setmodel("tag_origin_animate");
	weaver_door_out_model.animname = "weaver_door_out";	
	weaver_door_out_model useanimtree(level.scr_animtree["weaver_door_out"]);
	
	// link the door to the 'tag_origin_animate' model
	weaver_door_out linkto( weaver_door_out_model,"origin_animate_jnt" );
	
	anim_node thread anim_first_frame( weaver_door_in_model, "open" );
	anim_node thread anim_first_frame( weaver_door_out_model, "open" );
	

	weaver_door_in_model thread waittill_notify_weaver_rescue_door_close( anim_node );
	
	level waittill( "notify_weaver_rescue_door_open" );
	anim_node thread anim_single_aligned( weaver_door_in_model, "open" );
	
	level waittill( "notify_weaver_rescue_door_bash" );
	flag_set( "START_WEAVER_RESCUE_MOVIE" );
	anim_node thread anim_single_aligned( weaver_door_out_model, "open" );
}

event6_RescueWeaver()
{
/*
 SLOW MO scene, with 3 guards
 As the Player has jumped through the window, one guard is knocked to the floor, stunned
 Guard reaches for his weapon, Player needs to shoot him before he gets to his weapon
 Another stumbles back into some physics objects before he can shoot
 Weaver looks a complete mess, minus one eye but plus lots of ooze drooling from his vacant eye socket
 Someone rushes over to patch him up, then gets him to his feet
 Weaver VO: �Just a scratch {or preferably something less corny}, I�m gonna make it�
 Weaver also reveals intel about the location of the Scientists (the reinforced bunker room)
*/

	debug_event( "event6_RescueWeaver", "start" );
	
	level thread rescue_anim_doors();
	
	//Bring up pipe blocker script_brushmodel
	back_door_blocker = getent( "weaver_door_blocker", "targetname" );
	//back_door_blocker NotSolid();

	flag_wait( "END_OF_ROPE" );	
	level.player thread checkForRoomCleared();

	flag_wait( "WEAVER_IS_RESCUED" );
	//playVO( "WEAVER_IS_RESCUED", "DEBUG" );
	Objective_State( level.obj_num, "done" );
	Objective_Set3D( level.obj_num, false );
	//level.obj_num++; // want the next objective to be a new one
	
	//Clean up prev stuff
	flag_set( "CLEANUP_BASE_AFTER_ZIPLINE" );
	
	level thread delete_axis_ai_during_weaver_scene();

	wait( 1.0 );
	
	//playVO( "PLAY RESUCE ANIMS", "DEBUG" );
	
	woods_breachroom_after = getnode( "woods_breachroom_after", "targetname" );
	hudson_breachroom_after = getnode( "hudson_breachroom_after", "targetname" );
	brooks_breachroom_after = getnode( "lewis_breachroom_after", "targetname" );
	
	flag_set( "start_rescue_anims" );
	level.bowman thread rescue_anim_bowman( hudson_breachroom_after );
	level.woods thread rescue_anim_woods( woods_breachroom_after );
	level.brooks thread rescue_anim_brooks( brooks_breachroom_after );
	//level thread rescue_anim_doors();

	
	weaver_frontdoor_blocker = getent( "weaver_frontdoor_blocker", "targetname" );
	weaver_frontdoor_blocker ConnectPaths();
	weaver_frontdoor_blocker Delete();
	
	//weaver_frontdoor_blocker
	//wait( 10.0 );
	
	//playVO( "PLAY RESUCE ANIMS - DONE", "DEBUG" );
	
	//level.player.ignoreMe = false;
	
	//Give player sniper weapon
	//level.player GiveWeapon( "m14_scope_silencer_sp" );
	//level.player SwitchToWeapon( "m14_scope_silencer_sp" );
	
//	back_door_blocker NotSolid();


	//Get everone ready for next section
// 	lewis_breachroom_after = getnode( "lewis_breachroom_after", "targetname" );
// 	level.brooks SetGoalNode( lewis_breachroom_after );
	
//	debug_event( "event6_RescueWeaver", "end" );
	
	
	//MID_FLASHPOINT_2
	start_movie_scene();
	add_scene_line(&"flashpoint_vox_fla1_s01_803A_inte", 2.8, 5);		//You saved his life. Now you had to locate the Ascension Group and kill the scientists.
	add_scene_line(&"flashpoint_vox_fla1_s01_804A_maso", 8, 4.5);		//No...I had to kill...Dragovich.
	//Queue up the movie to play
	level.movie_trans_in = "white";
	level.movie_trans_out = "white";
	level thread play_movie("mid_flashpoint_2", false, false, "movie2_start", true, "movie2_end", 0.3);
		
	flag_wait( "START_WEAVER_RESCUE_MOVIE" );
	
	SetSavedDvar("r_streamFreezeState",1);
	
	wait( 3.0 );
	
	level.player FreezeControls(true);

	SetSavedDvar("r_streamFreezeState",1);
	wait( 1.0 );

	level notify( "movie2_start" );

	wait 1;
	
	cleanup_vehicles_afterzipline();
	
	level.woods StopAnimScripted();
	level.weaver StopAnimScripted();
	level.brooks StopAnimScripted();
	level.bowman StopAnimScripted();
	
	
	player_breachroom_after = getnode( "player_breachroom_after", "targetname" );
	woods_breachroom_after = getnode( "woods_breachroom_after", "targetname" );
	hudson_breachroom_after = getnode( "hudson_breachroom_after", "targetname" );
	lewis_breachroom_after = getnode( "lewis_breachroom_after", "targetname" );
	weaver_breachroom_after = getnode( "weaver_breachroom_after", "targetname" );	
	
	level.woods StopAnimScripted();
	level.weaver StopAnimScripted();
	level.brooks StopAnimScripted();
	level.weaver StopAnimScripted();
	
	
	//Player
	level.player setorigin( player_breachroom_after.origin );
	level.player setplayerangles( player_breachroom_after.angles );
	
	level.woods forceTeleport( woods_breachroom_after.origin );
	level.woods SetGoalPos( woods_breachroom_after.origin );
	level.weaver forceTeleport( weaver_breachroom_after.origin );
	level.weaver SetGoalPos( weaver_breachroom_after.origin );
	level.brooks forceTeleport( lewis_breachroom_after.origin );
	level.brooks SetGoalPos( lewis_breachroom_after.origin );
	level.bowman forceTeleport( hudson_breachroom_after.origin );
	level.bowman SetGoalPos( hudson_breachroom_after.origin );
	
	SetSavedDvar("r_streamFreezeState",1);
	battlechatter_on( "allies" );
	
	//Movie is playing
	
	level waittill( "movie2_end" );
	SetSavedDvar("r_streamFreezeState",0);
	
	level.woods delayThread(1.0, ::playVO_proper, "losetheb", 0 );
	
	//Goto next event
	flag_set("BEGIN_EVENT7");
}


//-----------------------------------------------------
//
//
//	THIS ONE IS FOR DEMO PURPOSES ONLY
//
//
//-----------------------------------------------------

// event6_RescueWeaverDemo()
// {
// 	debug_event( "event6_RescueWeaver", "start" );
// 	
// 	level waittill("break_breach_window");
// 	
// 	
// 	//level.zipline_room_guard_01.ignoreall = true;
// 	level.zipline_room_guard_02.ignoreall = true;
// 	
// 	
// 	//level.player FreezeControls(true);
// 	level thread custom_fade_screen_out( "black", 0.75 );
// 	//level timescale_tween( 1.0, 0.05, 0.15 );
// 	
// 	clientnotify( "window_snapshot" );
// 	player = get_players()[0];
// 	player playsound("evt_blackout","blackout_wait");
// 	player waittill("blackout_wait");
// 	
// 	//level.player player_gets_weapons_back();
// 	level thread custom_fade_screen_out( "e3_slate", 0 );
// 	wait(2.0);
// 	
// 
// 
// 	ChangeLevel( "" );
// 	
// 	//level.player lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
// }

////////////////////////////////////////////////////////////////////////////////////////////
// EOF
////////////////////////////////////////////////////////////////////////////////////////////
