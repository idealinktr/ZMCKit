#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler patchTextureSmpSC 2:1
//texture texture2D patchTexture 2:0:2:1
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform mat4 modelView;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(modelView*l9_0.position,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef patchTextureHasSwappedViews
#define patchTextureHasSwappedViews 0
#elif patchTextureHasSwappedViews==1
#undef patchTextureHasSwappedViews
#define patchTextureHasSwappedViews 1
#endif
#ifndef patchTextureLayout
#define patchTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_patchTexture
#define SC_USE_UV_TRANSFORM_patchTexture 0
#elif SC_USE_UV_TRANSFORM_patchTexture==1
#undef SC_USE_UV_TRANSFORM_patchTexture
#define SC_USE_UV_TRANSFORM_patchTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_patchTexture
#define SC_SOFTWARE_WRAP_MODE_U_patchTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_patchTexture
#define SC_SOFTWARE_WRAP_MODE_V_patchTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_patchTexture
#define SC_USE_UV_MIN_MAX_patchTexture 0
#elif SC_USE_UV_MIN_MAX_patchTexture==1
#undef SC_USE_UV_MIN_MAX_patchTexture
#define SC_USE_UV_MIN_MAX_patchTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_patchTexture
#define SC_USE_CLAMP_TO_BORDER_patchTexture 0
#elif SC_USE_CLAMP_TO_BORDER_patchTexture==1
#undef SC_USE_CLAMP_TO_BORDER_patchTexture
#define SC_USE_CLAMP_TO_BORDER_patchTexture 1
#endif
uniform vec4 patchTextureDims;
uniform mat3 patchTextureTransform;
uniform vec4 patchTextureUvMinMax;
uniform vec4 patchTextureBorderColor;
uniform mediump sampler2D patchTexture;
void main()
{
int l9_0;
#if (patchTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(vec4(sc_SampleTextureBiasOrLevel(patchTextureDims.xy,patchTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_patchTexture)!=0),patchTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_patchTexture,SC_SOFTWARE_WRAP_MODE_V_patchTexture),(int(SC_USE_UV_MIN_MAX_patchTexture)!=0),patchTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_patchTexture)!=0),patchTextureBorderColor,0.0,patchTexture).xyz,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
