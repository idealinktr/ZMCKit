#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler baseTexSmpSC 2:2
//sampler sampler prevTexSmpSC 2:3
//texture texture2D baseTex 2:0:2:2
//texture texture2D prevTex 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
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
#ifndef prevTexHasSwappedViews
#define prevTexHasSwappedViews 0
#elif prevTexHasSwappedViews==1
#undef prevTexHasSwappedViews
#define prevTexHasSwappedViews 1
#endif
#ifndef prevTexLayout
#define prevTexLayout 0
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
#ifndef SC_USE_UV_TRANSFORM_prevTex
#define SC_USE_UV_TRANSFORM_prevTex 0
#elif SC_USE_UV_TRANSFORM_prevTex==1
#undef SC_USE_UV_TRANSFORM_prevTex
#define SC_USE_UV_TRANSFORM_prevTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_prevTex
#define SC_SOFTWARE_WRAP_MODE_U_prevTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_prevTex
#define SC_SOFTWARE_WRAP_MODE_V_prevTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 0
#elif SC_USE_UV_MIN_MAX_prevTex==1
#undef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 0
#elif SC_USE_CLAMP_TO_BORDER_prevTex==1
#undef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 1
#endif
uniform vec4 baseTexDims;
uniform vec4 prevTexDims;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform mat3 prevTexTransform;
uniform vec4 prevTexUvMinMax;
uniform vec4 prevTexBorderColor;
uniform float isFirstFrame;
uniform mediump sampler2D baseTex;
uniform mediump sampler2D prevTex;
void main()
{
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_0,vec2(0.5),(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
float l9_2=l9_1.x;
int l9_3;
#if (prevTexHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
vec4 l9_4=sc_SampleTextureBiasOrLevel(prevTexDims.xy,prevTexLayout,l9_3,vec2(0.5),(int(SC_USE_UV_TRANSFORM_prevTex)!=0),prevTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_prevTex,SC_SOFTWARE_WRAP_MODE_V_prevTex),(int(SC_USE_UV_MIN_MAX_prevTex)!=0),prevTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_prevTex)!=0),prevTexBorderColor,0.0,prevTex);
float l9_5=l9_4.x;
sc_writeFragData0(vec4(mix(max(mix(max(l9_2,l9_5),min(l9_2,l9_5),0.050000001),l9_2),l9_2,isFirstFrame),0.0,0.0,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
