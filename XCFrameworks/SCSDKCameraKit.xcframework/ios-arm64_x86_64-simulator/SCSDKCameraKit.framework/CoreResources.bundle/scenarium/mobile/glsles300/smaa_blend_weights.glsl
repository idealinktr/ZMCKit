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
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
#ifndef SMAA_QUALITY
#define SMAA_QUALITY 0
#endif
uniform mat4 sc_ProjectorMatrix;
uniform vec4 sc_UniformConstants;
uniform vec4 inputTextureSize;
out float varClipDistance;
in vec4 position;
in vec2 texture0;
out vec4 varPosAndMotion;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec2 varShadowTex;
out vec2 varPixCoord;
out vec4 varOffset0;
out vec4 varOffset1;
out vec4 varOffset2;
out vec4 varNormalAndMotion;
out vec4 varTangent;
flat out int varStereoViewID;
in vec3 normal;
in vec4 tangent;
in vec2 texture1;
int smaaMaxSearchSteps(int smaaQuality)
{
if (((smaaQuality==2)||(smaaQuality==3))||(smaaQuality==4))
{
return 25;
}
return 0;
}
void main()
{
varPosAndMotion=vec4(position.x,position.y,position.z,varPosAndMotion.w);
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varScreenPos=position;
varScreenTexturePos=((position.xy/vec2(position.w))*0.5)+vec2(0.5);
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_0=sc_ProjectorMatrix*position;
varShadowTex=((l9_0.xy/vec2(l9_0.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_1=position*1.0;
vec4 l9_2;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_3=l9_1;
l9_3.x=l9_1.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_2=l9_3;
}
#else
{
l9_2=l9_1;
}
#endif
gl_Position=l9_2;
vec2 l9_5=(position.xy*0.5)+vec2(0.5);
varTex01=vec4(l9_5.x,l9_5.y,varTex01.z,varTex01.w);
vec4 l9_6=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
varPixCoord=varTex01.xy*l9_6.zw;
vec4 l9_7=l9_6.xyxy;
varOffset0=(l9_7*vec4(-0.25,0.125,1.25,0.125))+varTex01.xyxy;
varOffset1=(l9_7*vec4(-0.125,0.25,-0.125,-1.25))+varTex01.xyxy;
varOffset2=((l9_6.xxyy*vec4(-2.0,2.0,2.0,-2.0))*float(smaaMaxSearchSteps(SMAA_QUALITY)))+vec4(varOffset0.xz,varOffset1.yw);
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
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef edgesTexHasSwappedViews
#define edgesTexHasSwappedViews 0
#elif edgesTexHasSwappedViews==1
#undef edgesTexHasSwappedViews
#define edgesTexHasSwappedViews 1
#endif
#ifndef areaTexHasSwappedViews
#define areaTexHasSwappedViews 0
#elif areaTexHasSwappedViews==1
#undef areaTexHasSwappedViews
#define areaTexHasSwappedViews 1
#endif
#ifndef searchTexHasSwappedViews
#define searchTexHasSwappedViews 0
#elif searchTexHasSwappedViews==1
#undef searchTexHasSwappedViews
#define searchTexHasSwappedViews 1
#endif
#ifndef SMAA_QUALITY
#define SMAA_QUALITY 0
#endif
#ifndef edgesTexLayout
#define edgesTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_edgesTex
#define SC_USE_UV_TRANSFORM_edgesTex 0
#elif SC_USE_UV_TRANSFORM_edgesTex==1
#undef SC_USE_UV_TRANSFORM_edgesTex
#define SC_USE_UV_TRANSFORM_edgesTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_edgesTex
#define SC_SOFTWARE_WRAP_MODE_U_edgesTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_edgesTex
#define SC_SOFTWARE_WRAP_MODE_V_edgesTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_edgesTex
#define SC_USE_UV_MIN_MAX_edgesTex 0
#elif SC_USE_UV_MIN_MAX_edgesTex==1
#undef SC_USE_UV_MIN_MAX_edgesTex
#define SC_USE_UV_MIN_MAX_edgesTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_edgesTex
#define SC_USE_CLAMP_TO_BORDER_edgesTex 0
#elif SC_USE_CLAMP_TO_BORDER_edgesTex==1
#undef SC_USE_CLAMP_TO_BORDER_edgesTex
#define SC_USE_CLAMP_TO_BORDER_edgesTex 1
#endif
#ifndef SMAA_AREATEX_MAX_DISTANCE_DIAG
#define SMAA_AREATEX_MAX_DISTANCE_DIAG 20
#endif
#ifndef areaTexLayout
#define areaTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_areaTex
#define SC_USE_UV_TRANSFORM_areaTex 0
#elif SC_USE_UV_TRANSFORM_areaTex==1
#undef SC_USE_UV_TRANSFORM_areaTex
#define SC_USE_UV_TRANSFORM_areaTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_areaTex
#define SC_SOFTWARE_WRAP_MODE_U_areaTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_areaTex
#define SC_SOFTWARE_WRAP_MODE_V_areaTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_areaTex
#define SC_USE_UV_MIN_MAX_areaTex 0
#elif SC_USE_UV_MIN_MAX_areaTex==1
#undef SC_USE_UV_MIN_MAX_areaTex
#define SC_USE_UV_MIN_MAX_areaTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_areaTex
#define SC_USE_CLAMP_TO_BORDER_areaTex 0
#elif SC_USE_CLAMP_TO_BORDER_areaTex==1
#undef SC_USE_CLAMP_TO_BORDER_areaTex
#define SC_USE_CLAMP_TO_BORDER_areaTex 1
#endif
#ifndef searchTexLayout
#define searchTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_searchTex
#define SC_USE_UV_TRANSFORM_searchTex 0
#elif SC_USE_UV_TRANSFORM_searchTex==1
#undef SC_USE_UV_TRANSFORM_searchTex
#define SC_USE_UV_TRANSFORM_searchTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_searchTex
#define SC_SOFTWARE_WRAP_MODE_U_searchTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_searchTex
#define SC_SOFTWARE_WRAP_MODE_V_searchTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_searchTex
#define SC_USE_UV_MIN_MAX_searchTex 0
#elif SC_USE_UV_MIN_MAX_searchTex==1
#undef SC_USE_UV_MIN_MAX_searchTex
#define SC_USE_UV_MIN_MAX_searchTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_searchTex
#define SC_USE_CLAMP_TO_BORDER_searchTex 0
#elif SC_USE_CLAMP_TO_BORDER_searchTex==1
#undef SC_USE_CLAMP_TO_BORDER_searchTex
#define SC_USE_CLAMP_TO_BORDER_searchTex 1
#endif
#ifndef SMAA_AREATEX_MAX_DISTANCE
#define SMAA_AREATEX_MAX_DISTANCE 16
#endif
#ifndef DEBUG_MODE
#define DEBUG_MODE 0
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
uniform vec4 inputTextureSize;
uniform mat3 edgesTexTransform;
uniform vec4 edgesTexUvMinMax;
uniform vec4 edgesTexBorderColor;
uniform mat3 areaTexTransform;
uniform vec4 areaTexUvMinMax;
uniform vec4 areaTexBorderColor;
uniform mat3 searchTexTransform;
uniform vec4 searchTexUvMinMax;
uniform vec4 searchTexBorderColor;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2DArray inputTextureArrSC;
uniform mediump sampler2D edgesTex;
uniform mediump sampler2DArray edgesTexArrSC;
uniform mediump sampler2D areaTex;
uniform mediump sampler2DArray areaTexArrSC;
uniform mediump sampler2D searchTex;
uniform mediump sampler2DArray searchTexArrSC;
layout(location=0) out vec4 sc_FragData0;
in vec4 varTex01;
in vec4 varOffset0;
in vec4 varOffset2;
in vec4 varOffset1;
in vec2 varPixCoord;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varScreenPos;
in vec2 varScreenTexturePos;
in vec2 varShadowTex;
flat in int varStereoViewID;
in float varClipDistance;
int inputTextureGetStereoViewIndex()
{
int l9_0;
#if (inputTextureHasSwappedViews)
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
void sc_writeFragData0(vec4 col)
{
#if (sc_ShaderCacheConstant!=0)
{
col.x+=(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
}
#endif
sc_FragData0=col;
}
int edgesTexGetStereoViewIndex()
{
int l9_0;
#if (edgesTexHasSwappedViews)
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
int smaaMaxSearchStepsDiag(int smaaQuality)
{
if (smaaQuality==2)
{
return 8;
}
else
{
if ((smaaQuality==3)||(smaaQuality==4))
{
return 16;
}
}
return 0;
}
vec2 SMAASearchDiag1(vec2 texcoord,vec2 dir,out vec2 e)
{
vec4 l9_0;
l9_0=vec4(texcoord,-1.0,1.0);
vec4 l9_1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_2=smaaMaxSearchStepsDiag(SMAA_QUALITY);
bool l9_3=l9_0.z<float(l9_2-1);
bool l9_4;
if (l9_3)
{
l9_4=l9_0.w>0.89999998;
}
else
{
l9_4=l9_3;
}
if (l9_4)
{
vec3 l9_5=(vec3(1.0/inputTextureSize.x,1.0/inputTextureSize.y,1.0)*vec3(dir,1.0))+l9_0.xyz;
vec4 l9_6=vec4(l9_5.x,l9_5.y,l9_5.z,l9_0.w);
vec4 l9_7;
#if (edgesTexLayout==2)
{
l9_7=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_5.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_7=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_5.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
e=l9_7.xy;
l9_1=l9_6;
l9_1.w=dot(e,vec2(0.5));
l9_0=l9_1;
continue;
}
else
{
break;
}
}
return l9_0.zw;
}
void SMAAMovc(vec2 cond,inout vec2 variable,vec2 value)
{
if (cond.x>0.0)
{
variable.x=value.x;
}
if (cond.y>0.0)
{
variable.y=value.y;
}
}
int areaTexGetStereoViewIndex()
{
int l9_0;
#if (areaTexHasSwappedViews)
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
vec2 SMAAAreaDiag(vec2 dist,vec2 e,float offset)
{
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
vec2 l9_1=(vec2(0.0062500001,0.0017857143)*((vec2(float(SMAA_AREATEX_MAX_DISTANCE_DIAG))*e)+dist))+vec2(0.003125,0.00089285715);
float l9_2=l9_1.y+(0.14285715*offset);
vec2 l9_3=vec2(l9_1.x+0.5,l9_2);
l9_3.y=1.0-l9_2;
vec4 l9_4;
#if (areaTexLayout==2)
{
l9_4=sc_SampleTextureBias(areaTexLayout,areaTexGetStereoViewIndex(),l9_3+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTexArrSC);
}
#else
{
l9_4=sc_SampleTextureBias(areaTexLayout,areaTexGetStereoViewIndex(),l9_3+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTex);
}
#endif
return l9_4.xy;
}
vec2 SMAASearchDiag2(vec2 texcoord,vec2 dir,out vec2 e)
{
float l9_0=1.0/inputTextureSize.x;
vec4 l9_1=vec4(texcoord,-1.0,1.0);
l9_1.x=texcoord.x+(0.25*l9_0);
vec4 l9_2;
l9_2=l9_1;
vec4 l9_3;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_4=smaaMaxSearchStepsDiag(SMAA_QUALITY);
bool l9_5=l9_2.z<float(l9_4-1);
bool l9_6;
if (l9_5)
{
l9_6=l9_2.w>0.89999998;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
vec3 l9_7=(vec3(l9_0,1.0/inputTextureSize.y,1.0)*vec3(dir,1.0))+l9_2.xyz;
vec4 l9_8=vec4(l9_7.x,l9_7.y,l9_7.z,l9_2.w);
vec4 l9_9;
#if (edgesTexLayout==2)
{
l9_9=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_9=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
e=l9_9.xy;
vec2 l9_10=e;
l9_10.x=e.x*abs((5.0*e.x)-3.75);
e=round(l9_10);
l9_3=l9_8;
l9_3.w=dot(e,vec2(0.5));
l9_2=l9_3;
continue;
}
else
{
break;
}
}
return l9_2.zw;
}
vec2 SMAACalculateDiagWeights(vec2 texcoord,vec2 e,vec4 subsampleIndices)
{
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
vec4 l9_1;
if (e.x>0.0)
{
vec2 param_2;
vec2 l9_2=SMAASearchDiag1(texcoord,vec2(-1.0),param_2);
vec4 l9_3=vec4(l9_2.x,vec4(0.0).y,l9_2.y,vec4(0.0).w);
l9_3.x=l9_2.x+float(param_2.y>0.89999998);
l9_1=l9_3;
}
else
{
l9_1=vec4(0.0);
}
vec2 param_5;
vec2 l9_4=SMAASearchDiag1(texcoord,vec2(1.0),param_5);
vec2 l9_5;
if ((l9_1.x+l9_4.x)>2.0)
{
float l9_6=-l9_1.x;
vec4 l9_7=(vec4(l9_6+0.25,l9_6,l9_4.x,l9_4.x+0.25)*l9_0.xyxy)+texcoord.xyxy;
vec4 l9_8;
#if (edgesTexLayout==2)
{
l9_8=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.xy+(l9_0.xy*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_8=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.xy+(l9_0.xy*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec4 l9_9;
#if (edgesTexLayout==2)
{
l9_9=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.zw+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_9=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_7.zw+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_10=vec4(l9_8.x,l9_8.y,l9_9.x,l9_9.y).xz*abs((vec4(l9_8.x,l9_8.y,l9_9.x,l9_9.y).xz*5.0)-vec2(3.75));
vec4 l9_11=round(vec4(l9_10.x,vec4(l9_8.x,l9_8.y,l9_9.x,l9_9.y).y,l9_10.y,vec4(l9_8.x,l9_8.y,l9_9.x,l9_9.y).w));
vec2 param_51=(vec2(2.0)*l9_11.yw)+l9_11.xz;
SMAAMovc(step(vec2(0.89999998),vec4(l9_1.x,l9_4.x,l9_1.z,l9_4.y).zw),param_51,vec2(0.0));
l9_5=vec2(0.0)+SMAAAreaDiag(vec4(l9_1.x,l9_4.x,l9_1.z,l9_4.y).xy,param_51,subsampleIndices.z);
}
else
{
l9_5=vec2(0.0);
}
vec4 l9_12;
#if (edgesTexLayout==2)
{
l9_12=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),texcoord+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_12=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),texcoord+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 param_80;
vec2 l9_13=SMAASearchDiag2(texcoord,vec2(-1.0,1.0),param_80);
vec4 l9_14;
if (l9_12.x>0.0)
{
vec2 param_83;
vec2 l9_15=SMAASearchDiag2(texcoord,vec2(1.0,-1.0),param_83);
vec4 l9_16=vec4(l9_13.x,l9_15.x,l9_13.y,l9_15.y);
l9_16.y=l9_15.x+float(param_83.y>0.89999998);
l9_14=l9_16;
}
else
{
l9_14=vec4(l9_13.x,vec2(0.0).x,l9_13.y,vec2(0.0).y);
}
vec2 l9_17;
if ((l9_14.x+l9_14.y)>2.0)
{
float l9_18=-l9_14.x;
vec4 l9_19=(vec4(l9_18,l9_18,l9_14.yy)*l9_0.xyxy)+texcoord.xyxy;
vec4 l9_20;
#if (edgesTexLayout==2)
{
l9_20=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.xy+(l9_0.xy*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_20=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.xy+(l9_0.xy*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec4 l9_21=vec4(0.0);
l9_21.x=l9_20.y;
vec4 l9_22;
#if (edgesTexLayout==2)
{
l9_22=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.xy+(l9_0.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_22=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.xy+(l9_0.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec4 l9_23=l9_21;
l9_23.y=l9_22.x;
vec4 l9_24;
#if (edgesTexLayout==2)
{
l9_24=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.zw+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_24=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_19.zw+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 param_151=(vec2(2.0)*vec4(l9_23.x,l9_23.y,l9_24.y,l9_24.x).xz)+vec4(l9_23.x,l9_23.y,l9_24.y,l9_24.x).yw;
SMAAMovc(step(vec2(0.89999998),l9_14.zw),param_151,vec2(0.0));
l9_17=l9_5+SMAAAreaDiag(l9_14.xy,param_151,subsampleIndices.w).yx;
}
else
{
l9_17=l9_5;
}
return l9_17;
}
bool smaaDisableDetection(int smaaQuality)
{
if (((smaaQuality==0)||(smaaQuality==1))||(smaaQuality==4))
{
return true;
}
return false;
}
int searchTexGetStereoViewIndex()
{
int l9_0;
#if (searchTexHasSwappedViews)
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
float SMAASearchLength(vec2 e,float offset)
{
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
vec2 l9_1=vec2(1.0)/vec2(64.0,16.0);
vec2 l9_2=((((vec2(66.0,33.0)*vec2(0.5,-1.0))+vec2(-1.0,1.0))*l9_1)*e)+(((vec2(66.0,33.0)*vec2(offset,1.0))+vec2(0.5,-0.5))*l9_1);
vec2 l9_3=l9_2;
l9_3.y=1.0-l9_2.y;
vec4 l9_4;
#if (searchTexLayout==2)
{
l9_4=sc_SampleTextureBias(searchTexLayout,searchTexGetStereoViewIndex(),l9_3+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_searchTex)!=0),searchTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_searchTex,SC_SOFTWARE_WRAP_MODE_V_searchTex),(int(SC_USE_UV_MIN_MAX_searchTex)!=0),searchTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_searchTex)!=0),searchTexBorderColor,0.0,searchTexArrSC);
}
#else
{
l9_4=sc_SampleTextureBias(searchTexLayout,searchTexGetStereoViewIndex(),l9_3+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_searchTex)!=0),searchTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_searchTex,SC_SOFTWARE_WRAP_MODE_V_searchTex),(int(SC_USE_UV_MIN_MAX_searchTex)!=0),searchTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_searchTex)!=0),searchTexBorderColor,0.0,searchTex);
}
#endif
return l9_4.x;
}
vec2 SMAAArea(vec2 dist,float e1,float e2,float offset)
{
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
vec2 l9_1=(vec2(0.0062500001,0.0017857143)*((vec2(float(SMAA_AREATEX_MAX_DISTANCE))*round(vec2(e1,e2)*4.0))+dist))+vec2(0.003125,0.00089285715);
vec2 l9_2=l9_1;
l9_2.y=1.0-((0.14285715*offset)+l9_1.y);
vec4 l9_3;
#if (areaTexLayout==2)
{
l9_3=sc_SampleTextureBias(areaTexLayout,areaTexGetStereoViewIndex(),l9_2+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTexArrSC);
}
#else
{
l9_3=sc_SampleTextureBias(areaTexLayout,areaTexGetStereoViewIndex(),l9_2+(l9_0.xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTex);
}
#endif
return l9_3.xy;
}
int smaaMaxSearchSteps(int smaaQuality)
{
if (((smaaQuality==2)||(smaaQuality==3))||(smaaQuality==4))
{
return 25;
}
return 0;
}
vec4 DebugColor(vec4 weights,float e1,float e2,vec2 dist)
{
#if ((DEBUG_MODE==1)||(DEBUG_MODE==2))
{
float l9_0;
#if (DEBUG_MODE==1)
{
l9_0=e1*4.0;
}
#else
{
l9_0=e2*4.0;
}
#endif
if (l9_0<0.5)
{
return vec4(1.0,0.0,0.0,1.0);
}
else
{
if (l9_0<1.5)
{
return vec4(0.0,1.0,0.0,1.0);
}
else
{
if (l9_0<3.5)
{
return vec4(0.0,0.0,1.0,1.0);
}
else
{
if (l9_0<4.5)
{
return vec4(1.0,1.0,0.0,1.0);
}
else
{
return vec4(0.5,0.5,0.5,1.0);
}
}
}
}
}
#endif
#if (DEBUG_MODE==3)
{
if (dist.x==0.0)
{
return vec4(1.0,0.0,0.0,1.0);
}
return vec4(dist.x/float(smaaMaxSearchSteps(SMAA_QUALITY)));
}
#else
{
#if (DEBUG_MODE==4)
{
if (dist.y==0.0)
{
return vec4(1.0,0.0,0.0,1.0);
}
return vec4(dist.y/float(smaaMaxSearchSteps(SMAA_QUALITY)));
}
#endif
}
#endif
return weights;
}
int smaaCornerRounding(int smaaQuality)
{
if ((smaaQuality==3)||(smaaQuality==4))
{
return 15;
}
return 0;
}
void main()
{
float l9_0=1.0/inputTextureSize.x;
float l9_1=1.0/inputTextureSize.y;
vec4 l9_2=vec4(l9_0,l9_1,inputTextureSize.x,inputTextureSize.y);
#if (DEBUG_MODE==5)
{
vec4 l9_3;
#if (inputTextureLayout==2)
{
l9_3=sc_SampleTextureBias(inputTextureLayout,inputTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTextureArrSC);
}
#else
{
l9_3=sc_SampleTextureBias(inputTextureLayout,inputTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
}
#endif
sc_writeFragData0(l9_3);
return;
}
#endif
vec4 l9_4;
#if (edgesTexLayout==2)
{
l9_4=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_4=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
#if (DEBUG_MODE==6)
{
vec4 l9_5;
#if (edgesTexLayout==2)
{
l9_5=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_5=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
sc_writeFragData0(l9_5);
return;
}
#endif
vec2 l9_6;
vec4 l9_7;
if (l9_4.y>0.0)
{
vec2 l9_8=SMAACalculateDiagWeights(varTex01.xy,l9_4.xy,vec4(0.0));
bool l9_9=l9_8.x==(-l9_8.y);
bool l9_10;
if (!l9_9)
{
l9_10=smaaDisableDetection(SMAA_QUALITY);
}
else
{
l9_10=l9_9;
}
vec2 l9_11;
vec4 l9_12;
if (l9_10)
{
vec2 l9_13;
vec2 l9_14;
l9_14=vec2(0.0,1.0);
l9_13=varOffset0.xy;
float l9_15;
vec2 l9_16;
vec2 l9_17;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_15=l9_13.x;
bool l9_18=l9_15>varOffset2.x;
bool l9_19;
if (l9_18)
{
l9_19=l9_14.y>0.82810003;
}
else
{
l9_19=l9_18;
}
bool l9_20;
if (l9_19)
{
l9_20=l9_14.x==0.0;
}
else
{
l9_20=l9_19;
}
if (l9_20)
{
vec4 l9_21;
#if (edgesTexLayout==2)
{
l9_21=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_13,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_21=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_13,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
l9_16=l9_21.xy;
l9_17=(vec2(-2.0,-0.0)*l9_2.xy)+l9_13;
l9_14=l9_16;
l9_13=l9_17;
continue;
}
else
{
break;
}
}
float l9_22=SMAASearchLength(l9_14,0.0);
float l9_23=(l9_0*(((-2.007874)*l9_22)+3.25))+l9_15;
vec3 l9_24=vec3(0.0);
l9_24.x=l9_23;
vec3 l9_25=l9_24;
l9_25.y=varOffset1.y;
vec4 l9_26;
#if (edgesTexLayout==2)
{
l9_26=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_25.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_26=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_25.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_27;
vec2 l9_28;
l9_28=vec2(0.0,1.0);
l9_27=varOffset0.zw;
float l9_29;
vec2 l9_30;
vec2 l9_31;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_29=l9_27.x;
bool l9_32=l9_29<varOffset2.y;
bool l9_33;
if (l9_32)
{
l9_33=l9_28.y>0.82810003;
}
else
{
l9_33=l9_32;
}
bool l9_34;
if (l9_33)
{
l9_34=l9_28.x==0.0;
}
else
{
l9_34=l9_33;
}
if (l9_34)
{
vec4 l9_35;
#if (edgesTexLayout==2)
{
l9_35=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_27,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_35=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_27,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
l9_30=l9_35.xy;
l9_31=(vec2(2.0,0.0)*l9_2.xy)+l9_27;
l9_28=l9_30;
l9_27=l9_31;
continue;
}
else
{
break;
}
}
float l9_36=SMAASearchLength(l9_28,0.5);
float l9_37=((-l9_0)*(((-2.007874)*l9_36)+3.25))+l9_29;
vec3 l9_38=vec3(l9_23,varOffset1.y,l9_37);
vec2 l9_39=abs(round((l9_2.zz*vec2(l9_23,l9_37))-varPixCoord.xx));
vec4 l9_40;
#if (edgesTexLayout==2)
{
l9_40=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_38.zy+(l9_2.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_40=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_38.zy+(l9_2.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_41=SMAAArea(sqrt(l9_39),l9_26.x,l9_40.x,0.0);
vec4 l9_42=DebugColor(vec4(l9_41.x,l9_41.y,vec4(0.0).z,vec4(0.0).w),l9_26.x,l9_40.x,l9_39);
vec3 l9_43=l9_38;
l9_43.y=varTex01.y;
vec2 l9_44=l9_42.xy;
vec2 l9_45;
if (!smaaDisableDetection(SMAA_QUALITY))
{
int l9_46=smaaCornerRounding(SMAA_QUALITY);
vec2 l9_47=step(l9_39,l9_39.yx);
vec2 l9_48=(l9_47*(1.0-(float(l9_46)/100.0)))/vec2(l9_47.x+l9_47.y);
vec4 l9_49;
#if (edgesTexLayout==2)
{
l9_49=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.xy+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_49=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.xy+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_50=l9_48.x;
vec4 l9_51;
#if (edgesTexLayout==2)
{
l9_51=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.zy+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_51=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.zy+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_52=l9_48.y;
vec4 l9_53;
#if (edgesTexLayout==2)
{
l9_53=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.xy+(l9_2.xy*vec2(0.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_53=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.xy+(l9_2.xy*vec2(0.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_54=1.0-(l9_50*l9_53.x);
vec4 l9_55;
#if (edgesTexLayout==2)
{
l9_55=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.zy+(l9_2.xy*vec2(1.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_55=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_43.zy+(l9_2.xy*vec2(1.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_56=vec2((1.0-(l9_50*l9_49.x))-(l9_52*l9_51.x),l9_54);
l9_56.y=l9_54-(l9_52*l9_55.x);
l9_45=l9_44*clamp(l9_56,vec2(0.0),vec2(1.0));
}
else
{
l9_45=l9_44;
}
l9_12=vec4(l9_45.x,l9_45.y,l9_42.z,l9_42.w);
l9_11=l9_4.xy;
}
else
{
vec2 l9_57=vec2(0.0);
l9_57.x=0.0;
l9_12=vec4(l9_8.x,l9_8.y,vec4(0.0).z,vec4(0.0).w);
l9_11=l9_57;
}
l9_7=l9_12;
l9_6=l9_11;
}
else
{
l9_7=vec4(0.0);
l9_6=l9_4.xy;
}
vec4 l9_58;
if (l9_6.x>0.0)
{
vec2 l9_59;
vec2 l9_60;
l9_60=vec2(1.0,0.0);
l9_59=varOffset1.xy;
float l9_61;
vec2 l9_62;
vec2 l9_63;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_61=l9_59.y;
bool l9_64=l9_61<varOffset2.z;
bool l9_65;
if (l9_64)
{
l9_65=l9_60.x>0.82810003;
}
else
{
l9_65=l9_64;
}
bool l9_66;
if (l9_65)
{
l9_66=l9_60.y==0.0;
}
else
{
l9_66=l9_65;
}
if (l9_66)
{
vec4 l9_67;
#if (edgesTexLayout==2)
{
l9_67=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_59,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_67=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_59,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
l9_62=l9_67.xy;
l9_63=(vec2(0.0,2.0)*l9_2.xy)+l9_59;
l9_60=l9_62;
l9_59=l9_63;
continue;
}
else
{
break;
}
}
float l9_68=SMAASearchLength(l9_60.yx,0.0);
float l9_69=(l9_1*(-(((-2.007874)*l9_68)+3.25)))+l9_61;
vec3 l9_70=vec3(0.0);
l9_70.y=l9_69;
vec3 l9_71=l9_70;
l9_71.x=varOffset0.x;
vec4 l9_72;
#if (edgesTexLayout==2)
{
l9_72=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_71.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_72=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_71.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_73;
vec2 l9_74;
l9_74=vec2(1.0,0.0);
l9_73=varOffset1.zw;
float l9_75;
vec2 l9_76;
vec2 l9_77;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_75=l9_73.y;
bool l9_78=l9_75>varOffset2.w;
bool l9_79;
if (l9_78)
{
l9_79=l9_74.x>0.82810003;
}
else
{
l9_79=l9_78;
}
bool l9_80;
if (l9_79)
{
l9_80=l9_74.y==0.0;
}
else
{
l9_80=l9_79;
}
if (l9_80)
{
vec4 l9_81;
#if (edgesTexLayout==2)
{
l9_81=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_73,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_81=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_73,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
l9_76=l9_81.xy;
l9_77=(vec2(-0.0,-2.0)*l9_2.xy)+l9_73;
l9_74=l9_76;
l9_73=l9_77;
continue;
}
else
{
break;
}
}
float l9_82=SMAASearchLength(l9_74.yx,0.5);
float l9_83=((-l9_1)*(-(((-2.007874)*l9_82)+3.25)))+l9_75;
vec3 l9_84=vec3(varOffset0.x,l9_69,l9_83);
vec2 l9_85=abs(round((l9_2.ww*vec2(l9_69,l9_83))-varPixCoord.yy));
vec4 l9_86;
#if (edgesTexLayout==2)
{
l9_86=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_84.xz+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_86=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_84.xz+(l9_2.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_87=SMAAArea(sqrt(l9_85),l9_72.y,l9_86.y,0.0);
vec4 l9_88=DebugColor(vec4(l9_7.x,l9_7.y,l9_87.x,l9_87.y),l9_72.y,l9_86.y,l9_85);
vec3 l9_89=l9_84;
l9_89.x=varTex01.x;
vec2 l9_90=l9_88.zw;
vec2 l9_91;
if (!smaaDisableDetection(SMAA_QUALITY))
{
int l9_92=smaaCornerRounding(SMAA_QUALITY);
vec2 l9_93=step(l9_85,l9_85.yx);
vec2 l9_94=(l9_93*(1.0-(float(l9_92)/100.0)))/vec2(l9_93.x+l9_93.y);
vec4 l9_95;
#if (edgesTexLayout==2)
{
l9_95=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xy+(l9_2.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_95=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xy+(l9_2.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_96=l9_94.x;
vec4 l9_97;
#if (edgesTexLayout==2)
{
l9_97=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xz+(l9_2.xy*vec2(1.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_97=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xz+(l9_2.xy*vec2(1.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_98=l9_94.y;
vec4 l9_99;
#if (edgesTexLayout==2)
{
l9_99=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xy+(l9_2.xy*vec2(2.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_99=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xy+(l9_2.xy*vec2(2.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
float l9_100=1.0-(l9_96*l9_99.y);
vec4 l9_101;
#if (edgesTexLayout==2)
{
l9_101=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xz+(l9_2.xy*vec2(-2.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTexArrSC);
}
#else
{
l9_101=sc_SampleTextureBias(edgesTexLayout,edgesTexGetStereoViewIndex(),l9_89.xz+(l9_2.xy*vec2(-2.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
}
#endif
vec2 l9_102=vec2((1.0-(l9_96*l9_95.y))-(l9_98*l9_97.y),l9_100);
l9_102.y=l9_100-(l9_98*l9_101.y);
l9_91=l9_90*clamp(l9_102,vec2(0.0),vec2(1.0));
}
else
{
l9_91=l9_90;
}
l9_58=vec4(l9_88.x,l9_88.y,l9_91.x,l9_91.y);
}
else
{
l9_58=l9_7;
}
sc_writeFragData0(l9_58);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
