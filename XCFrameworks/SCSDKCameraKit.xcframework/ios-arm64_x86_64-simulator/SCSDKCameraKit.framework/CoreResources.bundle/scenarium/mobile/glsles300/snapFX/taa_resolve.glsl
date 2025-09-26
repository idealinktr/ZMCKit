#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler sc_TAAColorTextureSmpSC 0:16
//sampler sampler sc_TAAHistoryTextureSmpSC 0:18
//sampler sampler sc_TAAMotionVectorTextureSmpSC 0:19
//texture texture2D sc_TAAColorTexture 0:6:0:16
//texture texture2D sc_TAAHistoryTexture 0:8:0:18
//texture texture2D sc_TAAMotionVectorTexture 0:9:0:19
//texture texture2DArray sc_TAAColorTextureArrSC 0:23:0:16
//texture texture2DArray sc_TAAHistoryTextureArrSC 0:25:0:18
//texture texture2DArray sc_TAAMotionVectorTextureArrSC 0:26:0:19
//spec_const bool DO_BLIT 0 0
//spec_const bool ENABLE_COLOR_CLAMPING 1 1
//spec_const bool ENABLE_VELOCITY_DILATION 2 1
//spec_const bool SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 3 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 4 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 5 0
//spec_const bool SC_USE_UV_MIN_MAX_sc_TAAColorTexture 6 0
//spec_const bool SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 7 0
//spec_const bool SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 8 0
//spec_const bool SC_USE_UV_TRANSFORM_sc_TAAColorTexture 9 0
//spec_const bool SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 10 0
//spec_const bool SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 11 0
//spec_const bool sc_TAAColorTextureHasSwappedViews 12 0
//spec_const bool sc_TAAHistoryTextureHasSwappedViews 13 0
//spec_const bool sc_TAAMotionVectorTextureHasSwappedViews 14 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture 15 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture 16 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture 17 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture 18 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture 19 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture 20 -1
//spec_const int sc_ShaderCacheConstant 21 0
//spec_const int sc_StereoRenderingMode 22 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 23 0
//spec_const int sc_StereoViewID 24 0
//spec_const int sc_TAAColorTextureLayout 25 0
//spec_const int sc_TAAHistoryTextureLayout 26 0
//spec_const int sc_TAAMotionVectorTextureLayout 27 0
//SG_REFLECTION_END
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
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec2 texture0;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varTangent;
out vec2 varShadowTex;
in vec3 normal;
in vec4 tangent;
in vec2 texture1;
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
vec4 l9_0=vec4(position.xy,0.0,1.0);
vec2 l9_1=(l9_0.xy*0.5)+vec2(0.5);
varTex01=vec4(l9_1.x,l9_1.y,varTex01.z,varTex01.w);
vec4 l9_2;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_3=l9_0;
l9_3.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_2=l9_3;
}
#else
{
l9_2=l9_0;
}
#endif
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_2;
vec2 l9_4=((l9_2.xy/vec2(l9_2.w))*0.5)+vec2(0.5);
vec2 l9_5;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_6=vec3(l9_4,0.0);
l9_6.y=((2.0*l9_4.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_5=l9_6.xy;
}
#else
{
l9_5=l9_4;
}
#endif
varScreenTexturePos=l9_5;
vec4 l9_7=l9_2*1.0;
vec4 l9_8;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_9=l9_7;
l9_9.x=l9_7.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_8=l9_9;
}
#else
{
l9_8=l9_7;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_10=dot(l9_8,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_10);
}
#else
{
varClipDistance=l9_10;
}
#endif
}
#endif
gl_Position=l9_8;
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
uniform vec4 sc_UniformConstants;
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
uniform mediump sampler2DArray sc_TAAHistoryTextureArrSC;
uniform mediump sampler2D sc_TAAHistoryTexture;
uniform mediump sampler2DArray sc_TAAMotionVectorTextureArrSC;
uniform mediump sampler2D sc_TAAMotionVectorTexture;
uniform mediump sampler2DArray sc_TAAColorTextureArrSC;
uniform mediump sampler2D sc_TAAColorTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
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
int sc_TAAHistoryTextureGetStereoViewIndex()
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
vec4 sc_SampleTextureLevel(int renderingLayout,int viewIndex,vec2 uv,bool useUvTransform,mat3 uvTransform,ivec2 softwareWrapModes,bool useUvMinMax,vec4 uvMinMax,bool useClampToBorder,vec4 borderColor,float level_,highp sampler2DArray texture_sampler_)
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
float l9_10=level_;
vec3 l9_11=sc_SamplingCoordsViewToGlobal(uv,renderingLayout,viewIndex);
vec4 l9_12=textureLod(texture_sampler_,l9_11,l9_10);
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
vec4 sc_SampleViewLevel(vec2 uv,int renderingLayout,int viewIndex,float level_,highp sampler2D texsmp)
{
return textureLod(texsmp,sc_SamplingCoordsViewToGlobal(uv,renderingLayout,viewIndex).xy,level_);
}
vec4 sc_SampleTextureLevel(int renderingLayout,int viewIndex,vec2 uv,bool useUvTransform,mat3 uvTransform,ivec2 softwareWrapModes,bool useUvMinMax,vec4 uvMinMax,bool useClampToBorder,vec4 borderColor,float level_,highp sampler2D texture_sampler_)
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
vec4 l9_10=sc_SampleViewLevel(uv,renderingLayout,viewIndex,level_,texture_sampler_);
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
void sc_writeFragData0Internal(vec4 col,float zero,int cacheConst)
{
col.x+=zero*float(cacheConst);
sc_FragData0=col;
}
int sc_TAAMotionVectorTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_TAAMotionVectorTextureHasSwappedViews)
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
int sc_TAAColorTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_TAAColorTextureHasSwappedViews)
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
vec4 l9_11;
#if (sc_TAAMotionVectorTextureLayout==2)
{
l9_11=sc_SampleTextureLevel(sc_TAAMotionVectorTextureLayout,sc_TAAMotionVectorTextureGetStereoViewIndex(),varTex01.xy+(vec2(float(l9_5),float(l9_10))*sc_TAAMotionVectorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTextureArrSC);
}
#else
{
l9_11=sc_SampleTextureLevel(sc_TAAMotionVectorTextureLayout,sc_TAAMotionVectorTextureGetStereoViewIndex(),varTex01.xy+(vec2(float(l9_5),float(l9_10))*sc_TAAMotionVectorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTexture);
}
#endif
if (all(equal(l9_11,vec4(0.0))))
{
l9_9=l9_4+1.0;
l9_8=l9_3;
l9_7=l9_2;
}
else
{
vec2 l9_12=vec2(((((((l9_11.x*255.0)*256.0)+(l9_11.y*255.0))/65535.0)+7.6295e-06)*0.2)-0.1,((((((l9_11.z*255.0)*256.0)+(l9_11.w*255.0))/65535.0)+7.6295e-06)*0.2)-0.1);
float l9_13=dot(l9_12,l9_12);
bool l9_14=l9_13>l9_2;
bvec2 l9_15=bvec2(l9_14);
l9_9=l9_4;
l9_8=vec2(l9_15.x ? l9_12.x : l9_3.x,l9_15.y ? l9_12.y : l9_3.y);
l9_7=l9_14 ? l9_13 : l9_2;
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
vec4 l9_16;
#if (sc_TAAColorTextureLayout==2)
{
l9_16=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTextureArrSC);
}
#else
{
l9_16=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture);
}
#endif
sc_writeFragData0Internal(l9_16,sc_UniformConstants.x,sc_ShaderCacheConstant);
return;
}
vec2 l9_17;
#if (!ENABLE_VELOCITY_DILATION)
{
vec4 l9_18;
#if (sc_TAAMotionVectorTextureLayout==2)
{
l9_18=sc_SampleTextureLevel(sc_TAAMotionVectorTextureLayout,sc_TAAMotionVectorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTextureArrSC);
}
#else
{
l9_18=sc_SampleTextureLevel(sc_TAAMotionVectorTextureLayout,sc_TAAMotionVectorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0),sc_TAAMotionVectorTextureBorderColor,0.0,sc_TAAMotionVectorTexture);
}
#endif
vec2 l9_19;
if (all(equal(l9_18,vec4(0.0))))
{
l9_19=vec2(0.0);
}
else
{
l9_19=vec2(((((((l9_18.x*255.0)*256.0)+(l9_18.y*255.0))/65535.0)+7.6295e-06)*0.2)-0.1,((((((l9_18.z*255.0)*256.0)+(l9_18.w*255.0))/65535.0)+7.6295e-06)*0.2)-0.1);
}
l9_17=l9_19;
}
#else
{
l9_17=l9_1;
}
#endif
vec2 l9_20=varTex01.xy-l9_17;
vec4 l9_21;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_21=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_21=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
vec2 l9_22=l9_17*sc_TAAHistoryTextureSize.xy;
vec2 l9_23=vec2(0.5)-abs(fract(l9_22)-vec2(0.5));
bool l9_24=l9_23.x>0.0099999998;
bool l9_25;
if (!l9_24)
{
l9_25=l9_23.y>0.0099999998;
}
else
{
l9_25=l9_24;
}
bool l9_26;
if (!l9_25)
{
l9_26=debugConsts.x>0.0;
}
else
{
l9_26=l9_25;
}
vec4 l9_27;
if (l9_26)
{
vec2 l9_28=sqrt(l9_23*2.0)*sc_TAAHistoryTextureSize.zw;
vec4 l9_29;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_29=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_29=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
vec4 l9_30;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_30=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(-1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_30=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(-1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
vec4 l9_31;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_31=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(1.0,-1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_31=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(1.0,-1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
vec4 l9_32;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_32=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(-1.0,1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_32=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),l9_20+(vec2(-1.0,1.0)*l9_28),(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
vec2 l9_33=abs(l9_23-vec2(0.30000001));
l9_27=l9_21+((l9_21-((((l9_29+l9_30)+l9_31)+l9_32)*0.25))*(sharpening*(0.60000002-max(l9_33.x,l9_33.y))));
}
else
{
l9_27=l9_21;
}
vec4 l9_34;
#if (ENABLE_COLOR_CLAMPING)
{
vec4 l9_35;
vec4 l9_36;
l9_36=vec4(-9999.0);
l9_35=vec4(9999.0);
vec4 l9_37;
vec4 l9_38;
int l9_39=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_39<=1)
{
l9_38=l9_36;
l9_37=l9_35;
vec4 l9_40;
vec4 l9_41;
int l9_42=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_42<=1)
{
vec4 l9_43;
#if (sc_TAAColorTextureLayout==2)
{
l9_43=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy+(vec2(float(l9_39),float(l9_42))*sc_TAAColorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTextureArrSC);
}
#else
{
l9_43=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy+(vec2(float(l9_39),float(l9_42))*sc_TAAColorTextureSize.zw),(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture);
}
#endif
l9_40=min(l9_37,l9_43);
l9_41=max(l9_38,l9_43);
l9_38=l9_41;
l9_37=l9_40;
l9_42++;
continue;
}
else
{
break;
}
}
l9_36=l9_38;
l9_35=l9_37;
l9_39++;
continue;
}
else
{
break;
}
}
l9_34=clamp(l9_27,l9_35,l9_36);
}
#else
{
l9_34=l9_27;
}
#endif
vec4 l9_44;
#if (sc_TAAColorTextureLayout==2)
{
l9_44=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTextureArrSC);
}
#else
{
l9_44=sc_SampleTextureLevel(sc_TAAColorTextureLayout,sc_TAAColorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0),sc_TAAColorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0),sc_TAAColorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0),sc_TAAColorTextureBorderColor,0.0,sc_TAAColorTexture);
}
#endif
sc_writeFragData0Internal(mix(l9_34,l9_44,vec4(currentFrameWeight)),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
void main()
{
#if (DO_BLIT)
{
vec4 l9_0;
#if (sc_TAAHistoryTextureLayout==2)
{
l9_0=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTextureArrSC);
}
#else
{
l9_0=sc_SampleTextureLevel(sc_TAAHistoryTextureLayout,sc_TAAHistoryTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture),(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0),sc_TAAHistoryTextureBorderColor,0.0,sc_TAAHistoryTexture);
}
#endif
sc_writeFragData0Internal(l9_0,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#else
{
doResolvePass();
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
