/*
	
	THIS SCRIPT HANDLES EVERYTHING UTILITY TO POW

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;

pow_objectives( jumpto_objective )
{
	wait_for_first_player();
	
	//SetSavedDvar("cg_objectiveIndicatorFarFadeDist", 180000);
	
	
	players = get_players();
	for( i=0; i < players.size; i++ )
	{
		players[i] SetClientDvar("cg_objectiveIndicatorFarFadeDist", 80000);
	}
	
	
	/* 
		List of objective Flags:
		
			obj_kill_hind_crew
			obj_take_hind
			obj_fly_to_base
			obj_truck_depot
			obj_truck_depot_complete
			obj_player_in_hind
			obj_large_boat
			obj_enemy_hind
	*/
	
	obj_number = 0;
	
	if(!IsDefined(level.pow_demo))
	{
		//------------------------------------------------------------------------------------------
		flag_wait( "obj_chase_russian" );
		//-- Setup the object to get the russian
		obj_number++;
		
		Objective_Add( obj_number, "current", &"POW_OBJ_GET_RUSSIAN" );
		Objective_Set3D( obj_number, true);
		pow_objectives_tunnel_breadcrumb( obj_number );
		
		flag_wait("obj_russian_start");
		
		level notify("stop_breadcrumb_obj"); //-- kill the breadcrumb system
		
		obj_ent = Spawn("script_model", level.russian.origin + (0,0,70));
		obj_ent SetModel("tag_origin");
		obj_ent LinkTo(level.russian);
		Objective_Position( obj_number, obj_ent );
		Objective_Set3d( obj_number, true, "default", &"POW_SHOOT" );
		
		flag_wait("spetz_hit"); //-- turn off the objective when the russian gets shot
		Objective_Set3d( obj_number, false );
		Objective_State( obj_number, "done" );
		
		/* -- old follow Woods objective
		Objective_AdditionalPosition( obj_number, 0, level.woods );
		Objective_Set3D( obj_number, true, "default", &"POW_FOLLOW);
		*/
		
		//flag_wait( "obj_chase_russian_complete" );
		
		
		//------------------------------------------------------------------------------------------
		flag_wait( "obj_boost_woods" );
		//-- Setup the object to boost woods out of the cave
		obj_number++;
		
		obj_boostup = getstruct("obj_boost_woods_struct");
		Objective_Add( obj_number, "current", &"POW_OBJ_TUNNELS", obj_boostup.origin );
		Objective_Set3D( obj_number, true);
	
		flag_wait( "obj_boost_woods_complete" );
		Objective_Set3D( obj_number, false);
		Objective_State( obj_number, "done" );
		Objective_Delete( obj_number);
	}
	
	//------------------------------------------------------------------------------------------
	flag_wait( "obj_kill_hind_crew" );
	//-- Setup the object to kill the russian hind crew
	Objective_Add( obj_number, "current", &"POW_OBJ_HIND" );
		
	//------------------------------------------------------------------------------------------
	flag_wait( "obj_take_hind" );
	Objective_State( obj_number, "done" );

	obj_number++;
	Objective_Add( obj_number, "current", &"POW_OBJ_GET_IN");
	obj_origin = level.hind GetTagOrigin("tag_driver"); //-- Specific location to enter the Hind Helicopter
	Objective_Position( obj_number, obj_origin );
	Objective_Set3D( obj_number, true );
	
	//------------------------------------------------------------------------------------------
	flag_wait( "obj_player_in_hind" );
	Objective_State( obj_number, "done" );
	Objective_Delete( obj_number);
	flag_wait( "obj_fly_to_base" );
	
	//-- Setup the objective to fly to The Bear's base
	//     ... this objective does not clear until you actually reach his base
	//     and there are several objectives inbetween...
		
	//obj_number++;
	obj_land_num = obj_number;
	Objective_Add( obj_land_num, "current", &"POW_POW_OBJ_FLY_KRAV"); //-- typo fixed in script, not the string file
	Objective_Set3D( obj_land_num, true);
	level thread pow_objectives_flying_breadcrumb( obj_land_num );
		
	//------------------------------------------------------------------------------------------
	flag_wait( "obj_truck_depot"); //-- This flag gets set by a trigger in radiant
	//-- Setup the objective to destroy the truck depot
	
	obj_number++;
	if(IsDefined(level.pipe_tank_destroyed) && !level.pipe_tank_destroyed)
	{
		large_tank = GetEnt( "pipe_tank_1", "script_noteworthy" );
		Objective_Add( obj_number, "current", &"POW_OBJ_NVA_DEF", large_tank.origin);
		Objective_Set3D( obj_number, true );
		Objective_Set3D( obj_land_num, false );
	
		flag_wait_any( "obj_truck_depot_complete", "obj_truck_depot_passed");
		if(flag("obj_truck_depot_complete"))
		{
			Objective_State( obj_number, "done" );
		}
		Objective_Delete( obj_number );
		Objective_Set3D( obj_land_num, true);
	}
		
	//------------------------------------------------------------------------------------------
	
	flag_wait( "obj_enemy_hip");
	//obj_number++;
	
	Objective_Add( obj_number, "current", &"POW_OBJ_HIP");
	enemy_hip = GetEnt("enemy_hip", "targetname");
	enemy_hip thread set_flag_on_notify( "death", "obj_enemy_hip_complete" );
	Objective_AdditionalPosition( obj_number, 0, enemy_hip );
	Objective_Set3D( obj_number, true);
	Objective_Set3D( obj_land_num, false );
	
	
	flag_wait_any( "obj_enemy_hip_complete", "obj_enemy_hip_passed");
	if(flag("obj_enemy_hip_complete"))
	{
		Objective_State( obj_number, "done" );
	}
	Objective_Delete( obj_number );
	Objective_Set3D( obj_land_num, true);
	
	//------------------------------------------------------------------------------------------
	
	flag_wait( "obj_sam_cave" );
	Objective_Add( obj_number, "current", &"POW_OBJ_SAM" );
	obj_pos_struct = getstruct( "struct_sam_cave_explo", "targetname");
	Objective_Position( obj_number, obj_pos_struct.origin );
	Objective_Set3D( obj_number, true, "default" );
	Objective_set3D( obj_land_num, false );
	
	level thread watch_for_sam_cave_passed();
	flag_wait_any( "obj_sam_cave_complete", "obj_sam_cave_passed" );
	if(flag("obj_sam_cave_complete"))
	{
		Objective_State( obj_number, "done" );
	}
	Objective_Delete( obj_number);
	Objective_Set3D( obj_land_num, true);
	
	//------------------------------------------------------------------------------------------
	
	flag_wait( "obj_large_village" );	//-- this flag gets set by a trigger in radiant
	
	//obj_number++;
	Objective_Add( obj_number, "current", &"POW_OBJ_NVA_DEF");
	other_ents = [];
	if(!flag("radio_tower_destroyed"))
	{
		other_ents[0] = getent( "fxanim_pow_radar_tower_mod", "targetname" );
	}
	level thread update_destroy_village_position( obj_number, "village_zsus",  other_ents, "obj_large_village_complete" );
	Objective_Set3D( obj_number, true, "default" );
	Objective_Set3D( obj_land_num, false );
	
	//optionally, the player can kill the 2 bridge ZSUs and fly past the pipe bridge and the level should continue
	level thread both_zsus_and_past_pipe( "obj_large_village_complete" );
	
	flag_wait( "obj_large_village_complete");
	level notify( "obj_large_village_complete_end_threads" );
	flag_set("music_villagefinished");
	Objective_State( obj_number, "done" );
	Objective_Delete(obj_number );
	Objective_Set3D( obj_land_num, true);
	
	//------------------------------------------------------------------------------------------
		
	flag_wait( "obj_enemy_hind" );
	
	obj_number++;
	Objective_Add( obj_number, "current");
	Objective_String( obj_number, &"POW_OBJ_HINDS", 2 );
	level thread update_destroy_village_position( obj_number, "hind_for_last_battle", undefined, "obj_enemy_hind_complete" );
	Objective_Set3D( obj_number, true, "default" );
	Objective_Set3D( obj_land_num, false );
	
	level waittill("obj_enemy_hind_complete"); //-- should get triggered when 1 (either) gets destroyed
	Objective_String( obj_number, &"POW_OBJ_HINDS", 1 );
	
	flag_wait( "obj_enemy_hind_complete" );
	wait(3);
	flag_set("music_twohindsdestroyed");
	
	//TUEY set music state to LANDING
	setmusicstate ("LANDING");
	
	Objective_State( obj_number, "done" );
	Objective_Delete( obj_number, "done" );
	
	Objective_Set3D( obj_land_num, true );
	
	//------------------------------------------------------------------------------------------
	
	flag_wait( "obj_hind_landing" );
	Objective_State( obj_land_num, "done" );
	
	//------------------------------------------------------------------------------------------
	
	flag_wait( "obj_to_kravchenko" );
	Objective_Add( obj_number, "current", &"POW_OBJ_KILL_KRAV");
	Objective_AdditionalPosition( obj_number, 0, level.woods );
	Objective_Set3D( obj_number, true, "default", &"POW_FOLLOW" );
	
	
	//-- FLAMETHROWER OBJECTIVE -------------------------------------------
	//flag_wait("obj_player_needs_ft");
	
	//level.woods thread anim_single(level.woods, "get_ft"); //-- just tell the player about the ft.
	/*
	obj_number++;
	goal_weapon = GetEnt("ak47_ft", "targetname");
	Objective_Add( obj_number, "current", &"POW_OBJ_AK47_FLAME", goal_weapon.origin + (0,0,12));
	Objective_Set3D( obj_number, true);
	goal_weapon waittill("trigger");
	Objective_State( obj_number, "done" );
	Objective_Delete(obj_number );
	*/
	
	flag_wait( "woods_ready_to_save_pows" );
	goal_pos = getstruct("struct_woods_cell_open", "targetname");
	Objective_Add( obj_number, "current", &"POW_OBJ_POWS", goal_pos.origin + (0,0,48));
	Objective_Set3D( obj_number, true, "default");
	
	flag_wait("player_saved_pows");
	Objective_State( obj_number, "done" );
	Objective_Delete( obj_number );
	
	//... keep adding more objectives
	
	Objective_Add( obj_number, "current", &"POW_OBJ_KILL_KRAV");
	Objective_Set3D( obj_number, true, "default" );
	level thread pow_objectives_krav_breadcrumb( obj_number );
	
	player = get_players()[0];
	player waittill("door_breached");
	Objective_Set3D( obj_number, false, "default" );
	level waittill("swap_rez_now");
	Objective_State( obj_number, "done" );
}

watch_for_sam_cave_passed()
{
	flag_wait( "obj_large_village" );
	flag_set( "obj_sam_cave_passed" );
}

both_zsus_and_past_pipe( flag_to_set )
{
	level endon( flag_to_set + "_end_threads" );
	
	zsus = [];
	zsus[0] = GetEnt("bridge_zsu_left", "script_noteworthy");
	zsus[1] = GetEnt("bridge_zsu_right", "script_noteworthy");
	
	while( zsus.size > 0 )
	{
		zsus = array_removedead(zsus);
		wait(0.1);
	}

	trigger_wait( "nva_pbr_start" );
	flag_set( flag_to_set );
}

pow_objectives_tunnel_breadcrumb( obj_number )
{
	obj_triggers = GetEntArray("cave_objs", "targetname");
	array_thread( obj_triggers, ::update_fly_to_pos, obj_number );
}

//-- Specifically the "fly to base" objective
pow_objectives_flying_breadcrumb( obj_number )
{
	obj_triggers = GetEntArray("flying_objective", "targetname");
	array_thread( obj_triggers, ::update_fly_to_pos, obj_number );
}

update_fly_to_pos( obj_number )
{
	//TODO: create endon condition for this
	self endon("death"); //-- this should be when the trigger gets deleted
	level endon("stop_breadcrumb_obj");
	
	while(1)
	{
		self waittill("trigger", guy);
		level notify("fly_obj_trig_hit");
		self trigger_off();
		
		obj_struct = getstruct(self.target, "targetname");
		Objective_Position( obj_number, obj_struct.origin );
		
		level waittill("fly_obj_trig_hit");
		self trigger_on();
	}
}

pow_objectives_krav_breadcrumb( obj_number )
{
	obj_triggers = GetEntArray("krav_bread_objective", "targetname");
	array_thread( obj_triggers, ::update_fly_to_pos, obj_number );
}

update_destroy_village_position( obj_number, vehicles_name, destructibles, flag_to_set )
{
	level endon(flag_to_set + "_end_threads" );
	targets = GetEntArray( vehicles_name, "targetname" );
	targets = array_removedead(targets);
	//triggers = GetEntArray( trigger_name, "targetname" );
	
	array_thread(targets, ::update_position_on_death, flag_to_set);
	
	if(IsDefined(destructibles))
	{
		array_thread(destructibles, ::updated_obj_on_break, flag_to_set );
		targets = array_combine( targets, destructibles );
	}
	
	while( targets.size > 0)
	{
		i = 0;
		
		for( ; i < 8 && i < targets.size; i++) //-- 8 is the limit for Objective_AdditionalPosition
		{
			if( targets[i].classname == "trigger_multiple" )
			{
				temp_ent = GetEnt(targets[i].target, "targetname");
				Objective_AdditionalPosition( obj_number, i, temp_ent.origin );
			}
			else
			{
				Objective_AdditionalPosition( obj_number, i, targets[i] );
			}
		}
		
		for( ; i < 8; i++ )
		{
			//Objective_AdditionalPosition( obj_number, i, undefined );
			Objective_AdditionalPosition( obj_number, i, (0,0,0) );
		}
		
		level waittill(flag_to_set);
		
		//targets = array_removedead(targets);
		new_array = [];
		for( i = targets.size - 1; i >= 0; i-- )
		{
			if(IsDefined(targets[i].obj_break))
			{
				if(targets[i].obj_break)
				{
					targets = array_remove(targets, targets[i]);
				}
			}
			else if( !IsAlive( targets[ i ] ) || ( isDefined( targets[i].isacorpse) && targets[i].isacorpse) ) //-- basically array_removedead, but that was removing the destructibles as well, so changed it to this
			{
				targets = array_remove(targets, targets[i]); 
			}
		}
	}
	
	flag_set(flag_to_set);
}

update_destroy_depot_position( obj_number, truck_script_noteworthy )
{
	obj_origins = [];
	//-- There are 5 of these in radiant (0-4), have to change this number if i add another objective
	for( i = 0; i < 1; i++ ) //TODO: reduced down to just the 1 group of trucks, everything else is gravy
	{
		obj_origins[i] = GetEnt("required_truck_depot_" + i, "targetname");
	} 
	
	obj_targets = [];
	for( i = 0; i < obj_origins.size; i++ )
	{
		veh_array = GetEntArray( obj_origins[i].targetname, "script_noteworthy" );
		obj_targets = array_combine( obj_targets, veh_array );
	}
	
	array_thread(obj_targets, ::update_position_on_death, "update_truck_depot_location");
	
	while( obj_targets.size > 0)
	{
		i = 0;
		
		for( ; i < 8 && i < obj_origins.size; i++) //-- 8 is the limit for Objective_AdditionalPosition
		{
			count = how_many_matching_objectives( obj_origins[i], obj_targets );
			
			if( count > 1 )
			{
				Objective_AdditionalPosition( obj_number, i, obj_origins[i].origin );
			}
			else
			{
				target_ent_array = GetEntArray(obj_origins[i].targetname, "script_noteworthy");
				target_ent = array_removedead(target_ent_array);
				Objective_AdditionalPosition( obj_number, i, target_ent[0] );
			}
		}
		
		for( ; i < 8; i++ )
		{
			//Objective_AdditionalPosition( obj_number, i, undefined );
			Objective_AdditionalPosition( obj_number, i, (0,0,0) );
		}
		
		level waittill("update_truck_depot_location");
		
		//-- remove dead vehicles
		obj_targets = array_removedead(obj_targets);
		
		//-- remove completed objective origins
		for( i = 0; i < obj_origins.size; i++ )
		{
			count = how_many_matching_objectives( obj_origins[i], obj_targets );
			if( count == 0 )
			{
				obj_origins = array_remove( obj_origins, obj_origins[i] );
				i--;
			}
		}
	}
	
	flag_set("obj_truck_depot_complete");
	flag_set("music_truckdepotdestroyed");
}

how_many_matching_objectives( script_origin, vehicles )
{
	count = 0;
	
	for( i = 0; i < vehicles.size; i++ )
	{
		if( script_origin.targetname == vehicles[i].script_noteworthy )
		{
			count++;
		}
	}	
			
	return count;
}


update_position_on_death( update_msg ) 
{
	while( IsDefined(self) && !self maps\_vehicle::is_corpse()) //TODO: check to see if this is a hack
	{
		wait(0.1);
	}
	
	level notify( update_msg );
}

updated_obj_on_break( update_msg )
{
	self.obj_break = false;
	self waittill("break");
	self.obj_break = true;
	level notify( update_msg );
}

objective_delay_then_update( delay_time, notify_str )
{
	wait(delay_time);
	level notify("update_objectives");
	
	//-- An optional string for the script to notify on
	if(IsDefined(notify_str))
	{
		level notify(notify_str);
	}
}

//-- This is called on the destructible bridges in the Flyable Helicopter event
bridge_rocket_notify( bridge_name, level_notify )
{
	level endon("kill_bridge_threads");
	level endon(level_notify);
	
	bridge = GetEnt(bridge_name, "targetname");
	AssertEX(IsDefined(bridge), "Trying to destroy a bridge which doesn't exist");
	
	bridge SetCanDamage(true);
	
	while(1)
	{
		bridge waittill("damage", dmg_amount, attacker, dir, point, type);
		
		//-- only the player hind rockets should be doing this much damage
		//TODO: figure out if there is a better way to do this
		if(dmg_amount > 300)
		{
			break;
		}
			
		wait(0.05);
	}
	
	level notify(level_notify);
}

bridge_minigun_notify( bridge_name, level_notify, health )
{
	level endon("kill_bridge_threads");
	level endon(level_notify);
	
	bridge = GetEnt(bridge_name, "targetname");
	AssertEX(IsDefined(bridge), "Trying to destroy a bridge which doesn't exist");
	
	bridge SetCanDamage(true);
	bridge.health = health + 10000;
	
	total_damage = 0;
	
	while(1)
	{
		bridge waittill("damage", dmg_amount, attacker, dir, point, type);
		
		total_damage += dmg_amount;
		//-- only the player hind rockets should be doing this much damage
		//TODO: figure out if there is a better way to do this
		if(total_damage > health)
		{
			break;
		}
			
		wait(0.05);
	}
	
	level notify(level_notify);
}

