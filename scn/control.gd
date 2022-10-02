extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Unirest.Get("https://httpbin.org/get").as_empty()
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
