#include "VkRenderPass.h"

#include <set>
#include <unordered_set>

#include "Core/Memory.h"
#include "VkCoreMacros.h"

namespace LTSE::Graphics::Internal
{

    sVkRenderPassObject::sVkRenderPassObject( Ref<VkContext> aContext, std::vector<VkAttachmentDescription> a_Attachments, std::vector<VkSubpassDescription> a_Subpasses,
                                              std::vector<VkSubpassDependency> a_SubpassDependencies )
        : mContext{ aContext }
    {
        mVkObject = mContext->CreateRenderPass( a_Attachments, a_Subpasses, a_SubpassDependencies );
    }

    sVkRenderPassObject::sVkRenderPassObject( Ref<VkContext> aContext, VkFormat a_Format, uint32_t a_SampleCount, bool a_IsSampled, bool a_IsPresented, math::vec4 a_ClearColor )
        : mSampleCount{ a_SampleCount }
        , mContext{ aContext }
    {
        VkSubpassDescription l_Subpass{};
        std::vector<VkAttachmentDescription> l_Attachments{};

        if( mSampleCount == 1 )
        {
            l_Attachments.resize( 2 );
            mClearValues.resize( 2 );
            VkAttachmentDescription l_ColorAttachment = ColorAttachment( a_Format, mSampleCount, a_IsSampled, a_IsPresented );
            VkAttachmentReference l_ColorAttachmentReference{};
            l_ColorAttachmentReference.attachment = 0;
            l_ColorAttachmentReference.layout     = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

            VkAttachmentDescription l_DepthAttachment = DepthAttachment( 1 );
            VkAttachmentReference l_DepthAttachmentReference{};
            l_DepthAttachmentReference.attachment = 1;
            l_DepthAttachmentReference.layout     = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

            l_Attachments[0] = l_ColorAttachment;
            l_Attachments[1] = l_DepthAttachment;

            mClearValues[0]       = VkClearValue{};
            mClearValues[0].color = { a_ClearColor.x, a_ClearColor.y, a_ClearColor.z, a_ClearColor.w };

            mClearValues[1]       = VkClearValue{};
            mClearValues[1].color = { a_ClearColor.x, a_ClearColor.y, a_ClearColor.z, a_ClearColor.w };

            l_Subpass.pipelineBindPoint       = VK_PIPELINE_BIND_POINT_GRAPHICS;
            l_Subpass.colorAttachmentCount    = 1;
            l_Subpass.pColorAttachments       = &l_ColorAttachmentReference;
            l_Subpass.pResolveAttachments     = nullptr;
            l_Subpass.pDepthStencilAttachment = &l_DepthAttachmentReference;
        }
        else
        {
            l_Attachments.resize( 3 );
            mClearValues.resize( 3 );

            VkAttachmentDescription l_MSAAColorAttachment = ColorAttachment( a_Format, mSampleCount, false, false );
            VkAttachmentReference l_MSAAColorAttachmentReference{};
            l_MSAAColorAttachmentReference.attachment = 0;
            l_MSAAColorAttachmentReference.layout     = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

            VkAttachmentDescription l_ResolveColorAttachment = ColorAttachment( a_Format, 1, a_IsSampled, a_IsPresented );
            VkAttachmentReference l_ResolveColorAttachmentReference{};
            l_ResolveColorAttachmentReference.attachment = 1;
            l_ResolveColorAttachmentReference.layout     = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

            VkAttachmentDescription l_DepthAttachment = DepthAttachment( mSampleCount );
            VkAttachmentReference l_DepthAttachmentReference{};
            l_DepthAttachmentReference.attachment = 2;
            l_DepthAttachmentReference.layout     = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

            l_Attachments[0] = l_MSAAColorAttachment;
            l_Attachments[1] = l_ResolveColorAttachment;
            l_Attachments[2] = l_DepthAttachment;

            mClearValues[0]       = VkClearValue{};
            mClearValues[0].color = { a_ClearColor.x, a_ClearColor.y, a_ClearColor.z, a_ClearColor.w };

            mClearValues[1]       = VkClearValue{};
            mClearValues[1].color = { a_ClearColor.x, a_ClearColor.y, a_ClearColor.z, a_ClearColor.w };

            mClearValues[2]              = VkClearValue{};
            mClearValues[2].depthStencil = { 1.0f, 0 };

            l_Subpass.pipelineBindPoint       = VK_PIPELINE_BIND_POINT_GRAPHICS;
            l_Subpass.colorAttachmentCount    = 1;
            l_Subpass.pColorAttachments       = &l_MSAAColorAttachmentReference;
            l_Subpass.pResolveAttachments     = &l_ResolveColorAttachmentReference;
            l_Subpass.pDepthStencilAttachment = &l_DepthAttachmentReference;
        }

        std::vector<VkSubpassDependency> l_SubpassDependencies( 2 );
        l_SubpassDependencies[0].srcSubpass    = VK_SUBPASS_EXTERNAL;
        l_SubpassDependencies[0].srcAccessMask = VK_ACCESS_SHADER_READ_BIT;
        l_SubpassDependencies[0].srcStageMask  = VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT | VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
        l_SubpassDependencies[0].dstSubpass    = 0;
        l_SubpassDependencies[0].dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
        l_SubpassDependencies[0].dstStageMask  = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;

        l_SubpassDependencies[1].srcSubpass    = 0;
        l_SubpassDependencies[1].srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT | VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT;
        l_SubpassDependencies[1].srcStageMask  = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
        l_SubpassDependencies[1].dstSubpass    = VK_SUBPASS_EXTERNAL;
        l_SubpassDependencies[1].dstAccessMask = VK_ACCESS_SHADER_READ_BIT;
        l_SubpassDependencies[1].dstStageMask  = VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;

        mVkObject = mContext->CreateRenderPass( l_Attachments, std::vector<VkSubpassDescription>{ l_Subpass }, l_SubpassDependencies );
    }

