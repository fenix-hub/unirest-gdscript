extends RefCounted
class_name UnirestError

var cause: Dictionary
var message: String
var original_body: String

func _init(cause: Dictionary, message: String = "", original_body: String = "") -> void:
    self.cause = cause
    self.message = message
    self.original_body = original_body

func get_cause() -> Dictionary:
    return self.cause

func get_message() -> String:
    return self.message

func get_original_body() -> String:
    return self.original_body

func _to_string() -> String:
    return str({
        cause = cause,
        message = message,
        original_body = original_body
    })
