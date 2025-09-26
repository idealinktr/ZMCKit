#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler depthTextureSmpSC 2:1
//texture texture2D depthTexture 2:0:2:1
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
#ifndef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 0
#elif depthTextureHasSwappedViews==1
#undef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 1
#endif
#ifndef depthTextureLayout
#define depthTextureLayout 0
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
#ifndef PACKED_DISPARITY
#define PACKED_DISPARITY 0
#elif PACKED_DISPARITY==1
#undef PACKED_DISPARITY
#define PACKED_DISPARITY 1
#endif
uniform vec4 depthTextureDims;
uniform mat3 depthTextureTransform;
uniform vec4 depthTextureUvMinMax;
uniform vec4 depthTextureBorderColor;
uniform float depthToDisparityNumerator;
uniform float depthScale;
uniform float defaultDepth;
uniform mediump sampler2D depthTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (depthTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(depthTextureDims.xy,depthTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_depthTexture)!=0),depthTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture),(int(SC_USE_UV_MIN_MAX_depthTexture)!=0),depthTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0),depthTextureBorderColor,0.0,depthTexture);
float l9_2;
#if (PACKED_DISPARITY)
{
l9_2=(depthToDisparityNumerator/(dot(l9_1.xy,vec2(1.0,0.0039215689))+9.9999997e-06))*depthScale;
}
#else
{
l9_2=l9_1.x*depthScale;
}
#endif
bool l9_3=isinf(l9_2);
bool l9_4=!l9_3;
bool l9_5;
if (l9_4)
{
l9_5=!isnan(l9_2);
}
else
{
l9_5=l9_4;
}
float l9_6;
if (l9_5)
{
vec4 l9_7=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(0.0,0.0,-l9_2,1.0);
l9_6=((0.5*l9_7.z)/l9_7.w)+0.5;
}
else
{
l9_6=defaultDepth;
}
sc_writeFragDepth(l9_6);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
