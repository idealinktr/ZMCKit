#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler uvTextureSmpSC 2:2
//sampler sampler yTextureSmpSC 2:3
//texture texture2D uvTexture 2:0:2:2
//texture texture2D yTexture 2:1:2:3
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
#ifndef yTextureHasSwappedViews
#define yTextureHasSwappedViews 0
#elif yTextureHasSwappedViews==1
#undef yTextureHasSwappedViews
#define yTextureHasSwappedViews 1
#endif
#ifndef yTextureLayout
#define yTextureLayout 0
#endif
#ifndef uvTextureHasSwappedViews
#define uvTextureHasSwappedViews 0
#elif uvTextureHasSwappedViews==1
#undef uvTextureHasSwappedViews
#define uvTextureHasSwappedViews 1
#endif
#ifndef uvTextureLayout
#define uvTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_yTexture
#define SC_USE_UV_TRANSFORM_yTexture 0
#elif SC_USE_UV_TRANSFORM_yTexture==1
#undef SC_USE_UV_TRANSFORM_yTexture
#define SC_USE_UV_TRANSFORM_yTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_yTexture
#define SC_SOFTWARE_WRAP_MODE_U_yTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_yTexture
#define SC_SOFTWARE_WRAP_MODE_V_yTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_yTexture
#define SC_USE_UV_MIN_MAX_yTexture 0
#elif SC_USE_UV_MIN_MAX_yTexture==1
#undef SC_USE_UV_MIN_MAX_yTexture
#define SC_USE_UV_MIN_MAX_yTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_yTexture
#define SC_USE_CLAMP_TO_BORDER_yTexture 0
#elif SC_USE_CLAMP_TO_BORDER_yTexture==1
#undef SC_USE_CLAMP_TO_BORDER_yTexture
#define SC_USE_CLAMP_TO_BORDER_yTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_uvTexture
#define SC_USE_UV_TRANSFORM_uvTexture 0
#elif SC_USE_UV_TRANSFORM_uvTexture==1
#undef SC_USE_UV_TRANSFORM_uvTexture
#define SC_USE_UV_TRANSFORM_uvTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_uvTexture
#define SC_SOFTWARE_WRAP_MODE_U_uvTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_uvTexture
#define SC_SOFTWARE_WRAP_MODE_V_uvTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_uvTexture
#define SC_USE_UV_MIN_MAX_uvTexture 0
#elif SC_USE_UV_MIN_MAX_uvTexture==1
#undef SC_USE_UV_MIN_MAX_uvTexture
#define SC_USE_UV_MIN_MAX_uvTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_uvTexture
#define SC_USE_CLAMP_TO_BORDER_uvTexture 0
#elif SC_USE_CLAMP_TO_BORDER_uvTexture==1
#undef SC_USE_CLAMP_TO_BORDER_uvTexture
#define SC_USE_CLAMP_TO_BORDER_uvTexture 1
#endif
#ifndef FORMAT_NV12
#define FORMAT_NV12 0
#elif FORMAT_NV12==1
#undef FORMAT_NV12
#define FORMAT_NV12 1
#endif
#ifndef FORMAT_NV21
#define FORMAT_NV21 0
#elif FORMAT_NV21==1
#undef FORMAT_NV21
#define FORMAT_NV21 1
#endif
uniform vec4 yTextureDims;
uniform vec4 uvTextureDims;
uniform mat3 yTextureTransform;
uniform vec4 yTextureUvMinMax;
uniform vec4 yTextureBorderColor;
uniform mat3 uvTextureTransform;
uniform vec4 uvTextureUvMinMax;
uniform vec4 uvTextureBorderColor;
uniform mediump sampler2D yTexture;
uniform mediump sampler2D uvTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (yTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(yTextureDims.xy,yTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_yTexture)!=0),yTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_yTexture,SC_SOFTWARE_WRAP_MODE_V_yTexture),(int(SC_USE_UV_MIN_MAX_yTexture)!=0),yTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_yTexture)!=0),yTextureBorderColor,0.0,yTexture);
int l9_2;
#if (uvTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(uvTextureDims.xy,uvTextureLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_uvTexture)!=0),uvTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_uvTexture,SC_SOFTWARE_WRAP_MODE_V_uvTexture),(int(SC_USE_UV_MIN_MAX_uvTexture)!=0),uvTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_uvTexture)!=0),uvTextureBorderColor,0.0,uvTexture);
float l9_4=l9_1.x;
vec3 l9_5;
#if (FORMAT_NV12)
{
l9_5=(mat3(vec3(1.0),vec3(0.0,-0.33763301,1.732446),vec3(1.370705,-0.69800103,0.0))*vec3(l9_4,l9_3.xy))+vec3(-0.6853525,0.51781702,-0.86622298);
}
#else
{
vec3 l9_6;
#if (FORMAT_NV21)
{
l9_6=(mat3(vec3(1.0),vec3(0.0,-0.33763301,1.732446),vec3(1.370705,-0.69800103,0.0))*vec3(l9_4,l9_3.yx))+vec3(-0.6853525,0.51781702,-0.86622298);
}
#else
{
l9_6=vec3(0.0);
}
#endif
l9_5=l9_6;
}
#endif
sc_writeFragData0(vec4(l9_5,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
