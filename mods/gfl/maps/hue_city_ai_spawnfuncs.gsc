#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_civilians;
#include maps\hue_city;
#include maps\hue_city_event1;


#using_animtree("generic_human");
hue_city_ai_spawnfuncs()
{
	//array_thread( getentarray("macv_civilian_struct_spawn_trigger", "script_parameters"), ::struct_spawn_trigger);

	// GLOBAL - General spawnfuncs that can be used globally through the level (typically on script_noteworthy)
	array_thread( getentarray("playerseek", "script_noteworthy"),      ::add_spawn_function,  ::seek_player );
	array_thread(getentarray("mbs", "script_noteworthy"), ::add_spawn_function, ::magic_bullet_shield);
	array_thread(getentarray("reznov_ai", "script_noteworthy"), ::add_spawn_function, ::reznov_ai_setup);


// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - 	SUMEET SPAWNFUNCS 
// -------------------------------------------------------------------------------------

	// first two AI's in the first encounter, need to be already running when player sees them
	array_thread( GetEntArray( "first_encounter_rushers", "script_noteworthy"), ::add_spawn_function, ::event1_setup_rushers );
	// special death rusher
	array_thread( GetEntArray( "first_encounter_guys_one", "targetname"), ::add_spawn_function, ::event1_first_rusher_kill_think );

	// special death rusher
	array_thread( GetEntArray( "first_encounter_guys", "targetname"), ::add_spawn_function, ::event1_rushers );


	// guys in second counter
	array_thread( GetEntArray( "second_encounter_guys", "targetname" ), ::add_spawn_function, ::event1_skydemon_ai_think );
	array_thread( GetEntArray( "second_encounter_guys_back", "targetname" ), ::add_spawn_function, ::event1_skydemon_ai_think );
	array_thread( GetEntArray( "second_encounter_guys_back_last", "targetname" ), ::add_spawn_function, ::event1_skydemon_ai_think );

	// civilians in 1st hallway
	array_thread( GetEntArray( "hallway_civs", "targetname" ), ::add_spawn_function, ::event1_civs_animate_hallway );

	// hallway cower civilian
	array_thread( GetEntArray( "hallway_cower_civ", "targetname" ), ::add_spawn_function, ::event1_hallway_civ_left_cower );
	// civilians in the room after skydemon
	array_thread( GetEntArray( "macv_civ_corner_surprise", "targetname" ), ::add_spawn_function, ::event1_civs_animate_corner_surprise );

	// runners
	array_thread( GetEntArray( "runner", "script_noteworthy" ), ::add_spawn_function, ::room_runners_think );
	// special death effects on AI dying with spas dragons breath
	array_thread( GetSpawnerTeamArray( "axis" ), ::add_spawn_function, ::special_dragons_breath_death );
	// passage beatdown animation guys
	array_thread( GetEntArray( "macv_passage_beatdown_guys", "targetname" ), ::add_spawn_function, ::event1_animate_passage_beatdown );
	// NVA shooting civilians on stairs
	array_thread( GetEntArray( "stair_civilian_shooters", "script_noteworthy" ), ::add_spawn_function, ::event1_stairs_civilian_shooters );
	// molotov thrower 
	array_thread( GetEntArray( "molotov_thrower", "targetname" ), ::add_spawn_function, ::event1_staircase_molotov_thrower_think );
	// spawn function for the guy who dies on back in staircase room
	array_thread( GetEntArray( "stair_death_back_guy", "script_noteworthy" ), ::add_spawn_function, ::event1_stair_guy_back_think );
	// staircase mowdown scene
	array_thread( GetEntArray( "stair_runaway_scene_guys", "targetname" ), ::add_spawn_function, ::event1_animate_stairs_mowdown_ent );
	// RPG guy that thrws the player down in the balcony
	array_thread( GetEntArray( "rpg_guy", "script_noteworthy" ), ::add_spawn_function, ::event1_balcony_rpg_guy_think );

	array_thread( GetEntArray( "scared_into_mowdown_guys", "script_noteworthy" ), ::add_spawn_function, ::scared_into_mowdown_guys_setup );


	// spawn function for the guy who dies on back in staircase room
	//array_thread( GetEntArray( "stair_death_front_guy", "script_noteworthy" ), ::add_spawn_function, ::event1_stair_guy_front_think );


	// first skydemon spotlight
	add_spawn_function_veh( "skydemon_flyover_1", ::event1_first_encounter_spotlight );
	
	// second encounter helicopter
	add_spawn_function_veh( "macv_skydemon", ::event1_skydemon_firing_think, 1 );

	// repel guys after skydemon
	add_spawn_function_veh( "skydemon_flyover_2", ::event1_repel_guys );
	add_spawn_function_veh( "skydemon_flyover_2", ::event1_repel_heli_think );

	///************** END SUMEET SPAWNFUNCS ***************************




	// EVENT 1 - MACV
	array_thread( getentarray("macv_aatruck_escorts", "targetname"),      ::add_spawn_function,  ::wait_and_kill,30 );	
	array_thread(getentarray("crawling_civilian", "targetname"), ::add_spawn_function, ::crawler_setup );			
	array_thread(getentarray("woods_struct_spawner", "targetname"), ::add_spawn_function, ::woods_setup );						
	array_thread(getentarray("reznov", "script_noteworthy"), ::add_spawn_function, ::reznov_setup );						
	array_thread(getentarray("stair_guys", "script_noteworthy"), ::add_spawn_function, ::stair_guys_setup );						
	

	
	// EVENT 2 - MACV Transition
	array_thread(getentarray("vin_area_stackers", "targetname"), ::add_spawn_function, ::vin_area_stackers_setup);

	array_thread(getentarray("alley_enemies", "script_noteworthy"), ::add_spawn_function, ::ignore_player_onflag_setup);
	array_thread(getentarray("alley_balcony_guys", "script_noteworthy"), ::add_spawn_function, ::ignore_player_onflag_setup);
		
	array_thread(getentarray("first_street_guys", "targetname"), ::add_spawn_function, ::ignore_player_setup);
	array_thread(getentarray("first_street_guys_ground", "targetname"), ::add_spawn_function, ::ignore_player_setup);
	array_thread(getentarray("high_balcony_guys", "targetname"), ::add_spawn_function, ::ignore_player_setup);
		
	// EVENT 2 - streets
	
	array_thread(getentarray("street_retreater", "script_noteworthy"), ::add_spawn_function, ::street_retreater_setup);
	array_thread(getentarray("alleyskipto_woods", "script_noteworthy"), ::add_spawn_function, ::woods_setup);
	array_thread(getentarray("woods_ai", "script_noteworthy"), ::add_spawn_function, ::woods_setup);
	array_thread(getentarray("street_heroes", "targetname"), ::add_spawn_function, ::street_heroes_setup);
	array_thread(getentarray("street_bowman", "script_noteworthy"), ::add_spawn_function, ::street_bowman_setup);
	array_thread(GetEntArray("bowman_ai", "script_noteworthy"), ::add_spawn_function, ::bowman_ai_setup);
	array_thread(GetEntArray("macv_bowman_ai", "script_noteworthy"), ::add_spawn_function, ::bowman_ai_setup);
	//array_thread(getentarray("poor_friend", "targetname"), ::add_spawn_function, ::poor_friend_setup);

	array_thread(getentarray("valid_apc_targets", "script_noteworthy"), ::add_spawn_function, ::cqbchance);
	array_thread(getentarray("valid_apc_targets", "script_noteworthy"), ::add_spawn_function, ::maybe_dont_drop_weapon);
	array_thread(getentarray("e2_street_spawners", "script_noteworthy"), ::add_spawn_function, ::cqbchance);
	array_thread(getentarray("e2_street_spawners", "script_noteworthy"), ::add_spawn_function, ::maybe_dont_drop_weapon);
	array_thread(getentarray("e2_street_spawners", "script_noteworthy"), ::add_spawn_function, ::close_to_player_nowattack);
	array_thread(getentarray("end_street_guys", "script_noteworthy"), ::add_spawn_function, ::cqbchance	);						
	
		
	spawners = GetSpawnerArray();
	cqbchance_spawners = [];
	for (i=0; i < spawners.size; i++)
	{
		if (spawners[i].origin[1] > -500 && spawners[i].origin[0] < -1500) // that is, spawners located in the street area
		{
			cqbchance_spawners = array_add(cqbchance_spawners, spawners[i] );
		}
	}
	array_thread(cqbchance_spawners, ::add_spawn_function, ::cqbchance);
	
	array_thread(spawners, ::add_spawn_function, ::rpg_refill);
	
		
	// EVENT 2b - alley
	
	array_thread(getentarray("alley_balcony_guys", "script_noteworthy"), ::add_spawn_function, ::alley_balcony_guys_setup) ;
	array_thread(getentarray("midsection_civ", "script_noteworthy"), ::add_spawn_function, ::wait_and_kill, 30) ;
	
	array_thread(getentarray("comeout_on_balcony_guys", "targetname"), ::add_spawn_function, ::comeout_on_balcony_guys_setup) ;
	array_thread(getentarray("aa_gun_crew", "targetname"), ::add_spawn_function, ::aa_gun_crew_setup) ;
		
			
		
	 // EVENT 3 - defend
	 
	array_thread(getentarray("e3_attackers", "script_noteworthy"), ::add_spawn_function, ::e3_attackers_setup) ;
	array_thread(getentarray("e3_roofguys", "script_noteworthy"), ::add_spawn_function, ::e3_roofguys_setup) ;
	array_thread(getentarray("chopper_death_dudes", "targetname"), ::add_spawn_function, ::chopper_death_dudes_setup) ;
	array_thread(getentarray("mortar_spotter", "targetname"), ::add_spawn_function, ::mortar_spotter_setup) ;
				
	array_thread(getentarray("first_wave_guys", "targetname"), ::add_spawn_function, ::wait_and_kill,RandomFloatRange(15,20) ) ;
						
				
				
	// Added new spawn function for aa gun in repel sequence
	add_spawn_function_veh( "macv_aa_truck", maps\hue_city_event1::event1_aa_repel_hit_targets );

	
		add_spawn_function_veh( "macv_skydemon", ::fill_huey_with_script_models, "deleting");
		//add_spawn_function_veh( "skydemon_flyover_1", ::fill_huey_with_script_models);
		//add_spawn_function_veh( "skydemon_flyover_2", ::fill_huey_with_script_models);
		//add_spawn_function_veh( "intro_cowbell_hueys", ::fill_huey_with_script_models);

		add_spawn_function_veh( "e2_friendly_apc", maps\hue_city_event2::friendly_apc_movement);
		add_spawn_function_veh( "alley_aa_gun", ::alley_aa_gun_setup );
		add_spawn_function_veh( "alley_tank", ::alley_tank_setup );
		add_spawn_function_veh( "defend_tank", ::defend_tank_setup );
		
		add_spawn_function_veh( "enemytank1", maps\hue_city_event2::enemytank1_setup );
		add_spawn_function_veh( "skydemon", ::street_spotlight_on_gun );

	add_spawn_function_veh( "defend_retreat_choppers", maps\hue_city_event3::defend_retreat_choppers_setup );

	level thread trig_funcs();

}


