#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
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
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
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
uniform mat4 sc_ProjectorMatrix;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2DArray mainTextureArrSC;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec2 texture0;
out vec4 varPosAndMotion;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out float varDepth;
out vec4 varNormalAndMotion;
out vec4 varTangent;
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
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void main()
{
vec4 l9_0;
#if (mainTextureLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_mainTexture)!=0));
float l9_2=texture0.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x);
float l9_3=l9_2;
float l9_4=texture0.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_mainTexture)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,mainTextureUvMinMax.x,mainTextureUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,mainTextureUvMinMax.y,mainTextureUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),mainTextureLayout,mainTextureGetStereoViewIndex());
vec4 l9_23=textureLod(mainTextureArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_24=mix(mainTextureBorderColor,l9_23,vec4(l9_21));
}
#else
{
l9_24=l9_23;
}
#endif
l9_0=l9_24;
}
#else
{
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_mainTexture)!=0));
float l9_26=texture0.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x);
float l9_27=l9_26;
float l9_28=texture0.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_mainTexture)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,mainTextureUvMinMax.x,mainTextureUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,mainTextureUvMinMax.y,mainTextureUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),mainTextureLayout,mainTextureGetStereoViewIndex());
vec4 l9_47=textureLod(mainTexture,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_48=mix(mainTextureBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
vec3 l9_49=position.xyz*l9_0.x;
float l9_50=l9_49.z;
varDepth=l9_50;
float l9_51=-l9_49.y;
vec4 l9_52=vec4(l9_49.x,l9_49.y,l9_49.z,position.w);
l9_52.y=l9_51;
vec4 l9_53=l9_52;
l9_53.z=-l9_50;
vec4 l9_54;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_55=l9_53;
l9_55.y=(l9_51*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_54=l9_55;
}
#else
{
l9_54=l9_53;
}
#endif
varPosAndMotion=vec4(l9_54.x,l9_54.y,l9_54.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_54;
vec2 l9_56=((l9_54.xy/vec2(l9_54.w))*0.5)+vec2(0.5);
vec2 l9_57;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_58=vec3(l9_56,0.0);
l9_58.y=((2.0*l9_56.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_57=l9_58.xy;
}
#else
{
l9_57=l9_56;
}
#endif
varScreenTexturePos=l9_57;
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_59=sc_ProjectorMatrix*l9_53;
varShadowTex=((l9_59.xy/vec2(l9_59.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_60=l9_54*1.0;
vec4 l9_61;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_62=l9_60;
l9_62.x=l9_60.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_61=l9_62;
}
#else
{
l9_61=l9_60;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_63=dot(l9_61,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_63);
}
#else
{
varClipDistance=l9_63;
}
#endif
}
#endif
gl_Position=l9_61;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
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
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
in float varDepth;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varTex01;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
flat in int varStereoViewID;
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
int l9_0=int(min(varDepth,65535.0));
int l9_1=l9_0/256;
float l9_2=float(l9_1)/255.0;
vec4 l9_3=vec4(l9_2,float(l9_0-(l9_1*256))/255.0,0.0,1.0);
vec4 l9_4;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_5=l9_3;
l9_5.x=l9_2+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_4=l9_5;
}
#else
{
l9_4=l9_3;
}
#endif
sc_FragData0=l9_4;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
