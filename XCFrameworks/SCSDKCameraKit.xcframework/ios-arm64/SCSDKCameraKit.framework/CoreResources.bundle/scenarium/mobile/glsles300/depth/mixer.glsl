#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler mainTextureSmpSC 0:12
//sampler sampler tex_BY_YSmpSC 0:19
//sampler sampler tex_RG_RB_GBSmpSC 0:20
//sampler sampler tex_RR_GG_BBSmpSC 0:21
//sampler sampler tex_RY_GYSmpSC 0:22
//sampler sampler tex_R_G_BSmpSC 0:23
//texture texture2D mainTexture 0:0:0:12
//texture texture2D tex_BY_Y 0:7:0:19
//texture texture2D tex_RG_RB_GB 0:8:0:20
//texture texture2D tex_RR_GG_BB 0:9:0:21
//texture texture2D tex_RY_GY 0:10:0:22
//texture texture2D tex_R_G_B 0:11:0:23
//texture texture2DArray mainTextureArrSC 0:24:0:12
//texture texture2DArray tex_BY_YArrSC 0:28:0:19
//texture texture2DArray tex_RG_RB_GBArrSC 0:29:0:20
//texture texture2DArray tex_RR_GG_BBArrSC 0:30:0:21
//texture texture2DArray tex_RY_GYArrSC 0:31:0:22
//texture texture2DArray tex_R_G_BArrSC 0:32:0:23
//spec_const bool CAMEOS_MATTING 0 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_mainTexture 1 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_tex_BY_Y 2 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB 3 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB 4 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_tex_RY_GY 5 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_tex_R_G_B 6 0
//spec_const bool SC_USE_UV_MIN_MAX_mainTexture 7 0
//spec_const bool SC_USE_UV_MIN_MAX_tex_BY_Y 8 0
//spec_const bool SC_USE_UV_MIN_MAX_tex_RG_RB_GB 9 0
//spec_const bool SC_USE_UV_MIN_MAX_tex_RR_GG_BB 10 0
//spec_const bool SC_USE_UV_MIN_MAX_tex_RY_GY 11 0
//spec_const bool SC_USE_UV_MIN_MAX_tex_R_G_B 12 0
//spec_const bool SC_USE_UV_TRANSFORM_mainTexture 13 0
//spec_const bool mainTextureHasSwappedViews 14 0
//spec_const bool tex_BY_YHasSwappedViews 15 0
//spec_const bool tex_RG_RB_GBHasSwappedViews 16 0
//spec_const bool tex_RR_GG_BBHasSwappedViews 17 0
//spec_const bool tex_RY_GYHasSwappedViews 18 0
//spec_const bool tex_R_G_BHasSwappedViews 19 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_mainTexture 20 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y 21 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB 22 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB 23 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY 24 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B 25 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_mainTexture 26 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y 27 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB 28 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB 29 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY 30 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B 31 -1
//spec_const int mainTextureLayout 32 0
//spec_const int sc_ShaderCacheConstant 33 0
//spec_const int sc_StereoRenderingMode 34 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 35 0
//spec_const int sc_StereoViewID 36 0
//spec_const int tex_BY_YLayout 37 0
//spec_const int tex_RG_RB_GBLayout 38 0
//spec_const int tex_RR_GG_BBLayout 39 0
//spec_const int tex_RY_GYLayout 40 0
//spec_const int tex_R_G_BLayout 41 0
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
vec4 l9_0;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_1=position;
l9_1.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_0=l9_1;
}
#else
{
l9_0=position;
}
#endif
varPosAndMotion=vec4(l9_0.x,l9_0.y,l9_0.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_0;
vec2 l9_2=((l9_0.xy/vec2(l9_0.w))*0.5)+vec2(0.5);
vec2 l9_3;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_4=vec3(l9_2,0.0);
l9_4.y=((2.0*l9_2.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_3=l9_4.xy;
}
#else
{
l9_3=l9_2;
}
#endif
varScreenTexturePos=l9_3;
vec4 l9_5=l9_0*1.0;
vec4 l9_6;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_7=l9_5;
l9_7.x=l9_5.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_6=l9_7;
}
#else
{
l9_6=l9_5;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_8=dot(l9_6,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_8);
}
#else
{
varClipDistance=l9_8;
}
#endif
}
#endif
gl_Position=l9_6;
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
#ifndef tex_RY_GYHasSwappedViews
#define tex_RY_GYHasSwappedViews 0
#elif tex_RY_GYHasSwappedViews==1
#undef tex_RY_GYHasSwappedViews
#define tex_RY_GYHasSwappedViews 1
#endif
#ifndef tex_RY_GYLayout
#define tex_RY_GYLayout 0
#endif
#ifndef tex_BY_YHasSwappedViews
#define tex_BY_YHasSwappedViews 0
#elif tex_BY_YHasSwappedViews==1
#undef tex_BY_YHasSwappedViews
#define tex_BY_YHasSwappedViews 1
#endif
#ifndef tex_BY_YLayout
#define tex_BY_YLayout 0
#endif
#ifndef tex_R_G_BHasSwappedViews
#define tex_R_G_BHasSwappedViews 0
#elif tex_R_G_BHasSwappedViews==1
#undef tex_R_G_BHasSwappedViews
#define tex_R_G_BHasSwappedViews 1
#endif
#ifndef tex_R_G_BLayout
#define tex_R_G_BLayout 0
#endif
#ifndef tex_RR_GG_BBHasSwappedViews
#define tex_RR_GG_BBHasSwappedViews 0
#elif tex_RR_GG_BBHasSwappedViews==1
#undef tex_RR_GG_BBHasSwappedViews
#define tex_RR_GG_BBHasSwappedViews 1
#endif
#ifndef tex_RR_GG_BBLayout
#define tex_RR_GG_BBLayout 0
#endif
#ifndef tex_RG_RB_GBHasSwappedViews
#define tex_RG_RB_GBHasSwappedViews 0
#elif tex_RG_RB_GBHasSwappedViews==1
#undef tex_RG_RB_GBHasSwappedViews
#define tex_RG_RB_GBHasSwappedViews 1
#endif
#ifndef tex_RG_RB_GBLayout
#define tex_RG_RB_GBLayout 0
#endif
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY
#define SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY
#define SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RY_GY
#define SC_USE_UV_MIN_MAX_tex_RY_GY 0
#elif SC_USE_UV_MIN_MAX_tex_RY_GY==1
#undef SC_USE_UV_MIN_MAX_tex_RY_GY
#define SC_USE_UV_MIN_MAX_tex_RY_GY 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RY_GY
#define SC_USE_CLAMP_TO_BORDER_tex_RY_GY 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RY_GY==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RY_GY
#define SC_USE_CLAMP_TO_BORDER_tex_RY_GY 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y
#define SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y
#define SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_BY_Y
#define SC_USE_UV_MIN_MAX_tex_BY_Y 0
#elif SC_USE_UV_MIN_MAX_tex_BY_Y==1
#undef SC_USE_UV_MIN_MAX_tex_BY_Y
#define SC_USE_UV_MIN_MAX_tex_BY_Y 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_BY_Y
#define SC_USE_CLAMP_TO_BORDER_tex_BY_Y 0
#elif SC_USE_CLAMP_TO_BORDER_tex_BY_Y==1
#undef SC_USE_CLAMP_TO_BORDER_tex_BY_Y
#define SC_USE_CLAMP_TO_BORDER_tex_BY_Y 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B
#define SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B
#define SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_R_G_B
#define SC_USE_UV_MIN_MAX_tex_R_G_B 0
#elif SC_USE_UV_MIN_MAX_tex_R_G_B==1
#undef SC_USE_UV_MIN_MAX_tex_R_G_B
#define SC_USE_UV_MIN_MAX_tex_R_G_B 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_R_G_B
#define SC_USE_CLAMP_TO_BORDER_tex_R_G_B 0
#elif SC_USE_CLAMP_TO_BORDER_tex_R_G_B==1
#undef SC_USE_CLAMP_TO_BORDER_tex_R_G_B
#define SC_USE_CLAMP_TO_BORDER_tex_R_G_B 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB
#define SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB
#define SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RR_GG_BB
#define SC_USE_UV_MIN_MAX_tex_RR_GG_BB 0
#elif SC_USE_UV_MIN_MAX_tex_RR_GG_BB==1
#undef SC_USE_UV_MIN_MAX_tex_RR_GG_BB
#define SC_USE_UV_MIN_MAX_tex_RR_GG_BB 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB
#define SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB
#define SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB
#define SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB
#define SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RG_RB_GB
#define SC_USE_UV_MIN_MAX_tex_RG_RB_GB 0
#elif SC_USE_UV_MIN_MAX_tex_RG_RB_GB==1
#undef SC_USE_UV_MIN_MAX_tex_RG_RB_GB
#define SC_USE_UV_MIN_MAX_tex_RG_RB_GB 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB
#define SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB
#define SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB 1
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
#ifndef CAMEOS_MATTING
#define CAMEOS_MATTING 0
#elif CAMEOS_MATTING==1
#undef CAMEOS_MATTING
#define CAMEOS_MATTING 1
#endif
uniform vec4 sc_UniformConstants;
uniform vec4 tex_RY_GYUvMinMax;
uniform vec4 tex_RY_GYBorderColor;
uniform vec4 tex_BY_YUvMinMax;
uniform vec4 tex_BY_YBorderColor;
uniform vec4 tex_R_G_BUvMinMax;
uniform vec4 tex_R_G_BBorderColor;
uniform vec4 tex_RR_GG_BBUvMinMax;
uniform vec4 tex_RR_GG_BBBorderColor;
uniform vec4 tex_RG_RB_GBUvMinMax;
uniform vec4 tex_RG_RB_GBBorderColor;
uniform float epsilon;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mediump sampler2DArray tex_RY_GYArrSC;
uniform mediump sampler2D tex_RY_GY;
uniform mediump sampler2DArray tex_BY_YArrSC;
uniform mediump sampler2D tex_BY_Y;
uniform mediump sampler2DArray tex_R_G_BArrSC;
uniform mediump sampler2D tex_R_G_B;
uniform mediump sampler2DArray tex_RR_GG_BBArrSC;
uniform mediump sampler2D tex_RR_GG_BB;
uniform mediump sampler2DArray tex_RG_RB_GBArrSC;
uniform mediump sampler2D tex_RG_RB_GB;
uniform mediump sampler2DArray mainTextureArrSC;
uniform mediump sampler2D mainTexture;
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
int tex_RY_GYGetStereoViewIndex()
{
int l9_0;
#if (tex_RY_GYHasSwappedViews)
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
int tex_BY_YGetStereoViewIndex()
{
int l9_0;
#if (tex_BY_YHasSwappedViews)
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
int tex_R_G_BGetStereoViewIndex()
{
int l9_0;
#if (tex_R_G_BHasSwappedViews)
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
int tex_RR_GG_BBGetStereoViewIndex()
{
int l9_0;
#if (tex_RR_GG_BBHasSwappedViews)
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
int tex_RG_RB_GBGetStereoViewIndex()
{
int l9_0;
#if (tex_RG_RB_GBHasSwappedViews)
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
int mainTextureGetStereoViewIndex()
{
int l9_0;
#if (mainTextureHasSwappedViews)
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
#if (tex_RY_GYLayout==2)
{
l9_0=sc_SampleTextureBias(tex_RY_GYLayout,tex_RY_GYGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY,SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY),(int(SC_USE_UV_MIN_MAX_tex_RY_GY)!=0),tex_RY_GYUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RY_GY)!=0),tex_RY_GYBorderColor,0.0,tex_RY_GYArrSC);
}
#else
{
l9_0=sc_SampleTextureBias(tex_RY_GYLayout,tex_RY_GYGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY,SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY),(int(SC_USE_UV_MIN_MAX_tex_RY_GY)!=0),tex_RY_GYUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RY_GY)!=0),tex_RY_GYBorderColor,0.0,tex_RY_GY);
}
#endif
vec4 l9_1;
#if (tex_BY_YLayout==2)
{
l9_1=sc_SampleTextureBias(tex_BY_YLayout,tex_BY_YGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y,SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y),(int(SC_USE_UV_MIN_MAX_tex_BY_Y)!=0),tex_BY_YUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_BY_Y)!=0),tex_BY_YBorderColor,0.0,tex_BY_YArrSC);
}
#else
{
l9_1=sc_SampleTextureBias(tex_BY_YLayout,tex_BY_YGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y,SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y),(int(SC_USE_UV_MIN_MAX_tex_BY_Y)!=0),tex_BY_YUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_BY_Y)!=0),tex_BY_YBorderColor,0.0,tex_BY_Y);
}
#endif
float l9_2=dot(l9_1.zw,vec2(1.0,0.0039215689));
vec4 l9_3;
#if (tex_R_G_BLayout==2)
{
l9_3=sc_SampleTextureBias(tex_R_G_BLayout,tex_R_G_BGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B,SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B),(int(SC_USE_UV_MIN_MAX_tex_R_G_B)!=0),tex_R_G_BUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_R_G_B)!=0),tex_R_G_BBorderColor,0.0,tex_R_G_BArrSC);
}
#else
{
l9_3=sc_SampleTextureBias(tex_R_G_BLayout,tex_R_G_BGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B,SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B),(int(SC_USE_UV_MIN_MAX_tex_R_G_B)!=0),tex_R_G_BUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_R_G_B)!=0),tex_R_G_BBorderColor,0.0,tex_R_G_B);
}
#endif
vec4 l9_4;
#if (tex_RR_GG_BBLayout==2)
{
l9_4=sc_SampleTextureBias(tex_RR_GG_BBLayout,tex_RR_GG_BBGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB,SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB),(int(SC_USE_UV_MIN_MAX_tex_RR_GG_BB)!=0),tex_RR_GG_BBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB)!=0),tex_RR_GG_BBBorderColor,0.0,tex_RR_GG_BBArrSC);
}
#else
{
l9_4=sc_SampleTextureBias(tex_RR_GG_BBLayout,tex_RR_GG_BBGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB,SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB),(int(SC_USE_UV_MIN_MAX_tex_RR_GG_BB)!=0),tex_RR_GG_BBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB)!=0),tex_RR_GG_BBBorderColor,0.0,tex_RR_GG_BB);
}
#endif
vec4 l9_5;
#if (tex_RG_RB_GBLayout==2)
{
l9_5=sc_SampleTextureBias(tex_RG_RB_GBLayout,tex_RG_RB_GBGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB,SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB),(int(SC_USE_UV_MIN_MAX_tex_RG_RB_GB)!=0),tex_RG_RB_GBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB)!=0),tex_RG_RB_GBBorderColor,0.0,tex_RG_RB_GBArrSC);
}
#else
{
l9_5=sc_SampleTextureBias(tex_RG_RB_GBLayout,tex_RG_RB_GBGetStereoViewIndex(),varTex01.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB,SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB),(int(SC_USE_UV_MIN_MAX_tex_RG_RB_GB)!=0),tex_RG_RB_GBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB)!=0),tex_RG_RB_GBBorderColor,0.0,tex_RG_RB_GB);
}
#endif
vec3 l9_6=abs(l9_4.xyz-(l9_3.xyz*l9_3.xyz))+vec3(epsilon*epsilon);
vec3 l9_7=l9_5.xyz-(l9_3.xxy*l9_3.yzz);
float l9_8=l9_6.x;
float l9_9=l9_6.y;
float l9_10=l9_6.z;
float l9_11=l9_7.x;
float l9_12=l9_7.y;
float l9_13=l9_7.z;
float l9_14=(l9_12*l9_13)-(l9_10*l9_11);
float l9_15=(l9_11*l9_13)-(l9_12*l9_9);
float l9_16=(l9_11*l9_12)-(l9_8*l9_13);
vec3 l9_17=vec3((l9_10*l9_9)-(l9_13*l9_13),l9_14,l9_15);
vec3 l9_18=(mat3(l9_17,vec3(l9_14,(l9_10*l9_8)-(l9_12*l9_12),l9_16),vec3(l9_15,l9_16,(l9_8*l9_9)-(l9_11*l9_11)))*(vec4(dot(l9_0.xy,vec2(1.0,0.0039215689)),dot(l9_0.zw,vec2(1.0,0.0039215689)),dot(l9_1.xy,vec2(1.0,0.0039215689)),l9_2).xyz-(l9_3.xyz*l9_2)))/vec3(dot(vec3(l9_8,l9_11,l9_12),l9_17));
vec4 l9_19;
#if (mainTextureLayout==2)
{
l9_19=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_19=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
float l9_20=dot(l9_18,l9_19.xyz)+(l9_2-dot(l9_18,l9_3.xyz));
vec4 l9_21;
#if (CAMEOS_MATTING)
{
l9_21=vec4(l9_20,0.0,0.0,1.0);
}
#else
{
vec2 l9_22=fract(vec2(1.0,255.0)*l9_20);
float l9_23=l9_22.y;
l9_21=vec4(l9_22.x-(l9_23/255.0),l9_23,0.0,1.0);
}
#endif
sc_writeFragData0Internal(l9_21,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
