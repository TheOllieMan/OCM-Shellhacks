shader_type canvas_item;

render_mode unshaded, blend_add;

uniform vec4 glow_color : source_color =
	vec4(0.25, 0.75, 1.0, 1.0);

uniform float core_size : hint_range(0.05, 0.8) = 0.22;

uniform float glow_falloff : hint_range(0.5, 5.0) = 2.0;

uniform float pulse_speed : hint_range(0.0, 10.0) = 1.5;

uniform float pulse_frequency : hint_range(1.0, 10.0) = 3.0;

uniform float minimum_brightness :
	hint_range(0.0, 1.0) = 0.25;

varying float light_energy;

void vertex()
{
	float path_progress = INSTANCE_CUSTOM.x;

	float wave =
		0.5 +
		0.5 *
		sin(
			path_progress * pulse_frequency * TAU
			-
			TIME * pulse_speed
		);

	light_energy =
		mix(
			minimum_brightness,
			1.0,
			wave
		);
}

void fragment()
{
	vec2 centered_uv =
		(UV - vec2(0.5)) * 2.0;

	float distance_from_center =
		length(centered_uv);

	float halo =
		1.0 -
		smoothstep(
			0.0,
			1.0,
			distance_from_center
		);

	halo = pow(
		halo,
		glow_falloff
	);

	float core =
		1.0 -
		smoothstep(
			0.0,
			core_size,
			distance_from_center
		);

	float brightness =
		(
			halo * 0.7
			+
			core
		)
		*
		light_energy;

	COLOR =
		vec4(
			glow_color.rgb * brightness,
			halo * glow_color.a
		);
}