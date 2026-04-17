extends ItemScript

var player: Player:
	get: return Util.get_player()

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_round_start)

func on_round_start(manager: BattleManager) -> void:
	await get_tree().process_frame
	var new_regen := load("res://objects/battle/battle_resources/status_effects/resources/mod_cog_sturdy.tres").duplicate(true)
	new_regen.status_name = "Hard-Boiled"
	new_regen.icon = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/eggab.png")
	new_regen.icon_scale = 0.9
	new_regen.description = "You will endure lethal damage once before defeat"
	new_regen.target = player
	manager.add_status_effect(new_regen)
	BattleService.s_refresh_statuses.emit()
	
