#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler baseTexSmpSC 2:1
//texture texture2D baseTex 2:0:2:1
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 baseTexSize;
varying vec2 varTex[9];
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=(l9_0.position.xy*0.5)+vec2(0.5);
varTex[0]=l9_1;
varTex[1]=l9_1+vec2(0.0,baseTexSize.w);
varTex[2]=l9_1+vec2(baseTexSize.z,baseTexSize.w);
varTex[3]=l9_1+vec2(baseTexSize.z,0.0);
float l9_2=-baseTexSize.z;
varTex[4]=l9_1+vec2(l9_2,baseTexSize.w);
varTex[5]=l9_1+vec2(l9_2,0.0);
float l9_3=-baseTexSize.w;
varTex[6]=l9_1+vec2(l9_2,l9_3);
varTex[7]=l9_1+vec2(0.0,l9_3);
varTex[8]=l9_1+vec2(baseTexSize.z,l9_3);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 0
#elif SC_USE_UV_TRANSFORM_baseTex==1
#undef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
uniform vec4 baseTexDims;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform mediump sampler2D baseTex;
varying vec2 varTex[9];
void main()
{
float l9_0;
float l9_1;
l9_1=0.0;
l9_0=0.0;
float l9_2;
float l9_3;
int l9_4=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_4<9)
{
int l9_5;
#if (baseTexHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
l9_2=l9_0+step(0.89999998,dot(sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_5,varTex[l9_4],(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex).xyz,vec3(0.29899999,0.58700001,0.114)));
l9_3=float(l9_4);
l9_1=l9_3;
l9_0=l9_2;
l9_4++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(vec4(l9_0/l9_1,0.0,0.0,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
