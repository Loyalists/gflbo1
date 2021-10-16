#include maps\_anim; 
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_music; 
#include maps\_zombietron_utility; 
#include maps\_busing;


#using_animtree("generic_human");			
actor_idle()
{
	self.animname = "actor";
	level endon("introduction_complete");
	while(isDefined(self))
	{
		switch(RandomInt(3))
		{
			case 0:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle;
			break;
			case 1:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle_twitch_01;
			break;
			case 2:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle_twitch_02;
			break;
		}
		self maps\_anim::anim_single(self, "idle");
	}	
}
ape_intro_exit(origin)
{
	self thread maps\_zombietron_ai_ape::ape_shielder();
	self SetGoalPos( origin );
	self waittill("goal");
	level notify("ape_exited");
}
tutorial_exit_watch(trigger)
{
	level waittill_any("exit_taken");
	level.abort_tutorial = true;
	trigger notify("trigger");
}



game_tutorial_render_instructions(curPage,lastPage,instruction1,instruction2,instruction3,p1,p2,p3)
{
	instruct1 = undefined;
	instruct2 = undefined;
	instruct3 = undefined;

	title							= NewHudElem( level );
	title.alignX 			= "center";
	title.alignY 			= "middle";
	title.horzAlign 	= "center";
	title.vertAlign 	= "middle";
	title.foreground 	= true;
	title.fontScale 	= 3;
	title.y 				 -= 130;
	title.color 			= ( 1.0, 0.84, 0.0 );
	title.alpha 			= 0;
	title SetText( &"ZOMBIETRON_TITLE" );
	title FadeOverTime( 1 );
	title.alpha = 1;
	title.hidewheninmenu = true;
	level thread assassinateHudElem(title,"exit_taken");

	subtitle							= NewHudElem( level );
	subtitle.alignX 			= "center";
	subtitle.alignY 			= "middle";
	subtitle.horzAlign 	= "center";
	subtitle.vertAlign 	= "middle";
	subtitle.foreground 	= true;
	subtitle.fontScale 	= 1;
	subtitle.y 				 -= 110;
	subtitle.color 			= ( 1.0, 0.84, 0.0 );
	subtitle.alpha 			= 0;
	subtitle SetText( &"ZOMBIETRON_PAGE",curPage,lastPage );
	subtitle FadeOverTime( 1 );
	subtitle.alpha = 1;
	subtitle.hidewheninmenu = true;
	level thread assassinateHudElem(subtitle,"exit_taken");

	
	if ( isDefineD(instruction1) )
	{	
		instruct1							= NewHudElem( level );
		instruct1.alignX 			= "center";
		instruct1.alignY 			= "middle";
		instruct1.horzAlign 	= "center";
		instruct1.vertAlign 	= "middle";
		instruct1.foreground 	= true;
		instruct1.fontScale 	= 1.5;
		instruct1.y 				 -= 90;
		instruct1.color 			= ( 1.0, 0.84, 0.0 );
		instruct1.alpha 			= 0;
		if ( isDefined(p1) )
			instruct1 SetText( instruction1,p1 );
		else 
			instruct1 SetText( instruction1);
		instruct1 FadeOverTime( 1 );
		instruct1.alpha = 1;
		instruct1.hidewheninmenu = true;
		
		level thread assassinateHudElem(instruct1,"exit_taken");
		
	}
	
	if (isDefined(instruction2) )
	{
		instruct2							= NewHudElem( level );
		instruct2.alignX 			= "center";
		instruct2.alignY 			= "middle";
		instruct2.horzAlign 	= "center";
		instruct2.vertAlign 	= "middle";
		instruct2.foreground 	= true;
		instruct2.fontScale 	= 1.5;
		instruct2.y 				 -= 60;
		instruct2.color 			= ( 1.0, 0.84, 0.0 );
		instruct2.alpha 			= 0;
		if ( isDefined(p2) )
			instruct2 SetText( instruction2,p2 );
		else 
			instruct2 SetText( instruction2);
		instruct2 FadeOverTime( 2 );
		instruct2.alpha = 1;
		instruct2.hidewheninmenu = true;
		
		level thread assassinateHudElem(instruct2,"exit_taken");
	}
	
	if (isDefined(instruction3) )
	{
		instruct3							= NewHudElem( level );
		instruct3.alignX 			= "center";
		instruct3.alignY 			= "middle";
		instruct3.horzAlign 	= "center";
		instruct3.vertAlign 	= "middle";
		instruct3.foreground 	= true;
		instruct3.fontScale 	= 1.5;
		instruct3.y 				 -= 30;
		instruct3.color 			= ( 1.0, 0.84, 0.0 );
		instruct3.alpha 			= 0;
		if ( isDefined(p3) )
			instruct3 SetText( instruction3,p3 );
		else 
			instruct3 SetText( instruction3);
		instruct3 FadeOverTime( 3 );
		instruct3.alpha = 1;
		instruct3.hidewheninmenu = true;
		
		level thread assassinateHudElem(instruct3,"exit_taken");
	}
	nextPage = undefined;
	if (curPage != lastPage)
	{
		nextPage							= NewHudElem( level );
		nextPage.alignX 			= "center";
		nextPage.alignY 			= "middle";
		nextPage.horzAlign 	= "center";
		nextPage.vertAlign 	= "middle";
		nextPage.foreground 	= true;
		nextPage.fontScale 	= 1.5;
		nextPage.y 				 += 30;
		nextPage.color 			= ( 1.0, 0.84, 0.0 );
		nextPage.alpha 			= 0;
		nextPage SetText( &"ZOMBIETRON_NEXT_PAGE");
		nextPage FadeOverTime( 3 );
		nextPage.alpha = 1;
		nextPage.hidewheninmenu = true;
		level thread assassinateHudElem(nextPage,"exit_taken");
	}
	
	
	
	level waittill_any("exit_taken","next_page");

	title FadeOverTime(1);
	title.alpha = 0;
	subtitle FadeOverTime(1);
	subtitle.alpha = 0;
	nextPage FadeOverTime(1);
	nextPage.alpha = 0;
	
	if ( isDefined(instruct1) )
	{
		instruct1 FadeOverTime(1);
		instruct1.alpha = 0;
	}	
	if ( isDefined(instruct2) )
	{
		instruct2 FadeOverTime(1);
		instruct2.alpha = 0;
	}	
	if ( isDefined(instruct3) )
	{
		instruct3 FadeOverTime(1);
		instruct3.alpha = 0;
	}	
	
	wait 1;

	DestroyHudElem(title);
	DestroyHudElem(subtitle);
	DestroyHudElem(nextPage);
	DestroyHudElem(instruct1);
	DestroyHudElem(instruct2);
	DestroyHudElem(instruct3);
}
game_skipPage_watcher()
{
	level endon("exit_taken");
	player = GetPlayers()[0];
	while(1)
	{
		if ( player UseButtonPressed() )
		{
			level notify("next_page");
			wait 1;
		}
		wait 0.05;
	}
}

