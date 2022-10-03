# unirest-gdscript (4.x)
Unirest in GDScript: Simplified, lightweight HTTP client library. Godot Engine HTTPClient extension inspired by Kong Unirest.

👉 [3.x](https://github.com/fenix-hub/unirest-gdscript)

### sync example
```gdscript
func _ready() -> void:
	var json_response: JsonResponse = await Unirest.Get("https://jsonplaceholder.typicode.com/posts/{id}")  
	.header("Accept", "application/json") \
	.route_param("id", "1")
	.as_json()
	
	var json_node: JsonNode = json_response.get_body()
	print(json_node.as_dict().get("title"))
```

### async example
```gdscript
func _ready() -> void:
	Unirest.get("https://jsonplaceholder.typicode.com/posts/{id}") 
	.header("Accept", "application/json") 
	.route_param("id", "1")
	.as_json_async(
		func(json_response: JsonResponse):
			response.get_body().as_dict().get("title")
	)
```
