#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler baseTexSmpSC 2:1
//texture texture2D baseTex 2:0:2:1
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 baseTexDims;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec3 lightDir;
uniform vec3 skyColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(vec4((texture0*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
varPackedTex=vec4(varPackedTex.x,varPackedTex.y,texture0.x,texture0.y);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 0
#elif SC_USE_UV_TRANSFORM_baseTex==1
#undef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
uniform vec4 baseTexDims;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec3 lightDir;
uniform vec3 skyColor;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mediump sampler2D baseTex;
void main()
{
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
vec3 l9_2=vec4(pow(l9_1.x,2.2),pow(l9_1.y,2.2),pow(l9_1.z,2.2),0.0).xyz;
float l9_3=dot(l9_2,vec3(0.21259999,0.71520001,0.0722));
float l9_4=l9_3+(1.0-max(abs(sign(l9_3)),0.99900001));
float l9_5=pow(2.7179999,l9_4*3.0)/10.0;
vec2 l9_6=((varPackedTex.zw*2.0)-vec2(1.0))*1.5707999;
vec2 l9_7=sin(l9_6);
vec2 l9_8=cos(l9_6);
float l9_9=l9_8.y;
vec3 l9_10=mix(vec4((l9_2*mix(mix(mix((-0.27000001)+max(pow(l9_5,5.8000002),0.0),0.34+max(pow(l9_5,4.0),0.0),step(l9_4,0.81999999)),0.19+max(pow(l9_5,2.3),0.0),step(l9_4,0.64999998)),l9_4*0.64999998,step(l9_4,0.41999999)))/vec3(l9_4),0.0).xyz,skyColor,vec3(0.1*max(0.0,dot(lightDir,vec3(l9_8.x*l9_9,l9_7.x*l9_9,l9_7.y)))));
float l9_11=max(1.0/max(1.0,max(l9_10.x,max(l9_10.y,l9_10.z))),0.0039607845);
sc_writeFragData0(vec4(l9_10.xyz*l9_11,l9_11));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
