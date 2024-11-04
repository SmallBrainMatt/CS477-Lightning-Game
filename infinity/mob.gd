extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

#Kill mob when it's off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#This doesn't work
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bullet":
		print("Bullet hit detected!")
		queue_free()
