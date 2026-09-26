shader_type canvas_item;

render_mode unshaded, blend_add;


uniform vec4 glow_color : source_color =
	vec4(213, 176, 34, 1.0);

uniform float falloff :
	hint_range(0.5, 6.0) = 2.4;


void fragment()
{
	vec2 centered_uv =
		(UV - vec2(0.5)) * 2.0;

	float distance_from_center =
		length(centered_uv);

	float glow =
		clamp(
			1.0 - distance_from_center,
			0.0,
			1.0
		);

	glow = pow(
		glow,
		falloff
	);

	float core =
		1.0 -
		smoothstep(
			0.0,
			0.18,
			distance_from_center
		);

	float brightness =
		glow * 0.75
		+
		core * 0.15;

	float alpha =
		glow * glow_color.a;

	COLOR =
		vec4(
			glow_color.rgb * brightness,
			alpha
		);
}