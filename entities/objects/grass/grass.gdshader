shader_type canvas_item;

uniform float strength : hint_range(0.0, 20.0) = 4.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float frequency : hint_range(0.0, 10.0) = 3.0;

void vertex() {
	float height_factor = UV.y;

	// pseudo-random offset per tile
	float offset = fract(sin(dot(VERTEX.xy ,vec2(12.9898,78.233))) * 43758.5453);

	float wave = sin(TIME * speed + offset * 6.28);

	VERTEX.x += wave * strength * (1.0 - height_factor);
}