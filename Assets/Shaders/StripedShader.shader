Shader "Custom/StripedShader"
{
    Properties
    {
        _CommonColor("CommonColor", Color) = (1, 1, 1, 1)
        _StripeColor1("StripeColor1", Color) = (1, 1, 1, 1)
        _StripeColor2("StripeColor2", Color) = (1, 1, 1, 1)
        
        _MaskTex ("_MaskTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl" 
            
            struct appdata
            {
                float4 vertexObjPos   : POSITION;
                float2 uv       : TEXCOORD0;
                half3 normal    : NORMAL;
            };
            
            struct v2f
            {
                float4 vertexClipPos    : SV_POSITION;
                float2 uv               : TEXCOORD0;
                half3 normal            : NORMAL;
            };

            float4 _CommonColor;
            float4 _StripeColor1;
            float4 _StripeColor2;

            sampler2D _MaskTex;
            float4 _MaskTex_ST;

            v2f vert (appdata IN)
            {
                v2f OUT;
                
                OUT.vertexClipPos = TransformObjectToHClip(IN.vertexObjPos.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MaskTex);
                OUT.normal = IN.normal;
                
                return OUT;
            }

            half4 frag (v2f IN) : SV_Target
            {
                half4 col = tex2D(_MaskTex, IN.uv);
                
                float y = clamp(IN.normal.y, 0, 1);

                col = ((_StripeColor1 * col.r + _StripeColor2 * col.g) * y) + (_CommonColor * (1 - y));
                
                return col;
            }
            
            ENDHLSL
        }
    }
}