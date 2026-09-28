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
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
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
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform vec4 sc_BoneMatrices[((sc_SkinBonesCount*3)+1)];
uniform mat3 sc_SkinBonesNormalMatrices[(sc_SkinBonesCount+1)];
uniform vec4 weights0;
uniform vec4 weights1;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform mat4 sc_ProjectionMatrixInverseArray[sc_NumStereoViews];
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform mat3 sc_NormalMatrix;
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
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out vec4 varTangent;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out float varViewSpaceDepth;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
void blendTargetShapeWithNormal(inout sc_Vertex_t v,vec3 position_1,vec3 normal_1,float weight)
{
vec3 l9_0=v.position.xyz+(position_1*weight);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
v.normal+=(normal_1*weight);
}
vec4 sc_GetBoneWeights()
{
vec4 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 l9_1=vec4(1.0,fract(boneData.yzw));
vec4 l9_2=l9_1;
l9_2.x=1.0-dot(l9_1.yzw,vec3(1.0));
l9_0=l9_2;
}
#else
{
l9_0=vec4(0.0);
}
#endif
return l9_0;
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
vec3 l9_2;
vec3 l9_3;
vec4 l9_4;
#if (sc_VertexBlending)
{
vec2 l9_5;
vec2 l9_6;
vec3 l9_7;
vec3 l9_8;
vec4 l9_9;
#if (sc_VertexBlendingUseNormals)
{
sc_Vertex_t l9_10=sc_Vertex_t(position,normal,tangent.xyz,texture0,texture1);
blendTargetShapeWithNormal(l9_10,blendShape0Pos,blendShape0Normal,weights0.x);
blendTargetShapeWithNormal(l9_10,blendShape1Pos,blendShape1Normal,weights0.y);
blendTargetShapeWithNormal(l9_10,blendShape2Pos,blendShape2Normal,weights0.z);
l9_9=l9_10.position;
l9_8=l9_10.normal;
l9_7=l9_10.tangent;
l9_6=l9_10.texture0;
l9_5=l9_10.texture1;
}
#else
{
vec3 l9_12=(((((position.xyz+(blendShape0Pos*weights0.x)).xyz+(blendShape1Pos*weights0.y)).xyz+(blendShape2Pos*weights0.z)).xyz+(blendShape3Pos*weights0.w)).xyz+(blendShape4Pos*weights1.x)).xyz+(blendShape5Pos*weights1.y);
l9_9=vec4(l9_12.x,l9_12.y,l9_12.z,position.w);
l9_8=normal;
l9_7=tangent.xyz;
l9_6=texture0;
l9_5=texture1;
}
#endif
l9_4=l9_9;
l9_3=l9_8;
l9_2=l9_7;
l9_1=l9_6;
l9_0=l9_5;
}
#else
{
l9_4=position;
l9_3=normal;
l9_2=tangent.xyz;
l9_1=texture0;
l9_0=texture1;
}
#endif
vec4 l9_13;
#if (sc_SkinBonesCount>0)
{
vec4 l9_14=sc_GetBoneWeights();
vec3 l9_15=(((skinVertexPosition(int(boneData.x),l9_4)*l9_14.x)+(skinVertexPosition(int(boneData.y),l9_4)*l9_14.y))+(skinVertexPosition(int(boneData.z),l9_4)*l9_14.z))+(skinVertexPosition(int(boneData.w),l9_4)*l9_14.w);
l9_13=vec4(l9_15.x,l9_15.y,l9_15.z,l9_4.w);
}
#else
{
l9_13=l9_4;
}
#endif
vec3 l9_16;
#if (sc_SkinBonesCount>0)
{
vec4 l9_17=sc_GetBoneWeights();
l9_16=((((sc_SkinBonesNormalMatrices[int(boneData.x)]*l9_3)*l9_17.x)+((sc_SkinBonesNormalMatrices[int(boneData.y)]*l9_3)*l9_17.y))+((sc_SkinBonesNormalMatrices[int(boneData.z)]*l9_3)*l9_17.z))+((sc_SkinBonesNormalMatrices[int(boneData.w)]*l9_3)*l9_17.w);
}
#else
{
l9_16=l9_3;
}
#endif
vec3 l9_18;
#if (sc_SkinBonesCount>0)
{
vec4 l9_19=sc_GetBoneWeights();
l9_18=((((sc_SkinBonesNormalMatrices[int(boneData.x)]*l9_2)*l9_19.x)+((sc_SkinBonesNormalMatrices[int(boneData.y)]*l9_2)*l9_19.y))+((sc_SkinBonesNormalMatrices[int(boneData.z)]*l9_2)*l9_19.z))+((sc_SkinBonesNormalMatrices[int(boneData.w)]*l9_2)*l9_19.w);
}
#else
{
l9_18=l9_2;
}
#endif
vec4 l9_20;
#if (sc_RenderingSpace==3)
{
l9_20=sc_ApplyScreenSpaceInstancedClippedShift(l9_13);
}
#else
{
vec4 l9_21;
#if (sc_RenderingSpace==2)
{
l9_21=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_13;
}
#else
{
vec4 l9_22;
#if (sc_RenderingSpace==1)
{
l9_22=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_13;
}
#else
{
vec4 l9_23;
#if (sc_RenderingSpace==4)
{
l9_23=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_13)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_23=l9_13;
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
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_20.x,l9_20.y,l9_20.z,varPosAndMotion.w);
vec3 l9_24=normalize(l9_16);
varNormalAndMotion=vec4(l9_24.x,l9_24.y,l9_24.z,varNormalAndMotion.w);
vec3 l9_25=normalize(l9_18);
varTangent=vec4(l9_25.x,l9_25.y,l9_25.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_13.x,l9_13.y,l9_13.z,varPosAndMotion.w);
vec3 l9_26=normalize(l9_16);
varNormalAndMotion=vec4(l9_26.x,l9_26.y,l9_26.z,varNormalAndMotion.w);
vec3 l9_27=normalize(l9_18);
varTangent=vec4(l9_27.x,l9_27.y,l9_27.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_28=sc_ModelMatrix*l9_13;
varPosAndMotion=vec4(l9_28.x,l9_28.y,l9_28.z,varPosAndMotion.w);
vec3 l9_29=normalize(sc_NormalMatrix*l9_16);
varNormalAndMotion=vec4(l9_29.x,l9_29.y,l9_29.z,varNormalAndMotion.w);
vec3 l9_30=normalize(sc_NormalMatrix*l9_18);
varTangent=vec4(l9_30.x,l9_30.y,l9_30.z,varTangent.w);
}
#endif
}
#endif
}
#endif
varTangent.w=tangent.w;
varTex01=vec4(l9_1.x,l9_1.y,varTex01.z,varTex01.w);
varTex01=vec4(varTex01.x,varTex01.y,l9_0.x,l9_0.y);
varScreenPos=l9_20;
vec2 l9_31=((l9_20.xy/vec2(l9_20.w))*0.5)+vec2(0.5);
vec2 l9_32;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_33=vec3(l9_31,0.0);
l9_33.y=((2.0*l9_31.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_32=l9_33.xy;
}
#else
{
l9_32=l9_31;
}
#endif
varScreenTexturePos=l9_32;
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_34;
#if (sc_RenderingSpace==1)
{
l9_34=sc_ModelMatrix*l9_13;
}
#else
{
l9_34=l9_13;
}
#endif
vec4 l9_35=sc_ProjectorMatrix*l9_34;
varShadowTex=((l9_35.xy/vec2(l9_35.w))*0.5)+vec2(0.5);
}
#endif
#if ((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass)
{
vec4 l9_36;
#if (sc_RenderingSpace==3)
{
l9_36=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_13;
}
#else
{
vec4 l9_37;
#if (sc_RenderingSpace==2)
{
l9_37=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_13;
}
#else
{
vec4 l9_38;
#if (sc_RenderingSpace==1)
{
l9_38=sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_13;
}
#else
{
l9_38=l9_13;
}
#endif
l9_37=l9_38;
}
#endif
l9_36=l9_37;
}
#endif
varViewSpaceDepth=-l9_36.z;
}
#endif
vec4 l9_39;
#if (sc_DepthBufferMode==1)
{
vec4 l9_40;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_41=l9_20;
l9_41.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_20.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_20.w;
l9_40=l9_41;
}
else
{
l9_40=l9_20;
}
l9_39=l9_40;
}
#else
{
l9_39=l9_20;
}
#endif
vec4 l9_42=l9_39*1.0;
vec4 l9_43;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_44=l9_42;
l9_44.x=l9_42.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_43=l9_44;
}
#else
{
l9_43=l9_42;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_45=dot(l9_43,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_45);
}
#else
{
varClipDistance=l9_45;
}
#endif
}
#endif
gl_Position=l9_43;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
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
uniform vec4 sc_UniformConstants;
uniform vec3 uniMainTextureSize;
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
in vec4 varTex01;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in float varViewSpaceDepth;
in vec2 varShadowTex;
flat in int varStereoViewID;
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
vec2 l9_0=varTex01.xy*uniMainTextureSize.xy;
vec2 l9_1=dFdx(l9_0);
vec2 l9_2=dFdy(l9_0);
float l9_3=(0.5*log2(max(dot(l9_1,l9_1),dot(l9_2,l9_2))))-0.5;
bool l9_4;
if (uniMainTextureSize.z==1.0)
{
l9_4=l9_3<0.0;
}
else
{
l9_4=l9_3<0.1;
}
vec4 l9_5;
if (l9_4)
{
l9_5=vec4(0.0,1.0,0.0,1.0);
}
else
{
l9_5=vec4(1.0,0.0,0.0,1.0);
}
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
sc_FragData0=l9_6;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
