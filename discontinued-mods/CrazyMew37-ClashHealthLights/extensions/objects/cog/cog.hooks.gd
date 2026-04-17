extends Object

# My first mod seperate from another's. Unsurprsingly, it nearly drove me mad at first. -cm37

func update_health_light(chain: ModLoaderHookChain) -> void:
	var health_ratio = float(chain.reference_object.stats.hp) / float(chain.reference_object.stats.max_hp)

	if chain.reference_object.light_tween:
		chain.reference_object.light_tween.kill()
		chain.reference_object.light_tween = null

	if health_ratio >= .95:
		chain.reference_object.hp_light.set_color(Color(0, 1, 0), Color(.25, 1, .25, .5))
	elif health_ratio >= .9:
		chain.reference_object.hp_light.set_color(Color(.5, 1, 0), Color(.5, 1, .25, .5))
	elif health_ratio >= .8:
		chain.reference_object.hp_light.set_color(Color(.75, 1, 0), Color(.75, 1, .25, .5))
	elif health_ratio >= .7:
		chain.reference_object.hp_light.set_color(Color(1, 1, 0), Color(1, 1, .25, .5))
	elif health_ratio >= .6:
		chain.reference_object.hp_light.set_color(Color(1, .866, 0), Color(1, .866, .25, .5))
	elif health_ratio >= .5:
		chain.reference_object.hp_light.set_color(Color(1, .6, 0), Color(1, .6, .25, .5))
	elif health_ratio >= .3:
		chain.reference_object.hp_light.set_color(Color(1, .5, 0), Color(1, .5, .25, .5))
	elif health_ratio >= .15:
		chain.reference_object.hp_light.set_color(Color(1, .25, 0), Color(1, .25, .25, .5))
	elif health_ratio >= .05:
		chain.reference_object.hp_light.set_color(Color(1, 0, 0), Color(1, .25, .25, .5))
	elif health_ratio > 0.0:
		chain.reference_object.light_tween = chain.reference_object.create_tween()
		chain.reference_object.light_tween.set_loops()
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(1, 0, 0), Color(1, .25, .25, .5)))
		chain.reference_object.light_tween.tween_interval(0.75)
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		chain.reference_object.light_tween.tween_interval(0.1)
	else:
		chain.reference_object.light_tween = chain.reference_object.create_tween()
		chain.reference_object.light_tween.set_loops()
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(1, 0, 0), Color(1, .25, .25, .5)))
		chain.reference_object.light_tween.tween_interval(0.25)
		chain.reference_object.light_tween.tween_callback(chain.reference_object.hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		chain.reference_object.light_tween.tween_interval(0.1)
