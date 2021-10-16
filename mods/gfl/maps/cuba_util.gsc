#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

event_thread(event_name, func, arg1, arg2, arg3, arg4, arg5)
{
	level thread do_event_thread(event_name, func, arg1, arg2, arg3, arg4, arg5);
}

do_event_thread(event_name, func, arg1, arg2, arg3, arg4, arg5)
{
	level endon(event_name + "_complete");
	single_func(level, func, arg1, arg2, arg3, arg4, arg5);
}

set_objective(objective, ent_or_pos, type)
{
	level.objective = objective;
	level.objective_pos = ent_or_pos;
	level.objective_type = type;

	wait_network_frame();
	level notify("update_objective");
}

get_hero_by_name(name, func, arg1, arg2, arg3, arg4, arg5)
{
 	name = ToLower(name);

	if (!IsDefined(level.heroes))
	{
		level.heroes = [];
	}

	if (!IsDefined(level.heroes[name]))
	{
		flag_clear(name + "!spawned");
	}
 
 	if (!flag(name + "!spawned"))
 	{
		spawner = GetEnt(name, "targetname");
		if (!is_true(spawner.spawning))
		{
			simple_spawn_single(spawner, maps\cuba_load::sf_hero);
			spawner.count++;
		}
 	}
 
 	flag_wait(name + "!spawned");	
 	hero = level.heroes[name];

	if (IsDefined(func))
	{
		single_func(hero, func, arg1, arg2, arg3, arg4, arg5);
	}

 	return hero;
}

// return an array of specific heroes
get_heroes_by_name(hero1, hero2, hero3, hero4, hero5, func, arg1, arg2, arg3, arg4, arg5)
{
	heroes = [];
	if (IsDefined(hero1))
	{
		heroes = array_add(heroes, get_hero_by_name(hero1, func, arg1, arg2, arg3, arg4, arg5));
	}

	if (IsDefined(hero2))
	{
		heroes = array_add(heroes, get_hero_by_name(hero2, func, arg1, arg2, arg3, arg4, arg5));
	}

	if (IsDefined(hero3))
	{
		heroes = array_add(heroes, get_hero_by_name(hero3, func, arg1, arg2, arg3, arg4, arg5));
	}

	if (IsDefined(hero4))
	{
		heroes = array_add(heroes, get_hero_by_name(hero4, func, arg1, arg2, arg3, arg4, arg5));
	}

	if (IsDefined(hero5))
	{
		heroes = array_add(heroes, get_hero_by_name(hero5, func, arg1, arg2, arg3, arg4, arg5));
	}

	return heroes;
}

get_all_heroes()
{
	heros = get_heroes_by_name("carlos", "woods", "bowman");
	return heros;
}

make_casual(name)
{
	if (!IsDefined(name))
	{
		name = ToLower(self.name);
	}
	
	if ( name == "woods" )
	{		
		self character\c_usa_cubcasual_barnes::main();
	}
	else if ( name == "bowman" )
	{
		self character\c_usa_cubcasual_bowman::main();
	}
	else if ( name == "carlos" )
	{
		self character\c_cub_carlos_casual::main();
	}
	else
	{
		AssertMsg("Trying to make someone casual, who doesn't have a casual character.");
	}
}

temp_player_move(start_org_name, time)
{
	point = getstruct(start_org_name, "targetname");
	while (IsDefined(point))
	{
		t = 1;
		if (IsDefined(point.script_transition_time))
		{
			t = point.script_transition_time;
		}

		get_players()[0] StartCameraTween(t);
		get_players()[0] SetOrigin(point.origin);
		get_players()[0] SetPlayerAngles(point.angles);

		wait t;

		if (IsDefined(point.target))
		{
			point = GetEnt(point.target, "targetname");
		}
		else
		{
			point = undefined;
		}

		wait .05;
	}
}

///////////////////
//
// has a guy be pacifist until he reaches his goal then cqb
//
///////////////////////////////
pacifist_till_goal()
{
	
	self endon( "death" );

	self.goalradius = 32;
	self.pacifist = true;
	
	self waittill( "goal" );

	self.goalradius = 2048;
	self.pacifist = false;
}

