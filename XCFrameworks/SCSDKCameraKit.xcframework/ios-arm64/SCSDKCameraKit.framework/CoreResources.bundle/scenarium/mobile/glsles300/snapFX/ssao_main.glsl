#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
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
uniform mat4 sc_ProjectorMatrix;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
out vec4 varPosAndMotion;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out vec4 varNormalAndMotion;
out vec4 varTangent;
out vec4 varTex01;
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
vec4 l9_0=vec4(position.xy,0.0,1.0);
vec4 l9_1;
#if (sc_StereoRenderingMode==1)
{
vec4 l9_2=l9_0;
l9_2.y=(position.y*0.5)+(0.5-float(sc_GetStereoViewIndex()));
l9_1=l9_2;
}
#else
{
l9_1=l9_0;
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
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_6=sc_ProjectorMatrix*l9_0;
varShadowTex=((l9_6.xy/vec2(l9_6.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_7=l9_1*1.0;
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
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
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
#ifndef depthBufferHasSwappedViews
#define depthBufferHasSwappedViews 0
#elif depthBufferHasSwappedViews==1
#undef depthBufferHasSwappedViews
#define depthBufferHasSwappedViews 1
#endif
#ifndef depthBufferLayout
#define depthBufferLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_depthBuffer
#define SC_USE_UV_TRANSFORM_depthBuffer 0
#elif SC_USE_UV_TRANSFORM_depthBuffer==1
#undef SC_USE_UV_TRANSFORM_depthBuffer
#define SC_USE_UV_TRANSFORM_depthBuffer 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_depthBuffer
#define SC_SOFTWARE_WRAP_MODE_U_depthBuffer -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_depthBuffer
#define SC_SOFTWARE_WRAP_MODE_V_depthBuffer -1
#endif
#ifndef SC_USE_UV_MIN_MAX_depthBuffer
#define SC_USE_UV_MIN_MAX_depthBuffer 0
#elif SC_USE_UV_MIN_MAX_depthBuffer==1
#undef SC_USE_UV_MIN_MAX_depthBuffer
#define SC_USE_UV_MIN_MAX_depthBuffer 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_depthBuffer
#define SC_USE_CLAMP_TO_BORDER_depthBuffer 0
#elif SC_USE_CLAMP_TO_BORDER_depthBuffer==1
#undef SC_USE_CLAMP_TO_BORDER_depthBuffer
#define SC_USE_CLAMP_TO_BORDER_depthBuffer 1
#endif
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat3 depthBufferTransform;
uniform vec4 depthBufferUvMinMax;
uniform vec4 depthBufferBorderColor;
uniform mat4 sc_ProjectionMatrixInverseArray[sc_NumStereoViews];
uniform vec4 depthBufferDims;
uniform vec2 tapRotationCosSin;
uniform float projectionScaleRadiusInPixels;
uniform vec2 sampleCount;
uniform float invRadiusSquared;
uniform float selfOcclusionBias;
uniform float peakFalloffSquared;
uniform float intensity;
uniform float power;
uniform float invFarPlane;
uniform mediump sampler2DArray depthBufferArrSC;
uniform mediump sampler2D depthBuffer;
flat in int varStereoViewID;
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
in vec4 varScreenPos;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varTex01;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
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
int depthBufferGetStereoViewIndex()
{
int l9_0;
#if (depthBufferHasSwappedViews)
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
float depthScreenToViewSpace(float depth,vec4 projectionMatrixTerms)
{
float l9_0=projectionMatrixTerms.x;
float l9_1=projectionMatrixTerms.y;
depth=(depth*2.0)-1.0;
float l9_2;
if (projectionMatrixTerms.z==0.0)
{
l9_2=(depth-l9_1)/l9_0;
}
else
{
l9_2=l9_1/((-depth)-l9_0);
}
return l9_2;
}
float depthScreenToViewSpace(float depth)
{
return depthScreenToViewSpace(depth,vec4(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z,sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z,sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w,0.0));
}
float sampleLinearDepth(vec2 uv)
{
vec4 l9_0;
#if (depthBufferLayout==2)
{
l9_0=sc_SampleTextureBias(depthBufferLayout,depthBufferGetStereoViewIndex(),uv,(int(SC_USE_UV_TRANSFORM_depthBuffer)!=0),depthBufferTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthBuffer,SC_SOFTWARE_WRAP_MODE_V_depthBuffer),(int(SC_USE_UV_MIN_MAX_depthBuffer)!=0),depthBufferUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_depthBuffer)!=0),depthBufferBorderColor,0.0,depthBufferArrSC);
}
#else
{
l9_0=sc_SampleTextureBias(depthBufferLayout,depthBufferGetStereoViewIndex(),uv,(int(SC_USE_UV_TRANSFORM_depthBuffer)!=0),depthBufferTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_depthBuffer,SC_SOFTWARE_WRAP_MODE_V_depthBuffer),(int(SC_USE_UV_MIN_MAX_depthBuffer)!=0),depthBufferUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_depthBuffer)!=0),depthBufferBorderColor,0.0,depthBuffer);
}
#endif
return depthScreenToViewSpace(l9_0.x);
}
vec3 computeViewSpacePositionFromDepth(vec2 uv)
{
float l9_0=sampleLinearDepth(uv);
return vec3(((vec2(0.5)-uv)*vec2(sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()][0].x,sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()][1].y))*l9_0,l9_0);
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
vec2 l9_0=(varScreenPos.xy*0.5)+vec2(0.5);
vec3 l9_1=computeViewSpacePositionFromDepth(l9_0);
vec2 l9_2=vec2(1.0)/depthBufferDims.xy;
vec3 l9_3=computeViewSpacePositionFromDepth(l9_0+vec2(l9_2.x,0.0));
vec3 l9_4=computeViewSpacePositionFromDepth(l9_0+vec2(0.0,l9_2.y));
float l9_5;
if (intensity>0.0)
{
float l9_6=fract(52.982918*fract(dot(gl_FragCoord.xy,vec2(0.067110561,0.0058371499))));
float l9_7=15.079645*l9_6;
float l9_8=l9_1.z;
float l9_9;
vec2 l9_10;
l9_10=vec2(cos(l9_7),sin(l9_7));
l9_9=0.0;
vec2 l9_11;
float l9_12=0.0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_12<sampleCount.x)
{
float l9_13=((l9_12+l9_6)+0.5)*sampleCount.y;
vec3 l9_14=computeViewSpacePositionFromDepth(l9_0+((l9_10*max(1.0,(l9_13*l9_13)*((-projectionScaleRadiusInPixels)/l9_8)))*l9_2))-l9_1;
float l9_15=dot(l9_14,l9_14);
float l9_16=max(0.0,1.0-(l9_15*invRadiusSquared));
l9_10=mat2(vec2(tapRotationCosSin.x,tapRotationCosSin.y),vec2(-tapRotationCosSin.y,tapRotationCosSin.x))*l9_10;
l9_9+=((l9_16*l9_16)*(max(0.0,dot(l9_14,normalize(cross(l9_3-l9_1,l9_4-l9_1)))+(l9_8*selfOcclusionBias))/(l9_15+peakFalloffSquared)));
l9_12+=1.0;
continue;
}
else
{
break;
}
}
l9_5=sqrt(l9_9*intensity);
}
else
{
l9_5=0.0;
}
float l9_17=1.0-l9_5;
float l9_18=pow(clamp(l9_17,0.0,1.0),power);
float l9_19=256.0*clamp((-l9_1.z)*invFarPlane,0.0,1.0);
float l9_20=floor(l9_19);
vec4 l9_21=vec4(l9_18,l9_20*0.00390625,l9_19-l9_20,1.0);
vec4 l9_22;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_23=l9_21;
l9_23.x=l9_18+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_22=l9_23;
}
#else
{
l9_22=l9_21;
}
#endif
sc_FragData0=l9_22;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
