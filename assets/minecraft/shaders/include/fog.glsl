#version 150





// --------------------CONFIG--------------------
// For each of these, a value of 1.0 gives
// vanilla behavior. Always include the decimal
// point or the shader won't compile!

// Distance where fog starts to appear, relative
// to the player's render distance
float fogStartMultiplier = 0.1;

// Distance where objects are completely in fog,
// also relative to the player's render distance
float fogEndMultiplier = 1.0;

// Factor affects the curve of the fog density
// per distance, smaller value = less fog near,
// larger value = more fog near.
float fogCurveFactor = 0.9;

// ---------------------------------------------







float linear_fog_fade(float vertexDistance, float fogStart, float fogEnd) {
    fogStart *= fogStartMultiplier;
    fogEnd *= fogEndMultiplier;
    if (vertexDistance <= fogStart) {
        return 1.0;
    } else if (vertexDistance >= fogEnd) {
        return 0.0;
    }

    return pow(smoothstep(fogEnd, fogStart, vertexDistance), max(0.0, fogCurveFactor));
}

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    return vec4(mix(inColor.rgb, fogColor.rgb, (1.0 - linear_fog_fade(vertexDistance, fogStart, fogEnd)) * fogColor.a), inColor.a);
}

float fog_distance(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {
        return length((modelViewMat * vec4(pos, 1.0)).xyz);
    } else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}
