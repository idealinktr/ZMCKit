#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler baseTexSmpSC 2:2
//sampler sampler borderTexSmpSC 2:3
//texture texture2D baseTex 2:0:2:2
//texture texture2D borderTex 2:1:2:3
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_TANGENT 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
uniform vec4 baseTexDims;
uniform vec4 borderTexDims;
uniform mat4 script_modelMatrix;
uniform mat4 script_viewProjectionMatrix;
uniform vec3 uniSphereCenter;
uniform vec3 uniCameraPos;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec4 borderTexSize;
uniform vec4 borderTexView;
uniform mat3 borderTexTransform;
uniform vec4 borderTexUvMinMax;
uniform vec4 borderTexBorderColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(vec4(((texture0*1.002)*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
varPos=(script_modelMatrix*(mat4(vec4(12.0,0.0,0.0,0.0),vec4(0.0,12.0,0.0,0.0),vec4(0.0,0.0,12.0,0.0),vec4(0.0,0.0,0.0,1.0))*(mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0))*position))).xyz;
varNormal=normalize(((script_modelMatrix*mat4(vec4(0.0,0.0,1.0,0.0),vec4(0.0,1.0,0.0,0.0),vec4(-1.0,0.0,0.0,0.0),vec4(0.0,0.0,0.0,1.0)))*vec4(normalize(position.xyz),0.0)).xyz);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_TANGENT 1
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
struct twoPoints
{
vec3 p1;
vec3 p2;
};
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef borderTexHasSwappedViews
#define borderTexHasSwappedViews 0
#elif borderTexHasSwappedViews==1
#undef borderTexHasSwappedViews
#define borderTexHasSwappedViews 1
#endif
#ifndef borderTexLayout
#define borderTexLayout 0
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_borderTex
#define SC_SOFTWARE_WRAP_MODE_U_borderTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_borderTex
#define SC_SOFTWARE_WRAP_MODE_V_borderTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_borderTex
#define SC_USE_UV_MIN_MAX_borderTex 0
#elif SC_USE_UV_MIN_MAX_borderTex==1
#undef SC_USE_UV_MIN_MAX_borderTex
#define SC_USE_UV_MIN_MAX_borderTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_borderTex
#define SC_USE_CLAMP_TO_BORDER_borderTex 0
#elif SC_USE_CLAMP_TO_BORDER_borderTex==1
#undef SC_USE_CLAMP_TO_BORDER_borderTex
#define SC_USE_CLAMP_TO_BORDER_borderTex 1
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
uniform vec4 borderTexDims;
uniform vec3 uniCameraPos;
uniform vec3 uniSphereCenter;
uniform mat4 script_viewProjectionMatrix;
uniform mat3 borderTexTransform;
uniform mat3 baseTexTransform;
uniform vec4 borderTexUvMinMax;
uniform vec4 borderTexBorderColor;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform mat4 script_modelMatrix;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform vec4 borderTexSize;
uniform vec4 borderTexView;
uniform mediump sampler2D borderTex;
uniform mediump sampler2D baseTex;
void getLineSphereIntersection(vec3 p1,vec3 p2,vec3 shpereCenter,float sphereRadius,inout twoPoints intersections)
{
vec3 l9_0=p2;
vec3 l9_1=p1;
vec3 l9_2=l9_0-l9_1;
float l9_3=dot(l9_2,l9_2);
vec3 l9_4=p1;
vec3 l9_5=shpereCenter;
float l9_6=2.0*dot(l9_2,l9_4-l9_5);
vec3 l9_7=shpereCenter;
vec3 l9_8=shpereCenter;
vec3 l9_9=p1;
vec3 l9_10=p1;
vec3 l9_11=shpereCenter;
vec3 l9_12=p1;
float l9_13=sphereRadius;
float l9_14=sphereRadius;
float l9_15=(l9_6*l9_6)-((4.0*l9_3)*(((dot(l9_7,l9_8)+dot(l9_9,l9_10))-(2.0*dot(l9_11,l9_12)))-(l9_13*l9_14)));
intersections.p1=vec3(10000.0,10000.0,0.0);
intersections.p2=vec3(10000.0,10000.0,0.0);
if (l9_15>=0.0)
{
float l9_16=sqrt(l9_15);
float l9_17=2.0*l9_3;
float l9_18=l9_17+(1.0-max(abs(sign(l9_17)),0.99900001));
float l9_19=-l9_6;
intersections.p1=p1+((p2-p1)*((l9_19-l9_16)/l9_18));
intersections.p2=p1+((p2-p1)*((l9_19+l9_16)/l9_18));
}
}
void main()
{
float l9_0=max(length(uniCameraPos-uniSphereCenter),100.0);
vec3 l9_1=uniSphereCenter+(normalize(varNormal)*l9_0);
vec4 l9_2=script_viewProjectionMatrix*vec4(l9_1,1.0);
float l9_3=l9_2.w;
float l9_4=sign(l9_3);
vec4 l9_5=(l9_2/vec4(l9_3+(1.0-max(abs(l9_4),0.99900001))))*l9_4;
vec2 l9_6=(l9_5.xy*0.5)+vec2(0.5);
twoPoints param_4=twoPoints(vec3(0.0),vec3(0.0));
getLineSphereIntersection(uniCameraPos,uniCameraPos+vec3(0.0,0.0,-1.0),uniSphereCenter,l9_0,param_4);
vec2 l9_7=vec2((borderTexTransform*vec3(l9_6,1.0)).xy)-vec2(0.5);
vec2 l9_8=l9_7/vec2(max(abs(l9_7.x),abs(l9_7.y))*2.0);
float l9_9=acos(dot(normalize(mix(param_4.p2,param_4.p1,vec3(step(param_4.p1.z,uniSphereCenter.z)))-uniSphereCenter),normalize(l9_1-uniSphereCenter)));
int l9_10;
#if (borderTexHasSwappedViews)
{
l9_10=1-sc_GetStereoViewIndex();
}
#else
{
l9_10=sc_GetStereoViewIndex();
}
#endif
vec4 l9_11=sc_SampleTextureBiasOrLevel(borderTexDims.xy,borderTexLayout,l9_10,l9_8+vec2(0.5),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,min(log2(max((l9_9-0.78539002)/0.049090002,1.0)),8.0),borderTex);
float l9_12=max(l9_9-1.5707901,0.0);
int l9_13;
#if (borderTexHasSwappedViews)
{
l9_13=1-sc_GetStereoViewIndex();
}
#else
{
l9_13=sc_GetStereoViewIndex();
}
#endif
vec4 l9_14=sc_SampleTextureBiasOrLevel(borderTexDims.xy,borderTexLayout,l9_13,(-l9_8)+vec2(0.5),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_borderTex,SC_SOFTWARE_WRAP_MODE_V_borderTex),(int(SC_USE_UV_MIN_MAX_borderTex)!=0),borderTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_borderTex)!=0),borderTexBorderColor,min(log2(max((2.3561699+(1.5707901-l9_12))/0.049090002,1.0)),8.0),borderTex);
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
sc_writeFragData0(mix(mix(l9_11,l9_14,vec4(sqrt((0.5*smoothstep(0.0,1.5707901,l9_12))*2.0)*0.5)),sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_15,vec2((baseTexTransform*vec3(clamp(l9_6,vec2(0.0020000001),vec2(0.99800003)),1.0)).xy),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex),vec4((step(abs(l9_5.x),1.0)*step(abs(l9_5.y),1.0))*step(abs(l9_5.z),1.0))));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