wood_bridge_rocket_clip_notify(bridge_clip, level_notify)
{
	level endon("kill_bridge_threads");
	level endon(level_notify);
	
	bridge = GetEnt(bridge_clip, "targetname");
	AssertEX(IsDefined(bridge), "Trying to destroy a bridge which doesn't exist");
	
	bridge SetCanDamage(true);
	
	while(1)
	{
		bridge waittill("damage", dmg_amount, attacker, dir, point, type);
		
		//-- only the player hind rockets should be doing this much damage
		//TODO: figure out if there is a better way to do this
		if(dmg_amount > 300)
		{
			break;
		}
			
		wait(0.05);
	}
	
	level notify(level_notify);
}

//-- This is called on the destructible bridges in the Flyable Helicopter event
radar_tower_notify( radar_name, level_notify )
{
	radar_tower = GetEnt(radar_name, "targetname");
	AssertEX(IsDefined(radar_tower), "Trying to destroy a radar tower which doesn't exist");
	
	radar_tower.health = 10000;
	radar_tower SetCanDamage(true);
	
	radar_tower thread radar_tower_create_dish();
	
	while(1)
	{
		radar_tower waittill("damage", dmg_amount, attacker, dir, point, type);
		
		//-- only the player hind rockets should be doing this much damage
		//TODO: figure out if there is a better way to do this
		if(dmg_amount > 300)
		{
			radar_tower notify("radar_tower_broke");
			break;
		}
			
		wait(0.05);
	}
	
	level notify(level_notify);
	radar_tower Delete();
}

radar_tower_create_dish()
{
	radar_tower = GetEnt("fxanim_pow_radar_tower_mod", "targetname");
	
	radar_dish = Spawn("script_model", (57160, 8068, 1760));
	radar_dish SetModel("p_rus_radar_dish");
	radar_dish.origin = radar_tower GetTagOrigin("radar_dish_jnt");
	radar_dish.angles = radar_tower GetTagAngles("radar_dish_jnt");
	
	radar_dish thread radar_dish_rotate(self);
	
	self waittill("radar_tower_broke");
	radar_dish LinkTo(radar_tower, "radar_dish_jnt", (0,0,0), (0,0,0));
}

radar_dish_rotate( tower )
{
	tower endon("radar_tower_broke");
	
	while(1)
	{
		new_yaw = self.angles[1] + 90;
		if(self.angles[1] > 360)
		{
			new_yaw -= 360;
		}
		self RotateYaw( new_yaw, 5, 0, 0 );
		self waittill("rotatedone");
	}
}

invincible_hind()
{
	while(IsAlive(self))
	{
		self waittill("damage", amount);
		self.health += amount;
	}
	
	AssertEx( true, "Something broke and the invincible hind died");
}

convoy_basic_fire_loop_rpg( target ) //self == truck, jeep, sampan, etc
{
	self endon("death");
	
	while(true)
	{
		self convoy_fire_rpg( target );
		wait(3);
	}
}

throw_boat_driver_on_death()
{
	self waittill("death");
	
	if(!IsDefined(self)) //-- then I deleted the boat
	{
		return;
	}
	
	driver = Spawn( "script_model", self.origin + (0,0,120) );
	driver SetModel("c_vtn_vc2_fb_drone"); //-- specific drone model for POW
	
	if(available_ragdoll(true))
	{
		driver add_to_ragdoll_bucket();
		
		if( IsDefined(self.weapon_last_damage) && self.weapon_last_damage == "hind_rockets" )
		{
			// Launch me
			driver LaunchRagdoll((100, 100, 200), driver.origin);
		}
		else
		{
			driver LaunchRagdoll((50, 50, 30), driver.origin);
		}
	}
	
	wait(15);
	if(IsDefined(driver))
	{
		driver Delete();
	}
}

heli_fire_rpg( target )
{
	if(target is_helicopter())
	{
		new_target = Spawn("script_model", target.origin);
		new_target SetModel("tag_origin");
		
		forward = VectorNormalize(AnglesToForward(target.angles));
		up = VectorNormalize(AnglesToUp(target.angles));
		offset = (forward * 300) + (up * -50);
		new_target LinkTo(target, "tag_origin", offset, (0,0,0));
		
		target = new_target;
	}
	
	start_pos_l = self GetTagOrigin("tag_rocket2");
	start_pos_r = self GetTagOrigin("tag_rocket3");
	end_pos = target.origin;
		
	MagicBullet( "hind_rockets", start_pos_l, end_pos, self );
	MagicBullet( "hind_rockets", start_pos_r, end_pos, self );
	
}

convoy_fire_rpg( target ) //self == truck, jeep, sampan, etc
{
	//-- TODO: Check to see which vehicle it is, to setup the correct firing start position 
	
	start_pos = self.origin + (0,0,120);
	end_pos = target.origin;
	
	MagicBullet( "rpg_pow_sp", start_pos, end_pos, self );
	
}

convoy_fire_mg() //self == truck, jeep, sampan, etc
{
	
}

ambient_dialog_manager()
{
	
}


rain_start() //-- self is probably a helicopter
{
	level endon("rain_stop");
	
	if(IsDefined(level.rain_ent))
	{
		return false;
	}
	
	level.rain_ent = Spawn("script_model", self.origin);
	level.rain_ent SetModel("tag_origin");
	level.rain_ent LinkTo(self, "tag_origin", (0,0,0), (0,0,0));
	
	while(true)
	{
		PlayFXOnTag( level._effect["rain"], level.rain_ent, "tag_origin");
		wait(0.15);
	}
}


rain_stop()
{
	if(IsDefined(level.rain_ent))
	{
		level.rain_ent Delete();
		level notify("rain_stop");
		return true;
	}
	
	return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//	Radio Chatter - stolen from inc_pilot
///////////////////////////////////////////////////////////////////////////////////////
random_radio_chatter() //self is the hind
{

	self endon( "death" );

	random_chatter = [];
	random_chatter[0] = "vox_huey_radio_01";
	random_chatter[1] = "vox_huey_radio_02";
	random_chatter[2] = "vox_huey_radio_03";
	random_chatter[3] = "vox_huey_radio_04";

	while( 1 )
	{
		if( IsDefined( self ) && IsAlive( self ) )
		{
			self PlaySound( random_chatter[randomint(random_chatter.size)] );
		}

		wait(RandomIntRange (10,23));
//		wait( 10 );
	}

}

sam_lead_target(target) //-- self is the script struct firing the missiles
{
	bullet_max_speed = 6000;
	target_speed = target GetSpeed();
	target_forward = AnglesToForward(target.angles);
	targetted_vec = target.origin;
	
	distance_to_target = Distance(self.origin , targetted_vec);
	bullet_travel_time = distance_to_target / bullet_max_speed;
	
	bullet_offset_forward = target_forward * bullet_travel_time * target_speed;
	end_vec = targetted_vec + bullet_offset_forward;
	
	//return end_vec;
	return targetted_vec;
}

hind_reload_VO() //-- self is the hind
{
	self endon("death");
	self endon("landed");
	
	while(true)
	{
		self waittill("rocket_reload", rockets_free );
		
		rand_num = RandomIntRange(0, 99);
		
		if(rand_num < 20)
		{
			if(rockets_free == 0)
			{
				level thread dialog_fly_reload(2);
			}
			else
			{
				rand_line = RandomInt(2);
				level thread dialog_fly_reload(rand_line);
			}
		}
		else
		{
			// do nothing
		}
		
		wait(10); //-- don't want rocket spamming to cause this to trigger too often
	}
}

hind_damage_think() //-- self == player hind
{
	self thread hind_damage_player();
	self thread hind_damage_cockpit_swap();
	self thread hind_damage_health_watch();
	self thread hind_reload_VO();
}

hind_destroyed_parts()
{
	self waittill( "switch_climbin_anim" );
	
	self.extra_parts = array("fxanim_gp_hind_dashboard_mod", "fxanim_gp_hind_periscope_mod", "fxanim_gp_hind_top_light_mod", "fxanim_gp_hind_wire01_mod", "fxanim_gp_hind_wire02_mod" );
	self thread link_parts_to_bone( self.extra_parts, "tag_body" );
}

hind_top_light_start( delay )
{
	if(IsDefined(delay))
	{
		wait(delay);
	}
	
	level notify( "hind_top_light_start" );
}

link_parts_to_bone( parts, link_tag )
{
	for(i = 0; i < parts.size; i++)
	{
		part = GetEnt(parts[i], "targetname");
		part LinkTo(self, link_tag, (0,0,0), (0,0,0));
	}
}
	
//-- Watches the health of the hind and sends out notifies to the other parts of the system
//-- TODO: This also needs to play the damage fx
hind_damage_health_watch() //-- self == player hind
{
	//self thread hind_damage_cockpit_fx();
	
	state_1_health = 1000;
	state_2_health = 2000;
	state_3_health = 3000;
	
	switch( GetDifficulty() )
	{
		case "easy": 
			state_1_health = 1500;
			state_2_health = 3000;
			state_3_health = 4500;
		break;
		
		case "hard":
			state_1_health = 670;
			state_2_health = 1340;
			state_3_health = 2000;
		break;
		
		case "fu":
			state_1_health = 500;
			state_2_health = 1000;
			state_3_health = 1500;
		break;			
	}
	
	
	self.dmg_thresholds = array( state_1_health, state_2_health, state_3_health);
	self.dmg_taken_max = state_3_health;
	self.current_damage = 0;

	self.playing_alarm_loop = false;
	self.alarm_snd_ent = Spawn( "script_origin", self.origin );
	self.alarm_snd_ent LinkTo( self );

	max_dmg_states = 3;
	
	total_dmg_taken = 0;
	current_threshold = 0;
	
	enemy_hind_rocket_damage = 100;
	enemy_hind_damage = 10;
	enemy_hip_damage = 100;
	enemy_zsu_damage = 10;
	enemy_ai_damage = 1;
	enemy_nva_patrol_damage = 3;
	
	self thread hind_damage_cockpit_fx_based_on_health();
	self thread hind_damage_cockpit_animations_based_on_health();
	
	while(IsAlive(self) || (IsDefined(level.pow_demo) && level.pow_demo))
	{
		self waittill("damage", amount, attacker);
		
		//TODO: take this out eventually
		player = get_players()[0];
		
		if( IsGodMode( player ) )
		{
			continue;
		}
		
		total_dmg_taken = self.current_damage;
		
		if(IsDefined(attacker) && IsDefined(attacker.classname) && attacker.classname == "script_vehicle")
		{
			if(attacker.vehicletype == "heli_hind" || attacker.vehicletype == "heli_hind_doublesize")
			{
				total_dmg_taken += enemy_hind_damage;
			}
			else if(attacker.vehicletype == "heli_hip")
			{
				total_dmg_taken += enemy_hip_damage;
			}
			else if(attacker.vehicletype == "tank_zsu23_low")
			{
				total_dmg_taken += enemy_zsu_damage;
			}
			else if(attacker.vehicletype == "boat_patrol_nva")
			{
				total_dmg_taken += enemy_nva_patrol_damage;
			}
		}
		else
		{
			total_dmg_taken += enemy_ai_damage;
		}
		
		//-- special stuff specifically to track enemy helicopter rockets
		if( self.last_weapon_hit == "hind_rockets_sp" || self.last_weapon_hit == "hind_rockets_2x_sp" )
		{ 
			//-- do specific rocket damage stuff		
			self.dmg_thresholds = array( state_1_health, state_2_health, state_3_health);	
			
			if(self.current_damage < self.dmg_thresholds[0])
			{
				total_dmg_taken += self.dmg_thresholds[0] - self.current_damage + 1;
			}
			else if(self.current_damage < self.dmg_thresholds[1])
			{
				total_dmg_taken += self.dmg_thresholds[1] - self.current_damage + 1;
			}
			else if(self.current_damage < self.dmg_thresholds[2])
			{
				total_dmg_taken += enemy_hind_rocket_damage;
			}
		}
		
		if( amount > 5000 ) //then this was an instant kill weapon
		{
			total_dmg_taken += amount;
		}
		
		if(total_dmg_taken > self.dmg_thresholds[current_threshold])
		{
			current_threshold++;
			if(current_threshold >= max_dmg_states || total_dmg_taken > self.dmg_taken_max) //-- 2nd check is for SAM missiles
			{
				self.current_damage = total_dmg_taken; //-- so we can make sure that the damage states update
				break;
			}

			self notify("next_dmg_state");
			self notify("next_dmg_fx");
		}
		if( !self.playing_alarm_loop && total_dmg_taken > (.76 * state_3_health) )
		{
			self.playing_alarm_loop = true;
			self.alarm_snd_ent PlayLoopSound( "veh_hind_alarm_damage_high_loop" );
		}
		
		self.current_damage = total_dmg_taken;
		self thread hind_regen_health();
	}
	
	/*
	if(IsDefined(level.pow_demo) && level.pow_demo)
	{
		return;
	}
	*/
	
	while(self maps\_hind_player::next_cockpit_damage_state()) //-- make sure we are on the last damage state
	{
		wait(0.05);
	}
	
	level thread fade_out(3.0);
	self thread player_helicopter_crashing_anims();
	player = get_players()[0];
	PlayFX(level._effect["player_explo"], player.origin);
	level thread flame_overlay();
	missionFailedWrapper();
}

flame_overlay()
{
	player = get_players()[0];
	player SetBurn(3);
}

//TODO: this is going to need a lot of tuning
hind_regen_health() // self == hind
{
	self endon("damage");
	self endon("death");
	
	wait(6); //-- wait for 3 seconds before regen starts
	
	while(1)
	{
		self.current_damage = self.current_damage - 5;
		wait(0.1);
		
		if( self.playing_alarm_loop && self.current_damage < 2000 )
		{
			self.playing_alarm_loop = false;
			self.alarm_snd_ent StopLoopSound();
		}

		if(self.current_damage < 0)
		{
			self.current_damage = 0;
			return;
		}
	}
}

hind_damage_cockpit_fx_based_on_health()
{
	/*
		self.dmg_thresholds = array( 1000, 2000, 3000);
		self.dmg_taken_max = 3000;
		self.current_damage = 0;
	*/
	
	while( self.current_damage / self.dmg_taken_max < .25 )
	{
		wait(0.05);
	}
	
	self thread hind_ramp_dmg_fx_up_and_down( "tag_fx_spark_l", self.dmg_taken_max * .25, self.dmg_taken_max * .6 );
	
	while( self.current_damage < self.dmg_taken_max * .4 )
	{
		wait(0.05);
	}
	
	self thread hind_ramp_dmg_fx_up_and_down( "tag_fx_spark_r", self.dmg_taken_max * .45, self.dmg_taken_max * .8 );

}

hind_ramp_dmg_fx_up_and_down( tag_name, spark_threshold, fire_threshold )
{
	//"panel_dmg_sm", "panel_dmg_md"
	
	self endon("death");
	while(1)
	{
		temp_model = create_temp_model_and_linkto_tag(tag_name);
		PlayFXOnTag( level._effect["panel_dmg_sm"], temp_model, "tag_origin" );
		
		while(self.current_damage < fire_threshold)
		{
			wait(0.1);
		}
		
		temp_model Delete();
		temp_model = create_temp_model_and_linkto_tag(tag_name);
		PlayFXOnTag( level._effect["panel_dmg_md"], temp_model, "tag_origin" );
		
		while(self.current_damage > spark_threshold)
		{
			wait(0.1);
		}
		
		temp_model Delete();	
	}
}

hind_damage_cockpit_animations_based_on_health()
{
	self endon("death");
	
	while( self.current_damage / self.dmg_taken_max < .4 )
	{
		wait(0.05);
	}
	
	level notify("hind_dashboard_start");
	level thread dialog_fly_dmg( 0 );
	
	while( self.current_damage / self.dmg_taken_max < .5 )
	{
		wait(0.05);
	}
	
	level notify("hind_periscope_start");
	level thread dialog_fly_dmg( 1 );
	
	while( self.current_damage / self.dmg_taken_max < .6 )
	{
		wait(0.05);
	}
	
	level notify("hind_wire01_start");
	level thread dialog_fly_dmg( 2 );
	
	while( self.current_damage / self.dmg_taken_max < .7 )
	{
		wait(0.05);
	}
	
	level notify("hind_wire02_start");	
	level thread dialog_fly_dmg( 3 );
	
	while( self.current_damage / self.dmg_taken_max < .8 )
	{
		wait(0.05);
	}
	
	level notify("hind_top_light_break_start");
}

create_temp_model_and_linkto_tag( tag_name )
{
	temp_model = Spawn("script_model", (0,0,0));
	temp_model SetModel("tag_origin");
	temp_model.origin = self GetTagOrigin(tag_name);
	temp_model.angles = self GetTagAngles(tag_name);
	temp_model LinkTo(self);
	
	return temp_model;
}

hind_reload_dialog()
{
	
}

//-- TODO: REWRITE THIS WHEN WE GET MORE DAMAGE FX THAT NEED TO PLAY THROUGHOUT THE HIND
hind_damage_spawn_and_play_dmg_fx( fx_to_play ) //-- self == enemy hind
{
	
	if(IsDefined(self.dmg_fx_ents))
	{
		for(i = 0; i < self.dmg_fx_ents.size; i++ )
		{
			self.dmg_fx_ents[i] Delete();
		}
	}
	
	self.dmg_fx_ents = [];
	
	temp_model = Spawn("script_model", (0,0,0));
	temp_model SetModel("tag_origin");
	temp_model.origin = self GetTagOrigin("tag_fx_spark_l");
	temp_model.angles = self GetTagAngles("tag_fx_spark_l");
	temp_model LinkTo(self);
	self.dmg_fx_ents[0] = temp_model;
	
	temp_model = Spawn("script_model", (0,0,0));
	temp_model SetModel("tag_origin");
	temp_model.origin = self GetTagOrigin("tag_fx_spark_r");
	temp_model.angles = self GetTagAngles("tag_fx_spark_r");
	temp_model LinkTo(self);
	self.dmg_fx_ents[1] = temp_model;
	
	for( i=0; i < self.dmg_fx_ents.size; i++ )
	{
		PlayFXOnTag( level._effect[fx_to_play], self.dmg_fx_ents[i], "tag_origin" );
	}
}


//-- waits for a notify from hind_damage_health_watch and then will swap the cockpit model
hind_damage_cockpit_swap()
{
	self endon("death");
	
	number_of_swaps = 1;
	while(1)
	{
		self waittill("next_dmg_state");
		self maps\_hind_player::next_cockpit_damage_state();
		
		switch( number_of_swaps )
		{
			case 1:
				self SetClientFlag(3);
			break;
			
			case 2:
				self ClearClientFlag(3);
				self SetClientFlag(4);
			break;
			
			case 3:
				self SetClientFlag(3);
				self SetClientFlag(4);
			break;
			
			default:
			break;
		}
	
		number_of_swaps++;
	}
}

//-- damages the player based on the damage that the hind itself has recieved
hind_damage_player() //self == player hind
{	
	level.disable_damage_overlay_in_vehicle = true; //-- gets rid of the blood fx on the screen
	level thread reset_disable_damage_overlay_on_notify( "player_out_of_copter" );
	
	self endon("death");
	level endon("player_out_of_copter");
	
	bullet_hits = 0;
		
	// hits per damage done and damage values against player
	enemy_hind_ratio = 5;
	enemy_hind_damage = 5;
	enemy_hip_ratio = 1;
	enemy_hip_damage = 5;
	enemy_zsu_ratio = 5;
	enemy_zsu_damage = 5;
	enemy_ai_ratio = 4;
	enemy_ai_damage = 5;
	enemy_nva_patrol_ratio = 10;
	enemy_nva_patrol_damage = 5;
	
	//TODO: this is temp until we figure out exactly what is going on here
	player = get_players()[0];
	player EnableInvulnerability();
	
	//demo
	
	/*
	if(IsDefined(level.pow_demo) && level.pow_demo)
	{
		return;
	}
	*/
	
	while(1)
	{
		//-- TODO: track damage types because eventually that will be important	
		self waittill("damage", dmg_amount, attacker);
		
		do_player_damage = false;
		
		if(IsDefined(attacker))
		{
			player = get_players()[0];
			
			if(attacker.classname == "script_vehicle")
			{
				bullet_hit_mod = 999999;
				vehicle_damage = 0;
				
				if(attacker.vehicletype == "heli_hind" || attacker.vehicletype == "heli_hind_doublesize")
				{
					bullet_hit_mod = enemy_hind_ratio;
					vehicle_damage = enemy_hind_damage;
				}
				if(attacker.vehicletype == "heli_hip")
				{
					bullet_hit_mod = enemy_hip_ratio;
					vehicle_damage = enemy_hip_damage;
				}
				else if(attacker.vehicletype == "tank_zsu23_low")
				{
					bullet_hit_mod = enemy_zsu_ratio;
					vehicle_damage = enemy_zsu_damage;
				}
				else if(attacker.vehicletype == "boat_patrol_nva")
				{
					bullet_hit_mod = enemy_nva_patrol_ratio;
					vehicle_damage = enemy_nva_patrol_damage;
				}
				
				if(bullet_hits % bullet_hit_mod == 0)
				{
					
					//player DoDamage( vehicle_damage, attacker.origin, self ); 
					bullet_hits = 0;
					do_player_damage = true;
				}
			}
			else if(bullet_hits % enemy_ai_ratio == 0) // - attacker is an AI
			{
				bullet_hits = 0;
				do_player_damage = true;
			}
			
			if( do_player_damage )
			{
				player DisableInvulnerability();
				player.health = player.maxHealth;
				player DoDamage( enemy_ai_damage, attacker.origin, self );
				bullet_hits = 0;
				self notify("player_damage_through_hind");
				wait(0.05);
				player EnableInvulnerability();
			}
			wait(0.05);
		}
		
		bullet_hits++;
	}
}

reset_disable_damage_overlay_on_notify( notify_msg )
{
	level waittill(notify_msg);
	level.disable_damage_overlay_in_vehicle = undefined;	
}

fade_out( time )
{
	if( !isdefined( level.fade_out_overlay ) )
	{
		level.fade_out_overlay = NewHudElem();
		level.fade_out_overlay.x = 0;
		level.fade_out_overlay.y = 0;
		level.fade_out_overlay.horzAlign = "fullscreen";
		level.fade_out_overlay.vertAlign = "fullscreen";
		level.fade_out_overlay.foreground = false;  // arcademode compatible
		level.fade_out_overlay.sort = 50;  // arcademode compatible
		level.fade_out_overlay SetShader( "black", 640, 480 );
	}

	// start off invisible
	level.fade_out_overlay.alpha = 0;

	level.fade_out_overlay fadeOverTime( time );
	level.fade_out_overlay.alpha = 1;
	wait( time );
}

create_sam_target() //self == player hind
{
	self endon("death");
	
	//-- target for the SAMs to fire at
	sam_target = Spawn("script_model", (0,0,0));
	sam_target SetModel("tag_origin");
	self.sam_target = sam_target;
	
	//-- NOTES:
	//-- hind max speed is 110mph according to the gdt
	
	//max_forward_offset = 3000;
	max_forward_offset = 0; //-- make it shoot at the hind more
	max_speed_mph = 110;
	
	while(true)
	{
		player = get_players()[0];
		//target_offset = AnglesToForward( (0, self.angles[1], self.angles[2]) ) * ( max_forward_offset * ( self GetSpeedMPH() / max_speed_mph )); //-- TODO: NEED TO MAKE THIS SCALABLE ON SPEED SOMEHOW
		//sam_target.origin = self.origin + target_offset - ( 0, 0, 124);
		sam_target.origin = player.origin;
		
		wait(0.05);
	}
}


#using_animtree ("generic_human");

barnes_model_think( lookat_target ) //-- self == the hind
{
	//barnes_clear_all_anims();
		
	if(IsDefined(lookat_target))
	{
		self thread barnes_model_headtrack_target( lookat_target );
		self thread barnes_flinch_when_hit( ::barnes_model_headtrack_target, lookat_target );
	}
	else
	{
		//-- TODO: add in normal idles here.
		self thread barnes_model_normal_mode();
	}
}

barnes_procedural_talk( msg_notify )
{
	self thread barnes_procedural_talk_clear( msg_notify );
	self endon( msg_notify );
	self endon( "death" );
	
	while(1)
	{
		random_wait = .10 + RandomFloatRange(0, 0.15);
		amplitude = .15 + RandomFloatRange( 0, 0.1 );
		level.barnes SetAnim( level.scr_anim["barnes"]["head_up"], amplitude, random_wait);
		level.barnes SetAnim( level.scr_anim["barnes"]["head_down"], 1 - amplitude, random_wait);
		wait(random_wait);
		
		random_wait = .10 + RandomFloatRange(0, 0.15);
		amplitude = .15 + RandomFloatRange( 0, 0.1 );
		level.barnes SetAnim( level.scr_anim["barnes"]["head_up"], 0, random_wait);
		level.barnes SetAnim( level.scr_anim["barnes"]["head_down"], 1 - amplitude, random_wait);
		wait(random_wait);
	}
}

barnes_procedural_talk_clear( msg_notify )
{
	self endon("death");
	self waittill( msg_notify );
	wait(0.1);
	self ClearAnim( level.scr_anim["barnes"]["head_up"], 0.25);
	self ClearAnim( level.scr_anim["barnes"]["head_down"], 0.25);
}

barnes_clear_all_anims( clear_time )
{
	if(!IsDefined(clear_time))
	{
		clear_time = 0.15;
	}
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "climb_in_and_takeoff" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "idle_in_hind" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "flinch_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "flinch_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "glance_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "glance_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "look2sit_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "look2sit_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "look_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "look_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "point_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "point_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "sit2look_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "sit2look_r" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "arm_d" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "arm_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "arm_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "arm_u" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "head_d" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "head_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "head_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "head_u" ], clear_time );
		
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "headarm_d" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "headarm_l" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "headarm_r" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "headarm_u" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "scan_left_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "scan_left_low" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "scan_right_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "scan_right_low" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "dmgcheck1" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "dmgcheck2" ], clear_time );
		
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_back" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_front_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_front_low" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_side_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_side_low" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_back" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_front_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_front_low" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_side_high" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_side_low" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_back_idle" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_back_spin" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_back_spin2idle" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_back_idle2out" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_left_tail_check" ], clear_time );
	
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_back_idle" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_back_spin" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_back_spin2idle" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_back_idle2out" ], clear_time );
	level.barnes ClearAnim( level.scr_anim[ "barnes" ][ "spot_right_tail_check" ], clear_time );
}