loc_random_offset(loc)
{
	loc += ( RandomFloatRange(-64,64),RandomFloatRange(-64,64),0);
	return loc;
}

game_tutorial_go()
{
	level endon("exit_taken");
	level thread game_skipPage_watcher();
	
	level game_tutorial_render_instructions(1,8,&"ZOMBIETRON_INSTRUCTION1",&"ZOMBIETRON_INSTRUCTION2",&"ZOMBIETRON_INSTRUCTION3");
	level game_tutorial_render_instructions(2,8,&"ZOMBIETRON_INSTRUCTION4",&"ZOMBIETRON_INSTRUCTION5");
	level game_tutorial_render_instructions(3,8,&"ZOMBIETRON_INSTRUCTION6",&"ZOMBIETRON_INSTRUCTION7");

	//bombs	
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "bomb", loc  );
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "bomb", loc );
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "bomb", loc );
	level game_tutorial_render_instructions(4,8,&"ZOMBIETRON_INSTRUCTION8");
	maps\_zombietron_pickups::clear_all_pickups();

	//boosters	
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "booster", loc );
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "booster", loc );
	loc = loc_random_offset(maps\_zombietron_pickups::get_random_pickup_location().origin);
	maps\_zombietron_pickups::spawn_pickup( "booster", loc );
	level game_tutorial_render_instructions(5,8,&"ZOMBIETRON_INSTRUCTION9");
	maps\_zombietron_pickups::clear_all_pickups();

	level thread maps\_zombietron_pickups::spawn_treasure(level.zombie_vars["zombie_treasure_boss"]);
	level game_tutorial_render_instructions(6,8,&"ZOMBIETRON_INSTRUCTION10",&"ZOMBIETRON_INSTRUCTION11",undefined,undefined,level.zombie_vars["extra_life_at_every"]);
	level game_tutorial_render_instructions(7,8,&"ZOMBIETRON_INSTRUCTION12");
	level game_tutorial_render_instructions(8,8,&"ZOMBIETRON_INSTRUCTION13");
}
begin_game_tutorial()
{
	title1			= NewHudElem( level );
	title1.alignX 			= "center";
	title1.alignY 			= "middle";
	title1.horzAlign 	= "center";
	title1.vertAlign 	= "middle";
	title1.foreground 	= true;
	title1.fontScale 	= 3;
	title1.y -= 70;
	title1.color 			= ( 1.0, 0.84, 0.0 );
	title1.alpha 			= 0;
	title1 SetText( &"ZOMBIETRON_TUTORIAL1");
	title1.hidewheninmenu = true;
	
	title2 						= NewHudElem( level );
	title2.alignX 			= "center";
	title2.alignY 			= "middle";
	title2.horzAlign 	= "center";
	title2.vertAlign 	= "middle";
	title2.foreground 	= true;
	title2.y -= 40;
	title2.fontScale 	= 2;
	title2.color 			= ( 1.0, 0.84, 0.0 );
	title2.alpha 			= 0;
	title2 SetText( &"ZOMBIETRON_TUTORIAL2");
	title2.hidewheninmenu = true;
	
	title1 FadeOverTime( 1 );
	title2 FadeOverTime( 2 );
	title1.alpha = 1;
	title2.alpha = 1;

	location = maps\_zombietron_pickups::get_random_pickup_location();
	
	above = location.origin + (0,0,100);
	below = location.origin + (0,0,-500);
	trace = bullettrace(above, below, false, undefined);
	dest_point = (location.origin[0],location.origin[1],trace["position"][2]);
	teleporter = Spawn( "script_model", dest_point);
	teleporter SetModel( "zombie_teleporter_pad" );
	
	playsoundatposition( "zmb_teleporter_spawn", teleporter.origin );
	trigger = spawn( "trigger_radius", location.origin, 0, 10, 50 );
	
	objective_add( 2, "active", &"ZOMBIETRON_TUTORIAL3", trigger.origin );
	Objective_String( 2, &"ZOMBIETRON_TUTORIAL3" );
	objective_set3d( 2, true, "default",&"ZOMBIETRON_TUTORIAL3");
	objective_current( 2 );
	level thread tutorial_exit_watch(trigger);
	trigger waittill_any( "trigger" );
	objective_delete( 2 );
	
	title1 FadeOverTime( 1 );
	title2 FadeOverTime( 1 );
	title1.alpha = 0;
	title2.alpha = 0;
	wait 1;
	DestroyHudElem(title1);
	DestroyHudElem(title2);
	teleporter Delete();
	
	if ( !isDefined(level.abort_tutorial) )
	{
		level thread game_tutorial_go();
	}
}

	
/*	
Summary of introduction as it stands currently:
                Scene opens on the island arena in 3rd person cam mode
                Princess and Player are standing there in idle.  There is a small boat and a lot of treasure
                Our villain, the Cosmic Silverback, comes charging down out of the skull rock stopping short of the couple
                Some dialog using James� dialog tech
                Ape kills woman dramatically
                Ape collects up some treasure, says some shit and splits.
                Camera goes to top down
                Player is armed
                Brief tutorial
                Enter the zombies��
         
	
*/	


