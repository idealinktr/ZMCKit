#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTextureSmpSC 2:1
//texture texture2D inputTexture 2:0:2:1
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
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 0
#elif SC_USE_UV_TRANSFORM_inputTexture==1
#undef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 0
#elif SC_USE_UV_MIN_MAX_inputTexture==1
#undef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 1
#endif
#ifndef COLOR_SOURCE
#define COLOR_SOURCE 0
#elif COLOR_SOURCE==1
#undef COLOR_SOURCE
#define COLOR_SOURCE 1
#endif
#ifndef R
#define R 0
#elif R==1
#undef R
#define R 1
#endif
#ifndef RG
#define RG 0
#elif RG==1
#undef RG
#define RG 1
#endif
uniform vec4 inputTextureDims;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform vec4 baseColor;
uniform mediump sampler2D inputTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (inputTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec4 l9_2;
#if (COLOR_SOURCE)
{
l9_2=l9_1*baseColor;
}
#else
{
l9_2=vec4(baseColor.xyz,l9_1.x*baseColor.w);
}
#endif
vec4 l9_3;
#if (R)
{
l9_3=vec4(l9_2.w,0.0,0.0,l9_2.w);
}
#else
{
vec4 l9_4;
#if (RG)
{
l9_4=vec4(l9_2.xw,0.0,l9_2.w);
}
#else
{
l9_4=l9_2;
}
#endif
l9_3=l9_4;
}
#endif
sc_writeFragData0(l9_3);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
