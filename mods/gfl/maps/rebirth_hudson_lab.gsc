/*
	Rebirth: Hudson Lab Event - 
		
	Player works up to the lab, battles outside, and then enters, looking for Steiner.
*/

#include maps\_utility;
#include common_scripts\utility; 
#include maps\_vehicle;
#include maps\rebirth_anim;
#include maps\_rusher;
#include maps\_anim;
#include maps\rebirth_utility;
#include maps\_music;
#include maps\_civilians;
#include maps\_civilians_anim;


/*------------------------------------------------------------------------------------------------------------
																								Event:  Hudson Lab
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Main event thread.  Controls the flow of the event.  
// Waits for the proper flag to be set to move on.
event_hudson_lab() 
{		
	level thread hudson_lab_objectives();
	
	lab_entrance_setup();
	
	// event functions
	level thread lab_exterior();
	level thread stop_gas_exploders();
	level thread gas_mask_off();
	level thread enemy_spawn();
	level thread enemy_wait_to_be_killed();
	level thread delete_color_entrance();
	level thread lab_interior();
	level thread pass_through_clean_room();
	level thread stair_combat();
	
	flag_wait( "event_lab_entrance_done" );
}

lab_entrance_setup()
{
	// Turn this trigger off, so it will not spawn extra redshirts during the normal playthrough
	spawn_redshirts = GetEnt("spawn_redshirts", "targetname");
	spawn_redshirts trigger_off();
	
	//move_down_hill = GetEnt("move_down_hill", "targetname");
	//move_down_hill trigger_off();
	
	// Turning all allies from the previous section to have the right settings
	hudson_btr_hero = get_ai_array("hudson_btr_hero", "script_noteworthy");
	weaver_btr_guys = get_ai_array("weaver_btr_guys", "script_noteworthy");
	hudson_lab_redshirts = array_merge(hudson_btr_hero, weaver_btr_guys);
	
	for(i = 0; i < hudson_lab_redshirts.size; i++)
	{
		//hudson_btr_hero[i] set_force_color("g");
		//hudson_lab_redshirts[i] stop_magic_bullet_shield();
		hudson_lab_redshirts[i] unmake_hero();
	}
	
	/*
	weaver_btr_guys = get_ai_array("weaver_btr_guys", "script_noteworthy");
	for(i = 0; i < weaver_btr_guys.size; i++)
	{
		weaver_btr_guys[i] stop_magic_bullet_shield();
	}
	*/
	
	trigger_use( "weaver_section_4_start" );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	trigger_use( "obj_section_4_start" );
	
	spawn_crashed_heli();
	
	// gas on top of the hill
	//exploder(460);
	
	// fire for the crashed helicopter
	exploder(470);
	
	// fog
	//exploder(10);
	exploder(15);
	
	//fueltanks = GetEntArray( "e4_fueltank", "targetname" );
	//array_thread( fueltanks, maps\rebirth_btr_rail::fueltank_blowup );
	
	clean_up_from_mason_lab();
	
	//debug_triggers();
	
	level.rpg_guy_left_shot = false;
	level.rpg_guy_right_shot = false;
	
	// spawn rpg guys if they are not dead from section 1
	trigger_use( "spawn_roof_guys" );
}

debug_triggers()
{
	trigs = GetEntArray( "trigger_radius", "classname");
	trig_brush = GetEntArray( "trigger_multiple", "classname" );
	array_merge( trigs, trig_brush );
	array_thread( trigs, ::print_targetname_when_triggered );
}

print_targetname_when_triggered()
{
	self waittill("trigger");
	if(IsDefined(self.targetname))
	{
		IPrintLn("Trigger triggered: " + self.targetname );
	}
	else
	{
		IPrintLn("Trigger triggered: undefined" );
	}
}

things_for_fx()
{
	fx_crashed_heli = GetEnt("fx_crashed_heli", "targetname");
	fx_crashed_heli Delete();
}

spawn_crashed_heli()
{
	crashed_heli = getstructarray( "crashed_heli", "targetname" );
	for(i = 0; i < crashed_heli.size; i++ )
	{
		crashed_heli[i].veh = Spawn( "script_model", crashed_heli[i].origin );
		crashed_heli[i].veh.angles = crashed_heli[i].angles;
		crashed_heli[i].veh SetModel( crashed_heli[i].script_string );
	}
}

delete_crashed_heli()
{
	crashed_heli = getstructarray( "crashed_heli", "targetname" );
	for(i = 0; i < crashed_heli.size; i++ )
	{
		crashed_heli[i].veh Delete();
	}
}

clean_up_from_mason_lab()
{
	if( IsDefined( level.heroes[ "reznov" ] ) )
	{
		level.heroes[ "reznov" ] Delete();
	}
	
	steiner = get_ai("mason_steiner", "script_noteworthy");
	if( IsDefined(steiner) )
	{
		steiner Delete();
	}
	
	hudson = get_ai( "mason_hudson", "script_noteworthy" );
	if( IsDefined(hudson) )
	{
		hudson Delete();
	}
	
	if( IsDefined(level.radio) )
	{
		level.radio Delete();
	}
	
	if( IsDefined(level.mason_lab_chair) )
	{
		level.mason_lab_chair Delete();
	}
}

