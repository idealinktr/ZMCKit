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
//attribute vec2 texture1 4
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec3 positionNext 15
//attribute vec3 positionPrevious 16
//attribute vec4 strandProperties 17
//sampler sampler lookupTextureSmpSC 0:8
//sampler sampler maskTextureSmpSC 0:9
//sampler sampler sc_ScreenTextureSmpSC 0:13
//texture texture2D lookupTexture 0:0:0:8
//texture texture2D maskTexture 0:1:0:9
//texture texture2D sc_ScreenTexture 0:5:0:13
//texture texture2DArray lookupTextureArrSC 0:16:0:8
//texture texture2DArray maskTextureArrSC 0:17:0:9
//texture texture2DArray sc_ScreenTextureArrSC 0:20:0:13
//spec_const bool ADD_NOISE 0 1
//spec_const bool EYE_SHARPEN 1 0
//spec_const bool EYE_WHITENING 2 0
//spec_const bool IS_LEGACY_LOOKUP 3 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_lookupTexture 4 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_maskTexture 5 0
//spec_const bool SC_USE_UV_MIN_MAX_lookupTexture 6 0
//spec_const bool SC_USE_UV_MIN_MAX_maskTexture 7 0
//spec_const bool SC_USE_UV_TRANSFORM_lookupTexture 8 0
//spec_const bool SC_USE_UV_TRANSFORM_maskTexture 9 0
//spec_const bool SOFT_SKIN 10 0
//spec_const bool TEETH_WHITENING 11 0
//spec_const bool lookupTextureHasSwappedViews 12 0
//spec_const bool maskTextureHasSwappedViews 13 0
//spec_const bool sc_FramebufferFetch 14 0
//spec_const bool sc_OITCompositingPass 15 0
//spec_const bool sc_OITDepthBoundsPass 16 0
//spec_const bool sc_OITDepthGatherPass 17 0
//spec_const bool sc_ProjectiveShadowsReceiver 18 0
//spec_const bool sc_ScreenTextureHasSwappedViews 19 0
//spec_const bool sc_VertexBlending 20 0
//spec_const bool sc_VertexBlendingUseNormals 21 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_lookupTexture 22 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_maskTexture 23 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_lookupTexture 24 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_maskTexture 25 -1
//spec_const int lookupTextureLayout 26 0
//spec_const int maskTextureLayout 27 0
//spec_const int sc_DepthBufferMode 28 0
//spec_const int sc_RenderingSpace 29 -1
//spec_const int sc_ScreenTextureLayout 30 0
//spec_const int sc_ShaderCacheConstant 31 0
//spec_const int sc_SkinBonesCount 32 0
//spec_const int sc_StereoRenderingMode 33 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 34 0
//spec_const int sc_StereoViewID 35 0
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
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
#ifndef SOFT_SKIN
#define SOFT_SKIN 0
#elif SOFT_SKIN==1
#undef SOFT_SKIN
#define SOFT_SKIN 1
#endif
#ifndef EYE_SHARPEN
#define EYE_SHARPEN 0
#elif EYE_SHARPEN==1
#undef EYE_SHARPEN
#define EYE_SHARPEN 1
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
in vec2 texture1;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out float varViewSpaceDepth;
out vec4 varCustomTex0;
out vec4 varCustomTex1;
out vec4 varCustomTex2;
out vec4 varCustomTex3;
out vec4 varTangent;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
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
vec2 l9_0=((position.xy/vec2(position.w))*0.5)+vec2(0.5);
varTex01=vec4(l9_0.x,l9_0.y,varTex01.z,varTex01.w);
#if (SOFT_SKIN)
{
vec2 l9_1=varTex01.xy+vec2(-0.0069444398,-0.00390625);
varCustomTex0=vec4(l9_1.x,l9_1.y,varCustomTex0.z,varCustomTex0.w);
vec2 l9_2=varTex01.xy+vec2(-0.0069444398,0.0054687499);
varCustomTex1=vec4(l9_2.x,l9_2.y,varCustomTex1.z,varCustomTex1.w);
vec2 l9_3=varTex01.xy+vec2(0.0097222198,-0.00390625);
varCustomTex2=vec4(l9_3.x,l9_3.y,varCustomTex2.z,varCustomTex2.w);
vec2 l9_4=varTex01.xy+vec2(0.0097222198,0.0054687499);
varCustomTex3=vec4(l9_4.x,l9_4.y,varCustomTex3.z,varCustomTex3.w);
}
#endif
#if (EYE_SHARPEN)
{
float l9_5=sc_Camera.aspect/1280.0;
float l9_6=-l9_5;
vec2 l9_7=varTex01.xy+vec2(l9_6,-0.00078125001);
varCustomTex0=vec4(varCustomTex0.x,varCustomTex0.y,l9_7.x,l9_7.y);
vec2 l9_8=varTex01.xy+vec2(l9_5,-0.00078125001);
varCustomTex1=vec4(varCustomTex1.x,varCustomTex1.y,l9_8.x,l9_8.y);
vec2 l9_9=varTex01.xy+vec2(l9_6,0.00078125001);
varCustomTex2=vec4(varCustomTex2.x,varCustomTex2.y,l9_9.x,l9_9.y);
vec2 l9_10=varTex01.xy+vec2(l9_5,0.00078125001);
varCustomTex3=vec4(varCustomTex3.x,varCustomTex3.y,l9_10.x,l9_10.y);
}
#endif
vec2 l9_11;
vec4 l9_12;
#if (sc_VertexBlending)
{
vec2 l9_13;
vec4 l9_14;
#if (sc_VertexBlendingUseNormals)
{
sc_Vertex_t l9_15=sc_Vertex_t(position,vec3(0.0),vec3(0.0),vec2(0.0),texture1);
blendTargetShapeWithNormal(l9_15,blendShape0Pos,blendShape0Normal,weights0.x);
blendTargetShapeWithNormal(l9_15,blendShape1Pos,blendShape1Normal,weights0.y);
blendTargetShapeWithNormal(l9_15,blendShape2Pos,blendShape2Normal,weights0.z);
l9_14=l9_15.position;
l9_13=l9_15.texture1;
}
#else
{
vec3 l9_17=(((((position.xyz+(blendShape0Pos*weights0.x)).xyz+(blendShape1Pos*weights0.y)).xyz+(blendShape2Pos*weights0.z)).xyz+(blendShape3Pos*weights0.w)).xyz+(blendShape4Pos*weights1.x)).xyz+(blendShape5Pos*weights1.y);
l9_14=vec4(l9_17.x,l9_17.y,l9_17.z,position.w);
l9_13=texture1;
}
#endif
l9_12=l9_14;
l9_11=l9_13;
}
#else
{
l9_12=position;
l9_11=texture1;
}
#endif
vec4 l9_18;
#if (sc_SkinBonesCount>0)
{
vec4 l9_19;
#if (sc_SkinBonesCount>0)
{
vec4 l9_20=vec4(1.0,fract(boneData.yzw));
vec4 l9_21=l9_20;
l9_21.x=1.0-dot(l9_20.yzw,vec3(1.0));
l9_19=l9_21;
}
#else
{
l9_19=vec4(0.0);
}
#endif
vec3 l9_22=(((skinVertexPosition(int(boneData.x),l9_12)*l9_19.x)+(skinVertexPosition(int(boneData.y),l9_12)*l9_19.y))+(skinVertexPosition(int(boneData.z),l9_12)*l9_19.z))+(skinVertexPosition(int(boneData.w),l9_12)*l9_19.w);
l9_18=vec4(l9_22.x,l9_22.y,l9_22.z,l9_12.w);
}
#else
{
l9_18=l9_12;
}
#endif
vec4 l9_23;
#if (sc_RenderingSpace==3)
{
l9_23=sc_ApplyScreenSpaceInstancedClippedShift(l9_18);
}
#else
{
vec4 l9_24;
#if (sc_RenderingSpace==2)
{
l9_24=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_18;
}
#else
{
vec4 l9_25;
#if (sc_RenderingSpace==1)
{
l9_25=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_18;
}
#else
{
vec4 l9_26;
#if (sc_RenderingSpace==4)
{
l9_26=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_18)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_26=l9_18;
}
#endif
l9_25=l9_26;
}
#endif
l9_24=l9_25;
}
#endif
l9_23=l9_24;
}
#endif
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_23.x,l9_23.y,l9_23.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_18.x,l9_18.y,l9_18.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_27=sc_ModelMatrix*l9_18;
varPosAndMotion=vec4(l9_27.x,l9_27.y,l9_27.z,varPosAndMotion.w);
}
#endif
}
#endif
}
#endif
varTex01=vec4(varTex01.x,varTex01.y,l9_11.x,l9_11.y);
varScreenPos=l9_23;
vec2 l9_28=((l9_23.xy/vec2(l9_23.w))*0.5)+vec2(0.5);
vec2 l9_29;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_30=vec3(l9_28,0.0);
l9_30.y=((2.0*l9_28.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_29=l9_30.xy;
}
#else
{
l9_29=l9_28;
}
#endif
varScreenTexturePos=l9_29;
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_31;
#if (sc_RenderingSpace==1)
{
l9_31=sc_ModelMatrix*l9_18;
}
#else
{
l9_31=l9_18;
}
#endif
vec4 l9_32=sc_ProjectorMatrix*l9_31;
varShadowTex=((l9_32.xy/vec2(l9_32.w))*0.5)+vec2(0.5);
}
#endif
#if ((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass)
{
vec4 l9_33;
#if (sc_RenderingSpace==3)
{
l9_33=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_18;
}
#else
{
vec4 l9_34;
#if (sc_RenderingSpace==2)
{
l9_34=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_18;
}
#else
{
vec4 l9_35;
#if (sc_RenderingSpace==1)
{
l9_35=sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_18;
}
#else
{
l9_35=l9_18;
}
#endif
l9_34=l9_35;
}
#endif
l9_33=l9_34;
}
#endif
varViewSpaceDepth=-l9_33.z;
}
#endif
vec4 l9_36;
#if (sc_DepthBufferMode==1)
{
vec4 l9_37;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_38=l9_23;
l9_38.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_23.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_23.w;
l9_37=l9_38;
}
else
{
l9_37=l9_23;
}
l9_36=l9_37;
}
#else
{
l9_36=l9_23;
}
#endif
vec4 l9_39=l9_36*1.0;
vec4 l9_40;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_41=l9_39;
l9_41.x=l9_39.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_40=l9_41;
}
#else
{
l9_40=l9_39;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_42=dot(l9_40,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_42);
}
#else
{
varClipDistance=l9_42;
}
#endif
}
#endif
gl_Position=l9_40;
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
#ifndef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 0
#elif sc_ScreenTextureHasSwappedViews==1
#undef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 1
#endif
#ifndef sc_ScreenTextureLayout
#define sc_ScreenTextureLayout 0
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#ifndef lookupTextureHasSwappedViews
#define lookupTextureHasSwappedViews 0
#elif lookupTextureHasSwappedViews==1
#undef lookupTextureHasSwappedViews
#define lookupTextureHasSwappedViews 1
#endif
#ifndef lookupTextureLayout
#define lookupTextureLayout 0
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
#ifndef IS_LEGACY_LOOKUP
#define IS_LEGACY_LOOKUP 0
#elif IS_LEGACY_LOOKUP==1
#undef IS_LEGACY_LOOKUP
#define IS_LEGACY_LOOKUP 1
#endif
#ifndef SC_USE_UV_TRANSFORM_lookupTexture
#define SC_USE_UV_TRANSFORM_lookupTexture 0
#elif SC_USE_UV_TRANSFORM_lookupTexture==1
#undef SC_USE_UV_TRANSFORM_lookupTexture
#define SC_USE_UV_TRANSFORM_lookupTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_lookupTexture
#define SC_SOFTWARE_WRAP_MODE_U_lookupTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_lookupTexture
#define SC_SOFTWARE_WRAP_MODE_V_lookupTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_lookupTexture
#define SC_USE_UV_MIN_MAX_lookupTexture 0
#elif SC_USE_UV_MIN_MAX_lookupTexture==1
#undef SC_USE_UV_MIN_MAX_lookupTexture
#define SC_USE_UV_MIN_MAX_lookupTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_lookupTexture
#define SC_USE_CLAMP_TO_BORDER_lookupTexture 0
#elif SC_USE_CLAMP_TO_BORDER_lookupTexture==1
#undef SC_USE_CLAMP_TO_BORDER_lookupTexture
#define SC_USE_CLAMP_TO_BORDER_lookupTexture 1
#endif
#ifndef ADD_NOISE
#define ADD_NOISE 1
#elif ADD_NOISE==1
#undef ADD_NOISE
#define ADD_NOISE 1
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
#ifndef SOFT_SKIN
#define SOFT_SKIN 0
#elif SOFT_SKIN==1
#undef SOFT_SKIN
#define SOFT_SKIN 1
#endif
#ifndef EYE_SHARPEN
#define EYE_SHARPEN 0
#elif EYE_SHARPEN==1
#undef EYE_SHARPEN
#define EYE_SHARPEN 1
#endif
#ifndef EYE_WHITENING
#define EYE_WHITENING 0
#elif EYE_WHITENING==1
#undef EYE_WHITENING
#define EYE_WHITENING 1
#endif
#ifndef TEETH_WHITENING
#define TEETH_WHITENING 0
#elif TEETH_WHITENING==1
#undef TEETH_WHITENING
#define TEETH_WHITENING 1
#endif
uniform vec4 sc_CurrentRenderTargetDims;
uniform vec4 sc_UniformConstants;
uniform mat3 lookupTextureTransform;
uniform vec4 lookupTextureUvMinMax;
uniform vec4 lookupTextureBorderColor;
uniform float softSkinRadius;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform float softSkinIntensity;
uniform float sharpenEyeIntensity;
uniform float eyeWhiteningIntensity;
uniform float teethWhiteningIntensity;
uniform mediump sampler2D sc_ScreenTexture;
uniform mediump sampler2DArray sc_ScreenTextureArrSC;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2DArray maskTextureArrSC;
uniform mediump sampler2D lookupTexture;
uniform mediump sampler2DArray lookupTextureArrSC;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varCustomTex0;
in vec4 varCustomTex1;
in vec4 varCustomTex2;
in vec4 varCustomTex3;
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
int sc_ScreenTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_ScreenTextureHasSwappedViews)
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
vec4 sc_ScreenTextureSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (sc_ScreenTextureLayout==2)
{
l9_0=texture(sc_ScreenTextureArrSC,sc_SamplingCoordsViewToGlobal(uv,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()),bias);
}
#else
{
l9_0=sc_SampleView(uv,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex(),bias,sc_ScreenTexture);
}
#endif
return l9_0;
}
mediump vec4 sc_readFragData0_Platform()
{
return getFragData()[0];
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
int lookupTextureGetStereoViewIndex()
{
int l9_0;
#if (lookupTextureHasSwappedViews)
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
#if (sc_FramebufferFetch)
{
l9_0=sc_readFragData0_Platform();
}
#else
{
vec2 l9_1=gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw;
vec2 l9_2;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_3=vec3(l9_1,0.0);
l9_3.y=((2.0*l9_1.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_2=l9_3.xy;
}
#else
{
l9_2=l9_1;
}
#endif
l9_0=sc_ScreenTextureSampleViewBias(l9_2,0.0);
}
#endif
vec4 l9_4;
#if (maskTextureLayout==2)
{
l9_4=sc_SampleTextureBias(maskTextureLayout,maskTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTextureArrSC);
}
#else
{
l9_4=sc_SampleTextureBias(maskTextureLayout,maskTextureGetStereoViewIndex(),varTex01.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
}
#endif
vec4 l9_5;
#if (SOFT_SKIN)
{
float l9_6=dot(l9_0,vec4(0.29899999,0.58700001,0.114,0.0));
vec4 l9_7=sc_ScreenTextureSampleViewBias(varCustomTex0.xy,0.0);
vec4 l9_8=sc_ScreenTextureSampleViewBias(varCustomTex1.xy,0.0);
vec4 l9_9=sc_ScreenTextureSampleViewBias(varCustomTex2.xy,0.0);
vec4 l9_10=sc_ScreenTextureSampleViewBias(varCustomTex3.xy,0.0);
mat4 l9_11=mat4(l9_7,l9_8,l9_9,l9_10);
vec4 l9_12=log((vec4(0.29899999,0.58700001,0.114,0.0)*l9_11)/vec4(l9_6+1e-06));
vec4 l9_13=exp((l9_12*l9_12)*((-1.0)/((2.0*softSkinRadius)*softSkinRadius)))*0.36787945;
float l9_14=1.0+dot(l9_13,vec4(1.0));
vec4 l9_15=l9_0+(l9_11*l9_13);
vec4 l9_16;
#if (ADD_NOISE)
{
float l9_17=(fract(sin(dot(varTex01.xy,vec2(12.9898,78.233002)))*43758.547)-0.5)/30.0;
l9_16=(l9_15/vec4(l9_14))+vec4(l9_17,l9_17,l9_17,1.0);
}
#else
{
l9_16=l9_15/vec4(l9_14);
}
#endif
l9_5=mix(l9_0,l9_16,vec4(l9_4.x*softSkinIntensity));
}
#else
{
l9_5=l9_0;
}
#endif
vec4 l9_18;
#if (EYE_SHARPEN)
{
l9_18=clamp(mix(l9_5,((((l9_5*5.0)-sc_ScreenTextureSampleViewBias(varCustomTex0.zw,0.0))-sc_ScreenTextureSampleViewBias(varCustomTex1.zw,0.0))-sc_ScreenTextureSampleViewBias(varCustomTex2.zw,0.0))-sc_ScreenTextureSampleViewBias(varCustomTex3.zw,0.0),vec4(l9_4.z*sharpenEyeIntensity)),vec4(0.0),vec4(1.0));
}
#else
{
l9_18=l9_5;
}
#endif
float l9_19;
#if (EYE_WHITENING)
{
l9_19=0.0+(l9_4.z*eyeWhiteningIntensity);
}
#else
{
l9_19=0.0;
}
#endif
float l9_20;
#if (TEETH_WHITENING)
{
l9_20=l9_19+(l9_4.y*teethWhiteningIntensity);
}
#else
{
l9_20=l9_19;
}
#endif
vec4 l9_21;
#if (EYE_WHITENING||TEETH_WHITENING)
{
float l9_22;
vec2 l9_23;
vec4 l9_24;
#if (IS_LEGACY_LOOKUP)
{
float l9_25=(l9_18.z*255.0)/4.0;
vec2 l9_26=clamp(vec2(floor(l9_25))+vec2(0.0,1.0),vec2(0.0),vec2(63.0));
vec2 l9_27=floor((l9_26/vec2(8.0))+vec2(1e-06));
vec4 l9_28=((l9_18.yyxx*0.12304688)+(vec4(l9_27,l9_26-(l9_27*8.0))*0.125))+vec4(0.0009765625);
vec2 l9_29=vec2(l9_28.z,1.0-l9_28.x);
vec2 l9_30=vec2(l9_28.w,1.0-l9_28.y);
l9_24=vec4(l9_29.x,l9_29.y,l9_30.x,l9_30.y);
l9_23=l9_26;
l9_22=l9_25;
}
#else
{
float l9_31=l9_18.z*15.0;
vec2 l9_32=clamp(vec2(floor(l9_31))+vec2(0.0,1.0),vec2(0.0),vec2(15.0));
vec3 l9_33=((l9_18.xxy*vec3(0.05859375,0.05859375,0.9375))+vec3(l9_32*0.0625,0.0))+vec3(0.001953125,0.001953125,0.03125);
l9_24=vec4(l9_33.x,l9_33.z,l9_33.y,l9_33.z);
l9_23=l9_32;
l9_22=l9_31;
}
#endif
float l9_34=l9_22-l9_23.x;
vec4 l9_35;
#if (lookupTextureLayout==2)
{
l9_35=sc_SampleTextureBias(lookupTextureLayout,lookupTextureGetStereoViewIndex(),l9_24.xy,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTextureArrSC);
}
#else
{
l9_35=sc_SampleTextureBias(lookupTextureLayout,lookupTextureGetStereoViewIndex(),l9_24.xy,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTexture);
}
#endif
vec4 l9_36;
#if (lookupTextureLayout==2)
{
l9_36=sc_SampleTextureBias(lookupTextureLayout,lookupTextureGetStereoViewIndex(),l9_24.zw,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTextureArrSC);
}
#else
{
l9_36=sc_SampleTextureBias(lookupTextureLayout,lookupTextureGetStereoViewIndex(),l9_24.zw,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTexture);
}
#endif
l9_21=mix(l9_18,vec4(mix(l9_35.xyz,l9_36.xyz,vec3(l9_34)),l9_18.w),vec4(l9_20));
}
#else
{
l9_21=l9_18;
}
#endif
sc_writeFragData0Internal(l9_21,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
