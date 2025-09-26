#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler backTextureSmpSC 0:9
//sampler sampler inputTextureSmpSC 0:10
//sampler sampler maskTextureSmpSC 0:11
//texture texture2D backTexture 0:0:0:9
//texture texture2D inputTexture 0:1:0:10
//texture texture2D maskTexture 0:2:0:11
//texture texture2DArray backTextureArrSC 0:18:0:9
//texture texture2DArray inputTextureArrSC 0:19:0:10
//texture texture2DArray maskTextureArrSC 0:20:0:11
//spec_const bool backTextureHasSwappedViews 0 0
//spec_const bool inputTextureHasSwappedViews 1 0
//spec_const bool maskTextureHasSwappedViews 2 0
//spec_const int MASK_CHANNEL 3 0
//spec_const int backTextureLayout 4 0
//spec_const int inputTextureLayout 5 0
//spec_const int maskTextureLayout 6 0
//spec_const int sc_ShaderCacheConstant 7 0
//spec_const int sc_StereoRenderingMode 8 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 9 0
//spec_const int sc_StereoViewID 10 0
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
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
uniform mat3 inputTextureTransform;
uniform mat3 maskTransform;
uniform mat3 backTransform;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec2 texture0;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varTexMaskAndBack;
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
vec3 l9_0=vec3(texture0,1.0);
vec2 l9_1=vec2((inputTextureTransform*l9_0).xy);
vec2 l9_2=vec2((maskTransform*l9_0).xy);
varTexMaskAndBack=vec4(l9_2.x,l9_2.y,varTexMaskAndBack.z,varTexMaskAndBack.w);
vec2 l9_3=vec2((backTransform*l9_0).xy);
varTexMaskAndBack=vec4(varTexMaskAndBack.x,varTexMaskAndBack.y,l9_3.x,l9_3.y);
vec4 l9_4;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_5=position;
l9_5.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_4=l9_5;
}
#else
{
l9_4=position;
}
#endif
varPosAndMotion=vec4(l9_4.x,l9_4.y,l9_4.z,varPosAndMotion.w);
varTex01=vec4(l9_1.x,l9_1.y,varTex01.z,varTex01.w);
varScreenPos=l9_4;
vec2 l9_6=((l9_4.xy/vec2(l9_4.w))*0.5)+vec2(0.5);
vec2 l9_7;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_8=vec3(l9_6,0.0);
l9_8.y=((2.0*l9_6.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_7=l9_8.xy;
}
#else
{
l9_7=l9_6;
}
#endif
varScreenTexturePos=l9_7;
vec4 l9_9=l9_4*1.0;
vec4 l9_10;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_11=l9_9;
l9_11.x=l9_9.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_10=l9_11;
}
#else
{
l9_10=l9_9;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_12=dot(l9_10,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_12);
}
#else
{
varClipDistance=l9_12;
}
#endif
}
#endif
gl_Position=l9_10;
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
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 0
#elif maskTextureHasSwappedViews==1
#undef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 1
#endif
#ifndef maskTextureLayout
#define maskTextureLayout 0
#endif
#ifndef backTextureHasSwappedViews
#define backTextureHasSwappedViews 0
#elif backTextureHasSwappedViews==1
#undef backTextureHasSwappedViews
#define backTextureHasSwappedViews 1
#endif
#ifndef backTextureLayout
#define backTextureLayout 0
#endif
#ifndef MASK_CHANNEL
#define MASK_CHANNEL 0
#endif
uniform vec4 sc_UniformConstants;
uniform vec4 backColorMult;
uniform mediump sampler2DArray inputTextureArrSC;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2DArray maskTextureArrSC;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2DArray backTextureArrSC;
uniform mediump sampler2D backTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
in vec4 varTexMaskAndBack;
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
int inputTextureGetStereoViewIndex()
{
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
return l9_0;
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
vec4 sc_SampleView(vec2 uv,int renderingLayout,int viewIndex,float bias,highp sampler2D texsmp)
{
return texture(texsmp,sc_SamplingCoordsViewToGlobal(uv,renderingLayout,viewIndex).xy,bias);
}
int maskTextureGetStereoViewIndex()
{
int l9_0;
#if (maskTextureHasSwappedViews)
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
vec4 maskTextureSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (maskTextureLayout==2)
{
l9_0=texture(maskTextureArrSC,sc_SamplingCoordsViewToGlobal(uv,maskTextureLayout,maskTextureGetStereoViewIndex()),bias);
}
#else
{
l9_0=sc_SampleView(uv,maskTextureLayout,maskTextureGetStereoViewIndex(),bias,maskTexture);
}
#endif
return l9_0;
}
int backTextureGetStereoViewIndex()
{
int l9_0;
#if (backTextureHasSwappedViews)
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
#if ((sc_StereoRenderingMode==1)&&(sc_StereoRendering_IsClipDistanceEnabled==0))
{
if (varClipDistance<0.0)
{
discard;
}
}
#endif
vec4 l9_0;
#if (inputTextureLayout==2)
{
l9_0=texture(inputTextureArrSC,sc_SamplingCoordsViewToGlobal(varTex01.xy,inputTextureLayout,inputTextureGetStereoViewIndex()),0.0);
}
#else
{
l9_0=sc_SampleView(varTex01.xy,inputTextureLayout,inputTextureGetStereoViewIndex(),0.0,inputTexture);
}
#endif
vec4 l9_1;
#if (MASK_CHANNEL==0)
{
l9_1=maskTextureSampleViewBias(varTexMaskAndBack.xy,0.0).xxxx;
}
#else
{
vec4 l9_2;
#if (MASK_CHANNEL==1)
{
l9_2=maskTextureSampleViewBias(varTexMaskAndBack.xy,0.0);
}
#else
{
vec4 l9_3;
#if (MASK_CHANNEL==2)
{
l9_3=maskTextureSampleViewBias(varTexMaskAndBack.xy,0.0).wwww;
}
#else
{
l9_3=vec4(0.0);
}
#endif
l9_2=l9_3;
}
#endif
l9_1=l9_2;
}
#endif
vec4 l9_4;
#if (backTextureLayout==2)
{
l9_4=texture(backTextureArrSC,sc_SamplingCoordsViewToGlobal(varTexMaskAndBack.zw,backTextureLayout,backTextureGetStereoViewIndex()),0.0);
}
#else
{
l9_4=sc_SampleView(varTexMaskAndBack.zw,backTextureLayout,backTextureGetStereoViewIndex(),0.0,backTexture);
}
#endif
sc_writeFragData0Internal(mix(l9_4*backColorMult,l9_0,l9_1),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
