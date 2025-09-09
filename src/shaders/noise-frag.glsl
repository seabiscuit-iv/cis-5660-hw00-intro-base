#version 300 es


precision highp float;

uniform vec4 u_Color;
uniform float u_Ticks;

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec3 fs_Pos;

out vec4 out_Col;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}


void main()
{
        float attenuation = noise(fs_Pos + vec3(u_Ticks * 0.005));
        vec4 diffuseColor = u_Color * clamp(attenuation, 0.0, 1.0) + (vec4((vec3(1.0) - u_Color.xyz), 1.0) * clamp(1.0 - attenuation, 0.0, 1.0));


        // Compute final shaded color
        out_Col = vec4(diffuseColor.rgb, diffuseColor.a);
}
