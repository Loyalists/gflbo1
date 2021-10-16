/*
///////
///////
WMD_APPROACH_RADAR.GSC
BUILDER: BRIAN CLINES, ROSS KAYLOR, SUSAN ARNOLD



///////
///////
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_util;
#include maps\_anim;
#include maps\_music;
#include maps\_stealth_logic;
#include maps\wmd;
#include maps\_rusher;



approach_main()
{	
	flag_wait("all_players_spawned");
	
	level.explosive_tip = false;
	
	SetSavedDvar( "r_skyTransition", 0 );
	
	level thread ai_spawn_functions();
	
	//Client notify for base sounds
	clientnotify("start_base_sounds");
	
	//allows the area to go hot
	flag_set("allow_alert");
			
	level thread disable_ai_revive();	
	level thread down_relay_station();
	level thread color_chain_approach();
	level thread down_to_door();
	level thread cleanup_ai();
	level thread glo_hinge();
	level thread lerp_squad();
	level thread save_at_stairs();
	
	flag_set( "obj_personnel_a" );
	
	level thread objective_approach_radar();
	
	trigger_wait("triggercolor_to_choppers");
	
	clientnotify("delete_breach_items");
	
	level thread setup_woodchoppers();
	level thread stealth_event_setup();
	level thread stealth_event();
	level.weaver thread vo_choppers();
	level thread vo_russian_choppers();
	level thread wood_axe_physics();
	level thread vo_area_alerted();
	level thread commstat_weapon_check();
	level thread check_for_grenade();
	level thread show_comstat_objects();
	
	trigger_wait("trigger_radar_installation");
	
	level thread wake_up_squad();
	level thread spawn_event1_initial_enemies();
	level thread spawn_shovelers();
	level thread open_garage_door();
	
	flag_set( "jump_down" );
	
	trigger_wait("trigger_jump_down");
	
	guys = getaiarray( "allies" );
	
	for( i=0; i<guys.size; i++ )
	{
		guys[i] disable_cqbsprint();
	}
	
	stop_exploder(60);
	
	//level thread check_alert_one();
	level thread check_alert_two();
	level thread check_alert_three();
	level thread change_names();
	level thread check_gaz_guys();
	level thread spawn_stair_guy();
	
	level thread hide_base();
	
	monitor_radar_installation();
	wait_for_weaver();
	battlechatter_on();
}


show_base()
{
	level endon("jumped_gap");
	
	trigger_wait("trigger_show_base");
	
	baseoutdoors = getstructarray("occlude_baseoutdoors", "targetname");
	
	for(i=0; i<baseoutdoors.size; i++)
	{
		SetCellVisibleAtPos(baseoutdoors[i].origin);
	}
	
	level thread hide_base();
}


hide_base()
{
	level endon("jumped_gap");
	
	trigger_wait("trigger_hide_base");
	
	baseoutdoors = getstructarray("occlude_baseoutdoors", "targetname");
	
	for(i=0; i<baseoutdoors.size; i++)
	{
		SetCellInvisibleAtPos(baseoutdoors[i].origin);
	}
	
	level thread show_base();
}


show_comstat_objects()
{
	weapons = getentarray("weapon_comstat", "targetname");
	
	for (i=0; i<weapons.size; i++)
	{
		weapons[i] show();
	}
	
	tanker = getent("tanker", "targetname");
	truck = getent("scrape_gaz", "targetname");
	can = getent("gaz_can", "targetname");
	
	tanker show();
	truck show();
	can show();
}


save_at_stairs()
{
	trigger_wait("trigger_save_stairs");
	
	autosave_by_name( "wmd" );
}


cleanup_ai()
{
	victim = getent("overrail_victim_ai", "targetname");
	guys = getaiarray("axis");
	guys = array_exclude(guys, victim);
	
	for(i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
	
	dog = getent("dog_ai", "targetname");
	if (isdefined(dog))
	{
		dog delete();
	}
	
	tree_clip = getent("brokentree_collision", "targetname");
	tree_clip trigger_off();
}


glo_hinge()
{
	glo_hinge_bot = getent("glo_hinge_bot", "targetname");
	glo_hinge_top = getent("glo_hinge_top", "targetname");
	door_lower_dmg = getent("door_lower_dmg", "targetname");
	door_upper_dmg = getent("door_upper_dmg", "targetname");
	
	glo_hinge_bot hide();
	glo_hinge_top hide();
	door_lower_dmg hide();
	door_upper_dmg hide();
	
	flag_wait("weaver_knife");
	
	glo_hinge_bot show();
	glo_hinge_top show();
}


spawn_event1_initial_enemies()
{
	level thread gaz_guys_setup();	
	level thread right_side_setup();	
	level thread left_side_setup();
	
	wait(0.1);
	
	level thread ice_scrapers_init();	
	level thread init_idle_nodes();
	level thread kill_exterior_guards();
	
	wait(1.0);
	
	level.weaver thread weaver_position();
	level.brooks thread brooks_position();
	level.harris thread harris_position();
}


ai_spawn_functions()
{
	sc_guy1 = getent("snow_cat_driver", "targetname");
	sc_guy2 = getent("snow_cat_passenger", "targetname");
	sc_guy1 add_spawn_function(::setup_sc_guy);
	sc_guy2 add_spawn_function(::setup_sc_guy);
	add_spawn_function_veh("snowcat", ::setup_snowcat);
}


#using_animtree("generic_human");
right_side_setup()
{
	roof_guy = simple_spawn ( "roof_guy", ::setup_roof_patrol );		
}


teleport_to_skipto()
{
	player_pos = getstruct( "approach_radar_player", "targetname" );
	pos_harris = getstruct( "radar_pos_harris", "targetname" );
	pos_weaver = getstruct( "radar_pos_weaver", "targetname" );
	pos_brooks = getstruct( "radar_pos_brooks", "targetname" );
	
	level.harris = simple_spawn_single( "spawner_harris", ::setup_teleported_guys );	
	level.weaver = simple_spawn_single( "spawner_weaver", ::setup_teleported_guys );	
	level.brooks = simple_spawn_single( "spawner_brooks", ::setup_teleported_guys );
	
	level.harris.name = ( "harris" );
	level.weaver.name = ( "Weaver" );
	level.brooks.name = ( "Brooks" );
	
	player = get_players()[0];
	
	player SetOrigin( player_pos.origin );
	player SetPlayerAngles( player_pos.angles );
	
	level.harris forceteleport( pos_harris.origin, pos_harris.angles );
	level.weaver forceteleport( pos_weaver.origin, pos_weaver.angles );
	level.brooks forceteleport( pos_brooks.origin, pos_brooks.angles );
}


setup_teleported_guys()
{
	self make_hero();
	self.ignoreall = true;
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


change_names()
{
	level.heroes=[];
	level.heroes["kristina"] = level.weaver;
	level.heroes["pierro"] = level.brooks;
	level.heroes["glines"] = level.harris;
	
	level.heroes["kristina"].name = ("Weaver");
	level.heroes["pierro"].name = ("Brooks");
	level.heroes["glines"].name = ("Harris");
	
	level.heroes["kristina"] enable_ai_color();
	level.heroes["glines"] enable_ai_color();
	level.heroes["pierro"] enable_ai_color();
}


wake_up_squad()
{
	level endon( "hinge_breach" );
	level endon( "hut_breach_go" );
	level endon( "breach_begin" );
	
	flag_wait("area_alerted");
	
	level thread explosive_tip_hint();
	
	level.weaver.ignoreall = false;
	level.harris.ignoreall = false;
	level.brooks.ignoreall = false;
	
	get_players()[0].ignoreme = false;
	level.weaver.ignoreme = false;
	level.brooks.ignoreme = false;
	level.harris.ignoreme = false;
	
	level.weaver gun_switchto("ak12_zm", "right");
	level.harris gun_switchto("aug_arctic_acog_sp", "right");
	level.brooks gun_switchto("aug_arctic_acog_sp", "right");
	
	battlechatter_on();
}


explosive_tip_hint()
{
	level endon("stackup");
	level endon("remove_hint");
	
	flag_wait("explosive_hint");
	
	player = get_players()[0];
	
	currentweapon = player GetCurrentWeapon();
	
	if( player HasWeapon("crossbow_vzoom_alt_sp")  && currentweapon != "crossbow_explosive_alt_sp")
	{
		screen_message_create(&"WMD_EXPLOSIVE_TIP_HINT");
		
		level thread explosive_hint_timer();
		
		level.explosive_tip = true;
		
		wait(0.1);
		
		currentweapon = player GetCurrentWeapon();
		
		while(1)
		{
			currentweapon = player GetCurrentWeapon();
			
			if (currentweapon == "crossbow_explosive_alt_sp")
			{
				break;
			}
			
			wait(0.1);
		}
		
		screen_message_delete();
		
		level.explosive_tip = false;
	}
}


explosive_hint_timer()
{
	wait(10.0);
	
	level notify("remove_hint");
	
	if (level.explosive_tip)
	{
		screen_message_delete();
	}
}


down_relay_station()
{
	guys = getaiarray( "allies" );
	
	for( i=0; i<guys.size; i++ )
	{
		guys[i] enable_ai_color();
		guys[i] AllowedStances("prone", "crouch", "stand");
		guys[i] enable_cqbsprint();
	}
	
	level.weaver set_force_color("c");
	level.brooks set_force_color("g");
	level.harris set_force_color("r");
	
	wait(0.1);
	
	trigger_use("triggercolor_stairs_brooks");
			
	wait(1.5);
	
	trigger_use("triggercolor_stairs_harris");
		
	wait(1.0);
	
	trigger_use("triggercolor_stairs_weaver");
		
	flag_wait("target_choppers");
	
	guys = getentarray( "wood_choppers_ai", "targetname" );
	
	if (isdefined(guys[0]))
	{
		level.weaver thread target_chopper(guys[0]);
	}
	
	if (isdefined(guys[1]))
	{
		level.harris thread target_chopper(guys[1]);
	}
	
	if (isAlive(guys[0]) || isAlive(guys[1]))
	{
		level.brooks thread cover_choppers();
	}
}


objective_approach_radar()
{
	wait(1.0);
	
	trigger_wait("trigger_radar_installation");
	
	flag_set( "obj_personnel_a_b" );
	
	flag_wait("hinge_breach");
}


target_chopper( guy )
{
	self aim_at_target( guy );
	
	self thread kill_chopper( guy );
	
	while( isAlive( guy ) )
	{
		wait( 0.1 );
	}
	
	self stop_aim_at_target();
}


cover_choppers()
{
	aim_pos = getent("align_wood_choppers", "targetname");
	
	self aim_at_target(aim_pos);
	
	guys = getentarray("wood_choppers_ai", "targetname");
	
	while(guys.size > 0)
	{
		guys = getentarray("wood_choppers_ai", "targetname");
		wait(0.1);
	}
	
	self stop_aim_at_target();
}


kill_chopper(guy)
{
	flag_wait("kill_chopper");
	
	wait( 0.1 );
	
	if (isAlive(guy) && flag("lerp_squad_check"))
	{
		self thread shoot_and_kill(guy);
	}
}


check_choppers()
{
	waittill_ai_group_cleared( "group_wood" );
	
	level.weaver.ignoreme = true;
	level.brooks.ignoreme = true;
	level.harris.ignoreme = true;
	
	level thread vo_approach();
	
	trigger_use("triggercolor_approach_radar");
}


// set up for event with enemies patrolling and in stealth.
stealth_event_setup()
{
	array_thread( getentarray( "radar_patroller", "targetname" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "snow_cat_passenger", "targetname" ), ::add_spawn_function, ::stealth_ai );
	
	array_thread( getentarray( "snow_cat_driver", "targetname" ), ::add_spawn_function, ::setup_snowcat_driver );
	array_thread( getentarray( "snow_cat_passenger", "targetname" ), ::add_spawn_function, ::setup_snowcat_passenger );
	
	array_thread( get_players(), ::stealth_ai );
}


stealth_event()
{
	flag_wait_any("_stealth_spotted", "_stealth_found_corpse");
   
   wait(1.0);
   
   flag_set("area_alerted");
}


commstat_weapon_check()
{
	level endon("stackup");
	level endon("area_alerted");
	
	triggers = getentarray("commstat_weapon_check", "targetname");
	
	while(1)
	{
		player = get_players()[0];
		
		for(i=0; i<triggers.size; i++)
		{
			if (player isTouching(triggers[i]) && player AttackButtonPressed())
			{
				currentweapon =  player GetCurrentWeapon();
				
				if (currentweapon == "crossbow_explosive_alt_sp")
				{
					wait(2.5);	//wait for explosion
					flag_set ("area_alerted");
				}
				
				if ((currentweapon == "crossbow_vzoom_alt_sp") || (currentweapon == "aug_arctic_acog_silencer_sp"))
				{
					wait(0.05);
				}
				else
				{
					wait(1.0);
					
					flag_set("area_alerted");
				}
			}
		}
		
		wait(0.1);
	}
}


check_for_grenade()
{
	level endon("stackup");
	level endon("area_alerted");
	
	triggers = getentarray("commstat_weapon_check", "targetname");
	
	player = get_players()[0];
	player waittill("grenade_fire", grenade);
	
	while(IsDefined(grenade))
	{
		wait(0.05);
	}
	
	for(i=0; i<triggers.size; i++)
	{
		if (player isTouching(triggers[i]))
		{
			flag_set("area_alerted");
		}
	}
}


// Squad takes out enemies along with player //////////////////////////////////////////
kill_exterior_guards()
{
	level thread monitor_shed_guys();
	level thread monitor_gaz_guys();
	
	smoker = getent( "left_side_smoker_ai", "targetname" );
	welder = getent( "welder_ai", "targetname" );
	
	smoker thread maps\_stealth_logic::enemy_corpse_death();
	welder thread maps\_stealth_logic::enemy_corpse_death();
	
	scraper = getai_by_noteworthy("scraper_1");
	fueler = getai_by_noteworthy("scraper_2");
	
	scraper thread maps\_stealth_logic::enemy_corpse_death();
	fueler thread maps\_stealth_logic::enemy_corpse_death();
	
	if (IsDefined (smoker))
	{
		smoker thread check_smoker();
		smoker thread monitor_welder();
	}
	if (IsDefined (welder))
	{
		welder thread check_welder();
		welder thread monitor_smoker();
	}
	if(IsDefined (scraper))
	{
		scraper thread check_scraper();
		scraper thread monitor_fueler();
	}
	if (IsDefined (fueler))
	{
		fueler thread check_fueler();
		fueler thread monitor_scraper();
	}
	
	level.weaver thread shoot_garage_guy();
	level.brooks thread shoot_gaz_guy();
	level.harris thread shoot_shoveler();
	level thread vo_gaz_guys();
}


monitor_shed_guys()
{
	smoker = getent( "left_side_smoker_ai", "targetname" );
	welder = getent( "welder_ai", "targetname" );
	
	while(isAlive(smoker) || isAlive(welder))
	{
		wait(0.5);
	}
	
	flag_set("crossroad");
}


monitor_gaz_guys()
{
	scraper = getai_by_noteworthy("scraper_1");
	fueler = getai_by_noteworthy("scraper_2");
	
	while(isAlive(scraper) || isAlive(fueler))
	{
		wait(0.5);
	}
	
	flag_wait("crossroad");
	flag_set("approach");
}


monitor_fueler()
{
	self endon("death");
	
	fueler = getai_by_noteworthy("scraper_2");
	
	while(isAlive(fueler))
	{
		wait(0.1);
	}
	
	flag_set("gaz_alerted");
}


monitor_scraper()
{
	self endon("death");
	
	scraper = getai_by_noteworthy("scraper_1");
	
	while(isAlive(scraper))
	{
		wait(0.1);
	}
	
	flag_set("gaz_alerted");
}


monitor_welder()
{
	self endon("death");
	
	welder = getent("welder_ai", "targetname");
	
	while(isAlive(welder))
	{
		wait(0.1);
	}
	
	flag_set("shed_alerted");
}


monitor_smoker()
{
	self endon("death");
	
	smoker = getent("left_side_smoker_ai", "targetname");
	
	while(isAlive(smoker))
	{
		wait(0.1);
	}
	
	flag_set("shed_alerted");
}


run_to_alert(node)
{
	self endon("death");
	
	self.goalradius = 16;
	self thread force_goal();
	
	wait(1.0);
	
	self setgoalnode(node);
	
	self waittill("goal");
	
	self.ignoreall = false;
	
	flag_set("area_alerted");
	
	node = getnode("node_after_alert", "targetname");
	
	self setgoalnode(node);
}


kill_shovelers()
{
	shoveler1 = getai_by_noteworthy("shoveler_1");
	shoveler2 = getai_by_noteworthy("shoveler_2");
	
	if (IsDefined (shoveler1))
	{
		shoveler1 thread check_shoveler1();
		shoveler1 thread monitor_shoveler2();
	}
	if (IsDefined (shoveler2))
	{
		shoveler2 thread check_shoveler2();
		shoveler2 thread monitor_shoveler1();
	}
}


monitor_shoveler2()
{
	self endon("death");
	
	shoveler2 = getai_by_noteworthy("shoveler_2");
	
	while(isAlive(shoveler2))
	{
		wait(0.1);
	}
	
	flag_set("shoveler_alerted");
}


monitor_shoveler1()
{
	self endon("death");
	
	shoveler1 = getai_by_noteworthy("shoveler_1");
	
	while(isAlive(shoveler1))
	{
		wait(0.1);
	}
	
	flag_set("shoveler_alerted");
}


weaver_position()
{
	self.inposition = false;
	
	trigger = getent("trigger_weaver_inposition", "targetname");
	trigger waittill("trigger");
	
	wait(1.5);
	
	self.inposition = true;
	
	smoker = getent("left_side_smoker_ai", "targetname");
	
	if (isAlive(smoker))
	{
		self aim_at_target(smoker);
	}
	
	while(isAlive(smoker))
	{
		if (flag("area_alerted"))
		{
			break;
		}
		
		wait(0.1);
	}
	
	self stop_aim_at_target();
}


brooks_position()
{
	self.inposition = false;
	
	trigger = getent("trigger_brooks_inposition", "targetname");
	trigger waittill("trigger");
	
	wait(1.5);
	
	self.inposition = true;
	
	scraper = getai_by_noteworthy("scraper_1");
	
	if (isAlive(scraper))
	{
		self aim_at_target(scraper);
	}
	
	while(isAlive(scraper))
	{
		if (flag("area_alerted"))
		{
			break;
		}
		
		wait(0.1);
	}
	
	self stop_aim_at_target();
}


harris_position()
{
	self.inposition = false;
	
	trigger = getent("trigger_harris_inposition", "targetname");
	trigger waittill("trigger");
	
	wait(1.5);
	
	self.inposition = true;
	
	shoveler1 = getai_by_noteworthy("shoveler_1");
	
	if (isAlive(shoveler1))
	{
		self aim_at_target(shoveler1);
	}
	
	while(isAlive(shoveler1))
	{
		if (flag("area_alerted"))
		{
			break;
		}
		
		wait(0.1);
	}
	
	self stop_aim_at_target();
}


check_smoker()
{
	self waittill_any("damage", "death");
	
	flag_set("smoker_shot");
	flag_set("shed_alerted");
}

check_welder()
{
	self waittill_any("damage", "death");
	
	flag_set("welder_shot");
	flag_set("shed_alerted");
}

check_scraper()
{
	self waittill_any("damage", "death");
	
	flag_set("scraper_shot");
	flag_set("gaz_alerted");
}

check_fueler()
{
	self waittill_any("damage", "death");
	
	flag_set("fueler_shot");
	flag_set("gaz_alerted");
}


check_shoveler1()
{
	self waittill_any("damage", "death");
	
	flag_set("shoveler1_shot");
	flag_set("shoveler_alerted");
}


check_shoveler2()
{
	self waittill_any("damage", "death");
	
	flag_set("shoveler2_shot");
	flag_set("shoveler_alerted");
}


shoot_garage_guy()
{
	level endon("area_alerted");
	level endon("stackup");
	
	smoker = getent( "left_side_smoker_ai", "targetname" );
	welder = getent( "welder_ai", "targetname" );
	
	self.inposition = false;
	
	while(1 )
	{
		if (flag("smoker_shot") && self.inposition)
		{
			if (isAlive(welder))
			{
				wait(0.3);
				self thread shoot_and_kill (welder);
				break;
			}
		}
		if (flag("welder_shot") && self.inposition)
		{
			if (isAlive(smoker))
			{
				wait(0.3);
				self thread shoot_and_kill (smoker);
				break;
			}
		}
		wait(0.05);
	}
}


shoot_gaz_guy()
{
	level endon("area_alerted");
	level endon("stackup");
	
	scraper = getai_by_noteworthy("scraper_1");
	fueler = getai_by_noteworthy("scraper_2");	
	
	self.inposition = false;
	
	while(1 )
	{
		if (flag("scraper_shot") && self.inposition)
		{
			if (isAlive(fueler))
			{
				wait(0.3);
				self thread shoot_and_kill (fueler);
				break;
			}
		}
		if (flag("fueler_shot") && self.inposition)
		{
			if (isAlive(scraper))
			{
				wait(0.3);
				self thread shoot_and_kill (scraper);
				break;
			}
		}
		wait(0.05);
	}
}


shoot_shoveler()
{
	level endon("area_alerted");
	level endon("stackup");
	
	shoveler1 = getai_by_noteworthy("shoveler_1");
	shoveler2 = getai_by_noteworthy("shoveler_2");
	
	self.inposition = false;
	
	while(1)
	{
		if (flag("shoveler1_shot") && self.inposition)
		{
			if (isAlive(shoveler2))
			{
				wait(0.3);
				self thread shoot_and_kill (shoveler2);
				break;
			}
		}
		if (flag("shoveler2_shot") && self.inposition)
		{
			if (isAlive(shoveler1))
			{
				wait(0.3);
				self thread shoot_and_kill (shoveler1);
				break;
			}
		}
		wait(0.05);
	}
}


//Gives all clear to enter radar installation once all enemies outside have been dealt with
monitor_radar_installation()
{
	waittill_ai_group_cleared("group_radar");
	
	flag_wait("kill_spawns");
	
	spawn_manager_kill("manager_jump_down");
	spawn_manager_kill("manager_crossroad");
	//spawn_manager_kill("manager_approach");
	
	guys = getaiarray( "axis" );
	
	wait(3.0);
	
	while( guys.size > 0 )
	{
		guys = getaiarray( "axis" );
		
		stair_guy1 = getent("stair_guy_ai", "targetname");
		stair_guy2 = getent("stair_guy2_ai", "targetname");
		
		if (isdefined(stair_guy1))
		{
			guys = array_exclude(guys, stair_guy1);
		}
		
		if (isdefined(stair_guy2))
		{
			guys = array_exclude(guys, stair_guy2);
		}
		
		wait(1.0);
	}
	
	//moved to after stair guy is killed
	//TUEY Stop the Music!
	//setmusicstate("RADAR_FIGHT_DONE");
	
	flag_set("stackup");
	
	wait(0.5);
	
	if (level.explosive_tip)
	{
		screen_message_delete();
	}
}


close_on_player()
{
	self endon("death");
	self endon("rush");
	
	self set_spawner_targets("com_stat_stairs");
	
	self waittill("goal");
				
	wait(0.1);
		
	self.goalradius = 16;
		
	num = RandomIntRange(1, 100);
		
	wait(RandomFloatRange(5.0, 8.0));
		
	if (num < 10)
	{
		self rush();
		self notify("rush");		
	}
	
	while(isAlive(self))
	{
		self.goalradius = 200;
		self setgoalentity(get_players()[0]);
		self waittill("goal");
		wait(RandomFloatRange(3.0, 5.0));
	}
}


spawn_stair_guy()
{
	trigger_wait("trigger_stair_guy");
	
	flag_set("hinge_breach");
	
	if (flag("area_alerted"))
	{
		stair_guy = simple_spawn_single("stair_guy", ::setup_stairguy_alert);
	}
	else
	{
		stair_guy = simple_spawn_single("stair_guy2", ::setup_stairguy_notalert);
	}
	
	guys = getaiarray("axis");
	guys = array_exclude(guys, stair_guy);
	
	for(i=0; i<guys.size; i++)
	{
		guys[i] thread close_on_player();
	}
}


setup_stairguy_alert()
{
	self endon("death");
	
	self thread check_stair_guy();
	
	self.goalradius = 16;
	
	self waittill("goal");
	
	self.goalradius = 16;
}


setup_stairguy_notalert()
{
	self endon("death");
	
	self thread check_stair_guy();
	
	self.dofiringdeath = false;
	self.allowdeath = true;
	
	//self thread stealth_event();
}


check_stair_guy()  //once player reaches knife throw door, get rid of trailing ai
{
	self waittill("death");
	
	if (flag("area_alerted"))
	{
		setmusicstate("RADAR_FIGHT_DONE");
	}
	
	flag_set("stair_dead");
	
	level thread vo_before_comm();
	
	flag_wait("at_hinges");  //set by trigger at shoot hinges door
	flag_wait("stackup");
	
	guys = getaiarray("axis");
	
	for(i=0; i<guys.size; i++)
	{
		guys[i] thread bloody_death(true, 0);  //kill off ai to progress to knife throw
		wait(0.1);
	}
}


wait_for_weaver()
{
	trigger = getent("trigger_weaver_knife", "targetname");
	trigger waittill("trigger");
	
	flag_set("weaver_knife");
}


// Check if gaz guys are still alive when the player approaches the snowcat shed
check_gaz_guys()
{
	trigger_wait("triggercolor_approach");
	
	guys = getentarray("gaz_guys_ai", "targetname");
	
	if(guys.size > 0 )
	{
		flag_set("area_alerted");
	}
}


monitor_shovelers()
{
	guys = getentarray("shovelers_ai", "targetname");
	
	while(guys.size > 0)
	{
		guys = getentarray("shovelers_ai", "targetname");
		wait(0.1);
	}
	
	flag_set("shovelers_dead");
}


color_chain_approach()
{
	flag_wait( "jump_down" );
	
	trigger_use("triggercolor_jump_down");
		
	flag_wait( "crossroad" );
	
	wait(0.1);
	
	trigger_use("triggercolor_crossroad");
	
	flag_wait( "approach" );
	
	wait(0.1);
	
	trigger_use("triggercolor_to_radar");
	
	flag_wait("shovelers_dead");
	
	wait(0.1);
	
	trigger_use("triggercolor_weaver_closer");
	
	flag_wait( "stackup" );
	
	wait(0.1);
	
	trigger_use("triggercolor_stack_up");
}


down_to_door()
{
	flag_wait("hinge_breach");
	
	level.weaver.ignoreme = false;
	level.brooks.ignoreme = false;
	level.harris.ignoreme = false;
	player = get_players()[0];
	player.ignoreme = false;
	
	flag_wait( "stackup" );
	flag_wait("stair_dead");
	
	wait(0.5);
	
	if (!flag("area_alerted"))
	{
		get_players()[0] giveachievement_wrapper("SP_LVL_WMD_RELAY");
	}
	
	trigger_use("triggercolor_to_door");
	
	// ALEXP 4/5/10: don't let weaver play a turn animation
	// that prevents him from playing a cover arrival animation here
	level.weaver disable_turns_until_next_goal();
	
	level.harris waittill("goal");
	
	wait(1.0);
	
	pos1 = getstruct("stairs_aim1", "targetname");
	
	aim1 = spawn("script_origin", pos1.origin);
	
	level.harris aim_at_target(aim1);
	
	flag_wait("breach_begin");
	
	level.harris stop_aim_at_target();
}


disable_turns_until_next_goal()
{
	self.disableTurns = true;
	self waittill("goal_changed");
	self waittill("goal");
	self.disableTurns = false;
}


// Opens garage door for snow cat /////////////////////////////////////////////////////////////////////
open_garage_door()
{
	garage = getstruct("occlude_garage", "targetname");
	
	SetCellVisibleAtPos(garage.origin);
	
	door1 = getent( "garage_door1", "targetname" );
	door2 = getent( "garage_door2", "targetname" );
	door3 = getent( "garage_door3", "targetname" );
	door4 = getent( "garage_door4", "targetname" );
	
	door1 connectpaths();
	door2 connectpaths();
	door3 connectpaths();
	door4 connectpaths();
	
	door1 movez( 28, 2.0 );
	door2 movez( 56, 4.0 );
	door3 movez( 84, 6.0 );
	door4 movez( 84, 6.0 );
	
	door1 waittill( "movedone" );
	door1 delete();
	
	door2 waittill( "movedone" );
	door2 delete();
	
	door3 waittill( "movedone" );
	door3 delete();
}


// Smoking guy /////////////////////////////////////////////////////////////////////////////////////////////////
setup_smoker()
{
	self endon( "death" );
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
	
	self endon("death");
	self endon("alert");
	self endon("damage");
	
	node = getent("smoker_align","targetname");
	
	self.animname ="smoker";
	barrel = ent_get("smoker_barrel");
	
	model = spawn("script_model",node.origin);
	model setmodel("tag_origin_animate");
	model.animname = "barrel";	
	model useanimtree(level.scr_animtree["door"]);
	
	self.align_node = node;
	self.barrel = barrel;
	self.barrel_linkto = model;
	
	self thread smoker_react();
	self thread smoker_alerted();
	//self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	barrel thread barrel_explode();
	self thread smoker_stopanim();

	barrel.origin = node.origin;
	barrel linkto(model,"origin_animate_jnt");
	
	anim_ents = array(self, model);
	
	model thread stop_barrel(barrel);
	
	trigger_wait("trigger_radar_installation");
	
	level.on_barrel = false;
	
	level thread check_smoker_anim();
	
	node anim_single_aligned(anim_ents,"cig_break");
	
	if (!flag("area_alerted"))
	{
		node thread anim_loop_aligned(self,"cig_break_idle");
	}
}


check_smoker_anim()
{
	animtime = GetAnimLength(level.scr_anim["smoker"]["cig_break"]);
	
	wait(animtime);
	
	level.on_barrel = true;
}


stop_barrel(barrel)	//self = barrel model
{
	flag_wait("shed_alerted");
	
	wait(1.5);
	
	self stopanimscripted();
	
	if (isdefined(barrel))
	{
		barrel unlink();
		barrel physicslaunch (barrel.origin, (5, 5, -10));
	}
}


barrel_explode()
{
	self setcandamage( true );
	self waittill( "damage" );
	
	playfx(	level._effect["barrel_exp"], self.origin );
	
	RadiusDamage(self.origin, 200, 500, 50, get_players()[0], "MOD_EXPLOSIVE", "crossbow_explosive_alt_sp");
	
	trig = getent( "trigger_barrel_exp", "targetname" );
	
	guys = getaiarray( "axis" );
	
	for( i=0; i<guys.size; i++ )
	{
		if ( guys[i] isTouching( trig ) )
		{
			vec = VectorNormalize( guys[i].origin - self.origin );
			guys[i] startragdoll();
			guys[i] dodamage( guys[i].health, guys[i].origin );
			guys[i] LaunchRagdoll(( vec*90 ) + ( 0, 0, 90 ));
		}
	}
	
	wait(0.05);
	
	physicsExplosionSphere(self.origin + (0, 0, -100), 100, 100, 3.0);
	
	playsoundatposition("exp_veh_large", self.origin);
	
	self delete();
	
	wait(0.5);
	
	flag_set( "area_alerted" );
}


smoker_react()
{
	self endon( "death" );
	
	self waittill_any( "alert", "bulletwhizby", "damage", "grenade danger" );
	
	flag_set("shed_alerted");
}


smoker_alerted()
{
	self endon( "death" );
	
	flag_wait( "area_alerted" );
	
	flag_set("shed_alerted");
}


smoker_stopanim()
{
	self endon("death");
	
	flag_wait("shed_alerted");
	
	wait(1.0);
	
	self stopanimscripted();
	
	self gun_recall();
	
	node = getent("smoker_align","targetname");
	
	if (level.on_barrel)
	{
		node anim_single_aligned(self, "cig_react");
	}
	else
	{
		self stopanimscripted();
	}
	
	if (!flag("area_alerted") && isAlive(self))
	{
		node = getnode("node_shed_guys", "targetname");
	
		self thread run_to_alert(node);
	}
	else
	{
		if (isAlive(self))
		{
			node = getnode("node_smoker", "targetname");
			self setgoalnode(node);
		}
	}
}


/*------------------------------------
rotates the big radar dish 
------------------------------------*/
rotate_radar_dish()
{
	flag_wait("all_players_spawned");
	
	dish = ent_get( "relay_radar_dish" );
	base = ent_get( "relay_radar_pivot" );
	move_sound_ent = getent ("dish_groan", "targetname");
	anim_ent = GetEnt( "fxanim_wmd_radar_mod", "targetname" );
	mdl_dish_animate = GetEnt( "fxanim_wmd_radar_mod", "targetname" );
	
	dish BypassSledgehammer();
	base BypassSledgehammer();
	
	// -- WWILLIAMS: ATTCH THE RADAR PIECES TO THE ANIMATE MODEL JOINTS
	dish LinkTo( mdl_dish_animate, "dish_top_jnt", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	base LinkTo( mdl_dish_animate, "dish_mid_jnt", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	wait( 0.05 );
	
	// -- WWILLAIMS: START THE FX ANIM FOR THE RADAR
	level notify( "radar01_start" );
}


left_side_setup()
{
	//the guy smoking in the shed
	smoker = simple_spawn("left_side_smoker",::setup_smoker);
	
	//the guy welding the radar dish - moved to shed - jpark
	welder = simple_spawn_single( "welder", ::setup_welder );
	
	trigger_wait("trigger_radar_installation");
	
	flag_set("choppers_alerted");
	
	simple_spawn_single( "radar_patroller", ::setup_radar_patrol );
}


// Shovelers /////////////////////////////////////////////////////////////////////////////////////////////////////
spawn_shovelers()
{
	shovelers = simple_spawn ("shovelers");
	
	node = getent( "shovel_align", "targetname" );
	
	shovel01 = ent_get ("shovel01", "script_noteworthy");
	shovel02 = ent_get ("shovel02", "script_noteworthy");
	shovel01 useanimtree(level.scr_animtree["shovel01"]);
	shovel01.animname  = "shovel01";
	shovel02 useanimtree(level.scr_animtree["shovel02"]);
	shovel02.animname  = "shovel02";
	
	guy01 = shovelers[0];
	guy01.animname = "grd01_shoveling";
	guy01 thread shovel_guy_logic( shovel01, node );
	
	guy02 = shovelers[1];
	guy02.animname = "grd02_shoveling";
	guy02 thread shovel_guy_logic( shovel02, node );

	//create array for the animation (one for each guy)
	anim_ents =  array(guy01, shovel01);
	anim_ents2 =  array(guy02, shovel02);
	
	//play anim scene
	if (!flag("area_alerted"))
	{
		node thread anim_loop_aligned(anim_ents, "shoveling");	
		node thread anim_loop_aligned(anim_ents2, "shoveling");	
	}
	
	wait(0.1);
	
	level thread kill_shovelers();
	level thread monitor_shovelers();
}


shovel_guy_logic( shovel, node )
{
	self gun_remove();
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.allowdeath = true;
	
	//self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	self thread shoveler_react( shovel, node );
	self thread shoveler_alerted( shovel, node );
	self thread shovel_stop(shovel);
	self thread shoveler_stopanim(shovel);
}


shoveler_react( shovel, node )
{
	self endon("death");
	
	self waittill_any("bulletwhizby","alert","damage","grenade_danger");
	
	flag_set("shoveler_alerted");
}


shoveler_alerted( shovel, node )
{
	self endon("death");
	
	flag_wait("area_alerted");
	
	flag_set("shoveler_alerted");
}


shoveler_stopanim(shovel)
{
	self endon("death");
	
	flag_wait("shoveler_alerted");
	
	wait(1.0);
	
	node = getent("shovel_align", "targetname");
	
	self gun_recall();
	
	node anim_single_aligned(self, "shoveling_alert");
	
	if (!flag("area_alerted") && isAlive(self))
	{
		node = getnode("node_shovel_guys", "targetname");
	
		self thread run_to_alert(node);
	}
	else
	{
		if (isAlive(self))
		{
			self set_spawner_targets("shoveler");
		}
	}
}


shovel_stop(shovel)
{
	flag_wait_any("shoveler_alerted", "area_alerted");
	
	shovel stopanimscripted();
	
	shovel physicslaunch (shovel.origin, (5,5,5));
}


// Welding guy //////////////////////////////////////////////////////////////////////////////////////////////////////
setup_welder()
{
	self endon("death");
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
	
	self thread welder_sound();
	self thread welding_fx();
	//self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	self thread welder_react();
	self thread welder_alerted();
	self thread vo_welder();
	self thread welder_stopanim();
	
	//self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");
	
	node = getnode(self.target,"targetname");
	self.reaction_node = (node);
	self.animname = "welder";
	node thread anim_loop_aligned(self, "weld");
}


welder_sound()
{
	welder_ent = spawn ("script_origin", self.origin);
	welder_ent playloopsound("evt_weld");
	
	self waittill_any( "alert", "bulletwhizby", "damage", "grenade danger", "death");
	welder_ent stoploopsound(0);
	
	welder_ent delete();
}


welder_react()
{
	self endon( "death" );
	
	self waittill_any( "alert", "bulletwhizby", "damage", "grenade danger" );
	
	flag_set("shed_alerted");
}



welder_alerted()
{
	self endon( "death" );
	
	flag_wait( "area_alerted" );
	
	flag_set("shed_alerted");
}


welder_stopanim()
{
	self endon("death");
	
	flag_wait("shed_alerted");
	
	wait(1.0);
	
	node = getnode(self.target,"targetname");
	self.reaction_node = (node);
	self.animname = "welder";
	node anim_single_aligned(self, "alert");
	
	//self stopanimscripted();
	
	self gun_recall();
	
	if (!flag("area_alerted") && isAlive(self))
	{
		node = getnode("node_shed_guys", "targetname");
	
		self thread run_to_alert(node);
	}
	else
	{
		if (isAlive(self))
		{
			node = getnode("node_welder", "targetname");
			self setgoalnode(node);
		}
	}
}


welding_fx()
{
	self endon("death");
	self endon("alert");
	self endon("damage");
	self endon("grenade");
	self endon("grenade danger");
	
	point = getstruct( "welding_fx", "targetname" );
	
	while(1)
	{
		playfx(	level._effect["garage_sparks"],point.origin);
		wait(randomfloatrange(.15,.75));
	}
}


// Gaz guys //////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree("generic_human");
gaz_guys_setup()
{
	gaz_guys = simple_spawn ( "gaz_guys", ::gaz_guys_init );
}


gaz_guys_init()
{
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
	
	self clearenemy();
	self gun_remove();
	self.dropweapon = 0;	
	
	self thread gaz_guys_react();
	//self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
}


gaz_guys_react()
{
	self endon("death");
	
	self waittill_any( "damage","bulletwhizby","grenade danger","alert" );
	
	flag_set("gaz_alerted");
}


ice_scrapers_init()
{
	//truck acts as align node
	truck = ent_get("scrape_gaz");
	truck thread gaz_physics_launch();
	
	//gas can
	can = ent_get("gaz_can");
	can.origin = truck.origin;
	can.angles = truck.angles;
	model = spawn("script_model",truck.origin);
	model.angles = truck.angles;
	model setmodel("tag_origin_animate");
	
	can init_anim_model("gascan", true);
	
	can thread can_stop_anim();
	
	guy_01 = getai_by_noteworthy("scraper_1");
	guy_02 = getai_by_noteworthy("scraper_2");	
	
	guy_01 thread ice_scraper_animate(truck);
	guy_02 thread refuel_animate(truck,model,can);		
}


ice_scraper_animate(truck)
{
	self endon ("death");
	
	self.animname = "scraper";
	
	truck thread anim_loop_aligned(self, "scrape_loop");
	
	flag_wait("gaz_alerted");
	
	wait(1.0);
	
	self gun_recall();
	
	anim_single(self, "scrape_react");
	
	if (!flag("area_alerted") && isAlive(self))
	{
		node = getnode("node_gaz_guys", "targetname");
	
		self thread run_to_alert(node);
	}
	else
	{
		if (isAlive(self))
		{
			node = getnode("node_scraper", "targetname");
			self setgoalnode(node);
		}
	}
}


refuel_animate(truck, model, can)
{
	self endon ("death");
	
	self.animname = "fueler";
	
	ents = array(self, can);
	
	truck thread anim_loop_aligned(ents, "fueler_loop");
	
	flag_wait("gaz_alerted");
	
	wait(1.0);
	
	self stopanimscripted();
	
	self gun_recall();
	
	anim_single(self, "fueler_react");
	
	if (!flag("area_alerted") && isAlive(self))
	{
		node = getnode("node_gaz_guys", "targetname");
	
		self thread run_to_alert(node);
	}
	else
	{
		if (isAlive(self))
		{
			node = getnode("node_fueler", "targetname");
			self setgoalnode(node);
		}
	}
}


can_stop_anim()
{
	flag_wait("gaz_alerted");
	
	wait(0.1);
	
	self unlink();
	self physicslaunch(self.origin, (10, 10, 10));
}


// snowcat guys /////////////////////////////////////////////////////////////////////////////////////////////
setup_snowcat_driver()
{
	self endon("death");
	
	self thread maps\_stealth_logic::enemy_corpse_death();
	
	self thread garage_worker_react();
	
	self.animname = "snowcat_driver";
	
	flag_wait("snowcat_arrived");
	
	self unlink();
	
	snowcat = getent("snowcat", "targetname");
	
	snowcat anim_single_aligned(self, "exit_snowcat");
	
	if (!flag("area_alerted"))
	{
		if (isAlive(self))
		{
			anim_node = getstruct("garage_work_pos", "targetname");
			
			self.animname = "working_guard_1";
			
			anim_node anim_reach_aligned(self, "working_loop");
			
			self gun_remove();
			
			anim_node thread anim_loop_aligned(self, "working_loop");
			
			level.passenger_working = true;
		}
	}
}


setup_snowcat_passenger()
{
	self endon("death");
	
	self contextual_melee(false);
	
	self thread monitor_passenger();
	
	self.animname = "snowcat_pass";
	
	flag_wait("snowcat_arrived");
	
	self unlink();
	
	snowcat = getent("snowcat", "targetname");
	
	snowcat anim_single_aligned(self, "exit_snowcat");
	
	self gun_recall();
}


setup_snowcat()  //self = snowcat
{
	level.passenger_working = false;
	
	self.dontunloadonend = 1;
	
	self waittill("reached_end_node");
	
	flag_set("snowcat_arrived");
	
	self.animname = "snowcat";
	self useanimtree(level.scr_animtree[ "snowcat" ] );
		
	level thread snowcat_guys_exited();
	
	self anim_single_aligned(self, "exit_snowcat");
}


monitor_passenger()
{
	self waittill("death");
	
	flag_set("passenger_dead");
}


garage_worker_react()
{
	self endon("death");
	
	flag_wait_any("area_alerted", "snowcat_alerted");
	
	self.ignoreall = false;
	
	self gun_recall();
	
	if (level.passenger_working)
	{
		self anim_single_aligned(self, "working_react");
	}
}


snowcat_guys_exited()
{
	wait(7.0);
	
	flag_set("snowcat_exited");
}


setup_sc_guy()
{
	self endon( "death" );
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
	
	flag_wait("snowcat_exited");
	
	//self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	self thread snowcat_react();
	self thread snowcat_alerted();
	self thread snowcat_set_alert();
}


snowcat_react()
{
	self endon("death");
	
	self waittill_any ("bulletwhizby","alert","damage","grenade_danger");
	
	flag_set("snowcat_alerted");
	
	self clear_run_anim();
	
	self stopanimscripted();
}


snowcat_alerted()
{
	self endon("death");
	
	flag_wait( "area_alerted" );
	
	flag_set("snowcat_alerted");
	
	self clear_run_anim();
	
	self stopanimscripted();
}


snowcat_set_alert()
{
	flag_wait("snowcat_alerted");
	
	wait(1.0);
	
	flag_set("area_alerted");
}


// wood choppers /////////////////////////////////////////////////////////////////////////////////////////////
choppers_spawnfunc()
{
	self endon( "death" );
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
		
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	self thread alert_choppers();
	self thread alert_other_chopper();
	self thread bloody_kill();
	self thread check_weapon_used();
	self thread run_for_help();
}


setup_woodchoppers()
{	
	node = getent( "align_wood_choppers", "targetname" );
	node.angles = ( 0, 0 ,0 );
	
	axe = ent_get("axe");
	axe.animname = "axe";
	axe.origin = node.origin;
	axe.angles = node.angles;
	axe useanimtree(level.scr_animtree["axe"]);
	
	wood1 = ent_get("wood1");
	wood2 = ent_get("wood2");
	wood1.animname = "wood01";
	wood2.animname = "wood02";
	wood1 useanimtree(level.scr_animtree["wood01"]);
	wood2 useanimtree(level.scr_animtree["wood02"]);
	
	choppers = simple_spawn ( "wood_choppers", ::choppers_spawnfunc );
	array_thread(choppers, ::woodchopper_init,axe);
	
	ents = [];
	for(i=0;i<choppers.size;i++)
	{
		ents[ents.size] = choppers[i];
	}
	ents[ents.size] = axe;	
	ents[ents.size] = wood1;
	ents[ents.size] = wood2;
	wood1.node = node;
	node thread anim_loop_aligned(ents,"chop",undefined,"stop_chopping");	
	node thread wheelbarrow_anim();
	
	flag_set( "target_choppers" );
	
	level thread check_choppers();
}


woodchopper_init(axe,model)
{
	self.allowdeath = true;
	//self gun_remove();
	
	if(self.script_noteworthy == "chopper_1")
	{
		self.animname = "chopper_1";
		self thread woodchopper_death(axe);
		self thread woodchopper_alerted( axe );
	}
	else
	{
		self.animname = "chopper_2";
		self thread woodchopper_death();
		self thread woodchopper_alerted( axe );
		self thread barrow_guy_death();
		self.deathanim = level.scr_anim["chopper_2"]["chop_death"];
	}	
}


woodchopper_death( axe )
{
	self endon( "death" );
	
	self waittill_any( "alert", "bulletwhizby", "damage", "grenade danger" );
	
	flag_set("choppers_alerted");
	
	//self stop_woodchopper_anim( axe );
}


woodchopper_alerted( axe )
{
	self endon( "death" );
	
	flag_wait("choppers_alerted");
	
	self thread stop_woodchopper_anim( axe );
	
	self.maxsightdistsqrd = self.old_sightdist;
	self.ignoreall = false;
}


stop_woodchopper_anim( axe )
{
	self endon("death");
	
	self anim_single(self, "chop_alert");
	
	//self gun_recall();
	
	flag_set("kill_chopper");
}


alert_choppers()
{
	self endon("death");
	
	self waittill( "alert" );
	
	flag_set("lerp_squad");
	
	wait( 0.5 );
	
	flag_set( "choppers_alerted" );
}


alert_other_chopper()
{
	self waittill( "death" );
	
	flag_set("lerp_squad");
	
	wait(1.0);
	
	flag_set( "choppers_alerted" );
}


wood_axe_physics()
{
	flag_wait("choppers_alerted");
	
	org = ent_get("align_wood_choppers");
	wood1 = ent_get("wood1");
	wood2 = ent_get("wood2");
	
	org notify("stop_chopping");
	
	wood1 anim_stopanimscripted();
	wood2 anim_stopanimscripted();
	wood1 physicslaunch(wood1.origin, (0, 0, 0));
	wood2 physicslaunch(wood2.origin, (0, 0, 0));	
	
	axe = ent_get("axe");
	
	if(isDefined(axe))
	{
		axe anim_stopanimscripted();
		axe physicslaunch(axe.origin, (0, 0, 0));
	}
}


bloody_kill()
{
	self waittill("damage");
	
	flag_set("kill_chopper");
	
	self thread bloody_death(true, 0);
}


barrow_guy_death()
{
	self waittill("death");
	
	if (!flag("choppers_alerted"))
	{
		flag_set("go_wheelbarrow");
	}
}


wheelbarrow_anim()
{
	linker = Spawn( "script_model", self.origin );
	linker.angles = self.angles;
	linker SetModel( "tag_origin_animate" );
	linker.animname = "wheelbarrow";
	linker useanimtree(level.scr_animtree["wheelbarrow"]);
	
	wheelbarrow = getent("wheelbarrow", "targetname");

	wheelbarrow.origin = linker GetTagOrigin( "origin_animate_jnt" );
	wheelbarrow.angles = linker GetTagAngles( "origin_animate_jnt" );
	wheelbarrow linkto( linker, "origin_animate_jnt" );

	self thread anim_loop_aligned( linker, "barrow_idle" );
	flag_wait("go_wheelbarrow");
	self thread anim_single_aligned(linker, "barrow_death");
	
	wait(3.5);
	
	playfx(	level._effect["snow_puff_land"], wheelbarrow.origin + (15, 0, 0) );
	physicsExplosionSphere(wheelbarrow.origin, 80, 80, 0.15);
}


check_weapon_used()
{
	self waittill("damage", amount, inflictor, direction, point, type, modelName, tagName);
	
	if (IsPlayer(inflictor))
	{	
		inflictor_weapon = inflictor GetCurrentWeapon();
		
		if (inflictor_weapon == "crossbow_explosive_alt_sp")
		{
			flag_set("area_alerted");
		}
	}
}


run_for_help()
{
	self endon("death");
	
	flag_wait("choppers_alerted");
	
	self thread force_goal();
	
	node = getnode("node_chopper_runto", "targetname");
	
	self.goalradius = 200;
	
	self setgoalnode(node);
	
	self waittill("goal");
	
	flag_set("area_alerted");
}


setup_radar_patrol()
{
	self contextual_melee(false);
	self.dofiringdeath = false;
	self.allowdeath = true;
}


setup_roof_patrol()
{
	self endon( "death" );
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.dofiringdeath = false;
	self.allowdeath = true;
	self.dropWeapon = false;
	self.stayinplace = true;
	
	wait( 1.0 );
	
	self thread alert_installation();
	self thread check_shot_at();
	self thread check_if_sighted();
	self thread ai_alerted();
	self thread monitor_snowcat_passenger();
}


monitor_snowcat_passenger()
{
	self endon("death");
	
	flag_wait("passenger_dead");
	
	wait(1.0);
	
	self notify("alert");
}


// Check for player detection /////////////////////////////////////////////////////////////////////////////
alert_installation()
{
	self endon("death");
	
	self waittill( "alert" );
	
	wait( 0.5 );
	
	flag_set( "area_alerted" );  //player has one second to kill ai before alert is set, see "check_shot_at"
	flag_set( "jump_down" );
}


check_shot_at()
{
	self endon( "death" );
	self endon( "melee_victim" );
	
	self waittill_any( "damage", "grenade danger", "explode", "bulletwhizby" );
	
	wait( 1.0 );
	
	//self alert_notify_wrapper();
	self notify("alert");
}


ai_alerted()
{
	self endon( "death" );
	
	flag_wait( "area_alerted" );
	
	//self alert_notify_wrapper();
	self notify("alert");
	
	self.maxsightdistsqrd = self.old_sightdist;
	self.ignoreall = false;
	self.goalradius = 2048;
}


check_if_sighted()
{
	self endon( "death" );
	self endon( "melee_victim" );
	self endon( "alert" );
	
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			
			stance = players[i] getstance() ;
			dist = distancesquared( players[i].origin,self.origin);

				
			if(dist <= 128*128)					// alert if the player stands up within a 128 unit radius, otherwise no pose is safe if the guard can see the player
			{
				if( stance == "stand" && self can_see_player( players[i] ) )
				{
					//wait(1);
					//self thread print3d_group_sight();
					//self alert_notify_wrapper();
					self notify("alert");
				}
				else if (self can_see_player(players[i]))
				{
					//wait(1);
					//self thread print3d_group_sight();
					//self alert_notify_wrapper();
					self notify("alert");
				}
			}	
			else if(dist <= 512*512)		//only alert if the player is NOT proned and the guard has line of sight. If the player is prone, we dont' care if he's with a 512 unit radius
			{
				if(stance != "prone" && self can_see_player(players[i]))
				{
					//wait(1);
					//self thread print3d_group_sight();
					//self alert_notify_wrapper();
					self notify("alert");
				}
			}			
		 	else if(dist <= 1024*1024)	//only alert if the player is standing within 1024 units and the guard has line of sight
			{
				if( stance == "stand" && self can_see_player(players[i]))
				{
					//wait(1);
					//self thread print3d_group_sight();
					//self alert_notify_wrapper();
					self notify("alert");
				}
			}
		}
		wait(.1);
	}
	
}


