extends Resource
class_name UnirestConfig

@export var http_log_format: HttpLogFormat
@export var http_proxy: HttpProxy
@export var default_base_url: String

func _init(
    http_log_format: HttpLogFormat = null,
    http_proxy: HttpProxy = null,
    default_base_url: String = ""
) -> void:
    self.http_log_format = http_log_format
    self.http_proxy = http_proxy
    self.default_base_url = default_base_url

func client_certificate_store(cert_path: String) -> void:
    ProjectSettings.set_setting("network/ssl/certificates", cert_path)
