# GLSL Rapid Sharpen

## Overview
Simple sharpening shader for mpv. Implements a YCbCr 3x3 box blur unsharp masking with built-in antiring. Sharpening strength can be tuned through the `strength` parameter.

## Variants
- `RapidSharpen.glsl`: Main version that runs at the last hook point.
- `RapidSharpen_Native.glsl`: Cheaper version that runs before the main scaling stage.
- `RapidSharpen_Luma.glsl`: Cheapest version that sharpens luma only.

## Example
![RapidSharpen Example](./rapidsharpen_example.png "ArtCNN Example")
