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
struct sc_DrawCallUBO_obj
{
float4x4 sc_ModelMatrix;
float3x3 sc_NormalMatrix;
float4x4 sc_ProjectorMatrix;
float4 weights0;
float4 weights1;
float4x4 sc_ModelViewProjectionMatrixArray[4];
float4x4 sc_ModelViewMatrixArray[4];
};
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct sc_CameraUBO_obj
{
float4 sc_Time;
float4 sc_UniformConstants;
float4x4 sc_ViewProjectionMatrixArray[4];
float4x4 sc_ViewProjectionMatrixInverseArray[4];
float4x4 sc_ProjectionMatrixArray[4];
float4x4 sc_ProjectionMatrixInverseArray[4];
float4x4 sc_ViewMatrixArray[4];
float4x4 sc_ViewMatrixInverseArray[4];
float4x4 sc_PrevFrameViewProjectionMatrixArray[4];
float4 sc_CurrentRenderTargetDims;
float4 sc_WindowToViewportTransform;
float4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_BonesUBO_obj
{
sc_Bone_t sc_Bones[1];
};
struct userUniformsObj
{
float3 uniMainTextureSize;
};
struct sc_Set0
{
};
struct sc_Set1
{
constant sc_CameraUBO_obj* sc_CameraUBO [[id(1)]];
};
struct sc_Set2
{
constant userUniformsObj* UserUniforms [[id(0)]];
constant sc_DrawCallUBO_obj* sc_DrawCallUBO [[id(3)]];
constant sc_BonesUBO_obj* sc_BonesUBO [[id(6)]];
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
void sc_BlendVertex(thread sc_Vertex_t& v,constant sc_DrawCallUBO_obj& sc_DrawCallUBO,thread float3& blendShape0Pos,thread float3& blendShape0Normal,thread float3& blendShape1Pos,thread float3& blendShape1Normal,thread float3& blendShape2Pos,thread float3& blendShape2Normal,thread float3& blendShape3Pos,thread float3& blendShape4Pos,thread float3& blendShape5Pos)
{
if ((int(sc_VertexBlending_tmp)!=0))
{
if ((int(sc_VertexBlendingUseNormals_tmp)!=0))
{
sc_Vertex_t param=v;
float3 param_1=blendShape0Pos;
float3 param_2=blendShape0Normal;
float param_3=sc_DrawCallUBO.weights0.x;
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
float param_7=sc_DrawCallUBO.weights0.y;
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
float param_11=sc_DrawCallUBO.weights0.z;
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
float param_14=sc_DrawCallUBO.weights0.x;
float3 l9_12=param_12.position.xyz+(param_13*param_14);
param_12.position=float4(l9_12.x,l9_12.y,l9_12.z,param_12.position.w);
v=param_12;
sc_Vertex_t param_15=v;
float3 param_16=blendShape1Pos;
float param_17=sc_DrawCallUBO.weights0.y;
float3 l9_13=param_15.position.xyz+(param_16*param_17);
param_15.position=float4(l9_13.x,l9_13.y,l9_13.z,param_15.position.w);
v=param_15;
sc_Vertex_t param_18=v;
float3 param_19=blendShape2Pos;
float param_20=sc_DrawCallUBO.weights0.z;
float3 l9_14=param_18.position.xyz+(param_19*param_20);
param_18.position=float4(l9_14.x,l9_14.y,l9_14.z,param_18.position.w);
v=param_18;
sc_Vertex_t param_21=v;
float3 param_22=blendShape3Pos;
float param_23=sc_DrawCallUBO.weights0.w;
float3 l9_15=param_21.position.xyz+(param_22*param_23);
param_21.position=float4(l9_15.x,l9_15.y,l9_15.z,param_21.position.w);
v=param_21;
sc_Vertex_t param_24=v;
float3 param_25=blendShape4Pos;
float param_26=sc_DrawCallUBO.weights1.x;
float3 l9_16=param_24.position.xyz+(param_25*param_26);
param_24.position=float4(l9_16.x,l9_16.y,l9_16.z,param_24.position.w);
v=param_24;
sc_Vertex_t param_27=v;
float3 param_28=blendShape5Pos;
float param_29=sc_DrawCallUBO.weights1.y;
float3 l9_17=param_27.position.xyz+(param_28*param_29);
param_27.position=float4(l9_17.x,l9_17.y,l9_17.z,param_27.position.w);
v=param_27;
}
}
}
void sc_ProcessVertex(thread sc_Vertex_t& v,thread uint& gl_InstanceIndex,thread float4& gl_Position,constant sc_DrawCallUBO_obj& sc_DrawCallUBO,thread float& varClipDistance,constant sc_CameraUBO_obj& sc_CameraUBO,thread int& varStereoViewID,constant sc_BonesUBO_obj& sc_BonesUBO,thread float4& boneData,thread float3& blendShape0Pos,thread float3& blendShape0Normal,thread float3& blendShape1Pos,thread float3& blendShape1Normal,thread float3& blendShape2Pos,thread float3& blendShape2Normal,thread float3& blendShape3Pos,thread float3& blendShape4Pos,thread float3& blendShape5Pos,thread float4& tangent,thread float4& varPosAndMotion,thread float4& varNormalAndMotion,thread float4& varTangent,thread float4& varTex01,thread float4& varScreenPos,thread float2& varScreenTexturePos,thread float2& varShadowTex,thread float& varViewSpaceDepth)
{
sc_Vertex_t param=v;
sc_BlendVertex(param,sc_DrawCallUBO,blendShape0Pos,blendShape0Normal,blendShape1Pos,blendShape1Normal,blendShape2Pos,blendShape2Normal,blendShape3Pos,blendShape4Pos,blendShape5Pos);
v=param;
sc_Vertex_t param_1=v;
float4 l9_0=param_1.position;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_1=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_1=float4(1.0,fract(boneData.yzw));
l9_1.x-=dot(l9_1.yzw,float3(1.0));
}
float4 l9_2=l9_1;
float4 l9_3=l9_2;
int l9_4=int(boneData.x);
int l9_5=int(boneData.y);
int l9_6=int(boneData.z);
int l9_7=int(boneData.w);
int l9_8=l9_4;
float4 l9_9=l9_0;
float3 l9_10=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_11=l9_8;
float4 l9_12=sc_BonesUBO.sc_Bones[l9_11].boneMatrix[0];
float4 l9_13=sc_BonesUBO.sc_Bones[l9_11].boneMatrix[1];
float4 l9_14=sc_BonesUBO.sc_Bones[l9_11].boneMatrix[2];
float4 l9_15[3];
l9_15[0]=l9_12;
l9_15[1]=l9_13;
l9_15[2]=l9_14;
l9_10=float3(dot(l9_9,l9_15[0]),dot(l9_9,l9_15[1]),dot(l9_9,l9_15[2]));
}
else
{
l9_10=l9_9.xyz;
}
float3 l9_16=l9_10;
float3 l9_17=l9_16;
float l9_18=l9_3.x;
int l9_19=l9_5;
float4 l9_20=l9_0;
float3 l9_21=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_22=l9_19;
float4 l9_23=sc_BonesUBO.sc_Bones[l9_22].boneMatrix[0];
float4 l9_24=sc_BonesUBO.sc_Bones[l9_22].boneMatrix[1];
float4 l9_25=sc_BonesUBO.sc_Bones[l9_22].boneMatrix[2];
float4 l9_26[3];
l9_26[0]=l9_23;
l9_26[1]=l9_24;
l9_26[2]=l9_25;
l9_21=float3(dot(l9_20,l9_26[0]),dot(l9_20,l9_26[1]),dot(l9_20,l9_26[2]));
}
else
{
l9_21=l9_20.xyz;
}
float3 l9_27=l9_21;
float3 l9_28=l9_27;
float l9_29=l9_3.y;
int l9_30=l9_6;
float4 l9_31=l9_0;
float3 l9_32=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_33=l9_30;
float4 l9_34=sc_BonesUBO.sc_Bones[l9_33].boneMatrix[0];
float4 l9_35=sc_BonesUBO.sc_Bones[l9_33].boneMatrix[1];
float4 l9_36=sc_BonesUBO.sc_Bones[l9_33].boneMatrix[2];
float4 l9_37[3];
l9_37[0]=l9_34;
l9_37[1]=l9_35;
l9_37[2]=l9_36;
l9_32=float3(dot(l9_31,l9_37[0]),dot(l9_31,l9_37[1]),dot(l9_31,l9_37[2]));
}
else
{
l9_32=l9_31.xyz;
}
float3 l9_38=l9_32;
float3 l9_39=l9_38;
float l9_40=l9_3.z;
int l9_41=l9_7;
float4 l9_42=l9_0;
float3 l9_43=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_44=l9_41;
float4 l9_45=sc_BonesUBO.sc_Bones[l9_44].boneMatrix[0];
float4 l9_46=sc_BonesUBO.sc_Bones[l9_44].boneMatrix[1];
float4 l9_47=sc_BonesUBO.sc_Bones[l9_44].boneMatrix[2];
float4 l9_48[3];
l9_48[0]=l9_45;
l9_48[1]=l9_46;
l9_48[2]=l9_47;
l9_43=float3(dot(l9_42,l9_48[0]),dot(l9_42,l9_48[1]),dot(l9_42,l9_48[2]));
}
else
{
l9_43=l9_42.xyz;
}
float3 l9_49=l9_43;
float3 l9_50=(((l9_17*l9_18)+(l9_28*l9_29))+(l9_39*l9_40))+(l9_49*l9_3.w);
l9_0=float4(l9_50.x,l9_50.y,l9_50.z,l9_0.w);
}
param_1.position=l9_0;
float3 l9_51=param_1.normal;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_52=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_52=float4(1.0,fract(boneData.yzw));
l9_52.x-=dot(l9_52.yzw,float3(1.0));
}
float4 l9_53=l9_52;
float4 l9_54=l9_53;
int l9_55=int(boneData.x);
int l9_56=int(boneData.y);
int l9_57=int(boneData.z);
int l9_58=int(boneData.w);
int l9_59=l9_55;
float3x3 l9_60=float3x3(float3(sc_BonesUBO.sc_Bones[l9_59].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_59].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_59].normalMatrix[2].xyz));
float3x3 l9_61=l9_60;
float3x3 l9_62=l9_61;
int l9_63=l9_56;
float3x3 l9_64=float3x3(float3(sc_BonesUBO.sc_Bones[l9_63].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_63].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_63].normalMatrix[2].xyz));
float3x3 l9_65=l9_64;
float3x3 l9_66=l9_65;
int l9_67=l9_57;
float3x3 l9_68=float3x3(float3(sc_BonesUBO.sc_Bones[l9_67].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_67].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_67].normalMatrix[2].xyz));
float3x3 l9_69=l9_68;
float3x3 l9_70=l9_69;
int l9_71=l9_58;
float3x3 l9_72=float3x3(float3(sc_BonesUBO.sc_Bones[l9_71].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_71].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_71].normalMatrix[2].xyz));
float3x3 l9_73=l9_72;
float3x3 l9_74=l9_73;
l9_51=((((l9_62*l9_51)*l9_54.x)+((l9_66*l9_51)*l9_54.y))+((l9_70*l9_51)*l9_54.z))+((l9_74*l9_51)*l9_54.w);
}
param_1.normal=l9_51;
float3 l9_75=param_1.tangent;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_76=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_76=float4(1.0,fract(boneData.yzw));
l9_76.x-=dot(l9_76.yzw,float3(1.0));
}
float4 l9_77=l9_76;
float4 l9_78=l9_77;
int l9_79=int(boneData.x);
int l9_80=int(boneData.y);
int l9_81=int(boneData.z);
int l9_82=int(boneData.w);
int l9_83=l9_79;
float3x3 l9_84=float3x3(float3(sc_BonesUBO.sc_Bones[l9_83].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_83].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_83].normalMatrix[2].xyz));
float3x3 l9_85=l9_84;
float3x3 l9_86=l9_85;
int l9_87=l9_80;
float3x3 l9_88=float3x3(float3(sc_BonesUBO.sc_Bones[l9_87].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_87].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_87].normalMatrix[2].xyz));
float3x3 l9_89=l9_88;
float3x3 l9_90=l9_89;
int l9_91=l9_81;
float3x3 l9_92=float3x3(float3(sc_BonesUBO.sc_Bones[l9_91].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_91].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_91].normalMatrix[2].xyz));
float3x3 l9_93=l9_92;
float3x3 l9_94=l9_93;
int l9_95=l9_82;
float3x3 l9_96=float3x3(float3(sc_BonesUBO.sc_Bones[l9_95].normalMatrix[0].xyz),float3(sc_BonesUBO.sc_Bones[l9_95].normalMatrix[1].xyz),float3(sc_BonesUBO.sc_Bones[l9_95].normalMatrix[2].xyz));
float3x3 l9_97=l9_96;
float3x3 l9_98=l9_97;
l9_75=((((l9_86*l9_75)*l9_78.x)+((l9_90*l9_75)*l9_78.y))+((l9_94*l9_75)*l9_78.z))+((l9_98*l9_75)*l9_78.w);
}
param_1.tangent=l9_75;
v=param_1;
float4 param_2=v.position;
float4 l9_99=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
float4 l9_100=param_2;
if (sc_StereoRenderingMode_tmp==1)
{
int l9_101=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_101=0;
}
else
{
l9_101=gl_InstanceIndex%2;
}
int l9_102=l9_101;
float l9_103=float(l9_102);
l9_100.y=(l9_100.y*0.5)+(0.5-l9_103);
}
float4 l9_104=l9_100;
l9_99=l9_104;
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_105=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_105=0;
}
else
{
l9_105=gl_InstanceIndex%2;
}
int l9_106=l9_105;
l9_99=sc_CameraUBO.sc_ViewProjectionMatrixArray[l9_106]*param_2;
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_107=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_107=0;
}
else
{
l9_107=gl_InstanceIndex%2;
}
int l9_108=l9_107;
l9_99=sc_DrawCallUBO.sc_ModelViewProjectionMatrixArray[l9_108]*param_2;
}
else
{
if (sc_RenderingSpace_tmp==4)
{
int l9_109=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_109=0;
}
else
{
l9_109=gl_InstanceIndex%2;
}
int l9_110=l9_109;
param_2=(sc_DrawCallUBO.sc_ModelViewMatrixArray[l9_110]*param_2)*float4(1.0/sc_CameraUBO.sc_Camera.aspect,1.0,1.0,1.0);
float4 l9_111=param_2;
if (sc_StereoRenderingMode_tmp==1)
{
int l9_112=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_112=0;
}
else
{
l9_112=gl_InstanceIndex%2;
}
int l9_113=l9_112;
float l9_114=float(l9_113);
l9_111.y=(l9_111.y*0.5)+(0.5-l9_114);
}
float4 l9_115=l9_111;
l9_99=l9_115;
}
else
{
l9_99=param_2;
}
}
}
}
float4 l9_116=l9_99;
float4 screenPosition=l9_116;
if ((sc_RenderingSpace_tmp==3)||(sc_RenderingSpace_tmp==4))
{
varPosAndMotion=float4(screenPosition.xyz.x,screenPosition.xyz.y,screenPosition.xyz.z,varPosAndMotion.w);
float3 l9_117=normalize(v.normal);
varNormalAndMotion=float4(l9_117.x,l9_117.y,l9_117.z,varNormalAndMotion.w);
float3 l9_118=normalize(v.tangent);
varTangent=float4(l9_118.x,l9_118.y,l9_118.z,varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==2)
{
varPosAndMotion=float4(v.position.xyz.x,v.position.xyz.y,v.position.xyz.z,varPosAndMotion.w);
float3 l9_119=normalize(v.normal);
varNormalAndMotion=float4(l9_119.x,l9_119.y,l9_119.z,varNormalAndMotion.w);
float3 l9_120=normalize(v.tangent);
varTangent=float4(l9_120.x,l9_120.y,l9_120.z,varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==1)
{
float3 l9_121=(sc_DrawCallUBO.sc_ModelMatrix*v.position).xyz;
varPosAndMotion=float4(l9_121.x,l9_121.y,l9_121.z,varPosAndMotion.w);
float3 l9_122=normalize(sc_DrawCallUBO.sc_NormalMatrix*v.normal);
varNormalAndMotion=float4(l9_122.x,l9_122.y,l9_122.z,varNormalAndMotion.w);
float3 l9_123=normalize(sc_DrawCallUBO.sc_NormalMatrix*v.tangent);
varTangent=float4(l9_123.x,l9_123.y,l9_123.z,varTangent.w);
}
}
}
varTangent.w=tangent.w;
varTex01=float4(v.texture0.x,v.texture0.y,varTex01.z,varTex01.w);
varTex01=float4(varTex01.x,varTex01.y,v.texture1.x,v.texture1.y);
varScreenPos=screenPosition;
float2 globalScreenCoords=((screenPosition.xy/float2(screenPosition.w))*0.5)+float2(0.5);
float2 param_3=globalScreenCoords;
float2 l9_124=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_125=1;
int l9_126=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_126=0;
}
else
{
l9_126=gl_InstanceIndex%2;
}
int l9_127=l9_126;
int l9_128=l9_127;
float3 l9_129=float3(param_3,0.0);
int l9_130=l9_125;
int l9_131=l9_128;
if (l9_130==1)
{
l9_129.y=((2.0*l9_129.y)+float(l9_131))-1.0;
}
float2 l9_132=l9_129.xy;
l9_124=l9_132;
}
else
{
l9_124=param_3;
}
float2 l9_133=l9_124;
varScreenTexturePos=l9_133;
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float4 param_4=v.position;
float4 l9_134=param_4;
if (sc_RenderingSpace_tmp==1)
{
l9_134=sc_DrawCallUBO.sc_ModelMatrix*param_4;
}
float4 l9_135=sc_DrawCallUBO.sc_ProjectorMatrix*l9_134;
float2 l9_136=((l9_135.xy/float2(l9_135.w))*0.5)+float2(0.5);
varShadowTex=l9_136;
}
if (((int(sc_OITDepthGatherPass_tmp)!=0)||(int(sc_OITCompositingPass_tmp)!=0))||(int(sc_OITDepthBoundsPass_tmp)!=0))
{
float4 param_5=v.position;
float4 l9_137=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
int l9_138=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_138=0;
}
else
{
l9_138=gl_InstanceIndex%2;
}
int l9_139=l9_138;
l9_137=sc_CameraUBO.sc_ProjectionMatrixInverseArray[l9_139]*param_5;
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_140=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_140=0;
}
else
{
l9_140=gl_InstanceIndex%2;
}
int l9_141=l9_140;
l9_137=sc_CameraUBO.sc_ViewMatrixArray[l9_141]*param_5;
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_142=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_142=0;
}
else
{
l9_142=gl_InstanceIndex%2;
}
int l9_143=l9_142;
l9_137=sc_DrawCallUBO.sc_ModelViewMatrixArray[l9_143]*param_5;
}
else
{
l9_137=param_5;
}
}
}
float4 l9_144=l9_137;
varViewSpaceDepth=-l9_144.z;
}
float4 param_6=screenPosition;
if (sc_DepthBufferMode_tmp==1)
{
int l9_145=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_145=0;
}
else
{
l9_145=gl_InstanceIndex%2;
}
int l9_146=l9_145;
if (sc_CameraUBO.sc_ProjectionMatrixArray[l9_146][2].w!=0.0)
{
float l9_147=2.0/log2(sc_CameraUBO.sc_Camera.clipPlanes.y+1.0);
param_6.z=((log2(fast::max(sc_CameraUBO.sc_Camera.clipPlanes.x,1.0+param_6.w))*l9_147)-1.0)*param_6.w;
}
}
float4 l9_148=param_6;
screenPosition=l9_148;
float4 clipPosition=screenPosition*1.0;
float4 param_7=clipPosition;
if (sc_ShaderCacheConstant_tmp!=0)
{
param_7.x+=(sc_CameraUBO.sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
if (sc_StereoRenderingMode_tmp>0)
{
varStereoViewID=gl_InstanceIndex%2;
}
float4 l9_149=param_7;
if (sc_StereoRenderingMode_tmp==1)
{
float l9_150=dot(l9_149,sc_CameraUBO.sc_StereoClipPlanes[gl_InstanceIndex%2]);
float l9_151=l9_150;
if (sc_StereoRendering_IsClipDistanceEnabled_tmp==1)
{
}
else
{
varClipDistance=l9_151;
}
}
float4 l9_152=float4(param_7.x,-param_7.y,(param_7.z*0.5)+(param_7.w*0.5),param_7.w);
float4 l9_153=l9_152;
gl_Position=l9_153;
}
vertex main_vert_out main_vert(main_vert_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]],uint gl_InstanceIndex [[instance_id]])
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
sc_ProcessVertex(param,gl_InstanceIndex,out.gl_Position,(*sc_set2.sc_DrawCallUBO),out.varClipDistance,(*sc_set1.sc_CameraUBO),out.varStereoViewID,(*sc_set2.sc_BonesUBO),in.boneData,in.blendShape0Pos,in.blendShape0Normal,in.blendShape1Pos,in.blendShape1Normal,in.blendShape2Pos,in.blendShape2Normal,in.blendShape3Pos,in.blendShape4Pos,in.blendShape5Pos,in.tangent,out.varPosAndMotion,out.varNormalAndMotion,out.varTangent,out.varTex01,out.varScreenPos,out.varScreenTexturePos,out.varShadowTex,out.varViewSpaceDepth);
return out;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct sc_CameraUBO_obj
{
float4 sc_Time;
float4 sc_UniformConstants;
float4x4 sc_ViewProjectionMatrixArray[4];
float4x4 sc_ViewProjectionMatrixInverseArray[4];
float4x4 sc_ProjectionMatrixArray[4];
float4x4 sc_ProjectionMatrixInverseArray[4];
float4x4 sc_ViewMatrixArray[4];
float4x4 sc_ViewMatrixInverseArray[4];
float4x4 sc_PrevFrameViewProjectionMatrixArray[4];
float4 sc_CurrentRenderTargetDims;
float4 sc_WindowToViewportTransform;
float4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
};
struct userUniformsObj
{
float3 uniMainTextureSize;
};
struct sc_DrawCallUBO_obj
{
float4x4 sc_ModelMatrix;
float3x3 sc_NormalMatrix;
float4x4 sc_ProjectorMatrix;
float4 weights0;
float4 weights1;
float4x4 sc_ModelViewProjectionMatrixArray[4];
float4x4 sc_ModelViewMatrixArray[4];
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_BonesUBO_obj
{
sc_Bone_t sc_Bones[1];
};
struct sc_Set0
{
};
struct sc_Set1
{
constant sc_CameraUBO_obj* sc_CameraUBO [[id(1)]];
};
struct sc_Set2
{
constant userUniformsObj* UserUniforms [[id(0)]];
constant sc_DrawCallUBO_obj* sc_DrawCallUBO [[id(3)]];
constant sc_BonesUBO_obj* sc_BonesUBO [[id(6)]];
};
struct main_frag_out
{
float4 sc_FragData0 [[color(0)]];
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
fragment main_frag_out main_frag(main_frag_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]])
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
float2 uvAbsolute=in.varTex01.xy*(*sc_set2.UserUniforms).uniMainTextureSize.xy;
float2 uvdx=dfdx(uvAbsolute);
float2 uvdy=dfdy(uvAbsolute);
float uLength2=dot(uvdx,uvdx);
float vLength2=dot(uvdy,uvdy);
float lengthMax=fast::max(uLength2,vLength2);
bool baseLevelPass=false;
float mipLevel=(0.5*log2(lengthMax))-0.5;
if ((*sc_set2.UserUniforms).uniMainTextureSize.z==1.0)
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
param.x+=((*sc_set1.sc_CameraUBO).sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
out.sc_FragData0=param;
return out;
}
} // FRAGMENT SHADER
