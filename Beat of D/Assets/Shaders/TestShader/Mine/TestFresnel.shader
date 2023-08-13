Shader "Unlit/TestFresnel"
{
    Properties
    {
        _Color1("Color 1",Color)=(1,1,1,0)
        _Alpha("Alpha",Range(0,5))=1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent"
         }
        

        Pass
        {
            ZWrite Off
            Cull Off
            Blend  DstAlpha SrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define TAU 6.28318530718

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals:TEXCOORD1;
            };

            struct Interpolator
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal:TEXCOORD1;
                float3 fresnelNormal:TEXCOORD2;
                 float4 worldPos : TEXCOORD3;
                float3 viewDir : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color1;
            float _Alpha;

            Interpolator vert (MeshData v)
            {
                Interpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal =UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv;
                o.fresnelNormal=UnityObjectToViewPos(v.normals);
                 o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));
                return o;
            }


void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
{
    Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
}
            float4 frag (Interpolator i) : SV_Target
            {
                // sample the texture

                
                //float2 centeredUv=i.uv*2-1;
                float distanceFromCenter=length(i.uv);
                float4 col = float4(_Color1.x,_Color1.y,_Color1.z,_Color1.w);
                float topBottomRemover=(abs(i.normal.y)<0.999);
                //float alphaToUV=(_Alpha*abs(centeredUv.y));
                float outValue;
                Unity_FresnelEffect_float(i.fresnelNormal,i.viewDir,_Alpha,outValue);
                return col*outValue;
            }
            ENDCG
        }
    }
}
