extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var StandingInColor = Color(1, 1, 1, 1)
var EmptyColor = Color(1, 0, 0, 1)

onready var AttackSprite = $UpgradesLabels/Attack
onready var DefenseSprite = $UpgradesLabels/Defense
onready var HealthSprite = $UpgradesLabels/Health

onready var AttackUpgrade = $UpgradePlatforms/AttackPlatform
onready var DefenseUpgrade= $UpgradePlatforms/DefensePlatform
onready var HealthUpgrade = $UpgradePlatforms/HealthPlatform
onready var Platforms = $UpgradePlatforms

enum  {ATTACK, DEFENSE, HEALTH}



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Dungeon Animations")
	AttackUpgrade.play()
	DefenseUpgrade.play()
	HealthUpgrade.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func upgradeStat(statToUpgrade):
	match(statToUpgrade):
		ATTACK:
			$Player.upgradeAttack()
			continue
		DEFENSE:
			$Player.upgradeDefense()
			continue
		HEALTH:
			$Player.upgradeHealth()
			continue
	disableUpgrades()

func disableUpgrades():
	pass


func _on_playerAttack_area_entered(_area):
	Platforms.get_child(0).modulate = StandingInColor
	upgradeStat(ATTACK)


func _on_playerDefense_area_entered(_area):
	Platforms.get_child(1).modulate = StandingInColor
	upgradeStat(DEFENSE)


func _on_playerHealth_area_entered(_area):
	Platforms.get_child(2).modulate = StandingInColor
	upgradeStat(HEALTH)


func _on_playerAttack_area_exited(_area):
	Platforms.get_child(0).modulate = EmptyColor


func _on_playerDefense_area_exited(_area):
	Platforms.get_child(1).modulate = EmptyColor


func _on_playerHealth_area_exited(_area):
	Platforms.get_child(2).modulate = EmptyColor
