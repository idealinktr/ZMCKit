#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//output vec4 sc_FragData0 0
//sampler sampler baseTexSmpSC 0:2
//sampler sampler baseUTexSmpSC 0:3
//texture texture2D baseTex 0:0:0:2
//texture utexture2D baseUTex 0:1:0:3
//ubo float UserUniforms 0:4:32 {
//float4 baseColor 0
//float maxDepth 16
//float distanceScale 20
//int maxCasterId 24
//}
//spec_const int PROGRAM_INDEX 0 0
//SG_REFLECTION_END
constant int PROGRAM_INDEX [[function_constant(0)]];
constant int PROGRAM_INDEX_tmp = is_function_constant_defined(PROGRAM_INDEX) ? PROGRAM_INDEX : 0;

namespace SNAP_VS {
struct userUniformsObj
{
float4 baseColor;
float maxDepth;
float distanceScale;
int maxCasterId;
};
struct sc_Set0
{
texture2d<float> baseTex [[id(0)]];
texture2d<uint> baseUTex [[id(1)]];
sampler baseTexSmpSC [[id(2)]];
sampler baseUTexSmpSC [[id(3)]];
constant userUniformsObj* UserUniforms [[id(4)]];
};
struct main_vert_out
{
float4 gl_Position [[position]];
};
struct main_vert_in
{
float4 position [[attribute(0)]];
};
vertex main_vert_out main_vert(main_vert_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]])
{
main_vert_out out={};
float4 param=float4(in.position.xy,0.0,1.0);
float4 l9_0=float4(param.x,-param.y,(param.z*0.5)+(param.w*0.5),param.w);
out.gl_Position=l9_0;
return out;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct userUniformsObj
{
float4 baseColor;
float maxDepth;
float distanceScale;
int maxCasterId;
};
struct sc_Set0
{
texture2d<float> baseTex [[id(0)]];
texture2d<uint> baseUTex [[id(1)]];
sampler baseTexSmpSC [[id(2)]];
sampler baseUTexSmpSC [[id(3)]];
constant userUniformsObj* UserUniforms [[id(4)]];
};
struct main_frag_out
{
float4 sc_FragData0 [[color(0)]];
};
fragment main_frag_out main_frag(constant sc_Set0& sc_set0 [[buffer(0)]],float4 gl_FragCoord [[position]])
{
main_frag_out out={};
int2 screenPos=int2(gl_FragCoord.xy);
if (PROGRAM_INDEX_tmp==0)
{
float depth=sc_set0.baseTex.read(uint2(screenPos),0).x;
if (depth==0.0)
{
out.sc_FragData0=float4(0.0,1.0,0.0,1.0);
}
else
{
if (depth==1.0)
{
out.sc_FragData0=float4(0.0,0.0,1.0,1.0);
}
else
{
float w=0.02;
float ld=w/((1.0+w)-depth);
out.sc_FragData0=float4(ld,ld,ld,1.0);
}
}
}
else
{
if (PROGRAM_INDEX_tmp==1)
{
out.sc_FragData0=(*sc_set0.UserUniforms).baseColor;
}
else
{
if (PROGRAM_INDEX_tmp==2)
{
uint4 receiverData1=sc_set0.baseUTex.read(uint2(screenPos),0);
uint2 param=receiverData1.xy;
float2 l9_0=float2(as_type<half2>(param.x|(param.y<<uint(16))));
float2 l9_1=l9_0;
float3 l9_2=float3(l9_1.x,l9_1.y,(1.0-abs(l9_1.x))-abs(l9_1.y));
float l9_3=fast::max(-l9_2.z,0.0);
float l9_4;
if (l9_2.x>=0.0)
{
l9_4=-l9_3;
}
else
{
l9_4=l9_3;
}
float l9_5=l9_4;
float l9_6;
if (l9_2.y>=0.0)
{
l9_6=-l9_3;
}
else
{
l9_6=l9_3;
}
float2 l9_7=l9_2.xy+float2(l9_5,l9_6);
l9_2=float3(l9_7.x,l9_7.y,l9_2.z);
float3 l9_8=normalize(l9_2);
float3 l9_9=l9_8;
float3 normal=l9_9;
out.sc_FragData0=float4((normal*0.5)+float3(0.5),1.0);
}
else
{
if (PROGRAM_INDEX_tmp==3)
{
uint4 receiverData1_1=sc_set0.baseUTex.read(uint2(screenPos),0);
uint param_1=receiverData1_1.w;
param_1 &= 1023u;
float l9_10=float(param_1)/1000.0;
float roughness=l9_10;
out.sc_FragData0=float4(float3(roughness),1.0);
}
else
{
if (PROGRAM_INDEX_tmp==4)
{
uint4 receiverData0=sc_set0.baseUTex.read(uint2(screenPos),0);
if (all(receiverData0.xyz==uint3(0u)))
{
out.sc_FragData0=float4(0.0,0.0,0.0,1.0);
}
else
{
float3 col=float3(receiverData0.xyz)/float3(65535.0);
out.sc_FragData0=float4(col,1.0);
}
uint mask=receiverData0.w;
if (mask==0u)
{
int2 m=(screenPos/int2(4))%int2(2);
out.sc_FragData0*=float4(float(abs(m.x-m.y)));
}
}
else
{
if (PROGRAM_INDEX_tmp==5)
{
float2 encodedDirection=sc_set0.baseTex.read(uint2(screenPos),0).xy;
float2 param_2=encodedDirection;
float3 l9_11=float3(param_2.x,param_2.y,(1.0-abs(param_2.x))-abs(param_2.y));
float l9_12=fast::max(-l9_11.z,0.0);
float l9_13;
if (l9_11.x>=0.0)
{
l9_13=-l9_12;
}
else
{
l9_13=l9_12;
}
float l9_14=l9_13;
float l9_15;
if (l9_11.y>=0.0)
{
l9_15=-l9_12;
}
else
{
l9_15=l9_12;
}
float2 l9_16=l9_11.xy+float2(l9_14,l9_15);
l9_11=float3(l9_16.x,l9_16.y,l9_11.z);
float3 l9_17=normalize(l9_11);
float3 direction=l9_17;
out.sc_FragData0=float4((direction*0.5)+float3(0.5),1.0);
}
else
{
if (PROGRAM_INDEX_tmp==6)
{
uint rawDistance=sc_set0.baseUTex.read(uint2(screenPos),0).x;
if (rawDistance==4294967295u)
{
int2 m_1=(screenPos/int2(4))%int2(2);
float f=float(abs(m_1.x-m_1.y));
out.sc_FragData0=float4(float3(f),1.0);
}
else
{
float d=float(rawDistance)/(*sc_set0.UserUniforms).distanceScale;
float r=1.0-fract(d);
float g=1.0-fract(d*0.1);
float b=1.0-fract(d*0.0099999998);
out.sc_FragData0=float4(r,g,b,1.0);
}
}
else
{
if (PROGRAM_INDEX_tmp==7)
{
uint4 idAndBarycentric=sc_set0.baseUTex.read(uint2(screenPos),0);
float2 brcVW=float2(float2(as_type<half2>(idAndBarycentric.z)).x,float2(as_type<half2>(idAndBarycentric.w)).x);
float3 brc=float3((1.0-brcVW.x)-brcVW.y,brcVW);
out.sc_FragData0=float4(brc,1.0);
}
else
{
if (PROGRAM_INDEX_tmp==8)
{
uint4 idAndBarycentric_1=sc_set0.baseUTex.read(uint2(screenPos),0);
uint casterId=idAndBarycentric_1.x;
if (casterId==0u)
{
out.sc_FragData0=float4(1.0,0.0,1.0,1.0);
}
else
{
float v=float(casterId)/float((*sc_set0.UserUniforms).maxCasterId);
out.sc_FragData0=float4(v,v,1.0,1.0);
}
}
else
{
if (PROGRAM_INDEX_tmp==9)
{
uint4 idAndBarycentric_2=sc_set0.baseUTex.read(uint2(screenPos),0);
uint primId=idAndBarycentric_2.y;
if (primId==0u)
{
out.sc_FragData0=float4(1.0);
}
else
{
float h=float(primId%24u)/24.0;
float param_3=h;
float param_4=1.0;
float param_5=1.0;
float3 l9_18=abs((fract(float3(param_3)+float3(1.0,0.66666669,0.33333334))*6.0)-float3(3.0));
float3 l9_19=float3(param_5)*mix(float3(1.0),fast::clamp(l9_18-float3(1.0),float3(0.0),float3(1.0)),float3(param_4));
out.sc_FragData0=float4(l9_19,1.0);
}
}
else
{
if (PROGRAM_INDEX_tmp==10)
{
float depth_1=sc_set0.baseTex.read(uint2(screenPos),0).x;
if (depth_1==0.0)
{
out.sc_FragData0=float4(0.0,0.0,0.0,1.0);
}
else
{
if (depth_1>=(*sc_set0.UserUniforms).maxDepth)
{
out.sc_FragData0=float4(0.0,0.0,1.0,1.0);
}
else
{
float color=depth_1/(*sc_set0.UserUniforms).maxDepth;
out.sc_FragData0=float4(color,color,color,1.0);
}
}
}
else
{
if (PROGRAM_INDEX_tmp==11)
{
float4 col_1=sc_set0.baseTex.read(uint2(screenPos),0);
int2 m_2=(screenPos/int2(16))%int2(2);
float3 squares=float3(mix(0.60000002,0.69999999,float(abs(m_2.x-m_2.y))));
float3 l9_20=mix(squares,col_1.xyz,float3(col_1.w));
col_1=float4(l9_20.x,l9_20.y,l9_20.z,col_1.w);
out.sc_FragData0=float4(col_1.xyz,1.0);
}
else
{
if (PROGRAM_INDEX_tmp==12)
{
float4 col_2=sc_set0.baseTex.read(uint2(screenPos),0);
int2 m_3=(screenPos/int2(16))%int2(2);
float3 squares_1=float3(mix(0.60000002,0.69999999,float(abs(m_3.x-m_3.y))));
float3 param_6=col_2.xyz;
bool3 l9_21=param_6<=float3(0.5);
float3 l9_22=(param_6*param_6)/float3(3.0);
float3 l9_23=(exp((param_6-float3(0.55991071))/float3(0.17883277))+float3(0.28466892))/float3(12.0);
float3 l9_24=float3(l9_21.x ? l9_22.x : l9_23.x,l9_21.y ? l9_22.y : l9_23.y,l9_21.z ? l9_22.z : l9_23.z);
float3 l9_25=mix(squares_1,l9_24,float3(col_2.w));
col_2=float4(l9_25.x,l9_25.y,l9_25.z,col_2.w);
out.sc_FragData0=float4(col_2.xyz,1.0);
}
else
{
if (PROGRAM_INDEX_tmp==13)
{
float normalizedKernel=sc_set0.baseTex.read(uint2(screenPos),0).x;
float kernel0=(normalizedKernel*255.0)/55.0;
float hue=fast::clamp((kernel0/0.94999999)+0.050000001,0.0,1.0);
float value=(kernel0<0.050000001) ? 0.2 : 1.0;
float param_7=hue;
float param_8=1.0;
float param_9=value;
float3 l9_26=abs((fract(float3(param_7)+float3(1.0,0.66666669,0.33333334))*6.0)-float3(3.0));
float3 l9_27=float3(param_9)*mix(float3(1.0),fast::clamp(l9_26-float3(1.0),float3(0.0),float3(1.0)),float3(param_8));
out.sc_FragData0=float4(l9_27,1.0);
}
else
{
if (PROGRAM_INDEX_tmp==14)
{
float shadowPrepass=sc_set0.baseTex.read(uint2(screenPos),0).x;
if (shadowPrepass==(-1000.0))
{
out.sc_FragData0=float4(1.0);
}
else
{
if (shadowPrepass==1000.0)
{
out.sc_FragData0=float4(1.0,1.0,0.0,1.0);
}
else
{
out.sc_FragData0=float4(abs(shadowPrepass),0.0,0.0,1.0);
}
}
}
else
{
if (PROGRAM_INDEX_tmp==15)
{
float shadow=sc_set0.baseTex.read(uint2(screenPos),0).x;
out.sc_FragData0=float4(float3(shadow),1.0);
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
return out;
}
} // FRAGMENT SHADER
