precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 c = texture2D(tex, v_texcoord);

    float avg = (c.r + c.g + c.b) / 3.0;
    float sat = 0.35;   // cambia intensidad aquí

    c.r = mix(avg, c.r, 1.0 + sat);
    c.g = mix(avg, c.g, 1.0 + sat);
    c.b = mix(avg, c.b, 1.0 + sat);

    gl_FragColor = c;
}

