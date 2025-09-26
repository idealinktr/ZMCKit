#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//attribute vec2 texture0 3
//attribute vec3 normal 1
//attribute vec4 tangent 2
//attribute vec2 texture1 4
//sampler sampler depthTextureSmpSC 0:7
//texture texture2D depthTexture 0:0:0:7
//texture texture2DArray depthTextureArrSC 0:14:0:7
//spec_const bool PACKED_DISPARITY 0 0
//spec_const bool SC_USE_CLAMP_TO_BORDER_depthTexture 1 0
//spec_const bool SC_USE_UV_MIN_MAX_depthTexture 2 0
//spec_const bool SC_USE_UV_TRANSFORM_depthTexture 3 0
//spec_const bool depthTextureHasSwappedViews 4 0
//spec_const int SC_SOFTWARE_WRAP_MODE_U_depthTexture 5 -1
//spec_const int SC_SOFTWARE_WRAP_MODE_V_depthTexture 6 -1
//spec_const int depthTextureLayout 7 0
//spec_const int sc_DepthBufferMode 8 0
//spec_const int sc_RenderingSpace 9 -1
//spec_const int sc_ShaderCacheConstant 10 0
//spec_const int sc_StereoRenderingMode 11 0
//spec_const int sc_StereoRendering_IsClipDistanceEnabled 12 0
//spec_const int sc_StereoViewID 13 0
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
#ifndef sc_DepthBufferMode
#define sc_DepthBufferMode 0
#endif
uniform mat4 sc_ModelMatrix;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
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
vec4 l9_0;
#if (sc_RenderingSpace==3)
{
l9_0=sc_ApplyScreenSpaceInstancedClippedShift(position);
}
#else
{
vec4 l9_1;
#if (sc_RenderingSpace==2)
{
l9_1=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*position;
}
#else
{
vec4 l9_2;
#if (sc_RenderingSpace==1)
{
l9_2=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*position;
}
#else
{
vec4 l9_3;
#if (sc_RenderingSpace==4)
{
l9_3=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_3=position;
}
#endif
l9_2=l9_3;
}
#endif
l9_1=l9_2;
}
#endif
l9_0=l9_1;
}
#endif
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_0.x,l9_0.y,l9_0.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(position.x,position.y,position.z,varPosAndMotion.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_4=sc_ModelMatrix*position;
varPosAndMotion=vec4(l9_4.x,l9_4.y,l9_4.z,varPosAndMotion.w);
}
#endif
}
#endif
}
#endif
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=l9_0;
vec2 l9_5=((l9_0.xy/vec2(l9_0.w))*0.5)+vec2(0.5);
vec2 l9_6;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_7=vec3(l9_5,0.0);
l9_7.y=((2.0*l9_5.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_6=l9_7.xy;
}
#else
{
l9_6=l9_5;
}
#endif
varScreenTexturePos=l9_6;
vec4 l9_8;
#if (sc_DepthBufferMode==1)
{
vec4 l9_9;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_10=l9_0;
l9_10.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_0.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_0.w;
l9_9=l9_10;
}
else
{
l9_9=l9_0;
}
l9_8=l9_9;
}
#else
{
l9_8=l9_0;
}
#endif
vec4 l9_11=l9_8*1.0;
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
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 0
#elif depthTextureHasSwappedViews==1
#undef depthTextureHasSwappedViews
#define depthTextureHasSwappedViews 1
#endif
#ifndef depthTextureLayout
#define depthTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_depthTexture
#define SC_USE_UV_TRANSFORM_depthTexture 0
#elif SC_USE_UV_TRANSFORM_depthTexture==1
#undef SC_USE_UV_TRANSFORM_depthTexture
#define SC_USE_UV_TRANSFORM_depthTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_depthTexture
#define SC_SOFTWARE_WRAP_MODE_U_depthTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_depthTexture
#define SC_SOFTWARE_WRAP_MODE_V_depthTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_depthTexture
#define SC_USE_UV_MIN_MAX_depthTexture 0
#elif SC_USE_UV_MIN_MAX_depthTexture==1
#undef SC_USE_UV_MIN_MAX_depthTexture
#define SC_USE_UV_MIN_MAX_depthTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_depthTexture
#define SC_USE_CLAMP_TO_BORDER_depthTexture 0
#elif SC_USE_CLAMP_TO_BORDER_depthTexture==1
#undef SC_USE_CLAMP_TO_BORDER_depthTexture
#define SC_USE_CLAMP_TO_BORDER_depthTexture 1
#endif
#ifndef PACKED_DISPARITY
#define PACKED_DISPARITY 0
#elif PACKED_DISPARITY==1
#undef PACKED_DISPARITY
#define PACKED_DISPARITY 1
#endif
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform mat3 depthTextureTransform;
uniform vec4 depthTextureUvMinMax;
uniform vec4 depthTextureBorderColor;
uniform float depthToDisparityNumerator;
uniform float depthScale;
uniform float defaultDepth;
uniform mediump sampler2DArray depthTextureArrSC;
uniform mediump sampler2D depthTexture;
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
int depthTextureGetStereoViewIndex()
{
int l9_0;
#if (depthTextureHasSwappedViews)
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
#if (depthTextureLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_depthTexture)!=0));
float l9_2=varTex01.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x);
float l9_3=l9_2;
float l9_4=varTex01.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_depthTexture)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,depthTextureUvMinMax.x,depthTextureUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,depthTextureUvMinMax.y,depthTextureUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_depthTexture)!=0),depthTextureTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),depthTextureLayout,depthTextureGetStereoViewIndex());
vec4 l9_23=texture(depthTextureArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_24=mix(depthTextureBorderColor,l9_23,vec4(l9_21));
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
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_depthTexture)!=0));
float l9_26=varTex01.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x);
float l9_27=l9_26;
float l9_28=varTex01.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_depthTexture)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,depthTextureUvMinMax.x,depthTextureUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_depthTexture)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,depthTextureUvMinMax.y,depthTextureUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_depthTexture)!=0),depthTextureTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthTexture,SC_SOFTWARE_WRAP_MODE_V_depthTexture).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),depthTextureLayout,depthTextureGetStereoViewIndex());
vec4 l9_47=texture(depthTexture,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_depthTexture)
{
l9_48=mix(depthTextureBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
float l9_49;
#if (PACKED_DISPARITY)
{
l9_49=(depthToDisparityNumerator/(dot(l9_0.xy,vec2(1.0,0.0039215689))+9.9999997e-06))*depthScale;
}
#else
{
l9_49=l9_0.x*depthScale;
}
#endif
bool l9_50=isinf(l9_49);
bool l9_51=!l9_50;
bool l9_52;
if (l9_51)
{
l9_52=!isnan(l9_49);
}
else
{
l9_52=l9_51;
}
float l9_53;
if (l9_52)
{
vec4 l9_54=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(0.0,0.0,-l9_49,1.0);
l9_53=((0.5*l9_54.z)/l9_54.w)+0.5;
}
else
{
l9_53=defaultDepth;
}
gl_FragDepth=l9_53;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