crawler_setup()
{
	level waittill ("kill_crawler");
	shotspot = getstruct("kill_crawler_shotspot", "targetname");
	
	hitspot = getstructent("kill_crawler_hitspot", "targetname");
	for( i=0; i < 4; i++ )
	{
		magicbullet("fnfal_sp", shotspot.origin, hitspot.origin );
		bullettracer(shotspot.origin, hitspot.origin );
		wait 0.1;
		hitspot.origin = hitspot.origin+(10,0,0);
	}
	wait 0.6;
	
	level thread fakefire_on_runningcivs();
	for( i=0; i < 2; i++ )
	{
		magicbullet("fnfal_sp", shotspot.origin, self.origin );
		bullettracer(shotspot.origin, self.origin+( (i*3) ,0,0 )) ;
		wait 0.05;
	}
}
		
fakefire_on_runningcivs()
{
	shotspot = getstruct("kill_runningcivs_shotspot", "targetname");
	hitspot = getstruct("kill_runningcivs_hitspot", "targetname");
	
	for( i=0; i < 15; i++ )
	{
		offset = random_offset(1,40,5);
		magicbullet("fnfal_sp", shotspot.origin, shotspot.origin+offset) ;
		bullettracer(shotspot.origin, shotspot.origin+offset);
		wait 0.1;
	}
}
	

