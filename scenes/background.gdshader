shader_type canvas_item;

uniform float speed = .2;

void vertex() {
	UV.x += TIME * speed;
}
