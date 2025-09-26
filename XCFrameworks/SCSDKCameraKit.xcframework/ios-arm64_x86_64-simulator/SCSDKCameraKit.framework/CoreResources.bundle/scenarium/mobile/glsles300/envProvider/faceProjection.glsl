#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec3 normal 1
//attribute vec2 texture0 3
//attribute vec2 texture1 4
//attribute vec4 tangent 2
//sampler sampler baseTexSmpSC 0:8
//sampler sampler borderTexSmpSC 0:9
//texture texture2D baseTex 0:0:0:8
//texture texture2D borderTex 0:1:0:9
//texture texture2DArray baseTexArrSC 0:16:0:8
//texture texture2DArray borderTexArrSC 0:17:0:9
//spec_const bool SC_USE_CLAMP_TO_BORDER_baseTex 0 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_borderTex 1 0
//spec_const bool SC_USE_UV_MIN_MAX_baseTex 2 0
//spec_const bool SC_USE_UV_MIN_MAX_borderTex 3 0
//spec_const bool baseTexHasSwappedViews 4 0
//spec_const bool borderTexHasSwappedViews 5 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_baseTex 6 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_U_borderTex 7 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_baseTex 8 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_borderTex 9 -1
//spec_const int baseTexLayout 10 0
//spec_const int borderTexLayout 11 0
//spec_const int sc_ShaderCacheConstant 12 0
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_TANGENT 1
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
uniform mat3 sc_NormalMatrix;
uniform mat4 script_modelMatrix;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
in vec4 position;
in vec3 normal;
in vec2 texture0;
in vec2 texture1;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varTangent;
out vec2 varShadowTex;
flat out int varStereoViewID;
in vec4 tangent;
void main()
{
vec4 l9_0=vec4(((texture0*1.002)*2.0)-vec2(1.0),0.0,1.0);
vec4 l9_1=sc_ModelViewProjectionMatrixArray[0]*l9_0;
vec4 l9_2=sc_ModelMatrix*l9_0;
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
vec3 l9_3=normalize(sc_NormalMatrix*normal);
varNormalAndMotion=vec4(l9_3.x,l9_3.y,l9_3.z,varNormalAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varTex01=vec4(varTex01.x,varTex01.y,texture1.x,texture1.y);
varScreenPos=l9_1;
varScreenTexturePos=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
vec4 l9_4=l9_1*1.0;
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
vec4 l9_8=script_modelMatrix*(mat4(vec4(12.0,0.0,0.0,0.0),vec4(0.0,12.0,0.0,0.0),vec4(0.0,0.0,12.0,0.0),vec4(0.0,0.0,0.0,1.0))*(mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0))*position));
varPosAndMotion=vec4(l9_8.x,l9_8.y,l9_8.z,varPosAndMotion.w);
vec3 l9_9=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
varNormalAndMotion=vec4(l9_9.x,l9_9.y,l9_9.z,varNormalAndMotion.w);
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
#ifndef borderTexHasSwappedViews
#define borderTexHasSwappedViews 0
#elif borderTexHasSwappedViews==1
#undef borderTexHasSwappedViews
#define borderTexHasSwappedViews 1
#endif
#ifndef borderTexLayout
#define borderTexLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_borderTex
#define SC_SOFTWARE_WRAP_MODE_U_borderTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_borderTex
#define SC_SOFTWARE_WRAP_MODE_V_borderTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_borderTex
#define SC_USE_UV_MIN_MAX_borderTex 0
#elif SC_USE_UV_MIN_MAX_borderTex==1
#undef SC_USE_UV_MIN_MAX_borderTex
#define SC_USE_UV_MIN_MAX_borderTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_borderTex
#define SC_USE_CLAMP_TO_BORDER_borderTex 0
#elif SC_USE_CLAMP_TO_BORDER_borderTex==1
#undef SC_USE_CLAMP_TO_BORDER_borderTex
#define SC_USE_CLAMP_TO_BORDER_borderTex 1
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
uniform vec3 uniCameraPos;
uniform vec3 uniSphereCenter;
uniform mat4 script_viewProjectionMatrix;
uniform mat3 borderTexTransform;
uniform mat3 baseTexTransform;
uniform vec4 borderTexUvMinMax;
uniform vec4 borderTexBorderColor;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform mediump sampler2DArray borderTexArrSC;
uniform mediump sampler2D borderTex;
uniform mediump sampler2DArray baseTexArrSC;
uniform mediump sampler2D baseTex;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varTex01;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
flat in int varStereoViewID;
in float varClipDistance;
int borderTexGetStereoViewIndex()
{
int l9_0;
#if (borderTexHasSwappedViews)
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
void sc_writeFragData0Internal(vec4 col,float zero,int cacheConst)
{
col.x+=zero*float(cacheConst);
sc_FragData0=col;
}
void main()
{
vec3 l9_0=uniCameraPos-uniSphereCenter;
float l9_1=max(length(l9_0),100.0);
vec3 l9_2=uniSphereCenter+(normalize(varNormalAndMotion.xyz)*l9_1);
vec4 l9_3=script_viewProjectionMatrix*vec4(l9_2,1.0);
float l9_4=l9_3.w;
float l9_5=sign(l9_4);
vec4 l9_6=(l9_3/vec4(l9_4+(1.0-max(abs(l9_5),0.99900001))))*l9_5;
vec2 l9_7=(l9_6.xy*0.5)+vec2(0.5);
vec3 l9_8=(uniCameraPos+vec3(0.0,0.0,-1.0))-uniCameraPos;
float l9_9=dot(l9_8,l9_8);
float l9_10=2.0*dot(l9_8,l9_0);
float l9_11=(l9_10*l9_10)-((4.0*l9_9)*(((dot(uniSphereCenter,uniSphereCenter)+dot(uniCameraPos,uniCameraPos))-(2.0*dot(uniSphereCenter,uniCameraPos)))-(l9_1*l9_1)));
vec3 l9_12;
vec3 l9_13;
if (l9_11>=0.0)
{
float l9_14=sqrt(l9_11);
float l9_15=2.0*l9_9;
float l9_16=l9_15+(1.0-max(abs(sign(l9_15)),0.99900001));
float l9_17=-l9_10;
l9_13=uniCameraPos+(l9_8*((l9_17-l9_14)/l9_16));
l9_12=uniCameraPos+(l9_8*((l9_17+l9_14)/l9_16));
}
else
{
l9_13=vec3(10000.0,10000.0,0.0);
l9_12=vec3(10000.0,10000.0,0.0);
}
vec3 l9_18=mix(l9_12,l9_13,vec3(step(l9_13.z,uniSphereCenter.z)));
vec2 l9_19=vec2((borderTexTransform*vec3(l9_7,1.0)).xy)-vec2(0.5);
vec2 l9_20=l9_19/vec2(max(abs(l9_19.x),abs(l9_19.y))*2.0);
vec2 l9_21=l9_20+vec2(0.5);
vec2 l9_22=vec2((baseTexTransform*vec3(clamp(l9_7,vec2(0.0020000001),vec2(0.99800003)),1.0)).xy);
float l9_23=acos(dot(normalize(l9_18-uniSphereCenter),normalize(l9_2-uniSphereCenter)));
float l9_24=min(log2(max((l9_23-0.78539002)/0.049090002,1.0)),8.0);
vec4 l9_25;
#if (borderTexLayout==2)
{
l9_25=sc_SampleTextureBias(borderTexLayout,borderTexGetStereoViewIndex(),l9_21,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,l9_24,borderTexArrSC);
}
#else
{
l9_25=sc_SampleTextureBias(borderTexLayout,borderTexGetStereoViewIndex(),l9_21,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,l9_24,borderTex);
}
#endif
float l9_26=max(l9_23-1.5707901,0.0);
float l9_27=min(log2(max((2.3561699+(1.5707901-l9_26))/0.049090002,1.0)),8.0);
vec2 l9_28=(-l9_20)+vec2(0.5);
vec4 l9_29;
#if (borderTexLayout==2)
{
l9_29=sc_SampleTextureBias(borderTexLayout,borderTexGetStereoViewIndex(),l9_28,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,l9_27,borderTexArrSC);
}
#else
{
l9_29=sc_SampleTextureBias(borderTexLayout,borderTexGetStereoViewIndex(),l9_28,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,l9_27,borderTex);
}
#endif
vec4 l9_30=mix(l9_25,l9_29,vec4(sqrt((0.5*smoothstep(0.0,1.5707901,l9_26))*2.0)*0.5));
vec4 l9_31;
#if (baseTexLayout==2)
{
l9_31=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_22,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTexArrSC);
}
#else
{
l9_31=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_22,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
}
#endif
sc_writeFragData0Internal(mix(l9_30,l9_31,vec4((step(abs(l9_6.x),1.0)*step(abs(l9_6.y),1.0))*step(abs(l9_6.z),1.0))),sc_UniformConstants.x,sc_ShaderCacheConstant);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
