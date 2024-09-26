@tool
extends EditorPlugin

var dialogue_script_import_plugin

func _enter_tree():
	dialogue_script_import_plugin = preload("dialogue_cutscene_import.gd").new()
	add_import_plugin(dialogue_script_import_plugin)

func _exit_tree():
	remove_import_plugin(dialogue_script_import_plugin)
	dialogue_script_import_plugin = null
