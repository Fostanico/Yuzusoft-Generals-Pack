# Title page light layer: static frame and floral corners.
# Installed HOI4 1.19.3 buttonstate contract; shared code in yzl_launch.fxh.
Includes = { "buttonstate.fxh" "yzl_launch.fxh" }
VertexStruct VS_OUTPUT {
    float4 vPosition : PDX_POSITION;
    float2 vTexCoord : TEXCOORD0;
};
VertexShader = {
    MainCode VertexShader [[
        VS_OUTPUT main(const VS_INPUT v) {
            VS_OUTPUT Out;
            Out.vPosition = mul(WorldViewProjectionMatrix, float4(v.vPosition.xyz, 1.0));
            Out.vTexCoord = v.vTexCoord + Offset;
            return Out;
        }
    ]]
}
PixelShader = {
    Samplers = {
        MapTexture = {
            Index = 0
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
        }
    }
    MainCode PixelShaderUp [[
        float4 main(VS_OUTPUT v) : PDX_COLOR {
            return YzlFx(v.vTexCoord, Time, AnimationTime, 0.0, MapTexture) * Color;
        }
    ]]
    MainCode PixelShaderOver [[
        float4 main(VS_OUTPUT v) : PDX_COLOR {
            return YzlFx(v.vTexCoord, Time, AnimationTime, 0.0, MapTexture) * Color;
        }
    ]]
    MainCode PixelShaderDown [[
        float4 main(VS_OUTPUT v) : PDX_COLOR {
            return YzlFx(v.vTexCoord, Time, AnimationTime, 0.0, MapTexture) * Color;
        }
    ]]
    MainCode PixelShaderDisable [[
        float4 main(VS_OUTPUT v) : PDX_COLOR {
            return YzlFx(v.vTexCoord, Time, AnimationTime, 0.0, MapTexture) * Color;
        }
    ]]
}
BlendState BlendState {
    BlendEnable = yes
    SourceBlend = "src_alpha"
    DestBlend = "inv_src_alpha"
}
Effect Up { VertexShader = "VertexShader" PixelShader = "PixelShaderUp" }
Effect Down { VertexShader = "VertexShader" PixelShader = "PixelShaderDown" }
Effect Over { VertexShader = "VertexShader" PixelShader = "PixelShaderOver" }
Effect Disable { VertexShader = "VertexShader" PixelShader = "PixelShaderDisable" }
