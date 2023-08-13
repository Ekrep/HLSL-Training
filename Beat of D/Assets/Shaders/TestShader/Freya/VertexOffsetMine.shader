Shader "Unlit/VertexOffsetMine"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorStart("Color Start", Range(0,1))=0
        _ColorEnd("Color End", Range(0,1))=0

        _WaveAmp("Wave Amplitute",Range(0,0.2))=0.1

        
        
    }
        SubShader
    {
        Tags { 
            "RenderType" = "Opaque"
            "Queue"="Geometry" 
            }


        Pass
        {
          
            

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            //sampler2D _MainTex;
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _WaveAmp;
          

            struct MeshData
            {
                float4 vertex : POSITION;//local space vertex positon
                float3 normals: NORMAL;//local space normal direction
                float4 uv0: TEXCOORD0;//uv0 diffuse/normal map textures
                //float2 uv1 : TEXCOORD1;//uv1 coordinates lightmap coordinates
                //float4 tangent: TANGENT; tangent //direction (xyz) tangent sign(w)
                //float4 color: COLOR;//vertex color
                
            };

            struct Interpolators
            {
                //float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 worldSpacePos:TEXCOORD2;
                //float2 tangent:TEXCOORD1;
                //float2 justSomeValues:TEXCOORD2;
                
            };

            


            Interpolators vert(MeshData v)
            {
                Interpolators o;

                float wave=cos((v.uv0.y-_Time.y*0.1)*TAU*5);
                float wave2=cos((v.uv0.x-_Time.y*0.1)*TAU*5);
                v.vertex.y=((0.01+wave)*(0.01+wave2))*_WaveAmp;
                
                


                o.vertex = UnityObjectToClipPos(v.vertex);//v.vertex;
                o.normal =UnityObjectToWorldNormal(v.normals);//Just pass through data
                o.worldSpacePos=mul(unity_ObjectToWorld, v.vertex);
                o.uv=v.uv0;//(v.uv0+_Offset)*_Scale;//simple pass through
                //o.normal=UnityObjectToWorldDir(v.normals);
                                                          
                return o;
            }

            float InverseLerp(float a, float b,float v){
                return(v-a)/(b-a);
            }

            float4 frag(Interpolators i) : SV_Target
            {
                //float4 myValue;
                //float2 otherValue = myValue.rg;//swizzling
                //float t=saturate(InverseLerp(_ColorStart,_ColorEnd,i.uv.x));
                //float t=abs(frac(i.uv.x*5)*2-1);
                

                
                float wave=cos((i.worldSpacePos.xy-_Time.y*0.1)*TAU*5)*0.5+0.5;             
                return wave;

            
                
               
            }
            ENDCG

        }

    }
}
