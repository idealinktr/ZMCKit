#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//sampler sampler inputTexture1SmpSC 0:9
//sampler sampler inputTexture2SmpSC 0:10
//sampler sampler inputTextureSmpSC 0:11
//texture texture2D inputTexture 0:0:0:11
//texture texture2D inputTexture1 0:1:0:9
//texture texture2D inputTexture2 0:2:0:10
//texture texture2DArray inputTexture1ArrSC 0:18:0:9
//texture texture2DArray inputTexture2ArrSC 0:19:0:10
//texture texture2DArray inputTextureArrSC 0:20:0:11
//spec_const bool SC_USE_CLAMP_TO_BORDER_inputTexture 0 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_inputTexture1 1 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_inputTexture2 2 0
//spec_const bool SC_USE_UV_MIN_MAX_inputTexture 3 0
//spec_const bool SC_USE_UV_MIN_MAX_inputTexture1 4 0
//spec_const bool SC_USE_UV_MIN_MAX_inputTexture2 5 0
//spec_const bool SC_USE_UV_TRANSFORM_inputTexture 6 0
//spec_const bool SC_USE_UV_TRANSFORM_inputTexture1 7 0
//spec_const bool SC_USE_UV_TRANSFORM_inputTexture2 8 0
//spec_const bool inputTexture1HasSwappedViews 9 0
//spec_const bool inputTexture2HasSwappedViews 10 0
//spec_const bool inputTextureHasSwappedViews 11 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_inputTexture 12 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_inputTexture1 13 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_inputTexture2 14 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_inputTexture 15 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_inputTexture1 16 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_inputTexture2 17 -1
//spec_const int inputTexture1Layout 18 0
//spec_const int inputTexture2Layout 19 0
//spec_const int inputTextureLayout 20 0
//spec_const int sc_ShaderCacheConstant 21 0
//spec_const int sc_StereoRenderingMode 22 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 23 0
//spec_const int sc_StereoViewID 24 0
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
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varTex01;
out vec4 varTangent;
out vec2 varShadowTex;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
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
vec2 l9_0=((position.xy/vec2(position.w))*0.5)+vec2(0.5);
varTex01=vec4(l9_0.x,l9_0.y,varTex01.z,varTex01.w);
vec4 l9_1;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_2=position;
l9_2.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_1=l9_2;
}
#else
{
l9_1=position;
}
#endif
varPosAndMotion=vec4(l9_1.x,l9_1.y,l9_1.z,varPosAndMotion.w);
varScreenPos=l9_1;
vec2 l9_3=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
vec2 l9_4;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_5=vec3(l9_3,0.0);
l9_5.y=((2.0*l9_3.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_4=l9_5.xy;
}
#else
{
l9_4=l9_3;
}
#endif
varScreenTexturePos=l9_4;
vec4 l9_6=l9_1*1.0;
vec4 l9_7;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_8=l9_6;
l9_8.x=l9_6.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_7=l9_8;
}
#else
{
l9_7=l9_6;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_9=dot(l9_7,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_9);
}
#else
{
varClipDistance=l9_9;
}
#endif
}
#endif
gl_Position=l9_7;
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
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef inputTexture1HasSwappedViews
#define inputTexture1HasSwappedViews 0
#elif inputTexture1HasSwappedViews==1
#undef inputTexture1HasSwappedViews
#define inputTexture1HasSwappedViews 1
#endif
#ifndef inputTexture1Layout
#define inputTexture1Layout 0
#endif
#ifndef inputTexture2HasSwappedViews
#define inputTexture2HasSwappedViews 0
#elif inputTexture2HasSwappedViews==1
#undef inputTexture2HasSwappedViews
#define inputTexture2HasSwappedViews 1
#endif
#ifndef inputTexture2Layout
#define inputTexture2Layout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 0
#elif SC_USE_UV_TRANSFORM_inputTexture==1
#undef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 0
#elif SC_USE_UV_MIN_MAX_inputTexture==1
#undef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture1
#define SC_USE_UV_TRANSFORM_inputTexture1 0
#elif SC_USE_UV_TRANSFORM_inputTexture1==1
#undef SC_USE_UV_TRANSFORM_inputTexture1
#define SC_USE_UV_TRANSFORM_inputTexture1 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture1
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture1 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture1
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture1 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture1
#define SC_USE_UV_MIN_MAX_inputTexture1 0
#elif SC_USE_UV_MIN_MAX_inputTexture1==1
#undef SC_USE_UV_MIN_MAX_inputTexture1
#define SC_USE_UV_MIN_MAX_inputTexture1 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture1
#define SC_USE_CLAMP_TO_BORDER_inputTexture1 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture1==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture1
#define SC_USE_CLAMP_TO_BORDER_inputTexture1 1
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture2
#define SC_USE_UV_TRANSFORM_inputTexture2 0
#elif SC_USE_UV_TRANSFORM_inputTexture2==1
#undef SC_USE_UV_TRANSFORM_inputTexture2
#define SC_USE_UV_TRANSFORM_inputTexture2 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture2
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture2 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture2
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture2 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture2
#define SC_USE_UV_MIN_MAX_inputTexture2 0
#elif SC_USE_UV_MIN_MAX_inputTexture2==1
#undef SC_USE_UV_MIN_MAX_inputTexture2
#define SC_USE_UV_MIN_MAX_inputTexture2 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture2
#define SC_USE_CLAMP_TO_BORDER_inputTexture2 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture2==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture2
#define SC_USE_CLAMP_TO_BORDER_inputTexture2 1
#endif
uniform vec4 sc_UniformConstants;
uniform vec4 voxelization_params_0;
uniform vec4 jfa3d_params_0;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mat3 inputTexture1Transform;
uniform vec4 inputTexture1UvMinMax;
uniform vec4 inputTexture1BorderColor;
uniform mat3 inputTexture2Transform;
uniform vec4 inputTexture2UvMinMax;
uniform vec4 inputTexture2BorderColor;
uniform mediump sampler2DArray inputTextureArrSC;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2DArray inputTexture1ArrSC;
uniform mediump sampler2D inputTexture1;
uniform mediump sampler2DArray inputTexture2ArrSC;
uniform mediump sampler2D inputTexture2;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
in vec4 varTex01;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
vec2 UVW2UV(vec3 uvw,float sliceCount,float tileSize)
{
int l9_0=int(uvw.z*sliceCount);
return (vec2(uvw.x,uvw.y)+vec2(float(l9_0%int(tileSize)),float(l9_0/int(tileSize))))/vec2(tileSize);
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
int inputTextureGetStereoViewIndex()
{
int l9_0;
#if (inputTextureHasSwappedViews)
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
int inputTexture1GetStereoViewIndex()
{
int l9_0;
#if (inputTexture1HasSwappedViews)
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
int inputTexture2GetStereoViewIndex()
{
int l9_0;
#if (inputTexture2HasSwappedViews)
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
vec4 CombineAxesRatio11(vec3 uvw)
{
vec2 l9_0=UVW2UV(uvw,voxelization_params_0.x,jfa3d_params_0.w);
vec4 l9_1;
#if (inputTextureLayout==2)
{
l9_1=sc_SampleTextureBias(inputTextureLayout,inputTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTextureArrSC);
}
#else
{
l9_1=sc_SampleTextureBias(inputTextureLayout,inputTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
}
#endif
vec4 l9_2;
#if (inputTexture1Layout==2)
{
l9_2=sc_SampleTextureBias(inputTexture1Layout,inputTexture1GetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture1)!=0),inputTexture1Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture1,SC_SOFTWARE_WRAP_MODE_V_inputTexture1),(int(SC_USE_UV_MIN_MAX_inputTexture1)!=0),inputTexture1UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture1)!=0),inputTexture1BorderColor,0.0,inputTexture1ArrSC);
}
#else
{
l9_2=sc_SampleTextureBias(inputTexture1Layout,inputTexture1GetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture1)!=0),inputTexture1Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture1,SC_SOFTWARE_WRAP_MODE_V_inputTexture1),(int(SC_USE_UV_MIN_MAX_inputTexture1)!=0),inputTexture1UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture1)!=0),inputTexture1BorderColor,0.0,inputTexture1);
}
#endif
vec4 l9_3;
#if (inputTexture2Layout==2)
{
l9_3=sc_SampleTextureBias(inputTexture2Layout,inputTexture2GetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture2)!=0),inputTexture2Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture2,SC_SOFTWARE_WRAP_MODE_V_inputTexture2),(int(SC_USE_UV_MIN_MAX_inputTexture2)!=0),inputTexture2UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture2)!=0),inputTexture2BorderColor,0.0,inputTexture2ArrSC);
}
#else
{
l9_3=sc_SampleTextureBias(inputTexture2Layout,inputTexture2GetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture2)!=0),inputTexture2Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture2,SC_SOFTWARE_WRAP_MODE_V_inputTexture2),(int(SC_USE_UV_MIN_MAX_inputTexture2)!=0),inputTexture2UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture2)!=0),inputTexture2BorderColor,0.0,inputTexture2);
}
#endif
bool l9_4=dot(l9_1.xyz,l9_1.xyz)==0.0;
bool l9_5;
if (l9_4)
{
l9_5=dot(l9_2.xyz,l9_2.xyz)==0.0;
}
else
{
l9_5=l9_4;
}
bool l9_6;
if (l9_5)
{
l9_6=dot(l9_3.xyz,l9_3.xyz)==0.0;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
return vec4(0.0,0.0,0.0,1.0);
}
return vec4(uvw,0.0);
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
float l9_0=varTex01.x*jfa3d_params_0.w;
float l9_1=varTex01.y*jfa3d_params_0.w;
sc_writeFragData0Internal(CombineAxesRatio11(vec3(fract(l9_0),fract(l9_1),(floor(l9_0)+(floor(l9_1)*jfa3d_params_0.w))/jfa3d_params_0.z)),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
