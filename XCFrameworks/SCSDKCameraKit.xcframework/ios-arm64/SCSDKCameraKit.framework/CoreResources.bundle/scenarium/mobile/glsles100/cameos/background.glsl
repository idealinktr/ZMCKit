#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler bgTextureAlphaSmpSC 2:2
//sampler sampler bgTextureSmpSC 2:3
//texture texture2D bgTexture 2:0:2:3
//texture texture2D bgTextureAlpha 2:1:2:2
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
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
#ifndef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 0
#elif bgTextureHasSwappedViews==1
#undef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 1
#endif
#ifndef bgTextureLayout
#define bgTextureLayout 0
#endif
#ifndef bgTextureAlphaHasSwappedViews
#define bgTextureAlphaHasSwappedViews 0
#elif bgTextureAlphaHasSwappedViews==1
#undef bgTextureAlphaHasSwappedViews
#define bgTextureAlphaHasSwappedViews 1
#endif
#ifndef bgTextureAlphaLayout
#define bgTextureAlphaLayout 0
#endif
#ifndef ALPHA_EXISTS
#define ALPHA_EXISTS 0
#elif ALPHA_EXISTS==1
#undef ALPHA_EXISTS
#define ALPHA_EXISTS 1
#endif
#ifndef SC_USE_UV_TRANSFORM_bgTextureAlpha
#define SC_USE_UV_TRANSFORM_bgTextureAlpha 0
#elif SC_USE_UV_TRANSFORM_bgTextureAlpha==1
#undef SC_USE_UV_TRANSFORM_bgTextureAlpha
#define SC_USE_UV_TRANSFORM_bgTextureAlpha 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_bgTextureAlpha
#define SC_SOFTWARE_WRAP_MODE_U_bgTextureAlpha -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_bgTextureAlpha
#define SC_SOFTWARE_WRAP_MODE_V_bgTextureAlpha -1
#endif
#ifndef SC_USE_UV_MIN_MAX_bgTextureAlpha
#define SC_USE_UV_MIN_MAX_bgTextureAlpha 0
#elif SC_USE_UV_MIN_MAX_bgTextureAlpha==1
#undef SC_USE_UV_MIN_MAX_bgTextureAlpha
#define SC_USE_UV_MIN_MAX_bgTextureAlpha 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_bgTextureAlpha
#define SC_USE_CLAMP_TO_BORDER_bgTextureAlpha 0
#elif SC_USE_CLAMP_TO_BORDER_bgTextureAlpha==1
#undef SC_USE_CLAMP_TO_BORDER_bgTextureAlpha
#define SC_USE_CLAMP_TO_BORDER_bgTextureAlpha 1
#endif
#ifndef TEXTURE_EXISTS
#define TEXTURE_EXISTS 0
#elif TEXTURE_EXISTS==1
#undef TEXTURE_EXISTS
#define TEXTURE_EXISTS 1
#endif
#ifndef SC_USE_UV_TRANSFORM_bgTexture
#define SC_USE_UV_TRANSFORM_bgTexture 0
#elif SC_USE_UV_TRANSFORM_bgTexture==1
#undef SC_USE_UV_TRANSFORM_bgTexture
#define SC_USE_UV_TRANSFORM_bgTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_bgTexture
#define SC_SOFTWARE_WRAP_MODE_U_bgTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_bgTexture
#define SC_SOFTWARE_WRAP_MODE_V_bgTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_bgTexture
#define SC_USE_UV_MIN_MAX_bgTexture 0
#elif SC_USE_UV_MIN_MAX_bgTexture==1
#undef SC_USE_UV_MIN_MAX_bgTexture
#define SC_USE_UV_MIN_MAX_bgTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_bgTexture
#define SC_USE_CLAMP_TO_BORDER_bgTexture 0
#elif SC_USE_CLAMP_TO_BORDER_bgTexture==1
#undef SC_USE_CLAMP_TO_BORDER_bgTexture
#define SC_USE_CLAMP_TO_BORDER_bgTexture 1
#endif
uniform vec4 bgTextureDims;
uniform vec4 bgTextureAlphaDims;
uniform mat3 bgTextureAlphaTransform;
uniform vec4 bgTextureAlphaUvMinMax;
uniform vec4 bgTextureAlphaBorderColor;
uniform mat3 bgTextureTransform;
uniform vec4 bgTextureUvMinMax;
uniform vec4 bgTextureBorderColor;
uniform vec4 bgColor;
uniform mediump sampler2D bgTextureAlpha;
uniform mediump sampler2D bgTexture;
void main()
{
float l9_0;
#if (ALPHA_EXISTS)
{
int l9_1;
#if (bgTextureAlphaHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
l9_0=sc_SampleTextureBiasOrLevel(bgTextureAlphaDims.xy,bgTextureAlphaLayout,l9_1,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_bgTextureAlpha)!=0),bgTextureAlphaTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTextureAlpha,SC_SOFTWARE_WRAP_MODE_V_bgTextureAlpha),(int(SC_USE_UV_MIN_MAX_bgTextureAlpha)!=0),bgTextureAlphaUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTextureAlpha)!=0),bgTextureAlphaBorderColor,0.0,bgTextureAlpha).x;
}
#else
{
l9_0=1.0;
}
#endif
vec4 l9_2;
#if (TEXTURE_EXISTS)
{
int l9_3;
#if (bgTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
l9_2=vec4(sc_SampleTextureBiasOrLevel(bgTextureDims.xy,bgTextureLayout,l9_3,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_bgTexture)!=0),bgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTexture,SC_SOFTWARE_WRAP_MODE_V_bgTexture),(int(SC_USE_UV_MIN_MAX_bgTexture)!=0),bgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTexture)!=0),bgTextureBorderColor,0.0,bgTexture).xyz,l9_0);
}
#else
{
l9_2=bgColor;
}
#endif
sc_writeFragData0(l9_2);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
