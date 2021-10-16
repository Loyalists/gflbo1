#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

/*------------------------------------
spawns the hero characters
------------------------------------*/

// -- WWILLIAMS: USED IN WMD_INTRO
spawn_heros() 
{
	level.heroes=[];
	level.heroes["kristina"] = simple_spawn_single("spawner_weaver",::setup_heroes);	
	//level.heroes["mitchell"] = simple_spawn_single("hero_hudson",::setup_heroes);	
	level.heroes["glines"] = simple_spawn_single("spawner_harris",::setup_heroes);
	level.heroes["pierro"] = simple_spawn_single("spawner_brooks",::setup_heroes);
	
	wait(.25);
	
	level.heroes["kristina"].name = ("Weaver");
	//level.heroes["mitchell"].name = ("Lucas");
	level.heroes["glines"].name = ("Harris");
	level.heroes["pierro"].name = ("Brooks");
	
	level.weaver = level.heroes["kristina"];
	//level.heroes["mitchell"] = level.brooks;
	level.brooks = level.heroes["pierro"];
	level.harris = level.heroes["glines"];
}

setup_heroes()
{		
		//disabling these while we use the stealth system
		
		self.pacifistwait = 0;
		self.pacifist = 1;
		self.ignoresuppression = 1;
		self.accuracy = .8;
		self.ignoreme = true;	
		self.goalradius = 32;
		self make_hero();
		self pushplayer(true);
}

// -- WWILLIAMS: USED IN WMD_INTRO
set_player_stances(stand,crouch,prone)
{
	
	self allowstand(stand);
	self allowcrouch(crouch);
	self allowprone(prone);
	
}


/*------------------------------------
wrapper for add_spawn_function that 
makes it less cumbersome
------------------------------------*/
/*
make_spawn_function(value,function,key)
{
	if(!isDefined(key))
	{
		key = "targetname";
	}
	spawners = getspawnerarray();
	for(i=0;i<spawners.size;i++)
	{
		if(isDefined(spawners[i].key) && spawners[i].key == value)
		{
			spawners[i] add_spawn_function(function);
		}
	}
}
*/
/*------------------------------------
returns any AI with the specified script noteworthy
supports single ents or an array
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO
getai_by_noteworthy(script_noteworthy)
{
	ents = getentarray(script_noteworthy,"script_noteworthy");
	guys = [];
	
	if(ents.size < 1)
	{
		return;
	}	
	else
	{
	
		for(i=0;i<ents.size;i++)
		{
			if(isAI(ents[i]) && isAlive(ents[i]))
			{
				guys[guys.size] = ents[i];
			}
		}
		
		if(guys.size > 1)
		{	
			return guys;
		}
		else if( guys.size < 1)
		{
			return;
		}
		else
		{
			return guys[0];
		}
	}	
}

/*------------------------------------
returns any AI with the specified key/value. 
the key defaults to "targetname" unless specified
supports single ents or an array
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO AND WMD_RTS
getai(value,key)
{
	if(!isDefined(key))
	{
		key = "targetname";
	}
	
	ents = getentarray(value,key);
	guys = [];
	
	if(ents.size < 1)
	{
		return;
	}	
	else
	{
	
		for(i=0;i<ents.size;i++)
		{
			if(isAI(ents[i]) && isAlive(ents[i]))
			{
				guys[guys.size] = ents[i];
			}
		}
		
		if(guys.size > 1)
		{	
			return guys;
		}
		else if( guys.size < 1)
		{
			return;
		}
		else
		{
			return guys[0];
		}
	}	
	
}

/*------------------------------------
moves the players after spawning them in
used in skipto's/starts
------------------------------------*/
/*
move_players(spots)
{

	players = get_players();
	points = ent_get(spots);
	if(!isDefined(points))
	{
		points = getstructarray(spots,"targetname");
	}
	
	for(x =0;x<players.size;x++)
	{
		players[x] setorigin(points[x].origin);
		if(isDefined(points[x].angles))
		{
			players[x] setplayerangles( points[x].angles);
		}
	}
	
}
*/

/*
attack_player()
{
	self alert_notify_wrapper();
	players = get_players();
	self.goalorigin = 128;
	self setgoalentity(players[0]);
}
*/

//uses a script_struct like a trigger radius ( keep down those ent counts! )
/*
org_trigger(org,radius,notification)
{
	
	trig = false;
	while(!trig)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if( distancesquared(players[i].origin,org) < radius * radius)
			{
				trig = true;
			}
		}
		wait(.1);
	}
	
	if(isDefined(notification))	
	{
		level notify(notification);
	}
}
*/

/*
delete_on_goal()
{
	self endon ("death");
	self waittill ("goal");
	self delete();
	
}	
*/

/*------------------------------------
shows a msg
------------------------------------*/
/*
show_message( time, message, y, player )
{	
	self endon( "disconnect" );	
			
	if(!isDefined(self.message_hud))
	{
		self.message_hud = newclientHudElem( self );

		self.message_hud.hidewheninmenu = true;
		self.message_hud.horzAlign = "center";
		self.message_hud.vertAlign = "middle";
		self.message_hud.alignX = "center";
		self.message_hud.alignY = "middle";
		self.message_hud.x = 0;
		self.message_hud.y = y;
		self.message_hud.foreground = true;
		self.message_hud.font = "default";
		self.message_hud.fontScale = 1.5;
		self.message_hud.color = ( 1.0, 1.0, 1.0 );			
	}
	
	if( isDefined ( player ) )
	{
		self.message_hud setText( message, player );
	}
	else
	{
		self.message_hud setText( message );
	}
	self.message_hud.alpha = 1;
	self.message_hud fadeOverTime( time );
	
	self.message_hud.alpha = 0;
	
	wait( time + 0.2 );
}
*/
/*------------------------------------
debug 3d print
------------------------------------*/
// -- WWILLIAMS: USED IN MULTIPLE UTIL FUNCTIONS
print_3d( message, color, no_offset )
{
	return;

	self endon( "death" );
	if(isDefined(self._3d_print))
	{
		return;
	}
	self._3d_print = 1;
	
	if( !isdefined( color ) )
	{
		color = ( 0.48, 9.4, 0.76 );
	}

	while( 1 )
	{
		
		if( isdefined( no_offset ) && no_offset )
		{		
			print3d( self.origin, message, color, 1, 1 ); 
		}
		else
		{
			print3d( self.origin +( 0, 0, 65 ), message, color, 1, 1 ); 
		}
		
		wait( 0.05 ); 
	}
	
}


/*
Print_on_ent( msg ) 
 { 
 /# 
	self endon( "death" );  
	self notify( "stop_print3d_on_ent" );  
	self endon( "stop_print3d_on_ent" );  

	while( 1 ) 
	{ 
		print3d( self.origin + ( 0, 0, 0 ), msg );  
		wait( 0.05 );  
	} 
 #/ 
 }
 */

// -- WWILLIAMS: USED IN WMD_INTRO AND WMD_RTS
set_white_body_models(guys)
{
	level._white_models = true;
	
	for(i=0;i<guys.size;i++)
	{
		guys[i].old_model = guys[i].model;	

		// if(isDefined(guys[i].gearModel))
		// {		
		// 	guys[i] detach ( guys[i].headModel,"");
		// }
		// if(isDefined(guys[i].gearModel))
		// {
		// 	guys[i] detach ( guys[i].gearModel,"");	
		// }
		// guys[i] setmodel("c_rus_spetznaz_snow_sr71_fb");
	}
}

// -- WWILLIAMS: USED IN WMD_INTRO
restore_body_model(guys)
{
	level._white_models = false;

	for(i=0;i<guys.size;i++)
	{
		// if(isDefined(guys[i].old_model))
		// {
		// 	guys[i] setmodel("c_usa_blackops_winter_body3_fb");
		// }
	}	
}

