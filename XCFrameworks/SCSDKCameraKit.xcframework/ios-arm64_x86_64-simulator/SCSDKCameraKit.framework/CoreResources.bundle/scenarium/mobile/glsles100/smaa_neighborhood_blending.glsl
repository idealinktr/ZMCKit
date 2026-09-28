#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec2 inputRTSize;
varying vec2 varTexCoords;
varying vec4 smaaRTMetrics;
varying vec4 varOffset0;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(l9_0);
varTexCoords=(l9_0.position.xy*0.5)+vec2(0.5);
smaaRTMetrics=vec4(1.0/inputRTSize.x,1.0/inputRTSize.y,inputRTSize.x,inputRTSize.y);
varOffset0=(smaaRTMetrics.xyxy*vec4(1.0,0.0,0.0,-1.0))+varTexCoords.xyxy;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef blendTexHasSwappedViews
#define blendTexHasSwappedViews 0
#elif blendTexHasSwappedViews==1
#undef blendTexHasSwappedViews
#define blendTexHasSwappedViews 1
#endif
#ifndef blendTexLayout
#define blendTexLayout 0
#endif
#ifndef inputTexHasSwappedViews
#define inputTexHasSwappedViews 0
#elif inputTexHasSwappedViews==1
#undef inputTexHasSwappedViews
#define inputTexHasSwappedViews 1
#endif
#ifndef inputTexLayout
#define inputTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_blendTex
#define SC_USE_UV_TRANSFORM_blendTex 0
#elif SC_USE_UV_TRANSFORM_blendTex==1
#undef SC_USE_UV_TRANSFORM_blendTex
#define SC_USE_UV_TRANSFORM_blendTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_blendTex
#define SC_SOFTWARE_WRAP_MODE_U_blendTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_blendTex
#define SC_SOFTWARE_WRAP_MODE_V_blendTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_blendTex
#define SC_USE_UV_MIN_MAX_blendTex 0
#elif SC_USE_UV_MIN_MAX_blendTex==1
#undef SC_USE_UV_MIN_MAX_blendTex
#define SC_USE_UV_MIN_MAX_blendTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_blendTex
#define SC_USE_CLAMP_TO_BORDER_blendTex 0
#elif SC_USE_CLAMP_TO_BORDER_blendTex==1
#undef SC_USE_CLAMP_TO_BORDER_blendTex
#define SC_USE_CLAMP_TO_BORDER_blendTex 1
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTex
#define SC_USE_UV_TRANSFORM_inputTex 0
#elif SC_USE_UV_TRANSFORM_inputTex==1
#undef SC_USE_UV_TRANSFORM_inputTex
#define SC_USE_UV_TRANSFORM_inputTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTex
#define SC_SOFTWARE_WRAP_MODE_U_inputTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTex
#define SC_SOFTWARE_WRAP_MODE_V_inputTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTex
#define SC_USE_UV_MIN_MAX_inputTex 0
#elif SC_USE_UV_MIN_MAX_inputTex==1
#undef SC_USE_UV_MIN_MAX_inputTex
#define SC_USE_UV_MIN_MAX_inputTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTex
#define SC_USE_CLAMP_TO_BORDER_inputTex 0
#elif SC_USE_CLAMP_TO_BORDER_inputTex==1
#undef SC_USE_CLAMP_TO_BORDER_inputTex
#define SC_USE_CLAMP_TO_BORDER_inputTex 1
#endif
uniform vec4 blendTexDims;
uniform vec4 inputTexDims;
uniform mat3 blendTexTransform;
uniform vec4 blendTexUvMinMax;
uniform vec4 blendTexBorderColor;
uniform mat3 inputTexTransform;
uniform vec4 inputTexUvMinMax;
uniform vec4 inputTexBorderColor;
uniform mediump sampler2D blendTex;
uniform mediump sampler2D inputTex;
varying vec4 varOffset0;
varying vec2 varTexCoords;
varying vec4 smaaRTMetrics;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (blendTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(blendTexDims.xy,blendTexLayout,l9_0,varOffset0.xy,(int(SC_USE_UV_TRANSFORM_blendTex)!=0),blendTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_blendTex,SC_SOFTWARE_WRAP_MODE_V_blendTex),(int(SC_USE_UV_MIN_MAX_blendTex)!=0),blendTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_blendTex)!=0),blendTexBorderColor,0.0,blendTex);
float l9_2=l9_1.w;
vec4 l9_3=vec4(0.0);
l9_3.x=l9_2;
int l9_4;
#if (blendTexHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(blendTexDims.xy,blendTexLayout,l9_4,varOffset0.zw,(int(SC_USE_UV_TRANSFORM_blendTex)!=0),blendTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_blendTex,SC_SOFTWARE_WRAP_MODE_V_blendTex),(int(SC_USE_UV_MIN_MAX_blendTex)!=0),blendTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_blendTex)!=0),blendTexBorderColor,0.0,blendTex);
float l9_6=l9_5.y;
vec4 l9_7=l9_3;
l9_7.y=l9_6;
int l9_8;
#if (blendTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(blendTexDims.xy,blendTexLayout,l9_8,varTexCoords,(int(SC_USE_UV_TRANSFORM_blendTex)!=0),blendTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_blendTex,SC_SOFTWARE_WRAP_MODE_V_blendTex),(int(SC_USE_UV_MIN_MAX_blendTex)!=0),blendTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_blendTex)!=0),blendTexBorderColor,0.0,blendTex);
vec4 l9_10=vec4(l9_7.x,l9_7.y,l9_9.z,l9_9.x);
vec4 l9_11;
if (dot(l9_10,vec4(1.0))<9.9999997e-06)
{
int l9_12;
#if (inputTexHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
l9_11=sc_SampleTextureBiasOrLevel(inputTexDims.xy,inputTexLayout,l9_12,varTexCoords,(int(SC_USE_UV_TRANSFORM_inputTex)!=0),inputTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTex,SC_SOFTWARE_WRAP_MODE_V_inputTex),(int(SC_USE_UV_MIN_MAX_inputTex)!=0),inputTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTex)!=0),inputTexBorderColor,0.0,inputTex);
}
else
{
float l9_13=l9_9.z;
float l9_14=l9_9.x;
vec4 l9_15=vec4(0.0,l9_6,0.0,l9_14);
vec2 l9_16=l9_10.yw;
vec2 l9_17=l9_15.xy;
bool l9_18=float(max(l9_2,l9_13)>max(l9_6,l9_14))>0.0;
vec2 l9_19;
if (l9_18)
{
vec2 l9_20=l9_17;
l9_20.x=l9_2;
l9_19=l9_20;
}
else
{
l9_19=l9_17;
}
vec2 l9_21;
if (l9_18)
{
vec2 l9_22=l9_19;
l9_22.y=0.0;
l9_21=l9_22;
}
else
{
l9_21=l9_19;
}
vec2 l9_23=l9_15.zw;
vec2 l9_24;
if (l9_18)
{
vec2 l9_25=l9_23;
l9_25.x=l9_13;
l9_24=l9_25;
}
else
{
l9_24=l9_23;
}
vec2 l9_26;
if (l9_18)
{
vec2 l9_27=l9_24;
l9_27.y=0.0;
l9_26=l9_27;
}
else
{
l9_26=l9_24;
}
vec2 l9_28;
if (l9_18)
{
vec2 l9_29=l9_16;
l9_29.x=l9_2;
l9_28=l9_29;
}
else
{
l9_28=l9_16;
}
vec2 l9_30;
if (l9_18)
{
vec2 l9_31=l9_28;
l9_31.y=l9_13;
l9_30=l9_31;
}
else
{
l9_30=l9_28;
}
float l9_32=dot(l9_30,vec2(1.0));
vec2 l9_33=l9_30/vec2(l9_32);
vec4 l9_34=(vec4(l9_21.x,l9_21.y,l9_26.x,l9_26.y)*vec4(smaaRTMetrics.x,-smaaRTMetrics.y,-smaaRTMetrics.x,smaaRTMetrics.y))+varTexCoords.xyxy;
int l9_35;
#if (inputTexHasSwappedViews)
{
l9_35=1-sc_GetStereoViewIndex();
}
#else
{
l9_35=sc_GetStereoViewIndex();
}
#endif
vec4 l9_36=sc_SampleTextureBiasOrLevel(inputTexDims.xy,inputTexLayout,l9_35,l9_34.xy,(int(SC_USE_UV_TRANSFORM_inputTex)!=0),inputTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTex,SC_SOFTWARE_WRAP_MODE_V_inputTex),(int(SC_USE_UV_MIN_MAX_inputTex)!=0),inputTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTex)!=0),inputTexBorderColor,0.0,inputTex);
int l9_37;
#if (inputTexHasSwappedViews)
{
l9_37=1-sc_GetStereoViewIndex();
}
#else
{
l9_37=sc_GetStereoViewIndex();
}
#endif
l9_11=(l9_36*l9_33.x)+(sc_SampleTextureBiasOrLevel(inputTexDims.xy,inputTexLayout,l9_37,l9_34.zw,(int(SC_USE_UV_TRANSFORM_inputTex)!=0),inputTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTex,SC_SOFTWARE_WRAP_MODE_V_inputTex),(int(SC_USE_UV_MIN_MAX_inputTex)!=0),inputTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTex)!=0),inputTexBorderColor,0.0,inputTex)*l9_33.y);
}
sc_writeFragData0(l9_11);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
