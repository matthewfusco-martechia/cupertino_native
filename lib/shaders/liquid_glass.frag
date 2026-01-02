#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uIntensity;
uniform vec2 uPointer;
uniform float uWiggle; // 0.0 to 1.0 based on movement velocity

out vec4 fragColor;

// Better pseudo-random noise for the "frosted" grain
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 centeredUv = uv * 2.0 - 1.0;
    
    // 1. Refraction Warp (Thick Glass Effect)
    // Distort the UVs slightly towards the center to simulate magnification/glass thickness
    float distortion = 0.02 * uIntensity;
    vec2 distortedUv = uv + centeredUv * distortion * (1.0 - length(centeredUv));
    
    // 2. Frost Grain (Apple's Material noise)
    float grain = hash(uv * 250.0 + uTime * 0.05) * 0.04 * uIntensity;
    
    // 3. Iridescence (The Rainbow Border)
    // Based on the distance from center (fresnel-like effect)
    float d = length(centeredUv);
    float iridMask = smoothstep(0.7, 1.0, d);
    vec3 iridColor = vec3(
        sin(d * 10.0 - uTime * 0.5 + 0.0) * 0.5 + 0.5,
        sin(d * 10.0 - uTime * 0.5 + 2.0) * 0.5 + 0.5,
        sin(d * 10.0 - uTime * 0.5 + 4.0) * 0.5 + 0.5
    );
    vec3 edgeIrid = iridColor * iridMask * 0.15 * uIntensity;
    
    // 4. Specular Gloss (Dynamic Light)
    // Multiple light streaks for a more premium look
    float light1 = smoothstep(0.7, 0.95, sin(uv.x * 2.0 + uv.y * 1.5 - uTime * 1.2 + uPointer.x * 3.0));
    float light2 = smoothstep(0.85, 0.98, sin(uv.x * -1.5 + uv.y * 3.0 - uTime * 0.8));
    float specular = (light1 * 0.12 + light2 * 0.08) * uIntensity;
    
    // 5. Soft Inner Glow (Liquid Feel)
    float innerGlow = (1.0 - smoothstep(0.0, 0.5, d)) * 0.05 * uIntensity;
    
    // Composition
    vec3 baseColor = vec3(0.95, 0.97, 1.0); // Clean white/blue tint
    float alpha = 0.03 + specular + innerGlow; // Base alpha is very low since BackdropFilter handles transparency
    
    vec3 finalColor = baseColor + edgeIrid + vec3(grain) + vec3(specular);
    
    // Apply uWiggle to add some chromatic splitting during movement
    if (uWiggle > 0.01) {
        finalColor.r += uWiggle * 0.05;
        finalColor.b -= uWiggle * 0.05;
    }

    fragColor = vec4(finalColor * alpha, alpha);
}
