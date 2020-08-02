Shader "GKit.UnityShader/Special/Depth" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
		_DepthDistance("DepthDistance", float) = 25
    }
    SubShader {
        Cull Off 
		ZWrite On 
		ZTest Always

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
			half4 _MainTex_TexelSize;
			sampler2D _CameraDepthTexture;
			half _DepthDistance;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target {
				float depth = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(float4(i.uv, 1, 1))).r;
				float normalizedDepth = LinearEyeDepth(depth);	
				float filteredDepth = 1 - saturate(normalizedDepth / _DepthDistance);
				
				
				return filteredDepth;
            }
            ENDCG
        }
    }
}