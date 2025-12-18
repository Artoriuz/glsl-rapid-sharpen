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

//!HOOK LUMA
//!BIND LUMA
//!DESC Rapid Sharpen

vec4 hook() {
    float aa = LUMA_texOff(vec2(-1.0, -1.0)).x;
    float ab = LUMA_texOff(vec2(-1.0,  0.0)).x;
    float ac = LUMA_texOff(vec2(-1.0,  1.0)).x;

    float ba = LUMA_texOff(vec2( 0.0, -1.0)).x;
    float bb = LUMA_texOff(vec2( 0.0,  0.0)).x;
    float bc = LUMA_texOff(vec2( 0.0,  1.0)).x;

    float ca = LUMA_texOff(vec2( 1.0, -1.0)).x;
    float cb = LUMA_texOff(vec2( 1.0,  0.0)).x;
    float cc = LUMA_texOff(vec2( 1.0,  1.0)).x;

    float avg = (bb + ab + ba + bc + cb + aa + ac + ca + cc) / 9.0;
    float sharp = 2.0 * bb - avg;

    float min_pix = min(aa, min(ab, min(ac, min(ba, min(bb, min(bc, min(ca, min(cb, cc))))))));
    float max_pix = max(aa, max(ab, max(ac, max(ba, max(bb, max(bc, max(ca, max(cb, cc))))))));
    float clipped = clamp(sharp, min_pix, max_pix);
    float out_pix = mix(bb, clipped, strength);
    return vec4(out_pix, 0.0, 0.0, 1.0);
}
