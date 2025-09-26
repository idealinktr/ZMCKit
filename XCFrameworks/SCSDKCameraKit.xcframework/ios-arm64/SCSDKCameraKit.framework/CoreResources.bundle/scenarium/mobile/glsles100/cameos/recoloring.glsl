#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler alphaTextureSmpSC 2:2
//sampler sampler assetTextureSmpSC 2:3
//texture texture2D alphaTexture 2:0:2:2
//texture texture2D assetTexture 2:1:2:3
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform mat4 modelView;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(modelView*l9_0.position,l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef assetTextureHasSwappedViews
#define assetTextureHasSwappedViews 0
#elif assetTextureHasSwappedViews==1
#undef assetTextureHasSwappedViews
#define assetTextureHasSwappedViews 1
#endif
#ifndef assetTextureLayout
#define assetTextureLayout 0
#endif
#ifndef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 0
#elif alphaTextureHasSwappedViews==1
#undef alphaTextureHasSwappedViews
#define alphaTextureHasSwappedViews 1
#endif
#ifndef alphaTextureLayout
#define alphaTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_assetTexture
#define SC_USE_UV_TRANSFORM_assetTexture 0
#elif SC_USE_UV_TRANSFORM_assetTexture==1
#undef SC_USE_UV_TRANSFORM_assetTexture
#define SC_USE_UV_TRANSFORM_assetTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_assetTexture
#define SC_SOFTWARE_WRAP_MODE_U_assetTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_assetTexture
#define SC_SOFTWARE_WRAP_MODE_V_assetTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_assetTexture
#define SC_USE_UV_MIN_MAX_assetTexture 0
#elif SC_USE_UV_MIN_MAX_assetTexture==1
#undef SC_USE_UV_MIN_MAX_assetTexture
#define SC_USE_UV_MIN_MAX_assetTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_assetTexture
#define SC_USE_CLAMP_TO_BORDER_assetTexture 0
#elif SC_USE_CLAMP_TO_BORDER_assetTexture==1
#undef SC_USE_CLAMP_TO_BORDER_assetTexture
#define SC_USE_CLAMP_TO_BORDER_assetTexture 1
#endif
#ifndef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 0
#elif SC_USE_UV_TRANSFORM_alphaTexture==1
#undef SC_USE_UV_TRANSFORM_alphaTexture
#define SC_USE_UV_TRANSFORM_alphaTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_U_alphaTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_alphaTexture
#define SC_SOFTWARE_WRAP_MODE_V_alphaTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 0
#elif SC_USE_UV_MIN_MAX_alphaTexture==1
#undef SC_USE_UV_MIN_MAX_alphaTexture
#define SC_USE_UV_MIN_MAX_alphaTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 0
#elif SC_USE_CLAMP_TO_BORDER_alphaTexture==1
#undef SC_USE_CLAMP_TO_BORDER_alphaTexture
#define SC_USE_CLAMP_TO_BORDER_alphaTexture 1
#endif
uniform vec4 assetTextureDims;
uniform vec4 alphaTextureDims;
uniform mat3 assetTextureTransform;
uniform vec4 assetTextureUvMinMax;
uniform vec4 assetTextureBorderColor;
uniform mat3 alphaTextureTransform;
uniform vec4 alphaTextureUvMinMax;
uniform vec4 alphaTextureBorderColor;
uniform int alphaChannel;
uniform vec3 bodyMedian;
uniform vec3 deviationRatio;
uniform vec3 faceMedian;
uniform mediump sampler2D assetTexture;
uniform mediump sampler2D alphaTexture;
void main()
{
int l9_0;
#if (assetTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(assetTextureDims.xy,assetTextureLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_assetTexture)!=0),assetTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_assetTexture,SC_SOFTWARE_WRAP_MODE_V_assetTexture),(int(SC_USE_UV_MIN_MAX_assetTexture)!=0),assetTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_assetTexture)!=0),assetTextureBorderColor,0.0,assetTexture);
int l9_2;
#if (alphaTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec3 l9_3=pow(mat3(vec3(0.43395299,0.212671,0.017758001),vec3(0.376219,0.71516001,0.109477),vec3(0.18982799,0.072168998,0.87276602))*pow((l9_1.xyz+vec3(0.055))*0.94786727,vec3(2.4000001)),vec3(0.33333334));
float l9_4=l9_3.y;
vec3 l9_5=vec3(((116.0*l9_4)-16.0)/100.0,((500.0*(l9_3.x-l9_4))+128.0)/255.0,((200.0*(l9_4-l9_3.z))+128.0)/255.0);
vec3 l9_6=mix(l9_5,((l9_5-bodyMedian)*deviationRatio)+faceMedian,vec3(sc_SampleTextureBiasOrLevel(alphaTextureDims.xy,alphaTextureLayout,l9_2,varPackedTex.zw,(int(SC_USE_UV_TRANSFORM_alphaTexture)!=0),alphaTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_alphaTexture,SC_SOFTWARE_WRAP_MODE_V_alphaTexture),(int(SC_USE_UV_MIN_MAX_alphaTexture)!=0),alphaTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_alphaTexture)!=0),alphaTextureBorderColor,0.0,alphaTexture)[alphaChannel]));
float l9_7=((l9_6.x*100.0)+16.0)/116.0;
sc_writeFragData0(vec4((pow(mat3(vec3(3.0799351,-0.92123401,0.052889999),vec3(-1.5371521,1.87599,-0.204041),vec3(-0.54278302,0.045244001,1.151152))*pow(vec3((((l9_6.y*255.0)-128.0)/500.0)+l9_7,l9_7,(((l9_6.z*255.0)-128.0)/(-200.0))+l9_7),vec3(3.0)),vec3(0.41666666))*1.0549999)-vec3(0.055),1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
