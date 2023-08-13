Shader "Unlit/TestOutline"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {

                float outlineXValue = i.uv.x>0.9;
                float outlineXLowValue = i.uv.x<0.1;
                float outlineYValue = i.uv.y>0.9;
                float outlineYLowValue = i.uv.y<0.1;

                float outlineX = outlineXValue + outlineXLowValue;
                float outlineY = outlineYValue + outlineYLowValue;
                
                //return float4(i.vertex.x,i.vertex.y,0,1);
                return float4( outlineX , outlineY , 0 , 1);

                //float4 col = tex2D(_MainTex, i.uv);


                //return col;
            }
            ENDCG
        }
    }
}
