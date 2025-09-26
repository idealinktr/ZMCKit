#pragma clang diagnostic ignored "-Wmissing-prototypes"
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
namespace SNAP_VS {
int sc_GetStereoViewIndex()
{
return 0;
}
}
#ifndef sc_TextureRenderingLayout_Regular
#define sc_TextureRenderingLayout_Regular 0
#define sc_TextureRenderingLayout_StereoInstancedClipped 1
#define sc_TextureRenderingLayout_StereoMultiview 2
#endif
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
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec3 positionNext 15
//attribute vec3 positionPrevious 16
//attribute vec4 strandProperties 17
//output vec4 FragColor0 0
//output vec4 FragColor1 1
//output vec4 FragColor2 2
//output vec4 FragColor3 3
//ubo float sc_BonesUBO 0:3:96 {
//sc_Bone_t sc_Bones 0:[1]:96
//float4 sc_Bones.boneMatrix 0:[3]:16
//float4 sc_Bones.normalMatrix 48:[3]:16
//}
//ubo int UserUniforms 0:26:4208 {
//float4 sc_UniformConstants 1392
//float4x4 sc_ModelViewProjectionMatrixArray 1424:[2]:64
//float4x4 sc_ViewProjectionMatrixArray 1680:[2]:64
//float4x4 sc_ModelViewMatrixArray 1936:[2]:64
//float4x4 sc_ProjectionMatrixArray 2384:[2]:64
//float4x4 sc_ProjectionMatrixInverseArray 2512:[2]:64
//float4x4 sc_ViewMatrixArray 2640:[2]:64
//float4x4 sc_ModelMatrix 3024
//float3x3 sc_NormalMatrix 3152
//sc_Camera_t sc_Camera 3472
//float3 sc_Camera.position 0
//float sc_Camera.aspect 16
//float2 sc_Camera.clipPlanes 24
//float4x4 sc_ProjectorMatrix 3536
//float4 weights0 3616
//float4 weights1 3632
//float4 sc_StereoClipPlanes 3664:[2]:16
//float3 uniMainTextureSize 4192
//}
//ssbo int sc_RayTracingCasterIndexBuffer 0:0:4 {
//uint sc_RayTracingCasterTriangles 0:[1]:4
//}
//ssbo float sc_RayTracingCasterNonAnimatedVertexBuffer 0:2:4 {
//float sc_RayTracingCasterNonAnimatedVertices 0:[1]:4
//}
//ssbo float sc_RayTracingCasterVertexBuffer 0:1:4 {
//float sc_RayTracingCasterVertices 0:[1]:4
//}
//spec_const bool sc_OITCompositingPass 0 0
//spec_const bool sc_OITDepthBoundsPass 1 0
//spec_const bool sc_OITDepthGatherPass 2 0
//spec_const bool sc_ProjectiveShadowsReceiver 3 0
//spec_const bool sc_VertexBlendingUseNormals 4 0
//spec_const bool sc_VertexBlending 5 0
//spec_const int sc_DepthBufferMode 6 0
//spec_const int sc_RenderingSpace 7 -1
//spec_const int sc_ShaderCacheConstant 8 0
//spec_const int sc_SkinBonesCount 9 0
//spec_const int sc_StereoRenderingMode 10 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 11 0
//SG_REFLECTION_END
constant bool sc_OITCompositingPass [[function_constant(0)]];
constant bool sc_OITCompositingPass_tmp = is_function_constant_defined(sc_OITCompositingPass) ? sc_OITCompositingPass : false;
constant bool sc_OITDepthBoundsPass [[function_constant(1)]];
constant bool sc_OITDepthBoundsPass_tmp = is_function_constant_defined(sc_OITDepthBoundsPass) ? sc_OITDepthBoundsPass : false;
constant bool sc_OITDepthGatherPass [[function_constant(2)]];
constant bool sc_OITDepthGatherPass_tmp = is_function_constant_defined(sc_OITDepthGatherPass) ? sc_OITDepthGatherPass : false;
constant bool sc_ProjectiveShadowsReceiver [[function_constant(3)]];
constant bool sc_ProjectiveShadowsReceiver_tmp = is_function_constant_defined(sc_ProjectiveShadowsReceiver) ? sc_ProjectiveShadowsReceiver : false;
constant bool sc_VertexBlendingUseNormals [[function_constant(4)]];
constant bool sc_VertexBlendingUseNormals_tmp = is_function_constant_defined(sc_VertexBlendingUseNormals) ? sc_VertexBlendingUseNormals : false;
constant bool sc_VertexBlending [[function_constant(5)]];
constant bool sc_VertexBlending_tmp = is_function_constant_defined(sc_VertexBlending) ? sc_VertexBlending : false;
constant int sc_DepthBufferMode [[function_constant(6)]];
constant int sc_DepthBufferMode_tmp = is_function_constant_defined(sc_DepthBufferMode) ? sc_DepthBufferMode : 0;
constant int sc_RenderingSpace [[function_constant(7)]];
constant int sc_RenderingSpace_tmp = is_function_constant_defined(sc_RenderingSpace) ? sc_RenderingSpace : -1;
constant int sc_ShaderCacheConstant [[function_constant(8)]];
constant int sc_ShaderCacheConstant_tmp = is_function_constant_defined(sc_ShaderCacheConstant) ? sc_ShaderCacheConstant : 0;
constant int sc_SkinBonesCount [[function_constant(9)]];
constant int sc_SkinBonesCount_tmp = is_function_constant_defined(sc_SkinBonesCount) ? sc_SkinBonesCount : 0;
constant int sc_StereoRenderingMode [[function_constant(10)]];
constant int sc_StereoRenderingMode_tmp = is_function_constant_defined(sc_StereoRenderingMode) ? sc_StereoRenderingMode : 0;
constant int sc_StereoRendering_IsClipDistanceEnabled [[function_constant(11)]];
constant int sc_StereoRendering_IsClipDistanceEnabled_tmp = is_function_constant_defined(sc_StereoRendering_IsClipDistanceEnabled) ? sc_StereoRendering_IsClipDistanceEnabled : 0;

