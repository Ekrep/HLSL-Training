Shader "Unlit/TestTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "gray" {}
        _Pattern ("Pattern Texture", 2D) = "white" {}
        _Rock ("Rock", 2D) = "white" {}
        _MIP ("MIP", Float) = 0//highest mip level value

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
     

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
  
            #define TAU 6.28318530718
            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Pattern;
            sampler2D _Rock;
            float _MIP;
            //float4 _MainTex_ST; //optional

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);//object to world
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv.x+=_Time.y*0.1;//uv anim slide
                return o;
            }
             float GetWave(float coord){
                              
                float wave=cos((coord-_Time.y*0.1)*TAU*5);  
                wave*=coord;           
                return wave;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // sample the texture

                float2 topDownProjection=i.worldPos.xz;
                float4 moss = tex2Dlod(_MainTex, float4(topDownProjection,_MIP.xx));
                 float4 rock = tex2D(_Rock, topDownProjection);
                float pattern=tex2D(_Pattern,i.uv).x;

                float4 finalColor=lerp(rock,moss,pattern);
                return moss;
            }
            ENDCG
        }
    }
}
