extends Area

# var taken = false
signal snHit
func __on_ladder_body_enter(body):
    #if(body.name=="player女西装"):
    print("__on_ladder_body_enter==",body.name);
    emit_signal("snHit");
	# if not taken and body is preload("res://player/player.gd"):
		# get_node("Animation").play("take")
		# taken = true
