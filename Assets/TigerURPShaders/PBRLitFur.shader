Shader "Tiger/URP/LitFur(Cut-Out)"
{
    Properties
    {
        [NoScaleOffset] MainTexture("Diffuse Texture(UV0)", 2D) = "white" {}
        _DiffuseColor("Diffuse Color", Color) = (0.5,0.5,0.5,0)
        
        [NoScaleOffset] DetailTexture("Detail Diffuse(UV1)", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0.5

        _WindStrength("WindStrength", Range(0, 50)) = 20

        [Normal][NoScaleOffset] NormalTexture("Normal Texture(UV0)", 2D) = "bump" {}
        [NoScaleOffset] MetallicTexture("Metallic Texture(UV0)", 2D) = "white" {}
         _Cutoff("Alpha Cutoff", Range(0,1)) = 0.333
        
        _Cull("Face Culling(面Culling)", Float) = 2.0
    }
    
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }

        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Blend One Zero, One Zero
            ZTest LEqual
            ZWrite On

            Cull[_Cull]
            // ColorMask: <None>


            HLSLPROGRAM
            #pragma vertex customvert
            #pragma fragment frag
            // --------------------------------------------------
            // Pass

            // Pragmas         
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing


            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK

            // Defines
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
        //define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define SHADERPASS SHADERPASS_FORWARD

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            
            CBUFFER_START(UnityPerMaterial)
            half _Cutoff;
            float3 _DiffuseColor;
            half _Smoothness;
            float4 MainTexture_ST;
            float4 DetailTexture_ST;
            half _WindStrength;
            CBUFFER_END

            TEXTURE2D(MainTexture); 
            SAMPLER(sampler_MainTexture); 


            TEXTURE2D(NormalTexture);
            SAMPLER(sampler_NormalTexture);

            TEXTURE2D(DetailTexture);
            SAMPLER(sampler_DetailTexture);

            TEXTURE2D(MetallicTexture);
            SAMPLER(sampler_MetallicTexture);

                    // --------------------------------------------------
            // Structs and Packing

            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float4 uv1 : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float4 texCoord1;
                float4 texCoord2;
                float3 normalWS;
                float4 tangentWS;
                float3 viewDirectionWS;
                float3 sh;
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float3 interp03 : TEXCOORD3;
                float4 interp04 : TEXCOORD4;
                float3 interp05 : TEXCOORD5;
                float3 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
                
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;

                output.interp00.xyz = input.positionWS;
                output.interp01.xyzw = input.texCoord1;
                output.interp02.xyzw = input.texCoord2;
                output.interp03.xyz = input.normalWS;
                output.interp04.xyzw = input.tangentWS;
                output.interp05.xyz = input.viewDirectionWS;
                output.interp06.xyz = input.sh;            
                output.interp07.xyzw = input.fogFactorAndVertexLight;
                output.interp08.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.texCoord1 = input.interp01.xyzw;
                output.texCoord2 = input.interp02.xyzw;
                output.normalWS = input.interp03.xyz;
                output.tangentWS = input.interp04.xyzw;
                output.viewDirectionWS = input.interp05.xyz;
                output.sh = input.interp06.xyz;
                output.fogFactorAndVertexLight = input.interp07.xyzw;
                output.shadowCoord = input.interp08.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // custom vertex shader
            Varyings BuildVertex(Attributes IN)
            {
                Varyings OUT;

                float3 inputVertex = IN.positionOS.xyz;


                float WaveSpeed = _WindStrength;
                float WaveStr = 0.005;
                float3 sinOff = float3(sin(_Time.x * WaveSpeed), sin(_Time.x * WaveSpeed), cos(_Time.x * WaveSpeed));

                inputVertex += (sinOff * IN.normalOS.y * WaveStr);

                VertexPositionInputs positionInputs = GetVertexPositionInputs(inputVertex);
                OUT.positionCS = positionInputs.positionCS;
                OUT.positionWS = positionInputs.positionWS;
                VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normalOS, IN.tangentOS);
                // or, if you just need the normal :
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.texCoord1 = float4(TRANSFORM_TEX(IN.uv1, MainTexture), 1, 1);
                OUT.texCoord2 = float4(TRANSFORM_TEX(IN.uv2, DetailTexture), 1, 1);
                real sign = IN.tangentOS.w * GetOddNegativeScale();
                OUT.tangentWS = half4(normalInputs.tangentWS.xyz, sign);
                OUTPUT_SH(OUT.normalWS.xyz, OUT.sh);

                // View Direction, Perspective only
                OUT.viewDirectionWS = _WorldSpaceCameraPos - positionInputs.positionWS;

                // Vertex Lighting & Fog
                half3 vertexLight = VertexLighting(positionInputs.positionWS, normalInputs.normalWS);
                half fogFactor = ComputeFogFactor(positionInputs.positionCS.z);
                OUT.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

                // Shadow Coord
    #ifdef REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
                OUT.shadowCoord = GetShadowCoord(positionInputs);
    #endif
                return OUT;
            }


            PackedVaryings customvert(Attributes input)
            {
                Varyings output = (Varyings)0;
                output = BuildVertex(input);
                PackedVaryings packedOutput = (PackedVaryings)0;
                packedOutput = PackVaryings(output);
                return packedOutput;
            }



            // Unity Surface Shader
            struct SurfaceDescriptionInputs
            {
                float4 uv1;
                float4 uv2;
            };

            struct SurfaceDescription
            {
                float3 BaseColor;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };

        

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface;

                float4 _SampleTexture2D_Main = SAMPLE_TEXTURE2D(MainTexture, sampler_MainTexture, IN.uv1.xy);

                float4 _SampleTexture2D_Normal= SAMPLE_TEXTURE2D(NormalTexture, sampler_NormalTexture, IN.uv1.xy);
                _SampleTexture2D_Normal.rgb = UnpackNormal(_SampleTexture2D_Normal);

                float4 _SampleTexture2D_Metallic = SAMPLE_TEXTURE2D(MetallicTexture, sampler_MetallicTexture, IN.uv1.xy);

                float4 _SampleTexture2D_Detail = SAMPLE_TEXTURE2D(DetailTexture, sampler_DetailTexture, IN.uv2.xy);

                surface.BaseColor = _SampleTexture2D_Detail.xyz;
                surface.Normal = _SampleTexture2D_Normal.xyz;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = _SampleTexture2D_Metallic.x;
                surface.Smoothness = _Smoothness * _SampleTexture2D_Metallic.w;
                surface.Occlusion = 1;
                surface.Alpha = _SampleTexture2D_Main.w;
                surface.AlphaClipThreshold = _Cutoff;
                clip(surface.Alpha - _Cutoff);

                return surface;
            }



            // --------------------------------------------------
            // Build Graph Inputs

            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);


                output.uv1 = input.texCoord1;
                output.uv2 = input.texCoord2;


            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }


            // --------------------------------------------------
            // Main
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }

        // // shadow caster pass
        // Pass 
        // {
        //     Name "ShadowCaster"
        //     Tags
        //     {
        //         "LightMode" = "ShadowCaster"
        //     }

        //         // Render State
        //         Blend One Zero, One Zero
        //         Cull Back
        //         ZTest LEqual
        //         ZWrite On
        //         // ColorMask: <None>


        //         HLSLPROGRAM
        //         #pragma vertex vert
        //         #pragma fragment frag

        //         // Debug
        //         // <None>

        //         // --------------------------------------------------
        //         // Pass

        //         // Pragmas
        //         #pragma prefer_hlslcc gles
        //         #pragma exclude_renderers d3d11_9x
        //         #pragma target 2.0
        //         #pragma multi_compile_instancing

        //         // Keywords
        //         // PassKeywords: <None>
        //         // GraphKeywords: <None>

        //         // Defines
        //         #define _NORMAL_DROPOFF_TS 1
        //         #define ATTRIBUTES_NEED_NORMAL
        //         #define ATTRIBUTES_NEED_TANGENT
        //         #define SHADERPASS_SHADOWCASTER

        //         // Includes
        //         #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        //         #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        //         // --------------------------------------------------
        //         // Graph

        //         // Graph Properties
        //         CBUFFER_START(UnityPerMaterial)
        //         CBUFFER_END

        //         // Graph Functions
        //         // GraphFunctions: <None>

        //         // Graph Vertex
        //         // GraphVertex: <None>

        //         // Graph Pixel
        //         struct SurfaceDescriptionInputs
        //         {
        //             float3 TangentSpaceNormal;
        //         };

        //         struct SurfaceDescription
        //         {
        //             float Alpha;
        //             float AlphaClipThreshold;
        //         };

        //         SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        //         {
        //             SurfaceDescription surface = (SurfaceDescription)0;
        //             surface.Alpha = 1;
        //             surface.AlphaClipThreshold = 0;
        //             return surface;
        //         }

        //         // --------------------------------------------------
        //         // Structs and Packing

        //         // Generated Type: Attributes
        //         struct Attributes
        //         {
        //             float3 positionOS : POSITION;
        //             float3 normalOS : NORMAL;
        //             float4 tangentOS : TANGENT;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : INSTANCEID_SEMANTIC;
        //             #endif
        //         };

        //         // Generated Type: Varyings
        //         struct Varyings
        //         {
        //             float4 positionCS : SV_POSITION;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : CUSTOM_INSTANCE_ID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        //             #endif
        //         };

        //         // Generated Type: PackedVaryings
        //         struct PackedVaryings
        //         {
        //             float4 positionCS : SV_POSITION;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : CUSTOM_INSTANCE_ID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        //             #endif
        //         };

        //         // Packed Type: Varyings
        //         PackedVaryings PackVaryings(Varyings input)
        //         {
        //             PackedVaryings output = (PackedVaryings)0;
        //             output.positionCS = input.positionCS;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             output.instanceID = input.instanceID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             output.cullFace = input.cullFace;
        //             #endif
        //             return output;
        //         }

        //         // Unpacked Type: Varyings
        //         Varyings UnpackVaryings(PackedVaryings input)
        //         {
        //             Varyings output = (Varyings)0;
        //             output.positionCS = input.positionCS;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             output.instanceID = input.instanceID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             output.cullFace = input.cullFace;
        //             #endif
        //             return output;
        //         }

        //         // --------------------------------------------------
        //         // Build Graph Inputs

        //         SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        //         {
        //             SurfaceDescriptionInputs output;
        //             ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        //             output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


        //         #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //         #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        //         #else
        //         #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        //         #endif
        //         #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        //             return output;
        //         }


        //         // --------------------------------------------------
        //         // Main

        //         #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

        //         ENDHLSL
        //     }

        // // depth pass
        // Pass
        // {
        //     Name "DepthOnly"
        //     Tags
        //     {
        //         "LightMode" = "DepthOnly"
        //     }

        //         // Render State
        //         Blend One Zero, One Zero
        //         Cull Back
        //         ZTest LEqual
        //         ZWrite On
        //         ColorMask 0


        //         HLSLPROGRAM
        //         #pragma vertex vert
        //         #pragma fragment frag

        //         // Debug
        //         // <None>

        //         // --------------------------------------------------
        //         // Pass

        //         // Pragmas
        //         #pragma prefer_hlslcc gles
        //         #pragma exclude_renderers d3d11_9x
        //         #pragma target 2.0
        //         #pragma multi_compile_instancing

        //         // Keywords
        //         // PassKeywords: <None>
        //         // GraphKeywords: <None>

        //         // Defines
        //         #define _NORMAL_DROPOFF_TS 1
        //         #define ATTRIBUTES_NEED_NORMAL
        //         #define ATTRIBUTES_NEED_TANGENT
        //         #define SHADERPASS_DEPTHONLY

        //         // Includes
        //         #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        //         #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        //         // --------------------------------------------------
        //         // Graph

        //         // Graph Properties
        //         CBUFFER_START(UnityPerMaterial)
        //         CBUFFER_END

        //         // Graph Functions
        //         // GraphFunctions: <None>

        //         // Graph Vertex
        //         // GraphVertex: <None>

        //         // Graph Pixel
        //         struct SurfaceDescriptionInputs
        //         {
        //             float3 TangentSpaceNormal;
        //         };

        //         struct SurfaceDescription
        //         {
        //             float Alpha;
        //             float AlphaClipThreshold;
        //         };

        //         SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        //         {
        //             SurfaceDescription surface = (SurfaceDescription)0;
        //             surface.Alpha = 1;
        //             surface.AlphaClipThreshold = 0;
        //             return surface;
        //         }

        //         // --------------------------------------------------
        //         // Structs and Packing

        //         // Generated Type: Attributes
        //         struct Attributes
        //         {
        //             float3 positionOS : POSITION;
        //             float3 normalOS : NORMAL;
        //             float4 tangentOS : TANGENT;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : INSTANCEID_SEMANTIC;
        //             #endif
        //         };

        //         // Generated Type: Varyings
        //         struct Varyings
        //         {
        //             float4 positionCS : SV_POSITION;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : CUSTOM_INSTANCE_ID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        //             #endif
        //         };

        //         // Generated Type: PackedVaryings
        //         struct PackedVaryings
        //         {
        //             float4 positionCS : SV_POSITION;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             uint instanceID : CUSTOM_INSTANCE_ID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        //             #endif
        //         };

        //         // Packed Type: Varyings
        //         PackedVaryings PackVaryings(Varyings input)
        //         {
        //             PackedVaryings output = (PackedVaryings)0;
        //             output.positionCS = input.positionCS;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             output.instanceID = input.instanceID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             output.cullFace = input.cullFace;
        //             #endif
        //             return output;
        //         }

        //         // Unpacked Type: Varyings
        //         Varyings UnpackVaryings(PackedVaryings input)
        //         {
        //             Varyings output = (Varyings)0;
        //             output.positionCS = input.positionCS;
        //             #if UNITY_ANY_INSTANCING_ENABLED
        //             output.instanceID = input.instanceID;
        //             #endif
        //             #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        //             output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        //             #endif
        //             #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        //             output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        //             #endif
        //             #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //             output.cullFace = input.cullFace;
        //             #endif
        //             return output;
        //         }

        //         // --------------------------------------------------
        //         // Build Graph Inputs

        //         SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        //         {
        //             SurfaceDescriptionInputs output;
        //             ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        //             output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


        //         #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        //         #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        //         #else
        //         #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        //         #endif
        //         #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        //             return output;
        //         }


        //         // --------------------------------------------------
        //         // Main

        //         #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        //         #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

        //         ENDHLSL
        //     }


    }
      
    FallBack "Hidden/Shader Graph/FallbackError"
}
