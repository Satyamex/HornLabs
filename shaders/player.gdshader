shader_type spatial;
render_mode unshaded, depth_draw_never, cull_disabled;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D noise_tex;
uniform float strength = 0.01;
uniform float speed = 0.4;

void fragment() {
    vec2 uv = SCREEN_UV;

    vec2 noise_uv = UV + vec2(TIME * speed, TIME * speed);
    float noise = texture(noise_tex, noise_uv).r;

    uv.y += (noise - 0.5) * strength;

    ALBEDO = texture(SCREEN_TEXTURE, uv).rgb;
	float dist = distance(UV, vec2(0.5));
	float mask = smoothstep(0.5, 0.3, dist);
    ALPHA = 0.5*mask;
}
