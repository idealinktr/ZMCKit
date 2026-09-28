#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 mainTextureSize;
varying vec2 blurCoordinates[25];
void setBlurCoordinates(vec2 texCoords,vec4 size)
{
blurCoordinates[0]=texCoords+vec2((-10.0)*size.z,(-10.0)*size.w);
blurCoordinates[1]=texCoords+vec2((-10.0)*size.z,(-5.0)*size.w);
blurCoordinates[2]=texCoords+vec2((-10.0)*size.z,0.0*size.w);
blurCoordinates[3]=texCoords+vec2((-10.0)*size.z,5.0*size.w);
blurCoordinates[4]=texCoords+vec2((-10.0)*size.z,10.0*size.w);
blurCoordinates[5]=texCoords+vec2((-5.0)*size.z,(-10.0)*size.w);
blurCoordinates[6]=texCoords+vec2((-5.0)*size.z,(-5.0)*size.w);
blurCoordinates[7]=texCoords+vec2((-5.0)*size.z,0.0*size.w);
blurCoordinates[8]=texCoords+vec2((-5.0)*size.z,5.0*size.w);
blurCoordinates[9]=texCoords+vec2((-5.0)*size.z,10.0*size.w);
blurCoordinates[10]=texCoords+vec2(0.0*size.z,(-10.0)*size.w);
blurCoordinates[11]=texCoords+vec2(0.0*size.z,(-5.0)*size.w);
blurCoordinates[12]=texCoords+vec2(0.0*size.z,0.0*size.w);
blurCoordinates[13]=texCoords+vec2(0.0*size.z,5.0*size.w);
blurCoordinates[14]=texCoords+vec2(0.0*size.z,10.0*size.w);
blurCoordinates[15]=texCoords+vec2(5.0*size.z,(-10.0)*size.w);
blurCoordinates[16]=texCoords+vec2(5.0*size.z,(-5.0)*size.w);
blurCoordinates[17]=texCoords+vec2(5.0*size.z,0.0*size.w);
blurCoordinates[18]=texCoords+vec2(5.0*size.z,5.0*size.w);
blurCoordinates[19]=texCoords+vec2(5.0*size.z,10.0*size.w);
blurCoordinates[20]=texCoords+vec2(10.0*size.z,(-10.0)*size.w);
blurCoordinates[21]=texCoords+vec2(10.0*size.z,(-5.0)*size.w);
blurCoordinates[22]=texCoords+vec2(10.0*size.z,0.0*size.w);
blurCoordinates[23]=texCoords+vec2(10.0*size.z,5.0*size.w);
blurCoordinates[24]=texCoords+vec2(10.0*size.z,10.0*size.w);
}
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
setBlurCoordinates(l9_0.texture0,mainTextureSize);
sc_ProcessVertex(l9_0);
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
#ifndef DEPTH_BLUR
#define DEPTH_BLUR 0
#elif DEPTH_BLUR==1
#undef DEPTH_BLUR
#define DEPTH_BLUR 1
#endif
uniform vec4 mainTextureDims;
uniform mat3 mainTextureTransform;
uniform vec4 mainTextureUvMinMax;
uniform vec4 mainTextureBorderColor;
uniform mediump sampler2D mainTexture;
varying vec2 blurCoordinates[25];
vec2 blur_x_depth()
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_0,blurCoordinates[0],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_2;
#if (mainTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_2,blurCoordinates[1],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_4;
#if (mainTextureHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_4,blurCoordinates[2],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_6;
#if (mainTextureHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
vec4 l9_7=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_6,blurCoordinates[3],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_8;
#if (mainTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_8,blurCoordinates[4],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_10;
#if (mainTextureHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_10,blurCoordinates[5],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_12;
#if (mainTextureHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
vec4 l9_13=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_12,blurCoordinates[6],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_14;
#if (mainTextureHasSwappedViews)
{
l9_14=1-sc_GetStereoViewIndex();
}
#else
{
l9_14=sc_GetStereoViewIndex();
}
#endif
vec4 l9_15=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_14,blurCoordinates[7],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_16;
#if (mainTextureHasSwappedViews)
{
l9_16=1-sc_GetStereoViewIndex();
}
#else
{
l9_16=sc_GetStereoViewIndex();
}
#endif
vec4 l9_17=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_16,blurCoordinates[8],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_18;
#if (mainTextureHasSwappedViews)
{
l9_18=1-sc_GetStereoViewIndex();
}
#else
{
l9_18=sc_GetStereoViewIndex();
}
#endif
vec4 l9_19=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_18,blurCoordinates[9],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_20;
#if (mainTextureHasSwappedViews)
{
l9_20=1-sc_GetStereoViewIndex();
}
#else
{
l9_20=sc_GetStereoViewIndex();
}
#endif
vec4 l9_21=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_20,blurCoordinates[10],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_22;
#if (mainTextureHasSwappedViews)
{
l9_22=1-sc_GetStereoViewIndex();
}
#else
{
l9_22=sc_GetStereoViewIndex();
}
#endif
vec4 l9_23=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_22,blurCoordinates[11],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_24;
#if (mainTextureHasSwappedViews)
{
l9_24=1-sc_GetStereoViewIndex();
}
#else
{
l9_24=sc_GetStereoViewIndex();
}
#endif
vec4 l9_25=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_24,blurCoordinates[12],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_26;
#if (mainTextureHasSwappedViews)
{
l9_26=1-sc_GetStereoViewIndex();
}
#else
{
l9_26=sc_GetStereoViewIndex();
}
#endif
vec4 l9_27=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_26,blurCoordinates[13],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_28;
#if (mainTextureHasSwappedViews)
{
l9_28=1-sc_GetStereoViewIndex();
}
#else
{
l9_28=sc_GetStereoViewIndex();
}
#endif
vec4 l9_29=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_28,blurCoordinates[14],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_30;
#if (mainTextureHasSwappedViews)
{
l9_30=1-sc_GetStereoViewIndex();
}
#else
{
l9_30=sc_GetStereoViewIndex();
}
#endif
vec4 l9_31=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_30,blurCoordinates[15],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_32;
#if (mainTextureHasSwappedViews)
{
l9_32=1-sc_GetStereoViewIndex();
}
#else
{
l9_32=sc_GetStereoViewIndex();
}
#endif
vec4 l9_33=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_32,blurCoordinates[16],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_34;
#if (mainTextureHasSwappedViews)
{
l9_34=1-sc_GetStereoViewIndex();
}
#else
{
l9_34=sc_GetStereoViewIndex();
}
#endif
vec4 l9_35=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_34,blurCoordinates[17],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_36;
#if (mainTextureHasSwappedViews)
{
l9_36=1-sc_GetStereoViewIndex();
}
#else
{
l9_36=sc_GetStereoViewIndex();
}
#endif
vec4 l9_37=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_36,blurCoordinates[18],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_38;
#if (mainTextureHasSwappedViews)
{
l9_38=1-sc_GetStereoViewIndex();
}
#else
{
l9_38=sc_GetStereoViewIndex();
}
#endif
vec4 l9_39=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_38,blurCoordinates[19],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_40;
#if (mainTextureHasSwappedViews)
{
l9_40=1-sc_GetStereoViewIndex();
}
#else
{
l9_40=sc_GetStereoViewIndex();
}
#endif
vec4 l9_41=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_40,blurCoordinates[20],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_42;
#if (mainTextureHasSwappedViews)
{
l9_42=1-sc_GetStereoViewIndex();
}
#else
{
l9_42=sc_GetStereoViewIndex();
}
#endif
vec4 l9_43=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_42,blurCoordinates[21],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_44;
#if (mainTextureHasSwappedViews)
{
l9_44=1-sc_GetStereoViewIndex();
}
#else
{
l9_44=sc_GetStereoViewIndex();
}
#endif
vec4 l9_45=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_44,blurCoordinates[22],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_46;
#if (mainTextureHasSwappedViews)
{
l9_46=1-sc_GetStereoViewIndex();
}
#else
{
l9_46=sc_GetStereoViewIndex();
}
#endif
vec4 l9_47=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_46,blurCoordinates[23],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_48;
#if (mainTextureHasSwappedViews)
{
l9_48=1-sc_GetStereoViewIndex();
}
#else
{
l9_48=sc_GetStereoViewIndex();
}
#endif
vec4 l9_49=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_48,blurCoordinates[24],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
return clamp(((((((((((((((((((((((((vec2(dot(l9_1.xy,vec2(1.0,0.0039215689)),dot(l9_1.zw,vec2(1.0,0.0039215689)))/vec2(25.0))+(vec2(dot(l9_3.xy,vec2(1.0,0.0039215689)),dot(l9_3.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_5.xy,vec2(1.0,0.0039215689)),dot(l9_5.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_7.xy,vec2(1.0,0.0039215689)),dot(l9_7.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_9.xy,vec2(1.0,0.0039215689)),dot(l9_9.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_11.xy,vec2(1.0,0.0039215689)),dot(l9_11.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_13.xy,vec2(1.0,0.0039215689)),dot(l9_13.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_15.xy,vec2(1.0,0.0039215689)),dot(l9_15.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_17.xy,vec2(1.0,0.0039215689)),dot(l9_17.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_19.xy,vec2(1.0,0.0039215689)),dot(l9_19.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_21.xy,vec2(1.0,0.0039215689)),dot(l9_21.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_23.xy,vec2(1.0,0.0039215689)),dot(l9_23.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_25.xy,vec2(1.0,0.0039215689)),dot(l9_25.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_27.xy,vec2(1.0,0.0039215689)),dot(l9_27.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_29.xy,vec2(1.0,0.0039215689)),dot(l9_29.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_31.xy,vec2(1.0,0.0039215689)),dot(l9_31.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_33.xy,vec2(1.0,0.0039215689)),dot(l9_33.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_35.xy,vec2(1.0,0.0039215689)),dot(l9_35.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_37.xy,vec2(1.0,0.0039215689)),dot(l9_37.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_39.xy,vec2(1.0,0.0039215689)),dot(l9_39.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_41.xy,vec2(1.0,0.0039215689)),dot(l9_41.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_43.xy,vec2(1.0,0.0039215689)),dot(l9_43.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_45.xy,vec2(1.0,0.0039215689)),dot(l9_45.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_47.xy,vec2(1.0,0.0039215689)),dot(l9_47.zw,vec2(1.0,0.0039215689)))/vec2(25.0)))+(vec2(dot(l9_49.xy,vec2(1.0,0.0039215689)),dot(l9_49.zw,vec2(1.0,0.0039215689)))/vec2(25.0)),vec2(0.0),vec2(0.99998999));
}
vec4 blur_x()
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
vec4 l9_1=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_0,blurCoordinates[0],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_2;
#if (mainTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_2,blurCoordinates[1],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_4;
#if (mainTextureHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_4,blurCoordinates[2],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_6;
#if (mainTextureHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
vec4 l9_7=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_6,blurCoordinates[3],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_8;
#if (mainTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_8,blurCoordinates[4],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_10;
#if (mainTextureHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_10,blurCoordinates[5],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_12;
#if (mainTextureHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
vec4 l9_13=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_12,blurCoordinates[6],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_14;
#if (mainTextureHasSwappedViews)
{
l9_14=1-sc_GetStereoViewIndex();
}
#else
{
l9_14=sc_GetStereoViewIndex();
}
#endif
vec4 l9_15=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_14,blurCoordinates[7],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_16;
#if (mainTextureHasSwappedViews)
{
l9_16=1-sc_GetStereoViewIndex();
}
#else
{
l9_16=sc_GetStereoViewIndex();
}
#endif
vec4 l9_17=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_16,blurCoordinates[8],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_18;
#if (mainTextureHasSwappedViews)
{
l9_18=1-sc_GetStereoViewIndex();
}
#else
{
l9_18=sc_GetStereoViewIndex();
}
#endif
vec4 l9_19=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_18,blurCoordinates[9],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_20;
#if (mainTextureHasSwappedViews)
{
l9_20=1-sc_GetStereoViewIndex();
}
#else
{
l9_20=sc_GetStereoViewIndex();
}
#endif
vec4 l9_21=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_20,blurCoordinates[10],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_22;
#if (mainTextureHasSwappedViews)
{
l9_22=1-sc_GetStereoViewIndex();
}
#else
{
l9_22=sc_GetStereoViewIndex();
}
#endif
vec4 l9_23=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_22,blurCoordinates[11],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_24;
#if (mainTextureHasSwappedViews)
{
l9_24=1-sc_GetStereoViewIndex();
}
#else
{
l9_24=sc_GetStereoViewIndex();
}
#endif
vec4 l9_25=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_24,blurCoordinates[12],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_26;
#if (mainTextureHasSwappedViews)
{
l9_26=1-sc_GetStereoViewIndex();
}
#else
{
l9_26=sc_GetStereoViewIndex();
}
#endif
vec4 l9_27=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_26,blurCoordinates[13],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_28;
#if (mainTextureHasSwappedViews)
{
l9_28=1-sc_GetStereoViewIndex();
}
#else
{
l9_28=sc_GetStereoViewIndex();
}
#endif
vec4 l9_29=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_28,blurCoordinates[14],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_30;
#if (mainTextureHasSwappedViews)
{
l9_30=1-sc_GetStereoViewIndex();
}
#else
{
l9_30=sc_GetStereoViewIndex();
}
#endif
vec4 l9_31=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_30,blurCoordinates[15],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_32;
#if (mainTextureHasSwappedViews)
{
l9_32=1-sc_GetStereoViewIndex();
}
#else
{
l9_32=sc_GetStereoViewIndex();
}
#endif
vec4 l9_33=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_32,blurCoordinates[16],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_34;
#if (mainTextureHasSwappedViews)
{
l9_34=1-sc_GetStereoViewIndex();
}
#else
{
l9_34=sc_GetStereoViewIndex();
}
#endif
vec4 l9_35=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_34,blurCoordinates[17],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_36;
#if (mainTextureHasSwappedViews)
{
l9_36=1-sc_GetStereoViewIndex();
}
#else
{
l9_36=sc_GetStereoViewIndex();
}
#endif
vec4 l9_37=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_36,blurCoordinates[18],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_38;
#if (mainTextureHasSwappedViews)
{
l9_38=1-sc_GetStereoViewIndex();
}
#else
{
l9_38=sc_GetStereoViewIndex();
}
#endif
vec4 l9_39=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_38,blurCoordinates[19],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_40;
#if (mainTextureHasSwappedViews)
{
l9_40=1-sc_GetStereoViewIndex();
}
#else
{
l9_40=sc_GetStereoViewIndex();
}
#endif
vec4 l9_41=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_40,blurCoordinates[20],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_42;
#if (mainTextureHasSwappedViews)
{
l9_42=1-sc_GetStereoViewIndex();
}
#else
{
l9_42=sc_GetStereoViewIndex();
}
#endif
vec4 l9_43=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_42,blurCoordinates[21],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_44;
#if (mainTextureHasSwappedViews)
{
l9_44=1-sc_GetStereoViewIndex();
}
#else
{
l9_44=sc_GetStereoViewIndex();
}
#endif
vec4 l9_45=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_44,blurCoordinates[22],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_46;
#if (mainTextureHasSwappedViews)
{
l9_46=1-sc_GetStereoViewIndex();
}
#else
{
l9_46=sc_GetStereoViewIndex();
}
#endif
vec4 l9_47=sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_46,blurCoordinates[23],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture);
int l9_48;
#if (mainTextureHasSwappedViews)
{
l9_48=1-sc_GetStereoViewIndex();
}
#else
{
l9_48=sc_GetStereoViewIndex();
}
#endif
return clamp(((((((((((((((((((((((((l9_1/vec4(25.0))+(l9_3/vec4(25.0)))+(l9_5/vec4(25.0)))+(l9_7/vec4(25.0)))+(l9_9/vec4(25.0)))+(l9_11/vec4(25.0)))+(l9_13/vec4(25.0)))+(l9_15/vec4(25.0)))+(l9_17/vec4(25.0)))+(l9_19/vec4(25.0)))+(l9_21/vec4(25.0)))+(l9_23/vec4(25.0)))+(l9_25/vec4(25.0)))+(l9_27/vec4(25.0)))+(l9_29/vec4(25.0)))+(l9_31/vec4(25.0)))+(l9_33/vec4(25.0)))+(l9_35/vec4(25.0)))+(l9_37/vec4(25.0)))+(l9_39/vec4(25.0)))+(l9_41/vec4(25.0)))+(l9_43/vec4(25.0)))+(l9_45/vec4(25.0)))+(l9_47/vec4(25.0)))+(sc_SampleTextureBiasOrLevel(mainTextureDims.xy,mainTextureLayout,l9_48,blurCoordinates[24],(int(SC_USE_UV_TRANSFORM_mainTexture)!=0),mainTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_mainTexture,SC_SOFTWARE_WRAP_MODE_V_mainTexture),(int(SC_USE_UV_MIN_MAX_mainTexture)!=0),mainTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_mainTexture)!=0),mainTextureBorderColor,0.0,mainTexture)/vec4(25.0)),vec4(0.0),vec4(0.99998999));
}
void main()
{
sc_DiscardStereoFragment();
vec4 l9_0;
#if (DEPTH_BLUR)
{
vec2 l9_1=blur_x_depth();
vec2 l9_2=fract(vec2(1.0,255.0)*l9_1.x);
float l9_3=l9_2.y;
vec2 l9_4=fract(vec2(1.0,255.0)*l9_1.y);
float l9_5=l9_4.y;
l9_0=vec4(l9_2.x-(l9_3/255.0),l9_3,l9_4.x-(l9_5/255.0),l9_5);
}
#else
{
l9_0=blur_x();
}
#endif
sc_writeFragData0(l9_0);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
