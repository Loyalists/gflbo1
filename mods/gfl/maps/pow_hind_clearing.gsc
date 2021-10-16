/*
	
	THIS SCRIPT HANDLES EVERYTHING SPECIFIC TO STEALING THE HIND IN THE CLEARING

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\pow_utility;
#include maps\pow_spawnfuncs;
#include maps\_anim;
#include maps\_music;

//-- Parts of this have been modified specifically for demo purposes.
//-- These parts will need to be removed after the demo

start_non_demo()
{
	level.barnes = level.woods; //TODO: clean this up...
	
	//SetSavedDvar( "sm_sunSampleSizeNear", 1.208);
	SetSavedDvar( "sm_sunSampleSizeNear", 0.4);
	
	maps\_vehicle::scripted_spawn(31);
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind init_hind();
	
	//-- DVARS FOR NEXT EVENT
	player = get_players()[0];
	player SetClientDvar( "cg_aggressiveCullRadius", 2000 );
	player SetClientDvar( "cg_dof_useDefaultForVehicle", 0 );
	level notify("set_flying_dof");
	
	crew_spawners = GetEntArray("heli_crew", "targetname");
	array_thread( crew_spawners, ::add_spawn_function, ::clearing_animation );
	
	level thread clearing_truck();
	
	//TUEY set music up
	setmusicstate ("CLEARING_INTRO");
	
	flag_wait("woods_done_with_climbup_anim");
	
	animated_ents = [];
	animated_ents[0] = level.barnes;
	array_thread(animated_ents, ::temp_dialogue_and_logic_takeoff );
	
	battlechatter_off();
	align_struct = getstruct("clearing_intro_align_struct", "targetname");
	align_struct anim_reach_aligned( level.barnes, "clearing" );	
	align_struct thread anim_loop_aligned( level.barnes, "clearing_loop" );
	
	//-- wait until the player is near to play the scene
	player_nearby_trig = Spawn( "trigger_radius", level.barnes.origin, 0, 172, 128 );
	player_nearby_trig waittill("trigger");
	
	level thread clearing_player_shooting();
	level thread clearing_player_grenaded();
	
	level.barnes set_force_color("b"); 
	align_struct thread anim_single_aligned( level.barnes, "clearing" );
	level.barnes thread stop_animation_if_player_runs_past(align_struct, "clearing");
	level.barnes thread barnes_set_off_clearing( align_struct, "clearing" );
		
	//-- update objective
	flag_set( "obj_kill_hind_crew" );
	
	level thread clear_barnes_ignore();
	//level thread move_barnes_when_group_cleared( "heli_crew", "trig_bc_6");
	waittill_ai_group_cleared("heli_crew");
	
	level thread send_barnes_to_hind();
	/*
	barnes_heli_node = GetNode( "barnes_heli_node", "targetname" );
	level.barnes SetGoalNode( barnes_heli_node );
	level.barnes.goalradius = 16;
	*/
	
	flag_set( "obj_take_hind" );
	
	// END THE MUSIC
	setmusicstate ("INTRO_FIGHT_FINISHED");
	//level.allowBattleChatter = false;
	battlechatter_off();

	//-- Play some nag VO
	level.barnes thread get_in_heli_nag_vo();
		
	//-- Transition to next event once the player enters the chopper
	level.hind thread maps\_hind_player::make_player_usable();
	
	level.hind thread animate_player_headset();
	level.hind thread animate_barnes_headset();
	level.hind thread wait_for_notify_then_track_notetracks();
	level.hind waittill("switch_climbin_anim");
	//level.hind animate_barnes_into_hind();
	level.hind thread animate_barnes_into_hind_and_takeoff();
		
	//level.hind waittill("player_entered");
	player = get_players()[0];
	//player FreezeControls(true);
	player SetClientDvar( "hud_showstance", "0" );
	player SetClientDvar( "actionSlotsHide", "0" );
	player SetClientDvar( "ammoCounterHide", "1" );
	
	flag_set("obj_player_in_hind"); //clears the objective poi, but does not set a new one
	
	//-- cleanup as many entities as possible
	clearing_cleanup();
	
	maps\pow_hind_fly::start();
}

