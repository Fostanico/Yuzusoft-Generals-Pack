# Startup UI shared material functions (yzl_ prefix), 2026-10-11 palette pass.
# Contract: buttonstate.fxh Time/AnimationTime/Color + MapTexture only.
# GUI vertices stay fixed per control; layout and derived SD/card sizes are owned by this UI.
# Panels stay still; title-page hair has a faint 20 s light cycle.
# SD keeps its original idle animation. Control glints are state-triggered.
# Stage atlas: art (0,0,606,857), blurred art (606,0,303,428),
# hair R (606,429,303,428), floral corner R (912,4,85,75).
# This file is hand-maintained; build_launch_ui.py does not overwrite it.
# Palette sampled from the original Kurumi start_ui_origin_no_bargin.png and
# its button art: black-grey surfaces and muted grey-rose trim, not Claude's violet theme.
PixelShader = {
Code
[[
float3 YzlRose() { return float3(160.0, 136.0, 131.0) / 255.0; }
float3 YzlChampagne() { return float3(177.0, 150.0, 144.0) / 255.0; }
float3 YzlInk() { return float3(37.0, 34.0, 38.0) / 255.0; }
float YzlSq(float x) { return x * x; }
float YzlHash(float2 p)
{
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}
float YzlOnce(float t, float stamp, float duration)
{
    float age = t - stamp;
    float fresh = step(0.0, age) * (1.0 - step(duration, age));
    return lerp(1.0, saturate(age / duration), fresh);
}
float YzlEase(float x)
{
    float k = 1.0 - saturate(x);
    return 1.0 - k * k * k;
}
float YzlBox(float2 p, float2 halfSize, float r)
{
    float2 q = abs(p) - halfSize + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}
float3 YzlTone(float3 c, float saturation)
{
    float l = dot(c, float3(0.299, 0.587, 0.114));
    return lerp(float3(l, l, l), c, saturation);
}
float YzlAtan2(float y, float x)
{
    float ax = abs(x);
    float ay = abs(y);
    float a = min(ax, ay) / max(max(ax, ay), 0.000001);
    float s = a * a;
    float r = ((-0.0464964749 * s + 0.15931422) * s - 0.327622764) * s * a + a;
    if (ay > ax) { r = 1.57079637 - r; }
    if (x < 0.0) { r = 3.14159274 - r; }
    if (y < 0.0) { r = -r; }
    return r;
}

float YzlGlint(float2 q, float scale)
{
    float2 a = abs(q) / scale;
    float core = exp(-dot(a, a) * 0.45);
    float arms = exp(-a.y * a.y * 0.9 - a.x * 0.24) + exp(-a.x * a.x * 0.9 - a.y * 0.24);
    return core + 0.65 * arms;
}

float4 YzlTap(in sampler2D tex, float2 local, float4 rect)
{
    float2 l = clamp(local, 0.5 / rect.zw, 1.0 - 0.5 / rect.zw);
    return tex2D(tex, (rect.xy + l * rect.zw) / float2(1022.0, 857.0));
}
// Premultiplied accumulation, converted to straight alpha at each return.
float4 YzlOver(float4 acc, float3 colour, float a)
{
    float k = saturate(a);
    return float4(colour * k + acc.rgb * (1.0 - k), k + acc.a * (1.0 - k));
}
float3 YzlBackdrop(float2 p)
{
    float2 uv = p / float2(1022.0, 857.0);
    float3 c = lerp(float3(47.0, 43.0, 44.0) / 255.0, float3(33.0, 30.0, 35.0) / 255.0, uv.y);
    float2 q = (uv - float2(0.69, 0.30)) * float2(1.4, 1.0);
    c += float3(0.012, 0.010, 0.011) * exp(-dot(q, q) * 4.0);
    return c + (YzlHash(floor(p)) - 0.5) * 0.004;
}

// Stable portrait composition. Material masks affect colour, never geometry.
// mode: 0 = title, 1 = reading. The reading background is time-independent.
float4 YzlStage(float2 uv, float t, float stamp, float mode, in sampler2D tex)
{
    float2 p = uv * float2(1022.0, 857.0);
    float2 origin = float2(260.0, -100.0);
    float2 size = float2(762.0, 1078.0);
    float2 au = (p - origin) / size;
    float3 art = YzlTap(tex, au, float4(0.0, 0.0, 606.0, 857.0)).rgb;
    float3 soft = YzlTap(tex, au, float4(606.0, 0.0, 303.0, 428.0)).rgb;
    float hair = YzlTap(tex, au, float4(606.0, 429.0, 303.0, 428.0)).r;
    float inside = step(0.0, au.x) * step(au.x, 1.0) * step(0.0, au.y) * step(au.y, 1.0);
    float present = inside * smoothstep(0.0, 0.10, au.x);
    float vig = smoothstep(0.18, 0.80, length((au - float2(0.40, 0.42)) * float2(1.0, 1.25)));
    float3 grade = lerp(float3(0.98, 0.98, 0.98), float3(0.62, 0.60, 0.62), vig);
    float3 back = YzlBackdrop(p);
    float3 col = lerp(back, YzlTone(art, 1.0) * grade, present * lerp(1.0, 0.10, mode));

    // Broad, very faint neutral light stays in the hair mask and off the face.
    // No moving camera, eye glints, coloured leaks or particles.
    float band = exp(-YzlSq((au.y - 0.25 - 0.12 * sin(t * 0.3141593)) * 5.0));
    float faceClear = smoothstep(0.16, 0.34, length((au - float2(0.40, 0.48)) * float2(1.0, 1.3)));
    col += YzlChampagne() * hair * band * faceClear * present * 0.016 * (1.0 - mode);
    float newsShade = (1.0 - smoothstep(40.0, 170.0, p.y)) * (1.0 - smoothstep(480.0, 760.0, p.x));
    col *= 1.0 - (0.22 * newsShade) * (1.0 - mode);

    // Frosted reading material: existing preblur + distance-based opacity.
    // The centre is quieter than the edges; nothing sweeps behind the text.
    float2 pc = p - float2(625.0, 460.5);
    float pd = YzlBox(pc, float2(373.0, 374.5), 12.0);
    float pin = (1.0 - smoothstep(-0.8, 0.8, pd)) * mode;
    float edge = 1.0 - smoothstep(0.0, 55.0, -pd);
    float3 under = lerp(back, YzlTone(soft, 0.55) * grade, present);
    float3 glass = lerp(under, YzlInk(), 0.985 - 0.015 * edge);
    glass += float3(0.012, 0.010, 0.011) * exp(-max(p.y - 86.0, 0.0) / 100.0);
    glass += (YzlHash(floor(p) + 7.0) - 0.5) * 0.003;
    float shadow = (1.0 - smoothstep(-6.0, 28.0, YzlBox(pc - float2(0.0, 8.0), float2(373.0, 374.5), 12.0))) * mode;
    col *= 1.0 - 0.38 * shadow * (1.0 - pin);
    col = lerp(col, glass, pin);

    // A shared quiet header keeps native text legible above both page modes.
    float header = 1.0 - smoothstep(60.0, 100.0, p.y);
    col = lerp(col, YzlInk(), header * 0.65);
    float nav = 1.0 - smoothstep(231.0, 233.0, p.x);
    float3 navCol = lerp(float3(47.0, 43.0, 44.0) / 255.0, float3(33.0, 30.0, 35.0) / 255.0, uv.y);
    col = lerp(col, navCol, nav);
    // The GUI already owns a 400 ms fade; no second black-to-bright shader fade.
    return float4(saturate(col), 1.0);
}

float YzlCorners(float2 p, float2 centre, float2 halfSize, float scale, in sampler2D tex)
{
    float2 local = (halfSize - abs(p - centre)) / (float2(85.0, 75.0) * scale);
    float inBox = step(0.0, local.x) * step(local.x, 1.0) * step(0.0, local.y) * step(local.y, 1.0);
    return YzlTap(tex, local, float4(912.0, 4.0, 85.0, 75.0)).r * inBox;
}
// Static structure. No orbiting lights, separator pulses, stars or bokeh.
float4 YzlFx(float2 uv, float t, float stamp, float mode, in sampler2D tex)
{
    float2 p = uv * float2(1022.0, 857.0);
    float d = YzlBox(p - float2(511.0, 428.5), float2(504.0, 421.5), 3.0);
    float frame = exp(-d * d * 1.4) * 0.30;
    float sep = exp(-YzlSq(p.x - 232.0) * 1.1);
    sep *= smoothstep(18.0, 95.0, p.y) * smoothstep(18.0, 95.0, 857.0 - p.y) * 0.30;
    float divFade = smoothstep(20.0, 47.0, p.x) * (1.0 - smoothstep(185.0, 212.0, p.x));
    float divs = exp(-YzlSq(p.y - 81.0)) * divFade * 0.18;
    float floralHome = YzlCorners(p, float2(625.0, 460.5), float2(361.0, 362.5), 0.9, tex);
    float floralRead = YzlCorners(p, float2(625.0, 460.5), float2(361.0, 362.5), 0.8, tex);
    float floral = lerp(floralHome, floralRead, mode) * 0.18;
    float pd = YzlBox(p - float2(625.0, 460.5), float2(373.0, 374.5), 12.0);
    float rim = exp(-pd * pd * 1.2) * mode * (0.20 + 0.10 * (1.0 - uv.y));
    // Visual grip only: the native background receives the actual drag.
    float2 grip = p - float2(511.0, 18.0);
    float gripA = (exp(-YzlSq(grip.y - 2.0)) + exp(-YzlSq(grip.y + 2.0)))
                * (1.0 - smoothstep(17.0, 21.0, abs(grip.x))) * 0.28;
    return float4(YzlRose(), saturate(frame + sep + divs + floral + rim + gripA));
}

// Atlas frame 1: R glyph coverage, G soft shadow, B bevel. No animated glow.
float4 YzlLogo(float2 atlasUV, float t, float stamp, float2 sizePx, in sampler2D tex)
{
    float3 base = tex2D(tex, atlasUV).rgb;
    float3 data = tex2D(tex, float2(atlasUV.x + 0.5, atlasUV.y)).rgb;
    float lum = dot(base, float3(0.299, 0.587, 0.114));
    float3 col = YzlChampagne() * (0.75 + 0.25 * lum) + (data.b - 0.5) * 0.20;
    float4 acc = YzlOver(float4(0.0, 0.0, 0.0, 0.0), float3(0.015, 0.018, 0.022), data.g * 0.38);
    acc = YzlOver(acc, saturate(col), data.r);
    return float4(saturate(acc.rgb / max(acc.a, 0.0001)), saturate(acc.a));
}

// Native control states: 0 up, 1 over, 2 down, 3 disabled.
// Resting states do not animate. Hover ends in a stable material highlight.
float4 YzlNav(float2 uv, float t, float stamp, float btnState, float2 sizePx, float muted, in sampler2D tex)
{
    float4 c = tex2D(tex, uv);
    float2 p = (uv - 0.5) * sizePx;
    float d = YzlBox(p, sizePx * 0.5 - float2(5.0, 5.0), 6.0);
    float inner = 1.0 - smoothstep(-7.0, -3.0, d);
    float edge = exp(-d * d * 0.65);
    c.rgb = YzlTone(c.rgb, 1.0) * float3(1.0, 1.0, 1.0) * (1.0 - 0.10 * muted);
    float over = step(0.5, btnState) * (1.0 - step(1.5, btnState));
    float down = step(1.5, btnState) * (1.0 - step(2.5, btnState));
    float hover = YzlEase(YzlOnce(t, stamp, 0.18)) * over;
    float top = 1.0 - smoothstep(0.10, 0.80, uv.y);
    c.rgb += YzlChampagne() * (0.042 * inner + 0.14 * edge * top) * hover;
    // Restore Claude's edge-travel response, bounded to the first 0.65 s.
    // The independent *_on sprite remains the persistent page indicator.
    float h = YzlOnce(t, stamp, 0.65);
    float ang = YzlAtan2(p.y / sizePx.y, p.x / sizePx.x) / 6.2831853 + 0.5;
    float arc = exp(-frac(h - ang) * 9.0) + exp(-frac(h + 0.5 - ang) * 9.0);
    c.rgb += YzlChampagne() * edge * arc * over * (1.0 - h) * 0.35;
    float press = YzlOnce(t, stamp, 0.45);
    float ring = exp(-YzlSq((length(p / sizePx.y) - press * 2.2) * 6.0));
    c.rgb *= 1.0 - 0.19 * down;
    c.rgb += YzlChampagne() * ring * (1.0 - press) * inner * down * 0.42;
    if (btnState > 2.5) { c.rgb = YzlTone(c.rgb, 0.0) * 0.65; }
    return float4(saturate(c.rgb), c.a);
}
// Existing *_on visibility owns selection. Static side rule, no halo.
float4 YzlNavGlow(float2 uv, float t, float2 sizePx)
{
    float2 p = (uv - 0.5) * sizePx;
    float marker = 1.0 - smoothstep(-0.5, 0.5, YzlBox(p - float2(-108.0, 0.0), float2(1.5, 12.0), 1.0));
    float d = YzlBox(p, float2(96.0, 32.5), 6.0);
    float rule = exp(-d * d * 1.3) * 0.22;
    return float4(YzlChampagne(), saturate(marker * 0.80 + rule));
}
float4 YzlNews(float2 uv, float t, float stamp, float btnState, float2 sizePx, in sampler2D tex)
{
    float4 c = tex2D(tex, uv);
    float2 px = uv * sizePx;
    float active = step(0.5, btnState) * (1.0 - step(2.5, btnState));
    float hover = YzlEase(YzlOnce(t, stamp, 0.18)) * active;
    float down = step(1.5, btnState) * (1.0 - step(2.5, btnState));
    float d = YzlBox(px - sizePx * 0.5, sizePx * 0.5 - float2(1.5, 1.5), 13.0);
    float dotA = 0.0;
    float2 cp = px - float2(sizePx.x - 22.0 + 2.0 * hover, 26.0);
    float chev = (1.0 - smoothstep(0.7, 1.5, abs(cp.x - (3.0 - abs(cp.y))) * 0.7071)) * step(abs(cp.y), 6.5);
    float3 col = YzlTone(c.rgb, 0.30) * float3(1.0, 0.92, 0.92);
    col += YzlChampagne() * (0.025 + 0.12 * exp(-d * d * 0.8)) * hover;
    float rule = exp(-YzlSq(px.y - 49.0)) * smoothstep(18.0, 26.0, px.x) * (1.0 - smoothstep(sizePx.x - 26.0, sizePx.x - 18.0, px.x));
    col = lerp(col, YzlRose(), rule * 0.20);
    col = lerp(col, YzlChampagne(), max(dotA * 0.62, chev * (0.55 + 0.25 * hover)));
    col *= 1.0 - 0.16 * down;
    if (btnState > 2.5) { col = YzlTone(col, 0.0) * 0.60; }
    return float4(saturate(col), max(c.a, max(dotA, chev)));
}
// Restore the original 0.35 s quarter-turn and hover halo for every reading
// page. Motion stays inside the fixed 36 px hit box; colours keep the calm palette.
float4 YzlBack(float2 uv, float t, float stamp, float btnState)
{
    float2 p = (uv - 0.5) * 36.0;
    float r = length(p);
    float active = step(0.5, btnState) * (1.0 - step(2.5, btnState));
    float hover = YzlEase(YzlOnce(t, stamp, 0.35)) * active;
    float ring = 1.0 - smoothstep(0.6, 1.4, abs(r - 15.0));
    float fill = 1.0 - smoothstep(14.4, 15.2, r);
    float ang = hover * 1.5707963;
    float ca = cos(ang);
    float sa = sin(ang);
    float2 q = float2(ca * p.x - sa * p.y, sa * p.x + ca * p.y);
    float2 aq = abs(q);
    float mark = (1.0 - smoothstep(0.7, 1.5, abs(aq.x - aq.y) * 0.7071)) * (1.0 - smoothstep(11.0, 12.5, aq.x + aq.y));
    float halo = exp(-max(r - 15.0, 0.0) / 3.0) * step(15.0, r) * hover * 0.6;
    float3 col = YzlInk() + float3(0.025, 0.027, 0.029) * hover * fill;
    col = lerp(col, YzlRose(), max(ring, halo * (1.0 - fill)));
    col = lerp(col, YzlChampagne(), mark);
    col *= 1.0 - 0.18 * step(1.5, btnState) * (1.0 - step(2.5, btnState));
    if (btnState > 2.5) { col = YzlTone(col, 0.0) * 0.60; }
    return float4(saturate(col), max(fill * 0.90, max(ring, max(mark, halo))));
}
// Original SD bob / hop / squash restored. Hover stars and rim use neutral light.
float4 YzlChibi(float2 uv, float t, float stamp, float btnState, float phase, in sampler2D tex)
{
    float2 size = float2(224.0, 274.0);
    float2 px = uv * size;
    float2 foot = float2(112.0, 270.0);
    float over = step(0.5, btnState) * step(btnState, 1.5);
    float down = step(1.5, btnState) * step(btnState, 2.5);

    float bob = 1.5 + 1.5 * sin(t * 2.1 + phase);
    float k = YzlOnce(t, stamp, 0.55);
    float hop = 4.0 * k * (1.0 - k) * 15.0 * over;
    float land = (1.0 - YzlOnce(t, stamp + 0.55, 0.22)) * over;
    float pk = YzlOnce(t, stamp, 0.30);
    float squash = 0.012 * sin(t * 4.2 + phase * 2.0) - 0.06 * land - (0.03 + 0.05 * (1.0 - pk)) * down;
    float sy = 1.0 + squash;
    float sx = 1.0 - squash * 0.6;
    float lift = (bob + hop) * (1.0 - down * 0.7);

    float2 src = foot + (px - foot + float2(0.0, lift)) / float2(sx, sy);
    float4 c = tex2D(tex, src / size);
    float n = max(max(tex2D(tex, (src + float2(2.5, 0.0)) / size).a, tex2D(tex, (src - float2(2.5, 0.0)) / size).a),
                  max(tex2D(tex, (src + float2(0.0, 2.5)) / size).a, tex2D(tex, (src - float2(0.0, 2.5)) / size).a));
    float hot = saturate(over + down);
    float rimA = saturate(n - c.a) * hot * (0.75 + 0.25 * sin(t * 6.0));

    float lifted = saturate(lift / 18.0);
    float2 sd = (px - float2(112.0, 270.5)) / float2(lerp(53.0, 38.0, lifted), 4.5);
    float shadowA = exp(-dot(sd, sd) * 1.6) * lerp(0.45, 0.22, lifted);

    float stars = 0.0;
    for (int i = 0; i < 3; i++)
    {
        float fi = float(i);
        float2 at = float2(lerp(40.0, 184.0, frac(fi * 0.618 + 0.13)), lerp(38.0, 128.0, frac(fi * 0.382 + 0.4)));
        at.y -= lift;
        float tw = pow(saturate(sin(t * 3.0 + fi * 2.1)), 3.0);
        stars += YzlGlint(px - at, 0.55 + 0.35 * tw) * tw;
    }
    stars *= hot * 0.5;

    float4 acc = YzlOver(float4(0.0, 0.0, 0.0, 0.0), float3(0.02, 0.01, 0.02), shadowA);
    acc = YzlOver(acc, YzlChampagne(), rimA * 0.65);
    if (btnState > 2.5) { c.rgb = YzlTone(c.rgb, 0.0) * 0.65; }
    acc = YzlOver(acc, c.rgb, c.a);
    acc = YzlOver(acc, YzlChampagne(), saturate(stars));
    return float4(saturate(acc.rgb / max(acc.a, 0.0001)), saturate(acc.a));
}
]]
}