end_game_introduction(player)
{
	level waittill("end_the_intro");
/*	

	fake_player = GetEnt("fake_player","script_noteworthy");
	princess    = GetEnt("princess","script_noteworthy");
	
	player StartCameraTween(1);
	wait 0.1;
	player SetPlayerAngles( fake_player.angles );
	player SetClientDvars("player_topDownCamMode", "3");
	player SetClientDvars("cl_scoreDraw", "1");
	
	player SetOrigin(fake_player.origin);
	fake_player Delete();
	maps\_zombietron_pickups::clear_all_pickups();
	player freezeControls(false);
	
	if (isDefined(level.skip_msg ) )
	{
		DestroyHudElem(level.skip_msg );
		level.skip_msg  = undefined;
	}

	princess Delete();
	//ape Delete(); deleted by ape_taunt_deleter
*/	

	player thread maps\_zombietron_pickups::update_drop_bomb();
	player thread maps\_zombietron_pickups::update_drop_booster();

	exit = GetEnt("ape_spawn_point","script_noteworthy");
	ape = GetEnt("the_ape","script_noteworthy");
	if (!isDefined(ape))
	{
		ape = simple_spawn_single( "ape_taunt", maps\_zombietron_ai_ape::ape_prespawn );
		ape.script_noteworthy = "the_ape";
		ape.takedamage = false;
		ape thread maps\_zombietron_ai_ape::ape_you_greedy_mf(exit.origin);
		ape thread maps\_zombietron_ai_ape::ape_taunt_deleter();
		spot = GetEnt("ape_intro_spot","script_noteworthy");
		ape forceTeleport(spot.origin,spot.angles);
		level thread maps\_zombietron_pickups::spawn_treasures(spot.origin,5 + RandomInt( 5 ) );
		level waittill( "fade_in_complete");
		level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
		ape thread maps\_anim::anim_single(ape, "chest_beat");
		wait 1;
		ape anim_stopanimscripted(0.15);
		ape set_run_anim( "sprint3" );
		ape.run_combatanim = level.scr_anim["ape_zombie"]["sprint3"];
		ape.crouchRunAnim = level.scr_anim["ape_zombie"]["sprint3"];
		ape.crouchrun_combatanim = level.scr_anim["ape_zombie"]["sprint3"];
		ape.goalradius = 32;
	}
	ape thread ape_intro_exit(exit.origin);
	//ape waittill("goal");
	wait 2;
	
	if (!isDefined(level.abort_scene))
	{
		level thread begin_game_tutorial();
		maps\_zombietron_main::open_exits("top");
	}
	maps\_zombietron_pickups::clear_all_pickups();
	player maps\_zombietron_main::player_reset_score();
	maps\_zombietron_main::move_players_to_start();
	wait 1;
	fade_in();
	level notify("introduction_complete");

}

introduction_abort_watcher()
{
	level endon("end_the_intro");
	
	level.skip_msg							= NewHudElem( level );
	level.skip_msg.alignX 			= "center";
	level.skip_msg.alignY 			= "middle";
	level.skip_msg.horzAlign 	= "right";
	level.skip_msg.vertAlign 	= "bottom";
	level.skip_msg.foreground 	= true;
	level.skip_msg.fontScale 	= 1;
	level.skip_msg.x -= 70;
	level.skip_msg.color 			= ( 1.0, 1.0, 1.0 );
	level.skip_msg.alpha 			= 1;
	level.skip_msg SetText( &"ZOMBIETRON_SKIP_SCENE");
	level.skip_msg.hidewheninmenu = true;
	
	while(1)
	{
		if ( self UseButtonPressed() )
		{
			princess    = GetEnt("princess","script_noteworthy");
			princess startragdoll();
			princess launchragdoll( (0,0,200) );
			maps\_zombietron_pickups::clear_all_pickups();
			level.abort_scene = true;
			level notify("bubbles_off");
			level notify("end_the_intro");
			return;
		}
		wait 0.05;
	}
}

