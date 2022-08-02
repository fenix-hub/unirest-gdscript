# unirest-gdscript
Unirest in GDScript: Simplified, lightweight HTTP client library. Godot Engine HTTPClient extension based on Kong Unirest.

### sync example
```gdscript
func _ready() -> void:
    var unirest_request: UnirestRequest = \
        Unirest.get("https://jsonplaceholder.typicode.com/posts/{id}") \
        .header("Accept", "application/json") \
        .route_param("id", "1")
	var json_response: JsonResponse = yield(
		unirest_request.as_json(),
		"completed"
	)
	var json_node: JsonNode = json_response.get_body()
	print(json_node.as_dict().get("title")
```

### async example
```gdscript
    var unirest_request: UnirestRequest = \
        Unirest.get("https://jsonplaceholder.typicode.com/posts/{id}") \
        .header("Accept", "application/json") \
        .route_param("id", "1")
	unirest_request.connect("completed", self, "on_completed")
	unirest_request.as_json_async()

func on_completed(json_response: JsonResponse) -> void:
    var json_node: JsonNode = json_response.get_body()
    print(json_node.as_dict().get("title")
```
