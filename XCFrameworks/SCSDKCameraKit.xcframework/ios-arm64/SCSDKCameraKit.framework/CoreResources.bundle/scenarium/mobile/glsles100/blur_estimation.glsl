#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTextureSmpSC 2:3
//sampler sampler maskTextureSmpSC 2:4
//sampler sampler originalTextureSmpSC 2:5
//texture texture2D inputTexture 2:0:2:3
//texture texture2D maskTexture 2:1:2:4
//texture texture2D originalTexture 2:2:2:5
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef KERNEL_SIZE
#define KERNEL_SIZE 13
#endif
uniform vec4 inputTextureSize;
uniform vec2 blurDir;
uniform vec3 offset;
varying vec2 blurCoordinates[((KERNEL_SIZE/2)+1)];
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
vec2 l9_3=inputTextureSize.zw*blurDir;
blurCoordinates[0]=varPackedTex.xy;
vec2 l9_4=l9_3*offset.x;
blurCoordinates[1]=varPackedTex.xy+l9_4;
blurCoordinates[2]=varPackedTex.xy-l9_4;
vec2 l9_5=l9_3*offset.y;
blurCoordinates[3]=varPackedTex.xy+l9_5;
blurCoordinates[4]=varPackedTex.xy-l9_5;
vec2 l9_6=l9_3*offset.z;
blurCoordinates[5]=varPackedTex.xy+l9_6;
blurCoordinates[6]=varPackedTex.xy-l9_6;
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef originalTextureHasSwappedViews
#define originalTextureHasSwappedViews 0
#elif originalTextureHasSwappedViews==1
#undef originalTextureHasSwappedViews
#define originalTextureHasSwappedViews 1
#endif
#ifndef originalTextureLayout
#define originalTextureLayout 0
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
#ifndef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 0
#elif maskTextureHasSwappedViews==1
#undef maskTextureHasSwappedViews
#define maskTextureHasSwappedViews 1
#endif
#ifndef maskTextureLayout
#define maskTextureLayout 0
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
#ifndef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 0
#elif SC_USE_UV_TRANSFORM_maskTexture==1
#undef SC_USE_UV_TRANSFORM_maskTexture
#define SC_USE_UV_TRANSFORM_maskTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_maskTexture
#define SC_SOFTWARE_WRAP_MODE_U_maskTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_maskTexture
#define SC_SOFTWARE_WRAP_MODE_V_maskTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 0
#elif SC_USE_UV_MIN_MAX_maskTexture==1
#undef SC_USE_UV_MIN_MAX_maskTexture
#define SC_USE_UV_MIN_MAX_maskTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 0
#elif SC_USE_CLAMP_TO_BORDER_maskTexture==1
#undef SC_USE_CLAMP_TO_BORDER_maskTexture
#define SC_USE_CLAMP_TO_BORDER_maskTexture 1
#endif
#ifndef KERNEL_SIZE
#define KERNEL_SIZE 13
#endif
#ifndef BLUR_ESTIMATION_FIRST_PASS
#define BLUR_ESTIMATION_FIRST_PASS 0
#elif BLUR_ESTIMATION_FIRST_PASS==1
#undef BLUR_ESTIMATION_FIRST_PASS
#define BLUR_ESTIMATION_FIRST_PASS 1
#endif
#ifndef SC_USE_UV_TRANSFORM_originalTexture
#define SC_USE_UV_TRANSFORM_originalTexture 0
#elif SC_USE_UV_TRANSFORM_originalTexture==1
#undef SC_USE_UV_TRANSFORM_originalTexture
#define SC_USE_UV_TRANSFORM_originalTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_originalTexture
#define SC_SOFTWARE_WRAP_MODE_U_originalTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_originalTexture
#define SC_SOFTWARE_WRAP_MODE_V_originalTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_originalTexture
#define SC_USE_UV_MIN_MAX_originalTexture 0
#elif SC_USE_UV_MIN_MAX_originalTexture==1
#undef SC_USE_UV_MIN_MAX_originalTexture
#define SC_USE_UV_MIN_MAX_originalTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_originalTexture
#define SC_USE_CLAMP_TO_BORDER_originalTexture 0
#elif SC_USE_CLAMP_TO_BORDER_originalTexture==1
#undef SC_USE_CLAMP_TO_BORDER_originalTexture
#define SC_USE_CLAMP_TO_BORDER_originalTexture 1
#endif
uniform vec4 originalTextureDims;
uniform vec4 inputTextureDims;
uniform vec4 maskTextureDims;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform vec4 weight;
uniform mat3 originalTextureTransform;
uniform vec4 originalTextureUvMinMax;
uniform vec4 originalTextureBorderColor;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2D originalTexture;
varying vec2 blurCoordinates[((KERNEL_SIZE/2)+1)];
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (inputTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_0,blurCoordinates[0],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_2;
#if (inputTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_2,blurCoordinates[1],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
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
vec4 l9_5=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_4,blurCoordinates[2],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_6;
#if (inputTextureHasSwappedViews)
{
l9_6=1-sc_GetStereoViewIndex();
}
#else
{
l9_6=sc_GetStereoViewIndex();
}
#endif
vec4 l9_7=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_6,blurCoordinates[3],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_8;
#if (inputTextureHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_8,blurCoordinates[4],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_10;
#if (inputTextureHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_10,blurCoordinates[5],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
int l9_12;
#if (inputTextureHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
vec4 l9_13=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_12,blurCoordinates[6],(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
vec4 l9_14=(((l9_1*weight.x)+((l9_3+l9_5)*weight.y))+((l9_7+l9_9)*weight.z))+((l9_11+l9_13)*weight.w);
int l9_15;
#if (maskTextureHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
vec4 l9_16=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_15,blurCoordinates[0],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_17;
#if (maskTextureHasSwappedViews)
{
l9_17=1-sc_GetStereoViewIndex();
}
#else
{
l9_17=sc_GetStereoViewIndex();
}
#endif
vec4 l9_18=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_17,blurCoordinates[1],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_19;
#if (maskTextureHasSwappedViews)
{
l9_19=1-sc_GetStereoViewIndex();
}
#else
{
l9_19=sc_GetStereoViewIndex();
}
#endif
vec4 l9_20=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_19,blurCoordinates[2],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_21;
#if (maskTextureHasSwappedViews)
{
l9_21=1-sc_GetStereoViewIndex();
}
#else
{
l9_21=sc_GetStereoViewIndex();
}
#endif
vec4 l9_22=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_21,blurCoordinates[3],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_23;
#if (maskTextureHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
vec4 l9_24=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_23,blurCoordinates[4],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_25;
#if (maskTextureHasSwappedViews)
{
l9_25=1-sc_GetStereoViewIndex();
}
#else
{
l9_25=sc_GetStereoViewIndex();
}
#endif
vec4 l9_26=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_25,blurCoordinates[5],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
int l9_27;
#if (maskTextureHasSwappedViews)
{
l9_27=1-sc_GetStereoViewIndex();
}
#else
{
l9_27=sc_GetStereoViewIndex();
}
#endif
vec4 l9_28=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_27,blurCoordinates[6],(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
float l9_29=(((weight.x*l9_16.x)+(weight.y*(l9_18.x+l9_20.x)))+(weight.z*(l9_22.x+l9_24.x)))+(weight.w*(l9_26.x+l9_28.x));
#if (BLUR_ESTIMATION_FIRST_PASS)
{
sc_writeFragData0(l9_14);
sc_writeFragData1(vec4(l9_29));
}
#else
{
int l9_30;
#if (originalTextureHasSwappedViews)
{
l9_30=1-sc_GetStereoViewIndex();
}
#else
{
l9_30=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(mix(sc_SampleTextureBiasOrLevel(originalTextureDims.xy,originalTextureLayout,l9_30,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_originalTexture)!=0),originalTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_originalTexture,SC_SOFTWARE_WRAP_MODE_V_originalTexture),(int(SC_USE_UV_MIN_MAX_originalTexture)!=0),originalTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_originalTexture)!=0),originalTextureBorderColor,0.0,originalTexture),l9_14,vec4(l9_29)));
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
