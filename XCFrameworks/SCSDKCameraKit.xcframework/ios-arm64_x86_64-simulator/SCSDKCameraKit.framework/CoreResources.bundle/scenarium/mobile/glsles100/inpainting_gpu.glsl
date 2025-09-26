#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec2 l9_1=(l9_0.position.xy*0.5)+vec2(0.5);
varPackedTex=vec4(l9_1.x,l9_1.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
void main()
{
sc_DiscardStereoFragment();
vec4 l9_0=sc_ScreenTextureSampleView(varPackedTex.xy);
vec4 l9_1;
if (all(equal(l9_0.xyz,vec3(1.0,0.0,0.0))))
{
vec4 l9_2;
float l9_3;
int l9_4;
l9_4=1;
l9_3=0.0;
l9_2=vec4(0.0);
int l9_5;
int l9_6;
vec4 l9_7;
float l9_8;
int l9_9=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (all(equal(l9_2,vec4(0.0)))&&(l9_9<24))
{
l9_5=(l9_9+l9_4)+2;
int l9_10=(-1)*l9_5;
l9_8=l9_3;
l9_7=l9_2;
vec4 l9_11;
float l9_12;
int l9_13=l9_10;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_13<=l9_5)
{
l9_12=l9_8;
l9_11=l9_7;
vec4 l9_14;
float l9_15;
int l9_16=l9_10;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_16<=l9_5)
{
if ((l9_13!=0)||(l9_16!=0))
{
float l9_17=float(l9_16);
float l9_18=varPackedTex.x+(l9_17/sc_ScreenTextureSize.x);
float l9_19=float(l9_13);
float l9_20=varPackedTex.y+(l9_19/sc_ScreenTextureSize.x);
bool l9_21=(l9_18>=0.0)&&(l9_18<=1.0);
bool l9_22;
if (l9_21)
{
l9_22=(l9_20>=0.0)&&(l9_20<=1.0);
}
else
{
l9_22=l9_21;
}
vec4 l9_23;
float l9_24;
if (l9_22)
{
vec4 l9_25=sc_ScreenTextureSampleView(vec2(l9_18,l9_20));
vec3 l9_26=l9_25.xyz;
bool l9_27=any(notEqual(l9_26,vec3(1.0,0.0,0.0)));
bool l9_28;
if (l9_27)
{
l9_28=any(notEqual(l9_26,vec3(0.0)));
}
else
{
l9_28=l9_27;
}
vec4 l9_29;
float l9_30;
if (l9_28)
{
l9_30=l9_12+1.0;
l9_29=l9_11+l9_25;
}
else
{
l9_30=l9_12;
l9_29=l9_11;
}
l9_24=l9_30;
l9_23=l9_29;
}
else
{
l9_24=l9_12;
l9_23=l9_11;
}
l9_15=l9_24;
l9_14=l9_23;
}
else
{
l9_15=l9_12;
l9_14=l9_11;
}
l9_12=l9_15;
l9_11=l9_14;
l9_16+=l9_4;
continue;
}
else
{
break;
}
}
l9_13+=l9_4;
l9_8=l9_12;
l9_7=l9_11;
continue;
}
else
{
break;
}
}
l9_6=l9_4+8;
l9_4=l9_6;
l9_3=l9_8;
l9_9=l9_5;
l9_2=l9_7;
continue;
}
else
{
break;
}
}
l9_1=l9_2/vec4(l9_3);
}
else
{
l9_1=l9_0;
}
sc_writeFragData0(l9_1);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
