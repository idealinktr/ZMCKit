#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTexture1SmpSC 2:4
//sampler sampler inputTexture2SmpSC 2:5
//sampler sampler inputTexture3SmpSC 2:6
//sampler sampler inputTextureSmpSC 2:7
//texture texture2D inputTexture 2:0:2:7
//texture texture2D inputTexture1 2:1:2:4
//texture texture2D inputTexture2 2:2:2:5
//texture texture2D inputTexture3 2:3:2:6
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
#ifndef inputTexture3HasSwappedViews
#define inputTexture3HasSwappedViews 0
#elif inputTexture3HasSwappedViews==1
#undef inputTexture3HasSwappedViews
#define inputTexture3HasSwappedViews 1
#endif
#ifndef inputTexture3Layout
#define inputTexture3Layout 0
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
#ifndef SC_USE_UV_TRANSFORM_inputTexture3
#define SC_USE_UV_TRANSFORM_inputTexture3 0
#elif SC_USE_UV_TRANSFORM_inputTexture3==1
#undef SC_USE_UV_TRANSFORM_inputTexture3
#define SC_USE_UV_TRANSFORM_inputTexture3 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture3
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture3 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture3
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture3 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture3
#define SC_USE_UV_MIN_MAX_inputTexture3 0
#elif SC_USE_UV_MIN_MAX_inputTexture3==1
#undef SC_USE_UV_MIN_MAX_inputTexture3
#define SC_USE_UV_MIN_MAX_inputTexture3 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture3
#define SC_USE_CLAMP_TO_BORDER_inputTexture3 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture3==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture3
#define SC_USE_CLAMP_TO_BORDER_inputTexture3 1
#endif
uniform vec4 inputTextureDims;
uniform vec4 inputTexture1Dims;
uniform vec4 inputTexture2Dims;
uniform vec4 inputTexture3Dims;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mat3 inputTexture1Transform;
uniform vec4 inputTexture1UvMinMax;
uniform vec4 inputTexture1BorderColor;
uniform mat3 inputTexture2Transform;
uniform vec4 inputTexture2UvMinMax;
uniform vec4 inputTexture2BorderColor;
uniform vec4 jfa3d_params_0;
uniform mat3 inputTexture3Transform;
uniform vec4 inputTexture3UvMinMax;
uniform vec4 inputTexture3BorderColor;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D inputTexture1;
uniform mediump sampler2D inputTexture2;
uniform mediump sampler2D inputTexture3;
vec4 CheckBoundaries(vec3 uvw)
{
vec3 l9_0=uvw;
float l9_1=uvw.y;
float l9_2=uvw.x;
int l9_3;
#if (inputTextureHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
vec4 l9_4=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_3,l9_0.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_5;
#if (inputTexture1HasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
vec4 l9_6=sc_SampleTextureBiasOrLevel(inputTexture1Dims.xy,inputTexture1Layout,l9_5,l9_0.xy,(int(SC_USE_UV_TRANSFORM_inputTexture1)!=0),inputTexture1Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture1,SC_SOFTWARE_WRAP_MODE_V_inputTexture1),(int(SC_USE_UV_MIN_MAX_inputTexture1)!=0),inputTexture1UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture1)!=0),inputTexture1BorderColor,0.0,inputTexture1);
int l9_7;
#if (inputTexture2HasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
vec4 l9_8=sc_SampleTextureBiasOrLevel(inputTexture2Dims.xy,inputTexture2Layout,l9_7,l9_0.xy,(int(SC_USE_UV_TRANSFORM_inputTexture2)!=0),inputTexture2Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture2,SC_SOFTWARE_WRAP_MODE_V_inputTexture2),(int(SC_USE_UV_MIN_MAX_inputTexture2)!=0),inputTexture2UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture2)!=0),inputTexture2BorderColor,0.0,inputTexture2);
bool l9_9=l9_0.z>=(1.0-l9_4.y);
bool l9_10;
if (l9_9)
{
l9_10=l9_0.z<=l9_4.x;
}
else
{
l9_10=l9_9;
}
bool l9_11=l9_1>=(1.0-l9_6.y);
bool l9_12;
if (l9_11)
{
l9_12=l9_1<=l9_6.x;
}
else
{
l9_12=l9_11;
}
bool l9_13=l9_2>=(1.0-l9_8.y);
bool l9_14;
if (l9_13)
{
l9_14=l9_2<=l9_8.x;
}
else
{
l9_14=l9_13;
}
float l9_15=float(l9_10);
float l9_16=float(l9_12);
float l9_17=float(l9_14);
return vec4(l9_15,l9_16,l9_17,(l9_15*l9_16)*l9_17);
}
void main()
{
sc_DiscardStereoFragment();
vec3 l9_0=UV2UVW(varPackedTex.xy,jfa3d_params_0.z,jfa3d_params_0.w);
vec4 l9_1=CheckBoundaries(l9_0);
int l9_2;
#if (inputTexture3HasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(inputTexture3Dims.xy,inputTexture3Layout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_inputTexture3)!=0),inputTexture3Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture3,SC_SOFTWARE_WRAP_MODE_V_inputTexture3),(int(SC_USE_UV_MIN_MAX_inputTexture3)!=0),inputTexture3UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture3)!=0),inputTexture3BorderColor,0.0,inputTexture3);
float l9_4=l9_3.w;
bool l9_5=l9_1.w>0.0;
float l9_6;
if (l9_5)
{
l9_6=-l9_4;
}
else
{
l9_6=l9_4;
}
sc_writeFragData0(vec4((l9_6*0.5)+0.5,l9_4,float(l9_5),l9_0.z));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