/* ---------------------------------------------------------------------------------
Plays police siren effect on veh
--------------------------------------------------------------------------------- */
play_sirens()
{
	sound_ent = Spawn( "script_origin", self.origin );
	sound_ent LinkTo( self, "tag_driver", (0,0,45) );
	sound_ent PlayLoopSound( "veh_police_siren" );
	
	self thread siren_stop_on_endnode(sound_ent);
	self thread siren_break(sound_ent);
}
siren_stop_on_endnode(ent)
{
	self endon ("nice_timing");
	self waittill( "reached_end_node" );
	wait 2;
	self notify( "too_late" );
	self waittill ("death");
	ent Delete();	
}
siren_break(ent)//if you destroy the cop car within 2 seconds of it reaching its end node it plays the siren break sound
{
	self endon( "too_late" );
	self waittill("damage");//this hopefully makes it so that it has to be shot before it dies so deleted vehicles dont play the sound
	self waittill( "death" );
	self notify( "nice_timing" );
	wait .5;
	ent stoploopsound(.1);
	ent playsound( "veh_siren_crash" , "sound_done" );
	ent waittill( "sound_done" );
	ent Delete();	
}

wait_and_show( time )
{
	wait time;
	self Show();
}

wait_and_delete( time, thing )
{
	self endon ("death");
	if (IsDefined( time ) )
	{
		wait time;
	}
	self Delete();
}

delete_at_node(node)
{
	self SetGoalNode(node);
	self waittill("goal");
	self Delete();
}

init_zpu_aa_gun()
{
	self endon( "death" );
	if (IsDefined(self.targetname))
	{

		self veh_magic_bullet_shield( 1 );

		switch (self.targetname)
		{

		case "balcony_ground_aa_gun":
			balcony_ground_targets = GetEntArray( "balcony_ground_targets", "targetname" );
			self thread start_aa_gun( balcony_ground_targets );
			break;
		case "balcony_roof_aa_gun":
			balcony_roof_targets = GetEntArray( "balcony_roof_targets", "targetname" );
			self thread start_aa_gun( balcony_roof_targets );
			break;
		case "courtyard_aa_gun_1":
			aa_gun_1_targets = GetEntArray( "aa_gun_1_targets", "targetname" );
			self thread start_aa_gun( aa_gun_1_targets );
			break;
		case "courtyard_aa_gun_2":
			aa_gun_2_targets = GetEntArray( "aa_gun_2_targets", "targetname" );
			self thread start_aa_gun( aa_gun_2_targets );
			break;
		case "courtyard_aa_gun_3":
			aa_gun_3_targets = GetEntArray( "aa_gun_3_targets", "targetname" );
			self thread start_aa_gun( aa_gun_3_targets );
			break;
		case "player_zpu":
			targets = getentarray("player_gun_target","targetname");
			self thread start_aa_gun(targets);
			break;		
		}
	}
}

start_aa_gun( targets , alias1 , alias2 )
{
	self endon("death");
	self endon("driver_death");
	self endon( "stop_aa_gun" );

	self thread burst_fire(alias1, alias2);

	while(1)
	{
		for(i = 0; i < targets.size; i++)
		{
			if( IsDefined( targets[i] ) )
			{
				self SetTurretTargetEnt(targets[i]);
				wait(5);
			}
		}
		wait (0.05 );
	}
}

burst_fire(alias1, alias2)
{
	self endon("death");
	self endon("driver_death");
	self endon( "balcony_plane_gone" );

	wait( RandomFloatRange( 1, 4 ) );
	
	if( IsDefined( alias1 )&& IsDefined(alias2) )
	{
		sound_ent = spawn( "script_origin" , self.origin );
		rand = randomintrange( 10, 50 );
		self thread audio_ent_fakelink( sound_ent );
		self thread burst_fire_audio_delete( sound_ent );
		while(1)
		{
			sound_ent playloopsound( alias1 );
			//for( i = 0; i < 20; i ++ )
			for( i = 0; i < rand; i ++ )//kevin randomizing the burst so it sounds more real
			{
				self FireWeapon();
				wait(0.05);
			}
			sound_ent stoploopsound();
			sound_ent playsound( alias2 );
			wait(1.5);
		}
	}
	else
	{
		while(1)
		{
			for( i = 0; i < 20; i ++ )
			{
				self FireWeapon();
				wait(0.05);
			}
			wait(1.5);
		}
	}
}

