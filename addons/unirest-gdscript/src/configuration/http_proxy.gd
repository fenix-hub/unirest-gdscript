extends Resource
class_name HttpProxy

export (String) var host: String = ""
export (int) var port: int = -1
export (String) var username: String = ""
export (String) var password: String = ""

func _init(host: String, port: int, username: String = "", password: String = "") -> void:
    self.host = host
    self.port = port
    self.username = username
    self.password = password
