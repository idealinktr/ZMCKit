#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler mainTextureSmpSC 2:2
//sampler sampler maskTextureSmpSC 2:3
//texture texture2D mainTexture 2:0:2:2
//texture texture2D maskTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
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
#ifndef EMOCHECKERS
#define EMOCHECKERS 0
#elif EMOCHECKERS==1
#undef EMOCHECKERS
#define EMOCHECKERS 1
#endif
#ifndef NOTEXTURE
#define NOTEXTURE 0
#elif NOTEXTURE==1
#undef NOTEXTURE
#define NOTEXTURE 1
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
#ifndef NOMASK
#define NOMASK 0
#elif NOMASK==1
#undef NOMASK
#define NOMASK 1
#endif
#ifndef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 0
#elif SC_USE_UV_TRANSFORM_maskTexture==1
#undef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_maskTexture
#define SC_SOFTWARE_WRAP_MODE_U_maskTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_maskTexture
#define SC_SOFTWARE_WRAP_MODE_V_maskTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 0
#elif SC_USE_UV_MIN_MAX_maskTexture==1
#undef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 0
#elif SC_USE_CLAMP_TO_BORDER_maskTexture==1
#undef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 1
#endif
#ifndef ENABLESHADOWS
#define ENABLESHADOWS 0
#elif ENABLESHADOWS==1
#undef ENABLESHADOWS
#define ENABLESHADOWS 1
#endif
uniform vec4 mainTextureDims;
uniform vec4 maskTextureDims;
uniform vec4 mainColor;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2D maskTexture;
void main()
{
sc_DiscardStereoFragment();
vec4 l9_0;
#if (EMOCHECKERS)
{
float l9_1=abs(dot(step(vec2(0.5),fract(varPackedTex.xy*2.0)),vec2(1.0))-1.0);
l9_0=vec4(l9_1,0.0,l9_1,1.0);
}
#else
{
vec4 l9_2;
#if (!NOTEXTURE)
{
int l9_3;
#if (mainTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
l9_2=mainColor*sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_3,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
}
#else
{
l9_2=mainColor;
}
#endif
vec4 l9_4;
#if (!NOMASK)
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
vec4 l9_6=l9_2;
l9_6.w=l9_2.w*sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_5,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture).x;
l9_4=l9_6;
}
#else
{
l9_4=l9_2;
}
#endif
l9_0=l9_4;
}
#endif
vec4 l9_7;
#if (ENABLESHADOWS)
{
vec4 l9_8;
#if (sc_ProjectiveShadowsReceiver)
{
vec3 l9_9=l9_0.xyz*evaluateShadow();
l9_8=vec4(l9_9.x,l9_9.y,l9_9.z,l9_0.w);
}
#else
{
l9_8=l9_0;
}
#endif
vec4 l9_10;
#if (sc_ProjectiveShadowsCaster)
{
l9_10=evaluateShadowCasterColor(l9_8);
}
#else
{
l9_10=l9_8;
}
#endif
l9_7=l9_10;
}
#else
{
l9_7=l9_0;
}
#endif
sc_writeFragData0(l9_7);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
