class_name TimeSnapshot
extends Resource

@export var player_position: Vector3
@export var player_rotation: Vector3
@export var captured_texture: ImageTexture
@export var object_states: Dictionary = {} # Stores ID: state pairs for items in the room
@export var timestamp: float
