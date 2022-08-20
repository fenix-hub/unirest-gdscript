extends Resource
class_name HttpLogFormat

export (String) var request: String = '[{date}] - {host} >> "{method} {URI} {protocol}" {bytes} "{agent}"'
export (String) var response: String = '[{date}] - {host} << "{protocol} {status} {message}" {headers} {body} ({ttr}ms)'

func _init(request: String, response: String) -> void:
    self.request = request
    self.response = response
