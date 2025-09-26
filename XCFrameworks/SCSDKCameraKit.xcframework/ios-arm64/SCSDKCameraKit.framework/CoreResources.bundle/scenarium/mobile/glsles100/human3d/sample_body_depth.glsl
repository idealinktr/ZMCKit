#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler confidenceTextureSmpSC 2:2
//sampler sampler cropTextureSmpSC 2:3
//texture texture2D confidenceTexture 2:0:2:2
//texture texture2D cropTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs_without_output.glsl>
#include <std2_fs_depth_output.glsl>
#include <std2_texture.glsl>
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs_without_output.glsl>
#include <std2_fs_depth_output.glsl>
#include <std2_texture.glsl>
#ifndef cropTextureHasSwappedViews
#define cropTextureHasSwappedViews 0
#elif cropTextureHasSwappedViews==1
#undef cropTextureHasSwappedViews
#define cropTextureHasSwappedViews 1
#endif
#ifndef cropTextureLayout
#define cropTextureLayout 0
#endif
#ifndef confidenceTextureHasSwappedViews
#define confidenceTextureHasSwappedViews 0
#elif confidenceTextureHasSwappedViews==1
#undef confidenceTextureHasSwappedViews
#define confidenceTextureHasSwappedViews 1
#endif
#ifndef confidenceTextureLayout
#define confidenceTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_confidenceTexture
#define SC_USE_UV_TRANSFORM_confidenceTexture 0
#elif SC_USE_UV_TRANSFORM_confidenceTexture==1
#undef SC_USE_UV_TRANSFORM_confidenceTexture
#define SC_USE_UV_TRANSFORM_confidenceTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_confidenceTexture
#define SC_SOFTWARE_WRAP_MODE_U_confidenceTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_confidenceTexture
#define SC_SOFTWARE_WRAP_MODE_V_confidenceTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_confidenceTexture
#define SC_USE_UV_MIN_MAX_confidenceTexture 0
#elif SC_USE_UV_MIN_MAX_confidenceTexture==1
#undef SC_USE_UV_MIN_MAX_confidenceTexture
#define SC_USE_UV_MIN_MAX_confidenceTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_confidenceTexture
#define SC_USE_CLAMP_TO_BORDER_confidenceTexture 0
#elif SC_USE_CLAMP_TO_BORDER_confidenceTexture==1
#undef SC_USE_CLAMP_TO_BORDER_confidenceTexture
#define SC_USE_CLAMP_TO_BORDER_confidenceTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_cropTexture
#define SC_USE_UV_TRANSFORM_cropTexture 0
#elif SC_USE_UV_TRANSFORM_cropTexture==1
#undef SC_USE_UV_TRANSFORM_cropTexture
#define SC_USE_UV_TRANSFORM_cropTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_cropTexture
#define SC_SOFTWARE_WRAP_MODE_U_cropTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_cropTexture
#define SC_SOFTWARE_WRAP_MODE_V_cropTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_cropTexture
#define SC_USE_UV_MIN_MAX_cropTexture 0
#elif SC_USE_UV_MIN_MAX_cropTexture==1
#undef SC_USE_UV_MIN_MAX_cropTexture
#define SC_USE_UV_MIN_MAX_cropTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_cropTexture
#define SC_USE_CLAMP_TO_BORDER_cropTexture 0
#elif SC_USE_CLAMP_TO_BORDER_cropTexture==1
#undef SC_USE_CLAMP_TO_BORDER_cropTexture
#define SC_USE_CLAMP_TO_BORDER_cropTexture 1
#endif
uniform vec4 cropTextureDims;
uniform vec4 confidenceTextureDims;
uniform mat3 screenToCropTransform;
uniform mat3 confidenceTextureTransform;
uniform vec4 confidenceTextureUvMinMax;
uniform vec4 confidenceTextureBorderColor;
uniform float minimumConfidence;
uniform mat3 cropTextureTransform;
uniform vec4 cropTextureUvMinMax;
uniform vec4 cropTextureBorderColor;
uniform vec4 depthProjectionMatrixTerms;
uniform mediump sampler2D confidenceTexture;
uniform mediump sampler2D cropTexture;
void main()
{
sc_DiscardStereoFragment();
vec3 l9_0=screenToCropTransform*vec3(varPackedTex.xy,1.0);
float l9_1=l9_0.x;
float l9_2=l9_0.y;
vec2 l9_3=vec2(l9_1,l9_2);
bool l9_4=0.0<=l9_1;
bool l9_5;
if (l9_4)
{
l9_5=l9_1<=1.0;
}
else
{
l9_5=l9_4;
}
bool l9_6;
if (l9_5)
{
l9_6=0.0<=l9_2;
}
else
{
l9_6=l9_5;
}
bool l9_7;
if (l9_6)
{
l9_7=l9_2<=1.0;
}
else
{
l9_7=l9_6;
}
float l9_8;
if (l9_7)
{
int l9_9;
#if (confidenceTextureHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
float l9_10;
if (sc_SampleTextureBiasOrLevel(confidenceTextureDims.xy,confidenceTextureLayout,l9_9,l9_3,(int(SC_USE_UV_TRANSFORM_confidenceTexture)!=0),confidenceTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_confidenceTexture,SC_SOFTWARE_WRAP_MODE_V_confidenceTexture),(int(SC_USE_UV_MIN_MAX_confidenceTexture)!=0),confidenceTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_confidenceTexture)!=0),confidenceTextureBorderColor,0.0,confidenceTexture).x>=minimumConfidence)
{
int l9_11;
#if (cropTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
l9_10=depthViewToScreenSpace(sc_SampleTextureBiasOrLevel(cropTextureDims.xy,cropTextureLayout,l9_11,l9_3,(int(SC_USE_UV_TRANSFORM_cropTexture)!=0),cropTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_cropTexture,SC_SOFTWARE_WRAP_MODE_V_cropTexture),(int(SC_USE_UV_MIN_MAX_cropTexture)!=0),cropTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_cropTexture)!=0),cropTextureBorderColor,0.0,cropTexture).x,depthProjectionMatrixTerms);
}
else
{
l9_10=1.0;
}
l9_8=l9_10;
}
else
{
l9_8=1.0;
}
sc_writeFragDepth(l9_8);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
