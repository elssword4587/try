# WorldMap.gd
# Responsibility: Provides a controllable 2D map surface for symbolic movement.
# - Holds references to the map sprite, layers for locations and the character icon.
# - Supplies helper methods to clamp or generate positions on the map.
# Scene attachment: Add this script to a Node2D that owns a Sprite2D named "MapSprite" (centered disabled).
# Create child Node2D nodes named "LocationLayer" and "CharacterLayer" to visually separate markers.
extends Node2D

@export var map_sprite_path: NodePath
@export var location_layer_path: NodePath
@export var character_layer_path: NodePath
@export_range(0.0, 64.0) var edge_margin: float = 16.0

var map_sprite: Sprite2D
var location_layer: Node2D
var character_layer: Node2D

func _ready() -> void:
    map_sprite = _resolve_node(map_sprite_path, "MapSprite") as Sprite2D
    location_layer = _resolve_node(location_layer_path, "LocationLayer") as Node2D
    character_layer = _resolve_node(character_layer_path, "CharacterLayer") as Node2D
    if map_sprite:
        map_sprite.centered = false

func _resolve_node(path: NodePath, fallback_name: String) -> Node:
    if path != NodePath("") and has_node(path):
        return get_node(path)
    if has_node(fallback_name):
        return get_node(fallback_name)
    push_warning("WorldMap: Missing node %s" % fallback_name)
    return null

func get_map_rect() -> Rect2:
    if map_sprite == null or map_sprite.texture == null:
        return Rect2(Vector2.ZERO, Vector2.ZERO)
    var local_rect := map_sprite.get_rect()
    var global_top_left := map_sprite.to_global(local_rect.position)
    var global_bottom_right := map_sprite.to_global(local_rect.position + local_rect.size)
    var size := global_bottom_right - global_top_left
    return Rect2(global_top_left, size)

func get_random_point() -> Vector2:
    var rect := get_map_rect()
    if rect.size == Vector2.ZERO:
        return Vector2.ZERO
    var min_point := rect.position + Vector2(edge_margin, edge_margin)
    var max_point := rect.position + rect.size - Vector2(edge_margin, edge_margin)
    return Vector2(
        randf_range(min_point.x, max_point.x),
        randf_range(min_point.y, max_point.y)
    )

func clamp_to_map(global_position: Vector2) -> Vector2:
    var rect := get_map_rect()
    if rect.size == Vector2.ZERO:
        return global_position
    var clamped := global_position
    clamped.x = clamp(clamped.x, rect.position.x + edge_margin, rect.position.x + rect.size.x - edge_margin)
    clamped.y = clamp(clamped.y, rect.position.y + edge_margin, rect.position.y + rect.size.y - edge_margin)
    return clamped

func add_location_marker(marker: Node2D) -> void:
    if location_layer and marker:
        location_layer.add_child(marker)

func add_character_icon(icon: Node2D) -> void:
    if character_layer and icon:
        character_layer.add_child(icon)
