#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;

main()
{
	//This MUST be first for CreateFX!
	maps\frontend_fx::main();
	
	maps\_specialops::delete_by_type( maps\_specialops::type_so );

	frontend_precache();

	level.contextualMeleeFeature = false;
	level.onMenuMessage = ::menu_message;
	level.onDec20Message = ::frontend_dec20_message;

	maps\_load::main();

	maps\frontend_amb::main();
	maps\frontend_anim::main();
	
	init_flags();
	init_level_vars();
	
	level thread frontend_player_connect();
	
	thread set_default_vision();
	thread level_load_fade();
	
	level thread play_aligned_fx();
	level thread stoolpush();	

}

frontend_precache()
{
	PrecacheMenu( "main" );
	PrecacheMenu( "main_lockout" );
	PrecacheMenu( "main_text" );
	PrecacheMenu( "main_setup" );
	PreCacheModel("p_int_interrogation_chair_strap");
	PreCacheModel("p_int_monitor_a_extracam");
	PreCacheModel("p_int_monitor_b_extracam");
	PreCacheModel("p_int_monitor_c_extracam");
	PreCacheModel("p_int_monitor_c_bink");
	PrecacheShellShock("int_escape");
	PrecacheShellShock("electrocution");
	PreCacheString( &"FRONTEND_PRESS_BUTTON_TO_SIT_DOWN");
	PrecacheShader( "logo_cod2" );
	PreCacheShader("cinematic");
	PreCacheRumble("melee_garrote");
	
	character\gfl\character_gfl_m16a1::precache();
	character\gfl\character_gfl_ak12::precache();
}

spy_monitors_randomize()
{
	level endon ("first_interstitial_go");
	monitor1 = GetEnt( "security_monitor", "targetname" );
	monitor2 = GetEnt( "security_monitor_01", "targetname" );
	monitor3 = GetEnt( "security_monitor_02", "targetname" );
	//monitor4 = GetEnt( "security_monitor_03", "targetname" );
	monitor5 = GetEnt( "security_monitor_04", "targetname" );
	monitor_xc1 = GetEnt( "security_monitor_xc", "targetname" );
	monitor_xc2 = GetEnt( "security_monitor_xc_01", "targetname" );
	monitor_xc3 = GetEnt( "security_monitor_xc_02", "targetname" );
	//monitor_xc4 = GetEnt( "security_monitor_xc_03", "targetname" );
	monitor_xc5 = GetEnt( "security_monitor_xc_04", "targetname" );

	monitor1 hide();
	monitor_xc1 show();

	while (1)
	{
		wait(randomfloat(10));
		j=randomint(20);
		switch(j)
		{
		case 0:
			break;
		case 1:
			monitor2 hide();
			monitor_xc2 show();
			//monitor4 hide();
			//monitor_xc4 show();
			break;
		case 2:
			monitor3 hide();
			monitor_xc3 show();
			monitor5 hide();
			monitor_xc5 show();
			break;
		case 3:
			monitor2 show();
			monitor_xc2 hide();
			//monitor4 show();
			//monitor_xc4 hide();
			break;
		case 4:
			monitor3 show();
			monitor_xc3 hide();
			monitor5 show();
			monitor_xc5 hide();
			break;
		case 5:
			monitor2 hide();
			monitor_xc2 show();
			monitor3 hide();
			monitor_xc3 show();
			//monitor4 hide();
			//monitor_xc4 show();
			monitor5 hide();
			monitor_xc5 show();
			break;
		case 6:
			monitor2 show();
			monitor_xc2 hide();
			monitor3 show();
			monitor_xc3 hide();
			//monitor4 show();
			//monitor_xc4 hide();
			monitor5 show();
			monitor_xc5 hide();
			break;
		default:
			break;
		}
	}
}

set_monitors_to_snow()
{
	monitor1 = GetEnt( "monitor_01", "targetname" );
	monitor2 = GetEnt( "monitor_02", "targetname" );
	monitor3 = GetEnt( "monitor_03", "targetname" );
	monitor4 = GetEnt( "monitor_04", "targetname" );
	monitor5 = GetEnt( "monitor_05", "targetname" );
	monitor6 = GetEnt( "monitor_06", "targetname" );
	monitor7 = GetEnt( "monitor_07", "targetname" );
	monitor8 = GetEnt( "monitor_08", "targetname" );
	monitor9 = GetEnt( "monitor_09", "targetname" );
	monitor1 setclientflagasval(63);
	monitor2 setclientflagasval(63);
	monitor3 setclientflagasval(63);
	monitor4 setclientflagasval(63);
	monitor5 setclientflagasval(63);
	monitor6 setclientflagasval(63);
	monitor7 setclientflagasval(63);
	monitor8 setclientflagasval(63);
	monitor9 setclientflagasval(63);
}

