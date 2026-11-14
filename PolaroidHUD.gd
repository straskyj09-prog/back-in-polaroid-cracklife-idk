extends CanvasLayer

const POLAROID_CARD_SCENE = preload("res://PolaroidCard.tscn")

@onready var flash_rect: ColorRect = $Control/FlashRect
@onready var photo_strip: HBoxContainer = $Control/PhotoStrip

func trigger_flash():
	flash_rect.color = Color(1, 1, 1, 1)
	
	var tween = create_tween()
	# Animate the alpha channel of the Color property directly
	tween.tween_property(flash_rect, "color:a", 0.0, 0.35)

func add_polaroid_to_hud(snapshot, player: Node3D, room_objects: Array):
	trigger_flash()
	
	if photo_strip.get_child_count() >= TimeManager.MAX_SNAPSHOTS:
		var oldest = photo_strip.get_child(0)
		oldest.queue_free()
	
	var card = POLAROID_CARD_SCENE.instantiate()
	if card is Control:
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		
	photo_strip.add_child(card)
	
	# Safely look for the texture display node inside the card
	var texture_rect = card.get_node_or_null("MarginContainer/PhotoDisplay")
	if texture_rect and snapshot.has("captured_texture"):
		texture_rect.texture = snapshot.captured_texture
	
	card.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			trigger_flash()
			TimeManager.revert_to_snapshot(snapshot, player, room_objects)
	)
