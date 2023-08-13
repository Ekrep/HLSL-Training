Shader "Unlit/HealthBarTest"
{
    Properties
    {
        _MainTex("Main Texture",2D)="white"{}
        _Health("Current Health",Range(0,1))=1
        _BorderSize("Border Size",Range(0,0.5))=1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }


        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha//Alpha Blending


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

          float _Health;
          sampler2D _MainTex;
          float4 _MainTex_ST;
          float _BorderSize;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv=v.uv;
                return o;
            }

            float InverseLerp(float a,float b, float v){
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
               //for the rounded corner sdf

               float2 coords= i.uv;
               coords.x*=8;

               float2 pointOnLineSeg=float2(clamp(coords.x, 0.5, 7.5), 0.5);
               float sdf = distance(coords,pointOnLineSeg)*2-1;
               clip(-sdf);

               float borderSdf = sdf+_BorderSize;

               float borderMask = step(0,-borderSdf);
               

               //return float4(borderMask.xxx,1);
              

               

               //return float4(sdf.xxx,1);


               
               float healthBarMask = _Health > i.uv.x;
               


               //clip(healthBarMask-0.5);// deletes fragment 

                
               float3 healthBarColor = tex2D(_MainTex,float2(_Health,i.uv.y));
               
                if(_Health<0.2){
                    float flash = cos(_Time.y * 4)* 0.4 + 1;
                    healthBarColor*=flash; 
                }
                
                //float3 bgColor = float3(0,0,0);
                

                //Mathf.lerp()// returns clamped value
                //lerp()// returns unclamped value

                //float3 outColor=lerp(bgColor,healthBarColor,healthBarMask);


                return float4(healthBarColor * healthBarMask * borderMask,1);
               
            }
            ENDCG
        }
    }
}
