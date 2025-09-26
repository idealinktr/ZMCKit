#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 boneData 5
//attribute vec3 blendShape0Pos 6
//attribute vec3 blendShape0Normal 12
//attribute vec3 blendShape1Pos 7
//attribute vec3 blendShape1Normal 13
//attribute vec3 blendShape2Pos 8
//attribute vec3 blendShape2Normal 14
//attribute vec3 blendShape3Pos 9
//attribute vec3 blendShape4Pos 10
//attribute vec3 blendShape5Pos 11
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec3 normal 1
//attribute vec4 tangent 2
//sampler sampler mainTextureSmpSC 0:8
//sampler sampler maskTextureSmpSC 0:9
//sampler sampler sc_ShadowTextureSmpSC 0:14
//texture texture2D mainTexture 0:0:0:8
//texture texture2D maskTexture 0:1:0:9
//texture texture2D sc_ShadowTexture 0:6:0:14
//texture texture2DArray mainTextureArrSC 0:16:0:8
//texture texture2DArray maskTextureArrSC 0:17:0:9
//spec_const bool EMOCHECKERS 0 0
//spec_const bool ENABLESHADOWS 1 0
//spec_const bool NOMASK 2 0
//spec_const bool NOTEXTURE 3 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_mainTexture 4 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_maskTexture 5 0
//spec_const bool SC_USE_UV_MIN_MAX_mainTexture 6 0
//spec_const bool SC_USE_UV_MIN_MAX_maskTexture 7 0
//spec_const bool SC_USE_UV_TRANSFORM_mainTexture 8 0
//spec_const bool SC_USE_UV_TRANSFORM_maskTexture 9 0
//spec_const bool mainTextureHasSwappedViews 10 0
//spec_const bool maskTextureHasSwappedViews 11 0
//spec_const bool sc_BlendMode_Add 12 0
//spec_const bool sc_BlendMode_AddWithAlphaFactor 13 0
//spec_const bool sc_BlendMode_AlphaTest 14 0
//spec_const bool sc_BlendMode_AlphaToCoverage 15 0
//spec_const bool sc_BlendMode_ColoredGlass 16 0
//spec_const bool sc_BlendMode_Max 17 0
//spec_const bool sc_BlendMode_Min 18 0
//spec_const bool sc_BlendMode_Multiply 19 0
//spec_const bool sc_BlendMode_MultiplyOriginal 20 0
//spec_const bool sc_BlendMode_Normal 21 0
//spec_const bool sc_BlendMode_PremultipliedAlpha 22 0
//spec_const bool sc_BlendMode_PremultipliedAlphaAuto 23 0
//spec_const bool sc_BlendMode_PremultipliedAlphaHardware 24 0
//spec_const bool sc_BlendMode_Screen 25 0
//spec_const bool sc_OITCompositingPass 26 0
//spec_const bool sc_OITDepthBoundsPass 27 0
//spec_const bool sc_OITDepthGatherPass 28 0
//spec_const bool sc_ProjectiveShadowsCaster 29 0
//spec_const bool sc_ProjectiveShadowsReceiver 30 0
//spec_const bool sc_VertexBlending 31 0
//spec_const bool sc_VertexBlendingUseNormals 32 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_mainTexture 33 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_maskTexture 34 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_mainTexture 35 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_maskTexture 36 -1
//spec_const int mainTextureLayout 37 0
//spec_const int maskTextureLayout 38 0
//spec_const int sc_DepthBufferMode 39 0
//spec_const int sc_RenderingSpace 40 -1
//spec_const int sc_ShaderCacheConstant 41 0
//spec_const int sc_SkinBonesCount 42 0
//spec_const int sc_StereoRenderingMode 43 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 44 0
//spec_const int sc_StereoViewID 45 0
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
struct sc_Vertex_t
{
vec4 position;
vec3 normal;
vec3 tangent;
vec2 texture0;
vec2 texture1;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_RenderingSpace
#define sc_RenderingSpace -1
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
#ifndef sc_SkinBonesCount
#define sc_SkinBonesCount 0
#endif
#ifndef sc_VertexBlending
#define sc_VertexBlending 0
#elif sc_VertexBlending==1
#undef sc_VertexBlending
#define sc_VertexBlending 1
#endif
#ifndef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 0
#elif sc_VertexBlendingUseNormals==1
#undef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 1
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef sc_DepthBufferMode
#define sc_DepthBufferMode 0
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
#ifndef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 0
#elif sc_OITDepthGatherPass==1
#undef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 1
#endif
#ifndef sc_OITCompositingPass
#define sc_OITCompositingPass 0
#elif sc_OITCompositingPass==1
#undef sc_OITCompositingPass
#define sc_OITCompositingPass 1
#endif
#ifndef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 0
#elif sc_OITDepthBoundsPass==1
#undef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 1
#endif
uniform mat4 sc_ModelMatrix;
uniform mat4 sc_ProjectorMatrix;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform vec4 sc_BoneMatrices[((sc_SkinBonesCount*3)+1)];
uniform vec4 weights0;
uniform vec4 weights1;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform mat4 sc_ProjectionMatrixInverseArray[sc_NumStereoViews];
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 boneData;
in vec3 blendShape0Pos;
in vec3 blendShape0Normal;
in vec3 blendShape1Pos;
in vec3 blendShape1Normal;
in vec3 blendShape2Pos;
in vec3 blendShape2Normal;
in vec3 blendShape3Pos;
in vec3 blendShape4Pos;
in vec3 blendShape5Pos;
in vec4 position;
in vec2 texture0;
in vec2 texture1;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out float varViewSpaceDepth;
out vec4 varTangent;
in vec3 normal;
in vec4 tangent;
void blendTargetShapeWithNormal(inout sc_Vertex_t v,vec3 position_1,vec3 normal_1,float weight)
{
vec3 l9_0=v.position.xyz+(position_1*weight);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
v.normal+=(normal_1*weight);
}
void sc_GetBoneMatrix(int index,out vec4 m0,out vec4 m1,out vec4 m2)
{
int l9_0=3*index;
m0=sc_BoneMatrices[l9_0];
m1=sc_BoneMatrices[l9_0+1];
m2=sc_BoneMatrices[l9_0+2];
}
vec3 skinVertexPosition(int i,vec4 v)
{
vec3 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 param_1;
vec4 param_2;
vec4 param_3;
sc_GetBoneMatrix(i,param_1,param_2,param_3);
l9_0=vec3(dot(v,param_1),dot(v,param_2),dot(v,param_3));
}
#else
{
l9_0=v.xyz;
}
#endif
return l9_0;
}
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
vec4 sc_ApplyScreenSpaceInstancedClippedShift(vec4 screenPosition)
{
#if (sc_StereoRenderingMode==1)
{
screenPosition.y=(screenPosition.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
}
#endif
return screenPosition;
}
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
vec2 l9_0;
vec2 l9_1;
vec4 l9_2;
#if (sc_VertexBlending)
{
vec2 l9_3;
vec2 l9_4;
vec4 l9_5;
#if (sc_VertexBlendingUseNormals)
{
sc_Vertex_t l9_6=sc_Vertex_t(position,vec3(0.0),vec3(0.0),texture0,texture1);
blendTargetShapeWithNormal(l9_6,blendShape0Pos,blendShape0Normal,weights0.x);
blendTargetShapeWithNormal(l9_6,blendShape1Pos,blendShape1Normal,weights0.y);
blendTargetShapeWithNormal(l9_6,blendShape2Pos,blendShape2Normal,weights0.z);
l9_5=l9_6.position;
l9_4=l9_6.texture0;
l9_3=l9_6.texture1;
}
#else
{
vec3 l9_8=(((((position.xyz+(blendShape0Pos*weights0.x)).xyz+(blendShape1Pos*weights0.y)).xyz+(blendShape2Pos*weights0.z)).xyz+(blendShape3Pos*weights0.w)).xyz+(blendShape4Pos*weights1.x)).xyz+(blendShape5Pos*weights1.y);
l9_5=vec4(l9_8.x,l9_8.y,l9_8.z,position.w);
l9_4=texture0;
l9_3=texture1;
}
#endif
l9_2=l9_5;
l9_1=l9_4;
l9_0=l9_3;
}
#else
{
l9_2=position;
l9_1=texture0;
l9_0=texture1;
}
#endif
vec4 l9_9;
#if (sc_SkinBonesCount>0)
{
vec4 l9_10;
#if (sc_SkinBonesCount>0)
{
vec4 l9_11=vec4(1.0,fract(boneData.yzw));
vec4 l9_12=l9_11;
l9_12.x=1.0-dot(l9_11.yzw,vec3(1.0));
l9_10=l9_12;
}
#else
{
l9_10=vec4(0.0);
}
#endif
vec3 l9_13=(((skinVertexPosition(int(boneData.x),l9_2)*l9_10.x)+(skinVertexPosition(int(boneData.y),l9_2)*l9_10.y))+(skinVertexPosition(int(boneData.z),l9_2)*l9_10.z))+(skinVertexPosition(int(boneData.w),l9_2)*l9_10.w);
l9_9=vec4(l9_13.x,l9_13.y,l9_13.z,l9_2.w);
}
#else
{
l9_9=l9_2;
}
#endif
vec4 l9_14;
#if (sc_RenderingSpace==3)
{
l9_14=sc_ApplyScreenSpaceInstancedClippedShift(l9_9);
}
#else
{
vec4 l9_15;
#if (sc_RenderingSpace==2)
{
l9_15=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_9;
}
#else
{
vec4 l9_16;
#if (sc_RenderingSpace==1)
{
l9_16=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_9;
}
#else
{
vec4 l9_17;
#if (sc_RenderingSpace==4)
{
l9_17=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_9)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_17=l9_9;
}
#endif
l9_16=l9_17;
}
#endif
l9_15=l9_16;
}
#endif
l9_14=l9_15;
}
#endif
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_14.x,l9_14.y,l9_14.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_9.x,l9_9.y,l9_9.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_18=sc_ModelMatrix*l9_9;
varPosAndMotion=vec4(l9_18.x,l9_18.y,l9_18.z,varPosAndMotion.w);
}
#endif
}
#endif
}
#endif
varTex01=vec4(l9_1.x,l9_1.y,varTex01.z,varTex01.w);
varTex01=vec4(varTex01.x,varTex01.y,l9_0.x,l9_0.y);
varScreenPos=l9_14;
vec2 l9_19=((l9_14.xy/vec2(l9_14.w))*0.5)+vec2(0.5);
vec2 l9_20;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_21=vec3(l9_19,0.0);
l9_21.y=((2.0*l9_19.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_20=l9_21.xy;
}
#else
{
l9_20=l9_19;
}
#endif
varScreenTexturePos=l9_20;
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_22;
#if (sc_RenderingSpace==1)
{
l9_22=sc_ModelMatrix*l9_9;
}
#else
{
l9_22=l9_9;
}
#endif
vec4 l9_23=sc_ProjectorMatrix*l9_22;
varShadowTex=((l9_23.xy/vec2(l9_23.w))*0.5)+vec2(0.5);
}
#endif
#if ((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass)
{
vec4 l9_24;
#if (sc_RenderingSpace==3)
{
l9_24=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_9;
}
#else
{
vec4 l9_25;
#if (sc_RenderingSpace==2)
{
l9_25=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_9;
}
#else
{
vec4 l9_26;
#if (sc_RenderingSpace==1)
{
l9_26=sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_9;
}
#else
{
l9_26=l9_9;
}
#endif
l9_25=l9_26;
}
#endif
l9_24=l9_25;
}
#endif
varViewSpaceDepth=-l9_24.z;
}
#endif
vec4 l9_27;
#if (sc_DepthBufferMode==1)
{
vec4 l9_28;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_29=l9_14;
l9_29.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_14.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_14.w;
l9_28=l9_29;
}
else
{
l9_28=l9_14;
}
l9_27=l9_28;
}
#else
{
l9_27=l9_14;
}
#endif
vec4 l9_30=l9_27*1.0;
vec4 l9_31;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_32=l9_30;
l9_32.x=l9_30.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_31=l9_32;
}
#else
{
l9_31=l9_30;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_33=dot(l9_31,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_33);
}
#else
{
varClipDistance=l9_33;
}
#endif
}
#endif
gl_Position=l9_31;
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
#ifndef sc_BlendMode_Normal
#define sc_BlendMode_Normal 0
#elif sc_BlendMode_Normal==1
#undef sc_BlendMode_Normal
#define sc_BlendMode_Normal 1
#endif
#ifndef sc_BlendMode_AlphaToCoverage
#define sc_BlendMode_AlphaToCoverage 0
#elif sc_BlendMode_AlphaToCoverage==1
#undef sc_BlendMode_AlphaToCoverage
#define sc_BlendMode_AlphaToCoverage 1
#endif
#ifndef sc_BlendMode_PremultipliedAlphaHardware
#define sc_BlendMode_PremultipliedAlphaHardware 0
#elif sc_BlendMode_PremultipliedAlphaHardware==1
#undef sc_BlendMode_PremultipliedAlphaHardware
#define sc_BlendMode_PremultipliedAlphaHardware 1
#endif
#ifndef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 0
#elif sc_BlendMode_PremultipliedAlphaAuto==1
#undef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 1
#endif
#ifndef sc_BlendMode_PremultipliedAlpha
#define sc_BlendMode_PremultipliedAlpha 0
#elif sc_BlendMode_PremultipliedAlpha==1
#undef sc_BlendMode_PremultipliedAlpha
#define sc_BlendMode_PremultipliedAlpha 1
#endif
#ifndef sc_BlendMode_AddWithAlphaFactor
#define sc_BlendMode_AddWithAlphaFactor 0
#elif sc_BlendMode_AddWithAlphaFactor==1
#undef sc_BlendMode_AddWithAlphaFactor
#define sc_BlendMode_AddWithAlphaFactor 1
#endif
#ifndef sc_BlendMode_AlphaTest
#define sc_BlendMode_AlphaTest 0
#elif sc_BlendMode_AlphaTest==1
#undef sc_BlendMode_AlphaTest
#define sc_BlendMode_AlphaTest 1
#endif
#ifndef sc_BlendMode_Multiply
#define sc_BlendMode_Multiply 0
#elif sc_BlendMode_Multiply==1
#undef sc_BlendMode_Multiply
#define sc_BlendMode_Multiply 1
#endif
#ifndef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 0
#elif sc_BlendMode_MultiplyOriginal==1
#undef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 1
#endif
#ifndef sc_BlendMode_ColoredGlass
#define sc_BlendMode_ColoredGlass 0
#elif sc_BlendMode_ColoredGlass==1
#undef sc_BlendMode_ColoredGlass
#define sc_BlendMode_ColoredGlass 1
#endif
#ifndef sc_BlendMode_Add
#define sc_BlendMode_Add 0
#elif sc_BlendMode_Add==1
#undef sc_BlendMode_Add
#define sc_BlendMode_Add 1
#endif
#ifndef sc_BlendMode_Screen
#define sc_BlendMode_Screen 0
#elif sc_BlendMode_Screen==1
#undef sc_BlendMode_Screen
#define sc_BlendMode_Screen 1
#endif
#ifndef sc_BlendMode_Min
#define sc_BlendMode_Min 0
#elif sc_BlendMode_Min==1
#undef sc_BlendMode_Min
#define sc_BlendMode_Min 1
#endif
#ifndef sc_BlendMode_Max
#define sc_BlendMode_Max 0
#elif sc_BlendMode_Max==1
#undef sc_BlendMode_Max
#define sc_BlendMode_Max 1
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
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
#ifndef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 0
#elif maskTextureHasSwappedViews==1
#undef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 1
#endif
#ifndef maskTextureLayout
#define maskTextureLayout 0
#endif
#ifndef EMOCHECKERS
#define EMOCHECKERS 0
#elif EMOCHECKERS==1
#undef EMOCHECKERS
#define EMOCHECKERS 1
#endif
#ifndef NOTEXTURE
#define NOTEXTURE 0
#elif NOTEXTURE==1
#undef NOTEXTURE
#define NOTEXTURE 1
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
#ifndef NOMASK
#define NOMASK 0
#elif NOMASK==1
#undef NOMASK
#define NOMASK 1
#endif
#ifndef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 0
#elif SC_USE_UV_TRANSFORM_maskTexture==1
#undef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_maskTexture
#define SC_SOFTWARE_WRAP_MODE_U_maskTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_maskTexture
#define SC_SOFTWARE_WRAP_MODE_V_maskTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 0
#elif SC_USE_UV_MIN_MAX_maskTexture==1
#undef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 0
#elif SC_USE_CLAMP_TO_BORDER_maskTexture==1
#undef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 1
#endif
#ifndef ENABLESHADOWS
#define ENABLESHADOWS 0
#elif ENABLESHADOWS==1
#undef ENABLESHADOWS
#define ENABLESHADOWS 1
#endif
#ifndef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 0
#elif sc_ProjectiveShadowsCaster==1
#undef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 1
#endif
uniform float sc_ShadowDensity;
uniform vec4 sc_ShadowColor;
uniform vec4 sc_UniformConstants;
uniform vec4 mainColor;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform mediump sampler2DArray mainTextureArrSC;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2DArray maskTextureArrSC;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2D sc_ShadowTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in float varViewSpaceDepth;
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
#if (EMOCHECKERS)
{
float l9_1=abs(dot(step(vec2(0.5),fract(varTex01.xy*2.0)),vec2(1.0))-1.0);
l9_0=vec4(l9_1,0.0,l9_1,1.0);
}
#else
{
vec4 l9_2;
#if (!NOTEXTURE)
{
vec4 l9_3;
#if (mainTextureLayout==2)
{
l9_3=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_3=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
l9_2=mainColor*l9_3;
}
#else
{
l9_2=mainColor;
}
#endif
vec4 l9_4;
#if (!NOMASK)
{
vec4 l9_5;
#if (maskTextureLayout==2)
{
l9_5=sc_SampleTextureBias(maskTextureLayout,maskTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTextureArrSC);
}
#else
{
l9_5=sc_SampleTextureBias(maskTextureLayout,maskTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
}
#endif
vec4 l9_6=l9_2;
l9_6.w=l9_2.w*l9_5.x;
l9_4=l9_6;
}
#else
{
l9_4=l9_2;
}
#endif
l9_0=l9_4;
}
#endif
vec4 l9_7;
#if (ENABLESHADOWS)
{
vec4 l9_8;
#if (sc_ProjectiveShadowsReceiver)
{
vec3 l9_9;
#if (sc_ProjectiveShadowsReceiver)
{
vec2 l9_10=abs(varShadowTex-vec2(0.5));
vec4 l9_11=texture(sc_ShadowTexture,varShadowTex)*step(max(l9_10.x,l9_10.y),0.5);
l9_9=mix(vec3(1.0),mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_11.xyz,vec3(sc_ShadowColor.w)),vec3(l9_11.w*sc_ShadowDensity));
}
#else
{
l9_9=vec3(1.0);
}
#endif
vec3 l9_12=l9_0.xyz*l9_9;
l9_8=vec4(l9_12.x,l9_12.y,l9_12.z,l9_0.w);
}
#else
{
l9_8=l9_0;
}
#endif
vec4 l9_13;
#if (sc_ProjectiveShadowsCaster)
{
float l9_14;
#if (((sc_BlendMode_Normal||sc_BlendMode_AlphaToCoverage)||sc_BlendMode_PremultipliedAlphaHardware)||sc_BlendMode_PremultipliedAlphaAuto)
{
l9_14=l9_8.w;
}
#else
{
float l9_15;
#if (sc_BlendMode_PremultipliedAlpha)
{
l9_15=clamp(l9_8.w*2.0,0.0,1.0);
}
#else
{
float l9_16;
#if (sc_BlendMode_AddWithAlphaFactor)
{
l9_16=clamp(dot(l9_8.xyz,vec3(l9_8.w)),0.0,1.0);
}
#else
{
float l9_17;
#if (sc_BlendMode_AlphaTest)
{
l9_17=1.0;
}
#else
{
float l9_18;
#if (sc_BlendMode_Multiply)
{
l9_18=(1.0-dot(l9_8.xyz,vec3(0.33333001)))*l9_8.w;
}
#else
{
float l9_19;
#if (sc_BlendMode_MultiplyOriginal)
{
l9_19=(1.0-clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0))*l9_8.w;
}
#else
{
float l9_20;
#if (sc_BlendMode_ColoredGlass)
{
l9_20=clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0)*l9_8.w;
}
#else
{
float l9_21;
#if (sc_BlendMode_Add)
{
l9_21=clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_22;
#if (sc_BlendMode_AddWithAlphaFactor)
{
l9_22=clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0)*l9_8.w;
}
#else
{
float l9_23;
#if (sc_BlendMode_Screen)
{
l9_23=dot(l9_8.xyz,vec3(0.33333001))*l9_8.w;
}
#else
{
float l9_24;
#if (sc_BlendMode_Min)
{
l9_24=1.0-clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_25;
#if (sc_BlendMode_Max)
{
l9_25=clamp(dot(l9_8.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
l9_25=1.0;
}
#endif
l9_24=l9_25;
}
#endif
l9_23=l9_24;
}
#endif
l9_22=l9_23;
}
#endif
l9_21=l9_22;
}
#endif
l9_20=l9_21;
}
#endif
l9_19=l9_20;
}
#endif
l9_18=l9_19;
}
#endif
l9_17=l9_18;
}
#endif
l9_16=l9_17;
}
#endif
l9_15=l9_16;
}
#endif
l9_14=l9_15;
}
#endif
l9_13=vec4(mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_8.xyz,vec3(sc_ShadowColor.w)),sc_ShadowDensity*l9_14);
}
#else
{
l9_13=l9_8;
}
#endif
l9_7=l9_13;
}
#else
{
l9_7=l9_0;
}
#endif
sc_writeFragData0Internal(l9_7,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
