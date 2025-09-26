#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//spec_const int N_SPHERICAL_GAUSSIANS 0 12
//spec_const int sc_ShaderCacheConstant 1 0
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
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
uniform mat4 sc_ModelMatrix;
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 script_modelMatrix;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
in vec4 position;
in vec2 texture0;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec3 varCustomNormal;
out vec4 varTangent;
out vec2 varShadowTex;
flat out int varStereoViewID;
in vec3 normal;
in vec4 tangent;
in vec2 texture1;
void main()
{
varCustomNormal=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
vec4 l9_0=vec4(((texture0*1.002)*2.0)-vec2(1.0),0.0,1.0);
vec4 l9_1=sc_ModelViewProjectionMatrixArray[0]*l9_0;
vec4 l9_2=sc_ModelMatrix*l9_0;
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_1;
varScreenTexturePos=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
vec4 l9_3=l9_1*1.0;
vec4 l9_4;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_5=l9_3;
l9_5.x=l9_3.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_4=l9_5;
}
#else
{
l9_4=l9_3;
}
#endif
gl_Position=l9_4;
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
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef N_SPHERICAL_GAUSSIANS
#define N_SPHERICAL_GAUSSIANS 12
#endif
uniform vec4 sc_UniformConstants;
uniform vec3 sgAxis[N_SPHERICAL_GAUSSIANS];
uniform vec4 sgColorAndSharpness[N_SPHERICAL_GAUSSIANS];
uniform vec3 sgAmbientLight;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec3 varCustomNormal;
in vec4 varTangent;
in vec4 varTex01;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
flat in int varStereoViewID;
in float varClipDistance;
void sc_writeFragData0Internal(vec4 col,float zero,int cacheConst)
{
col.x+=zero*float(cacheConst);
sc_FragData0=col;
}
void main()
{
vec3 l9_0;
l9_0=sgAmbientLight;
int l9_1=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1<N_SPHERICAL_GAUSSIANS)
{
l9_0+=(sgColorAndSharpness[l9_1].xyz*exp(sgColorAndSharpness[l9_1].w*(dot(sgAxis[l9_1],normalize(varCustomNormal))-1.0)));
l9_1++;
continue;
}
else
{
break;
}
}
float l9_2=max(1.0/max(1.0,max(l9_0.x,max(l9_0.y,l9_0.z))),0.0039607845);
sc_writeFragData0Internal(vec4(l9_0*l9_2,l9_2),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
