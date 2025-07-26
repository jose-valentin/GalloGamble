extends Node
@onready var wall = self

func _ready():
	var segments = 60
	var radius = 85
	var thickness = 10

	# Create a shared physics material with friction
	var phys_mat = PhysicsMaterial.new()
	phys_mat.friction = 1.0  # Max = 1.0, tune as needed
	phys_mat.bounce = 100.0

	for i in range(segments):
		var angle = i * TAU / segments
		var segment = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(thickness, 40)
		segment.shape = shape

		# Apply the physics material to the segment
		segment.set("material_override", phys_mat)

		segment.rotation = angle
		segment.position = Vector2(cos(angle), sin(angle)) * radius
		wall.add_child(segment)
