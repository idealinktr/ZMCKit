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
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
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
uniform vec4 seeds;
uniform float stddev;
uniform float rgbRatio;
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
int l9_2;
#if (inputTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,5.0,inputTexture);
float l9_4=l9_1.x;
float l9_5;
#if (SC_DEVICE_CLASS>=2)
{
l9_5=pow(l9_4,2.2);
}
#else
{
l9_5=l9_4*l9_4;
}
#endif
float l9_6=l9_1.y;
float l9_7;
#if (SC_DEVICE_CLASS>=2)
{
l9_7=pow(l9_6,2.2);
}
#else
{
l9_7=l9_6*l9_6;
}
#endif
float l9_8=l9_1.z;
float l9_9;
#if (SC_DEVICE_CLASS>=2)
{
l9_9=pow(l9_8,2.2);
}
#else
{
l9_9=l9_8*l9_8;
}
#endif
vec3 l9_10=vec3(l9_5,l9_7,l9_9);
vec2 l9_11=fwidth(varPackedTex.xy);
vec2 l9_12=floor(varPackedTex.xy/(l9_11*2.0))*l9_11;
float l9_13=6.2831855*fract(sin(dot(l9_12+vec2(seeds.y),vec2(12.9898,78.233002)))*43758.547);
float l9_14=6.2831855*fract(sin(dot(l9_12+vec2(seeds.w),vec2(12.9898,78.233002)))*43758.547);
vec4 l9_15=vec4(vec2(cos(l9_13),sin(l9_13))*sqrt((-2.0)*log(max(fract(sin(dot(l9_12+vec2(seeds.x),vec2(12.9898,78.233002)))*43758.547),1e-06))),vec2(cos(l9_14),sin(l9_14))*sqrt((-2.0)*log(max(fract(sin(dot(l9_12+vec2(seeds.z),vec2(12.9898,78.233002)))*43758.547),1e-06))))*stddev;
float l9_16=l9_3.x;
float l9_17;
#if (SC_DEVICE_CLASS>=2)
{
l9_17=pow(l9_16,2.2);
}
#else
{
l9_17=l9_16*l9_16;
}
#endif
float l9_18=l9_3.y;
float l9_19;
#if (SC_DEVICE_CLASS>=2)
{
l9_19=pow(l9_18,2.2);
}
#else
{
l9_19=l9_18*l9_18;
}
#endif
float l9_20=l9_3.z;
float l9_21;
#if (SC_DEVICE_CLASS>=2)
{
l9_21=pow(l9_20,2.2);
}
#else
{
l9_21=l9_20*l9_20;
}
#endif
vec3 l9_22=vec3(l9_17,l9_19,l9_21);
vec3 l9_23=clamp(l9_10+(((l9_15.xyz*rgbRatio)+vec3(l9_15.w*(1.0-rgbRatio)))*sqrt(1.0-max(dot(l9_22,vec3(0.29899999,0.58700001,0.114)),0.0))),vec3(0.0),vec3(1.0));
float l9_24=l9_23.x;
float l9_25;
#if (SC_DEVICE_CLASS>=2)
{
l9_25=pow(l9_24,0.45454547);
}
#else
{
l9_25=sqrt(l9_24);
}
#endif
float l9_26=l9_23.y;
float l9_27;
#if (SC_DEVICE_CLASS>=2)
{
l9_27=pow(l9_26,0.45454547);
}
#else
{
l9_27=sqrt(l9_26);
}
#endif
float l9_28=l9_23.z;
float l9_29;
#if (SC_DEVICE_CLASS>=2)
{
l9_29=pow(l9_28,0.45454547);
}
#else
{
l9_29=sqrt(l9_28);
}
#endif
sc_writeFragData0(vec4(l9_25,l9_27,l9_29,l9_1.w));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
