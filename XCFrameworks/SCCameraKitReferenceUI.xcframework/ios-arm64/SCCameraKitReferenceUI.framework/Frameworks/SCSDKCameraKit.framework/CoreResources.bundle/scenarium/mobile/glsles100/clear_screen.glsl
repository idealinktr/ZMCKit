#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 color;
void main()
{
sc_ProcessVertex(sc_LoadVertexAttributes());
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#define STD_DISABLE_VERTEX_NORMAL 1
#define STD_DISABLE_VERTEX_TANGENT 1
#define STD_DISABLE_VERTEX_TEXTURE0 1
#define STD_DISABLE_VERTEX_TEXTURE1 1
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_fs.glsl>
uniform vec4 color;
void main()
{
sc_DiscardStereoFragment();
sc_writeFragData0(color);
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
