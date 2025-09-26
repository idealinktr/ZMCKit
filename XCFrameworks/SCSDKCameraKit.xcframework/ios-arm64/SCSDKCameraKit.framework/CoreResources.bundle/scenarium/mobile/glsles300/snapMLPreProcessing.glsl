#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler screenTextureSmpSC 0:13
//texture texture2D screenTexture 0:6:0:13
//texture texture2DArray screenTextureArrSC 0:17:0:13
//spec_const bool SC_USE_CLAMP_TO_BORDER_screenTexture 0 0
//spec_const bool USE_MIP_BIAS 1 0
//spec_const bool screenTextureHasSwappedViews 2 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_screenTexture 3 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_screenTexture 4 -1
//spec_const int sc_RenderingSpace 5 -1
//spec_const int sc_ShaderCacheConstant 6 0
//spec_const int sc_StereoRenderingMode 7 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 8 0
//spec_const int sc_StereoViewID 9 0
//spec_const int screenTextureLayout 10 0
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
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
uniform mat4 sc_ModelMatrix;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform mat3 screenTextureTransform;
uniform mat3 meshTransform;
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
vec2 l9_0=vec2((screenTextureTransform*vec3((position.xy+vec2(1.0))*0.5,1.0)).xy);
vec2 l9_1=vec2((meshTransform*vec3(position.xy,1.0)).xy);
vec4 l9_2=vec4(l9_1.x,l9_1.y,position.z,position.w);
vec4 l9_3;
#if (sc_RenderingSpace==3)
{
l9_3=sc_ApplyScreenSpaceInstancedClippedShift(l9_2);
}
#else
{
vec4 l9_4;
#if (sc_RenderingSpace==2)
{
l9_4=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_2;
}
#else
{
vec4 l9_5;
#if (sc_RenderingSpace==1)
{
l9_5=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_2;
}
#else
{
vec4 l9_6;
#if (sc_RenderingSpace==4)
{
l9_6=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*l9_2)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_6=l9_2;
}
#endif
l9_5=l9_6;
}
#endif
l9_4=l9_5;
}
#endif
l9_3=l9_4;
}
#endif
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_3.x,l9_3.y,l9_3.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_7=sc_ModelMatrix*l9_2;
varPosAndMotion=vec4(l9_7.x,l9_7.y,l9_7.z,varPosAndMotion.w);
}
#endif
}
#endif
}
#endif
varTex01=vec4(l9_0.x,l9_0.y,varTex01.z,varTex01.w);
varScreenPos=l9_3;
vec2 l9_8=((l9_3.xy/vec2(l9_3.w))*0.5)+vec2(0.5);
vec2 l9_9;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_10=vec3(l9_8,0.0);
l9_10.y=((2.0*l9_8.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_9=l9_10.xy;
}
#else
{
l9_9=l9_8;
}
#endif
varScreenTexturePos=l9_9;
vec4 l9_11=l9_3*1.0;
vec4 l9_12;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_13=l9_11;
l9_13.x=l9_11.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_12=l9_13;
}
#else
{
l9_12=l9_11;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_14=dot(l9_12,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_14);
}
#else
{
varClipDistance=l9_14;
}
#endif
}
#endif
gl_Position=l9_12;
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
#ifndef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 0
#elif screenTextureHasSwappedViews==1
#undef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 1
#endif
#ifndef screenTextureLayout
#define screenTextureLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_screenTexture
#define SC_SOFTWARE_WRAP_MODE_U_screenTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_screenTexture
#define SC_SOFTWARE_WRAP_MODE_V_screenTexture -1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 0
#elif SC_USE_CLAMP_TO_BORDER_screenTexture==1
#undef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 1
#endif
#ifndef USE_MIP_BIAS
#define USE_MIP_BIAS 0
#elif USE_MIP_BIAS==1
#undef USE_MIP_BIAS
#define USE_MIP_BIAS 1
#endif
uniform vec4 sc_UniformConstants;
uniform float screenTextureBias;
uniform vec4 screenTextureBorderColor;
uniform mediump sampler2DArray screenTextureArrSC;
uniform mediump sampler2D screenTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
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
void sc_SoftwareWrapLate(inout float uv,int softwareWrapMode,bool useClampToBorder,inout float clampToBorderFactor)
{
if ((softwareWrapMode==0)||(softwareWrapMode==3))
{
sc_ClampUV(uv,0.0,1.0,useClampToBorder,clampToBorderFactor);
}
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
l9_0=varStereoViewID;
}
#endif
return l9_0;
}
int screenTextureGetStereoViewIndex()
{
int l9_0;
#if (screenTextureHasSwappedViews)
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
vec4 screenTextureSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (screenTextureLayout==2)
{
l9_0=texture(screenTextureArrSC,sc_SamplingCoordsViewToGlobal(uv,screenTextureLayout,screenTextureGetStereoViewIndex()),bias);
}
#else
{
l9_0=sc_SampleView(uv,screenTextureLayout,screenTextureGetStereoViewIndex(),bias,screenTexture);
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
float param=varTex01.x;
sc_SoftwareWrapEarly(param,SC_SOFTWARE_WRAP_MODE_U_screenTexture);
float param_2=varTex01.y;
sc_SoftwareWrapEarly(param_2,SC_SOFTWARE_WRAP_MODE_V_screenTexture);
float param_4=param;
float param_7=1.0;
sc_SoftwareWrapLate(param_4,SC_SOFTWARE_WRAP_MODE_U_screenTexture,(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0),param_7);
float l9_0=param_4;
float param_8=param_2;
float param_11=param_7;
sc_SoftwareWrapLate(param_8,SC_SOFTWARE_WRAP_MODE_V_screenTexture,(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0),param_11);
float l9_1=param_8;
vec2 l9_2=vec2(l9_0,l9_1);
float l9_3=param_11;
vec4 l9_4;
#if (USE_MIP_BIAS)
{
l9_4=screenTextureSampleViewBias(l9_2,screenTextureBias);
}
#else
{
l9_4=screenTextureSampleViewBias(l9_2,0.0);
}
#endif
vec4 l9_5;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_5=mix(screenTextureBorderColor,l9_4,vec4(l9_3));
}
#else
{
l9_5=l9_4;
}
#endif
sc_writeFragData0Internal(l9_5,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
