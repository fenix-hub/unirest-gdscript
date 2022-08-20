extends Reference
class_name EmptyResponse

var config: UnirestConfiguration = load("res://addons/unirest-gdscript/src/configuration/configuration.tres")

var headers: Dictionary
var status: int

func _init(headers: PoolStringArray, status: int) -> void:
    self.headers = UniOperations.dictionary_to_headers(headers)
    self.status = status

func get_headers() -> Dictionary:
    return headers

func get_status() -> int:
    return status

func _to_string() -> String:
    return config.http_log_format.response \
    .format({
        host = UniOperations.resolve_host(get_meta("host")),
        date = Time.get_datetime_string_from_system(),
        headers = self.headers,
        status = self.status,
        ttr = get_meta("ttr", "?")
       })