set_monitors_to_snow_int_screens()
{
	monitor1 = GetEnt( "monitor_01", "targetname" );
	monitor2 = GetEnt( "monitor_02", "targetname" );
	monitor3 = GetEnt( "monitor_03", "targetname" );
	monitor4 = GetEnt( "monitor_04", "targetname" );
	monitor5 = GetEnt( "monitor_05", "targetname" );
	monitor6 = GetEnt( "monitor_06", "targetname" );
	monitor7 = GetEnt( "monitor_07", "targetname" );
	monitor8 = GetEnt( "monitor_08", "targetname" );
	monitor9 = GetEnt( "monitor_09", "targetname" );
	monitor1 setclientflagasval(35);
	monitor2 setclientflagasval(35);
	monitor3 setclientflagasval(35);
	monitor4 setclientflagasval(35);
	monitor5 setclientflagasval(35);
	monitor6 setclientflagasval(35);
	monitor7 setclientflagasval(35);
	monitor8 setclientflagasval(35);
	monitor9 setclientflagasval(35);
}

bink_monitor_zombies()
{
	flag_wait("in_zombie_menu");
	level endon ("left_zombie_menu");
	
	level thread bink_monitor_randomize();
	
	set_monitors_to_snow();
	wait RandomFloatRange(1,3);
	
	while(1)
	{
		bink_zombie_footage_select();
		wait RandomFloat(15);
	}
}
		
bink_zombie_footage_select()
{
	level endon ("left_zombie_menu");
	min = 0;
	max = 1;
	tiles = [];
	num = 0;

	for (i=0; i < 10; i++)	// set all TV's to a single image selected from zombies
	{
		toss = RandomInt(100); 
		if (toss < 10)
		{
			num = 100;
		}
		else if (toss  < 88)    // regular single screen zombie footage
		{
			min = 16;
			max = 31;
			num = RandomIntRange(min, max);
		}
		else if (toss < 91)  // bars
		{
			num = 39;
		}
		else if (toss < 94)  // COD BO
		{
			num = 47;
		}
		else if (toss < 97)  // Treyarch
		{
			num = 55;
		}
		else // static
		{
			num = 63;
		}

		if ( is_in_array(tiles, num))
		{
			i--;
			wait 0.05;
		}
		else
		{
			tiles = array_add(tiles, num);
		}
	}
	
	for (i=1; i < 10; i++)
	{
		if (tiles[i-1] == 100)
		{
			continue;
		}
		monitor = GetEnt( "monitor_0"+i, "targetname");
		monitor setclientflagasval(tiles[i-1]);
		wait RandomFloat(1);
	}
	
	
	// chance to play video wall
	
	toss = RandomInt(100);
	
	if (toss < 15 ) //15% chance
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_06", "targetname") setclientflagasval(48);
			GetEnt("monitor_04", "targetname") setclientflagasval(49);
			GetEnt("monitor_05", "targetname") setclientflagasval(50);
			GetEnt("monitor_01", "targetname") setclientflagasval(56);
			GetEnt("monitor_02", "targetname") setclientflagasval(57);
			GetEnt("monitor_03", "targetname") setclientflagasval(58);
		}
		else
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(48);
			GetEnt("monitor_05", "targetname") setclientflagasval(49);
			GetEnt("monitor_07", "targetname") setclientflagasval(50);
			GetEnt("monitor_02", "targetname") setclientflagasval(56);
			GetEnt("monitor_03", "targetname") setclientflagasval(57);
			GetEnt("monitor_09", "targetname") setclientflagasval(58);
		}
	}
	else if (toss < 30)
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(51);
			GetEnt("monitor_05", "targetname") setclientflagasval(52);
			GetEnt("monitor_02", "targetname") setclientflagasval(59);
			GetEnt("monitor_03", "targetname") setclientflagasval(60);
		}
		else
		{
			GetEnt("monitor_05", "targetname") setclientflagasval(51);
			GetEnt("monitor_07", "targetname") setclientflagasval(52);
			GetEnt("monitor_03", "targetname") setclientflagasval(59);
			GetEnt("monitor_09", "targetname") setclientflagasval(60);
		}
	}
	else if (toss < 45)
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(53);
			GetEnt("monitor_05", "targetname") setclientflagasval(54);
			GetEnt("monitor_02", "targetname") setclientflagasval(61);
			GetEnt("monitor_03", "targetname") setclientflagasval(62);
		}
		else
		{
			GetEnt("monitor_06", "targetname") setclientflagasval(53);
			GetEnt("monitor_04", "targetname") setclientflagasval(54);
			GetEnt("monitor_01", "targetname") setclientflagasval(61);
			GetEnt("monitor_02", "targetname") setclientflagasval(62);
		}
	}
}
	
