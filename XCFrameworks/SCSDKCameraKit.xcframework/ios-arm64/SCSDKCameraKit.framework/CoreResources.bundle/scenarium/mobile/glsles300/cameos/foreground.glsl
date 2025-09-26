#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec2 texture2 5
//attribute vec3 normal 1
//attribute vec4 tangent 2
//sampler sampler bgTextureSmpSC 0:9
//sampler sampler fgAlphaTextureSmpSC 0:10
//sampler sampler fgTextureSmpSC 0:11
//texture texture2D bgTexture 0:0:0:9
//texture texture2D fgAlphaTexture 0:1:0:10
//texture texture2D fgTexture 0:2:0:11
//texture texture2DArray bgTextureArrSC 0:18:0:9
//texture texture2DArray fgAlphaTextureArrSC 0:19:0:10
//texture texture2DArray fgTextureArrSC 0:20:0:11
//spec_const bool ADDITION_BLENDING 0 0
//spec_const bool ALPHA_EXISTS 1 0
//spec_const bool COLOR_DODGE_BLENDING 2 0
//spec_const bool CUSTOM_BLENDING 3 0
//spec_const bool HARD_LIGHT_BLENDING 4 0
//spec_const bool LIGHTEN_BLENDING 5 0
//spec_const bool LINEAR_LIGHT_BLENDING 6 0
//spec_const bool MULTIPLY_BLENDING 7 0
//spec_const bool NONE_BLENDING 8 0
//spec_const bool OVERLAY_BLENDING 9 0
//spec_const bool SCREEN_BLENDING 10 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_bgTexture 11 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_fgAlphaTexture 12 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_fgTexture 13 0
//spec_const bool SC_USE_UV_MIN_MAX_bgTexture 14 0
//spec_const bool SC_USE_UV_MIN_MAX_fgAlphaTexture 15 0
//spec_const bool SC_USE_UV_MIN_MAX_fgTexture 16 0
//spec_const bool SC_USE_UV_TRANSFORM_bgTexture 17 0
//spec_const bool SC_USE_UV_TRANSFORM_fgAlphaTexture 18 0
//spec_const bool SC_USE_UV_TRANSFORM_fgTexture 19 0
//spec_const bool SOFT_LIGHT_BLENDING 20 0
//spec_const bool VIVID_LIGHT_BLENDING 21 0
//spec_const bool bgTextureHasSwappedViews 22 0
//spec_const bool fgAlphaTextureHasSwappedViews 23 0
//spec_const bool fgTextureHasSwappedViews 24 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_bgTexture 25 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture 26 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_fgTexture 27 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_bgTexture 28 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture 29 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_fgTexture 30 -1
//spec_const int bgTextureLayout 31 0
//spec_const int fgAlphaTextureLayout 32 0
//spec_const int fgTextureLayout 33 0
//spec_const int sc_ShaderCacheConstant 34 0
//spec_const int sc_StereoRenderingMode 35 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 36 0
//spec_const int sc_StereoViewID 37 0
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define sc_StereoRendering_Disabled 0
#define sc_StereoRendering_InstancedClipped 1
#define sc_StereoRendering_Multiview 2
#ifdef VERTEX_SHADER
#define scOutPos(clipPosition) gl_Position=clipPosition
#define MAIN main
#endif
#ifdef SC_ENABLE_INSTANCED_RENDERING
#ifndef sc_EnableInstancing
#define sc_EnableInstancing 1
#endif
#endif
#define mod(x,y) (x-y*floor((x+1e-6)/y))
#if __VERSION__<300
#define isinf(x) (x!=0.0&&x*2.0==x ? true : false)
#define isnan(x) (x>0.0||x<0.0||x==0.0 ? false : true)
#define inverse(M) M
#endif
#ifdef sc_EnableStereoClipDistance
#if defined(GL_APPLE_clip_distance)
#extension GL_APPLE_clip_distance : require
#elif defined(GL_EXT_clip_cull_distance)
#extension GL_EXT_clip_cull_distance : require
#else
#error Clip distance is requested but not supported by this device.
#endif
#endif
#ifdef sc_EnableMultiviewStereoRendering
#define sc_StereoRenderingMode sc_StereoRendering_Multiview
#define sc_NumStereoViews 2
#extension GL_OVR_multiview2 : require
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID sc_GlobalInstanceID
#define sc_StereoViewID int(gl_ViewID_OVR)
#endif
#elif defined(sc_EnableInstancedClippedStereoRendering)
#ifndef sc_EnableInstancing
#error Instanced-clipped stereo rendering requires enabled instancing.
#endif
#ifndef sc_EnableStereoClipDistance
#define sc_StereoRendering_IsClipDistanceEnabled 0
#else
#define sc_StereoRendering_IsClipDistanceEnabled 1
#endif
#define sc_StereoRenderingMode sc_StereoRendering_InstancedClipped
#define sc_NumStereoClipPlanes 1
#define sc_NumStereoViews 2
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID (sc_GlobalInstanceID/2)
#define sc_StereoViewID (sc_GlobalInstanceID%2)
#endif
#else
#define sc_StereoRenderingMode sc_StereoRendering_Disabled
#endif
#if defined(sc_EnableInstancing)&&defined(VERTEX_SHADER)
#ifdef GL_ARB_draw_instanced
#extension GL_ARB_draw_instanced : require
#define gl_InstanceID gl_InstanceIDARB
#endif
#ifdef GL_EXT_draw_instanced
#extension GL_EXT_draw_instanced : require
#define gl_InstanceID gl_InstanceIDEXT
#endif
#ifndef sc_InstanceID
#define sc_InstanceID gl_InstanceID
#endif
#ifndef sc_GlobalInstanceID
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID)
#define sc_LocalInstanceID (sc_FallbackInstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#define sc_LocalInstanceID gl_InstanceID
#endif
#endif
#endif
#ifndef GL_ES
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable
#define precision
#define lowp
#define mediump
#define highp
#define sc_FragmentPrecision
#endif
#ifdef GL_ES
#ifdef sc_FramebufferFetch
#if defined(GL_EXT_shader_framebuffer_fetch)
#extension GL_EXT_shader_framebuffer_fetch : require
#elif defined(GL_ARM_shader_framebuffer_fetch)
#extension GL_ARM_shader_framebuffer_fetch : require
#else
#error Framebuffer fetch is requested but not supported by this device.
#endif
#endif
#ifdef GL_FRAGMENT_PRECISION_HIGH
#define sc_FragmentPrecision highp
#else
#define sc_FragmentPrecision mediump
#endif
#ifdef FRAGMENT_SHADER
precision highp int;
precision highp float;
#endif
#endif
#ifdef VERTEX_SHADER
#ifdef sc_EnableMultiviewStereoRendering
layout(num_views=sc_NumStereoViews) in;
#endif
#endif
#define SC_INT_FALLBACK_FLOAT int
#define SC_INTERPOLATION_FLAT flat
#define SC_INTERPOLATION_CENTROID centroid
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_TextureRenderingLayout_Regular
#define sc_TextureRenderingLayout_Regular 0
#define sc_TextureRenderingLayout_StereoInstancedClipped 1
#define sc_TextureRenderingLayout_StereoMultiview 2
#endif
#if defined VERTEX_SHADER
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 modelView;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec2 texture0;
in vec2 texture1;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varTex2;
in vec2 texture2;
out vec4 varTangent;
out vec2 varShadowTex;
in vec3 normal;
in vec4 tangent;
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=sc_StereoViewID;
}
#endif
return l9_0;
}
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
vec4 l9_0=modelView*position;
vec4 l9_1;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_2=l9_0;
l9_2.y=(l9_0.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_1=l9_2;
}
#else
{
l9_1=l9_0;
}
#endif
varPosAndMotion=vec4(l9_1.x,l9_1.y,l9_1.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varTex01=vec4(varTex01.x,varTex01.y,texture1.x,texture1.y);
varScreenPos=l9_1;
vec2 l9_3=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
vec2 l9_4;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_5=vec3(l9_3,0.0);
l9_5.y=((2.0*l9_3.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_4=l9_5.xy;
}
#else
{
l9_4=l9_3;
}
#endif
varScreenTexturePos=l9_4;
vec4 l9_6=l9_1*1.0;
vec4 l9_7;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_8=l9_6;
l9_8.x=l9_6.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_7=l9_8;
}
#else
{
l9_7=l9_6;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_9=dot(l9_7,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_9);
}
#else
{
varClipDistance=l9_9;
}
#endif
}
#endif
gl_Position=l9_7;
varTex2=texture2;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#if defined(GL_ES)||__VERSION__>=420
#if sc_FragDataCount>=1
#define sc_DeclareFragData0(StorageQualifier) layout(location=0) StorageQualifier sc_FragmentPrecision vec4 sc_FragData0
#endif
#if sc_FragDataCount>=2
#define sc_DeclareFragData1(StorageQualifier) layout(location=1) StorageQualifier sc_FragmentPrecision vec4 sc_FragData1
#endif
#if sc_FragDataCount>=3
#define sc_DeclareFragData2(StorageQualifier) layout(location=2) StorageQualifier sc_FragmentPrecision vec4 sc_FragData2
#endif
#if sc_FragDataCount>=4
#define sc_DeclareFragData3(StorageQualifier) layout(location=3) StorageQualifier sc_FragmentPrecision vec4 sc_FragData3
#endif
#ifndef sc_DeclareFragData0
#define sc_DeclareFragData0(_) const vec4 sc_FragData0=vec4(0.0)
#endif
#ifndef sc_DeclareFragData1
#define sc_DeclareFragData1(_) const vec4 sc_FragData1=vec4(0.0)
#endif
#ifndef sc_DeclareFragData2
#define sc_DeclareFragData2(_) const vec4 sc_FragData2=vec4(0.0)
#endif
#ifndef sc_DeclareFragData3
#define sc_DeclareFragData3(_) const vec4 sc_FragData3=vec4(0.0)
#endif
#if sc_FramebufferFetch
#ifdef GL_EXT_shader_framebuffer_fetch
sc_DeclareFragData0(inout);
sc_DeclareFragData1(inout);
sc_DeclareFragData2(inout);
sc_DeclareFragData3(inout);
mediump mat4 getFragData() { return mat4(sc_FragData0,sc_FragData1,sc_FragData2,sc_FragData3); }
#define gl_LastFragData (getFragData())
#elif defined(GL_ARM_shader_framebuffer_fetch)
sc_DeclareFragData0(out);
sc_DeclareFragData1(out);
sc_DeclareFragData2(out);
sc_DeclareFragData3(out);
mediump mat4 getFragData() { return mat4(gl_LastFragColorARM,vec4(0.0),vec4(0.0),vec4(0.0)); }
#define gl_LastFragData (getFragData())
#endif
#else
sc_DeclareFragData0(out);
sc_DeclareFragData1(out);
sc_DeclareFragData2(out);
sc_DeclareFragData3(out);
mediump mat4 getFragData() { return mat4(vec4(0.0),vec4(0.0),vec4(0.0),vec4(0.0)); }
#define gl_LastFragData (getFragData())
#endif
#else
#ifdef FRAGMENT_SHADER
#define sc_FragData0 gl_FragData[0]
#define sc_FragData1 gl_FragData[1]
#define sc_FragData2 gl_FragData[2]
#define sc_FragData3 gl_FragData[3]
#endif
mat4 getFragData() { return mat4(vec4(0.0),vec4(0.0),vec4(0.0),vec4(0.0)); }
#define gl_LastFragData (getFragData())
#if sc_FramebufferFetch
#error Framebuffer fetch is requested but not supported by this device.
#endif
#endif
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
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
uniform vec4 sc_UniformConstants;
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
uniform mediump sampler2DArray fgTextureArrSC;
uniform mediump sampler2D fgTexture;
uniform mediump sampler2DArray fgAlphaTextureArrSC;
uniform mediump sampler2D fgAlphaTexture;
uniform mediump sampler2DArray bgTextureArrSC;
uniform mediump sampler2D bgTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
in vec2 varTex2;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=varStereoViewID;
}
#endif
return l9_0;
}
int fgTextureGetStereoViewIndex()
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
return l9_0;
}
void sc_SoftwareWrapEarly(inout float uv,int softwareWrapMode)
{
if (softwareWrapMode==1)
{
uv=fract(uv);
}
else
{
if (softwareWrapMode==2)
{
float l9_0=fract(uv);
uv=mix(l9_0,1.0-l9_0,clamp(step(0.25,fract((uv-l9_0)*0.5)),0.0,1.0));
}
}
}
void sc_ClampUV(inout float value,float minValue,float maxValue,bool useClampToBorder,inout float clampToBorderFactor)
{
float l9_0=clamp(value,minValue,maxValue);
float l9_1=step(abs(value-l9_0),9.9999997e-06);
clampToBorderFactor*=(l9_1+((1.0-float(useClampToBorder))*(1.0-l9_1)));
value=l9_0;
}
vec2 sc_TransformUV(vec2 uv,bool useUvTransform,mat3 uvTransform)
{
if (useUvTransform)
{
uv=vec2((uvTransform*vec3(uv,1.0)).xy);
}
return uv;
}
void sc_SoftwareWrapLate(inout float uv,int softwareWrapMode,bool useClampToBorder,inout float clampToBorderFactor)
{
if ((softwareWrapMode==0)||(softwareWrapMode==3))
{
sc_ClampUV(uv,0.0,1.0,useClampToBorder,clampToBorderFactor);
}
}
vec3 sc_SamplingCoordsViewToGlobal(vec2 uv,int renderingLayout,int viewIndex)
{
vec3 l9_0;
if (renderingLayout==0)
{
l9_0=vec3(uv,0.0);
}
else
{
vec3 l9_1;
if (renderingLayout==1)
{
l9_1=vec3(uv.x,(uv.y*0.5)+(0.5-(float(viewIndex)*0.5)),0.0);
}
else
{
l9_1=vec3(uv,float(viewIndex));
}
l9_0=l9_1;
}
return l9_0;
}
vec4 sc_SampleTextureBias(int renderingLayout,int viewIndex,vec2 uv,bool useUvTransform,mat3 uvTransform,ivec2 softwareWrapModes,bool useUvMinMax,vec4 uvMinMax,bool useClampToBorder,vec4 borderColor,float bias,highp sampler2DArray texture_sampler_)
{
bool l9_0=useClampToBorder;
bool l9_1=useUvMinMax;
bool l9_2=l9_0&&(!l9_1);
sc_SoftwareWrapEarly(uv.x,softwareWrapModes.x);
sc_SoftwareWrapEarly(uv.y,softwareWrapModes.y);
float l9_3;
if (useUvMinMax)
{
bool l9_4=useClampToBorder;
bool l9_5;
if (l9_4)
{
l9_5=softwareWrapModes.x==3;
}
else
{
l9_5=l9_4;
}
float param_8=1.0;
sc_ClampUV(uv.x,uvMinMax.x,uvMinMax.z,l9_5,param_8);
float l9_6=param_8;
bool l9_7=useClampToBorder;
bool l9_8;
if (l9_7)
{
l9_8=softwareWrapModes.y==3;
}
else
{
l9_8=l9_7;
}
float param_13=l9_6;
sc_ClampUV(uv.y,uvMinMax.y,uvMinMax.w,l9_8,param_13);
l9_3=param_13;
}
else
{
l9_3=1.0;
}
uv=sc_TransformUV(uv,useUvTransform,uvTransform);
float param_20=l9_3;
sc_SoftwareWrapLate(uv.x,softwareWrapModes.x,l9_2,param_20);
sc_SoftwareWrapLate(uv.y,softwareWrapModes.y,l9_2,param_20);
float l9_9=param_20;
float l9_10=bias;
vec3 l9_11=sc_SamplingCoordsViewToGlobal(uv,renderingLayout,viewIndex);
vec4 l9_12=texture(texture_sampler_,l9_11,l9_10);
vec4 l9_13;
if (useClampToBorder)
{
l9_13=mix(borderColor,l9_12,vec4(l9_9));
}
else
{
l9_13=l9_12;
}
return l9_13;
}
vec4 sc_SampleView(vec2 uv,int renderingLayout,int viewIndex,float bias,highp sampler2D texsmp)
{
return texture(texsmp,sc_SamplingCoordsViewToGlobal(uv,renderingLayout,viewIndex).xy,bias);
}
vec4 sc_SampleTextureBias(int renderingLayout,int viewIndex,vec2 uv,bool useUvTransform,mat3 uvTransform,ivec2 softwareWrapModes,bool useUvMinMax,vec4 uvMinMax,bool useClampToBorder,vec4 borderColor,float bias,highp sampler2D texture_sampler_)
{
bool l9_0=useClampToBorder;
bool l9_1=useUvMinMax;
bool l9_2=l9_0&&(!l9_1);
sc_SoftwareWrapEarly(uv.x,softwareWrapModes.x);
sc_SoftwareWrapEarly(uv.y,softwareWrapModes.y);
float l9_3;
if (useUvMinMax)
{
bool l9_4=useClampToBorder;
bool l9_5;
if (l9_4)
{
l9_5=softwareWrapModes.x==3;
}
else
{
l9_5=l9_4;
}
float param_8=1.0;
sc_ClampUV(uv.x,uvMinMax.x,uvMinMax.z,l9_5,param_8);
float l9_6=param_8;
bool l9_7=useClampToBorder;
bool l9_8;
if (l9_7)
{
l9_8=softwareWrapModes.y==3;
}
else
{
l9_8=l9_7;
}
float param_13=l9_6;
sc_ClampUV(uv.y,uvMinMax.y,uvMinMax.w,l9_8,param_13);
l9_3=param_13;
}
else
{
l9_3=1.0;
}
uv=sc_TransformUV(uv,useUvTransform,uvTransform);
float param_20=l9_3;
sc_SoftwareWrapLate(uv.x,softwareWrapModes.x,l9_2,param_20);
sc_SoftwareWrapLate(uv.y,softwareWrapModes.y,l9_2,param_20);
float l9_9=param_20;
vec4 l9_10=sc_SampleView(uv,renderingLayout,viewIndex,bias,texture_sampler_);
vec4 l9_11;
if (useClampToBorder)
{
l9_11=mix(borderColor,l9_10,vec4(l9_9));
}
else
{
l9_11=l9_10;
}
return l9_11;
}
int fgAlphaTextureGetStereoViewIndex()
{
int l9_0;
#if (fgAlphaTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
int bgTextureGetStereoViewIndex()
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
return l9_0;
}
void sc_writeFragData0Internal(vec4 col,float zero,int cacheConst)
{
col.x+=zero*float(cacheConst);
sc_FragData0=col;
}
void main()
{
vec4 l9_0;
#if (fgTextureLayout==2)
{
l9_0=sc_SampleTextureBias(fgTextureLayout,fgTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_fgTexture)!=0),fgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgTexture,SC_SOFTWARE_WRAP_MODE_V_fgTexture),(int(SC_USE_UV_MIN_MAX_fgTexture)!=0),fgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgTexture)!=0),fgTextureBorderColor,0.0,fgTextureArrSC);
}
#else
{
l9_0=sc_SampleTextureBias(fgTextureLayout,fgTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_fgTexture)!=0),fgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgTexture,SC_SOFTWARE_WRAP_MODE_V_fgTexture),(int(SC_USE_UV_MIN_MAX_fgTexture)!=0),fgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgTexture)!=0),fgTextureBorderColor,0.0,fgTexture);
}
#endif
vec3 fg=l9_0.xyz;
float l9_1;
#if (ALPHA_EXISTS)
{
vec4 l9_2;
#if (fgAlphaTextureLayout==2)
{
l9_2=sc_SampleTextureBias(fgAlphaTextureLayout,fgAlphaTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_fgAlphaTexture)!=0),fgAlphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture,SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture),(int(SC_USE_UV_MIN_MAX_fgAlphaTexture)!=0),fgAlphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgAlphaTexture)!=0),fgAlphaTextureBorderColor,0.0,fgAlphaTextureArrSC);
}
#else
{
l9_2=sc_SampleTextureBias(fgAlphaTextureLayout,fgAlphaTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_fgAlphaTexture)!=0),fgAlphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_fgAlphaTexture,SC_SOFTWARE_WRAP_MODE_V_fgAlphaTexture),(int(SC_USE_UV_MIN_MAX_fgAlphaTexture)!=0),fgAlphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_fgAlphaTexture)!=0),fgAlphaTextureBorderColor,0.0,fgAlphaTexture);
}
#endif
l9_1=l9_2.x;
}
#else
{
l9_1=l9_0.w;
}
#endif
float l9_3=l9_1*opacity;
vec4 l9_4;
#if (CUSTOM_BLENDING)
{
vec4 l9_5;
#if (bgTextureLayout==2)
{
l9_5=sc_SampleTextureBias(bgTextureLayout,bgTextureGetStereoViewIndex(),varTex2,(int(SC_USE_UV_TRANSFORM_bgTexture)!=0),bgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTexture,SC_SOFTWARE_WRAP_MODE_V_bgTexture),(int(SC_USE_UV_MIN_MAX_bgTexture)!=0),bgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTexture)!=0),bgTextureBorderColor,0.0,bgTextureArrSC);
}
#else
{
l9_5=sc_SampleTextureBias(bgTextureLayout,bgTextureGetStereoViewIndex(),varTex2,(int(SC_USE_UV_TRANSFORM_bgTexture)!=0),bgTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_bgTexture,SC_SOFTWARE_WRAP_MODE_V_bgTexture),(int(SC_USE_UV_MIN_MAX_bgTexture)!=0),bgTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_bgTexture)!=0),bgTextureBorderColor,0.0,bgTexture);
}
#endif
vec3 bg=l9_5.xyz;
vec4 l9_6;
#if (NONE_BLENDING)
{
l9_6=vec4(mix(l9_5.xyz,l9_0.xyz,vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_7;
#if (MULTIPLY_BLENDING)
{
l9_7=vec4(mix(l9_5.xyz,l9_5.xyz*l9_0.xyz,vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_8;
#if (SCREEN_BLENDING)
{
l9_8=vec4(mix(l9_5.xyz,vec3(1.0)-((vec3(1.0)-l9_5.xyz)*(vec3(1.0)-l9_0.xyz)),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_9;
#if (LIGHTEN_BLENDING)
{
l9_9=vec4(mix(l9_5.xyz,max(l9_5.xyz,l9_0.xyz),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_10;
#if (COLOR_DODGE_BLENDING)
{
l9_10=vec4(mix(l9_5.xyz,l9_5.xyz/((vec3(1.0)-l9_0.xyz)+vec3(0.0099999998)),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_11;
#if (OVERLAY_BLENDING)
{
l9_11=vec4(mix(l9_5.xyz,mix(vec3(1.0)-(((vec3(1.0)-l9_5.xyz)*2.0)*(vec3(1.0)-l9_0.xyz)),(l9_5.xyz*2.0)*l9_0.xyz,step(l9_5.xyz,vec3(0.5))),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_12;
#if (SOFT_LIGHT_BLENDING)
{
vec3 l9_13=l9_0.xyz*2.0;
l9_12=vec4(mix(l9_5.xyz,(((max(vec3(1.0)-l9_13,vec3(0.0))*l9_5.xyz)*l9_5.xyz)+((min(l9_0.xyz,vec3(1.0)-l9_0.xyz)*2.0)*l9_5.xyz))+(max(l9_13-vec3(1.0),vec3(0.0))*sqrt(l9_5.xyz)),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_14;
#if (ADDITION_BLENDING)
{
l9_14=vec4(mix(l9_5.xyz,min(l9_5.xyz+l9_0.xyz,vec3(1.0)),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_15;
#if (VIVID_LIGHT_BLENDING)
{
vec3 blendColor=vec3(0.0);
int l9_16=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_16<3)
{
if (fg[l9_16]>0.5)
{
blendColor[l9_16]=bg[l9_16]/((2.0*(1.0-fg[l9_16]))+0.0039215689);
}
else
{
blendColor[l9_16]=1.0-((1.0-bg[l9_16])/((2.0*fg[l9_16])+0.0039215689));
}
l9_16++;
continue;
}
else
{
break;
}
}
l9_15=vec4(mix(l9_5.xyz,blendColor,vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_17;
#if (LINEAR_LIGHT_BLENDING)
{
l9_17=vec4(mix(l9_5.xyz,(l9_5.xyz+(l9_0.xyz*2.0))-vec3(1.0),vec3(l9_3)),l9_3);
}
#else
{
vec4 l9_18;
#if (HARD_LIGHT_BLENDING)
{
l9_18=vec4(mix(l9_5.xyz,mix(vec3(1.0)-(((vec3(1.0)-l9_5.xyz)*2.0)*(vec3(1.0)-l9_0.xyz)),(l9_5.xyz*2.0)*l9_0.xyz,step(l9_0.xyz,vec3(0.5))),vec3(l9_3)),l9_3);
}
#else
{
l9_18=vec4(0.0);
}
#endif
l9_17=l9_18;
}
#endif
l9_15=l9_17;
}
#endif
l9_14=l9_15;
}
#endif
l9_12=l9_14;
}
#endif
l9_11=l9_12;
}
#endif
l9_10=l9_11;
}
#endif
l9_9=l9_10;
}
#endif
l9_8=l9_9;
}
#endif
l9_7=l9_8;
}
#endif
l9_6=l9_7;
}
#endif
l9_4=l9_6;
}
#else
{
l9_4=vec4(l9_0.xyz,l9_3);
}
#endif
sc_writeFragData0Internal(l9_4,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
