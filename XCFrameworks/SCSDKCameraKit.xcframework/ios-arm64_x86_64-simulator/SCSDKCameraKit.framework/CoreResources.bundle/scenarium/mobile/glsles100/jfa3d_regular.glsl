#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//sampler sampler inputTextureSmpSC 2:1
//texture texture2D inputTexture 2:0:2:1
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <voxeldata_common.glsl>
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
vec4 l9_1=l9_0.position;
vec2 l9_2=((l9_1.xy/vec2(l9_1.w))*0.5)+vec2(0.5);
varPackedTex=vec4(l9_2.x,l9_2.y,varPackedTex.z,varPackedTex.w);
sc_ProcessVertex(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#include <voxeldata_common.glsl>
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 0
#elif SC_USE_UV_TRANSFORM_inputTexture==1
#undef SC_USE_UV_TRANSFORM_inputTexture
#define SC_USE_UV_TRANSFORM_inputTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTexture
#define SC_SOFTWARE_WRAP_MODE_U_inputTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTexture
#define SC_SOFTWARE_WRAP_MODE_V_inputTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 0
#elif SC_USE_UV_MIN_MAX_inputTexture==1
#undef SC_USE_UV_MIN_MAX_inputTexture
#define SC_USE_UV_MIN_MAX_inputTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 0
#elif SC_USE_CLAMP_TO_BORDER_inputTexture==1
#undef SC_USE_CLAMP_TO_BORDER_inputTexture
#define SC_USE_CLAMP_TO_BORDER_inputTexture 1
#endif
uniform vec4 inputTextureDims;
uniform vec4 jfa3d_params_0;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mediump sampler2D inputTexture;
vec4 JFA3DStep(vec3 uvw)
{
float l9_0=uvw.x;
bool l9_1=l9_0<0.0;
bool l9_2;
if (!l9_1)
{
l9_2=uvw.y<0.0;
}
else
{
l9_2=l9_1;
}
bool l9_3;
if (!l9_2)
{
l9_3=uvw.z<0.0;
}
else
{
l9_3=l9_2;
}
bool l9_4;
if (!l9_3)
{
l9_4=uvw.x>1.0;
}
else
{
l9_4=l9_3;
}
bool l9_5;
if (!l9_4)
{
l9_5=uvw.y>1.0;
}
else
{
l9_5=l9_4;
}
bool l9_6;
if (!l9_5)
{
l9_6=uvw.z>1.0;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
return vec4(0.0,0.0,0.0,1.0);
}
vec3 offsets[27];
offsets[0]=vec3(-1.0,-1.0,1.0);
offsets[1]=vec3(0.0,-1.0,1.0);
offsets[2]=vec3(1.0,-1.0,1.0);
offsets[3]=vec3(-1.0,0.0,1.0);
offsets[4]=vec3(0.0,0.0,1.0);
offsets[5]=vec3(1.0,0.0,1.0);
offsets[6]=vec3(-1.0,1.0,1.0);
offsets[7]=vec3(0.0,1.0,1.0);
offsets[8]=vec3(1.0);
offsets[9]=vec3(-1.0,-1.0,0.0);
offsets[10]=vec3(0.0,-1.0,0.0);
offsets[11]=vec3(1.0,-1.0,0.0);
offsets[12]=vec3(-1.0,0.0,0.0);
offsets[13]=vec3(0.0);
offsets[14]=vec3(1.0,0.0,0.0);
offsets[15]=vec3(-1.0,1.0,0.0);
offsets[16]=vec3(0.0,1.0,0.0);
offsets[17]=vec3(1.0,1.0,0.0);
offsets[18]=vec3(-1.0);
offsets[19]=vec3(0.0,-1.0,-1.0);
offsets[20]=vec3(1.0,-1.0,-1.0);
offsets[21]=vec3(-1.0,0.0,-1.0);
offsets[22]=vec3(0.0,0.0,-1.0);
offsets[23]=vec3(1.0,0.0,-1.0);
offsets[24]=vec3(-1.0,1.0,-1.0);
offsets[25]=vec3(0.0,1.0,-1.0);
offsets[26]=vec3(1.0,1.0,-1.0);
vec3 l9_7;
float l9_8;
l9_8=1000000.0;
l9_7=vec3(0.0);
vec3 l9_9;
float l9_10;
int l9_11=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_11<27)
{
vec3 l9_12=uvw;
vec3 l9_13=offsets[l9_11];
vec3 l9_14=l9_12+((l9_13*jfa3d_params_0.x)*(1.0/jfa3d_params_0.z));
float l9_15=l9_14.x;
bool l9_16=l9_15<0.0;
bool l9_17;
if (!l9_16)
{
l9_17=l9_14.y<0.0;
}
else
{
l9_17=l9_16;
}
bool l9_18;
if (!l9_17)
{
l9_18=l9_14.z<0.0;
}
else
{
l9_18=l9_17;
}
bool l9_19;
if (!l9_18)
{
l9_19=l9_15>=1.0;
}
else
{
l9_19=l9_18;
}
bool l9_20;
if (!l9_19)
{
l9_20=l9_14.y>=1.0;
}
else
{
l9_20=l9_19;
}
bool l9_21;
if (!l9_20)
{
l9_21=l9_14.z>=1.0;
}
else
{
l9_21=l9_20;
}
if (l9_21)
{
l9_10=l9_8;
l9_9=l9_7;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
vec2 l9_22=UVW2UV(l9_14,jfa3d_params_0.z,jfa3d_params_0.w);
int l9_23;
#if (inputTextureHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
vec4 l9_24=sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_23,l9_22,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture);
if (l9_24.w==1.0)
{
l9_10=l9_8;
l9_9=l9_7;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
vec3 l9_25=l9_24.xyz;
vec3 l9_26=uvw;
float l9_27=length(l9_25-l9_26);
vec3 l9_28;
float l9_29;
if (l9_27<l9_8)
{
l9_29=l9_27;
l9_28=l9_25;
}
else
{
l9_29=l9_8;
l9_28=l9_7;
}
l9_10=l9_29;
l9_9=l9_28;
l9_8=l9_10;
l9_7=l9_9;
l9_11++;
continue;
}
else
{
break;
}
}
return vec4(l9_7,l9_8);
}
void main()
{
sc_DiscardStereoFragment();
sc_writeFragData0(JFA3DStep(UV2UVW(varPackedTex.xy,jfa3d_params_0.z,jfa3d_params_0.w)));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
