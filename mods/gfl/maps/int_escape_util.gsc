#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_clientfaceanim;


larry_the_limper()
{
	level.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	get_players()[0] PlayerSetGroundReferenceEnt( level.ground_ref_ent );
	
	limpset = [];
	limpset[0] = ::decent_leftlimp;
	limpset[1] = ::decent_rightlimp;
	limpset[2] = ::decent_straight_limp;
	limpset[3] = ::decent_leftlimp;
	
	decent_straight_limp();
	
	
	level thread player_velocity_tracker();
	level thread speed_ramp_up();
	
	wait 0.05;
	
	while(1)
	{
		if (level.player_speed > 1)
		{
			myfunc = limpset[RandomInt(limpset.size)];
			[[myfunc]]();
			larry_the_limper_tweaktech();
			
			if (flag("in_conf_room"))
			{
				wait 0.05;
				larry_the_limper_tweaktech_fast();
			}
			
			if (!flag("no_limp") )
			{
				get_players()[0] PlayerSetGroundReferenceEnt( level.ground_ref_ent );
				limp_loop();
			}
			else
			{
				wait 0.05;
			}
		}
		else
		{
			wait 0.05;
		}
	}
}

limp_loop()
{
	level endon ("player_not_moving");
	get_players()[0] setblur( 0.5, 0.5 );
	first_limp_point = (level.f_groundref_x, level.f_groundref_y, level.f_groundref_z);
	angles = adjust_angles_to_player( first_limp_point );
	get_players()[0] thread player_speed_set(level.f_limpspeed, level.f_limpspeedsettime);
	level.ground_ref_ent rotateto( angles, level.flimptime , level.flimptime_accel, level.flimptime_deccel );
	wait level.f_waittime;
		
	get_players()[0] setblur( 0, 0.5 );
	second_limp_point = (level.s_groundref_x, level.s_groundref_y, level.s_groundref_z);
	angles = adjust_angles_to_player( second_limp_point );
	get_players()[0] thread player_speed_set(level.s_limpspeed, level.s_limpspeedsettime);
	level.ground_ref_ent rotateto( angles, level.slimptime, level.slimptime_accel, level.slimptime_deccel );
	wait level.s_waitttime;
		
	get_players()[0] thread player_speed_set(level.t_limpspeed ,level.t_limpspeedsettime);
	third_limp_point = (level.t_groundref_x, level.t_groundref_y, level.t_groundref_z);
	angles = adjust_angles_to_player( third_limp_point );
	level.ground_ref_ent rotateto( angles, level.tlimptime, level.tlimptime_accel, level.tlimptime_deccel );
	wait level.t_waitttime;
}

player_velocity_tracker()
{
	last_player_speed = 0;
	while(1)
	{
		velocity = get_players()[0] GetVelocity();
		level.player_speed = abs( velocity [0] ) + abs( velocity[1] );
		if (level.player_speed < 1 && last_player_speed > 1)
		{
			level notify ("player_not_moving");
			level.ground_ref_ent rotateto( (0,0,0), 1 );
			wait 0.5;
		}
		if ( level.player_speed > 1 && level.player_speed < 40 && !flag("no_limp") )
		{
			larry_the_limper_tweaktech_halved();
		}
		wait 0.05;
		last_player_speed = level.player_speed;
	}
}

speed_ramp_up()
{
	flag_wait("in_conf_room");
	while(level._player_speed_modifier < 1.3)
	{
		level._player_speed_modifier +=0.01;
		wait 0.1;
	}
}

 

larry_the_limper_tweaktech()
{
		level.f_groundref_x = level.base_1_gref_x ;
		level.f_groundref_y = level.base_1_gref_y ;
		level.f_groundref_z = level.base_1_gref_z ;
		level.flimptime = level.base_1_limptime ;
		level.flimptime_accel = level.base_1_limptime_accel ;
		level.flimptime_deccel = level.base_1_limptime_deccel ;
		level.f_waittime = level.base_1_waittime ;
		level.f_limpspeed = level.base_1_limpspeed ;
		level.f_limpspeedsettime = level.base_1_limpspeedsettime ;
		
		level.s_groundref_x = level.base_2_gref_x ;
		level.s_groundref_y = level.base_2_gref_y ;
		level.s_groundref_z = level.base_2_gref_z ;
		level.slimptime = level.base_2_limptime ;
		level.slimptime_accel = level.base_2_limptime_accel ;
		level.slimptime_deccel = level.base_2_limptime_deccel ;
		level.s_waitttime = level.base_2_waitttime ;
		level.s_limpspeed = level.base_2_limpspeed ;
		level.s_limpspeedsettime = 	level.base_2_limpspeedsettime ;
		
		level.t_groundref_x = level.base_3_gref_x ;
		level.t_groundref_y = level.base_3_gref_y ;
		level.t_groundref_z = level.base_3_gref_z ;
		level.tlimptime = level.base_3_limptime ;
		level.tlimptime_accel = level.base_3_limptime_accel ;
		level.tlimptime_deccel = level.base_3_limptime_deccel ;
		level.t_waitttime = level.base_3_waitttime ;
		level.t_limpspeed = level.base_3_limpspeed ;
		level.t_limpspeedsettime = level.base_3_limpspeedsettime ;
}

