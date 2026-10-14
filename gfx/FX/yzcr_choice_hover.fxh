# Recruitment choice buttons: on hover and press only the white option text
# turns red, as in the original games. The plate, border and flakes never change.
# The quad spans a whole language column of the atlas; each option is one row.
PixelShader = {
Code
[[
float4 YzcrRedText(in sampler2D tex, float2 uv, float rows, float press)
{
    float4 c = tex2D(tex, uv);
    float2 local = float2(frac(uv.x * 3.0), frac(uv.y * rows));
    float band = smoothstep(0.075, 0.105, local.x) * (1.0 - smoothstep(0.895, 0.925, local.x))
               * smoothstep(0.16, 0.22, local.y) * (1.0 - smoothstep(0.80, 0.86, local.y));
    float lum = dot(c.rgb, float3(0.299, 0.587, 0.114));
    float sat = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
    float text = smoothstep(0.42, 0.72, lum) * (1.0 - smoothstep(0.10, 0.22, sat)) * band;
    // User reference: solid glyph colour #FE877F, RGB (254, 135, 127).
    // Keep the existing text mask, antialiasing and press-darkening response.
    float3 red = float3(254.0 / 255.0, 135.0 / 255.0, 127.0 / 255.0) * saturate(lum * 1.08) * (1.0 - 0.18 * press);
    c.rgb = lerp(c.rgb, red, text);
    return c;
}
]]
}
