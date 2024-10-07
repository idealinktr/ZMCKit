#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler backTextureSmpSC 2:3
//sampler sampler inputTextureSmpSC 2:4
//sampler sampler maskTextureSmpSC 2:5
//texture texture2D backTexture 2:0:2:3
//texture texture2D inputTexture 2:1:2:4
//texture texture2D maskTexture 2:2:2:5
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 inputTextureDims;
uniform vec4 maskTextureDims;
uniform vec4 backTextureDims;
uniform mat3 inputTextureTransform;
uniform mat3 maskTransform;
uniform mat3 backTransform;
uniform vec4 inputTextureSize;
uniform vec4 inputTextureView;
uniform vec4 maskTextureSize;
uniform vec4 maskTextureView;
uniform vec4 backTextureSize;
uniform vec4 backTextureView;
uniform vec4 backColorMult;
varying vec4 varTexMaskAndBack;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec3 l9_1=vec3(l9_0.texture0,1.0);
vec2 l9_2=vec2((maskTransform*l9_1).xy);
varTexMaskAndBack=vec4(l9_2.x,l9_2.y,varTexMaskAndBack.z,varTexMaskAndBack.w);
vec2 l9_3=vec2((backTransform*l9_1).xy);
varTexMaskAndBack=vec4(varTexMaskAndBack.x,varTexMaskAndBack.y,l9_3.x,l9_3.y);
sc_ProcessVertex(sc_Vertex_t(l9_0.position,l9_0.normal,l9_0.tangent,vec2((inputTextureTransform*l9_1).xy),l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 0
#elif maskTextureHasSwappedViews==1
#undef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 1
#endif
#ifndef maskTextureLayout
#define maskTextureLayout 0
#endif
#ifndef backTextureHasSwappedViews
#define backTextureHasSwappedViews 0
#elif backTextureHasSwappedViews==1
#undef backTextureHasSwappedViews
#define backTextureHasSwappedViews 1
#endif
#ifndef backTextureLayout
#define backTextureLayout 0
#endif
#ifndef MASK_CHANNEL
#define MASK_CHANNEL 0
#endif
uniform vec4 inputTextureDims;
uniform vec4 maskTextureDims;
uniform vec4 backTextureDims;
uniform vec4 backColorMult;
uniform vec4 inputTextureSize;
uniform vec4 inputTextureView;
uniform vec4 maskTextureSize;
uniform vec4 maskTextureView;
uniform vec4 backTextureSize;
uniform vec4 backTextureView;
uniform mat3 maskTransform;
uniform mat3 backTransform;
uniform mat3 inputTextureTransform;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2D backTexture;
varying vec4 varTexMaskAndBack;
void main()
{
sc_DiscardStereoFragment();
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
vec4 l9_1=sc_SampleView(inputTextureDims.xy,varPackedTex.xy,inputTextureLayout,l9_0,0.0,inputTexture);
vec4 l9_2;
#if (MASK_CHANNEL==0)
{
int l9_3;
#if (maskTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
l9_2=sc_SampleView(maskTextureDims.xy,varTexMaskAndBack.xy,maskTextureLayout,l9_3,0.0,maskTexture).xxxx;
}
#else
{
vec4 l9_4;
#if (MASK_CHANNEL==1)
{
int l9_5;
#if (maskTextureHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
l9_4=sc_SampleView(maskTextureDims.xy,varTexMaskAndBack.xy,maskTextureLayout,l9_5,0.0,maskTexture);
}
#else
{
vec4 l9_6;
#if (MASK_CHANNEL==2)
{
int l9_7;
#if (maskTextureHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
l9_6=sc_SampleView(maskTextureDims.xy,varTexMaskAndBack.xy,maskTextureLayout,l9_7,0.0,maskTexture).wwww;
}
#else
{
l9_6=vec4(0.0);
}
#endif
l9_4=l9_6;
}
#endif
l9_2=l9_4;
}
#endif
int l9_8;
#if (backTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(mix(sc_SampleView(backTextureDims.xy,varTexMaskAndBack.zw,backTextureLayout,l9_8,0.0,backTexture)*backColorMult,l9_1,l9_2));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