larry_the_limper_tweaktech_fast()
{
		level.f_groundref_x = level.base_1_gref_x ;
		level.f_groundref_y = level.base_1_gref_y ;
		level.f_groundref_z = level.base_1_gref_z ;
		level.flimptime = level.base_1_limptime ;
		level.flimptime_accel = level.base_1_limptime_accel ;
		level.flimptime_deccel = level.base_1_limptime_deccel ;
		level.f_waittime = level.base_1_waittime ;
		level.f_limpspeed = level.base_1_limpspeed ;
		level.f_limpspeedsettime = level.base_1_limpspeedsettime ;
		
		level.s_groundref_x = level.base_2_gref_x ;
		level.s_groundref_y = level.base_2_gref_y ;
		level.s_groundref_z = level.base_2_gref_z ;
		level.slimptime = level.base_2_limptime ;
		level.slimptime_accel = level.base_2_limptime_accel ;
		level.slimptime_deccel = level.base_2_limptime_deccel ;
		level.s_waitttime = level.base_2_waitttime ;
		level.s_limpspeed = level.base_2_limpspeed ;
		level.s_limpspeedsettime = 	level.base_2_limpspeedsettime ;
		
		level.t_groundref_x = level.base_3_gref_x ;
		level.t_groundref_y = level.base_3_gref_y ;
		level.t_groundref_z = level.base_3_gref_z ;
		level.tlimptime = level.base_3_limptime ;
		level.tlimptime_accel = level.base_3_limptime_accel ;
		level.tlimptime_deccel = level.base_3_limptime_deccel ;
		level.t_waitttime = level.base_3_waitttime ;
		level.t_limpspeed = level.base_3_limpspeed ;
		level.t_limpspeedsettime = level.base_3_limpspeedsettime ;
}

larry_the_limper_tweaktech_halved()
{
		level.f_groundref_x = 0.8*level.base_1_gref_x ;
		level.f_groundref_y = 0.8*level.base_1_gref_y ;
		level.f_groundref_z = 0.8*level.base_1_gref_z ;
		level.flimptime = 0.8*level.base_1_limptime ;
		level.flimptime_accel = 0.8*level.base_1_limptime_accel ;
		level.flimptime_deccel = 0.8*level.base_1_limptime_deccel ;
		level.f_waittime = 0.8*level.base_1_waittime ;
		level.f_limpspeed = 0.8*level.base_1_limpspeed ;
		level.f_limpspeedsettime = 0.8*level.base_1_limpspeedsettime ;
		
		level.s_groundref_x = 0.8*level.base_2_gref_x ;
		level.s_groundref_y = 0.8*level.base_2_gref_y ;
		level.s_groundref_z = 0.8*level.base_2_gref_z ;
		level.slimptime = 0.8*level.base_2_limptime ;
		level.slimptime_accel = 0.8*level.base_2_limptime_accel ;
		level.slimptime_deccel = 0.8*level.base_2_limptime_deccel ;
		level.s_waitttime = 0.8*level.base_2_waitttime ;
		level.s_limpspeed = 0.8*level.base_2_limpspeed ;
		level.s_limpspeedsettime = 	0.8*level.base_2_limpspeedsettime ;
		
		level.t_groundref_x = 0.8*level.base_3_gref_x ;
		level.t_groundref_y = 0.8*level.base_3_gref_y ;
		level.t_groundref_z = 0.8*level.base_3_gref_z ;
		level.tlimptime = 0.8*level.base_3_limptime ;
		level.tlimptime_accel = 0.8*level.base_3_limptime_accel ;
		level.tlimptime_deccel = 0.8*level.base_3_limptime_deccel ;
		level.t_waitttime = 0.8*level.base_3_waitttime ;
		level.t_limpspeed = 0.8*level.base_3_limpspeed ;
		level.t_limpspeedsettime = 0.8*level.base_3_limpspeedsettime ;
}

