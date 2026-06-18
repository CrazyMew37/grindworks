extends Node3D

enum BeanColor {
	RED,
	GREEN,
	LIGHT_BLUE,
	YELLOW,
	BLUE,
	PINK,
	ORANGE,
	MAGENTA,
	SILVER
}
@export var bean_color: BeanColor

## Child references
@onready var bean := $Jellybean_all/jellybean
@onready var highlight := $Jellybean_all/Jellybeanhilight

## Locals
var bean_mat: StandardMaterial3D
var highlight_mat: StandardMaterial3D

## Standard Bean Colors
var colors = {
	BeanColor.RED: Color(1.0, 0.0, 0.0),
	BeanColor.GREEN: Color(0.5, 1.0, 0.5),
	BeanColor.LIGHT_BLUE: Color(0.5, 1.0, 1.0),
	BeanColor.YELLOW: Color(1.0, 1.0, 0.4),
	BeanColor.BLUE: Color(0.4, 0.4, 1.0),
	BeanColor.PINK: Color(0.7, 0.5, 1.0),
	BeanColor.ORANGE: Color(1.0, 0.7, 0.4),
	BeanColor.MAGENTA: Color(1.0, 0.8, 0.9),
	BeanColor.SILVER: Color(0.8, 0.8, 0.8)
}
## Bean Values
var values := {
	BeanColor.RED: 2,
	BeanColor.YELLOW: 6,
	BeanColor.GREEN: 8,
	BeanColor.LIGHT_BLUE: 10,
	BeanColor.BLUE: 12,
	BeanColor.PINK: 14,
	BeanColor.ORANGE: 4,
	BeanColor.MAGENTA: 16,
	BeanColor.SILVER: 20
}

func _ready() -> void:
	bean_mat = bean.mesh.surface_get_material(0).duplicate(true)
	highlight_mat = highlight.mesh.surface_get_material(0).duplicate(true)
	bean.set_surface_override_material(0,bean_mat)
	highlight.set_surface_override_material(0, highlight_mat)

func setup(item: Item):
	if not item.stats_add.has('money'):
		item.stats_add['money'] = values[bean_color]
		item.big_description = "Gives +" + str(values[bean_color]) + " jellybeans."
	set_color(colors[bean_color])
	if NodeGlobals.get_ancestor_of_type(self, ToonShop):
		item.reroll()

func set_color(color: Color):
	bean_mat.albedo_color = color
	highlight_mat.albedo_color = color

func modify(ui_bean) -> void:
	ui_bean.set_color(colors[bean_color])