//-- THIS IS THE BEHAVIOR THAT IS USED WHEN JUST FLYING AROUND THE LEVEL
barnes_model_normal_mode()
{
	AssertEX(IsDefined(level.barnes), "BARNES IS NOT VALID YET - normal mode");
	
	level.barnes notify("barnes_change_behavior");
	level.barnes endon("barnes_change_behavior");
		
	//-- Setup different animation arrays that are needed for blending
	if(!IsDefined(level.barnes.pow_anims))
	{
		level.barnes.pow_anims = SpawnStruct();
	}
	
	level.barnes.pow_anims.talk_anims = [];
	level.barnes.pow_anims.talk_anims[ "right" ] = [];
	level.barnes.pow_anims.talk_anims[ "right" ][ "long" ] = level.scr_anim["barnes"]["talk_long_r"];
	level.barnes.pow_anims.talk_anims[ "right" ][ "short" ] = level.scr_anim["barnes"]["talk_short_r"];
	level.barnes.pow_anims.talk_anims[ "left" ] = [];
	level.barnes.pow_anims.talk_anims[ "left" ][ "long" ] = level.scr_anim["barnes"]["talk_long_l"];
	level.barnes.pow_anims.talk_anims[ "left" ][ "short" ] = level.scr_anim["barnes"]["talk_short_l"];
	
	level.barnes.pow_anims.fidgets = []; //-- These are one shot animations that do not get blended
	level.barnes.pow_anims.fidgets[0] = level.scr_anim["barnes"]["dmgcheck1"];
	level.barnes.pow_anims.fidgets[1] = level.scr_anim["barnes"]["dmgcheck2"];
	
	//-- Setup other vars used to trigger various systems
	fidget_time = RandomIntRange(10, 15);
	time_since_fidget = 0;
	scan_time = RandomIntRange(12, 20);
	time_since_scan = 0;
	
	if(!IsDefined(level.barnes.needs_to_talk))
	{
		level.barnes.needs_to_talk = "";
	}
	
	while(1)
	{	
		if(level.barnes.needs_to_talk != "")
		{
			length = ""; //long, short
			side = ""; //right, left
			
			if(IsSubStr(level.barnes.needs_to_talk, "long"))
			{
				length = "long";
			}
			else
			{
				length = "short";
			}
			
			if(IsSubStr(level.barnes.needs_to_talk, "right"))
			{
				side = "right";
			}
			else
			{
				side = "left";
			}
						
			level.barnes SetFlaggedAnim("talking_anim", level.barnes.pow_anims.talk_anims[side][length], 1, 0.15, 1);
			level.barnes waittill("talking_anim");
			level.barnes ClearAnim(level.barnes.pow_anims.talk_anims[side][length], 0.15);
			
			level.barnes.needs_to_talk = "";
		}
		else if( time_since_fidget > fidget_time )
		{
			fidget_time = RandomIntRange(3, 10);
			time_since_fidget = 0;
			
			anim_index = RandomInt(level.barnes.pow_anims.fidgets.size);
			
			level.barnes SetFlaggedAnim("fidget_anim", level.barnes.pow_anims.fidgets[anim_index], 1, 0.15, 1);
			level.barnes waittill("fidget_anim");
			level.barnes ClearAnim(level.barnes.pow_anims.fidgets[anim_index], 0.15);
			
			time_since_scan -= 2.9; //delay the scanning if he just fidgeted
		}
		else if( time_since_scan > scan_time )
		{
			scan_time = RandomIntRange(3,10);
			time_since_scan = 0;
			
			self barnes_model_scanning();
		}
		
		level.barnes SetAnim( level.scr_anim["barnes"]["idle_in_hind"], 1, 0.15, 1 );
		time_since_fidget += 0.15;
		time_since_scan += 0.15;
		wait(0.15);
	}
}

//-- This is for idle scanning while flying
barnes_model_scanning( style )
{
	scanning_anims = [];
	scanning_anims = array( "scan_left_low", "scan_right_low", "scan_right_high", "scan_left_high");
	
	scanning_styles = [];
	//DEMO: removed these because it looked like he was looking backwards
	scanning_styles = array( "high", "low", "high_right", "high_left"); //,"right", "left", "low_right", "low_left" );
	
	if( !IsDefined(style) )
	{
		style = array_randomize( scanning_styles )[0];
	}
	
	level.barnes.pow_anims.scanning = []; //-- These are one shot animations that do not get blended
	switch( style )
	{
		case "high":
			level.barnes.pow_anims.scanning[2] = level.scr_anim["barnes"]["scan_right_high"];
			level.barnes.pow_anims.scanning[3] = level.scr_anim["barnes"]["scan_left_high"];
		break;
		
		case "low":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_left_low"];
			level.barnes.pow_anims.scanning[1] = level.scr_anim["barnes"]["scan_right_low"];
		break;
		
		case "right":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_right_low"];
			level.barnes.pow_anims.scanning[1] = level.scr_anim["barnes"]["scan_right_high"];
		break;
		
		case "left":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_left_low"];
			level.barnes.pow_anims.scanning[1] = level.scr_anim["barnes"]["scan_left_high"];
		break;
		
		case "high_right":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_right_high"];
		break;
		
		case "high_left":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_left_high"];
		break;
		
		case "low_right":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_right_low"];
		break;
		
		case "low_left":
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_left_low"];
		break;
		
		default:
			level.barnes.pow_anims.scanning[0] = level.scr_anim["barnes"]["scan_left_low"];
			level.barnes.pow_anims.scanning[1] = level.scr_anim["barnes"]["scan_right_low"];
			level.barnes.pow_anims.scanning[2] = level.scr_anim["barnes"]["scan_right_high"];
			level.barnes.pow_anims.scanning[3] = level.scr_anim["barnes"]["scan_left_high"];
		break;
	}
	
	barnes_clear_all_anims( 1.0 );
	for(i = 0; i < scanning_anims.size; i++ )
	{
		level.barnes SetFlaggedAnim("scanning_anims", level.scr_anim["barnes"][scanning_anims[i]], 1, 1.5, .65);
		level.barnes waittill("scanning_anims");
		level.barnes ClearAnim(level.scr_anim["barnes"][scanning_anims[i]], 0.5);
	}
}

//-- Point at a vector then return to a different behavior (like normal_mode or headtrack_target)
barnes_model_point_at_target( target_position, point_style, return_behavior, func_param1 )
{
	level.barnes notify("barnes_change_behavior");
		
	//-- Setup different animation arrays that are needed for blending
	if(!IsDefined(level.barnes.pow_anims))
	{
		level.barnes.pow_anims = SpawnStruct();
	}
	
	level.barnes.pow_anims.pointat_anims = [];
	level.barnes.pow_anims.pointat_anims["right"] = [];
	level.barnes.pow_anims.pointat_anims["right"]["front"] = [];
	level.barnes.pow_anims.pointat_anims["right"]["front"]["high"] 	= level.scr_anim["barnes"]["spot_right_front_high"];
	level.barnes.pow_anims.pointat_anims["right"]["front"]["low"] 	= level.scr_anim["barnes"]["spot_right_front_low"];
	level.barnes.pow_anims.pointat_anims["right"]["side"] = [];
	level.barnes.pow_anims.pointat_anims["right"]["side"]["high"] 	= level.scr_anim["barnes"]["spot_right_side_high"];
	level.barnes.pow_anims.pointat_anims["right"]["side"]["low"] 		= level.scr_anim["barnes"]["spot_right_side_low"];
	level.barnes.pow_anims.pointat_anims["right"]["back"] 					= level.scr_anim["barnes"]["spot_right_back"];

	level.barnes.pow_anims.pointat_anims["left"] = [];
	level.barnes.pow_anims.pointat_anims["left"]["front"] = [];
	level.barnes.pow_anims.pointat_anims["left"]["front"]["high"] 	= level.scr_anim["barnes"]["spot_left_front_high"];
	level.barnes.pow_anims.pointat_anims["left"]["front"]["low"] 	= level.scr_anim["barnes"]["spot_left_front_low"];
	level.barnes.pow_anims.pointat_anims["left"]["side"] = [];
	level.barnes.pow_anims.pointat_anims["left"]["side"]["high"] 	= level.scr_anim["barnes"]["spot_left_side_high"];
	level.barnes.pow_anims.pointat_anims["left"]["side"]["low"] 		= level.scr_anim["barnes"]["spot_left_side_low"];
	level.barnes.pow_anims.pointat_anims["left"]["back"] 					= level.scr_anim["barnes"]["spot_left_back"];
	
	forward_ang = AnglesToForward(self.angles);
	right_ang = AnglesToRight(self.angles);
	up_ang = AnglesToUp(self.angles);
	
	anim_side = "";
	anim_direction = "";
	anim_height = "";
		
	target_dir = VectorNormalize( target_position - self.origin );
	
	// DSL
	if(!IsDefined(target_dir))
	{
		if(!IsDefined(func_param1))
		{
			[[return_behavior]]();
		}
		else
		{
			[[return_behavior]](func_param1); 
		}		
	}	
	
	//-- pick if its left or right
	if( VectorDot( right_ang, target_dir ) > 0 )
	{
		anim_side = "right";
	}
	else
	{
		anim_side = "left";
	}

	//-- Check front of back
	result = is_target_behind_me( forward_ang, target_dir);
	dot = result.dot;
		
	if( result.target_behind_me)
	{
		anim_direction = "back";
	}
	else
	{
		if( dot > 0.7 )
		{
			anim_direction = "front";
		}
		else
		{
			anim_direction = "side";
		}
	
		//-- pick if its high or low
		dot = VectorDot( up_ang, target_dir );
		
		if(dot > 0)
		{
			anim_height = "high";
		}
		else
		{
			anim_height = "low";
		}	
	}

	if( point_style == "casual" )
	{
		anim_play_rate = 0.6;
	}
	else
	{
		anim_play_rate = 1.0;
	}
	

	//-- Play the point at animation
	barnes_clear_all_anims();
	if(anim_direction == "back")
	{
		level.barnes SetFlaggedAnim("pointat", level.barnes.pow_anims.pointat_anims[anim_side]["back"], 1, 0.15, anim_play_rate );
	}
	else
	{
		level.barnes SetFlaggedAnim("pointat", level.barnes.pow_anims.pointat_anims[anim_side][anim_direction][anim_height], 1, 0.15, anim_play_rate );
	}
	
	level.barnes waittill("pointat");
	
	//-- free up the result struct
	result = undefined;		
	
	//-- put barnes back into another behavior
	if(!IsDefined(func_param1))
	{
		[[return_behavior]]();
	}
	else
	{
		[[return_behavior]](func_param1); 
	}
}

