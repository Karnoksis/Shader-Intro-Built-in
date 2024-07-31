Shader "Unlit/SimpleVertexLambert"
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
                float lambertLight : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);   

                float3 worldNormal = mul(unity_ObjectToWorld, v.normal);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                o.lambertLight = max(0,dot(worldNormal, lightDir));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 color = float4(i.lambertLight,i.lambertLight,i.lambertLight,1);
                return color;
            }
            ENDCG
        }
    }
}
