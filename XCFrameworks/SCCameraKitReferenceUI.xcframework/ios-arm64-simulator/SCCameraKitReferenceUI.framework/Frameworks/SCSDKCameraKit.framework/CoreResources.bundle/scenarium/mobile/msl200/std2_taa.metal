#pragma once
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
#include "std2.metal"
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END

namespace SNAP_VS {
} // VERTEX SHADER


namespace SNAP_FS {
float2 encodeVal(thread const float& f)
{
float res=floor(f*65535.0);
float msb=floor(res*0.00390625);
return float2(msb/255.0,(res-(msb*256.0))/255.0);
}
float decodeVal(thread const float2& v)
{
return ((((v.x*255.0)*256.0)+(v.y*255.0))/65535.0)+7.6295e-06;
}
float4 encodeMotionVector(thread const float2& v)
{
float param=(v.x*5.0)+0.5;
float param_1=(v.y*5.0)+0.5;
return float4(encodeVal(param),encodeVal(param_1));
}
float2 decodeMotionVector(thread const float4& v)
{
float2 param=v.xy;
float2 param_1=v.zw;
return float2((decodeVal(param)*0.2)-0.1,(decodeVal(param_1)*0.2)-0.1);
}
float4 computeMotionVector(thread const float3& surfacePosWorldSpace,thread sc_SysIn& sc_sysIn,const constant sc_Set0& sc_set0,const constant sc_Set1& sc_set1)
{
float4 surfacePosNDC=(*sc_set0.LibraryUniforms).sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1)]*float4(surfacePosWorldSpace,1.0);
float2 l9_0=surfacePosNDC.xy/float2(surfacePosNDC.w);
surfacePosNDC=float4(l9_0.x,l9_0.y,surfacePosNDC.z,surfacePosNDC.w);
float4 prevFramePosNDC=(((*sc_set0.LibraryUniforms).sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex(sc_sysIn,sc_set0,sc_set1)]*(*sc_set0.LibraryUniforms).sc_PrevFrameModelMatrix)*(*sc_set0.LibraryUniforms).sc_ModelMatrixInverse)*float4(surfacePosWorldSpace,1.0);
float2 l9_1=prevFramePosNDC.xy/float2(prevFramePosNDC.w);
prevFramePosNDC=float4(l9_1.x,l9_1.y,prevFramePosNDC.z,prevFramePosNDC.w);
float2 velocity=(surfacePosNDC.xy-prevFramePosNDC.xy)*0.5;
float2 param=velocity;
return encodeMotionVector(param);
}
float4 outputMotionVectorsIfNeeded(thread const float3& surfacePosWorldSpace,thread const float4& finalColor,thread sc_SysIn& sc_sysIn,const constant sc_Set0& sc_set0,const constant sc_Set1& sc_set1)
{
#if (sc_MotionVectorsPass)
{
float3 param=surfacePosWorldSpace;
return computeMotionVector(param,sc_sysIn,sc_set0,sc_set1);
}
#else
{
return finalColor;
}
#endif
}
} // FRAGMENT SHADER
