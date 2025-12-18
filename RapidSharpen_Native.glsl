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

//!PARAM strength
//!DESC Mixing Strength
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 1
1.0

//!HOOK NATIVE
//!BIND NATIVE
//!DESC Rapid Sharpen

vec4 hook() {
    vec4 aa = NATIVE_texOff(vec2(-1.0, -1.0));
    vec4 ab = NATIVE_texOff(vec2(-1.0,  0.0));
    vec4 ac = NATIVE_texOff(vec2(-1.0,  1.0));

    vec4 ba = NATIVE_texOff(vec2( 0.0, -1.0));
    vec4 bb = NATIVE_texOff(vec2( 0.0,  0.0));
    vec4 bc = NATIVE_texOff(vec2( 0.0,  1.0));

    vec4 ca = NATIVE_texOff(vec2( 1.0, -1.0));
    vec4 cb = NATIVE_texOff(vec2( 1.0,  0.0));
    vec4 cc = NATIVE_texOff(vec2( 1.0,  1.0));

    vec4 avg = (bb + ab + ba + bc + cb + aa + ac + ca + cc) / 9.0;
    vec4 sharp = 2.0 * bb - avg;

    vec4 min_pix = min(aa, min(ab, min(ac, min(ba, min(bb, min(bc, min(ca, min(cb, cc))))))));
    vec4 max_pix = max(aa, max(ab, max(ac, max(ba, max(bb, max(bc, max(ca, max(cb, cc))))))));
    vec4 clipped = clamp(sharp, min_pix, max_pix);
    vec4 out_pix = mix(bb, clipped, strength);
    return out_pix;
}
