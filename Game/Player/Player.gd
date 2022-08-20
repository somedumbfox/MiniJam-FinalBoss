extends KinematicBody2D


export var SPEED = 7500
var velocity = Vector2.ZERO setget set_velocity, get_velocity
var jumpStrength = 50
var jumped = false


var AttackStrength = 1
var DefenseStrength = 1
var playerHealth = 10

var AttackUpgradeIncrement = 2
var DefenseUpgradeIncrement = 2
var HealthUpgradIncrement = 5



# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/DebugLabel.visible = OS.is_debug_build()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if($UI/DebugLabel.visible):
		$UI/DebugLabel.text = "Attack: %d\nDefense: %d\nHealth: %d\n" % [AttackStrength, DefenseStrength, playerHealth]
	pass

func _physics_process(delta):
	move(delta)
	resetJump()
	pass
func set_velocity(value):
	velocity = value

func get_velocity():
	return velocity

func move(delta):
	var rightMovement:Vector2 = Vector2.ZERO
	var leftMovement:Vector2 = Vector2.ZERO
	var gravity:Vector2 = Vector2.DOWN * 2
	if(Input.is_action_pressed("right")):
		rightMovement.x = 2
	if(Input.is_action_pressed("left")):
		leftMovement.x = -2
	if(Input.is_action_just_pressed("jump") and !jumped):
		gravity.y =- jumpStrength
		jumped = true
	
	velocity = lerp(velocity, (rightMovement+leftMovement+gravity) * SPEED * delta, .25)
	
	velocity = move_and_slide(velocity, Vector2.UP) 
		
	pass

func attack():
	pass

func resetJump():
	if(jumped):
		jumped = !is_on_floor()

func upgradeAttack():
	AttackStrength += AttackUpgradeIncrement

func upgradeDefense():
	DefenseStrength += DefenseUpgradeIncrement

func upgradeHealth():
	playerHealth += HealthUpgradIncrement
