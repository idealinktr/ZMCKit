#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler baseTexSmpSC 0:7
//texture texture2D baseTex 0:0:0:7
//texture texture2DArray baseTexArrSC 0:14:0:7
//spec_const bool SC_USE_CLAMP_TO_BORDER_baseTex 0 0
//spec_const bool SC_USE_UV_MIN_MAX_baseTex 1 0
//spec_const bool baseTexHasSwappedViews 2 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_baseTex 3 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_baseTex 4 -1
//spec_const int baseTexLayout 5 0
//spec_const int sc_ShaderCacheConstant 6 0
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
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
uniform mat4 sc_ModelMatrix;
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat3 baseTexTransform;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
in vec4 position;
in vec2 texture0;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varTangent;
out vec2 varShadowTex;
flat out int varStereoViewID;
in vec3 normal;
in vec4 tangent;
in vec2 texture1;
void main()
{
vec2 l9_0=vec2((baseTexTransform*vec3(texture0,1.0)).xy);
varTex01=vec4(varTex01.x,varTex01.y,l9_0.x,l9_0.y);
vec4 l9_1=vec4((texture0*2.0)-vec2(1.0),0.0,1.0);
vec4 l9_2=sc_ModelViewProjectionMatrixArray[0]*l9_1;
vec4 l9_3=sc_ModelMatrix*l9_1;
varPosAndMotion=vec4(l9_3.x,l9_3.y,l9_3.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_2;
varScreenTexturePos=((l9_2.xy/vec2(l9_2.w))*0.5)+vec2(0.5);
vec4 l9_4=l9_2*1.0;
vec4 l9_5;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_6=l9_4;
l9_6.x=l9_4.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_5=l9_6;
}
#else
{
l9_5=l9_4;
}
#endif
gl_Position=l9_5;
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
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
uniform vec4 sc_UniformConstants;
uniform vec2 RTSize;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform mediump sampler2DArray baseTexArrSC;
uniform mediump sampler2D baseTex;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTex01;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
flat in int varStereoViewID;
in float varClipDistance;
int baseTexGetStereoViewIndex()
{
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1;
}
#else
{
l9_0=0;
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
void sc_writeFragData0Internal(vec4 col,float zero,int cacheConst)
{
col.x+=zero*float(cacheConst);
sc_FragData0=col;
}
void main()
{
float l9_0=max(step(gl_FragCoord.x,1.0),step(RTSize.x-1.0,gl_FragCoord.x));
float l9_1=max(step(gl_FragCoord.y,1.0),step(RTSize.y-1.0,gl_FragCoord.y));
if (max(l9_0,l9_1)<0.5)
{
discard;
}
vec2 l9_2=mix(varTex01.zw,vec2(0.5)+(sign(varTex01.zw-vec2(0.5))*0.5),vec2(l9_0,l9_1));
vec4 l9_3;
#if (baseTexLayout==2)
{
bool l9_4=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_5=l9_2.x;
sc_SoftwareWrapEarly(l9_5,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_6=l9_5;
float l9_7=l9_2.y;
sc_SoftwareWrapEarly(l9_7,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_8=l9_7;
vec2 l9_9;
float l9_10;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_11;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_11=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_11=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_12=l9_6;
float l9_13=1.0;
sc_ClampUV(l9_12,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_11,l9_13);
float l9_14=l9_12;
float l9_15=l9_13;
bool l9_16;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_16=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_16=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_17=l9_8;
float l9_18=l9_15;
sc_ClampUV(l9_17,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_16,l9_18);
l9_10=l9_18;
l9_9=vec2(l9_14,l9_17);
}
#else
{
l9_10=1.0;
l9_9=vec2(l9_6,l9_8);
}
#endif
vec2 l9_19=sc_TransformUV(l9_9,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)));
float l9_20=l9_19.x;
float l9_21=l9_10;
sc_SoftwareWrapLate(l9_20,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_4,l9_21);
float l9_22=l9_19.y;
float l9_23=l9_21;
sc_SoftwareWrapLate(l9_22,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_4,l9_23);
float l9_24=l9_23;
vec3 l9_25=sc_SamplingCoordsViewToGlobal(vec2(l9_20,l9_22),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_26=texture(baseTexArrSC,l9_25,0.0);
vec4 l9_27;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_27=mix(baseTexBorderColor,l9_26,vec4(l9_24));
}
#else
{
l9_27=l9_26;
}
#endif
l9_3=l9_27;
}
#else
{
bool l9_28=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_29=l9_2.x;
sc_SoftwareWrapEarly(l9_29,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_30=l9_29;
float l9_31=l9_2.y;
sc_SoftwareWrapEarly(l9_31,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_32=l9_31;
vec2 l9_33;
float l9_34;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_35;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_35=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_35=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_36=l9_30;
float l9_37=1.0;
sc_ClampUV(l9_36,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_35,l9_37);
float l9_38=l9_36;
float l9_39=l9_37;
bool l9_40;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_40=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_40=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_41=l9_32;
float l9_42=l9_39;
sc_ClampUV(l9_41,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_40,l9_42);
l9_34=l9_42;
l9_33=vec2(l9_38,l9_41);
}
#else
{
l9_34=1.0;
l9_33=vec2(l9_30,l9_32);
}
#endif
vec2 l9_43=sc_TransformUV(l9_33,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)));
float l9_44=l9_43.x;
float l9_45=l9_34;
sc_SoftwareWrapLate(l9_44,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_28,l9_45);
float l9_46=l9_43.y;
float l9_47=l9_45;
sc_SoftwareWrapLate(l9_46,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_28,l9_47);
float l9_48=l9_47;
vec3 l9_49=sc_SamplingCoordsViewToGlobal(vec2(l9_44,l9_46),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_50=texture(baseTex,l9_49.xy,0.0);
vec4 l9_51;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_51=mix(baseTexBorderColor,l9_50,vec4(l9_48));
}
#else
{
l9_51=l9_50;
}
#endif
l9_3=l9_51;
}
#endif
sc_writeFragData0Internal(l9_3,sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