//-- THIS IS THE BEHAVIOR THAT IS USED WHEN FIGHTING AGAINST A HELICOPTER OR A LOT OF TARGETS
barnes_model_headtrack_target( lookat_target ) //-- the hind
{
	AssertEX(IsDefined(level.barnes), "BARNES IS NOT VALID YET - headtracking");
	
	level.barnes notify("barnes_change_behavior");
	level.barnes endon("barnes_change_behavior");
	lookat_target endon("death");
	
	//-- Setup different animation arrays that are needed for blending
	if(!IsDefined(level.barnes.pow_anims))
	{
		level.barnes.pow_anims = SpawnStruct();
	}
	
	level.barnes.pow_anims.lookback_anims = [];
	level.barnes.pow_anims.lookback_anims["right"] = [];
	level.barnes.pow_anims.lookback_anims["right"]["idle"] = level.scr_anim["barnes"]["spot_right_back_idle"];
	level.barnes.pow_anims.lookback_anims["right"]["spin"] = level.scr_anim["barnes"]["spot_right_back_spin"];
	level.barnes.pow_anims.lookback_anims["right"]["spin2idle"] = level.scr_anim["barnes"]["spot_right_back_spin2idle"];
	level.barnes.pow_anims.lookback_anims["right"]["idle2out"] = level.scr_anim["barnes"]["spot_right_back_idle2out"];
	level.barnes.pow_anims.lookback_anims["right"]["tailcheck"] = level.scr_anim["barnes"]["spot_right_tail_check"];

	level.barnes.pow_anims.lookback_anims["left"] = [];
	level.barnes.pow_anims.lookback_anims["left"]["idle"] = level.scr_anim["barnes"]["spot_left_back_idle"];
	level.barnes.pow_anims.lookback_anims["left"]["spin"] = level.scr_anim["barnes"]["spot_left_back_spin"];
	level.barnes.pow_anims.lookback_anims["left"]["spin2idle"] = level.scr_anim["barnes"]["spot_left_back_spin2idle"];
	level.barnes.pow_anims.lookback_anims["left"]["idle2out"] = level.scr_anim["barnes"]["spot_left_back_idle2out"];
	level.barnes.pow_anims.lookback_anims["left"]["tailcheck"] = level.scr_anim["barnes"]["spot_left_tail_check"];
	
	
	level.barnes ClearAnim(level.scr_anim["barnes"]["idle_in_hind"], 0.05);
	
	while(1)
	{
		forward_ang = AnglesToForward(self.angles);
		right_ang = AnglesToRight(self.angles);
		up_ang = AnglesToUp(self.angles);
		
		target_dir = VectorNormalize( lookat_target.origin - self.origin );
		
		left = 0;
		right = 0;
		
		result = is_target_behind_me( forward_ang, target_dir);
		dot = result.dot;
		target_behind_me = result.target_behind_me;
				
		//-- pick if its left or right
		if( VectorDot( right_ang, target_dir ) > 0 )
		{
			right = 1 - dot;
			left = 0;
		}
		else
		{
			left = 1 - dot;
			right = 0;
		}

		//-- pick if its up or down
		dot = VectorDot( up_ang, target_dir );
		
		if(dot > 0)
		{
			up = dot;
			down = 0;
		}
		else
		{
			down = abs(dot);
			up = 0;
		}
	
		center = 1 - up - down - left - right;
		if(center < 0)
		{
			center = 0;
		}	
			
		//-- Normal Head Tracking
		if( !target_behind_me )
		{
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_u"], up, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_d"], down, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_l"], left, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_r"], right, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["idle_in_hind"], center, 0.15, 1 );
		}
		else
		{
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_u"], 0, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_d"], 0, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_l"], 0, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["headarm_r"], 0, 0.15, 1 );
			level.barnes SetAnim(level.scr_anim["barnes"]["idle_in_hind"], 0, 0.15, 1 );
				
			//-- Loops in the backwards behavior, until the other helicopter comes out the front)		
			spot_back_anim = "";
			side = "";
			if(left > right)
			{
				spot_back_anim = "spot_left_back";
				side = "left";
			}
			else
			{
				spot_back_anim = "spot_right_back";
				side = "right";
			}
			
			level.barnes SetFlaggedAnim("backwards_anim", level.scr_anim["barnes"][spot_back_anim], 1, 0.15, 1);
			level.barnes waittill("backwards_anim");
			level.barnes ClearAnim(level.scr_anim["barnes"][spot_back_anim], 0);
			
			first_time = true;
			time_target_behind = 0;
			
			while(true)
			{
				forward_ang = AnglesToForward(self.angles);
				right_ang = AnglesToRight(self.angles);
				target_dir = VectorNormalize( lookat_target.origin - self.origin );	
				if(!is_target_behind_me( forward_ang, target_dir, true ))
				{
					break;
				}
				
				new_side = "";
				if( VectorDot( right_ang, target_dir ) > 0 )
				{
					new_side = "right";
				}
				else
				{
					new_side = "left";
				}
				
				if(side != new_side && !first_time)
				{
					random_tail_check = RandomInt(10);					
					if(random_tail_check < 7)
					{
						level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["idle"], 0.15);
						level.barnes SetFlaggedAnim("tailcheck_anim", level.barnes.pow_anims.lookback_anims[side]["tailcheck"], 1, 0.15, 1);
						level.barnes waittill("tailcheck_anim");
						level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["tailcheck"], 0.15);
					}
					
					level.barnes SetAnim(level.barnes.pow_anims.lookback_anims[side]["idle"], 0, 0.4, 1);
					level.barnes SetAnim(level.barnes.pow_anims.lookback_anims[new_side]["idle"], 1, 0.45, 1);
					side = new_side;
					wait(0.4);
					time_target_behind += 0.4;
				}
				else
				{
					if(first_time)
					{
						level.barnes SetFlaggedAnim("backwards_anim", level.barnes.pow_anims.lookback_anims[side]["spin2idle"], 1, 0.15, 1);
						level.barnes waittill("backwards_anim");
						first_time = false;
						level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["spin2idle"], 0);
					}
					level.barnes SetFlaggedAnim("backwards_anim", level.barnes.pow_anims.lookback_anims[side]["idle"], 1, 0.15, 1);
					level.barnes waittill_notify_or_timeout("backwards_anim", 0.1);
					time_target_behind += 0.1;
				}
				
				//-- if the threat has been behind the player for 5 seconds, redo the spin command
				if(time_target_behind > 5)
				{
					level.barnes SetFlaggedAnim("spin_anim", level.barnes.pow_anims.lookback_anims[side]["spin"], 1, 0.15, 1);
					level.barnes waittill("spin_anim");
					level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["spin"], 0.15);
					level.barnes SetFlaggedAnim("spin_trans_anim", level.barnes.pow_anims.lookback_anims[side]["spin2idle"], 1, 0.15, 1);
					level.barnes waittill("spin_trans_anim");
					level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["spin2idle"], 0);
					level.barnes SetFlaggedAnim("backwards_anim", level.barnes.pow_anims.lookback_anims[side]["idle"], 1, 0.15, 1);
					
					//-- reset last time since spin
					time_target_behind = 0;
				}
			}
			
			//-- Transition back to looking forward
			level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims["right"]["idle"], 0);
			level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims["left"]["idle"], 0);
			level.barnes SetFlaggedAnim("backwards_anim", level.barnes.pow_anims.lookback_anims[side]["idle2out"], 1, 0.15, 1);
			level.barnes waittill("backwards_anim");
			level.barnes ClearAnim(level.barnes.pow_anims.lookback_anims[side]["idle2out"], 0.15);
			
			if(side == "right")
			{
				level.barnes SetFlaggedAnim("trans_back", level.scr_anim["barnes"]["headarm_r"], 1, 0.15, 1 );
			}
			else
			{
				level.barnes SetFlaggedAnim("trans_back", level.scr_anim["barnes"]["headarm_l"], 1, 0.15, 1 );
			}
			
			level.barnes waittill("trans_back");
			//-- free up the result struct
			result = undefined;
			continue;
		}
		
		wait(0.05);
		
		//-- free up the result struct
		result = undefined;
	}
}

is_target_behind_me( forward_ang, target_dir, only_bool )
{
	dot = VectorDot(forward_ang, target_dir);

	if(dot < 0)
	{
		dot = 0;
		target_behind_me = true;
	}	
	else
	{
		target_behind_me = false;
	}
	
	if(IsDefined(only_bool))
	{
		return(target_behind_me);
	}
	
	result = SpawnStruct();
	result.dot = dot;
	result.target_behind_me = target_behind_me;
	
	return(result);
}


barnes_flinch_when_hit( next_behavior, param1 ) //-- self == the hind
{
	param1 endon("death"); //-- This is the lookat_target for the head tracking.  Usually a helicopter.
	
	self waittill("player_damage_through_hind");
	
	level.barnes notify("barnes_change_behavior");
	level.barnes ClearAnim( %root, 0.15 );
	
	if(RandomInt(2))
	{
		flinch_anim = "flinch_r";
	}
	else
	{
		flinch_anim = "flinch_l";
	}
	
	level.barnes SetFlaggedAnim( "flinch_anim", level.scr_anim["barnes"][flinch_anim], 1, 0.05, 1  );
	level.barnes waittill("flinch_anim");
	level.barnes ClearAnim(level.scr_anim["barnes"][flinch_anim], 0.05);	
	
	self thread barnes_flinch_when_hit( next_behavior, param1 );
	self thread [[next_behavior]](param1);
}

barnes_point_at_trig() //-- self == trig
{
	self waittill("trigger");
	lookat_point = getstruct(self.target, "targetname").origin;
	
	point_style = "combat";
	if(IsDefined(self.script_string))
	{
		point_style = self.script_string;
	}
	
	if(self.script_noteworthy == "normal")
	{
		level.hind barnes_model_point_at_target( lookat_point, point_style, ::barnes_model_normal_mode );
	}
}

start_hands_flightstick() //-- self = hind
{		
	self endon( "death" );
		
	player_hands = self.player_body;
	player_hands.animname = "player_hands";
	
	player = get_players()[0];
	
	origin_offset = ( 157, -1, -172 );
	link_loc = self.origin + origin_offset;
	player_hands LinkTo( self, "origin_animate_jnt", origin_offset, ( 0, 0, 0 ) );	
	
	self UseBy(player);
	self SetSpeedImmediate(0, 1000, 1000);
	player_hands thread hands_flightstick_animator_think( self );
	wait(0.1);
	player SetViewLockEnt( level.hind.view_lock_ent );
	player SetClientDvar( "cg_crosshairAlpha", 0.7 );
	flag_set("player_on_heli");
	
	self waittill("stop_flightstick");
	player_hands thread stop_flightstick_animator();
}

stop_flightstick_animator()
{
	self clear_flightstick_animations();
	self SetAnim(level.scr_anim["player_hands"]["flightstick_handsoff"], 0.15);
}

clear_flightstick_animations()
{
	self ClearAnim(level.scr_anim["player_hands"]["flightstick_right"], 0.15);
	self ClearAnim(level.scr_anim["player_hands"]["flightstick_left"], 0.15);
	self ClearAnim(level.scr_anim["player_hands"]["flightstick_away"], 0.15);
	self ClearAnim(level.scr_anim["player_hands"]["flightstick_towards"], 0.15);
	self ClearAnim(level.scr_anim["player_hands"]["flightstick_neutral"], 0.15);
}

hands_flightstick_animator_think( helicopter )
{
	
	player = get_players()[0];
	helicopter endon("stop_flightstick");
	
	while(1)
	{		
		player_leftstick_x = player GetNormalizedMovement()[1];
		player_leftstick_y = player GetNormalizedMovement()[0];

		self hands_flightstick_animator( player_leftstick_x, player_leftstick_y );

		wait(0.05);
	}	
}


hands_flightstick_animator( player_leftstick_x, player_leftstick_y )
{
	player_leftstick = [];
	player_leftstick[0] = player_leftstick_x;
	player_leftstick[1] = player_leftstick_y;
	
	weights = set_flightstick_weights( player_leftstick_x, player_leftstick_y );
			
	self SetAnim(level.scr_anim["player_hands"]["flightstick_right"], weights[0], 0.25, 1 );
	self SetAnim(level.scr_anim["player_hands"]["flightstick_left"], weights[1], 0.25, 1 );
	self SetAnim(level.scr_anim["player_hands"]["flightstick_away"], weights[2], 0.25, 1 );
	self SetAnim(level.scr_anim["player_hands"]["flightstick_towards"], weights[3], 0.25, 1 );
	self SetAnim(level.scr_anim["player_hands"]["flightstick_neutral"], weights[4], 0.35, 1 );
}

// Sets the blend weights for the hand flightstick anims based on joystick input.
set_flightstick_weights( player_leftstick_x, player_leftstick_y )
{	
	weights = [];
	movement_floor = 0.015;
	// Set the goal weights
	for( i = 0; i < 5; i++ )
	{
		weights[i] = 0;
	}
	
	if( player_leftstick_x < movement_floor && player_leftstick_x > (-1 * movement_floor) 
		&& player_leftstick_y < movement_floor && player_leftstick_y > (-1 * movement_floor) )
	{
		weights[4] = 1;	
		return weights;
	}	
	
	if( player_leftstick_x >= movement_floor )
	{
		weights[0] = player_leftstick_x;
		weights[1] = 0;
	}
	else
	{
		weights[0] = 0;
		weights[1] = abs(player_leftstick_x);
	}
	
	if( player_leftstick_y >= movement_floor )
	{
		weights[2] = player_leftstick_y;
		weights[3] = 0;
	}
	else
	{
		weights[2] = 0;
		weights[3] = abs(player_leftstick_y);
	}	
		
	return weights;	
}


//---------------------------------------------------------------------------------------

//-- PIPES

//---------------------------------------------------------------------------------------

pipes_init( pipe_targetname_prefix )
{
	unreasonably_high_number = 100000;
	if(!IsDefined(level.pipeline))
	{
		level.pipeline = [];
	}
	
	if(!Isdefined(level.pipeline[pipe_targetname_prefix]))
	{
		level.pipeline[pipe_targetname_prefix] = [];
	}
	
	for( i = 1; i < unreasonably_high_number; i++ )
	{
		level.pipeline[pipe_targetname_prefix][i] = GetEnt(pipe_targetname_prefix + i, "targetname");
				
		if(IsDefined(level.pipeline[pipe_targetname_prefix][i]))
		{
			//-- do pipey stuff with it
			level.pipeline[pipe_targetname_prefix][i] thread pipe_watch_for_dmg();
			level.pipeline[pipe_targetname_prefix][i].my_index = i;
			level.pipeline[pipe_targetname_prefix][i] SetCanDamage(true);
			level.pipeline[pipe_targetname_prefix][i].prefix = pipe_targetname_prefix;
		}
		else
		{
			PrintLn("There were " + i + " pieces of pipe setup.");
			break;
		}
		
		array_of_pipes_on_bridge_one = array( 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 );
		array_of_pipes_on_bridge_two = array( 68, 69, 70, 71, 72 );
		array_of_pipes_on_bridge_three = array( 99, 100, 101, 102, 103, 104, 105, 106, 107, 108 );
		
		if(pipe_targetname_prefix == "pipe_")
		{
			
			if( is_in_array( array_of_pipes_on_bridge_one, i ) )
			{
				level.pipeline[pipe_targetname_prefix][i].notify_on_explode = "pipebridge_01_start";
			}
			else if( is_in_array( array_of_pipes_on_bridge_two, i ) )
			{
				level.pipeline[pipe_targetname_prefix][i].notify_on_explode = "pipebridge_02_start";
			}
			else if( is_in_array( array_of_pipes_on_bridge_three, i ) )
			{
				level.pipeline[pipe_targetname_prefix][i].notify_on_explode = "pipebridge_03_start";
			}
			
		}
	}
}

pipe_watch_for_dmg()
{
	self endon("stop_dmg_watch_pipe");
	
	self.total_damage = 0;
	max_damage = 500;
	
	while(1)
	{
		self waittill("damage", dmg_amount, attacker, dir, point, type);
		
		if(IsDefined(attacker.targetname) && isSubStr(attacker.targetname, "pipe"))
		{
			continue;
		}
		
		if(IsDefined(attacker.script_noteworthy) && attacker.script_noteworthy == "pipe_tank_1" )
		{
			
			self pipe_explode_me( "chain", true );
			continue;
		}
		
		if(IsPlayer(attacker))
		{
			//-- These were turned into "always one hit" pipes
			self.total_damage = max_damage + 1; //DEMO: one shot pipes!
		}
		
		//-- only the player hind rockets should be doing this much damage to blow up the pipeline in 1 shot
		if(dmg_amount > 300 || self.total_damage >= max_damage)
		{
			self thread pipe_explode_me( "primary" );
			
			random_wait = RandomFloatRange(0.75, 1.15);
			wait(random_wait);
			self thread pipe_chain_nearby(self.prefix, self.my_index + 1, true);
			self thread pipe_chain_nearby(self.prefix, self.my_index - 1, true);
			break;
		}
			
		wait(0.05);
	}
}

pipe_chain_nearby( prefix, pipe_index , always_explode)
{
	if(pipe_index < 1 || pipe_index > level.pipeline[prefix].size || IsDefined(level.pipeline[prefix][pipe_index].exploded))
	{
		return;	// invalid piece of pipe
	}
	
	if(!IsDefined(always_explode))
	{
		if(IsDefined(self.script_string) && self.script_string == "always_explode")
		{
			always_explode = true;
		}
		else
		{
			always_explode = false;
		}
	}
	
	pipe = level.pipeline[prefix][pipe_index];
	
	explo_roll = RandomInt(10);
	if(explo_roll < 7 || always_explode)
	{
		pipe pipe_explode_me( "chain" );
			
		random_wait = RandomFloatRange(0.75, 1.15);
		wait(random_wait);
		pipe thread pipe_chain_nearby(pipe.prefix, pipe.my_index + 1);
		pipe thread pipe_chain_nearby(pipe.prefix, pipe.my_index - 1);
	}
}

pipe_explode_me( type, gas_tank )
{
	if(IsDefined(self.exploded))
	{
		return;
	}
	
	self.exploded = true;
			
	if(type == "primary")
	{
		//-- play proper fx
		if(!IsDefined(level.large_pipe_explo_playing))
		{
			PlayFX( level._effect["pipe_lg"], self.origin, (1,0,0), (0,0,1));
			level.large_pipe_explo_playing = true;
			level thread large_pipe_undefine_after_delay( 9 );
		}
		else
		{
			PlayFX( level._effect["pipe_md"], self.origin, (1,0,0), (0,0,1));	
			self PlaySound("evt_pipeline_explo_md");
		}
		
		//SOUND - Shawn J
		self PlaySound("evt_pipeline_explo_lg");
		PlaySoundAtPosition( "evt_fire_plume", self.origin + (0,0,750) );
		
		//-- lingering fire
		PlayFXOnTag( level._effect["pipe_fire_xlg"], self, "tag_origin");
		
		//-- switch to primary destroyed model
		self SetModel("p_jun_pipeline_d2");
	}
	else
	{
		if( IsDefined(gas_tank))
		{
			//-- Don't do anything, just swap model
		}
		else
		{
			//-- play proper fx
			if(RandomInt(2) < 1)
			{
				PlayFX( level._effect["pipe_md"], self.origin, (1,0,0), (0,0,1));
				
			//SOUND - Shawn J
			self PlaySound("evt_pipeline_explo_md");
			
			}
			else
			{
				PlayFX( level._effect["pipe_sm"], self.origin, (1,0,0), (0,0,1));
				
				//SOUND - Shawn J
				self PlaySound("evt_pipeline_explo_sm");
				
			}
			
			//-- do damage to things around me
			RadiusDamage( self.origin, 800, 500, 499, self );
		}
				
		//-- switch to 2ndary destroyed model
		self SetModel("p_jun_pipeline_d1");
		
		random_roll = RandomIntRange(-15, 15);
		random_move = RandomIntRange(-3, 3);
		self.angles += (random_roll,0,random_move);
		
		//-- lingering fire
		if(RandomIntRange(0, 10) < 5)
		{
			PlayFXOnTag( level._effect["pipe_fire_lg"], self, "tag_origin");
		}
		else
		{
			PlayFXOnTag( level._effect["pipe_fire_lg_b"], self, "tag_origin");
		}
	}
	
	self SetCanDamage(false);
	
	//-- specific for pipe bridge
	if(IsDefined(self.notify_on_explode))
	{
		level notify(self.notify_on_explode);
	}
}

