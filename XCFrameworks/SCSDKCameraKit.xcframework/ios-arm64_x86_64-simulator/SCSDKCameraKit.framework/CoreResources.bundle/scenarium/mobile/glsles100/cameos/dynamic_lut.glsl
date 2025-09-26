#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler bgTextureSmpSC 2:2
//sampler sampler lutTextureSmpSC 2:3
//texture texture2D bgTexture 2:0:2:2
//texture texture2D lutTexture 2:1:2:3
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
#ifndef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 0
#elif bgTextureHasSwappedViews==1
#undef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 1
#endif
#ifndef bgTextureLayout
#define bgTextureLayout 0
#endif
#ifndef lutTextureHasSwappedViews
#define lutTextureHasSwappedViews 0
#elif lutTextureHasSwappedViews==1
#undef lutTextureHasSwappedViews
#define lutTextureHasSwappedViews 1
#endif
#ifndef lutTextureLayout
#define lutTextureLayout 0
#endif
#ifndef LINEAR_LUT
#define LINEAR_LUT 0
#elif LINEAR_LUT==1
#undef LINEAR_LUT
#define LINEAR_LUT 1
#endif
#ifndef SC_USE_UV_TRANSFORM_lutTexture
#define SC_USE_UV_TRANSFORM_lutTexture 0
#elif SC_USE_UV_TRANSFORM_lutTexture==1
#undef SC_USE_UV_TRANSFORM_lutTexture
#define SC_USE_UV_TRANSFORM_lutTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_lutTexture
#define SC_SOFTWARE_WRAP_MODE_U_lutTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_lutTexture
#define SC_SOFTWARE_WRAP_MODE_V_lutTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_lutTexture
#define SC_USE_UV_MIN_MAX_lutTexture 0
#elif SC_USE_UV_MIN_MAX_lutTexture==1
#undef SC_USE_UV_MIN_MAX_lutTexture
#define SC_USE_UV_MIN_MAX_lutTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_lutTexture
#define SC_USE_CLAMP_TO_BORDER_lutTexture 0
#elif SC_USE_CLAMP_TO_BORDER_lutTexture==1
#undef SC_USE_CLAMP_TO_BORDER_lutTexture
#define SC_USE_CLAMP_TO_BORDER_lutTexture 1
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
uniform vec4 lutTextureDims;
uniform mat3 lutTextureTransform;
uniform vec4 lutTextureUvMinMax;
uniform vec4 lutTextureBorderColor;
uniform mat3 bgTextureTransform;
uniform vec4 bgTextureUvMinMax;
uniform vec4 bgTextureBorderColor;
uniform float opacity;
uniform mediump sampler2D bgTexture;
uniform mediump sampler2D lutTexture;
vec4 lookup(vec4 textureColor)
{
mediump vec4 l9_0;
#if (LINEAR_LUT)
{
int l9_1;
#if (lutTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
mediump vec4 l9_2=vec4(0.0);
l9_2.x=sc_SampleTextureBiasOrLevel(lutTextureDims.xy,lutTextureLayout,l9_1,vec2(textureColor.z,0.5),(int(SC_USE_UV_TRANSFORM_lutTexture)!=0),lutTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lutTexture,SC_SOFTWARE_WRAP_MODE_V_lutTexture),(int(SC_USE_UV_MIN_MAX_lutTexture)!=0),lutTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lutTexture)!=0),lutTextureBorderColor,0.0,lutTexture).x;
int l9_3;
#if (lutTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
mediump vec4 l9_4=l9_2;
l9_4.y=sc_SampleTextureBiasOrLevel(lutTextureDims.xy,lutTextureLayout,l9_3,vec2(textureColor.y,0.5),(int(SC_USE_UV_TRANSFORM_lutTexture)!=0),lutTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lutTexture,SC_SOFTWARE_WRAP_MODE_V_lutTexture),(int(SC_USE_UV_MIN_MAX_lutTexture)!=0),lutTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lutTexture)!=0),lutTextureBorderColor,0.0,lutTexture).y;
int l9_5;
#if (lutTextureHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
mediump vec4 l9_6=l9_4;
l9_6.z=sc_SampleTextureBiasOrLevel(lutTextureDims.xy,lutTextureLayout,l9_5,vec2(textureColor.x,0.5),(int(SC_USE_UV_TRANSFORM_lutTexture)!=0),lutTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lutTexture,SC_SOFTWARE_WRAP_MODE_V_lutTexture),(int(SC_USE_UV_MIN_MAX_lutTexture)!=0),lutTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lutTexture)!=0),lutTextureBorderColor,0.0,lutTexture).z;
l9_0=l9_6;
}
#else
{
float l9_7=textureColor.z;
float l9_8=l9_7*63.0;
mediump float l9_9=floor(l9_8);
mediump float l9_10=floor(l9_9/8.0);
mediump float l9_11=ceil(l9_8);
mediump float l9_12=floor(l9_11/8.0);
float l9_13=textureColor.x;
float l9_14=textureColor.y;
float l9_15=textureColor.x;
float l9_16=textureColor.y;
int l9_17;
#if (lutTextureHasSwappedViews)
{
l9_17=1-sc_GetStereoViewIndex();
}
#else
{
l9_17=sc_GetStereoViewIndex();
}
#endif
int l9_18;
#if (lutTextureHasSwappedViews)
{
l9_18=1-sc_GetStereoViewIndex();
}
#else
{
l9_18=sc_GetStereoViewIndex();
}
#endif
l9_0=vec4(0.0);
}
#endif
return l9_0;
}
void main()
{
int l9_0;
#if (bgTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(vec4(lookup(sc_SampleTextureBiasOrLevel(bgTextureDims.xy,bgTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_bgTexture)!=0),bgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTexture,SC_SOFTWARE_WRAP_MODE_V_bgTexture),(int(SC_USE_UV_MIN_MAX_bgTexture)!=0),bgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTexture)!=0),bgTextureBorderColor,0.0,bgTexture)).xyz,opacity));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
