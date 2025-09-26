#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler texAbSmpSC 2:2
//sampler sampler texMainSmpSC 2:3
//texture texture2D texAb 2:0:2:2
//texture texture2D texMain 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef texAbHasSwappedViews
#define texAbHasSwappedViews 0
#elif texAbHasSwappedViews==1
#undef texAbHasSwappedViews
#define texAbHasSwappedViews 1
#endif
#ifndef texAbLayout
#define texAbLayout 0
#endif
#ifndef texMainHasSwappedViews
#define texMainHasSwappedViews 0
#elif texMainHasSwappedViews==1
#undef texMainHasSwappedViews
#define texMainHasSwappedViews 1
#endif
#ifndef texMainLayout
#define texMainLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_texAb
#define SC_USE_UV_TRANSFORM_texAb 0
#elif SC_USE_UV_TRANSFORM_texAb==1
#undef SC_USE_UV_TRANSFORM_texAb
#define SC_USE_UV_TRANSFORM_texAb 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_texAb
#define SC_SOFTWARE_WRAP_MODE_U_texAb -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_texAb
#define SC_SOFTWARE_WRAP_MODE_V_texAb -1
#endif
#ifndef SC_USE_UV_MIN_MAX_texAb
#define SC_USE_UV_MIN_MAX_texAb 0
#elif SC_USE_UV_MIN_MAX_texAb==1
#undef SC_USE_UV_MIN_MAX_texAb
#define SC_USE_UV_MIN_MAX_texAb 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_texAb
#define SC_USE_CLAMP_TO_BORDER_texAb 0
#elif SC_USE_CLAMP_TO_BORDER_texAb==1
#undef SC_USE_CLAMP_TO_BORDER_texAb
#define SC_USE_CLAMP_TO_BORDER_texAb 1
#endif
#ifndef SC_USE_UV_TRANSFORM_texMain
#define SC_USE_UV_TRANSFORM_texMain 0
#elif SC_USE_UV_TRANSFORM_texMain==1
#undef SC_USE_UV_TRANSFORM_texMain
#define SC_USE_UV_TRANSFORM_texMain 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_texMain
#define SC_SOFTWARE_WRAP_MODE_U_texMain -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_texMain
#define SC_SOFTWARE_WRAP_MODE_V_texMain -1
#endif
#ifndef SC_USE_UV_MIN_MAX_texMain
#define SC_USE_UV_MIN_MAX_texMain 0
#elif SC_USE_UV_MIN_MAX_texMain==1
#undef SC_USE_UV_MIN_MAX_texMain
#define SC_USE_UV_MIN_MAX_texMain 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_texMain
#define SC_USE_CLAMP_TO_BORDER_texMain 0
#elif SC_USE_CLAMP_TO_BORDER_texMain==1
#undef SC_USE_CLAMP_TO_BORDER_texMain
#define SC_USE_CLAMP_TO_BORDER_texMain 1
#endif
#ifndef MASK_PROCESSING_MULTIPLICATION
#define MASK_PROCESSING_MULTIPLICATION 0
#elif MASK_PROCESSING_MULTIPLICATION==1
#undef MASK_PROCESSING_MULTIPLICATION
#define MASK_PROCESSING_MULTIPLICATION 1
#endif
#ifndef MASK_PROCESSING_SMOOTH_STEP
#define MASK_PROCESSING_SMOOTH_STEP 0
#elif MASK_PROCESSING_SMOOTH_STEP==1
#undef MASK_PROCESSING_SMOOTH_STEP
#define MASK_PROCESSING_SMOOTH_STEP 1
#endif
#ifndef MASK_PROCESSING_SCALE
#define MASK_PROCESSING_SCALE 0
#elif MASK_PROCESSING_SCALE==1
#undef MASK_PROCESSING_SCALE
#define MASK_PROCESSING_SCALE 1
#endif
uniform vec4 texAbDims;
uniform vec4 texMainDims;
uniform mat3 texAbTransform;
uniform vec4 texAbUvMinMax;
uniform vec4 texAbBorderColor;
uniform mat3 texMainTransform;
uniform vec4 texMainUvMinMax;
uniform vec4 texMainBorderColor;
uniform float epsilonSq;
uniform float maskSmoothStepMin;
uniform float maskSmoothStepMax;
uniform float maskScaleMultiplier;
uniform bool invertMask;
uniform mediump sampler2D texAb;
uniform mediump sampler2D texMain;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (texAbHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(texAbDims.xy,texAbLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_texAb)!=0),texAbTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_texAb,SC_SOFTWARE_WRAP_MODE_V_texAb),(int(SC_USE_UV_MIN_MAX_texAb)!=0),texAbUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texAb)!=0),texAbBorderColor,0.0,texAb);
int l9_2;
#if (texMainHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_texMain)!=0),texMainTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
vec2 l9_4=l9_1.zw-(l9_1.xx*l9_1.yx);
float l9_5=((l9_4.x/(l9_4.y+epsilonSq))*(dot(l9_3.xyz,vec3(0.21259999,0.71520001,0.0722))-l9_1.x))+l9_1.y;
float l9_6;
#if (MASK_PROCESSING_MULTIPLICATION)
{
l9_6=l9_5*l9_5;
}
#else
{
float l9_7;
#if (MASK_PROCESSING_SMOOTH_STEP)
{
l9_7=smoothstep(maskSmoothStepMin,maskSmoothStepMax,l9_5);
}
#else
{
float l9_8;
#if (MASK_PROCESSING_SCALE)
{
l9_8=l9_5*maskScaleMultiplier;
}
#else
{
l9_8=l9_5;
}
#endif
l9_7=l9_8;
}
#endif
l9_6=l9_7;
}
#endif
float l9_9;
if (invertMask)
{
l9_9=1.0-l9_6;
}
else
{
l9_9=l9_6;
}
sc_writeFragData0(vec4(l9_9,l9_9,l9_9,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
