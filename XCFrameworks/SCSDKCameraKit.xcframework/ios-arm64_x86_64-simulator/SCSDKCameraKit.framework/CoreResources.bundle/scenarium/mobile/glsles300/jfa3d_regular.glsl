#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//sampler sampler inputTextureSmpSC 0:7
//texture texture2D inputTexture 0:0:0:7
//texture texture2DArray inputTextureArrSC 0:14:0:7
//spec_const bool SC_USE_CLAMP_TO_BORDER_inputTexture 0 0
//spec_const bool SC_USE_UV_MIN_MAX_inputTexture 1 0
//spec_const bool SC_USE_UV_TRANSFORM_inputTexture 2 0
//spec_const bool inputTextureHasSwappedViews 3 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_inputTexture 4 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_inputTexture 5 -1
//spec_const int inputTextureLayout 6 0
//spec_const int sc_ShaderCacheConstant 7 0
//spec_const int sc_StereoRenderingMode 8 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 9 0
//spec_const int sc_StereoViewID 10 0
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
uniform vec4 sc_UniformConstants;
uniform vec4 jfa3d_params_0;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mediump sampler2DArray inputTextureArrSC;
uniform mediump sampler2D inputTexture;
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
vec4 JFA3DStep(vec3 uvw)
{
float l9_0=uvw.x;
bool l9_1=l9_0<0.0;
bool l9_2;
if (!l9_1)
{
l9_2=uvw.y<0.0;
}
else
{
l9_2=l9_1;
}
bool l9_3;
if (!l9_2)
{
l9_3=uvw.z<0.0;
}
else
{
l9_3=l9_2;
}
bool l9_4;
if (!l9_3)
{
l9_4=uvw.x>1.0;
}
else
{
l9_4=l9_3;
}
bool l9_5;
if (!l9_4)
{
l9_5=uvw.y>1.0;
}
else
{
l9_5=l9_4;
}
bool l9_6;
if (!l9_5)
{
l9_6=uvw.z>1.0;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
return vec4(0.0,0.0,0.0,1.0);
}
vec3 offsets[27];
offsets[0]=vec3(-1.0,-1.0,1.0);
offsets[1]=vec3(0.0,-1.0,1.0);
offsets[2]=vec3(1.0,-1.0,1.0);
offsets[3]=vec3(-1.0,0.0,1.0);
offsets[4]=vec3(0.0,0.0,1.0);
offsets[5]=vec3(1.0,0.0,1.0);
offsets[6]=vec3(-1.0,1.0,1.0);
offsets[7]=vec3(0.0,1.0,1.0);
offsets[8]=vec3(1.0);
offsets[9]=vec3(-1.0,-1.0,0.0);
offsets[10]=vec3(0.0,-1.0,0.0);
offsets[11]=vec3(1.0,-1.0,0.0);
offsets[12]=vec3(-1.0,0.0,0.0);
offsets[13]=vec3(0.0);
offsets[14]=vec3(1.0,0.0,0.0);
offsets[15]=vec3(-1.0,1.0,0.0);
offsets[16]=vec3(0.0,1.0,0.0);
offsets[17]=vec3(1.0,1.0,0.0);
offsets[18]=vec3(-1.0);
offsets[19]=vec3(0.0,-1.0,-1.0);
offsets[20]=vec3(1.0,-1.0,-1.0);
offsets[21]=vec3(-1.0,0.0,-1.0);
offsets[22]=vec3(0.0,0.0,-1.0);
offsets[23]=vec3(1.0,0.0,-1.0);
offsets[24]=vec3(-1.0,1.0,-1.0);
offsets[25]=vec3(0.0,1.0,-1.0);
offsets[26]=vec3(1.0,1.0,-1.0);
vec3 l9_7;
float l9_8;
l9_8=1000000.0;
l9_7=vec3(0.0);
vec3 l9_9;
float l9_10;
int l9_11=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_11<27)
{
vec3 l9_12=uvw;
vec3 l9_13=offsets[l9_11];
vec3 l9_14=l9_12+((l9_13*jfa3d_params_0.x)*(1.0/jfa3d_params_0.z));
float l9_15=l9_14.x;
bool l9_16=l9_15<0.0;
bool l9_17;
if (!l9_16)
{
l9_17=l9_14.y<0.0;
}
else
{
l9_17=l9_16;
}
bool l9_18;
if (!l9_17)
{
l9_18=l9_14.z<0.0;
}
else
{
l9_18=l9_17;
}
bool l9_19;
if (!l9_18)
{
l9_19=l9_15>=1.0;
}
else
{
l9_19=l9_18;
}
bool l9_20;
if (!l9_19)
{
l9_20=l9_14.y>=1.0;
}
else
{
l9_20=l9_19;
}
bool l9_21;
if (!l9_20)
{
l9_21=l9_14.z>=1.0;
}
else
{
l9_21=l9_20;
}
if (l9_21)
{
l9_10=l9_8;
l9_9=l9_7;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
int l9_22=int(l9_14.z*jfa3d_params_0.z);
int l9_23=int(jfa3d_params_0.w);
vec2 l9_24=(vec2(l9_15,l9_14.y)+vec2(float(l9_22%l9_23),float(l9_22/l9_23)))/vec2(jfa3d_params_0.w);
vec4 l9_25;
#if (inputTextureLayout==2)
{
bool l9_26=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_inputTexture)!=0));
float l9_27=l9_24.x;
sc_SoftwareWrapEarly(l9_27,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x);
float l9_28=l9_27;
float l9_29=l9_24.y;
sc_SoftwareWrapEarly(l9_29,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y);
float l9_30=l9_29;
vec2 l9_31;
float l9_32;
#if (SC_USE_UV_MIN_MAX_inputTexture)
{
bool l9_33;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_33=ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x==3;
}
#else
{
l9_33=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0);
}
#endif
float l9_34=l9_28;
float l9_35=1.0;
sc_ClampUV(l9_34,inputTextureUvMinMax.x,inputTextureUvMinMax.z,l9_33,l9_35);
float l9_36=l9_34;
float l9_37=l9_35;
bool l9_38;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_38=ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y==3;
}
#else
{
l9_38=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0);
}
#endif
float l9_39=l9_30;
float l9_40=l9_37;
sc_ClampUV(l9_39,inputTextureUvMinMax.y,inputTextureUvMinMax.w,l9_38,l9_40);
l9_32=l9_40;
l9_31=vec2(l9_36,l9_39);
}
#else
{
l9_32=1.0;
l9_31=vec2(l9_28,l9_30);
}
#endif
vec2 l9_41=sc_TransformUV(l9_31,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform);
float l9_42=l9_41.x;
float l9_43=l9_32;
sc_SoftwareWrapLate(l9_42,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x,l9_26,l9_43);
float l9_44=l9_41.y;
float l9_45=l9_43;
sc_SoftwareWrapLate(l9_44,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y,l9_26,l9_45);
float l9_46=l9_45;
vec3 l9_47=sc_SamplingCoordsViewToGlobal(vec2(l9_42,l9_44),inputTextureLayout,inputTextureGetStereoViewIndex());
vec4 l9_48=texture(inputTextureArrSC,l9_47,0.0);
vec4 l9_49;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_49=mix(inputTextureBorderColor,l9_48,vec4(l9_46));
}
#else
{
l9_49=l9_48;
}
#endif
l9_25=l9_49;
}
#else
{
bool l9_50=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_inputTexture)!=0));
float l9_51=l9_24.x;
sc_SoftwareWrapEarly(l9_51,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x);
float l9_52=l9_51;
float l9_53=l9_24.y;
sc_SoftwareWrapEarly(l9_53,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y);
float l9_54=l9_53;
vec2 l9_55;
float l9_56;
#if (SC_USE_UV_MIN_MAX_inputTexture)
{
bool l9_57;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_57=ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x==3;
}
#else
{
l9_57=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0);
}
#endif
float l9_58=l9_52;
float l9_59=1.0;
sc_ClampUV(l9_58,inputTextureUvMinMax.x,inputTextureUvMinMax.z,l9_57,l9_59);
float l9_60=l9_58;
float l9_61=l9_59;
bool l9_62;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_62=ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y==3;
}
#else
{
l9_62=(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0);
}
#endif
float l9_63=l9_54;
float l9_64=l9_61;
sc_ClampUV(l9_63,inputTextureUvMinMax.y,inputTextureUvMinMax.w,l9_62,l9_64);
l9_56=l9_64;
l9_55=vec2(l9_60,l9_63);
}
#else
{
l9_56=1.0;
l9_55=vec2(l9_52,l9_54);
}
#endif
vec2 l9_65=sc_TransformUV(l9_55,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform);
float l9_66=l9_65.x;
float l9_67=l9_56;
sc_SoftwareWrapLate(l9_66,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).x,l9_50,l9_67);
float l9_68=l9_65.y;
float l9_69=l9_67;
sc_SoftwareWrapLate(l9_68,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture).y,l9_50,l9_69);
float l9_70=l9_69;
vec3 l9_71=sc_SamplingCoordsViewToGlobal(vec2(l9_66,l9_68),inputTextureLayout,inputTextureGetStereoViewIndex());
vec4 l9_72=texture(inputTexture,l9_71.xy,0.0);
vec4 l9_73;
#if (SC_USE_CLAMP_TO_BORDER_inputTexture)
{
l9_73=mix(inputTextureBorderColor,l9_72,vec4(l9_70));
}
#else
{
l9_73=l9_72;
}
#endif
l9_25=l9_73;
}
#endif
if (l9_25.w==1.0)
{
l9_10=l9_8;
l9_9=l9_7;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
vec3 l9_74=uvw;
float l9_75=length(l9_25.xyz-l9_74);
vec3 l9_76;
float l9_77;
if (l9_75<l9_8)
{
l9_77=l9_75;
l9_76=l9_25.xyz;
}
else
{
l9_77=l9_8;
l9_76=l9_7;
}
l9_10=l9_77;
l9_9=l9_76;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
else
{
break;
}
}
return vec4(l9_7,l9_8);
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
sc_writeFragData0Internal(JFA3DStep(vec3(fract(l9_0),fract(l9_1),(floor(l9_0)+(floor(l9_1)*jfa3d_params_0.w))/jfa3d_params_0.z)),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
