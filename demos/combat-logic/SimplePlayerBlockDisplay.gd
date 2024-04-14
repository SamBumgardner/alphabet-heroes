extends Label

const TEXT_TEMPLATE = "Block: %s"

func _on_block_decreased(_previous_block:int, new_block:int):
	text = TEXT_TEMPLATE % new_block
	modulate = Color.RED

func _on_block_increased(_previous_block:int, new_block:int):
	text = TEXT_TEMPLATE % new_block
	modulate = Color.WHITE
