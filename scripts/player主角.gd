#by imdjs

extends KinematicBody

# signal snHit
const iAnim0D = 0
const iAnim1D = 1
# const iAnimAirDownD = 2
# const fShootTimeD = 1.5
# const fShootScaleD = 2
#----速度--------------------------
const iMaxSpeedD = 4;const iMaxPulseD = 10;var fSpeedPulseG=0;#[0--10]
# const iJumpSpeedG = 7
const fStopSpeedD=0.01;
var fTurnSpeedG=0;var iTimeG=0;
onready var time=get_node("Timer");
#----状态--------------------------
var iAniJumpG = 0;var bTurnG=false;var bHitLadderG=false;var bHitGrayG=false;
# var b前=false;var b后=false;var b左=false;var b右=false;
var bJumpG = false;var b1OnFloorG=false;
var bPressDerectG=false;var bPreShootG=false;
#----混合--------------------------
var iStandWalkRunG = 0;var fBlendRunG=-1.0;var fWalk_GunG=0;
var fWeightG=0;


# const gdCamG= preload("res://人物/camera.gd");
# onready var gdCamG =get_node("res://人物/camera.gd");
# onready var gdCamG =get_node("camera/camera.gd");

var fAngD_camG=0;
var rotYCamG=0;
var vMoveNowG=Vector3(0,-10,0);var vMoveToG=Vector3();var vMoveTMP=Vector3();
var fShootBlend = 0;var fDotG=0;
var vDirectNG = Vector3.BACK;
# var g = Vector3(0,-9.8,0);#var v0 = Vector3();
var up=Vector3(0,30,0);#var locArmG = Vector3();var locArmPreG = Vector3();
#var v2Mpre=null;
#----角度--------------------------
var rotYG=0;
var a360=6.283185;var a180=3.14159;var a_180=-3.14159;var a90=1.57079;var a45=0.785398;var a135=2.3561946;
# var rad90D= deg2rad(60);var rad_90D= deg2rad(-50);
#----node--------------------------
const DR= preload("E:/Godot/GdscriptLib/GSLIB_draw.gd");var DRG=DR.new();
onready var X = get_node("X");onready var cam = get_node("X/camera");
onready var FG = get_node("X/P前");onready var F2G = get_node("X/P前2");
onready var apG =get_node("../AnimationPlayer");
onready var atpG =get_node("../AnimationTreeBaidu");
onready var armG =get_node("../B_bodyG");

#const BUL= preload("res://物品/bullet/bullet.gd");
#var BUL2= preload("res://物品/bullet2/bullet.gd").new()#.instance();
var space_stateG=null;
#------------------------------
onready var rcFaceG =get_node("X/camera/RayCast");
onready var lbTextG=get_node("../状态栏");

onready var nGroundG =get_node("../../地面");onready var nRootG =get_node("../../../Scene Root");
#onready var igDrawG =get_node("../../地面/ImmediateGeometry");

onready var g = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector");#●负数
onready var g10=g*10;


#========================================
func __Zero(v):
	v.x=0;v.y=0;v.z=0;
	
func __HitLadder(body):
	print("__HitLadder==",body.name);
	if(bHitLadderG==false):
		bHitLadderG=true;vMoveNowG.y=0;
		
func __LeaveLadder(body):
	print("__LeaveLadder==",body.name);
	if(bHitLadderG==true):
		bHitLadderG=false;
#----CAM--------------------------
func _ready():
	atpG.set_active(true);#激活playertree
	space_stateG=get_world().direct_space_state;
	# g10=g*5;
	bJumpG=false;iTimeG=0;bTurnG=false;bPressDerectG=false;fWalk_GunG=0;time.one_shot=true;
	# move_and_slide(vMoveNowG,Vector3.UP);
	# print("gdCamG.iFBG==",X.iFBG);
	print("getroot==",get_tree().get_root().name,nGroundG.name,nRootG.name);
#========================================
# func _input(event):
#☐☐☐☐┆┅┈☐☐☐☐☐☐+☐0☐-☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐☐│☐☐┅┈☐☐☐◇7┌━━━┐1☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐┆☐┈☐┆☐☐→☐┃☐↑☐┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐│☐┆┅☐│☐☐→◇6┃☐┼☐┃2☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐┅┈☐☐┆☐☐☐→☐┃☐cam◇┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐☐☐┅┈│☐☐☐☐☐└━━━┘☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
#☐☐☐☐armG☐☐☐☐☐☐☐5☐☐4☐☐3☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐

	
		