game_introduction(player)
{
	level endon("end_the_intro");
	
/*	
//Scene opens on the island arena in 3rd person cam mode
	player SetClientDvars("player_topDownCamMode", "0");
	player SetClientDvars("cl_scoreDraw", "0");

	spot = GetEnt("player_intro_spot","script_noteworthy");
	fake_player = spawn("script_model", spot.origin);
	fake_player.angles = spot.angles;
	fake_player.script_noteworthy = "fake_player";
	fake_player SetModel( "c_usa_blackops_body3_fb" );
	fake_player UseAnimTree(#animtree);
	fake_player thread actor_idle();
	
	spot = GetEnt("princess_intro_spot","script_noteworthy");
	princess = spawn("script_model", spot.origin);
	princess.angles = spot.angles;
	princess SetModel( "c_rus_kristina_fb" );
	princess.script_noteworthy = "princess";
	princess UseAnimTree(#animtree);
	princess thread actor_idle();

	spot = GetEnt("ape_spawn_point","script_noteworthy");
	ape = simple_spawn_single( "ape_taunt", maps\_zombietron_ai_ape::ape_prespawn );
	ape.script_noteworthy = "the_ape";
	ape forceTeleport(spot.origin,spot.angles);
	ape.takedamage = false;
	ape thread maps\_zombietron_ai_ape::ape_you_greedy_mf(ape.origin);
	ape thread maps\_zombietron_ai_ape::ape_taunt_deleter();
	exit = spot;

	spot = GetEnt("ape_intro_spot","script_noteworthy");
	level thread maps\_zombietron_pickups::spawn_treasures(spot.origin,5 + RandomInt( 5 ) );

	ape set_run_anim( "sprint3" );
	ape.run_combatanim = level.scr_anim["ape_zombie"]["sprint3"];
	ape.crouchRunAnim = level.scr_anim["ape_zombie"]["sprint3"];
	ape.crouchrun_combatanim = level.scr_anim["ape_zombie"]["sprint3"];
	ape.goalradius = 32;
	level waittill( "fade_in_complete");
	player freezeControls(true);
	player thread introduction_abort_watcher();


	level thread bubble_message( &"ZOMBIETRON_BUBBLE_RELAX", 300, 200, 4 );
	fake_player PlaySound( "zmb_intro_line_00" );
	wait 4;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_RICH", 200, 210, 4 );
	princess PlaySound( "zmb_intro_line_01" );

	ape SetGoalPos( spot.origin );
	ape waittill("goal");
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	wait 1;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_TREASURE", 250, 200, 1.5 );
	ape PlaySound( "zmb_intro_line_02" );
	wait 2;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_OHNO", 200, 210, 2 );
	princess PlaySound( "zmb_intro_line_03" );

	wait 1;
	ape anim_stopanimscripted(0.15);
	ape.goalradius = 72;
	ape SetGoalPos( princess.origin );
	ape waittill("goal");
	level.scr_anim["ape_zombie"]["attack"] = %ai_semianaut_attack_v1;
	ape thread maps\_anim::anim_single(ape, "attack");
	wait 0.75;
	PlayFxOnTag( level._effect["betty_explode"], princess, "tag_origin" ); 
	EarthQuake( 1.0, 0.8, princess.origin, 1000 ); 
	PlayRumbleOnPosition("explosion_generic", princess.origin);
	
	princess startragdoll();
	princess launchragdoll( (0,0,200) );
	princess PlaySound( "zmb_intro_princess_death" );
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");

	level thread bubble_message( &"ZOMBIETRON_BUBBLE_NOOO", 300, 200, 4 );
	fake_player PlaySound( "zmb_intro_line_04" );

	wait 2.4;
	ape anim_stopanimscripted(0.15);
	ape OrientMode( "face point", princess.origin );
	ape thread maps\_anim::anim_single(ape, "attack");
	wait 0.75;
	physicsExplosionSphere( princess.origin, 512, 128, 2 );
	PlayFx( level._effect["gib_death"], princess.origin, (0,0,100) );
	PlayRumbleOnPosition("explosion_generic", princess.origin);
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_HAHA", 200, 210, 1.5 );
	ape PlaySound( "zmb_intro_line_05" );
	wait 1;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_FCUK", 320, 200, 1.5 );
	fake_player PlaySound( "zmb_intro_line_06" );
	wait 1;
	ape anim_stopanimscripted(0.15);
*/	
	wait 0.1;
	level notify("end_the_intro");
	
}

begin_game_introduction(player)
{
	player.lives 				= 1;
	player.bombs 				= 0;
	player.boosters 		= 0;	
	player maps\_zombietron_score::update_multiplier_bar( 0 );
	player maps\_zombietron_score::update_hud();
	
	
	level thread game_introduction(player);
	level thread end_game_introduction(player);
	level waittill("introduction_complete");
}