    sVkRenderPassObject::~sVkRenderPassObject() { mContext->DestroyRenderPass( mVkObject ); }

    std::vector<VkClearValue> sVkRenderPassObject::GetClearValues() { return mClearValues; }

    VkAttachmentDescription sVkRenderPassObject::ColorAttachment( VkFormat a_Format, uint32_t a_SampleCount, bool a_Sampled, bool a_Presented )
    {
        VkAttachmentDescription l_AttachmentSpec{};
        l_AttachmentSpec.samples        = VK_SAMPLE_COUNT_VALUE( a_SampleCount );
        l_AttachmentSpec.format         = a_Format;
        l_AttachmentSpec.loadOp         = VK_ATTACHMENT_LOAD_OP_CLEAR;
        l_AttachmentSpec.storeOp        = VK_ATTACHMENT_STORE_OP_STORE;
        l_AttachmentSpec.stencilLoadOp  = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
        l_AttachmentSpec.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
        l_AttachmentSpec.initialLayout  = VK_IMAGE_LAYOUT_UNDEFINED;

        if( a_Sampled )
        {
            l_AttachmentSpec.finalLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
        }
        else if( a_Presented )
        {
            l_AttachmentSpec.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
        }
        else
        {
            l_AttachmentSpec.finalLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
        }

        return l_AttachmentSpec;
    }

    VkAttachmentDescription sVkRenderPassObject::DepthAttachment( uint32_t a_SampleCount )
    {
        VkAttachmentDescription l_AttachmentSpec{};
        l_AttachmentSpec.samples        = VK_SAMPLE_COUNT_VALUE( a_SampleCount );
        l_AttachmentSpec.format         = mContext->GetDepthFormat();
        l_AttachmentSpec.loadOp         = VK_ATTACHMENT_LOAD_OP_CLEAR;
        l_AttachmentSpec.storeOp        = VK_ATTACHMENT_STORE_OP_DONT_CARE;
        l_AttachmentSpec.stencilLoadOp  = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
        l_AttachmentSpec.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
        l_AttachmentSpec.initialLayout  = VK_IMAGE_LAYOUT_UNDEFINED;
        l_AttachmentSpec.finalLayout    = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

        return l_AttachmentSpec;
    }

} // namespace LTSE::Graphics::Internal