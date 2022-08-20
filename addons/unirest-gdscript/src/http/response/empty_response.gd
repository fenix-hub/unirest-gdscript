extends Reference
class_name EmptyResponse

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
    return Unirest.config().http_log_format.response \
    .format({
        host = IP.get_local_addresses()[0],
        date = Time.get_datetime_string_from_system(),
        headers = self.headers,
        status = self.status,
        ttr = get_meta("ttr", "?")
       })