namespace SNAP_VS {
struct sc_Vertex_t
{
float4 position;
float3 normal;
float3 tangent;
float2 texture0;
float2 texture1;
};
struct sc_PointLight_t
{
int falloffEnabled;
float falloffEndDistance;
float negRcpFalloffEndDistance4;
float angleScale;
float angleOffset;
float3 direction;
float3 position;
float4 color;
};
struct sc_DirectionalLight_t
{
float3 direction;
float4 color;
};
struct sc_AmbientLight_t
{
float3 color;
float intensity;
};
struct sc_SphericalGaussianLight_t
{
float3 color;
float sharpness;
float3 axis;
};
struct sc_LightEstimationData_t
{
sc_SphericalGaussianLight_t sg[12];
float3 ambientLight;
};
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct userUniformsObj
{
sc_PointLight_t sc_PointLights[3];
sc_DirectionalLight_t sc_DirectionalLights[5];
sc_AmbientLight_t sc_AmbientLights[3];
sc_LightEstimationData_t sc_LightEstimationData;
float4 sc_EnvmapDiffuseSize;
float4 sc_EnvmapDiffuseDims;
float4 sc_EnvmapDiffuseView;
float4 sc_EnvmapSpecularSize;
float4 sc_EnvmapSpecularDims;
float4 sc_EnvmapSpecularView;
float3 sc_EnvmapRotation;
float sc_EnvmapExposure;
float3 sc_Sh[9];
float sc_ShIntensity;
float4 sc_Time;
float4 sc_UniformConstants;
float4 sc_GeometryInfo;
float4x4 sc_ModelViewProjectionMatrixArray[2];
float4x4 sc_ModelViewProjectionMatrixInverseArray[2];
float4x4 sc_ViewProjectionMatrixArray[2];
float4x4 sc_ViewProjectionMatrixInverseArray[2];
float4x4 sc_ModelViewMatrixArray[2];
float4x4 sc_ModelViewMatrixInverseArray[2];
float3x3 sc_ViewNormalMatrixArray[2];
float3x3 sc_ViewNormalMatrixInverseArray[2];
float4x4 sc_ProjectionMatrixArray[2];
float4x4 sc_ProjectionMatrixInverseArray[2];
float4x4 sc_ViewMatrixArray[2];
float4x4 sc_ViewMatrixInverseArray[2];
float4x4 sc_PrevFrameViewProjectionMatrixArray[2];
float4x4 sc_ModelMatrix;
float4x4 sc_ModelMatrixInverse;
float3x3 sc_NormalMatrix;
float3x3 sc_NormalMatrixInverse;
float4x4 sc_PrevFrameModelMatrix;
float4x4 sc_PrevFrameModelMatrixInverse;
float3 sc_LocalAabbMin;
float3 sc_LocalAabbMax;
float3 sc_WorldAabbMin;
float3 sc_WorldAabbMax;
float4 sc_WindowToViewportTransform;
float4 sc_CurrentRenderTargetDims;
sc_Camera_t sc_Camera;
float sc_ShadowDensity;
float4 sc_ShadowColor;
float4x4 sc_ProjectorMatrix;
float shaderComplexityValue;
float4 weights0;
float4 weights1;
float4 weights2;
float4 sc_StereoClipPlanes[2];
int sc_FallbackInstanceID;
float2 sc_TAAJitterOffset;
float strandWidth;
float strandTaper;
float4 sc_StrandDataMapTextureSize;
float clumpInstanceCount;
float clumpRadius;
float clumpTipScale;
float hairstyleInstanceCount;
float hairstyleNoise;
float4 sc_ScreenTextureSize;
float4 sc_ScreenTextureDims;
float4 sc_ScreenTextureView;
int sc_RayTracingReceiverEffectsMask;
float4 sc_RayTracingReflectionsSize;
float4 sc_RayTracingReflectionsDims;
float4 sc_RayTracingReflectionsView;
float4 sc_RayTracingGlobalIlluminationSize;
float4 sc_RayTracingGlobalIlluminationDims;
float4 sc_RayTracingGlobalIlluminationView;
float4 sc_RayTracingShadowsSize;
float4 sc_RayTracingShadowsDims;
float4 sc_RayTracingShadowsView;
float3 sc_RayTracingOriginScale;
uint sc_RayTracingReceiverMask;
float3 sc_RayTracingOriginScaleInv;
float3 sc_RayTracingOriginOffset;
uint sc_RayTracingReceiverId;
uint4 sc_RayTracingCasterConfiguration;
uint4 sc_RayTracingCasterOffsetPNTC;
uint4 sc_RayTracingCasterOffsetTexture;
uint4 sc_RayTracingCasterFormatPNTC;
uint4 sc_RayTracingCasterFormatTexture;
float4 sc_RayTracingRayDirectionSize;
float4 sc_RayTracingRayDirectionDims;
float4 sc_RayTracingRayDirectionView;
float3 uniMainTextureSize;
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_Bones_obj
{
sc_Bone_t sc_Bones[1];
};
struct sc_RayTracingCasterIndexBuffer_obj
{
uint sc_RayTracingCasterTriangles[1];
};
struct sc_RayTracingCasterVertexBuffer_obj
{
float sc_RayTracingCasterVertices[1];
};
struct sc_RayTracingCasterNonAnimatedVertexBuffer_obj
{
float sc_RayTracingCasterNonAnimatedVertices[1];
};
struct sc_Set0
{
const device sc_RayTracingCasterIndexBuffer_obj* sc_RayTracingCasterIndexBuffer [[id(0)]];
const device sc_RayTracingCasterVertexBuffer_obj* sc_RayTracingCasterVertexBuffer [[id(1)]];
const device sc_RayTracingCasterNonAnimatedVertexBuffer_obj* sc_RayTracingCasterNonAnimatedVertexBuffer [[id(2)]];
constant sc_Bones_obj* sc_BonesUBO [[id(3)]];
constant userUniformsObj* UserUniforms [[id(26)]];
};
struct main_vert_out
{
float4 varPosAndMotion [[user(locn0)]];
float4 varNormalAndMotion [[user(locn1)]];
float4 varTangent [[user(locn2)]];
float4 varTex01 [[user(locn3)]];
float4 varScreenPos [[user(locn4)]];
float2 varScreenTexturePos [[user(locn5)]];
float varViewSpaceDepth [[user(locn6)]];
float2 varShadowTex [[user(locn7)]];
int varStereoViewID [[user(locn8)]];
float varClipDistance [[user(locn9)]];
float4 gl_Position [[position]];
};
struct main_vert_in
{
float4 position [[attribute(0)]];
float3 normal [[attribute(1)]];
float4 tangent [[attribute(2)]];
float2 texture0 [[attribute(3)]];
float2 texture1 [[attribute(4)]];
float4 boneData [[attribute(5)]];
float3 blendShape0Pos [[attribute(6)]];
float3 blendShape1Pos [[attribute(7)]];
float3 blendShape2Pos [[attribute(8)]];
float3 blendShape3Pos [[attribute(9)]];
float3 blendShape4Pos [[attribute(10)]];
float3 blendShape5Pos [[attribute(11)]];
float3 blendShape0Normal [[attribute(12)]];
float3 blendShape1Normal [[attribute(13)]];
float3 blendShape2Normal [[attribute(14)]];
float3 positionNext [[attribute(15)]];
float3 positionPrevious [[attribute(16)]];
float4 strandProperties [[attribute(17)]];
};
void sc_BlendVertex(thread sc_Vertex_t& v,constant userUniformsObj& UserUniforms,thread float3& blendShape0Pos,thread float3& blendShape0Normal,thread float3& blendShape1Pos,thread float3& blendShape1Normal,thread float3& blendShape2Pos,thread float3& blendShape2Normal,thread float3& blendShape3Pos,thread float3& blendShape4Pos,thread float3& blendShape5Pos)
{
if ((int(sc_VertexBlending_tmp)!=0))
{
if ((int(sc_VertexBlendingUseNormals_tmp)!=0))
{
sc_Vertex_t param=v;
float3 param_1=blendShape0Pos;
float3 param_2=blendShape0Normal;
float param_3=UserUniforms.weights0.x;
sc_Vertex_t l9_0=param;
float3 l9_1=param_1;
float l9_2=param_3;
float3 l9_3=l9_0.position.xyz+(l9_1*l9_2);
l9_0.position=float4(l9_3.x,l9_3.y,l9_3.z,l9_0.position.w);
param=l9_0;
param.normal+=(param_2*param_3);
v=param;
sc_Vertex_t param_4=v;
float3 param_5=blendShape1Pos;
float3 param_6=blendShape1Normal;
float param_7=UserUniforms.weights0.y;
sc_Vertex_t l9_4=param_4;
float3 l9_5=param_5;
float l9_6=param_7;
float3 l9_7=l9_4.position.xyz+(l9_5*l9_6);
l9_4.position=float4(l9_7.x,l9_7.y,l9_7.z,l9_4.position.w);
param_4=l9_4;
param_4.normal+=(param_6*param_7);
v=param_4;
sc_Vertex_t param_8=v;
float3 param_9=blendShape2Pos;
float3 param_10=blendShape2Normal;
float param_11=UserUniforms.weights0.z;
sc_Vertex_t l9_8=param_8;
float3 l9_9=param_9;
float l9_10=param_11;
float3 l9_11=l9_8.position.xyz+(l9_9*l9_10);
l9_8.position=float4(l9_11.x,l9_11.y,l9_11.z,l9_8.position.w);
param_8=l9_8;
param_8.normal+=(param_10*param_11);
v=param_8;
}
else
{
sc_Vertex_t param_12=v;
float3 param_13=blendShape0Pos;
float param_14=UserUniforms.weights0.x;
float3 l9_12=param_12.position.xyz+(param_13*param_14);
param_12.position=float4(l9_12.x,l9_12.y,l9_12.z,param_12.position.w);
v=param_12;
sc_Vertex_t param_15=v;
float3 param_16=blendShape1Pos;
float param_17=UserUniforms.weights0.y;
float3 l9_13=param_15.position.xyz+(param_16*param_17);
param_15.position=float4(l9_13.x,l9_13.y,l9_13.z,param_15.position.w);
v=param_15;
sc_Vertex_t param_18=v;
float3 param_19=blendShape2Pos;
float param_20=UserUniforms.weights0.z;
float3 l9_14=param_18.position.xyz+(param_19*param_20);
param_18.position=float4(l9_14.x,l9_14.y,l9_14.z,param_18.position.w);
v=param_18;
sc_Vertex_t param_21=v;
float3 param_22=blendShape3Pos;
float param_23=UserUniforms.weights0.w;
float3 l9_15=param_21.position.xyz+(param_22*param_23);
param_21.position=float4(l9_15.x,l9_15.y,l9_15.z,param_21.position.w);
v=param_21;
sc_Vertex_t param_24=v;
float3 param_25=blendShape4Pos;
float param_26=UserUniforms.weights1.x;
float3 l9_16=param_24.position.xyz+(param_25*param_26);
param_24.position=float4(l9_16.x,l9_16.y,l9_16.z,param_24.position.w);
v=param_24;
sc_Vertex_t param_27=v;
float3 param_28=blendShape5Pos;
float param_29=UserUniforms.weights1.y;
float3 l9_17=param_27.position.xyz+(param_28*param_29);
param_27.position=float4(l9_17.x,l9_17.y,l9_17.z,param_27.position.w);
v=param_27;
}
}
}
void sc_SkinVertex(thread sc_Vertex_t& v,constant sc_Bones_obj& sc_BonesUBO,thread float4& boneData)
{
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_0=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_0=float4(1.0,fract(boneData.yzw));
l9_0.x-=dot(l9_0.yzw,float3(1.0));
}
float4 l9_1=l9_0;
float4 weights=l9_1;
int index0=int(boneData.x);
int index1=int(boneData.y);
int index2=int(boneData.z);
int index3=int(boneData.w);
int param=index0;
float4 param_1=v.position;
float3 l9_2=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_3=param;
float4 l9_4=sc_BonesUBO.sc_Bones[l9_3].boneMatrix[0];
float4 l9_5=sc_BonesUBO.sc_Bones[l9_3].boneMatrix[1];
float4 l9_6=sc_BonesUBO.sc_Bones[l9_3].boneMatrix[2];
float4 l9_7[3];
l9_7[0]=l9_4;
l9_7[1]=l9_5;
l9_7[2]=l9_6;
l9_2=float3(dot(param_1,l9_7[0]),dot(param_1,l9_7[1]),dot(param_1,l9_7[2]));
}
else
{
l9_2=param_1.xyz;
}
float3 l9_8=l9_2;
float3 l9_9=l9_8;
float l9_10=weights.x;
int param_2=index1;
float4 param_3=v.position;
float3 l9_11=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_12=param_2;
float4 l9_13=sc_BonesUBO.sc_Bones[l9_12].boneMatrix[0];
float4 l9_14=sc_BonesUBO.sc_Bones[l9_12].boneMatrix[1];
float4 l9_15=sc_BonesUBO.sc_Bones[l9_12].boneMatrix[2];
float4 l9_16[3];
l9_16[0]=l9_13;
l9_16[1]=l9_14;
l9_16[2]=l9_15;
l9_11=float3(dot(param_3,l9_16[0]),dot(param_3,l9_16[1]),dot(param_3,l9_16[2]));
}
else
{
l9_11=param_3.xyz;
}
float3 l9_17=l9_11;
float3 l9_18=l9_17;
float l9_19=weights.y;
int param_4=index2;
float4 param_5=v.position;
float3 l9_20=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_21=param_4;
float4 l9_22=sc_BonesUBO.sc_Bones[l9_21].boneMatrix[0];
float4 l9_23=sc_BonesUBO.sc_Bones[l9_21].boneMatrix[1];
float4 l9_24=sc_BonesUBO.sc_Bones[l9_21].boneMatrix[2];
float4 l9_25[3];
l9_25[0]=l9_22;
l9_25[1]=l9_23;
l9_25[2]=l9_24;
l9_20=float3(dot(param_5,l9_25[0]),dot(param_5,l9_25[1]),dot(param_5,l9_25[2]));
}
else
{
l9_20=param_5.xyz;
}
float3 l9_26=l9_20;
float3 l9_27=l9_26;
float l9_28=weights.z;
int param_6=index3;
float4 param_7=v.position;
float3 l9_29=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_30=param_6;
float4 l9_31=sc_BonesUBO.sc_Bones[l9_30].boneMatrix[0];
float4 l9_32=sc_BonesUBO.sc_Bones[l9_30].boneMatrix[1];
float4 l9_33=sc_BonesUBO.sc_Bones[l9_30].boneMatrix[2];
float4 l9_34[3];
l9_34[0]=l9_31;
l9_34[1]=l9_32;
l9_34[2]=l9_33;
l9_29=float3(dot(param_7,l9_34[0]),dot(param_7,l9_34[1]),dot(param_7,l9_34[2]));
}
else
{
l9_29=param_7.xyz;
}
float3 l9_35=l9_29;
float3 l9_36=(((l9_9*l9_10)+(l9_18*l9_19))+(l9_27*l9_28))+(l9_35*weights.w);
v.position=float4(l9_36.x,l9_36.y,l9_36.z,v.position.w);
int param_8=index0;
float3x3 l9_37=float3x3(float3(sc_BonesUBO.sc_Bones[param_8].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[param_8].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[param_8].normalMatrix[2].xyz));
float3x3 l9_38=l9_37;
float3x3 normalMatrix0=l9_38;
int param_9=index1;
float3x3 l9_39=float3x3(float3(sc_BonesUBO.sc_Bones[param_9].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[param_9].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[param_9].normalMatrix[2].xyz));
float3x3 l9_40=l9_39;
float3x3 normalMatrix1=l9_40;
int param_10=index2;
float3x3 l9_41=float3x3(float3(sc_BonesUBO.sc_Bones[param_10].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[param_10].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[param_10].normalMatrix[2].xyz));
float3x3 l9_42=l9_41;
float3x3 normalMatrix2=l9_42;
int param_11=index3;
float3x3 l9_43=float3x3(float3(sc_BonesUBO.sc_Bones[param_11].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[param_11].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[param_11].normalMatrix[2].xyz));
float3x3 l9_44=l9_43;
float3x3 normalMatrix3=l9_44;
v.normal=((((normalMatrix0*v.normal)*weights.x)+((normalMatrix1*v.normal)*weights.y))+((normalMatrix2*v.normal)*weights.z))+((normalMatrix3*v.normal)*weights.w);
v.tangent=((((normalMatrix0*v.tangent)*weights.x)+((normalMatrix1*v.tangent)*weights.y))+((normalMatrix2*v.tangent)*weights.z))+((normalMatrix3*v.tangent)*weights.w);
}
}
void sc_ProcessVertex(thread sc_Vertex_t& v,thread uint& gl_InstanceIndex,thread float4& gl_Position,constant userUniformsObj& UserUniforms,thread float4& varPosAndMotion,thread float4& varNormalAndMotion,thread float& varClipDistance,thread int& varStereoViewID,constant sc_Bones_obj& sc_BonesUBO,thread float4& boneData,thread float3& blendShape0Pos,thread float3& blendShape0Normal,thread float3& blendShape1Pos,thread float3& blendShape1Normal,thread float3& blendShape2Pos,thread float3& blendShape2Normal,thread float3& blendShape3Pos,thread float3& blendShape4Pos,thread float3& blendShape5Pos,thread float4& tangent,thread float4& varTangent,thread float4& varTex01,thread float4& varScreenPos,thread float2& varScreenTexturePos,thread float2& varShadowTex,thread float& varViewSpaceDepth)
{
sc_Vertex_t param=v;
sc_BlendVertex(param,UserUniforms,blendShape0Pos,blendShape0Normal,blendShape1Pos,blendShape1Normal,blendShape2Pos,blendShape2Normal,blendShape3Pos,blendShape4Pos,blendShape5Pos);
v=param;
sc_Vertex_t param_1=v;
sc_SkinVertex(param_1,sc_BonesUBO,boneData);
v=param_1;
float4 param_2=v.position;
float4 l9_0=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
float4 l9_1=param_2;
if (sc_StereoRenderingMode_tmp==1)
{
int l9_2=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2=0;
}
else
{
l9_2=gl_InstanceIndex%2;
}
int l9_3=l9_2;
float l9_4=float(l9_3);
l9_1.y=(l9_1.y*0.5)+(0.5-l9_4);
}
float4 l9_5=l9_1;
l9_0=l9_5;
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_6=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_6=0;
}
else
{
l9_6=gl_InstanceIndex%2;
}
int l9_7=l9_6;
l9_0=UserUniforms.sc_ViewProjectionMatrixArray[l9_7]*param_2;
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_8=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_8=0;
}
else
{
l9_8=gl_InstanceIndex%2;
}
int l9_9=l9_8;
l9_0=UserUniforms.sc_ModelViewProjectionMatrixArray[l9_9]*param_2;
}
else
{
if (sc_RenderingSpace_tmp==4)
{
int l9_10=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_10=0;
}
else
{
l9_10=gl_InstanceIndex%2;
}
int l9_11=l9_10;
param_2=(UserUniforms.sc_ModelViewMatrixArray[l9_11]*param_2)*float4(1.0/UserUniforms.sc_Camera.aspect,1.0,1.0,1.0);
float4 l9_12=param_2;
if (sc_StereoRenderingMode_tmp==1)
{
int l9_13=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_13=0;
}
else
{
l9_13=gl_InstanceIndex%2;
}
int l9_14=l9_13;
float l9_15=float(l9_14);
l9_12.y=(l9_12.y*0.5)+(0.5-l9_15);
}
float4 l9_16=l9_12;
l9_0=l9_16;
}
else
{
l9_0=param_2;
}
}
}
}
float4 l9_17=l9_0;
float4 screenPosition=l9_17;
if ((sc_RenderingSpace_tmp==3)||(sc_RenderingSpace_tmp==4))
{
varPosAndMotion=float4(screenPosition.xyz.x,screenPosition.xyz.y,screenPosition.xyz.z,varPosAndMotion.w);
float3 l9_18=normalize(v.normal);
varNormalAndMotion=float4(l9_18.x,l9_18.y,l9_18.z,varNormalAndMotion.w);
float3 l9_19=normalize(v.tangent);
varTangent=float4(l9_19.x,l9_19.y,l9_19.z,varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==2)
{
varPosAndMotion=float4(v.position.xyz.x,v.position.xyz.y,v.position.xyz.z,varPosAndMotion.w);
float3 l9_20=normalize(v.normal);
varNormalAndMotion=float4(l9_20.x,l9_20.y,l9_20.z,varNormalAndMotion.w);
float3 l9_21=normalize(v.tangent);
varTangent=float4(l9_21.x,l9_21.y,l9_21.z,varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==1)
{
float3 l9_22=(UserUniforms.sc_ModelMatrix*v.position).xyz;
varPosAndMotion=float4(l9_22.x,l9_22.y,l9_22.z,varPosAndMotion.w);
float3 l9_23=normalize(UserUniforms.sc_NormalMatrix*v.normal);
varNormalAndMotion=float4(l9_23.x,l9_23.y,l9_23.z,varNormalAndMotion.w);
float3 l9_24=normalize(UserUniforms.sc_NormalMatrix*v.tangent);
varTangent=float4(l9_24.x,l9_24.y,l9_24.z,varTangent.w);
}
}
}
varTangent.w=tangent.w;
varTex01=float4(v.texture0.x,v.texture0.y,varTex01.z,varTex01.w);
varTex01=float4(varTex01.x,varTex01.y,v.texture1.x,v.texture1.y);
varScreenPos=screenPosition;
float2 globalScreenCoords=((screenPosition.xy/float2(screenPosition.w))*0.5)+float2(0.5);
float2 param_3=globalScreenCoords;
float2 l9_25=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_26=1;
int l9_27=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_27=0;
}
else
{
l9_27=gl_InstanceIndex%2;
}
int l9_28=l9_27;
int l9_29=l9_28;
float3 l9_30=float3(param_3,0.0);
int l9_31=l9_26;
int l9_32=l9_29;
if (l9_31==1)
{
l9_30.y=((2.0*l9_30.y)+float(l9_32))-1.0;
}
float2 l9_33=l9_30.xy;
l9_25=l9_33;
}
else
{
l9_25=param_3;
}
float2 l9_34=l9_25;
varScreenTexturePos=l9_34;
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float4 param_4=v.position;
float4 l9_35=param_4;
if (sc_RenderingSpace_tmp==1)
{
l9_35=UserUniforms.sc_ModelMatrix*param_4;
}
float4 l9_36=UserUniforms.sc_ProjectorMatrix*l9_35;
float2 l9_37=((l9_36.xy/float2(l9_36.w))*0.5)+float2(0.5);
varShadowTex=l9_37;
}
if (((int(sc_OITDepthGatherPass_tmp)!=0)||(int(sc_OITCompositingPass_tmp)!=0))||(int(sc_OITDepthBoundsPass_tmp)!=0))
{
float4 param_5=v.position;
float4 l9_38=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
int l9_39=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_39=0;
}
else
{
l9_39=gl_InstanceIndex%2;
}
int l9_40=l9_39;
l9_38=UserUniforms.sc_ProjectionMatrixInverseArray[l9_40]*param_5;
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_41=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_41=0;
}
else
{
l9_41=gl_InstanceIndex%2;
}
int l9_42=l9_41;
l9_38=UserUniforms.sc_ViewMatrixArray[l9_42]*param_5;
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_43=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_43=0;
}
else
{
l9_43=gl_InstanceIndex%2;
}
int l9_44=l9_43;
l9_38=UserUniforms.sc_ModelViewMatrixArray[l9_44]*param_5;
}
else
{
l9_38=param_5;
}
}
}
float4 l9_45=l9_38;
varViewSpaceDepth=-l9_45.z;
}
float4 param_6=screenPosition;
if (sc_DepthBufferMode_tmp==1)
{
int l9_46=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_46=0;
}
else
{
l9_46=gl_InstanceIndex%2;
}
int l9_47=l9_46;
if (UserUniforms.sc_ProjectionMatrixArray[l9_47][2].w!=0.0)
{
float l9_48=2.0/log2(UserUniforms.sc_Camera.clipPlanes.y+1.0);
param_6.z=((log2(fast::max(UserUniforms.sc_Camera.clipPlanes.x,1.0+param_6.w))*l9_48)-1.0)*param_6.w;
}
}
float4 l9_49=param_6;
screenPosition=l9_49;
float4 clipPosition=screenPosition*1.0;
float4 param_7=clipPosition;
if (sc_ShaderCacheConstant_tmp!=0)
{
param_7.x+=(UserUniforms.sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
if (sc_StereoRenderingMode_tmp>0)
{
varStereoViewID=gl_InstanceIndex%2;
}
float4 l9_50=param_7;
if (sc_StereoRenderingMode_tmp==1)
{
float l9_51=dot(l9_50,UserUniforms.sc_StereoClipPlanes[gl_InstanceIndex%2]);
float l9_52=l9_51;
if (sc_StereoRendering_IsClipDistanceEnabled_tmp==1)
{
}
else
{
varClipDistance=l9_52;
}
}
float4 l9_53=float4(param_7.x,-param_7.y,(param_7.z*0.5)+(param_7.w*0.5),param_7.w);
gl_Position=l9_53;
}
vertex main_vert_out main_vert(main_vert_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],uint gl_InstanceIndex [[instance_id]])
{
main_vert_out out={};
sc_Vertex_t l9_0;
l9_0.position=in.position;
l9_0.normal=in.normal;
l9_0.tangent=in.tangent.xyz;
l9_0.texture0=in.texture0;
l9_0.texture1=in.texture1;
sc_Vertex_t l9_1=l9_0;
sc_Vertex_t v=l9_1;
sc_Vertex_t param=v;
sc_ProcessVertex(param,gl_InstanceIndex,out.gl_Position,(*sc_set0.UserUniforms),out.varPosAndMotion,out.varNormalAndMotion,out.varClipDistance,out.varStereoViewID,(*sc_set0.sc_BonesUBO),in.boneData,in.blendShape0Pos,in.blendShape0Normal,in.blendShape1Pos,in.blendShape1Normal,in.blendShape2Pos,in.blendShape2Normal,in.blendShape3Pos,in.blendShape4Pos,in.blendShape5Pos,in.tangent,out.varTangent,out.varTex01,out.varScreenPos,out.varScreenTexturePos,out.varShadowTex,out.varViewSpaceDepth);
return out;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct sc_PointLight_t
{
int falloffEnabled;
float falloffEndDistance;
float negRcpFalloffEndDistance4;
float angleScale;
float angleOffset;
float3 direction;
float3 position;
float4 color;
};
struct sc_DirectionalLight_t
{
float3 direction;
float4 color;
};
struct sc_AmbientLight_t
{
float3 color;
float intensity;
};
struct sc_SphericalGaussianLight_t
{
float3 color;
float sharpness;
float3 axis;
};
struct sc_LightEstimationData_t
{
sc_SphericalGaussianLight_t sg[12];
float3 ambientLight;
};
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct userUniformsObj
{
sc_PointLight_t sc_PointLights[3];
sc_DirectionalLight_t sc_DirectionalLights[5];
sc_AmbientLight_t sc_AmbientLights[3];
sc_LightEstimationData_t sc_LightEstimationData;
float4 sc_EnvmapDiffuseSize;
float4 sc_EnvmapDiffuseDims;
float4 sc_EnvmapDiffuseView;
float4 sc_EnvmapSpecularSize;
float4 sc_EnvmapSpecularDims;
float4 sc_EnvmapSpecularView;
float3 sc_EnvmapRotation;
float sc_EnvmapExposure;
float3 sc_Sh[9];
float sc_ShIntensity;
float4 sc_Time;
float4 sc_UniformConstants;
float4 sc_GeometryInfo;
float4x4 sc_ModelViewProjectionMatrixArray[2];
float4x4 sc_ModelViewProjectionMatrixInverseArray[2];
float4x4 sc_ViewProjectionMatrixArray[2];
float4x4 sc_ViewProjectionMatrixInverseArray[2];
float4x4 sc_ModelViewMatrixArray[2];
float4x4 sc_ModelViewMatrixInverseArray[2];
float3x3 sc_ViewNormalMatrixArray[2];
float3x3 sc_ViewNormalMatrixInverseArray[2];
float4x4 sc_ProjectionMatrixArray[2];
float4x4 sc_ProjectionMatrixInverseArray[2];
float4x4 sc_ViewMatrixArray[2];
float4x4 sc_ViewMatrixInverseArray[2];
float4x4 sc_PrevFrameViewProjectionMatrixArray[2];
float4x4 sc_ModelMatrix;
float4x4 sc_ModelMatrixInverse;
float3x3 sc_NormalMatrix;
float3x3 sc_NormalMatrixInverse;
float4x4 sc_PrevFrameModelMatrix;
float4x4 sc_PrevFrameModelMatrixInverse;
float3 sc_LocalAabbMin;
float3 sc_LocalAabbMax;
float3 sc_WorldAabbMin;
float3 sc_WorldAabbMax;
float4 sc_WindowToViewportTransform;
float4 sc_CurrentRenderTargetDims;
sc_Camera_t sc_Camera;
float sc_ShadowDensity;
float4 sc_ShadowColor;
float4x4 sc_ProjectorMatrix;
float shaderComplexityValue;
float4 weights0;
float4 weights1;
float4 weights2;
float4 sc_StereoClipPlanes[2];
int sc_FallbackInstanceID;
float2 sc_TAAJitterOffset;
float strandWidth;
float strandTaper;
float4 sc_StrandDataMapTextureSize;
float clumpInstanceCount;
float clumpRadius;
float clumpTipScale;
float hairstyleInstanceCount;
float hairstyleNoise;
float4 sc_ScreenTextureSize;
float4 sc_ScreenTextureDims;
float4 sc_ScreenTextureView;
int sc_RayTracingReceiverEffectsMask;
float4 sc_RayTracingReflectionsSize;
float4 sc_RayTracingReflectionsDims;
float4 sc_RayTracingReflectionsView;
float4 sc_RayTracingGlobalIlluminationSize;
float4 sc_RayTracingGlobalIlluminationDims;
float4 sc_RayTracingGlobalIlluminationView;
float4 sc_RayTracingShadowsSize;
float4 sc_RayTracingShadowsDims;
float4 sc_RayTracingShadowsView;
float3 sc_RayTracingOriginScale;
uint sc_RayTracingReceiverMask;
float3 sc_RayTracingOriginScaleInv;
float3 sc_RayTracingOriginOffset;
uint sc_RayTracingReceiverId;
uint4 sc_RayTracingCasterConfiguration;
uint4 sc_RayTracingCasterOffsetPNTC;
uint4 sc_RayTracingCasterOffsetTexture;
uint4 sc_RayTracingCasterFormatPNTC;
uint4 sc_RayTracingCasterFormatTexture;
float4 sc_RayTracingRayDirectionSize;
float4 sc_RayTracingRayDirectionDims;
float4 sc_RayTracingRayDirectionView;
float3 uniMainTextureSize;
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_Bones_obj
{
sc_Bone_t sc_Bones[1];
};
struct sc_RayTracingCasterIndexBuffer_obj
{
uint sc_RayTracingCasterTriangles[1];
};
struct sc_RayTracingCasterVertexBuffer_obj
{
float sc_RayTracingCasterVertices[1];
};
struct sc_RayTracingCasterNonAnimatedVertexBuffer_obj
{
float sc_RayTracingCasterNonAnimatedVertices[1];
};
struct sc_Set0
{
const device sc_RayTracingCasterIndexBuffer_obj* sc_RayTracingCasterIndexBuffer [[id(0)]];
const device sc_RayTracingCasterVertexBuffer_obj* sc_RayTracingCasterVertexBuffer [[id(1)]];
const device sc_RayTracingCasterNonAnimatedVertexBuffer_obj* sc_RayTracingCasterNonAnimatedVertexBuffer [[id(2)]];
constant sc_Bones_obj* sc_BonesUBO [[id(3)]];
constant userUniformsObj* UserUniforms [[id(26)]];
};
struct main_frag_out
{
float4 FragColor0 [[color(0)]];
float4 FragColor1 [[color(1)]];
float4 FragColor2 [[color(2)]];
float4 FragColor3 [[color(3)]];
};
struct main_frag_in
{
float4 varPosAndMotion [[user(locn0)]];
float4 varNormalAndMotion [[user(locn1)]];
float4 varTangent [[user(locn2)]];
float4 varTex01 [[user(locn3)]];
float4 varScreenPos [[user(locn4)]];
float2 varScreenTexturePos [[user(locn5)]];
float varViewSpaceDepth [[user(locn6)]];
float2 varShadowTex [[user(locn7)]];
int varStereoViewID [[user(locn8)]];
float varClipDistance [[user(locn9)]];
};
fragment main_frag_out main_frag(main_frag_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]])
{
main_frag_out out={};
if ((sc_StereoRenderingMode_tmp==1)&&(sc_StereoRendering_IsClipDistanceEnabled_tmp==0))
{
if (in.varClipDistance<0.0)
{
discard_fragment();
}
}
float4 pixel=float4(0.0,0.0,1.0,1.0);
float2 uvAbsolute=in.varTex01.xy*(*sc_set0.UserUniforms).uniMainTextureSize.xy;
float2 uvdx=dfdx(uvAbsolute);
float2 uvdy=dfdy(uvAbsolute);
float uLength2=dot(uvdx,uvdx);
float vLength2=dot(uvdy,uvdy);
float lengthMax=fast::max(uLength2,vLength2);
bool baseLevelPass=false;
float mipLevel=(0.5*log2(lengthMax))-0.5;
if ((*sc_set0.UserUniforms).uniMainTextureSize.z==1.0)
{
baseLevelPass=mipLevel<0.0;
}
else
{
float mipThreshold=0.1;
baseLevelPass=mipLevel<mipThreshold;
}
if (baseLevelPass)
{
pixel=float4(float3(0.0,1.0,0.0).x,float3(0.0,1.0,0.0).y,float3(0.0,1.0,0.0).z,pixel.w);
}
else
{
pixel=float4(float3(1.0,0.0,0.0).x,float3(1.0,0.0,0.0).y,float3(1.0,0.0,0.0).z,pixel.w);
}
float4 param=pixel;
if (sc_ShaderCacheConstant_tmp!=0)
{
param.x+=((*sc_set0.UserUniforms).sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
out.FragColor0=param;
return out;
}
} // FRAGMENT SHADER
