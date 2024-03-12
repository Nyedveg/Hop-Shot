extends Area3D


func _on_body_entered(body):
		# Check if the body is the player
	if body.name == "Player":
		# Call the player's add_weapon method
		body.spawn_weapon("weapon")
		# Delete the weapon pickup
		queue_free()
