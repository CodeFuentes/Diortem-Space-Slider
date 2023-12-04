extends CharacterBody2D

# SIGNALS
signal shoot(caller, position, direction)

# PHYSICS
const GRAVITY = 750
const SPEED = 200.0
const JUMP_VELOCITY = -350.0

# 
var is_on_air = false;
var can_shoot = true;

var is_cannon_active = false:
	set(active):
		is_cannon_active = active
		$ShootingParticles.emitting = active
		if active:
			active_sprite = cannon_sprites
		else:
			active_sprite = no_cannon_sprites

# STATES
const STATE_IDLE = "idle"
const STATE_RUNNING = "running"
const STATE_JUMPING = "jumping"
const STATE_WALL_SLIDING = "wall_sliding"

var current_state = STATE_IDLE

# STATE MAPS
var cannon_states = {
	true: "cannon",
	false: "no_cannon"
}
var animations_map = {
	"cannon": {
		STATE_IDLE: "idle_shooting",
		STATE_RUNNING: "run_shooting"
	},
	"no_cannon": {
		STATE_IDLE: "idle",
		STATE_RUNNING: "running",
		STATE_JUMPING: "spinning"
	}
}

# SPRITE MANAGEMENT

@onready var cannon_sprites: Sprite2D = $NoCannonSprites
@onready var no_cannon_sprites: Sprite2D = $CannonSprites
@onready var active_sprite: Sprite2D = $NoCannonSprites:
	set(sprite):
		active_sprite = sprite
		cannon_sprites.visible = cannon_sprites == active_sprite
		no_cannon_sprites.visible = no_cannon_sprites == active_sprite

# METHODS

func _ready():
	is_cannon_active = false;

func _process(_delta):
	
	var x_direction = Input.get_axis("LEFT", "RIGHT")
	var is_player_moving: bool = x_direction;
	
	if Input.is_action_just_pressed("SHOOT") and not is_on_air:
		is_cannon_active = true
		shoot.emit(Globals.PLAYER, $CannonMarker.global_position, Vector2(x_direction, 0))
	
	if is_on_air:
		current_state = STATE_JUMPING
		is_cannon_active = false
	elif x_direction:
		current_state = STATE_RUNNING
	else:
		current_state = STATE_IDLE
		
	if is_player_moving and x_direction < 0:
		active_sprite.flip_h = true
	elif is_player_moving and x_direction > 0:
		active_sprite.flip_h = false
			

func play_animation(player_state):
	var cannon_state = cannon_states[is_cannon_active]
	$AnimationPlayer.play(animations_map[cannon_state][player_state])
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
