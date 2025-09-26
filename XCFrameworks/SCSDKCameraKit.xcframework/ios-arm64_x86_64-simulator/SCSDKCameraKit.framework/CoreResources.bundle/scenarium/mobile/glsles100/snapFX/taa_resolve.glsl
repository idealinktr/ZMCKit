#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler sc_TAAColorTextureSmpSC 2:4
//sampler sampler sc_TAAHistoryTextureSmpSC 2:6
//sampler sampler sc_TAAMotionVectorTextureSmpSC 2:7
//texture texture2D sc_TAAColorTexture 2:0:2:4
//texture texture2D sc_TAAHistoryTexture 2:2:2:6
//texture texture2D sc_TAAMotionVectorTexture 2:3:2:7
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <std2_taa.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=vec4(position.xy,0.0,1.0);
vec2 l9_2=(l9_1.xy*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(sc_Vertex_t(l9_1,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <std2_taa.glsl>
#ifndef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 0
#elif sc_TAAColorTextureHasSwappedViews==1
#undef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAColorTextureLayout
#define sc_TAAColorTextureLayout 0
#endif
#ifndef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 0
#elif sc_TAAHistoryTextureHasSwappedViews==1
#undef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 1
#endif
#ifndef sc_TAAHistoryTextureLayout
#define sc_TAAHistoryTextureLayout 0
#endif
#ifndef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 0
#elif sc_TAAMotionVectorTextureHasSwappedViews==1
#undef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAMotionVectorTextureLayout
#define sc_TAAMotionVectorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAColorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAColorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 1
#endif
#ifndef ENABLE_VELOCITY_DILATION
#define ENABLE_VELOCITY_DILATION 1
#elif ENABLE_VELOCITY_DILATION==1
#undef ENABLE_VELOCITY_DILATION
#define ENABLE_VELOCITY_DILATION 1
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 1
#endif
#ifndef ENABLE_COLOR_CLAMPING
#define ENABLE_COLOR_CLAMPING 1
#elif ENABLE_COLOR_CLAMPING==1
#undef ENABLE_COLOR_CLAMPING
#define ENABLE_COLOR_CLAMPING 1
#endif
#ifndef DO_BLIT
#define DO_BLIT 0
#elif DO_BLIT==1
#undef DO_BLIT
#define DO_BLIT 1
#endif
uniform vec4 sc_TAAColorTextureDims;
uniform vec4 sc_TAAHistoryTextureDims;
uniform vec4 sc_TAAMotionVectorTextureDims;
uniform vec4 sc_TAAMotionVectorTextureSize;
uniform mat3 sc_TAAMotionVectorTextureTransform;
uniform vec4 sc_TAAMotionVectorTextureUvMinMax;
uniform vec4 sc_TAAMotionVectorTextureBorderColor;
uniform mat3 sc_TAAColorTextureTransform;
uniform vec4 sc_TAAColorTextureUvMinMax;
uniform vec4 sc_TAAColorTextureBorderColor;
uniform mat3 sc_TAAHistoryTextureTransform;
uniform vec4 sc_TAAHistoryTextureUvMinMax;
uniform vec4 sc_TAAHistoryTextureBorderColor;
uniform float sharpening;
uniform vec4 sc_TAAHistoryTextureSize;
uniform vec4 debugConsts;
uniform vec4 sc_TAAColorTextureSize;
uniform float currentFrameWeight;
uniform mediump sampler2D sc_TAAHistoryTexture;
uniform mediump sampler2D sc_TAAMotionVectorTexture;
uniform mediump sampler2D sc_TAAColorTexture;
void doResolvePass()
{
float l9_0;
vec2 l9_1;
l9_1=vec2(0.0);
l9_0=0.0;
float l9_2;
vec2 l9_3;
float l9_4;
int l9_5=-1;
float l9_6=0.0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_5<=1)
{
l9_4=l9_0;
l9_3=l9_1;
l9_2=l9_6;
float l9_7;
vec2 l9_8;
float l9_9;
int l9_10=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_10<=1)
{
int l9_11;
#if (sc_TAAMotionVectorTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureLevel(sc_TAAMotionVectorTextureDims.xy,sc_TAAMotionVectorTextureLayout,l9_11,varPackedTex.xy+(vec2(float(l9_5),float(l9_10))*sc_TAAMotionVectorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTexture);
if (all(equal(l9_12,vec4(0.0))))
{
l9_9=l9_4+1.0;
l9_8=l9_3;
l9_7=l9_2;
}
else
{
vec2 l9_13=decodeMotionVector(l9_12);
float l9_14=dot(l9_13,l9_13);
bool l9_15=l9_14>l9_2;
bvec2 l9_16=bvec2(l9_15);
l9_9=l9_4;
l9_8=vec2(l9_16.x ? l9_13.x : l9_3.x,l9_16.y ? l9_13.y : l9_3.y);
l9_7=l9_15 ? l9_14 : l9_2;
}
l9_4=l9_9;
l9_3=l9_8;
l9_2=l9_7;
l9_10++;
continue;
}
else
{
break;
}
}
l9_1=l9_3;
l9_0=l9_4;
l9_5++;
l9_6=l9_2;
continue;
}
else
{
break;
}
}
if (l9_0>8.0)
{
int l9_17;
#if (sc_TAAColorTextureHasSwappedViews)
{
l9_17=1-sc_GetStereoViewIndex();
}
#else
{
l9_17=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(sc_SampleTextureLevel(sc_TAAColorTextureDims.xy,sc_TAAColorTextureLayout,l9_17,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture));
return;
}
vec2 l9_18;
#if (!ENABLE_VELOCITY_DILATION)
{
int l9_19;
#if (sc_TAAMotionVectorTextureHasSwappedViews)
{
l9_19=1-sc_GetStereoViewIndex();
}
#else
{
l9_19=sc_GetStereoViewIndex();
}
#endif
vec4 l9_20=sc_SampleTextureLevel(sc_TAAMotionVectorTextureDims.xy,sc_TAAMotionVectorTextureLayout,l9_19,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTexture);
vec2 l9_21;
if (all(equal(l9_20,vec4(0.0))))
{
l9_21=vec2(0.0);
}
else
{
l9_21=decodeMotionVector(l9_20);
}
l9_18=l9_21;
}
#else
{
l9_18=l9_1;
}
#endif
vec2 l9_22=varPackedTex.xy-l9_18;
int l9_23;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
vec4 l9_24=sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_23,l9_22,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
vec2 l9_25=l9_18*sc_TAAHistoryTextureSize.xy;
vec2 l9_26=vec2(0.5)-abs(fract(l9_25)-vec2(0.5));
bool l9_27=l9_26.x>0.0099999998;
bool l9_28;
if (!l9_27)
{
l9_28=l9_26.y>0.0099999998;
}
else
{
l9_28=l9_27;
}
bool l9_29;
if (!l9_28)
{
l9_29=debugConsts.x>0.0;
}
else
{
l9_29=l9_28;
}
vec4 l9_30;
if (l9_29)
{
vec2 l9_31=sqrt(l9_26*2.0)*sc_TAAHistoryTextureSize.zw;
int l9_32;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_32=1-sc_GetStereoViewIndex();
}
#else
{
l9_32=sc_GetStereoViewIndex();
}
#endif
vec4 l9_33=sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_32,l9_22+(vec2(1.0)*l9_31),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
int l9_34;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_34=1-sc_GetStereoViewIndex();
}
#else
{
l9_34=sc_GetStereoViewIndex();
}
#endif
vec4 l9_35=sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_34,l9_22+(vec2(-1.0)*l9_31),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
int l9_36;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_36=1-sc_GetStereoViewIndex();
}
#else
{
l9_36=sc_GetStereoViewIndex();
}
#endif
vec4 l9_37=sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_36,l9_22+(vec2(1.0,-1.0)*l9_31),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
int l9_38;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_38=1-sc_GetStereoViewIndex();
}
#else
{
l9_38=sc_GetStereoViewIndex();
}
#endif
vec2 l9_39=abs(l9_26-vec2(0.30000001));
l9_30=l9_24+((l9_24-((((l9_33+l9_35)+l9_37)+sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_38,l9_22+(vec2(-1.0,1.0)*l9_31),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture))*0.25))*(sharpening*(0.60000002-max(l9_39.x,l9_39.y))));
}
else
{
l9_30=l9_24;
}
vec4 l9_40;
#if (ENABLE_COLOR_CLAMPING)
{
vec4 l9_41;
vec4 l9_42;
l9_42=vec4(-9999.0);
l9_41=vec4(9999.0);
vec4 l9_43;
vec4 l9_44;
int l9_45=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_45<=1)
{
l9_44=l9_42;
l9_43=l9_41;
vec4 l9_46;
vec4 l9_47;
int l9_48=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_48<=1)
{
int l9_49;
#if (sc_TAAColorTextureHasSwappedViews)
{
l9_49=1-sc_GetStereoViewIndex();
}
#else
{
l9_49=sc_GetStereoViewIndex();
}
#endif
vec4 l9_50=sc_SampleTextureLevel(sc_TAAColorTextureDims.xy,sc_TAAColorTextureLayout,l9_49,varPackedTex.xy+(vec2(float(l9_45),float(l9_48))*sc_TAAColorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture);
l9_46=min(l9_43,l9_50);
l9_47=max(l9_44,l9_50);
l9_44=l9_47;
l9_43=l9_46;
l9_48++;
continue;
}
else
{
break;
}
}
l9_42=l9_44;
l9_41=l9_43;
l9_45++;
continue;
}
else
{
break;
}
}
l9_40=clamp(l9_30,l9_41,l9_42);
}
#else
{
l9_40=l9_30;
}
#endif
int l9_51;
#if (sc_TAAColorTextureHasSwappedViews)
{
l9_51=1-sc_GetStereoViewIndex();
}
#else
{
l9_51=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(mix(l9_40,sc_SampleTextureLevel(sc_TAAColorTextureDims.xy,sc_TAAColorTextureLayout,l9_51,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture),vec4(currentFrameWeight)));
}
void main()
{
#if (DO_BLIT)
{
int l9_0;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(sc_SampleTextureLevel(sc_TAAHistoryTextureDims.xy,sc_TAAHistoryTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture));
}
#else
{
doResolvePass();
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