//-- GL: used to keep AI from dodging around each other in poor ways when you are overhead
ai_no_dodge( on_or_off )
{
	self.noDodgeMove = on_or_off;
}
 



/*------------------------------------
changes the FOV over time
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO
lerp_fov_over_time( time, destfov )
{
	basefov = GetDvarFloat( #"cg_fov" );
	incs = int( time/.05 );
	incfov = (  destfov  -  basefov  ) / incs ;
	currentfov = basefov;
	for ( i = 0; i < incs; i++ )
	{
		currentfov += incfov;
		self setClientDvar( "cg_fov", currentfov );
		wait .05;
	}

	self setClientDvar( "cg_fov", destfov );
}

/*------------------------------------
puts on the visor  TODO: make co-op friendly
------------------------------------*/
/*
visor_on()
{
	// Do weapon change
	
	clientNotify( "toggle_jump_goggles" );
}
*/
/*------------------------------------
takes off the visor  TODO: make co-op friendly
------------------------------------*/
/*
visor_off()
{
	if(IsDefined(level.visor))
	{
		level.visor Destroy();
	}
}
*/



/*------------------------------------
//STEALTH STUFF///
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO
notify_damage_or_death(guy) 
{
	//self = level
 	self endon (guy.targetname +"_alert");
 
 	str = guy.targetname +"_alert";
 
 	guy waittill_any ("damage", "bulletwhizby", "death", "alert");
 	
 	//iprintlnbold (str);
 	
	//notfy example: "radar_guy_ai_altert" 
 	level notify (str);
 }
 
/*------------------------------------`
sets up the patrollers
self = patroller guy
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO & WMD_RTS
setup_patroller(dont_patrol,patrol_target,no_track_player)
{	
	self endon("death");
	self.old_sightdist = self.maxsightdistsqrd;
	self.a.disablelongdeath = true;
	self clearenemy();
	target = undefined;
	if(!isDefined(dont_patrol))
	{
		if(isDefined(self.target))
		{
			target = self.target;
		}
		else if(!isDefined(patrol_target))
		{
			target = self.script_noteworthy;
		}
		else
		{
			target = patrol_target;
		}
		self thread maps\_patrol::patrol(target);
	}
	waittillframeend;
	
	self thread waitfor_enemy();
	if(!isDefined(no_track_player))
	{
		self thread patroller_wait();
	}
}


/*------------------------------------
This is the main state tracker which waits
for the patroller to be notified of any potential danger
from the player or from another alerted patrol guy
------------------------------------*/
#using_animtree("generic_human");
// -- WWILLIAMS: USED BY SETUP_PATROLLER
patroller_wait()
{
	self endon("death");
	team = "axis";
	self.ignoreall = true;
	self.alerted = false;
	self.deathAnim = %death_stand_dropinplace;
	self thread patrol_stealth_track_player();
	self thread patrol_stealth_damage_notify();
	self thread patrol_track_enemy_fire();
	self thread patrol_death_notify();
	
	self waittill_any("grenade danger","alert","bulletwhizby");
	self notify("enemy");
	self.ignoreall = false;
	self.alerted = true;
	self thread print_3d("alerted");	
	wait(2);
	friends = getaiarray(team);
	for(i=0;i<friends.size;i++)
	{
		if(isAlive(friends[i]) && distancesquared(friends[i].origin,self.origin) < 1024*1024)
		{
			if(isalive(friends[i]) && self != friends[i])
			{
				friends[i] alert_notify_wrapper();
				friends[i] thread print_3d("alerted_by_friend");
				friends[i] thread alert_nearby_for_30_seconds();
			}
		}
	}
	if(flag("allow_alert"))
	{
		flag_set("area_alerted");
	}
}
// -- WWILLIAMS: USED BY SETUP PATROLLER
patrol_track_enemy_fire()
{
	self endon("death");
	
	while(self.a.lastShootTime == 0)
	{
		wait(.05);
	}
		
	friends = getaiarray(self.team);
	for(i=0;i<friends.size;i++)
	{
		if(isAlive(friends[i]) && distancesquared(friends[i].origin,self.origin) < 1024*1024)
		{
			friends[i] alert_notify_wrapper();
			friends[i] thread print_3d("alerted_heard_enemy_shot");
			friends[i] thread alert_nearby_for_30_seconds();
		}
	}
}
// -- WWILLIAMS: USED BY SETUP_PATROLLER
patrol_death_notify()
{
	self waittill("death");
	if(!isDefined(self))
	{
		return;
	}
	
	friends = getaiarray(self.team);
	for(i=0;i<friends.size;i++)
	{
		if(isAlive(friends[i]) && distancesquared(friends[i].origin,self.origin) < 400*400 )
		{
			if(can_see_other(friends[i],self))
			{
				friends[i] alert_notify_wrapper();
				friends[i] thread print_3d("alerted_nearby_death");
				friends[i] thread alert_nearby_for_30_seconds();
			}
		}
	}
}
// -- WWILLIAMS: USED BY SETUP_PATROLLER
patrol_stealth_track_player()
{
	
	self endon("death");
	self endon("enemy");
	self endon("fire");
	
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			stance = players[i] getstance() ;
			dist = distancesquared( players[i].origin,self.origin);
			
			if(isDefined(players[i].ignoreme) && players[i].ignoreme )
			{
				wait .05;
				continue;
			}
			if(players[i] isnotarget() )
			{
				wait .05;
				continue;
			}

			if(dist <= 96*96)					// alert if the player stands up within a 128 unit radius, otherwise no pose is safe if the guard can see the player
			{
				if( stance == "stand" || stance == "crouch" )
				{
					wait(.5); // 2 second wait is where a 'reaction' animation would go
					self alert_notify_wrapper();
				}
				else if (self can_see_player(players[i]))
				{
					wait(.5);
					self alert_notify_wrapper();
				}
			}
			
			if(dist <= 256*256)			// alert if the player stands up within a 512 unit radius, otherwise no pose is safe if the guard can see the player
			{
				if( stance != "prone" && self can_see_player(players[i]) )
				{
					wait(.5); // 2 second wait is where a 'reaction' animation would go
					self alert_notify_wrapper();
				}
			}			
				
			else if(dist <= 600*600)		//only alert if the player is NOT proned and the guard has line of sight. If the player is prone, we dont' care if he's with a 512 unit radius
			{
				if(stance == "stand" && self can_see_player(players[i]))
				{
					wait(.5);
					self alert_notify_wrapper();
				}
			}			
			
		}
		wait(.1);
	}
	
}

/*
heroes_cqbwalk(val)
{

	keys = getarraykeys(level.heroes);
	for(i=0;i<keys.size;i++)
	{		
		level.heroes[keys[i]].cqbwalking = val;		
	}
}
*/
// -- WWILLIAMS: USED BY SETUP_PATROLLER
patrol_stealth_damage_notify()
{
	self endon("death");
	
	team = self.team;
	self waittill_any("damage","pain","pain_death");
	self alert_notify_wrapper();;
}

// -- WWILLIAMS: USED BY MULTIPLE UTIL FUNCTIONS
alert_nearby_for_30_seconds()
{
	self endon("death");
	if(isDefined(self._isalerting))
	{
		return;
	}
	self._isalerting = true;
	x=0;
	//wait 2 seconds to give the player a chance to kill the ai before he is able to notify everyone
	while(x < 60)
	{
		friendlies = getaiarray(self.team);
		enemies = getaiarray("allies");
		friends = array_combine(friendlies,enemies);
		for(i=0;i<friends.size;i++)
		{
			if(friends[i] != self && distancesquared(friends[i].origin,self.origin) < 512*512)
			{
				if(isalive(friends[i]) )
				{
					friends[i] thread print_3d("alerted");
					friends[i] alert_notify_wrapper();
				}
			}
		}
		wait(.5);
		x++;
	}
}

