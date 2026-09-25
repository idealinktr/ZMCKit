#version 300 es
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define sc_TAADisabled 1
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
#ifndef sc_RenderingSpace
#define sc_RenderingSpace -1
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
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef ENABLE_SDF
#define ENABLE_SDF 0
#elif ENABLE_SDF==1
#undef ENABLE_SDF
#define ENABLE_SDF 1
#endif
uniform mat4 sc_ModelMatrix;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ModelViewMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform float textScaledEmHeight;
uniform vec4 sc_CurrentRenderTargetDims;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 position;
in vec2 texture0;
in vec2 texture1;
out vec4 varPosAndMotion;
out vec4 varTex01;
out vec4 varScreenPos;
out vec2 varScreenTexturePos;
out vec4 varSdfParams;
out vec2 varPassIdDecorThickness;
in float passIdentifierAttr;
in float sdfOffsetAttr;
in float decorThicknessRatioAttr;
out vec4 varGlyphAtlasUvRect;
in vec4 glyphAtlasUvRectAttr;
out vec4 varNormalAndMotion;
out vec4 varTangent;
out vec2 varShadowTex;
in vec3 normal;
in vec4 tangent;
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
float calculateFrustumHeightAtVertex(vec3 vertexWorldPos)
{
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
return abs((2.0*(-(sc_ViewMatrixArray[sc_GetStereoViewIndex()]*vec4(vertexWorldPos,1.0)).z))/sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][1].y);
}
else
{
return abs(4.0/sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][1].y);
}
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
#if (ENABLE_SDF)
{
float l9_0=calculateFrustumHeightAtVertex((sc_ModelMatrix*vec4(position.xyz,1.0)).xyz);
float l9_1=((textScaledEmHeight/l9_0)*sc_CurrentRenderTargetDims.y)/93.0;
mat4 l9_2=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix;
float l9_3=abs(dot(normalize(mat3(l9_2[0].xyz,l9_2[1].xyz,l9_2[2].xyz)*vec3(0.0,0.0,1.0)),vec3(0.0,0.0,-1.0)));
float l9_4;
if (l9_3<0.69999999)
{
l9_4=l9_1*clamp(l9_3,0.11,0.69999999);
}
else
{
l9_4=l9_1;
}
varSdfParams.x=clamp(1.0-((l9_4-0.5)/0.5),0.0,1.0);
varSdfParams.y=clamp((l9_4*31.67)+1.0,1.0,250.0);
varSdfParams.z=clamp(l9_4*15.83,0.0,124.5);
}
#endif
vec4 l9_5;
#if (sc_RenderingSpace==3)
{
l9_5=sc_ApplyScreenSpaceInstancedClippedShift(position);
}
#else
{
vec4 l9_6;
#if (sc_RenderingSpace==2)
{
l9_6=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*position;
}
#else
{
vec4 l9_7;
#if (sc_RenderingSpace==1)
{
l9_7=sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()]*position;
}
#else
{
vec4 l9_8;
#if (sc_RenderingSpace==4)
{
l9_8=sc_ApplyScreenSpaceInstancedClippedShift((sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0));
}
#else
{
l9_8=position;
}
#endif
l9_7=l9_8;
}
#endif
l9_6=l9_7;
}
#endif
l9_5=l9_6;
}
#endif
#if ((sc_RenderingSpace==3)||(sc_RenderingSpace==4))
{
varPosAndMotion=vec4(l9_5.x,l9_5.y,l9_5.z,varPosAndMotion.w);
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
vec4 l9_9=sc_ModelMatrix*position;
varPosAndMotion=vec4(l9_9.x,l9_9.y,l9_9.z,varPosAndMotion.w);
}
#endif
}
#endif
}
#endif
varTex01=vec4(texture0.x,texture0.y,varTex01.z,varTex01.w);
varTex01=vec4(varTex01.x,varTex01.y,texture1.x,texture1.y);
varScreenPos=l9_5;
vec2 l9_10=((l9_5.xy/vec2(l9_5.w))*0.5)+vec2(0.5);
vec2 l9_11;
#if (sc_StereoRenderingMode==1)
{
vec3 l9_12=vec3(l9_10,0.0);
l9_12.y=((2.0*l9_10.y)+float(sc_GetStereoViewIndex()))-1.0;
l9_11=l9_12.xy;
}
#else
{
l9_11=l9_10;
}
#endif
varScreenTexturePos=l9_11;
vec4 l9_13=l9_5*1.0;
vec4 l9_14;
#if (sc_ShaderCacheConstant!=0)
{
vec4 l9_15=l9_13;
l9_15.x=l9_13.x+(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
l9_14=l9_15;
}
#else
{
l9_14=l9_13;
}
#endif
#if (sc_StereoRenderingMode>0)
{
varStereoViewID=sc_StereoViewID;
}
#endif
#if (sc_StereoRenderingMode==1)
{
float l9_16=dot(l9_14,sc_StereoClipPlanes[sc_StereoViewID]);
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(l9_16);
}
#else
{
varClipDistance=l9_16;
}
#endif
}
#endif
gl_Position=l9_14;
varPassIdDecorThickness.x=passIdentifierAttr;
varSdfParams.w=sdfOffsetAttr;
varPassIdDecorThickness.y=decorThicknessRatioAttr;
varGlyphAtlasUvRect=glyphAtlasUvRectAttr;
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
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef colorTextureHasSwappedViews
#define colorTextureHasSwappedViews 0
#elif colorTextureHasSwappedViews==1
#undef colorTextureHasSwappedViews
#define colorTextureHasSwappedViews 1
#endif
#ifndef mainFillTextureHasSwappedViews
#define mainFillTextureHasSwappedViews 0
#elif mainFillTextureHasSwappedViews==1
#undef mainFillTextureHasSwappedViews
#define mainFillTextureHasSwappedViews 1
#endif
#ifndef shadowFillTextureHasSwappedViews
#define shadowFillTextureHasSwappedViews 0
#elif shadowFillTextureHasSwappedViews==1
#undef shadowFillTextureHasSwappedViews
#define shadowFillTextureHasSwappedViews 1
#endif
#ifndef outlineFillTextureHasSwappedViews
#define outlineFillTextureHasSwappedViews 0
#elif outlineFillTextureHasSwappedViews==1
#undef outlineFillTextureHasSwappedViews
#define outlineFillTextureHasSwappedViews 1
#endif
#ifndef backgroundFillTextureHasSwappedViews
#define backgroundFillTextureHasSwappedViews 0
#elif backgroundFillTextureHasSwappedViews==1
#undef backgroundFillTextureHasSwappedViews
#define backgroundFillTextureHasSwappedViews 1
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
#ifndef ENABLE_SDF
#define ENABLE_SDF 0
#elif ENABLE_SDF==1
#undef ENABLE_SDF
#define ENABLE_SDF 1
#endif
#ifndef MAIN_FILL_COLOR
#define MAIN_FILL_COLOR 0
#elif MAIN_FILL_COLOR==1
#undef MAIN_FILL_COLOR
#define MAIN_FILL_COLOR 1
#endif
#ifndef MAIN_FILL_TEXTURE
#define MAIN_FILL_TEXTURE 0
#elif MAIN_FILL_TEXTURE==1
#undef MAIN_FILL_TEXTURE
#define MAIN_FILL_TEXTURE 1
#endif
#ifndef mainFillTextureLayout
#define mainFillTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_mainFillTexture
#define SC_USE_UV_TRANSFORM_mainFillTexture 0
#elif SC_USE_UV_TRANSFORM_mainFillTexture==1
#undef SC_USE_UV_TRANSFORM_mainFillTexture
#define SC_USE_UV_TRANSFORM_mainFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_mainFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_mainFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_mainFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_mainFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_mainFillTexture
#define SC_USE_UV_MIN_MAX_mainFillTexture 0
#elif SC_USE_UV_MIN_MAX_mainFillTexture==1
#undef SC_USE_UV_MIN_MAX_mainFillTexture
#define SC_USE_UV_MIN_MAX_mainFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_mainFillTexture
#define SC_USE_CLAMP_TO_BORDER_mainFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_mainFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_mainFillTexture
#define SC_USE_CLAMP_TO_BORDER_mainFillTexture 1
#endif
#ifndef ENABLE_SHADOW
#define ENABLE_SHADOW 0
#elif ENABLE_SHADOW==1
#undef ENABLE_SHADOW
#define ENABLE_SHADOW 1
#endif
#ifndef ENABLE_OUTLINE
#define ENABLE_OUTLINE 0
#elif ENABLE_OUTLINE==1
#undef ENABLE_OUTLINE
#define ENABLE_OUTLINE 1
#endif
#ifndef SHADOW_FILL_COLOR
#define SHADOW_FILL_COLOR 0
#elif SHADOW_FILL_COLOR==1
#undef SHADOW_FILL_COLOR
#define SHADOW_FILL_COLOR 1
#endif
#ifndef SHADOW_FILL_TEXTURE
#define SHADOW_FILL_TEXTURE 0
#elif SHADOW_FILL_TEXTURE==1
#undef SHADOW_FILL_TEXTURE
#define SHADOW_FILL_TEXTURE 1
#endif
#ifndef shadowFillTextureLayout
#define shadowFillTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_shadowFillTexture
#define SC_USE_UV_TRANSFORM_shadowFillTexture 0
#elif SC_USE_UV_TRANSFORM_shadowFillTexture==1
#undef SC_USE_UV_TRANSFORM_shadowFillTexture
#define SC_USE_UV_TRANSFORM_shadowFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_shadowFillTexture
#define SC_USE_UV_MIN_MAX_shadowFillTexture 0
#elif SC_USE_UV_MIN_MAX_shadowFillTexture==1
#undef SC_USE_UV_MIN_MAX_shadowFillTexture
#define SC_USE_UV_MIN_MAX_shadowFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_shadowFillTexture
#define SC_USE_CLAMP_TO_BORDER_shadowFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_shadowFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_shadowFillTexture
#define SC_USE_CLAMP_TO_BORDER_shadowFillTexture 1
#endif
#ifndef OUTLINE_FILL_COLOR
#define OUTLINE_FILL_COLOR 0
#elif OUTLINE_FILL_COLOR==1
#undef OUTLINE_FILL_COLOR
#define OUTLINE_FILL_COLOR 1
#endif
#ifndef OUTLINE_FILL_TEXTURE
#define OUTLINE_FILL_TEXTURE 0
#elif OUTLINE_FILL_TEXTURE==1
#undef OUTLINE_FILL_TEXTURE
#define OUTLINE_FILL_TEXTURE 1
#endif
#ifndef outlineFillTextureLayout
#define outlineFillTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_outlineFillTexture
#define SC_USE_UV_TRANSFORM_outlineFillTexture 0
#elif SC_USE_UV_TRANSFORM_outlineFillTexture==1
#undef SC_USE_UV_TRANSFORM_outlineFillTexture
#define SC_USE_UV_TRANSFORM_outlineFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_outlineFillTexture
#define SC_USE_UV_MIN_MAX_outlineFillTexture 0
#elif SC_USE_UV_MIN_MAX_outlineFillTexture==1
#undef SC_USE_UV_MIN_MAX_outlineFillTexture
#define SC_USE_UV_MIN_MAX_outlineFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_outlineFillTexture
#define SC_USE_CLAMP_TO_BORDER_outlineFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_outlineFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_outlineFillTexture
#define SC_USE_CLAMP_TO_BORDER_outlineFillTexture 1
#endif
#ifndef ENABLE_BACKGROUND
#define ENABLE_BACKGROUND 0
#elif ENABLE_BACKGROUND==1
#undef ENABLE_BACKGROUND
#define ENABLE_BACKGROUND 1
#endif
#ifndef BACKGROUND_FILL_COLOR
#define BACKGROUND_FILL_COLOR 0
#elif BACKGROUND_FILL_COLOR==1
#undef BACKGROUND_FILL_COLOR
#define BACKGROUND_FILL_COLOR 1
#endif
#ifndef BACKGROUND_FILL_TEXTURE
#define BACKGROUND_FILL_TEXTURE 0
#elif BACKGROUND_FILL_TEXTURE==1
#undef BACKGROUND_FILL_TEXTURE
#define BACKGROUND_FILL_TEXTURE 1
#endif
#ifndef backgroundFillTextureLayout
#define backgroundFillTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_backgroundFillTexture
#define SC_USE_UV_TRANSFORM_backgroundFillTexture 0
#elif SC_USE_UV_TRANSFORM_backgroundFillTexture==1
#undef SC_USE_UV_TRANSFORM_backgroundFillTexture
#define SC_USE_UV_TRANSFORM_backgroundFillTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture
#define SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture
#define SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_backgroundFillTexture
#define SC_USE_UV_MIN_MAX_backgroundFillTexture 0
#elif SC_USE_UV_MIN_MAX_backgroundFillTexture==1
#undef SC_USE_UV_MIN_MAX_backgroundFillTexture
#define SC_USE_UV_MIN_MAX_backgroundFillTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_backgroundFillTexture
#define SC_USE_CLAMP_TO_BORDER_backgroundFillTexture 0
#elif SC_USE_CLAMP_TO_BORDER_backgroundFillTexture==1
#undef SC_USE_CLAMP_TO_BORDER_backgroundFillTexture
#define SC_USE_CLAMP_TO_BORDER_backgroundFillTexture 1
#endif
#ifndef colorTextureLayout
#define colorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_colorTexture
#define SC_USE_UV_TRANSFORM_colorTexture 0
#elif SC_USE_UV_TRANSFORM_colorTexture==1
#undef SC_USE_UV_TRANSFORM_colorTexture
#define SC_USE_UV_TRANSFORM_colorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_colorTexture
#define SC_SOFTWARE_WRAP_MODE_U_colorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_colorTexture
#define SC_SOFTWARE_WRAP_MODE_V_colorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_colorTexture
#define SC_USE_UV_MIN_MAX_colorTexture 0
#elif SC_USE_UV_MIN_MAX_colorTexture==1
#undef SC_USE_UV_MIN_MAX_colorTexture
#define SC_USE_UV_MIN_MAX_colorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_colorTexture
#define SC_USE_CLAMP_TO_BORDER_colorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_colorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_colorTexture
#define SC_USE_CLAMP_TO_BORDER_colorTexture 1
#endif
uniform vec4 sc_UniformConstants;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform float backgroundCornerRadius;
uniform vec4 mainColor;
uniform mat3 mainFillTextureTransform;
uniform vec4 mainFillTextureUvMinMax;
uniform vec4 mainFillTextureBorderColor;
uniform vec4 mainFillColorTint;
uniform vec4 shadowColor;
uniform mat3 shadowFillTextureTransform;
uniform vec4 shadowFillTextureUvMinMax;
uniform vec4 shadowFillTextureBorderColor;
uniform vec4 shadowFillColorTint;
uniform vec4 outlineColor;
uniform mat3 outlineFillTextureTransform;
uniform vec4 outlineFillTextureUvMinMax;
uniform vec4 outlineFillTextureBorderColor;
uniform vec4 outlineFillColorTint;
uniform vec2 backgroundSize;
uniform vec4 backgroundColor;
uniform mat3 backgroundFillTextureTransform;
uniform vec4 backgroundFillTextureUvMinMax;
uniform vec4 backgroundFillTextureBorderColor;
uniform vec4 backgroundFillColorTint;
uniform mat3 colorTextureTransform;
uniform vec4 colorTextureUvMinMax;
uniform vec4 colorTextureBorderColor;
uniform mediump sampler2DArray mainTextureArrSC;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2DArray mainFillTextureArrSC;
uniform mediump sampler2D mainFillTexture;
uniform mediump sampler2DArray shadowFillTextureArrSC;
uniform mediump sampler2D shadowFillTexture;
uniform mediump sampler2DArray outlineFillTextureArrSC;
uniform mediump sampler2D outlineFillTexture;
uniform mediump sampler2DArray backgroundFillTextureArrSC;
uniform mediump sampler2D backgroundFillTexture;
uniform mediump sampler2DArray colorTextureArrSC;
uniform mediump sampler2D colorTexture;
flat in int varStereoViewID;
in float varClipDistance;
layout(location=0) out vec4 sc_FragData0;
in vec4 varSdfParams;
in vec4 varTex01;
in vec4 varGlyphAtlasUvRect;
in vec2 varPassIdDecorThickness;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in vec4 varTangent;
in vec4 varScreenPos;
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
float calculateSdfOpacityMultisampled(float dist,float multisampleBlend)
{
float l9_0=dist;
float l9_1=clamp((l9_0*varSdfParams.y)-varSdfParams.z,0.0,1.0);
float l9_2;
if (multisampleBlend>0.0)
{
vec2 l9_3=dFdx(varTex01.xy);
vec2 l9_4=dFdy(varTex01.xy);
vec2 l9_5=(l9_3+l9_4)*0.35355338;
vec4 l9_6=vec4(clamp(varTex01.xy-l9_5,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw),clamp(varTex01.xy+l9_5,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw));
vec4 l9_7;
#if (mainTextureLayout==2)
{
l9_7=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_7=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
vec4 l9_8;
#if (mainTextureLayout==2)
{
l9_8=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_8=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
vec4 l9_9;
#if (mainTextureLayout==2)
{
l9_9=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_9=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
vec4 l9_10;
#if (mainTextureLayout==2)
{
l9_10=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_10=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_6.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
l9_2=mix(l9_1,((((l9_1+clamp((l9_7.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((l9_8.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((l9_9.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))+clamp((l9_10.x*varSdfParams.y)-varSdfParams.z,0.0,1.0))*0.2,multisampleBlend);
}
else
{
l9_2=l9_1;
}
return l9_2;
}
int mainFillTextureGetStereoViewIndex()
{
int l9_0;
#if (mainFillTextureHasSwappedViews)
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
float calculateSdfOpacityMultisampledOutline(float dist,float sdfEdge,float multisampleBlend)
{
float l9_0=dist;
float l9_1=sdfEdge;
float l9_2=clamp(((l9_0-l9_1)*varSdfParams.y)+0.5,0.0,1.0);
float l9_3;
if (multisampleBlend>0.0)
{
vec2 l9_4=dFdx(varTex01.xy);
vec2 l9_5=dFdy(varTex01.xy);
vec2 l9_6=(l9_4+l9_5)*0.35355338;
vec4 l9_7=vec4(clamp(varTex01.xy-l9_6,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw),clamp(varTex01.xy+l9_6,varGlyphAtlasUvRect.xy,varGlyphAtlasUvRect.zw));
vec4 l9_8;
#if (mainTextureLayout==2)
{
l9_8=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_8=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.xw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
float l9_9=sdfEdge;
vec4 l9_10;
#if (mainTextureLayout==2)
{
l9_10=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_10=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
float l9_11=sdfEdge;
vec4 l9_12;
#if (mainTextureLayout==2)
{
l9_12=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_12=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.zy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
float l9_13=sdfEdge;
vec4 l9_14;
#if (mainTextureLayout==2)
{
l9_14=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_14=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),l9_7.zw,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
l9_3=mix(l9_2,((((l9_2+clamp(((l9_8.x-l9_9)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((l9_10.x-l9_11)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((l9_12.x-l9_13)*varSdfParams.y)+0.5,0.0,1.0))+clamp(((l9_14.x-sdfEdge)*varSdfParams.y)+0.5,0.0,1.0))*0.2,multisampleBlend);
}
else
{
l9_3=l9_2;
}
return l9_3;
}
int shadowFillTextureGetStereoViewIndex()
{
int l9_0;
#if (shadowFillTextureHasSwappedViews)
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
int outlineFillTextureGetStereoViewIndex()
{
int l9_0;
#if (outlineFillTextureHasSwappedViews)
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
float getCornerFade(vec2 corner)
{
if (length(abs(corner-varTex01.xy))>backgroundCornerRadius)
{
return 1.0;
}
float l9_0=corner.x;
float l9_1=corner.y;
float l9_2=length(abs(abs(vec2(l9_0-backgroundCornerRadius,l9_1-backgroundCornerRadius))-varTex01.xy))/backgroundCornerRadius;
if (l9_2<0.98000002)
{
return 1.0;
}
if (l9_2>1.0)
{
return 0.0;
}
return smoothstep(1.0,0.98000002,l9_2);
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
int backgroundFillTextureGetStereoViewIndex()
{
int l9_0;
#if (backgroundFillTextureHasSwappedViews)
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
int colorTextureGetStereoViewIndex()
{
int l9_0;
#if (colorTextureHasSwappedViews)
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
void main()
{
#if (sc_MotionVectorsPass)
{
discard;
}
#endif
#if ((sc_StereoRenderingMode==1)&&(sc_StereoRendering_IsClipDistanceEnabled==0))
{
if (varClipDistance<0.0)
{
discard;
}
}
#endif
vec2 l9_0=vec2(fract(varTex01.z),fract(varTex01.w));
int l9_1=int(varPassIdDecorThickness.x+0.5);
bool l9_2=l9_1==1;
vec4 l9_3;
float l9_4;
if ((l9_1==0)||l9_2)
{
float l9_5;
#if (ENABLE_SDF)
{
vec4 l9_6;
#if (mainTextureLayout==2)
{
l9_6=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_6=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
l9_5=calculateSdfOpacityMultisampled(l9_6.x,varSdfParams.x);
}
#else
{
l9_5=0.0;
}
#endif
vec4 l9_7;
#if (MAIN_FILL_COLOR)
{
l9_7=mainColor;
}
#else
{
vec4 l9_8;
#if (MAIN_FILL_TEXTURE)
{
vec4 l9_9;
#if (mainFillTextureLayout==2)
{
l9_9=sc_SampleTextureBias(mainFillTextureLayout,mainFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTextureArrSC);
}
#else
{
l9_9=sc_SampleTextureBias(mainFillTextureLayout,mainFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTexture);
}
#endif
l9_8=l9_9*mainFillColorTint;
}
#else
{
l9_8=vec4(1.0);
}
#endif
l9_7=l9_8;
}
#endif
l9_4=l9_5;
l9_3=l9_7;
}
else
{
l9_4=0.0;
l9_3=vec4(1.0);
}
vec4 l9_10;
float l9_11;
#if (ENABLE_SHADOW)
{
vec4 l9_12;
float l9_13;
if (l9_1==2)
{
float l9_14;
#if (ENABLE_SDF)
{
vec4 l9_15;
#if (mainTextureLayout==2)
{
l9_15=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_15=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
float l9_16;
#if (ENABLE_OUTLINE)
{
l9_16=calculateSdfOpacityMultisampledOutline(l9_15.x,0.5-varSdfParams.w,varSdfParams.x);
}
#else
{
l9_16=calculateSdfOpacityMultisampled(l9_15.x,varSdfParams.x);
}
#endif
l9_14=l9_16;
}
#else
{
l9_14=l9_4;
}
#endif
vec4 l9_17;
#if (SHADOW_FILL_COLOR)
{
l9_17=shadowColor;
}
#else
{
vec4 l9_18;
#if (SHADOW_FILL_TEXTURE)
{
vec4 l9_19;
#if (shadowFillTextureLayout==2)
{
l9_19=sc_SampleTextureBias(shadowFillTextureLayout,shadowFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTextureArrSC);
}
#else
{
l9_19=sc_SampleTextureBias(shadowFillTextureLayout,shadowFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTexture);
}
#endif
l9_18=l9_19*shadowFillColorTint;
}
#else
{
l9_18=l9_3;
}
#endif
l9_17=l9_18;
}
#endif
l9_13=l9_14;
l9_12=l9_17;
}
else
{
l9_13=l9_4;
l9_12=l9_3;
}
l9_11=l9_13;
l9_10=l9_12;
}
#else
{
l9_11=l9_4;
l9_10=l9_3;
}
#endif
vec4 l9_20;
float l9_21;
#if (ENABLE_OUTLINE)
{
vec4 l9_22;
float l9_23;
if (l9_1==3)
{
float l9_24;
#if (ENABLE_SDF)
{
vec4 l9_25;
#if (mainTextureLayout==2)
{
l9_25=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTextureArrSC);
}
#else
{
l9_25=sc_SampleTextureBias(mainTextureLayout,mainTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#endif
l9_24=calculateSdfOpacityMultisampledOutline(l9_25.x,0.5-varSdfParams.w,varSdfParams.x);
}
#else
{
l9_24=l9_11;
}
#endif
vec4 l9_26;
#if (OUTLINE_FILL_COLOR)
{
l9_26=outlineColor;
}
#else
{
vec4 l9_27;
#if (OUTLINE_FILL_TEXTURE)
{
vec4 l9_28;
#if (outlineFillTextureLayout==2)
{
l9_28=sc_SampleTextureBias(outlineFillTextureLayout,outlineFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTextureArrSC);
}
#else
{
l9_28=sc_SampleTextureBias(outlineFillTextureLayout,outlineFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTexture);
}
#endif
l9_27=l9_28*outlineFillColorTint;
}
#else
{
l9_27=l9_10;
}
#endif
l9_26=l9_27;
}
#endif
l9_23=l9_24;
l9_22=l9_26;
}
else
{
l9_23=l9_11;
l9_22=l9_10;
}
l9_21=l9_23;
l9_20=l9_22;
}
#else
{
l9_21=l9_11;
l9_20=l9_10;
}
#endif
#if (ENABLE_BACKGROUND)
{
if (l9_1==4)
{
float l9_29=getCornerFade(vec2(0.0));
float l9_30=getCornerFade(vec2(backgroundSize.x,0.0));
float l9_31=getCornerFade(vec2(backgroundSize.x,backgroundSize.y));
float l9_32=getCornerFade(vec2(0.0,backgroundSize.y));
float l9_33=(((1.0*l9_29)*l9_30)*l9_31)*l9_32;
if (l9_33<0.0049999999)
{
discard;
}
#if (BACKGROUND_FILL_COLOR)
{
float l9_34=backgroundColor.w*l9_33;
sc_writeFragData0(vec4(backgroundColor.xyz*l9_34,l9_34));
}
#else
{
#if (BACKGROUND_FILL_TEXTURE)
{
vec4 l9_35;
#if (backgroundFillTextureLayout==2)
{
l9_35=sc_SampleTextureBias(backgroundFillTextureLayout,backgroundFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_backgroundFillTexture)!=0),backgroundFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture,SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture),(int(SC_USE_UV_MIN_MAX_backgroundFillTexture)!=0),backgroundFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_backgroundFillTexture)!=0),backgroundFillTextureBorderColor,0.0,backgroundFillTextureArrSC);
}
#else
{
l9_35=sc_SampleTextureBias(backgroundFillTextureLayout,backgroundFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_backgroundFillTexture)!=0),backgroundFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_backgroundFillTexture,SC_SOFTWARE_WRAP_MODE_V_backgroundFillTexture),(int(SC_USE_UV_MIN_MAX_backgroundFillTexture)!=0),backgroundFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_backgroundFillTexture)!=0),backgroundFillTextureBorderColor,0.0,backgroundFillTexture);
}
#endif
vec4 l9_36=l9_35*backgroundFillColorTint;
float l9_37=l9_36.w*l9_33;
sc_writeFragData0(vec4(l9_36.xyz*l9_37,l9_37));
}
#endif
}
#endif
return;
}
}
#endif
bool l9_38=l9_1==6;
bool l9_39=l9_1==7;
if (((l9_1==5)||l9_38)||l9_39)
{
vec4 l9_40;
if (l9_38)
{
vec4 l9_41;
#if (OUTLINE_FILL_COLOR)
{
l9_41=outlineColor;
}
#else
{
vec4 l9_42;
#if (OUTLINE_FILL_TEXTURE)
{
vec4 l9_43;
#if (outlineFillTextureLayout==2)
{
l9_43=sc_SampleTextureBias(outlineFillTextureLayout,outlineFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTextureArrSC);
}
#else
{
l9_43=sc_SampleTextureBias(outlineFillTextureLayout,outlineFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_outlineFillTexture)!=0),outlineFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_outlineFillTexture,SC_SOFTWARE_WRAP_MODE_V_outlineFillTexture),(int(SC_USE_UV_MIN_MAX_outlineFillTexture)!=0),outlineFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_outlineFillTexture)!=0),outlineFillTextureBorderColor,0.0,outlineFillTexture);
}
#endif
l9_42=l9_43*outlineFillColorTint;
}
#else
{
l9_42=l9_20;
}
#endif
l9_41=l9_42;
}
#endif
l9_40=l9_41;
}
else
{
vec4 l9_44;
if (l9_39)
{
vec4 l9_45;
#if (SHADOW_FILL_COLOR)
{
l9_45=shadowColor;
}
#else
{
vec4 l9_46;
#if (SHADOW_FILL_TEXTURE)
{
vec4 l9_47;
#if (shadowFillTextureLayout==2)
{
l9_47=sc_SampleTextureBias(shadowFillTextureLayout,shadowFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTextureArrSC);
}
#else
{
l9_47=sc_SampleTextureBias(shadowFillTextureLayout,shadowFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_shadowFillTexture)!=0),shadowFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_shadowFillTexture,SC_SOFTWARE_WRAP_MODE_V_shadowFillTexture),(int(SC_USE_UV_MIN_MAX_shadowFillTexture)!=0),shadowFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_shadowFillTexture)!=0),shadowFillTextureBorderColor,0.0,shadowFillTexture);
}
#endif
l9_46=l9_47*shadowFillColorTint;
}
#else
{
l9_46=l9_20;
}
#endif
l9_45=l9_46;
}
#endif
l9_44=l9_45;
}
else
{
vec4 l9_48;
#if (MAIN_FILL_COLOR)
{
l9_48=mainColor;
}
#else
{
vec4 l9_49;
#if (MAIN_FILL_TEXTURE)
{
vec4 l9_50;
#if (mainFillTextureLayout==2)
{
l9_50=sc_SampleTextureBias(mainFillTextureLayout,mainFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTextureArrSC);
}
#else
{
l9_50=sc_SampleTextureBias(mainFillTextureLayout,mainFillTextureGetStereoViewIndex(),l9_0,(int(SC_USE_UV_TRANSFORM_mainFillTexture)!=0),mainFillTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainFillTexture,SC_SOFTWARE_WRAP_MODE_V_mainFillTexture),(int(SC_USE_UV_MIN_MAX_mainFillTexture)!=0),mainFillTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainFillTexture)!=0),mainFillTextureBorderColor,0.0,mainFillTexture);
}
#endif
l9_49=l9_50*mainFillColorTint;
}
#else
{
l9_49=l9_20;
}
#endif
l9_48=l9_49;
}
#endif
l9_44=l9_48;
}
l9_40=l9_44;
}
float l9_51=abs(varTex01.y);
float l9_52=dFdy(varTex01.y);
float l9_53;
if (l9_51>varPassIdDecorThickness.y)
{
l9_53=l9_40.w*smoothstep(varPassIdDecorThickness.y+(abs(l9_52)*0.5),varPassIdDecorThickness.y,l9_51);
}
else
{
l9_53=l9_40.w;
}
if (l9_53<0.0099999998)
{
discard;
}
sc_writeFragData0(vec4(l9_40.xyz*l9_53,l9_53));
return;
}
if (l9_2)
{
vec4 l9_54;
#if (colorTextureLayout==2)
{
l9_54=sc_SampleTextureBias(colorTextureLayout,colorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_colorTexture)!=0),colorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_colorTexture,SC_SOFTWARE_WRAP_MODE_V_colorTexture),(int(SC_USE_UV_MIN_MAX_colorTexture)!=0),colorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_colorTexture)!=0),colorTextureBorderColor,0.0,colorTextureArrSC);
}
#else
{
l9_54=sc_SampleTextureBias(colorTextureLayout,colorTextureGetStereoViewIndex(),varTex01.xy,(int(SC_USE_UV_TRANSFORM_colorTexture)!=0),colorTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_colorTexture,SC_SOFTWARE_WRAP_MODE_V_colorTexture),(int(SC_USE_UV_MIN_MAX_colorTexture)!=0),colorTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_colorTexture)!=0),colorTextureBorderColor,0.0,colorTexture);
}
#endif
float l9_55=l9_54.w*l9_20.w;
sc_writeFragData0(vec4(l9_54.xyz*l9_55,l9_55));
}
else
{
#if (ENABLE_SDF)
{
float l9_56=l9_20.w*l9_21;
sc_writeFragData0(vec4(l9_20.xyz*l9_56,l9_56));
}
#else
{
vec4 l9_57;
#if (mainTextureLayout==2)
{
bool l9_58=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_mainTexture)!=0));
float l9_59=varTex01.x;
sc_SoftwareWrapEarly(l9_59,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x);
float l9_60=l9_59;
float l9_61=varTex01.y;
sc_SoftwareWrapEarly(l9_61,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y);
float l9_62=l9_61;
vec2 l9_63;
float l9_64;
#if (SC_USE_UV_MIN_MAX_mainTexture)
{
bool l9_65;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_65=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x==3;
}
#else
{
l9_65=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_66=l9_60;
float l9_67=1.0;
sc_ClampUV(l9_66,mainTextureUvMinMax.x,mainTextureUvMinMax.z,l9_65,l9_67);
float l9_68=l9_66;
float l9_69=l9_67;
bool l9_70;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_70=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y==3;
}
#else
{
l9_70=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_71=l9_62;
float l9_72=l9_69;
sc_ClampUV(l9_71,mainTextureUvMinMax.y,mainTextureUvMinMax.w,l9_70,l9_72);
l9_64=l9_72;
l9_63=vec2(l9_68,l9_71);
}
#else
{
l9_64=1.0;
l9_63=vec2(l9_60,l9_62);
}
#endif
vec2 l9_73=sc_TransformUV(l9_63,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform);
float l9_74=l9_73.x;
float l9_75=l9_64;
sc_SoftwareWrapLate(l9_74,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x,l9_58,l9_75);
float l9_76=l9_73.y;
float l9_77=l9_75;
sc_SoftwareWrapLate(l9_76,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y,l9_58,l9_77);
float l9_78=l9_77;
vec3 l9_79=sc_SamplingCoordsViewToGlobal(vec2(l9_74,l9_76),mainTextureLayout,mainTextureGetStereoViewIndex());
vec4 l9_80=textureLod(mainTextureArrSC,l9_79,0.0);
vec4 l9_81;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_81=mix(mainTextureBorderColor,l9_80,vec4(l9_78));
}
#else
{
l9_81=l9_80;
}
#endif
l9_57=l9_81;
}
#else
{
bool l9_82=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_mainTexture)!=0));
float l9_83=varTex01.x;
sc_SoftwareWrapEarly(l9_83,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x);
float l9_84=l9_83;
float l9_85=varTex01.y;
sc_SoftwareWrapEarly(l9_85,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y);
float l9_86=l9_85;
vec2 l9_87;
float l9_88;
#if (SC_USE_UV_MIN_MAX_mainTexture)
{
bool l9_89;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_89=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x==3;
}
#else
{
l9_89=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_90=l9_84;
float l9_91=1.0;
sc_ClampUV(l9_90,mainTextureUvMinMax.x,mainTextureUvMinMax.z,l9_89,l9_91);
float l9_92=l9_90;
float l9_93=l9_91;
bool l9_94;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_94=ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y==3;
}
#else
{
l9_94=(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0);
}
#endif
float l9_95=l9_86;
float l9_96=l9_93;
sc_ClampUV(l9_95,mainTextureUvMinMax.y,mainTextureUvMinMax.w,l9_94,l9_96);
l9_88=l9_96;
l9_87=vec2(l9_92,l9_95);
}
#else
{
l9_88=1.0;
l9_87=vec2(l9_84,l9_86);
}
#endif
vec2 l9_97=sc_TransformUV(l9_87,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform);
float l9_98=l9_97.x;
float l9_99=l9_88;
sc_SoftwareWrapLate(l9_98,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).x,l9_82,l9_99);
float l9_100=l9_97.y;
float l9_101=l9_99;
sc_SoftwareWrapLate(l9_100,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture).y,l9_82,l9_101);
float l9_102=l9_101;
vec3 l9_103=sc_SamplingCoordsViewToGlobal(vec2(l9_98,l9_100),mainTextureLayout,mainTextureGetStereoViewIndex());
vec4 l9_104=textureLod(mainTexture,l9_103.xy,0.0);
vec4 l9_105;
#if (SC_USE_CLAMP_TO_BORDER_mainTexture)
{
l9_105=mix(mainTextureBorderColor,l9_104,vec4(l9_102));
}
#else
{
l9_105=l9_104;
}
#endif
l9_57=l9_105;
}
#endif
float l9_106=l9_57.x*l9_20.w;
sc_writeFragData0(vec4(l9_20.xyz*l9_106,l9_106));
}
#endif
}
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