bink_monitor_randomize()
{
	flag_waitopen("in_zombie_menu");
	
	level notify ("new_bink_monitor_randomize");
	level endon ("new_bink_monitor_randomize");
	
	level endon ("stop_bink_monitor_randomize");
	level endon ("in_zombie_menu");
	level endon ("first_interstitial_go");
	
	level thread bink_monitor_zombies();
	
	monitor1 = GetEnt( "monitor_01", "targetname" );
	monitor2 = GetEnt( "monitor_02", "targetname" );
	monitor3 = GetEnt( "monitor_03", "targetname" );
	monitor4 = GetEnt( "monitor_04", "targetname" );
	monitor5 = GetEnt( "monitor_05", "targetname" );
	monitor6 = GetEnt( "monitor_06", "targetname" );
	monitor7 = GetEnt( "monitor_07", "targetname" );
	monitor8 = GetEnt( "monitor_08", "targetname" );
	monitor9 = GetEnt( "monitor_09", "targetname" );
	
	nums = [];
	for (i=0; i < 16; i++)
	{
		nums = array_add(nums, i);
	}
	nums = array_add(nums, 39);
	nums = array_add(nums, 47);
	nums = array_add(nums, 55);
	
	set_monitors_to_snow();
	
	while (1)
	{
		while(flag("bink_monitors_hold"))
		{
			wait (.05);
		}
		
	
		wait(randomfloat(15));
		
		j=randomint(15);

		switch(j)
		{
			case 0://snow
				set_monitors_to_snow();
				break;
			case 1:
			{
				if (level.script == "frontend") //treyarch logos
				{
					monitor1 setclientflagasval(55);
					monitor2 setclientflagasval(55);
					monitor3 setclientflagasval(55);
					monitor4 setclientflagasval(55);
					monitor5 setclientflagasval(55);
					monitor6 setclientflagasval(55);
					monitor7 setclientflagasval(55);
					monitor8 setclientflagasval(55);
					monitor9 setclientflagasval(55);
				}
				else // default
				{
					bink_stock_footage_select();
				}
			}
			break;
			case 2:
			{
				if (level.script == "frontend") //cod logos
				{
					monitor1 setclientflagasval(47);
					monitor2 setclientflagasval(47);
					monitor3 setclientflagasval(47);
					monitor4 setclientflagasval(47);
					monitor5 setclientflagasval(47);
					monitor6 setclientflagasval(47);
					monitor7 setclientflagasval(47);
					monitor8 setclientflagasval(47);
					monitor9 setclientflagasval(47);
				}
				else // default
				{
					bink_stock_footage_select();
				}
			}
			break;
			
			case 3:
			{
				for (i=0; i < 16; i++)
				{
					num = nums[RandomInt(nums.size)];
					for (j=1; j < 10; j++)
					{
						monitor = GetEnt( "monitor_0"+j, "targetname");
						monitor setclientflagasval(num);
					}
					wait(0.2);
				}
			}			
			break;
			
				
			default:
					bink_stock_footage_select();
				break; 
			}
	}
}


bink_stock_footage_select()
{
	level endon ("left_zombie_menu");
	tiles = [];
	nums = [];
	for (i=0; i < 16; i++)
	{
		nums = array_add(nums, i);
	}
	nums = array_add(nums, 39);
	nums = array_add(nums, 47);
	nums = array_add(nums, 55);
	nums = array_add(nums, 100);
	
	for (i=1; i < 10; i++)
	{
		num =  nums[RandomInt(nums.size)] ;
		if ( is_in_array(tiles, num))
		{
			i--;
			wait 0.05;
			continue;
		}
		if (num == 100)
		{
			continue;
		}
		
		tiles = array_add(tiles, num);
		monitor = GetEnt( "monitor_0"+i, "targetname");
		monitor setclientflagasval( num );
		wait RandomFloat(0.3);
	}
	
	
	// chance to play video wall
	toss = RandomInt(100);
	
	if (toss < 15 ) //15% chance
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_06", "targetname") setclientflagasval(32);
			GetEnt("monitor_04", "targetname") setclientflagasval(33);
			GetEnt("monitor_05", "targetname") setclientflagasval(34);
			GetEnt("monitor_01", "targetname") setclientflagasval(40);
			GetEnt("monitor_02", "targetname") setclientflagasval(41);
			GetEnt("monitor_03", "targetname") setclientflagasval(42);
		}
		else
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(32);
			GetEnt("monitor_05", "targetname") setclientflagasval(33);
			GetEnt("monitor_07", "targetname") setclientflagasval(34);
			GetEnt("monitor_02", "targetname") setclientflagasval(40);
			GetEnt("monitor_03", "targetname") setclientflagasval(41);
			GetEnt("monitor_09", "targetname") setclientflagasval(42);
		}
	}
	else if (toss < 30)
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(35);
			GetEnt("monitor_05", "targetname") setclientflagasval(36);
			GetEnt("monitor_02", "targetname") setclientflagasval(43);
			GetEnt("monitor_03", "targetname") setclientflagasval(44);
		}
		else
		{
			GetEnt("monitor_05", "targetname") setclientflagasval(35);
			GetEnt("monitor_07", "targetname") setclientflagasval(36);
			GetEnt("monitor_03", "targetname") setclientflagasval(43);
			GetEnt("monitor_09", "targetname") setclientflagasval(44);
		}
	}
	else if (toss < 45)
	{
		if (cointoss() )  //either play on left side or right side of wall
		{
			GetEnt("monitor_04", "targetname") setclientflagasval(37);
			GetEnt("monitor_05", "targetname") setclientflagasval(38);
			GetEnt("monitor_02", "targetname") setclientflagasval(45);
			GetEnt("monitor_03", "targetname") setclientflagasval(46);
		}
		else
		{
			GetEnt("monitor_06", "targetname") setclientflagasval(37);
			GetEnt("monitor_04", "targetname") setclientflagasval(38);
			GetEnt("monitor_01", "targetname") setclientflagasval(45);
			GetEnt("monitor_02", "targetname") setclientflagasval(46);
		}
	}
}