#========================================
func _physics_process(delta):#delta==0.0166
	# if(time.time_left==0):time.start(2);
	fTurnSpeedG=7;bPressDerectG=false;#print("time==",time.time_left);
	iStandWalkRunG=0;#fBlendRunG=-1.0;
	# print("is_on_floor()==",is_on_floor()," is_on_wall ( )=",is_on_wall ( )," is_on_ceiling ( )=",is_on_ceiling ( ),"  vMoveNowG=",vMoveNowG);
	# if(b1OnFloorG==false):
	#----1开始在空中下坠--------------------------
	if(b1OnFloorG==false):
		move_and_slide(vMoveNowG,Vector3.UP);#print("MOVE==",vMoveNowG,"is_on_floor()==",is_on_floor());
		if(is_on_floor()):
			b1OnFloorG=true;
	# print("delta==",delta," fWalk_GunG=",fWalk_GunG,"  X.bAimG=",X.bAimG);
	#----●必须在 _physics_process 才能准确检测 ↗向弹出键--------------------------
	if Input.is_action_pressed("front") ||  Input.is_action_pressed("back") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		vDirectNG = Vector3(Input.get_action_strength("right")-Input.get_action_strength("left") ,0,
												Input.get_action_strength("back")-Input.get_action_strength("front") );
		rotYCamG = cam.global_transform.basis.get_euler().y;
	
		vDirectNG = vDirectNG.rotated(Vector3.UP, rotYCamG).normalized();#旋转到与镜头同步
		if(bPressDerectG==false):bPressDerectG=true;
	#----跳高--------------------------
	if(is_on_floor() or bHitLadderG):
		if(Input.is_action_just_pressed("jump")):
		# if(Input.is_key_pressed(KEY_SPACE)):
			bJumpG=true;iAniJumpG = 1;time.start(0.5);#print("按 JUMP==",g);#get_node("sound_jump").play();
			atpG["parameters/1走or跳/active"] = true;
			move_and_slide(vMoveNowG,Vector3.UP);#先离地
		if(bPressDerectG):
			# if(Input.is_action_pressed("ACCELERATE")):#加速
			if(Input.is_key_pressed(KEY_CONTROL)):#加速
				#----从走到跑------------------
				if(fBlendRunG<1):
					fBlendRunG+=delta*3;#从走到跑
				if(fSpeedPulseG<iMaxPulseD):
					fSpeedPulseG+=delta*8;#print("十十速==",fSpeedPulseG);
				iStandWalkRunG=2;
				#------------------------------
				if(X.iFBG==0 and 0<fWeightG):
					fWeightG-=delta;#print("fWeightG==",1-fWeightG);
					cam.translation=lerp(FG.translation,F2G.translation,1-fWeightG);#●以防cam碰到头
			#----走--------------------------
			else:
				# if(Input.is_action_just_released("ACCELERATE")):
				if(X.iFBG==0 and fWeightG<=1):
					fWeightG+=delta;#print("fWeightG==",fWeightG);
					cam.translation=lerp(F2G.translation,FG.translation,fWeightG);#●以防cam碰到头
					
				#----从停到走------------------
				if(fBlendRunG<0):
					fBlendRunG+=delta*3;
					if(0<fBlendRunG):fBlendRunG=0;
				elif(0<fBlendRunG):
					fBlendRunG-=delta*4;
					if(fBlendRunG<0):fBlendRunG=0;                    
				#----从跑到走--------------------------
				if(0<fSpeedPulseG):
					fSpeedPulseG-=delta*50;
					# fSpeedPulseG=0;
				iStandWalkRunG=1;
		#----站立--------------------------
		else:
			if(X.iFBG==0 and fWeightG<=1):
				fWeightG+=delta;
				cam.translation=lerp(F2G.translation,FG.translation,fWeightG);
			#----从走到停--------------------------
			if(-1<fBlendRunG):
				fBlendRunG-=delta*5;
			iStandWalkRunG=0;
		#----在地面----------------------------------------------
		# if(is_on_floor()):#if the body is on the floor. Only updates when calling move_and_slide.
		# print("ON floar==");
		if(bHitLadderG==false):
			vMoveNowG.y=g.y;#print("↓G 1==");
		if(bJumpG):
			# print("time.time_left==",time.time_left);
			if(time.time_left==0):
				# yield(get_tree().create_timer(0.50), "timeout");
				vMoveNowG.y= up.y;#print("↑ JUMP+==",vMoveNowG.y," g.y==",g.y);
				iTimeG=0;
				move_and_slide(vMoveNowG,Vector3.UP);#先离地
		

	#----在空中--------------------------
	else:
		if(bHitLadderG==false):
			vMoveNowG.y+=delta*g10.y;#print("空中下 vMoveNowG.y==", vMoveNowG.y);
			
			if(vMoveNowG.y<0.1):
				bJumpG=false;iAniJumpG=0;
		else:
			vMoveNowG.y=0;bJumpG=false;iAniJumpG=0;
	
		move_and_slide(vMoveNowG,Vector3.UP);
	#====move==========================
	if(bPressDerectG):
		#☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐☐☐☐☐☐↗☐vMoveNowG☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐☐☐☐☐/┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐☐☐☐/☐┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐☐☐/☐☐┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐☐/☐☐☐┃☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		#☐☐O━━━━→━━→vDirectNG☐☐☐☐☐☐☐☐☐
		#☐☐☐vMoveG(修正)☐☐☐☐☐☐☐☐☐☐☐☐☐☐☐
		# vDirectNG.y = 0;vDirectNG=vDirectNG.normalized();#忽略向上方向
		vMoveNowG+=vDirectNG*delta*iMaxSpeedD; 
		fDotG=vMoveNowG.dot(vDirectNG);#print("fDotG==",fDotG,"  fSpeedPulseG==",fSpeedPulseG);
		if(fDotG<0):
			fDotG=0;fSpeedPulseG=0;#●如果在反方向,就归零方向,实现无惯性.
		elif(iMaxSpeedD<fDotG):
			fDotG=iMaxSpeedD;#限制速度
			
		vMoveTMP=vDirectNG*(fDotG+fSpeedPulseG);#print("vMoveTMP==",vMoveTMP,"  fDotG==",fDotG);
		vMoveNowG.x=vMoveTMP.x;vMoveNowG.z=vMoveTMP.z;#抵消了 不在方向上的力s
		#----移动赋值--------------------------
		# if(is_on_floor() ==false):
		move_and_slide(vMoveNowG,Vector3.UP);#player move

		# fSpeedNowG=vMoveTMP.length();#运动方向长度
	#----修正armG方向------------------------------------
	# print("armGY",armG.rotation.y,"  vDirectNG",vDirectNG,"  vMoveNowG==",vMoveNowG,"  X.iFBG==",X.iFBG);
	# if(armG.rotation.y!=rotYG):
	if(X.iFBG==1):
		fAngD_camG=atan2(-vDirectNG.x, -vDirectNG.z)-cam.rotation.y;#atan2函数返回的是原点至点(x,y)的方位角，即与 x 轴的夹角。也可以理解为复数 x+yi 的辐角。返回值的单位为弧度，取值范围为(-pi,pi);
		if(0!=fAngD_camG):
			armG.rotation.y = lerp_angle(armG.rotation.y,fAngD_camG, fTurnSpeedG*delta);
		if(Input.is_action_just_released("aim")):
			# print("RElease 右锓==");
			rotYCamG = cam.global_transform.basis.get_euler().y;
			vDirectNG = Vector3.FORWARD;
			vDirectNG = vDirectNG.rotated(Vector3.UP, rotYCamG).normalized();


	#----没有按方向,归零--------------------------
	if(bPressDerectG==false):
		vMoveNowG.x=0;vMoveNowG.z=0;vMoveTMP.x=0;vMoveTMP.z=0;#归零速度
		fSpeedPulseG=0;bTurnG=false;
	# print("vMoveNowG==",vMoveNowG.z," (vMoveToG)==",vMoveToG.z," vMoveTMP==",vMoveTMP.z,"(fSpeedNowG)",fSpeedNowG);#return ;

	#----播放动画--------------------------
	if (is_on_floor() or bHitLadderG):
		# print("iStandWalkRunG==",iStandWalkRunG,"  fBlendRunG==",fBlendRunG);
		if(iStandWalkRunG==2):
			atpG["parameters/停走跑/blend_amount"] =fBlendRunG;#1
			atpG["parameters/scale/scale"] = 2;#限制最小为1
		elif(iStandWalkRunG==1):
			atpG["parameters/停走跑/blend_amount"] =fBlendRunG; #0    
			atpG["parameters/scale/scale"] = 1;            
		else:
			atpG["parameters/停走跑/blend_amount"] =fBlendRunG;#-1
			atpG["parameters/scale/scale"] = 1;

		# atpG["parameters/停走跑/blend_amount"] =(fSpeedNowG+fSpeedPulseG)/iMaxSpeedD-1;
		# print("fSpeedNowG==",fSpeedNowG," fSpeedPulseG ",fSpeedPulseG,"   ",(fSpeedNowG+fSpeedPulseG)/iMaxSpeedD-1);
	
	#----转身--------------------------
	# atpG["parameters/LR/blend_amount"] = iLRG;
	# atpG["parameters/转身/active"] = bTurnG;
	# print("Pulse==",fSpeedPulseG,"  ",min(fSpeedPulseG, 1.0));


	
	



