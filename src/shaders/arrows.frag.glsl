precision mediump float;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

varying vec2 v_center;
varying float v_size;
varying float v_speed;


uniform sampler2D u_color_ramp;
uniform vec4 u_halo_color;

float polygon(vec3 st, int N) {
    float a = atan(st.x, st.y) + PI;
  	float r = TWO_PI / float(N);

    float d = cos(floor(0.5 + a / r) * r - a) * length(st.xy);
    return d;
}

mat3 scale(vec2 _scale){
    return mat3(1.0 / _scale.x, 0, 0,
                0, 1.0 / _scale.y, 0,
                0, 0, 1);
}

mat3 translate(vec2 _translate) {
    return mat3(1, 0, _translate.x,
                0, 1, _translate.y,
                0, 0, 1);
}

float arrow(vec3 st, float len) {
    return min(
        polygon(st* scale(vec2(0.3)), 3),
        polygon(st* translate(vec2(-0.00, len / 2.0)) * scale(vec2(0.2, len)), 4)
    );
}

void main() {
    vec3 st = vec3(v_center, 1);
    float size = mix(0.25, 4.0, v_size);
    float d = arrow(st * translate(vec2(0, -size / 2.0)), size);

    float inside = 1.0 - smoothstep(0.4, 0.405, d);
    float halo = (1.0 - smoothstep(0.43, 0.435, d)) - inside;
    vec2 ramp_pos = vec2(
        fract(16.0 * v_speed),
        floor(16.0 * v_speed) / 16.0);

    vec4 color = texture2D(u_color_ramp, ramp_pos);
    gl_FragColor = color * inside + halo * u_halo_color;
}
