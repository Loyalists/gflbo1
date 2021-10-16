#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_util;
#include maps\_anim;
#include maps\_music;
#include maps\_stealth_logic;
#include maps\wmd;


radar_main()
{
	//waits for the enemies to be cleared and the sabotage to be completed
	level thread event1_wait_for_objectives_done();
	
	glo_hinge_bot = getent("glo_hinge_bot", "targetname");
	glo_hinge_top = getent("glo_hinge_top", "targetname");
	
	glo_hinge_bot notsolid();
	glo_hinge_top notsolid();
	
	//knife throwing vignette
	level thread Start_Knife_Throw();
	
	//radar room
	level thread hut_breach();
	level thread comm_station_breach();
	level thread gunshot_comm_station();
	level thread hut_battle();	
	level thread control_final_wave();
		
	//waits for the player to stop the radar dish
	level thread wait_for_sabotage();
	
	//ledge rpg event
	level thread ledge();
	
	//missile Launch
	level thread launch_sa2_and_react();
	
	//base jump
	level thread base_jump();
	//level thread players_jump_from_cliff();
}


/************************post control rooom*********************/
base_jump()
{	
	//flag_wait("relay_station_sabotaged");

	//wait for missile launch to finish
	level waittill( "missile_done" );
	
	level thread setup_parachute_anim();
	level waittill("parachute_anim_done");
	
	players = get_players();	
	
	flag_set ("player_signaled_reznov");	//TODO change this flag name
}


wait_for_player_jump()
{
	trigger_wait("start_fall", "targetname");
	
	flag_set("players_jumped");
	
	level thread monitor_player_status();
	level thread maps\wmd_amb::event_heart_beat( "sedated", 0 );
	level thread maps\wmd_amb::base_jump_heartbeat_stop();
	
	level notify("players_jumped");
}


setup_parachute_anim()
{
	trigger_wait("start_parachute_vignette");
	
	level thread maps\wmd_amb::event_heart_beat( "panicked", 1 );
	
	level thread wait_for_player_jump();
	
	anode = getnode("parachute_align","targetname");
	
	level.heroes["kristina"].animname = "kristina";
	level.heroes["pierro"].animname = "pierro";
	level.heroes["pierro"]._goal_offset = (0,240,500);
	
	guys = array(level.heroes["kristina"],level.heroes["pierro"]);

	flag_set("parachute_anim_triggered");
	player = get_players()[0];	
	player disableweapons();

	//who unlink();	
	level notify("parachute_anim_done");
	
	wait 3;	//lock player?
	
	flag_wait("players_jumped");
	
	//player puts goggles on so he knows he can jump
	level thread visor_on();
	
	level.heroes["kristina"] stopanimscripted();
	anode notify("stop_signal_loop");
	level.heroes["kristina"] notify("stop_signal_loop");

	wait( 0.90 );

	level.heroes["kristina"] StopAnimScripted();

	//anode anim_single_aligned ( level.heroes["kristina"] , "throwpack_jump" );	
	level.heroes["kristina"] AnimCustom( ::ai_start_tandem_freefall );
	//level.heroes["pierro"] AnimCustom( ::ai_start_tandem_freefall_brooks );
	//level.heroes[ "pierro" ] thread ai_start_freefall("pierro");
}


parachute_first_guy()
{
	//self anim_single_aligned ( level.heroes["pierro"], "throwpack" );	
	//level.heroes["pierro"] Delete();
	level.heroes["pierro"] thread ai_start_freefall("pierro");
}


ai_start_freefall(who)
{
	
	// -- WWILLIAMS: FLAG LETS FUNCTIONS KNOW WHAT STATE THE VEIHCLE IS IN
	self ent_flag_init( "veh_removed" );
	
	activate_trigger_with_targetname(who + "_freefall_trig");
	while(!isDefined(ent_get(who + "_freefall_start") ))
	{
		wait(.05);
	}
	self stopanimscripted();

	veh = ent_get(who + "_freefall_start");		
	self.anchor = spawn("script_model",self.origin);
	self.anchor setmodel("tag_origin");
	self linkto(self.anchor);
	self.anchor.origin = veh.origin;
	self unlink();
	self linkto(veh);
	self.anchor delete();
	

	self.animname = who;//"ai_freefall";
		
	self thread anim_loop( self, "freefall", "chute_pull" );
	self.ignoreme = true;
	
	veh thread maps\_vehicle::gopath();
	self thread ai_stay_in_front_of_player( veh, 350 ); // -- WWILLIAMS: FUNCTION KEEPS THE AI A CERTAIN DISTANCE FROM THE PLAYER
	
	chute_pull = getvehiclenode(who + "_pull_chute","script_noteworthy");
	chute_pull waittill("trigger");
	self thread ai_pull_chute(veh);
	veh waittill("reached_end_node");
	self ai_land(veh);
	
	/*
	self setgoalnode(getnode(who + "_land_node","targetname"));
	*/
	
}

#using_animtree( "generic_human" );

