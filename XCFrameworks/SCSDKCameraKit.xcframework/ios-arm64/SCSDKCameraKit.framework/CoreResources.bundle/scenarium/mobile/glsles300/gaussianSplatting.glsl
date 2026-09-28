#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
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
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_gs_QuatsHalfAngle
#define sc_gs_QuatsHalfAngle 0
#elif sc_gs_QuatsHalfAngle==1
#undef sc_gs_QuatsHalfAngle
#define sc_gs_QuatsHalfAngle 1
#endif
#ifndef sc_gs_QuatsSmallestThree
#define sc_gs_QuatsSmallestThree 0
#elif sc_gs_QuatsSmallestThree==1
#undef sc_gs_QuatsSmallestThree
#define sc_gs_QuatsSmallestThree 1
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_gs_OrthoProjection
#define sc_gs_OrthoProjection 0
#elif sc_gs_OrthoProjection==1
#undef sc_gs_OrthoProjection
#define sc_gs_OrthoProjection 1
#endif
#ifndef sc_ChunkySplats
#define sc_ChunkySplats 0
#elif sc_ChunkySplats==1
#undef sc_ChunkySplats
#define sc_ChunkySplats 1
#endif
#ifndef sc_gs_UseInterFrame
#define sc_gs_UseInterFrame 0
#elif sc_gs_UseInterFrame==1
#undef sc_gs_UseInterFrame
#define sc_gs_UseInterFrame 1
#endif
#ifndef sc_gs_TwoInterFrames
#define sc_gs_TwoInterFrames 0
#elif sc_gs_TwoInterFrames==1
#undef sc_gs_TwoInterFrames
#define sc_gs_TwoInterFrames 1
#endif
#ifndef sc_gs_ErrorPattern
#define sc_gs_ErrorPattern 0
#elif sc_gs_ErrorPattern==1
#undef sc_gs_ErrorPattern
#define sc_gs_ErrorPattern 1
#endif
#ifndef sc_gs_AlphaCutoffEnabled
#define sc_gs_AlphaCutoffEnabled 0
#elif sc_gs_AlphaCutoffEnabled==1
#undef sc_gs_AlphaCutoffEnabled
#define sc_gs_AlphaCutoffEnabled 1
#endif
#ifndef sc_TAAEnabled
#define sc_TAAEnabled 0
#elif sc_TAAEnabled==1
#undef sc_TAAEnabled
#define sc_TAAEnabled 1
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
uniform vec4 dims;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_CurrentRenderTargetDims;
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform float sc_gs_InterpolationFactor;
uniform vec3 sc_LocalAabbMin;
uniform vec3 sc_LocalAabbMax;
uniform mat4 sc_ModelMatrix;
uniform float sc_gs_AlphaCutoff;
uniform vec2 sc_TAAJitterOffset;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_PrevFrameViewProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_PrevFrameModelMatrix;
uniform mediump sampler2D texChunkInfo;
uniform mediump sampler2D texCenterXYZScaleX;
uniform mediump sampler2D texScaleYZ;
uniform mediump sampler2D texRotation;
uniform mediump sampler2D texColor;
uniform mediump sampler2D texCenterDelta;
uniform mediump sampler2D texRotationOverride;
uniform mediump sampler2D texCenterDelta2;
uniform mediump sampler2D texRotationOverride2;
in vec2 uv;
out vec4 varTex01;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
flat out vec4 varColor;
out vec4 varTangent;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
in vec4 position;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
vec3 sc_gs_Scale;
vec4 sc_gs_Rotation;
vec4 sc_gs_Color;
vec4 sc_gs_reconstructQuat(vec4 packed_unorm)
{
vec3 l9_0=(packed_unorm.xyz*2.0)-vec3(1.0);
float l9_1=dot(l9_0,l9_0);
#if (sc_gs_QuatsHalfAngle)
{
if (l9_1>2.0)
{
return vec4(0.0,0.0,0.0,1.0);
}
return vec4(l9_0*sqrt(2.0-l9_1),1.0-l9_1);
}
#endif
#if (sc_gs_QuatsSmallestThree)
{
float l9_2=1.0-l9_1;
float l9_3;
if (l9_2>0.0)
{
l9_3=sqrt(l9_2);
}
else
{
l9_3=0.0;
}
float l9_4=packed_unorm.w;
if (l9_4<0.1)
{
return vec4(l9_3,l9_0.yzx);
}
if (l9_4<0.60000002)
{
return vec4(l9_0.y,l9_3,l9_0.zx);
}
if (l9_4<0.80000001)
{
return vec4(l9_0.yz,l9_3,l9_0.x);
}
return vec4(l9_0,l9_3);
}
#endif
float l9_5=1.0-l9_1;
float l9_6;
if (l9_5>0.0)
{
l9_6=sqrt(l9_5);
}
else
{
l9_6=0.0;
}
return vec4(l9_0,l9_6).yzwx;
}
vec4 sc_gs_nlerpQuat(vec4 q0,vec4 q1,float t)
{
if (dot(q0,q1)<0.0)
{
q1=-q1;
}
vec4 l9_0=mix(q0,q1,vec4(t));
return l9_0*inversesqrt(dot(l9_0,l9_0));
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
vec4 sc_gs_ProcessSplat(vec4 centerWorld,float pointSize)
{
vec4 l9_0=centerWorld;
vec4 l9_1=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_0;
vec4 l9_2=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_1;
float l9_3=l9_2.w;
if (l9_2.z<(-l9_3))
{
return vec4(0.0,0.0,2.0,1.0);
}
float l9_4=sc_gs_Rotation.y*sc_gs_Rotation.y;
float l9_5=sc_gs_Rotation.z*sc_gs_Rotation.z;
float l9_6=sc_gs_Rotation.x*sc_gs_Rotation.y;
float l9_7=sc_gs_Rotation.z*sc_gs_Rotation.w;
float l9_8=sc_gs_Rotation.x*sc_gs_Rotation.z;
float l9_9=sc_gs_Rotation.y*sc_gs_Rotation.w;
float l9_10=sc_gs_Rotation.x*sc_gs_Rotation.x;
float l9_11=sc_gs_Rotation.y*sc_gs_Rotation.z;
float l9_12=sc_gs_Rotation.x*sc_gs_Rotation.w;
mat3 l9_13=mat3(sc_ModelMatrix[0].xyz,sc_ModelMatrix[1].xyz,sc_ModelMatrix[2].xyz)*mat3(vec3(1.0-(2.0*(l9_4+l9_5)),2.0*(l9_6+l9_7),2.0*(l9_8-l9_9)),vec3(2.0*(l9_6-l9_7),1.0-(2.0*(l9_10+l9_5)),2.0*(l9_11+l9_12)),vec3(2.0*(l9_8+l9_9),2.0*(l9_11-l9_12),1.0-(2.0*(l9_10+l9_4))));
float l9_14=sc_gs_Scale.x*l9_13[0].x;
float l9_15=sc_gs_Scale.x*l9_13[0].y;
float l9_16=sc_gs_Scale.x*l9_13[0].z;
float l9_17=sc_gs_Scale.y*l9_13[1].x;
float l9_18=sc_gs_Scale.y*l9_13[1].y;
float l9_19=sc_gs_Scale.y*l9_13[1].z;
float l9_20=sc_gs_Scale.z*l9_13[2].x;
float l9_21=sc_gs_Scale.z*l9_13[2].y;
float l9_22=sc_gs_Scale.z*l9_13[2].z;
float l9_23=((l9_14*l9_15)+(l9_17*l9_18))+(l9_20*l9_21);
float l9_24=((l9_14*l9_16)+(l9_17*l9_19))+(l9_20*l9_22);
float l9_25=((l9_15*l9_16)+(l9_18*l9_19))+(l9_21*l9_22);
float l9_26=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][0].x*sc_CurrentRenderTargetDims.x;
float l9_27=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][1].y*sc_CurrentRenderTargetDims.y;
vec3 l9_28;
#if (sc_gs_OrthoProjection)
{
l9_28=vec3(0.0,0.0,1.0);
}
#else
{
l9_28=l9_1.xyz;
}
#endif
float l9_29=1.0/l9_28.z;
float l9_30=l9_29*l9_29;
int l9_31=sc_GetStereoViewIndex();
mat3 l9_32=mat3(vec3(l9_26*l9_29,0.0,0.0),vec3(0.0,l9_27*l9_29,0.0),vec3(((-l9_26)*l9_28.x)*l9_30,((-l9_27)*l9_28.y)*l9_30,0.0))*mat3(sc_ViewMatrixArray[l9_31][0].xyz,sc_ViewMatrixArray[l9_31][1].xyz,sc_ViewMatrixArray[l9_31][2].xyz);
mat3 l9_33=(l9_32*mat3(vec3(((l9_14*l9_14)+(l9_17*l9_17))+(l9_20*l9_20),l9_23,l9_24),vec3(l9_23,((l9_15*l9_15)+(l9_18*l9_18))+(l9_21*l9_21),l9_25),vec3(l9_24,l9_25,((l9_16*l9_16)+(l9_19*l9_19))+(l9_22*l9_22))))*transpose(l9_32);
float l9_34=l9_33[0].x+0.30000001;
float l9_35=l9_33[0].y;
float l9_36=l9_33[1].y+0.30000001;
float l9_37=0.5*(l9_34+l9_36);
float l9_38=length(vec2((l9_34-l9_36)*0.5,l9_35));
float l9_39=l9_37+l9_38;
vec2 l9_40=vec2(l9_35,l9_39-l9_34);
vec2 l9_41=l9_40*inversesqrt(max(dot(l9_40,l9_40),1e-10));
vec2 l9_42=l9_41*min(sqrt(2.0*l9_39),1024.0);
vec2 l9_43=vec2(l9_41.y,-l9_41.x)*min(sqrt(2.0*max(l9_37-l9_38,0.1)),1024.0);
float l9_44;
#if (sc_gs_AlphaCutoffEnabled)
{
l9_44=clamp(log(max(sc_gs_Color.w,1e-30)/sc_gs_AlphaCutoff),0.039999999,4.0)*0.25;
}
#else
{
l9_44=1.0;
}
#endif
float l9_45=l9_44*dot(l9_42,l9_42);
bool l9_46=l9_45<1.0;
bool l9_47;
if (l9_46)
{
l9_47=(l9_44*dot(l9_43,l9_43))<1.0;
}
else
{
l9_47=l9_46;
}
if (l9_47)
{
return vec4(0.0,0.0,2.0,1.0);
}
float l9_48;
#if (sc_gs_AlphaCutoffEnabled)
{
l9_48=sqrt(l9_44);
}
#else
{
l9_48=1.0;
}
#endif
vec2 l9_49=vec2((ivec2(gl_VertexID>>1,gl_VertexID&1)*ivec2(2))-ivec2(1))*l9_48;
vec2 l9_50=l9_49*2.0;
varTex01=vec4(l9_50.x,l9_50.y,varTex01.z,varTex01.w);
vec2 l9_51=(l9_42*l9_49.x)+(l9_43*l9_49.y);
vec2 l9_52;
if (pointSize>0.1)
{
l9_52=l9_51*(pointSize/(length(l9_42)+length(l9_43)));
}
else
{
l9_52=l9_51;
}
return l9_2+(vec4((l9_52*sc_CurrentRenderTargetDims.zw)*2.0,0.0,0.0)*l9_3);
}
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
sc_gs_Scale=vec3(0.0);
sc_gs_Rotation=vec4(0.0);
sc_gs_Color=vec4(0.0);
vec3 l9_0;
#if (sc_ChunkySplats)
{
ivec2 l9_1=ivec2((uv*dims.xy)-vec2(0.40000001));
int l9_2=(l9_1.x+(l9_1.y*int(dims.x+0.5)))/256;
int l9_3=int(dims.z)/3;
vec2 l9_4=(vec2(ivec2(3*(l9_2%l9_3),l9_2/l9_3))+vec2(0.5))/dims.zw;
vec2 l9_5=vec2(1.0/dims.z,0.0);
vec4 l9_6=textureLod(texChunkInfo,l9_4+vec2(0.0),0.0);
vec4 l9_7=textureLod(texChunkInfo,l9_4+(l9_5*1.0),0.0);
vec4 l9_8=textureLod(texChunkInfo,l9_4+(l9_5*2.0),0.0);
sc_gs_Scale=mix(l9_8.xyz,vec3(l9_6.w,l9_7.w,l9_8.w),textureLod(texScaleYZ,uv,0.0).xyz);
l9_0=mix(l9_6.xyz,l9_7.xyz,textureLod(texCenterXYZScaleX,uv,0.0).xyz);
}
#else
{
vec4 l9_9=textureLod(texCenterXYZScaleX,uv,0.0);
sc_gs_Scale=vec3(l9_9.w,textureLod(texScaleYZ,uv,0.0).xy);
l9_0=l9_9.xyz;
}
#endif
sc_gs_Rotation=sc_gs_reconstructQuat(textureLod(texRotation,uv,0.0));
sc_gs_Color=textureLod(texColor,uv,0.0);
vec3 l9_10;
#if (sc_gs_UseInterFrame)
{
vec3 l9_11=textureLod(texCenterDelta,uv,0.0).xyz;
vec4 l9_12=sc_gs_reconstructQuat(textureLod(texRotationOverride,uv,0.0));
vec3 l9_13;
#if (sc_gs_TwoInterFrames)
{
sc_gs_Rotation=sc_gs_nlerpQuat(l9_12,sc_gs_reconstructQuat(textureLod(texRotationOverride2,uv,0.0)),sc_gs_InterpolationFactor);
l9_13=l9_0+mix(l9_11,textureLod(texCenterDelta2,uv,0.0).xyz,vec3(sc_gs_InterpolationFactor));
}
#else
{
sc_gs_Rotation=sc_gs_nlerpQuat(sc_gs_Rotation,l9_12,sc_gs_InterpolationFactor);
l9_13=l9_0+(l9_11*sc_gs_InterpolationFactor);
}
#endif
l9_10=l9_13;
}
#else
{
l9_10=l9_0;
}
#endif
#if (sc_gs_ErrorPattern)
{
ivec3 l9_14=ivec3(floor(((l9_10-sc_LocalAabbMin)/(sc_LocalAabbMax-sc_LocalAabbMin))*50.0));
vec3 l9_15=mix(sc_gs_Color.xyz,vec3(1.0,0.0,1.0)*float(((l9_14.x+l9_14.y)+l9_14.z)&1),vec3(0.80000001));
sc_gs_Color=vec4(l9_15.x,l9_15.y,l9_15.z,sc_gs_Color.w);
sc_gs_Color.w=(sc_gs_Color.w*0.5)+0.5;
}
#endif
vec4 l9_16=vec4(l9_10,1.0);
vec4 l9_17=sc_ModelMatrix*l9_16;
#if (sc_MotionVectorsPass)
{
vec4 l9_18=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(l9_17.xyz,1.0);
vec4 l9_19=sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4((sc_PrevFrameModelMatrix*l9_16).xyz,1.0);
vec2 l9_20=((l9_18.xy/vec2(l9_18.w)).xy-(l9_19.xy/vec2(l9_19.w)).xy)*0.5;
varPosAndMotion.w=l9_20.x;
varNormalAndMotion.w=l9_20.y;
}
#endif
varColor=sc_gs_Color;
vec4 l9_21=sc_gs_ProcessSplat(l9_17,0.0);
vec4 l9_22;
#if (sc_TAAEnabled)
{
vec2 l9_23=l9_21.xy+(sc_TAAJitterOffset*l9_21.w);
l9_22=vec4(l9_23.x,l9_23.y,l9_21.z,l9_21.w);
}
#else
{
l9_22=l9_21;
}
#endif
vec4 l9_24;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_25=l9_22;
l9_25.x=l9_22.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_24=l9_25;
}
#else
{
l9_24=l9_22;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_26=dot(l9_24,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_26);
}
#else
{
varClipDistance=l9_26;
}
#endif
}
#endif
gl_Position=l9_24;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 0
#elif sc_BlendMode_MultiplyOriginal==1
#undef sc_BlendMode_MultiplyOriginal
#define sc_BlendMode_MultiplyOriginal 1
#endif
#ifndef sc_BlendMode_Screen
#define sc_BlendMode_Screen 0
#elif sc_BlendMode_Screen==1
#undef sc_BlendMode_Screen
#define sc_BlendMode_Screen 1
#endif
#ifndef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 0
#elif sc_BlendMode_PremultipliedAlphaAuto==1
#undef sc_BlendMode_PremultipliedAlphaAuto
#define sc_BlendMode_PremultipliedAlphaAuto 1
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
#ifndef sc_gs_AlphaCutoffEnabled
#define sc_gs_AlphaCutoffEnabled 0
#elif sc_gs_AlphaCutoffEnabled==1
#undef sc_gs_AlphaCutoffEnabled
#define sc_gs_AlphaCutoffEnabled 1
#endif
uniform vec4 sc_UniformConstants;
uniform float sc_gs_AlphaCutoff;
in vec4 varTex01;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
flat in vec4 varColor;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
flat in int varStereoViewID;
vec4 sc_OutputMotionVectorIfNeeded(vec4 finalColor)
{
#if (sc_MotionVectorsPass)
{
float l9_0=floor(((varPosAndMotion.w*5.0)+0.5)*65535.0);
float l9_1=floor(l9_0*0.00390625);
float l9_2=floor(((varNormalAndMotion.w*5.0)+0.5)*65535.0);
float l9_3=floor(l9_2*0.00390625);
return vec4(l9_1/255.0,(l9_0-(l9_1*256.0))/255.0,l9_3/255.0,(l9_2-(l9_3*256.0))/255.0);
}
#else
{
return finalColor;
}
#endif
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
float l9_0=dot(varTex01.xy,varTex01.xy);
float l9_1;
if (l9_0>4.0)
{
l9_1=0.0;
}
else
{
l9_1=exp(-l9_0);
}
float l9_2=varColor.w*l9_1;
#if (sc_gs_AlphaCutoffEnabled)
{
if (l9_2<=sc_gs_AlphaCutoff)
{
discard;
}
}
#else
{
if (l9_1<=0.0)
{
discard;
}
}
#endif
vec4 l9_3=vec4(varColor.xyz,l9_2);
vec4 l9_4;
#if (sc_BlendMode_MultiplyOriginal)
{
l9_4=vec4(mix(vec3(1.0),l9_3.xyz,vec3(l9_2)),l9_2);
}
#else
{
vec4 l9_5;
#if (sc_BlendMode_Screen||sc_BlendMode_PremultipliedAlphaAuto)
{
float l9_6;
#if (sc_BlendMode_PremultipliedAlphaAuto)
{
l9_6=clamp(l9_2,0.0,1.0);
}
#else
{
l9_6=l9_2;
}
#endif
l9_5=vec4(l9_3.xyz*l9_6,l9_6);
}
#else
{
l9_5=l9_3;
}
#endif
l9_4=l9_5;
}
#endif
vec4 l9_7=sc_OutputMotionVectorIfNeeded(l9_4);
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
sc_FragData0=l9_8;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
