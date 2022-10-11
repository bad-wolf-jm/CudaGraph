#include "GraphicsPipeline.h"

#include "Core/Logging.h"
#include "Core/Memory.h"

#include <stdexcept>

namespace LTSE::Graphics
{
    GraphicsPipeline::GraphicsPipeline( GraphicContext &a_GraphicContext, GraphicsPipelineCreateInfo &a_CreateInfo )
        : mGraphicContext( a_GraphicContext )
    {
        std::vector<Ref<Internal::sVkDescriptorSetLayoutObject>> l_DescriptorSetLayouts( a_CreateInfo.SetLayouts.size() );
        for( uint32_t i = 0; i < a_CreateInfo.SetLayouts.size(); i++ )
            l_DescriptorSetLayouts[i] = a_CreateInfo.SetLayouts[i]->GetVkDescriptorSetLayoutObject();

        m_PipelineLayoutObject = LTSE::Core::New<Internal::sVkPipelineLayoutObject>( mGraphicContext.mContext, l_DescriptorSetLayouts, a_CreateInfo.PushConstants );

        Internal::sDepthTesting lDepth{};
        lDepth.mDepthComparison  = a_CreateInfo.DepthComparison;
        lDepth.mDepthTestEnable  = a_CreateInfo.DepthTestEnable;
        lDepth.mDepthWriteEnable = a_CreateInfo.DepthWriteEnable;

        m_PipelineObject = LTSE::Core::New<Internal::sVkPipelineObject>( mGraphicContext.mContext, a_CreateInfo.SampleCount, a_CreateInfo.InputBufferLayout,
                                                                         a_CreateInfo.InstanceBufferLayout, a_CreateInfo.Topology, a_CreateInfo.Culling, a_CreateInfo.LineWidth,
                                                                         lDepth, a_CreateInfo.ShaderStages, m_PipelineLayoutObject, a_CreateInfo.RenderPass );
    }

} // namespace LTSE::Graphics