import sys
from opcua import Client
from opcua import ua
# from erlport.erlterms import Atom
# from erlport.erlang import call


url = None
name_uri = None
opc_client = None
name_index = None
root = None
objects = None

def connect(p_url,p_name_uri):
    global url
    global name_uri
    global opc_client
    global name_index
    global root
    global objects

    try:
        if isinstance(p_url, bytes):
            p_url = p_url.decode("utf-8")
        if isinstance(p_name_uri, bytes):
            p_name_uri = p_name_uri.decode("utf-8")

        url = p_url
        name_uri = p_name_uri
        opc_client =  Client(url)
        opc_client.connect()
        opc_client.load_type_definitions()

        name_index = opc_client.get_namespace_index(name_uri)
        root = opc_client.get_root_node()
        objects = opc_client.get_objects_node()

        return True
    except Exception as ex: # 에러 종류
        # print(ex)
        return (False,str(ex))

def disconnect():
    opc_client.disconnect()

def get_name_index():
    name_index
    return (True, name_index)

# obj 의 variables 들을 가져온다. 
def get_variables_of_obj(obj):        
    result = []

    for var in obj.get_variables():
        result.insert(len(result), (var.get_display_name().Text, var.get_value()))
        # result.insert(len(result), var.get_value())

    return result

def get_variables_of_path(path = None):
    obj = get_child_of_path(path)
    return get_variables_of_obj(obj)

# 한 객체를 가져온다 
# node_path = "2:obj1/2:obj1_1"
def get_child_of_path(path = None):    
    if path == None or path.decode("utf-8") == "/":
        return objects

    if isinstance(path, str):
        path = path.split("/")
    elif isinstance(path, bytes):
        path = path.decode("utf-8").split("/")

    return objects.get_child(path)

# 한 객체의 하위 객체만을 가져온다. (variable을 제외한 )
def get_sub_objects_of_obj(obj=None):
    if (obj == None):
        obj = objects

    result = []
    object_children = obj.get_children(ua.ObjectIds.HierarchicalReferences, ua.NodeClass.Object)

    for child in object_children:
        result.insert(len(result), child.get_display_name().Text)
    return result

# path의 하위 object 들을 가져온다
def get_sub_objects_of_path(path=None):
    obj = get_child_of_path(path)
    return get_sub_objects_of_obj(obj)
    
def test():
    print("this is python")
    return get_sub_objects_of_obj()

# print(connect("opc.tcp://localhost:4840/freeopcua/server/", "http://example.org"))
# print(get_name_index())


# print("objects : ",get_child_of_path())
# print("sub objects of Objects : ", get_sub_objects_of_obj())

# print("variables of 2:obj1 : ", get_variables_of_path("2:obj1"))

# print("child of 2:obj1 : ", get_child_of_path("2:obj1"))
# print("variables of 2:obj1/2:obj1_1 : ", get_variables_of_path("2:obj1/2:obj1_1"))




# print(disconnect())
