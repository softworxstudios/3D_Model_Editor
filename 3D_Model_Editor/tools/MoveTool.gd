# res://addons/3D_model_editor/tools/MoveTool.gd

extends Node

# Reference to the active controller (set externally)
var controller: ARVRController = null

# Reference to the SelectTool to get the selected object
var select_tool: Node = null

# Sensitivity factor for movement
export(float) var move_sensitivity = 0.01

func _ready():
    pass

func set_dependencies(controller_node: ARVRController, select_tool_node: Node):
    controller = controller_node
    select_tool = select_tool_node

func _process(delta):
    if not controller or not select_tool:
        return
    
    if controller.is_button_pressed(BUTTON_GRIP):
        var selected = select_tool.selected_object
        if selected:
            var movement = controller.get_linear_velocity() * move_sensitivity
            selected.translate(movement)
