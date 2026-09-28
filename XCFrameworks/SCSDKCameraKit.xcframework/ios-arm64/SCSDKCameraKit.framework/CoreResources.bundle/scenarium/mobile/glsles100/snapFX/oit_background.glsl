#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
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
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef sc_OITAlpha0HasSwappedViews
#define sc_OITAlpha0HasSwappedViews 0
#elif sc_OITAlpha0HasSwappedViews==1
#undef sc_OITAlpha0HasSwappedViews
#define sc_OITAlpha0HasSwappedViews 1
#endif
#ifndef sc_OITAlpha0Layout
#define sc_OITAlpha0Layout 0
#endif
#ifndef sc_OITAlpha1HasSwappedViews
#define sc_OITAlpha1HasSwappedViews 0
#elif sc_OITAlpha1HasSwappedViews==1
#undef sc_OITAlpha1HasSwappedViews
#define sc_OITAlpha1HasSwappedViews 1
#endif
#ifndef sc_OITAlpha1Layout
#define sc_OITAlpha1Layout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_OITAlpha0
#define SC_USE_UV_TRANSFORM_sc_OITAlpha0 0
#elif SC_USE_UV_TRANSFORM_sc_OITAlpha0==1
#undef SC_USE_UV_TRANSFORM_sc_OITAlpha0
#define SC_USE_UV_TRANSFORM_sc_OITAlpha0 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha0
#define SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha0 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha0
#define SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha0 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_OITAlpha0
#define SC_USE_UV_MIN_MAX_sc_OITAlpha0 0
#elif SC_USE_UV_MIN_MAX_sc_OITAlpha0==1
#undef SC_USE_UV_MIN_MAX_sc_OITAlpha0
#define SC_USE_UV_MIN_MAX_sc_OITAlpha0 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0
#define SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0 0
#elif SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0==1
#undef SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0
#define SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0 1
#endif
#ifndef SC_USE_UV_TRANSFORM_sc_OITAlpha1
#define SC_USE_UV_TRANSFORM_sc_OITAlpha1 0
#elif SC_USE_UV_TRANSFORM_sc_OITAlpha1==1
#undef SC_USE_UV_TRANSFORM_sc_OITAlpha1
#define SC_USE_UV_TRANSFORM_sc_OITAlpha1 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha1
#define SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha1 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha1
#define SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha1 -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sc_OITAlpha1
#define SC_USE_UV_MIN_MAX_sc_OITAlpha1 0
#elif SC_USE_UV_MIN_MAX_sc_OITAlpha1==1
#undef SC_USE_UV_MIN_MAX_sc_OITAlpha1
#define SC_USE_UV_MIN_MAX_sc_OITAlpha1 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1
#define SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1 0
#elif SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1==1
#undef SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1
#define SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1 1
#endif
uniform vec4 sc_OITAlpha0Dims;
uniform vec4 sc_OITAlpha1Dims;
uniform mat3 sc_OITAlpha0Transform;
uniform vec4 sc_OITAlpha0UvMinMax;
uniform vec4 sc_OITAlpha0BorderColor;
uniform mat3 sc_OITAlpha1Transform;
uniform vec4 sc_OITAlpha1UvMinMax;
uniform vec4 sc_OITAlpha1BorderColor;
uniform mediump sampler2D sc_OITAlpha0;
uniform mediump sampler2D sc_OITAlpha1;
void main()
{
sc_DiscardStereoFragment();
#if (sc_OITMaxLayersVisualizeLayerCount)
{
int l9_0;
#if (sc_OITAlpha0HasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(sc_OITAlpha0Dims.xy,sc_OITAlpha0Layout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_OITAlpha0)!=0),sc_OITAlpha0Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha0,SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha0),(int(SC_USE_UV_MIN_MAX_sc_OITAlpha0)!=0),sc_OITAlpha0UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0)!=0),sc_OITAlpha0BorderColor,0.0,sc_OITAlpha0);
float l9_2=l9_1.x;
vec4 l9_3;
if (l9_2==0.0)
{
l9_3=vec4(0.0,0.0,0.0,1.0);
}
else
{
vec4 l9_4;
if (l9_2<=0.015686275)
{
l9_4=vec4(0.0,1.0,0.0,1.0);
}
else
{
vec4 l9_5;
if (l9_2<=0.031372551)
{
l9_5=vec4(1.0,1.0,0.0,1.0);
}
else
{
l9_5=vec4(1.0,0.0,0.0,1.0);
}
l9_4=l9_5;
}
l9_3=l9_4;
}
sc_writeFragData0(l9_3);
return;
}
#endif
int alphas[8];
int l9_6=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_6<8)
{
alphas[l9_6]=0;
l9_6++;
continue;
}
else
{
break;
}
}
int l9_7;
#if (sc_OITAlpha0HasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
vec4 l9_8=sc_SampleTextureBiasOrLevel(sc_OITAlpha0Dims.xy,sc_OITAlpha0Layout,l9_7,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_OITAlpha0)!=0),sc_OITAlpha0Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha0,SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha0),(int(SC_USE_UV_MIN_MAX_sc_OITAlpha0)!=0),sc_OITAlpha0UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_OITAlpha0)!=0),sc_OITAlpha0BorderColor,0.0,sc_OITAlpha0);
float l9_9=floor((l9_8.w*255.0)+0.5);
alphas[3]=(alphas[3]*4)+int(floor(mod(l9_9,4.0)));
float l9_10=floor(l9_9/4.0);
alphas[2]=(alphas[2]*4)+int(floor(mod(l9_10,4.0)));
float l9_11=floor(l9_10/4.0);
alphas[1]=(alphas[1]*4)+int(floor(mod(l9_11,4.0)));
alphas[0]=(alphas[0]*4)+int(floor(mod(floor(l9_11/4.0),4.0)));
float l9_12=floor((l9_8.z*255.0)+0.5);
alphas[3]=(alphas[3]*4)+int(floor(mod(l9_12,4.0)));
float l9_13=floor(l9_12/4.0);
alphas[2]=(alphas[2]*4)+int(floor(mod(l9_13,4.0)));
float l9_14=floor(l9_13/4.0);
alphas[1]=(alphas[1]*4)+int(floor(mod(l9_14,4.0)));
alphas[0]=(alphas[0]*4)+int(floor(mod(floor(l9_14/4.0),4.0)));
float l9_15=floor((l9_8.y*255.0)+0.5);
alphas[3]=(alphas[3]*4)+int(floor(mod(l9_15,4.0)));
float l9_16=floor(l9_15/4.0);
alphas[2]=(alphas[2]*4)+int(floor(mod(l9_16,4.0)));
float l9_17=floor(l9_16/4.0);
alphas[1]=(alphas[1]*4)+int(floor(mod(l9_17,4.0)));
alphas[0]=(alphas[0]*4)+int(floor(mod(floor(l9_17/4.0),4.0)));
float l9_18=floor((l9_8.x*255.0)+0.5);
alphas[3]=(alphas[3]*4)+int(floor(mod(l9_18,4.0)));
float l9_19=floor(l9_18/4.0);
alphas[2]=(alphas[2]*4)+int(floor(mod(l9_19,4.0)));
float l9_20=floor(l9_19/4.0);
alphas[1]=(alphas[1]*4)+int(floor(mod(l9_20,4.0)));
alphas[0]=(alphas[0]*4)+int(floor(mod(floor(l9_20/4.0),4.0)));
#if (sc_OITMaxLayers8)
{
int l9_21;
#if (sc_OITAlpha1HasSwappedViews)
{
l9_21=1-sc_GetStereoViewIndex();
}
#else
{
l9_21=sc_GetStereoViewIndex();
}
#endif
vec4 l9_22=sc_SampleTextureBiasOrLevel(sc_OITAlpha1Dims.xy,sc_OITAlpha1Layout,l9_21,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_sc_OITAlpha1)!=0),sc_OITAlpha1Transform,ivec2(SC_SOFTWARE_WRAP_MODE_U_sc_OITAlpha1,SC_SOFTWARE_WRAP_MODE_V_sc_OITAlpha1),(int(SC_USE_UV_MIN_MAX_sc_OITAlpha1)!=0),sc_OITAlpha1UvMinMax,(int(SC_USE_CLAMP_TO_BORDER_sc_OITAlpha1)!=0),sc_OITAlpha1BorderColor,0.0,sc_OITAlpha1);
float l9_23=floor((l9_22.w*255.0)+0.5);
alphas[7]=(alphas[7]*4)+int(floor(mod(l9_23,4.0)));
float l9_24=floor(l9_23/4.0);
alphas[6]=(alphas[6]*4)+int(floor(mod(l9_24,4.0)));
float l9_25=floor(l9_24/4.0);
alphas[5]=(alphas[5]*4)+int(floor(mod(l9_25,4.0)));
alphas[4]=(alphas[4]*4)+int(floor(mod(floor(l9_25/4.0),4.0)));
float l9_26=floor((l9_22.z*255.0)+0.5);
alphas[7]=(alphas[7]*4)+int(floor(mod(l9_26,4.0)));
float l9_27=floor(l9_26/4.0);
alphas[6]=(alphas[6]*4)+int(floor(mod(l9_27,4.0)));
float l9_28=floor(l9_27/4.0);
alphas[5]=(alphas[5]*4)+int(floor(mod(l9_28,4.0)));
alphas[4]=(alphas[4]*4)+int(floor(mod(floor(l9_28/4.0),4.0)));
float l9_29=floor((l9_22.y*255.0)+0.5);
alphas[7]=(alphas[7]*4)+int(floor(mod(l9_29,4.0)));
float l9_30=floor(l9_29/4.0);
alphas[6]=(alphas[6]*4)+int(floor(mod(l9_30,4.0)));
float l9_31=floor(l9_30/4.0);
alphas[5]=(alphas[5]*4)+int(floor(mod(l9_31,4.0)));
alphas[4]=(alphas[4]*4)+int(floor(mod(floor(l9_31/4.0),4.0)));
float l9_32=floor((l9_22.x*255.0)+0.5);
alphas[7]=(alphas[7]*4)+int(floor(mod(l9_32,4.0)));
float l9_33=floor(l9_32/4.0);
alphas[6]=(alphas[6]*4)+int(floor(mod(l9_33,4.0)));
float l9_34=floor(l9_33/4.0);
alphas[5]=(alphas[5]*4)+int(floor(mod(l9_34,4.0)));
alphas[4]=(alphas[4]*4)+int(floor(mod(floor(l9_34/4.0),4.0)));
}
#endif
float alphas_normalized[8];
int l9_35=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_35<8)
{
alphas_normalized[l9_35]=float(alphas[l9_35])/255.0;
l9_35++;
continue;
}
else
{
break;
}
}
float l9_36;
l9_36=1.0;
int l9_37=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_37<(((int(sc_OITMaxLayers8)!=0) ? 2 : 1)*4))
{
l9_36=(1.0-alphas_normalized[l9_37])*l9_36;
l9_37++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(vec4(l9_36,l9_36,l9_36,1.0));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