// WWILLIAMS: USED IN PATROL_STEALTH_TRACK_PLAYER
can_see_player(player)
{
	
		yaw  =  self animscripts\utility::GetYawToSpot(player.origin );

		if(yaw > 80 || yaw < -80 )
		{
			return false;
		}
		success = SightTracePassed(self gettagorigin( "tag_eye" ) , player gettagorigin( "tag_eye" ) , false, undefined );
		return success;	
}

// WWILLIAMS: USED BY PATROL_DEATH_NOTIFY
can_see_other(seeing_ent,seen_ent)
{
	
	yaw  = seeing_ent animscripts\utility::GetYawToSpot(seen_ent.origin );
		
	if(yaw > 61 || yaw < -59 )
	{
		success = false;
		return false;
	}
	
	success = seen_ent SightConeTrace( seeing_ent gettagorigin("tag_eye"), seeing_ent, seeing_ent.angles, 60 );//BulletTracePassed(seeing_ent gettagorigin( "tag_eye" ) , seen_ent gettagorigin( "tag_origin" ) + (0,0,34), false, undefined );

	return success;
}


/*------------------------------------
grab all the turrets and make the AI aware of them
------------------------------------*/
/*
init_turrets()
{
	turrets = ent_array("checkpoint_turret","script_noteworthy");	
	array_thread(turrets,::make_ai_aware_of_turret,"axis");
	
}
*/
/*------------------------------------
Make the AI aware of a turret and use it when appropriate.
self = a turret
------------------------------------*/
/*
make_ai_aware_of_turret(side)
{
	
	self.maxrange = 3000;
	self._make_aware = false;
	
	while(1)
	{
		//check every second to see if it should be used
		wait(1);
		
		//grab the closest AI to the turret within 800 units
		guy = get_closest_ai( self.origin, side );
		if(isDefined(guy))
		{
			if(distancesquared(guy.origin,self.origin) > 512*512)
			{
				continue;
			}
			if(isDefined(guy.script_patroller))
			{
				continue;
			}
			
			//check to see which team this turret is being used by
			if(side == "axis")
			{
				enemies = getaiarray("allies");
				players = get_players();
				living = array_combine(enemies,players);
				spot = get_closest_living( self.origin, living);
				if(!isDefined(spot))
				{
					continue;
				}
				yaw  =  self animscripts\utility::GetYawToSpot(spot.origin );
			}
			else
			{
				yaw  =  self animscripts\utility::GetYawToSpot(get_closest_ai(self.origin,"axis").origin );
			}
			// this checks to see if it even makes sense for the guy to use the turret ( I.E. - the player is not out of the turrets arc of fire )
			// if the yaw is too great in either direction, then it doesn't make sense to use this turret
			if(!isDefined(yaw))
			{
				continue;
			}
			
			// this means that the left/right arc should be set at 60 
			// currently not doing any up/down or line of sight checking.
			if(yaw > 61 || yaw < -59 )
			{
				self setturretignoregoals(false); //<--- make sure the guy isnt' forced to stay on the turret now and can choose a new cover spot
				continue;
			}					
			//if we've passed the previous checks, then the turret should be used by this guy, so go use it! 
			guy goto_turret(self);
			if(isDefined(guy)&& isalive(guy))
			{
				self setturretignoregoals(true); //<--- i'm not 100% sure what this does, but it makes dudes look better when using a turret by sorta forcing them to stay on it
			}
		}
		//keep waiting until the turret is free again
		while( isDefined(self GetTurretOwner() ) )
		{
			//if an enemy gets too close or goes outside of his arc, then drop the turret
			
			//TODO - this is hardcoded to only check for the player and needs to be expanded to combine players + ai into the check
			yaw  =  self animscripts\utility::GetYawToSpot(get_closest_player(self.origin).origin );
			if(yaw > 61 || yaw < -59 )
			{
				
				if(!isPlayer(self getturretowner()))
				{
					self getturretowner() StopUseTurret(); 
				}
				self setturretignoregoals(false); //<--- make sure the guy isnt' forced to stay on the turret now and can choose a new cover spot
			}
			wait(.25);
		}
		self setturretignoregoals(false);
	}
}
*/
/*------------------------------------
send a guy to the cover node by the turret
------------------------------------*/
/*
goto_turret(turret)
{
	self endon("death");
	self endon("bad_path");	

	//grab the turret's node
	anode = turret get_turret_node();				
	
	//make sure he gets close enough to make the warping less noticable when he uses the turret
	self.goalradius = 32;
	self setgoalnode(anode);
	self waittill("goal");
	self.ignoresuppression = 1;

	//increase his goal radius to make sure he can choose a new cover node if he needs to 
	//self.goalradius = 2048;
	
	//use the turret
	self maps\_spawner::use_a_turret(turret);
	turret waittill("turretstatechange");
	
	friends = getaiarray(self.team);
	for(i=0;i<friends.size;i++)
	{
		if(isAlive(friends[i]) && distancesquared(friends[i].origin,self.origin) < 2048*2048)
		{
			friends[i] alert_notify_wrapper();
			friends[i] thread print_3d("alerted_heard_enemy_shot");
			friends[i] thread alert_nearby_for_30_seconds();
		}
	}
	
}
*/

/*------------------------------------
get the node which targets the turret
------------------------------------*/
/*
get_turret_node()
{
	nodes = getnodearray("turrets","script_noteworthy");
	for(i=0;i<nodes.size;i++)
	{
		if( isDefined(nodes[i].target) && nodes[i].target == self.targetname)
		{
			return nodes[i];
		}
	}	
}
*/
// -- WWILLIAMS: USED BY SETUP_PATROLLER
//waits for the patroller to encounter an enemy
waitfor_enemy(spawners)
{
	self endon("death");
	
	self waittill("enemy");
	//wait(.5);
	//set their sightrange and goalradius back to default ( or whatever values you want ). 
	self.goalradius = level.default_goalradius;
	self.maxsightdistsqrd = self.old_sightdist;
	
	self.script_patroller = undefined;
}


////////////////////////////////////////////////////////////////////////////
// CUSTOM WHITE SCREEN FADE

/*
	SAMPLE USAGE:

		custom_fade_screen();				// basic fade out then back in:
		custom_fade_screen( text_array );	// fade out, display text, fade text away, then fade back in
		custom_fade_screen( text_array, "bottom_right" );  
		custom_fade_screen( text_array, "bottom_right", "white" );  

	Note: The sub-functions can be called individually. 

		Ex: To fade out at the end of the level (no fade in)

			custom_fade_screen_out();

		Ex: To fade text in and out (no background shader)

			custom_fade_screen_text( text_array );

	//------------------------------------------------------------------------

	NOTIFIES SENT
	
		level notify( "screen_fade_out_complete" ); 	// the moment screen turns completely black/white

		level notify( "text_line_fade_in" );			// The moment when a single line of text begins to fade in
														// This will be sent once for each line of text

		level notify( "text_begin_fade_out" );			// The moment when all text is starting to fade out

		level notify( "text_fade_out_complete" );		// The moment when all text is faded out

		level notify( "screen_fade_in_begins" ); 		// the moment screen start to fade back into the game

		level notify( "screen_fade_in_complete" ); 		// the moment screen completely returns back into the game

	//------------------------------------------------------------------------

	PARAMETERS: No required parameters

		text_array			- Array of text strings, in order they will be displayed (any size)
								undefined ( default )

		alignment_type		- Position of text 
							  	"center"
								"bottom_left" ( default )
								"bottom_right"
								"top_left"
								"top_right"

		shader				- Color of background
								"black" ( default )
								"white"

		fade_out_time		- Time to completely fade out
								2.0 ( default )

		fade_in_time 		- Time to completely fade back in
								2.0 ( default )

		space_between_text	- 30 ( default )

		text_scale_first_line	- 1.75 ( default )

		text_scale_other_lines	- 1.5 ( default )

		font				- "default" ( default )

		pause_before_text	- Time between screen fades out and first line of text appearing
								0 ( default )

		pause_time_after_line1 - Time between first line of text appearing and the second line
								 appearing, in case the first line has some significance
								2.0 ( default )

		pause_time_after_other_lines - Time between each line of text appearing (except between
									   the first and second line)								 
										1.5 ( default )

		text_fade_in_time	- Time for each line of text to fade in
								1.2 ( default )

		text_fade_out_time	- Time for text to fade out (all lines fade out together)
								1.2 ( default )

		time_before_fade_out - Time for all text to be displayed on screen, before fading out starts.

*/
// -- WWILLIAMS: USED IN WMD_INTRO
custom_fade_screen( text_array, alignment_type, shader, fade_out_time, fade_in_time, space_between_text, 
					text_scale_first_line, text_scale_other_lines, font, pause_before_text, pause_time_after_line1, 
					pause_time_after_other_lines, text_fade_in_time, text_fade_out_time, time_before_fade_out )
{
	custom_gary_fade = false;
	
	if( custom_gary_fade )
	{
		fade_in_time = 0;
	}
	
	custom_fade_screen_out( shader, fade_out_time );

	custom_fade_screen_text( text_array, alignment_type, space_between_text, text_scale_first_line, 
					text_scale_other_lines, font, pause_before_text, pause_time_after_line1, 
					pause_time_after_other_lines, text_fade_in_time, text_fade_out_time, time_before_fade_out );

	custom_fade_screen_in( fade_in_time );
}