ai_start_tandem_freefall()
{
	self endon( "death" );
	self notify( "stop_wait_loop" );
	
	self clear_run_anim();
	
	// -- WWILLIAMS: FLAG LETS FUNCTIONS KNOW WHAT STATE THE VEHICLE IS IN
	self ent_flag_init( "veh_removed" );
	
	activate_trigger_with_targetname(self.animname + "_freefall_trig");
	while(!isDefined(ent_get(self.animname + "_freefall_start") ))
	{
		wait(.05);
	}
	
	self ClearAnim( %root, 0 );
	
	self SetAnim( level.scr_anim[self.animname]["bullet_dive"][0], 1, 0 );
	
	wait(0.05);
	
	veh = ent_get(self.animname + "_freefall_start");		
	self OrientMode( "face angle", veh.angles[1] );
	self.anchor = spawn("script_model",self.origin);
	self.anchor setmodel("tag_origin");
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	
	//***self.anchor MoveTo( veh.origin, 0.05 );
	//***self.anchor RotateTo( veh.angles, 0.05 );
	//self.anchor MoveTo(level.weaver_ent.origin + (-20, 50, -100), 0.05);
	self.anchor MoveTo(level.weaver_ent.origin, 0.05);
	self.anchor RotateTo(level.weaver_ent.angles, 0.05);
	
	self.anchor waittill("movedone");
	
	//wait( 0.05 );
	//PrintLn( "origin: "+self.origin[0]+" "+self.origin[1]+" "+self.origin[2]+"\n" );
	//wait( 0.05 );
	
	//***self.anchor linkto(veh);
	self.anchor linkto(level.weaver_ent);
	
	level.weaver_ent thread weaver_free_fall();
		
	wait( 0.05 );
	
	veh thread maps\_vehicle::gopath();
	//self thread ai_stay_in_front_of_player( veh, 150 ); // -- WWILLIAMS: FUNCTION KEEPS THE AI A CERTAIN DISTANCE FROM THE PLAYER
	// self thread ai_debug_end_of_path( veh );
	//self.anchor delete();
	
	veh thread match_player_speed();
	
	self.ignoreme = true;
	
	//stop_dive_node = GetVehicleNode( self.animname + "_stop_bullet_dive", "script_noteworthy" );
	//stop_dive_node waittill( "trigger" );
	
	flag_wait("weaver_caught_up");
	
	wait(0.3);
	
	self SetFlaggedAnimKnob( "transition", level.scr_anim[self.animname]["bullet_dive_trans"], 1, 0.2 );
	
	self waittillmatch( "transition", "end" );
	
	self ClearAnim( level.scr_anim[self.animname]["bullet_dive_trans"], 0.2 );
	
	min_diff_for_anim = 2;
	full_diff_for_anim = 10;
	old_y = self.origin[1];
	
	while( !flag( "ai_pull_chute" ) )
	{
		//PrintLn( "y: "+(self.origin[0] - old_y) );
		right_weight = 0;
		left_weight = 0;
		center_weight = 1;
		if( old_y < self.origin[0]  && (self.origin[0] - old_y) > min_diff_for_anim )
		{
			right_weight = (self.origin[0] - old_y - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			right_weight = min( right_weight, 1 );
			center_weight = 1 - right_weight;
		}
		else if( old_y > self.origin[0] && (old_y - self.origin[0]) > min_diff_for_anim )
		{
			left_weight = (old_y - self.origin[0] - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			left_weight = min( left_weight, 1 );
			center_weight = 1 - left_weight;
		}
		
		old_y = self.origin[0];
		
		self SetAnim( level.scr_anim[self.animname]["freefall"][0], center_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_left"][0], left_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_right"][0], right_weight, 0.2 );
		
		wait( 0.05 );
	}
	
	animtime = GetAnimLength(level.scr_anim["kristina"]["pull_chute"]);
	
	self SetAnim(level.scr_anim["kristina"]["pull_chute"], 1.0, 0.1);
	
	wait(animtime);
	
	while( !flag( "players_landed" ) )
	{
		//PrintLn( "y: "+(self.origin[0] - old_y) );
		right_weight = 0;
		left_weight = 0;
		center_weight = 1;
		if( old_y < self.origin[0]  && (self.origin[0] - old_y) > min_diff_for_anim )
		{
			right_weight = (self.origin[0] - old_y - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			right_weight = min( right_weight, 1 );
			center_weight = 1 - right_weight;
		}
		else if( old_y > self.origin[0] && (old_y - self.origin[0]) > min_diff_for_anim )
		{
			left_weight = (old_y - self.origin[0] - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			left_weight = min( left_weight, 1 );
			center_weight = 1 - left_weight;
		}
		
		old_y = self.origin[0];
		
		self SetAnim( level.scr_anim[self.animname]["freefall"][0], center_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_left"][0], left_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_right"][0], right_weight, 0.2 );
		
		wait( 0.05 );
	}
}


ai_start_tandem_freefall_brooks()
{
	self endon( "death" );
	self notify( "stop_wait_loop" );
	
	self clear_run_anim();
	
	activate_trigger_with_targetname(self.animname + "_freefall_trig");
	while(!isDefined(ent_get(self.animname + "_freefall_start") ))
	{
		wait(.05);
	}
	
	self ClearAnim( %root, 0 );
	
	self SetAnim( level.scr_anim[self.animname]["bullet_dive"][0], 1, 0 );
	
	wait(0.05);
	
	veh = ent_get(self.animname + "_freefall_start");		
	self OrientMode( "face angle", veh.angles[1] );
	self.anchor = spawn("script_model",self.origin);
	self.anchor setmodel("tag_origin");
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	
	self.anchor MoveTo(level.brooks_ent.origin, 0.05);
	self.anchor RotateTo(level.brooks_ent.angles, 0.05);
	
	self.anchor waittill("movedone");
	
	self.anchor linkto(level.brooks_ent);
	
	wait( 0.05 );
	
	self.ignoreme = true;
	
	self ClearAnim( %root, 0.2 );
	
	self SetFlaggedAnimKnob( "transition", level.scr_anim[self.animname]["bullet_dive_trans"], 1, 0.2 );
	
	self waittillmatch( "transition", "end" );
	
	self ClearAnim( %root, 0.2 );
	
	level.brooks_ent thread brooks_free_fall();
	
	min_diff_for_anim = 2;
	full_diff_for_anim = 10;
	old_y = self.origin[1];
	
	while( !flag( "ai_pull_chute" ) )
	{
		//PrintLn( "y: "+(self.origin[0] - old_y) );
		right_weight = 0;
		left_weight = 0;
		center_weight = 1;
		if( old_y < self.origin[0]  && (self.origin[0] - old_y) > min_diff_for_anim )
		{
			right_weight = (self.origin[0] - old_y - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			right_weight = min( right_weight, 1 );
			center_weight = 1 - right_weight;
		}
		else if( old_y > self.origin[0] && (old_y - self.origin[0]) > min_diff_for_anim )
		{
			left_weight = (old_y - self.origin[0] - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			left_weight = min( left_weight, 1 );
			center_weight = 1 - left_weight;
		}
		
		old_y = self.origin[0];
		
		self SetAnim( level.scr_anim[self.animname]["freefall"][0], center_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_left"][0], left_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_right"][0], right_weight, 0.2 );
		
		wait( 0.05 );
	}
	
	self ClearAnim( %root, 0.2 );
	
	animtime = GetAnimLength(level.scr_anim["pierro"]["pull_chute"]);
	
	self SetAnim(level.scr_anim["pierro"]["pull_chute"], 1.0, 0.1);
	
	wait(animtime);
	
	self ClearAnim( %root, 0.2 );
	
	while( !flag( "players_landed" ) )
	{
		//PrintLn( "y: "+(self.origin[0] - old_y) );
		right_weight = 0;
		left_weight = 0;
		center_weight = 1;
		if( old_y < self.origin[0]  && (self.origin[0] - old_y) > min_diff_for_anim )
		{
			right_weight = (self.origin[0] - old_y - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			right_weight = min( right_weight, 1 );
			center_weight = 1 - right_weight;
		}
		else if( old_y > self.origin[0] && (old_y - self.origin[0]) > min_diff_for_anim )
		{
			left_weight = (old_y - self.origin[0] - min_diff_for_anim)/(full_diff_for_anim - min_diff_for_anim);
			left_weight = min( left_weight, 1 );
			center_weight = 1 - left_weight;
		}
		
		old_y = self.origin[0];
		
		self SetAnim( level.scr_anim[self.animname]["freefall"][0], center_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_left"][0], left_weight, 0.2 );
		self SetAnim( level.scr_anim[self.animname]["freefall_right"][0], right_weight, 0.2 );
		
		wait( 0.05 );
	}
}


monitor_player_status()
{
	player = get_players()[0];
	
	player waittill("death");
	
	flag_set("end_freefall");
}


weaver_free_fall()  //self = level.weaver_ent
{
	level endon("end_freefall");
	
	x = -200;
	y = 150;
	z = 0;
	
	self moveto(level.player_ent.origin + (x, y, z), 0.05);
	self waittill("movedone");
	
	// catch up to the player first
	while(z > -300)
	{
		self moveto(level.player_ent.origin + (x, y, z), 0.1);
		wait(0.05);
		
		x = x + 1;
		y = y + 1;
		z = z - 3;
	}
	
	flag_set("weaver_caught_up");
	
	x_rlim = -15;
	x_llim = -75;
	
	y_llim = 150;
	y_rlim = 450;
	
	z_llim = -300;
	z_rlim = -400;
	
	while(!flag("ai_pull_chute"))
	{
		self moveto(level.player_ent.origin + (x, y, z), 0.1);
		wait(0.05);
		
		//adds incremental x movement while freefalling
		sign = RandomInt(100);
		
		if (sign > 50)
		{
			inc = -2;
		}
		else
		{
			inc = 2;
		}
		
		x_mov = x + inc;
		
		if (x_mov > x_rlim)
		{
			x = x_rlim;
		}
		else if (x_mov < x_llim)
		{
			x = x_llim;
		}
		else
		{
			x = x_mov;
		}
		
		//adds incremental y movement while freefalling
		sign = RandomInt(100);
		
		if (sign > 50)
		{
			inc = -2;
		}
		else
		{
			inc = 2;
		}
		
		y_mov = y + inc;
		
		if (y_mov > y_rlim)
		{
			y = y_rlim;
		}
		else if (y_mov < y_llim)
		{
			y = y_llim;
		}
		else
		{
			y = y_mov;
		}
		
		//adds incremental z movement while freefalling
		sign = RandomInt(100);
		
		if (sign > 50)
		{
			inc = -2;
		}
		else
		{
			inc = 2;
		}
		
		z_mov = z + inc;
		
		if (z_mov < z_rlim)
		{
			z = z_rlim;
		}
		else if (z_mov > z_llim)
		{
			z = z_llim;
		}
		else
		{
			z = z_mov;
		}
	}
	
	//chute deployed
	while(z < -250)
	{
		self moveto(level.player_ent.origin + (x, y, z), 0.1);
		wait(0.05);
		
		z += 5;
	}
}


brooks_free_fall()  //self = level.brooks_ent
{
	level endon("end_freefall");
	
	x = 200;
	y = -100;
	z = -580;
	num = 0;
	
	self moveto(level.player_ent.origin + (x, y, z), 0.05);
	self waittill("movedone");
	
	// catch up to the player first
	while(1)
	{
		self moveto(level.player_ent.origin + (x, y, z), 0.1);
		wait(0.05);

		if (y < 850)
		{				
			y += 5;
		}
		
		if (flag("ai_pull_chute"))
		{
			num++;
			
			if (num > 15)
			{
				break;
			}
		}
	}
	
	//chute deployed
	while(z < -200)
	{
		self moveto(level.player_ent.origin + (x, y, z), 0.1);
		wait(0.05);
		
		z += 20;
	}
}


match_player_speed()
{
	wait(3.5);
	
	while(1)
	{
		self SetSpeed(level.player_speed + 10);
		wait(0.05);
	}
}


/*
// -- WWILLIAMS: attempt to control the freefall vehicle speed to keep the ai at the right distance
// -- SELF == AI
*/
ai_stay_in_front_of_player( ent_vehicle, optimal_dist )
{
	self endon( "veh_removed" );

	// ent_vehicle endon( "reached_end_node" );
	if( !IsDefined( optimal_dist ) )
	{
		optimal_dist = 1000;
	}
	
	// optimal_dist = 1000;
	
	wait( 1.0 );
	
	players = get_players();
	AssertEx( IsDefined( players[0].my_fall_speed ), "fall speed not defined yet" );
	
	while( 1 )
	{
		players = get_players();
		
		// get difference of the ai z and the optimal distance z
		destination = players[0].origin[2] - optimal_dist;
		diff = ent_vehicle.origin[2] - destination;
		
		if( diff < 0 )
		{
				/*
				ent_vehicle SetSpeed( 8 );
				wait( 0.05 );
				continue;
				*/
				scale_multipler = 100;
		}
		else
		{
			scale_multipler = 300;
		}
		
		
		// make diff a positive number
		diff = Abs( diff );
		
		// clamp diff between two ranges
		clamp_diff = clamp( diff, 0.1, 100 );
		
		// scale the number?
		scalar_value = linear_map( clamp_diff, 0, 100, 0, 1 );
		
		// translate the player speed
		// from seconds to minutes
		players = get_players();
		inches_per_min = players[0].my_fall_speed * 60;
		
		// from minutes to hours
		inches_per_hour = inches_per_min * 60;
		
		// translate the inches to miles -- 63,360 inches in a mile
		player_mph = inches_per_hour/63360;
		
		// calculate the speed for the ai to travel
		freefall_speed = player_mph + ( scalar_value * scale_multipler );
		
		// set the speed on the vehicle
		ent_vehicle SetSpeed( freefall_speed );
		
		wait( 0.05 );
		
	}
}

/*
// -- debug function, tells me when the ai vehicle hits the end of it's node
*/
ai_debug_end_of_path( ent_vehicle )
{
	self endon( "death" );
	
	ent_vehicle waittill( "reached_end_node" );
	
	//IPrintLnBold( "freefall at end of path" );
}


ai_land(veh)
{

	self notify("start_landing");
	self anim_stopanimscripted();
	waittillframeend;
	self unlink();
	anode = spawn("script_origin",veh.origin);
	ents = array(self,self.chute);
	anode anim_single_aligned(ents,self.animname + "_landing");	

	if(isDefined(self.chute))
	{
		self.chute StopLoopSound(1);
		self.chute notify("landed");
		waittillframeend;
		self.chute delete();
	}
	
	// -- WWILLIAMS: ABOUT TO DELETE THE VEHICLE
	self ent_flag_set( "veh_removed" );
	
	veh delete();
	anode delete();

}

#using_animtree("wmd");
ai_pull_chute(veh)
{
	self notify("chute_pull");
	self._chute_pull_started = true;

	self.chute = spawn("script_model",self.origin );
	self.chute.angles = self.angles;
	self PlaySound( "evt_para_open_3rd" );
	self.chute setmodel("p_jun_basejump_parachute");
	self.chute hide();
	self.chute linkto(self,"tag_origin");
	self.chute.animname = "ai_chute";
	self.chute useanimtree(#animtree);
	self.chute.veh = veh;
	
	guys = array(self,self.chute);
	anim_single(guys,"pull_chute");
	self.chute thread chute_anim_loop();
	self thread anim_loop(self,"chute_float","start_landing");

}


/*------------------------------------
plays animation on the chute after it's deployed
------------------------------------*/
chute_anim_loop()
{
	self endon("landed");
	self endon ("ai_landed");
	
	self PlayLoopSound( "fly_chute_loop" );

	self UseAnimTree(#animtree);
	self.animname = "ai_chute";
	//self show();
	self anim_loop( self, "chute_loop", "landed" );
}


/*------------------------------------
sam missile launch and reactions
------------------------------------*/
launch_sa2_and_react()
{
	//boulder/avalanche
	trigger_wait("missile_rocks","targetname");
		
	//level thread missile_rocks();
	//level thread missile_vo();
	level thread do_sprint_unlimited();
	level thread do_sprint_hint();
	level thread sprint_hint_timer();
	//level thread do_wipeout();
	level thread push_player_off();
	level thread fall_to_death();
	
	wait (3.0);
	
	level thread missile_rocks(); //temp put here
	
	//last missiles	
	trigger_wait("sa2_launch","targetname");
	
	flag_set("approach_jump");

	align_node = getnode("parachute_align","targetname");
	anim_ents = array(level.heroes["kristina"],level.heroes["pierro"]);
	
	level.heroes["kristina"].animname = "kristina";	//weaver
	level.heroes["pierro"].animname = "pierro";		//brooks

	//align_node thread anim_single_aligned(anim_ents,"sam_react");
	wait(2);
		
	//need to wait till anim done -jc
	level notify( "missile_done");
}


push_player_off()
{
	level endon("approach_jump");
	level endon("off_cliff");
	
	while(1)
	{
		player = get_players()[0];
		
		vel = player GetVelocity();
		
		if (player JumpButtonPressed())
		{
			wait(3.0);
		}
		
		if (vel[1] < 10)
		{
			player SetVelocity(vel + (30, 0, 0));
		}
		
		if (vel[1] < 80 && vel[1] > 10)
		{
			player SetVelocity(vel + (20, 0, 0));
		}
		
		if (vel[1] < 140 && vel[1] > 80)
		{
			player SetVelocity(vel + (15, 0, 0));
		}
		
		if (vel[1] > 140)
		{
			player SetVelocity(vel + (5, 0, 0));
		}
		
		wait( 0.05 );
	}
}


fall_to_death()
{
	trigs = getentarray("trigger_kill_player", "targetname");
	
	for(i=0; i<trigs.size; i++)
	{
		trigs[i] thread wait_player_fall();
	}
}


wait_player_fall()
{
	level endon("players_jumped");
	
	self waittill("trigger");
	
	if (!flag("players_jumped"))
	{
		get_players()[0] DoDamage(get_players()[0].health, get_players()[0].origin);
	}
}
	

missile_rocks()
{
	rock1 = GetEnt( "avalanche_fall_piece01", "targetname" );
	rock2 = GetEnt( "avalanche_fall_piece02", "targetname" );
	
	wait 4;
	//IPrintLnBold( "rock1" );
	//rock1 Delete();
	rock1 MoveZ( -1000, 5 );
	
	trigger_wait("sa2_launch","targetname");

	//IPrintLnBold( "rock2" );
	//rock2 Delete();
	rock2 MoveZ( -1000, 5 );
}


do_sprint_unlimited()
{
	//slow player speed
	get_players()[0] SetMoveSpeedScale(0.75);

	//give unlimited sprint 
	get_players()[0] SetClientDvar("player_sprintUnlimited", 1);
	
	flag_wait("players_jumped");	//too late?
	
	//reset
	get_players()[0] SetMoveSpeedScale(1);
	get_players()[0] SetClientDvar("player_sprintUnlimited", 0);
}


do_sprint_hint()
{
	level endon("end_sprint_hint");
	
	player = get_players()[0];
	
	dvarName = "player" + player GetEntityNumber() + "downs";
	player.downs = getdvarint( dvarName );
	
	if (player.downs > 1)
	{
		//tell player to sprint
		screen_message_create(&"WMD_SPRINT_HINT");
	
		while(1)
		{
			if( get_players()[0] issprinting( true ) )
			{
				screen_message_delete();
				break;
			}
			else
			{
				wait .5;		
			}	
		}
	}
}


sprint_hint_timer()
{
	wait(10.0);
	
	flag_set("end_sprint_hint");
	
	screen_message_delete();
}


do_shakeandrumble()
{
	self endon("death");
	level endon("stop_quaking");
	level endon("players_jumped");
	level endon("players_landed");
	level endon("cord_pull");
	
	waittime = 1;
	
	clientnotify ("avalanch");
	
	self thread shake_on_jump();
	
	while(1)
	{
		wait(waittime);
		if( waittime > .5 )
		{
			earthquake(randomfloatrange(.3,.8),.45,self.origin,5000);
			self PlayRumbleOnEntity("damage_heavy");
		}
		else
		{
			earthquake(randomfloatrange(.1,.5),.25,self.origin,5000);
			self PlayRumbleOnEntity("reload_small");
		}
		waittime -= .1;
		if( waittime < .2 )
		{
			waittime = .2;
		}	
	}
}


shake_on_jump()
{
	level endon("player_has_jumped");
	
	trigger_wait("trigger_basejump");
	
	level notify("stop_quaking");
	
	self shellshock("explosion", 1.5);
	
	while(1)
	{
		earthquake(randomfloatrange(.3,.8),.45,self.origin,5000);
		self PlayRumbleOnEntity("damage_heavy");
		wait(0.3);
	}
}


//kill player if he's lagging during avalanche
do_wipeout()
{
	self endon("death");
	level endon("players_jumped");	//may need a better endon
	
	//basejump spot
	marker = GetEnt( "objective_2","script_noteworthy");
	
	player = get_players()[0];	
	
	old_dist = distance(player.origin,marker.origin);
	threshold = 192;
	
	while(1)
	{
		wait 2;
		dist = distance(player.origin,marker.origin);
		progress = old_dist - dist;
		
		//IPrintLnBold( "progress ", progress);
		
		if( progress < threshold )
		{
				//player not moving enough
				break;
		}
		else
		{
			old_dist = dist;
		}
	
		//ramp difficulty
		threshold += 16;
		
		if( threshold > 320 )
		{
			threshold = 320;
			
		}
	}
	
	MissionFailed();
	//IPrintLnBold( "TOO SLOW, You're Dead" );	
}


play_avalanch_sound (player )
{
	player thread avalanch_sound();
	rock_ents = getstructarray("amb_avalanch_rocks", "targetname");	
	for (i=0;i<rock_ents.size;i++)
	{
		rock_ents[i] thread rock_debris_sound();	
	}	
	
}
avalanch_sound()
{
	sound_ent = spawn ("script_origin", self.origin);	
	sound_ent playloopsound ("evt_avalanch_high");
	
	level waittill ("player_has_jumped");
	
	sound_ent stoploopsound(2);
	
}
rock_debris_sound()
{
	level endon ("players_jumped");
	while(1)
	{
		wait (randomfloatrange (0.5, 3));
		playsoundatposition ("evt_avalanch_rock_hit", self.origin);	
				
	}	
	
}


missile_vo()
{
	level.brooks animscripts\face::SaySpecificDialogue( undefined, "vox_wmd1_s01_350A_broo", 1.0, "sound_done" ); 
	level.brooks waittill( "sound_done" );

	//level.weaver animscripts\face::SaySpecificDialogue( undefined, "vox_wmd1_s01_211A_weav", 1.0, "sound_done" ); 
	//weaver waittill( "sound_done" );

	player = get_players()[0];
	pilot = player;
	
	wait 3;
	
	level.brooks animscripts\face::SaySpecificDialogue( undefined, "vox_wmd1_s01_352A_broo", 1.0, "sound_done" ); 
	level.brooks waittill( "sound_done" );
	
	wait 2;
	
	level.weaver animscripts\face::SaySpecificDialogue( undefined, "vox_wmd1_s01_206A_weav", 1.0, "sound_done" ); 

}

//gust from missiles
missile_snow()
{
	player = get_players()[0];	

	//play snow/wind at feet
	//PlayFX (level._effect["snow_gust_wind_burst"], player.origin + (0,0,64) ); //not working

	
}
//bouncing rocks
rock_slide()
{
	//start rock slide
	org = GetEnt( "rock_slide", "script_noteworthy" );
	for( i = 0; i < 3; i++)
	{
		PhysicsExplosionSphere( org.origin, 800, 800, 3 );
		wait(.5);
	}
}

//temp 
rock_fx()
{
	level endon( "missile_done"); //should be earlier
	
	while(1)
	{
		PlayFX (level._effect["rocks_falling"], self.origin);	// can use fx_snow_wall_hvy nr base jump
		wait( RandomIntRange( 2,4  ) );
		
	}
}


missile_launch()
{
//	trigger_wait("sa2_launch","targetname");
	//missile = ent_get("sa2");
	
	fx = spawn("script_model",self.origin);
	fx.angles = (-90,0,0);
	fx setmodel("tag_origin");
	fx linkto(self);
	playfxontag(	level._effect["sa2_trail"],fx,"tag_origin");
	self moveto(self.origin + (0,0,10000),3);
	//self thread missile_rumble();
	//avalanche fx
	exploder(100);
	self waittill("movedone");
	self delete();
	fx Delete();
}


//rumble when missiles go by
missile_rumble()
{
	self endon("movedone");
	player = get_players()[0];	
	
	while(1)
	{
		wait(randomfloat(.15));
		//earthquake(randomfloatrange(.1,.25),5,self.origin,8000);
		if(distancesquared(player.origin,self.origin) < 3000*3000)
		{
			player PlayRumbleOnEntity("damage_heavy");
		}	
	}
}

////Control Room

hut_breach()
{	
	flag_wait ("hut_breach_go"); //-add a trig so it's easier to debug - jc
		
	//trigger on player_breach door
	hut_breach_trigger = ent_get ("hut_breach_trigger");
		
	//player trigger door kick
	hut_breach_trigger waittill ("door_opening");
	
	flag_set( "obj_personnel_a_c" );
	
	//get rid of door collision
	door_col = GetEnt( "kick_door_collision", "targetname" );
	door_col connectpaths();
	door_col trigger_off();
	
	//door kick sound
	clientnotify ("breach_begin" );
		
	//wait for door to be opened
	hut_breach_trigger waittill ("kick_door_opened");
	
	flag_set ("breach_begin");
	
	trigger_wait("last_wave_lower");
	
	door_col = GetEnt( "kick_door_collision", "targetname" );
	door = getent("door_com_stat", "targetname");
	door rotateyaw(-155, 0.3);
	door_col trigger_on();
	wait(0.1);
	door_col disconnectpaths();
}


comm_station_breach()
{
	flag_wait ("hut_breach_go");
	
	desk_guy = simple_spawn_single("desk_guy",::init_floor_guys);
	floor_guy = simple_spawn_single("floor_guy",::init_floor_guys);
	desk_guy02 = simple_spawn_single("desk_guy02",::init_desk_guy);
	
	//these guys get killed by repel guys
	guys = simple_spawn("repel_breach_guys",::repel_breach_guys_init);	
	array_thread(guys,::breach_guys_leadin);
	
	anode = ent_get ("repel_align");
	
	flag_wait ("breach_begin");
	
	level.weaver gun_switchto("ak12_zm", "right");
	level.brooks gun_switchto("aug_arctic_acog_sp", "right");
	level.harris gun_switchto("aug_arctic_acog_sp", "right");
	
	battlechatter_on();
	
	//kevin adding a voice line to one of the scientists so there is a yell when the fight starts.
	if (isAlive(desk_guy))
	{
		desk_guy playsound( "vox_wmd1_s01_153B_sov3" );
	}
	
	//force player to look in direction
	level thread breach_player_look();
	
	//was in knife_throw, moved here so weaver doesn't shoot into room
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		ai[i].pacifist = 0;
		ai[i].ignoresuppression = 0;
		ai[i].accuracy = .8;
		ai[i].ignoreme = false;
		ai[i].ignoreall = false;	
	}
	
	//wait to start ai breach
	wait( 0.5 );
		
	//setup squad new color chains
	level.heroes["kristina"] set_force_color( "b" );
	
	//color trigger puts squad in position for hut battle!
	activate_trigger_with_targetname ("squad_in_position");
	
	level.heroes["kristina"] disable_cqbwalk();
	
	//get actors
	guy01 = level.heroes["pierro"];
	guy01.animname = "guy01";
	guy01 disable_ai_color();
	guy01 thread reset_commstat_color();
	
	guy02 = level.heroes["glines"];
	guy02.animname = "guy02";
	guy02 disable_ai_color();
	guy02 thread reset_commstat_color();
	
	russ01 = getai_by_noteworthy("russ01");
	russ02 = getai_by_noteworthy("russ02");
	
	if (isalive(russ01))
	{
		russ01.health = 100;
		russ01.ignoreme = true;
	}
	if (isalive(russ02))
	{
		russ02.health = 100;
		russ02.ignoreme = true;
	}

	//create array for the animation
	anim_ents = [];
	anim_ents[anim_ents.size] = guy01;
	anim_ents[anim_ents.size] = guy02;
	anim_ents[anim_ents.size] = russ01;	
	anim_ents[anim_ents.size] = russ02;
	
	//play anim scene	
	anode anim_single_aligned ( anim_ents, "repel_breach" );
	
	node_harris = getnode("harris_post_breach", "targetname");
	node_brooks = getnode("brooks_post_breach", "targetname");
	
	guy01 setgoalnode(node_brooks);
	guy02 setgoalnode(node_harris);
	
	//turns off ignoreme and other variables for battle purposes
	array_thread (level.heroes, ::heroes_fighting);
	
	flag_set ("hut_breach_ended");
}


reset_commstat_color()
{
	trigger_wait("inital_radar_cleared");
	
	self set_force_color("r");
	
	self enable_cqbwalk();
}


gunshot_comm_station()
{
	level endon("breach_begin");
	
	trigger_wait("trigger_outside_commdoor");
	
	trigger = getent("trigger_outside_commdoor", "targetname");
	
	while(1)
	{
		player = get_players()[0];
		
		if (player isTouching(trigger) && player AttackButtonPressed())
		{
			currentweapon =  player GetCurrentWeapon();
			
			if ((currentweapon == "crossbow_vzoom_alt_sp") || (currentweapon == "aug_arctic_acog_silencer_sp"))
			{
				wait(0.05);
			}
			else
			{
				flag_set ("breach_begin");
			}
			
			if (currentweapon == "crossbow_explosive_alt_sp")
			{
				wait(2.5);	//wait for explosion
				flag_set ("breach_begin");
			}
		}
		
		wait(0.1);
	}
}


//make guy look at window
breach_player_look()
{
	//lerp player to look at breach
	wait(.25);	//need a notify when anim finished
	node = GetNode( "lookat_breach", "targetname" );
	player = get_players()[0];
	//player waittill( "door_breached" );
	player StartCameraTween( 0.5 );
	player SetPlayerAngles(node.angles);
}


heroes_fighting()
{
	self.pacifist = 0;
	self.ignoreme = false;	
	self disable_pain();
	self disable_react();	
}	


#using_animtree("generic_human");
breach_guys_leadin()
{
	self endon( "death" );
	
	node = ent_get ("repel_align");
	
	node anim_reach_aligned(self,"repel_breach");
	
	self thread anim_loop (self,"talking"); 
	
	//wait for player to open the door
	flag_wait ("breach_begin");
	
	self anim_stopanimscripted();
}


#using_animtree("generic_human");
init_floor_guys()
{
	self endon( "death" );
	
	self.pathenemyFightdist = 40; 
	self.ignoresuppression = true;
	self.ignoreall = true;
	self.ignoreme = true;

	self.animname = "generic";
	self thread anim_loop (self, "ai_smoking");
	
	flag_wait ("breach_begin");
	
	self.allowdeath = true;
	self anim_stopanimscripted();
	wait(1.7);
	//self anim_single ( self, "react" );
	self allowedstances("stand","crouch","prone");
	self.ignoreall = false;
	self.ignoreme = false;
}


/*----------------------------------------------------------------------------------------------
The scientists sitting in the control room 
-----------------------------------------------------------------------------------------------*/
init_desk_guy()
{
	if(self.targetname == "desk_guy_ai")
	{
//		//self.animname = "desk_guy01";
//		//self thread desk_guys_logic("desk01","chair01","breach_loop","react1");
//		self thread init_floor_guys();
	}
	else if(self.targetname == "desk_guy02_ai")
	{
		self.animname = "desk_guy02";
		self thread desk_guys_logic("desk02","chair02","breach_loop02","react02");
	}	
	
	self.ignoreme = true;
	self.pathenemyFightdist = 40; 
	self.ignoresuppression = true;
	self.ignoreall = true;
	self gun_remove();
}


desk_guys_logic(desk_targetname, chair_targetname, loop_anim, react_anim)
{
	self endon( "death" );
	
	desk = ent_get (desk_targetname);
	chair = ent_get (chair_targetname);

	node = spawn("script_model", chair.origin);
	
	if(self.animname == "desk_guy01")
	{	
		node.angles = (0, 0, 0);	//was 0,180,0
	}
	else
	{
		node.angles = chair.angles;
	}
	//model = spawn("script_model", desk.origin);
	//model.angles = desk.angles;
	model = spawn("script_model", chair.origin);
	model.angles = chair.angles;
	model setmodel ("tag_origin_animate");
	model.animname = chair_targetname;
	model useanimtree(level.scr_animtree[chair_targetname]);	
	chair linkto (model,"origin_animate_jnt");
	
	anim_ents = array (model, self);
	
	node thread anim_loop_aligned (anim_ents, loop_anim );
	
	//wait for player to open the door
	flag_wait ("breach_begin");
	
	self.allowdeath = true;
	
	wait(0.5);
	
	self attach("t5_weapon_cz75_world", "tag_weapon_right");

	node anim_single_aligned (anim_ents, react_anim); 
	
	//self gun_recall();
	//self.a.allow_sideArm = false;	
	self.ignoreme = false;
	self.ignoreall = false;
	self.goalradius = 16;
	chair unlink();
	
	self thread bloody_death(true, 0);
}


#using_animtree("generic_human");
repel_breach_guys_init()
{	
	self.allowdeath = true;
	self.goalradius = 8;
	//self.pacifist = true;
	//self.pacifistwait = 0;
	self.ignoreall = true;
	self clearenemy();
	self.animname = self.script_noteworthy;
	//self.deathanim = %dying_back_death_v1;
	self.dropweapon = 0;
}


//battle inside radar room
hut_battle()
{
	level thread wait_upstairs_clear();
	
	//wait until the breach is over
	flag_wait ("hut_breach_ended");
		
	//wait(.5); - jc bring them in right away
	//spawn function for hut enemies 
	array_thread (ent_get("hut_baddies"), ::add_spawn_function, ::hut_baddies_logic);
	//spawn them
	activate_trigger_with_targetname ("hut_spawner");
	
	trigger_wait( "initial_radar_cleared" );
	
	player = get_players()[0];
	player anim_single(player, "multiple");		//Kilo One you have multiple targets inbound to the comstat!
}


wait_upstairs_clear()
{
	trigger_wait("trigger_upstairs_guys");
	
	wait(2.0);
	
	while(1)
	{
		guys = getaiarray("axis");
		
		num = 0;
		
		for(i=0; i<guys.size; i++)
		{
			if (guys[i].origin[2] > 38475)		//is guy upstairs?
			{
				num++;
			}	
		}
		
		if (!num)
		{
			break;
		}
		
		wait(0.1);
	}	
	
	trigger_use("triggercolor_comstat_downstairs");
}


hut_baddies_logic()
{
	self endon("death");

	self.pathenemyFightdist = 40; 
	self.ignoresuppression = true;
}


//last wave before in room
control_final_wave()
{
	//lower last guys
	trigger_wait("last_wave_lower" );
	
	level thread control_final_lower();
			
	//upper last guys
	trigger_wait("last_wave_upper" );
	control_lmg = simple_spawn( "control_lmg" );

	wait 5;

	level thread control_spetz_slide();
	
	wait 5;
	
	while(1)
	{
		count = get_ai_group_count( "control_guys" );
		if( count < 5 )
		{
				level thread control_spetz_slide();
				break;
		}
		else
		{
			wait .5;
		}
	}
	
	waittill_ai_group_cleared ("control_guys");	

	wait 2;	//beat
	
	level.weaver anim_single(level.weaver, "shut_down");  //We're clear. Hudson, shut down the relay dish.
	
	//update obj to powerbox
	flag_set( "obj_radar" );
	// obj = getent("objective_1","script_noteworthy");
	// objective_position(1,obj.origin);
	// objective_set3d(1,1);

	//nag player 
	level thread control_nag();
}


control_final_lower()
{
	//breach door
	//door = GetEnt( "control_door_lower", "targetname");
	//door ConnectPaths();
	org = GetEnt( "control_door_lower_org", "targetname");
	
	//play explosion fx
	PlayFX(	level._effect["breach_door_smoke"], org.origin );
	
	//launch door
	org playsound ("wpn_grenade_explode");
	//door MoveY( 600, 1 );
	PhysicsExplosionSphere( org.origin, 512, 512, 3 );
	//door Delete();
}


control_nag()
{
	player = get_players()[0];
	//obj = getent("objective_1","script_noteworthy");
	//dist = distancesquared(player.origin,obj.origin);
	trig = GetEnt( "control_cleared", "targetname");
	toggle = 0;
	trig endon ( "trigger" );
	
	while( !player IsTouching( trig ) )
	{
		wait (8.0);
		
		//say line if player is too far away
		if ( toggle == 0 )
		{
			level.weaver anim_single(level.weaver, "relay_prompt1");		//Hudson! You need to find the relay switch!
			toggle = 1;
		}
		else
		{
			level.weaver anim_single(level.weaver, "relay_prompt2");		//Come on Hudson, we need to get moving!
			toggle = 0;
		}
	}	
}


#using_animtree("generic_human");
control_spetz_slide()
{
	loc = get_players()[0].origin[2];
	
	while(loc > 38480)	//don't spawn the guys if the player is upstairs
	{
		loc = get_players()[0].origin[2];
		
		wait(0.1);
	}
	
	spetz1 = simple_spawn_single("spetz1", ::setup_spetz1);	
	spetz2 = simple_spawn_single("spetz2", ::setup_spetz2);	
}


setup_spetz1()
{
	self endon("death");
	
	anode = ent_get ("repel_align");
	
	self.animname = "spetz1";
	self.allowdeath = true;
	self.isRushing = false;
	
	dist = int(Distance2D(self.origin, get_players()[0].origin));
	
	if ((dist > 750) || (get_players()[0].origin[2] < 38300))
	{
		anode anim_single_aligned (self, "spetz_slide");	
	}
	else
	{
		self thread maps\_rusher::rush();
		self.isRushing = true;
	}
	
	if(RandomInt(2) == 0 && !self.isRushing)
	{
		self thread maps\_rusher::rush();
	}
}


setup_spetz2()
{
	self endon("death");
	
	anode = ent_get ("repel_align");
	
	self.animname = "spetz2";
	self.allowdeath = true;
	self.isRushing = false;
	
	dist = int(Distance2D(self.origin, get_players()[0].origin));
	
	if ((dist > 750) || (get_players()[0].origin[2] < 38300))
	{
		anode anim_single_aligned (self, "spetz_slide");	
	}
	else
	{
		self thread maps\_rusher::rush();
		self.isRushing = true;
	}
}


//hut_clear_monitor()
//{
//	
//	trig = getent("stack_up_outside","targetname");
//	trig trigger_off();
//	
//	
//	flag_wait ("right_side_clear");
//	flag_wait ("left_side_clear");
//	
//	//color trigger moves entire squad up
//	activate_trigger_with_targetname ("outside_hut_clear");	
//	wait(1);
//	trig trigger_on();
//}	

/*------------------------------------
the player sabotages the relay station 
------------------------------------*/

//make into objective tracker?

event1_wait_for_objectives_done()
{
	flag_wait ("hut_breach_ended");
	
	waittill_ai_group_cleared ("control_guys");	
	
	flag_set( "obj_radar" );
}


#using_animtree("wmd");
wait_for_sabotage()
{
	//this is the actual USE trigger to sabotge the dish
	sabotage_relay_trigger = ent_get ("sabotage_relay");

	//turn off until ready
	sabotage_relay_trigger trigger_off();
	
	//monitor if all guys are dead in last wave
	waittill_ai_group_cleared ("control_guys");
	
	battlechatter_off();
	
	//sabotage nodes for squad
	level thread sabotage_squad_setup();
	
	trig = getent("trigger_sabotage", "targetname");
	
	player = get_players()[0];
	
	while(1)
	{
		trig waittill("trigger");
		
		get_players()[0] SetScriptHintString(&"WMD_USE_DESTROY_DISH");
				
		while((player isTouching(trig)) && (!player use_button_held()))
		{
			wait(0.05);
		}
		
		get_players()[0] SetScriptHintString("");
		
		if (player use_button_held())
		{
			break;
		}
	}
	
	player = get_players()[0];
	player disableweapons();
		
	//send guys to other side of ledge
	level thread ledge_squad_setup();
	
	//pulling wires anim
	wires = ent_get("sabotage_wires");
	player_hands = spawn_anim_model("player_sabotage_hands",wires.origin,wires.angles);
	wires.animname = "sabotage_wires";
	wires useanimtree(#animtree);
		
	player playerlinktoabsolute(player_hands);
	
	ents = array(wires,player_hands);
	wires thread do_initial_sparks();
	
	playsoundatposition ("evt_pull_power_cords", (0,0,0));
	
	wires anim_single_aligned(ents,"sabotage");
	player unlink();
	player_hands delete();
	player enableweapons();	
	
	//turn off lights
	clientnotify("power_light");
	
	//stop dish from rotating
	flag_set("relay_station_sabotaged");
	
	level thread sabotage_vo();
	
	level notify( "stop_radar_dish" ); // -- WWILLIAMS: STOPS THE NEW FX ANIM WAITING FOR A NOTIFY
	level notify ("base_alarm_off");
	
	//fx for post sabotage
	exploder( 84 );
	
	//sound
	playsoundatposition("amb_power_down", (0,0,0));
	
	//set up the guys climbing the cliff animations 
	level thread guys_climb_cliff();
	
	ClientNotify("start_heartbeat");	
	
	wait(30);
	
	wires notify("stop_sparks");
}


//moves the guys to correct spots for sabotage event
sabotage_squad_setup()
{
	//take off color chain
	array_thread(level.heroes, ::disable_ai_color);
	
	level.heroes["kristina"] thread force_goal();
	level.heroes["pierro"] thread force_goal();
	level.heroes["glines"] thread force_goal();
	
	//send to nodes
	node_weaver = GetNode( "sabotage_weaver", "targetname");
	level.heroes["kristina"] SetGoalNode( node_weaver );
	
	node_brooks = GetNode( "sabotage_brooks", "targetname");
	level.heroes["pierro"] SetGoalNode( node_brooks );
	
	node_harris = GetNode( "sabotage_harris", "targetname");
	level.heroes["glines"] SetGoalNode( node_harris );
}


sabotage_vo()
{
	level endon("to_ledge");
	
	wait(0.5);
	
	player = get_players()[0];
	player.animname = "hudson";
	
	player anim_single(player, "confirm_offline");  //BigEye this is Kilo One. Confirm that the relay is offline, over?
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "com_ceased");  //Affirmative Kilo One. All communications are offline. We have zero chatter.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "to_primary");  //Kilo 1 - Moving to the Primary Target.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "bow_out");  //Okay Gentlemen, we're running on fumes now... this is where we bow out.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "leave_recon");  //Leaving recon.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "stay_safe");  //Copy that BigEye. Thanks for the help. Stay safe.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "bigeye_out");  //Affirmative. BigEye out.
}


vo_to_ledge()
{
	wait(1.5);
	
	level.weaver anim_single(level.weaver, "wont_take");	//It won't take them long to figure out we're here. Let's move.
	
	flag_wait("rpg_shoot");
	
	level.weaver anim_single(level.weaver, "rpg_ledge");		//RPG on the ridge!
	
	wait(0.5);
	
	level.brooks.animname = "brooks";
	level.brooks anim_single(level.brooks, "off_ledge");		//Hudson! Get off the ledge!
	
	flag_wait("lost_harris");
	
	player = get_players()[0];
	player anim_single(player, "lost_harris");  //We lost Harris!
	
	wait(1.0);
	
	level.weaver anim_single(level.weaver, "avalanche");		//Avalanche!!!!
	
	wait(1.0);
	
	level.weaver anim_single(level.weaver, "run_run");		//Hudson! Run! RUN!
	
	wait(1.5);
	
	player = get_players()[0];
	player anim_single(player, "gogogo");  //Go!  Go!  Go!
}


//moves guys for ledge
ledge_squad_setup()
{
	//open ledge door
	door = GetEnt( "ledge_door", "targetname");
	door_model = GetEnt( door.target, "targetname" );
	door_model LinkTo( door );
	door MoveZ( -300, 0.1 );	//rotate so can close during ledge event
	door waittill("movedone");
	door ConnectPaths();
			
	//put guys on blue color chain
	level.heroes["pierro"] set_force_color( "r" );
	level.heroes["kristina"] set_force_color( "b" );
	
	level.heroes["pierro"] disable_cqbwalk();
	level.heroes["kristina"] disable_cqbwalk();
	level.heroes["glines"] disable_cqbwalk();
	
	level.heroes["pierro"].grenadeawareness = 0;
	level.heroes["kristina"].grenadeawareness = 0;
	
	ledge_org = getstruct("missile_skipto", "targetname");
	
	level.heroes["pierro"] forceteleport(ledge_org.origin);
	level.heroes["kristina"] forceteleport(ledge_org.origin + (0, -20, 0));
		
	//send them across ledge
	ent_get("post_sabotage_color") notify("trigger");

	//make him not targeted
	level.heroes["glines"].ignoreme = true;
	level.heroes["glines"].pacifist = true;
	level.heroes["glines"].goalradius = 16;
	//level.heroes["glines"].sprint = true;
		
	//send harris to node
	trig = GetEnt( "control_cleared", "targetname");
	player = get_players()[0];
	
	node = GetNode("post_sabotage_harris", "targetname");
	level.heroes["glines"] thread force_goal();
	level.heroes["glines"] SetGoalNode(node);
	
	trigger_wait("trigger_harris_ledge");
		
	//send to intermediate node
	//node = GetNode( "ledge_trans", "targetname" );	
	//level.heroes["glines"] SetGoalNode( node );
	
	level.heroes["glines"].grenadeawareness = 0;

	//send harris to ledge - slow player speed?
	level.heroes["glines"] thread force_goal();
	node = GetNode( "ledge_death", "targetname" );
	level.heroes["glines"] SetGoalNode( node );
		
	//player leaves room
	trigger_wait("ledge_spawn");
	
	flag_set("to_ledge");
	
	level thread vo_to_ledge();
	
	//player walks onto ledge
	trigger_wait("ledge_shoot");
		
	//door closes so player cant break ledge event
	door MoveZ( 300, 0.1 );	//rotate so can close during ledge event
}


do_initial_sparks()
{
	self endon("stop_sparks");
	
	wait(1.5);	
	
	playfxontag(	level._effect["wire_sparks"] ,self,"tag_cable03_fx");
	playsoundatposition ("evt_comp_room_sparks", self.origin);
	
	self thread continue_sparking("tag_cable03_fx");
	
	wait(2);
	
	playfxontag(	level._effect["wire_sparks"] ,self,"tag_cable01_fx");
	playsoundatposition ("evt_comp_room_sparks", self.origin);
	
	playfxontag(	level._effect["wire_sparks"] ,self,"tag_cable02_fx");
	playsoundatposition ("evt_comp_room_sparks", self.origin);
	
	self thread continue_sparking("tag_cable01_fx");
	self thread continue_sparking("tag_cable02_fx");
}


continue_sparking(tag)
{
	self endon("stop_sparks");
	while(1)
	{
		playfxontag(	level._effect["wire_sparks"] ,self,tag);
		playsoundatposition ("evt_comp_room_sparks", self.origin);
		wait randomfloatrange(.1,.5);
	}	
}


//ledge event - catwalk after radar
// -- WWILLIAMS: CAME BACK TO FIX THIS FUNCTION SO IT WORKS WITH THE NEW FXANIM PROVIDED BY JESS'S GROUP
ledge()
{
	// objects
	// level.broken_ledge_fx
	
	//hide destroyed ledge
	level.broken_ledge_fx thread ledge_hide();
	
	//hide rope
//	ropes = GetEntArray( "ledge_rope", "targetname" );
//	for( i= 0; i < ropes.size; i++ )
//	{
//		//ropes[i] ledge_hide();
//		ropes[i] Hide();
//
//	}
		
	//wait for player to sabotage the base first
	flag_wait("relay_station_sabotaged");
	
	level thread ledge_guy();
	
	level waittill( "ledge_break" );
		
//	for( i= 0; i < ropes.size; i++ )
//	{
//			PhysicsExplosionSphere( ropes[i].origin, 256, 128, 3 );
//			wait( .1 );
//		
//	}	
		
}


// -- WWILLIAMS: NO LONGER HIDES THE PIECES JUST SHOWS THE FXANIM BROKEN VERSION
ledge_hide()
{
	level waittill( "ledge_break" );
	
	level notify( "catwalk_start" );
	
	self Show();
}


ledge_guy()
{
	// objects
	anim_origin = GetEnt( "repel_align", "targetname" );
	
	player = get_players()[0];
	
	//spawn ledge_redshirt 
	//trigger_wait("ledge_spawn");
	trigger_wait("ledge_shoot");
	
	flag_set("rpg_shoot");
	
//	setmusicstate("AVALANCH");
	
	level thread maps\wmd_amb::event_heart_beat( "relaxed", 0 );
	
	//spawn rpg guy
	rpg_guy = simple_spawn_single("ledge_rpg", ::setup_rpg_ledge);
	
	//player walks onto ledge
	//trigger_wait("ledge_shoot");
			
	flag_wait("rpg_shot");

	level thread maps\wmd_amb::event_heart_beat( "stressed", 1 );

	//level thread ledge_slowmo();
	
	//spawn extra enemies
	//extra_guy = simple_spawn_single("ledge_guy");
	
	//kill redshirt, put in ragdoll
	//ledge_redshirt waittill( "damage" );
	//spot SetCanDamage( true );
	//spot waittill("damage" );
	wait( .7 );	//TODO temp till figure a way to get a notify -jc
	
	//ledge collapse	
	level thread ledge_break();
	level notify( "ledge_break");
	
	//temp this will be animated
	level.heroes["glines"] unmake_hero();
	old_animname = level.heroes[ "glines" ].animname;
	level.heroes[ "glines" ].animname = "harris";
	
	// player the animation on the player
	// -- anim_origin
	player = get_players()[0];
	body = spawn_anim_model( "player_body" , player.origin, player.angles );
	body useanimtree( level.scr_animtree[ "player_body" ] );
	body.animname = "player_body";
	player PlayerLinkToAbsolute( body, "tag_player" );
	player HideViewModel();
	
	// -- play anim on player and ai
	level.heroes["glines"] gun_remove();
	anim_origin thread anim_single_aligned( level.heroes[ "glines" ], "ledge_fall" );
	anim_origin anim_single_aligned( body, "player_ledge_fall" );
	
	flag_set("lost_harris");
	
	vel = player GetVelocity();
	player SetVelocity(vel + (30, 0, 0));
	
	body Hide();
	players = get_players();
	players[0] Unlink();
	players[0] ShowViewModel();
	body Delete();
	
	clip_player = getent("clip_player_ledge", "targetname");
	clip_player delete();
	
	player thread do_shakeandrumble();
	level thread play_avalanch_sound(player);
	level thread ledge_gap_timer();
	level thread base_jump_timer();
	
	wait(2.0);
	
	clip = getent("catwalk_undestroyed_collision", "targetname");
	clip delete();
}


setup_rpg_ledge()
{
	self endon("death");
	
	self.ignoreme = true;
	self.ignoreall = true;
	self.pacifist = true;
	self.takedamage = false;
	self.goalradius = 16;
	
	self thread force_goal();
	
	self waittill("goal");
	
	self AllowedStances("crouch");
	
	spot = GetEnt("ledge_target", "targetname"); 	
	
	self thread shoot_at_target(spot);

	self waittill ("shoot");
	
	flag_set("rpg_shot");
	
	//can kill him now
	self.ignoreme = false;
	self.pacifist = false;
	self.takedamage = true;
	
	wait(3.0);
	
	self thread bloody_death();
	//self StartRagdoll();
	//self LaunchRagdoll( (50,0,10) );
}



//start after rpg is fired
ledge_slowmo()
{
	//pause
	wait .5;
	SetTimescale( 0.2 );	
	wait 1;
	timescale_tween( 0.2, 1, 0.5 );
	
}


//handle the catwalk breaking
ledge_break()
{
	//"start" avalanche shader
	avalanche = getent("basejump_avalanche_hide", "targetname");
	avalanche delete();
	
	//define player
	player = get_players()[0];
	
	//ledge collapses
	//PlayFX (level._effect["rocks_falling"], spot.origin);
	spot = GetEnt( "ledge_target", "targetname" ); 	
	
	//fx for rpg hitting ledge
//	playsoundatposition ("exp_mortar_dirt", player[0].origin);

	exploder( 91 );

	Earthquake(0.65, 1.5, player.origin, 3000);
	player ShellShock( "explosion", .75 );
	player SetStance("prone");
	
	ledge_new = GetEnt("ledge_new", "targetname");
	ledge_new Delete();
	
	//show damaged ledge
	
	
//	ledge2 = GetEnt( "catwalk_break_piece2", "targetname" );
//	ledge2 RotateTo( (15,0,15), 0.05 );
//	
//	ledge3 = GetEnt( "catwalk_break_piece3", "targetname" );
//	ledge3 RotateTo( (0,0,-15), 0.05 );
//	
//	//ledge in front of player
//	ledge0 = GetEnt( "catwalk_break_piece0", "targetname" );
//	ledge0 RotateTo( (-15,0,-15), 0.05 );

	wait 0.5;
	
	setmusicstate("AVALANCH");
	playsoundatposition ("evt_metal_impact", (0,0,0));
	
	PhysicsExplosionSphere( player.origin, 768, 512, 3 );

//	//ledge ai is standing on
//	ledge1 = GetEnt( "catwalk_break_piece1", "targetname" );
//	//ledge1 Launch( (0, 100, -140) );
//	ledge1 Delete();
	
	wait 0.5;	//to see stuff fall away
	player SetStance("stand");
	

	
	//after player jumps gap
	trigger_wait("ledge_fall");
	
	flag_set("jumped_gap");
	flag_set("squad_go");
	
	Earthquake(0.65, .5, spot.origin, 3000);

	level notify( "catwalk_fall_start" );
	level notify("set_ledge_fog");
	//shake and break
	Earthquake(0.65, .5, spot.origin, 3000);

	//	ledge3 Launch( (0, 100, -140) );
	
	//cleanup
	
	//stop fx in rooms now that we can't go back
	stop_exploder(80);
	stop_exploder(90);
}


ledge_gap_timer()
{
	level endon("jumped_gap");
	
	wait(2.0);
	
	flag_set("squad_go");
	
	wait(2.0);
	
	maps\_utility::missionfailedwrapper(&"WMD_LEDGE_FAIL" );
	
	//SetDvar("ui_deadquote", &"WMD_LEDGE_FAIL");
	//missionFailedWrapper();
}


base_jump_timer()
{
	level endon("players_jumped");
	
	wait(28.0);
	
	maps\_utility::missionfailedwrapper(&"WMD_LEDGE_FAIL" );
	
	//SetDvar("ui_deadquote", &"WMD_LEDGE_FAIL");
	//missionFailedWrapper();
}


#using_animtree("generic_human");
guys_climb_cliff()
{
	flag_wait("squad_go");
	
	level.heroes["pierro"].animname = "brooks";
	level.heroes["pierro"] SetCanDamage( false );	//prevent pain looping bug
	level.heroes["pierro"] set_run_anim( "sprint_brooks" );
	
	level.heroes["kristina"].animname = "weaver";
	level.heroes["kristina"] SetCanDamage( false );
	level.heroes["kristina"] set_run_anim( "sprint_weaver" );

		
	level.heroes["kristina"] thread weaver_cliff_internal();	
	level.heroes["kristina"] thread do_rubberband(640);
	wait( 0.5 );
	level.heroes["pierro"] thread brooks_cliff_internal();
	level.heroes["pierro"] thread do_rubberband(384);
	
	flag_wait("players_jumped");
	
	level.heroes["kristina"] clear_run_anim();
	level.heroes["pierro"] clear_run_anim();
	
	level.heroes["pierro"].grenadeawareness = 1;
	level.heroes["kristina"].grenadeawareness = 1;
}


weaver_cliff_internal()
{
	self endon( "stop_wait_loop" );
	
	self disable_ai_color();
	node = getnode("parachute_align","targetname");
	node anim_reach_aligned(self,"jump_gap");
	node anim_single_aligned(self,"jump_gap");
	self.animname = "kristina";
	node anim_reach_aligned(self, "basejump_leadin" );
	node anim_single_aligned( self, "basejump_leadin" );
	
	while( 1 )
	{
		node thread anim_loop_aligned( self, "wait_jump" );
		wait( 0.1 );	//changed from 2,3 so more frequent -jc
		node anim_single_aligned( self, "prep_loop" );
	}
}


brooks_cliff_internal()
{
	self.animname = "pierro";
	self disable_ai_color();
	
	node = getnode("parachute_align","targetname");
	
	node anim_reach_aligned(self,"jump_gap");
	
	node anim_single_aligned(self,"jump_gap");
	
	node anim_reach_aligned(self, "basejump_leadin" );
	
	//player nr base jump
	//trigger_wait("sa2_launch","targetname");
	
	node anim_single_aligned( self, "basejump_leadin" );
	
	level.heroes["pierro"] hide();
	
	flag_wait("players_jumped");
	
	level.heroes["pierro"] AnimCustom( ::ai_start_tandem_freefall_brooks );
	
	wait(1.0);
	
	level.heroes["pierro"] show();
}


do_rubberband( dist )
{
	while(1)
	{
		wait 0.1;
		distsq = DistanceSquared( get_players()[0].origin, self.origin );
		
		if( distsq > dist*dist )
		{
			self.moveplaybackrate = ( 0.8 );
			
		}
		else
		{
			self.moveplaybackrate = ( 1 );
		}
	}
		
}


/*------------------------------------
knife throwing vignette
------------------------------------*/
//waits for door hinges to be shot so guy can breach and throw knife
door_hinge()
{
	trig_top = getent("hinge_trig_top", "targetname");
	trig_bot = getent("hinge_trig_bot", "targetname");
	
	door_lower_dmg = getent("door_lower_dmg", "targetname");
	door_upper_dmg = getent("door_upper_dmg", "targetname");
	
	door_lower_dmg hide();
	door_upper_dmg hide();
	
	trig_top thread top_hinge_think();
	trig_bot thread bot_hinge_think();
	
	level.hinge_shot = 0;
	
	// -- WWILLIAMS: NAG LINES FOR SHOOTING THE HINGES
	level.weaver.animname = "weaver";
	level.weaver thread door_hinge_nag_lines();
	
	level thread shoot_hinge_instruction();
	
	while( level.hinge_shot < 2 )
	{
		wait 0.05;
	}	
}


shoot_hinge_instruction()
{
	wait(10.0);
	
	text = false;
	
	if (level.hinge_shot < 2)
	{
		text = true;
		screen_message_create(&"WMD_SHOOT_HINGES");
	}
	
	while(level.hinge_shot < 2)
	{
		wait(0.05);
	}
	
	if (text)
	{
		screen_message_delete();
	}
}


top_hinge_think()
{
	glo_hinge_top = getent("glo_hinge_top", "targetname");
	
	glo_hinge_top show();
	
	hinge_fx = Spawn( "script_model", glo_hinge_top.origin );
	hinge_fx SetModel( "tag_origin" );
	hinge_fx.angles = ( 0,0,0 );	//so it faces correct way
	
	self waittill( "trigger" );	//when shot
	
	door_upper = getent("door_upper", "targetname");
	door_upper_dmg = getent("door_upper_dmg", "targetname");
	
	door_upper delete();
	door_upper_dmg show();

	PlayFXOnTag( level._effect["hinge_shot"], hinge_fx, "tag_origin");

	self playsound( "evt_hinge_break_1" );		
	
	wait 0.25;
	
	level.hinge_shot++;
	
	glo_hinge_top Delete();
}


bot_hinge_think()
{
	glo_hinge_bot = getent("glo_hinge_bot", "targetname");
	
	glo_hinge_bot show();
	
	hinge_fx = Spawn( "script_model", glo_hinge_bot.origin );
	hinge_fx SetModel( "tag_origin" );
	hinge_fx.angles = ( 0,0,0 );	//so it faces correct way
	
	self waittill( "trigger" );	//when shot
	
	door_lower = getent("door_lower", "targetname");
	door_lower_dmg = getent("door_lower_dmg", "targetname");
	
	door_lower delete();
	door_lower_dmg show();

	PlayFXOnTag( level._effect["hinge_shot"], hinge_fx, "tag_origin");

	self playsound( "evt_hinge_break_2" );		
	
	wait 0.25;
	
	level.hinge_shot++;
	
	glo_hinge_bot Delete();
}


// -- WWILLIAMS: NAG LINES FOR SHOOTING THE HINGE
door_hinge_nag_lines()
{
	self endon( "death" );
	
	self anim_single(self, "shoot_hinge");  //Shoot the hinges...
	
	while(1)
	{
		wait( RandomIntRange( 8, 10 ) );
		
		if (level.hinge_shot < 2)
		{
			self anim_single(self, "shoot_hinge");  //Shoot the hinges...
		}
	}
}


Start_Knife_Throw()
{
	//get_players()[0] SetLowReady(true);
	breach_trigger = ent_get("start_knife_throw");
	
	level.heroes["kristina"] disable_react();
		
	//door glowy hinges
	door_hinge();
	
	level notify("set_radar_station_fog");
	
	flag_set( "obj_personnel_a_c" );
	
	//this stuff is to make barnes look better coming out of his animation and the squad look a bit better coming through the narrow hallway
	level.heroes["kristina"] disable_ai_color();		
	level.heroes["kristina"].disableTurns = 1;
	level.heroes["kristina"].badplaceawareness = 0;
	
	breach_trigger delete();
	
	players = get_players();
	guys = simple_spawn("knife_throw_guys",::knife_guy_init);	
	
	barnes = level.heroes["kristina"];
	barnes.animname = "weaver";
	
	russ02 = getai_by_noteworthy("russ02");
	russ02.animname = "knife_guy";
	russ02.health = 10000;

	//anim of door knocked down
	door = ent_get("door_lower_dmg");
	door2 = ent_get("door_upper_dmg");
	
	door2 linkto(door);
	
	//alignment node for the anim
	node = GetNode("anim_node_knife_throw", "targetname" );
	
	model = spawn("script_model",door.origin);	
	model setmodel("tag_origin_animate");
	model.animname = "door";	
	model useanimtree(level.scr_animtree["door"]);

	// link the door to the 'tag_origin_animate' model
	door linkto( model,"origin_animate_jnt" );
	
	//russ02 gun_remove();
	
	//create array for the animation
	anim_ents = [];
	anim_ents[anim_ents.size] = barnes;
	anim_ents[anim_ents.size] = russ02;	
	anim_ents[anim_ents.size] = model;
	
	node anim_reach_aligned(barnes, "knife_throw");
	
	//fx for room
	exploder(80);

	flag_set("hut_breach_go");
	
	level thread play_weaver_stinger();
	level thread knife_throw_vo();
	
	get_players()[0] SetLowReady(true);
	
	level thread door_collision();
	level thread post_knife_savegame();

	node anim_single_aligned(anim_ents, "knife_throw");	
	
	get_players()[0] SetLowReady(false);
			
	door notsolid();
	door unlink();		
	model delete();
	
	level.heroes["kristina"] set_force_color( "b" );
	
	// sends to node by door to radar room
	level.heroes["kristina"] thread wait_to_reach_door();
}


post_knife_savegame()
{
	animtime = GetAnimLength(level.scr_anim["weaver"]["knife_throw"]);
	
	wait(animtime - 6);
	
	flag_set("knife_done");
}


door_collision()
{
	wait(2.0);
	
	//get rid of door collision
	door_col = GetEnt( "door_lower_collision", "targetname" );
	door_col connectpaths();
	door_col Delete();
}


wait_to_reach_door()
{
	self endon("death");

	// This prevents AI from playing exits after the animation is over.
	level.heroes["kristina"].disableexits = 1;
	
	// set the goalnode before the animation starts , this way barnes won't try to run back to his original goal node after his animation
	level.heroes["kristina"] setgoalnode( getnode("barnes_post_knife","targetname") );	

	// enable his special walk again - 
	level.heroes["kristina"] enable_cqbwalk();
		
	// waittill goal node
	level.heroes["kristina"] waittill( "goal" );
	
	// turn off disable exits
	level.heroes["kristina"].disableexits = 0;
}


play_weaver_stinger()
{
	wait(2);
	playsoundatposition ("mus_weaver_knife_throw", (0,0,0));	
	setmusicstate ("RADAR_FIGHT_DONE");
}


knife_throw_vo()
{
	level endon("breach_begin");
	
	wait(4.0);
	
	player = get_players()[0];
	player.animname = "hudson";
	player anim_single(player, "control_per");	//Good job Kilo one. You have control of the perimeter.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "be_advised");	//Be advised - We have about three minutes left before we need to refuel with KC-135
	
	wait(0.3);
	
	player = get_players()[0];
	player anim_single(player, "understood");	//Understood.
	
	wait(0.3);
	
	player = get_players()[0];
	player anim_single(player, "at_comstat");	//BigEye, Kilo One are at the Comstat.
	
	wait(0.3);
	
	player = get_players()[0];
	player anim_single(player, "at_window");		//Copy that. Your team is in position at the window.
	
	wait(0.2);
	
	level.brooks.animname = "brooks";
	level.brooks anim_single(level.brooks, "in_position");		//We're in position.
}


#using_animtree("generic_human");
knife_guy_init()
{
	self.pacifist = true;
	self.pacifistwait = 0;
	self clearenemy();
	self.animname = self.script_noteworthy;
	self.deathanim = %dying_back_death_v1;
	self.dropweapon = 0;
}











 