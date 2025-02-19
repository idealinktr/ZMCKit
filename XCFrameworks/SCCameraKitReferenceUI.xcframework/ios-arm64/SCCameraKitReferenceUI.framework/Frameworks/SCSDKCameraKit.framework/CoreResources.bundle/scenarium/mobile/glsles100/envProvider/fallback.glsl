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
uniform mat4 script_modelMatrix;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(vec4(((texture0*1.002)*2.0)-vec2(1.0),0.0,1.0),normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz),l9_0.tangent,l9_0.texture0,l9_0.texture1));
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
uniform mat4 script_modelMatrix;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mediump sampler2D baseTex;
vec2 calculateEnvmapScreenToCube(vec3 V)
{
V.y=-V.y;
V.z=abs(V.z);
vec3 l9_0=V;
vec3 l9_1=abs(l9_0);
float l9_2=l9_1.z;
float l9_3=l9_1.x;
bool l9_4=l9_2>=l9_3;
bool l9_5;
if (l9_4)
{
l9_5=l9_2>=l9_1.y;
}
else
{
l9_5=l9_4;
}
vec2 l9_6;
if (l9_5)
{
l9_6=((vec2(V.x,V.y)*(0.5/l9_2))*0.5)+vec2(0.5);
}
else
{
float l9_7=l9_1.y;
vec2 l9_8;
if (l9_7>=l9_3)
{
float l9_9=V.x;
float l9_10=V.z;
vec2 l9_11=vec2(l9_9,-l9_10)*(0.5/l9_7);
float l9_12=l9_11.y;
float l9_13=l9_12*0.5;
float l9_14=abs(l9_13);
vec2 l9_15=vec2((l9_11.x*mix(0.5,1.0,1.0-(abs(l9_12)*2.0)))+0.5,l9_13);
l9_15.y=l9_14;
vec2 l9_16;
if (V.y>0.0)
{
vec2 l9_17=l9_15;
l9_17.y=1.0-l9_14;
l9_16=l9_17;
}
else
{
l9_16=l9_15;
}
l9_8=l9_16;
}
else
{
float l9_18;
if (V.x<0.0)
{
l9_18=V.z;
}
else
{
l9_18=-V.z;
}
float l9_19=V.y;
vec2 l9_20=vec2(l9_18,l9_19);
vec2 l9_21=l9_20*(0.5/l9_3);
float l9_22=l9_21.x;
float l9_23=l9_22*0.5;
float l9_24=abs(l9_23);
vec2 l9_25=vec2(l9_23,(l9_21.y*mix(0.5,1.0,1.0-(abs(l9_22)*2.0)))+0.5);
l9_25.x=l9_24;
vec2 l9_26;
if (V.x>0.0)
{
vec2 l9_27=l9_25;
l9_27.x=1.0-l9_24;
l9_26=l9_27;
}
else
{
l9_26=l9_25;
}
l9_8=l9_26;
}
l9_6=l9_8;
}
return l9_6;
}
void main()
{
vec2 l9_0=calculateEnvmapScreenToCube(-varNormal);
int l9_1;
#if (baseTexHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
vec4 l9_2=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_1,clamp(vec2((baseTexTransform*vec3(l9_0,1.0)).xy),vec2(0.0020000001),vec2(0.99800003)),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
l9_2.w=1.0;
sc_writeFragData0(l9_2);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
