#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler alphaTextureSmpSC 2:2
//sampler sampler mainTextureSmpSC 2:3
//texture texture2D alphaTexture 2:0:2:2
//texture texture2D mainTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef SEPARATE_ALPHA_TEXTURE
#define SEPARATE_ALPHA_TEXTURE 0
#elif SEPARATE_ALPHA_TEXTURE==1
#undef SEPARATE_ALPHA_TEXTURE
#define SEPARATE_ALPHA_TEXTURE 1
#endif
uniform mat4 modelView;
void main()
{
varPackedTex=vec4(texture0.x,texture0.y,varPackedTex.z,varPackedTex.w);
#if (SEPARATE_ALPHA_TEXTURE)
{
varPackedTex=vec4(varPackedTex.x,varPackedTex.y,texture1.x,texture1.y);
}
#endif
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(modelView*l9_0.position,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
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
#ifndef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 0
#elif alphaTextureHasSwappedViews==1
#undef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 1
#endif
#ifndef alphaTextureLayout
#define alphaTextureLayout 0
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
#ifndef SEPARATE_ALPHA_TEXTURE
#define SEPARATE_ALPHA_TEXTURE 0
#elif SEPARATE_ALPHA_TEXTURE==1
#undef SEPARATE_ALPHA_TEXTURE
#define SEPARATE_ALPHA_TEXTURE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 0
#elif SC_USE_UV_TRANSFORM_alphaTexture==1
#undef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_U_alphaTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_V_alphaTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 0
#elif SC_USE_UV_MIN_MAX_alphaTexture==1
#undef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 0
#elif SC_USE_CLAMP_TO_BORDER_alphaTexture==1
#undef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 1
#endif
uniform vec4 mainTextureDims;
uniform vec4 alphaTextureDims;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mat3 alphaTextureTransform;
uniform vec4 alphaTextureUvMinMax;
uniform vec4 alphaTextureBorderColor;
uniform mediump sampler2D mainTexture;
uniform mediump sampler2D alphaTexture;
void main()
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
vec4 l9_2;
#if (SEPARATE_ALPHA_TEXTURE)
{
int l9_3;
#if (alphaTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
vec4 l9_4=l9_1;
l9_4.w=sc_SampleTextureBiasOrLevel(alphaTextureDims.xy,alphaTextureLayout,l9_3,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_alphaTexture)!=0),alphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_alphaTexture,SC_SOFTWARE_WRAP_MODE_V_alphaTexture),(int(SC_USE_UV_MIN_MAX_alphaTexture)!=0),alphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_alphaTexture)!=0),alphaTextureBorderColor,0.0,alphaTexture).x;
l9_2=l9_4;
}
#else
{
l9_2=l9_1;
}
#endif
sc_writeFragData0(l9_2);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
