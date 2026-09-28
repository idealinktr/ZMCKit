#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 inputTextureSize;
varying vec2 varTexCoords;
varying vec4 varOffset0;
varying vec4 varOffset1;
varying vec4 varOffset2;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(l9_0);
varTexCoords=(l9_0.position.xy*0.5)+vec2(0.5);
vec4 l9_1=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xyxy;
varOffset0=(l9_1*vec4(-1.0,0.0,0.0,1.0))+varTexCoords.xyxy;
varOffset1=(l9_1*vec4(1.0,0.0,0.0,-1.0))+varTexCoords.xyxy;
varOffset2=(l9_1*vec4(-2.0,0.0,0.0,2.0))+varTexCoords.xyxy;
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
#ifndef SMAA_QUALITY
#define SMAA_QUALITY 0
#endif
uniform vec4 inputTextureDims;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mediump sampler2D inputTexture;
varying vec2 varTexCoords;
varying vec4 varOffset0;
varying vec4 varOffset1;
varying vec4 varOffset2;
float getThreshHold(int smaaQuality)
{
if (smaaQuality==0)
{
return 0.15000001;
}
else
{
if (smaaQuality==1)
{
return 0.1;
}
else
{
if (smaaQuality==2)
{
return 0.1;
}
else
{
if (smaaQuality==3)
{
return 0.050000001;
}
else
{
return 0.0;
}
}
}
}
}
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_0,varTexCoords,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
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
vec4 l9_3=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_2,varOffset0.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_4;
#if (inputTextureHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_4,varOffset0.zw,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec2 l9_6=vec2(dot(l9_3.xyz,vec3(0.21259999,0.71520001,0.0722)),dot(l9_5.xyz,vec3(0.21259999,0.71520001,0.0722)));
vec2 l9_7=vec2(dot(l9_1.xyz,vec3(0.21259999,0.71520001,0.0722)));
float l9_8=getThreshHold(SMAA_QUALITY);
vec2 l9_9=abs(l9_7-l9_6).xy;
vec2 l9_10=step(vec2(l9_8),l9_9);
if (dot(l9_10,vec2(1.0))==0.0)
{
sc_writeFragData0(vec4(0.0));
return;
}
int l9_11;
#if (inputTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_11,varOffset1.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
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
vec4 l9_14=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_13,varOffset1.zw,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
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
vec4 l9_16=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_15,varOffset2.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_17;
#if (inputTextureHasSwappedViews)
{
l9_17=1-sc_GetStereoViewIndex();
}
#else
{
l9_17=sc_GetStereoViewIndex();
}
#endif
vec2 l9_18=max(max(l9_9,abs(l9_7-vec2(dot(l9_12.xyz,vec3(0.21259999,0.71520001,0.0722)),dot(l9_14.xyz,vec3(0.21259999,0.71520001,0.0722)))).xy),abs(l9_6-vec2(dot(l9_16.xyz,vec3(0.21259999,0.71520001,0.0722)),dot(sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_17,varOffset2.zw,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture).xyz,vec3(0.21259999,0.71520001,0.0722)))).xy);
sc_writeFragData0(vec4(l9_10*step(vec2(max(l9_18.x,l9_18.y)),l9_9*2.0),0.0,0.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
