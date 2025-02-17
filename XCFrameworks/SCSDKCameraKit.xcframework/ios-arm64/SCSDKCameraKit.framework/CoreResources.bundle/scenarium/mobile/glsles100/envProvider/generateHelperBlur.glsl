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
uniform vec4 baseTexDims;
uniform mat3 baseTexTransform;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=l9_0.texture0;
vec2 l9_2=vec2((baseTexTransform*vec3(l9_1,1.0)).xy);
varPackedTex=vec4(varPackedTex.x,varPackedTex.y,l9_2.x,l9_2.y);
sc_ProcessVertex(sc_Vertex_t(vec4((l9_1*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_1,l9_0.texture1));
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
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
uniform vec4 baseTexSize;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform mediump sampler2D baseTex;
void main()
{
vec2 l9_0=varPackedTex.zw-vec2(0.5);
vec2 l9_1=(vec2(0.5)+l9_0)+((sign(l9_0)*(baseTexSize.zw*1.0))*0.5);
float l9_2=6.2831855*l9_1.x;
float l9_3=3.1415927*l9_1.y;
float l9_4=sin(l9_3);
vec3 l9_5=normalize(vec3(cos(l9_2)*l9_4,cos(l9_3),sin(l9_2)*l9_4));
vec2 l9_6=vec2(0.0,1.0/baseTexSize.y);
vec2 l9_7=l9_1+l9_6;
vec2 l9_8=l9_1-l9_6;
float l9_9=l9_7.y;
bool l9_10=l9_9>0.0;
bool l9_11;
if (l9_10)
{
l9_11=l9_9<1.0;
}
else
{
l9_11=l9_10;
}
bvec2 l9_12=bvec2(l9_11);
vec2 l9_13=vec2(l9_12.x ? l9_7.x : l9_8.x,l9_12.y ? l9_7.y : l9_8.y);
float l9_14=6.2831855*l9_13.x;
float l9_15=3.1415927*l9_13.y;
float l9_16=sin(l9_15);
float l9_17=3.1415927/baseTexSize.y;
float l9_18=sin(l9_17);
vec3 l9_19=normalize(normalize(vec3(cos(l9_14)*l9_16,cos(l9_15),sin(l9_14)*l9_16))-(l9_5*cos(l9_17)));
vec3 l9_20=l9_19*l9_18;
vec3 l9_21=normalize(cross(l9_5,l9_19))*l9_18;
vec3 l9_22=l9_5+mix(l9_21*0.1,l9_20*0.1,vec3(fract(sin(dot(l9_1,vec2(12.9898,78.233002)))*43758.547)));
vec3 shiftedVectors[9];
shiftedVectors[0]=l9_22;
shiftedVectors[1]=l9_22+l9_21;
shiftedVectors[2]=l9_22+l9_20;
shiftedVectors[3]=l9_22-l9_21;
shiftedVectors[4]=l9_22-l9_20;
vec3 l9_23=l9_20*0.70710677;
vec3 l9_24=l9_22+l9_23;
vec3 l9_25=l9_21*0.70710677;
shiftedVectors[5]=l9_24+l9_25;
vec3 l9_26=l9_22-l9_23;
shiftedVectors[6]=l9_26-l9_25;
shiftedVectors[7]=l9_24-l9_25;
shiftedVectors[8]=l9_26+l9_25;
vec3 l9_27;
l9_27=vec3(0.0);
vec3 l9_28;
int l9_29=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_29<9)
{
vec3 l9_30=shiftedVectors[l9_29];
vec3 l9_31=normalize(l9_30);
float l9_32=-l9_31.z;
float l9_33=l9_31.x;
int l9_34;
#if (baseTexHasSwappedViews)
{
l9_34=1-sc_GetStereoViewIndex();
}
#else
{
l9_34=sc_GetStereoViewIndex();
}
#endif
vec4 l9_35=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_34,vec2((((l9_33<0.0) ? (-1.0) : 1.0)*acos(clamp(l9_32/length(vec2(l9_33,l9_32)),-1.0,1.0)))-1.5707964,acos(l9_31.y))/vec2(6.2831855,3.1415927),false,mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(0.0,0.0,1.0)),ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
l9_28=l9_27+(l9_35.xyz*(1.0/l9_35.w));
l9_27=l9_28;
l9_29++;
continue;
}
else
{
break;
}
}
vec3 l9_36=l9_27/vec3(9.0);
float l9_37=max(1.0/max(1.0,max(l9_36.x,max(l9_36.y,l9_36.z))),0.0039607845);
sc_writeFragData0(vec4(l9_36*l9_37,l9_37));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
