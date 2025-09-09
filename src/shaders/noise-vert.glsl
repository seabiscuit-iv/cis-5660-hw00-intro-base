#version 300 es

uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;
uniform mat4 u_ViewProj;
uniform float u_Ticks;

in vec4 vs_Pos;

in vec4 vs_Nor;

in vec4 vs_Col;

out vec4 fs_Nor;
out vec4 fs_LightVec;
out vec4 fs_Col;
out vec3 fs_Pos;

const vec4 lightPos = vec4(5, 5, 3, 1);

float heartbeat(float t) {
    // t = time in seconds
    float period = 1.0; // seconds per beat cycle
    float phase = mod(t, period); // 0 → 1 each cycle

    // First pulse: main “lub”
    float pulse1 = pow(sin(clamp(phase * 3.1415 * 2.0, 0.0, 3.1415)), 2.0);

    // Second pulse: “dub”, closer to the first pulse
    float pulse2 = pow(sin(clamp((phase - 0.32) * 3.1415 * 2.0, 0.0, 3.1415)), 2.0);

    // Baseline scale (never goes below 0.95)
    float baseline = 0.95;

    // Combine baseline + pulses
    return baseline + 0.05 * (pulse1 + pulse2); // 0.95 → ~1.05
}

void main()
{
    fs_Col = vs_Col;

    mat3 invTranspose = mat3(u_ModelInvTr);
    fs_Nor = vec4(invTranspose * vec3(vs_Nor), 0);

    vec4 pos = vs_Pos;

    pos.y += abs(pos.x);
    pos.z += abs(pos.x);

    pos *= heartbeat(u_Ticks * 0.005);

    pos.w = 1.0;

    vec4 modelposition = u_Model * pos;
    
    fs_LightVec = lightPos - modelposition;
    
    gl_Position = u_ViewProj * modelposition;
    fs_Pos = pos.xyz;
}