init_flags()
{
	flag_init("struggle_left");
	flag_init("struggle_right");
	flag_init("bink_monitors_hold");
	flag_init("allow_escape_buttons");
	flag_init("ignore_chair_playerlook");
	flag_set("ignore_chair_playerlook");
	flag_init("player_linked_absolute");
	flag_init("past_splash_screen");
	flag_init("player_out_of_chair");
	flag_init("warp_player_to_chair");
	flag_init("warping_player_to_chair");
	flag_init("at_splash_screen");
	flag_set("at_splash_screen");
	flag_init("in_zombie_menu");
	flag_init("dialogue_in_progress");
	flag_init("first_interstitial_go");
	flag_init("button_pressed");
	flag_init("level_fadeout");
	flag_init("next_tv_round");
	flag_init("player_camera_moving");
	flag_init("allow_vo");
	flag_init("enable_idle_drift");
}

level_load_fade()
{
	wait_for_first_player();
	cover_screen_in_black(1, 0, 1);
}

set_default_vision(fadetime)
{
	wait_for_first_player();
	level.do_not_use_dof = true;
	
	if (!IsDefined(fadetime))
	{
		fadetime = 0.1;
	}
	
	if (flag("in_zombie_menu"))
		VisionSetNaked( "zombie_frontend_default", fadetime);
	else
		VisionSetNaked( "int_frontend_default", fadetime);
	
	set_default_dof();
}

set_default_dof()
{
	NearStart = 0;
	NearEnd = 54;
	FarStart = 54;
	FarEnd = 587;
	NearBlur = 6;
	FarBlur = 9.4;
	
	get_players()[0] SetDepthOfField( NearStart, NearEnd, FarStart, FarEnd, NearBlur, FarBlur);	
}

#using_animtree("player");
frontend_player_connect()
{
	wait_for_first_player();

	thread bink_stock_footage_select();

	start3dcinematic("frontend", true, false);
	SetDvar("dec20_Enabled",1);
	
	level thread maps\frontend_amb::interrogation_room_watcher();
	
	get_players()[0] takeallweapons();

	get_players()[0] DisableWeapons();
	get_players()[0] AllowProne( false );
	get_players()[0] AllowJump(false);
	get_players()[0] AllowSprint(false);

	get_players()[0] OpenMainMenu( "main" );

	level thread use_computer();

	//thread extracam_tv_test();

	frontend_top_menu_start();
}

play_static_when_up()
{
	while(1)
	{
		flag_wait("player_out_of_chair");
		get_players()[0] setclientflagasval(1);
		get_players()[0] CloseMainMenu ();
		get_players()[0] initdec20terminal();
		flag_waitopen("player_out_of_chair");
		get_players()[0] OpenMainMenu( "main" );
		get_players()[0] setclientflagasval(0);
	}
}

computer_hintstring_regulator()
{
	trig = GetEnt("computer_trigger", "targetname");	
	trig SetHintString( &"PLATFORM_USE_COMPUTER" );
	trig setcursorhint( "HINT_NOICON" );
	
	while(1)
	{
		flag_wait("warping_player_to_chair");
		trig SetHintString( "" );
		flag_waitopen("warping_player_to_chair");
		trig SetHintString( &"PLATFORM_USE_COMPUTER" );
	}
}

