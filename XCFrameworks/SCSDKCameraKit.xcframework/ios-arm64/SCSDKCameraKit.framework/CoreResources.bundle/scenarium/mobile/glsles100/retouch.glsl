#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler lookupTextureSmpSC 2:2
//sampler sampler maskTextureSmpSC 2:3
//texture texture2D lookupTexture 2:0:2:2
//texture texture2D maskTexture 2:1:2:3
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef SOFT_SKIN
#define SOFT_SKIN 0
#elif SOFT_SKIN==1
#undef SOFT_SKIN
#define SOFT_SKIN 1
#endif
#ifndef EYE_SHARPEN
#define EYE_SHARPEN 0
#elif EYE_SHARPEN==1
#undef EYE_SHARPEN
#define EYE_SHARPEN 1
#endif
uniform vec4 lookupTextureDims;
uniform vec4 maskTextureDims;
uniform vec4 lookupTextureSize;
uniform vec4 lookupTextureView;
uniform mat3 lookupTextureTransform;
uniform vec4 lookupTextureUvMinMax;
uniform vec4 lookupTextureBorderColor;
uniform vec4 maskTextureSize;
uniform vec4 maskTextureView;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform float softSkinRadius;
uniform float softSkinIntensity;
uniform float teethWhiteningIntensity;
uniform float eyeWhiteningIntensity;
uniform float sharpenEyeIntensity;
varying vec4 varCustomTex0;
varying vec4 varCustomTex1;
varying vec4 varCustomTex2;
varying vec4 varCustomTex3;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
#if (SOFT_SKIN)
{
vec2 l9_3=varPackedTex.xy+vec2(-0.0069444398,-0.00390625);
varCustomTex0=vec4(l9_3.x,l9_3.y,varCustomTex0.z,varCustomTex0.w);
vec2 l9_4=varPackedTex.xy+vec2(-0.0069444398,0.0054687499);
varCustomTex1=vec4(l9_4.x,l9_4.y,varCustomTex1.z,varCustomTex1.w);
vec2 l9_5=varPackedTex.xy+vec2(0.0097222198,-0.00390625);
varCustomTex2=vec4(l9_5.x,l9_5.y,varCustomTex2.z,varCustomTex2.w);
vec2 l9_6=varPackedTex.xy+vec2(0.0097222198,0.0054687499);
varCustomTex3=vec4(l9_6.x,l9_6.y,varCustomTex3.z,varCustomTex3.w);
}
#endif
#if (EYE_SHARPEN)
{
float l9_7=sc_Camera.aspect/1280.0;
float l9_8=-l9_7;
vec2 l9_9=varPackedTex.xy+vec2(l9_8,-0.00078125001);
varCustomTex0=vec4(varCustomTex0.x,varCustomTex0.y,l9_9.x,l9_9.y);
vec2 l9_10=varPackedTex.xy+vec2(l9_7,-0.00078125001);
varCustomTex1=vec4(varCustomTex1.x,varCustomTex1.y,l9_10.x,l9_10.y);
vec2 l9_11=varPackedTex.xy+vec2(l9_8,0.00078125001);
varCustomTex2=vec4(varCustomTex2.x,varCustomTex2.y,l9_11.x,l9_11.y);
vec2 l9_12=varPackedTex.xy+vec2(l9_7,0.00078125001);
varCustomTex3=vec4(varCustomTex3.x,varCustomTex3.y,l9_12.x,l9_12.y);
}
#endif
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef lookupTextureHasSwappedViews
#define lookupTextureHasSwappedViews 0
#elif lookupTextureHasSwappedViews==1
#undef lookupTextureHasSwappedViews
#define lookupTextureHasSwappedViews 1
#endif
#ifndef lookupTextureLayout
#define lookupTextureLayout 0
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
#ifndef IS_LEGACY_LOOKUP
#define IS_LEGACY_LOOKUP 0
#elif IS_LEGACY_LOOKUP==1
#undef IS_LEGACY_LOOKUP
#define IS_LEGACY_LOOKUP 1
#endif
#ifndef SC_USE_UV_TRANSFORM_lookupTexture
#define SC_USE_UV_TRANSFORM_lookupTexture 0
#elif SC_USE_UV_TRANSFORM_lookupTexture==1
#undef SC_USE_UV_TRANSFORM_lookupTexture
#define SC_USE_UV_TRANSFORM_lookupTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_lookupTexture
#define SC_SOFTWARE_WRAP_MODE_U_lookupTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_lookupTexture
#define SC_SOFTWARE_WRAP_MODE_V_lookupTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_lookupTexture
#define SC_USE_UV_MIN_MAX_lookupTexture 0
#elif SC_USE_UV_MIN_MAX_lookupTexture==1
#undef SC_USE_UV_MIN_MAX_lookupTexture
#define SC_USE_UV_MIN_MAX_lookupTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_lookupTexture
#define SC_USE_CLAMP_TO_BORDER_lookupTexture 0
#elif SC_USE_CLAMP_TO_BORDER_lookupTexture==1
#undef SC_USE_CLAMP_TO_BORDER_lookupTexture
#define SC_USE_CLAMP_TO_BORDER_lookupTexture 1
#endif
#ifndef ADD_NOISE
#define ADD_NOISE 1
#elif ADD_NOISE==1
#undef ADD_NOISE
#define ADD_NOISE 1
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
#ifndef SOFT_SKIN
#define SOFT_SKIN 0
#elif SOFT_SKIN==1
#undef SOFT_SKIN
#define SOFT_SKIN 1
#endif
#ifndef EYE_SHARPEN
#define EYE_SHARPEN 0
#elif EYE_SHARPEN==1
#undef EYE_SHARPEN
#define EYE_SHARPEN 1
#endif
#ifndef EYE_WHITENING
#define EYE_WHITENING 0
#elif EYE_WHITENING==1
#undef EYE_WHITENING
#define EYE_WHITENING 1
#endif
#ifndef TEETH_WHITENING
#define TEETH_WHITENING 0
#elif TEETH_WHITENING==1
#undef TEETH_WHITENING
#define TEETH_WHITENING 1
#endif
uniform vec4 lookupTextureDims;
uniform vec4 maskTextureDims;
uniform mat3 lookupTextureTransform;
uniform vec4 lookupTextureUvMinMax;
uniform vec4 lookupTextureBorderColor;
uniform float softSkinRadius;
uniform mat3 maskTextureTransform;
uniform vec4 maskTextureUvMinMax;
uniform vec4 maskTextureBorderColor;
uniform float softSkinIntensity;
uniform float sharpenEyeIntensity;
uniform float eyeWhiteningIntensity;
uniform float teethWhiteningIntensity;
uniform vec4 lookupTextureSize;
uniform vec4 lookupTextureView;
uniform vec4 maskTextureSize;
uniform vec4 maskTextureView;
uniform mediump sampler2D maskTexture;
uniform mediump sampler2D lookupTexture;
varying vec4 varCustomTex0;
varying vec4 varCustomTex1;
varying vec4 varCustomTex2;
varying vec4 varCustomTex3;
vec4 softSkin(vec4 originalColor,float factor)
{
vec4 l9_0=originalColor;
vec4 l9_1=sc_ScreenTextureSampleView(varCustomTex0.xy);
vec4 l9_2=sc_ScreenTextureSampleView(varCustomTex1.xy);
vec4 l9_3=sc_ScreenTextureSampleView(varCustomTex2.xy);
vec4 l9_4=sc_ScreenTextureSampleView(varCustomTex3.xy);
mat4 l9_5=mat4(l9_1,l9_2,l9_3,l9_4);
vec4 l9_6=log((vec4(0.29899999,0.58700001,0.114,0.0)*l9_5)/vec4(dot(l9_0,vec4(0.29899999,0.58700001,0.114,0.0))+1e-06));
vec4 l9_7=exp((l9_6*l9_6)*((-1.0)/((2.0*softSkinRadius)*softSkinRadius)))*0.36787945;
float l9_8=1.0+dot(l9_7,vec4(1.0));
vec4 l9_9=l9_0+(l9_5*l9_7);
vec4 l9_10;
#if (ADD_NOISE)
{
float l9_11=(fract(sin(dot(varPackedTex.xy,vec2(12.9898,78.233002)))*43758.547)-0.5)/30.0;
l9_10=(l9_9/vec4(l9_8))+vec4(l9_11,l9_11,l9_11,1.0);
}
#else
{
l9_10=l9_9/vec4(l9_8);
}
#endif
return mix(originalColor,l9_10,vec4(factor));
}
vec3 mapColor(vec3 orgColor)
{
float l9_0;
vec2 l9_1;
vec4 l9_2;
#if (IS_LEGACY_LOOKUP)
{
float l9_3=(orgColor.z*255.0)/4.0;
vec2 l9_4=clamp(vec2(floor(l9_3))+vec2(0.0,1.0),vec2(0.0),vec2(63.0));
vec2 l9_5=floor((l9_4/vec2(8.0))+vec2(1e-06));
vec4 l9_6=((orgColor.yyxx*0.12304688)+(vec4(l9_5,l9_4-(l9_5*8.0))*0.125))+vec4(0.0009765625);
vec2 l9_7=vec2(l9_6.z,1.0-l9_6.x);
vec2 l9_8=vec2(l9_6.w,1.0-l9_6.y);
l9_2=vec4(l9_7.x,l9_7.y,l9_8.x,l9_8.y);
l9_1=l9_4;
l9_0=l9_3;
}
#else
{
float l9_9=orgColor.z*15.0;
vec2 l9_10=clamp(vec2(floor(l9_9))+vec2(0.0,1.0),vec2(0.0),vec2(15.0));
vec3 l9_11=((orgColor.xxy*vec3(0.05859375,0.05859375,0.9375))+vec3(l9_10*0.0625,0.0))+vec3(0.001953125,0.001953125,0.03125);
l9_2=vec4(l9_11.x,l9_11.z,l9_11.y,l9_11.z);
l9_1=l9_10;
l9_0=l9_9;
}
#endif
float l9_12=l9_0-l9_1.x;
int l9_13;
#if (lookupTextureHasSwappedViews)
{
l9_13=1-sc_GetStereoViewIndex();
}
#else
{
l9_13=sc_GetStereoViewIndex();
}
#endif
vec4 l9_14=sc_SampleTextureBiasOrLevel(lookupTextureDims.xy,lookupTextureLayout,l9_13,l9_2.xy,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTexture);
int l9_15;
#if (lookupTextureHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
return mix(l9_14.xyz,sc_SampleTextureBiasOrLevel(lookupTextureDims.xy,lookupTextureLayout,l9_15,l9_2.zw,(int(SC_USE_UV_TRANSFORM_lookupTexture)!=0),lookupTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_lookupTexture,SC_SOFTWARE_WRAP_MODE_V_lookupTexture),(int(SC_USE_UV_MIN_MAX_lookupTexture)!=0),lookupTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_lookupTexture)!=0),lookupTextureBorderColor,0.0,lookupTexture).xyz,vec3(l9_12));
}
void main()
{
sc_DiscardStereoFragment();
vec4 l9_0=getFramebufferColor();
int l9_1;
#if (maskTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
vec4 l9_2=sc_SampleTextureBiasOrLevel(maskTextureDims.xy,maskTextureLayout,l9_1,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_maskTexture)!=0),maskTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_maskTexture,SC_SOFTWARE_WRAP_MODE_V_maskTexture),(int(SC_USE_UV_MIN_MAX_maskTexture)!=0),maskTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_maskTexture)!=0),maskTextureBorderColor,0.0,maskTexture);
vec4 l9_3;
#if (SOFT_SKIN)
{
l9_3=softSkin(l9_0,l9_2.x*softSkinIntensity);
}
#else
{
l9_3=l9_0;
}
#endif
vec4 l9_4;
#if (EYE_SHARPEN)
{
l9_4=clamp(mix(l9_3,((((l9_3*5.0)-sc_ScreenTextureSampleView(varCustomTex0.zw))-sc_ScreenTextureSampleView(varCustomTex1.zw))-sc_ScreenTextureSampleView(varCustomTex2.zw))-sc_ScreenTextureSampleView(varCustomTex3.zw),vec4(l9_2.z*sharpenEyeIntensity)),vec4(0.0),vec4(1.0));
}
#else
{
l9_4=l9_3;
}
#endif
float l9_5;
#if (EYE_WHITENING)
{
l9_5=0.0+(l9_2.z*eyeWhiteningIntensity);
}
#else
{
l9_5=0.0;
}
#endif
float l9_6;
#if (TEETH_WHITENING)
{
l9_6=l9_5+(l9_2.y*teethWhiteningIntensity);
}
#else
{
l9_6=l9_5;
}
#endif
vec4 l9_7;
#if (EYE_WHITENING||TEETH_WHITENING)
{
l9_7=mix(l9_4,vec4(mapColor(l9_4.xyz),l9_4.w),vec4(l9_6));
}
#else
{
l9_7=l9_4;
}
#endif
sc_writeFragData0(l9_7);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
