#pragma once
//SG_REFLECTION_BEGIN(100)
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#include <std2.glsl>
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
vec2 encodeVal(float f)
{
float res=floor(f*65535.0);
float msb=floor(res*0.00390625);
return vec2(msb/255.0,(res-(msb*256.0))/255.0);
}
float decodeVal(vec2 v)
{
return ((((v.x*255.0)*256.0)+(v.y*255.0))/65535.0)+7.6295e-06;
}
vec4 encodeMotionVector(vec2 v)
{
return vec4(encodeVal((v.x*5.0)+0.5),encodeVal((v.y*5.0)+0.5));
}
vec2 decodeMotionVector(vec4 v)
{
return vec2((decodeVal(v.xy)*0.2)-0.1,(decodeVal(v.zw)*0.2)-0.1);
}
vec4 computeMotionVector(vec3 surfacePosWorldSpace)
{
vec4 surfacePosNDC=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(surfacePosWorldSpace,1.0);
vec2 l9_0=surfacePosNDC.xy/vec2(surfacePosNDC.w);
surfacePosNDC=vec4(l9_0.x,l9_0.y,surfacePosNDC.z,surfacePosNDC.w);
vec4 prevFramePosNDC=((sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*sc_PrevFrameModelMatrix)*sc_ModelMatrixInverse)*vec4(surfacePosWorldSpace,1.0);
vec2 l9_1=prevFramePosNDC.xy/vec2(prevFramePosNDC.w);
prevFramePosNDC=vec4(l9_1.x,l9_1.y,prevFramePosNDC.z,prevFramePosNDC.w);
vec2 velocity=(surfacePosNDC.xy-prevFramePosNDC.xy)*0.5;
return encodeMotionVector(velocity);
}
vec4 outputMotionVectorsIfNeeded(vec3 surfacePosWorldSpace,vec4 finalColor)
{
#if (sc_MotionVectorsPass)
{
return computeMotionVector(surfacePosWorldSpace);
}
#else
{
return finalColor;
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
