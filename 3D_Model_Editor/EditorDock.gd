# res://addons/vr_model_editor/EditorDock.gd

extends VBoxContainer

# Tool references (set externally)
var main_plugin = null

func _ready():
    # Connect shape creation buttons
    $HBoxContainer/Button_Create_Cube.connect("pressed", self, "_on_create_cube_pressed")
    $HBoxContainer/Button_Create_Sphere.connect("pressed", self, "_on_create_sphere_pressed")
    $HBoxContainer/Button_Create_Plane.connect("pressed", self, "_on_create_plane_pressed")
    
    # Connect manipulation tool buttons
    $HBoxContainer_1/Button_Select.connect("pressed", self, "_on_select_tool_pressed")
    $HBoxContainer_1/Button_Move.connect("pressed", self, "_on_move_tool_pressed")
    $HBoxContainer_1/Button_Rotate.connect("pressed", self, "_on_rotate_tool_pressed")
    $HBoxContainer_1/Button_Scale.connect("pressed", self, "_on_scale_tool_pressed")
    
    # Connect import button
    $HBoxContainer_2/Button_Import_Model.connect("pressed", self, "_on_import_model_pressed")
    
    # Initialize tool states
    _update_tool_buttons()

# Callback functions for shape creation
func _on_create_cube_pressed():
    if main_plugin and main_plugin.cube_tool:
        main_plugin.cube_tool.create_cube()
    else:
        push_error("CubeTool not initialized.")
        
func _on_create_sphere_pressed():
    if main_plugin and main_plugin.sphere_tool:
        main_plugin.sphere_tool.create_sphere()
    else:
        push_error("SphereTool not initialized.")
        
func _on_create_plane_pressed():
    if main_plugin and main_plugin.plane_tool:
        main_plugin.plane_tool.create_plane()
    else:
        push_error("PlaneTool not initialized.")

# Callback functions for manipulation tools
func _on_select_tool_pressed():
    if main_plugin and main_plugin.select_tool:
        main_plugin.select_tool.activate_tool()
        _update_tool_buttons(active_tool="select")
    else:
        push_error("SelectTool not initialized.")

func _on_move_tool_pressed():
    if main_plugin and main_plugin.move_tool:
        main_plugin.move_tool.activate_tool()
        _update_tool_buttons(active_tool="move")
    else:
        push_error("MoveTool not initialized.")

func _on_rotate_tool_pressed():
    if main_plugin and main_plugin.rotate_tool:
        main_plugin.rotate_tool.activate_tool()
        _update_tool_buttons(active_tool="rotate")
    else:
        push_error("RotateTool not initialized.")

func _on_scale_tool_pressed():
    if main_plugin and main_plugin.scale_tool:
        main_plugin.scale_tool.activate_tool()
        _update_tool_buttons(active_tool="scale")
    else:
        push_error("ScaleTool not initialized.")

# Callback for import model
func _on_import_model_pressed():
    # Open a file dialog to select a model to import
    var file_dialog = FileDialog.new()
    file_dialog.mode = FileDialog.MODE_OPEN_FILE
    file_dialog.access = FileDialog.ACCESS_FILESYSTEM
    file_dialog.filters = ["*.obj ; Wavefront OBJ", "*.glb ; GLTF Binary", "*.gltf ; GLTF Text", "*.fbx ; FBX"]
    file_dialog.connect("file_selected", self, "_on_model_selected")
    add_child(file_dialog)
    file_dialog.popup_centered()

func _on_model_selected(path):
    if main_plugin and main_plugin.import_tool:
        main_plugin.import_tool.import_model(path)
    else:
        push_error("ImportTool not initialized.")

# Function to update tool button states (e.g., highlight active tool)
func _update_tool_buttons(active_tool = null):
    # Reset all buttons
    $HBoxContainer_1/Button_Select.modulate = Color(1, 1, 1)
    $HBoxContainer_1/Button_Move.modulate = Color(1, 1, 1)
    $HBoxContainer_1/Button_Rotate.modulate = Color(1, 1, 1)
    $HBoxContainer_1/Button_Scale.modulate = Color(1, 1, 1)
    
    # Highlight the active tool button
    match active_tool:
        "select":
            $HBoxContainer_1/Button_Select.modulate = Color(0.8, 0.8, 1)
        "move":
            $HBoxContainer_1/Button_Move.modulate = Color(0.8, 0.8, 1)
        "rotate":
            $HBoxContainer_1/Button_Rotate.modulate = Color(0.8, 0.8, 1)
        "scale":
            $HBoxContainer_1/Button_Scale.modulate = Color(0.8, 0.8, 1)
        _:
            pass