steady_fire(flag_ender)
{	
	//self = ZPU 
	sound_ent = spawn( "script_origin" , self.origin );	
	//self endon ("death");
	while(!flag(flag_ender) )
	{
		sound_ent playloopsound("wpn_btr_fire_loop_balc");	
		self FireWeapon();
		wait(0.05);	
	}
	sound_ent stoploopsound();
	sound_ent Delete();
			
}
	
	
	


audio_ent_fakelink( ent )
{
	self endon("death");
	self endon("driver_death");
	self endon( "stop_aa_gun" );
	
	while(1)
	{
		ent moveto( self.origin, .1 );
		ent waittill("movedone");
	}
}

burst_fire_audio_delete(ent)
{
	self waittill_any( "death" , "driver_death" , "balcony_plane_gone" );
	ent delete();
}

countdown( num, ender )
{
	level endon( ender );
	
	while( num > 0 )
	{
		//iPrintLn( num );
		num--;
		wait( 1 );
	}
}


///////////////////
//
// Kills specific ai with specified script_aigroup
//
///////////////////////////////
kill_aigroup( name )
{
	ai = get_ai_group_ai( name );

	for( i = 0; i < ai.size; i++ )
	{
		// stop magic bullet shield if it's on
		if ( IsDefined( ai[i].magic_bullet_shield ) && ai[i].magic_bullet_shield )
		{
			ai[i] stop_magic_bullet_shield(); 
		}

		wait( 0.05 );
		
		if( IsAlive( ai[i] ) )
		{
			ai[i] DoDamage( ai[i].health + 1, ( 0, 0, 0 ) );
		}
	}	
}


// --------------------------------------------------------------------------------
// ---- VO nag loop ----
// --------------------------------------------------------------------------------
do_vo_nag_loop( name, vo_array, ender, repeat_interval, filter_func )
{
	hero = get_hero_by_name(name);		
	x = 0;
	is_first_time = true;

	level.used_nag_lines = [];

	while( !flag( ender ) )
	{
		wait 1;
		x++;

		if (flag( ender ))
		{
			return;
		}

		if (IsDefined(filter_func) && !self [[filter_func]]())
		{
			continue;
		}

		if( x >= repeat_interval || is_first_time )
		{		
			is_first_time = false;

			//mix up the array and pick a random one
			mixed_lines = array_randomize( vo_array );
			
			//THE line
			random_line = random (mixed_lines);
			
			//hero does nag line
			hero thread maps\_anim::anim_single_queue( hero, random_line );
			x = 0;
	
			//add that line to the used array
			level.used_nag_lines = add_to_array (level.used_nag_lines, random_line );
			
			//remove the line from the nag array
			vo_array = array_remove (vo_array, random_line);

			//if we've used all the lines
			if(vo_array.size == 0)
			{
				//reset the array 
				vo_array = level.used_nag_lines;
				
				//empty the used lines array
				level.used_nag_lines = [];
				//IPrintLn ("replenished moveup lines array");
			}
		}
	}
}

lamp_light()
{
	lamps = GetEntArray("lamp", "script_noteworthy");
	for( i=0; i < lamps.size; i++ )
	{
		//lamps[i] thread Print3d_on_ent ("lamps");
		god_ray = Spawn("script_model", lamps[i].origin);
		god_ray SetModel("tag_origin");
		god_ray.angles = (-90,0,0);
		god_ray LinkTo( lamps[i] );
		PlayFXOnTag( level._effect["lamp_lightray"], god_ray, "tag_origin");
		lamps[i] PhysicsLaunch( lamps[i].origin, (0, 0, 0) );
	}
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
	// -- WWILLIAMS: FIX TO BUG 22523
	/*
	strings_set_2 = []; // multiple lines
	strings_set_2[0] = &"WMD_INTRO_LEVELNAME";
	strings_set_2[1] = &"WMD_INTRO_LOCATION";
	strings_set_2[2] = &"WMD_INTRO_NAME";
	strings_set_2[3] = &"WMD_INTRO_DATE";
	*/

	// -- WWILLIAMS: CHANGED THE SHADER COLOR TO WHITE BASED ON BUG 22525
	level thread custom_fade_screen( undefined, "bottom_left", "white", 0, 2.3, undefined, undefined, undefined, undefined, 1.5);
}



// --------------------------------------------------------------------------------
// ---- Utils for sumeet ----													   			
// --------------------------------------------------------------------------------

