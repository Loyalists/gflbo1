main()
{
	switch( codescripts\character::get_random_character(20) )
	{
	case 0:
		character\c_rus_spetznaz_winter_1::main();
		break;
	case 1:
		character\c_rus_spetznaz_winter_2::main();
		break;
	case 2:
		character\c_rus_spetznaz_winter_3::main();
		break;
	case 3:
		character\c_rus_spetznaz_winter_1::main();
		break;
	case 4:
		character\c_rus_spetznaz_winter_2::main();
		break;
	case 5:
		character\c_rus_spetznaz_winter_3::main();
		break;
	case 6:
		character\c_rus_spetznaz_winter_1::main();
		break;
	case 7:
		character\c_rus_spetznaz_winter_2::main();
		break;
	case 8:
		character\c_rus_spetznaz_winter_3::main();
		break;
	case 9:
		character\c_rus_spetznaz_winter_1::main();
		break;
	case 10:
		character\c_rus_spetznaz_winter_2::main();
		break;
	case 11:
		character\c_rus_spetznaz_winter_3::main();
		break;
	case 12:
		character\gfl\character_gfl_p90::main();
		break;
	case 13:
		character\gfl\character_gfl_type97::main();
		break;
	case 14:
		character\gfl\character_gfl_suomi::main();
		break;
	case 15:
		character\gfl\character_gfl_saiga12::main();
		break;
	case 16:
		character\gfl\character_gfl_ppsh41::main();
		break;
	case 17:
		character\gfl\character_gfl_9a91::main();
		break;
	case 18:
		character\gfl\character_gfl_ak74m::main();
		break;
	case 19:
		character\gfl\character_gfl_type89::main();
		break;
	}
	self.voice = "russian";
}

precache()
{
	character\gfl\character_gfl_p90::precache();
	character\gfl\character_gfl_type97::precache();
	character\gfl\character_gfl_suomi::precache();
	character\gfl\character_gfl_saiga12::precache();
	character\gfl\character_gfl_ppsh41::precache();
	character\gfl\character_gfl_9a91::precache();
	character\gfl\character_gfl_ak74m::precache();
	character\gfl\character_gfl_type89::precache();
	character\c_rus_spetznaz_winter_1::precache();
	character\c_rus_spetznaz_winter_2::precache();
	character\c_rus_spetznaz_winter_3::precache();
}