reznov_setup()
{
	level.reznov = self;
	level.squad["reznov"] = self;
	self notify("stop_hide");
	self thread hide_reznov();
	
}

determine_deathtoll()
{
	self waittill ("death", attacker);
	
	if (!IsDefined(attacker))
		return 0.5;
		
	if (IsPlayer(attacker))
	{
		return 1;
	}
	else
		return 0.5;
	
	
}


chopper_death_dudes_setup()
{
	GetAIArray("axis")[0] MagicGrenade(self.origin - 50, self.origin, 0.05);
	spot = getstruct("chopper_death_nade_spot", "targetname").origin;
	GetAIArray("axis")[0] MagicGrenade(spot, self.origin, 0.05);
}

wave_attacker_random_behavior()
{
	self endon ("death");
	chance = RandomInt(100);
	
	if (chance < 6 && level._attackers_chasing_player < 1 )
	{
		level._attackers_chasing_player++;
		self thread decrement_on_death();
		self thread seek_player( 512 );
		self._is_a_charger = 1;
	}
	if (( chance <= 10 && chance >= 6) || level._first_wave_through_smoke_guys < 9)
	{
		level._first_wave_through_smoke_guys++;
//		while(1)
//		{
//			my_enemy = GetAIArray("allies")[RandomInt(GetAIArray("allies").size)];
//			self.goalradius = 60;
//			self set_goal_entity(my_enemy);
//			my_enemy waittill ("death");
//		}
	}
	if (chance > 10 && chance < 25)
	{
//		self delaythread (RandomFloat(15,20), ::enable_cqbwalk);
	}
	if (chance > 25 && chance < 30)
	{
		//self thread defend_prone_crawl();
	}
		if (chance > 30 && chance < 45)
	{
		self thread give_unregulated_threatbias();
	}
}

