shader_type spatial;

uniform bool highlight = false;
uniform vec4 highlight_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    ALBEDO = highlight ? highlight_color.rgb : ALBEDO;
    ALPHA = highlight ? highlight_color.a : ALPHA;
}
