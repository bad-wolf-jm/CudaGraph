#pragma once

#include <vulkan/vulkan.h>

#include "Core/Memory.h"

#include "DescriptorSet.h"
#include "Developer/Core/Vulkan/VkPipeline.h"
#include "Developer/Core/Vulkan/VkRenderPass.h"
#include "Developer/GraphicContext/GraphicContext.h"


namespace LTSE::Graphics
{
    using eBufferDataType        = Internal::eBufferDataType;
    using sBufferLayoutElement   = Internal::sBufferLayoutElement;
    using sBufferLayout          = Internal::sBufferLayout;
    using ePrimitiveTopology     = Internal::ePrimitiveTopology;
    using eFaceCulling           = Internal::eFaceCulling;
    using sShader                = Internal::sShader;
    using sPushConstantRange     = Internal::sPushConstantRange;
    using eDepthCompareOperation = Internal::eDepthCompareOperation;

    struct GraphicsPipelineCreateInfo
    {
        std::vector<sShader> ShaderStages                = {};
        sBufferLayout InputBufferLayout                  = {};
        sBufferLayout InstanceBufferLayout               = {};
        ePrimitiveTopology Topology                      = ePrimitiveTopology::TRIANGLES;
        eFaceCulling Culling                             = eFaceCulling::BACK;
        uint8_t SampleCount                              = 1;
        float LineWidth                                  = 1.0f;
        bool DepthWriteEnable                            = false;
        bool DepthTestEnable                             = false;
        eDepthCompareOperation DepthComparison           = eDepthCompareOperation::ALWAYS;
        std::vector<sPushConstantRange> PushConstants    = {};
        Ref<Internal::sVkRenderPassObject> RenderPass    = nullptr;
        std::vector<Ref<DescriptorSetLayout>> SetLayouts = {};
    };

    class GraphicsPipeline
    {
      public:
        GraphicsPipeline( GraphicContext &a_GraphicContext, GraphicsPipelineCreateInfo &a_CreateInfo );
        ~GraphicsPipeline() = default;

        Ref<Internal::sVkPipelineObject> GetVkPipelineObject() { return m_PipelineObject; }
        Ref<Internal::sVkPipelineLayoutObject> GetVkPipelineLayoutObject() { return m_PipelineLayoutObject; }

      private:
        GraphicContext mGraphicContext{};
        Ref<Internal::sVkPipelineLayoutObject> m_PipelineLayoutObject = nullptr;
        Ref<Internal::sVkPipelineObject> m_PipelineObject             = nullptr;
    };

} // namespace LTSE::Graphics