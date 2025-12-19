shader_type canvas_item;
render_mode skip_vertex_transform, unshaded;

const vec2 target_resolution = vec2(220.0, 220.0);
const float colors_per_channel = 32.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

vec3 rgb2hsv(vec3 c) 
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() 
{
    vec2 uv = floor(SCREEN_UV * target_resolution) / target_resolution;
    vec3 color = texture(screen_texture, uv).rgb;
    vec3 hsv = rgb2hsv(color);
    hsv.x = round(hsv.x * colors_per_channel) / colors_per_channel;
    hsv.y = floor(hsv.y * colors_per_channel) / colors_per_channel;
    hsv.z = floor(hsv.z * colors_per_channel) / colors_per_channel;
    vec3 quantized_color = hsv2rgb(hsv);
    COLOR = vec4(quantized_color, 1.0);
}