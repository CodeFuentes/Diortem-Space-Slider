extends Area2D
class_name Projectile

@export var speed: int = 1000
var direction: Vector2

var damage = Globals.DEFAULT_DAMAGE
var is_true_damage = false

var has_area_effect = false
var emits_light = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointLight2D.enabled = emits_light
	$QueueFreeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit()
	queue_free()


func _on_queue_free_timer_timeout():
	queue_free()