// Enemies spawn as the player progresses towards the radar if stealth is broken
check_alert_one()
{
	level endon("stackup");
	
	trigger = getent("trigger_jump_down", "targetname");
	player = get_players()[0];
	
	while(player isTouching(trigger))
	{
		guys = getaiarray("axis");
		
		if(flag("area_alerted") && guys.size < 5)
		{
			spawn_manager_enable("manager_jump_down");
			break;
		}
		wait(0.1);
	}
}


check_alert_two()
{
	level endon("stackup");
	
	vol = getent("vol_crossroad", "targetname");
	player = get_players()[0];
	
	while(1)
	{
		if(player isTouching(vol))
		{
			//flag_set("crossroad");
			spawn_manager_kill("manager_jump_down");
			
			if (flag("area_alerted"))
			{
				wait(1.0);
				spawn_manager_enable("manager_crossroad");
				break;
			}
		}
		wait(0.1);
	}
}


check_alert_three()
{
	level endon("stackup");
	
	vol = getent("vol_approach", "targetname");
	player = get_players()[0];
	
	while(1)
	{
		if(player isTouching(vol))
		{
			flag_set("kill_spawns");
			spawn_manager_kill("manager_crossroad");
			
			if (flag("area_alerted"))
			{
				spawn_manager_enable("manager_approach");
				break;
			}
		}
		wait(0.1);
	}	
}


