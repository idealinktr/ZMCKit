#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler cropTextureSmpSC 2:1
//texture texture2D cropTexture 2:0:2:1
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
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
#ifndef cropTextureHasSwappedViews
#define cropTextureHasSwappedViews 0
#elif cropTextureHasSwappedViews==1
#undef cropTextureHasSwappedViews
#define cropTextureHasSwappedViews 1
#endif
#ifndef cropTextureLayout
#define cropTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_cropTexture
#define SC_USE_UV_TRANSFORM_cropTexture 0
#elif SC_USE_UV_TRANSFORM_cropTexture==1
#undef SC_USE_UV_TRANSFORM_cropTexture
#define SC_USE_UV_TRANSFORM_cropTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_cropTexture
#define SC_SOFTWARE_WRAP_MODE_U_cropTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_cropTexture
#define SC_SOFTWARE_WRAP_MODE_V_cropTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_cropTexture
#define SC_USE_UV_MIN_MAX_cropTexture 0
#elif SC_USE_UV_MIN_MAX_cropTexture==1
#undef SC_USE_UV_MIN_MAX_cropTexture
#define SC_USE_UV_MIN_MAX_cropTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_cropTexture
#define SC_USE_CLAMP_TO_BORDER_cropTexture 0
#elif SC_USE_CLAMP_TO_BORDER_cropTexture==1
#undef SC_USE_CLAMP_TO_BORDER_cropTexture
#define SC_USE_CLAMP_TO_BORDER_cropTexture 1
#endif
#ifndef INVERT_MASK
#define INVERT_MASK 0
#elif INVERT_MASK==1
#undef INVERT_MASK
#define INVERT_MASK 1
#endif
uniform vec4 cropTextureDims;
uniform mat3 cropTextureTransform;
uniform vec4 cropTextureUvMinMax;
uniform vec4 cropTextureBorderColor;
uniform mediump sampler2D cropTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (cropTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(cropTextureDims.xy,cropTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_cropTexture)!=0),cropTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_cropTexture,SC_SOFTWARE_WRAP_MODE_V_cropTexture),(int(SC_USE_UV_MIN_MAX_cropTexture)!=0),cropTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_cropTexture)!=0),cropTextureBorderColor,0.0,cropTexture);
float l9_2=l9_1.x;
float l9_3;
#if (INVERT_MASK)
{
l9_3=1.0-l9_2;
}
#else
{
l9_3=l9_2;
}
#endif
sc_writeFragData0(vec4(l9_3,l9_3,l9_3,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