//------------------------------------
// Lab event while player is outside the lab
lab_exterior()
{	
	level endon("event_lab_entrance_done");
	
	weaver_is_defined = false;
	while(!weaver_is_defined)
	{
		if( IsDefined( level.heroes[ "weaver" ] ) )
		{
			weaver_is_defined = true;
		}
		
		wait(1.0);
	}
	
	weaver = level.heroes["weaver"];
	player = get_players()[0];
	
	player thread player_is_camping();
	
	level.revive_player = true;
	player thread revive_from_rpg_attacks();
	
	weaver set_ignoreall(true);
	
	// "almost_at" VO
	weaver anim_single( weaver, "almost_at" );
	
	// "all right" VO
	trigger_wait("vo_hudson_lab_start");
	weaver anim_single( weaver, "all_right" );
	
	// "move out" VO
	player anim_single( player, "move_out" );
	
	// spawn rpg guys if they are not dead from section 1
	//trigger_use( "spawn_roof_guys" );
	
	maps\rebirth_gas_attack::clean_up_gas_attack();
	SetAILimit(19);
	
	flag_wait("rpg_trigger_0_hit");// on rpg_trigger_0 in radiant
	
	// "weapons free" VO
	weaver set_ignoreall(false);
	weaver anim_single( weaver, "weapons_free" );
	
	//TUEY Set music state to WEAPONS_FREE
	setmusicstate ("WEAPONS_FREE");
	
	// "flank left" VO
	trigger_wait("sm_lab_ext_2");
	weaver anim_single( weaver, "flank_left" );
	flag_set("stop_rpg_hack");
	
	//level.revive_player = false;
	//level notify("revive_done");
	
	trigger_wait("sm_lab_ext_2_extra");
	player.overridePlayerDamage = undefined;
	
	/*
	rpg_guy = get_ai( "roof_patroller3", "script_noteworthy" );
	if( IsDefined(rpg_guy) )
	{
		rpg_guy.script_accuracy = 1;
	}
	
	rpg_guy = get_ai( "roof_patroller4", "script_noteworthy" );
	if( IsDefined(rpg_guy) )
	{
		rpg_guy.script_accuracy = 1;
	}
	*/
}

player_is_camping()
{
	self endon("death");
	
	trigger_wait("sm_lab_ext_2");
	
	enemy_hunting_player = false;
	player_origin_previous = self.origin;
	while( true )
	{
		wait(10.0);
		
		player_origin_current = self.origin;
		player_previous_min_x = player_origin_previous + (-64, 0, 0);
		player_previous_max_x = player_origin_previous + (64, 0, 0);
		player_previous_min_y = player_origin_previous + (0, -64, 0);
		player_previous_max_y = player_origin_previous + (0, 64, 0);
		player_previous_min_z = player_origin_previous + (0, 0, -64);
		player_previous_max_z = player_origin_previous + (0, 0, 64);
		
		if( (player_origin_current[0] > player_previous_min_x[0]) && (player_origin_current[0] < player_previous_max_x[0])
		 && (player_origin_current[1] > player_previous_min_y[1]) && (player_origin_current[1] < player_previous_max_y[1])
		 && (player_origin_current[2]> player_previous_min_z[2]) && (player_origin_current[2] < player_previous_max_z[2]) )
		{
			if(enemy_hunting_player == false)
			{
				enemy_ais = get_ai_array("enemy_before_clean_room", "script_noteworthy");
				if(enemy_ais.size > 0)
				{
					random_int = RandomIntRange(0, enemy_ais.size);
					enemy_ais[random_int] hunt_down_player();
					//enemy_hunting_player = true;
				}
			}
		}
		
		player_origin_previous = player_origin_current;
	}
}

hunt_down_player()
{
	self maps\_rusher::rush();
	
	self waittill("death");
}

stop_gas_exploders()
{
	trigger_wait("take_off_mask");
	stop_exploder(370);
	stop_exploder(440);
	stop_exploder(450);
	//maps\rebirth_gas_attack::clean_up_gas_attack();
	//SetAILimit(19);
}

//------------------------------------
// Everyone takes off their masks
gas_mask_off()
{
	level endon("event_lab_entrance_done");
	
	trigger_wait("take_off_mask");
	player = get_players()[0];
	
	player thread maps\rebirth_gas_attack::gas_mask_weapon_lower();
	
	hudson_btr_hero = get_ai_array("hudson_btr_hero", "script_noteworthy");
	weaver_btr_guys = get_ai_array("weaver_btr_guys", "script_noteworthy");
	previous_redshirts = array_merge(hudson_btr_hero, weaver_btr_guys);
	for(i = 0; i < previous_redshirts.size; i++)
	{
		previous_redshirts[i] thread detach_mask();
		previous_redshirts[i].script_noteworthy = "hudson_lab_redshirts";
	}
}

