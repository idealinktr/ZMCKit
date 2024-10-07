#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//attribute float passIdentifierAttr 18
//attribute float sdfOffsetAttr 19
//sampler sampler backgroundFillTextureSmpSC 2:6
//sampler sampler colorTextureSmpSC 2:7
//sampler sampler mainFillTextureSmpSC 2:8
//sampler sampler mainTextureSmpSC 2:9
//sampler sampler outlineFillTextureSmpSC 2:10
//sampler sampler shadowFillTextureSmpSC 2:11
//texture texture2D backgroundFillTexture 2:0:2:6
//texture texture2D colorTexture 2:1:2:7
//texture texture2D mainFillTexture 2:2:2:8
//texture texture2D mainTexture 2:3:2:9
//texture texture2D outlineFillTexture 2:4:2:10
//texture texture2D shadowFillTexture 2:5:2:11
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#include <std2.glsl>
#include <std2_fs.glsl>
#include <std2_vs.glsl>
uniform vec4 mainTextureDims;
uniform vec4 colorTextureDims;
uniform vec4 mainFillTextureDims;
uniform vec4 shadowFillTextureDims;
uniform vec4 outlineFillTextureDims;
uniform vec4 backgroundFillTextureDims;
uniform vec4 mainTextureSize;
uniform vec4 mainTextureView;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform vec4 colorTextureSize;
uniform vec4 colorTextureView;
uniform mat3 colorTextureTransform;
uniform vec4 colorTextureUvMinMax;
uniform vec4 colorTextureBorderColor;
uniform vec4 mainFillTextureSize;
uniform vec4 mainFillTextureView;
uniform mat3 mainFillTextureTransform;
uniform vec4 mainFillTextureUvMinMax;
uniform vec4 mainFillTextureBorderColor;
uniform vec4 shadowFillTextureSize;
uniform vec4 shadowFillTextureView;
uniform mat3 shadowFillTextureTransform;
uniform vec4 shadowFillTextureUvMinMax;
uniform vec4 shadowFillTextureBorderColor;
uniform vec4 outlineFillTextureSize;
uniform vec4 outlineFillTextureView;
uniform mat3 outlineFillTextureTransform;
uniform vec4 outlineFillTextureUvMinMax;
uniform vec4 outlineFillTextureBorderColor;
uniform vec4 backgroundFillTextureSize;
uniform vec4 backgroundFillTextureView;
uniform mat3 backgroundFillTextureTransform;
uniform vec4 backgroundFillTextureUvMinMax;
uniform vec4 backgroundFillTextureBorderColor;
uniform vec4 mainColor;
uniform vec4 shadowColor;
uniform vec4 outlineColor;
uniform vec4 backgroundColor;
uniform float backgroundCornerRadius;
uniform vec2 backgroundSize;
uniform float multisampleBlend;
varying float varPassIdentifier;
attribute float passIdentifierAttr;
varying float varSdfOffset;
attribute float sdfOffsetAttr;
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
varPassIdentifier=passIdentifierAttr;
varSdfOffset=sdfOffsetAttr;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#include <std2.glsl>
#include <std2_fs.glsl>
#include <std2_vs.glsl>
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
#endif
#ifndef colorTextureHasSwappedViews
#define colorTextureHasSwappedViews 0
#elif colorTextureHasSwappedViews==1
#undef colorTextureHasSwappedViews
#define colorTextureHasSwappedViews 1
#endif
#ifndef colorTextureLayout
#define colorTextureLayout 0
#endif
#ifndef mainFillTextureHasSwappedViews
#define mainFillTextureHasSwappedViews 0
#elif mainFillTextureHasSwappedViews==1
#undef mainFillTextureHasSwappedViews
#define mainFillTextureHasSwappedViews 1
#endif
#ifndef mainFillTextureLayout
#define mainFillTextureLayout 0
#endif
#ifndef shadowFillTextureHasSwappedViews
#define shadowFillTextureHasSwappedViews 0
#elif shadowFillTextureHasSwappedViews==1
#undef shadowFillTextureHasSwappedViews
#define shadowFillTextureHasSwappedViews 1
#endif
#ifndef shadowFillTextureLayout
#define shadowFillTextureLayout 0
#endif
#ifndef outlineFillTextureHasSwappedViews
#define outlineFillTextureHasSwappedViews 0
#elif outlineFillTextureHasSwappedViews==1
#undef outlineFillTextureHasSwappedViews
#define outlineFillTextureHasSwappedViews 1
#endif
#ifndef outlineFillTextureLayout
#define outlineFillTextureLayout 0
#endif
#ifndef backgroundFillTextureHasSwappedViews
#define backgroundFillTextureHasSwappedViews 0
#elif backgroundFillTextureHasSwappedViews==1
#undef backgroundFillTextureHasSwappedViews
#define backgroundFillTextureHasSwappedViews 1
#endif
#ifndef backgroundFillTextureLayout
#define backgroundFillTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_mainTexture
#define SC_USE_UV_TRANSFORM_mainTexture 0
#elif SC_USE_UV_TRANSFORM_mainTexture==1
#undef SC_USE_UV_TRANSFORM_mainTexture
#define SC_USE_UV_TRANSFORM_mainTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_mainTexture
#define SC_SOFTWARE_WRAP_MODE_U_mainTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_mainTexture
#define SC_SOFTWARE_WRAP_MODE_V_mainTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_mainTexture
#define SC_USE_UV_MIN_MAX_mainTexture 0
#elif SC_USE_UV_MIN_MAX_mainTexture==1
#undef SC_USE_UV_MIN_MAX_mainTexture
#define SC_USE_UV_MIN_MAX_mainTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_mainTexture
#define SC_USE_CLAMP_TO_BORDER_mainTexture 0
#elif SC_USE_CLAMP_TO_BORDER_mainTexture==1
#undef SC_USE_CLAMP_TO_BORDER_mainTexture
#define SC_USE_CLAMP_TO_BORDER_mainTexture 1
#endif
#ifndef MAIN_FILL_COLOR
#define MAIN_FILL_COLOR 0
#elif MAIN_FILL_COLOR==1
#undef MAIN_FILL_COLOR
#define MAIN_FILL_COLOR 1
#endif
#ifndef MAIN_FILL_TEXTURE
#define MAIN_FILL_TEXTURE 0
#elif MAIN_FILL_TEXTURE==1
#undef MAIN_FILL_TEXTURE
#define MAIN_FILL_TEXTURE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_mainFillTexture
#define SC_USE_UV_TRANSFORM_mainFillTexture 0
#elif SC_USE_UV_TRANSFORM_mainFillTexture==1
#undef SC_USE_UV_TRANSFORM_mainFillTexture
#define SC_USE_UV_TRANSFORM_mainFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_mainFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_mainFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_mainFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_mainFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_mainFillTexture
#define SC_USE_UV_MIN_MAX_mainFillTexture 0
#elif SC_USE_UV_MIN_MAX_mainFillTexture==1
#undef SC_USE_UV_MIN_MAX_mainFillTexture
#define SC_USE_UV_MIN_MAX_mainFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_mainFillTexture
#define SC_USE_CLAMP_TO_BORDER_mainFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_mainFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_mainFillTexture
#define SC_USE_CLAMP_TO_BORDER_mainFillTexture 1
#endif
#ifndef ENABLE_SHADOW
#define ENABLE_SHADOW 0
#elif ENABLE_SHADOW==1
#undef ENABLE_SHADOW
#define ENABLE_SHADOW 1
#endif
#ifndef SHADOW_FILL_COLOR
#define SHADOW_FILL_COLOR 0
#elif SHADOW_FILL_COLOR==1
#undef SHADOW_FILL_COLOR
#define SHADOW_FILL_COLOR 1
#endif
#ifndef SHADOW_FILL_TEXTURE
#define SHADOW_FILL_TEXTURE 0
#elif SHADOW_FILL_TEXTURE==1
#undef SHADOW_FILL_TEXTURE
#define SHADOW_FILL_TEXTURE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_shadowFillTexture
#define SC_USE_UV_TRANSFORM_shadowFillTexture 0
#elif SC_USE_UV_TRANSFORM_shadowFillTexture==1
#undef SC_USE_UV_TRANSFORM_shadowFillTexture
#define SC_USE_UV_TRANSFORM_shadowFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_shadowFillTexture
#define SC_USE_UV_MIN_MAX_shadowFillTexture 0
#elif SC_USE_UV_MIN_MAX_shadowFillTexture==1
#undef SC_USE_UV_MIN_MAX_shadowFillTexture
#define SC_USE_UV_MIN_MAX_shadowFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_shadowFillTexture
#define SC_USE_CLAMP_TO_BORDER_shadowFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_shadowFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_shadowFillTexture
#define SC_USE_CLAMP_TO_BORDER_shadowFillTexture 1
#endif
#ifndef ENABLE_OUTLINE
#define ENABLE_OUTLINE 0
#elif ENABLE_OUTLINE==1
#undef ENABLE_OUTLINE
#define ENABLE_OUTLINE 1
#endif
#ifndef ENABLE_SDF
#define ENABLE_SDF 0
#elif ENABLE_SDF==1
#undef ENABLE_SDF
#define ENABLE_SDF 1
#endif
#ifndef OUTLINE_FILL_COLOR
#define OUTLINE_FILL_COLOR 0
#elif OUTLINE_FILL_COLOR==1
#undef OUTLINE_FILL_COLOR
#define OUTLINE_FILL_COLOR 1
#endif
#ifndef OUTLINE_FILL_TEXTURE
#define OUTLINE_FILL_TEXTURE 0
#elif OUTLINE_FILL_TEXTURE==1
#undef OUTLINE_FILL_TEXTURE
#define OUTLINE_FILL_TEXTURE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_outlineFillTexture
#define SC_USE_UV_TRANSFORM_outlineFillTexture 0
#elif SC_USE_UV_TRANSFORM_outlineFillTexture==1
#undef SC_USE_UV_TRANSFORM_outlineFillTexture
#define SC_USE_UV_TRANSFORM_outlineFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_outlineFillTexture
#define SC_USE_UV_MIN_MAX_outlineFillTexture 0
#elif SC_USE_UV_MIN_MAX_outlineFillTexture==1
#undef SC_USE_UV_MIN_MAX_outlineFillTexture
#define SC_USE_UV_MIN_MAX_outlineFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_outlineFillTexture
#define SC_USE_CLAMP_TO_BORDER_outlineFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_outlineFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_outlineFillTexture
#define SC_USE_CLAMP_TO_BORDER_outlineFillTexture 1
#endif
#ifndef ENABLE_BACKGROUND
#define ENABLE_BACKGROUND 0
#elif ENABLE_BACKGROUND==1
#undef ENABLE_BACKGROUND
#define ENABLE_BACKGROUND 1
#endif
#ifndef BACKGROUND_FILL_COLOR
#define BACKGROUND_FILL_COLOR 0
#elif BACKGROUND_FILL_COLOR==1
#undef BACKGROUND_FILL_COLOR
#define BACKGROUND_FILL_COLOR 1
#endif
#ifndef BACKGROUND_FILL_TEXTURE
#define BACKGROUND_FILL_TEXTURE 0
#elif BACKGROUND_FILL_TEXTURE==1
#undef BACKGROUND_FILL_TEXTURE
#define BACKGROUND_FILL_TEXTURE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_backgroundFillTexture
#define SC_USE_UV_TRANSFORM_backgroundFillTexture 0
#elif SC_USE_UV_TRANSFORM_backgroundFillTexture==1
#undef SC_USE_UV_TRANSFORM_backgroundFillTexture
#define SC_USE_UV_TRANSFORM_backgroundFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_backgroundFillTexture
#define SC_USE_UV_MIN_MAX_backgroundFillTexture 0
#elif SC_USE_UV_MIN_MAX_backgroundFillTexture==1
#undef SC_USE_UV_MIN_MAX_backgroundFillTexture
#define SC_USE_UV_MIN_MAX_backgroundFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_backgroundFillTexture
#define SC_USE_CLAMP_TO_BORDER_backgroundFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_backgroundFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_backgroundFillTexture
#define SC_USE_CLAMP_TO_BORDER_backgroundFillTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_colorTexture
#define SC_USE_UV_TRANSFORM_colorTexture 0
#elif SC_USE_UV_TRANSFORM_colorTexture==1
#undef SC_USE_UV_TRANSFORM_colorTexture
#define SC_USE_UV_TRANSFORM_colorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_colorTexture
#define SC_SOFTWARE_WRAP_MODE_U_colorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_colorTexture
#define SC_SOFTWARE_WRAP_MODE_V_colorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_colorTexture
#define SC_USE_UV_MIN_MAX_colorTexture 0
#elif SC_USE_UV_MIN_MAX_colorTexture==1
#undef SC_USE_UV_MIN_MAX_colorTexture
#define SC_USE_UV_MIN_MAX_colorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_colorTexture
#define SC_USE_CLAMP_TO_BORDER_colorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_colorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_colorTexture
#define SC_USE_CLAMP_TO_BORDER_colorTexture 1
#endif
uniform vec4 mainTextureDims;
uniform vec4 colorTextureDims;
uniform vec4 mainFillTextureDims;
uniform vec4 shadowFillTextureDims;
uniform vec4 outlineFillTextureDims;
uniform vec4 backgroundFillTextureDims;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform float backgroundCornerRadius;
uniform vec4 mainColor;
uniform mat3 mainFillTextureTransform;
uniform vec4 mainFillTextureUvMinMax;
uniform vec4 mainFillTextureBorderColor;
uniform vec4 shadowColor;
uniform mat3 shadowFillTextureTransform;
uniform vec4 shadowFillTextureUvMinMax;
uniform vec4 shadowFillTextureBorderColor;
uniform vec4 outlineColor;
uniform mat3 outlineFillTextureTransform;
uniform vec4 outlineFillTextureUvMinMax;
uniform vec4 outlineFillTextureBorderColor;
uniform vec2 backgroundSize;
uniform vec4 backgroundColor;
uniform mat3 backgroundFillTextureTransform;
uniform vec4 backgroundFillTextureUvMinMax;
uniform vec4 backgroundFillTextureBorderColor;
uniform mat3 colorTextureTransform;
uniform vec4 colorTextureUvMinMax;
uniform vec4 colorTextureBorderColor;
uniform float multisampleBlend;
uniform vec4 mainTextureSize;
uniform vec4 mainTextureView;
uniform vec4 colorTextureSize;
uniform vec4 colorTextureView;
uniform vec4 mainFillTextureSize;
uniform vec4 mainFillTextureView;
uniform vec4 shadowFillTextureSize;
uniform vec4 shadowFillTextureView;
uniform vec4 outlineFillTextureSize;
uniform vec4 outlineFillTextureView;
uniform vec4 backgroundFillTextureSize;
uniform vec4 backgroundFillTextureView;
uniform mediump sampler2D mainFillTexture;
uniform mediump sampler2D shadowFillTexture;
uniform mediump sampler2D outlineFillTexture;
uniform mediump sampler2D backgroundFillTexture;
uniform mediump sampler2D colorTexture;
uniform mediump sampler2D mainTexture;
varying float varPassIdentifier;
varying float varSdfOffset;
bool isPass(float pass,float identifier)
{
float l9_0=identifier;
float l9_1=pass;
bool l9_2=l9_0>(l9_1-0.050000001);
bool l9_3;
if (l9_2)
{
l9_3=identifier<(pass+0.050000001);
}
else
{
l9_3=l9_2;
}
if (l9_3)
{
return true;
}
return false;
}
float getCornerFade(vec2 corner)
{
if (length(abs(corner-varPackedTex.xy))>backgroundCornerRadius)
{
return 1.0;
}
float l9_0=corner.x;
float l9_1=corner.y;
float l9_2=length(abs(abs(vec2(l9_0-backgroundCornerRadius,l9_1-backgroundCornerRadius))-varPackedTex.xy))/backgroundCornerRadius;
if (l9_2<0.98000002)
{
return 1.0;
}
if (l9_2>1.0)
{
return 0.0;
}
return smoothstep(1.0,0.98000002,l9_2);
}
float calculateSdfOpacityMultisampled(float dist,float sdfEdge,float multisampleBlend_1)
{
float l9_0=dist;
float l9_1=sdfEdge;
float l9_2=fwidth(l9_0);
float l9_3=smoothstep(l9_1-l9_2,l9_1+l9_2,l9_0);
float l9_4;
if (multisampleBlend_1>0.0)
{
vec2 l9_5=dFdx(varPackedTex.xy);
vec2 l9_6=dFdy(varPackedTex.xy);
vec2 l9_7=(l9_5+l9_6)*0.35355338;
vec4 l9_8=vec4(varPackedTex.xy-l9_7,varPackedTex.xy+l9_7);
int l9_9;
#if (mainTextureHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
vec4 l9_10=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_9,l9_8.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_11=l9_10.x;
float l9_12=sdfEdge;
float l9_13=fwidth(l9_11);
int l9_14;
#if (mainTextureHasSwappedViews)
{
l9_14=1-sc_GetStereoViewIndex();
}
#else
{
l9_14=sc_GetStereoViewIndex();
}
#endif
vec4 l9_15=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_14,l9_8.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_16=l9_15.x;
float l9_17=sdfEdge;
float l9_18=fwidth(l9_16);
int l9_19;
#if (mainTextureHasSwappedViews)
{
l9_19=1-sc_GetStereoViewIndex();
}
#else
{
l9_19=sc_GetStereoViewIndex();
}
#endif
vec4 l9_20=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_19,l9_8.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_21=l9_20.x;
float l9_22=sdfEdge;
float l9_23=fwidth(l9_21);
int l9_24;
#if (mainTextureHasSwappedViews)
{
l9_24=1-sc_GetStereoViewIndex();
}
#else
{
l9_24=sc_GetStereoViewIndex();
}
#endif
vec4 l9_25=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_24,l9_8.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_26=l9_25.x;
float l9_27=fwidth(l9_26);
l9_4=mix(l9_3,((((l9_3+smoothstep(l9_12-l9_13,l9_12+l9_13,l9_11))+smoothstep(l9_17-l9_18,l9_17+l9_18,l9_16))+smoothstep(l9_22-l9_23,l9_22+l9_23,l9_21))+smoothstep(sdfEdge-l9_27,sdfEdge+l9_27,l9_26))*0.2,multisampleBlend_1);
}
else
{
l9_4=l9_3;
}
return l9_4;
}
void main()
{
sc_DiscardStereoFragment();
vec2 l9_0=vec2(fract(varPackedTex.z),fract(varPackedTex.w));
bool l9_1=isPass(0.0,varPassIdentifier);
bool l9_2;
if (!l9_1)
{
l9_2=isPass(0.1,varPassIdentifier);
}
else
{
l9_2=l9_1;
}
vec4 l9_3;
if (l9_2)
{
vec4 l9_4;
#if (MAIN_FILL_COLOR)
{
l9_4=mainColor;
}
#else
{
vec4 l9_5;
#if (MAIN_FILL_TEXTURE)
{
int l9_6;
#if (mainFillTextureHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
l9_5=sc_SampleTextureBiasOrLevel(mainFillTextureDims.xy,mainFillTextureLayout,l9_6,l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTexture);
}
#else
{
l9_5=vec4(1.0);
}
#endif
l9_4=l9_5;
}
#endif
l9_3=l9_4;
}
else
{
l9_3=vec4(1.0);
}
vec4 l9_7;
#if (ENABLE_SHADOW)
{
vec4 l9_8;
if (isPass(0.2,varPassIdentifier))
{
vec4 l9_9;
#if (SHADOW_FILL_COLOR)
{
l9_9=shadowColor;
}
#else
{
vec4 l9_10;
#if (SHADOW_FILL_TEXTURE)
{
int l9_11;
#if (shadowFillTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
l9_10=sc_SampleTextureBiasOrLevel(shadowFillTextureDims.xy,shadowFillTextureLayout,l9_11,l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTexture);
}
#else
{
l9_10=l9_3;
}
#endif
l9_9=l9_10;
}
#endif
l9_8=l9_9;
}
else
{
l9_8=l9_3;
}
l9_7=l9_8;
}
#else
{
l9_7=l9_3;
}
#endif
vec4 l9_12;
float l9_13;
#if (ENABLE_OUTLINE)
{
vec4 l9_14;
float l9_15;
if (isPass(0.30000001,varPassIdentifier))
{
float l9_16;
#if (ENABLE_SDF)
{
l9_16=0.5-varSdfOffset;
}
#else
{
l9_16=0.5;
}
#endif
vec4 l9_17;
#if (OUTLINE_FILL_COLOR)
{
l9_17=outlineColor;
}
#else
{
vec4 l9_18;
#if (OUTLINE_FILL_TEXTURE)
{
int l9_19;
#if (outlineFillTextureHasSwappedViews)
{
l9_19=1-sc_GetStereoViewIndex();
}
#else
{
l9_19=sc_GetStereoViewIndex();
}
#endif
l9_18=sc_SampleTextureBiasOrLevel(outlineFillTextureDims.xy,outlineFillTextureLayout,l9_19,l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTexture);
}
#else
{
l9_18=l9_7;
}
#endif
l9_17=l9_18;
}
#endif
l9_15=l9_16;
l9_14=l9_17;
}
else
{
l9_15=0.5;
l9_14=l9_7;
}
l9_13=l9_15;
l9_12=l9_14;
}
#else
{
l9_13=0.5;
l9_12=l9_7;
}
#endif
#if (ENABLE_BACKGROUND)
{
if (isPass(0.40000001,varPassIdentifier))
{
float l9_20=getCornerFade(vec2(0.0));
float l9_21=getCornerFade(vec2(backgroundSize.x,0.0));
float l9_22=getCornerFade(vec2(backgroundSize.x,backgroundSize.y));
float l9_23=getCornerFade(vec2(0.0,backgroundSize.y));
float l9_24=(((1.0*l9_20)*l9_21)*l9_22)*l9_23;
if (l9_24<0.0049999999)
{
discard;
}
#if (BACKGROUND_FILL_COLOR)
{
float l9_25=backgroundColor.w*l9_24;
sc_writeFragData0(vec4(backgroundColor.xyz*l9_25,l9_25));
}
#else
{
#if (BACKGROUND_FILL_TEXTURE)
{
int l9_26;
#if (backgroundFillTextureHasSwappedViews)
{
l9_26=1-sc_GetStereoViewIndex();
}
#else
{
l9_26=sc_GetStereoViewIndex();
}
#endif
vec4 l9_27=sc_SampleTextureBiasOrLevel(backgroundFillTextureDims.xy,backgroundFillTextureLayout,l9_26,l9_0,(int(SC_USE_UV_TRANSFORM_backgroundFillTexture)!=0),backgroundFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture,SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture),(int(SC_USE_UV_MIN_MAX_backgroundFillTexture)!=0),backgroundFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_backgroundFillTexture)!=0),backgroundFillTextureBorderColor,0.0,backgroundFillTexture);
float l9_28=l9_27.w*l9_24;
sc_writeFragData0(vec4(l9_27.xyz*l9_28,l9_28));
}
#endif
}
#endif
return;
}
}
#endif
if (isPass(0.1,varPassIdentifier))
{
int l9_29;
#if (colorTextureHasSwappedViews)
{
l9_29=1-sc_GetStereoViewIndex();
}
#else
{
l9_29=sc_GetStereoViewIndex();
}
#endif
vec4 l9_30=sc_SampleTextureBiasOrLevel(colorTextureDims.xy,colorTextureLayout,l9_29,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_colorTexture)!=0),colorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_colorTexture,SC_SOFTWARE_WRAP_MODE_V_colorTexture),(int(SC_USE_UV_MIN_MAX_colorTexture)!=0),colorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_colorTexture)!=0),colorTextureBorderColor,0.0,colorTexture);
float l9_31=l9_30.w*l9_12.w;
sc_writeFragData0(vec4(l9_30.xyz*l9_31,l9_31));
}
else
{
#if (ENABLE_SDF)
{
int l9_32;
#if (mainTextureHasSwappedViews)
{
l9_32=1-sc_GetStereoViewIndex();
}
#else
{
l9_32=sc_GetStereoViewIndex();
}
#endif
float l9_33=l9_12.w*calculateSdfOpacityMultisampled(sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_32,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x,l9_13,multisampleBlend);
sc_writeFragData0(vec4(l9_12.xyz*l9_33,l9_33));
}
#else
{
int l9_34;
#if (mainTextureHasSwappedViews)
{
l9_34=1-sc_GetStereoViewIndex();
}
#else
{
l9_34=sc_GetStereoViewIndex();
}
#endif
float l9_35=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_34,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x*l9_12.w;
sc_writeFragData0(vec4(l9_12.xyz*l9_35,l9_35));
}
#endif
}
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
