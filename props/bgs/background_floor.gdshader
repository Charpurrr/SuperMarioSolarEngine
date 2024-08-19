shader_type canvas_item;

uniform float rollRotation; // Rotation in Radians (0 to 1)
uniform float scale; //Scale of image
uniform vec3 mapPosition;  // Position of the camera within 2D/3D space

void fragment()
{
	// Calculate roll rotation matrix
	mat3 rollMatrix = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos(rollRotation), -sin(rollRotation)),
		vec3(0.0, sin(rollRotation), cos(rollRotation))
	);
	
	mat3 heightMatrix = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, 0.0, exp(mapPosition.y)),
		vec3(0.0, 1.0, 0.0)
	);
	
	mat3 scaleMatrix = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, 1.0, 0.0),
		vec3(0.0, 0.0, scale)
	);
	
	mat3 translationMatrix = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, 1.0, 0.0),
		vec3(mapPosition.x, mapPosition.z, 1.0)
	);
	
	mat3 finalMatrix = translationMatrix * scaleMatrix * rollMatrix * heightMatrix;
	
	vec3 uv = finalMatrix * vec3(UV - 0.5, 1.0);
	if (uv.z < 0.0) discard;
	
	COLOR = texture(TEXTURE, uv.xy / uv.z + mapPosition.xz);
}