mission_failed( fail_msg_index_key )
{	
	if( flag( "mission_failed" ) )
		return;
	
	flag_set("mission_failed");

	if( IsDefined( fail_msg_index_key ) )
	{
		fail_message = level.fail_messages[ fail_msg_index_key ];
		maps\_utility::missionfailedwrapper( fail_message );
	}
	else
	{
		maps\_utility::missionfailedwrapper();
	}
	
}

play_vo( vo_string ) // self = AI / player
{
	self anim_single( self, vo_string );
}

set_faster_moveplayerbackrate( rate ) // self = AI
{
	if( IsDefined( rate ) )
		self.moveplaybackrate = rate;
	
	// choose random number
	self.moveplaybackrate = RandomFloatRange( 1.2, 1.5 );
}

// --------------------------------------------------------------------------------
// ---- Ambient planes ----
// --------------------------------------------------------------------------------
ambiant_planes( endon_flag, area )
{
	if( area == "zipline" )
	{
		// player is in zipline event
		ambiant_nodes = GetVehicleNodeArray( "invasion_ambiant_planes", "targetname" );
		wait_time_min = 3;
		wait_time_max = 5;
	}
	else if( area == "compound" )
	{
		// player is in compound
		ambiant_nodes = GetVehicleNodeArray( "compound_planes", "script_noteworthy" );
		ambiant_nodes  = GetVehicleNodeArray( "parking_planes", "script_noteworthy" );
	
		wait_time_min = 7;
		wait_time_max = 10;
	}
	else
	{
		// player is in parking area
		ambiant_nodes  = GetVehicleNodeArray( "parking_planes", "script_noteworthy" );
	
		wait_time_min = 1;
		wait_time_max = 2;
	}

	// get all the vehicle nodes that are supposed to trigger exploders
	array_thread( GetVehicleNodeArray( "exploder_node", "script_noteworthy" ), ::ambiant_bomb_exploders, endon_flag );

	while( !flag( endon_flag ) )
	{
		// get an array of possible unused nodes
		ambiant_unused_nodes = get_ambiant_unused_nodes( ambiant_nodes );

		// make sure we dont spawn more than 64 vehicles here
		vehicles = GetEntArray( "script_vehicle", "classname" );

		if( !ambiant_unused_nodes.size || vehicles.size >= 32 )
		{
			wait(0.1);
			continue;
		}
		
		node = random( ambiant_unused_nodes );

		if( RandomInt( 100 ) < 75 )
		{
			vehicle = "t5_veh_air_c130";
			vehicle_type = "plane_hercules";
			sound = "evt_c130_long_apex";
			apex = 3500;
		}
		else
		{
			vehicle = "t5_veh_jet_mig17_gear";	
			vehicle_type = "plane_mig17_gear";
			sound = "evt_f4_long_wash";
			apex = 3500;
		}

		plane = SpawnVehicle( vehicle, "ambiant_invasion_bombers", vehicle_type, node.origin, node.angles);
		plane.script_vehicle_selfremove = 1; 	// remove at the end of the path
		plane.script_string = "no_deathmodel"; 		
		plane.script_numbombs = 2;
		maps\_vehicle::vehicle_init( plane );  
		
		if( vehicle == "t5_veh_jet_mig17_gear" )
		{
			PlayFXOnTag( level._effect["jet_contrail"], plane, "tag_left_wingtip" );
			PlayFXOnTag( level._effect["jet_contrail"], plane, "tag_right_wingtip" );
		}
		else
		{
			PlayFXOnTag( level._effect["jet_contrail"], plane, "tag_tail_tip" );
		}
		
		plane SetForceNoCull();//SHolmes: to prevent flickering from portals, etc
		
		// pick up random speed
		plane SetSpeedImmediate( RandomIntRange( 200, 300 ), RandomIntRange( 2, 5 ), 1 );

		plane thread plane_go_path_wrapper( node );
	
		plane thread maps\_flyover_audio::plane_position_updater (apex, sound, "null"); 

		wait( RandomIntRange( wait_time_min, wait_time_max ) );
	}
}

get_ambiant_unused_nodes( ambiant_nodes )
{
	nodes = [];

	for( i=0;i<ambiant_nodes.size;i++ )
	{
		if( !IsDefined( ambiant_nodes[i].plane_inuse ) || !ambiant_nodes[i].plane_inuse )
			nodes[ nodes.size ] = ambiant_nodes[ i ];
	}

	return nodes;
}

