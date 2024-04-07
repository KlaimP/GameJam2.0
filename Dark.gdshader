shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D noise2 : repeat_enable;

uniform sampler2D colorTexture : repeat_enable;
uniform vec2 scroll= vec2(0.1,0.1);
uniform vec2 scroll2= vec2(0.2,0.2);

void fragment() {
	float energy = texture(noise,  UV + scroll * TIME).r * texture(noise2, UV + scroll2 * TIME).r ;
	vec4 color = texture(colorTexture, vec2(energy));
	color.a *= sqrt(pow(UV.x-0.5, 2) + pow(UV.y-0.5, 2)) *PI * 0.45;
	color.a = 1.0/color.a-2.0;
	COLOR = color;

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
