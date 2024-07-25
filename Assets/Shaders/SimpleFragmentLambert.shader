Shader "Unlit/SimpleFragmentLambert"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION; //POSITION - координаты вершины в пространстве объекта
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0; //TEXCOORD0 - координаты вершин в нулевом UV пространстве
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;

            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);   
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = mul(unity_ObjectToWorld, i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float lambertLight = max(0.0, dot(worldNormal, lightDir));

                float4 color = float4(lambertLight,lambertLight,lambertLight,1);
                return color;
            }
            ENDCG
        }
    }
}
