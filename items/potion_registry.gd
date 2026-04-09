extends Resource
class_name PotionRegistry

const HealEffect = preload("res://items/effects/heal_effect.gd")
const SpeedEffect = preload("res://items/effects/speed_effect.gd")

static func get_effects_for(potion_id: String) -> Array:
	var out: Array = []
	match potion_id:
		"health_potion":
			var h = HealEffect.new()
			h.amount = 25
			out.append(h)
		"speed_potion":
			var s = SpeedEffect.new()
			s.multiplier = 3.0
			s.duration = 5.0
			out.append(s)
		"super_potion":
			var h2 = HealEffect.new()
			h2.amount = 50
			var s2 = SpeedEffect.new()
			s2.multiplier = 2.5
			s2.duration = 6.0
			out.append(h2)
			out.append(s2)
		"light_potion":
			# placeholder - no effects yet
			pass
		"fire_potion":
			# can implement damage-over-time or other behavior later
			pass
		_:
			pass

	return out
