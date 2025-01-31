#pragma clang diagnostic ignored "-Wmissing-prototypes"
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
#include "required2.metal"
#include "std2_vs.metal"
#include "std2_fs.metal"
#include "std2_texture.metal"
#include "std2_taa.metal"
//SG_REFLECTION_BEGIN(100)
//sampler sampler sc_TAAColorTextureSmpSC 2:4
//sampler sampler sc_TAAHistoryTextureSmpSC 2:6
//sampler sampler sc_TAAMotionVectorTextureSmpSC 2:7
//texture texture2D sc_TAAColorTexture 2:0:2:4
//texture texture2D sc_TAAHistoryTexture 2:2:2:6
//texture texture2D sc_TAAMotionVectorTexture 2:3:2:7
//ubo float UserUniforms 2:8:528 {
//float4 sc_TAAColorTextureSize 0
//float4 sc_TAAColorTextureDims 16
//float4 sc_TAAColorTextureView 32
//float3x3 sc_TAAColorTextureTransform 48
//float4 sc_TAAColorTextureUvMinMax 96
//float4 sc_TAAColorTextureBorderColor 112
//float4 sc_TAAHistoryTextureSize 128
//float4 sc_TAAHistoryTextureDims 144
//float4 sc_TAAHistoryTextureView 160
//float3x3 sc_TAAHistoryTextureTransform 176
//float4 sc_TAAHistoryTextureUvMinMax 224
//float4 sc_TAAHistoryTextureBorderColor 240
//float4 sc_TAADepthTextureSize 256
//float4 sc_TAADepthTextureDims 272
//float4 sc_TAADepthTextureView 288
//float3x3 sc_TAADepthTextureTransform 304
//float4 sc_TAADepthTextureUvMinMax 352
//float4 sc_TAADepthTextureBorderColor 368
//float4 sc_TAAMotionVectorTextureSize 384
//float4 sc_TAAMotionVectorTextureDims 400
//float4 sc_TAAMotionVectorTextureView 416
//float3x3 sc_TAAMotionVectorTextureTransform 432
//float4 sc_TAAMotionVectorTextureUvMinMax 480
//float4 sc_TAAMotionVectorTextureBorderColor 496
//float currentFrameWeight 512
//}
//SG_REFLECTION_END

