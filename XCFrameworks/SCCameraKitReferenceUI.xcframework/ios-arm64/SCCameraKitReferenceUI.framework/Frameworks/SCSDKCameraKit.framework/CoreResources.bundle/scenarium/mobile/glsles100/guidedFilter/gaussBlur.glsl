#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler texMainSmpSC 2:1
//texture texture2D texMain 2:0:2:1
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 texMainDims;
uniform vec4 texMainSize;
uniform vec2 blurVector;
uniform vec4 texMainView;
uniform mat3 texMainTransform;
uniform vec4 texMainUvMinMax;
uniform vec4 texMainBorderColor;
varying vec2 blurCoordinates[7];
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(l9_0);
vec2 l9_1=(l9_0.position.xy*0.5)+vec2(0.5);
vec2 l9_2=texMainSize.zw*blurVector;
blurCoordinates[0]=l9_1;
vec2 l9_3=l9_2*1.4584301;
blurCoordinates[1]=l9_1+l9_3;
blurCoordinates[2]=l9_1-l9_3;
vec2 l9_4=l9_2*3.403985;
blurCoordinates[3]=l9_1+l9_4;
blurCoordinates[4]=l9_1-l9_4;
vec2 l9_5=l9_2*5.3518062;
blurCoordinates[5]=l9_1+l9_5;
blurCoordinates[6]=l9_1-l9_5;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef texMainHasSwappedViews
#define texMainHasSwappedViews 0
#elif texMainHasSwappedViews==1
#undef texMainHasSwappedViews
#define texMainHasSwappedViews 1
#endif
#ifndef texMainLayout
#define texMainLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_texMain
#define SC_SOFTWARE_WRAP_MODE_U_texMain -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_texMain
#define SC_SOFTWARE_WRAP_MODE_V_texMain -1
#endif
#ifndef SC_USE_UV_MIN_MAX_texMain
#define SC_USE_UV_MIN_MAX_texMain 0
#elif SC_USE_UV_MIN_MAX_texMain==1
#undef SC_USE_UV_MIN_MAX_texMain
#define SC_USE_UV_MIN_MAX_texMain 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_texMain
#define SC_USE_CLAMP_TO_BORDER_texMain 0
#elif SC_USE_CLAMP_TO_BORDER_texMain==1
#undef SC_USE_CLAMP_TO_BORDER_texMain
#define SC_USE_CLAMP_TO_BORDER_texMain 1
#endif
uniform vec4 texMainDims;
uniform vec4 texMainUvMinMax;
uniform vec4 texMainBorderColor;
uniform vec4 texMainSize;
uniform vec4 texMainView;
uniform mat3 texMainTransform;
uniform vec2 blurVector;
uniform mediump sampler2D texMain;
varying vec2 blurCoordinates[7];
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (texMainHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_0,blurCoordinates[0],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_2;
#if (texMainHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_2,blurCoordinates[1],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_4;
#if (texMainHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_4,blurCoordinates[2],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_6;
#if (texMainHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
vec4 l9_7=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_6,blurCoordinates[3],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_8;
#if (texMainHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_8,blurCoordinates[4],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_10;
#if (texMainHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_10,blurCoordinates[5],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain);
int l9_12;
#if (texMainHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0((((l9_1*0.137023)+((l9_3+l9_5)*0.239337))+((l9_7+l9_9)*0.13944))+((l9_11+sc_SampleTextureBiasOrLevel(texMainDims.xy,texMainLayout,l9_12,blurCoordinates[6],false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_texMain,SC_SOFTWARE_WRAP_MODE_V_texMain),(int(SC_USE_UV_MIN_MAX_texMain)!=0),texMainUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texMain)!=0),texMainBorderColor,0.0,texMain))*0.052710999));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
