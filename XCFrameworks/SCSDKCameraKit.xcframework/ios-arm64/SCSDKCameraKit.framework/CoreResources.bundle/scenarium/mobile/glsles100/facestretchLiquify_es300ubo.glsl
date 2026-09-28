#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
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
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef CAMERA_ORTHO
#define CAMERA_ORTHO 0
#elif CAMERA_ORTHO==1
#undef CAMERA_ORTHO
#define CAMERA_ORTHO 1
#endif
#ifndef LIQUIFY_FACESTRETCH
#define LIQUIFY_FACESTRETCH 0
#elif LIQUIFY_FACESTRETCH==1
#undef LIQUIFY_FACESTRETCH
#define LIQUIFY_FACESTRETCH 1
#endif
#ifndef LIQUIFY_ONLY
#define LIQUIFY_ONLY 0
#elif LIQUIFY_ONLY==1
#undef LIQUIFY_ONLY
#define LIQUIFY_ONLY 1
#endif
#ifndef MAX_LIQUIFY
#define MAX_LIQUIFY 10
#endif
#if __VERSION__>=310
layout(binding=0,std140) uniform sc_CameraUBO
#else
layout( std140) uniform sc_CameraUBO
#endif
{
vec4 sc_Time;
vec4 sc_UniformConstants;
mat4 sc_ViewProjectionMatrixArray[4];
mat4 sc_ViewProjectionMatrixInverseArray[4];
mat4 sc_ProjectionMatrixArray[4];
mat4 sc_ProjectionMatrixInverseArray[4];
mat4 sc_ViewMatrixArray[4];
mat4 sc_ViewMatrixInverseArray[4];
mat4 sc_PrevFrameViewProjectionMatrixArray[4];
vec4 sc_CurrentRenderTargetDims;
vec4 sc_WindowToViewportTransform;
vec4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
} sc_CameraUBO_obj;
#if __VERSION__>=310
layout(binding=0,std140) uniform UserUniforms
#else
layout( std140) uniform UserUniforms
#endif
{
mat4 ptsInvMat[10];
vec4 coeffs[10];
vec3 camDirO[10];
} userUniformsObj;
in vec4 position;
in vec2 texture0;
out vec4 varPosAndMotion;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
in vec4 atbCoord2d;
out vec2 varScreenSpacePointsPos0;
out vec2 varScreenSpacePointsPos1;
out vec2 varScreenSpacePointsPos2;
out vec2 varScreenSpacePointsPos3;
out vec2 varScreenSpacePointsPos4;
out vec2 varScreenSpacePointsPos5;
out vec2 varScreenSpacePointsPos6;
out vec2 varScreenSpacePointsPos7;
out vec2 varScreenSpacePointsPos8;
out vec2 varScreenSpacePointsPos9;
out vec4 varNormalAndMotion;
out vec4 varTangent;
out vec2 varShadowTex;
flat out int varStereoViewID;
out float varClipDistance;
in vec3 normal;
in vec4 tangent;
in vec2 texture1;
vec2 calculateObjSpace(int i,vec4 worldPos)
{
vec4 l9_0=worldPos;
vec4 l9_1=userUniformsObj.ptsInvMat[i]*l9_0;
vec3 l9_2;
vec4 l9_3;
#if (CAMERA_ORTHO)
{
l9_3=l9_1-vec4(userUniformsObj.camDirO[i],0.0);
l9_2=userUniformsObj.camDirO[i];
}
#else
{
vec4 l9_4=userUniformsObj.ptsInvMat[i]*vec4(sc_CameraUBO_obj.sc_Camera.position,1.0);
l9_3=l9_4;
l9_2=normalize(l9_1.xyz-l9_4.xyz);
}
#endif
float l9_5;
if (l9_2.z!=0.0)
{
l9_5=(-l9_3.z)/l9_2.z;
}
else
{
l9_5=10000.0;
}
float l9_6;
if (l9_5<0.0)
{
l9_6=10000.0;
}
else
{
l9_6=l9_5;
}
return l9_3.xy+(l9_2.xy*l9_6);
}
void main()
{
vec4 l9_0=vec4(atbCoord2d.xy,0.0,1.0);
varPosAndMotion=vec4(l9_0.x,l9_0.y,l9_0.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_0;
varScreenTexturePos=((l9_0.xy/vec2(1.0))*0.5)+vec2(0.5);
vec4 l9_1=l9_0*1.0;
vec4 l9_2;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_3=l9_1;
l9_3.x=l9_1.x+(sc_CameraUBO_obj.sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_2=l9_3;
}
#else
{
l9_2=l9_1;
}
#endif
gl_Position=l9_2;
varScreenPos=atbCoord2d;
vec4 l9_5=vec4(atbCoord2d.xy,-1.0,1.0);
vec2 l9_6=vec2(atbCoord2d.z,atbCoord2d.w);
vec4 l9_7;
vec2 l9_8;
#if (LIQUIFY_FACESTRETCH)
{
vec2 l9_9=varScreenPos.xy+l9_6;
varScreenPos=vec4(l9_9.x,l9_9.y,varScreenPos.z,varScreenPos.w);
vec2 l9_10=l9_5.xy+l9_6;
l9_8=l9_6;
l9_7=vec4(l9_10.x,l9_10.y,l9_5.z,l9_5.w);
}
#else
{
vec2 l9_11;
#if (LIQUIFY_ONLY)
{
varScreenPos=vec4(varScreenPos.x,varScreenPos.y,vec2(0.0).x,vec2(0.0).y);
l9_11=vec2(0.0);
}
#else
{
l9_11=l9_6;
}
#endif
l9_8=l9_11;
l9_7=l9_5;
}
#endif
vec4 l9_12=sc_CameraUBO_obj.sc_ViewProjectionMatrixInverseArray[0]*l9_7;
vec3 l9_13=l9_12.xyz/vec3(l9_12.w);
vec4 l9_14=vec4(l9_13.x,l9_13.y,l9_13.z,l9_12.w);
l9_14.w=1.0;
#if (MAX_LIQUIFY>0)
{
varScreenSpacePointsPos0=calculateObjSpace(0,l9_14);
}
#endif
#if (MAX_LIQUIFY>1)
{
varScreenSpacePointsPos1=calculateObjSpace(1,l9_14);
}
#endif
#if (MAX_LIQUIFY>2)
{
varScreenSpacePointsPos2=calculateObjSpace(2,l9_14);
}
#endif
#if (MAX_LIQUIFY>3)
{
varScreenSpacePointsPos3=calculateObjSpace(3,l9_14);
}
#endif
#if (MAX_LIQUIFY>4)
{
varScreenSpacePointsPos4=calculateObjSpace(4,l9_14);
}
#endif
#if (MAX_LIQUIFY>5)
{
varScreenSpacePointsPos5=calculateObjSpace(5,l9_14);
}
#endif
#if (MAX_LIQUIFY>6)
{
varScreenSpacePointsPos6=calculateObjSpace(6,l9_14);
}
#endif
#if (MAX_LIQUIFY>7)
{
varScreenSpacePointsPos7=calculateObjSpace(7,l9_14);
}
#endif
#if (MAX_LIQUIFY>8)
{
varScreenSpacePointsPos8=calculateObjSpace(8,l9_14);
}
#endif
#if (MAX_LIQUIFY>9)
{
varScreenSpacePointsPos9=calculateObjSpace(9,l9_14);
}
#endif
#if (!LIQUIFY_FACESTRETCH)
{
vec2 l9_15=l9_8*0.5;
varScreenPos=vec4(varScreenPos.x,varScreenPos.y,l9_15.x,l9_15.y);
}
#endif
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#ifndef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 0
#elif sc_ScreenTextureHasSwappedViews==1
#undef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 1
#endif
#ifndef sc_ScreenTextureLayout
#define sc_ScreenTextureLayout 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef MAX_LIQUIFY
#define MAX_LIQUIFY 10
#endif
#ifndef LIQUIFY_ONLY
#define LIQUIFY_ONLY 0
#elif LIQUIFY_ONLY==1
#undef LIQUIFY_ONLY
#define LIQUIFY_ONLY 1
#endif
#ifndef LIQUIFY_FACESTRETCH
#define LIQUIFY_FACESTRETCH 0
#elif LIQUIFY_FACESTRETCH==1
#undef LIQUIFY_FACESTRETCH
#define LIQUIFY_FACESTRETCH 1
#endif
#if __VERSION__>=310
layout(binding=0,std140) uniform sc_CameraUBO
#else
layout( std140) uniform sc_CameraUBO
#endif
{
vec4 sc_Time;
vec4 sc_UniformConstants;
mat4 sc_ViewProjectionMatrixArray[4];
mat4 sc_ViewProjectionMatrixInverseArray[4];
mat4 sc_ProjectionMatrixArray[4];
mat4 sc_ProjectionMatrixInverseArray[4];
mat4 sc_ViewMatrixArray[4];
mat4 sc_ViewMatrixInverseArray[4];
mat4 sc_PrevFrameViewProjectionMatrixArray[4];
vec4 sc_CurrentRenderTargetDims;
vec4 sc_WindowToViewportTransform;
vec4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
} sc_CameraUBO_obj;
#if __VERSION__>=310
layout(binding=0,std140) uniform UserUniforms
#else
layout( std140) uniform UserUniforms
#endif
{
mat4 ptsInvMat[10];
vec4 coeffs[10];
vec3 camDirO[10];
} userUniformsObj;
uniform mediump sampler2DArray sc_ScreenTextureArrSC;
uniform mediump sampler2D sc_ScreenTexture;
layout(location=0) out vec4 sc_FragData0;
in vec4 varScreenPos;
in vec2 varScreenSpacePointsPos0;
in vec2 varScreenSpacePointsPos1;
in vec2 varScreenSpacePointsPos2;
in vec2 varScreenSpacePointsPos3;
in vec2 varScreenSpacePointsPos4;
in vec2 varScreenSpacePointsPos5;
in vec2 varScreenSpacePointsPos6;
in vec2 varScreenSpacePointsPos7;
in vec2 varScreenSpacePointsPos8;
in vec2 varScreenSpacePointsPos9;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varTex01;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
flat in int varStereoViewID;
in float varClipDistance;
vec2 calcOffsetForPoint(int i,vec2 varScreenSpacePointsPos,vec4 varScreenPos_1)
{
float l9_0=dot(varScreenSpacePointsPos,varScreenSpacePointsPos);
return (varScreenPos_1.xy-userUniformsObj.coeffs[i].xy)*((pow(clamp(l9_0/userUniformsObj.coeffs[i].w,0.00078125001,1.0),userUniformsObj.coeffs[i].z)-1.0)*step(l9_0,userUniformsObj.coeffs[i].w));
}
int sc_ScreenTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_ScreenTextureHasSwappedViews)
{
l9_0=1;
}
#else
{
l9_0=0;
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
void main()
{
vec2 l9_0;
#if (MAX_LIQUIFY>0)
{
l9_0=vec2(0.0)+calcOffsetForPoint(0,varScreenSpacePointsPos0,varScreenPos);
}
#else
{
l9_0=vec2(0.0);
}
#endif
vec2 l9_1;
#if (MAX_LIQUIFY>1)
{
l9_1=l9_0+calcOffsetForPoint(1,varScreenSpacePointsPos1,varScreenPos);
}
#else
{
l9_1=l9_0;
}
#endif
vec2 l9_2;
#if (MAX_LIQUIFY>2)
{
l9_2=l9_1+calcOffsetForPoint(2,varScreenSpacePointsPos2,varScreenPos);
}
#else
{
l9_2=l9_1;
}
#endif
vec2 l9_3;
#if (MAX_LIQUIFY>3)
{
l9_3=l9_2+calcOffsetForPoint(3,varScreenSpacePointsPos3,varScreenPos);
}
#else
{
l9_3=l9_2;
}
#endif
vec2 l9_4;
#if (MAX_LIQUIFY>4)
{
l9_4=l9_3+calcOffsetForPoint(4,varScreenSpacePointsPos4,varScreenPos);
}
#else
{
l9_4=l9_3;
}
#endif
vec2 l9_5;
#if (MAX_LIQUIFY>5)
{
l9_5=l9_4+calcOffsetForPoint(5,varScreenSpacePointsPos5,varScreenPos);
}
#else
{
l9_5=l9_4;
}
#endif
vec2 l9_6;
#if (MAX_LIQUIFY>6)
{
l9_6=l9_5+calcOffsetForPoint(6,varScreenSpacePointsPos6,varScreenPos);
}
#else
{
l9_6=l9_5;
}
#endif
vec2 l9_7;
#if (MAX_LIQUIFY>7)
{
l9_7=l9_6+calcOffsetForPoint(7,varScreenSpacePointsPos7,varScreenPos);
}
#else
{
l9_7=l9_6;
}
#endif
vec2 l9_8;
#if (MAX_LIQUIFY>8)
{
l9_8=l9_7+calcOffsetForPoint(8,varScreenSpacePointsPos8,varScreenPos);
}
#else
{
l9_8=l9_7;
}
#endif
vec2 l9_9;
#if (MAX_LIQUIFY>9)
{
l9_9=l9_8+calcOffsetForPoint(9,varScreenSpacePointsPos9,varScreenPos);
}
#else
{
l9_9=l9_8;
}
#endif
vec2 l9_10=varScreenPos.xy+l9_9;
vec2 l9_11=(l9_10*vec2(0.5))+vec2(0.5);
vec2 l9_12;
#if (!LIQUIFY_ONLY)
{
vec2 l9_13;
#if (!LIQUIFY_FACESTRETCH)
{
l9_13=l9_11+varScreenPos.zw;
}
#else
{
l9_13=l9_11;
}
#endif
l9_12=l9_13;
}
#else
{
l9_12=l9_11;
}
#endif
vec4 l9_14;
#if (sc_ScreenTextureLayout==2)
{
l9_14=texture(sc_ScreenTextureArrSC,sc_SamplingCoordsViewToGlobal(l9_12,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()),0.0);
}
#else
{
l9_14=texture(sc_ScreenTexture,sc_SamplingCoordsViewToGlobal(l9_12,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()).xy,0.0);
}
#endif
vec4 l9_15;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_16=l9_14;
l9_16.x=l9_14.x+(sc_CameraUBO_obj.sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_15=l9_16;
}
#else
{
l9_15=l9_14;
}
#endif
sc_FragData0=l9_15;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
