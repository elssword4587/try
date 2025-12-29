# CharacterMover.gd
# Responsibility: Symbolically move the character icon between two map points without physics.
# - Interpolates the icon's global position over time based on travel speed.
# - Reports movement completion so higher-level logic can trigger decisions.
# Scene attachment: Add this script to a Node (e.g., the character icon root) and assign the icon node in the inspector.
# Optionally set world_map_path to clamp destinations within the map.
extends Node

@export var icon_path: NodePath
@export var world_map_path: NodePath
@export var speed_pixels_per_second: float = 180.0

var icon: Node2D
var world_map: Node
var is_moving: bool = false
var _origin: Vector2
var _destination: Vector2
var _travel_duration: float = 0.0
var _elapsed: float = 0.0

signal travel_started(target_position: Vector2)
signal travel_finished(final_position: Vector2)

func _ready() -> void:
    icon = _resolve_node(icon_path) as Node2D
    world_map = _resolve_node(world_map_path)

func _process(delta: float) -> void:
    if not is_moving or icon == null:
        return
    _elapsed += delta
    var t := 1.0 if _travel_duration == 0.0 else clamp(_elapsed / _travel_duration, 0.0, 1.0)
    var next_position := _origin.lerp(_destination, t)
    icon.global_position = next_position
    if _elapsed >= _travel_duration:
        is_moving = false
        travel_finished.emit(icon.global_position)

func start_travel(target_position: Vector2) -> void:
    if icon == null:
        return
    _origin = icon.global_position
    _destination = _clamp_destination(target_position)
    var distance := _origin.distance_to(_destination)
    _travel_duration = 0.0 if speed_pixels_per_second <= 0.0 else distance / speed_pixels_per_second
    _elapsed = 0.0
    is_moving = _travel_duration > 0.0
    if is_moving:
        travel_started.emit(_destination)
    else:
        icon.global_position = _destination
        travel_finished.emit(_destination)

func snap_to(position: Vector2) -> void:
    if icon == null:
        return
    icon.global_position = _clamp_destination(position)
    is_moving = false
    _elapsed = 0.0
    _travel_duration = 0.0

func _clamp_destination(position: Vector2) -> Vector2:
    if world_map != null and world_map.has_method("clamp_to_map"):
        return world_map.clamp_to_map(position)
    return position

func _resolve_node(path: NodePath) -> Node:
    if path != NodePath("") and has_node(path):
        return get_node(path)
    return null