//------------------------------------
// Spawn enemies at certain places
enemy_spawn()
{
	level endon("event_lab_entrance_done");
	
	// Spawn 2 enemies in the beginning on the right
	//flag_wait("sm_lab_ext_0_hit");
	
	//enemy_lab_ext_0 = GetEntArray("enemy_lab_ext_0", "targetname");
	/*
	enemy_lab_ext_0 = GetEnt("enemy_lab_ext_0", "targetname");
	enemy_lab_ext_0_ai = [];
	
	for(i = 0; i < 2; i++)
	{
		enemy_lab_ext_0_ai[i] = enemy_lab_ext_0 StalingradSpawn();
		enemy_lab_ext_0_ai[i].script_forcegoal = true;
		enemy_lab_ext_0_ai[i].sprint = true;
	}
	*/
	
	trigger_wait("sm_lab_ext_3_right_b");
	
	level notify("stop_left_window_drones");
	
	scientists = GetEntArray("scientist_lab_hudson", "targetname");
	scientist_ai = [];
	for(i = 0; i < scientists.size; i++)
	{
		//scientist_ai[i] = scientists[i] StalingradSpawn();
	}
}

//------------------------------------
// Delete entities before the cleaning room
clean_up_before_cleaning_room()
{
	level endon("clean_up_before_done");
	
	weaver_must_kill = GetEntArray( "weaver_must_kill", "script_noteworthy" );
	enemy_before_clean_room = GetEntArray( "enemy_before_clean_room", "script_noteworthy" );
	before_clean_room_ents = GetEntArray( "before_clean_room", "script_noteworthy" );
	
	extra_ents = [];
	num_ents = 0;
	test_undefined = GetEnt( "roof_patroller3", "script_noteworthy" );
	if( IsDefined(test_undefined) )
	{
		extra_ents[num_ents] = test_undefined;
		num_ents++;
	}
	test_undefined = GetEnt( "roof_patroller4", "script_noteworthy" );
	if( IsDefined(test_undefined) )
	{
		extra_ents[num_ents] = test_undefined;
		num_ents++;
	}
	test_undefined = GetEnt( "entrance_color_0", "script_noteworthy" );
	if( IsDefined(test_undefined) )
	{
		extra_ents[num_ents] = test_undefined;
		num_ents++;
	}
	test_undefined = GetEnt( "entrance_color_1", "script_noteworthy" );
	if( IsDefined(test_undefined) )
	{
		extra_ents[num_ents] = test_undefined;
		num_ents++;
	}

	before_clean_room_ents = array_merge(before_clean_room_ents, weaver_must_kill);
	before_clean_room_ents = array_merge(before_clean_room_ents, enemy_before_clean_room);
	before_clean_room_ents = array_merge(before_clean_room_ents, extra_ents);
	
	for( i = 0; i < before_clean_room_ents.size; i++)
	{
		before_clean_room_ents[i] Delete();
	}
	
	/*
	if( IsDefined( level.heroes[ "reznov" ] ) )
	{
		level.heroes[ "reznov" ] Delete();
	}
	
	steiner = get_ai("mason_steiner", "script_noteworthy");
	if( IsDefined(steiner) )
	{
		steiner Delete();
	}
	
	hudson = get_ai( "mason_hudson", "script_noteworthy" );
	if( IsDefined(hudson) )
	{
		hudson Delete();
	}
	
	if( IsDefined(level.radio) )
	{
		level.radio Delete();
	}
	
	if( IsDefined(level.mason_lab_chair) )
	{
		level.mason_lab_chair Delete();
	}
	*/
	
	level notify("clean_up_before_done");
}

//------------------------------------
// Delete entities after the cleaning room
clean_up_after_cleaning_room()
{
	level endon("clean_up_after_done");
	
	// Kill the color chain for the color manager
	maps\_colors::kill_color_replacements();

	// Delete the allies
	hudson_lab_redshirts = get_ai_array("hudson_lab_redshirts", "script_noteworthy");
	for(i = 0; i < hudson_lab_redshirts.size; i++)
	{
		hudson_lab_redshirts[i] Delete();
	}
	
	enemy_stairs = get_ai_array("enemy_stairs", "targetname");
	for(i = 0; i < enemy_stairs.size; i++)
	{
		enemy_stairs[i] Delete();
	}
	
	hudson_lab_redshirts = GetEntArray( "hudson_lab_redshirts", "script_noteworthy" );
	enemy_stairs = GetEntArray( "enemy_stairs", "targetname" );
	after_clean_room_ents = GetEntArray( "after_clean_room", "script_noteworthy" );
	
	extra_ents = [];
	extra_ents[0] = GetEnt("breadcrumb_clean_room", "script_noteworthy");
	
	after_clean_room_ents = array_merge(after_clean_room_ents, hudson_lab_redshirts);
	after_clean_room_ents = array_merge(after_clean_room_ents, enemy_stairs);
	after_clean_room_ents = array_merge(after_clean_room_ents, extra_ents);
	
	for( i = 0; i < after_clean_room_ents.size; i++)
	{
		after_clean_room_ents[i] Delete();
	}
	
	level notify("clean_up_after_done");
}