clearing_player_shooting()
{
	level endon( "clearing_notified" );
	
	player = get_players()[0];
	player waittill_player_shoots();
	
	flag_set( "clearing_notified" );
}

clearing_player_grenaded()
{
	level endon( "clearing_notified" );
	
	player = get_players()[0];
	player waittill("grenade_fire", grenade);
	
	while(IsDefined(grenade))
	{
		wait(0.05);
	}
	
	flag_set( "clearing_notified" );
}

get_in_heli_nag_vo()
{
	level.hind endon("switch_climbin_anim");
	
	//Play some clear dialog CDC
	wait(2.0);
	level.barnes thread pow_dialog_with_wait("clear_lets_fly");	

	barnes_lines = array( "get_in_hind", "get_into_heli" );
	
	while(true)
	{
		wait(15);		
		
		for(i=0; i<barnes_lines.size; i++)
		{
			self anim_single( self, barnes_lines[i] );
			wait(15);	
		}
	}
}

barnes_set_off_clearing( align_struct, anim_string ) //-- self == woods
{
	level endon( "clearing_notified" );
	align_struct waittill( anim_string ); //-- wait for the "see that hind" animation to FinishPlayerDamage
	
	/*
	level.scr_sound["barnes"]["take_the_shot"] = "vox_pow1_s03_005A_wood"; //Take the shot.
  level.scr_sound["barnes"]["fire_when_ready"] = "vox_pow1_s03_006A_wood"; //Mason, fire when ready.
  level.scr_sound["barnes"]["ill_take_lead"] = "vox_pow1_s03_007A_wood"; //All right, I'll take the lead.
  */
	
	wait(7);
	self anim_single( self, "fire_when_ready" );
	wait(5);
	self anim_single( self, "take_the_shot" );
	wait(5);
	self anim_single( self, "ill_take_lead" );
	
	clear_barnes();
	//flag_set( "clearing_notified" ); //-- kick off the clearing fight
	
	self waittill("shoot");
	wait(0.1);
	flag_set("clearing_notified");
}

