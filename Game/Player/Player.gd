extends KinematicBody2D


export var SPEED = 7500
var velocity = Vector2.ZERO setget set_velocity, get_velocity
var jumpStrength = 30
var jumped = false
var attackInProgress = false


var AttackStrength = 1
var DefenseStrength = 1
var playerHealth = 10
var playerAgility = 1.15

var AttackUpgradeIncrement = 2
var DefenseUpgradeIncrement = 2
var HealthUpgradIncrement = 5
var AgilityUpgradeIncrement = .05



# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/DebugLabel.visible = OS.is_debug_build()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if($UI/DebugLabel.visible):
		$UI/DebugLabel.text = "Attack: %d\nDefense: %d\nHealth: %d\nVelocity: (%d, %d)" % [AttackStrength, DefenseStrength, playerHealth, velocity.x, velocity.y]
	if(OS.is_debug_build()):
		if(Input.is_action_just_pressed("reset_platforms")):
			get_tree().call_group("Upgraders", "enablePlatform")
		

func _physics_process(delta):
	move(delta)
	resetJump()
	attack()

func set_velocity(value):
	velocity = value

func get_velocity():
	return velocity

func move(delta):
	var rightMovement:Vector2 = Vector2.ZERO
	var leftMovement:Vector2 = Vector2.ZERO
	var gravity:Vector2 = Vector2.DOWN * 2  * SPEED
	if(Input.is_action_pressed("right")):
		rightMovement += Vector2.RIGHT * playerAgility * SPEED
		$AnimatedSprite.flip_h = false
	if(Input.is_action_pressed("left")):
		leftMovement += Vector2.LEFT * playerAgility * SPEED
		$AnimatedSprite.flip_h = true
	if(Input.is_action_just_pressed("jump") and !jumped):
		gravity = Vector2.UP * playerAgility * jumpStrength * SPEED
		jumped = true
	
	velocity = lerp(velocity, (rightMovement+leftMovement+gravity) * delta, .15)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	if(!attackInProgress):
		displaySprite(velocity)
		
	pass

func displaySprite(velocity):
	if(int(velocity.x) == 0 and int(velocity.y) == 0):
		$AnimatedSprite.play("default")
	if(int(velocity.x) != 0):
		$AnimatedSprite.play("walk")
	if(int(velocity.y) > 0):
		$AnimatedSprite.play("jumpDown")
	if(int(velocity.y) < 0):
		$AnimatedSprite.play("jumpUp")
	pass

func attack():
	if(Input.is_action_just_pressed("attack")):
		attackInProgress = true
		$AnimationPlayer.play("attack")

func resetJump():
	if(jumped):
		jumped = !is_on_floor()

func upgradeAttack():
	AttackStrength += AttackUpgradeIncrement

func upgradeDefense():
	DefenseStrength += DefenseUpgradeIncrement

func upgradeHealth():
	playerHealth += HealthUpgradIncrement

func upgradeAgility():
	playerAgility = clamp(playerAgility+AgilityUpgradeIncrement, 1.0, 2.0)


func _on_AttackPlatform_Upgrade():
	upgradeAttack()

func _on_HealthPlatform_Upgrade():
	upgradeHealth()
	upgradeAgility()

func _on_DefensePlatform_Upgrade():
	upgradeDefense()


func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "spike"):
		attackInProgress = false
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	get_tree().call_group("Enemy", "hit") # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "attack"):
		attackInProgress = false # Replace with function body.
