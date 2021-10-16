main()
{
	switch( codescripts\character::get_random_character(12) )
	{
	case 0:
		character\gfl\character_gfl_p90::main();
		break;
	case 1:
		character\gfl\character_gfl_type97::main();
		break;
	case 2:
		character\gfl\character_gfl_suomi::main();
		break;
	case 3:
		character\gfl\character_gfl_saiga12::main();
		break;
	case 4:
		character\gfl\character_gfl_ppsh41::main();
		break;
	case 5:
		character\gfl\character_gfl_9a91::main();
		break;
	case 6:
		character\gfl\character_gfl_ak74m::main();
		break;
	case 7:
		character\gfl\character_gfl_type89::main();
		break;
	case 8:
		character\c_rus_spetnaz_undercover1::main();
		break;
	case 9:
		character\c_rus_spetnaz_undercover2::main();
		break;
	case 10:
		character\c_rus_spetnaz_undercover1a::main();
		break;
	case 11:
		character\c_rus_spetnaz_undercover2b::main();
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
	character\c_rus_spetnaz_undercover1::precache();
	character\c_rus_spetnaz_undercover2::precache();
	character\c_rus_spetnaz_undercover1a::precache();
	character\c_rus_spetnaz_undercover2b::precache();
}