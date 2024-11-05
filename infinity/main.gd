extends Node

@export var mob_scene: PackedScene
var score
var spawn_wait_time = 2
var speed_range_min = 150
var speed_range_max = 250

#func game_over():
#	print("game_over() function called in main.gd")
#	$HUD.show_game_over()
#	$MobTimer.stop()

#Begins the game
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("Get Ready")

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

	var velocity = Vector2(randf_range(speed_range_min, speed_range_max), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_spawn_increase_timer_timeout() -> void:
	if speed_range_min < 500:
		speed_range_min += 20
	if speed_range_max < 700:
		speed_range_max += 20
