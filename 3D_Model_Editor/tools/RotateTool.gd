# res://addons/3D_model_editor/tools/RotateTool.gd

extends Node

# Reference to the active controller (set externally)
var controller: ARVRController = null

# Reference to the SelectTool to get the selected object
var select_tool: Node = null

# Sensitivity factor for rotation
export(float) var rotate_sensitivity = 0.5

func _ready():
    pass

func set_dependencies(controller_node: ARVRController, select_tool_node: Node):
    controller = controller_node
    select_tool = select_tool_node

func _process(delta):
    if not controller or not select_tool:
        return
    
    if controller.is_button_pressed(BUTTON_TRIGGER):
        var selected = select_tool.selected_object
        if selected:
            # Get controller rotation delta
            var rotation_delta = controller.get_angular_velocity() * rotate_sensitivity * delta
            selected.rotate_y(rotation_delta.y)
            selected.rotate_x(rotation_delta.x)
            selected.rotate_z(rotation_delta.z)
