// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("t5_gfl_9a91_body");
	self.headModel = "t5_gfl_9a91_head";
	self attach(self.headModel, "", true);
	self attach("t5_gfl_9a91_hair", "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("t5_gfl_9a91_body");
	precacheModel("t5_gfl_9a91_head");
	precacheModel("t5_gfl_9a91_hair");
}