// launches gaz truck into air, self = truck
gaz_physics_launch()
{
	level endon("weaver_knife");
	self endon("truck_boom");
	
	self thread check_crossbow_explosive();
	self thread truck_go_boom();
	
	tank = getent( "tanker", "targetname" );
	
	tank.health = 400;
	tank.origin = self.origin;
	tank.angles = self.angles;
	tank linkto(self);
	tank setcandamage(true);
	
	self SetBrake(1);
	
	while(1)
	{
		tank waittill("damage", amount, inflictor, direction, point, type, modelName, tagName);
		
		if (isPlayer(inflictor))
		{
			inflictor_weapon = inflictor GetCurrentWeapon();
			
			if (inflictor_weapon == "crossbow_vzoom_alt_sp")
			{
				wait(0.05);
			}
			
			else if (inflictor_weapon == "crossbow_explosive_alt_sp")
			{
				wait(1.5);
				flag_set("truck_boom");
				break;
			}
			
			else
			{
				flag_set("truck_boom");
				break;
			}
		}
		
		wait(0.05);
	}
}


check_crossbow_explosive()
{
	self endon("death");
	
	while(1)
	{
		self waittill("damage", amount, inflictor, direction, point, type, modelName, tagName);
	
		if (IsPlayer(inflictor))
		{	
			inflictor_weapon = inflictor GetCurrentWeapon();
			
			if (inflictor_weapon == "crossbow_explosive_alt_sp")
			{
				//wait(1.5);
				flag_set("truck_boom");
				break;
			}
		}
		
		if (type == "MOD_EXPLOSIVE" || type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE_SPLASH")
		{
			flag_set("truck_boom");
			break;
		}
		
		wait(0.05);
	}
}


truck_go_boom()
{
	trig = getent( "gaz_explosion_vicinity", "targetname" );
	node = getnodearray( "gaz_node", "targetname" );
	tank = getent( "tanker", "targetname" );
	
	force = ( 0, 0, 100 );
	hitpos = ( 0, 0, -50 );
	
	flag_wait("truck_boom");
		
	guys = getaiarray( "axis" );
			
	for( i=0; i<guys.size; i++ )
	{
		if ( guys[i] isTouching( trig ) )
		{
			vec = VectorNormalize( guys[i].origin - self.origin );
			guys[i] startragdoll();
			guys[i] dodamage( guys[i].health, guys[i].origin );
			guys[i] LaunchRagdoll( ( vec*200 ) + ( 0, 0, 150 ) );
		}
	}
				
	playfx(	level._effect["gaz_exp"], self.origin );
	playfx(	level._effect["gaz_firebig"], self.origin );
				
	playsoundatposition ("evt_scape_gaz_explosion", tank.origin);
				
	fire_ent = spawn ("script_origin", tank.origin);
				
	fire_ent playloopsound ("amb_fire_large");
				
	exploder(70);
	
	tanker = spawn("script_model", tank.origin);
	tanker SetModel("t5_veh_gaz66_tanker_dead");
	tanker.angles = tank.angles;
	tank delete();
	
	// SUMEET - if player dies by this radius damage then we need to display proper death hint		
	// setting this variable will cause fake vehicle damage and hint will be disaplayed properly
	tanker.create_fake_vehicle_damage = true;

	RadiusDamage( self.origin, 100, self.health, self.health, tanker );
	physicsExplosionSphere(trig.origin + (0,0,-100), 300, 300, 7.0);
	//self LaunchVehicle(force, hitpos, true, true);
			
	player = get_players()[0];
	earthquake(0.6, 1, player.origin, 500);
	
	self disconnectpaths();
			
	wait( 0.3 );
				
	level notify("tanker_tree_start");
				
	tree_clip = getent("brokentree_collision", "targetname");
	tree_clip trigger_on();
			
	flag_set( "area_alerted" );
	
	wait(0.2);
	
	truck = spawn("script_model", self.origin);
	truck SetModel("t5_veh_gaz66_dead");
	truck.angles = self.angles;
	self delete();
}
 
 
//VO setup/////////////////////////////////////////////////////////////////////////////////
vo_choppers()	//self = weaver
{
	self.animname = "weaver";
	
	trigger_wait("trigger_weaver_pickone");
	
	wait(1.5);
	
	if (Distance2DSquared(self.origin, get_players()[0].origin) < (400*400))
	{
		self anim_single(self, "pick"); //Pick one.
	}
}


vo_russian_choppers()
{
	level endon("choppers_alerted");
	
	flag_set("approach_choppers");
	
	wait(2.0);
	
	guys = getentarray("wood_choppers_ai", "targetname");
	
	guys[0].animname = "chopper_1";
	guys[1].animname = "chopper_2";
	
	guys[0] anim_single(guys[0], "soviet4");		//(Translated) How much more?
	
	wait(0.5);
	
	if (isAlive(guys[1]))
	{
		guys[1] anim_single(guys[1], "soviet5");		//(Translated) The captain didn't say. We keep going until we're told to stop, got  it?
	}
	
	wait(0.5);
	
	if (isAlive(guys[0]))
	{
		guys[0] anim_single(guys[0], "soviet6");		//(Translated) Of course. I bet he's warm.
	}
}


vo_approach()
{
	level endon("area_alerted");
	
	player = get_players()[0];
	player.animname = "hudson";
	level.brooks.animname = "brooks";
	level.weaver.animname = "weaver";
	
	wait(2.0);
	
	if (!flag("area_alerted"))
	{
		player anim_single(player, "approach");	//Kilo One is approaching the objective.
		
		wait(0.5);
		
		player anim_single(player, "copy");	//Copy.
		
		wait(0.5);
		
		player anim_single(player, "multiple");	//Kilo one, you have multiple targets at the Comstat. Take the storage shed on the south side then head to the power room entrance to the north.
		
		wait(0.5);
		
		player anim_single(player, "copy_that");	//Copy that.
		
		wait(0.5);
		
		level.brooks anim_single(level.brooks, "crossbow");	//Hudson, we need to keep this stealthy. Use your crossbow. If we get heat, switch to explosives.
		
		wait(0.5);
		
		level.weaver anim_single(level.weaver, "patrol_shed");	//One target patrolling outside the shed - two more inside
		
		wait(0.5);
		
		player anim_single(player, "by_truck");	//Two more by the truck on our right...
		
		wait(0.5);
		
		player anim_single(player, "gantry");	//One more on the right Gantry,
		
		wait(0.5);
		
		player anim_single(player, "ok_movein");	//Okay... Move in.
		
		level notify("close_to_base");
	}
}


vo_welder()
{
	self endon("death");
	self endon("alert");
	
	self.animname = "welder";
	
	while((DistanceSquared(get_players()[0].origin, self.origin) > 975 * 975))
	{
		wait(0.1);
	}
	
	self anim_single(self, "sit_there"); //(Translated) Are you just going to sit there?
}


vo_gaz_guys()
{
	level endon("area_alerted");
	
	scraper = getai_by_noteworthy("scraper_1");
	fueler = getai_by_noteworthy("scraper_2");
	
	scraper.animname = "scraper";
	fueler.animname = "fueler";
	
	wait(0.1);
	
	while((DistanceSquared(get_players()[0].origin, fueler.origin) > 1050 * 1050)  && isAlive(fueler) && isAlive(scraper))
	{
		wait(0.1);
	}
	
	if (isAlive(fueler))
	{
		fueler anim_single(fueler, "soviet8"); //(Translated) It must be 50 below.
		wait(0.5);
	}
	
	if (isAlive(scraper))
	{
		scraper anim_single(scraper, "soviet9"); //(Translated) Not even close.
		wait(0.5);
	}
	
	if (isAlive(fueler))
	{
		fueler anim_single(fueler, "soviet10"); //(Translated) The gasoline is FROZEN.
		wait(0.5);
	}
	
	if (isAlive(scraper))
	{
		scraper anim_single(scraper, "soviet11"); //(Translated) It is cold. I'm not saying it's not. But 50 below? We'd be dead.
		wait(0.5);
	}
	
	if (isAlive(fueler))
	{
		fueler anim_single(fueler, "soviet12"); //(Translated) I AM dead. As dead as this fucking car.
		wait(0.5);
	}
}


vo_area_alerted()
{
	level endon("stackup");
	
	flag_wait("area_alerted");
	
	level notify("close_to_base");
	
	//TUEY setting music to Post Breach (which has the breech state in it)
	setmusicstate("FIGHT");
	
	level thread maps\wmd_amb::play_radar_alert();
	
	wait(1.0);
	
	level.weaver anim_single(level.weaver, "trig_alarm");		//SHIT! They've triggered the Alarm!
	
	wait(0.3);
	
	guys = getaiarray("axis");
	
	if (guys.size > 1)
	{
		player = get_players()[0];
		player.animname = "hudson";
		player anim_single(player, "weapons");	//Weapons free!!
		
		wait(0.5);
		
		level.weaver anim_single(level.weaver, "infantry");		//More infantry inbound!
			
		wait(0.5);
			
		currentweapon = player GetCurrentWeapon();
		
		if(currentweapon != "crossbow_explosive_alt_sp")
		{
			level.brooks.animname = "brooks";
			level.brooks anim_single(level.brooks, "bolts");	//Hudson! switch to your explosive bolts!
			
			flag_set("explosive_hint");
		}
	}
}


vo_before_comm()
{
	wait(1.0);
	
	player = get_players()[0];
	player anim_single(player, "two_targets");	//Kilo, two targets just entered the power room.
	
	wait(0.5);
	
	player = get_players()[0];
	player anim_single(player, "copy_that");	//Copy that BigEye.
}


lerp_squad()
{
	flag_wait("lerp_squad");
	
	if (!flag("lerp_squad_check"))
	{
		level.weaver notify ("killanimscript");
		level.weaver setgoalpos(level.weaver.origin);
		
		level.brooks notify ("killanimscript");
		level.brooks setgoalpos(level.brooks.origin);
		
		level.harris notify ("killanimscript");
		level.harris setgoalpos(level.harris.origin);
				
		wait(0.1);
		
		level.weaver AnimCustom(::weaver_teleport);
		level.brooks AnimCustom(::brooks_teleport);
		level.harris AnimCustom(::harris_teleport);
		
		wait(1.0);
		
		trigger_use("triggercolor_post_teleport");
		
		wait(5.0);
		
		guys = getentarray("wood_choppers_ai", "targetname");
		
		if (isAlive(guys[0]))
		{
			level.weaver thread shoot_and_kill(guys[0]);
		}
		
		if (isAlive(guys[1]))
		{
			level.brooks thread shoot_and_kill(guys[1]);
		}
	}
}


weaver_teleport()
{
	pos = getstruct("lerp_squad_pos1", "targetname");
	
	self ClearAnim(%root, 0);
	
	wait(0.1);
	
	self forceteleport(pos.origin);
}


brooks_teleport()
{
	pos = getstruct("lerp_squad_pos2", "targetname");
	
	self ClearAnim(%root, 0);
	
	wait(0.1);
	
	self forceteleport(pos.origin);
}


harris_teleport()
{
	pos = getstruct("lerp_squad_pos3", "targetname");
	
	self ClearAnim(%root, 0);
	
	wait(0.1);
	
	self forceteleport(pos.origin);
}


vo_under_attack()
{
	level endon("stackup");
	
	flag_wait("area_alerted");
	
	player = get_players()[0];
	
	enemy = get_closest_ai(player.origin, "axis");
	
	ent = spawn("script_origin", enemy.origin);
	
	ent.animname = "soviet";
	
	ent anim_single(ent, "under_attack");
}