extends Node

@export var mob_scene: PackedScene
var score

func game_over():
	$MobTimer.stop()

#Begins the game
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

#Begin the mob timer
func _on_start_timer_timeout():
	$MobTimer.start()

#Spawn the mobs
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
