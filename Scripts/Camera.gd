extends Camera

export(NodePath) onready var target_parent = get_node(target_parent)
onready var target = target_parent.camera_target

func _process(_delta: float) -> void:
	if target:
		global_transform = target.global_transform
