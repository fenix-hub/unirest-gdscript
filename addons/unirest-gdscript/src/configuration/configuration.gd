extends Resource
class_name UnirestConfiguration

export (Resource) var http_log_format: Resource
export (Resource) var http_proxy: Resource
export (String) var default_base_url: String

func _init() -> void:
    pass

func proxy(host: String, port: int, username: String = "", password: String = "") -> void:
    http_proxy.host = host
    http_proxy.port = port
    http_proxy.username = username
    http_proxy.password = password

func log_format(request: String, response: String) -> void:
    http_log_format.request = request
    http_log_format.response = response

func client_certificate_store(cert_path: String) -> void:
    ProjectSettings.set_setting("network/ssl/certificates", cert_path)