plane_go_path_wrapper( node ) // self = plane
{	
	// set this so that we dont have two planes on the same node
	node.plane_inuse = true;

	// send this plane along the path
	self go_path( node );	
	
	// free this node
	node.plane_inuse = false;
}

ambiant_bomb_exploders( endon_flag ) // self = node
{
	level endon(endon_flag);

	while(1)
	{
		self waittill( "trigger" );
// Moved Sound call to the effect so it can be in the right place
		playsoundatposition ("evt_bomb_distant", self.origin);

		// script int stores the exploder id
		if( IsDefined( self.script_int ) )
			exploder( self.script_int );
	}
}

// --------------------------------------------------------------------------------
// ---- Follow path - when called AI will go down a certain path ----
// --------------------------------------------------------------------------------
follow_path( node_targetname, arrived_at_end_node_func )
{
	self endon( "death" );
	self endon( "stop_going_to_node" );

	node = GetNode( node_targetname, "targetname" );
	
	AssertEx( IsDefined( node ), "follow path, no start node defined for " + self.targetname );
	
	//set this so the radius doesn't explode.
	self.fixedNode = 1;

	// if arrived at end node function is specified then set that on the AI so that go_to_node can call it
	// when this AI reaches the end of the path
	if( IsDefined( arrived_at_end_node_func ) )
		self.arrived_at_end_node_func = arrived_at_end_node_func;

	self maps\_spawner::go_to_node( node, "node" );
}

stop_following_nodes() // self = AI
{
	self.fixedNode = 0;
	self notify( "stop_going_to_node" );
}

// --------------------------------------------------------------------------------
// ---- sets up a alerted patrollers, watch their damage ----
// --------------------------------------------------------------------------------
sprint_patrollers_movement( start_node_targetname, delete_flag, sprint_patrollers_end_func ) // self = patroller
{
	self endon("death");

	// dont collide, try dodging other AI's
	self.noDodgeMove = 1;
	
	self allowedStances("stand");
	self.disableArrivals = true;
	self.disableExits = true;
	self.disableTurns = true;
	//self.movePlayeBackRate = RandomFloatRange( 1.6, 2 );

	// use different variation of patrol anim
	index = RandomIntRange( 0, 7 );
	self set_generic_run_anim( "sprint_patrol_" + index, true );
	
	// delete this patroller at the end of his path
	self.delete_on_path_end = true;

	// send this guy down the path
	self thread follow_path( start_node_targetname, sprint_patrollers_end_func );

	// if delete flag is specified then AI will be deleted when the flag is set
	if( IsDefined( delete_flag ) )
	{
		flag_wait( delete_flag );	
		self Delete();
	}
}

// --------------------------------------------------------------------------------
// ---- look at and use the trigger ----
// --------------------------------------------------------------------------------
look_at_and_use( value, key, fov, ender, message_string, flag, delete_trigger, button_press_required ) // self = player
{
	self endon("death");
	
	if( !IsDefined( key ) )
		key = "targetname";
	
	trigger = GetEnt( value, key );

	if( !IsDefined( trigger ) )
		AssertEx( "look_at_and_use : Trigger not found" );

	if( IsDefined( ender ) )
		level endon(ender);

	if( !IsDefined( fov ) )
		fov = Cos(90);
		
	level.use_message_created = false;

	while(1)
	{
		if( self IsTouching( trigger ) && within_fov( self.origin, self.angles, trigger.origin, fov ) )
		{
			if( !level.use_message_created )
			{
				level.use_message_created = true;
			
				if( IsDefined( message_string ) )
				  self SetScriptHintString( message_string );
			}
		}
		else
		{
			if( level.use_message_created )
			{
				level.use_message_created = false;

				if( IsDefined( message_string ) )
					self SetScriptHintString("");
			}
		}

		if( level.use_message_created )
		{
			if( !IsDefined( button_press_required ) || button_press_required )
			{
				if( !self use_button_held() )
				{
					wait(0.05);
					continue;				
				}
			}
				
			level.use_message_created = false;
			self SetScriptHintString("");		
			
			if( IsDefined( flag ) )
				flag_set( flag );  
			
			if( IsDefined( delete_trigger ) )
				trigger Delete();

			break;
		}

		wait( 0.05 );
	}
}

