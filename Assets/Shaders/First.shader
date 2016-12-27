Shader "Custom/First" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      struct appdata {
        float4 vertex : POSITION;
      };

      struct v2f {
        float4 pos : SV_POSITION;
      };

      v2f vert (appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float4 color = float4(1,0,1,1);
        color.rgb = color.rbr * float3(0.5,0.5,1);
        return color; 


        return float4(1,0,0,1);
      }
      ENDCG
    }
  }
  Fallback "Diffuse"
}
