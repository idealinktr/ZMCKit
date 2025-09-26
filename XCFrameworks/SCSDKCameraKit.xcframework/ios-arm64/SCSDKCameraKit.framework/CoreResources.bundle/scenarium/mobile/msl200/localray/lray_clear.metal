#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
//SG_REFLECTION_BEGIN(200)
//attribute vec4 position 0
//output uint tmax 0
//output uvec4 id_and_barycentrics 1
//SG_REFLECTION_END

namespace SNAP_VS {
struct main_vert_out
{
float4 gl_Position [[position]];
};
struct main_vert_in
{
float4 position [[attribute(0)]];
};
vertex main_vert_out main_vert(main_vert_in in [[stage_in]])
{
main_vert_out out={};
out.gl_Position=float4(in.position.xy,-2.0,1.0);
return out;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct main_frag_out
{
uint tmax [[color(0)]];
uint4 id_and_barycentrics [[color(1)]];
};
fragment main_frag_out main_frag()
{
main_frag_out out={};
out.tmax=4294967295u;
out.id_and_barycentrics=uint4(0u);
return out;
}
} // FRAGMENT SHADER