decent_straight_limp()
{
	level.base_1_gref_x = 0;
	level.base_1_gref_y = 0;
	level.base_1_gref_z = 1;
	level.base_1_limptime = 0.6;
	level.base_1_limptime_accel = 0.55;
	level.base_1_limptime_deccel = 0.05;
	level.base_1_waittime = 0.6;
	level.base_1_limpspeed = 120;
	level.base_1_limpspeedsettime = 0.2;
	
	level.base_2_gref_x = 0;
	level.base_2_gref_y = 0;
	level.base_2_gref_z = 4;
	level.base_2_limptime = 0.4;
	level.base_2_limptime_accel = 0.35;
	level.base_2_limptime_deccel = 0.05;
	level.base_2_waitttime = 0.4;
	level.base_2_limpspeed = 130;
	level.base_2_limpspeedsettime = 0.2;
	
	level.base_3_gref_x = 0;
	level.base_3_gref_y = 0;
	level.base_3_gref_z = 0;
	level.base_3_limptime = 0.5;
	level.base_3_limptime_accel = 0.45;
	level.base_3_limptime_deccel = 0.05;
	level.base_3_waitttime = 0.5;
	level.base_3_limpspeed = 100;
	level.base_3_limpspeedsettime = 0.5;
}

decent_leftlimp()
{
	level.base_1_gref_x = 0;
	level.base_1_gref_y = 5;
	level.base_1_gref_z = -1;
	level.base_1_limptime = 0.6;
	level.base_1_limptime_accel = 0.55;
	level.base_1_limptime_deccel = 0.05;
	level.base_1_waittime = 0.6;
	level.base_1_limpspeed = 120;
	level.base_1_limpspeedsettime = 0.2;
	
	level.base_2_gref_x = 0;
	level.base_2_gref_y = 1;
	level.base_2_gref_z = 3;
	level.base_2_limptime = 0.4;
	level.base_2_limptime_accel = 0.35;
	level.base_2_limptime_deccel = 0.05;
	level.base_2_waitttime = 0.4;
	level.base_2_limpspeed = 130;
	level.base_2_limpspeedsettime = 0.2;
	
	level.base_3_gref_x = 0;
	level.base_3_gref_y = 0;
	level.base_3_gref_z = 0;
	level.base_3_limptime = 0.5;
	level.base_3_limptime_accel = 0.45;
	level.base_3_limptime_deccel = 0.05;
	level.base_3_waitttime = 0.5;
	level.base_3_limpspeed = 100;
	level.base_3_limpspeedsettime = 0.5;	
}

decent_rightlimp()
{
	level.base_1_gref_x = -2;
	level.base_1_gref_y = -5;
	level.base_1_gref_z = 3.5;
	level.base_1_limptime = 0.35;
	level.base_1_limptime_accel = 0.3;
	level.base_1_limptime_deccel = 0.05;
	level.base_1_waittime = 0.5;
	level.base_1_limpspeed = 105;
	level.base_1_limpspeedsettime = 0.35;
	
	level.base_2_gref_x = 1;
	level.base_2_gref_y = -1;
	level.base_2_gref_z = 2;
	level.base_2_limptime = 0.5;
	level.base_2_limptime_accel = 0.35;
	level.base_2_limptime_deccel = 0.05;
	level.base_2_waitttime = 0.4;
	level.base_2_limpspeed = 130;
	level.base_2_limpspeedsettime = 0.2;
	
	level.base_3_gref_x = 0;
	level.base_3_gref_y = 0;
	level.base_3_gref_z = 0;
	level.base_3_limptime = 0.5;
	level.base_3_limptime_accel = 0.25;
	level.base_3_limptime_deccel = 0.05;
	level.base_3_waitttime = 0.5;
	level.base_3_limpspeed = 150;
	level.base_3_limpspeedsettime = 0.2;	
}

