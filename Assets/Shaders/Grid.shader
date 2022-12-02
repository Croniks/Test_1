Shader "Custom/Grid"
{
    Properties
    {
    _width("Size", Float) = 0.9
    _tiling("Tiling", Vector) = (8, 8, 0, 0)
    _offset("Offset", Vector) = (0, 0, 0, 0)
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
float _width;
float2 _tiling;
float2 _offset;
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
float2 _Property_372660d10ff02e85a219c963d16063f1_Out_0 = _tiling;
float2 _Property_cf215d09b9c0dd8cbc94e9ff5fc8cd32_Out_0 = _offset;
float2 _TilingAndOffset_7ef98bf5d80d3e80920e877b157d97a2_Out_3;
Unity_TilingAndOffset_float(IN.uv0.xy, _Property_372660d10ff02e85a219c963d16063f1_Out_0, _Property_cf215d09b9c0dd8cbc94e9ff5fc8cd32_Out_0, _TilingAndOffset_7ef98bf5d80d3e80920e877b157d97a2_Out_3);
float2 _Fraction_00dd85cd0e38fc8ba6e24864e56ff16d_Out_1;
Unity_Fraction_float2(_TilingAndOffset_7ef98bf5d80d3e80920e877b157d97a2_Out_3, _Fraction_00dd85cd0e38fc8ba6e24864e56ff16d_Out_1);
surface.Out = all(isfinite(_Fraction_00dd85cd0e38fc8ba6e24864e56ff16d_Out_1)) ? half4(_Fraction_00dd85cd0e38fc8ba6e24864e56ff16d_Out_1.x, _Fraction_00dd85cd0e38fc8ba6e24864e56ff16d_Out_1.y, 0.0, 1.0) : float4(1.0f, 0.0f, 1.0f, 1.0f);
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