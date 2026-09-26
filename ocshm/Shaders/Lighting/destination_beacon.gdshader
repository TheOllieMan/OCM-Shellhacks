shader_type canvas_item;

render_mode unshaded, blend_add;

uniform vec4 beacon_color : source_color =
	vec4(0.3, 0.8, 1.0, 1.0);

uniform float breathe_speed :
	hint_range(0.0, 5.0) = 1.8;

void fragment()
{
	vec2 centered_uv =
		(UV - vec2(0.5)) * 2.0;

	float dist = length(centered_uv);

	// Soft glow that fully disappears before reaching the quad edge.
	float halo =
		1.0 -
		smoothstep(
			0.15,
			0.95,
			dist
		);

	// Small bright center.
	float core =
		1.0 -
		smoothstep(
			0.0,
			0.20,
			dist
		);

	float breathe =
		0.80 +
		0.20 *
		sin(TIME * breathe_speed);

	float brightness =
		(
			halo * 0.6 +
			core * 1.25
		)
		*
		breathe;

	float alpha =
		halo * beacon_color.a;

	COLOR = vec4(
		beacon_color.rgb * brightness,
		alpha
	);
}