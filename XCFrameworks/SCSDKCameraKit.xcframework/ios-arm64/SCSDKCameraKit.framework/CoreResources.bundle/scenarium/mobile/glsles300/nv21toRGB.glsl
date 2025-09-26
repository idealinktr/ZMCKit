#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler uvTextureSmpSC 0:14
//sampler sampler yTextureSmpSC 0:15
//texture texture2D uvTexture 0:6:0:14
//texture texture2D yTexture 0:7:0:15
//texture texture2DArray uvTextureArrSC 0:19:0:14
//texture texture2DArray yTextureArrSC 0:20:0:15
//spec_const bool FORMAT_NV12 0 0
//spec_const bool FORMAT_NV21 1 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_uvTexture 2 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_yTexture 3 0
//spec_const bool SC_USE_UV_MIN_MAX_uvTexture 4 0
//spec_const bool SC_USE_UV_MIN_MAX_yTexture 5 0
//spec_const bool SC_USE_UV_TRANSFORM_uvTexture 6 0
//spec_const bool SC_USE_UV_TRANSFORM_yTexture 7 0
//spec_const bool uvTextureHasSwappedViews 8 0
//spec_const bool yTextureHasSwappedViews 9 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_uvTexture 10 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_yTexture 11 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_uvTexture 12 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_yTexture 13 -1
//spec_const int sc_ShaderCacheConstant 14 0
//spec_const int sc_StereoRenderingMode 15 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 16 0
//spec_const int sc_StereoViewID 17 0
//spec_const int uvTextureLayout 18 0
//spec_const int yTextureLayout 19 0
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
vec4 l9_0;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_1=position;
l9_1.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_0=l9_1;
}
#else
{
l9_0=position;
}
#endif
varPosAndMotion=vec4(l9_0.x,l9_0.y,l9_0.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_0;
vec2 l9_2=((l9_0.xy/vec2(l9_0.w))*0.5)+vec2(0.5);
vec2 l9_3;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_4=vec3(l9_2,0.0);
l9_4.y=((2.0*l9_2.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_3=l9_4.xy;
}
#else
{
l9_3=l9_2;
}
#endif
varScreenTexturePos=l9_3;
vec4 l9_5=l9_0*1.0;
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
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_8=dot(l9_6,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_8);
}
#else
{
varClipDistance=l9_8;
}
#endif
}
#endif
gl_Position=l9_6;
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
#ifndef yTextureHasSwappedViews
#define yTextureHasSwappedViews 0
#elif yTextureHasSwappedViews==1
#undef yTextureHasSwappedViews
#define yTextureHasSwappedViews 1
#endif
#ifndef yTextureLayout
#define yTextureLayout 0
#endif
#ifndef uvTextureHasSwappedViews
#define uvTextureHasSwappedViews 0
#elif uvTextureHasSwappedViews==1
#undef uvTextureHasSwappedViews
#define uvTextureHasSwappedViews 1
#endif
#ifndef uvTextureLayout
#define uvTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_yTexture
#define SC_USE_UV_TRANSFORM_yTexture 0
#elif SC_USE_UV_TRANSFORM_yTexture==1
#undef SC_USE_UV_TRANSFORM_yTexture
#define SC_USE_UV_TRANSFORM_yTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_yTexture
#define SC_SOFTWARE_WRAP_MODE_U_yTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_yTexture
#define SC_SOFTWARE_WRAP_MODE_V_yTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_yTexture
#define SC_USE_UV_MIN_MAX_yTexture 0
#elif SC_USE_UV_MIN_MAX_yTexture==1
#undef SC_USE_UV_MIN_MAX_yTexture
#define SC_USE_UV_MIN_MAX_yTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_yTexture
#define SC_USE_CLAMP_TO_BORDER_yTexture 0
#elif SC_USE_CLAMP_TO_BORDER_yTexture==1
#undef SC_USE_CLAMP_TO_BORDER_yTexture
#define SC_USE_CLAMP_TO_BORDER_yTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_uvTexture
#define SC_USE_UV_TRANSFORM_uvTexture 0
#elif SC_USE_UV_TRANSFORM_uvTexture==1
#undef SC_USE_UV_TRANSFORM_uvTexture
#define SC_USE_UV_TRANSFORM_uvTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_uvTexture
#define SC_SOFTWARE_WRAP_MODE_U_uvTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_uvTexture
#define SC_SOFTWARE_WRAP_MODE_V_uvTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_uvTexture
#define SC_USE_UV_MIN_MAX_uvTexture 0
#elif SC_USE_UV_MIN_MAX_uvTexture==1
#undef SC_USE_UV_MIN_MAX_uvTexture
#define SC_USE_UV_MIN_MAX_uvTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_uvTexture
#define SC_USE_CLAMP_TO_BORDER_uvTexture 0
#elif SC_USE_CLAMP_TO_BORDER_uvTexture==1
#undef SC_USE_CLAMP_TO_BORDER_uvTexture
#define SC_USE_CLAMP_TO_BORDER_uvTexture 1
#endif
#ifndef FORMAT_NV12
#define FORMAT_NV12 0
#elif FORMAT_NV12==1
#undef FORMAT_NV12
#define FORMAT_NV12 1
#endif
#ifndef FORMAT_NV21
#define FORMAT_NV21 0
#elif FORMAT_NV21==1
#undef FORMAT_NV21
#define FORMAT_NV21 1
#endif
uniform vec4 sc_UniformConstants;
uniform mat3 yTextureTransform;
uniform vec4 yTextureUvMinMax;
uniform vec4 yTextureBorderColor;
uniform mat3 uvTextureTransform;
uniform vec4 uvTextureUvMinMax;
uniform vec4 uvTextureBorderColor;
uniform mediump sampler2DArray yTextureArrSC;
uniform mediump sampler2D yTexture;
uniform mediump sampler2DArray uvTextureArrSC;
uniform mediump sampler2D uvTexture;
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
int yTextureGetStereoViewIndex()
{
int l9_0;
#if (yTextureHasSwappedViews)
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
int uvTextureGetStereoViewIndex()
{
int l9_0;
#if (uvTextureHasSwappedViews)
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
#if (yTextureLayout==2)
{
l9_0=sc_SampleTextureBias(yTextureLayout,yTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_yTexture)!=0),yTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_yTexture,SC_SOFTWARE_WRAP_MODE_V_yTexture),(int(SC_USE_UV_MIN_MAX_yTexture)!=0),yTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_yTexture)!=0),yTextureBorderColor,0.0,yTextureArrSC);
}
#else
{
l9_0=sc_SampleTextureBias(yTextureLayout,yTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_yTexture)!=0),yTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_yTexture,SC_SOFTWARE_WRAP_MODE_V_yTexture),(int(SC_USE_UV_MIN_MAX_yTexture)!=0),yTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_yTexture)!=0),yTextureBorderColor,0.0,yTexture);
}
#endif
vec4 l9_1;
#if (uvTextureLayout==2)
{
l9_1=sc_SampleTextureBias(uvTextureLayout,uvTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_uvTexture)!=0),uvTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_uvTexture,SC_SOFTWARE_WRAP_MODE_V_uvTexture),(int(SC_USE_UV_MIN_MAX_uvTexture)!=0),uvTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_uvTexture)!=0),uvTextureBorderColor,0.0,uvTextureArrSC);
}
#else
{
l9_1=sc_SampleTextureBias(uvTextureLayout,uvTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_uvTexture)!=0),uvTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_uvTexture,SC_SOFTWARE_WRAP_MODE_V_uvTexture),(int(SC_USE_UV_MIN_MAX_uvTexture)!=0),uvTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_uvTexture)!=0),uvTextureBorderColor,0.0,uvTexture);
}
#endif
vec3 l9_2;
#if (FORMAT_NV12)
{
l9_2=(mat3(vec3(1.0),vec3(0.0,-0.33763301,1.732446),vec3(1.370705,-0.69800103,0.0))*vec3(l9_0.x,l9_1.xy))+vec3(-0.6853525,0.51781702,-0.86622298);
}
#else
{
vec3 l9_3;
#if (FORMAT_NV21)
{
l9_3=(mat3(vec3(1.0),vec3(0.0,-0.33763301,1.732446),vec3(1.370705,-0.69800103,0.0))*vec3(l9_0.x,l9_1.yx))+vec3(-0.6853525,0.51781702,-0.86622298);
}
#else
{
l9_3=vec3(0.0);
}
#endif
l9_2=l9_3;
}
#endif
sc_writeFragData0Internal(vec4(l9_2,1.0),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
