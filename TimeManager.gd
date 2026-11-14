extends Node

const TimeSnapshot_img = preload("res://TimeSnapshot.gd")

var active_snapshots: Array[TimeSnapshot] = []
const MAX_SNAPSHOTS: int = 5 

func take_snapshot(player: Node3D, current_room_objects: Array) -> TimeSnapshot:
	var snapshot = TimeSnapshot.new()
	snapshot.player_position = player.global_position
	snapshot.player_rotation = player.global_rotation
	snapshot.timestamp = Time.get_unix_time_from_system()
	
	for obj in current_room_objects:
		if obj.has_method("get_save_state"):
			snapshot.object_states[obj.get_instance_id()] = obj.get_save_state()
			
	active_snapshots.append(snapshot)
	if active_snapshots.size() > MAX_SNAPSHOTS:
		active_snapshots.pop_front()
		
	print("Polaroid captured! Total snapshots: ", active_snapshots.size())
	return snapshot

func revert_to_snapshot(snapshot: TimeSnapshot, player: Node3D, current_room_objects: Array):
	player.global_position = snapshot.player_position
	player.global_rotation = snapshot.player_rotation
	
	# Restore objects
	for obj in current_room_objects:
		var id = obj.get_instance_id()
		if snapshot.object_states.has(id) and obj.has_method("restore_state"):
			obj.restore_state(snapshot.object_states[id])
			
	print("Time bounced back to snapshot from: ", snapshot.timestamp)
