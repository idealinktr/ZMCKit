#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//attribute vec2 texture2 18
//sampler sampler bgTextureSmpSC 2:3
//sampler sampler fgAlphaTextureSmpSC 2:4
//sampler sampler fgTextureSmpSC 2:5
//texture texture2D bgTexture 2:0:2:3
//texture texture2D fgAlphaTexture 2:1:2:4
//texture texture2D fgTexture 2:2:2:5
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform mat4 modelView;
varying vec2 varTex2;
attribute vec2 texture2;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(modelView*l9_0.position,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
varTex2=texture2;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef fgTextureHasSwappedViews
#define fgTextureHasSwappedViews 0
#elif fgTextureHasSwappedViews==1
#undef fgTextureHasSwappedViews
#define fgTextureHasSwappedViews 1
#endif
#ifndef fgTextureLayout
#define fgTextureLayout 0
#endif
#ifndef fgAlphaTextureHasSwappedViews
#define fgAlphaTextureHasSwappedViews 0
#elif fgAlphaTextureHasSwappedViews==1
#undef fgAlphaTextureHasSwappedViews
#define fgAlphaTextureHasSwappedViews 1
#endif
#ifndef fgAlphaTextureLayout
#define fgAlphaTextureLayout 0
#endif
#ifndef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 0
#elif bgTextureHasSwappedViews==1
#undef bgTextureHasSwappedViews
#define bgTextureHasSwappedViews 1
#endif
#ifndef bgTextureLayout
#define bgTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_fgTexture
#define SC_USE_UV_TRANSFORM_fgTexture 0
#elif SC_USE_UV_TRANSFORM_fgTexture==1
#undef SC_USE_UV_TRANSFORM_fgTexture
#define SC_USE_UV_TRANSFORM_fgTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_fgTexture
#define SC_SOFTWARE_WRAP_MODE_U_fgTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_fgTexture
#define SC_SOFTWARE_WRAP_MODE_V_fgTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_fgTexture
#define SC_USE_UV_MIN_MAX_fgTexture 0
#elif SC_USE_UV_MIN_MAX_fgTexture==1
#undef SC_USE_UV_MIN_MAX_fgTexture
#define SC_USE_UV_MIN_MAX_fgTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_fgTexture
#define SC_USE_CLAMP_TO_BORDER_fgTexture 0
#elif SC_USE_CLAMP_TO_BORDER_fgTexture==1
#undef SC_USE_CLAMP_TO_BORDER_fgTexture
#define SC_USE_CLAMP_TO_BORDER_fgTexture 1
#endif
#ifndef ALPHA_EXISTS
#define ALPHA_EXISTS 0
#elif ALPHA_EXISTS==1
#undef ALPHA_EXISTS
#define ALPHA_EXISTS 1
#endif
#ifndef SC_USE_UV_TRANSFORM_fgAlphaTexture
#define SC_USE_UV_TRANSFORM_fgAlphaTexture 0
#elif SC_USE_UV_TRANSFORM_fgAlphaTexture==1
#undef SC_USE_UV_TRANSFORM_fgAlphaTexture
#define SC_USE_UV_TRANSFORM_fgAlphaTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture
#define SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture
#define SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_fgAlphaTexture
#define SC_USE_UV_MIN_MAX_fgAlphaTexture 0
#elif SC_USE_UV_MIN_MAX_fgAlphaTexture==1
#undef SC_USE_UV_MIN_MAX_fgAlphaTexture
#define SC_USE_UV_MIN_MAX_fgAlphaTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_fgAlphaTexture
#define SC_USE_CLAMP_TO_BORDER_fgAlphaTexture 0
#elif SC_USE_CLAMP_TO_BORDER_fgAlphaTexture==1
#undef SC_USE_CLAMP_TO_BORDER_fgAlphaTexture
#define SC_USE_CLAMP_TO_BORDER_fgAlphaTexture 1
#endif
#ifndef CUSTOM_BLENDING
#define CUSTOM_BLENDING 0
#elif CUSTOM_BLENDING==1
#undef CUSTOM_BLENDING
#define CUSTOM_BLENDING 1
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
#ifndef NONE_BLENDING
#define NONE_BLENDING 0
#elif NONE_BLENDING==1
#undef NONE_BLENDING
#define NONE_BLENDING 1
#endif
#ifndef MULTIPLY_BLENDING
#define MULTIPLY_BLENDING 0
#elif MULTIPLY_BLENDING==1
#undef MULTIPLY_BLENDING
#define MULTIPLY_BLENDING 1
#endif
#ifndef SCREEN_BLENDING
#define SCREEN_BLENDING 0
#elif SCREEN_BLENDING==1
#undef SCREEN_BLENDING
#define SCREEN_BLENDING 1
#endif
#ifndef LIGHTEN_BLENDING
#define LIGHTEN_BLENDING 0
#elif LIGHTEN_BLENDING==1
#undef LIGHTEN_BLENDING
#define LIGHTEN_BLENDING 1
#endif
#ifndef COLOR_DODGE_BLENDING
#define COLOR_DODGE_BLENDING 0
#elif COLOR_DODGE_BLENDING==1
#undef COLOR_DODGE_BLENDING
#define COLOR_DODGE_BLENDING 1
#endif
#ifndef OVERLAY_BLENDING
#define OVERLAY_BLENDING 0
#elif OVERLAY_BLENDING==1
#undef OVERLAY_BLENDING
#define OVERLAY_BLENDING 1
#endif
#ifndef SOFT_LIGHT_BLENDING
#define SOFT_LIGHT_BLENDING 0
#elif SOFT_LIGHT_BLENDING==1
#undef SOFT_LIGHT_BLENDING
#define SOFT_LIGHT_BLENDING 1
#endif
#ifndef ADDITION_BLENDING
#define ADDITION_BLENDING 0
#elif ADDITION_BLENDING==1
#undef ADDITION_BLENDING
#define ADDITION_BLENDING 1
#endif
#ifndef VIVID_LIGHT_BLENDING
#define VIVID_LIGHT_BLENDING 0
#elif VIVID_LIGHT_BLENDING==1
#undef VIVID_LIGHT_BLENDING
#define VIVID_LIGHT_BLENDING 1
#endif
#ifndef LINEAR_LIGHT_BLENDING
#define LINEAR_LIGHT_BLENDING 0
#elif LINEAR_LIGHT_BLENDING==1
#undef LINEAR_LIGHT_BLENDING
#define LINEAR_LIGHT_BLENDING 1
#endif
#ifndef HARD_LIGHT_BLENDING
#define HARD_LIGHT_BLENDING 0
#elif HARD_LIGHT_BLENDING==1
#undef HARD_LIGHT_BLENDING
#define HARD_LIGHT_BLENDING 1
#endif
uniform vec4 fgTextureDims;
uniform vec4 fgAlphaTextureDims;
uniform vec4 bgTextureDims;
uniform mat3 fgTextureTransform;
uniform vec4 fgTextureUvMinMax;
uniform vec4 fgTextureBorderColor;
uniform mat3 fgAlphaTextureTransform;
uniform vec4 fgAlphaTextureUvMinMax;
uniform vec4 fgAlphaTextureBorderColor;
uniform float opacity;
uniform mat3 bgTextureTransform;
uniform vec4 bgTextureUvMinMax;
uniform vec4 bgTextureBorderColor;
uniform mediump sampler2D fgTexture;
uniform mediump sampler2D fgAlphaTexture;
uniform mediump sampler2D bgTexture;
varying vec2 varTex2;
void main()
{
int l9_0;
#if (fgTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(fgTextureDims.xy,fgTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_fgTexture)!=0),fgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgTexture,SC_SOFTWARE_WRAP_MODE_V_fgTexture),(int(SC_USE_UV_MIN_MAX_fgTexture)!=0),fgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgTexture)!=0),fgTextureBorderColor,0.0,fgTexture);
vec3 l9_2=l9_1.xyz;
vec3 fg=l9_2;
float l9_3;
#if (ALPHA_EXISTS)
{
int l9_4;
#if (fgAlphaTextureHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
l9_3=sc_SampleTextureBiasOrLevel(fgAlphaTextureDims.xy,fgAlphaTextureLayout,l9_4,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_fgAlphaTexture)!=0),fgAlphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture,SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture),(int(SC_USE_UV_MIN_MAX_fgAlphaTexture)!=0),fgAlphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgAlphaTexture)!=0),fgAlphaTextureBorderColor,0.0,fgAlphaTexture).x;
}
#else
{
l9_3=l9_1.w;
}
#endif
float l9_5=l9_3*opacity;
vec4 l9_6;
#if (CUSTOM_BLENDING)
{
int l9_7;
#if (bgTextureHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
vec4 l9_8=sc_SampleTextureBiasOrLevel(bgTextureDims.xy,bgTextureLayout,l9_7,varTex2,(int(SC_USE_UV_TRANSFORM_bgTexture)!=0),bgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTexture,SC_SOFTWARE_WRAP_MODE_V_bgTexture),(int(SC_USE_UV_MIN_MAX_bgTexture)!=0),bgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTexture)!=0),bgTextureBorderColor,0.0,bgTexture);
vec3 l9_9=l9_8.xyz;
vec3 bg=l9_9;
vec4 l9_10;
#if (NONE_BLENDING)
{
l9_10=vec4(mix(l9_9,l9_2,vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_11;
#if (MULTIPLY_BLENDING)
{
l9_11=vec4(mix(l9_9,l9_9*l9_2,vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_12;
#if (SCREEN_BLENDING)
{
l9_12=vec4(mix(l9_9,vec3(1.0)-((vec3(1.0)-l9_9)*(vec3(1.0)-l9_2)),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_13;
#if (LIGHTEN_BLENDING)
{
l9_13=vec4(mix(l9_9,max(l9_9,l9_2),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_14;
#if (COLOR_DODGE_BLENDING)
{
l9_14=vec4(mix(l9_9,l9_9/((vec3(1.0)-l9_2)+vec3(0.0099999998)),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_15;
#if (OVERLAY_BLENDING)
{
l9_15=vec4(mix(l9_9,mix(vec3(1.0)-(((vec3(1.0)-l9_9)*2.0)*(vec3(1.0)-l9_2)),(l9_9*2.0)*l9_2,step(l9_9,vec3(0.5))),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_16;
#if (SOFT_LIGHT_BLENDING)
{
vec3 l9_17=l9_2*2.0;
l9_16=vec4(mix(l9_9,(((max(vec3(1.0)-l9_17,vec3(0.0))*l9_9)*l9_9)+((min(l9_2,vec3(1.0)-l9_2)*2.0)*l9_9))+(max(l9_17-vec3(1.0),vec3(0.0))*sqrt(l9_9)),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_18;
#if (ADDITION_BLENDING)
{
l9_18=vec4(mix(l9_9,min(l9_9+l9_2,vec3(1.0)),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_19;
#if (VIVID_LIGHT_BLENDING)
{
vec3 blendColor;
int l9_20=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_20<3)
{
if (fg[l9_20]>0.5)
{
blendColor[l9_20]=bg[l9_20]/((2.0*(1.0-fg[l9_20]))+0.0039215689);
}
else
{
blendColor[l9_20]=1.0-((1.0-bg[l9_20])/((2.0*fg[l9_20])+0.0039215689));
}
l9_20++;
continue;
}
else
{
break;
}
}
l9_19=vec4(mix(l9_9,blendColor,vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_21;
#if (LINEAR_LIGHT_BLENDING)
{
l9_21=vec4(mix(l9_9,(l9_9+(l9_2*2.0))-vec3(1.0),vec3(l9_5)),l9_5);
}
#else
{
vec4 l9_22;
#if (HARD_LIGHT_BLENDING)
{
l9_22=vec4(mix(l9_9,mix(vec3(1.0)-(((vec3(1.0)-l9_9)*2.0)*(vec3(1.0)-l9_2)),(l9_9*2.0)*l9_2,step(l9_2,vec3(0.5))),vec3(l9_5)),l9_5);
}
#else
{
l9_22=vec4(0.0);
}
#endif
l9_21=l9_22;
}
#endif
l9_19=l9_21;
}
#endif
l9_18=l9_19;
}
#endif
l9_16=l9_18;
}
#endif
l9_15=l9_16;
}
#endif
l9_14=l9_15;
}
#endif
l9_13=l9_14;
}
#endif
l9_12=l9_13;
}
#endif
l9_11=l9_12;
}
#endif
l9_10=l9_11;
}
#endif
l9_6=l9_10;
}
#else
{
l9_6=vec4(l9_1.xyz,l9_5);
}
#endif
sc_writeFragData0(l9_6);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
