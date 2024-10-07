//-----------------------------------------------------------------------
// Copyright (c) 2017 Snap Inc.
//-----------------------------------------------------------------------
#include <required.glsl>

#ifndef ARGBTEX_SWIZZLE
#define ARGBTEX_SWIZZLE 0
#endif

#ifndef USE_TEXTURE_2D
#define USE_TEXTURE_2D 0
#endif

#if USE_TEXTURE_2D == 0
uniform sampler2DRect rectTexture;
uniform vec2 texSize;
#else
uniform sampler2D rectTexture;
#endif

varying vec2 varTex0;

#ifdef VERTEX_SHADER
attribute vec2 position;
attribute vec2 texture0;

void main(void) {
    varTex0 = texture0;
    gl_Position = vec4(position, 0.0, 1.0);
}
#endif

#ifdef FRAGMENT_SHADER
void main(void) {

    #if USE_TEXTURE_2D == 0
    vec4 col = texture2DRect(rectTexture, varTex0 * texSize);
    #else
    vec4 col = texture2D(rectTexture, varTex0);
    #endif

    #if ARGBTEX_SWIZZLE == 0
    gl_FragColor = col;
    #else
    gl_FragColor = col.grab;
    #endif
}
#endif
