#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform mat3 inputTextureTransform;
uniform mat3 meshTransform;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=vec2((inputTextureTransform*vec3((l9_1.xy*0.5)+vec2(0.5),1.0)).xy);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
vec2 l9_3=vec2((meshTransform*vec3(l9_1.xy,1.0)).xy);
sc_ProcessVertex(sc_Vertex_t(vec4(l9_3.x,l9_3.y,vec2(0.0,1.0).x,vec2(0.0,1.0).y),l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
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
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef inputTextureWarpHasSwappedViews
#define inputTextureWarpHasSwappedViews 0
#elif inputTextureWarpHasSwappedViews==1
#undef inputTextureWarpHasSwappedViews
#define inputTextureWarpHasSwappedViews 1
#endif
#ifndef inputTextureWarpLayout
#define inputTextureWarpLayout 0
#endif
#ifndef ENABLE_WARP
#define ENABLE_WARP 0
#elif ENABLE_WARP==1
#undef ENABLE_WARP
#define ENABLE_WARP 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTextureWarp
#define SC_SOFTWARE_WRAP_MODE_U_inputTextureWarp -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTextureWarp
#define SC_SOFTWARE_WRAP_MODE_V_inputTextureWarp -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTextureWarp
#define SC_USE_UV_MIN_MAX_inputTextureWarp 0
#elif SC_USE_UV_MIN_MAX_inputTextureWarp==1
#undef SC_USE_UV_MIN_MAX_inputTextureWarp
#define SC_USE_UV_MIN_MAX_inputTextureWarp 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTextureWarp
#define SC_USE_CLAMP_TO_BORDER_inputTextureWarp 0
#elif SC_USE_CLAMP_TO_BORDER_inputTextureWarp==1
#undef SC_USE_CLAMP_TO_BORDER_inputTextureWarp
#define SC_USE_CLAMP_TO_BORDER_inputTextureWarp 1
#endif
#ifndef USE_FLOAT_WARP
#define USE_FLOAT_WARP 0
#elif USE_FLOAT_WARP==1
#undef USE_FLOAT_WARP
#define USE_FLOAT_WARP 1
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
uniform vec4 inputTextureDims;
uniform vec4 inputTextureWarpDims;
uniform vec4 inputTextureWarpUvMinMax;
uniform vec4 inputTextureWarpBorderColor;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform vec2 inputDenorm;
uniform mat3 meshTransformR;
uniform vec4 screenTextureUvMinMax;
uniform vec4 screenTextureBorderColor;
uniform float screenTextureLOD;
uniform mediump sampler2D inputTextureWarp;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D screenTexture;
void main()
{
sc_DiscardStereoFragment();
vec2 l9_0;
#if (ENABLE_WARP)
{
int l9_1;
#if (inputTextureWarpHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
vec4 l9_2=sc_SampleTextureBiasOrLevel(inputTextureWarpDims.xy,inputTextureWarpLayout,l9_1,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTextureWarp,SC_SOFTWARE_WRAP_MODE_V_inputTextureWarp),(int(SC_USE_UV_MIN_MAX_inputTextureWarp)!=0),inputTextureWarpUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTextureWarp)!=0),inputTextureWarpBorderColor,0.0,inputTextureWarp);
vec2 l9_3;
#if (USE_FLOAT_WARP)
{
l9_3=l9_2.xy/vec2(2.0);
}
#else
{
l9_3=(l9_2.xy-vec2(0.5))/vec2(4.0);
}
#endif
l9_0=varPackedTex.xy+l9_3;
}
#else
{
l9_0=varPackedTex.xy;
}
#endif
int l9_4;
#if (inputTextureHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_4,l9_0,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec4 l9_6=(l9_5-vec4(inputDenorm.y))*inputDenorm.x;
int l9_7;
#if (screenTextureHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(vec4((sc_SampleTextureBiasOrLevel(screenTextureDims.xy,screenTextureLayout,l9_7,(meshTransformR*vec3(l9_0,1.0)).xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture),(int(SC_USE_UV_MIN_MAX_screenTexture)!=0),screenTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0),screenTextureBorderColor,screenTextureLOD,screenTexture).xyz*(1.0-l9_6.w))+l9_6.xyz,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
