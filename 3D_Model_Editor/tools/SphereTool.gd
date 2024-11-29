extends EditorScript

tool
class_name SphereTool

func create_sphere(size = Vector3(1, 1, 1)):
    var mesh = SphereMesh.new()
    mesh.size = size
    var mesh_instance = MeshInstance.new()
    mesh_instance.mesh = mesh
    get_editor_interface().get_selection().add_node(mesh_instance)