start()
{
	//SetSavedDvar( "sm_sunSampleSizeNear", 1.208);
	SetSavedDvar( "sm_sunSampleSizeNear", 0.4);
	
	maps\_vehicle::scripted_spawn(31);
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind init_hind();
	
	//-- test
	player = get_players()[0];
	//player SetClientDvar( "compass", "0" );
	player SetClientDvar( "cg_aggressiveCullRadius", 2000 );
	player SetClientDvar( "cg_dof_useDefaultForVehicle", 0 );
	//player thread replenish_gl_ammo();
	//player thread maps\_hind_player::hud_rocket_create();
	//player thread maps\_hind_player::hud_minigun_create();
	//player notify("activate_hud");
	
	//-- DEMO
	player = get_players()[0];
	new_player_angles = (0, player.angles[1], player.angles[2]);
	player SetPlayerAngles( new_player_angles );
	player SetClientDvar("r_enablePlayerShadow", 0);
	player set_ignoreme(true);
	
	//-- DEMO
	//Depricated system now set in ART GSC
	//SetDvar( "r_heroLightScale", "1.5 1.5 1.5" );
	
	//-- DEMO
	level.barnes = simple_spawn_single("demo_barnes_spawner" );
	level.barnes set_ignoreall(true);
	level.barnes set_ignoreme(true);
	level.barnes Hide();
	
	crew_spawners = GetEntArray("heli_crew", "targetname");
	array_thread( crew_spawners, ::add_spawn_function, ::clearing_animation );
	
	/*
	clearing_tent = spawn_anim_model("clearing_tent", (0,0,0));
	clearing_tent thread clearing_animation();
	*/
	thread clearing_truck();
	
	//-- END DEMO
	
	player = get_players()[0];
	player_body = spawn_anim_model( "player_hands", player.origin );
	player DisableWeapons();
	player PlayerLinkToAbsolute(player_body, "tag_player");
	
	animated_ents = [];
	animated_ents[0] = player_body;
	animated_ents[1] = level.barnes;
	array_thread(animated_ents, ::temp_dialogue_and_logic_takeoff );
	
	flag_wait( "starting final intro screen fadeout" );
	
	align_struct = getstruct("clearing_intro_align_struct", "targetname");
	//align_struct anim_single_aligned( animated_ents, "clearing" );
	align_struct thread anim_single_aligned( player_body, "clearing" );
	
	while(1)
	{
		player_body waittill( "single anim", msg );
		if(msg == "start_barnes")
		{
			break;
		}
	}
	
	//thread switch_vision_set_after( 3 );
	
	level thread clearing_player_shooting();
	level thread clearing_player_grenaded();
	
	align_struct thread anim_single_aligned( level.barnes, "clearing" );
	level.barnes thread stop_animation_if_player_runs_past(align_struct, "clearing");
	level.barnes thread barnes_set_off_clearing( align_struct, "clearing" );
	wait(0.05);
	level.barnes Show();
	level.barnes set_force_color("b"); 
	while(1)
	{
		player_body waittill( "single anim", msg );
		if(msg == "end")
		{
			break;
		}
	}
	
	player Unlink();
	player_body Delete();
	player EnableWeapons();
	
	//-- update objective
	flag_set( "obj_kill_hind_crew" );
	
	//-- DEMO: put this back in after the demo, or do it differently with the stealth system
	//array_thread( crew_spawners, ::add_spawn_function, ::heli_crew_init );
	//perimeter_trig = GetEnt("trig_clearing_perimeter", "targetname");
	//perimeter_trig thread notify_perimeter_on_trig();
	//-- END DEMO
	
	level thread clear_barnes_ignore();
	//level thread move_barnes_when_group_cleared( "heli_crew", "trig_bc_6");
	waittill_ai_group_cleared("heli_crew");
	level thread send_barnes_to_hind();
	/*
	barnes_heli_node = GetNode( "barnes_heli_node", "targetname" );
	level.barnes SetGoalNode( barnes_heli_node );
	level.barnes.goalradius = 16;
	*/
	
	flag_set( "obj_take_hind" );
	
	// END THE MUSIC
	setmusicstate ("INTRO_FIGHT_FINISHED");
	//level.allowBattleChatter = false;
	battlechatter_off();

	//Play some clear dialog CDC
	//level.barnes thread pow_dialog_with_wait("clear_lets_fly");	
	//-- Play some nag VO
	level.barnes thread get_in_heli_nag_vo();
		
	//-- Transition to next event once the player enters the chopper
	level.hind thread maps\_hind_player::make_player_usable();
	
	level.hind thread animate_player_headset();
	level.hind thread animate_barnes_headset();
	level.hind thread wait_for_notify_then_track_notetracks();
	level.hind waittill("switch_climbin_anim");
	//level.hind animate_barnes_into_hind();
	level.hind thread animate_barnes_into_hind_and_takeoff();
		
	//level.hind waittill("player_entered");
	player = get_players()[0];
	//player FreezeControls(true);
	player SetClientDvar( "hud_showstance", "0" );
	player SetClientDvar( "actionSlotsHide", "0" );
	player SetClientDvar( "ammoCounterHide", "1" );
	
	flag_set("obj_player_in_hind"); //clears the objective poi, but does not set a new one
	
	//-- cleanup as many entities as possible
	clearing_cleanup();
	
	maps\pow_hind_fly::start();
}

