#modified by imdjs

extends Spatial


#----状态--------------------------
var iFBG=1;var bCamToggleG=false;var bAimG=false;var bShootG=false;
#----混合--------------------------
var fBlendUDG=0;var fBlendUDshootG=0;
#----角度--------------------------
var rotYG=0;
var a360=6.283185;var a180=3.14159;var a_180=-3.14159;var a90=1.57079;#var a_90=-1.5707963267;
var rad90D= deg2rad(60);var rad_90D= deg2rad(-50);
var fMousespeedD = 0.005;var f001=0.01;var delta10=0;

#----node--------------------------
onready var X = self;#onready var X = get_node("X");
onready var cam = get_node("camera");onready var nAimG = get_node("camera/准星十");
onready var FG = get_node("P前");onready var BG = get_node("P后");
onready var armG =get_node("../../B_bodyG");
onready var player =get_node("../../player女西装");

#----CAM--------------------------
var fcam_F=null;var fcam_B=null;var fDot=null;var B_F=null;var fcam_now=null;var fLen=0;
var time=null;var timer=Timer.new();
#----CAM--------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);#让鼠标永远在中间
	cam.add_exception(get_parent());#镜头不碰撞父级
	print("nodes==",X,cam,FG,BG,player,armG);

	cam.translation=BG.translation;
	bCamToggleG=false;B_F=(FG.translation-BG.translation).normalized();
	# time=get_tree().create_timer(0.5);timer.start(10.5);
#========================================
func _input(event):
	#----退出--------------------------
	if (Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_Q)):
		get_tree().quit();
		

	#----旋转camera--------------------------
	if(event is InputEventMouseMotion):
		X.rotation.x = clamp(X.rotation.x +event.relative.y*fMousespeedD,rad_90D, rad90D);#rotation 来源于 extends Camera
		X.rotation.y =X.rotation.y - event.relative.x*fMousespeedD;
	
		# print("〓Ncam==",X.rotation.y);
	#----瞄准--------------------------
	if(Input.is_mouse_button_pressed(BUTTON_RIGHT)):#瞄准
		fBlendUDG=X.rotation.x*1.2;
		if(bAimG==false):bAimG=true;#print("X.fBlendUDG==",X.rotation.x,"按 bAimG==",bAimG);
		clamp(fBlendUDG,-0.8,1);
		fBlendUDshootG=fBlendUDG-0.2;
	else:
		if(bAimG):
			bAimG=false;nAimG.visible=false;#print("释放bAimG=="," bAimG==",bAimG);
#====●这个检测没有input 或_process 那么频繁====================================
func _physics_process(delta):
	armG.translation=player.translation;

		
	# print("BG==",BG.translation,BG.global_transform,player.translation);
	
