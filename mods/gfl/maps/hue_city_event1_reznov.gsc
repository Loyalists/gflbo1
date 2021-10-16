#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\hue_city;
#include maps\_vehicle_turret_ai;


#using_animtree("generic_human");
event1_reznov()
{
	exit_war_room();
	exit_macv();
	e1b_transition_cowbell();
	exit_event1();
}

event1d_start()
{
	level thread maps\hue_city_event1::reznov_door_breach_trig();
	
	// spawn woods
	level.squad = [];
	level.squad["woods"] = simple_spawn_single( "woods_struct_spawner" );
	bowman = GetEnt("macv_bowman_ai", "script_noteworthy") StalingradSpawn();
	
	bowman disable_ai_color();
	level.squad["woods"] disable_ai_color();
	
	tp_to_start("e1d");
	// give player a weapon
	get_players()[0] maps\hue_city_event1::skipto_give_player_weapon();
	
	exit_macv();
	e1b_transition_cowbell();
}	




exit_war_room()
{
	GetEnt("in_reznov_room", "targetname") endon ("trigger");
	
	trig = 	GetEnt("on_warroom_floor", "targetname");
	
	level thread stop_topfloor_spawners_when_player_in_pit();
	
	level thread send_warroom_stragglers_at_nearest_ally();
	
	waittill_ai_group_cleared("war_room_guys_1");
	
	loopit = 1;
	while(loopit > 0)
	{
		loopit = 0;
		guys = GetAIArray("axis");
		for (i=0; i < guys.size; i++)
		{
			if (IsDefined(guys[i]) && IsAlive(guys[i]) && guys[i] IsTouching(trig))
			{
				loopit++;
			}
			wait 0.05;
		}
		wait 0.05;
	}
	
	trig Delete();

	waittill_ai_group_cleared("macv_far_balcony_spawners");
	waittill_ai_group_cleared("war_room_downstair_guys");
	flag_set("war_room_clear");
	
	playsoundatposition( "evt_num_num_02_r" , (0,0,0) );
	
	//TUEY Set Music State to WAR_ROOM_CLEAR
	setmusicstate ("WAR_ROOM_CLEAR");
	
	autosave_by_name("to_reznov_hall");
	
	level.woods disable_ai_color();
	level.bowman disable_ai_color();
	
	level.woods.goalradius = 4;
	level.bowman.goalradius = 256;
	wait 0.2;
	
	woodsnode = GetNode("reznov_hall_start_woods_node", "targetname");
	level.bowman SetGoalNode(GetNode("reznov_hall_start_bowman_node", "targetname"));
	level.woods SetGoalNode(woodsnode);

	guys = [];
	guys[0] = level.woods;
	guys[1] = level.bowman;

	level.woods disable_cqbwalk();
	while(DistanceSquared(level.woods.origin, woodsnode.origin) > (320*320) )
	{
		wait 0.1;
	}
	level.woods enable_cqbwalk();

	level.woods waittill ("goal");
	
	trig = GetEnt("squad_breach_reznov_hall_trig", "targetname");
	looktrig = GetEnt("reznov_hall_looktrig", "targetname");
	
	while(1)
	{
		if ( get_players()[0] IsTouching(trig) && get_players()[0] IsLookingAt(looktrig) )
		{
			break;
		}
		wait 0.2;
	}
	
	level.woods.animname = "woods";
	level.bowman.animname = "bowman";
	
	struct = getstruct("reznov_hall_start_align_struct", "targetname");
	struct anim_reach_aligned(level.woods, "door_breach");
	struct thread anim_single_aligned(level.woods, "door_breach");
	
	wait 0.5;
	
	clip = GetEnt("reznov_hall_clip", "targetname");
	clip ConnectPaths();
	clip Delete();
	
	level.bowman enable_cqbwalk();
	level.bowman.goalradius = 4;
	bownode = GetNode("rh_bowman_breach_node", "targetname");
	level.bowman SetGoalNode(bownode);
	
	wait 0.5;
	door = GetEnt("reznov_hall_entrance_door", "targetname");
	door RotateYaw(100,0.7, 0, 0.7);
	door waittill ("rotatedone");
		
	flag_set("woods_breaching_reznov_hall");
		
	level.woods enable_cqbwalk();
	level.woods StopAnimScripted();
	
	
	level thread maps\hue_city_anim::reznov_hall_quickanim();
	
	level.woods.perfectaim = false;
	level.bowman.perfectaim = false;

	flag_wait("player_in_reznov_hall");
	maps\_door_breach::door_breach_set_viewmodel("t5_gfl_ump45_viewmodel_player");
	level thread nagline_overkill();
}

