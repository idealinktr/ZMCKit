#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec3 uniMainTextureSize;
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec3 uniMainTextureSize;
void main()
{
sc_DiscardStereoFragment();
vec2 l9_0=varPackedTex.xy*uniMainTextureSize.xy;
vec2 l9_1=dFdx(l9_0);
vec2 l9_2=dFdy(l9_0);
float l9_3=(0.5*log2(max(dot(l9_1,l9_1),dot(l9_2,l9_2))))-0.5;
bool l9_4;
if (uniMainTextureSize.z==1.0)
{
l9_4=l9_3<0.0;
}
else
{
l9_4=l9_3<0.1;
}
vec4 l9_5;
if (l9_4)
{
l9_5=vec4(0.0,1.0,0.0,1.0);
}
else
{
l9_5=vec4(1.0,0.0,0.0,1.0);
}
sc_writeFragData0(l9_5);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