hide_temple_props( hide )
{
	if (hide == "none" )
	{
		statue_heads = GetEntArray("temple_head","targetname");
		if (isDefined(statue_heads)) 
		{
			for( i = 0; i < statue_heads.size; i++ )
			{
			    statue_heads[i] Show();
                statue_heads[i] SetScale(3.0);
			}
		}
		
		podium = GetEnt("temple_podium_first_place","targetname");
		if (isDefined(podium))
		{
			podium Hide();
			if (!isDefined(podium.old_origin))
			{
				podium.old_origin = podium.origin;
				podium.origin += (0,0,-500);
			}
		}

		podium = GetEnt("temple_podium_second_place","targetname");
		if (isDefined(podium))
		{
			podium Hide();
			if (!isDefined(podium.old_origin))
			{
				podium.old_origin = podium.origin;
				podium.origin += (0,0,-500);
			}
		}
		
		podium = GetEnt("temple_podium_third_place","targetname");
		if (isDefined(podium))
		{
			podium Hide();
			if (!isDefined(podium.old_origin))
			{
				podium.old_origin = podium.origin;
				podium.origin += (0,0,-500);
			}
		}
	
		podium = GetEnt("temple_podium_last_place","targetname");
		if (isDefined(podium))
		{
			podium Hide();
			if (!isDefined(podium.old_origin))
			{
				podium.old_origin = podium.origin;
				podium.origin += (0,0,-500);
			}
		}
	}
	else
	if (hide == "end" )
	{
		statue_heads = GetEntArray("temple_head","targetname");
		if (isDefined(statue_heads)) 
		{
			for( i = 0; i < statue_heads.size; i++ )
			{
			  statue_heads[i] Hide();
			}
		}
		
		podium = GetEnt("temple_podium_first_place","targetname");
		if (isDefined(podium))
		{
			podium Show();			if (isDefined(podium.old_origin))
			{
				podium.origin = podium.old_origin;
				podium.old_origin = undefined;
			}
		}
		
		podium = GetEnt("temple_podium_second_place","targetname");
		if (isDefined(podium))
		{
			podium Show();
			if (isDefined(podium.old_origin))
			{
				podium.origin = podium.old_origin;
				podium.old_origin = undefined;
			}
		}
		
		podium = GetEnt("temple_podium_third_place","targetname");
		if (isDefined(podium))
		{
			podium Show();
			if (isDefined(podium.old_origin))
			{
				podium.origin = podium.old_origin;
				podium.old_origin = undefined;
			}
		}
	
		podium = GetEnt("temple_podium_last_place","targetname");
		if (isDefined(podium))
		{
			podium Show();
			if (isDefined(podium.old_origin))
			{
				podium.origin = podium.old_origin;
				podium.old_origin = undefined;
			}
		}
	}
}



actor_end_bubbles(place)
{
	level endon("summary_complete");
	level waittill("summary_ready");
	
	originX = 340;
	originY = 110;
	switch(place)
	{
		case 0:
			originX = 340;
			originY = 110;
		break;
		case 1:
			originX = 450;
			originY = 170;
		break;
		case 2:
			originX = 210;
			originY = 180;
		break;
		case 3:
			originX = 100;
			originY = 220;
		break;
	}
	
		
	level thread bubble_message( &"ZOMBIETRON_NAME", originX, originY, 2, self.ent );
	wait 2.5;

	switch(place)
	{
		case 0://1st place
		if ( GetPlayers().size > 1 )
		{
			/*
			self.animname = "winner";
			level.scr_anim["winner"]["victory"] = %ch_sniper_resnov_cheer;
			self thread maps\_anim::anim_single(self, "victory");
			wait 1.5;
			self anim_stopanimscripted(0.15);
			*/
			//ch_sniper_resnov_cheer
			level thread bubble_message( &"ZOMBIETRON_BUBBLE_WINNER", originX, originY, 1.5 );
			self PlaySound( "zmb_1st_vox_00" );
			wait 2;
			level thread bubble_message( &"ZOMBIETRON_1ST", originX, originY, 6, self.score );
			self PlaySound( "zmb_1st_vox_01" );
		}
		else
		{
			level thread bubble_message( &"ZOMBIETRON_BUBBLE_DEAD", originX, originY, 1.5 );
			self PlaySound( "zmb_1st_vox_00" );
			wait 2;
			level thread bubble_message( &"ZOMBIETRON_SCORE", originX, originY, 6, self.score );
			self PlaySound( "zmb_1st_vox_01" );
		}
		wait 7;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_OHYEAH", originX, originY, 8 );
		self PlaySound( "zmb_1st_vox_02" );
		wait 13;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_WHAT", originX, originY, 2 );
		self PlaySound( "zmb_1st_vox_03" );
		wait 2;
		break;

		case 1://2nd place
		wait 1;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_NOTBAD", originX, originY, 1.5 );
		self PlaySound( "zmb_2nd_vox_00" );
		wait 2;
		level thread bubble_message( &"ZOMBIETRON_2ND", originX, originY, 6, self.score );
		self PlaySound( "zmb_2nd_vox_01" );
		wait 7;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_BIGMONEY", originX, originY, 1.5 );
		self PlaySound( "zmb_2nd_vox_02" );
		wait 2;
		
		break;

		case 2://3rd place
		wait 2;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_NEXTTIME", originX, originY, 1.5 );
		self PlaySound( "zmb_3rd_vox_00" );
		wait 2;
		level thread bubble_message( &"ZOMBIETRON_3RD", originX, originY, 6, self.score );
		self PlaySound( "zmb_3rd_vox_01" );
		wait 9;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_BIGPRIZES", originX, originY, 1.5 );
		self PlaySound( "zmb_3rd_vox_02" );
		wait 2;
		
		break;

		case 3://4th place
		wait 3;
		level thread bubble_message( &"ZOMBIETRON_BUBBLE_FCUK", originX, originY, 1.5 );
		self PlaySound( "zmb_4th_vox_00" );
		wait 2;
		level thread bubble_message( &"ZOMBIETRON_4TH", originX, originY, 6, self.score );
		self PlaySound( "zmb_4th_vox_01" );
		break;
	}
}

