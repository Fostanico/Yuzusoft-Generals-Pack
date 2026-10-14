# Floral core-circle material. Artwork is generated from editable SVG sources.
# Native quads/hit rectangles never move. Portraits remain separate, untinted icons.
Code [[
float YzCoreAge(float time, float stamp, float duration) {
    float age = time - stamp;
    if (age < 0.0 || age >= duration) return 1.0;
    return saturate(age / duration);
}
float3 YzCoreRose() { return float3(0.83,0.71,0.67); }
float YzCoreRoute(float2 uv) {
    // A clockwise route on the four sides, starting at the top-left corner.
    if (uv.y <= uv.x && uv.y <= 1.0-uv.x) return uv.x*0.25;
    if (1.0-uv.x <= uv.y && 1.0-uv.x <= 1.0-uv.y) return 0.25+uv.y*0.25;
    if (1.0-uv.y <= uv.x && 1.0-uv.y <= 1.0-uv.x) return 0.5+(1.0-uv.x)*0.25;
    return 0.75+(1.0-uv.y)*0.25;
}
float4 YzCoreFrame(float2 uv, float time, float stamp, float state, float live, in sampler2D tex) {
    float hover = state > 0.5 && state < 2.5 ? 1.0 : 0.0;
    float press = state > 1.5 && state < 2.5 ? 1.0 : 0.0;
    float disabled = state > 2.5 ? 1.0 : 0.0;
    float age = time-stamp;
    float ease = smoothstep(0.0,1.0,YzCoreAge(time,stamp,0.20));
    float2 sampleUV = (uv-0.5)*(1.0+press*0.018)+0.5;
    float4 art = tex2D(tex,sampleUV);
    art.a *= step(0.0,sampleUV.x)*step(sampleUV.x,1.0)*step(0.0,sampleUV.y)*step(sampleUV.y,1.0);
    float route = YzCoreRoute(uv);
    float distance = abs(frac(route-saturate(age/0.65)+0.5)-0.5);
    float trace = exp(-distance*distance*650.0);
    float fresh = age >= 0.0 && age < 0.65 ? 1.0 : 0.0;
    // Short perimeter highlight; the centre is alpha-clear and never washes out faces.
    art.rgb += YzCoreRose()*hover*ease*(0.10+0.35*trace*fresh*live);
    art.rgb *= 1.0-press*0.16;
    float grey = dot(art.rgb,float3(0.299,0.587,0.114));
    art.rgb = lerp(art.rgb,lerp(art.rgb,float3(grey,grey,grey),0.65)*0.70,disabled);
    return art;
}
float4 YzCoreCorners(float2 uv, float time, in sampler2D tex) {
    float2 p = min(uv,1.0-uv)*float2(114.0,146.0);
    float bevel = (1.0-smoothstep(0.5,1.5,abs(p.x+p.y-9.0)))*(1.0-smoothstep(9.0,12.0,max(p.x,p.y)));
    float vertical = (1.0-smoothstep(0.4,1.2,abs(p.x-1.5)))*smoothstep(7.0,10.0,p.y)*(1.0-smoothstep(18.0,25.0,p.y));
    float horizontal = (1.0-smoothstep(0.4,1.2,abs(p.y-1.5)))*smoothstep(7.0,10.0,p.x)*(1.0-smoothstep(18.0,25.0,p.x));
    float gem = abs(uv.x-0.5)*114.0+abs(p.y-4.7);
    float gemRim = 1.0-smoothstep(0.4,1.1,abs(gem-3.1));
    float breathing = 0.72+0.10*sin(time*2.0);
    return float4(float3(0.91,0.78,0.69),max(max(bevel,vertical+horizontal),gemRim)*breathing);
}
float4 YzCoreButton(float2 uv, float time, float stamp, float state, in sampler2D tex) {
    float hover = state > 0.5 && state < 2.5 ? 1.0 : 0.0;
    float press = state > 1.5 && state < 2.5 ? 1.0 : 0.0;
    float disabled = state > 2.5 ? 1.0 : 0.0;
    // Press insets pixels only; the native 200x40 click rectangle stays fixed.
    float2 sampleUV = (uv-0.5)*float2(1.0+press*0.018,1.0+press*0.065)+0.5;
    float4 art = tex2D(tex,sampleUV);
    art.a *= step(0.0,sampleUV.x)*step(sampleUV.x,1.0)*step(0.0,sampleUV.y)*step(sampleUV.y,1.0);
    float ramp = smoothstep(0.0,1.0,YzCoreAge(time,stamp,0.12));
    float2 edgeDistance = min(uv,1.0-uv)*float2(200.0,40.0);
    float edge = 1.0-smoothstep(1.0,3.0,min(edgeDistance.x,edgeDistance.y));
    float age = time-stamp;
    float sweep = exp(-pow((uv.x-saturate(age/0.55))*9.0,2.0));
    float fresh = age >= 0.0 && age < 0.55 ? 1.0 : 0.0;
    art.rgb += YzCoreRose()*hover*ramp*(0.14+edge*0.28+sweep*fresh*0.14);
    art.rgb *= 1.0-press*0.28;
    art.rgb *= 1.0-disabled*0.32;
    return art;
}
]]
