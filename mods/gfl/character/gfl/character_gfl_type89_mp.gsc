// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("t5_gfl_type89_body_mp");
	self.headModel = "t5_gfl_type89_head";
	self attach(self.headModel, "", true);
	self attach("t5_gfl_type89_hair", "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("t5_gfl_type89_body_mp");
	precacheModel("t5_gfl_type89_head");
	precacheModel("t5_gfl_type89_hair");
}
