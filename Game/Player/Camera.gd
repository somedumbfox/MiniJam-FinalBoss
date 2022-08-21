extends Camera2D

onready var Tweener = $Tween
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_all_completed():
	get_tree().set_pause(false)

func _on_Right_body_entered(body):
	get_tree().set_pause(true)
	Tweener.interpolate_property(self, "position", position, Vector2(position.x+512, position.y), .75)
	Tweener.start()

func _on_Left_body_entered(body):
	get_tree().set_pause(true)
	Tweener.interpolate_property(self, "position", position, Vector2(position.x-512, position.y), .75)
	Tweener.start()
