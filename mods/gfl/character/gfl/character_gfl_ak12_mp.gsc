// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("t5_gfl_ak12_body_mp");
	self.headModel = "t5_gfl_ak12_head";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("t5_gfl_ak12_body_mp");
	precacheModel("t5_gfl_ak12_head");
}
