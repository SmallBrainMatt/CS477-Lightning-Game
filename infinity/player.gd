extends Area2D

@export var speed = 400
var bullet = preload("res://bullet.tscn")
var bullet_speed = 2000
var screen_size
signal hit
var can_fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	can_fire = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	#Movement
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("player_fire") and can_fire == true:
		fire()
	
	#Play/stop animations (if there are any)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	look_at(get_global_mouse_position())


#Killing the player
func _on_body_entered(body: Node2D) -> void:
	hide()
	can_fire = false
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

#Beginning the game
func start(pos):
	position = pos
	show()
	can_fire = true
	$CollisionShape2D.disabled = false

#Shoot the gun
func fire():
	$Pew.play()
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.position = get_global_position()
	bullet_instance.linear_velocity = Vector2(bullet_speed,0).rotated(rotation)
	get_tree().get_root().add_child(bullet_instance)
