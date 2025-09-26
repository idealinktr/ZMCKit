#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler mainTextureSmpSC 0:8
//sampler sampler segmentationMaskSmpSC 0:15
//texture texture2D mainTexture 0:0:0:8
//texture texture2D segmentationMask 0:7:0:15
//texture texture2DArray mainTextureArrSC 0:16:0:8
//texture texture2DArray segmentationMaskArrSC 0:20:0:15
//spec_const bool GRAY_SCALE 0 0
//spec_const bool RG_RB_GB 1 0
//spec_const bool RR_GG_BB 2 0
//spec_const bool RY_GY_BY_Y 3 0
//spec_const bool R_G_B 4 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_mainTexture 5 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_segmentationMask 6 0
//spec_const bool SC_USE_UV_MIN_MAX_mainTexture 7 0
//spec_const bool SC_USE_UV_MIN_MAX_segmentationMask 8 0
//spec_const bool SC_USE_UV_TRANSFORM_mainTexture 9 0
//spec_const bool SC_USE_UV_TRANSFORM_segmentationMask 10 0
//spec_const bool mainTextureHasSwappedViews 11 0
//spec_const bool segmentationMaskHasSwappedViews 12 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_mainTexture 13 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_segmentationMask 14 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_mainTexture 15 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_segmentationMask 16 -1
//spec_const int mainTextureLayout 17 0
//spec_const int sc_ShaderCacheConstant 18 0
//spec_const int sc_StereoRenderingMode 19 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 20 0
//spec_const int sc_StereoViewID 21 0
//spec_const int segmentationMaskLayout 22 0
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
vec2 l9_0=(position.xy*0.5)+vec2(0.5);
vec2 l9_1=vec2(l9_0.x,1.0-l9_0.y);
varTex01=vec4(varTex01.x,varTex01.y,l9_1.x,l9_1.y);
vec4 l9_2;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_3=position;
l9_3.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_2=l9_3;
}
#else
{
l9_2=position;
}
#endif
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_2;
vec2 l9_4=((l9_2.xy/vec2(l9_2.w))*0.5)+vec2(0.5);
vec2 l9_5;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_6=vec3(l9_4,0.0);
l9_6.y=((2.0*l9_4.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_5=l9_6.xy;
}
#else
{
l9_5=l9_4;
}
#endif
varScreenTexturePos=l9_5;
vec4 l9_7=l9_2*1.0;
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
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_10=dot(l9_8,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_10);
}
#else
{
varClipDistance=l9_10;
}
#endif
}
#endif
gl_Position=l9_8;
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
#ifndef segmentationMaskHasSwappedViews
#define segmentationMaskHasSwappedViews 0
#elif segmentationMaskHasSwappedViews==1
#undef segmentationMaskHasSwappedViews
#define segmentationMaskHasSwappedViews 1
#endif
#ifndef segmentationMaskLayout
#define segmentationMaskLayout 0
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
#ifndef GRAY_SCALE
#define GRAY_SCALE 0
#elif GRAY_SCALE==1
#undef GRAY_SCALE
#define GRAY_SCALE 1
#endif
#ifndef RG_RB_GB
#define RG_RB_GB 0
#elif RG_RB_GB==1
#undef RG_RB_GB
#define RG_RB_GB 1
#endif
#ifndef RR_GG_BB
#define RR_GG_BB 0
#elif RR_GG_BB==1
#undef RR_GG_BB
#define RR_GG_BB 1
#endif
#ifndef R_G_B
#define R_G_B 0
#elif R_G_B==1
#undef R_G_B
#define R_G_B 1
#endif
#ifndef RY_GY_BY_Y
#define RY_GY_BY_Y 0
#elif RY_GY_BY_Y==1
#undef RY_GY_BY_Y
#define RY_GY_BY_Y 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_segmentationMask
#define SC_SOFTWARE_WRAP_MODE_U_segmentationMask -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_segmentationMask
#define SC_SOFTWARE_WRAP_MODE_V_segmentationMask -1
#endif
#ifndef SC_USE_UV_MIN_MAX_segmentationMask
#define SC_USE_UV_MIN_MAX_segmentationMask 0
#elif SC_USE_UV_MIN_MAX_segmentationMask==1
#undef SC_USE_UV_MIN_MAX_segmentationMask
#define SC_USE_UV_MIN_MAX_segmentationMask 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_segmentationMask
#define SC_USE_CLAMP_TO_BORDER_segmentationMask 0
#elif SC_USE_CLAMP_TO_BORDER_segmentationMask==1
#undef SC_USE_CLAMP_TO_BORDER_segmentationMask
#define SC_USE_CLAMP_TO_BORDER_segmentationMask 1
#endif
#ifndef SC_USE_UV_TRANSFORM_segmentationMask
#define SC_USE_UV_TRANSFORM_segmentationMask 0
#elif SC_USE_UV_TRANSFORM_segmentationMask==1
#undef SC_USE_UV_TRANSFORM_segmentationMask
#define SC_USE_UV_TRANSFORM_segmentationMask 1
#endif
uniform vec4 sc_UniformConstants;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform vec4 segmentationMaskUvMinMax;
uniform vec4 segmentationMaskBorderColor;
uniform mat3 segmentationMaskTransform;
uniform mediump sampler2DArray mainTextureArrSC;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2DArray segmentationMaskArrSC;
uniform mediump sampler2D segmentationMask;
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
int segmentationMaskGetStereoViewIndex()
{
int l9_0;
#if (segmentationMaskHasSwappedViews)
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
#if (mainTextureLayout==2)
{
l9_0=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_0=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
vec3 l9_1;
#if (GRAY_SCALE)
{
l9_1=vec3(dot(l9_0.xyz,vec3(0.21259999,0.71520001,0.0722)));
}
#else
{
l9_1=l9_0.xyz;
}
#endif
vec4 l9_2;
#if (RG_RB_GB)
{
l9_2=vec4(l9_1.xxy*l9_1.yzz,1.0);
}
#else
{
vec4 l9_3;
#if (RR_GG_BB)
{
l9_3=vec4(l9_1*l9_1,1.0);
}
#else
{
vec4 l9_4;
#if (R_G_B)
{
l9_4=vec4(l9_1,1.0);
}
#else
{
vec4 l9_5;
#if (RY_GY_BY_Y)
{
vec4 l9_6;
#if (segmentationMaskLayout==2)
{
l9_6=sc_SampleTextureBias(segmentationMaskLayout,segmentationMaskGetStereoViewIndex(),varTex01.zw,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMaskArrSC);
}
#else
{
l9_6=sc_SampleTextureBias(segmentationMaskLayout,segmentationMaskGetStereoViewIndex(),varTex01.zw,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMask);
}
#endif
l9_5=vec4(l9_1*l9_6.x,l9_6.x);
}
#else
{
vec4 l9_7;
#if (GRAY_SCALE)
{
vec4 l9_8;
#if (segmentationMaskLayout==2)
{
l9_8=sc_SampleTextureBias(segmentationMaskLayout,segmentationMaskGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_segmentationMask)!=0),segmentationMaskTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMaskArrSC);
}
#else
{
l9_8=sc_SampleTextureBias(segmentationMaskLayout,segmentationMaskGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_segmentationMask)!=0),segmentationMaskTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_segmentationMask,SC_SOFTWARE_WRAP_MODE_V_segmentationMask),(int(SC_USE_UV_MIN_MAX_segmentationMask)!=0),segmentationMaskUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_segmentationMask)!=0),segmentationMaskBorderColor,0.0,segmentationMask);
}
#endif
l9_7=vec4(l9_1.x,l9_8.x,l9_1.x*l9_8.x,l9_1.x*l9_1.x);
}
#else
{
l9_7=vec4(1.0,0.0,1.0,1.0);
}
#endif
l9_5=l9_7;
}
#endif
l9_4=l9_5;
}
#endif
l9_3=l9_4;
}
#endif
l9_2=l9_3;
}
#endif
sc_writeFragData0Internal(l9_2,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