large_pipe_undefine_after_delay( delay )
{
	wait(delay);
	level.large_pipe_explo_playing = undefined;
}

pipe_tank_init( targetname )
{
	level.pipe_tank_destroyed = false;
	tank = GetEnt( targetname, "script_noteworthy" );
	level.tank = tank; //-- this is used by other functions to do appropriate things
	tank waittill("broken");
	
	flag_set("vo_tank_destroyed");
	flag_set( "obj_truck_depot_complete");
	flag_set("music_truckdepotdestroyed");
		
	PlayFX( level._effect["pipe_lg"], tank.origin, (1,0,0), (0,0,1));
	PlayFX( level._effect["tank_wave"], tank.origin, (1,0,0), (0,0,1));

	//SOUND - Shawn J
	tank PlaySound("evt_pipeline_explo_tank");
		
	RadiusDamage( tank.origin, 700, 2000, 2000, tank );
	
	level thread pipe_tank_launch_trucks( tank );
	level.pipe_tank_destroyed = true;
	
	wait(0.1);
	exploder(4); //-- ambient fires that get left after the shockwave
	
	level thread maps\pow_utility::dialog_fly_extra("fuel_tank");
}

pipe_tank_launch_trucks( tank )
{
	unsorted_vehicle_array = GetEntArray("script_vehicle", "classname");
	
	vehicle_array = get_array_of_closest( tank.origin, unsorted_vehicle_array);
	max_index = vehicle_array.size;
	
	for(i = 0; i < max_index; i++)
	{
		dist = Distance(vehicle_array[i].origin, tank.origin);
		
		if( dist < 600 )
		{
			force = VectorNormalize(vehicle_array[i].origin - tank.origin) * (1000 - dist);
			vehicle_array[i] LaunchVehicle( force, (0,0,20), true, true );
		}
		
		if(max_index % 2 == 0)
		{
			wait(0.05);
		}
	}
}

zsu_basic_control( origins_targetnames, target, fire_notify, notify_count )
{
	if( self maps\_vehicle::is_corpse() )
	{
		//-- zsu is already dead so don't do anything
		return;
	}
	
	origin_array = GetEntArray(origins_targetnames, "targetname");
	AssertEX( origin_array.size > 0, "zsu does not have any origins to drive to" );
	
	self thread zsu_basic_movement( origin_array );
	self thread zsu_basic_fire( target, fire_notify, notify_count );
	
	self waittill("death");
	
	//-- Cleanup
	array_delete(origin_array);
	
}


//-- basis movement is damage based.
//    take damage and then move randomly.
zsu_basic_movement( positions ) // Self == ZSU
{
	if( self maps\_vehicle::is_corpse() )
	{
		//-- zsu is already dead so don't move
		return;
	}
	
	self thread zsu_end_move_on_death();
	self endon("death");
	
	goal_pos = RandomInt(positions.size);
	
	while(1)
	{
		self SetVehGoalPos( positions[goal_pos].origin, true, true );
				
		while(self GetSpeedMPH() > 1)
		{
			wait(0.1);
		}
				
		self waittill("damage");
		
		forw_or_back = RandomInt(2);
		
		if(forw_or_back == 0)
		{
			goal_pos--;
		}
		else
		{
			goal_pos++;
		}
		
		if(goal_pos < 0)
		{
			goal_pos = positions.size - 1;
		}
		else if( goal_pos == positions.size )
		{
			goal_pos = 0;
		}
	}
}

//-- move based on where your target is
zsu_track_target_movement( positions, target )
{
	if( self maps\_vehicle::is_corpse() )
	{
		//-- zsu is already dead so don't do anything
		return;
	}
	
	self thread zsu_end_move_on_death();
	self endon("death");
	
	while(1)
	{
		sorted_positions = get_array_of_closest( target.origin, positions );		
		self SetVehGoalPos( sorted_positions[0].origin, true, true );		
		
		self waittill_notify_or_timeout( "damage", 5 );
	}
}

zsu_end_move_on_death() //self == zsu
{
	self waittill("death");
	
	//-- if i don't clear the goal position, then the vehicle will never stop moving, which means it never actually dies
	//self SetVehGoalPos( self.origin, true, true );
	//self waittill("goal");
	if(IsDefined(self))
	{
		self ClearVehGoalPos();
		self SetSpeed(0, 10);
	}
}

zsu_basic_fire( target, fire_notify, notify_count ) //self == zsu
{
	if( self maps\_vehicle::is_corpse() )
	{
		//-- zsu is already dead so don't shoot
		return;
	}
	
	if(!IsDefined(notify_count))
	{
		notify_count = 0;
	}
	
	if( self.vehicletype == "truck_gaz63_single50" )
	{
		self thread gaz63_gunner("single50");
	}
	else if( self.vehicletype == "truck_gaz63_quad50" )
	{
		self thread gaz63_gunner("quad50");
	}
	
	self.fire_loop_sound = 0;
	
	self endon("death");	
	self notify("stop_firing");
	self endon("stop_firing");
		
	burst_fire_time = 2;
	fire_time = 0;
	
	
	self SetTurretTargetEnt( target, (0,0,-100) );
	
	while(IsDefined(self))
	{
		if(fire_time < burst_fire_time && DistanceSquared(self.origin, target.origin) < 7000*7000)
		{
			self FireWeapon();
			if (IsDefined ( self.sound_org))
			{
				self.sound_org playloopsound (self.sound_org.soundalias );
			}
			wait(0.05);
			fire_time += 0.05;
			
			if(notify_count > 0)
			{
				level notify(fire_notify);
				notify_count--;
			}
		}
		else
		{
			fire_time = 0;	
			if (IsDefined ( self.sound_org))
			{		
				self.sound_org stoploopsound();
				wait(0.05);
				if (IsDefined ( self.sound_org.flux) )
				{
					playsoundatposition (self.sound_org.flux, self.origin);
				}
			}
			
			random_wait = RandomFloatRange(1.0, 2.0);
			wait(random_wait);
		}
	}
}

tower_rpg_at_player( target )
{
	self thread delete_me_on_trigger("update_large_village_location");
	self endon("trigger");
	
	shoot_ent = GetEnt(self.target, "targetname");
	
	while(1)
	{
		MagicBullet( "rpg_pow_sp", shoot_ent.origin, target.origin, self );
		random_wait = RandomFloatRange(2.0, 5.0);
		wait(random_wait);
	}
}

delete_me_on_trigger( update_msg )
{
	self waittill("trigger");
	level notify( update_msg );
	self Delete();
}

notify_on_notify( waittll_msg , notify_msg ) //-- self is an entity, trigger or zsu
{
	self notify("only_wait_once" + waittll_msg + notify_msg );
	self endon("only_wait_once" + waittll_msg + notify_msg );
	
	self waittill(waittll_msg);
	level notify(notify_msg);
}

update_spawner_target_on_trigger( spawners )
{
	self endon("death");
	self waittill("trigger");

	for(i = 0; i < spawners.size; i++)
	{
		spawners[i].script_spawner_targets = self.script_noteworthy;
	}
	
	//-- Also update any AI with the new spawner target, if they have one defined
	ai = GetAIArray( "axis" );
	
	for(i = 0; i < ai.size; i++)
	{
		if(IsDefined(ai[i].script_spawner_targets))
		{
			ai[i] set_spawner_targets(self.script_noteworthy);
		}
	}
}

/*
average_position_ents( ent_array )
{
	AssertEX(IsDefined(ent_array), "The positional array for average_positions is not defined.");
	
	if(ent_array.size == 1)
	{
		return ent_array[0].origin;
	}
	
	pos = (0,0,0);
	
	for( i=0; i < ent_array.size; i++ )
	{
		pos += ent_array[i].origin;
	}
	
	avg_pos = pos / ent_array.size;
	
	return avg_pos;
}
*/

nva_pbr_target_player()
{
	pbr = GetEnt("nvapbr", "targetname");
	
	while(!IsDefined(level.hind))
	{
		wait(1);
	}
	
	player = get_players()[0];
	for( i=0; i < 2; i++)
	{
		pbr SetGunnerTargetEnt( player, (0,0,0), i);
	}
	
	pbr thread nva_pbr_shoot_in_range(0); // The parameter is the number of the gunner weapon
	pbr thread nva_pbr_shoot_in_range(1);
	
	positions = getstructarray( "nva_pbr_positions", "targetname");
	//pbr thread nva_pbr_basic_movement(player, positions);
	pbr thread zsu_basic_movement(positions);
}

nva_pbr_shoot_in_range( gunner_weapon )
{
	self endon("death");
	
	while(1)
	{
		
		if(Distance2D( level.hind.origin, self.origin ) < 8000) //TODO: change arbitrary attack range
		{
			player = get_players()[0];
			flak_missile = self FireGunnerWeapon(gunner_weapon);
			flak_missile thread missile_explode_at_target_height( player );
		}
		
		random_time = RandomFloatRange(2.0, 4.0);
		wait(random_time);
	}
}

missile_explode_at_target_height( target ) //self is a projectile
{
	self endon("death");
	target endon("death");
	
	explode_height_offset = RandomFloatRange(-120, 12);
	
	while( self.origin[2] < (target.origin[2] + explode_height_offset))
	{
		wait(0.05);
	}
	
	self ResetMissileDetonationTime( 0 );	
}

nva_pbr_basic_movement(target, positions) //self == nvapbr
{
	self endon("death");
	
	while(1)
	{
		sorted_positions = get_array_of_closest( target.origin, positions );		
		self SetVehGoalPos( sorted_positions[0].origin, true, true );		
		wait(10);
	}
}

rotate_helicopter_to_new_angles( struct_name, return_control, max_speed, wait_time, no_yaw ) //self - the hind
{
	direction_struct = getstruct(struct_name, "targetname");
	
	if(!isDefined(direction_struct))
	{
		direction_struct = GetEnt(struct_name, "targetname");
	}
	
	players = get_players();
	for( i=0; i < players.size; i++ )
	{
		players[i] SetClientDvar("vehHelicopterMaxSpeedVertical", 10);
	}
	
	if(IsDefined(max_speed))
	{
		//self SetVehMaxSpeed(max_speed);
		self SetSpeed(max_speed);
	}
	
	self SetYawSpeed( 30, 10, 2 ); 
	self SetVehGoalPos( direction_struct.origin, true );
	
	if(!IsDefined(no_yaw))
	{
		self SetTargetYaw( direction_struct.angles[1] );
	}
	self SetNearGoalNotifyDist( 12 );
	
	if(IsDefined(wait_time))
	{
		wait(wait_time);
	}
	else
	{
		if(IsDefined(no_yaw))
		{
			self waittill( "goal" );
		}
		else
		{
			self waittill( "goal_yaw" );
		}
	}
	
	/*
	These are the original settings for the original takeoff
	
	self SetYawSpeed( 20, 4, 4 ); 
	self SetVehGoalPos( direction_struct.origin, true );
	self SetTargetYaw( direction_struct.angles[1] );
	self SetNearGoalNotifyDist( 60 );
	self waittill( "goal_yaw" );
	*/
	
	while(!self ent_flag("took off"))
	{
		wait(0.05);	
	}
	
	if(IsDefined(return_control))
	{
		self ReturnPlayerControl();
		self SetYawSpeed( 360, 4, 4 ); 
	}
	
	self ResumeSpeed(100);
}

player_damage_helicopter_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansofDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if(eAttacker != level.hind)
	{
		return 0;
	}
	
	return iDamage;
}

drive_to_target_struct_on_notify(struct_targetname, my_notify )
{
	if(!IsDefined(my_notify))
	{
		my_notify = "drive_away";
	}
	
	self waittill(my_notify);
	self drive_to_target_struct(struct_targetname);

}

//TODO: this is because of a bug with physics vehicles
drive_to_target_struct_delay( delay, struct_targetname )
{
	self endon("death");
	
	AssertEX(IsDefined(delay), "bad scripter");
	AssertEX(delay > 0, "bad scripter");
	
	wait(delay);
		
	self drive_to_target_struct( struct_targetname );
}


drive_to_target_struct(struct_targetname)
{
	self endon("death");
	
	if(!IsDefined(struct_targetname))
	{
		AssertEx(IsDefined( self.script_string ), "Vehicle does not have a valid struct destination");
		struct_targetname = self.script_string;
	}
	
	while(1)
	{
		goal_pos = getstruct( struct_targetname , "targetname").origin;
		self SetVehGoalPos( goal_pos, true, true );
		self waittill("reached_end_node");
		
		if( Distance2D(self.origin, goal_pos) < 450 )
		{
			self notify("goal");
			return;
		}
	}
}

delayed_spawn_attack_gaz63_single_50( target, delay )
{
	self endon("death");
	self endon("stop_firing");
	
	if(IsDefined(delay) && delay > 0)
	{
		wait(delay);
	}
	
	//-- TODO: change this to a different type of fire when I figure out what behavior I want
	self thread zsu_basic_fire(target);
}

delete_on_goal()
{
    self endon("death");
    self SetNearGoalNotifyDist(450);
    self waittill_either("goal", "near_goal");
    self notify("deleted_on_goal");
    self delete();
}

cleanup_watcher()
{
	if(!IsDefined(level.pow_clean_up))
	{
		level.pow_clean_up = [];
		level.pow_clean_up["ai"] = [];
		level.pow_clean_up["vehicle"] = [];
		level.pow_clean_up["other"] = [];
	}
	
	while(1)
	{
		level waittill("level clean up");
		
		if( IsArray(level.pow_clean_up["ai"]))
		{
			level.pow_clean_up["ai"] = array_removeUndefined(level.pow_clean_up["ai"]);
			
			//-- cleanup actors
			for(i=0; i<level.pow_clean_up["ai"].size; i++)
			{
				level.pow_clean_up["ai"][i] Delete();
			}
		}
		
		if( IsArray(level.pow_clean_up["vehicle"]))
		{
			level.pow_clean_up["vehicle"] = array_removeUndefined(level.pow_clean_up["vehicle"]);
			
			//-- cleanup vehicles
			for(i = level.pow_clean_up["vehicle"].size - 1; i >= 0; i--)
			{
				level.pow_clean_up["vehicle"][i] notify("nodeath_thread");
				level.pow_clean_up["vehicle"][i] notify("stop_firing");
									
				//-- TODO: for now this will just place a script model in the same place as the current vehicle
				/*
				new_model = Spawn("script_model", level.pow_clean_up["vehicle"][i].origin);
				
				if(level.pow_clean_up["vehicle"][i] maps\_vehicle::is_corpse() && IsDefined(level.pow_clean_up["vehicle"][i].deathmodel))
				{
					new_model SetModel(level.pow_clean_up["vehicle"][i].deathmodel);
				}
				else
				{
					new_model SetModel(level.pow_clean_up["vehicle"][i].model);
				}
				
				new_model.origin = level.pow_clean_up["vehicle"][i].origin;
				new_model.angles = level.pow_clean_up["vehicle"][i].angles;
				*/

				level.pow_clean_up["vehicle"][i] Delete();
			}
			
			level.pow_clean_up["vehicle"] = array_removeUndefined(level.pow_clean_up["vehicle"]);
		}
		
		if( IsArray(level.pow_clean_up["other"]))
		{
			level.pow_clean_up["other"] = array_removeUndefined(level.pow_clean_up["other"]);
			
			//-- cleanup other
			for(i=0; i<level.pow_clean_up["other"].size; i++)
			{
				level.pow_clean_up["other"][i] Delete();
			}
		}
	}
}

cleanup_add()
{
	if(IsSubStr(self.classname, "actor"))
	{
		level.pow_clean_up["ai"][level.pow_clean_up["ai"].size] = self;
	}
	else if( self.classname == "script_vehicle" || self.classname == "script_vehicle_corpse")
	{
		level.pow_clean_up["vehicle"][level.pow_clean_up["vehicle"].size] = self;
	}
	else
	{
		level.pow_clean_up["other"][level.pow_clean_up["other"].size] = self;
	}
}

cleanup_populate_with_vehicles( index )
{
	ent_array = GetEntArray( "script_vehicle", "classname" );
	ent_array = array_combine(ent_array, GetEntArray( "script_vehicle_corpse", "classname"));
	
	clean_array = [];
	for(i = 0; i < ent_array.size; i++)
	{
		if(IsDefined(ent_array[i].script_int) && ent_array[i].script_int == index)
		{
			clean_array[clean_array.size] = ent_array[i];
		}
	}
	
	array_thread(clean_array, ::cleanup_add);
}

pow_vehicle_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName)
{
	//self = vehicle that is taking Damage
	/*
	if( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, sWeapon ) )
	{
		return;
	}
	*/
	
	//die in shot if attacker is the hind
	if( IsSubStr(self.vehicletype, "boat" ))
	{
		self.weapon_last_damage = sWeapon;
		
		if( self.vehicletype == "boat_sampan_pow" && sWeapon == "hind_rockets" )
		{
			iDamage = self.health + 10000;
		}
		
		if( self.vehicletype == "boat_sampan_pow" && IsPlayer(eAttacker))
		{
			iDamage = self.health + 10000;
		}
	}
	
	if(IsSubStr(self.vehicletype, "gaz63"))
	{
		self.last_weapon_hit = sWeapon;
		
		if(self.last_weapon_hit == "hind_rockets" )
		{
			physiced = self gaz_rocket_hit( eInflictor );
			if(physiced)
			{
				iDamage = self.health + 10000;
			}
		}
	}

	if( self.vehicletype == "heli_hip" || self.vehicletype == "heli_hind_doublesize" )
	{
		self.last_weapon_hit = sWeapon;

		if( self.last_weapon_hit == "hind_rockets" )
		{
			self PlaySound( "evt_enemy_hit" );
		}
		
		/*
		if(IsDefined(level.pow_demo) && level.pow_demo)
		{
			iDamage = iDamage * 3;
		}
		*/
	}

	if(self.vehicletype == "heli_hind_player")
	{
		self.last_weapon_hit = sWeapon;

		switch( self.last_weapon_hit )
		{
			case "hind_rockets_sp":
			case "hind_rockets_2x_sp":
			case "rpg_pow_sp":
			case "sam_pow_sp":
				self PlaySound( "evt_player_hit" );
				player = get_players()[0];
				player PlayRumbleOnEntity( "artillery_rumble" );
				Earthquake( 0.5, 1.0, self.origin, 700 );
			break;
		}
	}
			
	self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName, false);
}