stop_animation_if_player_runs_past( align_struct, anim_string ) //-- self == Woods
{
	align_struct endon( anim_string ); //-- wait for the "see that hind" animation to FinishPlayerDamage
	
	level waittill_player_past_or_event_kicked_off();
	self StopAnimScripted();
	
	level thread maps\pow_anim::notify_pilot_and_radioman( self );
	level thread maps\pow_anim::notify_truckguy( self );
	level thread maps\pow_anim::notify_fuelguy( self );
	
	if(!flag("woods_already_started_VO"))
	{
		level thread maps\_anim::anim_single( level.woods, "see_that_hind" );
		battlechatter_on();
	}
	
	level.barnes set_force_color("b"); 
}

waittill_player_past_or_event_kicked_off()
{
	level endon("clearing_notified");
	trigger_wait("trig_ran_past_woods");
}

switch_vision_set_after( time )
{
	wait(time);
	level notify("vs_clearing");
}
	
//TODO: find a better way to do this.  Maybe the climb-in animations should be removed fro teh _hind_player script
wait_for_notify_then_track_notetracks()
{
	self waittill("switch_climbin_anim");	
	
	while(!IsDefined(self.player_body))
	{
		wait(0.05);
	}
	self.player_body thread temp_dialogue_and_logic_takeoff();
}

#using_animtree("generic_human");

clearing_animation()
{
	align_struct = getstruct( "clearing_align_struct", "targetname" );
	AssertEx( IsDefined(align_struct), "Couldn't find the align node for the clearing animations" );
	
	//-- guy getting stuck in tent
	level thread delete_any_guys_in_tent("inside_the_tent");
	
	if(IsAI(self))
	{
		self thread clearing_pacifist();
		self thread clearing_notified();
		self.allowdeath = true;
	}
	
	switch( self.animname )
	{
		case "fuel":
			self thread clearing_anim_fuel( align_struct );
		break;
		
		case "inventory1":
			self thread clearing_anim_inventory( "kneel", "kneel2combat", align_struct );
		break;
		
		case "inventory2":
			self thread clearing_anim_inventory( "check", "check2combat", align_struct );
		break;
		
		case "pilot":
			self thread clearing_anim_pilot( align_struct );
		break;
		
		case "radio":
			self thread clearing_anim_radio( align_struct );
		break;
		
		case "truck":
			self thread clearing_anim_truck( align_struct );
		break;
		
		case "spetz1":
			// This guy has become a patroller.
			self.old_sightdist = self.maxsightdistsqrd;
			self.maxsightdistsqrd = 262144;
			self thread maps\_patrol::patrol("clearing_patrol_1");
			self thread large_goal_radius_with_enemy();
			//self thread clearing_anim_spetz( "guard", align_struct );
		break;
		
		case "spetz2":
			// This guy has become a patroller.
			self.old_sightdist = self.maxsightdistsqrd;
			self.maxsightdistsqrd = 262144;
			self thread maps\_patrol::patrol("clearing_patrol_2");
			self thread large_goal_radius_with_enemy();
			//self thread clearing_anim_spetz( "guard", align_struct );
		break;
		
		case "clearing_tent":
			self thread clearing_anim_tent( align_struct );
		break;
		
		default:
			AssertEX(false, "Didn't find a valid animname for this clearing spawner " + self.animname);
		break;
	}
	
	self thread clearing_watch_my_radius();
}

clearing_watch_my_radius()
{
	self endon("death");
	wait(0.05);; //-- see if making them animate some first helps
	self.my_trig = Spawn( "trigger_radius", self.origin - (0,0,10), 0, 384, 1000 );
	self.my_trig EnableLinkTo();
	self.my_trig LinkTo(self);
	self thread delete_guy_radius_trig();
	
	self.my_trig waittill("trigger");
	self StopAnimScripted();
	self.my_trig_hit = true;
	flag_set( "clearing_notified");
	
	self SetGoalPos(self.origin);
	self.goalradius = 16;
	
	wait(2);
	
	self.goalradius = 1024;
}

delete_guy_radius_trig()
{
	self endon("death");
	level waittill("clearing_notified");
	if(IsDefined(self) && IsDefined(self.my_trig))
	{
		self.my_trig Delete();
	}
}