send_warroom_stragglers_at_nearest_ally()
{
	level endon("war_room_clear");
	
	group2 = get_ai_group_ai("macv_far_balcony_spawners");
	while(group2.size < 1)
	{
		group2 = get_ai_group_ai("macv_far_balcony_spawners");
		wait(1);
	}
	
	killed_stragglers = false;
	while(!killed_stragglers)
	{			
		group1 = get_ai_group_ai("war_room_guys_1");
		group2 = get_ai_group_ai("macv_far_balcony_spawners");
		group3 = get_ai_group_ai("war_room_downstair_guys");
		
		_group = array_combine(group1,group2);
		group = array_combine(_group,group3);
		
			
		if(group.size > 0 && group.size < 3)
		{
			for(i=0;i<group.size;i++)
			{
				group[i] thread wait_and_kill(RandomFloatrange(0.1,3));
			}
			killed_stragglers = true;
		}
		wait(.1);
	}
}


stop_topfloor_spawners_when_player_in_pit()
{
	trigger_wait("on_warroom_floor");
	level notify ("on_warroom_floor");
	
	trig = GetEnt("squad_to_reznov_hall_trig", "targetname");
	trig trigger_on();
	
	trig waittill ("trigger");
	
	guys = array_combine(get_ai_array("macv_enemies_3_ai", "targetname"), get_ai_array("war_room_special_guys_ai", "targetname") ); 
	
	for (i=0; i < guys.size; i++)
	{
		guys[i] thread wait_and_kill(RandomFloat(15,20));
	}
}

exit_macv()
{
	flag_wait("player_breaching");
	
	points = getstructarray("woods_bowman_post_reznov_spots","targetname");
	
	level.woods notify( "stoploop");
	level.woods stopanimscripted();
	
	level.woods forceteleport(points[0].origin);
	level.bowman forceteleport(points[1].origin);
	
	level.woods setgoalpos(level.woods.origin);
	level.bowman setgoalpos(level.bowman.origin);
		
	
	level thread maps\hue_city_anim::reznov_reveal_deadguy();
	level thread struct_spawn("macv_trans_bodies", maps\hue_city_ai_spawnfuncs::random_direction_die);
	get_players()[0] DisableWeapons();
	flag_waitopen("player_breaching");
	flag_set("reznov_reveal_start");
	time = GetAnimLength(level.scr_anim["playboy_hands"]["reznov_reveal"]) ;
	level maps\hue_city_anim::reznov_reveal();
	//wait time - 5;
	wait(12.5);

	getstruct("reznov_hall_align_struct", "targetname") notify ("stoploop");
	SetSavedDvar("g_speed", 170);
	
	level.woods set_force_color("r");
	level.woods enable_ai_color();
	level.woods disable_cqbwalk();
	
	level.bowman set_force_color("r");
	level.bowman enable_ai_color();
	level.bowman disable_cqbwalk();
	
	wait(1);
	flag_set("in_reznov_room");

	clip = getent("reznov_reveal_player_clip","targetname");
	clip delete();
	
	wait 4;
	
	level thread yay_more_explosions_in_macv();
	
	//level thread maps\_autosave::autosave_game_now();
	autosave_by_name("reznov_reveal");
	
	level thread objective_control(2);
	level notify("set_street_fog");
}

exit_event1()
{
	trigger_wait("vin_area_stackers", "target");
	level thread maps\_autosave::autosave_game_now();
	SetSavedDvar("g_speed", 190);
	
	//level.reznov thread maps\hue_city_ai_spawnfuncs::street_reznov_setup();

	maps\hue_city_event2::event2();
}
	
macv_demo_over(trig)
{
	trig waittill ("trigger");
	bg = NewHudElem(); 
	bg.x = 0; 
	bg.y = 0; 
	bg.horzAlign = "fullscreen"; 
	bg.vertAlign = "fullscreen"; 
	bg.foreground = true; 
	bg SetShader( "black", 640, 480 ); 
	bg.alpha = 0; 
	bg FadeOverTime( 2 );
	bg.alpha = 1; 
	get_players()[0] FreezeControls(true);
	wait 2;
	guys = GetAIArray();
	for (i=0; i < guys.size; i++)
	{
		guys[i] thread disable_replace_on_death();
		waittillframeend;
		guys[i] Delete();
	}
	
	level thread maps\hue_city_event2::event2_start();
	bg FadeOverTime( 3 );
	bg.alpha = 0; 
	wait 1;
	get_players()[0] FreezeControls(false);
	wait 2;
	bg destroy();
}

