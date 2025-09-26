#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler mainTextureSmpSC 2:6
//sampler sampler tex_BY_YSmpSC 2:7
//sampler sampler tex_RG_RB_GBSmpSC 2:8
//sampler sampler tex_RR_GG_BBSmpSC 2:9
//sampler sampler tex_RY_GYSmpSC 2:10
//sampler sampler tex_R_G_BSmpSC 2:11
//texture texture2D mainTexture 2:0:2:6
//texture texture2D tex_BY_Y 2:1:2:7
//texture texture2D tex_RG_RB_GB 2:2:2:8
//texture texture2D tex_RR_GG_BB 2:3:2:9
//texture texture2D tex_RY_GY 2:4:2:10
//texture texture2D tex_R_G_B 2:5:2:11
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
#ifndef tex_RY_GYHasSwappedViews
#define tex_RY_GYHasSwappedViews 0
#elif tex_RY_GYHasSwappedViews==1
#undef tex_RY_GYHasSwappedViews
#define tex_RY_GYHasSwappedViews 1
#endif
#ifndef tex_RY_GYLayout
#define tex_RY_GYLayout 0
#endif
#ifndef tex_BY_YHasSwappedViews
#define tex_BY_YHasSwappedViews 0
#elif tex_BY_YHasSwappedViews==1
#undef tex_BY_YHasSwappedViews
#define tex_BY_YHasSwappedViews 1
#endif
#ifndef tex_BY_YLayout
#define tex_BY_YLayout 0
#endif
#ifndef tex_R_G_BHasSwappedViews
#define tex_R_G_BHasSwappedViews 0
#elif tex_R_G_BHasSwappedViews==1
#undef tex_R_G_BHasSwappedViews
#define tex_R_G_BHasSwappedViews 1
#endif
#ifndef tex_R_G_BLayout
#define tex_R_G_BLayout 0
#endif
#ifndef tex_RR_GG_BBHasSwappedViews
#define tex_RR_GG_BBHasSwappedViews 0
#elif tex_RR_GG_BBHasSwappedViews==1
#undef tex_RR_GG_BBHasSwappedViews
#define tex_RR_GG_BBHasSwappedViews 1
#endif
#ifndef tex_RR_GG_BBLayout
#define tex_RR_GG_BBLayout 0
#endif
#ifndef tex_RG_RB_GBHasSwappedViews
#define tex_RG_RB_GBHasSwappedViews 0
#elif tex_RG_RB_GBHasSwappedViews==1
#undef tex_RG_RB_GBHasSwappedViews
#define tex_RG_RB_GBHasSwappedViews 1
#endif
#ifndef tex_RG_RB_GBLayout
#define tex_RG_RB_GBLayout 0
#endif
#ifndef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 0
#elif mainTextureHasSwappedViews==1
#undef mainTextureHasSwappedViews
#define mainTextureHasSwappedViews 1
#endif
#ifndef mainTextureLayout
#define mainTextureLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY
#define SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY
#define SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RY_GY
#define SC_USE_UV_MIN_MAX_tex_RY_GY 0
#elif SC_USE_UV_MIN_MAX_tex_RY_GY==1
#undef SC_USE_UV_MIN_MAX_tex_RY_GY
#define SC_USE_UV_MIN_MAX_tex_RY_GY 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RY_GY
#define SC_USE_CLAMP_TO_BORDER_tex_RY_GY 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RY_GY==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RY_GY
#define SC_USE_CLAMP_TO_BORDER_tex_RY_GY 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y
#define SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y
#define SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_BY_Y
#define SC_USE_UV_MIN_MAX_tex_BY_Y 0
#elif SC_USE_UV_MIN_MAX_tex_BY_Y==1
#undef SC_USE_UV_MIN_MAX_tex_BY_Y
#define SC_USE_UV_MIN_MAX_tex_BY_Y 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_BY_Y
#define SC_USE_CLAMP_TO_BORDER_tex_BY_Y 0
#elif SC_USE_CLAMP_TO_BORDER_tex_BY_Y==1
#undef SC_USE_CLAMP_TO_BORDER_tex_BY_Y
#define SC_USE_CLAMP_TO_BORDER_tex_BY_Y 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B
#define SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B
#define SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_R_G_B
#define SC_USE_UV_MIN_MAX_tex_R_G_B 0
#elif SC_USE_UV_MIN_MAX_tex_R_G_B==1
#undef SC_USE_UV_MIN_MAX_tex_R_G_B
#define SC_USE_UV_MIN_MAX_tex_R_G_B 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_R_G_B
#define SC_USE_CLAMP_TO_BORDER_tex_R_G_B 0
#elif SC_USE_CLAMP_TO_BORDER_tex_R_G_B==1
#undef SC_USE_CLAMP_TO_BORDER_tex_R_G_B
#define SC_USE_CLAMP_TO_BORDER_tex_R_G_B 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB
#define SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB
#define SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RR_GG_BB
#define SC_USE_UV_MIN_MAX_tex_RR_GG_BB 0
#elif SC_USE_UV_MIN_MAX_tex_RR_GG_BB==1
#undef SC_USE_UV_MIN_MAX_tex_RR_GG_BB
#define SC_USE_UV_MIN_MAX_tex_RR_GG_BB 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB
#define SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB
#define SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB
#define SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB
#define SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB -1
#endif
#ifndef SC_USE_UV_MIN_MAX_tex_RG_RB_GB
#define SC_USE_UV_MIN_MAX_tex_RG_RB_GB 0
#elif SC_USE_UV_MIN_MAX_tex_RG_RB_GB==1
#undef SC_USE_UV_MIN_MAX_tex_RG_RB_GB
#define SC_USE_UV_MIN_MAX_tex_RG_RB_GB 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB
#define SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB 0
#elif SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB==1
#undef SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB
#define SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB 1
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
#ifndef CAMEOS_MATTING
#define CAMEOS_MATTING 0
#elif CAMEOS_MATTING==1
#undef CAMEOS_MATTING
#define CAMEOS_MATTING 1
#endif
uniform vec4 tex_RY_GYDims;
uniform vec4 tex_BY_YDims;
uniform vec4 tex_R_G_BDims;
uniform vec4 tex_RR_GG_BBDims;
uniform vec4 tex_RG_RB_GBDims;
uniform vec4 mainTextureDims;
uniform vec4 tex_RY_GYUvMinMax;
uniform vec4 tex_RY_GYBorderColor;
uniform vec4 tex_BY_YUvMinMax;
uniform vec4 tex_BY_YBorderColor;
uniform vec4 tex_R_G_BUvMinMax;
uniform vec4 tex_R_G_BBorderColor;
uniform vec4 tex_RR_GG_BBUvMinMax;
uniform vec4 tex_RR_GG_BBBorderColor;
uniform vec4 tex_RG_RB_GBUvMinMax;
uniform vec4 tex_RG_RB_GBBorderColor;
uniform float epsilon;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mediump sampler2D tex_RY_GY;
uniform mediump sampler2D tex_BY_Y;
uniform mediump sampler2D tex_R_G_B;
uniform mediump sampler2D tex_RR_GG_BB;
uniform mediump sampler2D tex_RG_RB_GB;
uniform mediump sampler2D mainTexture;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (tex_RY_GYHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(tex_RY_GYDims.xy,tex_RY_GYLayout,l9_0,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RY_GY,SC_SOFTWARE_WRAP_MODE_V_tex_RY_GY),(int(SC_USE_UV_MIN_MAX_tex_RY_GY)!=0),tex_RY_GYUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RY_GY)!=0),tex_RY_GYBorderColor,0.0,tex_RY_GY);
int l9_2;
#if (tex_BY_YHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(tex_BY_YDims.xy,tex_BY_YLayout,l9_2,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_BY_Y,SC_SOFTWARE_WRAP_MODE_V_tex_BY_Y),(int(SC_USE_UV_MIN_MAX_tex_BY_Y)!=0),tex_BY_YUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_BY_Y)!=0),tex_BY_YBorderColor,0.0,tex_BY_Y);
float l9_4=dot(l9_3.zw,vec2(1.0,0.0039215689));
int l9_5;
#if (tex_R_G_BHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
vec4 l9_6=sc_SampleTextureBiasOrLevel(tex_R_G_BDims.xy,tex_R_G_BLayout,l9_5,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_R_G_B,SC_SOFTWARE_WRAP_MODE_V_tex_R_G_B),(int(SC_USE_UV_MIN_MAX_tex_R_G_B)!=0),tex_R_G_BUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_R_G_B)!=0),tex_R_G_BBorderColor,0.0,tex_R_G_B);
vec3 l9_7=l9_6.xyz;
int l9_8;
#if (tex_RR_GG_BBHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(tex_RR_GG_BBDims.xy,tex_RR_GG_BBLayout,l9_8,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RR_GG_BB,SC_SOFTWARE_WRAP_MODE_V_tex_RR_GG_BB),(int(SC_USE_UV_MIN_MAX_tex_RR_GG_BB)!=0),tex_RR_GG_BBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RR_GG_BB)!=0),tex_RR_GG_BBBorderColor,0.0,tex_RR_GG_BB);
int l9_10;
#if (tex_RG_RB_GBHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(tex_RG_RB_GBDims.xy,tex_RG_RB_GBLayout,l9_10,varPackedTex.xy,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_tex_RG_RB_GB,SC_SOFTWARE_WRAP_MODE_V_tex_RG_RB_GB),(int(SC_USE_UV_MIN_MAX_tex_RG_RB_GB)!=0),tex_RG_RB_GBUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_tex_RG_RB_GB)!=0),tex_RG_RB_GBBorderColor,0.0,tex_RG_RB_GB);
vec3 l9_12=abs(l9_9.xyz-(l9_7*l9_7))+vec3(epsilon*epsilon);
vec3 l9_13=l9_11.xyz-(l9_6.xxy*l9_6.yzz);
float l9_14=l9_12.x;
float l9_15=l9_12.y;
float l9_16=l9_12.z;
float l9_17=l9_13.x;
float l9_18=l9_13.y;
float l9_19=l9_13.z;
float l9_20=(l9_18*l9_19)-(l9_16*l9_17);
float l9_21=(l9_17*l9_19)-(l9_18*l9_15);
float l9_22=(l9_17*l9_18)-(l9_14*l9_19);
vec3 l9_23=vec3((l9_16*l9_15)-(l9_19*l9_19),l9_20,l9_21);
vec3 l9_24=(mat3(l9_23,vec3(l9_20,(l9_16*l9_14)-(l9_18*l9_18),l9_22),vec3(l9_21,l9_22,(l9_14*l9_15)-(l9_17*l9_17)))*(vec4(dot(l9_1.xy,vec2(1.0,0.0039215689)),dot(l9_1.zw,vec2(1.0,0.0039215689)),dot(l9_3.xy,vec2(1.0,0.0039215689)),l9_4).xyz-(l9_7*l9_4)))/vec3(dot(vec3(l9_14,l9_17,l9_18),l9_23));
int l9_25;
#if (mainTextureHasSwappedViews)
{
l9_25=1-sc_GetStereoViewIndex();
}
#else
{
l9_25=sc_GetStereoViewIndex();
}
#endif
vec4 l9_26=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_25,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
float l9_27=dot(l9_24,l9_26.xyz)+(l9_4-dot(l9_24,l9_7));
vec4 l9_28;
#if (CAMEOS_MATTING)
{
l9_28=vec4(l9_27,0.0,0.0,1.0);
}
#else
{
vec2 l9_29=fract(vec2(1.0,255.0)*l9_27);
float l9_30=l9_29.y;
l9_28=vec4(l9_29.x-(l9_30/255.0),l9_30,0.0,1.0);
}
#endif
sc_writeFragData0(l9_28);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
