shader_type canvas_item;

render_mode unshaded, blend_add;

uniform vec4 glow_color : source_color =
	vec4(0.25, 0.75, 1.0, 1.0);

uniform float core_size : hint_range(0.05, 0.8) = 0.22;

uniform float glow_falloff : hint_range(0.5, 5.0) = 2.0;

uniform float pulse_speed : hint_range(0.0, 10.0) = 0.35;

uniform float pulse_width : hint_range(0.01, 0.5) = 0.13;


uniform float minimum_brightness :
	hint_range(0.0, 1.0) = 0.20;

varying float light_energy;

void vertex()
{
	float path_progress = INSTANCE_CUSTOM.x;

	// Moves from 0 -> 1 repeatedly.
	float pulse_position =
		fract(TIME * pulse_speed);

	// Distance of this light from the moving pulse.
	float distance_to_pulse =
		abs(path_progress - pulse_position);

	// Makes the transition smooth.
	float pulse =
		1.0 -
		smoothstep(
			0.0,
			pulse_width,
			distance_to_pulse
		);

	light_energy =
		mix(
			minimum_brightness,
			1.0,
			pulse
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