nagline_overkill()
{
	level endon ("in_reznov_room");
	lines = [];
	lines[0] = "rh_nag_overkill1";
	lines[1] = "rh_nag_overkill2";
	lines[2] = "rh_nag_overkill3";
	lines[3] = "rh_nag_overkill4";
	lines[4] = "rh_nag_overkill5";
	player = get_players()[0];
	trig = getent("door_breach_nag_trig","targetname");
	
	wait 5;
	while(1)
	{
		wait 10;
		if( player istouching(trig) )
		{
			level.woods Line_please(lines[RandomInt(lines.size)]);
		}
	}
}


yay_more_explosions_in_macv()
{
	level thread yay_more_explosions_outside_macv();
	level endon ("out_of_macv");
	quakescale = 0.6;
	quaketime = 1;
	earthquake (quakescale, quaketime, get_players()[0].origin, 500);
	get_players()[0] playrumbleonentity ("explosion_generic");
	//SOUND - Shawn J
	//iprintlnbold ("generic Boom");
	clientNotify ("exp_hit_rattle");
	playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));
	
	wait 2;
	quakescale = 0.7;
	quaketime = 0.7;
	earthquake (quakescale, quaketime, get_players()[0].origin, 500);
	get_players()[0] playrumbleonentity ("artillery_rumble");
	//SOUND - Shawn J
	//iprintlnbold ("artillery Boom");
	clientNotify ("exp_hit_rattle");
	playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));

	wait 1.5;
	quakescale = 0.5;
	quaketime = 0.5;
	earthquake (quakescale, quaketime, get_players()[0].origin, 500);
	get_players()[0] playrumbleonentity ("explosion_generic");
	//SOUND - Shawn J
	//iprintlnbold ("generic Boom");
	clientNotify ("exp_hit_rattle");
	playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));
	
	wait 0.5;
	quakescale = 0.8;
	quaketime = 0.7;
	earthquake (quakescale, quaketime, get_players()[0].origin, 1000);
	get_players()[0] playrumbleonentity ("explosion_generic");
	clientNotify ("exp_hit_rattle");
	//SOUND - Shawn J
	//iprintlnbold ("generic Boom");
	playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));
	
	while(1)
	{
	 	wait randomfloatrange(0.9, 4);
	 	quakescale = randomfloat(0.5,0.8);
	 	quaketime = randomfloat(1.5, 3.5);
	 	
	 	earthquake (quakescale, quaketime, get_players()[0].origin, 1000);
		if (cointoss() )
		{
			get_players()[0] playrumbleonentity ("explosion_generic");	
			//SOUND - Shawn J
			//iprintlnbold ("generic Boom");
			playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));
			clientNotify ("exp_hit_rattle");
		}
		else
		{
			get_players()[0] playrumbleonentity ("artillery_rumble");	
			//SOUND - Shawn J
			//iprintlnbold ("artillery Boom");
			playsoundatposition ("evt_yay_explo", (-2399, -2206, 7787));
			clientNotify ("exp_hit_rattle");
		}
	}
}

yay_more_explosions_outside_macv()
{
	flag_wait("out_of_macv");
	level endon ("event2_start_go");
	while(1)
	{
	 	wait randomfloatrange(0.8, 5.5);
	 	quakescale = randomfloat(0.4,0.6);
	 	quaketime = randomfloat(2, 5);
	 	
	 	earthquake (quakescale, quaketime, get_players()[0].origin, 1000);
		if (cointoss() )
		{
			get_players()[0] playrumbleonentity ("assault_fire");	
			//SOUND - Shawn J
			//iprintlnbold ("assault Boom");
			playsoundatposition ("evt_yay_explo_dist", (-2399, -2206, 7787));
			clientNotify ("exp_hit_rattle");
		}
		else
		{
			get_players()[0] playrumbleonentity ("damage_light");	
			//SOUND - Shawn J
			//iprintlnbold ("light damage");
			playsoundatposition ("evt_yay_explo_sub", (-2399, -2206, 7787));
			clientNotify ("exp_hit_rattle");			
		}
	}
}

e1b_transition_cowbell()
{
	trigger_wait("e1b_cowbell_1_trig");
	travel_offset = (-15000,0,0);
	level thread maps\hue_city_event2::street_chopper_group( travel_offset, "e1b_cowbell_1", 30);
	
	trigger_wait("e1b_cowbell_2_trig");
	level thread maps\hue_city_event2::streets_jets_group("e1b_cowbell_2", undefined, 3.5);
	
	wait 5;
	level thread maps\hue_city_event2::streets_jets_group("e1b_cowbell_3", undefined, 3.5);
}
