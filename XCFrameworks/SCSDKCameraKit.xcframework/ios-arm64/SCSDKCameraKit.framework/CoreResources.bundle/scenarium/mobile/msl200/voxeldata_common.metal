#pragma once
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
#include "std2_vs.metal"
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END

namespace SNAP_VS {
float2 UVW2UV(thread const float3& uvw,thread const float& sliceCount,thread const float& tileSize)
{
int sliceIndex=int(uvw.z*sliceCount);
float2 tileOffset=float2(float(sliceIndex%int(tileSize)),float(sliceIndex/int(tileSize)));
float2 uv=float2(uvw.x,uvw.y);
uv+=tileOffset;
uv/=float2(tileSize);
return uv;
}
float3 UV2UVW(thread const float2& uv,thread const float& sliceCount,thread const float& tileSize)
{
float tileX=floor(uv.x*tileSize);
float tileY=floor(uv.y*tileSize);
float3 uvw=float3(0.0);
uvw.x=fract(uv.x*tileSize);
uvw.y=fract(uv.y*tileSize);
uvw.z=(tileX+(tileY*tileSize))/sliceCount;
return uvw;
}
} // VERTEX SHADER


namespace SNAP_FS {
float2 UVW2UV(thread const float3& uvw,thread const float& sliceCount,thread const float& tileSize)
{
int sliceIndex=int(uvw.z*sliceCount);
float2 tileOffset=float2(float(sliceIndex%int(tileSize)),float(sliceIndex/int(tileSize)));
float2 uv=float2(uvw.x,uvw.y);
uv+=tileOffset;
uv/=float2(tileSize);
return uv;
}
float3 UV2UVW(thread const float2& uv,thread const float& sliceCount,thread const float& tileSize)
{
float tileX=floor(uv.x*tileSize);
float tileY=floor(uv.y*tileSize);
float3 uvw=float3(0.0);
uvw.x=fract(uv.x*tileSize);
uvw.y=fract(uv.y*tileSize);
uvw.z=(tileX+(tileY*tileSize))/sliceCount;
return uvw;
}
} // FRAGMENT SHADER
