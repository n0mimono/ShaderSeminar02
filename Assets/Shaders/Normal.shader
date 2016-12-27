Shader "Custom/Normal" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      float4 _Color;
      sampler2D _MainTex;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float3 normal : NORMAL;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
      };

      v2f vert (appdata v) {
        v2f o;

        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.normal = UnityObjectToWorldNormal(v.normal);

        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        return float4(normalDir * 0.5 + 0.5, 1);
      }
      ENDCG
    }
  }
}