// -- WWILLIAMS: USED IN WMD_INTRO
custom_fade_screen_out( shader, time )
{
	// define default values
	if( !isdefined( shader ) )
	{
		shader = "black";
	}

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( isdefined( level.fade_screen ) )
	{
		level.fade_screen Destroy();
	}

	level.fade_screen = NewHudElem(); 
	level.fade_screen.x = 0; 
	level.fade_screen.y = 0; 
	level.fade_screen.horzAlign = "fullscreen"; 
	level.fade_screen.vertAlign = "fullscreen"; 
	level.fade_screen.foreground = true;
	level.fade_screen SetShader( shader, 640, 480 );

	if( time == 0 )
	{
		level.fade_screen.alpha = 1; 
	}
	else
	{
		level.fade_screen.alpha = 0; 
		level.fade_screen FadeOverTime( time ); 
		level.fade_screen.alpha = 1; 
		wait( time );
	}
	level notify( "screen_fade_out_complete" );
}
// -- WWILLIAMS: USED IN WMD_INTRO
custom_fade_screen_in( time )
{
	level notify( "screen_fade_in_begins" );

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( !isdefined( level.fade_screen ) )
	{
		// error: the screen was not faded in in the first place
		//        for now, simply do nothing.
		return;
	}

	if( time == 0 )
	{
		level.fade_screen.alpha = 0; 
	}
	else
	{
		level.fade_screen.alpha = 1; 
		level.fade_screen FadeOverTime( time ); 
		level.fade_screen.alpha = 0; 
	}
	
	wait( time );
	level notify( "screen_fade_in_complete" );
}

custom_fade_screen_text( text_array, alignment_type, space_between_text, text_scale_first_line, 
					text_scale_other_lines, font, pause_before_text, pause_time_after_line1, 
					pause_time_after_other_lines, fade_in_time, fade_out_time, time_before_fade_out )
{
	// setting up default values
	if( !isdefined( time_before_fade_out ) )
	{
		time_before_fade_out = 2.0;
	}

	if( !isdefined( text_array ) || text_array.size == 0 )
	{
		// no text to display. Simply wait out the time and exit
		wait( time_before_fade_out );
		return;
	}

	if( !isdefined( space_between_text ) )
	{
		space_between_text = 30;
	}

	if( !isdefined( text_scale_first_line ) )
	{
		if ( level.splitscreen && !level.hidef )
			text_scale_first_line = 2.75;
		else
			text_scale_first_line = 1.75;
	}

	if( !isdefined( text_scale_other_lines ) )
	{
		if ( level.splitscreen && !level.hidef )
			text_scale_other_lines = 2.00;
		else
			text_scale_other_lines = 1.5;
	}

	if( !isdefined( alignment_type ) )
	{
		alignment_type = "bottom_left";
	}

	if( !isdefined( pause_before_text ) )
	{
		pause_before_text = 0;
	}

	if( !isdefined( pause_time_after_line1 ) )
	{
		pause_time_after_line1 = 2.0;
	}

	if( !isdefined( pause_time_after_other_lines ) )
	{
		pause_time_after_other_lines = 1.5;
	}

	if( !isdefined( fade_in_time ) )
	{
		fade_in_time = 1.2;
	}

	if( !isdefined( fade_out_time ) )
	{
		fade_out_time = 1.2;
	}

	// determine the general alignment
	
	// default is bottom left of screen
	align_x = "left";
	align_y = "bottom";
	horz_align = "left";
	vert_align = "bottom";
	first_line_y_offset = ( text_array.size - 1 ) * space_between_text * -1;

	if( alignment_type == "center" )
	{
		align_x = "center";
		align_y = "middle";
		horz_align = "center";
		vert_align = "middle";
		first_line_y_offset = ( text_array.size - 1 ) * space_between_text * -0.5;
	}
	else if( alignment_type == "bottom_right" )
	{
		align_x = "right";
		align_y = "bottom";
		horz_align = "right";
		vert_align = "bottom";
		first_line_y_offset = ( text_array.size - 1 ) * space_between_text * -1;
	}
	else if( alignment_type == "top_left" )
	{
		align_x = "left";
		align_y = "top";
		horz_align = "left";
		vert_align = "top";
		first_line_y_offset = 0;
	}
	else if( alignment_type == "top_right" )
	{
		align_x = "right";
		align_y = "top";
		horz_align = "right";
		vert_align = "top";
		first_line_y_offset = 0;
	}

	// create the hud elements
	level.fade_screen_text = [];

	for( i = 0; i < text_array.size; i++ )
	{
		level notify( "text_line_fade_in" );

		y_pos = first_line_y_offset + ( i * space_between_text );

		level.fade_screen_text[i] = NewHudElem(); 
		level.fade_screen_text[i].x = 0; 
		level.fade_screen_text[i].y = y_pos; 
		level.fade_screen_text[i].alignX = align_x; 
		level.fade_screen_text[i].alignY = align_y; 
		level.fade_screen_text[i].horzAlign = horz_align; 
		level.fade_screen_text[i].vertAlign = vert_align; 
		level.fade_screen_text[i].sort = 1; // force to draw after the background
		level.fade_screen_text[i].foreground = true; 
		level.fade_screen_text[i] SetText( text_array[i] ); 

		if( i == 0 )
		{
			level.fade_screen_text[i].fontScale = text_scale_first_line; 
		}
		else
		{
			level.fade_screen_text[i].fontScale = text_scale_other_lines; 
		}

		if( fade_in_time == 0 )
		{
			level.fade_screen_text[i].alpha = 1; 
		}
		else
		{
			level.fade_screen_text[i].alpha = 0; 
			level.fade_screen_text[i] FadeOverTime( fade_in_time ); 
			level.fade_screen_text[i].alpha = 1; 
		}
	
		if( IsDefined( font ) )
		{
			level.fade_screen_text[i].font = font;
		}

		// wait between the lines 
		if( i < text_array.size - 1 ) // there are still more lines
		{
			if( i == 0 )
			{
				wait( pause_time_after_line1 );
			}
			else
			{
				wait( pause_time_after_other_lines );
			}
		}
	}

	// all text is drawn. Time to begin fading them out
	wait( time_before_fade_out );

	level notify( "text_begin_fade_out" );

	for( i = 0; i < level.fade_screen_text.size; i++ )
	{
		level.fade_screen_text[i] FadeOverTime( fade_out_time );
		level.fade_screen_text[i].alpha = 0; 
	}	

	// destroy the hud elements once fade out is complete
	wait( fade_out_time );

	for( i = 0; i < level.fade_screen_text.size; i++ )
	{
		level.fade_screen_text[i] Destroy();
	}	

	level notify( "text_fade_out_complete" );
}

