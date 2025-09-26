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
//attribute vec2 uv 18
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec3 positionNext 15
//attribute vec3 positionPrevious 16
//attribute vec4 strandProperties 17
//sampler sampler texCenterXYZScaleXSmp 0:17
//sampler sampler texChunkInfoSmp 0:18
//sampler sampler texColorSmp 0:19
//sampler sampler texRotationSmp 0:20
//sampler sampler texScaleYZSmp 0:21
//texture texture2D texCenterXYZScaleX 0:6:0:17
//texture texture2D texChunkInfo 0:7:0:18
//texture texture2D texColor 0:8:0:19
//texture texture2D texRotation 0:9:0:20
//texture texture2D texScaleYZ 0:10:0:21
//spec_const bool sc_ChunkySplats 0 0
//spec_const int sc_ShaderCacheConstant 1 0
//spec_const int sc_StereoRenderingMode 2 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 3 0
//spec_const int sc_StereoViewID 4 0
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
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
#ifndef sc_ChunkySplats
#define sc_ChunkySplats 0
#elif sc_ChunkySplats==1
#undef sc_ChunkySplats
#define sc_ChunkySplats 1
#endif
uniform mat4 sc_ModelMatrix;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 dims;
uniform vec4 sc_CurrentRenderTargetDims;
uniform mat4 sc_ViewMatrixInverseArray[sc_NumStereoViews];
uniform highp sampler2D texChunkInfo;
uniform highp sampler2D texCenterXYZScaleX;
uniform highp sampler2D texScaleYZ;
uniform highp sampler2D texRotation;
uniform highp sampler2D texColor;
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
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out float varViewSpaceDepth;
in vec2 uv;
flat out vec4 varColor;
out vec2 varTexCoord;
out vec4 varTangent;
out vec4 varTex01;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
vec3 inScale;
vec3 inRotation;
vec4 inColor;
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
vec4 evalSplat(vec4 centerWorld)
{
vec4 l9_0=centerWorld;
vec4 l9_1=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_0;
vec4 l9_2=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_1;
float l9_3=l9_2.w;
if (l9_2.z<(-l9_3))
{
return vec4(0.0,0.0,2.0,1.0);
}
vec3 l9_4=inScale;
vec3 l9_5=inRotation;
vec3 l9_6=(l9_5*2.0)-vec3(1.0);
float l9_7=1.0-dot(l9_6,l9_6);
float l9_8;
if (l9_7>0.0)
{
l9_8=sqrt(l9_7);
}
else
{
l9_8=0.0;
}
float l9_9=l9_6.x;
float l9_10=l9_6.y;
float l9_11=l9_6.z;
varColor=inColor;
float l9_12=l9_11*l9_11;
float l9_13=l9_8*l9_8;
float l9_14=l9_10*l9_11;
float l9_15=l9_8*l9_9;
float l9_16=l9_10*l9_8;
float l9_17=l9_11*l9_9;
float l9_18=l9_10*l9_10;
float l9_19=l9_11*l9_8;
float l9_20=l9_10*l9_9;
mat3 l9_21=mat3(sc_ModelMatrix[0].xyz,sc_ModelMatrix[1].xyz,sc_ModelMatrix[2].xyz)*mat3(vec3(1.0-(2.0*(l9_12+l9_13)),2.0*(l9_14+l9_15),2.0*(l9_16-l9_17)),vec3(2.0*(l9_14-l9_15),1.0-(2.0*(l9_18+l9_13)),2.0*(l9_19+l9_20)),vec3(2.0*(l9_16+l9_17),2.0*(l9_19-l9_20),1.0-(2.0*(l9_18+l9_12))));
float l9_22=l9_4.x*l9_21[0].x;
float l9_23=l9_4.x*l9_21[0].y;
float l9_24=l9_4.x*l9_21[0].z;
float l9_25=l9_4.y*l9_21[1].x;
float l9_26=l9_4.y*l9_21[1].y;
float l9_27=l9_4.y*l9_21[1].z;
float l9_28=l9_4.z*l9_21[2].x;
float l9_29=l9_4.z*l9_21[2].y;
float l9_30=l9_4.z*l9_21[2].z;
float l9_31=((l9_22*l9_23)+(l9_25*l9_26))+(l9_28*l9_29);
float l9_32=((l9_22*l9_24)+(l9_25*l9_27))+(l9_28*l9_30);
float l9_33=((l9_23*l9_24)+(l9_26*l9_27))+(l9_29*l9_30);
float l9_34=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][0].x*sc_CurrentRenderTargetDims.x;
float l9_35=l9_1.z;
float l9_36=l9_34/l9_35;
float l9_37=l9_35*l9_35;
int l9_38=sc_GetStereoViewIndex();
mat3 l9_39=mat3(sc_ViewMatrixInverseArray[l9_38][0].xyz,sc_ViewMatrixInverseArray[l9_38][1].xyz,sc_ViewMatrixInverseArray[l9_38][2].xyz)*mat3(vec3(l9_36,0.0,(-(l9_34*l9_1.x))/l9_37),vec3(0.0,l9_36,(-(l9_34*l9_1.y))/l9_37),vec3(0.0));
mat3 l9_40=(transpose(l9_39)*mat3(vec3(((l9_22*l9_22)+(l9_25*l9_25))+(l9_28*l9_28),l9_31,l9_32),vec3(l9_31,((l9_23*l9_23)+(l9_26*l9_26))+(l9_29*l9_29),l9_33),vec3(l9_32,l9_33,((l9_24*l9_24)+(l9_27*l9_27))+(l9_30*l9_30))))*l9_39;
float l9_41=l9_40[0].x+0.30000001;
float l9_42=l9_40[0].y;
float l9_43=l9_40[1].y+0.30000001;
float l9_44=0.5*(l9_41+l9_43);
float l9_45=length(vec2((l9_41-l9_43)/2.0,l9_42));
float l9_46=l9_44+l9_45;
vec2 l9_47=normalize(vec2(l9_42,l9_46-l9_41));
vec2 l9_48=l9_47*min(sqrt(2.0*l9_46),1024.0);
vec2 l9_49=vec2(l9_47.y,-l9_47.x)*min(sqrt(2.0*max(l9_44-l9_45,0.1)),1024.0);
bool l9_50=dot(l9_48,l9_48)<4.0;
bool l9_51;
if (l9_50)
{
l9_51=dot(l9_49,l9_49)<4.0;
}
else
{
l9_51=l9_50;
}
if (l9_51)
{
return vec4(0.0,0.0,2.0,1.0);
}
vec2 l9_52=vec2(((ivec2(gl_VertexID)&ivec2(1,2))<<ivec2(1,0))-ivec2(1));
varTexCoord=l9_52*2.0;
return l9_2+(vec4((((l9_48*l9_52.x)+(l9_49*l9_52.y))*sc_CurrentRenderTargetDims.zw)*2.0,0.0,0.0)*l9_3);
}
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
inScale=vec3(0.0);
inRotation=vec3(0.0);
inColor=vec4(0.0);
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
inScale=mix(l9_8.xyz,vec3(l9_6.w,l9_7.w,l9_8.w),textureLod(texScaleYZ,uv,0.0).xyz);
l9_0=mix(l9_6.xyz,l9_7.xyz,textureLod(texCenterXYZScaleX,uv,0.0).xyz);
}
#else
{
vec4 l9_9=textureLod(texCenterXYZScaleX,uv,0.0);
inScale=vec3(l9_9.w,textureLod(texScaleYZ,uv,0.0).xy);
l9_0=l9_9.xyz;
}
#endif
inRotation=textureLod(texRotation,uv,0.0).xyz;
inColor=textureLod(texColor,uv,0.0);
vec4 l9_10=evalSplat(sc_ModelMatrix*vec4(l9_0,1.0));
vec4 l9_11;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_12=l9_10;
l9_12.x=l9_10.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_11=l9_12;
}
#else
{
l9_11=l9_10;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_13=dot(l9_11,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_13);
}
#else
{
varClipDistance=l9_13;
}
#endif
}
#endif
gl_Position=l9_11;
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
uniform vec4 sc_UniformConstants;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec2 varTexCoord;
flat in vec4 varColor;
in vec4 varTangent;
in vec4 varTex01;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in float varViewSpaceDepth;
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
float l9_0=-dot(varTexCoord,varTexCoord);
if (l9_0<(-4.0))
{
discard;
}
sc_writeFragData0Internal(vec4(varColor.xyz,exp(l9_0)*varColor.w),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
