extends Node3D

const GRID_SIDE := 20

@onready var _instanced_blocks: MultiMeshInstance3D = $InstancedBlocks
@onready var _sun: DirectionalLight3D = $Sun
@onready var _stats: Label = $HUD/Stats

var _individual_blocks: Node3D

func _ready() -> void:
	var batch := _instanced_blocks.multimesh
	var center_column := (GRID_SIDE - 1) * 0.5
	var ground_offset := -batch.mesh.get_aabb().position.y

	batch.instance_count = GRID_SIDE * GRID_SIDE
	for row in GRID_SIDE:
		for column in GRID_SIDE:
			var position_in_grid := Vector3((column - center_column) * 0.44, ground_offset, row * 0.235)

			batch.set_instance_transform(
				row * GRID_SIDE + column, Transform3D(Basis.IDENTITY, position_in_grid)
			)

func _process(_delta: float) -> void:
	var mode := "GPU instancing" if _instanced_blocks.visible else "Individual meshes"
	var draw_calls := int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))

	_stats.text = "%s  |  %d draw calls\nI  Switch mode    L  Toggle directional light" % [
		mode, draw_calls
	]


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_I:
				_toggle_instancing()

			KEY_L:
				_sun.visible = not _sun.visible


func _toggle_instancing() -> void:
	if is_instance_valid(_individual_blocks):
		_individual_blocks.hide()
		_individual_blocks.queue_free()
		_individual_blocks = null
		_instanced_blocks.show()

		return

	_individual_blocks = Node3D.new()
	_individual_blocks.name = "IndividualBlocks"

	add_child(_individual_blocks)

	var batch := _instanced_blocks.multimesh

	for index in batch.instance_count:
		var block := MeshInstance3D.new()

		block.mesh = batch.mesh
		block.transform = batch.get_instance_transform(index)
		block.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

		_individual_blocks.add_child(block)
	_instanced_blocks.hide()