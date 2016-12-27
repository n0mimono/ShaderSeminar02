Shader "Custom/HalfLambert (Bump)" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
    _BumpTex ("Bump Texture", 2D) = "bump" {}
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
      sampler2D _BumpTex;

      struct appdata {
        float4 vertex : POSITION;
        float2 texcoord : TEXCOORD0;
        float3 normal : NORMAL;
        float4 tangent : TANGENT;
      };

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float3 tangent : TEXCOORD2;
        float3 bitangent : TEXCOORD3;
        float4 worldPos : TEXCOORD4;
      };

      v2f vert (appdata v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.normal = UnityObjectToWorldNormal(v.normal);
        o.tangent = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz);
        o.bitangent = normalize(cross(o.normal, o.tangent) * v.tangent.w);
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        i.normal = normalize(i.normal);
        float3x3 rotation = float3x3(i.tangent, i.bitangent, i.normal);
        float3 normalLocal = UnpackNormal(tex2D(_BumpTex, i.uv));
        float3 normalDir = normalize(mul(normalLocal, rotation));

        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

        // diffuse color
        float NdotL = max(0,dot(normalDir, lightDir));
        float4 diffuse = (0.5 * NdotL + 0.5) * float4(1,1,1,1);

        // surface color
        float4 albedo = tex2D(_MainTex, i.uv) * _Color;

        // final color
        return albedo * diffuse;
      }
      ENDCG
    }
  }
}
