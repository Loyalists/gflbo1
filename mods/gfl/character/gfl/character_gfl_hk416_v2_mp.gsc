// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("t5_gfl_hk416_v2_body_mp");
	self.headModel = "t5_gfl_hk416_v2_head";
	self attach(self.headModel, "", true);
	self attach("t5_gfl_hk416_v2_gear", "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("t5_gfl_hk416_v2_body_mp");
	precacheModel("t5_gfl_hk416_v2_head");
	precacheModel("t5_gfl_hk416_v2_gear");
}