//------------------------------------
// Lab event while player is inside the lab
lab_interior()
{
	level endon("event_lab_entrance_done");
	
	//trigger_wait( "trig_at_lab" );
	trigger_wait("sm_lab_in_back");
	
	level thread delete_color_triggers();
	//level thread enemy_wait_to_be_killed();
	//level thread corpse_memory_place_models(); // Place models of dead bodies where an AI died in Section 2
	
	weaver = level.heroes[ "weaver" ];
	player = get_players()[0];
	
	// "in_here" VO
	weaver anim_single( weaver, "in_here" );
	
	// "this_way" VO
	trigger_wait("enter_clean_room", "script_noteworthy");
	weaver anim_single( weaver, "this_way" );
	
	trigger_wait("kill_lab_in_extra");
	// Kill these enemies if the player has not
	enemy_lab_in_hallway = get_ai_array( "enemy_lab_in_hallway_ai", "targetname" );
	enemy_lab_in_back = get_ai_array( "enemy_lab_in_back_ai", "targetname" );
	
	if(IsDefined(enemy_lab_in_hallway[0]))
	{
		enemy_lab_in_hallway[0] DoDamage(enemy_lab_in_hallway[0].health * 2, weaver.origin);
	}
	
	for(i = 0; i < enemy_lab_in_back.size; i++)
	{
		if(IsDefined(enemy_lab_in_back[i]))
		{
			enemy_lab_in_back[i] DoDamage(enemy_lab_in_back[i].health * 2, weaver.origin);
		}
	}
	
	trigger_wait("weaver_leave_clean_room");
	// "find steiner" VO
	weaver anim_single( weaver, "find_steiner" );
	
	// "are you there" VO
	player anim_single( player, "are_you_there" );
	
	// stops the gas on top of the hill
	stop_exploder(460);
	
	// stops the fire for the crashed helicopter
	stop_exploder(470);
	
	// stop fogs
	stop_exploder(10);
	stop_exploder(15);
	
	trigger_wait("security_office_start");
	
	level notify("stop_stair_combat_logic");
}

hudson_lab_kill_all_enemies()
{
	weaver = level.heroes[ "weaver" ];
	
	enemies_left = GetEntArray("enemy_lab_in_back_ai", "targetname");
	enemies_left[enemies_left.size] = GetEnt("enemy_lab_in_hallway_ai", "targetname");
	
	array_thread( enemies_left, ::hunt_down_player );
	
	if(enemies_left.size > 0)
	{
		hudson_lab_last_stand = GetNode("hudson_lab_last_stand", "targetname");
		weaver SetGoalNode( hudson_lab_last_stand );
		
		weaver waittill("goal");
		
		enemies_left = GetEntArray("enemy_lab_in_back_ai", "targetname");
		enemies_left[enemies_left.size] = GetEnt("enemy_lab_in_hallway_ai", "targetname");
		
		for(i = 0; i < enemies_left.size; i++)
		{
			while( IsDefined(enemies_left[i]) )
			{
				//weaver shoot_at_target( enemies_left[i] );
				//enemies_left[i] DoDamage(enemies_left[i].health * 2, weaver.origin);
				wait(0.06);
			}
		}
	}
}