screen_fade_in()
{
	strings_set_2 = []; // multiple lines
	strings_set_2[0] = &"WMD_SR71_INTRO_LEVELNAME";
	strings_set_2[1] = &"WMD_SR71_INTRO_LOCATION";
	strings_set_2[2] = &"WMD_SR71_INTRO_NAME";
	strings_set_2[3] = &"WMD_SR71_INTRO_DATE";

	level thread custom_fade_screen( strings_set_2, "bottom_left", "black", 0, 2.0, undefined, undefined, undefined, undefined, 1.5);
}

/*------------------------------------
Tethers Barnes to the player
------------------------------------*/
/*
barnes_follows_player()
{
	level.heroes["kristina"].ignoreall = 1;
	flag_wait("players_landed");
	
	players = get_players();
	player = players[0];
	
	player endon("death");
	player endon("disconnect");
	
	while(1)
	{
		if(distancesquared(level.heroes["kristina"].origin,player.origin) > 384*384)
		{
			level.heroes["kristina"] moveto_new_pos(player.origin);
			level.heroes["kristina"] waittill_either("goal","bad_path");
		}
		wait(.5);
	}
	
}
*/
/*
do_nag_dialogue(name,dialogue,nag_flag)
{
	
	add_dialogue_line( name, dialogue );
	x = 0;
	while(!flag(nag_flag))
	{
		wait 1;
		x++;
		if(x == 10)
		{
			add_dialogue_line( name, dialogue );
			x = 0;
		}
	}	
}
*/

/*------------------------------------
tells the squad to move to a new position and take up cover
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_RTS
moveto_new_pos(pos,time)
{
	self endon("death");
	self notify("new_pos");	
	self endon("new_pos");	
	self endon("forced_prone");	
	
	if(!isDefined(time))
	{
		time = 0;
	}
	
	wait(time *.1);
	
	self AllowedStances("crouch","stand");
	
	self.ignoresuppression = 1;
	self.grenadeawareness = 0;
	self.goalradius = 64;
	
	wait(RandomFloatRange(0.1, 0.4));
	
	self setgoalnode(pos);
	
	self waittill_either("goal","bad_path");	
	
	self.goalradius = 256;
	self.fixednode = false;
	self.grenadeawareness = 1;
	
	if(pos.type == "Path")
	{
		wait(2);
		self AllowedStances("crouch", "stand");
	}
}

// -- WWILLIAMS: USED IN WMD_RTS
turn_jeep_lights_on(rts)
{
	if( isSubstr(self.model,"gaz"))
	{
		playfxontag(level._effect["rts_uaz_headlight"], self, "tag_headlight_left" );
		playfxontag(level._effect["rts_uaz_headlight"], self, "tag_headlight_right" );
	}
	else if(isDefined(rts) || isSubstr(self.targetname,"rts_") )
	{
		playfxontag(level._effect["rts_uaz_headlight"], self, "tag_headlight_left" );
		playfxontag(level._effect["rts_uaz_headlight"], self, "tag_headlight_right" );
		playfxontag(level._effect["uaz_taillight"], self, "tag_tail_light_left" );
		playfxontag(level._effect["uaz_taillight"], self, "tag_tail_light_right" );

	}
	else
	{	
		playfxontag(level._effect["uaz_headlight"], self, "tag_headlight_left" );
		playfxontag(level._effect["uaz_headlight"], self, "tag_headlight_right" );
		playfxontag(level._effect["uaz_taillight"], self, "tag_tail_light_left" );
		playfxontag(level._effect["uaz_taillight"], self, "tag_tail_light_right" );
	}
}

/*
turn_on_player_view_fx()
{
	players = get_players();
	players[0] do_player_view_particles();
}
*/
/*------------------------------------
plays "flying through the air" effects on the player as he's freefalling
------------------------------------*/
/*
do_player_view_particles()
{
	if(!isDefined(self.wmd_fx_org))
	{
		self.wmd_fx_org = spawn("script_model",self.origin);
		self.wmd_fx_org setmodel("tag_origin");
		self.wmd_fx_org linkto(self,"tag_origin");
		playfxontag(level._effect["player_cloud"], self.wmd_fx_org,"tag_origin");
	}
}
*/
/*
stop_player_view_particles()
{
	if(isDefined(self.wmd_fx_org))
	{
		self.wmd_fx_org delete();
	}
}
*/
/*
morph_fog_settings(setting)
{
	
	if(setting == "lower")
	{
		start_dist = 0;
		halfway_dist = 22000;
		halfway_height = 12500;
		base_height = 50000.9;
		red = 0.43;
		green = 0.41;
		blue = 0.43;
		trans_time = 9;
	
		setVolFog(	start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
	
	if(setting == "upper")
	{
		start_dist = 0;
		halfway_dist = 2398;
		halfway_height = 19649;
		base_height = 27247;
		red = 1.65;
		green = 1.5;
		blue = 1.5;
		trans_time = 1;
	
		setVolFog(	start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}	
}
*/
/*
player_speed_control()
{
	players_speed_set(.7 );	
}
*/
/*
players_speed_set( speed )
{

	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		players[i] SetMoveSpeedScale( speed ); 
	}
	level.current_player_speed = speed;

}
*/
// -- WWILLIAMS: USED IN WMD_RTS
shoot_and_kill( enemy )
{
	self endon( "death" );
	//enemy endon( "death" );

	self.perfectAim = true;
	//enemy.health = 1;
	while( IsAlive(enemy) && !IsDefined(enemy.fake_killed))
	{
		self shoot_at_target( enemy,"J_head" );
		wait(0.05);
	}

	self.perfectAim = false;
	self notify( "enemy_killed" );
}

/*------------------------------------
run on a spawner as a spawn function
------------------------------------*/
/*
spawnfunc_ignoreall()
{
	self.ignoreall = true;
}
*/
/* spawnfunc_e2_init()
{
	self.alerted = false;
	self SetThreatBiasGroup("enemies");
	self.targetname = "e2_guard";
	self thread setup_patroller();
	self thread maps\wmd_event2::enemy_wait_for_whizby();
	self thread maps\wmd_event2::enemy_wait_for_damage();
	
}

spawnfunc_towersniper_init()
{
	self.alerted = false;
	self SetThreatBiasGroup("enemies");
	self.targetname = "e2_sniper";
	self thread setup_patroller();
	self thread maps\wmd_event2::enemy_wait_for_whizby();
	self thread maps\wmd_event2::enemy_wait_for_damage();
	
}

spawnfunc_e2_truck_guys()
{
	self.alerted = false;
	self SetThreatBiasGroup("enemies");
	self.targetname = "e2_guard";
	self thread setup_patroller(1);
	self thread load_e2_truck();
	self thread maps\wmd_event2::enemy_wait_for_whizby();
	self thread maps\wmd_event2::enemy_wait_for_damage();
	
} */
/*
spawnfunc_e2_building_guys()
{
	self.pathenemyfightdist = 96;
}
*/
/*
spawn_func_delete_on_goal()
{
	self endon("death");
	self.goalradius = 5;
	self.ignoreall = 1;
	self waittill("goal");
	self delete();
}
*/

