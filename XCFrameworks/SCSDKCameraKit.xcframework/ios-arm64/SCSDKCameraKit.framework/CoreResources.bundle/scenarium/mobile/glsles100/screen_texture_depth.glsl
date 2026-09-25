#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs_without_output.glsl>
#include <std2_fs_depth_output.glsl>
#include <std2_texture.glsl>
#ifndef USE_MESH_TRANSFORM
#define USE_MESH_TRANSFORM 0
#elif USE_MESH_TRANSFORM==1
#undef USE_MESH_TRANSFORM
#define USE_MESH_TRANSFORM 1
#endif
#ifndef ONLY_VERTEX_ATTRIBUTE
#define ONLY_VERTEX_ATTRIBUTE 0
#elif ONLY_VERTEX_ATTRIBUTE==1
#undef ONLY_VERTEX_ATTRIBUTE
#define ONLY_VERTEX_ATTRIBUTE 1
#endif
uniform mat3 meshTransform;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec4 l9_2;
#if (USE_MESH_TRANSFORM)
{
l9_2=vec4(meshTransform*vec3(l9_1.xy,1.0),1.0);
}
#else
{
l9_2=l9_1;
}
#endif
sc_ProcessVertex(sc_Vertex_t(l9_2,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
#if (ONLY_VERTEX_ATTRIBUTE)
{
vec2 l9_3=(l9_1.xy+vec2(1.0))*0.5;
varPackedTex=vec4(l9_3.x,l9_3.y,varPackedTex.z,varPackedTex.w);
}
#endif
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs_without_output.glsl>
#include <std2_fs_depth_output.glsl>
#include <std2_texture.glsl>
#ifndef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 0
#elif screenTextureHasSwappedViews==1
#undef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 1
#endif
#ifndef screenTextureLayout
#define screenTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_screenTexture
#define SC_USE_UV_TRANSFORM_screenTexture 0
#elif SC_USE_UV_TRANSFORM_screenTexture==1
#undef SC_USE_UV_TRANSFORM_screenTexture
#define SC_USE_UV_TRANSFORM_screenTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_screenTexture
#define SC_SOFTWARE_WRAP_MODE_U_screenTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_screenTexture
#define SC_SOFTWARE_WRAP_MODE_V_screenTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_screenTexture
#define SC_USE_UV_MIN_MAX_screenTexture 0
#elif SC_USE_UV_MIN_MAX_screenTexture==1
#undef SC_USE_UV_MIN_MAX_screenTexture
#define SC_USE_UV_MIN_MAX_screenTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 0
#elif SC_USE_CLAMP_TO_BORDER_screenTexture==1
#undef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 1
#endif
uniform vec4 screenTextureDims;
uniform mat3 screenTextureTransform;
uniform vec4 screenTextureUvMinMax;
uniform vec4 screenTextureBorderColor;
uniform vec4 inputProjectionMatrixTerms;
uniform vec4 currentProjectionMatrixTerms;
uniform mediump sampler2D screenTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (screenTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(screenTextureDims.xy,screenTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_screenTexture)!=0),screenTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture),(int(SC_USE_UV_MIN_MAX_screenTexture)!=0),screenTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0),screenTextureBorderColor,0.0,screenTexture);
float l9_2=l9_1.x;
float l9_3;
if ((l9_2<1.0)&&any(notEqual(inputProjectionMatrixTerms,currentProjectionMatrixTerms)))
{
l9_3=depthViewToScreenSpace(depthScreenToViewSpace(l9_2,inputProjectionMatrixTerms),currentProjectionMatrixTerms);
}
else
{
l9_3=l9_2;
}
sc_writeFragDepth(l9_3);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
