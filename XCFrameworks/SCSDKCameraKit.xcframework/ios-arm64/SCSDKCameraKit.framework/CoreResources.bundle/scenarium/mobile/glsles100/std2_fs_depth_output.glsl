#pragma once
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <std2.glsl>
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
void sc_writeFragDepth100ShaderConvertedTo300(float dep)
{
#if __VERSION__>100
gl_FragDepth=dep;
#endif
}
void sc_writeFragDepth(float dep)
{
sc_writeFragDepth100ShaderConvertedTo300(dep);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
