#pragma once

#include "Core/Math/Types.h"
#include "Developer/Platform/ViewportClient.h"
#include <memory>
#include <vulkan/vulkan.h>

#include "VkContext.h"
#include "VkImage.h"

#include "Core/Memory.h"

namespace LTSE::Graphics::Internal
{
    using namespace LTSE::Core;

    struct sVkRenderPassObject
    {
        VkRenderPass mVkObject = VK_NULL_HANDLE;
        uint32_t mSampleCount  = 1;

        sVkRenderPassObject()                        = default;
        sVkRenderPassObject( sVkRenderPassObject & ) = default;
        sVkRenderPassObject( Ref<VkContext> aContext, std::vector<VkAttachmentDescription> a_Attachments, std::vector<VkSubpassDescription> a_Subpasses,
                             std::vector<VkSubpassDependency> a_SubpassDependencies );

        sVkRenderPassObject( Ref<VkContext> aContext, VkFormat a_Format, uint32_t a_SampleCount, bool a_IsSampled, bool a_IsPresented, math::vec4 a_ClearColor );

        ~sVkRenderPassObject();

        VkAttachmentDescription ColorAttachment( VkFormat a_Format, uint32_t a_SampleCount, bool a_Sampled, bool a_Presented );
        VkAttachmentDescription DepthAttachment( uint32_t a_SampleCount );

        std::vector<VkClearValue> GetClearValues();

      private:
        Ref<VkContext> mContext                = nullptr;
        std::vector<VkClearValue> mClearValues = {};
    };

} // namespace LTSE::Graphics::Internal
