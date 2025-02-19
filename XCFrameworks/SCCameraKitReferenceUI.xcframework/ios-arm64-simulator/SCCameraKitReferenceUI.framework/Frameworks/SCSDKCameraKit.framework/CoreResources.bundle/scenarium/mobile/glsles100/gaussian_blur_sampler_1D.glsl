#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler targetTextureSmpSC 2:1
//texture texture2D targetTexture 2:0:2:1
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef sc_GaussianFilterDataLength
#define sc_GaussianFilterDataLength 5
#endif
uniform vec4 targetTextureDims;
uniform vec4 targetTextureSize;
uniform vec4 targetTextureView;
uniform mat3 targetTextureTransform;
uniform vec4 targetTextureUvMinMax;
uniform vec4 targetTextureBorderColor;
uniform float gaussianFilterWeights[sc_GaussianFilterDataLength];
uniform float gaussianFilterOffsets[sc_GaussianFilterDataLength];
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
#include <std2_texture.glsl>
#ifndef targetTextureHasSwappedViews
#define targetTextureHasSwappedViews 0
#elif targetTextureHasSwappedViews==1
#undef targetTextureHasSwappedViews
#define targetTextureHasSwappedViews 1
#endif
#ifndef targetTextureLayout
#define targetTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_targetTexture
#define SC_USE_UV_TRANSFORM_targetTexture 0
#elif SC_USE_UV_TRANSFORM_targetTexture==1
#undef SC_USE_UV_TRANSFORM_targetTexture
#define SC_USE_UV_TRANSFORM_targetTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_targetTexture
#define SC_SOFTWARE_WRAP_MODE_U_targetTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_targetTexture
#define SC_SOFTWARE_WRAP_MODE_V_targetTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_targetTexture
#define SC_USE_UV_MIN_MAX_targetTexture 0
#elif SC_USE_UV_MIN_MAX_targetTexture==1
#undef SC_USE_UV_MIN_MAX_targetTexture
#define SC_USE_UV_MIN_MAX_targetTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_targetTexture
#define SC_USE_CLAMP_TO_BORDER_targetTexture 0
#elif SC_USE_CLAMP_TO_BORDER_targetTexture==1
#undef SC_USE_CLAMP_TO_BORDER_targetTexture
#define SC_USE_CLAMP_TO_BORDER_targetTexture 1
#endif
#ifndef sc_GaussianFilterDataLength
#define sc_GaussianFilterDataLength 5
#endif
#ifndef sc_GaussianFilterVerticalPass
#define sc_GaussianFilterVerticalPass 0
#elif sc_GaussianFilterVerticalPass==1
#undef sc_GaussianFilterVerticalPass
#define sc_GaussianFilterVerticalPass 1
#endif
uniform vec4 targetTextureDims;
uniform mat3 targetTextureTransform;
uniform vec4 targetTextureUvMinMax;
uniform vec4 targetTextureBorderColor;
uniform float gaussianFilterWeights[sc_GaussianFilterDataLength];
uniform float gaussianFilterOffsets[sc_GaussianFilterDataLength];
uniform vec4 targetTextureSize;
uniform vec4 targetTextureView;
uniform mediump sampler2D targetTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (targetTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1;
l9_1=sc_SampleTextureBiasOrLevel(targetTextureDims.xy,targetTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_targetTexture)!=0),targetTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_targetTexture,SC_SOFTWARE_WRAP_MODE_V_targetTexture),(int(SC_USE_UV_MIN_MAX_targetTexture)!=0),targetTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_targetTexture)!=0),targetTextureBorderColor,0.0,targetTexture)*gaussianFilterWeights[0];
vec4 l9_2;
int l9_3=1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_3<sc_GaussianFilterDataLength)
{
vec4 l9_4;
#if (sc_GaussianFilterVerticalPass)
{
vec4 l9_5=varPackedTex.xyxy;
l9_5.y=varPackedTex.y+gaussianFilterOffsets[l9_3];
vec4 l9_6=l9_5;
l9_6.w=varPackedTex.y-gaussianFilterOffsets[l9_3];
l9_4=l9_6;
}
#else
{
vec4 l9_7=varPackedTex.xyxy;
l9_7.x=varPackedTex.x+gaussianFilterOffsets[l9_3];
vec4 l9_8=l9_7;
l9_8.z=varPackedTex.x-gaussianFilterOffsets[l9_3];
l9_4=l9_8;
}
#endif
int l9_9;
#if (targetTextureHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
vec4 l9_10=sc_SampleTextureBiasOrLevel(targetTextureDims.xy,targetTextureLayout,l9_9,l9_4.xy,(int(SC_USE_UV_TRANSFORM_targetTexture)!=0),targetTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_targetTexture,SC_SOFTWARE_WRAP_MODE_V_targetTexture),(int(SC_USE_UV_MIN_MAX_targetTexture)!=0),targetTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_targetTexture)!=0),targetTextureBorderColor,0.0,targetTexture);
int l9_11;
#if (targetTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
l9_2=l9_1+((l9_10+sc_SampleTextureBiasOrLevel(targetTextureDims.xy,targetTextureLayout,l9_11,l9_4.zw,(int(SC_USE_UV_TRANSFORM_targetTexture)!=0),targetTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_targetTexture,SC_SOFTWARE_WRAP_MODE_V_targetTexture),(int(SC_USE_UV_MIN_MAX_targetTexture)!=0),targetTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_targetTexture)!=0),targetTextureBorderColor,0.0,targetTexture))*gaussianFilterWeights[l9_3]);
l9_1=l9_2;
l9_3++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(l9_1);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