line_please(myline,waittime, myflag, dontplay_flag)
{
	//level endon ("cut_current_dialogue");
	stringline = undefined;
	if (isdefined(myflag))
	{
		flag_wait (myflag);
	}
	
	if (IsDefined(dontplay_flag) && flag(dontplay_flag))
	{
		return;
	}
	
	if (isdefined(waittime))
	{
		wait waittime;
	}
	
	if (IsDefined(self._isspeaking))
	{
		while(is_true(self._isspeaking))
		{
			wait 0.05;
		}
	}
	waittillframeend; // make sure to reset next flag if its done elsewhere before its checked
	
	if (IsDefined(dontplay_flag) && flag(dontplay_flag))
	{
		return;
	}
	
	self._isspeaking = 1;
	if (!(IsAI(self))) // if it's the radio or the player
	{
 	 	self anim_generic(self,myline);
  }
	
	else
	{
 	 	self anim_generic( self, myline );
	}

	//Assert( isdefined(stringline), "Stringline with animname "+self.animname+" and line "+myline+" couldn't be found");
 	self._isspeaking = undefined;
}

obj_3d(on_off, time)
{
	objective_set3d(1, on_off, (1,1,1) );
	if (IsDefined(time))
	{
		wait time;
			objective_set3d(1, true, (1,1,1) );
	}
	if (flag("dont_show_3d_marker") )
	{
		objective_set3d(1, false, (1,1,1) );
	}
}

show_viewmodel(time)
{
	if (IsDefined(time))
	{
		wait time;
	}
	get_players()[0] ShowViewModel();
	get_players()[0] EnableWeapons();
}

hide_viewmodel(time)
{
	if (IsDefined(time))
	{
		wait time;
	}
	get_players()[0] HideViewModel();
	get_players()[0] DisableWeapons();
}

switch_interrogation_hands(hands, delay)
{
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon(hands);
	get_players()[0] SwitchToWeapon(hands);
}


setup_prop_fx()
{
	props = getstructarray("fx_props", "targetname");
	array_thread(props, ::play_prop_fx);
}
	
play_prop_fx()
{
	fx = level._effect[self.script_noteworthy];
	
	while(1)
	{
		while( DistanceSquared(self.origin, get_players()[0].origin) > (1000*1000 ) )
		{
			wait 0.1;
		}
		fakemodel = spawn_a_model("tag_origin", self.origin, self.angles);
		PlayFXOnTag( fx, fakemodel, "tag_origin");
		
		while( DistanceSquared(self.origin, get_players()[0].origin) < (1000*1000 ) )
		{
			wait 0.1;
		}
		fakemodel Delete();
	}
}

door_clip_attach()
{
	doors = [];
	doors[0] = GetEnt("reznov_room_left_door", "targetname");
	doors[1] = GetEnt("reznov_room_right_door", "targetname");
	doors[2] = GetEnt("reznov_room_exit", "targetname");
	doors[3] = GetEnt("int_room_door", "targetname");
	doors[4] = GetEnt("morgue_entrance_door_l", "targetname");
	doors[5] = GetEnt("morgue_entrance_door_r", "targetname");
	doors[6] = GetEnt("hall1_door_r", "targetname");
	doors[7] = GetEnt("hall1_door_l", "targetname");
	
	for (i=0; i < doors.size; i++)
	{
		clip = GetEnt(doors[i].targetname+"_clip", "targetname");
		clip LinkTo(doors[i]);
	}
}

security_cameras_setup()
{
	cameras = GetEntArray("security_cameras", "script_noteworthy");
	for (i=0; i < cameras.size; i++)
	{
		PlayFXOnTag(level._effect["camera_light"], cameras[i], "tag_origin");
		
		if (RandomInt(100) < 40)
		{
			cameras[i] thread security_cameras_follow_player();
		}
		else
		{
			cameras[i] thread security_cameras_random_rotate();
		}
	}
}

security_cameras_follow_player()
{
	alignment = Spawn_a_model("tag_origin", self.origin, (self.angles+ (0,add_angle(self.angles[1], 270), 0) ) );
	self LinkTo(alignment, "tag_origin", (0,0,0), (0,90,0) );
	
	while(1)
	{
		vec = get_players()[0] GetEye() - alignment.origin;
		ang = VectorToAngles(vec);
		alignment RotateTo(ang, 0.05);
		alignment waittill ("rotatedone");
	}
}
		