defend_prone_crawl()
{
	self waittill ("defend_prone_chance");
	self AllowedStances("crouch");
	self waittill ("goal");
	self AllowedStances("stand", "crouch", "prone");
}

get_my_sm(side)
{
	if (self.targetname == "e3_"+side+"_on_guys"+"_ai")
	{
		return GetEnt(side+"_sm_on", "targetname");
	}
	else if (self.targetname == "e3_"+side+"_light_guys"+"_ai")
	{
		return GetEnt(side+"_light_sm_on", "targetname");
	}
	return undefined;
}
	
e3_attackers_setup()
{
	self endon ("death");
	self endon ("defend_wave_retreating");
	
	self._my_spawn_origin = self.origin;
	
	self thread kill_if_fall();
	self thread non_mortar_guys_deathtally();
	self thread close_to_player_nowattack();
	
	
	self._dgroup = get_my_groupname();
	my_sm = self get_my_sm(self._dgroup);
	
	//if (!flag("mortar_guys_out"))
	//{
		self wave_attacker_random_behavior();
	//}
	if (IsDefined(self._is_a_charger))
	{
		return;
	}
	
	
	for (i=1; i < 6; i++)
	{
			// move first guys in wave up close so the wave feels like it hits hard and player is aware of it.  First x guys in spawn manager leapfrog up past first node waves
		guys_to_leapfrog_up = 4;
		if ( i < 2 && IsDefined(my_sm._wave_guys_spawned) && my_sm._wave_guys_spawned < guys_to_leapfrog_up)
		{
			my_sm._wave_guys_spawned++;
			continue;
		}
		
		if (flag("defend_wave1_smoke_fading") && i < 3)	// want big advance when smoke clears
		{
			continue;
		}
		
		nodes = GetNodeArray(self._dgroup+"_d_nodes_"+i, "script_noteworthy");
		foundanode = false;
		for (j=0; j < nodes.size; j++)
		{
			if (!IsNodeOccupied(nodes[j]) && !IsDefined(nodes[j]._taken ) )
			{
				nodes[j]._taken = true;
				self SetGoalNode(nodes[j]);
				self._my_wave_node = nodes[j];
				foundanode = true;
				self thread clear_node_on_death( nodes[j]);
				
				break;
			}
		}
		if (foundanode == false) // this line is full, leap frog to next
		{
			continue;
		}
		
		if (i > 3)
		{
			flag_waitopen("mortar_guys_out");
		}
		if (i==4)
		{
			self notify ("defend_prone_chance");
		}
		if (i > 3)
		{
			level thread closing_in_on_side(self._dgroup);		
		}
		wait 10 + i;
		self._my_wave_node._taken = undefined;
	}
	
	at_end_of_wave();
}

non_mortar_guys_deathtally()
{
	self waittill ("death", attacker);
	if (flag("mortar_guys_out") && IsPlayer(attacker) )
	{
		level._normals_killed_during_mortars++;
	}
}

