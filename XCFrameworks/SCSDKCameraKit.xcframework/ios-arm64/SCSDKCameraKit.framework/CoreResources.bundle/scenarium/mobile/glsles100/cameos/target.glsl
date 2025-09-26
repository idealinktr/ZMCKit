#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler alphaTextureSmpSC 2:2
//sampler sampler targetTextureSmpSC 2:3
//texture texture2D alphaTexture 2:0:2:2
//texture texture2D targetTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform mat4 modelView;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(modelView*l9_0.position,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef targetTextureHasSwappedViews
#define targetTextureHasSwappedViews 0
#elif targetTextureHasSwappedViews==1
#undef targetTextureHasSwappedViews
#define targetTextureHasSwappedViews 1
#endif
#ifndef targetTextureLayout
#define targetTextureLayout 0
#endif
#ifndef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 0
#elif alphaTextureHasSwappedViews==1
#undef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 1
#endif
#ifndef alphaTextureLayout
#define alphaTextureLayout 0
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
#ifndef ALPHA_PATCH
#define ALPHA_PATCH 0
#elif ALPHA_PATCH==1
#undef ALPHA_PATCH
#define ALPHA_PATCH 1
#endif
#ifndef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 0
#elif SC_USE_UV_TRANSFORM_alphaTexture==1
#undef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_U_alphaTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_V_alphaTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 0
#elif SC_USE_UV_MIN_MAX_alphaTexture==1
#undef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 0
#elif SC_USE_CLAMP_TO_BORDER_alphaTexture==1
#undef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 1
#endif
uniform vec4 targetTextureDims;
uniform vec4 alphaTextureDims;
uniform mat3 targetTextureTransform;
uniform vec4 targetTextureUvMinMax;
uniform vec4 targetTextureBorderColor;
uniform vec2 inverseScreenSize;
uniform mat3 alphaTextureTransform;
uniform vec4 alphaTextureUvMinMax;
uniform vec4 alphaTextureBorderColor;
uniform float opacity;
uniform mediump sampler2D targetTexture;
uniform mediump sampler2D alphaTexture;
void main()
{
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(targetTextureDims.xy,targetTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_targetTexture)!=0),targetTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_targetTexture,SC_SOFTWARE_WRAP_MODE_V_targetTexture),(int(SC_USE_UV_MIN_MAX_targetTexture)!=0),targetTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_targetTexture)!=0),targetTextureBorderColor,0.0,targetTexture);
float l9_2;
#if (ALPHA_PATCH)
{
int l9_3;
#if (alphaTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
l9_2=sc_SampleTextureBiasOrLevel(alphaTextureDims.xy,alphaTextureLayout,l9_3,gl_FragCoord.xy*inverseScreenSize,(int(SC_USE_UV_TRANSFORM_alphaTexture)!=0),alphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_alphaTexture,SC_SOFTWARE_WRAP_MODE_V_alphaTexture),(int(SC_USE_UV_MIN_MAX_alphaTexture)!=0),alphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_alphaTexture)!=0),alphaTextureBorderColor,0.0,alphaTexture).x;
}
#else
{
l9_2=1.0;
}
#endif
sc_writeFragData0(vec4(l9_1.xyz,(l9_1.w*l9_2)*opacity));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
