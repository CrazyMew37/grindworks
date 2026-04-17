extends Object

# ngl Clash/Altis has some wack HP lights. This has a lot more colors but is more even. -cm37

func update_health_light(chain: ModLoaderHookChain) -> void:
	var health_ratio = float(chain.reference_object.stats.hp) / float(chain.reference_object.stats.max_hp)

	if chain.reference_object.light_tween:
		chain.reference_object.light_tween.kill()
		chain.reference_object.light_tween = null

	if health_ratio >= .95:
		chain.reference_object.hp_light.set_color(Color(0, 1, 0), Color(.25, 1, .25, .5))
	elif health_ratio >= .9:
		chain.reference_object.hp_light.set_color(Color(.25, 1, 0), Color(.25, 1, .25, .5))
	elif health_ratio >= .85:
		chain.reference_object.hp_light.set_color(Color(.5, 1, 0), Color(.5, 1, .25, .5))
	elif health_ratio >= .8:
		chain.reference_object.hp_light.set_color(Color(.75, 1, 0), Color(.75, 1, .25, .5))
	elif health_ratio >= .75:
		chain.reference_object.hp_light.set_color(Color(1, 1, 0), Color(1, 1, .25, .5))
	elif health_ratio >= .7:
		chain.reference_object.hp_light.set_color(Color(1, .9, 0), Color(1, .9, .25, .5))
	elif health_ratio >= .65:
		chain.reference_object.hp_light.set_color(Color(1, .8, 0), Color(1, .8, .25, .5))
	elif health_ratio >= .6:
		chain.reference_object.hp_light.set_color(Color(1, .7, 0), Color(1, .7, .25, .5))
	elif health_ratio >= .55:
		chain.reference_object.hp_light.set_color(Color(1, .6, 0), Color(1, .6, .25, .5))
	elif health_ratio >= .5:
		chain.reference_object.hp_light.set_color(Color(1, .5, 0), Color(1, .5, .25, .5))
	elif health_ratio >= .45:
		chain.reference_object.hp_light.set_color(Color(1, .4, 0), Color(1, .4, .25, .5))
	elif health_ratio >= .4:
		chain.reference_object.hp_light.set_color(Color(1, .3, 0), Color(1, .3, .25, .5))
	elif health_ratio >= .35:
		chain.reference_object.hp_light.set_color(Color(1, .2, 0), Color(1, .25, .25, .5))
	elif health_ratio >= .3:
		chain.reference_object.hp_light.set_color(Color(1, .1, 0), Color(1, .25, .25, .5))
	elif health_ratio >= .25:
		chain.reference_object.hp_light.set_color(Color(1, 0, 0), Color(1, .25, .25, .5))
	elif health_ratio >= .2:
		chain.reference_object.hp_light.set_color(Color(.9, 0, 0), Color(.9, .25, .25, .5))
	elif health_ratio >= .15:
		chain.reference_object.hp_light.set_color(Color(.8, 0, 0), Color(.8, .25, .25, .5))
	elif health_ratio >= .1:
		chain.reference_object.hp_light.set_color(Color(.7, 0, 0), Color(.7, .25, .25, .5))
	elif health_ratio >= .05:
		chain.reference_object.hp_light.set_color(Color(.6, 0, 0), Color(.6, .25, .25, .5))
	elif health_ratio > 0.0:
		chain.reference_object.light_tween = chain.reference_object.create_tween()
		chain.reference_object.light_tween.set_loops()
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.6, 0, 0), Color(.6, .25, .25, .5)))
		chain.reference_object.light_tween.tween_interval(0.75)
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		chain.reference_object.light_tween.tween_interval(0.1)
	else:
		chain.reference_object.light_tween = chain.reference_object.create_tween()
		chain.reference_object.light_tween.set_loops()
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.5, 0, 0), Color(.5, .25, .25, .5)))
		chain.reference_object.light_tween.tween_interval(0.25)
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		chain.reference_object.light_tween.tween_interval(0.1)
