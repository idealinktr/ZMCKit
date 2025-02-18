#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler cameraTextureSmpSC 2:1
//texture texture2D cameraTexture 2:0:2:1
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 cameraTextureDims;
uniform mat3 cameraTextureTransform;
uniform vec4 leftSampleOffsetSize;
uniform vec4 rightSampleOffsetSize;
uniform vec4 cameraTextureSize;
uniform vec4 cameraTextureView;
uniform vec4 cameraTextureUvMinMax;
uniform vec4 cameraTextureBorderColor;
varying float varLerp;
varying vec2 varLeftSampleCoord;
varying vec2 varRightSampleCoord;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=l9_0.texture0;
mat3 l9_2=cameraTextureTransform;
l9_2[0].x=cameraTextureTransform[0].x*leftSampleOffsetSize.z;
mat3 l9_3=l9_2;
l9_3[1].y=cameraTextureTransform[1].y*leftSampleOffsetSize.w;
mat3 l9_4=cameraTextureTransform;
l9_4[0].x=cameraTextureTransform[0].x*rightSampleOffsetSize.z;
mat3 l9_5=l9_4;
l9_5[1].y=cameraTextureTransform[1].y*rightSampleOffsetSize.w;
vec3 l9_6=vec3((l9_1*vec2(2.0))-vec2(1.0),1.0);
varLerp=1.0-l9_1.x;
varLeftSampleCoord=(((l9_6*l9_3).xy+leftSampleOffsetSize.xy)*0.5)+vec2(0.5);
varRightSampleCoord=(((l9_6*l9_5).xy+rightSampleOffsetSize.xy)*0.5)+vec2(0.5);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef cameraTextureHasSwappedViews
#define cameraTextureHasSwappedViews 0
#elif cameraTextureHasSwappedViews==1
#undef cameraTextureHasSwappedViews
#define cameraTextureHasSwappedViews 1
#endif
#ifndef cameraTextureLayout
#define cameraTextureLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_cameraTexture
#define SC_SOFTWARE_WRAP_MODE_U_cameraTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_cameraTexture
#define SC_SOFTWARE_WRAP_MODE_V_cameraTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_cameraTexture
#define SC_USE_UV_MIN_MAX_cameraTexture 0
#elif SC_USE_UV_MIN_MAX_cameraTexture==1
#undef SC_USE_UV_MIN_MAX_cameraTexture
#define SC_USE_UV_MIN_MAX_cameraTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_cameraTexture
#define SC_USE_CLAMP_TO_BORDER_cameraTexture 0
#elif SC_USE_CLAMP_TO_BORDER_cameraTexture==1
#undef SC_USE_CLAMP_TO_BORDER_cameraTexture
#define SC_USE_CLAMP_TO_BORDER_cameraTexture 1
#endif
uniform vec4 cameraTextureDims;
uniform vec4 cameraTextureUvMinMax;
uniform vec4 cameraTextureBorderColor;
uniform vec4 cameraTextureSize;
uniform vec4 cameraTextureView;
uniform mat3 cameraTextureTransform;
uniform vec4 leftSampleOffsetSize;
uniform vec4 rightSampleOffsetSize;
uniform mediump sampler2D cameraTexture;
varying vec2 varLeftSampleCoord;
varying vec2 varRightSampleCoord;
varying float varLerp;
void main()
{
sc_DiscardStereoFragment();
int l9_0;
#if (cameraTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(cameraTextureDims.xy,cameraTextureLayout,l9_0,varLeftSampleCoord,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_cameraTexture,SC_SOFTWARE_WRAP_MODE_V_cameraTexture),(int(SC_USE_UV_MIN_MAX_cameraTexture)!=0),cameraTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_cameraTexture)!=0),cameraTextureBorderColor,0.0,cameraTexture);
int l9_2;
#if (cameraTextureHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(vec4(mix(l9_1.xyz,sc_SampleTextureBiasOrLevel(cameraTextureDims.xy,cameraTextureLayout,l9_2,varRightSampleCoord,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_cameraTexture,SC_SOFTWARE_WRAP_MODE_V_cameraTexture),(int(SC_USE_UV_MIN_MAX_cameraTexture)!=0),cameraTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_cameraTexture)!=0),cameraTextureBorderColor,0.0,cameraTexture).xyz,vec3(varLerp)),1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
