# res://addons/3D_model_editor/tools/InputManager.gd

extends Node

# Signals for different actions
signal move_trigger_pressed(delta)
signal rotate_trigger_pressed(delta)
signal scale_thumb_pressed(delta)
signal object_selected(selected_node)

# References to controllers and tools
var left_controller: ARVRController = null
var right_controller: ARVRController = null
var select_tool: SelectTool = null

func _ready():
    # Initialize references (set externally)
    pass

func set_dependencies(left_ctrl: ARVRController, right_ctrl: ARVRController, select_t: SelectTool):
    left_controller = left_ctrl
    right_controller = right_ctrl
    select_tool = select_t
    
    # Connect signals or set up as needed
    # Example: connect select_tool's object_selected to emit own signal
    select_tool.connect("object_selected", self, "emit_object_selected")

func emit_object_selected(selected_node):
    emit_signal("object_selected", selected_node)

func _process(delta):
    if left_controller and left_controller.is_button_pressed(BUTTON_TRIGGER):
        # Handle selection via select_tool
        pass
    
    if right_controller:
        if right_controller.is_button_pressed(BUTTON_GRIP):
            var selected = select_tool.selected_object
            if selected:
                var movement = right_controller.get_transform().basis.z.normalized() * 0.01 * delta
                emit_signal("move_trigger_pressed", movement)
        
        if right_controller.is_button_pressed(BUTTON_TRIGGER):
            var selected = select_tool.selected_object
            if selected:
                var rotation_delta = right_controller.get_angular_velocity() * 0.5 * delta
                emit_signal("rotate_trigger_pressed", rotation_delta)
        
        if right_controller.is_button_pressed(BUTTON_THUMB):
            var selected = select_tool.selected_object
            if selected:
                var input_axis = right_controller.get_analog(BUTTON_AXIS_TRIGGER)  # Adjust as per controller setup
                var scale_factor = 1 + (input_axis * 0.01)
                emit_signal("scale_thumb_pressed", scale_factor)
