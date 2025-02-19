#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler mainTextureSmpSC 2:2
//sampler sampler segmentationMaskSmpSC 2:3
//texture texture2D mainTexture 2:0:2:2
//texture texture2D segmentationMask 2:1:2:3
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 segmentationMaskDims;
uniform vec4 mainTextureDims;
uniform vec4 segmentationMaskSize;
uniform vec4 segmentationMaskView;
uniform mat3 segmentationMaskTransform;
uniform vec4 segmentationMaskUvMinMax;
uniform vec4 segmentationMaskBorderColor;
uniform vec4 mainTextureSize;
uniform vec4 mainTextureView;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=(l9_0.position.xy*0.5)+vec2(0.5);
vec2 l9_2=vec2(l9_1.x,1.0-l9_1.y);
varPackedTex=vec4(varPackedTex.x,varPackedTex.y,l9_2.x,l9_2.y);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef segmentationMaskHasSwappedViews
#define segmentationMaskHasSwappedViews 0
#elif segmentationMaskHasSwappedViews==1
#undef segmentationMaskHasSwappedViews
#define segmentationMaskHasSwappedViews 1
#endif
#ifndef segmentationMaskLayout
#define segmentationMaskLayout 0
#endif
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
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
#ifndef GRAY_SCALE
#define GRAY_SCALE 0
#elif GRAY_SCALE==1
#undef GRAY_SCALE
#define GRAY_SCALE 1
#endif
#ifndef RG_RB_GB
#define RG_RB_GB 0
#elif RG_RB_GB==1
#undef RG_RB_GB
#define RG_RB_GB 1
#endif
#ifndef RR_GG_BB
#define RR_GG_BB 0
#elif RR_GG_BB==1
#undef RR_GG_BB
#define RR_GG_BB 1
#endif
#ifndef R_G_B
#define R_G_B 0
#elif R_G_B==1
#undef R_G_B
#define R_G_B 1
#endif
#ifndef RY_GY_BY_Y
#define RY_GY_BY_Y 0
#elif RY_GY_BY_Y==1
#undef RY_GY_BY_Y
#define RY_GY_BY_Y 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_segmentationMask
#define SC_SOFTWARE_WRAP_MODE_U_segmentationMask -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_segmentationMask
#define SC_SOFTWARE_WRAP_MODE_V_segmentationMask -1
#endif
#ifndef SC_USE_UV_MIN_MAX_segmentationMask
#define SC_USE_UV_MIN_MAX_segmentationMask 0
#elif SC_USE_UV_MIN_MAX_segmentationMask==1
#undef SC_USE_UV_MIN_MAX_segmentationMask
#define SC_USE_UV_MIN_MAX_segmentationMask 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_segmentationMask
#define SC_USE_CLAMP_TO_BORDER_segmentationMask 0
#elif SC_USE_CLAMP_TO_BORDER_segmentationMask==1
#undef SC_USE_CLAMP_TO_BORDER_segmentationMask
#define SC_USE_CLAMP_TO_BORDER_segmentationMask 1
#endif
uniform vec4 segmentationMaskDims;
uniform vec4 mainTextureDims;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform vec4 segmentationMaskUvMinMax;
uniform vec4 segmentationMaskBorderColor;
uniform vec4 segmentationMaskSize;
uniform vec4 segmentationMaskView;
uniform mat3 segmentationMaskTransform;
uniform vec4 mainTextureSize;
uniform vec4 mainTextureView;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2D segmentationMask;
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_0,sc_PlatformFlipV(varPackedTex.xy),(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
vec3 l9_2=l9_1.xyz;
vec3 l9_3;
#if (GRAY_SCALE)
{
l9_3=vec3(dot(l9_2,vec3(0.21259999,0.71520001,0.0722)));
}
#else
{
l9_3=l9_2;
}
#endif
vec4 l9_4;
#if (RG_RB_GB)
{
l9_4=vec4(l9_3.xxy*l9_3.yzz,1.0);
}
#else
{
vec4 l9_5;
#if (RR_GG_BB)
{
l9_5=vec4(l9_3*l9_3,1.0);
}
#else
{
vec4 l9_6;
#if (R_G_B)
{
l9_6=vec4(l9_3,1.0);
}
#else
{
vec4 l9_7;
#if (RY_GY_BY_Y)
{
int l9_8;
#if (segmentationMaskHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(segmentationMaskDims.xy,segmentationMaskLayout,l9_8,varPackedTex.zw,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMask);
float l9_10=l9_9.x;
l9_7=vec4(l9_3*l9_10,l9_10);
}
#else
{
vec4 l9_11;
#if (GRAY_SCALE)
{
int l9_12;
#if (segmentationMaskHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
vec4 l9_13=sc_SampleTextureBiasOrLevel(segmentationMaskDims.xy,segmentationMaskLayout,l9_12,varPackedTex.zw,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMask);
float l9_14=l9_13.x;
l9_11=vec4(l9_3.x,l9_14,l9_3.x*l9_14,l9_3.x*l9_3.x);
}
#else
{
l9_11=vec4(1.0,0.0,1.0,1.0);
}
#endif
l9_7=l9_11;
}
#endif
l9_6=l9_7;
}
#endif
l9_5=l9_6;
}
#endif
l9_4=l9_5;
}
#endif
sc_writeFragData0(l9_4);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
