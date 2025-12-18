// MIT License

// Copyright (c) 2025 João Chrisóstomo

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//!HOOK OUTPUT
//!BIND OUTPUT
//!DESC Rapid Sharpen 1st Pass

vec4 rgb2ycbcr_bt709(vec4 color) {
    vec3 rgb = clamp(color.rgb, 0.0, 1.0);
    const mat3 mat = mat3(
        vec3( 0.2126,   -0.114572,  0.5),
        vec3( 0.7152,   -0.385428, -0.454153),
        vec3( 0.0722,    0.5,      -0.045847));

    vec3 ycbcr = (mat * rgb) + vec3(0.0, 0.5, 0.5);
    return vec4(clamp(ycbcr, 0.0, 1.0), color.a);
}

vec4 hook() {
    return rgb2ycbcr_bt709(OUTPUT_texOff(vec2( 0.0,  0.0)));
}

//!PARAM strength
//!DESC Mixing Strength
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 1
1.0

//!HOOK OUTPUT
//!BIND OUTPUT
//!DESC Rapid Sharpen 2nd Pass

vec4 ycbcr2rgb_bt709(vec4 color) {
    vec3 ycbcr = clamp(color.rgb, 0.0, 1.0);
    ycbcr.yz -= 0.5;
    const mat3 mat = mat3(
        vec3(1.0,  1.0,     1.0),
        vec3(0.0, -0.1873,  1.8556),
        vec3(1.5748, -0.4681, 0.0));

    vec3 rgb = mat * ycbcr;
    return vec4(clamp(rgb, 0.0, 1.0), color.a);
}

vec4 hook() {
    vec4 aa = OUTPUT_texOff(vec2(-1.0, -1.0));
    vec4 ab = OUTPUT_texOff(vec2(-1.0,  0.0));
    vec4 ac = OUTPUT_texOff(vec2(-1.0,  1.0));

    vec4 ba = OUTPUT_texOff(vec2( 0.0, -1.0));
    vec4 bb = OUTPUT_texOff(vec2( 0.0,  0.0));
    vec4 bc = OUTPUT_texOff(vec2( 0.0,  1.0));

    vec4 ca = OUTPUT_texOff(vec2( 1.0, -1.0));
    vec4 cb = OUTPUT_texOff(vec2( 1.0,  0.0));
    vec4 cc = OUTPUT_texOff(vec2( 1.0,  1.0));

    vec4 avg = (bb + ab + ba + bc + cb + aa + ac + ca + cc) / 9.0;
    vec4 sharp = 2.0 * bb - avg;

    vec4 min_pix = min(aa, min(ab, min(ac, min(ba, min(bb, min(bc, min(ca, min(cb, cc))))))));
    vec4 max_pix = max(aa, max(ab, max(ac, max(ba, max(bb, max(bc, max(ca, max(cb, cc))))))));
    vec4 clipped = clamp(sharp, min_pix, max_pix);
    vec4 out_pix = mix(bb, clipped, strength);
    return ycbcr2rgb_bt709(out_pix);
}