/*------------------------------------
a wrapper for "getent" and "getentarray" that 
assumes "targetname" for the key if not specified. Eliminates
the need to use both calls

returns either an array or a single ent depending on what
it finds
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO AND WMD_RTS
ent_get(value,key)
{
	if(!isDefined(value))
	{
		return undefined;
	}
	if(!isDefined(key))
	{
		key = "targetname";
	}		
	ents = getentarray(value,key);
	if(!isDefined(ents))
	{
		return undefined;
	}
	if(ents.size < 1)
	{
		return undefined;
	}	
	if(ents.size > 1)
	{	
		return ents;
	}
	return ents[0];
}
// -- WWILLIAMS: USED IN WMD_INTRO AND WMD_RTS
ent_array(value,key)
{
	if(!isDefined(value))
	{
		return undefined;
	}
	if(!isDefined(key))
	{
		key = "targetname";
	}		
	ents = getentarray(value,key);
	return ents;
		
}

/*
load_e2_truck()
{
	self endon("death");
	self endon("alert");
	self endon("enemy");
	self.goalradius = 16;
	self.disablearrivals = true;
	self.disableexits = true;
	start_node = getnode(self.script_noteworthy,"script_noteworthy");
	end_node = getnode(start_node.target,"targetname");
	while(1)
	{
		self setgoalnode(start_node);
		self.goalradius = 16;
		self waittill("goal");
		wait(3);
		self setgoalnode(end_node);
		self waittill("goal");
		self.goalradius = 16;
		wait(3);		
	}
	
}
*/

/*------------------------------------
creates a hud prompt for the player
self = LEVEL
------------------------------------*/
// -- USED IN WMD_INTRO
set_hud_prompt(string,x_offset,y_offset,font_scale)
{
	if(!isDefined(self._prompt))
	{
		self._prompt = newClientHudElem( get_players()[0] );
	}
	
	if(!isDefined(x_offset))
	{
		x_offset = 0;
	}
	if(!isDefined(y_offset))
	{
		y_offset = 90;
	}
	if(!isDefined(font_scale))
	{
		font_scale = 1.5;
	}
	
	
	self._prompt.x = x_offset;
	self._prompt.y = y_offset;
	self._prompt.alignX = "center";
	self._prompt.alignY = "middle";
	self._prompt.horzAlign = "center";
	self._prompt.vertAlign = "middle";
	self._prompt.fontScale = font_scale;
	self._prompt settext(string);
	self._prompt.alpha = .8;
}

// -- USED IN WMD_RTS, BUT MIGHT NOT BE NEEDED. TODO: AFTER A COUPLE OF WEEKS CHECK TO SEE IF NEEDED
set_hud_prompt_test(string,ui3d)
{
	if(!isDefined(self._prompt2))
	{
		self._prompt2 = newClientHudElem( get_players()[0] );
	}
	self._prompt2.x = 90;
	self._prompt2.y = -90;
	self._prompt2.alignX = "center";
	self._prompt2.alignY = "middle";
	self._prompt2.horzAlign = "center";
	self._prompt2.vertAlign = "middle";
	self._prompt2.fontScale = 1.5;
	self._prompt2 settext(string);
	self._prompt2.alpha = 1;
	self._prompt2.ui3dwindow = ui3d;
}
// -- WWILLIAMS: USED IN WMD_RTS
hide_hud_prompt()
{
	self._prompt FadeOverTime(0.5);
	self._prompt.alpha = 0;
}


/*------------------------------------------------------------------------

SR71 STUFF

------------------------------------------------------------------------*/

// -- WWILLIAMS: THIS IS IN WMD_RTS BUT COMMENTED OUT TODO: AFTER A COUPLE WEEKS SEE IF STILL NEEDED
spawn_sr71_cam(cam_struct_targetname,ender,do_dialogue,mark_targets)
{

	level endon(ender);

	camera_struct = GetStruct(cam_struct_targetname, "targetname");
	
	camera_ent = spawn("script_origin",camera_struct.origin);
	camera_ent.angles = camera_struct.angles;
	camera_ent.movement_max_dist = camera_struct.radius;
	
	camera_ent.camera_struct = spawn("script_origin", camera_struct.origin);
	camera_ent.drift_target = GetStruct(camera_struct.target,"targetname");
	
	player = get_players()[0];	
	player thread player_moves_camera(camera_ent,mark_targets,ender);
	
	if(do_dialogue)
	{
		level thread enemy_spotted_dialogue();
	}
}


// -- WWILLIAMS: USED IN SPAWN_SR71_CAM
player_moves_camera(cam,mark_targets,ender)	// self == player
{
	self endon("disconnect");
	level endon("sr71_end");
	level endon(ender);
	level endon("sr71_relaystation_end");
	
	cam_move_scale = 30.0;
	camera_start_pos = cam.origin;
	level.goal_cam_pos = camera_start_pos;

	min_x = camera_start_pos[0] - (cam.movement_max_dist / 2);
	max_x = camera_start_pos[0] + (cam.movement_max_dist / 2);

	min_y = camera_start_pos[1] - (cam.movement_max_dist / 2);
	max_y = camera_start_pos[1] + (cam.movement_max_dist / 2);
	
	level thread camera_drift(cam,50,ender);
	level thread check_for_enemy_target(cam,mark_targets);
	
	delay = 0.1;

	new_pos = cam.camera_struct.origin;
	old_pos = cam.camera_struct.origin;
	self.playing_loop = false;
	while(1)
	{
		
		movement = self GetNormalizedMovement();
		
		
		if(movement[0] == 0 && movement[1] == 0 )
		{
			if(self.playing_loop)
			{
				self stoploopsound();
				self playsound("evt_sr71_camera_scroll_stop");
				self.playing_loop = false;
			}	
		}
		else
		{
			
			if(!self.playing_loop)
			{
				self.playing_loop = true;
				self stoploopsound();
				self playloopsound("evt_sr71_camera_scroll_loop");
			}			
		}		

		movement = (movement[0], 0 - movement[1], movement[2]);
		
		// amount the camera struct has moved over the last wait(delay) below
		delta_camdrift = cam.camera_struct.origin - old_pos;
		
		new_pos = new_pos + (movement * cam_move_scale) + delta_camdrift;//goal_cam_pos + (movement * cam_move_scale);
		
		if(new_pos[0] > max_x)
		{
			new_pos = (max_x, new_pos[1], new_pos[2]);
		}
		else if(new_pos[0] < min_x)
		{
			new_pos = (min_x, new_pos[1], new_pos[2]);
		}
		
		if(new_pos[1] > max_y)
		{
			new_pos = (new_pos[0], max_y, new_pos[2]);
		}
		else if(new_pos[1] < min_y)
		{
			new_pos = (new_pos[0], min_y, new_pos[2]);
		}
		
		if(IsDefined(level.force_cam_pos))
		{
			cam SetOrigin(level.force_cam_pos);
			level.goal_cam_pos = cam.origin;
			new_pos = level.goal_cam_pos;
			level.force_cam_pos = undefined;
		}
		else if(new_pos != level.goal_cam_pos)
		{
			level.goal_cam_pos = new_pos;
			cam MoveTo(level.goal_cam_pos, delay);
		}
		
		// save the camera struct position before the wait, to check for the delta
		old_pos = cam.camera_struct.origin;
		
		//reset the min/max camera movement 
		min_x = old_pos[0] - (cam.movement_max_dist / 2);
		max_x = old_pos[0] + (cam.movement_max_dist / 2);

		min_y = old_pos[1] - (cam.movement_max_dist / 2);
		max_y = old_pos[1] + (cam.movement_max_dist / 2);
		
		wait(delay);
		
		check_for_sr71_triggers(cam);
	}
}

// -- WWILLIAMS: USED IN PLAYER_MOVES_CAMERA
camera_drift(cam,time,ender)
{
	level endon("sr71_end");
	level endon(ender);
	level endon("sr71_relaystation_end");
	
	add_dialogue_line("SR71 Pilot","Targets in range, engage optics");
	cam.camera_struct moveto(cam.drift_target.origin,time);
	cam.camera_struct waittill("movedone");
	add_dialogue_line("SR71 Pilot","Done with the surveilance run, optics disengaged");
	level notify("done_spotting_relay");
}