actor_end_idle(place)
{
	self.animname = "actor";
	level endon("summary_complete");

	if ( place == 0 )
	{
//		playfxontag(level._effect["lght_marker"], self, "tag_origin");
//		playfxontag(level._effect["lght_marker_flare"], self, "tag_origin");
	}

	while(isDefined(self))
	{
		switch(RandomInt(3))
		{
			case 0:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle;
			break;
			case 1:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle_twitch_01;
			break;
			case 2:
			level.scr_anim["actor"]["idle"] = %ai_civ_gen_casual_stand_idle_twitch_02;
			break;
		}
		
		self maps\_anim::anim_single(self, "idle");
	}	
}



end_of_game_summary_begin()
{
	level endon("end_the_summary");
	
	//kill all axis
	zombies = GetAISpeciesArray( "axis", "all" );
	for(i=0;i<zombies.size;i++)
	{
		zombies[i] Delete();
	}		
	ClearAllCorpses();	
	CleanupSpawnedDynEnts();
	maps\_zombietron_pickups::clear_all_pickups();
	maps\_zombietron_pickups::clear_mines();
	
	//fake out the 'system'
	level.current_arena = maps\_zombietron_main::arena_findIndexByName("temple");
	spawn_origin 	= maps\_zombietron_main::get_player_spawn_point();
	spawn_origin 	= physicstrace( spawn_origin + (0,0,2000), spawn_origin - (0,0,2000) );
	camera_center = maps\_zombietron_main::get_camera_center_point();
	angles = VectorToAngles( camera_center - spawn_origin );
	camera_angles = GetDvarVector( "player_TopDownCamAngles" );
	camera_angles = ( camera_angles[0], 0, camera_angles[2] );
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] setClientDvars( "player_topDownCamMode", 4, "player_topDownCamCenterPos", camera_center, "player_TopDownCamAngles", camera_angles, "cg_fov", 65, "hud_drawHUD", "0","cl_scoreDraw", "0" );
	}
	
	//turn off the head, turn on the podiums
	hide_temple_props( "end" );

	//create winner's circle spot light
	spotlight = GetEnt("temple_light_spot","targetname");
	spotlight setmodel("tag_origin");
	playfxontag(level._effect["spot_light"], spotlight, "tag_origin");

	//kill any fx currently on
	if( IsDefined( level.weatherFx ) )
	{
		for( i = 0; i < level.weatherFx.size; i++ )
		{
			level.weatherFx[i] Delete();
		}
	}
	//set some mood lighting...
	dir = "-28 115.4";
	color = "0.9 0.84 0";
	light = "15";
	exposure = "1";
	VisionSetNaked( "zombietron_afternoon_death", 0 );
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] setClientDvars( 
			"r_lightTweakSunLight", light,
			"r_lightTweakSunColor", color, 
			"r_lightTweakSunDirection", dir,
			"r_exposureTweak", 1,
			"r_exposureValue", exposure
			);
	}
	//rank the players and place  on podium
	players = sort_by_score(GetPlayers());
	pads    = [];
	dudes   = [];
	for (i = 0;i<players.size;i++)
	{
		tname   = "temple_player_spot" + (i+1);
		padSite = GetEnt(tname,"targetname");
		if (isDefined(padSite))
		{
			dudes[i] = spawn("script_model", padSite.origin);
			dudes[i].angles= padSite.angles;
			dudes[i].score = players[i].score;
			dudes[i].script_noteworthy = "fake_player";
			switch( players[i] GetEntityNumber() )
			{
				case 0:
					// dudes[i] SetModel( "c_usa_blackops_body3_fb" );
					dudes[i] character\gfl\character_gfl_rfb::main();
				break;
				case 1:
					// dudes[i] SetModel( "c_zom_blue_guy_fb" );
					dudes[i] character\gfl\character_gfl_rfb::main();
				break;
				case 2:
					// dudes[i] SetModel( "c_zom_red_guy_fb" );
					dudes[i] character\gfl\character_gfl_rfb::main();
				break;
				case 3:
					// dudes[i] SetModel( "c_zom_yellow_guy_fb" );
					dudes[i] character\gfl\character_gfl_rfb::main();
				break;
			}
			
			dudes[i].ent  = players[i];
			dudes[i] UseAnimTree(#animtree);
			dudes[i] thread actor_end_idle(i);
			dudes[i] thread actor_end_bubbles(i);
			PlayFxOnTag(level._effect[players[i].light_playFX],dudes[i],"tag_origin");			
		}
	}

	//move camera to here temple_camera_spot
	camPos 		= getEnt("temple_camera_spot","targetname").origin;
	camera_angles	= getEnt("temple_camera_spot","targetname").angles;
	//clamp the ranges to +- 180
	if ( camera_angles[0] > 180 ) camera_angles -= (360,0,0);
	if ( camera_angles[1] > 180 ) camera_angles -= (0,360,0);
	if ( camera_angles[2] > 180 ) camera_angles -= (0,0,360);
	if ( camera_angles[0] < -180 ) camera_angles += (360,0,0);;
	if ( camera_angles[1] < -180 ) camera_angles += (0,360,0);;
	if ( camera_angles[2] < -180 ) camera_angles += (0,0,360);;
	//set the camera/angles
	offset = camPos - dudes[0].origin;
	for (i = 0; i < players.size; i++)
	{
		players[i] setClientDvars( "player_topDownCamOffset", offset,"player_TopDownCamAngles", camera_angles );
	}
	//play some victory music-TODO
	playsoundatposition( "zmb_fate_spawn", (0,0,0) );
	
	level thread summary_abort_watcher();
	
	//fade up
	fade_in();
	level notify("summary_ready");

	wait 7;
	prizePoint = dudes[0].origin + (0,0,400);
	playsoundatposition( "zmb_prize_shower", (0,0,0) );
	level thread maps\_zombietron_pickups::spawn_uber_prizes(20*level.zombie_vars["max_prize_inc_range"],prizePoint,true,(0,0,20));
	level thread maps\_zombietron_pickups::spawn_treasures(dudes[0].origin,4, 24, true );
	
	wait 10;
	//spawn in the arch enemy!!
	apeSpot = GetEnt("temple_ape_spot","targetname");
	Playfx( level._effect["ape_lightning_spawn"], apeSpot.origin );
	playsoundatposition( "zmb_ape_prespawn", apeSpot.origin );
	wait( .5 );
	playsoundatposition( "zmb_ape_spawn", apeSpot.origin );
	Playfx( level._effect["ape_lightning_spawn"], apeSpot.origin );
	wait( .5 );
	PlayFX( level._effect["ape_lightning_spawn"], apeSpot.origin );
	ape = simple_spawn_single( "ape_taunt", maps\_zombietron_ai_ape::ape_prespawn );
	wait( 1.5 );
	ape.script_noteworthy= "the_ape";
	ape forceTeleport(apeSpot.origin,apeSpot.angles);
	ape.takedamage = false;
	playsoundatposition( "zmb_ape_spawn", apeSpot.origin );
	playsoundatposition( "zmb_ape_bolt", apeSpot.origin );
	Earthquake( 0.5, 0.75, apeSpot.origin , 1000);
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	wait 1;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_IMBACK", 320, 60, 1.5 );
	wait 1.3;
	ape anim_stopanimscripted(0.15);
	
//	wait 1;
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	wait 2.3;
	ape anim_stopanimscripted(0.15);
	Earthquake( 0.5, 0.75, ape.origin, 1000);
	PlayFxOnTag( level._effect["boss_takeoff"], ape, "tag_origin" );
	ape PlaySound( "evt_turret_takeoff" ); 
	height = 800;
	timeMS = height/1000 * 3000;
	target = 	dudes[0];//dudes[dudes.size-1];
	ape maps\_zombietron_ai_ape::move_to_position_over_time(target.origin,timeMS,height);
	target PlaySound( "zmb_1st_vox_04" );
	ape PlaySound( "evt_turret_land" );
	target startragdoll();
	target launchragdoll( (0,0,200) );
	PlayRumbleOnPosition("explosion_generic", ape.origin);
	PlayFxOnTag( level._effect["boss_groundhit"], ape, "tag_origin" ); 
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_chest_beat;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	wait 1;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_TREASURE", 350, 120, 1.5 );
	ape thread ape_you_greedy_mf( ape.origin + (0,0,500));
	wait 1.7;
	ape anim_stopanimscripted(0.15);
	level.scr_anim["ape_zombie"]["chest_beat"] = %ai_zombie_simianaut_taunt;
	ape thread maps\_anim::anim_single(ape, "chest_beat");
	wait 2.9;
	level thread bubble_message( &"ZOMBIETRON_BUBBLE_HAHADOH", 350, 120, 1 );
	wait 1.1;
	PlayFxOnTag( level._effect["boss_takeoff"], ape, "tag_origin" );
	ape PlaySound( "evt_turret_takeoff" );  
	height = 800;//RandomIntRange (500,1000);
	timeMS = height/1000 * 3000;
	ape thread maps\_zombietron_ai_ape::move_to_position_over_time(ape.origin,timeMS,height);
	wait 1.5;
	level notify("end_the_summary");
	
}

