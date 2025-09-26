#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform mat4 script_modelMatrix;
varying vec3 varCustomNormal;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=l9_0.texture0;
varCustomNormal=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
sc_ProcessVertex(sc_Vertex_t(vec4(((l9_1*1.002)*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_1,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef N_SPHERICAL_GAUSSIANS
#define N_SPHERICAL_GAUSSIANS 12
#endif
uniform vec3 sgAxis[N_SPHERICAL_GAUSSIANS];
uniform vec4 sgColorAndSharpness[N_SPHERICAL_GAUSSIANS];
uniform vec3 sgAmbientLight;
varying vec3 varCustomNormal;
void main()
{
vec3 l9_0;
l9_0=sgAmbientLight;
int l9_1=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1<N_SPHERICAL_GAUSSIANS)
{
l9_0+=(sgColorAndSharpness[l9_1].xyz*exp(sgColorAndSharpness[l9_1].w*(dot(sgAxis[l9_1],normalize(varCustomNormal))-1.0)));
l9_1++;
continue;
}
else
{
break;
}
}
float l9_2=max(1.0/max(1.0,max(l9_0.x,max(l9_0.y,l9_0.z))),0.0039607845);
sc_writeFragData0(vec4(l9_0*l9_2,l9_2));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
