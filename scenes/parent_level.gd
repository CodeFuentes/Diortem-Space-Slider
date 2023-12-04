extends Node2D

var player_bullet: PackedScene = preload("res://projectiles/player_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for shooter in get_tree().get_nodes_in_group('Shooters'):
		shooter.connect("shoot", _on_shooter_shoot)

func _on_shooter_shoot(caller, projectile_position, projectile_direction):
	var projectile_scene: PackedScene = player_bullet
	
	if caller != Globals.PLAYER:
		# projectile = something else
		pass
	
	var projectile = projectile_scene.instantiate() as Area2D
	projectile.position = projectile_position
	projectile.direction = projectile_direction
	$Projectiles.add_child(projectile)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
