Shader "Unlit/SwordTestTexture"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
        _AOCTex("AO", 2D) = "white" {}
        _AlbedoTex("Albedo", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "white" {}
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
                float2 uvAlb : TEXCOORD1;
                float2 uvNormal : TEXCOORD2;
                float2 uvAOC : TEXCOORD3;
                
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uvAlb : TEXCOORD1;
                float2 uvNormal : TEXCOORD2;
                float2 uvAOC : TEXCOORD3;
            };

            sampler2D _MainTex;
            sampler2D _AlbedoTex;
            sampler2D _NormalMap;
            sampler2D _AOCTex;
            float4 _MainTex_ST;
            float4 _AlbedoTex_ST;
            float4 _NormalMap_ST;
            float4 _AOCTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvAlb = TRANSFORM_TEX(v.uv, _AlbedoTex);
                o.uvNormal = TRANSFORM_TEX(v.uv, _NormalMap);
                o.uvAOC = TRANSFORM_TEX(v.uv, _AOCTex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                float4 colAlb = tex2D(_AlbedoTex, i.uv);
                float4 colNormal = tex2D(_NormalMap, i.uv);
                float4 colAOC = tex2D(_AOCTex, i.uv);
                
                //float finalcolx = lerp(colAlb.x,colAOC.x,colAOC.x - i.uv.x);
                //float finalcolory = lerp(colAlb.y,colAOC.y,colAOC.y - i.uv.y);
                //float finalcolz = lerp(colAlb.z,colAOC.z,colAOC.z - i.uv.y);
                //float finalcolorw = lerp(colAlb.w,colAOC.w,i.uv.x);

                return float4(i.uv.xxx , 0);
            }
            ENDCG
        }
    }
}
