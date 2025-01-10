extends Resource
class_name UserPreferences

const PATH: String = "user://user_preferences.tres"

@export_range(0, 1, 0.05) var sound_volume: float = 1.0
@export_range(0, 1, 0.05) var music_volume: float = 1.0
@export var difficulty: GlobalState.Difficulty = GlobalState.Difficulty.Normal

func save() -> void:
	ResourceSaver.save(self, PATH)

static func load_or_create() -> UserPreferences:
	var ret: UserPreferences = load(PATH) as UserPreferences
	if ret:
		return ret
	ret = UserPreferences.new()
	ret.save()
	return ret
