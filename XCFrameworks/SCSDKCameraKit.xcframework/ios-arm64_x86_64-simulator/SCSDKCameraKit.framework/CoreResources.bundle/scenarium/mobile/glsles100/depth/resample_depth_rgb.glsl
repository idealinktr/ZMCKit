#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler depthTextureSmpSC 2:2
//sampler sampler mainTextureSmpSC 2:3
//texture texture2D depthTexture 2:0:2:2
//texture texture2D mainTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
#endif
#ifndef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 0
#elif depthTextureHasSwappedViews==1
#undef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 1
#endif
#ifndef depthTextureLayout
#define depthTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_mainTexture
#define SC_USE_UV_TRANSFORM_mainTexture 0
#elif SC_USE_UV_TRANSFORM_mainTexture==1
#undef SC_USE_UV_TRANSFORM_mainTexture
#define SC_USE_UV_TRANSFORM_mainTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_mainTexture
#define SC_SOFTWARE_WRAP_MODE_U_mainTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_mainTexture
#define SC_SOFTWARE_WRAP_MODE_V_mainTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_mainTexture
#define SC_USE_UV_MIN_MAX_mainTexture 0
#elif SC_USE_UV_MIN_MAX_mainTexture==1
#undef SC_USE_UV_MIN_MAX_mainTexture
#define SC_USE_UV_MIN_MAX_mainTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_mainTexture
#define SC_USE_CLAMP_TO_BORDER_mainTexture 0
#elif SC_USE_CLAMP_TO_BORDER_mainTexture==1
#undef SC_USE_CLAMP_TO_BORDER_mainTexture
#define SC_USE_CLAMP_TO_BORDER_mainTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_depthTexture
#define SC_USE_UV_TRANSFORM_depthTexture 0
#elif SC_USE_UV_TRANSFORM_depthTexture==1
#undef SC_USE_UV_TRANSFORM_depthTexture
#define SC_USE_UV_TRANSFORM_depthTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_depthTexture
#define SC_SOFTWARE_WRAP_MODE_U_depthTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_depthTexture
#define SC_SOFTWARE_WRAP_MODE_V_depthTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_depthTexture
#define SC_USE_UV_MIN_MAX_depthTexture 0
#elif SC_USE_UV_MIN_MAX_depthTexture==1
#undef SC_USE_UV_MIN_MAX_depthTexture
#define SC_USE_UV_MIN_MAX_depthTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_depthTexture
#define SC_USE_CLAMP_TO_BORDER_depthTexture 0
#elif SC_USE_CLAMP_TO_BORDER_depthTexture==1
#undef SC_USE_CLAMP_TO_BORDER_depthTexture
#define SC_USE_CLAMP_TO_BORDER_depthTexture 1
#endif
#ifndef CAMEOS_MATTING
#define CAMEOS_MATTING 0
#elif CAMEOS_MATTING==1
#undef CAMEOS_MATTING
#define CAMEOS_MATTING 1
#endif
#ifndef BY_Y
#define BY_Y 0
#elif BY_Y==1
#undef BY_Y
#define BY_Y 1
#endif
#ifndef RY_GY
#define RY_GY 0
#elif RY_GY==1
#undef RY_GY
#define RY_GY 1
#endif
uniform vec4 mainTextureDims;
uniform vec4 depthTextureDims;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mat3 depthTextureTransform;
uniform vec4 depthTextureUvMinMax;
uniform vec4 depthTextureBorderColor;
uniform float depthToDisparityNumerator;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2D depthTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (mainTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_2;
#if (depthTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(depthTextureDims.xy,depthTextureLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_depthTexture)!=0),depthTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture),(int(SC_USE_UV_MIN_MAX_depthTexture)!=0),depthTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0),depthTextureBorderColor,0.0,depthTexture);
float l9_4=l9_3.x;
float l9_5;
#if (CAMEOS_MATTING)
{
l9_5=clamp(l9_4,0.0,0.99998999);
}
#else
{
l9_5=clamp(depthToDisparityNumerator/(l9_4+9.9999997e-06),0.0,0.99998999);
}
#endif
vec4 l9_6;
#if (BY_Y)
{
vec2 l9_7=fract(vec2(1.0,255.0)*(l9_1.z*l9_5));
float l9_8=l9_7.y;
vec2 l9_9=fract(vec2(1.0,255.0)*l9_5);
float l9_10=l9_9.y;
l9_6=vec4(l9_7.x-(l9_8/255.0),l9_8,l9_9.x-(l9_10/255.0),l9_10);
}
#else
{
vec4 l9_11;
#if (RY_GY)
{
vec2 l9_12=fract(vec2(1.0,255.0)*(l9_1.x*l9_5));
float l9_13=l9_12.y;
vec2 l9_14=fract(vec2(1.0,255.0)*(l9_1.y*l9_5));
float l9_15=l9_14.y;
l9_11=vec4(l9_12.x-(l9_13/255.0),l9_13,l9_14.x-(l9_15/255.0),l9_15);
}
#else
{
l9_11=vec4(1.0,0.0,1.0,1.0);
}
#endif
l9_6=l9_11;
}
#endif
sc_writeFragData0(l9_6);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
