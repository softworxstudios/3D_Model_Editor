# res://addons/3D_model_editor/main.gd

extends EditorPlugin

# References to tool scripts
var select_tool
var move_tool
var rotate_tool
var scale_tool
var cube_tool
var sphere_tool
var plane_tool
var import_tool

# Reference to controller nodes (assuming they are named appropriately in the scene)
onready var left_controller = get_node_or_null("/root/ARVROrigin/ARVRControllerLeft")
onready var right_controller = get_node_or_null("/root/ARVROrigin/ARVRControllerRight")

# Reference to EditorDock
var editor_dock
var editor_dock_scene = preload("res://addons/vr_model_edit3D/EditorDock.tscn")

func _enter_tree():
    # Load and instantiate tools
    select_tool = preload("res://addons/vr_model_edit3D/tools/SelectTool.gd").new()
    move_tool = preload("res://addons/vr_model_edit3D/tools/MoveTool.gd").new()
    rotate_tool = preload("res://addons/vr_model_edit3D/tools/RotateTool.gd").new()
    scale_tool = preload("res://addons/vr_model_edit3D/tools/ScaleTool.gd").new()
    cube_tool = preload("res://addons/vr_model_edit3D/tools/CubeTool.gd").new()
    sphere_tool = preload("res://addons/vr_model_edit3D/tools/SphereTool.gd").new()
    plane_tool = preload("res://addons/vr_model_edit3D/tools/PlaneTool.gd").new()
    import_tool = preload("res://addons/vr_model_edit3D/tools/ImportTool.gd").new()
    
    # Add tools as children to ensure they are part of the scene and can process inputs
    add_child(select_tool)
    add_child(move_tool)
    add_child(rotate_tool)
    add_child(scale_tool)
    add_child(cube_tool)
    add_child(sphere_tool)
    add_child(plane_tool)
    add_child(import_tool)
    
    # Load and instantiate EditorDock
    editor_dock = editor_dock_scene.instance()
    add_control_to_dock(DOCK_SLOT_RIGHT_UL, editor_dock)
    editor_dock.main_plugin = self  # Pass reference to main plugin
    
    # Set dependencies for each tool
    # SelectTool uses the left controller for object selection
    if left_controller:
        select_tool.set_controller(left_controller)
    else:
        push_error("Left ARVRController not found. Please ensure it's named 'ARVRControllerLeft' and is present in the scene.")
    
    # Move, Rotate, and Scale tools use the right controller for manipulation
    if right_controller:
        move_tool.set_dependencies(right_controller, select_tool)
        rotate_tool.set_dependencies(right_controller, select_tool)
        scale_tool.set_dependencies(right_controller, select_tool)
        import_tool.set_dependencies(right_controller, select_tool)  # If ImportTool needs controllers
    else:
        push_error("Right ARVRController not found. Please ensure it's named 'ARVRControllerRight' and is present in the scene.")
    
    # Optionally, connect signals from selection to other tools
    # select_tool.connect("object_selected", self, "_on_object_selected")
    
    # Initialize import tool if needed
    import_tool.initialize()
    
func _exit_tree():
    # Remove tools
    if select_tool and is_instance_valid(select_tool):
        remove_child(select_tool)
        select_tool.queue_free()
    
    if move_tool and is_instance_valid(move_tool):
        remove_child(move_tool)
        move_tool.queue_free()
    
    if rotate_tool and is_instance_valid(rotate_tool):
        remove_child(rotate_tool)
        rotate_tool.queue_free()
    
    if scale_tool and is_instance_valid(scale_tool):
        remove_child(scale_tool)
        scale_tool.queue_free()
    
    if cube_tool and is_instance_valid(cube_tool):
        remove_child(cube_tool)
        cube_tool.queue_free()
    
    if sphere_tool and is_instance_valid(sphere_tool):
        remove_child(sphere_tool)
        sphere_tool.queue_free()
    
    if plane_tool and is_instance_valid(plane_tool):
        remove_child(plane_tool)
        plane_tool.queue_free()
    
    if import_tool and is_instance_valid(import_tool):
        remove_child(import_tool)
        import_tool.queue_free()
    
    # Remove and free EditorDock
    if editor_dock and is_instance_valid(editor_dock):
        remove_control_from_dock(editor_dock)
        editor_dock.queue_free()
    
    # If you added UI elements like docks, remove them here as well
    # Example:
    # if is_plugin_enabled("res://addons/vr_model_edit3D/EditorDock.tscn"):
    #     remove_control_from_dock(preload("res://addons/vr_model_edit3D/EditorDock.tscn").instance())