//------------------------------------
// Player enters the clean room, is sprayed, leaves
pass_through_clean_room()
{
	level endon("event_lab_entrance_done");
	
	weaver = level.heroes[ "weaver" ];
	player = get_players()[0];
	
	flash_door 	= GetEnt( "flash_room_door", "targetname" );
	
	clip_a = GetEnt( "clean_room_clip_a", "targetname" );
	door_a = GetEnt( "clean_door_0", "targetname" );
	clip_a LinkTo( door_a );
	
	//door_a_close = (14329.4, 14385.5, 120);
	door_a_close = door_a.origin;
	door_a_open = (14301.4, 14433.5, 120);
	
	clip_b = GetEnt( "clean_room_clip_b", "targetname" );
	door_b = GetEnt( "clean_door_1", "targetname" );
	clip_b LinkTo( door_b );
	
	door_b_open = (14623.9, 14619.5, 120);
	
	door_offset	= 500;
	
	clip_a DisconnectPaths();
	clip_b DisconnectPaths();
	
	breadcrumb_clean_room = GetEnt("breadcrumb_clean_room", "script_noteworthy");
	breadcrumb_clean_room trigger_off();

	trigger_wait( "go_to_door" );
	
	ResetAILimit();
	
	hudson_lab_kill_all_enemies();
	
	//weaver LookAtEntity( get_players()[0] );
		
	// anim
	anim_struct = getstruct( "anim_struct_pushbutton" );
	
	//rebirth_dialogue( "weaver_elevator_disabled" );
	
	// Make Weaver go to his starting position for the animation
	anim_struct anim_reach_aligned( weaver, "button_press" );
	level thread weaver_button_press(anim_struct, weaver);
	
	// "pass through decontamination" VO
	weaver thread anim_single( weaver, "pass_through_decontamination" );
	
	// waiting for the animation just for the button press to be done
	wait(1.6);
	player thread before_clean_room_hudson_vo();
	
	// open the door	
	//clip_a ConnectPaths();
	//door_a MoveTo( door_a.origin + (0, 0, door_offset ), 0.5 );
	door_a MoveTo( door_a_open, 0.4 );
	
	// SOUND - Shawn J
	door_a playsound ("evt_decon_door");
	clientnotify ("decon_alarm");
	
	breadcrumb_clean_room trigger_on();

  // Waits for the player to get into the clean room
	trigger_wait( "in_clean_room" );
	
	//door_a MoveTo( door_a.origin - (0, 0, door_offset ), 0.5 );
	clip_a DisconnectPaths();
	door_a MoveTo( door_a_close, 0.4 );
	
	// Start spawning the enemies in the stairway
	trigger_use( "sm_stairs" );
	
	level thread clean_up_before_cleaning_room();
	
	// decontamination spray FX
	exploder(480);
	
	// SOUND - Shawn J
	clientnotify ("decontamination_on");
	
	wait(5.5);
	
	clientnotify ("decontamination_off");
	exploder( 490 );	
		
	clip_b ConnectPaths();
	//door_b MoveTo(door_b.origin + ( 0, 0, door_offset ), 0.5 );
	door_b MoveTo( door_b_open, 0.4 );
	
	// SOUND - Shawn J
	door_b playsound ("evt_decon_door");
	
	// Notify to stop Weaver's looping animation
	level notify( "exit_clean_room" );
	
	//weaver LookAtEntity();
	
	anim_struct anim_single_aligned( weaver, "clean_room_exit" );
	
	trigger_use( "weaver_leave_clean_room" );
	
	// TEMP - clean up flash door in case of jump-to-start
	if( IsDefined( flash_door ) )
	{
		flash_door ConnectPaths();
		flash_door Delete();
	}
	
	flag_wait( "security_office_start_hit" );	// set on security_office_start in radiant
	
	//level thread clean_up_after_cleaning_room();
	
	flag_set( "event_lab_entrance_done" );
	//level notify("section_4_done");
}

before_clean_room_hudson_vo()
{
	wait(2);
	self thread anim_single( self, "hudson_this_is_hudson" );
}

//------------------------------------
// Mekes weaver wait at certain spots until a group of enemies is cleared
stair_combat()
{
	level endon("stop_stair_combat_logic");
	
	trigger_wait("weaver_leave_clean_room");
	
	all_killed = false;
	enemy_stairs_0 = get_ai_array( "enemy_stairs_0", "script_noteworthy" );
	while(!all_killed)
	{
		enemy_stairs_0 = get_ai_array( "enemy_stairs_0", "script_noteworthy" );
		if(enemy_stairs_0.size == 0)
		{
			trigger_use( "enemy_stairs_0_trig" );
			all_killed = true;
		}
		
		wait(1.0);
	}
	
	all_killed = false;
	enemy_stairs_1 = get_ai_array( "enemy_stairs_1", "script_noteworthy" );
	while(!all_killed)
	{
		enemy_stairs_1 = get_ai_array( "enemy_stairs_1", "script_noteworthy" );
		if(enemy_stairs_1.size == 0)
		{
			trigger_use( "enemy_stairs_1_trig" );
			all_killed = true;
		}
		
		wait(1.0);
	}
}

delete_color_entrance()
{
	level endon("delete_color_triggers_done");
	
	trigger_wait("entrance_color_1", "script_noteworthy");
	
	color_trigger = GetEnt("entrance_color_0", "script_noteworthy");
	color_trigger Delete();
}

//------------------------------------
// Delete all color triggers in this section
delete_color_triggers()
{
	level endon("delete_color_triggers_done");
	
	trigger_wait("enter_clean_room", "script_noteworthy");
	
	wait(2.0);
	
	color_triggers = GetEntArray("color_manager", "targetname");
	array_delete( color_triggers );
	
	level notify("delete_color_triggers_done");
}

//------------------------------------
// Weaver kills the enemy by the cleaning room door
enemy_wait_to_be_killed()
{
	level endon("enemy_killed");
	
	weaver = level.heroes[ "weaver" ];
	
	trigger_wait("kill_enemy_on_the_left");
		
	weaver_must_kill_ai = get_ai("weaver_must_kill", "script_noteworthy");
	if( IsDefined( weaver_must_kill_ai ) )
	{
		// MagicBullet("enfield_ir_sp", weaver.origin, weaver_must_kill_ai.origin);
		MagicBullet("ak12_zm", weaver.origin, weaver_must_kill_ai.origin);
		weaver_must_kill_ai DoDamage(weaver_must_kill_ai.health * 2, weaver.origin);
	}
	
	/*
	trigger_wait("kill_enemy_by_cleaning_room");
		
	weaver_must_kill_ai = get_ai("weaver_must_kill", "script_noteworthy");
	if( IsDefined( weaver_must_kill_ai ) )
	{
		MagicBullet("enfield_ir_sp", weaver.origin, weaver_must_kill_ai.origin);
		weaver_must_kill_ai DoDamage(weaver_must_kill_ai.health * 2, weaver.origin);
	}
	*/
	
	level notify("enemy_killed");
}

