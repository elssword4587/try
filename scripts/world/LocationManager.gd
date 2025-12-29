# LocationManager.gd
# Responsibility: Generate and register symbolic locations on the world map at game start.
# - Randomly places cities, dungeons, and landmarks within map bounds.
# - Spawns lightweight marker nodes to visualize each location on the map image.
# Scene attachment: Add this script to a Node under the same parent as WorldMap or as its child.
# Set the exported world_map_path to point at the Node with WorldMap.gd.
extends Node

@export var world_map_path: NodePath
@export var cities: int = 2
@export var dungeons: int = 2
@export var landmarks: int = 3

var world_map: Node
var locations: Array = []

func _ready() -> void:
    randomize()
    world_map = _resolve_world_map()

func _resolve_world_map() -> Node:
    if world_map_path != NodePath("") and has_node(world_map_path):
        return get_node(world_map_path)
    if get_parent() != null and get_parent().has_node("WorldMap"):
        return get_parent().get_node("WorldMap")
    push_warning("LocationManager: WorldMap not found; generation will be skipped.")
    return null

func generate_locations() -> void:
    if world_map == null:
        return
    locations.clear()
    _spawn_type("City", cities, Color.DODGER_BLUE)
    _spawn_type("Dungeon", dungeons, Color.DARK_RED)
    _spawn_type("Landmark", landmarks, Color.DARK_GOLDENROD)

func _spawn_type(kind: String, count: int, color: Color) -> void:
    for i in range(count):
        var location := _make_location(kind, i + 1)
        locations.append(location)
        var marker := _build_marker(location, color)
        world_map.add_location_marker(marker)

func _make_location(kind: String, index: int) -> Dictionary:
    var pos := world_map.get_random_point()
    return {
        "name": "%s %d" % [kind, index],
        "type": kind,
        "position": pos
    }

func _build_marker(location: Dictionary, color: Color) -> Node2D:
    var marker := Node2D.new()
    marker.name = location.get("name", "Marker")
    marker.position = location.get("position", Vector2.ZERO)

    var shape := Polygon2D.new()
    shape.polygon = PackedVector2Array([
        Vector2(-6, -6), Vector2(6, -6), Vector2(6, 6), Vector2(-6, 6)
    ])
    shape.color = color
    marker.add_child(shape)

    var label := Label.new()
    label.text = location.get("name", "")
    label.position = Vector2(10, -12)
    label.scale = Vector2.ONE * 0.85
    marker.add_child(label)

    return marker

func get_locations_near(global_position: Vector2, radius: float) -> Array:
    var nearby: Array = []
    for location in locations:
        var pos: Vector2 = location.get("position", Vector2.ZERO)
        if pos.distance_to(global_position) <= radius:
            nearby.append(location)
    return nearby