security_cameras_random_rotate()
{
	total_turn_time = 10;
	time_between_turns = 3;
	
	while(1)
	{
		self RotateYaw(40,total_turn_time/2);
		self playloopsound ("amb_camera_rotate");
		self waittill ("rotatedone");
		self stoploopsound();
		wait time_between_turns;
		self RotateYaw(-80, total_turn_time);
		self playloopsound ("amb_camera_rotate");
		self waittill ("rotatedone");
		self stoploopsound();
		wait time_between_turns;
		self playloopsound ("amb_camera_rotate");
		self RotateYaw(40,total_turn_time/2);
		self waittill ("rotatedone");
		self stoploopsound();
	}
}

play_random_shocking(cutoff_time, max_cutoff_time)
{
	if (!IsDefined(max_cutoff_time))
	{
		max_cutoff_time = 0.3;
	}
	if (!IsDefined(cutoff_time) || (IsDefined(cutoff_time) && cutoff_time < 0.1) )
	{
		cutoff_time = 0.1;
	}
	
	if (level.fullscreen_cin_hud.alpha == 0 || level.fullscreen_cin_hud.alpha == 1)
	{
		level.fullscreen_cin_hud.alpha = 1;
	}
	
	if(cointoss() )
	{
		start3dcinematic("int_shocking_1", true, true);
		playsoundatposition ("evt_shocking_1", (0,0,0));
		wait RandomFloatRange(cutoff_time, max_cutoff_time);
		stop3dcinematic();
	}
	else
	{
		start3dcinematic("int_shocking_2", true, true);
		playsoundatposition ("evt_shocking_2", (0,0,0));
		wait RandomFloatRange(cutoff_time, max_cutoff_time);
		stop3dcinematic();
	}
	level.fullscreen_cin_hud.alpha = 0;
}

int_esc_play_movie(movie, is_looping, is_loaded, alpha )
{
	if(cointoss() )
	{
		playsoundatposition ("evt_shocking_1", (0,0,0));
	}
	else
	{
		playsoundatposition ("evt_shocking_2", (0,0,0));
	}
	if (IsDefined(alpha))
	{
		level.fullscreen_cin_hud.alpha = alpha;
	}
	else
	{
		level.fullscreen_cin_hud.alpha = 1;
	}
	
	get_players()[0] FreezeControls(true);
	obj_3d(false);
	
	//play_movie(movie_name, is_looping, is_in_memory, start_on_notify, use_fullscreen_trans, notify_when_done, notify_offset, snapshot)
	//play_movie(movie, is_looping, is_loaded, undefined, undefined, undefined, .3, 1);

	if (!IsDefined(level.int_esc_play_movie_id))
	{
		level.int_esc_play_movie_id = 0;
	}

	level.int_esc_play_movie_id++;

	level thread play_movie(movie, is_looping, is_loaded, undefined, false, "int_esc_play_movie_done" + level.int_esc_play_movie_id);
	level waittill("int_esc_play_movie_done" + level.int_esc_play_movie_id);

	obj_3d(true);
	get_players()[0] FreezeControls(false);
}



do_fp_wrist_grab()
{
	get_players()[0] DisableWeapons();
	wait 0.5;
	get_players()[0] HideViewModel();
	get_players()[0] EnableWeapons();

	weapon = get_players()[0] GetCurrentWeapon();
	get_players()[0] GiveMaxAmmo(weapon);
	wait 0.05;
	get_players()[0] SetWeaponAmmoClip(weapon, 1);
	wait 0.05;
	get_players()[0] SetWeaponAmmoClip(weapon, 0);
	wait 0.05;
	
	get_players()[0] ShowViewModel();
}

play_numbers_bink(alpha, ender)
{
	level.fullscreen_cin_hud.alpha = alpha;
	stop3dcinematic();
	start3dcinematic("int_number_field", true, true);
	level waittill (ender);
	stop3dcinematic();
}

play_numbers_flash(alpha, delay, ender)
{
	level.fullscreen_cin_hud.alpha = alpha;
	stop3dcinematic();
	start3dcinematic("int_number_flash_1", true, true);
	if (IsDefined(delay))
	{
		wait delay;
	}
	else if (IsDefined(ender) )
	{
		level waittill (ender);
	}
	stop3dcinematic();
}

warpto_blackroom_spot()
{
	spot = GetEnt("blackroom_center_spot", "targetname");
	get_players()[0] Unlink();
	wait 0.05;
	get_players()[0] SetOrigin (spot.origin);
	get_players()[0] PlayerLinkToAbsolute(spot);
	wait 0.45;
	get_players()[0] Unlink();
}