shader_type canvas_item;

uniform vec3 bg_color: source_color = vec3(1);

void fragment() {
	vec4 t = texture(TEXTURE, UV);
	vec3 current_pixel = vec3(t.r, t.g, t.b);
	if (bg_color == current_pixel) {
		COLOR = vec4(0,0,0,0);
	}
}
