#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//attribute vec2 uv 18
//sampler sampler texCenterXYZScaleXSmp 2:5
//sampler sampler texChunkInfoSmp 2:6
//sampler sampler texColorSmp 2:7
//sampler sampler texRotationSmp 2:8
//sampler sampler texScaleYZSmp 2:9
//texture texture2D texCenterXYZScaleX 2:0:2:5
//texture texture2D texChunkInfo 2:1:2:6
//texture texture2D texColor 2:2:2:7
//texture texture2D texRotation 2:3:2:8
//texture texture2D texScaleYZ 2:4:2:9
//SG_REFLECTION_END
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
#ifndef sc_ChunkySplats
#define sc_ChunkySplats 0
#elif sc_ChunkySplats==1
#undef sc_ChunkySplats
#define sc_ChunkySplats 1
#endif
uniform vec4 dims;
uniform highp sampler2D texChunkInfo;
uniform highp sampler2D texCenterXYZScaleX;
uniform highp sampler2D texScaleYZ;
uniform highp sampler2D texRotation;
uniform highp sampler2D texColor;
attribute vec2 uv;
varying vec4 varColor;
varying vec2 varTexCoord;
vec3 inCenter;
vec3 inScale;
vec3 inRotation;
vec4 inColor;
void evalDataUV()
{
#if (sc_ChunkySplats)
{
ivec2 l9_0=ivec2((uv*dims.xy)-vec2(0.40000001));
int l9_1=(l9_0.x+(l9_0.y*int(dims.x+0.5)))/256;
int l9_2=int(dims.z)/3;
vec2 l9_3=(vec2(ivec2(3*(l9_1%l9_2),l9_1/l9_2))+vec2(0.5))/dims.zw;
vec2 l9_4=vec2(1.0/dims.z,0.0);
vec4 l9_5=texture2DLodEXT(texChunkInfo,l9_3+vec2(0.0),0.0);
vec4 l9_6=texture2DLodEXT(texChunkInfo,l9_3+(l9_4*1.0),0.0);
vec4 l9_7=texture2DLodEXT(texChunkInfo,l9_3+(l9_4*2.0),0.0);
inCenter=mix(l9_5.xyz,l9_6.xyz,texture2DLodEXT(texCenterXYZScaleX,uv,0.0).xyz);
inScale=mix(l9_7.xyz,vec3(l9_5.w,l9_6.w,l9_7.w),texture2DLodEXT(texScaleYZ,uv,0.0).xyz);
}
#else
{
vec4 l9_8=texture2DLodEXT(texCenterXYZScaleX,uv,0.0);
inCenter=l9_8.xyz;
inScale=vec3(l9_8.w,texture2DLodEXT(texScaleYZ,uv,0.0).xy);
}
#endif
inRotation=texture2DLodEXT(texRotation,uv,0.0).xyz;
inColor=texture2DLodEXT(texColor,uv,0.0);
}
void computeCov3d(mat3 rot,vec3 scale,out vec3 covA,out vec3 covB)
{
float l9_0=scale.x*rot[0].x;
float l9_1=scale.x*rot[0].y;
float l9_2=scale.x*rot[0].z;
float l9_3=scale.y*rot[1].x;
float l9_4=scale.y*rot[1].y;
float l9_5=scale.y*rot[1].z;
float l9_6=scale.z*rot[2].x;
float l9_7=scale.z*rot[2].y;
float l9_8=scale.z*rot[2].z;
covA=vec3(((l9_0*l9_0)+(l9_3*l9_3))+(l9_6*l9_6),((l9_0*l9_1)+(l9_3*l9_4))+(l9_6*l9_7),((l9_0*l9_2)+(l9_3*l9_5))+(l9_6*l9_8));
covB=vec3(((l9_1*l9_1)+(l9_4*l9_4))+(l9_7*l9_7),((l9_1*l9_2)+(l9_4*l9_5))+(l9_7*l9_8),((l9_2*l9_2)+(l9_5*l9_5))+(l9_8*l9_8));
}
vec4 evalSplat(vec4 centerWorld)
{
vec4 l9_0=centerWorld;
vec4 l9_1=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_0;
vec4 l9_2=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_1;
float l9_3=l9_2.w;
if (l9_2.z<(-l9_3))
{
return vec4(0.0,0.0,2.0,1.0);
}
vec3 l9_4=inScale;
vec3 l9_5=inRotation;
vec3 l9_6=(l9_5*2.0)-vec3(1.0);
float l9_7=1.0-dot(l9_6,l9_6);
float l9_8;
if (l9_7>0.0)
{
l9_8=sqrt(l9_7);
}
else
{
l9_8=0.0;
}
float l9_9=l9_6.x;
float l9_10=l9_6.y;
float l9_11=l9_6.z;
varColor=inColor;
float l9_12=l9_11*l9_11;
float l9_13=l9_8*l9_8;
float l9_14=l9_10*l9_11;
float l9_15=l9_8*l9_9;
float l9_16=l9_10*l9_8;
float l9_17=l9_11*l9_9;
float l9_18=l9_10*l9_10;
float l9_19=l9_11*l9_8;
float l9_20=l9_10*l9_9;
vec3 param_2;
vec3 param_3;
computeCov3d(mat3(sc_ModelMatrix[0].xyz,sc_ModelMatrix[1].xyz,sc_ModelMatrix[2].xyz)*mat3(vec3(1.0-(2.0*(l9_12+l9_13)),2.0*(l9_14+l9_15),2.0*(l9_16-l9_17)),vec3(2.0*(l9_14-l9_15),1.0-(2.0*(l9_18+l9_13)),2.0*(l9_19+l9_20)),vec3(2.0*(l9_16+l9_17),2.0*(l9_19-l9_20),1.0-(2.0*(l9_18+l9_12)))),l9_4,param_2,param_3);
vec3 l9_21=param_2;
float l9_22=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][0].x*sc_CurrentRenderTargetDims.x;
float l9_23=l9_1.z;
float l9_24=l9_22/l9_23;
float l9_25=l9_23*l9_23;
int l9_26=sc_GetStereoViewIndex();
mat3 l9_27=mat3(sc_ViewMatrixInverseArray[l9_26][0].xyz,sc_ViewMatrixInverseArray[l9_26][1].xyz,sc_ViewMatrixInverseArray[l9_26][2].xyz)*mat3(vec3(l9_24,0.0,(-(l9_22*l9_1.x))/l9_25),vec3(0.0,l9_24,(-(l9_22*l9_1.y))/l9_25),vec3(0.0));
mat3 l9_28=(transpose(l9_27)*mat3(l9_21,vec3(l9_21.y,param_3.xy),vec3(l9_21.z,param_3.yz)))*l9_27;
float l9_29=l9_28[0].x+0.30000001;
float l9_30=l9_28[0].y;
float l9_31=l9_28[1].y+0.30000001;
float l9_32=0.5*(l9_29+l9_31);
float l9_33=length(vec2((l9_29-l9_31)/2.0,l9_30));
float l9_34=l9_32+l9_33;
vec2 l9_35=normalize(vec2(l9_30,l9_34-l9_29));
vec2 l9_36=l9_35*min(sqrt(2.0*l9_34),1024.0);
vec2 l9_37=vec2(l9_35.y,-l9_35.x)*min(sqrt(2.0*max(l9_32-l9_33,0.1)),1024.0);
bool l9_38=dot(l9_36,l9_36)<4.0;
bool l9_39;
if (l9_38)
{
l9_39=dot(l9_37,l9_37)<4.0;
}
else
{
l9_39=l9_38;
}
if (l9_39)
{
return vec4(0.0,0.0,2.0,1.0);
}
vec2 l9_40=vec2(((ivec2(gl_VertexID)&ivec2(1,2))<<ivec2(1,0))-ivec2(1));
varTexCoord=l9_40*2.0;
return l9_2+(vec4((((l9_36*l9_40.x)+(l9_37*l9_40.y))*sc_CurrentRenderTargetDims.zw)*2.0,0.0,0.0)*l9_3);
}
void main()
{
evalDataUV();
vec4 l9_0=evalSplat(sc_ModelMatrix*vec4(inCenter,1.0));
sc_SetClipPosition(l9_0);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
#include <std2_fs.glsl>
varying vec2 varTexCoord;
varying vec4 varColor;
void main()
{
sc_DiscardStereoFragment();
float l9_0=-dot(varTexCoord,varTexCoord);
if (l9_0<(-4.0))
{
discard;
}
sc_writeFragData0(vec4(varColor.xyz,exp(l9_0)*varColor.w));
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