closing_in_on_side(side)
{
	if (level._last_side_warning_in_seconds > 0 || flag("wave2_timer_done") )
	{
		return;
	}
	level thread next_warning_countdown();
	
	if (!IsDefined(level._closing_in_lines_said) || ( IsDefined(level._closing_in_lines_said) && level._closing_in_lines_said.size > 3) )
	{
		level._closing_in_lines_said = [];
	}
	
	foundit = undefined;
	closing_in_line = undefined;
	
	closing_in = [];
	closing_in[0] = "maintain_fire";		//Maintain fire!
	closing_in[1] = "hold_them_back";		//Hold them back!
	closing_in[2] = "they_closing_in";	//They're closing in!

	if (side == "ruins")
	{
		closing_in[3] = "to_east";
	}
	if (side == "street")
	{
		closing_in[3] = "from_southeast";
	}
	if (side == "dock")
	{
		return;//closing_in[3] = "eyes_southwest";
	}
	
	while (!IsDefined(foundit))
	{
		closing_in_line = closing_in[RandomInt(closing_in.size)];

		foundit = 1;
		for (i=0; i < level._closing_in_lines_said.size; i++)
		{
			if ( closing_in_line == level._closing_in_lines_said[i])
			{
				foundit = 1;
			}
		}
		wait 0.05;
	}
	
	level._closing_in_lines_said = array_add(level._closing_in_lines_said, closing_in_line);
	level.woods line_please(closing_in_line);
}
		
		
next_warning_countdown()
{
	level._last_side_warning_in_seconds = 25;
	while (level._last_side_warning_in_seconds > 0)
	{
		level._last_side_warning_in_seconds--;
		wait 1;
	}
}

at_end_of_wave()
{
	self endon ("death");
	while(1)
	{
		if (level._attackers_chasing_player < 2)
		{
			self thread seek_player(128);
			level._attackers_chasing_player++;
			self thread decrement_on_death();
			return;
		}
		wait 4;
	}
}

decrement_on_death()
{
	self waittill ("death");
	level._attackers_chasing_player--;
}

get_my_groupname()
{
	if (!IsDefined(self.script_noteworthy))
	{
		return;
	}
	
	group = [];
	group[0] = "dock";
	group[1] = "street";
	group[2] = "ruins";

	for (i=0; i < group.size; i++)
	{
		if (	is_part_of_name(self.targetname , group[i]) )
		{
			return group[i];
		}
	}
	
	AssertEx (IsDefined(self._dgroup), "Couldnt find right dgroup, but this function should only be used on guys that have a dgroup associated targetname");
}

only_player_kill()
{
	self thread mortars_out_too_long();
	self.health = 999999;
	self disable_pain();
	while(1)
	{
		self waittill ("damage", amount, attacker);
		if (isplayer(attacker) )
		{
			break;
		}
	}
	self.health = 1;
	wait 0.05;
	self killme();
}

mortars_out_too_long()
{
	self endon ("death");
	wait 90;
	self notify ("damage", 500, get_players()[0]);
}

mortar_spotter_setup()
{
	self endon ("death");
	self thread only_player_kill();
	
	node = getstruct(self.target, "targetname");
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 16;
	self SetGoalPos(node.origin);
	self waittill ("goal");
	self thread mortars();
	
	self attach ("prop_mp_handheld_radio", "TAG_INHAND");
	self animscripts\shared::placeweaponOn(self.weapon, "none");
	
	node thread anim_loop_aligned(self, "mortarguy_loop");
	PlayFXOnTag(level._effect["radio_light"], self, "prop_mp_handheld_radio_lod0");
}

mortars()
{
	center = getstruct("mortar_range", "targetname");
	maxoffset = 600;
	startoffset = 200;
	firestructs = getstructarray("artillery_fire_spots_"+self.script_noteworthy, "targetname");
	
	fire_interval_min = 1;
	fire_interval_max = 4.5;
	
	wait RandomFloatRange(fire_interval_min, fire_interval_max);
	
	while(IsAlive(self) )
	{
		org = center.origin + random_offset(startoffset,startoffset,0) ;
		
		firespot = firestructs[RandomInt(firestructs.size)];

		rocket = spawn_a_model ("mortar_shell", firespot.origin);
		yaw_vec = vectortoangles(org - rocket.origin);
		rocket.angles = (315, yaw_vec[1] ,0);
		
		PlayFXOnTag( level._effect[ "rocket_trail" ], rocket, "tag_origin" );
		velocity_strength = RandomIntRange(1650,1850);
		
		playsoundatposition( "prj_mortar_launch", rocket.origin );	
			
		rocket throw_object_with_gravity_for_mortars( rocket, org );
		
		
        PlaySoundatposition( "exp_mortar_dirt", rocket.origin );
		PlayFX (level._effect["airstrike_hit"], rocket.origin);
		RadiusDamage(rocket.origin, 300, 150, 10);
		Earthquake(0.9, 1.2, rocket.origin, 1000);
		rocket SetModel("tag_origin");
		get_players()[0] PlayRumbleOnEntity("artillery_rumble");
		
		if (startoffset <maxoffset )
		{
			startoffset+=70;
		}
		else
		{
			center.origin = get_players()[0].origin;
		}
	
		wait RandomFloatRange(fire_interval_min, fire_interval_max);
		
		rocket Delete();
	}
}

