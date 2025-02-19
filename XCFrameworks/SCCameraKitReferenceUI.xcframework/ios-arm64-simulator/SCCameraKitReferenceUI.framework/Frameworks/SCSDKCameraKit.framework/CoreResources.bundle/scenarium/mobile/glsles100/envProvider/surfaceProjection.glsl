#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler baseTexSmpSC 2:2
//sampler sampler prevTexSmpSC 2:3
//texture texture2D baseTex 2:0:2:2
//texture texture2D prevTex 2:1:2:3
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 baseTexDims;
uniform vec4 prevTexDims;
uniform mat4 script_modelMatrix;
uniform mat3 prevTexTransform;
uniform mat4 script_viewProjectionMatrix;
uniform vec3 uniSphereCenter;
uniform vec3 uniCameraPos;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec4 prevTexSize;
uniform vec4 prevTexView;
uniform vec4 prevTexUvMinMax;
uniform vec4 prevTexBorderColor;
uniform float stopCapture;
uniform float blendInFactor;
varying vec3 varCustomPos;
varying vec3 varCustomNormal;
varying vec2 varCustomTex0;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=l9_0.texture0;
varCustomPos=(script_modelMatrix*(mat4(vec4(12.0,0.0,0.0,0.0),vec4(0.0,12.0,0.0,0.0),vec4(0.0,0.0,12.0,0.0),vec4(0.0,0.0,0.0,1.0))*(mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0))*l9_0.position))).xyz;
varCustomNormal=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
vec2 l9_2=l9_1*1.002;
varCustomTex0=vec2((prevTexTransform*vec3(l9_2,1.0)).xy);
sc_ProcessVertex(sc_Vertex_t(vec4((l9_2*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_1,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef prevTexHasSwappedViews
#define prevTexHasSwappedViews 0
#elif prevTexHasSwappedViews==1
#undef prevTexHasSwappedViews
#define prevTexHasSwappedViews 1
#endif
#ifndef prevTexLayout
#define prevTexLayout 0
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
#ifndef SC_SOFTWARE_WRAP_MODE_U_prevTex
#define SC_SOFTWARE_WRAP_MODE_U_prevTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_prevTex
#define SC_SOFTWARE_WRAP_MODE_V_prevTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 0
#elif SC_USE_UV_MIN_MAX_prevTex==1
#undef SC_USE_UV_MIN_MAX_prevTex
#define SC_USE_UV_MIN_MAX_prevTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 0
#elif SC_USE_CLAMP_TO_BORDER_prevTex==1
#undef SC_USE_CLAMP_TO_BORDER_prevTex
#define SC_USE_CLAMP_TO_BORDER_prevTex 1
#endif
uniform vec4 baseTexDims;
uniform vec4 prevTexDims;
uniform vec3 uniCameraPos;
uniform vec3 uniSphereCenter;
uniform mat4 script_viewProjectionMatrix;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform float blendInFactor;
uniform float stopCapture;
uniform vec4 prevTexUvMinMax;
uniform vec4 prevTexBorderColor;
uniform mat4 script_modelMatrix;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform vec4 prevTexSize;
uniform vec4 prevTexView;
uniform mat3 prevTexTransform;
uniform mediump sampler2D baseTex;
uniform mediump sampler2D prevTex;
varying vec3 varCustomNormal;
varying vec3 varCustomPos;
varying vec2 varCustomTex0;
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
float l9_0=(varCustomPos.y-0.0)/(varCustomNormal.y+(1.0-max(abs(sign(varCustomNormal.y)),0.99900001)));
float l9_1=step(l9_0,0.0);
float l9_2=max(length(uniCameraPos-uniSphereCenter),100.0);
vec3 l9_3=(varCustomPos+varCustomNormal)-varCustomPos;
float l9_4=dot(l9_3,l9_3);
float l9_5=2.0*dot(l9_3,varCustomPos-uniSphereCenter);
float l9_6=sqrt((l9_5*l9_5)-((4.0*l9_4)*(((dot(uniSphereCenter,uniSphereCenter)+dot(varCustomPos,varCustomPos))-(2.0*dot(uniSphereCenter,varCustomPos)))-(l9_2*l9_2))));
float l9_7=2.0*l9_4;
float l9_8=l9_7+(1.0-max(abs(sign(l9_7)),0.99900001));
float l9_9=-l9_5;
vec3 l9_10=varCustomPos+(l9_3*((l9_9-l9_6)/l9_8));
vec3 l9_11=step(vec3(0.0),(l9_10-varCustomPos)/varCustomNormal);
vec4 l9_12=script_viewProjectionMatrix*vec4(mix(mix(varCustomPos+(l9_3*((l9_9+l9_6)/l9_8)),l9_10,vec3(min(min(l9_11.x,l9_11.y),l9_11.z))),mix(vec3(0.0,0.0,10000.0),varCustomPos+((varCustomNormal*l9_0)*(-1.0)),vec3(l9_1)),vec3(l9_1*step((-1.0)*l9_2,l9_0))),1.0);
float l9_13=l9_12.w;
vec2 l9_14=vec2((baseTexTransform*vec3(((l9_12.xy/vec2(l9_13+(1.0-max(abs(sign(l9_13)),0.99900001))))*0.5)+vec2(0.5),1.0)).xy);
int l9_15;
#if (baseTexHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
vec2 l9_16=abs(clamp(l9_14,vec2(0.0),vec2(1.0))-vec2(0.5));
float l9_17=max(l9_16.x,l9_16.y)*2.0;
vec4 l9_18=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_15,l9_14,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
l9_18.w=((1.0-(l9_17*l9_17))*blendInFactor)*step(abs(l9_12.z/l9_13),1.0);
vec2 l9_19=calculateEnvmapScreenToCube(-varCustomNormal);
int l9_20;
#if (baseTexHasSwappedViews)
{
l9_20=1-sc_GetStereoViewIndex();
}
#else
{
l9_20=sc_GetStereoViewIndex();
}
#endif
vec4 l9_21=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_20,clamp(vec2((baseTexTransform*vec3(l9_19,1.0)).xy),vec2(0.0020000001),vec2(0.99800003)),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
l9_21.w=1.0;
vec4 l9_22=mix(l9_21,l9_18,vec4(stopCapture));
int l9_23;
#if (prevTexHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(mix(sc_SampleTextureBiasOrLevel(prevTexDims.xy,prevTexLayout,l9_23,varCustomTex0,false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_prevTex,SC_SOFTWARE_WRAP_MODE_V_prevTex),(int(SC_USE_UV_MIN_MAX_prevTex)!=0),prevTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_prevTex)!=0),prevTexBorderColor,0.0,prevTex),l9_22,vec4(l9_22.w)));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