// --------------------------------------------------------------------------------
// ---- door breach debug ----
// --------------------------------------------------------------------------------
/#

debug_door_breach_line( start, vec, color )
{
	end = start + vector_scale( AnglesToForward( vec ), 100 );
	RecordLine( start, end, color, "Script", self );
}

#/
// --------------------------------------------------------------------------------//
// ---- Utils for sumeet end ----													   //					
// --------------------------------------------------------------------------------//

set_wind(val, time)
{
	if (!IsDefined(level.wind_vec) || (val != level.wind_vec))
	{
		level.wind_vec = val;

		level notify("lerp_wind");
		level endon("lerp_wind");

		/* Wind doesn't seem to like being lerped
		curr_val = get_dvar_vec("wind_global_vector");

		step = .05;
		t = 0;

		if (time < .05)
		{
			time = .05;
		}

		while (t < time)
		{
			wait(step);
			t += step;

			lerp_t = linear_map(t, 0, time, 0, 1);
			new_val = LerpVector(curr_val, val, lerp_t);
			SetSavedDvar("wind_global_vector", vector_to_string(new_val));
		}
		*/

		SetSavedDvar("wind_global_vector", vector_to_string(val));
	}
}

string_to_vector(vec_str)
{
	vec = StrTok(vec_str, "( ,)");
	return (Float(vec[0]), Float(vec[1]), Float(vec[2]));
}

vector_to_string(str_vec)
{
	return (str_vec[0] + " " + str_vec[1] + " " + str_vec[2]);
}

get_dvar_vec(name)
{
	return string_to_vector(GetDvar(name));
}

get_random_spot_in_player_view(fwd_min,fwd_max,side_min,side_max,ender)
{
	level endon(ender);
	player = get_players()[0];

	fwd = AnglesToForward( player.angles );
	fwd = vector_scale( fwd, RandomIntRange( fwd_min, fwd_max ) );
	if( cointoss() )
	{
		side = AnglesToRight(player.angles);
	}
	else
	{
		side = AnglesToRight(player.angles)	 * - 1;
	}
	
	side = vector_scale( side, RandomIntRange( side_min, side_max ) );
	
	point = player.origin + fwd + side;
	point = point + (0,0,300);
	
	trace = bullettrace(point,point + (0,0,-1000),false,undefined);
	
	return trace["position"];	
}

clean_up(val, key)
{
	if (!IsDefined(key))
	{
		key = "targetname";
	}

	ents = GetEntArray(val, key);
	for (i = 0; i < ents.size; i++)
	{
		if (IsDefined(ents[i]))
		{
			ents[i] Delete();
		}
	}

	wait .05;
}

screen_message_delay_fade_delete( delayTime, endonString, fadeTime, flagName )
{
	if( IsDefined( endonString ) )
	{
		level endon ( endonString );
	}

	if( !IsDefined( delayTime ) )
	{
		delayTime = 6;
	}

	if( !IsDefined( fadeTime ) )
	{
		fadeTime = 3;
	}

	wait ( delayTime );

	if( IsDefined( level.missionfailed ) && level.missionfailed )
	{
		return;
	}

	if( GetDvarInt( "hud_missionFailed" ) == 1 )
	{
		return;
	}

	if( IsDefined( fadeTime ) && fadeTime > 0 )
	{
		if( IsDefined( level._screen_message_1 ) )
		{
			level._screen_message_1 FadeOverTime( fadeTime );
			level._screen_message_1.alpha = 0;
		}

		if( IsDefined( level._screen_message_2 ) )
		{
			level._screen_message_2 FadeOverTime( fadeTime );
			level._screen_message_2.alpha = 0;
		}

		if( IsDefined( level._screen_message_3 ) )
		{
			level._screen_message_3 FadeOverTime( fadeTime );
			level._screen_message_3.alpha = 0;
		}

		wait ( fadeTime );

		if( IsDefined( level.missionfailed ) && level.missionfailed )
		{
			return;
		}

		if( GetDvarInt( "hud_missionFailed" ) == 1 )
		{
			return;
		}
	}

	if( IsDefined( flagName ) )
	{
		flag_set( flagName );
	}

	screen_message_delete();
}