killme_reminder(time, message)
{
	self endon ("death");
	while(1)
	{
		wait time;
	}
}

kill_if_fall()
{
	self endon ("death");
	while(1)
	{
		if (self.origin[2] < (-10000) )
		{
			self killme();
		}
		wait 1;
	}
}
	



	// unfortunately have to do isdefined f
trig_funcs()
{
	GetEnt("tankbuilding_chain","targetname") thread trig_on_notify("chopperstrike_spot3_fire", undefined, 3);
	GetEnt("tankbuilding_chain","targetname") thread trig_on_notify("end_strafe");
	GetEnt("third_wave", "target") thread killspawner_on_trigger(103);
	
	GetEnt("nearing_e2", "targetname") thread func_on_trig(::clear_e1_ai);


	GetVehicleNode("alley_chopper_shotdown_node", "script_noteworthy") thread setflag_ontrig("alley_cross_chopper_shootdown_go");
	GetVehicleNode("tank_final_node", "script_noteworthy") thread setflag_ontrig("tank_in_final_position");
	GetVehicleNode("enemytank1_almost_inplace", "script_noteworthy") thread setflag_ontrig("enemytank1_almost_inplace");

	GetVehicleNode("defend_huey_exploder_1", "script_noteworthy") thread exploder_on_trigger(751, 0.5);
	GetVehicleNode("defend_huey_exploder_2", "script_noteworthy") thread exploder_on_trigger(752);
	GetVehicleNode("defend_huey_exploder_3", "script_noteworthy") thread exploder_on_trigger(753);

}

alley_aa_gun_setup()
{
	flag_set("alley_aa_gun_spawned");
}

alley_tank_setup()
{
	exploder(700);

	self endon ("death");
	Earthquake(0.6, 1.5, self.origin, 1500);
	trigger_use("tank_scare_chain");
	wait 0.5;

	self thread alley_tank_fire_loop();
	flag_wait("player_ready_alley_door");
	level notify ("stop_alley_tank_fire_loop");
	wait 10;
	self thread alley_tank_fire_loop();
	
}

alley_tank_fire_loop()
{
	self endon ("death");
	level endon ("stop_alley_tank_fire_loop");
	while(1)
	{
		allies = array_remove(GetAIArray("allies"), level.reznov);
		self SetTurretTargetEnt( allies[ RandomInt(allies.size) ] );
		wait 6;
		self FireWeapon();
	}
}

alley_balcony_guys_setup()
{
	self endon ("death");
	clip = GetEnt("alley_balcony_nosight_clip", "targetname");
	while(IsDefined(clip))
	{
		level waittill ("only_player_window_broke", pos);
		if (DistanceSquared(pos, clip.origin) < (60*60) )
		{
			break;
		}
	}
	
	while(1)
	{
		level waittill ("glass_smash", pos);
		if (DistanceSquared(pos, clip.origin) < (60*60) )
		{
			break;
		}
	}
	
	clip Delete();
	self SetThreatBiasGroup("axis");
}

defend_tank_setup()
{
	self endon ("death");
	self endon ("stop_targetfinding");
	level endon ("final_airstrike_called");

	self thread maps\_vehicle_turret_ai::enable_turret( 0, "mg", "allies" );
	self.turret_audio_override = true;
	self.turret_audio_ring_override_alias = true;
  self.turret_audio_override_alias = "wpn_50cal_fire_loop_npc";
  self.turret_audio_ring_override_alias = "wpn_50cal_fire_loop_ring_npc";
	self thread defend_tank_blow_gates();
	
	while(1)
	{

		allies = GetAIArray("allies");
		allies = array_add(allies, level.player);
		if (cointoss() )
		{
			self SetTurretTargetEnt(allies[RandomInt(allies.size)]);
		}
		else
		{
			self SetTurretTargetEnt(level.player);
		}
		wait 3;
		self FireWeapon();
		wait RandomFloatRange(3,7);
	}
}

defend_tank_blow_gates()
{
	level waittill ("final_airstrike_called");
	gate = GetEnt("defend_gate_right", "targetname");
	self SetTurretTargetVec(gate.origin+(-60,0,50) );
	wait 3;
	self FireWeapon();
	//kevin adding gate blow audio
	gate playsound( "evt_gate_explo" );
	level notify("blow_defend_gates");
	
	level waittill ("building_fallover_now");
	RadiusDamage(self.origin, 100, 10000, 5000); 
}

