#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define sc_TAADisabled 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_taa.glsl>
#ifndef ENABLE_SDF
#define ENABLE_SDF 0
#elif ENABLE_SDF==1
#undef ENABLE_SDF
#define ENABLE_SDF 1
#endif
uniform float textScaledEmHeight;
varying vec4 varSdfParams;
varying vec2 varPassIdDecorThickness;
attribute float passIdentifierAttr;
attribute float sdfOffsetAttr;
attribute float decorThicknessRatioAttr;
varying vec4 varGlyphAtlasUvRect;
attribute vec4 glyphAtlasUvRectAttr;
float calculateFrustumHeightAtVertex(vec3 vertexWorldPos)
{
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
return abs((2.0*(-(sc_ViewMatrixArray[sc_GetStereoViewIndex()]*vec4(vertexWorldPos,1.0)).z))/sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][1].y);
}
else
{
return abs(4.0/sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][1].y);
}
}
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
#if (ENABLE_SDF)
{
float l9_1=calculateFrustumHeightAtVertex((sc_ModelMatrix*vec4(l9_0.position.xyz,1.0)).xyz);
float l9_2=((textScaledEmHeight/l9_1)*sc_CurrentRenderTargetDims.y)/93.0;
mat4 l9_3=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix;
float l9_4=abs(dot(normalize(mat3(l9_3[0].xyz,l9_3[1].xyz,l9_3[2].xyz)*vec3(0.0,0.0,1.0)),vec3(0.0,0.0,-1.0)));
float l9_5;
if (l9_4<0.69999999)
{
l9_5=l9_2*clamp(l9_4,0.11,0.69999999);
}
else
{
l9_5=l9_2;
}
varSdfParams.x=clamp(1.0-((l9_5-0.5)/0.5),0.0,1.0);
varSdfParams.y=clamp((l9_5*31.67)+1.0,1.0,250.0);
varSdfParams.z=clamp(l9_5*15.83,0.0,124.5);
}
#endif
sc_ProcessVertex(l9_0);
varPassIdDecorThickness.x=passIdentifierAttr;
varSdfParams.w=sdfOffsetAttr;
varPassIdDecorThickness.y=decorThicknessRatioAttr;
varGlyphAtlasUvRect=glyphAtlasUvRectAttr;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_taa.glsl>
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
#ifndef ENABLE_SDF
#define ENABLE_SDF 0
#elif ENABLE_SDF==1
#undef ENABLE_SDF
#define ENABLE_SDF 1
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
#ifndef ENABLE_OUTLINE
#define ENABLE_OUTLINE 0
#elif ENABLE_OUTLINE==1
#undef ENABLE_OUTLINE
#define ENABLE_OUTLINE 1
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
uniform vec4 mainFillColorTint;
uniform vec4 shadowColor;
uniform mat3 shadowFillTextureTransform;
uniform vec4 shadowFillTextureUvMinMax;
uniform vec4 shadowFillTextureBorderColor;
uniform vec4 shadowFillColorTint;
uniform vec4 outlineColor;
uniform mat3 outlineFillTextureTransform;
uniform vec4 outlineFillTextureUvMinMax;
uniform vec4 outlineFillTextureBorderColor;
uniform vec4 outlineFillColorTint;
uniform vec2 backgroundSize;
uniform vec4 backgroundColor;
uniform mat3 backgroundFillTextureTransform;
uniform vec4 backgroundFillTextureUvMinMax;
uniform vec4 backgroundFillTextureBorderColor;
uniform vec4 backgroundFillColorTint;
uniform mat3 colorTextureTransform;
uniform vec4 colorTextureUvMinMax;
uniform vec4 colorTextureBorderColor;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2D mainFillTexture;
uniform mediump sampler2D shadowFillTexture;
uniform mediump sampler2D outlineFillTexture;
uniform mediump sampler2D backgroundFillTexture;
uniform mediump sampler2D colorTexture;
varying vec4 varSdfParams;
varying vec4 varGlyphAtlasUvRect;
varying vec2 varPassIdDecorThickness;
float calculateSdfOpacityMultisampled(float dist,float multisampleBlend)
{
float l9_0=dist;
float l9_1=clamp((l9_0*varSdfParams.y)-varSdfParams.z,0.0,1.0);
float l9_2;
if (multisampleBlend>0.0)
{
vec2 l9_3=dFdx(varPackedTex.xy);
vec2 l9_4=dFdy(varPackedTex.xy);
vec2 l9_5=(l9_3+l9_4)*0.35355338;
vec4 l9_6=vec4(clamp(varPackedTex.xy-l9_5,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw),clamp(varPackedTex.xy+l9_5,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw));
int l9_7;
#if (mainTextureHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
vec4 l9_8=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_7,l9_6.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
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
vec4 l9_10=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_9,l9_6.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_11;
#if (mainTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_11,l9_6.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_13;
#if (mainTextureHasSwappedViews)
{
l9_13=1-sc_GetStereoViewIndex();
}
#else
{
l9_13=sc_GetStereoViewIndex();
}
#endif
l9_2=mix(l9_1,((((l9_1+clamp((l9_8.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((l9_10.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((l9_12.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_13,l9_6.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x*varSdfParams.y)-varSdfParams.z,0.0,1.0))*0.2,multisampleBlend);
}
else
{
l9_2=l9_1;
}
return l9_2;
}
float calculateSdfOpacityMultisampledOutline(float dist,float sdfEdge,float multisampleBlend)
{
float l9_0=dist;
float l9_1=sdfEdge;
float l9_2=clamp(((l9_0-l9_1)*varSdfParams.y)+0.5,0.0,1.0);
float l9_3;
if (multisampleBlend>0.0)
{
vec2 l9_4=dFdx(varPackedTex.xy);
vec2 l9_5=dFdy(varPackedTex.xy);
vec2 l9_6=(l9_4+l9_5)*0.35355338;
vec4 l9_7=vec4(clamp(varPackedTex.xy-l9_6,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw),clamp(varPackedTex.xy+l9_6,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw));
int l9_8;
#if (mainTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_8,l9_7.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_10=sdfEdge;
int l9_11;
#if (mainTextureHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_11,l9_7.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_13=sdfEdge;
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
vec4 l9_15=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_14,l9_7.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_16=sdfEdge;
int l9_17;
#if (mainTextureHasSwappedViews)
{
l9_17=1-sc_GetStereoViewIndex();
}
#else
{
l9_17=sc_GetStereoViewIndex();
}
#endif
l9_3=mix(l9_2,((((l9_2+clamp(((l9_9.x-l9_10)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((l9_12.x-l9_13)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((l9_15.x-l9_16)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_17,l9_7.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x-sdfEdge)*varSdfParams.y)+0.5,0.0,1.0))*0.2,multisampleBlend);
}
else
{
l9_3=l9_2;
}
return l9_3;
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
void main()
{
sc_DiscardVelocityAndDepthInMotionVectorPass();
sc_DiscardStereoFragment();
vec2 l9_0=vec2(fract(varPackedTex.z),fract(varPackedTex.w));
int l9_1=int(varPassIdDecorThickness.x+0.5);
bool l9_2=l9_1==1;
vec4 l9_3;
float l9_4;
if ((l9_1==0)||l9_2)
{
float l9_5;
#if (ENABLE_SDF)
{
int l9_6;
#if (mainTextureHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
l9_5=calculateSdfOpacityMultisampled(sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_6,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x,varSdfParams.x);
}
#else
{
l9_5=0.0;
}
#endif
vec4 l9_7;
#if (MAIN_FILL_COLOR)
{
l9_7=mainColor;
}
#else
{
vec4 l9_8;
#if (MAIN_FILL_TEXTURE)
{
int l9_9;
#if (mainFillTextureHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
l9_8=sc_SampleTextureBiasOrLevel(mainFillTextureDims.xy,mainFillTextureLayout,l9_9,l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTexture)*mainFillColorTint;
}
#else
{
l9_8=vec4(1.0);
}
#endif
l9_7=l9_8;
}
#endif
l9_4=l9_5;
l9_3=l9_7;
}
else
{
l9_4=0.0;
l9_3=vec4(1.0);
}
vec4 l9_10;
float l9_11;
#if (ENABLE_SHADOW)
{
vec4 l9_12;
float l9_13;
if (l9_1==2)
{
float l9_14;
#if (ENABLE_SDF)
{
int l9_15;
#if (mainTextureHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
vec4 l9_16=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_15,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_17;
#if (ENABLE_OUTLINE)
{
l9_17=calculateSdfOpacityMultisampledOutline(l9_16.x,0.5-varSdfParams.w,varSdfParams.x);
}
#else
{
l9_17=calculateSdfOpacityMultisampled(l9_16.x,varSdfParams.x);
}
#endif
l9_14=l9_17;
}
#else
{
l9_14=l9_4;
}
#endif
vec4 l9_18;
#if (SHADOW_FILL_COLOR)
{
l9_18=shadowColor;
}
#else
{
vec4 l9_19;
#if (SHADOW_FILL_TEXTURE)
{
int l9_20;
#if (shadowFillTextureHasSwappedViews)
{
l9_20=1-sc_GetStereoViewIndex();
}
#else
{
l9_20=sc_GetStereoViewIndex();
}
#endif
l9_19=sc_SampleTextureBiasOrLevel(shadowFillTextureDims.xy,shadowFillTextureLayout,l9_20,l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTexture)*shadowFillColorTint;
}
#else
{
l9_19=l9_3;
}
#endif
l9_18=l9_19;
}
#endif
l9_13=l9_14;
l9_12=l9_18;
}
else
{
l9_13=l9_4;
l9_12=l9_3;
}
l9_11=l9_13;
l9_10=l9_12;
}
#else
{
l9_11=l9_4;
l9_10=l9_3;
}
#endif
vec4 l9_21;
float l9_22;
#if (ENABLE_OUTLINE)
{
vec4 l9_23;
float l9_24;
if (l9_1==3)
{
float l9_25;
#if (ENABLE_SDF)
{
int l9_26;
#if (mainTextureHasSwappedViews)
{
l9_26=1-sc_GetStereoViewIndex();
}
#else
{
l9_26=sc_GetStereoViewIndex();
}
#endif
l9_25=calculateSdfOpacityMultisampledOutline(sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_26,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x,0.5-varSdfParams.w,varSdfParams.x);
}
#else
{
l9_25=l9_11;
}
#endif
vec4 l9_27;
#if (OUTLINE_FILL_COLOR)
{
l9_27=outlineColor;
}
#else
{
vec4 l9_28;
#if (OUTLINE_FILL_TEXTURE)
{
int l9_29;
#if (outlineFillTextureHasSwappedViews)
{
l9_29=1-sc_GetStereoViewIndex();
}
#else
{
l9_29=sc_GetStereoViewIndex();
}
#endif
l9_28=sc_SampleTextureBiasOrLevel(outlineFillTextureDims.xy,outlineFillTextureLayout,l9_29,l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTexture)*outlineFillColorTint;
}
#else
{
l9_28=l9_10;
}
#endif
l9_27=l9_28;
}
#endif
l9_24=l9_25;
l9_23=l9_27;
}
else
{
l9_24=l9_11;
l9_23=l9_10;
}
l9_22=l9_24;
l9_21=l9_23;
}
#else
{
l9_22=l9_11;
l9_21=l9_10;
}
#endif
#if (ENABLE_BACKGROUND)
{
if (l9_1==4)
{
float l9_30=getCornerFade(vec2(0.0));
float l9_31=getCornerFade(vec2(backgroundSize.x,0.0));
float l9_32=getCornerFade(vec2(backgroundSize.x,backgroundSize.y));
float l9_33=getCornerFade(vec2(0.0,backgroundSize.y));
float l9_34=(((1.0*l9_30)*l9_31)*l9_32)*l9_33;
if (l9_34<0.0049999999)
{
discard;
}
#if (BACKGROUND_FILL_COLOR)
{
float l9_35=backgroundColor.w*l9_34;
sc_writeFragData0(vec4(backgroundColor.xyz*l9_35,l9_35));
}
#else
{
#if (BACKGROUND_FILL_TEXTURE)
{
int l9_36;
#if (backgroundFillTextureHasSwappedViews)
{
l9_36=1-sc_GetStereoViewIndex();
}
#else
{
l9_36=sc_GetStereoViewIndex();
}
#endif
vec4 l9_37=sc_SampleTextureBiasOrLevel(backgroundFillTextureDims.xy,backgroundFillTextureLayout,l9_36,l9_0,(int(SC_USE_UV_TRANSFORM_backgroundFillTexture)!=0),backgroundFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture,SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture),(int(SC_USE_UV_MIN_MAX_backgroundFillTexture)!=0),backgroundFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_backgroundFillTexture)!=0),backgroundFillTextureBorderColor,0.0,backgroundFillTexture)*backgroundFillColorTint;
float l9_38=l9_37.w*l9_34;
sc_writeFragData0(vec4(l9_37.xyz*l9_38,l9_38));
}
#endif
}
#endif
return;
}
}
#endif
bool l9_39=l9_1==6;
bool l9_40=l9_1==7;
if (((l9_1==5)||l9_39)||l9_40)
{
vec4 l9_41;
if (l9_39)
{
vec4 l9_42;
#if (OUTLINE_FILL_COLOR)
{
l9_42=outlineColor;
}
#else
{
vec4 l9_43;
#if (OUTLINE_FILL_TEXTURE)
{
int l9_44;
#if (outlineFillTextureHasSwappedViews)
{
l9_44=1-sc_GetStereoViewIndex();
}
#else
{
l9_44=sc_GetStereoViewIndex();
}
#endif
l9_43=sc_SampleTextureBiasOrLevel(outlineFillTextureDims.xy,outlineFillTextureLayout,l9_44,l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTexture)*outlineFillColorTint;
}
#else
{
l9_43=l9_21;
}
#endif
l9_42=l9_43;
}
#endif
l9_41=l9_42;
}
else
{
vec4 l9_45;
if (l9_40)
{
vec4 l9_46;
#if (SHADOW_FILL_COLOR)
{
l9_46=shadowColor;
}
#else
{
vec4 l9_47;
#if (SHADOW_FILL_TEXTURE)
{
int l9_48;
#if (shadowFillTextureHasSwappedViews)
{
l9_48=1-sc_GetStereoViewIndex();
}
#else
{
l9_48=sc_GetStereoViewIndex();
}
#endif
l9_47=sc_SampleTextureBiasOrLevel(shadowFillTextureDims.xy,shadowFillTextureLayout,l9_48,l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTexture)*shadowFillColorTint;
}
#else
{
l9_47=l9_21;
}
#endif
l9_46=l9_47;
}
#endif
l9_45=l9_46;
}
else
{
vec4 l9_49;
#if (MAIN_FILL_COLOR)
{
l9_49=mainColor;
}
#else
{
vec4 l9_50;
#if (MAIN_FILL_TEXTURE)
{
int l9_51;
#if (mainFillTextureHasSwappedViews)
{
l9_51=1-sc_GetStereoViewIndex();
}
#else
{
l9_51=sc_GetStereoViewIndex();
}
#endif
l9_50=sc_SampleTextureBiasOrLevel(mainFillTextureDims.xy,mainFillTextureLayout,l9_51,l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTexture)*mainFillColorTint;
}
#else
{
l9_50=l9_21;
}
#endif
l9_49=l9_50;
}
#endif
l9_45=l9_49;
}
l9_41=l9_45;
}
float l9_52=abs(varPackedTex.y);
float l9_53=dFdy(varPackedTex.y);
float l9_54;
if (l9_52>varPassIdDecorThickness.y)
{
l9_54=l9_41.w*smoothstep(varPassIdDecorThickness.y+(abs(l9_53)*0.5),varPassIdDecorThickness.y,l9_52);
}
else
{
l9_54=l9_41.w;
}
if (l9_54<0.0099999998)
{
discard;
}
sc_writeFragData0(vec4(l9_41.xyz*l9_54,l9_54));
return;
}
if (l9_2)
{
int l9_55;
#if (colorTextureHasSwappedViews)
{
l9_55=1-sc_GetStereoViewIndex();
}
#else
{
l9_55=sc_GetStereoViewIndex();
}
#endif
vec4 l9_56=sc_SampleTextureBiasOrLevel(colorTextureDims.xy,colorTextureLayout,l9_55,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_colorTexture)!=0),colorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_colorTexture,SC_SOFTWARE_WRAP_MODE_V_colorTexture),(int(SC_USE_UV_MIN_MAX_colorTexture)!=0),colorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_colorTexture)!=0),colorTextureBorderColor,0.0,colorTexture);
float l9_57=l9_56.w*l9_21.w;
sc_writeFragData0(vec4(l9_56.xyz*l9_57,l9_57));
}
else
{
#if (ENABLE_SDF)
{
float l9_58=l9_21.w*l9_22;
sc_writeFragData0(vec4(l9_21.xyz*l9_58,l9_58));
}
#else
{
int l9_59;
#if (mainTextureHasSwappedViews)
{
l9_59=1-sc_GetStereoViewIndex();
}
#else
{
l9_59=sc_GetStereoViewIndex();
}
#endif
float l9_60=sc_SampleTextureLevel(mainTextureDims.xy,mainTextureLayout,l9_59,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture).x*l9_21.w;
sc_writeFragData0(vec4(l9_21.xyz*l9_60,l9_60));
}
#endif
}
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
