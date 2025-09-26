#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTextureSmpSC 2:1
//texture texture2D inputTexture 2:0:2:1
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
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
uniform vec4 inputTextureDims;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform vec4 inputTextureSize;
uniform vec2 direction;
uniform mediump sampler2D inputTexture;
void main()
{
sc_DiscardStereoFragment();
vec2 l9_0=inputTextureSize.zw*direction;
int l9_1;
#if (inputTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
vec4 l9_2=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_1,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_3;
#if (inputTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
vec4 l9_4=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_3,varPackedTex.xy+l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_5;
#if (inputTextureHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
vec4 l9_6=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_5,varPackedTex.xy-l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_7=l9_0*2.0;
int l9_8;
#if (inputTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_8,varPackedTex.xy+l9_7,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_10;
#if (inputTextureHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_10,varPackedTex.xy-l9_7,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_12=l9_0*3.0;
int l9_13;
#if (inputTextureHasSwappedViews)
{
l9_13=1-sc_GetStereoViewIndex();
}
#else
{
l9_13=sc_GetStereoViewIndex();
}
#endif
vec4 l9_14=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_13,varPackedTex.xy+l9_12,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_15;
#if (inputTextureHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
vec4 l9_16=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_15,varPackedTex.xy-l9_12,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_17=l9_0*4.0;
int l9_18;
#if (inputTextureHasSwappedViews)
{
l9_18=1-sc_GetStereoViewIndex();
}
#else
{
l9_18=sc_GetStereoViewIndex();
}
#endif
vec4 l9_19=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_18,varPackedTex.xy+l9_17,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_20;
#if (inputTextureHasSwappedViews)
{
l9_20=1-sc_GetStereoViewIndex();
}
#else
{
l9_20=sc_GetStereoViewIndex();
}
#endif
vec4 l9_21=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_20,varPackedTex.xy-l9_17,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_22=l9_0*5.0;
int l9_23;
#if (inputTextureHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
vec4 l9_24=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_23,varPackedTex.xy+l9_22,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_25;
#if (inputTextureHasSwappedViews)
{
l9_25=1-sc_GetStereoViewIndex();
}
#else
{
l9_25=sc_GetStereoViewIndex();
}
#endif
vec4 l9_26=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_25,varPackedTex.xy-l9_22,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_27=l9_0*6.0;
int l9_28;
#if (inputTextureHasSwappedViews)
{
l9_28=1-sc_GetStereoViewIndex();
}
#else
{
l9_28=sc_GetStereoViewIndex();
}
#endif
vec4 l9_29=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_28,varPackedTex.xy+l9_27,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_30;
#if (inputTextureHasSwappedViews)
{
l9_30=1-sc_GetStereoViewIndex();
}
#else
{
l9_30=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(max(max(max(max(max(max(max(max(max(max(max(max(l9_2,l9_4),l9_6),l9_9),l9_11),l9_14),l9_16),l9_19),l9_21),l9_24),l9_26),l9_29),sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_30,varPackedTex.xy-l9_27,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture)));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
