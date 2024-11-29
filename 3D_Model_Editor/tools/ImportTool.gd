# res://addons/3D_model_editor/tools/ImportTool.gd

extends Node

# Reference to the active controller (if needed)
var controller: ARVRController = null

# Reference to the SelectTool to add the imported model to the selection
var select_tool: Node = null

func set_dependencies(controller_node: ARVRController, select_tool_node: Node):
    controller = controller_node
    select_tool = select_tool_node

func import_model(file_path: String):
    var scene = ResourceLoader.load(file_path)
    if scene:
        var instance = scene.instance()
        if instance:
            get_tree().current_scene.add_child(instance)
            select_tool.select_object(instance)
            print("Imported model:", file_path)
        else:
            push_error("Failed to instance the model: " + file_path)
    else:
        push_error("Failed to load model: " + file_path)