ape_you_greedy_mf(exit)
{
	self endon("end_the_summary");
	self endon("death");
	
	pickupsItems = GetEntArray("a_pickup_item","script_noteworthy");
	for (i=0;i<pickupsItems.size;i++)
	{
		if( distanceSquared( self.origin, pickupsItems[i].origin ) < 50*50 )
		{
			pickupsItems[i] thread moveto_and_delete(exit,1);
			wait 0.1;
		}
	}
}


end_of_game_summary_end(lastArena,old_camera_angles,old_camera_offset)
{
	level waittill("end_the_summary");
	
	ape = GetEnt("the_ape","script_noteworthy");
	if (isDefined(ape))
	{
		ape delete();
	}

	//fade down / clean house
	fade_out();
	if (isDefined(level.skip_msg ) )
	{
		DestroyHudElem(level.skip_msg );
		level.skip_msg  = undefined;
	}
	maps\_zombietron_pickups::clear_all_pickups();
	dudes = GetEntArray("fake_player","script_noteworthy");
	for (i=0;i<dudes.size;i++)
	{
		dudes[i] Delete();
	}
	hide_temple_props( "none" );

	level.current_arena	= lastArena;
	spawn_origin = maps\_zombietron_main::get_player_spawn_point();
	spawn_origin = physicstrace( spawn_origin + (0,0,2000), spawn_origin - (0,0,2000) );
	camera_center = maps\_zombietron_main::get_camera_center_point();
	angles = VectorToAngles( camera_center - spawn_origin );
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] setClientDvars( 	"player_topDownCamMode", 3,
																"player_topDownCamCenterPos", camera_center,
																"player_TopDownCamAngles", old_camera_angles,
																"player_topDownCamOffset", old_camera_offset,
																"cg_fov", 65,
																"cl_scoreDraw", "1",
																"hud_drawHUD", "1" );
	}
	maps\createart\zombietron_art::setup_random_sun();
	maps\_zombietron_pickups::clear_all_pickups();
	level notify("summary_complete");
}