/*------------------------------------
triggers that can be activated via tha SR71 camera looking at it
------------------------------------*/
// -- WWILLIAMS: USED IN PLAYER MOVES CAMERA
check_for_sr71_triggers(cam)
{

	selected = undefined;
	triggers = ent_array("sr71_cam_triggers");
	for ( i = 0; i < triggers.size; i++ )
	{
		trigger 				= triggers[i];
		angles 					= cam.angles;
		origin 					= cam.origin;				
		sight 					= anglestoforward( angles );
		vec_to_enemy  	= vectornormalize( trigger.origin - origin ); 
			
		//do we have an enemy centered in the sights?
		if( vectordot( sight, vec_to_enemy ) < .90  )
		{				
			continue;
		}
		
		trigger notify("trigger",get_players()[0]);

	}
	
}


/*------------------------------------
checks to see if the player is looking at an enemy through the SR71 camera
------------------------------------*/
// -- WWILLIAMS: USED IN PLAYER_MOVES_CAMERA
check_for_enemy_target(cam,mark_targets)
{
	level notify("stop_checking_targets");
	level endon("stop_checking_targets");
	
	player = get_players()[0];
	reticule = ent_get("cam_reticule");
	
	reticule hide();
	reticule._hidden = true;
	
	screen = getent("sr71_screen","targetname");
	
	screen SetClientFlag(0);	
	
	while(1)
	{
		selected = undefined;
		enemies = getaiarray("axis");
		for ( i = 0; i < enemies.size; i++ )
		{
			enemy 					= enemies[i];
			angles 					= cam.angles;
			origin 					= cam.origin;				
			sight 					= anglestoforward( angles );
			vec_to_enemy  	= vectornormalize( enemy.origin - origin ); 
			
			if(isDefined(enemy.is_marked))
			{
				continue;
			}			
			
			//do we have an enemy centered in the sights?
			if( vectordot( sight, vec_to_enemy ) < .996 )
			{				
				continue;
			}
						
			selected = enemy;
			break;

		}
		if(!isDefined(selected))
		{
			if(!reticule._hidden)
			{
				//reticule hide();
				screen SetClientFlag(0);
				level hide_hud_prompt();
				level notify("stop_waiting");
				reticule._hidden = true;
			}
		}
		else
		{
			//show the 'target' reticule so the player gets some feedback about highlighting enemies
			if(reticule._hidden)
			{
				screen ClearClientFlag(0);	
				//reticule show();
				screen playsound("evt_sr71_camera_highlight");
				level notify("enemy_spotted");
				if(mark_targets)
				{
					level thread wait_for_player_to_mark_enemy(selected,screen);
				}
				reticule._hidden = false;
			}
		}
		wait(.05);
	}	
}


/*------------------------------------
play some dialogue when the player highlights an enemy w/the SR71 cam
------------------------------------*/
// -- WWILLIAMS: USED IN SPAWN_SR71_CAM
enemy_spotted_dialogue()
{
	level endon("stop_spotting");
	
	while(1)
	{
		level waittill("enemy_spotted");
		add_dialogue_line("Camera Operator","Enemy spotted");
		wait(5);
	}
	
}

// -- WWILLIAMS: USED IN MARK_NEARBY_ENEMIES
store_enemy_target_location(spot)
{
	if(!isDefined(level.marked_targets))
	{
		level.marked_targets = [];
	}
	
	level.marked_targets[level.marked_targets.size] = spot;
	
}

// -- WWILLIAMS: USED IN WMD_RTS
wait_for_player_to_mark_enemy(enemy,screen)
{
	level endon("stop_waiting");	
	
	reticule = ent_get("cam_reticule");	
	player = get_players()[0];
	
	level thread set_hud_prompt(&"WMD_MARK_TARGET");
	
	while(!player usebuttonpressed() )
	{
		wait(.05);
	}
	
	enemy.is_marked = true;	
	mark_nearby_enemies(enemy);	
	level hide_hud_prompt();
	
	//screen = getent("sr71_screen","targetname");	
	screen SetClientFlag(0);	
	screen playsound("evt_sr71_camera_mark");
	reticule hide();
	reticule._hidden = true;
	add_dialogue_line("Camera Operator","Enemy location marked");
		
}

/*------------------------------------
treats enemies that are close to the highlighted
enemy as a group
------------------------------------*/

mark_nearby_enemies(guy)
{	
	guys = [];
	axis = getaiarray("axis");
	for(i=0;i<axis.size;i++)
	{
		if(axis[i] == guy)
		{
			continue;
		}
		if(distancesquared(axis[i].origin,guy.origin) < 256 * 256)
		{
			axis[i].is_marked = true;
			guys[guys.size] = axis[i];
		}
	}
	
	guys = add_to_array(guys,guy);
	
	spot = average_origin( guys );
	spot = spot + (0,0,60);
	level thread store_enemy_target_location(spot);
	
}

/*------------------------------------
marks the enemy targets
------------------------------------*/
/*
draw_marked_locations()
{
	
	trigs = ent_array("lookat_trigs","targetname");	
	
	if(isDefined(level.marked_targets))
	{
		for(i=0;i<level.marked_targets.size;i++)
		{
			trig = trigs[i];
			trig.obj_num = i+10;
			trig.origin = level.marked_targets[i];
			objective_add(i+10,"current");
			objective_position(i+10,level.marked_targets[i]);
			trig thread wait_to_be_looked_at();
			Objective_Set3D( i+10, true );
		}			
	}
}
*/

/*------------------------------------
wait for the enemy location to be looked at
------------------------------------*/
// -- WWILLIAMS: USED IN MAIN WMD_SR71
wait_to_be_looked_at()
{
	self endon("stop_look");
	player = get_players()[0];
	
	while(1)
	{
		self waittill("trigger");
		wait(.5);
		if(player is_player_looking_at( self.origin, 0.85, false ) && distancesquared(self.origin,player.origin) < 1500*1500)
		{
			break;
		}
	}
	
	objective_set3d(self.obj_num,0);
	objective_delete(self.obj_num);	
	self delete();
	
}

// -- WWILLIAMS: USED IN WMD_INTRO
spawn_player_body(node)
{
	body = spawn_anim_model( "player_body" ,node.origin,node.angles);
	body useanimtree(level.scr_animtree["player_body"] );
	return body;
}


/*------------------------------------
//returns array of specified ALLIED color team. Valid colors are "r","b","y","c","g","p","o"
------------------------------------*/
/*
get_allied_color_team(color)
{
	guys = [];
	
	allies = getaiarray("allies");
	for (i = 0; i < allies.size; i++ )
	{
		if (IsDefined(allies[i].script_forceColor) && (allies[i].script_forceColor == color))
		{
			guys[guys.size]=allies[i];
		}
	}
	return guys;
}		
*/

/*------------------------------------
this makes the AI only do their idle anims at cover nodes
( so they don't peek around corners , etc )
------------------------------------*/
// -- WWILLIAMS: USED IN WMD_INTRO
init_idle_nodes()
{
	nodes = getnodearray("idle_only_nodes","script_noteworthy");
	for(i=0;i<nodes.size;i++)
	{
		nodes[i].script_onlyidle = 1;
	}
}

// -- WWILLIMAS: USED IN WMD_INTRO
hide_and_remove_player_weapons()
{
	player = get_players()[0];
	player disableweapons();
	
	
	player AllowCrouch(false);
	player AllowJump(false);
	player AllowLean(false);
	player AllowMelee(false);
	player AllowProne(false);
	player AllowSprint(false);
	player AllowStand(true);	
	
	//hide default hands/gun
	player HideViewModel();
}
// -- WWILLIAMS: IS IN WMD_INTRO BUT COMMENTED OUT TODO: CLEAN UP
show_and_enable_player_weapons()
{
	player = get_players()[0];
	player enableweapons();
	
	player AllowCrouch(true);
	player AllowJump(true);
	player AllowLean(true);
	player AllowMelee(true);
	player AllowProne(true);
	player AllowSprint(true);
	player AllowStand(true);	
	
	//hide default hands/gun
	player ShowViewModel();
	
}

