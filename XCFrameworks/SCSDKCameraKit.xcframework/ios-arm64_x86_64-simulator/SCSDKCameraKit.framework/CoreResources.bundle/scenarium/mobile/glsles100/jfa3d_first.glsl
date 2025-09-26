#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTexture1SmpSC 2:3
//sampler sampler inputTexture2SmpSC 2:4
//sampler sampler inputTextureSmpSC 2:5
//texture texture2D inputTexture 2:0:2:5
//texture texture2D inputTexture1 2:1:2:3
//texture texture2D inputTexture2 2:2:2:4
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <voxeldata_common.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <voxeldata_common.glsl>
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef inputTexture1HasSwappedViews
#define inputTexture1HasSwappedViews 0
#elif inputTexture1HasSwappedViews==1
#undef inputTexture1HasSwappedViews
#define inputTexture1HasSwappedViews 1
#endif
#ifndef inputTexture1Layout
#define inputTexture1Layout 0
#endif
#ifndef inputTexture2HasSwappedViews
#define inputTexture2HasSwappedViews 0
#elif inputTexture2HasSwappedViews==1
#undef inputTexture2HasSwappedViews
#define inputTexture2HasSwappedViews 1
#endif
#ifndef inputTexture2Layout
#define inputTexture2Layout 0
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
#ifndef SC_USE_UV_TRANSFORM_inputTexture1
#define SC_USE_UV_TRANSFORM_inputTexture1 0
#elif SC_USE_UV_TRANSFORM_inputTexture1==1
#undef SC_USE_UV_TRANSFORM_inputTexture1
#define SC_USE_UV_TRANSFORM_inputTexture1 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture1
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture1 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture1
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture1 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture1
#define SC_USE_UV_MIN_MAX_inputTexture1 0
#elif SC_USE_UV_MIN_MAX_inputTexture1==1
#undef SC_USE_UV_MIN_MAX_inputTexture1
#define SC_USE_UV_MIN_MAX_inputTexture1 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture1
#define SC_USE_CLAMP_TO_BORDER_inputTexture1 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture1==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture1
#define SC_USE_CLAMP_TO_BORDER_inputTexture1 1
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture2
#define SC_USE_UV_TRANSFORM_inputTexture2 0
#elif SC_USE_UV_TRANSFORM_inputTexture2==1
#undef SC_USE_UV_TRANSFORM_inputTexture2
#define SC_USE_UV_TRANSFORM_inputTexture2 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture2
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture2 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture2
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture2 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture2
#define SC_USE_UV_MIN_MAX_inputTexture2 0
#elif SC_USE_UV_MIN_MAX_inputTexture2==1
#undef SC_USE_UV_MIN_MAX_inputTexture2
#define SC_USE_UV_MIN_MAX_inputTexture2 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture2
#define SC_USE_CLAMP_TO_BORDER_inputTexture2 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture2==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture2
#define SC_USE_CLAMP_TO_BORDER_inputTexture2 1
#endif
uniform vec4 inputTextureDims;
uniform vec4 inputTexture1Dims;
uniform vec4 inputTexture2Dims;
uniform vec4 voxelization_params_0;
uniform vec4 jfa3d_params_0;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mat3 inputTexture1Transform;
uniform vec4 inputTexture1UvMinMax;
uniform vec4 inputTexture1BorderColor;
uniform mat3 inputTexture2Transform;
uniform vec4 inputTexture2UvMinMax;
uniform vec4 inputTexture2BorderColor;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D inputTexture1;
uniform mediump sampler2D inputTexture2;
vec4 CombineAxesRatio11(vec3 uvw)
{
vec2 l9_0=UVW2UV(uvw,voxelization_params_0.x,jfa3d_params_0.w);
int l9_1;
#if (inputTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
vec4 l9_2=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_1,l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_3;
#if (inputTexture1HasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
vec4 l9_4=sc_SampleTextureBiasOrLevel(inputTexture1Dims.xy,inputTexture1Layout,l9_3,l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture1)!=0),inputTexture1Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture1,SC_SOFTWARE_WRAP_MODE_V_inputTexture1),(int(SC_USE_UV_MIN_MAX_inputTexture1)!=0),inputTexture1UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture1)!=0),inputTexture1BorderColor,0.0,inputTexture1);
int l9_5;
#if (inputTexture2HasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
vec4 l9_6=sc_SampleTextureBiasOrLevel(inputTexture2Dims.xy,inputTexture2Layout,l9_5,l9_0,(int(SC_USE_UV_TRANSFORM_inputTexture2)!=0),inputTexture2Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture2,SC_SOFTWARE_WRAP_MODE_V_inputTexture2),(int(SC_USE_UV_MIN_MAX_inputTexture2)!=0),inputTexture2UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture2)!=0),inputTexture2BorderColor,0.0,inputTexture2);
vec3 l9_7=l9_2.xyz;
bool l9_8=dot(l9_7,l9_7)==0.0;
bool l9_9;
if (l9_8)
{
vec3 l9_10=l9_4.xyz;
l9_9=dot(l9_10,l9_10)==0.0;
}
else
{
l9_9=l9_8;
}
bool l9_11;
if (l9_9)
{
vec3 l9_12=l9_6.xyz;
l9_11=dot(l9_12,l9_12)==0.0;
}
else
{
l9_11=l9_9;
}
if (l9_11)
{
return vec4(0.0,0.0,0.0,1.0);
}
return vec4(uvw,0.0);
}
void main()
{
sc_DiscardStereoFragment();
sc_writeFragData0(CombineAxesRatio11(UV2UVW(varPackedTex.xy,jfa3d_params_0.z,jfa3d_params_0.w)));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
