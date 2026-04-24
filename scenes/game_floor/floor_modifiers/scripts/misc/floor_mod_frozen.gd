extends FloorModifier

var DEFENSE_BUFF := 0.5
var ATTACK_NERF := -0.25

var status_effect: StatBoost:
	get: return GameLoader.load("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres").duplicate(true)

## Phrases the Frozen Cogs will say.
const STARTER_PHRASES : Array[String] = [
	"Who turned down the thermostat?!",
	"Get ready for a blizzard of sadness.",
	"Freeze!",
	"She must be around here somewhere...",
	"This place is colder than The Brrrgh...",
	"There's snow place to go, Toon.",
	"I'm so cold... that I'm shivering!",
	"My heart is as cold as I am.",
	"Your chances of winning? Absolute Zero.",
	"Icy you, Toon.",
]

const PHRASE_CHANCE := 1.0 / 3.0

## The cogs are FROZEN OH MY GOD-
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			if cog.dna:
				return
			cog.virtual_cog = true
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
			if not cog.is_punishment_cog:
				cog.VIRTUAL_COG_COLOR = Color('0099ffff')
	)

func cog_dna_set(cog: Cog) -> void:
	if randf():
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate(true)
	var effect := status_effect
	effect.boost = DEFENSE_BUFF
	effect.rounds = -1
	effect.quality = StatusEffect.EffectQuality.POSITIVE
	effect.stat = 'defense'
	cog.status_effects.append(effect)
	var effect_2 := status_effect
	effect_2.boost = ATTACK_NERF
	effect_2.rounds = -1
	effect_2.quality = StatusEffect.EffectQuality.NEGATIVE
	effect_2.stat = 'damage'
	cog.status_effects.append(effect_2)

func get_mod_name() -> String:
	return "FrozenStuff"