end_of_game_summary()
{

	level notify( "exit_taken" );
	level notify("stop_spawning_pickups");

	level thread end_of_game_summary_end(level.current_arena, GetDvarVector( "player_TopDownCamAngles" ),GetDvarVector( "player_topDownCamOffset" ));
	level thread end_of_game_summary_begin();

	level waittill("summary_complete");

}



summary_abort_watcher()
{
	level endon("end_the_summary");
	
	players = sort_by_score(GetPlayers());
	winner  = players[0];

	level.skip_msg							= NewHudElem( level );
	level.skip_msg.alignX 			= "right";
	level.skip_msg.alignY 			= "bottom";
	level.skip_msg.horzAlign 	= "user_right";
	level.skip_msg.vertAlign 	= "user_bottom";
	level.skip_msg.foreground 	= true;
	level.skip_msg.font		 	= "small";
	level.skip_msg.fontScale 	= 1.25;
	level.skip_msg.x -= 70;
	level.skip_msg.y -= 7;
	level.skip_msg.color 			= ( 1.0, 1.0, 1.0 );
	level.skip_msg.alpha 			= 1;
	level.skip_msg.hidewheninmenu = true;
	if (players.size > 1 )
	{
		level.skip_msg SetText( &"ZOMBIETRON_WINNER_SKIP");
	}
	else
	{
		level.skip_msg SetText( &"ZOMBIETRON_SKIP_SCENE");
	}
	

	while(1)
	{
		if ( isDefined(winner) && winner UseButtonPressed() )
		{
			maps\_zombietron_pickups::clear_all_pickups();
			level notify("bubbles_off");
			level notify("end_the_summary");
			level notify("stop_spawning_pickups");
			return;
		}
		wait 0.05;
	}
}





bubble_message( text, x, y, time, param )
{
	font_size = 2;

	bubblehud = create_simple_hud();
	bubblehud.foreground = true; 
	bubblehud.sort = 20; 
	bubblehud.x = x; 
	bubblehud.y = y; 
	bubblehud.fontScale = font_size; 
	bubblehud.alignX = "center"; 
	bubblehud.alignY = "middle"; 
	bubblehud.color = ( 0.0, 0.0, 0.0 );
	if ( isDefined(param) )
	{
		bubblehud SetText( text, param );
	}
	else
	{
		bubblehud SetText( text );
	}
	bubblehud.hidewheninmenu = true;	
	width = bubblehud GetTextWidth() + 22;

	//level.bubblehudtext = bubblehud;

	bubblehudbackground = create_simple_hud();
	bubblehudbackground.foreground = true; 
	bubblehudbackground.sort = 10; 
	bubblehudbackground.x = x; 
	bubblehudbackground.y = y + 2; 
	bubblehudbackground.alignX = "center"; 
	bubblehudbackground.alignY = "middle"; 
	bubblehudbackground.color = ( 0.9, 0.9, 0.9 );
	bubblehudbackground SetShader( "text_box", width, 40 );
	bubblehudbackground.hidewheninmenu = true;

	//level.bubblehudbackground = bubblehudbackground;
	level thread assassinateHudElem(bubblehud,"bubbles_off");
	level thread assassinateHudElem(bubblehudbackground,"bubbles_off");

	wait time;

	destroyHudElem( bubblehud );
	destroyHudElem( bubblehudbackground );
}
