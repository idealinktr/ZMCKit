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
#ifndef SAMPLE_COUNT
#define SAMPLE_COUNT 0
#endif
uniform vec4 baseTexDims;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform float mipLevel;
uniform mat4 fMipLevelsMat[((SAMPLE_COUNT/16)+1)];
uniform vec4 lightVec[(SAMPLE_COUNT+1)];
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(sc_Vertex_t(vec4((texture0*2.0)-vec2(1.0),0.0,1.0),l9_0.normal,l9_0.tangent,l9_0.texture0,l9_0.texture1));
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
#ifndef SAMPLE_COUNT
#define SAMPLE_COUNT 0
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
uniform mat4 fMipLevelsMat[((SAMPLE_COUNT/16)+1)];
uniform vec4 lightVec[(SAMPLE_COUNT+1)];
uniform vec4 baseTexSize;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform float mipLevel;
uniform vec4 baseTexView;
uniform mediump sampler2D baseTex;
vec4 filterEnvmap1(vec3 targetN)
{
vec3 l9_0;
float l9_1;
l9_1=0.0;
l9_0=vec3(0.0);
vec3 l9_2;
float l9_3;
int l9_4=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_4<SAMPLE_COUNT)
{
float l9_5=clamp(lightVec[l9_4].y,0.0,1.0);
float l9_6=targetN.y;
bvec3 l9_7=bvec3(abs(l9_6)<0.99900001);
vec3 l9_8=targetN;
vec3 l9_9=normalize(cross(vec3(l9_7.x ? vec3(0.0,1.0,0.0).x : vec3(0.0,0.0,1.0).x,l9_7.y ? vec3(0.0,1.0,0.0).y : vec3(0.0,0.0,1.0).y,l9_7.z ? vec3(0.0,1.0,0.0).z : vec3(0.0,0.0,1.0).z),l9_8));
vec3 l9_10=targetN;
vec3 l9_11=targetN;
vec3 l9_12=normalize(((l9_9*lightVec[l9_4].x)+(l9_11*lightVec[l9_4].y))+(cross(l9_10,l9_9)*lightVec[l9_4].z));
float l9_13=-l9_12.z;
float l9_14=l9_12.x;
int l9_15=l9_4/16;
int l9_16=l9_4-(l9_15*16);
mat4 l9_17=fMipLevelsMat[l9_15];
int l9_18=l9_16/4;
int l9_19=l9_16-(l9_18*4);
float l9_20=l9_17[l9_18][l9_19];
vec2 l9_21=max(vec2(1.0),baseTexSize.xy/vec2(exp2(l9_20)));
int l9_22;
#if (baseTexHasSwappedViews)
{
l9_22=1-sc_GetStereoViewIndex();
}
#else
{
l9_22=sc_GetStereoViewIndex();
}
#endif
vec4 l9_23=sc_SampleTextureLevel(baseTexDims.xy,baseTexLayout,l9_22,(((vec2((((l9_14<0.0) ? (-1.0) : 1.0)*acos(clamp(l9_13/length(vec2(l9_14,l9_13)),-1.0,1.0)))-1.5707964,acos(l9_12.y))/vec2(6.2831855,3.1415927))*l9_21)-vec2(0.5))/(l9_21-vec2(1.0)),(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,l9_20,baseTex);
l9_2=l9_0+((l9_23.xyz*(1.0/l9_23.w))*l9_5);
l9_3=l9_1+l9_5;
l9_1=l9_3;
l9_0=l9_2;
l9_4++;
continue;
}
else
{
break;
}
}
vec3 l9_24=l9_0/vec3(l9_1);
float l9_25=max(1.0/max(1.0,max(l9_24.x,max(l9_24.y,l9_24.z))),0.0039607845);
return vec4(l9_24*l9_25,l9_25);
}
void main()
{
vec2 l9_0=varPackedTex.xy-vec2(0.5);
vec2 l9_1=(vec2(0.5)+l9_0)+((sign(l9_0)*(baseTexSize.zw*exp2(mipLevel)))*0.5);
float l9_2=6.2831855*l9_1.x;
float l9_3=3.1415927*l9_1.y;
float l9_4=sin(l9_3);
sc_writeFragData0(filterEnvmap1(normalize(vec3(cos(l9_2)*l9_4,cos(l9_3),sin(l9_2)*l9_4))));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
