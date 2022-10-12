// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Lighting Shader"
{
	Properties{
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white"{}
		//_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
		[Gamma ]_Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.1
	}

	SubShader{

		Pass{
			Tags {
				"LightMode" = "ForwardBase"
			}


			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityStandardBRDF.cginc"
			#include "UnityStandardUtils.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			//float4 _SpecularTint;
			float _Metallic;
			float _Smoothness;

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			Interpolators MyVertexProgram (VertexData v) {
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.worldPos = mul(unity_ObjectToWorld, v.position);
				i.normal = UnityObjectToWorldNormal(v.normal);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
				i.normal = normalize(i.normal);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
				// albedo *= 1 - max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b));
				float3 specularTint;// = albedo * _Metallic;
				float oneMinusReflectivity;// = 1 - _Metallic;

				//albedo *= oneMinusReflectivity;

			

				albedo = DiffuseAndSpecularFromMetallic(
				albedo, _Metallic, specularTint, oneMinusReflectivity
				);
				
				float3 diffuse = albedo *lightColor * DotClamped(lightDir, i.normal);
				float3 halfVector = normalize(lightDir + viewDir);


				float3 specular = specularTint *lightColor * pow(DotClamped(halfVector, i.normal),_Smoothness * 100);

				return float4(diffuse + specular, 1);
			}

			ENDCG
		}
	}
}
