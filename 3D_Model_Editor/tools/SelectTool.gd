# res://addons/3D_model_editor/tools/SelectTool.gd

extends Node

# Signal emitted when an object is selected
signal object_selected(selected_node)

# Reference to the active controller (set externally)
var controller: ARVRController = null

# Currently selected object
var selected_object: Spatial = null

# Raycast node for selection
onready var raycast = RayCast.new()

func _ready():
    # Initialize RayCast
    raycast.cast_to = Vector3(0, 0, -100)  # Adjust as needed
    raycast.enabled = true
    add_child(raycast)

func set_controller(controller_node: ARVRController):
    controller = controller_node

func activate_tool():
    # Optionally reset selection or prepare tool
    pass

func _process(delta):
    if not controller:
        return
    
    # Update RayCast position and orientation
    raycast.global_transform = controller.global_transform
    raycast.force_raycast_update()
    
    if controller.is_button_pressed(BUTTON_TRIGGER):
        if raycast.is_colliding():
            var collider = raycast.get_collider()
            if collider and collider is Spatial:
                select_object(collider)

func select_object(node: Spatial):
    if selected_object != node:
        deselect_current_object()
        selected_object = node
        highlight_object(selected_object)
        emit_signal("object_selected", selected_object)

func deselect_current_object():
    if selected_object:
        unhighlight_object(selected_object)
        selected_object = null

func highlight_object(node: Spatial):
    # Simple highlight by changing the material or adding a highlight effect
    if node.has_method("set_highlight"):
        node.set_highlight(true)
    else:
        # Example: Change the modulate color to indicate selection
        if node.get_surface_material_count() > 0:
            var mat = node.get_surface_material(0).duplicate()
            mat.albedo_color = Color(1, 0, 0)  # Red highlight
            node.set_surface_material(0, mat)

func unhighlight_object(node: Spatial):
    if node.has_method("set_highlight"):
        node.set_highlight(false)
    else:
        # Reset the material color
        if node.get_surface_material_count() > 0:
            var mat = node.get_surface_material(0).duplicate()
            mat.albedo_color = Color(1, 1, 1)  # Original color
            node.set_surface_material(0, mat)

func highlight_object(node: Spatial):
    if node.get_surface_material_count() > 0:
        var mat = node.get_surface_material(0).duplicate()
        mat.set_shader_param("highlight", true)
        node.set_surface_material(0, mat)

func unhighlight_object(node: Spatial):
    if node.get_surface_material_count() > 0:
        var mat = node.get_surface_material(0).duplicate()
        mat.set_shader_param("highlight", false)
        node.set_surface_material(0, mat)