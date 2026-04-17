extends ItemScript

# this item has been consistenly the most broken in the game and idk why :/ -cm37

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-CrazyCrossovers", "crossoversettings")
var EndlessNerfsSetting = SettingsConfig.data["endlessnerfs"]
var old_bean_amount : int

func on_collect(_item: Item, _object: Node3D) -> void:
	grab_old_bean_amount()
	setup()

func on_load(_item: Item) -> void:
	grab_old_bean_amount()
	setup_load()

func on_item_removed() -> void:
	Util.get_player().stats.max_hp -= old_bean_amount

func grab_old_bean_amount() -> void:
	old_bean_amount = floori(Util.get_player().stats.money / 5)
	if old_bean_amount > 100 && EndlessNerfsSetting == 0:
		old_bean_amount = 100

func setup() -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	var player := Util.get_player()
	player.stats.s_money_changed.connect(on_money_changed)
	first_money_change(player.stats.money)

func setup_load() -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	var player := Util.get_player()
	player.stats.s_money_changed.connect(on_money_changed)
	on_money_changed(player.stats.money)

func first_money_change(money: int) -> void:
	var money_laff = floori(money / 5)
	if money_laff > 100 && EndlessNerfsSetting == 0:
		money_laff = 100
	Util.get_player().stats.max_hp = Util.get_player().stats.max_hp + money_laff
	Util.get_player().stats.hp = Util.get_player().stats.hp + money_laff

func on_money_changed(money: int) -> void:
	var money_laff = floori(money / 5)
	if money_laff > 100 && EndlessNerfsSetting == 0:
		money_laff = 100
	Util.get_player().stats.max_hp -= old_bean_amount
	Util.get_player().stats.max_hp = Util.get_player().stats.max_hp + money_laff
	Util.get_player().stats.hp = Util.get_player().stats.hp + (money_laff - old_bean_amount)
	grab_old_bean_amount()