// -- WWILLIAMS: USED IN WMD_INTRO
stop_timescale_on_timer(time)
{
	wait(time);
	SetTimeScale(1);
}

// -- WWILLIAMS: USED IN WMD_RTS
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( !isdefined( die ) )
	{
		die = true;	
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

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
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die && IsDefined( self ) && self.health )
	{
		self DoDamage( self.health + 150, self.origin );
	}
}

// -- WWILLAIMS: NEEDED FOR BLOODY DEATH
// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}
	if(isDefined(level.is_in_rts))
	{
		fxName = level._effect["rts_bloodsplatter"];
	}

	PlayFxOnTag( fxName, self, tag );
}


// -- WWILLIAMS: NEEDED FOR BLOODY DEATH
is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}


// Fake death
// self = the guy getting worked
extreme_bloody_death( die, delay )
{
	self endon( "death" );

	if( !isdefined( die ) )
	{
		die = true;	
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	if( !IsDefined(self) )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	if( !IsDefined( self ) )
	{
		return;	
	}

	tags = [];
	tags[0] = "j_head";
	
	for( i = 0; i < 3; i++ )
	{
		if( IsAlive(self) )
		{
			random = RandomInt(tags.size);
			self thread extreme_bloody_death_fx( tags[random], undefined );
			self PlaySound ("prj_bullet_impact_large_flesh");
		}
		wait( RandomFloat( 0.1 ) );
	}

	if( die && IsDefined(self) && IsAlive(self) )
	{
		self DoDamage( self.health + 100, self.origin);
	}
}	


// self = the AI on which we're playing fx
extreme_bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["bloody_death"][ RandomInt(level._effect["bloody_death"].size) ];
	}

	PlayFxOnTag( fxName, self, tag );
}


close_on_player()	//self = ai
{
	self endon("death");
	
	while(1)
	{
		self.goalradius = 64;
		
		self setgoalpos(get_players()[0].origin);
		
		self waittill("goal");
	}
}


/*
seek_player(goalrad)
{
	self.goalradius = 128;
	if (IsDefined(goalrad))
	{
		self.goalradius = goalrad;
	}
	self SetGoalEntity( get_players()[0] );	
}
*/

get_pilot_ent()
{
	// During the intro, the pilot will be found by this clause.
	pilots = ent_array("sr71_pilots");
	
	for(i = 0; i < pilots.size; i ++)
	{
		if(pilots[i].animname == "pilot")
		{
			return pilots[i];
		}
	}
	
	// We'll fall through to here in the RTS.
	plane = GetEnt("sr71_cam", "targetname");
	return plane.pilot;
}

get_operator_ent()
{
	// During the intro, the player will be found by this clause.
	pilots = ent_array("sr71_pilots");
	
	for(i = 0; i < pilots.size; i ++)
	{
		if(pilots[i].animname == "operator")
		{
			return pilots[i];
		}
	}
	
	// We'll fall through to here in the RTS
	
	operator = GetEnt("sr71_cam", "targetname");
	return operator;
}

get_hudson_ent()
{
	for(i = 0; i < level.rts_heroes.size; i ++)
	{
		if(IsDefined(level.rts_heroes[i].animname) && level.rts_heroes[i].animname == "hudson")
		{
			return level.rts_heroes[i];
		}
	}
}

hud_utility_init()
{
	//Create a fullscreen element that we can use for fades and flashbacks.
	level.hud_utility 					 = NewHudElem();
	level.hud_utility.x 				 = 0;
	level.hud_utility.y 			   = 0;
	level.hud_utility.horzAlign  = "fullscreen";
	level.hud_utility.vertAlign  = "fullscreen";
	level.hud_utility.foreground = false; //Arcade Mode compatible
	level.hud_utility.sort			 = 3;
	
	//Set the default shader.
	level.hud_utility setShader( "black", 640, 480 );
	
	//Hide the element until needed.
	level.hud_utility.alpha = 0;
}

hud_utility_show( shader, fadeSeconds )
{
	//If the hud utility does not yet exist...
	if( !isDefined( level.hud_utility ) )
	{
		//Create one now.
		hud_utility_init();
	}
	
	//If a shader was given, switch to it.
	if( isDefined( shader ) )
	{
		level.hud_utility setShader( shader, 640, 480 );
	}
	
	//If no seconds were specified or are not positive...
	if( !isDefined( fadeSeconds ) || fadeSeconds <= 0 )
	{
		level.hud_utility.alpha = 1;
	}
	else
	{
		//Fade into the color over the specified amount of time.
		level.hud_utility fadeOverTime( fadeSeconds );
		level.hud_utility.alpha = 1;
		wait( fadeSeconds );
	}
	
	//All done! Notify whoever called this.
	self notify( "fade_complete" );
}

hud_utility_hide( shader, fadeSeconds )
{
	//If the hud utility does not yet exist...
	if( !isDefined( level.hud_utility ) )
	{
		//Create one now.
		hud_utility_init();
	}
	
	//If a shader was given, switch to it.
	if( isDefined( fadeSeconds ) )
	{
		level.hud_utility setShader( shader, 640, 480 );
	}
	
	//If no seconds were specified or are not positive...
	if( !isDefined( fadeSeconds ) || fadeSeconds <= 0 )
	{
		level.hud_utility.alpha = 0;
	}
	else
	{
		//Fade into the color over the specified amount of time.
		level.hud_utility fadeOverTime( fadeSeconds );
		level.hud_utility.alpha = 0;
		wait( fadeSeconds );
	}

	//All done! Notify whoever called this.
	self notify( "fade_complete" );
}

exploder_for_period(id, time, second_id, before_end)
{
	if(!IsDefined(before_end))
	{
		before_end = 0;
	}
	
	exploder(id);
	wait time - before_end;
	
	if(IsDefined(second_id))
	{
		exploder(second_id);
	}
	
	wait(before_end);
	
	stop_exploder(id);
}

lerp_dof_over_time(near_start, near_end, far_start, far_end, near_blur, far_blur, time)
{
	old_near_start = self GetDepthOfField_NearStart();
	old_near_end = self GetDepthOfField_NearEnd();
	old_far_start = self GetDepthOfField_FarStart();
	old_far_end = self GetDepthOfField_FarEnd();
	old_near_blur = self GetDepthOfField_NearBlur();
	old_far_blur = self GetDepthOfField_FarBlur();
	
	endTime = time;
	deltaTime = 0;
	
	while( endTime > deltaTime )
	{
		if(endTime == 0)
		{
			break;
		}
		ratio = deltaTime/endTime;
		delta_near_start = calc_dof(old_near_start, near_start, ratio);
		delta_near_end = calc_dof(old_near_end, near_end, ratio);
		delta_far_start = calc_dof(old_far_start, far_start, ratio);
		delta_far_end = calc_dof(old_far_end, far_end, ratio);
		delta_near_blur = calc_dof(old_near_blur, near_blur, ratio);
		delta_far_blur = calc_dof(old_far_blur, far_blur, ratio);
		
		self SetDepthOfField(delta_near_start, delta_near_end, delta_far_start, delta_far_end, delta_near_blur, delta_far_blur);
		
		//wait, then loop.
		wait 0.05;
		deltaTime = deltaTime + 0.05;
	}
	
	//done with tween, set to values. 
	self SetDepthOfField(near_start, near_end, far_start, far_end, near_blur, far_blur);
}

calc_dof(old, new, ratio)
{
	return (((new-old)*ratio)+old);
}

nag_direction_after_aigroup( _ai_group, _nag_line )
{
	waittill_ai_group_cleared( _ai_group );
	
	operator = get_operator_ent();
	anim_single( operator, _nag_line );
}