namespace SNAP_VS {
struct userUniformsObj
{
float4 sc_TAAColorTextureSize;
float4 sc_TAAColorTextureDims;
float4 sc_TAAColorTextureView;
float3x3 sc_TAAColorTextureTransform;
float4 sc_TAAColorTextureUvMinMax;
float4 sc_TAAColorTextureBorderColor;
float4 sc_TAAHistoryTextureSize;
float4 sc_TAAHistoryTextureDims;
float4 sc_TAAHistoryTextureView;
float3x3 sc_TAAHistoryTextureTransform;
float4 sc_TAAHistoryTextureUvMinMax;
float4 sc_TAAHistoryTextureBorderColor;
float4 sc_TAADepthTextureSize;
float4 sc_TAADepthTextureDims;
float4 sc_TAADepthTextureView;
float3x3 sc_TAADepthTextureTransform;
float4 sc_TAADepthTextureUvMinMax;
float4 sc_TAADepthTextureBorderColor;
float4 sc_TAAMotionVectorTextureSize;
float4 sc_TAAMotionVectorTextureDims;
float4 sc_TAAMotionVectorTextureView;
float3x3 sc_TAAMotionVectorTextureTransform;
float4 sc_TAAMotionVectorTextureUvMinMax;
float4 sc_TAAMotionVectorTextureBorderColor;
float currentFrameWeight;
};
#ifndef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 0
#elif sc_TAAColorTextureHasSwappedViews==1
#undef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAColorTextureLayout
#define sc_TAAColorTextureLayout 0
#endif
#ifndef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 0
#elif sc_TAAHistoryTextureHasSwappedViews==1
#undef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 1
#endif
#ifndef sc_TAAHistoryTextureLayout
#define sc_TAAHistoryTextureLayout 0
#endif
#ifndef sc_TAADepthTextureHasSwappedViews
#define sc_TAADepthTextureHasSwappedViews 0
#elif sc_TAADepthTextureHasSwappedViews==1
#undef sc_TAADepthTextureHasSwappedViews
#define sc_TAADepthTextureHasSwappedViews 1
#endif
#ifndef sc_TAADepthTextureLayout
#define sc_TAADepthTextureLayout 0
#endif
#ifndef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 0
#elif sc_TAAMotionVectorTextureHasSwappedViews==1
#undef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAMotionVectorTextureLayout
#define sc_TAAMotionVectorTextureLayout 0
#endif
#ifndef sc_TAAColorTextureUV
#define sc_TAAColorTextureUV 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAColorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAColorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 1
#endif
#ifndef sc_TAAHistoryTextureUV
#define sc_TAAHistoryTextureUV 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 1
#endif
#ifndef sc_TAADepthTextureUV
#define sc_TAADepthTextureUV 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAADepthTexture
#define SC_USE_UV_TRANSFORM_sc_TAADepthTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAADepthTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAADepthTexture
#define SC_USE_UV_TRANSFORM_sc_TAADepthTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAADepthTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAADepthTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAADepthTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAADepthTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAADepthTexture
#define SC_USE_UV_MIN_MAX_sc_TAADepthTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAADepthTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAADepthTexture
#define SC_USE_UV_MIN_MAX_sc_TAADepthTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture 1
#endif
#ifndef sc_TAAMotionVectorTextureUV
#define sc_TAAMotionVectorTextureUV 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 1
#endif
struct sc_Set2
{
texture2d<float> sc_TAAColorTexture [[id(0)]];
texture2d<float> sc_TAAHistoryTexture [[id(2)]];
texture2d<float> sc_TAAMotionVectorTexture [[id(3)]];
sampler sc_TAAColorTextureSmpSC [[id(4)]];
sampler sc_TAAHistoryTextureSmpSC [[id(6)]];
sampler sc_TAAMotionVectorTextureSmpSC [[id(7)]];
constant userUniformsObj* UserUniforms [[id(8)]];
};
struct sc_VertOut
{
sc_SysOut sc_sysOut;
};
struct sc_VertIn
{
sc_SysAttributes sc_sysAttributes;
};
vertex sc_VertOut main_vert(sc_VertIn sc_vertIn [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]],uint gl_InstanceIndex [[instance_id]],uint gl_VertexIndex [[vertex_id]])
{
sc_SysIn sc_sysIn;
sc_sysIn.sc_sysAttributes=sc_vertIn.sc_sysAttributes;
sc_sysIn.gl_VertexIndex=gl_VertexIndex;
sc_sysIn.gl_InstanceIndex=gl_InstanceIndex;
sc_VertOut sc_vertOut={};
sc_Vertex_t v=sc_LoadVertexAttributes(sc_sysIn,sc_vertOut.sc_sysOut,sc_set0,sc_set1);
v.position=float4(sc_sysIn.sc_sysAttributes.position.xy,0.0,1.0);
float2 l9_0=(v.position.xy*0.5)+float2(0.5);
sc_vertOut.sc_sysOut.varPackedTex=float4(l9_0.x,l9_0.y,sc_vertOut.sc_sysOut.varPackedTex.z,sc_vertOut.sc_sysOut.varPackedTex.w);
sc_Vertex_t param=v;
sc_ProcessVertex(param,sc_sysIn,sc_vertOut.sc_sysOut,sc_set0,sc_set1);
return sc_vertOut;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct userUniformsObj
{
float4 sc_TAAColorTextureSize;
float4 sc_TAAColorTextureDims;
float4 sc_TAAColorTextureView;
float3x3 sc_TAAColorTextureTransform;
float4 sc_TAAColorTextureUvMinMax;
float4 sc_TAAColorTextureBorderColor;
float4 sc_TAAHistoryTextureSize;
float4 sc_TAAHistoryTextureDims;
float4 sc_TAAHistoryTextureView;
float3x3 sc_TAAHistoryTextureTransform;
float4 sc_TAAHistoryTextureUvMinMax;
float4 sc_TAAHistoryTextureBorderColor;
float4 sc_TAADepthTextureSize;
float4 sc_TAADepthTextureDims;
float4 sc_TAADepthTextureView;
float3x3 sc_TAADepthTextureTransform;
float4 sc_TAADepthTextureUvMinMax;
float4 sc_TAADepthTextureBorderColor;
float4 sc_TAAMotionVectorTextureSize;
float4 sc_TAAMotionVectorTextureDims;
float4 sc_TAAMotionVectorTextureView;
float3x3 sc_TAAMotionVectorTextureTransform;
float4 sc_TAAMotionVectorTextureUvMinMax;
float4 sc_TAAMotionVectorTextureBorderColor;
float currentFrameWeight;
};
#ifndef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 0
#elif sc_TAAColorTextureHasSwappedViews==1
#undef sc_TAAColorTextureHasSwappedViews
#define sc_TAAColorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAColorTextureLayout
#define sc_TAAColorTextureLayout 0
#endif
#ifndef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 0
#elif sc_TAAHistoryTextureHasSwappedViews==1
#undef sc_TAAHistoryTextureHasSwappedViews
#define sc_TAAHistoryTextureHasSwappedViews 1
#endif
#ifndef sc_TAAHistoryTextureLayout
#define sc_TAAHistoryTextureLayout 0
#endif
#ifndef sc_TAADepthTextureHasSwappedViews
#define sc_TAADepthTextureHasSwappedViews 0
#elif sc_TAADepthTextureHasSwappedViews==1
#undef sc_TAADepthTextureHasSwappedViews
#define sc_TAADepthTextureHasSwappedViews 1
#endif
#ifndef sc_TAADepthTextureLayout
#define sc_TAADepthTextureLayout 0
#endif
#ifndef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 0
#elif sc_TAAMotionVectorTextureHasSwappedViews==1
#undef sc_TAAMotionVectorTextureHasSwappedViews
#define sc_TAAMotionVectorTextureHasSwappedViews 1
#endif
#ifndef sc_TAAMotionVectorTextureLayout
#define sc_TAAMotionVectorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAColorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAColorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAColorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAColorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture
#define SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture
#define SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture
#define SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture
#define SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture 1
#endif
#ifndef sc_TAAColorTextureUV
#define sc_TAAColorTextureUV 0
#endif
#ifndef sc_TAAHistoryTextureUV
#define sc_TAAHistoryTextureUV 0
#endif
#ifndef sc_TAADepthTextureUV
#define sc_TAADepthTextureUV 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_TAADepthTexture
#define SC_USE_UV_TRANSFORM_sc_TAADepthTexture 0
#elif SC_USE_UV_TRANSFORM_sc_TAADepthTexture==1
#undef SC_USE_UV_TRANSFORM_sc_TAADepthTexture
#define SC_USE_UV_TRANSFORM_sc_TAADepthTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_TAADepthTexture
#define SC_SOFTWARE_WRAP_MODE_U_sc_TAADepthTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_TAADepthTexture
#define SC_SOFTWARE_WRAP_MODE_V_sc_TAADepthTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_TAADepthTexture
#define SC_USE_UV_MIN_MAX_sc_TAADepthTexture 0
#elif SC_USE_UV_MIN_MAX_sc_TAADepthTexture==1
#undef SC_USE_UV_MIN_MAX_sc_TAADepthTexture
#define SC_USE_UV_MIN_MAX_sc_TAADepthTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture
#define SC_USE_CLAMP_TO_BORDER_sc_TAADepthTexture 1
#endif
#ifndef sc_TAAMotionVectorTextureUV
#define sc_TAAMotionVectorTextureUV 0
#endif
struct sc_Set2
{
texture2d<float> sc_TAAColorTexture [[id(0)]];
texture2d<float> sc_TAAHistoryTexture [[id(2)]];
texture2d<float> sc_TAAMotionVectorTexture [[id(3)]];
sampler sc_TAAColorTextureSmpSC [[id(4)]];
sampler sc_TAAHistoryTextureSmpSC [[id(6)]];
sampler sc_TAAMotionVectorTextureSmpSC [[id(7)]];
constant userUniformsObj* UserUniforms [[id(8)]];
};
struct sc_FragOut
{
sc_SysOut sc_sysOut;
};
struct sc_FragIn
{
sc_SysIn sc_sysIn;
};
float2 sc_TAAColorTextureGetDims2D(constant userUniformsObj& UserUniforms)
{
return UserUniforms.sc_TAAColorTextureDims.xy;
}
int sc_TAAColorTextureGetStereoViewIndex(thread sc_SysIn& sc_sysIn,const constant sc_Set0& sc_set0,const constant sc_Set1& sc_set1)
{
int result=0;
#if (sc_TAAColorTextureHasSwappedViews)
{
result=1-sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#else
{
result=sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#endif
return result;
}
float2 sc_TAAMotionVectorTextureGetDims2D(constant userUniformsObj& UserUniforms)
{
return UserUniforms.sc_TAAMotionVectorTextureDims.xy;
}
int sc_TAAMotionVectorTextureGetStereoViewIndex(thread sc_SysIn& sc_sysIn,const constant sc_Set0& sc_set0,const constant sc_Set1& sc_set1)
{
int result=0;
#if (sc_TAAMotionVectorTextureHasSwappedViews)
{
result=1-sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#else
{
result=sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#endif
return result;
}
float2 sc_TAAHistoryTextureGetDims2D(constant userUniformsObj& UserUniforms)
{
return UserUniforms.sc_TAAHistoryTextureDims.xy;
}
int sc_TAAHistoryTextureGetStereoViewIndex(thread sc_SysIn& sc_sysIn,const constant sc_Set0& sc_set0,const constant sc_Set1& sc_set1)
{
int result=0;
#if (sc_TAAHistoryTextureHasSwappedViews)
{
result=1-sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#else
{
result=sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1);
}
#endif
return result;
}
fragment sc_FragOut main_frag(sc_FragIn sc_fragIn [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]],float4 gl_FragCoord [[position]],bool gl_FrontFacing [[front_facing]])
{
sc_fragIn.sc_sysIn.gl_FragCoord=gl_FragCoord;
sc_fragIn.sc_sysIn.gl_FrontFacing=gl_FrontFacing;
sc_FragOut sc_fragOut={};
float2 param=sc_TAAColorTextureGetDims2D((*sc_set2.UserUniforms));
int param_1=sc_TAAColorTextureLayout;
int param_2=sc_TAAColorTextureGetStereoViewIndex(sc_fragIn.sc_sysIn,sc_set0,sc_set1);
float2 param_3=sc_fragIn.sc_sysIn.varPackedTex.xy;
bool param_4=(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0);
float3x3 param_5=(*sc_set2.UserUniforms).sc_TAAColorTextureTransform;
int2 param_6=int2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture);
bool param_7=(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0);
float4 param_8=(*sc_set2.UserUniforms).sc_TAAColorTextureUvMinMax;
bool param_9=(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0);
float4 param_10=(*sc_set2.UserUniforms).sc_TAAColorTextureBorderColor;
float param_11=0.0;
float4 l9_0=sc_SampleTextureLevel(sc_set2.sc_TAAColorTexture,sc_set2.sc_TAAColorTextureSmpSC,param,param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,param_10,param_11);
float4 l9_1=l9_0;
float3 currentColor=l9_0.xyz;
float3 minColor=float3(9999.0);
float3 maxColor=float3(-9999.0);
int x=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (x<=1)
{
int y=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (y<=1)
{
float2 param_12=sc_TAAColorTextureGetDims2D((*sc_set2.UserUniforms));
int param_13=sc_TAAColorTextureLayout;
int param_14=sc_TAAColorTextureGetStereoViewIndex(sc_fragIn.sc_sysIn,sc_set0,sc_set1);
float2 param_15=sc_fragIn.sc_sysIn.varPackedTex.xy+(float2(float(x),float(y))*(*sc_set2.UserUniforms).sc_TAAColorTextureSize.zw);
bool param_16=(int(SC_USE_UV_TRANSFORM_sc_TAAColorTexture)!=0);
float3x3 param_17=(*sc_set2.UserUniforms).sc_TAAColorTextureTransform;
int2 param_18=int2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAColorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAColorTexture);
bool param_19=(int(SC_USE_UV_MIN_MAX_sc_TAAColorTexture)!=0);
float4 param_20=(*sc_set2.UserUniforms).sc_TAAColorTextureUvMinMax;
bool param_21=(int(SC_USE_CLAMP_TO_BORDER_sc_TAAColorTexture)!=0);
float4 param_22=(*sc_set2.UserUniforms).sc_TAAColorTextureBorderColor;
float param_23=0.0;
float4 l9_2=sc_SampleTextureLevel(sc_set2.sc_TAAColorTexture,sc_set2.sc_TAAColorTextureSmpSC,param_12,param_13,param_14,param_15,param_16,param_17,param_18,param_19,param_20,param_21,param_22,param_23);
float4 l9_3=l9_2;
float3 color=l9_2.xyz;
minColor=fast::min(minColor,color);
maxColor=fast::max(maxColor,color);
y++;
continue;
}
else
{
break;
}
}
x++;
continue;
}
else
{
break;
}
}
float background=0.0;
float maxSpeedSquared=0.0;
float2 velocity=float2(-1.0);
int x_1=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (x_1<=1)
{
int y_1=-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (y_1<=1)
{
float2 param_24=sc_TAAMotionVectorTextureGetDims2D((*sc_set2.UserUniforms));
int param_25=sc_TAAMotionVectorTextureLayout;
int param_26=sc_TAAMotionVectorTextureGetStereoViewIndex(sc_fragIn.sc_sysIn,sc_set0,sc_set1);
float2 param_27=sc_fragIn.sc_sysIn.varPackedTex.xy+(float2(float(x_1),float(y_1))*(*sc_set2.UserUniforms).sc_TAAMotionVectorTextureSize.zw);
bool param_28=(int(SC_USE_UV_TRANSFORM_sc_TAAMotionVectorTexture)!=0);
float3x3 param_29=(*sc_set2.UserUniforms).sc_TAAMotionVectorTextureTransform;
int2 param_30=int2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAMotionVectorTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAMotionVectorTexture);
bool param_31=(int(SC_USE_UV_MIN_MAX_sc_TAAMotionVectorTexture)!=0);
float4 param_32=(*sc_set2.UserUniforms).sc_TAAMotionVectorTextureUvMinMax;
bool param_33=(int(SC_USE_CLAMP_TO_BORDER_sc_TAAMotionVectorTexture)!=0);
float4 param_34=(*sc_set2.UserUniforms).sc_TAAMotionVectorTextureBorderColor;
float param_35=0.0;
float4 l9_4=sc_SampleTextureLevel(sc_set2.sc_TAAMotionVectorTexture,sc_set2.sc_TAAMotionVectorTextureSmpSC,param_24,param_25,param_26,param_27,param_28,param_29,param_30,param_31,param_32,param_33,param_34,param_35);
float4 l9_5=l9_4;
float4 color_1=l9_4;
if (all(color_1==float4(0.0)))
{
background+=1.0;
}
else
{
float4 param_36=color_1;
float2 v=decodeMotionVector(param_36);
float speedSquared=dot(v,v);
bool2 l9_6=bool2(speedSquared>maxSpeedSquared);
velocity=float2(l9_6.x ? v.x : velocity.x,l9_6.y ? v.y : velocity.y);
maxSpeedSquared=(speedSquared>maxSpeedSquared) ? speedSquared : maxSpeedSquared;
}
y_1++;
continue;
}
else
{
break;
}
}
x_1++;
continue;
}
else
{
break;
}
}
float2 param_37=sc_TAAHistoryTextureGetDims2D((*sc_set2.UserUniforms));
int param_38=sc_TAAHistoryTextureLayout;
int param_39=sc_TAAHistoryTextureGetStereoViewIndex(sc_fragIn.sc_sysIn,sc_set0,sc_set1);
float2 param_40=sc_fragIn.sc_sysIn.varPackedTex.xy-velocity;
bool param_41=(int(SC_USE_UV_TRANSFORM_sc_TAAHistoryTexture)!=0);
float3x3 param_42=(*sc_set2.UserUniforms).sc_TAAHistoryTextureTransform;
int2 param_43=int2(SC_SOFTWARE_WRAP_MODE_U_sc_TAAHistoryTexture,SC_SOFTWARE_WRAP_MODE_V_sc_TAAHistoryTexture);
bool param_44=(int(SC_USE_UV_MIN_MAX_sc_TAAHistoryTexture)!=0);
float4 param_45=(*sc_set2.UserUniforms).sc_TAAHistoryTextureUvMinMax;
bool param_46=(int(SC_USE_CLAMP_TO_BORDER_sc_TAAHistoryTexture)!=0);
float4 param_47=(*sc_set2.UserUniforms).sc_TAAHistoryTextureBorderColor;
float param_48=0.0;
float4 l9_7=sc_SampleTextureLevel(sc_set2.sc_TAAHistoryTexture,sc_set2.sc_TAAHistoryTextureSmpSC,param_37,param_38,param_39,param_40,param_41,param_42,param_43,param_44,param_45,param_46,param_47,param_48);
float4 l9_8=l9_7;
float3 historyColor=l9_7.xyz;
float3 clampedHistoryColor=fast::clamp(historyColor,minColor,maxColor);
float blendFactor=(background>8.0) ? 1.0 : 0.0625;
float4 param_49=float4(mix(clampedHistoryColor,currentColor,float3(blendFactor)),1.0);
sc_writeFragData0(param_49,sc_fragIn.sc_sysIn,sc_fragOut.sc_sysOut,sc_set0,sc_set1);
return sc_fragOut;
}
} // FRAGMENT SHADER
