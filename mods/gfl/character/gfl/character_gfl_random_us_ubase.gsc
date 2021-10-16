main()
{
	switch( codescripts\character::get_random_character(9) )
	{
	case 0:
		character\gfl\character_gfl_p90::main();
		break;
	case 1:
		character\gfl\character_gfl_type97::main();
		break;
	case 2:
		character\gfl\character_gfl_rfb::main();
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
		character\gfl\character_gfl_m1903::main();
		break;
	}
	self.voice = "american";
}

precache()
{
	character\gfl\character_gfl_p90::precache();
	character\gfl\character_gfl_type97::precache();
	character\gfl\character_gfl_rfb::precache();
	character\gfl\character_gfl_saiga12::precache();
	character\gfl\character_gfl_ppsh41::precache();
	character\gfl\character_gfl_9a91::precache();
	character\gfl\character_gfl_ak74m::precache();
	character\gfl\character_gfl_m1903::precache();
	character\gfl\character_gfl_type89::precache();
}