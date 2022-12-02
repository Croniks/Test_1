Shader "Custom/StripedSG"
{
    Properties
    {
    _frequency("Frequency", Float) = 6
    _offset("Offset", Float) = 0
    _width("Thickness", Range(0, 1)) = 0.5
    _rotation("Rotation", Float) = 45
    }
        SubShader
    {
    Tags
    {
            // RenderPipeline: <None>
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "ShaderGraphShader" = "true"
            }
            Pass
            {
            // Name: <None>
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        // RenderState: <None>

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma vertex vert
    #pragma fragment frag

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_PREVIEW
    #define SHADERGRAPH_PREVIEW 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */

        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Packing.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariables.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

        struct Attributes
    {
     float3 positionOS : POSITION;
     float4 uv0 : TEXCOORD0;
    #if UNITY_ANY_INSTANCING_ENABLED
     uint instanceID : INSTANCEID_SEMANTIC;
    #endif
    };
    struct Varyings
    {
     float4 positionCS : SV_POSITION;
     float4 texCoord0;
    #if UNITY_ANY_INSTANCING_ENABLED
     uint instanceID : CUSTOM_INSTANCE_ID;
    #endif
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
    #endif
    };
    struct SurfaceDescriptionInputs
    {
     float4 uv0;
    };
    struct VertexDescriptionInputs
    {
    };
    struct PackedVaryings
    {
     float4 positionCS : SV_POSITION;
     float4 interp0 : INTERP0;
    #if UNITY_ANY_INSTANCING_ENABLED
     uint instanceID : CUSTOM_INSTANCE_ID;
    #endif
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
    #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
    PackedVaryings output;
    ZERO_INITIALIZE(PackedVaryings, output);
    output.positionCS = input.positionCS;
    output.interp0.xyzw = input.texCoord0;
    #if UNITY_ANY_INSTANCING_ENABLED
    output.instanceID = input.instanceID;
    #endif
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    output.cullFace = input.cullFace;
    #endif
    return output;
    }

    Varyings UnpackVaryings(PackedVaryings input)
    {
    Varyings output;
    output.positionCS = input.positionCS;
    output.texCoord0 = input.interp0.xyzw;
    #if UNITY_ANY_INSTANCING_ENABLED
    output.instanceID = input.instanceID;
    #endif
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    output.cullFace = input.cullFace;
    #endif
    return output;
    }


    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float _frequency;
float _offset;
float _width;
float _rotation;
CBUFFER_END

// Object and Global properties

    // Graph Includes
    // GraphIncludes: <None>

    // -- Property used by ScenePickingPass
    #ifdef SCENEPICKINGPASS
    float4 _SelectionID;
    #endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
{
    //rotation matrix
    Rotation = Rotation * (3.1415926f / 180.0f);
    UV -= Center;
    float s = sin(Rotation);
    float c = cos(Rotation);

    //center rotation matrix
    float2x2 rMatrix = float2x2(c, -s, s, c);
    rMatrix *= 0.5;
    rMatrix += 0.5;
    rMatrix = rMatrix * 2 - 1;

    //multiply the UVs by the rotation matrix
    UV.xy = mul(UV.xy, rMatrix);
    UV += Center;

    Out = UV;
}

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Fraction_float2(float2 In, out float2 Out)
{
    Out = frac(In);
}

/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
// GraphVertex: <None>

/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreSurface' */

// Graph Pixel
struct SurfaceDescription
{
float4 Out;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_0d838097226700869079cc00d0852284_Out_0 = _rotation;
float2 _Rotate_920daf2ba7bd6180a0e932ba67f5a262_Out_3;
Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_0d838097226700869079cc00d0852284_Out_0, _Rotate_920daf2ba7bd6180a0e932ba67f5a262_Out_3);
float _Property_5fe60eed304b8c83969752c293e4ba8f_Out_0 = _frequency;
float2 _Vector2_08468c10273ef08d8ce3de1fb4f539c9_Out_0 = float2(_Property_5fe60eed304b8c83969752c293e4ba8f_Out_0, 1);
float _Property_b03df2adac750b87978af0b5cccfffce_Out_0 = _offset;
float2 _Vector2_e54ebef4d572b582836426bc4e72c7d5_Out_0 = float2(_Property_b03df2adac750b87978af0b5cccfffce_Out_0, 0);
float2 _TilingAndOffset_c17d9a59d978ad80abc8c87c4becfaba_Out_3;
Unity_TilingAndOffset_float(_Rotate_920daf2ba7bd6180a0e932ba67f5a262_Out_3, _Vector2_08468c10273ef08d8ce3de1fb4f539c9_Out_0, _Vector2_e54ebef4d572b582836426bc4e72c7d5_Out_0, _TilingAndOffset_c17d9a59d978ad80abc8c87c4becfaba_Out_3);
float2 _Fraction_9f379d335ff7bd88b257eeb9680ca387_Out_1;
Unity_Fraction_float2(_TilingAndOffset_c17d9a59d978ad80abc8c87c4becfaba_Out_3, _Fraction_9f379d335ff7bd88b257eeb9680ca387_Out_1);
surface.Out = all(isfinite(_Fraction_9f379d335ff7bd88b257eeb9680ca387_Out_1)) ? half4(_Fraction_9f379d335ff7bd88b257eeb9680ca387_Out_1.x, _Fraction_9f379d335ff7bd88b257eeb9680ca387_Out_1.y, 0.0, 1.0) : float4(1.0f, 0.0f, 1.0f, 1.0f);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewVaryings.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/PreviewPass.hlsl"

    ENDHLSL
}
    }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        FallBack "Hidden/Shader Graph/FallbackError"
}