//------------------------------------
// Threading the animation, so it will look correct
weaver_button_press(anim_struct, weaver)
{
	level endon("event_lab_entrance_done");
	
	anim_struct anim_single_aligned( weaver, "button_press" );
	
	//weaver LookAtEntity( get_players()[0] );
	anim_struct anim_loop( weaver, "clean_room_idle", "exit_clean_room" );
	//weaver LookAtEntity();
}

//------------------------------------
// Revives the player if the RPG hits him
revive_from_rpg_attacks()
{
	//self endon("revive_done");
	self endon("death");
	
	/*
	while(level.revive_player)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type );
	
		if(type == "MOD_PROJECTILE_SPLASH")
		{
			self.health = 100;
		}
		
		wait(1.0);
	}
	*/
	
	self.overridePlayerDamage = ::player_damage_callback;
}

player_damage_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime)
{

	rebirth_inflictor = eInflictor;
	rebirth_attacker = eAttacker;
	rebirth_damage = iDamage;
	rebirth_flags = iDFlags;
	rebirth_means = sMeansOfDeath;
	rebirth_weapon = sWeapon;
	rebirth_point = vPoint;
	rebirth_dir = vDir;
	rebirth_hitLoc = sHitLoc;
	rebirth_index = modelIndex;
	rebirth_offset = psOffsetTime;
	
	if(sMeansOfDeath == "MOD_PROJECTILE_SPLASH")
	{
		if(self.health > 1)
		{
			iDamage = self.health - 1;
		}
	}
	
	return iDamage;
}

// Detaches the gas masks when the player is not looking
detach_mask()
{
	self endon("death");
	self endon("mask_detached");
	
	player = get_players()[0];
	
	while( IsDefined(self) )
	{
		if(!(self player_can_see_me( player )))
		{
			self Detach(self.hatModel);
			self notify("mask_detached");
		}
		
		wait(1.0);
	}
}

