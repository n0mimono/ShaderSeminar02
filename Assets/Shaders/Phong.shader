Shader "Custom/Phong" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
    _GlossPow ("Gloss Power", Float) = 1
    _Specular ("Specular Color", Color) = (1,1,1,1)
    _Emission ("Emission Color", Color) = (0,0,0,0)
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
      float _GlossPow;
      float4 _Specular;
      float4 _Emission;

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
        float3 reflectViewDir = reflect(-viewDir, normalDir);

        // diffuse
        float NdotL = max(0,dot(normalDir, lightDir));
        float diffuse = NdotL;
        // surface color (albedo)
        float4 albedo = tex2D(_MainTex, i.uv) * _Color;
        // specular
        float RdotL = max(0,dot(reflectViewDir, lightDir));
        float gloss = pow(RdotL, _GlossPow);
        // final color
        return albedo * diffuse + _Specular * gloss + _Emission;
      }
      ENDCG
    }
  }
}
