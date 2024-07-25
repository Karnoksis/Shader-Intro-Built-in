Shader "Custom/Saturation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            
            float3 HSVToRGB( float3 c)
	        {
		        float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
		        float3 p = abs(frac( c.xxx + K.xyz ) * 6.0 - K.www );
		        return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y);
	        }
    
	        float3 RGBToHSV(float3 c)
	        {
		        float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
		        float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
		        float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
		        float d = q.x - min( q.w, q.y );
		        float e = 1.0e-10;
		        return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	        }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Saturation;
            

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float3 HSVColor = RGBToHSV(col.xyz);
                HSVColor.y = _Saturation;
                col = fixed4(HSVToRGB(HSVColor),1);

                return col;
            }
            ENDCG
        }
    }
}