street_retreater_setup()
{
	self thread maybe_dont_drop_weapon();
	self thread wait_and_kill(RandomIntRange(5,10) ) ;
	self.ignoreall = 1;
	self endon ("death");
	self.goalradius = 4;
	wait 1;
	self disable_cqbwalk();
	self waittill ("goal");
	self.ignoreall = 0;
}

ignore_player_onflag_setup()
{
	if (flag("ignore_player_now"))
	{
		self thread ignore_player_setup();
	}
}

ignore_player_setup()
{
	self endon ("death");
	wait 0.3;
	if (level.gameskill != 3)
	{
		self SetThreatBiasGroup("ignore_player");
	}
}


vin_area_stackers_setup()
{
	self thread cqbchance(101);
	self thread disable_replace_on_death();
	self thread kill_on_notify("get_chopper_now");
}

street_heroes_setup()
{
	wait 0.3;
	self SetThreatBiasGroup("ignored_hero");
}

street_spotlight_on_gun()
{
	self SetVehicleLookAtText ("RT Texas", &"HUE_CITY_HUEY_TYPE" );
	wait 0.1;
	
	level notify("new_spotlight_chopper");

	org = self GetTagOrigin("tag_flash_gunner4");
	ang = self GetTagAngles("tag_flash_gunner4");
	
	spot = spawn_a_model("tag_origin", org, ang );
	
	spot LinkTo (self, "tag_flash_gunner4");
	PlayFXOnTag(level._effect["spotlightd"],spot, "tag_origin");
	
	targetspot = spawn_a_model("tag_origin", (0,0,0) );
	PlayFXOnTag(level._effect["spotlightd_target"],targetspot, "tag_origin");
	
	
	while(IsAlive(self) )
	{
		direction = spot.angles;
		direction_vec = anglesToForward( direction );
		org = spot.origin;
		
		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace = bullettrace( org, org + vector_multiply( direction_vec , 10000 ), 0, undefined );
		//trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"], 0, get_players()[0] );
		
		// debug		
		//thread draw_line_for_time( eye, trace2["position"], 1, 0, 0, 0.05 );
		
		targetspot.origin = trace["position"];
		wait 0.05;
	}
	
	spot Delete();
}

bowman_ai_setup()
{
	level.bowman = self;
	level.squad["bowman"] = self;
	self.animname = "bowman";
}

reznov_ai_setup()
{
	level.reznov = self;
	level.squad["reznov"] = self;
	self.animname = "reznov";
	self notify("stop_hide");
	self thread hide_reznov();
}


hide_reznov()
{
	self endon("stop_hide");
	visible = 1;
	while(1)
	{
		reznov_invisible = getdvarint("hide_reznov");
		if(reznov_invisible != 0 && visible)
		{
			visible = 0;
			make_reznov_invisible();
		}
		else if(reznov_invisible == 0 && !visible)
		{
			visible = 1;
			make_reznov_visible();
		}
		wait(1);
	}
}

make_reznov_invisible()
{
	self hide();
}

make_reznov_visible()
{
	self show();
}


street_bowman_setup()
{
	bowman_ai_setup();
}

street_reznov_setup()
{
	
//	while(!flag("alley_aa_gun_spawned") )
//	{

//		if (DistanceSquared(self.origin, get_players()[0].origin) > (self.goalradius*self.goalradius) )
//		{
//			vec = self.origin- get_players()[0].origin;
//			nvec = VectorNormalize(vec);
//			newgoal = get_players()[0].origin + (nvec*125);
//			self SetGoalEntity(level.player);
//		}
//		wait 2;
//	}
	self.goalradius = 300;
	self SetGoalEntity(level.player);
	flag_wait("alley_aa_gun_spawned");
	self set_force_color("r");
	self enable_ai_color();
}

Poor_Friend_Setup()
{
//	self stop_magic_bullet_shield();
//	spot1 = getstruct("poorfriend_nadestart", "targetname").origin;
//	spot2 = getstruct("poorfriend_nadeend", "targetname").origin;
//	self.grenadeawareness = 0;
//	guy = simple_spawn( "guy_animated_shot_on_perch")[0];
//	guy.grenadeawareness = 0;
//	guy SetCanDamage(false);
//	guy.a.disablepain = true;
//	
//	self.ignoreme = true;
//	spot = GetVehicleNode("auto12389782", "targetname");
//	trigger_wait("player_approaching_perch");
//	wait 6;
//	
//	level.woods MagicGrenade(spot1, spot2, 2);
//	self stop_magic_bullet_shield();
//	self.ignoreme = false;
//	wait 2.5;
//	self.grenadeawareness = 1;
//	self thread wait_and_kill(RandomFloat(7));
}

