Shader "Custom/Rim (Mask)" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
    _RimColor ("Rim Color", Color) = (1,1,1,1)
    _RimAmplitude ("Rim Amplitude", Range(0,1)) = 0.5
    _RimPower ("Rim Power", Float) = 2
    _MaskTex ("Mask Texture", 2D) = "white" {}
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      float4 _Color;
      sampler2D _MainTex;
      sampler2D _MaskTex; float4 _MaskTex_ST;

      float4 _RimColor;
      float _RimAmplitude;
      float _RimPower;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float3 normal : NORMAL;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float4 worldPos : TEXCOORD2;
      };

      v2f vert (appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.normal = UnityObjectToWorldNormal(v.normal);
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        //float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

        float NdotV = dot(normalDir, viewDir);
        float NNdotV = 1 - NdotV;

        float mask = tex2D(_MaskTex, TRANSFORM_TEX(i.uv, _MaskTex)).r;
        float4 rim = (pow(NNdotV, _RimPower)) * _RimColor * (_RimAmplitude + mask);

        float4 col = tex2D(_MainTex, i.uv) * _Color;
        return col + rim;
      }
      ENDCG
    }
  }
}
