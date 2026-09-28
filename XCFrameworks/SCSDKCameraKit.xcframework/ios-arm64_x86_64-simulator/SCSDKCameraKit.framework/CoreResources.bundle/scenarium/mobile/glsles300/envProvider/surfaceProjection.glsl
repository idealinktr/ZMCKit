#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
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
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
uniform mat4 sc_ModelMatrix;
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat3 sc_NormalMatrix;
uniform mat4 script_modelMatrix;
uniform mat3 prevTexTransform;
out float varClipDistance;
in vec4 position;
in vec3 normal;
in vec2 texture0;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec3 varCustomPos;
out vec3 varCustomNormal;
out vec2 varCustomTex0;
out vec4 varTangent;
out vec2 varShadowTex;
flat out int varStereoViewID;
in vec4 tangent;
in vec2 texture1;
void main()
{
varCustomPos=(script_modelMatrix*(mat4(vec4(12.0,0.0,0.0,0.0),vec4(0.0,12.0,0.0,0.0),vec4(0.0,0.0,12.0,0.0),vec4(0.0,0.0,0.0,1.0))*(mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0))*position))).xyz;
varCustomNormal=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
vec2 l9_0=texture0*1.002;
varCustomTex0=vec2((prevTexTransform*vec3(l9_0,1.0)).xy);
vec4 l9_1=vec4((l9_0*2.0)-vec2(1.0),0.0,1.0);
vec4 l9_2=sc_ModelViewProjectionMatrixArray[0]*l9_1;
vec4 l9_3=sc_ModelMatrix*l9_1;
varPosAndMotion=vec4(l9_3.x,l9_3.y,l9_3.z,varPosAndMotion.w);
vec3 l9_4=normalize(sc_NormalMatrix*normal);
varNormalAndMotion=vec4(l9_4.x,l9_4.y,l9_4.z,varNormalAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_2;
varScreenTexturePos=((l9_2.xy/vec2(l9_2.w))*0.5)+vec2(0.5);
vec4 l9_5=l9_2*1.0;
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
gl_Position=l9_6;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
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
#ifndef prevTexHasSwappedViews
#define prevTexHasSwappedViews 0
#elif prevTexHasSwappedViews==1
#undef prevTexHasSwappedViews
#define prevTexHasSwappedViews 1
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
#ifndef prevTexLayout
#define prevTexLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_prevTex
#define SC_SOFTWARE_WRAP_MODE_U_prevTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_prevTex
#define SC_SOFTWARE_WRAP_MODE_V_prevTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 0
#elif SC_USE_UV_MIN_MAX_prevTex==1
#undef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 0
#elif SC_USE_CLAMP_TO_BORDER_prevTex==1
#undef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 1
#endif
uniform vec4 sc_UniformConstants;
uniform vec3 uniCameraPos;
uniform vec3 uniSphereCenter;
uniform mat4 script_viewProjectionMatrix;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform float blendInFactor;
uniform float stopCapture;
uniform vec4 prevTexUvMinMax;
uniform vec4 prevTexBorderColor;
uniform mediump sampler2DArray baseTexArrSC;
uniform mediump sampler2D baseTex;
uniform mediump sampler2DArray prevTexArrSC;
uniform mediump sampler2D prevTex;
layout(location=0) out vec4 sc_FragData0;
in vec3 varCustomNormal;
in vec3 varCustomPos;
in vec2 varCustomTex0;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varTex01;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
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
int prevTexGetStereoViewIndex()
{
int l9_0;
#if (prevTexHasSwappedViews)
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
void main()
{
float l9_0=(varCustomPos.y-0.0)/(varCustomNormal.y+(1.0-max(abs(sign(varCustomNormal.y)),0.99900001)));
float l9_1=step(l9_0,0.0);
float l9_2=max(length(uniCameraPos-uniSphereCenter),100.0);
vec3 l9_3=(varCustomPos+varCustomNormal)-varCustomPos;
float l9_4=dot(l9_3,l9_3);
float l9_5=2.0*dot(l9_3,varCustomPos-uniSphereCenter);
float l9_6=sqrt((l9_5*l9_5)-((4.0*l9_4)*(((dot(uniSphereCenter,uniSphereCenter)+dot(varCustomPos,varCustomPos))-(2.0*dot(uniSphereCenter,varCustomPos)))-(l9_2*l9_2))));
float l9_7=2.0*l9_4;
float l9_8=l9_7+(1.0-max(abs(sign(l9_7)),0.99900001));
float l9_9=-l9_5;
vec3 l9_10=varCustomPos+(l9_3*((l9_9-l9_6)/l9_8));
vec3 l9_11=step(vec3(0.0),(l9_10-varCustomPos)/varCustomNormal);
vec4 l9_12=script_viewProjectionMatrix*vec4(mix(mix(varCustomPos+(l9_3*((l9_9+l9_6)/l9_8)),l9_10,vec3(min(min(l9_11.x,l9_11.y),l9_11.z))),mix(vec3(0.0,0.0,10000.0),varCustomPos+((varCustomNormal*l9_0)*(-1.0)),vec3(l9_1)),vec3(l9_1*step((-1.0)*l9_2,l9_0))),1.0);
float l9_13=l9_12.w;
vec2 l9_14=vec2((baseTexTransform*vec3(((l9_12.xy/vec2(l9_13+(1.0-max(abs(sign(l9_13)),0.99900001))))*0.5)+vec2(0.5),1.0)).xy);
vec4 l9_15;
#if (baseTexLayout==2)
{
l9_15=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_14,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTexArrSC);
}
#else
{
l9_15=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_14,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
}
#endif
vec2 l9_16=abs(clamp(l9_14,vec2(0.0),vec2(1.0))-vec2(0.5));
float l9_17=max(l9_16.x,l9_16.y)*2.0;
vec4 l9_18=l9_15;
l9_18.w=((1.0-(l9_17*l9_17))*blendInFactor)*step(abs(l9_12.z/l9_13),1.0);
vec3 l9_19=-varCustomNormal;
float l9_20=-l9_19.y;
vec3 l9_21=l9_19;
l9_21.y=l9_20;
float l9_22=abs(l9_19.z);
vec3 l9_23=l9_21;
l9_23.z=l9_22;
vec3 l9_24=abs(l9_23);
float l9_25=l9_24.z;
float l9_26=l9_24.x;
bool l9_27=l9_25>=l9_26;
bool l9_28;
if (l9_27)
{
l9_28=l9_25>=l9_24.y;
}
else
{
l9_28=l9_27;
}
vec2 l9_29;
if (l9_28)
{
l9_29=((vec2(l9_19.x,l9_20)*(0.5/l9_25))*0.5)+vec2(0.5);
}
else
{
float l9_30=l9_24.y;
vec2 l9_31;
if (l9_30>=l9_26)
{
vec2 l9_32=vec2(l9_19.x,-l9_22)*(0.5/l9_30);
float l9_33=l9_32.y;
float l9_34=l9_33*0.5;
float l9_35=abs(l9_34);
vec2 l9_36=vec2((l9_32.x*mix(0.5,1.0,1.0-(abs(l9_33)*2.0)))+0.5,l9_34);
l9_36.y=l9_35;
vec2 l9_37;
if (l9_20>0.0)
{
vec2 l9_38=l9_36;
l9_38.y=1.0-l9_35;
l9_37=l9_38;
}
else
{
l9_37=l9_36;
}
l9_31=l9_37;
}
else
{
float l9_39=l9_19.x;
float l9_40;
if (l9_39<0.0)
{
l9_40=l9_22;
}
else
{
l9_40=-l9_22;
}
vec2 l9_41=vec2(l9_40,l9_20);
vec2 l9_42=l9_41*(0.5/l9_26);
float l9_43=l9_42.x;
float l9_44=l9_43*0.5;
float l9_45=abs(l9_44);
vec2 l9_46=vec2(l9_44,(l9_42.y*mix(0.5,1.0,1.0-(abs(l9_43)*2.0)))+0.5);
l9_46.x=l9_45;
vec2 l9_47;
if (l9_39>0.0)
{
vec2 l9_48=l9_46;
l9_48.x=1.0-l9_45;
l9_47=l9_48;
}
else
{
l9_47=l9_46;
}
l9_31=l9_47;
}
l9_29=l9_31;
}
vec2 l9_49=clamp(vec2((baseTexTransform*vec3(l9_29,1.0)).xy),vec2(0.0020000001),vec2(0.99800003));
vec4 l9_50;
#if (baseTexLayout==2)
{
l9_50=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_49,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTexArrSC);
}
#else
{
l9_50=sc_SampleTextureBias(baseTexLayout,baseTexGetStereoViewIndex(),l9_49,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
}
#endif
vec4 l9_51=l9_50;
l9_51.w=1.0;
vec4 l9_52=mix(l9_51,l9_18,vec4(stopCapture));
vec4 l9_53;
#if (prevTexLayout==2)
{
l9_53=sc_SampleTextureBias(prevTexLayout,prevTexGetStereoViewIndex(),varCustomTex0,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_prevTex,SC_SOFTWARE_WRAP_MODE_V_prevTex),(int(SC_USE_UV_MIN_MAX_prevTex)!=0),prevTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_prevTex)!=0),prevTexBorderColor,0.0,prevTexArrSC);
}
#else
{
l9_53=sc_SampleTextureBias(prevTexLayout,prevTexGetStereoViewIndex(),varCustomTex0,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_prevTex,SC_SOFTWARE_WRAP_MODE_V_prevTex),(int(SC_USE_UV_MIN_MAX_prevTex)!=0),prevTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_prevTex)!=0),prevTexBorderColor,0.0,prevTex);
}
#endif
vec4 l9_54=mix(l9_53,l9_52,vec4(l9_52.w));
vec4 l9_55;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_56=l9_54;
l9_56.x=l9_54.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_55=l9_56;
}
#else
{
l9_55=l9_54;
}
#endif
sc_FragData0=l9_55;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