street_charge_guys_setup()
{
	self.goalradius = 400;
	self SetGoalPos( ( -4816.8, 982.7, 7488) );
	self thread wait_and_kill( RandomFloatRange(10, 15) );
	self thread ignore_till_goal();
	self.moveplaybackrate = self.moveplaybackrate*1.2;
}


woods_setup()
{
	level.woods = self;
	level.squad["woods"] = self;
}

comeout_on_balcony_guys_setup()
{
	self endon ("death");
	wait RandomFloat(8,12);
	self killme();
}

aa_gun_crew_setup()
{
	self stopanimscripted();
	self startragdoll();
	wait 0.1;
	self launchragdoll( (0,0,170) );
	self notify ("killanimscript");
	self killme();
}

e3_roofguys_setup()
{
	self endon ("death");
	level waittill("roof_guys_die");
	self wait_and_kill(RandomFloat(8));
}

cqbchance(chance)
{
	if (!IsDefined(chance))
	{
		chance = 10;
	}
	
	if ( RandomInt(100) < chance)
	{
		self enable_cqbwalk();
	}
}

clear_node_on_death(mynode)
{
	self waittill ("death");
	mynode._taken = undefined;
}

executed_civs()
{
	self waittill_any("damage", "death");
	
	if( is_mature() )
	{
		if (cointoss() )
		{
			PlayFXOnTag(level._effect["heli_mowdown_blood_geyser"], self, "tag_eye");
		}
		else
		{
			PlayFXOnTag(level._effect["heli_mowdown_multihit"], self, "tag_eye");
		}
	}
	
	wait 0.1;
	self ragdoll_death();
}

clear_e1_ai()
{
	guys = GetAIArray();
	for (i=0; i < guys.size; i++)
	{
		if (!IsDefined(guys[i].script_hero) || (IsDefined(guys[i].script_hero) && guys[i].script_hero ==0 ) ) 
		{
			guys[i] Delete();
		}
	}
}

rpg_refill()
{
	self endon("death");
	player = get_players()[0];
	player endon("death");
	self.script_nodropsidearm = 1;
	
	if (self.weapon == "rpg_sp")
	{
		self.a.rockets = 50;
	}
	else
	{
		self thread close_to_player_nowattack();
	}
}

helicopter_haters()
{
	self endon ("death");
	self thread only_player_kill();
	self.ignoreme = true;
	self.ignoreall = true;
	//self thread magic_bullet_shield();
	
	struct = getstruct(self.animname+"_struct", "targetname");
	self.goalradius = 16;
	self SetGoalPos(struct.origin);
	self waittill ("goal");
	struct anim_single_aligned(self, "hate_on_helis");
	self killme();
}

scared_into_mowdown_guys_setup()
{
	self endon ("death");
	self thread event1_second_encounters_runners_think();
	
	firstnode = GetNode(self.target, "targetname");
	self force_goal(firstnode, 16);
}
	
stair_guys_setup()
{
	self endon ("death");
	self cqbchance();
	node1 = GetNode(self.target, "targetname");
	self SetGoalNode(node1);

}

force_to_goal()
{
	mygoal = GetNode(self.target, "targetname");
	self force_goal (mygoal);
}

intro_enemies_2a_setup()
{
	self endon ("death");
	self thread ignore_on();
	wait 5;
	self enable_cqbwalk();
}

maybe_dont_drop_weapon()
{
	if (self.dropweapon == 1 && cointoss())
	{
		self.dropweapon = 0;
	}
}

cqb_and_ignore()
{
	self thread ignore_on();
	self enable_cqbwalk();
}

give_unregulated_threatbias()
{
	self SetThreatBiasGroup("standard_enemies");
}


random_direction_die()
{
	self.goalradius = 16;
	self.ignoreme = 1;
	self.ignoreall = 1;
	self SetGoalPos(self.origin+(random_offset(200,200,0) ) );
	wait 1;
	self ragdoll_death();
}

close_to_player_nowattack()
{
	self endon ("death");
	if(isDefined(self.team) && self.team != "axis")
	{
		return;
	}
	
	while(1)
	{
		wait 1;
		if (DistanceSquared(self.origin, level.player.origin) < 400*400 )
		{
			self SetThreatBiasGroup("player_biased_enemies");
			break;
		}
	}
}