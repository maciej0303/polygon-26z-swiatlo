extends Node

## usage: [br]
## ex. menu_button.pressed.connect(
##         SceneSwitcher.switch_to_packed.bind(MAIN_MENU_PACKED), CONNECT_ONE_SHOT
##         )


@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

enum Transition {
	IN = 0,
	OUT = 1,
}

const DEFAULT_TRANSITION:Dictionary[Transition, StringName] = {
	Transition.IN: &'fade_in_from_black',
	Transition.OUT: &'fade_out_to_black',
}

var _during_switch:bool = false


func switch_to_packed(new:PackedScene, transition:Dictionary[Transition, StringName]=DEFAULT_TRANSITION) -> void:
	assert(not _during_switch)
	if _during_switch:  return
	_during_switch = true
	
	_fade_out(transition.get(Transition.OUT, DEFAULT_TRANSITION[Transition.OUT]))
	await animation_player.animation_finished
	
	var err:Error = await _change_scene_to_packed(new)
	if err != OK:  return
	
	_fade_in(transition.get(Transition.IN, DEFAULT_TRANSITION[Transition.IN]))
	await animation_player.animation_finished
	_during_switch = false


func _change_scene_to_packed(to:PackedScene) -> Error:
	var tree:SceneTree = get_tree()
	var err:Error = tree.change_scene_to_packed(to)
	if err != OK:
		push_error("Failed to change scene: %s" % error_string(err))
		_during_switch = false
		return err
	await tree.scene_changed
	return OK


func _fade_in(anim_name:StringName) -> void:
	animation_player.play(anim_name)


func _fade_out(anim_name:StringName) -> void:
	animation_player.play(anim_name)

	
