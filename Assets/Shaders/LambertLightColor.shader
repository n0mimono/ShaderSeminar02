Shader "Custom/Lambert (with Light Color)" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
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
      float4 _LightColor0;

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
        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

        // diffuse color
        float NdotL = max(0,dot(normalDir, lightDir));
        float4 diffuse = NdotL * _LightColor0;
        // surface color
        float4 albedo = tex2D(_MainTex, i.uv) * _Color;
        // final color
        return albedo * diffuse;
      }
      ENDCG
    }
  }
}
