Shader "Unlit/SimpleUnlit"
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
                float2 uv : TEXCOORD0; //TEXCOORD0 - координаты вершин в нулевом UV пространстве
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
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 color = float4(1,0,0,1);
                return color;
            }
            ENDCG
        }
    }
}
