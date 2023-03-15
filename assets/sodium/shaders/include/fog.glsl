





// --------------------CONFIG--------------------
// For each of these, a value of 1.0 gives
// vanilla behavior. Always include the decimal
// point or the shader won't compile!

// Unless you intent to use Sodium and
// sodium-shader-support, you can ignore or
// ignore this file

// ---------------------------------------------

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








const int FOG_SHAPE_SPHERICAL = 0;
const int FOG_SHAPE_CYLINDRICAL = 1;

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

vec4 _linearFog(vec4 fragColor, float fragDistance, vec4 fogColor, float fogStart, float fogEnd) {
    #ifdef USE_FOG
    return vec4(mix(fragColor.rgb, fogColor.rgb, (1.0 - linear_fog_fade(fragDistance, fogStart, fogEnd)) * fogColor.a), fragColor.a);
    #else
    return fragColor;
    #endif
}

float getFragDistance(int fogShape, vec3 position) {
    // Use the maximum of the horizontal and vertical distance to get cylindrical fog if fog shape is cylindrical
    switch (fogShape) {
        case FOG_SHAPE_SPHERICAL: return length(position);
        case FOG_SHAPE_CYLINDRICAL: return max(length(position.xz), abs(position.y));
        default: return length(position); // This shouldn't be possible to get, but return a sane value just in case
    }
}