/*------------------------------------------------------------------------------------------------------------
																								Corpse Memory
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Init relevant variables for corpse memory system
corpse_memory_init()
{
	level._corpse_loc_array["origin"] = [];
	level._corpse_loc_array["angles"] = [];
	level._corpse_sci_loc_array["origin"] = [];
	level._corpse_sci_loc_array["angles"] = [];		
}

//------------------------------------
// Use this spawn function on the AI that should 
// have their location remembered upon death
corpse_memory_spawnfunc()
{
	self.overrideActorDamage = ::corpse_memory_damage_override;
}

corpse_sci_memory_spawnfunc()
{
	self.overrideActorDamage = ::corpse_sci_memory_damage_override;
}



//------------------------------------
// override the damage to see if/when AI dies
corpse_memory_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if( iDamage > self.health && self.health >= 1 )
	{
		level._corpse_loc_array["origin"] = array_add( level._corpse_loc_array["origin"], self.origin );
		level._corpse_loc_array["angles"] = array_add( level._corpse_loc_array["angles"], self.angles );
	}
	
	return iDamage;
}

corpse_sci_memory_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
//	if( iDamage > self.health && self.health >= 1 )
//	{
//		level._corpse_sci_loc_array["origin"] = array_add( level._corpse_sci_loc_array["origin"], self.origin );
//		level._corpse_sci_loc_array["angles"] = array_add( level._corpse_sci_loc_array["angles"], self.angles );
//	}
	
	return iDamage;
}



//------------------------------------
// Place a corpse where an AI has died in the lab
corpse_memory_place_models()
{
	clean_up_after_cleaning_room();
	clearallcorpses();
	
	corpse_counter = 0;
	corpse_total = 15;
	sci_total = 0;
	corpse_toggle = true;
	
	if( level._corpse_loc_array["origin"].size == 0 )	// used for jumptos
	{
		default_corpse_structs = getstructarray( "default_corpse_memory", "targetname" );
		
		for( i = 0; i < default_corpse_structs.size; i++ )
		{
			level._corpse_loc_array["origin"] = array_add( level._corpse_loc_array["origin"], default_corpse_structs[i].origin );
			level._corpse_loc_array["angles"] = array_add( level._corpse_loc_array["angles"], (0,0,0) );
		}
	}
	
	// place a model at each location
	for( i = 0; i < level._corpse_loc_array["origin"].size; i++ )
	{
		if(corpse_counter < corpse_total)
		{
			if(corpse_toggle)//Do every other corpse to help get a better spread.
			{
				if(RandomInt(1))
				{
					if(is_mature())
					{
						corpse_model = rb_spawn_character("spetznaz_bloody_corpse1", level._corpse_loc_array["origin"][i], level._corpse_loc_array["angles"][i]);
					}
					else
					{
						corpse_model = rb_spawn_character("spetznaz_corpse1", level._corpse_loc_array["origin"][i], level._corpse_loc_array["angles"][i]);
					}
				}
				else
				{
					if(is_mature())
					{
						corpse_model = rb_spawn_character("spetznaz_bloody_corpse2", level._corpse_loc_array["origin"][i], level._corpse_loc_array["angles"][i]);	
					}
					else
					{
						corpse_model = rb_spawn_character("spetznaz_corpse2", level._corpse_loc_array["origin"][i], level._corpse_loc_array["angles"][i]);	
					}
				}
				corpse_model thread corpse_init();
				corpse_toggle = false;
				corpse_counter++;
			}
			else
				corpse_toggle = true;
		}
	}
	
	// place a scientist model at each location
	corpse_toggle = true;
	corpse_counter = 0;
//	for( i = 0; i < level._corpse_sci_loc_array["origin"].size; i++ )
//	{
//		if(corpse_counter < sci_total)
//		{
//			if(corpse_toggle)//Do every other corpse to help get a better spread.
//			{
//				//if(RandomInt(1))
//					corpse_model = rb_spawn_character("scientist_bloody_corpse1", level._corpse_sci_loc_array["origin"][i], level._corpse_sci_loc_array["angles"][i]);
//				//else
//					//corpse_model = rb_spawn_character("scientist_bloody_corpse2", level._corpse_sci_loc_array["origin"][i], level._corpse_sci_loc_array["angles"][i]);	
//				corpse_model thread corpse_init();
//				corpse_toggle = false;
//				corpse_counter++;
//			}
//			else
//				corpse_toggle = true;
//		}
//	}	
}

corpse_init()
{
	//self MakeFakeAI();
	self StartRagdoll();
	self LaunchRagDoll((RandomIntRange(0,3),RandomIntRange(10,30),RandomIntRange(0,3)));
	level waittill("cleanup_corpses");
	self Delete();
}



/*------------------------------------------------------------------------------------------------------------
																								Objectives
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Update objectives and objective markers
hudson_lab_objectives()
{
		maps\rebirth_utility::rb_objective_breadcrumb( level.obj_iterator, "obj_section_4_start" );
}



/*------------------------------------------------------------------------------------------------------------
																								Spawn Functions
------------------------------------------------------------------------------------------------------------*/
hudson_lab_redshirts_spawnfunc()
{
	self endon("death");
	
	self Detach(self.hatModel);
	self set_ignoreall(true);
	
	self thread cool_ragdoll();
	
	flag_wait("rpg_trigger_0_hit");
	self set_ignoreall(false);
}

//------------------------------------
// Gives all the redshirts a cool ragdoll effect when they get hit by a rocket
cool_ragdoll()
{
	self waittill ( "damage", damage, attacker, direction_vec, point, type );
	
	if(type == "MOD_PROJECTILE_SPLASH")
	{
		dir = (direction_vec[0], direction_vec[1], 0);
		force = dir * 100;
		force = force + (0, 0, 100);

		self DoDamage( self.health * 100, self.origin, self, undefined, "explosive" );
		self StartRagdoll( 1 );
		self LaunchRagdoll( force );
	}
}

hudson_lab_left_window_drones_spawnfunc()
{
	self endon("death");
	
	self set_ignoreall(true);
	self.script_forcegoal = true;
	
	self waittill("goal");
	
	left_final_node = GetNode( "left_final_node", "targetname" );
	self SetGoalNode( left_final_node );
	
	self waittill("goal");
	self Delete();
}

hudson_lab_right_window_drones_spawnfunc()
{
	self endon("death");
	
	self set_ignoreall(true);
	self.script_forcegoal = true;
	
	self waittill("goal");
	
	right_final_node = GetNode( "right_final_node", "targetname" );
	self SetGoalNode( right_final_node );
	
	self waittill("goal");
	self Delete();
}