delete_any_guys_in_tent(trigger_targetname)
{
	level waittill("clearing_notified");
	wait(1);
	
	battlechatter_on();
	
	trigger = GetEnt(trigger_targetname, "targetname");
	ai = GetAIArray("axis");
	delete = [];
	for( i = 0; i < ai.size; i++ )
	{
		if(ai[i] IsTouching(trigger))
		{
			delete[delete.size] = ai[i];
		}
	}
	
	array_thread(delete, ::bloody_death);
}

bloody_death( die )
{
	self.allowdeath = true;
	self endon( "death" );

	if( !isdefined( die ) )
	{
		die = true;	
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( !IsDefined( self ) )
	{
		return;	
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		//self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die && IsDefined( self ) && self.health )
	{
		self DoDamage( self.health + 150, self.origin );
	}
}

large_goal_radius_with_enemy()
{
	self endon("death");
	
	self waittill("enemy");
	self.goalradius = 2048;
}

clearing_anim_pilot( align_node )
{
	self thread clearing_anim_loop( align_node, "outsidetent" );
		
	level waittill_any("pilot_and_radio_go", "clearing_notified");
	
	// play some temp dialog CDC
	thread clearing_dialog_hack ();
	
	if(flag("clearing_notified"))
	{
		return;
	}
	
	self clearing_anim_single( align_node, "walktent" );
	self Delete();
	/*
	if(flag("clearing_notified") && IsAlive(self))
	{
		self anim_single( self, "out2combat" );
		return;
	}
	self clearing_anim_loop( align_node, "tentidle" );
	if(IsAlive(self))
	{
		self anim_single( self, "out2combat" );
		self anim_single( self, "runtohind" );
	}
	*/
}

clearing_anim_radio( align_node )
{
	//level waittill_any("pilot_and_radio_go", "clearing_notified");
	// play some temp dialog CDC
	self clearing_anim_single( align_node, "walk" );
	if(flag("clearing_notified"))
	{
		self StopAnimScripted();
		return;
	}
	self clearing_anim_loop( align_node, "talkloop" );
	if(IsAlive(self) && !IsDefined(self.my_trig_hit))
	{
		self anim_single( self, "talk2combat" );
	}
}

clear_ignoreall_when_notified( notify_msg )
{
	self endon("death");
	level waittill( notify_msg );
	self set_ignoreall( false );
	
}

clearing_anim_inventory( anime_loop, anim_combat, align_node )
{
	self clearing_anim_loop( align_node, anime_loop );
	if(IsAlive(self))
	{
		self.allowdeath = false; //-- to fix bug so that guy doesn't die in crate
		self anim_single( self, anim_combat );
	}
}

clearing_anim_truck( align_node )
{
	//level waittill_any("truck_go", "clearing_notified");
	
	self clearing_anim_single( align_node, "walk_by_truck" );
	if( flag("clearing_notified"))
	{
		self anim_single( self, "wave2combat" );
		return;
	}
	self clearing_anim_loop( align_node, "watch_fuel" );
	if(IsAlive(self))
	{
		self anim_single( self, "gone2combat" );
	}
}

clearing_anim_fuel( align_node )
{
	//level waittill_any("fuel_go", "clearing_notified");
	
	self clearing_anim_single( align_node, "walk" );
	self clearing_anim_loop( align_node, "loop" );
	if(IsAlive(self))
	{
		self anim_single( self, "combat" );
	}
}

clearing_anim_spetz( anime, align_node )
{
	self clearing_anim_loop( align_node, anime );
	self StopAnimScripted();
}

clearing_notified()
{
	level endon("clearing_notified");
	
	if(!flag("clearing_notified"))
	{
		self waittill_any("bullet_whizby", "damage", "death");	
	}
	
	//TUEY SET MUSIC STATE to FIGHT!
	setmusicstate ("INTRO_FIGHT");
	
	flag_set("clearing_notified");
}

clearing_pacifist()
{
	self endon("death");
	self set_pacifist( true );
	flag_wait( "clearing_notified");
	self set_pacifist( false );
}

clearing_anim_single( align_node, anime ) //self == guy
{
	if(flag("clearing_notified") || !IsAlive(self))
	{
		return;
	}
	
	level endon("clearing_notified");
	
	if(IsAlive(self))
	{
		align_node thread anim_single_aligned( self, anime );
	}
	else
	{
		return;
	}
	
	while(1)
	{
		self waittill( "single anim", msg );
		if(msg == "end")
		{
			break;
		}
	}
}

clearing_anim_loop( align_node, anime ) //self == guy
{
	self endon("death");
	
	/#	
	if(self.animname == "pilot")
	{
		println("put breakpoint here");
	}
	#/
	
	if(flag("clearing_notified") || !IsAlive(self))
	{
		return;
	}
	
	if(IsAlive(self))
	{
		align_node thread anim_loop_aligned( self, anime, undefined, "stoplooping" );
		flag_wait("clearing_notified");
	}
	else
	{
		return;
	}
}

clearing_truck() //self == align node
{
	/*
	align_struct = getstruct( "clearing_align_struct", "targetname" );
	origin = GetStartOrigin( align_struct.origin, align_struct.angles, level.scr_anim["truck"]["idle"] );
	angles = GetStartAngles( align_struct.origin, align_struct.angles, level.scr_anim["truck"]["idle"] );
	*/
	align_struct = getstruct("struct_spawn_clearing_truck", "targetname");
	vc_truck = SpawnVehicle("t5_veh_truck_gaz63_low", "vc_truck", "truck_gaz63_troops_low", align_struct.origin, align_struct.angles);
	maps\_vehicle::vehicle_init(vc_truck);
	
	level waittill_any( "clearing_notified", "truck_waved_off" );
	
	random_wait = RandomFloatRange(1.0,2.0);
	wait(random_wait);
	
	goal_struct = getstruct("clearing_truck_goal_struct", "targetname");
	vc_truck SetVehGoalPos( goal_struct.origin, true, true );
	vc_truck thread delete_on_goal();
	
}

clearing_dialog_hack()
{
	level endon ("clearing_notified");
	
	//-- this function gets called off an animation notetrack, so if you run past this will fire later and miss the first notify
	wait(0.1);
	if(flag("clearing_notified")) 
	{
		return;
	}
	
	self playsound ("vox_pow1_s03_001A_sov1");
	wait (4);
	self playsound ("vox_pow1_s03_002A_sov2");
	wait (7);
	self playsound ("vox_pow1_s03_003A_sov1");
}

move_barnes_when_group_cleared( ai_group_name, trigger_name )
{
	color_trigger = GetEnt(trigger_name, "targetname");
	color_trigger endon("trigger");
	
	waittill_ai_group_cleared(ai_group_name);
	trigger_use(trigger_name);
}

clear_barnes_ignore()
{
	flag_wait("clearing_notified");
	
	clear_barnes();
}

clear_barnes()
{
	level.barnes set_ignoreall(false);
	level.barnes set_ignoreme(false);
	level.barnes set_force_color("b"); 
	
	player = get_players()[0];
	player set_ignoreme(false);
}

notify_perimeter_on_trig()
{
	self waittill("trigger");
	level notify("perimeter_breached");
	

}

//-- This is the initial setup of the hind to make it ready for the tutorial

init_hind()	//-- self == hind helicopter
{
	//-- hind setup
	//self heli_toggle_rotor_fx(0);
	self MakeVehicleUnusable(); //-- made usable once the Spetsnaz have been killed
	
	self thread create_sam_target();
	
	//-- generic dvars that always apply to the helicopter
	players = get_players();
	
	for( i=0; i < players.size; i++ )
	{
		players[i] SetClientDvar("vehHelicopterMaxSpeedVertical", 100);
		
		//-- this is for the intial takeoff (change the vars once we have it setup for the clearing old value was 75)
		players[i] SetClientDvar("vehHelicopterMaxAccelVertical", 30); 
	}
	
	self maps\_hind_player::disable_driver_weapons();
	self ent_flag_init("took off");
	
	//-- turn off the dust kickup fx
	self thread veh_toggle_tread_fx( 0 );
	
	self thread invincible_hind();	
	self thread hind_destroyed_parts();
}

#using_animtree("generic_human");
animate_barnes_into_hind(  ) //-- self == level.hind == helicopter
{
	//-- Because AI don't link to and animate well, Barnes gets turned into a script_model for this section of the game.
	//   That is why level.barnes gets redefined
	
	level.barnes Delete();
	
	level.barnes = Spawn("script_model", self.origin);
	// level.barnes SetModel("c_usa_jungmar_barnes_pris_fb");
	level.barnes SetModel("t5_gfl_hk416_v2_body");
	level.barnes.headModel = "t5_gfl_hk416_v2_head";
	level.barnes attach(level.barnes.headModel, "", true);
	level.barnes attach("t5_gfl_hk416_v2_gear", "", true);
	level.barnes UseAnimTree( #animtree );
	level.barnes.animname = "barnes";
	
	self maps\_anim::anim_single_aligned(level.barnes, "climb_in", "origin_animate_jnt");
	level.barnes thread temp_dialogue_and_logic_takeoff();
	
//	self thread animate_barnes_takeoff_hind();
}

animate_barnes_into_hind_and_takeoff()
{
	level.barnes Delete();
	
	level.barnes = Spawn("script_model", self.origin);
	// level.barnes SetModel("c_usa_jungmar_barnes_pris_fb");
	level.barnes SetModel("t5_gfl_hk416_v2_body");
	level.barnes.headModel = "t5_gfl_hk416_v2_head";
	level.barnes attach(level.barnes.headModel, "", true);
	level.barnes attach("t5_gfl_hk416_v2_gear", "", true);
	level.barnes UseAnimTree( #animtree );
	level.barnes.animname = "barnes";
	
	level.barnes LinkTo( self, "origin_animate_jnt");
	
	level.barnes thread temp_dialogue_and_logic_takeoff();
	
	self maps\_anim::anim_single_aligned(level.barnes, "climb_in_and_takeoff", "origin_animate_jnt");
	level thread dialog_fly_story( "just_after_takeoff" );
	//level.barnes SetAnim( level.scr_anim["barnes"]["idle_in_hind"], 1, 0.05, 1 );
	
	//self thread animate_barnes_headset();
}

#using_animtree( "animated_props" );
animate_barnes_headset() //-- self is the hind
{
	self waittill("animated_switch");
	
	level.woods_headset = spawn_anim_model("barnes_headset", (0,0,0));
	level.woods_headset LinkTo( self, "origin_animate_jnt" );
	
	level.woods_headset thread temp_dialogue_and_logic_takeoff();
	self thread maps\_anim::anim_single_aligned(level.woods_headset, "takeoff", "origin_animate_jnt");
}

animate_player_headset()
{
	self waittill("playing takeoff animation");
	
	level.player_headset = spawn_anim_model("player_headset", (0,0,0));
	level.player_headset LinkTo( self, "origin_animate_jnt" );
	
	self maps\_anim::anim_single_aligned(level.player_headset, "takeoff", "origin_animate_jnt");
	level.player_headset Delete();
}

clearing_anim_tent( align_node )
{
	align_node thread anim_loop_aligned( self, "loop", undefined, "stoplooping" );
}

clearing_cleanup()
{
	player = get_players()[0];
	
	crew_spawners = GetEntArray("heli_crew", "targetname");
	array_delete(crew_spawners);
	
	/*
	tunnel_door = GetEnt("tunnel_door");
	tunnel_door Delete();
	*/
	
	destructibles = GetEntArray("destructible", "targetname" );
	urns = [];
	boards = [];
	for(i=0; i<destructibles.size; i++)
	{
		if(IsSubStr(destructibles[i].model, "dest_jun_urn"))
		{
			urns[urns.size] = destructibles[i];
		}
		else if(IsSubStr(destructibles[i].model, "dest_glo_board"))
		{
			boards[boards.size] = destructibles[i];
		}
	}
	
	array_delete(boards);
	array_delete(urns);
	
	//-- delete spawners
	russians = GetEntArray("actor_Spetsnaz_e_POW_Supervisor", "classname");
	array_delete(russians);
	
	rr_scene_guys = GetEntArray("rr_scene_guys", "targetname");
	array_delete(rr_scene_guys);
	
	vc_guys = GetEntArray("rr_vc_guys", "targetname");
	array_delete(vc_guys);
	
	vc_guys = GetEntArray("rr_vc_4", "targetname");
	array_delete(vc_guys);
	
	vc_guys = GetEntArray("rr_vc_5", "targetname");
	array_delete(vc_guys);
	
	vc_guys = GetEntArray("rr_vc_6", "targetname");
	array_delete(vc_guys);
	
	vc_rott = GetEntArray("actor_VC_e_Rottweil", "classname");
	array_delete(vc_rott);
	
	vc_ak47 = GetEntArray("actor_VC_e_AK47", "classname");
	old_vc = [];
	for(i=0; i<vc_ak47.size; i++)
	{
		if(vc_ak47[i].origin[2] < -100)
		{
			old_vc[old_vc.size] = vc_ak47[i];
		}
	}
	array_delete(old_vc);
	
	//-- leftover triggers
	ent_targetnames = array( "trig_spawn_tunnel_rush_1", "trig_baton_rusher", "trig_the_leaper", "woods_color_b24", "trig_spawn_big_room_ai_2",
													 "color_trig_after_roulette_allies", "trig_rushers_last_tunnel", "trigger_spetz_getaway", "trig_spawn_big_room_ai",
													 "trig_spawn_tunnel_rush_1", "trig_pulldown_table", "trig_tunnel_scripted_dds", "trigger_player_at_spetz",
													 "trigger_woods_at_spetz", "woods_color_b4");

	for(i = ent_targetnames.size - 1 ; i > -1; i-- )
	{
		main_ent = GetEnt( ent_targetnames[i], "targetname" );
		
		if(IsDefined(main_ent) && IsDefined(main_ent.target))
		{
			sub_ents = GetEntArray( main_ent.target, "targetname" );
			array_delete(sub_ents);
		}
		
		if(IsDefined(main_ent))
		{
			main_ent Delete();
		}
	}
	
	//-- items
	array_of_items = GetItemArray();
	for(i = array_of_items.size - 1; i > 0; i--)
	{
		if(array_of_items[i].origin[2] < -100)
		{
			array_of_items[i] Delete();
		}
	}
	
	//-- leftover objective triggers from the tunnels
	obj_triggers = GetEntArray("cave_objs", "targetname");
	array_delete(obj_triggers);
	
	//-- delete other random things
	GetEnt( "cargohanging_01", "targetname" ) Delete();
	GetEnt( "cargohanging_02", "targetname" ) Delete();
	GetEnt( "cargohanging_03", "targetname" ) Delete();
	GetEnt( "cargohanging_04", "targetname" ) Delete();	
	GetEnt( "cargohanging_05", "targetname" ) Delete();
	
}

send_barnes_to_hind()
{
	level.barnes endon("death");
	
	autosave_by_name( "pow_hind_clearing_clear" );
	
	wait(2.0);
	
	align_node = getstruct("clearing_align_struct", "targetname");
	align_node maps\_anim::anim_reach_aligned( level.barnes, "run_to_hind" );
	align_node maps\_anim::anim_single_aligned( level.barnes, "run_to_hind" );
	align_node maps\_anim::anim_loop_aligned( level.barnes, "wait_at_hind" );

} 