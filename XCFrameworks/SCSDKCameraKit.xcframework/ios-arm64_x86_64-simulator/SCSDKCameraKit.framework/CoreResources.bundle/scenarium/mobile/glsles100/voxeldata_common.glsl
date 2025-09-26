#pragma once
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <std2_vs.glsl>
vec2 UVW2UV(vec3 uvw,float sliceCount,float tileSize)
{
int sliceIndex=int(uvw.z*sliceCount);
vec2 tileOffset=vec2(float(sliceIndex%int(tileSize)),float(sliceIndex/int(tileSize)));
vec2 uv=vec2(uvw.x,uvw.y);
uv+=tileOffset;
uv/=vec2(tileSize);
return uv;
}
vec3 UV2UVW(vec2 uv,float sliceCount,float tileSize)
{
float tileX=floor(uv.x*tileSize);
float tileY=floor(uv.y*tileSize);
vec3 uvw;
uvw.x=fract(uv.x*tileSize);
uvw.y=fract(uv.y*tileSize);
uvw.z=(tileX+(tileY*tileSize))/sliceCount;
return uvw;
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2_vs.glsl>
vec2 UVW2UV(vec3 uvw,float sliceCount,float tileSize)
{
int sliceIndex=int(uvw.z*sliceCount);
vec2 tileOffset=vec2(float(sliceIndex%int(tileSize)),float(sliceIndex/int(tileSize)));
vec2 uv=vec2(uvw.x,uvw.y);
uv+=tileOffset;
uv/=vec2(tileSize);
return uv;
}
vec3 UV2UVW(vec2 uv,float sliceCount,float tileSize)
{
float tileX=floor(uv.x*tileSize);
float tileY=floor(uv.y*tileSize);
vec3 uvw;
uvw.x=fract(uv.x*tileSize);
uvw.y=fract(uv.y*tileSize);
uvw.z=(tileX+(tileY*tileSize))/sliceCount;
return uvw;
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