gaz_rocket_hit( rocket )
{
	rocket_impact = rocket.origin;
	
	forward = AnglesToForward(self.angles);
	right = AnglesToRight(self.angles);
	up = AnglesToRight(self.angles);
	
	max_x = 500;
	max_y = 400;
	
	/*
	max_x = 300;
	max_y = 200;
	*/
	
	//-- figure out where the rocket landed in relation to the truck
	impact_pos = rocket_impact - self.origin;
	dist_in_front = VectorDot(forward, impact_pos); //-- 208 either way
	dist_to_right = VectorDot(right, impact_pos); //-- 128 either way
	
	if(abs(dist_in_front) > max_x || abs(dist_to_right) > max_y)
	{
		return false; //-- not close enough to cause this type of behavior
	}
		
	impact_orient = "";
	
	if(abs(dist_in_front) < max_x * .25)
	{
		impact_orient = "mid_";
	}
	else if(dist_in_front < 0)
	{
		impact_orient = "rear_";
	}
	else
	{
		impact_orient = "front_";
	}
	
	if( dist_to_right < 0 )
	{
		impact_orient = impact_orient + "left";
	}
	else
	{
		impact_orient = impact_orient + "right";
	}
		
	//-- get the proper force data and impact point
	impact_pt = (0,0,0);
	force = (0,0,0);
		
	switch( impact_orient )
	{
		case "mid_left":
			impact_pt = (28, -46, 50);
			force = (0, 308, 30);
		break;
		
		case "mid_right":
			impact_pt = (28, 42, 50);
			force = (0, -340, 30);
		break;
		
		case "front_left":
			impact_pt = (108, 2, 50);
			force = (-16, 132, 126);
		break;
		
		case "front_right":
			impact_pt = (108, 2, 50);
			force = (-32, -132, 126);
		break;
		
		case "rear_left":
			impact_pt = (-84, -22, 26);
			force = (56, 180, 150);
		break;
		
		case "rear_right":
			impact_pt = (-92, 18, 26);
			force = (72, -148, 150);
		break;
	}
	
	//convert the force to worldspace
	world_force = (forward * force[0]) + (right * force[1]) + (up * force[2]);
	world_force = world_force * 3;
	self LaunchVehicle( world_force, impact_pt, true, true );
	
	return true;
}

