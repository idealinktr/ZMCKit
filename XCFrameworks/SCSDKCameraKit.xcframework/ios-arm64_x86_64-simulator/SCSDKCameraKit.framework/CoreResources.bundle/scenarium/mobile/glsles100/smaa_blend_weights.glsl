#version 100 sc_convert_to 300 es
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef SMAA_QUALITY
#define SMAA_QUALITY 0
#endif
uniform vec4 inputTextureSize;
varying vec2 varPixCoord;
varying vec4 varOffset0;
varying vec4 varOffset1;
varying vec4 varOffset2;
int smaaMaxSearchSteps(int smaaQuality)
{
if (((smaaQuality==2)||(smaaQuality==3))||(smaaQuality==4))
{
return 25;
}
return 0;
}
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_ProcessVertex(l9_0);
vec2 l9_1=(l9_0.position.xy*0.5)+vec2(0.5);
varPackedTex=vec4(l9_1.x,l9_1.y,varPackedTex.z,varPackedTex.w);
vec4 l9_2=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
varPixCoord=varPackedTex.xy*l9_2.zw;
vec4 l9_3=l9_2.xyxy;
varOffset0=(l9_3*vec4(-0.25,0.125,1.25,0.125))+varPackedTex.xyxy;
varOffset1=(l9_3*vec4(-0.125,0.25,-0.125,-1.25))+varPackedTex.xyxy;
varOffset2=((l9_2.xxyy*vec4(-2.0,2.0,2.0,-2.0))*float(smaaMaxSearchSteps(SMAA_QUALITY)))+vec4(varOffset0.xz,varOffset1.yw);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#include <std2_texture.glsl>
#ifndef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 0
#elif inputTextureHasSwappedViews==1
#undef inputTextureHasSwappedViews
#define inputTextureHasSwappedViews 1
#endif
#ifndef inputTextureLayout
#define inputTextureLayout 0
#endif
#ifndef edgesTexHasSwappedViews
#define edgesTexHasSwappedViews 0
#elif edgesTexHasSwappedViews==1
#undef edgesTexHasSwappedViews
#define edgesTexHasSwappedViews 1
#endif
#ifndef edgesTexLayout
#define edgesTexLayout 0
#endif
#ifndef areaTexHasSwappedViews
#define areaTexHasSwappedViews 0
#elif areaTexHasSwappedViews==1
#undef areaTexHasSwappedViews
#define areaTexHasSwappedViews 1
#endif
#ifndef areaTexLayout
#define areaTexLayout 0
#endif
#ifndef searchTexHasSwappedViews
#define searchTexHasSwappedViews 0
#elif searchTexHasSwappedViews==1
#undef searchTexHasSwappedViews
#define searchTexHasSwappedViews 1
#endif
#ifndef searchTexLayout
#define searchTexLayout 0
#endif
#ifndef SMAA_QUALITY
#define SMAA_QUALITY 0
#endif
#ifndef SC_USE_UV_TRANSFORM_edgesTex
#define SC_USE_UV_TRANSFORM_edgesTex 0
#elif SC_USE_UV_TRANSFORM_edgesTex==1
#undef SC_USE_UV_TRANSFORM_edgesTex
#define SC_USE_UV_TRANSFORM_edgesTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_edgesTex
#define SC_SOFTWARE_WRAP_MODE_U_edgesTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_edgesTex
#define SC_SOFTWARE_WRAP_MODE_V_edgesTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_edgesTex
#define SC_USE_UV_MIN_MAX_edgesTex 0
#elif SC_USE_UV_MIN_MAX_edgesTex==1
#undef SC_USE_UV_MIN_MAX_edgesTex
#define SC_USE_UV_MIN_MAX_edgesTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_edgesTex
#define SC_USE_CLAMP_TO_BORDER_edgesTex 0
#elif SC_USE_CLAMP_TO_BORDER_edgesTex==1
#undef SC_USE_CLAMP_TO_BORDER_edgesTex
#define SC_USE_CLAMP_TO_BORDER_edgesTex 1
#endif
#ifndef SMAA_AREATEX_MAX_DISTANCE_DIAG
#define SMAA_AREATEX_MAX_DISTANCE_DIAG 20
#endif
#ifndef SC_USE_UV_TRANSFORM_areaTex
#define SC_USE_UV_TRANSFORM_areaTex 0
#elif SC_USE_UV_TRANSFORM_areaTex==1
#undef SC_USE_UV_TRANSFORM_areaTex
#define SC_USE_UV_TRANSFORM_areaTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_areaTex
#define SC_SOFTWARE_WRAP_MODE_U_areaTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_areaTex
#define SC_SOFTWARE_WRAP_MODE_V_areaTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_areaTex
#define SC_USE_UV_MIN_MAX_areaTex 0
#elif SC_USE_UV_MIN_MAX_areaTex==1
#undef SC_USE_UV_MIN_MAX_areaTex
#define SC_USE_UV_MIN_MAX_areaTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_areaTex
#define SC_USE_CLAMP_TO_BORDER_areaTex 0
#elif SC_USE_CLAMP_TO_BORDER_areaTex==1
#undef SC_USE_CLAMP_TO_BORDER_areaTex
#define SC_USE_CLAMP_TO_BORDER_areaTex 1
#endif
#ifndef SC_USE_UV_TRANSFORM_searchTex
#define SC_USE_UV_TRANSFORM_searchTex 0
#elif SC_USE_UV_TRANSFORM_searchTex==1
#undef SC_USE_UV_TRANSFORM_searchTex
#define SC_USE_UV_TRANSFORM_searchTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_searchTex
#define SC_SOFTWARE_WRAP_MODE_U_searchTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_searchTex
#define SC_SOFTWARE_WRAP_MODE_V_searchTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_searchTex
#define SC_USE_UV_MIN_MAX_searchTex 0
#elif SC_USE_UV_MIN_MAX_searchTex==1
#undef SC_USE_UV_MIN_MAX_searchTex
#define SC_USE_UV_MIN_MAX_searchTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_searchTex
#define SC_USE_CLAMP_TO_BORDER_searchTex 0
#elif SC_USE_CLAMP_TO_BORDER_searchTex==1
#undef SC_USE_CLAMP_TO_BORDER_searchTex
#define SC_USE_CLAMP_TO_BORDER_searchTex 1
#endif
#ifndef SMAA_AREATEX_MAX_DISTANCE
#define SMAA_AREATEX_MAX_DISTANCE 16
#endif
#ifndef DEBUG_MODE
#define DEBUG_MODE 0
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
uniform vec4 edgesTexDims;
uniform vec4 areaTexDims;
uniform vec4 searchTexDims;
uniform vec4 inputTextureSize;
uniform mat3 edgesTexTransform;
uniform vec4 edgesTexUvMinMax;
uniform vec4 edgesTexBorderColor;
uniform mat3 areaTexTransform;
uniform vec4 areaTexUvMinMax;
uniform vec4 areaTexBorderColor;
uniform mat3 searchTexTransform;
uniform vec4 searchTexUvMinMax;
uniform vec4 searchTexBorderColor;
uniform mat3 inputTextureTransform;
uniform vec4 inputTextureUvMinMax;
uniform vec4 inputTextureBorderColor;
uniform mediump sampler2D inputTexture;
uniform mediump sampler2D edgesTex;
uniform mediump sampler2D areaTex;
uniform mediump sampler2D searchTex;
varying vec4 varOffset0;
varying vec4 varOffset2;
varying vec4 varOffset1;
varying vec2 varPixCoord;
int smaaMaxSearchStepsDiag(int smaaQuality)
{
if (smaaQuality==2)
{
return 8;
}
else
{
if ((smaaQuality==3)||(smaaQuality==4))
{
return 16;
}
}
return 0;
}
vec2 SMAASearchDiag1(vec2 texcoord,vec2 dir,out vec2 e)
{
vec4 l9_0;
l9_0=vec4(texcoord,-1.0,1.0);
vec4 l9_1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_2=smaaMaxSearchStepsDiag(SMAA_QUALITY);
bool l9_3=l9_0.z<float(l9_2-1);
bool l9_4;
if (l9_3)
{
l9_4=l9_0.w>0.89999998;
}
else
{
l9_4=l9_3;
}
if (l9_4)
{
vec3 l9_5=(vec3(1.0/inputTextureSize.x,1.0/inputTextureSize.y,1.0)*vec3(dir,1.0))+l9_0.xyz;
vec4 l9_6=vec4(l9_5.x,l9_5.y,l9_5.z,l9_0.w);
int l9_7;
#if (edgesTexHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
e=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_7,l9_5.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).xy;
l9_1=l9_6;
l9_1.w=dot(e,vec2(0.5));
l9_0=l9_1;
continue;
}
else
{
break;
}
}
return l9_0.zw;
}
vec2 SMAAAreaDiag(vec2 dist,vec2 e,float offset)
{
vec2 l9_0=(vec2(0.0062500001,0.0017857143)*((vec2(float(SMAA_AREATEX_MAX_DISTANCE_DIAG))*e)+dist))+vec2(0.003125,0.00089285715);
float l9_1=l9_0.y+(0.14285715*offset);
vec2 l9_2=vec2(l9_0.x+0.5,l9_1);
l9_2.y=1.0-l9_1;
int l9_3;
#if (areaTexHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
return sc_SampleTextureBiasOrLevel(areaTexDims.xy,areaTexLayout,l9_3,l9_2+(vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTex).xy;
}
vec2 SMAASearchDiag2(vec2 texcoord,vec2 dir,out vec2 e)
{
float l9_0=1.0/inputTextureSize.x;
vec4 l9_1=vec4(texcoord,-1.0,1.0);
l9_1.x=texcoord.x+(0.25*l9_0);
vec4 l9_2;
l9_2=l9_1;
vec4 l9_3;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_4=smaaMaxSearchStepsDiag(SMAA_QUALITY);
bool l9_5=l9_2.z<float(l9_4-1);
bool l9_6;
if (l9_5)
{
l9_6=l9_2.w>0.89999998;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
vec3 l9_7=(vec3(l9_0,1.0/inputTextureSize.y,1.0)*vec3(dir,1.0))+l9_2.xyz;
vec4 l9_8=vec4(l9_7.x,l9_7.y,l9_7.z,l9_2.w);
int l9_9;
#if (edgesTexHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
e=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_9,l9_7.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).xy;
vec2 l9_10=e;
l9_10.x=e.x*abs((5.0*e.x)-3.75);
e=round(l9_10);
l9_3=l9_8;
l9_3.w=dot(e,vec2(0.5));
l9_2=l9_3;
continue;
}
else
{
break;
}
}
return l9_2.zw;
}
vec2 SMAACalculateDiagWeights(vec2 texcoord,vec2 e,vec4 subsampleIndices)
{
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
vec4 l9_1;
if (e.x>0.0)
{
vec2 param_2;
vec2 l9_2=SMAASearchDiag1(texcoord,vec2(-1.0),param_2);
vec4 l9_3=vec4(l9_2.x,vec4(0.0).y,l9_2.y,vec4(0.0).w);
l9_3.x=l9_2.x+float(param_2.y>0.89999998);
l9_1=l9_3;
}
else
{
l9_1=vec4(vec2(0.0).x,vec4(0.0).y,vec2(0.0).y,vec4(0.0).w);
}
vec2 param_5;
vec2 l9_4=SMAASearchDiag1(texcoord,vec2(1.0),param_5);
vec2 l9_5;
if ((l9_1.x+l9_4.x)>2.0)
{
float l9_6=-l9_1.x;
vec4 l9_7=(vec4(l9_6+0.25,l9_6,l9_4.x,l9_4.x+0.25)*l9_0.xyxy)+texcoord.xyxy;
int l9_8;
#if (edgesTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec2 l9_9=l9_0.xy;
vec4 l9_10=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_8,l9_7.xy+(l9_9*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
int l9_11;
#if (edgesTexHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_11,l9_7.zw+(l9_9*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
vec4 l9_13=vec4(l9_10.x,l9_10.y,l9_12.x,l9_12.y);
vec2 l9_14=l9_13.xz;
vec2 l9_15=l9_14*abs((l9_14*5.0)-vec2(3.75));
vec4 l9_16=round(vec4(l9_15.x,l9_13.y,l9_15.y,l9_13.w));
vec2 l9_17=(vec2(2.0)*l9_16.yw)+l9_16.xz;
vec2 l9_18=step(vec2(0.89999998),vec4(l9_1.x,l9_4.x,l9_1.z,l9_4.y).zw);
vec2 l9_19;
if (l9_18.x>0.0)
{
vec2 l9_20=l9_17;
l9_20.x=0.0;
l9_19=l9_20;
}
else
{
l9_19=l9_17;
}
vec2 l9_21;
if (l9_18.y>0.0)
{
vec2 l9_22=l9_19;
l9_22.y=0.0;
l9_21=l9_22;
}
else
{
l9_21=l9_19;
}
l9_5=vec2(0.0)+SMAAAreaDiag(vec4(l9_1.x,l9_4.x,l9_1.z,l9_4.y).xy,l9_21,subsampleIndices.z);
}
else
{
l9_5=vec2(0.0);
}
int l9_23;
#if (edgesTexHasSwappedViews)
{
l9_23=1-sc_GetStereoViewIndex();
}
#else
{
l9_23=sc_GetStereoViewIndex();
}
#endif
vec2 l9_24=l9_0.xy;
vec2 l9_25=l9_24*vec2(1.0,0.0);
vec2 param_47;
vec2 l9_26=SMAASearchDiag2(texcoord,vec2(-1.0,1.0),param_47);
vec4 l9_27;
if (sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_23,texcoord+l9_25,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).x>0.0)
{
vec2 param_50;
vec2 l9_28=SMAASearchDiag2(texcoord,vec2(1.0,-1.0),param_50);
vec4 l9_29=vec4(l9_26.x,l9_28.x,l9_26.y,l9_28.y);
l9_29.y=l9_28.x+float(param_50.y>0.89999998);
l9_27=l9_29;
}
else
{
l9_27=vec4(l9_26.x,vec2(0.0).x,l9_26.y,vec2(0.0).y);
}
vec2 l9_30;
if ((l9_27.x+l9_27.y)>2.0)
{
float l9_31=-l9_27.x;
vec4 l9_32=(vec4(l9_31,l9_31,l9_27.yy)*l9_0.xyxy)+texcoord.xyxy;
int l9_33;
#if (edgesTexHasSwappedViews)
{
l9_33=1-sc_GetStereoViewIndex();
}
#else
{
l9_33=sc_GetStereoViewIndex();
}
#endif
vec2 l9_34=l9_32.xy;
vec4 l9_35=vec4(0.0);
l9_35.x=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_33,l9_34+(l9_24*vec2(-1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).y;
int l9_36;
#if (edgesTexHasSwappedViews)
{
l9_36=1-sc_GetStereoViewIndex();
}
#else
{
l9_36=sc_GetStereoViewIndex();
}
#endif
vec4 l9_37=l9_35;
l9_37.y=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_36,l9_34+(l9_24*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).x;
int l9_38;
#if (edgesTexHasSwappedViews)
{
l9_38=1-sc_GetStereoViewIndex();
}
#else
{
l9_38=sc_GetStereoViewIndex();
}
#endif
vec4 l9_39=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_38,l9_32.zw+l9_25,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
vec4 l9_40=vec4(l9_37.x,l9_37.y,l9_39.y,l9_39.x);
vec2 l9_41=(vec2(2.0)*l9_40.xz)+l9_40.yw;
vec2 l9_42=step(vec2(0.89999998),l9_27.zw);
vec2 l9_43;
if (l9_42.x>0.0)
{
vec2 l9_44=l9_41;
l9_44.x=0.0;
l9_43=l9_44;
}
else
{
l9_43=l9_41;
}
vec2 l9_45;
if (l9_42.y>0.0)
{
vec2 l9_46=l9_43;
l9_46.y=0.0;
l9_45=l9_46;
}
else
{
l9_45=l9_43;
}
l9_30=l9_5+SMAAAreaDiag(l9_27.xy,l9_45,subsampleIndices.w).yx;
}
else
{
l9_30=l9_5;
}
return l9_30;
}
bool smaaDisableDetection(int smaaQuality)
{
if (((smaaQuality==0)||(smaaQuality==1))||(smaaQuality==4))
{
return true;
}
return false;
}
float SMAASearchLength(vec2 e,float offset)
{
vec2 l9_0=vec2(1.0)/vec2(64.0,16.0);
vec2 l9_1=((((vec2(66.0,33.0)*vec2(0.5,-1.0))+vec2(-1.0,1.0))*l9_0)*e)+(((vec2(66.0,33.0)*vec2(offset,1.0))+vec2(0.5,-0.5))*l9_0);
vec2 l9_2=l9_1;
l9_2.y=1.0-l9_1.y;
int l9_3;
#if (searchTexHasSwappedViews)
{
l9_3=1-sc_GetStereoViewIndex();
}
#else
{
l9_3=sc_GetStereoViewIndex();
}
#endif
return sc_SampleTextureBiasOrLevel(searchTexDims.xy,searchTexLayout,l9_3,l9_2+(vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_searchTex)!=0),searchTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_searchTex,SC_SOFTWARE_WRAP_MODE_V_searchTex),(int(SC_USE_UV_MIN_MAX_searchTex)!=0),searchTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_searchTex)!=0),searchTexBorderColor,0.0,searchTex).x;
}
float SMAASearchXLeft(vec2 texcoord,float end)
{
float l9_0=1.0/inputTextureSize.x;
vec2 l9_1;
l9_1=vec2(0.0,1.0);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
float l9_2=texcoord.x;
float l9_3=end;
bool l9_4=l9_2>l9_3;
bool l9_5;
if (l9_4)
{
l9_5=l9_1.y>0.82810003;
}
else
{
l9_5=l9_4;
}
bool l9_6;
if (l9_5)
{
l9_6=l9_1.x==0.0;
}
else
{
l9_6=l9_5;
}
if (l9_6)
{
int l9_7;
#if (edgesTexHasSwappedViews)
{
l9_7=1-sc_GetStereoViewIndex();
}
#else
{
l9_7=sc_GetStereoViewIndex();
}
#endif
vec4 l9_8=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_7,texcoord,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
texcoord=(vec2(-2.0,-0.0)*vec4(l9_0,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy)+texcoord;
l9_1=l9_8.xy;
continue;
}
else
{
break;
}
}
return (l9_0*(((-2.007874)*SMAASearchLength(l9_1,0.0))+3.25))+texcoord.x;
}
float SMAASearchXRight(vec2 texcoord,float end)
{
float l9_0=1.0/inputTextureSize.x;
vec2 l9_1;
l9_1=vec2(0.0,1.0);
vec2 l9_2;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
float l9_3=texcoord.x;
float l9_4=end;
bool l9_5=l9_3<l9_4;
bool l9_6;
if (l9_5)
{
l9_6=l9_1.y>0.82810003;
}
else
{
l9_6=l9_5;
}
bool l9_7;
if (l9_6)
{
l9_7=l9_1.x==0.0;
}
else
{
l9_7=l9_6;
}
if (l9_7)
{
int l9_8;
#if (edgesTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
l9_2=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_8,texcoord,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).xy;
texcoord=(vec2(2.0,0.0)*vec4(l9_0,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy)+texcoord;
l9_1=l9_2;
continue;
}
else
{
break;
}
}
return ((-l9_0)*(((-2.007874)*SMAASearchLength(l9_1,0.5))+3.25))+texcoord.x;
}
vec2 SMAAArea(vec2 dist,float e1,float e2,float offset)
{
vec2 l9_0=(vec2(0.0062500001,0.0017857143)*((vec2(float(SMAA_AREATEX_MAX_DISTANCE))*round(vec2(e1,e2)*4.0))+dist))+vec2(0.003125,0.00089285715);
vec2 l9_1=l9_0;
l9_1.y=1.0-((0.14285715*offset)+l9_0.y);
int l9_2;
#if (areaTexHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
return sc_SampleTextureBiasOrLevel(areaTexDims.xy,areaTexLayout,l9_2,l9_1+(vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy*vec2(0.0)),(int(SC_USE_UV_TRANSFORM_areaTex)!=0),areaTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_areaTex,SC_SOFTWARE_WRAP_MODE_V_areaTex),(int(SC_USE_UV_MIN_MAX_areaTex)!=0),areaTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_areaTex)!=0),areaTexBorderColor,0.0,areaTex).xy;
}
int smaaMaxSearchSteps(int smaaQuality)
{
if (((smaaQuality==2)||(smaaQuality==3))||(smaaQuality==4))
{
return 25;
}
return 0;
}
vec4 DebugColor(vec4 weights,float e1,float e2,vec2 dist)
{
#if ((DEBUG_MODE==1)||(DEBUG_MODE==2))
{
float l9_0;
#if (DEBUG_MODE==1)
{
l9_0=e1*4.0;
}
#else
{
l9_0=e2*4.0;
}
#endif
if (l9_0<0.5)
{
return vec4(1.0,0.0,0.0,1.0);
}
else
{
if (l9_0<1.5)
{
return vec4(0.0,1.0,0.0,1.0);
}
else
{
if (l9_0<3.5)
{
return vec4(0.0,0.0,1.0,1.0);
}
else
{
if (l9_0<4.5)
{
return vec4(1.0,1.0,0.0,1.0);
}
else
{
return vec4(0.5,0.5,0.5,1.0);
}
}
}
}
}
#endif
#if (DEBUG_MODE==3)
{
if (dist.x==0.0)
{
return vec4(1.0,0.0,0.0,1.0);
}
return vec4(dist.x/float(smaaMaxSearchSteps(SMAA_QUALITY)));
}
#else
{
#if (DEBUG_MODE==4)
{
if (dist.y==0.0)
{
return vec4(1.0,0.0,0.0,1.0);
}
return vec4(dist.y/float(smaaMaxSearchSteps(SMAA_QUALITY)));
}
#endif
}
#endif
return weights;
}
int smaaCornerRounding(int smaaQuality)
{
if ((smaaQuality==3)||(smaaQuality==4))
{
return 15;
}
return 0;
}
void SMAADetectHorizontalCornerPattern(inout vec2 weights,vec4 texcoord,vec2 d)
{
if (!smaaDisableDetection(SMAA_QUALITY))
{
int l9_0=smaaCornerRounding(SMAA_QUALITY);
vec2 l9_1=d;
vec2 l9_2=step(l9_1,d.yx);
vec2 l9_3=(l9_2*(1.0-(float(l9_0)/100.0)))/vec2(l9_2.x+l9_2.y);
int l9_4;
#if (edgesTexHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec2 l9_5=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy;
vec2 l9_6=l9_5*vec2(0.0,-1.0);
vec4 l9_7=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_4,texcoord.xy+l9_6,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_8=l9_3.x;
int l9_9;
#if (edgesTexHasSwappedViews)
{
l9_9=1-sc_GetStereoViewIndex();
}
#else
{
l9_9=sc_GetStereoViewIndex();
}
#endif
vec4 l9_10=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_9,texcoord.zw+l9_6,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_11=l9_3.y;
int l9_12;
#if (edgesTexHasSwappedViews)
{
l9_12=1-sc_GetStereoViewIndex();
}
#else
{
l9_12=sc_GetStereoViewIndex();
}
#endif
vec4 l9_13=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_12,texcoord.xy+(l9_5*vec2(0.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_14=1.0-(l9_8*l9_13.x);
int l9_15;
#if (edgesTexHasSwappedViews)
{
l9_15=1-sc_GetStereoViewIndex();
}
#else
{
l9_15=sc_GetStereoViewIndex();
}
#endif
vec2 l9_16=vec2((1.0-(l9_8*l9_7.x))-(l9_11*l9_10.x),l9_14);
l9_16.y=l9_14-(l9_11*sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_15,texcoord.zw+(l9_5*vec2(1.0,2.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).x);
weights*=clamp(l9_16,vec2(0.0),vec2(1.0));
}
}
float SMAASearchYUp(vec2 texcoord,float end)
{
float l9_0=1.0/inputTextureSize.y;
vec2 l9_1;
l9_1=vec2(1.0,0.0);
vec2 l9_2;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
float l9_3=texcoord.y;
float l9_4=end;
bool l9_5=l9_3<l9_4;
bool l9_6;
if (l9_5)
{
l9_6=l9_1.x>0.82810003;
}
else
{
l9_6=l9_5;
}
bool l9_7;
if (l9_6)
{
l9_7=l9_1.y==0.0;
}
else
{
l9_7=l9_6;
}
if (l9_7)
{
int l9_8;
#if (edgesTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
l9_2=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_8,texcoord,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).xy;
texcoord=(vec2(0.0,2.0)*vec4(1.0/inputTextureSize.x,l9_0,inputTextureSize.x,inputTextureSize.y).xy)+texcoord;
l9_1=l9_2;
continue;
}
else
{
break;
}
}
return (l9_0*(-(((-2.007874)*SMAASearchLength(l9_1.yx,0.0))+3.25)))+texcoord.y;
}
float SMAASearchYDown(vec2 texcoord,float end)
{
float l9_0=1.0/inputTextureSize.y;
vec2 l9_1;
l9_1=vec2(1.0,0.0);
vec2 l9_2;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
float l9_3=texcoord.y;
float l9_4=end;
bool l9_5=l9_3>l9_4;
bool l9_6;
if (l9_5)
{
l9_6=l9_1.x>0.82810003;
}
else
{
l9_6=l9_5;
}
bool l9_7;
if (l9_6)
{
l9_7=l9_1.y==0.0;
}
else
{
l9_7=l9_6;
}
if (l9_7)
{
int l9_8;
#if (edgesTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
l9_2=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_8,texcoord,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).xy;
texcoord=(vec2(-0.0,-2.0)*vec4(1.0/inputTextureSize.x,l9_0,inputTextureSize.x,inputTextureSize.y).xy)+texcoord;
l9_1=l9_2;
continue;
}
else
{
break;
}
}
return ((-l9_0)*(-(((-2.007874)*SMAASearchLength(l9_1.yx,0.5))+3.25)))+texcoord.y;
}
void SMAADetectVerticalCornerPattern(inout vec2 weights,vec4 texcoord,vec2 d)
{
if (!smaaDisableDetection(SMAA_QUALITY))
{
int l9_0=smaaCornerRounding(SMAA_QUALITY);
vec2 l9_1=d;
vec2 l9_2=step(l9_1,d.yx);
vec2 l9_3=(l9_2*(1.0-(float(l9_0)/100.0)))/vec2(l9_2.x+l9_2.y);
int l9_4;
#if (edgesTexHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec2 l9_5=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y).xy;
vec4 l9_6=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_4,texcoord.xy+(l9_5*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_7=l9_3.x;
int l9_8;
#if (edgesTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_8,texcoord.zw+(l9_5*vec2(1.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_10=l9_3.y;
int l9_11;
#if (edgesTexHasSwappedViews)
{
l9_11=1-sc_GetStereoViewIndex();
}
#else
{
l9_11=sc_GetStereoViewIndex();
}
#endif
vec4 l9_12=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_11,texcoord.xy+(l9_5*vec2(2.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_13=1.0-(l9_7*l9_12.y);
int l9_14;
#if (edgesTexHasSwappedViews)
{
l9_14=1-sc_GetStereoViewIndex();
}
#else
{
l9_14=sc_GetStereoViewIndex();
}
#endif
vec2 l9_15=vec2((1.0-(l9_7*l9_6.y))-(l9_10*l9_9.y),l9_13);
l9_15.y=l9_13-(l9_10*sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_14,texcoord.zw+(l9_5*vec2(-2.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex).y);
weights*=clamp(l9_15,vec2(0.0),vec2(1.0));
}
}
void main()
{
sc_DiscardStereoFragment();
vec4 l9_0=vec4(1.0/inputTextureSize.x,1.0/inputTextureSize.y,inputTextureSize.x,inputTextureSize.y);
#if (DEBUG_MODE==5)
{
int l9_1;
#if (inputTextureHasSwappedViews)
{
l9_1=1-sc_GetStereoViewIndex();
}
#else
{
l9_1=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(sc_SampleTextureBiasOrLevel(inputTextureDims.xy,inputTextureLayout,l9_1,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_inputTexture)!=0),inputTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTexture,SC_SOFTWARE_WRAP_MODE_V_inputTexture),(int(SC_USE_UV_MIN_MAX_inputTexture)!=0),inputTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTexture)!=0),inputTextureBorderColor,0.0,inputTexture));
return;
}
#endif
int l9_2;
#if (edgesTexHasSwappedViews)
{
l9_2=1-sc_GetStereoViewIndex();
}
#else
{
l9_2=sc_GetStereoViewIndex();
}
#endif
vec4 l9_3=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_2,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
vec2 l9_4=l9_3.xy;
#if (DEBUG_MODE==6)
{
int l9_5;
#if (edgesTexHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
sc_writeFragData0(sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_5,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex));
return;
}
#endif
vec2 l9_6;
vec4 l9_7;
if (l9_3.y>0.0)
{
vec2 l9_8=SMAACalculateDiagWeights(varPackedTex.xy,l9_4,vec4(0.0));
bool l9_9=l9_8.x==(-l9_8.y);
bool l9_10;
if (!l9_9)
{
l9_10=smaaDisableDetection(SMAA_QUALITY);
}
else
{
l9_10=l9_9;
}
vec2 l9_11;
vec4 l9_12;
if (l9_10)
{
float l9_13=SMAASearchXLeft(varOffset0.xy,varOffset2.x);
vec3 l9_14=vec3(0.0);
l9_14.x=l9_13;
vec3 l9_15=l9_14;
l9_15.y=varOffset1.y;
int l9_16;
#if (edgesTexHasSwappedViews)
{
l9_16=1-sc_GetStereoViewIndex();
}
#else
{
l9_16=sc_GetStereoViewIndex();
}
#endif
vec4 l9_17=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_16,l9_15.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_18=l9_17.x;
float l9_19=SMAASearchXRight(varOffset0.zw,varOffset2.y);
vec3 l9_20=vec3(l9_13,varOffset1.y,l9_19);
vec2 l9_21=abs(round((l9_0.zz*vec2(l9_13,l9_19))-varPixCoord.xx));
int l9_22;
#if (edgesTexHasSwappedViews)
{
l9_22=1-sc_GetStereoViewIndex();
}
#else
{
l9_22=sc_GetStereoViewIndex();
}
#endif
vec4 l9_23=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_22,l9_20.zy+(l9_0.xy*vec2(1.0,0.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_24=l9_23.x;
vec2 l9_25=SMAAArea(sqrt(l9_21),l9_18,l9_24,0.0);
vec4 l9_26=DebugColor(vec4(l9_25.x,l9_25.y,vec4(0.0).z,vec4(0.0).w),l9_18,l9_24,l9_21);
vec3 l9_27=l9_20;
l9_27.y=varPackedTex.y;
vec2 param_78=l9_26.xy;
SMAADetectHorizontalCornerPattern(param_78,l9_27.xyzy,l9_21);
l9_12=vec4(param_78.x,param_78.y,l9_26.z,l9_26.w);
l9_11=l9_4;
}
else
{
vec2 l9_28=vec2(0.0);
l9_28.x=0.0;
l9_12=vec4(l9_8.x,l9_8.y,vec4(0.0).z,vec4(0.0).w);
l9_11=l9_28;
}
l9_7=l9_12;
l9_6=l9_11;
}
else
{
l9_7=vec4(0.0);
l9_6=l9_4;
}
vec4 l9_29;
if (l9_6.x>0.0)
{
float l9_30=SMAASearchYUp(varOffset1.xy,varOffset2.z);
vec3 l9_31=vec3(0.0);
l9_31.y=l9_30;
vec3 l9_32=l9_31;
l9_32.x=varOffset0.x;
int l9_33;
#if (edgesTexHasSwappedViews)
{
l9_33=1-sc_GetStereoViewIndex();
}
#else
{
l9_33=sc_GetStereoViewIndex();
}
#endif
vec4 l9_34=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_33,l9_32.xy,(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_35=l9_34.y;
float l9_36=SMAASearchYDown(varOffset1.zw,varOffset2.w);
vec3 l9_37=vec3(varOffset0.x,l9_30,l9_36);
vec2 l9_38=abs(round((l9_0.ww*vec2(l9_30,l9_36))-varPixCoord.yy));
int l9_39;
#if (edgesTexHasSwappedViews)
{
l9_39=1-sc_GetStereoViewIndex();
}
#else
{
l9_39=sc_GetStereoViewIndex();
}
#endif
vec4 l9_40=sc_SampleTextureBiasOrLevel(edgesTexDims.xy,edgesTexLayout,l9_39,l9_37.xz+(l9_0.xy*vec2(0.0,-1.0)),(int(SC_USE_UV_TRANSFORM_edgesTex)!=0),edgesTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_edgesTex,SC_SOFTWARE_WRAP_MODE_V_edgesTex),(int(SC_USE_UV_MIN_MAX_edgesTex)!=0),edgesTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_edgesTex)!=0),edgesTexBorderColor,0.0,edgesTex);
float l9_41=l9_40.y;
vec2 l9_42=SMAAArea(sqrt(l9_38),l9_35,l9_41,0.0);
vec4 l9_43=DebugColor(vec4(l9_7.x,l9_7.y,l9_42.x,l9_42.y),l9_35,l9_41,l9_38);
vec3 l9_44=l9_37;
l9_44.x=varPackedTex.x;
vec2 param_117=l9_43.zw;
SMAADetectVerticalCornerPattern(param_117,l9_44.xyxz,l9_38);
l9_29=vec4(l9_43.x,l9_43.y,param_117.x,param_117.y);
}
else
{
l9_29=l9_7;
}
sc_writeFragData0(l9_29);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
