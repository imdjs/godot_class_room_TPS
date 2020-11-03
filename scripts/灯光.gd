extends Spatial

const VAR= preload("E:/Godot/GdscriptLib/GSLIB_var.gd");

onready var nPip0G=get_node("../墙窗门/光管");
onready var nLight0G=get_node("../墙窗门/光管/SpotLight2");
onready var nLight1G=get_node("柱方/光管2/SpotLight2");
onready var nLight2G=get_node("柱方2/光管2/SpotLight2");

onready var matPip0G=preload("res://Mat/光W.material");
var matPip00G=null;var matPip10G=null;var matPip20G=null;

onready var player =get_node("../../百度二/player女西装");
#onready var playerGray =get_node("../../小灰人红/player小灰人");
var fDistanceG=0;
var time=null;var iLastG=0;var iLast1G=2;
func _ready():
	matPip00G=nPip0G.get_mesh().surface_get_material(0);
	# matPip10G=nPip1G.get_mesh().surface_get_material(0);
	# matPip20G=nPip2G.get_mesh().surface_get_material(0);
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);#让鼠标永远在中间
	#print("nLight1G==",nLight1G,"  playerGray=",playerGray);
	# nLight0G.visible=false;nLight1G.visible=false;nLight2G.visible=false;
	# print("mat0==",matPip00G,nPip0G.get_mesh().surface_1.name);#转独立子资源后
	print("mat==",nPip0G.get_surface_material(0),"  mat1",matPip0G);
	
	# matPip00G.albedo_color=VAR.cD;print("matPip00G.albedo_color==",matPip00G.albedo_color);
	# matPip00G.emission_enabled=false;
	time=get_tree().create_timer(1000.5);
	iLastG=time.time_left;iLast1G=iLastG-1;
	# print("time_left0 ==",time.time_left);
	
func _input(event):
	#----退出--------------------------
	# if (Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_Q)):
		# get_tree().quit();
	# if(Input.is_action_pressed("front")):
	# if(event is InputEventMouseMotion):
	pass
	
	
func _physics_process(delta):
	# if(Input.is_key_pressed(KEY_CONTROL)):
	# if(Input.is_mouse_button_pressed(BUTTON_RIGHT)):
	# if(is_on_floor()):
	# v=move_and_slide(v1,Y);
	# atpG["parameters/混合/blend_amount"]=fBlendG;
	# fDistanceG=(player.translation-playerGray.translation).length();
	#fDistanceG=(player.global_transform.origin-playerGray.global_transform.origin).length();
	# print("fDistanceG==",fDistanceG);
	return ;
	if(0<time.time_left):
		if(20<fDistanceG):
			if(time.time_left <=iLast1G):
				if(randi()&1==0):
					# matPip00G.emission_enabled=!matPip00G.emission_enabled;
					nLight0G.visible=!nLight0G.visible;nLight1G.visible=nLight0G.visible;nLight2G.visible=nLight0G.visible;
					if(nLight0G.visible):
						matPip00G.emission_energy=3;
					else:
						matPip00G.emission_energy=0;
					# iLastG=time.time_left;
				iLast1G=time.time_left - 0.1;#print("--==",iLast1G);
		else:
			if(nLight0G.visible==false):
				matPip00G.emission_energy=3;nLight0G.visible=true;nLight1G.visible=nLight0G.visible;nLight2G.visible=nLight0G.visible;
		# print("time_left==",time.time_left);
	# print("time_left ==",time.time_left,"_iLast1G=",iLast1G,fDistanceG,"randi()&0=",randi()&1);
	pass

		
		

		
		
		
		
		
		
		