#using_animtree("vehicles");
heli_crash_think()
{
	if(self.vehicletype == "heli_hip")
	{
		flag_set("music_hipdestroyed");
	}
	
	time = 3;
	if(self.vehicletype == "heli_hind_doublesize")
	{
		time = 2;
	}
	
	new_heli = Spawn("script_model", self.origin);
	new_heli SetModel(self.model);
	new_heli.animname = "helicopter";
	new_heli.angles = self.angles;
	new_heli UseAnimTree(#animtree);
	new_heli.vehicletype = self.vehicletype;
	new_heli PlaySound( "evt_enemy_crash" );
	
	self notify("nodeath_thread");
	self Delete();
		
	new_heli thread heli_crash_basic_crash(time);
}

heli_crash_basic_crash( time )
{
	PlayFXOnTag( level._effect["prop_main"], self, "main_rotor_jnt");
	PlayFXOnTag( level._effect["prop_tail"], self, "tail_rotor_jnt");
	//PlayFXOnTag( level._effect["prop_smoke"], self, "tail_rotor_jnt");

	self HidePart("tail_rotor_jnt");
	
	//play some crashing sound CDC
	self thread heli_crash_spin_audio ();
	
	if(self.vehicletype == "heli_hip")
	{
		self thread anim_single( self, "hip_left" );
		PlayFXOnTag( level._effect["prop_smoke"], self, "origin_animate_jnt");
	}
	else if(self.vehicletype == "heli_hind" || self.vehicletype == "heli_hind_doublesize")
	{
		self thread anim_single( self, "hind_left1" );
		PlayFXOnTag( level._effect["prop_smoke_large"], self, "tag_origin" );
	}
	else
	{
		AssertEX(false, "non defined type of helicopter going through the crash script");
	}
	
	if(IsDefined(time))
	{
		wait(time);
		if(self.vehicletype == "heli_hip")
		{
			self thread heli_crash_watch_for_ground_then_explode( true, "origin_animate_jnt" );	
		}
		else
		{
			self thread heli_crash_watch_for_ground_then_explode( true );	
		}
	}
	else
	{
		if(self.vehicletype == "heli_hip")
		{
			self thread heli_crash_watch_for_ground_then_explode( undefined, "origin_animate_jnt");
		}
		else
		{
			self thread heli_crash_watch_for_ground_then_explode();
		}
	}
}

heli_crash_spin_audio()
{
	self endon("death");
	self playloopsound ( "veh_heli_crash_loop" );
}

heli_crash_pitch_random_until_death()
{
	self endon("death");
	self endon("hit_surface");
	
	first = true;
	//play some crashing sound CDC
	
	while(1)
	{
		new_pitch = RandomIntRange(-20, 20);
		new_roll = RandomIntRange(-10, 10);
		if(first)
		{
			self RotateVelocity( (new_pitch, 400,new_roll), 4, 2, 1 );
		}
		else
		{
			self RotateVelocity( (new_pitch, 400, new_roll), 4, 0, 0 );
		}
		wait(3);
		self RotateVelocity( (new_pitch * -1, 400 , new_roll), 4, 0, 0 );
		wait(3);
	}
}

heli_crash_watch_for_ground_then_explode( right_away, trace_tag )
{
	self endon("death");
	
	if(!IsDefined(right_away))
	{
		right_away = false;	
	}
	
	if(!IsDefined(trace_tag))
	{
		trace_tag = "tag_origin";
	}
	
	if(!right_away)
	{
		original_position = self GetTagOrigin( trace_tag );
		
		heli_trace = 500;
		if(self.vehicletype == "heli_hip")
		{
			heli_trace = 200;
		}
		else if(level.hinds_killed > 0)
		{
			heli_trace = 800;
		}
		
		wait(0.1);
		
		while(1)
		{
			current_position = self GetTagOrigin( trace_tag );
		
			dir_movement = VectorNormalize(original_position - current_position);
			
			//TODO: Change this look in the direction the helicopter is going
			trace_origin = self GetTagOrigin( trace_tag );
			trace_direction = AnglesToForward(dir_movement) * 5000;
			trace = BulletTrace( trace_origin, trace_origin - (0,0,5000), false, self );
			
			trace_dist_sq = Distance( trace_origin, trace["position"] );
			
			if( trace_dist_sq < 200 )
			{
				break;
			}
			
			wait(0.1);
		}
	}
	
	death_fx = "";
	if( self.vehicletype == "heli_hip" )
	{
		death_fx = level._effect["hip_dead"];
		PlayFX(death_fx, self GetTagOrigin( trace_tag ));
	}
	else if(level.hinds_killed == 0 )
	{
		level.hinds_killed++;
		death_fx = level._effect["hind_dead"];
		PlayFX(death_fx, self.origin);
	}
	else
	{
		death_fx = level._effect["hind_dead_large"];
		forward = AnglesToForward( self.angles );
		up = AnglesToUp( self.angles );
		PlayFX(death_fx, self.origin, forward, up);
	}
		
	
	
	//Play the explo CDC
	playsoundatposition( "exp_pow_heli" , self GetTagOrigin( trace_tag ) );	
	
	if(self.vehicletype == "heli_hip")
	{
		level thread dialog_fly_extra( "hip_dead" );
	}
	
	wait(0.1);
	self Delete();
	level notify("crashed");
}

vehicle_in_use_save_restored_function()
{
	//-- Original functionality borrowed from river_util
	wait_for_first_player();
		
	player = get_players()[0];
	player.invulnerable = true; // Sumeet's fix from _callbackglobal.gsc - BriefInvulnerability would disable previously
	player EnableInvulnerability();
	
	//-- Reset some of the helicopter values so that you don't get a bad checkpoint
	level.hind._rocket_pods.free_rockets = level.hind._rocket_pods.total_rockets;
	level.hind.current_damage = 0;
}

#using_animtree("generic_human");
//-- util for the jumptos
player_warpto_struct( structname )
{
	teleport_struct = getstruct( structname, "targetname");
	
	player = get_players()[0];
	player SetOrigin(teleport_struct.origin);
	player SetPlayerAngles(teleport_struct.angles);
	/#
	println("warping player complete");
	#/
}

temp_dialogue_and_logic_takeoff( anim_notify )
{
	self notify("kill_temp_dialogue");
	self endon("kill_temp_dialogue");
	
	if(!IsDefined(anim_notify))
	{
		anim_notify = "single anim";
	}
	
	while(1)
	{
		self waittill( anim_notify, msg );
		
		if(msg == "end")
		{
			continue;
		}
		
		if( self.animname == "barnes_headset" && msg == "attach_headset" )
		{
			level.barnes Attach("anim_jun_radio_headset_b", "J_Head");
			self Delete();
		}
		else if( self.animname == "barnes_headset" && msg == "detach_headset" )
		{
			if(IsDefined(level.woods))
			{
				level.woods Detach("anim_jun_radio_headset_b", "J_Head");
			}
			else
			{
				level.barnes Detach("anim_jun_radio_headset_b", "J_Head");
			}
		}
		else if(self.animname != "player_hands" && self.animname != "hind_body")
		{
			/*
			if(msg == "your_bird")
			{
				exploder(3);	
			}
			*/
	
			//add_dialogue_line( self.animname, msg );

		}
		else
		{
			if(msg == "start rotor")
			{
				//SOUND - Shawn J - start-up sound for the hind & setting snapshot
				clientnotify( "hind_on_snapshot" );
				clientnotify( "hind_first_dust" );				
				player = get_players()[0];
				player PlaySound("evt_hind_start");
				level.hind heli_toggle_rotor_fx(0); //-- turn the rotor back on, takes about 8 seconds.
				exploder(2); //-- custom 1st person dirt fx
				level notify( "tarp_crate_stack_start" );
				level.hind thread animate_hind_console();
				//level.hind ShowPart( "tag_instrument_loading", "t5_veh_helo_hind_cockpitview" );
				
				level.hind.view_lock_ent = Spawn("script_model", (0,0,0));
				level.hind.view_lock_ent SetModel("tag_origin");
				level.hind.view_lock_ent LinkTo(level.hind, "tag_origin", (5000, 0, 0), (0,0,0));
				
				//level.hind thread draw_my_barrel();
			}
			else if( msg == "takeoff" )
			{
				//TUEY Set the music state to liftoff...
				setmusicstate ("CHOPPER_FIGHT_ONE");
	
				//-- Rotate the helicopter to face the proper direction
				//level.hind thread rotate_helicopter_to_new_angles("struct_heli_takeoff_end_angles", true);
				level thread hind_top_light_start();
				level.hind thread go_path( GetVehicleNode("hind_takeoff_node", "targetname") );
				flag_set("music_takeoff");
			
				exploder(100); //-- the waterfall and clouds and some other stuff, specific to the next section
				maps\_vehicle::scripted_spawn(28); //-- the first 3 sampans
				
				while(!level.hind ent_flag("took off"))
				{
					wait(0.05);	
				}
				
				flag_wait("player_on_heli");
				wait(0.5);
				
				
				//DEMO - take this out when we turn the hud back on
				level.hind thread maps\_hind_player::minigun_sound();
				level.hind ResumeSpeed(10);
				player = get_players()[0];
				level.hind ReturnPlayerControl();
				level.hind notify("activate_hud");
				
				level thread last_little_helicopter_stuff();
				/*
				flag_wait("woods_takeoff_anim_finished");
				
				//-- Put the hind on the height mesh
				level.hind.lockheliheight = true;
				player ClearViewLockEnt();
				wait(2.0);
				level.hind thread maps\pow_hind_fly::init_hind_flight_dvars_flying();
				*/
				
			}
			else if( msg == "sndnt#vox_pow1_s03_023A_maso")
			{
				exploder(3); 	//-- the bird particle at takeoff
			}
			else if( msg == "left_trigger_prompt" )
			{
				//level.hind.tut_hud["rocket_controls"] = true;
				//level.hind maps\_hind_player::update_tutorial_hud();
				//DEMO - REMOVED
				level.hind thread maps\_hind_player::hud_rocket_create();
			}
			else if( msg == "right_trigger_prompt" )
			{
				//level.hind.tut_hud["gun_controls"] = true;
				//level.hind maps\_hind_player::update_tutorial_hud();
				//DEMO - REMOVED
				level.hind thread maps\_hind_player::hud_minigun_create();
			}
			else if( msg == "start drift rear" )
			{
				
			}
			else if( msg == "stop drift rear" )
			{
				
			}
			else if( msg == "start tilt left" )
			{
				
			}
			else if( msg == "stop tilt left" )
			{
				
			}
			else if( msg == "start spin right" )
			{
				
			}
			else if( msg == "start drift forward" )
			{
				
			}
			else if( msg == "stop drift forward" )
			{
				
			}
			else if( msg == "enable_lookaround" )
			{
				/#
				println("freelook");
				#/
				
				
				player = get_players()[0];
				player_hands = level.hind.player_body;
				player StartCameraTween(0.3);	
				player Unlink();
				player PlayerLinkToDelta( player_hands, "tag_player", 0.7, 30, 30, 40, 10, true );
				level notify( "set_flying_dof" );
				
			}
			else if( msg == "disable_lookaround" )
			{
				/#
				println("no free look");
				#/
				
				/*
				player = get_players()[0];
				player_hands = level.hind.player_body;
				player StartCameraTween(0.1);	
				player PlayerLinkToDelta( player_hands, "tag_player", 1, 5, 5, 5, 5, true );
				*/
				
			}
			else
			{
				
			}
		}
	}
}

last_little_helicopter_stuff()
{
	player = get_players()[0];
	flag_wait("woods_takeoff_anim_finished");

	wait(0.1);
			
	//-- Put the hind on the height mesh
	level.hind.lockheliheight = true;
	player ClearViewLockEnt();
	level.hind thread maps\pow_hind_fly::init_hind_flight_dvars_flying();
}

draw_my_barrel()
{
	while(1)
	{
		barrel = self GetTagOrigin( "tag_barrel" );
		
		end_org = barrel + ( AnglesToForward( self GetTagAngles("tag_barrel") ) * 5000 );
		draw_debug_line(barrel, end_org, 0.05)		;
	}
	
} 

drone_lookat_restart( ) //-- self == lookat trigger
{
	level endon("end_drone_behaviors");
	
	//-- The Lookat Trigger
	AssertEX( IsDefined(self), "Drone lookat struct not defined");
	self ent_flag_init("triggered");
	
	
	//-- The Destructible Building
	building = GetEnt( self.script_string, "script_noteworthy");
	AssertEX( IsDefined(building), "Drone building not defined" );
	building endon("broken");
	
	//-- The Drone Trigger
	drone_trig = undefined;
	triggers = GetEntArray("drone_axis", "targetname");
	for(i = 0; i < triggers.size; i++)
	{
		if(IsDefined(triggers[i].script_string) && triggers[i].script_string == self.target)
		{
			drone_trig = triggers[i];
			break;
		}
	}
	
	if(!IsDefined(drone_trig))
	{
		return;
	}
	
	
	building thread kill_drone_trig_when_building_breaks(drone_trig);
	
	while(1)
	{
		while(1)
		{
			player = get_players()[0];
			if(DistanceSquared(self.origin, player.origin) < 15000*15000)
			{
				if(player is_player_looking_at( self.origin, 0.7, false ))
				{
					break;
				}
			}
			wait(0.15);
		}
				
		self ent_flag_set("triggered");
		/#
		println("drones_triggered");	
		#/
		drone_trig UseBy(get_players()[0]);
		
		//-- wait until the player isn't looking here or it's been a long time since we had drones run out
		time_spawning = 0;
		while( time_spawning < 60 )
		{
			if( get_players()[0] is_player_looking_at( self.origin, 0.7, false ) )
			{
				rand_wait = RandomIntRange(5, 6);
			}
			else
			{
				rand_wait = RandomIntRange(5, 6);
			}
			time_spawning += rand_wait;
			wait(rand_wait);
			
			drone_trig thread maps\_drones::drone_triggers_think(); // restart the drone trigger
			drone_trig UseBy(get_players()[0]);
		}
		
		/#
		println("drones_reset");
		#/
		self ent_flag_clear("triggered");
		drone_trig notify("stop_drone_loop");
		drone_trig thread maps\_drones::drone_triggers_think(); // restart the drone trigger
	}
}


drone_lookaway_restart( start_drones_notify, stop_drones_notify )
{
	level endon("end_drone_behaviors");
	level endon( stop_drones_notify );
	
	level waittill( start_drones_notify );
	
	//-- The Lookat Struct
	AssertEX( IsDefined(self), "Drone lookat struct not defined");
	self ent_flag_init("triggered");
	
	//-- The Drone Trigger
	drone_trig = undefined;
	triggers = GetEntArray("drone_axis", "targetname");
	for(i = 0; i < triggers.size; i++)
	{
		if(IsDefined(triggers[i].script_string) && triggers[i].script_string == self.target)
		{
			drone_trig = triggers[i];
			break;
		}
	}
	
	if(!IsDefined(drone_trig))
	{
		return;
	}
	
	
	while(1)
	{
		while(1)
		{
			player = get_players()[0];
			if(DistanceSquared(self.origin, player.origin) < 15000*15000)
			{
				if(!player is_player_looking_at( self.origin, 0.6, false ))
				{
					break;
				}
			}
			wait(0.15);
		}
				
		self ent_flag_set("triggered");
		drone_trig UseBy(get_players()[0]);
		
		wait(8);
		
		self ent_flag_clear("triggered");
		drone_trig notify("stop_drone_loop");
		drone_trig thread maps\_drones::drone_triggers_think(); // restart the drone trigger
	}
}

kill_drone_trig_when_building_breaks( trig )
{
	self waittill("broken");
	
	self notify("second_village_break", self );
	trig notify("stop_drone_loop");
	trig Delete();
}


#using_animtree("generic_human");
gaz63_gunner( bed_type ) //self == vehicle
{
	if(bed_type == "single50")
	{
		org_offset = (-27, 0,-36);
		ang_offset = (0,0,0);
		gunner_anim = %crew_truck_turret_mount;
	}
	else
	{
		org_offset = (0,36,0);
		ang_offset = (0,0,0);
		gunner_anim = %crew_flak1_tag1_idle_1;
	}
	
	
	gunner = Spawn( "script_model", self.origin );
	gunner SetModel("c_vtn_vc2_fb_drone"); //-- specific drone model for POW
	
	gunner UseAnimTree(#animtree);
	gunner LinkTo(self, "tag_turret", org_offset, ang_offset);
		
	gunner SetAnim( gunner_anim, 1 );
	
	self waittill("death");
	
	gunner Unlink();
	
	if(available_ragdoll(true))
	{
		gunner add_to_ragdoll_bucket();
		//gunner StartRagdoll();
		
		if( IsDefined(self.last_weapon_hit) && self.last_weapon_hit == "hind_rockets" )
		{
			// Launch me
			gunner LaunchRagdoll((75, 75, 200), gunner.origin);
		}
	}
	
	wait(15);
	if(IsDefined(gunner))
	{
		gunner Delete();
	}
}

ragdoll_at_target( target )
{
	self add_to_ragdoll_bucket();
	//self StartRagdoll();
	
	ragdoll_direction = VectorNormalize(target.origin - self.origin);
	
	ragdoll_direction = ragdoll_direction + (RandomIntRange(-30, 30), RandomIntRange(-30,30), 0);
	ragdoll_direction = (ragdoll_direction[0], ragdoll_direction[1], 200);
	
	self LaunchRagdoll( ragdoll_direction, self.origin );
}

nva_patrol_gunners()
{
	self thread nva_patrol_gunner( "tag_gunner1", (24,0,-4), (0,0,0) );
	self thread nva_patrol_gunner( "tag_gunner2", (-18,0,-4), (0,180,0));
}

nva_patrol_gunner( tag, offset, ang_offset )
{
	gunner = Spawn( "script_model", self.origin );
	gunner SetModel("c_vtn_vc2_fb_drone"); //-- specific drone model for POW
	
	gunner UseAnimTree(#animtree);
	gunner LinkTo(self, tag, offset, ang_offset);
		
	gunner SetAnim( %crew_truck_turret_mount, 1 );
	
	self waittill("death");
	
	gunner Unlink();
	
	if(available_ragdoll(true))
	{
		gunner add_to_ragdoll_bucket();
		//gunner StartRagdoll();
		
		if( IsDefined(self.weapon_last_damage) && self.weapon_last_damage == "hind_rockets" )
		{
			// Launch me
			gunner LaunchRagdoll((75, 75, 200), gunner.origin);
		}
	}
	
	wait(15);
	if(IsDefined(gunner))
	{
		gunner Delete();
	}	
}

building_flame_drone( building_noteworthy, drone_noteworthy, msg_trigger )
{
	building = GetEnt( building_noteworthy, "script_noteworthy" );
	
	if(!IsDefined(msg_trigger))
	{
		msg_trigger = "death";
	} 
	
	while(1)
	{
		building waittill( "broken", msg );
		if(msg == msg_trigger)
		{
			break;
		}
	}
	
	trigger_use( drone_noteworthy, "script_noteworthy" );
}

//-- level scripts random idea to hopefully make it easier for the audio department
//   because they always crank the levels up to 11
music_controller()
{
	level thread stinger_controller();
	
	flag_wait("music_takeoff");
	/#
	println("music - takeoff loop");
	#/
	level thread play_stinger_on_flag("music_truckdepotdestroyed", "truck_depot");
		
	flag_wait("music_hiptakingoff");
	/#
	println("music - transition to hip fight");
	println("music - hip fight loop");
	#/
	
	flag_wait("music_hipdestroyed");
	/#
	println("music - transition to calm fly");
	println("music - calm fly loop (after hip)");
	#/
	
	flag_wait("music_sameventstarted");
	/#
	println("music - transition sam loop");
	println("music - sam loop");
	#/
	
	flag_wait("music_sameventfinished");
	/#
	println("music - transition to large village");
	println("music - large village loop");
	#/
	
	flag_wait("music_villagefinished");
	/#
	println("music - transition to calm fly");
	println("music - calm fly loop(after village)");
	#/
	
	flag_wait("music_twohinds");
	/#
	println("music - transition to 2 hind fight");
	println("music - 2 hind fight loop");
	#/
	
	flag_wait("music_twohindsdestroyed");
	/#
	println("music - transition to calm fly");
	println("music - calm fly loop (end)");
	#/
}

stinger_controller()
{
	while(1)
	{
		level waittill("stinger", which);
		
		switch(which)
		{
			case "truck_depot":

			break;
			
			default:
			break;
		}
	}
}

play_stinger_on_flag( flagname, stinger_name )
{
	flag_wait(flagname);
	level notify( "stinger", stinger_name );
}

available_ragdoll( force_remove )
{
	assert(IsDefined(level.ragdoll_bucket), "There is no ragdoll bucket to check.");
	
	max_ragdolls = 5;
	
	if(level.ragdoll_bucket.size >= max_ragdolls)
	{
		//-- too many guys, lets see if we can remove any
		num_in_bucket = clean_up_ragdoll_bucket();
		
		if(num_in_bucket < max_ragdolls)
		{
			return true; //-- freed up some ragdoll slots
		}
		else if( IsDefined(force_remove) ) //-- we have to remove one for this very important ragdoll
		{
			if(level.ragdoll_bucket[0].targetname == "drone")
			{
				self.dontdelete = undefined;
				level.ragdoll_bucket[0] maps\_drones::drone_delete();
			}
			else
			{
				level.ragdoll_bucket[0] Delete();
			}
			
			level.ragdoll_bucket = array_remove_index( level.ragdoll_bucket, 0 );
			return true;
		}
		
		return false; //-- couldn't free any ragdoll slots
	}
	
	return true; //-- there was already ragdoll slots free
}

add_to_ragdoll_bucket()
{
	if(!IsDefined(level.ragdoll_bucket))
	{
		level.ragdoll_bucket = [];
	}
	
	self.ragdoll_start_time = GetTime();
	level.ragdoll_bucket[level.ragdoll_bucket.size] = self;
	
	self StartRagdoll();
}

clean_up_ragdoll_bucket()
{
	current_time = GetTime();
	
	new_bucket = [];
	for(i=0; i<16; i++ )
	{
		if(!IsDefined(level.ragdoll_bucket[i]))
		{
			continue;
		}
		
		if(current_time - level.ragdoll_bucket[i].ragdoll_start_time < 4000 )
		{
			new_bucket[new_bucket.size] = level.ragdoll_bucket[i];
		}
		else
		{
			if( IsDefined(level.ragdoll_bucket[i].targetname) && level.ragdoll_bucket[i].targetname == "drone")
			{
				level.ragdoll_bucket[i].dontdelete = undefined;
				level.ragdoll_bucket[i] maps\_drones::drone_delete();
			}
			else
			{
				level.ragdoll_bucket[i] Delete();
			}
		}
	}
	
	level.ragdoll_bucket = new_bucket;
	return level.ragdoll_bucket.size;
}



dialog_fly_story( msg )
{
	flag_waitopen("story_dialog");
	flag_set("story_dialog");
	flag_waitopen("extra_dialog");
	flag_waitopen("reload_dialog");
	flag_waitopen("nag_dialog");
	flag_waitopen("dmg_dialog");
	
	switch(msg)
	{
		case "just_after_takeoff":
			//level.barnes pow_dialog_with_wait( "fly_kravchenko" );
			flag_set("woods_takeoff_anim_finished");
			level.barnes pow_dialog_with_wait( "eyes_on_dirt", undefined, "talk_long_line" );
			level.hind.player_body pow_dialog_with_wait( "got_you_woods" );
		break;
		
		case "bridge":
			level.barnes pow_dialog_with_wait( "sampans" );
			level.barnes pow_dialog_with_wait( "bridge", undefined, "talk_long_line" );
		break;
		
		case "depot":
			level.barnes pow_dialog_with_wait( "truck_depot", undefined, "talk_long_line" );
			level.hind.player_body pow_dialog_with_wait( "i_see_it" );
			level.barnes pow_dialog_with_wait( "zsu_rockets" );
		break;
		
		case "tank":
			if(flag("vo_tank_destroyed") || flag("obj_truck_depot_passed"))
			{
				break;	
			}
			level.barnes pow_dialog_with_wait( "fuel_silo" );
		break;
		
		
		case "depot_clear":
			if(flag("vo_bend_reached") || flag("obj_truck_depot_passed"))
			{
				break;
			}
			level.barnes pow_dialog_with_wait( "depot_clear" );
		break;
		
		case "bend":
			level.barnes pow_dialog_with_wait( "supply_station", 2.5, "talk_long_line" );
			level.barnes pow_dialog_with_wait( "mi8" );
		break;
		
		case "hip_dead":
			if(flag("vo_napalm_reached") || flag("vo_sam_reached"))
			{
				break;
			}
			//level.barnes pow_dialog_with_wait( "mi8_dead" );
		break;
		
		case "napalm":
		/*
			if(flag("vo_sam_reached"))
			{
				break;
			}
			level.barnes pow_dialog_with_wait( "napalm" );
		*/
		break;
		
		case "sam_start":
			level.hind.player_body pow_dialog_with_wait( "radar_lock" );
			level.barnes pow_dialog_with_wait( "not_good" );
			level.barnes pow_dialog_with_wait( "in_that_cave" );
		break;
		
		
		case "sam_close":
			level.barnes pow_dialog_with_wait( "clear_em_out" );
		break;
		
		case "sam_done":
			level.barnes pow_dialog_with_wait( "last_bird", undefined, "explosion_react_l_big", true, 1.0 );
			//level.barnes pow_dialog_with_wait( "last_bird", 1.5 );
			level.barnes pow_dialog_with_wait( "bridge_and_pipe" );
		break;
		
		case "ho_chi_minh":
			level.barnes pow_dialog_with_wait( "ho_chi_minh", 1.5 );
			level.barnes pow_dialog_with_wait( "ho_chi_description" );
			level thread large_village_nag_lines();
		break;
		
		case "kravchenko_ahead":
			level.barnes pow_dialog_with_wait( "kravchenko_ahead");
		break;
		
		case "radar_blip":
			level.barnes pow_dialog_with_wait( "radar_blip" );
		break;
		
		case "hind_fallback":
			level.barnes pow_dialog_with_wait( "running" );
			level.barnes pow_dialog_with_wait( "bitch_please" );
			level.hind.player_body pow_dialog_with_wait( "hell_yeah" );
		break;
		
		case "one_hind_down":
			level.hind.player_body pow_dialog_with_wait( "yeah", 1.5 );
			level.barnes pow_dialog_with_wait( "one_down" );
		break;
		
		case "both_hinds_down":
			wait(3);
			level.barnes pow_dialog_with_wait( "fuck_yeah" );
			wait(0.2);
			player = get_players()[0];
			player.animname = "player";
			player anim_single( player, "the_line" );
		break;

		case "clear_lets_fly":
			wait(4);			
			level.barnes pow_dialog_with_wait( "clear_lets_fly" );
		break;		
		
		default:
		break;
	}
	
	flag_clear("story_dialog");
}

large_village_nag_lines()
{
	level endon("obj_large_village_complete_end_threads");
	
	target_array = array("zsu", "radar", "oil_line");
	
	while(true)
	{
		wait(15);
		current_target = target_array[0];
		
		if(current_target == "zsu")
		{
			targets = GetEntArray( "village_zsus", "targetname" );
			
			if(targets.size > 0)
			{
				bridge_zsus = 0;
				for(i = 0; i < targets.size; i++ )
				{
					if(IsDefined(targets[i].script_noteworthy) && IsSubStr(targets[i].script_noteworthy, "bridge"))
					{
						bridge_zsus++;
					}
				}
				
				if(bridge_zsus > 0)
				{
					level thread dialog_fly_nag("nag_zsu2");
				}
				else
				{
					random_int = RandomInt(2);
					level thread dialog_fly_nag("nag_zsu" + random_int);
				}
			}
		}
		else if( current_target == "radar" )
		{
			if(!flag("vo_radar_destroyed"))
			{
				level thread dialog_fly_nag("nag_radar");
			}
		}
		else if( current_target == "oil_line")
		{
			level thread dialog_fly_nag("nag_oil_line");
		}
		
		//-- bump the last target down
		target_array = array_remove( target_array, current_target );
		target_array[target_array.size] = current_target;
	}
}

dialog_fly_dmg( msg )
{
	if(flag("story_dialog") || flag("extra_dialog") || flag("nag_dialog") || flag("reload_dialog"))
	{
		return false;
	}
	
	flag_set( "dmg_dialog" );
		
	switch(msg)
	{
		case 0:
			level.barnes anim_single( level.barnes, "nag_dmg_0");
		break;
		
		case 1:
			level.barnes anim_single( level.barnes, "nag_dmg_1");
		break;
		
		case 2:
			level.barnes anim_single( level.barnes, "nag_dmg_2");
		break;
		
		case 3:
			level.barnes anim_single( level.barnes, "nag_dmg_3");
		break;
		
		default:
		break;
	}
	flag_clear( "dmg_dialog" );
	return true;
}

dialog_fly_nag( msg )
{
	if(flag("story_dialog") || flag("extra_dialog") || flag("reload_dialog") || flag("dmg_dialog"))
	{
		return false;
	}
	
	flag_set( "nag_dialog" );
		
	switch(msg)
	{
		case "nag_sam0":
			level.barnes anim_single( level.barnes, "nag_sam0");
		break;
		
		case "nag_sam1":
			level.barnes anim_single( level.barnes, "nag_sam1");
		break;
		
		case "nag_sam2":
			level.barnes anim_single( level.barnes, "nag_sam2");
		break;
		
		case "nag_zsu0":
			level.barnes anim_single( level.barnes, "nag_zsu0");
		break;
		
		case "nag_zsu1":
			level.barnes anim_single( level.barnes, "nag_zsu1");
		break;
		
		case "nag_zsu2":
			level.barnes anim_single( level.barnes, "nag_zsu2");
		break;
		
		case "nag_oil_line":
			level.barnes anim_single( level.barnes, "nag_oil_line");
		break;
		
		case "nag_radar":
			level.barnes anim_single( level.barnes, "nag_radar");
		break;
		
		default:
		break;
	}
	flag_clear( "nag_dialog" );
	return true;
}

dialog_fly_reload( msg )
{
	if(flag("story_dialog") || flag("nag_dialog") || flag("dmg_dialog") || flag("extra_dialog"))
	{
		return false;
	}
		
	flag_set( "reload_dialog" );
	
	switch(msg)
	{
		case 0:
			level.barnes anim_single( level.barnes, "reload_0");
		break;
		
		case 1:
		 	level.barnes anim_single( level.barnes, "reload_1");
		break;
		
		case 2: //-- only when you are totally out of rockets
			level.barnes anim_single( level.barnes, "reload_2");
		break;
		
		default:
		break;
	}
	flag_clear( "reload_dialog" );
	return true;
}

dialog_fly_extra( msg )
{
	if(flag("story_dialog") || flag("nag_dialog") || flag("dmg_dialog") || flag("reload_dialog"))
	{
		return false; //-- if story dialog is queued or already playing then don't play the extra dialog
	}
	
	flag_set("extra_dialog");
	
	switch(msg)
	{
		case "wooden_bridge":
			level.barnes pow_dialog_with_wait( "nice_work", undefined, "explosion_react_l_head", true, 1.0 );
		break;
		
		case "fuel_tank":
			level.barnes pow_dialog_with_wait( "fuck_yeah", undefined, "explosion_react_l_big", true, 1.0 );
		break;
		
		case "hip_dead":
			level.barnes pow_dialog_with_wait( "mi8_dead", undefined, "explosion_react_r_small", true, 1.0 );
		break;
		
		case "radio_tower_dead":
			level.barnes pow_dialog_with_wait( "great_shot", undefined, "explosion_react_r_head", true, 1.0 );
		break;
		
		default:
		break;
	}
	
	flag_clear("extra_dialog");
	return true;
}

dialog_fly_russian( msg, flag_abort )
{
	
	switch(msg)
	{
		case "takeoff":
			level.hind.player_body pow_dialog_with_wait( "control_this_is", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "noted_signature", 5, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "repeat_gorky", 5, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "negative_response", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "understood_on", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "control_please", 3, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "gorky_has_moved", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "understood_over", undefined, undefined, undefined, flag_abort );
		break;
		
		case "truck_depot":
			level.hind.player_body pow_dialog_with_wait( "we_are_under", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "control_nomsky22", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "we_need_immediate", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "soldier_identify", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "ground_force", undefined, undefined, undefined, flag_abort);
		break;
		
		case "bend_village":
			level.hind.player_body pow_dialog_with_wait( "ground_force_commander", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "no_response", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "combat_authorized", undefined, undefined, undefined, flag_abort );
		break;
		
		case "sam_missile":
			level.hind.player_body pow_dialog_with_wait( "we_are_locked_on", 2, undefined, undefined);
			level.hind.player_body pow_dialog_with_wait( "say_your_prayers", undefined, undefined, undefined);
		break;
		
		case "second_village":
			level.hind.player_body pow_dialog_with_wait( "we_see_him", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "clear_this_channel", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "control_we_have", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "all_personel", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "gorky63_identify", 3, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "final_warning", 3, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "gorky63_compromised", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "where_the_hell_is_our", 5, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "man_the_quad", 3, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "stand_your_ground", 2, undefined, undefined, flag_abort );
		break;
		
		case "hind_vs_hinds":
			level endon("obj_enemy_hind_complete");
			level thread kill_all_hind_vo_when_obj_complete();
			level.hind.player_body pow_dialog_with_wait( "enemy_evaded", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "bait_him_back_to", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "hes_all_over_me", 1, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "right_here", 2, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "circle_around", 3, undefined, undefined, flag_abort );
			level.hind.player_body pow_dialog_with_wait( "i_have_him_in", undefined, undefined, undefined, flag_abort );
		break;
		
		default:
			/#
			println("invalide default case hit in pow - russian dialog");
			#/
		break;
		
	}
	
}

kill_all_hind_vo_when_obj_complete()
{
	flag_wait("obj_enemy_hind_complete");
	
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["enemy_evaded"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["bait_him_back_to"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["hes_all_over_me"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["right_here"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["circle_around"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["i_have_him_in"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["were_taking_damage"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["chernov_one_three"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["im_going_to"]);
	level.hind.player_body StopSound(level.scr_sound[ "player_hands" ]["control_this_is"]);
}

//-- using this because i'm playing dialog on script models, not AIs
pow_dialog_with_wait( scene, wait_time, animation, play_anim_first, hold_dialog_time, abort_flag )
{
	if(IsDefined(abort_flag) && flag_set(abort_flag))
	{
		return;
	}
	
	if((!IsDefined(play_anim_first) || !play_anim_first) && scene != "")
	{
		self animscripts\face::SaySpecificDialogue( "", level.scr_sound[self.animname][scene], 1.0 );
	}
	
	if(IsDefined(animation))
	{
		self thread pow_dialog_animation( animation, "done speaking" );
	}
	
	if(IsDefined(play_anim_first) && play_anim_first)
	{
		AssertEx( IsDefined( hold_dialog_time ), "hold_dialog_time not defined in pow_dialog_with_wait when playing the anim first");
		wait(hold_dialog_time);
		if(scene != "")
		{
			self animscripts\face::SaySpecificDialogue( "", level.scr_sound[self.animname][scene], 1.0 );
		}
	}
	
	if(self.animname == "barnes")
	{
		wait(0.05);
		self thread barnes_procedural_talk( "done speaking" );
	}
	
	self waittill("done speaking");
	
	if(IsDefined(wait_time))
	{
		wait(wait_time);
	}
	else
	{
		wait_random = RandomFloatRange(0.1,0.15);
		wait(wait_random);
	}
}

pow_dialog_animation( animation, talking_done_notify )
{
	if(self.animname == "barnes")
	{
			self notify("barnes_change_behavior");
			self barnes_clear_all_anims(0.15);
			self SetFlaggedAnim("talkinganim", level.scr_anim[self.animname][animation], 0.8, 0.15, 1 );
			self waittill( talking_done_notify );
			self ClearAnim( level.scr_anim[self.animname][animation], 0.25 );
			self thread barnes_model_think();
	}
}

demo_intro_screen(string1, string2, string3, string4, string5)
{
		// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
	// the briefing menu will be displayed for network co-op in synchronize_players()
	//flag_wait( "all_players_connected" );

	//-- Get rid of the redacted text
	string1 = undefined;
	string2 = undefined;
	string3 = undefined;
	string4 = undefined;
	string5 = undefined;

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;
	level.introblack SetShader( "white", 640, 480 );

	freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
	
	level.introstring = []; 
	
	//introscreen_create_line( string, type, scale, font, color )
	
	wait(1.0);
	
	//Title of level
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1, undefined, undefined, undefined, (0,0,0) ); 
	}
	
	wait(2);
	
	//City, Country, Date
	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2, undefined, undefined, undefined, (0,0,0) ); 
	}

// Fade out black
	flag_set( "starting final intro screen fadeout" );
 	exploder(9);
 	
 	wait(.1);
 	
	level.introblack FadeOverTime( 5.0 ); 
	level.introblack.alpha = 0; 
	
	wait(2);

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3, undefined, undefined, undefined, (0,0,0) ); 
	}
 	
	level notify( "finished final intro screen fadein" );
	wait( 3 ); 

	
	
	// Restore player controls part way through the fade in
	level thread freezecontrols_all( false, 0.75 ); // 0.75 delay, since the autosave does a 0.5 delay

	level._introscreen = false;

	maps\_introscreen::introscreen_fadeOutText();
	level notify( "controls_active" ); // Notify when player controls have been restored

	flag_set( "introscreen_complete" ); // Notify when complete
	wait(3);
	
	level.introblack Destroy();
}

player_seek_no_cover( alt_target, delay )
{
	
	if(IsDefined(self.target))
	{
		return;
	}
	
	if(IsDefined(delay))
	{
		wait(delay);
	}
	
	self endon("death");
	
	// ignore suppression so that this AI can charge the player
	self.ignoresuppression = 1;

	player = get_players()[0];
	
	if(IsDefined(alt_target))
	{
		while(1)
		{
			// set the goal entity
			self SetGoalEntity( player );
			self set_goalradius( 12 );
			
			while(!self CanSee( player ) && !self CanSee(alt_target))
			{
				wait(0.15);
			}
			
			self SetGoalPos(self.origin);
			self set_goalradius( 128 );
			
			while(self CanSee( player ) || self CanSee(alt_target))
			{
				wait(0.15);
			}
		}		
	}
	else
	{
		while(1)
		{
			// set the goal entity
			self SetGoalEntity( player );
			self set_goalradius( 12 );
			
			while(!self CanSee( player ))
			{
				wait(0.15);
			}
			
			self SetGoalPos(self.origin);
			self set_goalradius( 128 );
			
			while(self CanSee( player ))
			{
				wait(0.15);
			}
		}
	}
}

#using_animtree ("generic_human");
pow_meatshield_success_fail() //self == the bookie
{
	maps\_contextual_melee::add_melee_weapon("scripted", "meatshield", "scripted", "scripted", "t5_weapon_coltpython_pow");		
	
	self.animname = "_meatshield:ai";
	
	player = get_players()[0];
	
	//TUEY change the music state to ROULETTE_TIMESLOW
	setmusicstate("ROULETTE_TIMESLOW");
	
	//-- Starts the actual meatshield system
	add_meatshield_angle_limits(self, 0, 0);
	self thread pow_meatshield_notetracks( player );
	
	level._contextual_melee_hide = false;
	level._CONTEXTUAL_MELEE_LERP_TIME = 0;

	player SetClientDvar( "ammoCounterHide", "1" );
	player thread pow_meatshield_player_max_ammo();
	autosave_by_name( "pow_meatshield_start" );
	self contextual_melee( "meatshield", "scripted" );
	self notify("start_scripted_melee", player);

	level thread kill_hb_after_delay( 2.0 );

	wait(0.1);
	SetTimeScale( 0.2 );	
	anim_length = GetAnimLength( level.scr_anim["_meatshield:player"]["grab"] );
	wait(anim_length - 0.15);
	chunk = 0.8 / 20;
	for( i = 1; i < 21; i++ )
	{
		SetTimeScale( 0.2 + (chunk * i));
		wait(0.05);
	}
}

kill_hb_after_delay( delay )
{
	wait(delay);
	level thread maps\pow_amb::event_heart_beat("none");
}

pow_meatshield_player_max_ammo()
{
	level endon("player_max_ammo");
	
	while(1)
	{
		self SetWeaponAmmoClip ("cz75_meatshield_sp", WeaponMaxAmmo("cz75_meatshield_sp"));
		wait(0.05);
	}
}

pow_meatshield_notetracks( player )
{
	level endon("end_meatshield_notetracks");
	
	while(!IsDefined(player.player_hands))
	{
		wait(0.05);
	}
	
	while(1)
	{
		player.player_hands waittill("contextual_melee_anim", note);
		
		switch(note)
		{
			case "blood_fx":
				
				//-- the player isn't looking at Woods for sure right here
				// level.barnes Detach(level.barnes.headmodel);
				// level.barnes SetModel("c_usa_jungmar_barnes_pris_fb");		
				level.barnes SetModel("t5_gfl_hk416_v2_body");

				//-- play fx opposite of the gun
				if(is_mature())
				{
					PlayFXOnTag( level._effect["pow_bookie_gore"], self, "J_Spine4" );
					flash_origin = player.player_hands GetTagOrigin("tag_flash");
					flash_forward = AnglesToForward(player.player_hands GetTagAngles( "tag_flash"));
					MagicBullet( "cz75_sp", flash_origin, flash_origin + flash_forward * 100);
				}
				
			break;
			
			case "detach_pistol":
				self SetClientFlag(level.ACTOR_BLEEDING);
				player.player_hands Detach("t5_weapon_coltpython_pow", "tag_weapon");
			break;
			
			case "attach_cz75":
				player.player_hands Attach(GetWeaponModel("cz75_sp"), "tag_weapon", true);
				player.player_hands UseWeaponHideTags("cz75_sp");
			break;
			
			case "end":
				level notify("end_meatshield_notetracks");
			break;
			
			case "freeze_woods":
				level notify("freeze_everyone");
			break;
			
			case "unfreeze_woods":
				level notify("unfreeze_everyone");
			break;
			
			default:
			break;
		}
	}
}

needs_to_press_attack_button() //self == player
{
	self endon("attack_button_checked");
	
	self.pow_attack_pressed = false;
	
	screen_message_create( "^3[{+attack}]^7" );
	
	while(!self AttackButtonPressed())
	{
		wait(0.05);
	}
	
	screen_message_delete();
	self.pow_attack_pressed = true;
}
	
	
	
did_player_press_attack_button() //-- self == player
{
	self notify("attack_button_checked");
	
	screen_message_delete();
	return self.pow_attack_pressed;	
}

delete_on_notify( msg )
{
	self endon("death");
	
	level waittill( msg );
	self Delete();
}


#using_animtree ("generic_human");

player_helicopter_crashing_anims() //-- self == the player's hind
{
	//-- animate Woods crash
	level.barnes notify("barnes_change_behavior");
	level.barnes barnes_clear_all_anims( 0.15);
	level.barnes SetAnim( level.scr_anim["barnes"]["crash"], 1 );
	
	self thread player_helicopter_player_crashing_anims();
}

#using_animtree ("player");

player_helicopter_player_crashing_anims()
{
	self notify("stop_flightstick");
	self.player_body clear_flightstick_animations();
	self.player_body SetAnim( level.scr_anim["player_hands"]["crash"], 1 );
}

#using_animtree ("vehicles");

animate_hind_console() //-- self == hind
{
	self endon("death");
	level endon("player_out_of_copter");
	/*
	level.scr_anim["helicopter"][ "horizon_left" ] = %v_pow_b03_cockpit_horizon_bankleft;
	level.scr_anim["helicopter"][ "horizon_right" ] = %v_pow_b03_cockpit_horizon_bankright;
	level.scr_anim["helicopter"][ "horizon_tiltdown" ] = %v_pow_b03_cockpit_horizon_tiltdown;
	level.scr_anim["helicopter"][ "horizon_tiltup" ] = %v_pow_b03_cockpit_horizon_tiltup;
	level.scr_anim["helicopter"][ "horizon_neutral" ] = %v_pow_b03_cockpit_horizon_neutral;
	*/
	
	while(1)
	{
		current_pitch = self.angles[0];
		current_roll = self.angles[2];
		
		weights = set_horizon_weights( current_pitch, current_roll );
		
		self SetAnim(level.scr_anim["helicopter"]["horizon_left"], weights[0], 0.25, 1 );
		self SetAnim(level.scr_anim["helicopter"]["horizon_right"], weights[1], 0.25, 1 );
		self SetAnim(level.scr_anim["helicopter"]["horizon_tiltdown"], weights[2], 0.25, 1 );
		self SetAnim(level.scr_anim["helicopter"]["horizon_tiltup"], weights[3], 0.25, 1 );
		self SetAnim(level.scr_anim["helicopter"]["horizon_neutral"], 1, 0.25, 1 );
		
		wait(0.05);
	}
	
}


set_horizon_weights( pitch, roll )
{	
	weights = [];
	
	// Set the goal weights
	for( i = 0; i < 5; i++ )
	{
		weights[i] = 0;
	}
	
	if( pitch == 0 && roll == 0)
	{
		weights[4] = 1;	
		return weights;
	}	
	
	current_roll = abs(roll) / 90;
	
	if( roll > 0 )
	{
		weights[0] = current_roll;
		weights[1] = 0;
	}
	else
	{
		weights[0] = 0;
		weights[1] = current_roll;
	}
	
	current_pitch = abs(pitch) / 90;
	
	if( pitch > 0 )
	{
		weights[2] = current_pitch;
		weights[3] = 0;
	}
	else
	{
		weights[2] = 0;
		weights[3] = current_pitch;
	}	
	
	for(i=0; i<weights.size; i++)
	{
		if(weights[i] < 0)
		{
			weights[i] = 0;
		}
	}
	
	return weights;	
}

delete_target_on_trigger( trigger_name, func_pointer )
{
	trigger = trigger_wait( trigger_name );
	ents = GetEntArray( trigger.target, "targetname" );
	array_delete(ents);
	
	if(IsDefined(func_pointer))
	{
		level thread [[func_pointer]]();
	}
}

pow_empty_function()
{
	if(1)
	{
		return;
	}
}

pow_flame_achievement()
{
	flame_deaths = 0;

	while(flame_deaths < 10)
	{
		level waittill("enemy_flame_death");
		flame_deaths++;
	}

	get_players()[0] giveachievement_wrapper("SP_LVL_POW_FLAMETHROWER");
}

pow_rocket_achievement()
{
	level.player_used_minigun = false;
	get_players()[0] thread track_minigun_usage();
	
	level waittill("player_out_of_hind");
	level notify("stop_tracking_minigun");
	
	if(!level.player_used_minigun)
	{
		get_players()[0] giveachievement_wrapper("SP_LVL_POW_HIND");
	}
}

track_minigun_usage() //self == player
{
	level endon("stop_tracking_minigun");
	level endon("obj_hind_landing");
	
	while(!self AttackButtonPressed())
	{
		wait(0.05);
	}

	level.player_used_minigun = true;	
}

destroy_vehicles_disconnect_nodes()
{
	if(!IsDefined(self.target))
	{
		PrintLn("POW: bridge destroyed, but did not have a trigger targetted");
		return;
	}
	
	trigger = GetEnt(self.target, "targetname");
	
	//-- disconnect any pathnodes in this trigger
	nodes = GetAllVehicleNodes();
	for( i=0; i < nodes.size; i++ )
	{
		//if( nodes[i] IsTouching( trigger ) )
		if( DistanceSquared( flat_origin(nodes[i].origin), flat_origin(trigger.origin) ) < 500*500 )
		{
			SetVehicleNodeEnabled( nodes[i], false );
		}
	}
	
	//-- TODO:  Put in something here for all the vehicle driving to recheck their goal to see if they can still drive to it
	
	vehicles = GetEntArray("script_vehicle", "classname");
	
	for(i = 0; i < vehicles.size; i++ )
	{
		//if( vehicles[i] IsTouching( trigger ) )
		if( vehicles[i].health > 0 && DistanceSquared( flat_origin(vehicles[i].origin), flat_origin(trigger.origin) ) < 500*500 )
		{
			RadiusDamage( vehicles[i].origin, 120, vehicles[i].health + 20, vehicles[i].health + 10 );
		}
	}
}

trigger_on_goal_or_death( trig1, trig2 ) //-- self == ai, this is intended as a spawn function
{
	self waittill_any( "goal", "damage" );
	
	if(IsDefined(trig1))
	{
		trigger_use( trig1 );
	}
	
	if(IsDefined(trig2))
	{
		trigger_use( trig2 );
	}
}

clear_ignore_on_goal() //-- self == ai, this is intended as a spawn function
{
	self endon("death");
	self waittill("goal");
	
	self.ignoreall = false;
}

spawn_func_setup_death_thread()
{
	self.deathFunction = ::flame_achievement_death_function;
}

flame_achievement_death_function()
{
	if( self.damagemod != "MOD_BURNED" )
	{
		return false;
	}
	
	if( IsDefined(self.attacker) && IsPlayer(self.attacker))
	{
		level notify("enemy_flame_death");
	}
	
	return false;
}


overrideactordamage_fakefight( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	//-- this flag might be backwards
	if(!flag("fake_ai_fight")) //-- AI is fighting, but no one should die because the player isn't there
	{
		return 0;
	}
	
	return iDamage;
}

wait_player_gets_flamethrower()
{
	player = get_players()[0];
	
	while(!player HasWeapon("ak47_ft_sp"))
	{
		wait(0.05);
	}
	
	level thread flamethrower_hint();
}

flamethrower_hint()
{
	player = get_players()[0];
	
	total_time = 0;
	
	currentweapon = player GetCurrentWeapon();
	while(currentweapon == "none") //-- need to give the player time to actually switch to the weapon
	{
		currentweapon = player GetCurrentWeapon();
		wait(0.05);
	}
	
	screen_message_create(&"POW_INSTRUCT_FT");
	
	while(currentweapon == "ak47_ft_sp" && total_time < 3.0)
	{
		currentweapon = player GetCurrentWeapon();
		
		if(currentweapon == "ft_ak47_sp")
		{
			break;
		}
		
		wait(0.05);
		total_time += 0.05;
	}
	
	screen_message_delete();
}

pow_meatshield_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime)
{
	MAX_DAMAGE = 7000;
	TRANSFER_DAMAGE_THRESHOLD = 230;
	TRANSFER_EXTRA_DAMAGE_THRESHOLD = 450;

	HIGH_DAMAGE = 35;
	LOW_DAMAGE = 15;
	
	if(self._meatshield_targets.size == 1)
	{
		HIGH_DAMAGE = 60;
		LOW_DAMAGE = 30;
	}

	if (!IsDefined(self._meatshield.damage_taken))
	{
		self._meatshield.damage_taken = 0;
	}
	
	if (!IsDefined(self._meatshield.bullets_taken))
	{
		self._meatshield.bullets_taken = 0;
	}

	if (!IsPlayer(eAttacker))
	{
		self._meatshield.bullets_taken++;
		self._meatshield.damage_taken += iDamage;
	
		if(self._meatshield.damage_taken > TRANSFER_DAMAGE_THRESHOLD)
		{	
			
			player = get_players()[0];
			
			if(self._meatshield.bullets_taken % 4 == 0)
			{
				if(self._meatshield.damage_taken > TRANSFER_EXTRA_DAMAGE_THRESHOLD)
				{
					player DoDamage(HIGH_DAMAGE, vPoint);
				}
				else
				{
					player DoDamage(LOW_DAMAGE, vPoint);
				}
			}
		}
	}

	level.meatshield_damage_take = self._meatshield.damage_taken;

	if (!is_true(self._meatshield.dead))
	{
		if ((self._meatshield.damage_taken > MAX_DAMAGE) || (self._meatshield.time_left < level._meatshield_timer / 1.3))
		{
			self._meatshield notify("_meatshield:death");
			self._meatshield.dead = true;
			clientnotify( "msd" );  //Notifying client of MeatShield Death

			if( is_mature() )
			{
				self SetClientFlag(level.CLIENT_ENABLE_EAR_BLOOD);
			}
			//self thread blood_wetness(); //this is now done via clientscript
		}
	}

	if(self._meatshield ent_flag("meatshield_active"))
	{
		maps\_meatshield::fake_bullets(); // wait for fake bullets before taking more damage
	}
	//self._meatshield blood_hud(self._meatshield.damage_taken / 2 / MAX_DAMAGE);

	return 0;
}

pow_turn_truck_into_model()
{
	level endon("cleanup_first_half");
	self endon("deleted_on_goal");
	
	while(!IsDefined(self.isacorpse) || !self.isacorpse)
	{
		wait(1.0);
	}
	
	previous_pos = self.origin;
		
	while(1) //-- wait for it to stop moving
	{
		wait(1);
		if( Length(previous_pos - self.origin) < 24 )
		{
			break;
		}
		else
		{
			previous_pos = self.origin;
		}
	}
	
	vehicletype = self.vehicletype;
	angles = self.angles;
	origin = self.origin;
	bed_dead = "t5_veh_gaz66_flatbed_dead_low";
	
	new_truck = Spawn("script_model", origin);
	
	if(self.isacorpse)
	{
		new_truck SetModel("t5_veh_truck_gaz63_dead_low");
	}
	
	new_truck.angles = angles;
			
	switch(vehicletype)
	{
		case "truck_gaz63_canvas_low":
			new_truck Attach( bed_dead, "tag_origin_animate_jnt" );
			new_truck Attach( "t5_veh_gaz66_canvas_dead_low", "tag_origin_animate_jnt" );
		break;
		
		case "truck_gaz63_flatbed_low":
			new_truck Attach( bed_dead, "tag_origin_animate_jnt" );
		break;
		
		case "truck_gaz63_tanker_low":
			new_truck Attach( "t5_veh_gaz66_tanker_dead_low", "tag_origin_animate_jnt" );
		break;
		
		case "truck_gaz63_troops_low":
			new_truck Attach( "t5_veh_gaz66_troops_dead_low", "tag_origin_animate_jnt" );
		break;
		
		case "truck_gaz63_quad50_low":
			new_truck Attach("t5_veh_gaz66_quad50_dead_low");
		break;
		
		case "truck_gaz63_single50_low":
			new_truck Attach("t5_veh_gaz66_single50_dead_low");
		break;
		
		default:
		break;
	}
	
	self Delete();
}

show_friendly_names( on )
{
	player = self;
	
	if(!IsPlayer(player))
	{
		player = get_players()[0];
	}
	
	player SetClientDvar("cg_drawFriendlyNames", on);
} 