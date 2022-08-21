extends Node2D

var ActiveColor = Color(1.0, 1.0, 1.0, 0.5)
var InactiveColor = Color(1.0, 0.0, 0.0, 0.5)
var isActive = false
export var limitedUpgrades = true
var maxUpgradesMet = false
var seekTime
export (Array, String, MULTILINE) var HintDialouge:Array = []
onready var Hint = $CanvasLayer/Hint

signal Upgrade


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Platform.modulate = InactiveColor # Replace with function body.
	$Platform.frame = 0
	$AnimationPlayer.play("FloatingSprite")
	seekTime = float(randi() % int($AnimationPlayer.current_animation_length)) + randf()
	$AnimationPlayer.seek(seekTime, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("attack") and isActive and !maxUpgradesMet):
		emit_signal("Upgrade")
		get_tree().call_group("Upgraders", "disablePlatform")
		advanceUpgradeSprite()

func advanceUpgradeSprite():
	if(limitedUpgrades):
		var numUpgrades = $UpgradeSprite.frames.get_frame_count($UpgradeSprite.animation) - 1
		var currentUpgrade = $UpgradeSprite.frame
		if(currentUpgrade < numUpgrades):
			$UpgradeSprite.frame = currentUpgrade+1
		else:
			maxUpgradesMet = true
		pass

func disablePlatform():
	$playerDetector.set_deferred("monitoring", false)
	hide()

func enablePlatform():
	show()
	if(!maxUpgradesMet):
		$playerDetector.set_deferred("monitoring", true)
	else:
		$UpgradeSprite.modulate = InactiveColor

func _on_playerDetector_body_entered(body):
	$Platform.modulate = ActiveColor
	isActive = true
	Hint.setD(HintDialouge)
	Hint.reset()
	Hint.show()
	


func _on_playerDetector_body_exited(body):
	$Platform.modulate = InactiveColor
	isActive = false
	Hint.hide()
