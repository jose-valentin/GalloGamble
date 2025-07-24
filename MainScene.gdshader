shader_type canvas_item;

uniform int steps : hint_range(1, 100) = 20;

void fragment() {
    // Center of the rectangle is (0.5, 0.5) in UV space
    vec2 center = vec2(0.5, -0.2);

    // Distance from current pixel to center
    float dist = distance(UV, center);

    // Quantize distance to get pixelated gradient rings
    float quant_dist = floor(dist * float(steps)) / float(steps);

    // Gradient from light in center to dark at edges
    vec4 center_color = vec4(1.0, 0.6, 0.2, 1.0);   // Light orange
    vec4 edge_color = vec4(0.8, 0.3, 0.0, 1.0);     // Dark orange

    COLOR = mix(center_color, edge_color, quant_dist);
}





//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
