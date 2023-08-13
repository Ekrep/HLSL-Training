Shader "Unlit/TestRipple"
{
    Properties
    {
        _Amplify("Amplify",Range(0,0.8))=0.1
        _ValueX("ValueX",Range(-5,5))=0.1
        _ValueY("ValueY",Range(-5,5))=0.1
        _ValueZ("ValueZ",Range(-5,5))=0.1
        _ValueW("ValueW",Range(-5,5))=0.1
        _Sharpness("Sharpness",Range(-5,5))=0.1
        _RippleMultipler("Ripple Multipler",Range(-5,5))=0.1
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _WaveValue("Wave Value",Range(0,5))=0.1

    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
            }
        

        Pass
        {
            Cull Off
            ZWrite Off
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #define TAU 6.28318530718
          

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals: NORMAL;
            };

            struct Interpolator
            {
                float2 uv : TEXCOORD1;
                float3 normal:TEXCOORD0;               
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Amplify;
            float _ValueX;
            float _ValueY;
            float _ValueZ;
            float _ValueW;
            float _Sharpness;
            float _RippleMultipler;
            float4 _ColorA;
            float4 _ColorB;
            float _WaveValue;


            float Ripple(float2 uv){
                float2 centerUV=uv*2-1;
                float distanceFromCenter=length(centerUV);
                float wave=cos((distanceFromCenter-_Time.y*0.1)*TAU*5);
                wave*=1-distanceFromCenter;
                return wave;


            }
              float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }

            float4 SomeKindOfMeshOffset(float4 vertexData){
                vertexData=cos(vertexData-_Time.y*0.1)*TAU*5;
                return vertexData;
            }

            Interpolator vert (MeshData v)
            {
                Interpolator o;
                //v.vertex.y=Ripple(v.uv)*_Amplify;
                //v.vertex.xz+=float2(v.uv.x*_ValueX,v.uv.y*_ValueY);
                float2 centerUV=v.uv*2-1;
                float distanceFromCenter=length(centerUV);
                float firstValue;
                float firstValueZ;
                firstValue=v.vertex.y*=(_Sharpness*centerUV.y)+cos(centerUV.y)*_ValueY;
                v.vertex.x*=(_Sharpness*centerUV.y)*cos(centerUV.y)*_ValueX;
                firstValueZ=v.vertex.z*=(_Sharpness*centerUV.y)*cos(centerUV.y)*_ValueZ;

                //v.vertex.y=firstValue+(Ripple(v.uv)*_Amplify*_RippleMultipler);
                v.vertex.z*=firstValueZ+random(distanceFromCenter)-_Time.y*0.1*_WaveValue;
                v.vertex.y=firstValue;
                //v.vertex.x*=cos(v.uv.x)*_ValueX;
                
                
                

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal =UnityObjectToWorldNormal(v.normals);
                o.uv=v.uv;
               
                return o;
            }

            float4 frag (Interpolator i) : SV_Target
            {
                 float xOffset=cos(i.uv.x*TAU*8)*0.01;
                float t=cos((i.uv.y+xOffset-_Time.y*0.1)*TAU*5)*0.5+0.5;
               
                t*=i.uv.y;

                float topBottomRemover=(abs(i.normal.y)<0.999);
                float4 gradients=lerp(_ColorA,_ColorB,i.uv.y);
                float waves=t;
                
                return gradients*waves;
                
               
             
               
            }
            ENDCG
        }
    }
}
