Shader "Unlit/SDFTest"
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



            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv*2-1;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {  
                float distancey =distance(0,i.uv.y)-0.2;
                float distancex =distance(i.uv.x,cos(i.uv.y*i.uv.y)-0.5)-0.2;
                

                float final=distancex+distancey;
                //return step(0,distance);
                
                return float4(final.xxx,0);
            }
            ENDCG
        }
    }
}