hudson_lab_rpg_left_spawnfunc()
{
	self endon("death");
	
	self set_ignoreall(true);
	self.a.rockets = 100;
	
	num_seconds = 6;
	
	weaver = level.heroes["weaver"];
	player = get_players()[0];
	
	self aim_at_target( player );
	
	trigger_wait( "vo_hudson_lab_start" );

	target_entity = GetEnt("sm_lab_ext_1", "targetname");
	self shoot_at_target( target_entity );
	
	while( !flag("stop_rpg_hack") )
	{
		self aim_at_target( player );
			
		while( level.rpg_guy_right_shot )
		{
			wait(0.06);
		}
			
		level.rpg_guy_left_shot = true;
		wait(num_seconds);
		level.rpg_guy_left_shot = false;
			
		hudson_redshirts = get_ai_array("hudson_lab_redshirts", "script_noteworthy");
		hudson_redshirts[hudson_redshirts.size] = weaver;
		hudson_redshirts[hudson_redshirts.size] = target_entity;
		hudson_redshirts[hudson_redshirts.size] = player;
		random_int = RandomIntRange(0, hudson_redshirts.size);
		if( IsDefined( hudson_redshirts[random_int] ) )
		{
			self shoot_at_target( hudson_redshirts[random_int] );
		}
	}
	
	self.script_accuracy = 1;
	
	while( true )
	{
		self aim_at_target( player );
			
		while( level.rpg_guy_right_shot )
		{
			wait(0.06);
		}
			
		level.rpg_guy_left_shot = true;
		wait(num_seconds);
		level.rpg_guy_left_shot = false;
			
		hudson_redshirts = get_ai_array("hudson_lab_redshirts", "script_noteworthy");
		hudson_redshirts[hudson_redshirts.size] = weaver;
		hudson_redshirts[hudson_redshirts.size] = player;
		random_int = RandomIntRange(0, hudson_redshirts.size);
		if( IsDefined( hudson_redshirts[random_int] ) )
		{
			self shoot_at_target( hudson_redshirts[random_int] );
		}
	}
}

hudson_lab_rpg_right_spawnfunc()
{
	self endon("death");
	
	self set_ignoreall(true);
	self.a.rockets = 100;
	
	num_seconds = 6;
	
	weaver = level.heroes["weaver"];
	player = get_players()[0];
	
	self aim_at_target( player );
	
	trigger_wait( "vo_hudson_lab_start" );

	target_entity = GetEnt("sm_lab_ext_1", "targetname");
	level.rpg_guy_right_shot = true;
	wait(num_seconds);
	level.rpg_guy_right_shot = false;
	self shoot_at_target( target_entity );
	
	while( !flag("stop_rpg_hack") )
	{
		self aim_at_target( player );
		while( level.rpg_guy_left_shot )
		{
			wait(0.06);
		}
		
		level.rpg_guy_right_shot = true;
		wait(num_seconds);
		level.rpg_guy_right_shot = false;
		
		hudson_redshirts = get_ai_array("hudson_lab_redshirts", "script_noteworthy");
		hudson_redshirts[hudson_redshirts.size] = weaver;
		hudson_redshirts[hudson_redshirts.size] = target_entity;
		hudson_redshirts[hudson_redshirts.size] = player;
		random_int = RandomIntRange(0, hudson_redshirts.size);
		if( IsDefined( hudson_redshirts[random_int] ) )
		{
			self shoot_at_target( hudson_redshirts[random_int] );
		}
	}
	
	self.script_accuracy = 1;
	
	while( true )
	{
		self aim_at_target( player );
		while( level.rpg_guy_left_shot )
		{
			wait(0.06);
		}
		
		level.rpg_guy_right_shot = true;
		wait(num_seconds);
		level.rpg_guy_right_shot = false;
		
		hudson_redshirts = get_ai_array("hudson_lab_redshirts", "script_noteworthy");
		hudson_redshirts[hudson_redshirts.size] = weaver;
		hudson_redshirts[hudson_redshirts.size] = player;
		random_int = RandomIntRange(0, hudson_redshirts.size);
		if( IsDefined( hudson_redshirts[random_int] ) )
		{
			self shoot_at_target( hudson_redshirts[random_int] );
		}
	}
}

hudson_lab_scientists_spawnfunc()
{
	self endon("death");
	
	self.team = "axis";
	self.script_forcegoal = true;
	self.noDodgeMove = true;
	self PushPlayer(true);
	
	self thread civilian_ai_idle_and_react( self, "cower_idle", "cower_react", undefined, self.script_string );
	
	level waittill( self.script_string );
	
	self notify( self.script_string );
	
	// wait for the hallway enemy to spawn and gets to his node
	if(self.script_string == "sm_lab_in_back")
	{
		wait(0.4);
	}
	
	hallway_left = GetNode( "hallway_left", "script_noteworthy" );
	node_owner = GetNodeOwner( hallway_left );
	
	scientist_first_node = GetNode( "scientist_first_node", "targetname" );
	if( IsDefined( node_owner ) )
	{
		alt_path = GetNode( "alt_path", "targetname" );
		self SetGoalNode( alt_path );
		
		self waittill("goal");
	}
		
	self SetGoalNode( scientist_first_node );

	self waittill("goal");
	
	player = get_players()[0];
	
	if( !self player_can_see_me( player ) )
	{
		self Delete();
	}
	
	if( IsDefined( node_owner ) )
	{
		alt_path = GetNode( "alt_path", "targetname" );
		self SetGoalNode( alt_path );
		
		self waittill("goal");
	}
	
	scientist_final_node = GetNode( "scientist_final_node", "targetname" );
	self SetGoalNode( scientist_final_node );
	
	self waittill("goal");

	self Delete();
} 