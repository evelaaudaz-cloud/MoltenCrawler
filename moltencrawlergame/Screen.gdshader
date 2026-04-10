shader_type canvas_item;

// Captura lo que hay detrás (el juego)
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// --- PARÁMETROS AJUSTABLES ---
// Juega con estos números en el inspector
uniform float scanline_count : hint_range(0, 1200) = 150.0; // Cantidad de líneas
uniform float scanline_opacity : hint_range(0, 1) = 0.3; // Oscuridad de las líneas
uniform float warp_amount : hint_range(0, 5) = 0.2; // Curvatura de pantalla vieja (Ojo de pez)
uniform float vignette_amount : hint_range(0, 2) = 0.5; // Oscuridad en las esquinas
uniform float aberration_amount : hint_range(0, 10) = 0.5; // Separación de colores (Glitch)
uniform bool noise_enabled = true; // Ruido de estática
uniform float noise_strength : hint_range(0, 1) = 0.05;

// Función para curvar las coordenadas UV
vec2 curve(vec2 uv) {
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	float delta_offset = delta4 * warp_amount;
	return uv + delta * delta_offset;
}

// Función para generar ruido aleatorio
float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// 1. Aplicamos la curvatura (Fish eye)
	vec2 uv = curve(SCREEN_UV);

	// Si la curvatura se sale de la pantalla, pintamos negro (bordes del monitor)
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		// 2. Aberración Cromática (Separar RGB)
		// Movemos el canal Rojo un poco a la izquierda y el Azul a la derecha
		float r = texture(screen_texture, uv + vec2(aberration_amount * 0.005, 0.0)).r;
		float g = texture(screen_texture, uv).g;
		float b = texture(screen_texture, uv - vec2(aberration_amount * 0.005, 0.0)).b;

		vec3 color = vec3(r, g, b);

		// 3. Scanlines (Líneas horizontales)
		float scanline = sin(uv.y * scanline_count * 3.14159 * 2.0);
		// Hacemos que las líneas oscuras no sean negro total, sino que bajen el brillo
		color -= scanline * scanline_opacity * 0.5;

		// 4. Viñeta (Esquinas oscuras)
		float dist = distance(uv, vec2(0.5));
		color *= (1.0 - dist * vignette_amount);

		// 5. Ruido (Estática suave)
		if (noise_enabled) {
			float noise = random(uv + vec2(TIME * 10.0, TIME * 50.0));
			color += (noise - 0.5) * noise_strength;
		}

		COLOR = vec4(color, 1.0);
	}
}//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