use_computer()
{
	thread computer_hintstring_regulator();
	
	while(1)
	{
		while(!flag("flag_frontend_usecomputer"))
			wait(0.05);
		
			
		if (flag("warping_player_to_chair"))
		{
			flag_clear("flag_frontend_usecomputer");
			wait 0.05;
			continue;
		}

		clientNotify("sit_at_dec20");
		VisionSetNaked("int_frontend_terminal", 1);
		
		trigger_off("computer_trigger","targetname");
		if (!IsDefined(level.terminal_linker))
		{
			level.terminal_linker = Spawn_a_model("tag_origin", (-23, 569, -20), (-2,90,0) );
		}
		if (get_players()[0] GetStance() == "crouch")
		{
			get_players()[0] AllowCrouch(false);
			get_players()[0] SetStance("stand");
			wait 0.3;
		}
		
		get_players()[0] AllowCrouch(false);
		clientnotify("cpu_fov_in");
		thread freeze_controls_for_time(1);
		
		get_players()[0] startcameratween(0.7);
		get_players()[0] PlayerLinkToAbsolute(level.terminal_linker);
		get_players()[0] AttachToDec20Terminal();

		if (level.console)
		{
			press_x = a_safe_text_display(&"FRONTEND_PRESS_X_TO_EXIT", 0, 0,undefined, 1.2, "left", "top", "left", "top");
		}
		else
		{
			press_x = a_safe_text_display(&"PLATFORM_PRESS_ESCAPE_TO_EXIT", 0, 0,undefined, 1.2, "left", "top", "left", "top");
		}

		while(GetDvarInt( #"dec20_inuse") && !flag("warping_player_to_chair") && !flag("warp_player_to_chair") )
			wait(0.05);

		get_players()[0] DetachDec20Terminal();
		
		clientNotify( "stand_from_dec20" );
		VisionSetNaked( "int_frontend_default", 0.1);

				
		press_x Destroy();
		spot = getstruct("player_up_from_cpu", "targetname");
		clientnotify("cpu_fov_out");
		thread freeze_controls_for_time(1);
		get_players()[0] Unlink();
		get_players()[0] lerp_player_view_to_position(spot.origin, spot.angles, 0.8);
		get_players()[0] AllowCrouch(true);
		
		trigger_on("computer_trigger","targetname");
		flag_clear("flag_frontend_usecomputer");
	}
}

frontend_dec20_message(command)
{
	switch(command[0])
	{
	case "alarm":
		break;
	case "lights":
		break;
	}
}

DoStartLevelSequence()
{
	level endon ("menu_resetstate");
	level notify ("level_selected");
		
	flag_set("bink_monitors_hold");

	set_default_vision();
	set_monitors_to_snow();

	if ( GetDvar(#"ui_load_level") == "cuba")
	{
		do_first_interstitial();
	}

	ChangeLevel(GetDvar(#"ui_load_level"),false,0);
	flag_clear("bink_monitors_hold");
}

DoStartMultiplayerSequence()
{
	flag_set("bink_monitors_hold");

	set_default_vision();
	set_monitors_to_snow();
	
	StartMultiplayerGame();
	flag_clear("bink_monitors_hold");
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

menu_message(state, item)
{
	toggle_idle_drift(state, item);

	if (state=="close")
	{
		switch(item)
		{
		case "options":
			break;
		case "main_text":
			flag_clear("allow_escape_buttons");
			break;
		case "main_lockout":	// we've just closed the splash screen
			flag_set("past_splash_screen");
			flag_clear("ignore_chair_playerlook");
			flag_clear("at_splash_screen");
			break;
		case "main_online":
			flag_clear("in_zombie_menu");
			break;
			
		case "levels":
		case "popmenu_difficulty":
		case "menu_collectibles":
			set_default_vision();	
			break;
			
		case "levels_zombie":
		case "menu_xboxlive":
		case "menu_xboxlive_privatelobby":
		case "findgame_category":
		case "menu_xboxlive_lobby":
		case "menu_gamesetup_splitscreen":
		case "menu_systemlink":
		case "menu_systemlink_lobby":
		case "settings":
			VisionSetNaked( "zombie_frontend_default", 0.1);
			break;

		case "fullscreen_collectibles":
			//AYERS: End Intel Audio Here
			break;
		}
	}
	else if (state=="open")
	{
		switch(item)
		{
		case "options":
		    level notify( "end_credits_music" );
			clientnotify( "nts" );
			break;
		case "main_text":
			flag_set("past_splash_screen");
			flag_clear("ignore_chair_playerlook");
			flag_clear("at_splash_screen");
			flag_set("allow_escape_buttons");
			
			break;
		case "main_lockout":	// we've gone back to splash screen
			flag_clear("past_splash_screen");
			flag_set("ignore_chair_playerlook");
			flag_set("at_splash_screen");
			break;
		case "main_online":
			flag_set("in_zombie_menu");
			break;
			
		case "levels":
		case "popmenu_difficulty":
		case "menu_collectibles":
			VisionSetNaked( "int_frontend_menus", 0.1);
			break;

		case "levels_zombie":
		case "menu_xboxlive":
		case "menu_xboxlive_privatelobby":
		case "findgame_category":
		case "menu_xboxlive_lobby":
		case "menu_gamesetup_splitscreen":
		case "menu_systemlink":
		case "menu_systemlink_lobby":
		case "settings":
			VisionSetNaked( "zombie_frontend_menus", 0.1);
			flag_set("in_zombie_menu");
			break;
			
		case "fullscreen_collectibles":
			//AYERS: Start Intel Audio Here
			break;
		}
	}
	else if (state=="startlevel")
	{
		DoStartLevelSequence();
	}
	else if (state=="startmp")
	{
		DoStartMultiplayerSequence();
	}
	else if (state=="startblackops")
	{
		//fly into the blackops monitor
		get_players()[0] OpenMainMenu("main_text");
	}
	else if (state=="resetstate")
	{
		//reset all states, the top level menu has reopened!
		flag_clear("bink_monitors_hold");
		flag_clear("allow_escape_buttons");
		//flag_clear("player_linked_absolute");
		flag_clear("past_splash_screen");
		flag_clear("player_out_of_chair");
		flag_clear("first_interstitial_go");
		flag_set("warp_player_to_chair");
		level.zombie_music_on = 0;
		level notify ("menu_resetstate");
	}
	else if (state=="allowescape")
	{
		if (item=="0")
			flag_clear("allow_escape_buttons");
		else
			flag_set("allow_escape_buttons");
	}
	else if (state=="credits")
	{
		if (item=="start")
		{
			Stop3dCinematic();
			setculldist(10);
			level thread play_credits_music();
			clientnotify( "crs" );
		}
		//close the credits menu
		if (item=="done")
		{
			thread cover_screen_in_black(0, 0, 0.2);
			setculldist(0);
			start3dcinematic("frontend", true, false);
			level notify( "end_credits_music" );
			clientnotify( "nts" );
//			get_players()[0] CloseMainMenu( );
			get_players()[0] OpenMainMenu( "main" );
		}
	}
	else if (state=="fiche_stickx")
	{
		level.fiche_stick_x_value = Float(item);
	}
	else if (state=="fiche_sticky")
	{
	    level.fiche_stick_y_value = Float(item);
	}
	else if (state=="fiche_zoom")
	{
	    level.fiche_zoom_value = Float(item);
	}
	else if (state=="allow_vo")
	{
		flag_set("allow_vo");
		enable_idle_drift();
	}
}

toggle_idle_drift(state, item)
{
	if (state == "open")
	{
		switch (item)
		{
		case "main_text":
		case "main_sp":
		case "main_online":
		case "systemlink_flyout":
			enable_idle_drift();
			break;

		default:
			disable_idle_drift();
		}
	}
	else if (state == "close")
	{
		switch (item)
		{
		case "blackout_3d_tv":
			enable_idle_drift();
			break;
		}
	}
}

enable_idle_drift()
{
	if (flag("allow_vo"))	// This makes sure we are past any initial config screens
	{
		/#
			if (!flag("enable_idle_drift"))
			{
				IPrintLn("Idle drift enabled");
			}
		#/

		flag_set("enable_idle_drift");
	}
}

disable_idle_drift()
{
	/#
		if (flag("enable_idle_drift"))
		{
			IPrintLn("Idle drift disabled");
		}
	#/

	flag_clear("enable_idle_drift");
	level notify("player_camera_moving");
}

#using_animtree ("generic_human");
random_weaver()
{
//	level.scr_anim["generic"]["walk"] = %civilian_walk_coffee;
	
	while(1)
	{	
		wait( randomIntRange( 5, 10 ) );
	}
}

start_interrogation_questions()
{
	level endon ("level_selected");
	level endon ("first_interstitial_go");
	
	level._generic_questions = [];
	level._generic_questions[0] = "g_question1";
	level._generic_questions[1] = "g_question2";
	level._generic_questions[2] = "g_question3";
	level._generic_questions[3] = "g_question4";
	level._generic_questions[4] = "g_question5";
	level._generic_questions[5] = "g_question6";
	level._generic_questions[6] = "g_question7";
	level._generic_questions[7] = "g_question8";
	level._generic_questions[8] = "g_question9";
	level._generic_questions[9] = "g_question10";
	level._generic_questions[10] = "g_question11";
	level._generic_questions[11] = "g_question12";
	level._generic_questions[12] = "g_question13";
	
	levelnum = Int(GetDvar(#"mis_01"));
	current_saved_level = undefined;
	
	switch(levelnum)	// if undefined, dont play any because player has passed it all already
	{
		case 0:
			current_saved_level = "cuba";
			break;
		case 1:
			current_saved_level = "vorkuta";
			break;
		case 2:
			current_saved_level = "pentagon";
			break;
		case 3:
			current_saved_level = "flashpoint";
			break;
		case 4:
			current_saved_level = "flashpoint";
			break;
		case 5:
			current_saved_level = "khe_sanh";
			break;
		case 6:
			current_saved_level = "hue_city";
			break;
		case 7:
			current_saved_level = "kowloon";
			break;
		case 8:
			current_saved_level = "creek_1";
			break;
		case 9:
			current_saved_level = "river";
			break;
		case 10:
			current_saved_level = "wmd";
			break;
		case 11:
			current_saved_level = "pow";
			break;
		case 12:
			current_saved_level = "fullahead";
			break;
		case 13:
			current_saved_level = "rebirth";
			break;
	}
	
	level._savedgame_questions = [];
	if (IsDefined(current_saved_level))
	{
		for (i=1; i < 10; i++)
		{
			
			if (IsDefined(level.scr_sound["generic"][current_saved_level+"_q"+i]) )
			{
				level._savedgame_questions = array_add(level._savedgame_questions, current_saved_level+"_q"+i);
			}
		}
	}
	
	level._said_sequential_savedgame_questions = 0;
	
	flag_wait("allow_vo");
	wait 10;
	
	while(1)
	{
		for (i=0; i < level._savedgame_questions.size; i++)
		{
			if (level._said_sequential_savedgame_questions > 0)
			{
				level.interrogator line_please(level._savedgame_questions[RandomInt(level._savedgame_questions.size) ]);  
				break;
			}
			
			level.interrogator line_please(level._savedgame_questions[i]);
			wait 20;

		}
		
		level._said_sequential_savedgame_questions++;		// this variable is so we don't do the same sequence of level specific questions too often to sound robotic
		if (level._said_sequential_savedgame_questions > 4)
		{
			level._said_sequential_savedgame_questions = 0;
		}
		
		generic_lines_amount = RandomIntRange(3, level._generic_questions.size);
		used_generic_lines = [];
		for (i=0; i < generic_lines_amount; i++)
		{
			new_line_num = random_int_not_in_array(0, level._generic_questions.size, used_generic_lines);
			level.interrogator line_please(level._generic_questions[new_line_num]);
			wait 25;
			used_generic_lines = array_add(used_generic_lines, new_line_num);
		}
	}	
}




line_please(myline,waittime, myflag, dontplay_flag)
{
	//level endon ("cut_current_dialogue");
	stringline = undefined;
	if (isdefined(myflag))
	{
		flag_wait (myflag);
	}
	
	if ( (IsDefined(dontplay_flag) && flag(dontplay_flag) ) || flag("at_splash_screen") )
	{
		return;
	}
	
	if (flag("at_splash_screen") || flag("player_out_of_chair") || flag("in_zombie_menu") )
	{
		return;
	}
	
	
	if (isdefined(waittime))
	{
		wait waittime;
	}
	
	waittillframeend; // make sure to reset next flag if its done elsewhere before its checked
	
	if (IsDefined(dontplay_flag) && flag(dontplay_flag))
	{
		return;
	}

	flag_waitopen("dialogue_in_progress");
	flag_set("dialogue_in_progress");
	level thread maps\frontend_amb::event_heart_beat("stressed"); 

	if (!(IsAI(self))) // if it's the radio or the player
	{
 	 	self anim_generic(self,myline);
 	}
	
	else
	{
 	 	self anim_generic( self, myline );
	}

	flag_clear("dialogue_in_progress");
	level thread maps\frontend_amb::event_heart_beat("relaxed"); 
}

stoolpush()
{
	trigger_wait("stoolpush_trig");
	spot = getstruct("stool_movespot", "targetname").origin;
	stool = GetEnt("int_stool", "targetname");
	
	movetime = 4.5;
	stool moveto(spot, movetime, 0, movetime);
	stool RotateYaw(290, movetime, 0, movetime);
}


do_first_interstitial()
{
	thread test_pauser();
	
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	
	create_fullscreen_cinematic_hud(0);
	level.fullscreen_cin_hud.alpha = 0;
	get_players()[0] CloseMainMenu ();
	
	//get_players()[0] AllowJump(true);
	//get_players()[0] SetStance("stand");
	
	level endon ("menu_resetstate");
	level endon ("interstitial_skipped");
	
	thread frontend_top_menu_start();
	
	get_players()[0] setclientflagasval(1);
	
	wait 0.25;
	VisionSetNaked( "int_frontend_char_trans", 1);
	playsoundatposition ("evt_new_game_flash", (0,0,0));	
	
	if (is_true(level.ps3) )
	{
		thread cover_screen_in_white(0.7, 1, 1.1);
	}
	
	wait 1;
	get_players()[0] SetBlur(7,0);
	
	white_bg = NewHudElem(); 
	white_bg.x = 0; 
	white_bg.y = 0;
	white_bg.alpha = 1; 
	white_bg.horzAlign  = "fullscreen";
	white_bg.vertAlign  = "fullscreen";
	white_bg.foreground = true; //Arcade Mode compatible
	white_bg.sort			 = 1;
	white_bg SetShader( "white" );
	white_bg thread wait_fade_destroy(1.5, 1);
	
	thread maps\so_narrative2_frontend_anim::fakeplayer_setup();
	thread first_int_tv_rounds();
	
	wait 0.7;
	get_players()[0] SetBlur(0,8);
	VisionSetNaked("int_frontend_narrative_1", 1.1);

	flag_wait("level_fadeout");
	level.end_level_hud					 = NewClientHudElem(get_players()[0]);
	level.end_level_hud.x 				 = 0;
	level.end_level_hud.y 			   = 0;
	level.end_level_hud.horzAlign  = "fullscreen";
	level.end_level_hud.vertAlign  = "fullscreen";
	level.end_level_hud.foreground = false; //Arcade Mode compatible
	level.end_level_hud.sort			 = 0;

	level.end_level_hud setShader( "black", 640, 480 );
	level.end_level_hud.alpha = 0;
	
	level.end_level_hud FadeOverTime(1);
	level.end_level_hud.alpha = 1;
	
	wait 1;
}

first_int_tv_rounds()
{
	level endon ("menu_resetstate");
	
	stop3dcinematic();
	start3dcinematic("int_screens", true, false);
	thread	set_monitors_to_snow_int_screens();
	
	tvs = GetEntArray("p_int_monitor_a", "script_noteworthy");
	tvs = array_combine(tvs, GetEntArray("p_int_monitor_b", "script_noteworthy") );
	tvs = array_combine(tvs, GetEntArray("p_int_monitor_c", "script_noteworthy") );
	
	for (i=0; i < tvs.size; i++)
	{
		tvs[i]._extracam_replacement = spawn_a_model(tvs[i].script_noteworthy+"_extracam", tvs[i].origin, tvs[i].angles);
		tvs[i]._extracam_replacement.targetname = tvs[i].targetname+"_extracam";
		tvs[i]._extracam_replacement.script_noteworthy = tvs[i].script_noteworthy;
		tvs[i]._extracam_replacement Hide();
	}
	
	next_tv_round();
	level notify ("stop_bink_monitor_randomize");
	
	
	for (i=0; i < tvs.size; i++)
	{
		tvs[i] Hide();
		tvs[i]._extracam_replacement Show();
	}
	
	next_tv_round();
	
	extracam_quadrant();
	next_tv_round();
		
		// show_numbers
	playsoundatposition ("num_03_d", (-17,370,61));		
		
	num_tile = 0;
		
	for (i=1; i < 6; i++)
	{
		tv= GetEnt( "monitor_0"+i+"_quad_extracam", "targetname");
		if (i==1)
		{
			tv= GetEnt( "monitor_0"+i+"_extracam", "targetname");
		}
		if (i < 5)
		{
			tv Hide();
			tv = GetEnt( "monitor_0"+i, "targetname");
			tv setclientflagasval(num_tile);
			tv Show();
		}
		else
		{
			tv Hide();
			tv = GetEnt( "monitor_0"+i, "targetname");
			tv setclientflagasval(num_tile);
			tv Show();
		}
		if (num_tile==2)
			num_tile = 0;
		else
			num_tile ++;		
	}
	
	num_tile = 0;
	for (i=6; i < 10; i++)
	{
		tv= GetEnt( "monitor_0"+i+"_extracam", "targetname");
		tv Hide();
		tv = GetEnt( "monitor_0"+i, "targetname");
		tv setclientflagasval(num_tile);
		tv Show();
		
		if (num_tile==2)
			num_tile = 0;
		else
			num_tile ++;		
	}
	
	tv = GetEnt("monitor_ui3d_01"+"_extracam", "targetname");
	tv Hide();
	
	binktv = spawn_a_model("p_int_monitor_c_bink", tv.origin, tv.angles);
	binktv setclientflagasval(num_tile);
		
	next_tv_round();
	binktv setclientflagasval(34);
	
	for (i=6; i < 9; i++)
	{
		tv = GetEnt( "monitor_0"+i, "targetname");
		tv Hide();
		tv= GetEnt( "monitor_0"+i+"_extracam", "targetname");
		tv Show();
		
		if (num_tile==2)
			num_tile = 0;
		else
			num_tile ++;		
	}
	
	next_tv_round();
	//flag_set("take_control");
}

extracam_quadrant()
{
	for (i=2; i < 6; i++)
	{
		tv = GetEnt( "monitor_0"+i+"_extracam", "targetname" );
		tv thread wait_and_hide(1);
		tv = Spawn_a_model(tv.script_noteworthy+"_bink", tv.origin, tv.angles );
		tv.targetname = ( "monitor_0"+i+"_quad_extracam");
		tv Hide();
		tv thread wait_and_show(1);
		
		
		tv thread wait_and_setclientflagasval(0.2, 50);
		tv thread wait_and_setclientflagasval(0.4, 100);
		tv delaythread ( 0.6, ::set_cam_space, i);
	}
}

set_cam_space(num)
{
	switch(num)
	{
		case 2:
			self setclientflagasval(level.CLIENT_EXTRACAM_TV_BL);
			break;
		case 3:
			self setclientflagasval(level.CLIENT_EXTRACAM_TV_BR);
			break;
		case 4:
			self setclientflagasval(level.CLIENT_EXTRACAM_TV_UL);
				break;
		case 5:
			self setclientflagasval(level.CLIENT_EXTRACAM_TV_UR);
			break;
	}
}
	
init_level_vars()
{
	level.CLIENT_EXTRACAM_TV_INIT = 100;
	level.CLIENT_EXTRACAM_TV_SINGLE = 101;

	level.CLIENT_EXTRACAM_TV_UL = 102;
	level.CLIENT_EXTRACAM_TV_UR = 103;
	level.CLIENT_EXTRACAM_TV_BL = 104;
	level.CLIENT_EXTRACAM_TV_BR = 105;
	
	
	level._hudson_int_anim = "hudson_inter_01";
	level._weaver_int_anim = "weaver_inter_01";
	level._ai_chair_anim = "int1_chair_anim";
	level._player_chair_anim = "int1_chair_anim";
}

frontend_top_menu_start()
{
	flag_waitopen("first_interstitial_go");
	level thread bink_monitor_randomize();
	level thread spy_monitors_randomize();
	level thread start_interrogation_questions();
	
	get_players()[0] thread play_static_when_up();
	get_players()[0] thread maps\frontend_anim::setup_idle_animation();
	get_players()[0] thread maps\frontend_anim::chair_trigger_setup();
	get_players()[0] thread maps\frontend_anim::window_ambient_anims();
	
	get_players()[0] thread maps\frontend_anim::player_camera_movment_tracker();
	get_players()[0] thread maps\frontend_anim::out_of_chair_idle_control();
}

play_aligned_fx()
{
	battery = GetEnt("awesome_battery", "targetname");
	PlayFXOnTag(level._effect["battery_spark"], battery, "tag_origin");
	
	
	cameras = GetEntArray("awesome_camera", "targetname");
	for (i=0; i < cameras.size; i++)
	{
		PlayFXOnTag(level._effect["camera_light"], cameras[i], "tag_origin");
	}
}

test_pauser()
{
	level.test_pauser = 1;
	while(1)
	{
		level.test_pauser++;
		wait 0.05;
	}
}
play_credits_music()
{
    level endon( "end_credits_music" );
    level endon( "menu_resetstate" );
    
    level thread wait_for_end_credits();
    
    if(GetDvar( #"language" ) != "german" )    
    {
   	 	level play_credit_song( "CREDIT_ZERO", 360 );
   	}
    
    if( is_mature() == true)
    {
        level play_credit_song( "CREDIT_ONE", 264 );
    }
    
    level play_credit_song( "CREDIT_TWO", 186 );
    level play_credit_song( "CREDIT_THREE", 106 );
    level play_credit_song( "CREDIT_FOUR", 136 );
    level play_credit_song( "CREDIT_FIVE", 82 );
    level play_credit_song( "CREDIT_SIX", 130 );
    level play_credit_song( "CREDIT_SEVEN", 182 );
}
play_credit_song( music_state, waittime )
{
    level endon( "end_credits_music" );
    level endon( "menu_resetstate" );
    
    setmusicstate( music_state );
    wait( waittime );
}
wait_for_end_credits()
{
    level waittill_any( "end_credits_music", "menu_resetstate" );
    setmusicstate( "INT_UNDERSCORE" );
}
