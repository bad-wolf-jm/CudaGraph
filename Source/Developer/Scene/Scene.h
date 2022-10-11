
#pragma once

#include <filesystem>
#include <optional>

#include "Core/Math/Types.h"
#include "Core/Memory.h"
#include "Core/Types.h"

#include "Developer/Core/Cuda/ExternalMemory.h"

#include "Developer/GraphicContext/DescriptorSet.h"
#include "Developer/GraphicContext/GraphicContext.h"
#include "Developer/GraphicContext/GraphicsPipeline.h"

#include "Developer/UI/UI.h"

#include "Developer/GraphicContext/UI/UIContext.h"
#include "VertexData.h"

#include "Core/EntityRegistry/Registry.h"
#include "Core/TextureTypes.h"

#include "Scripting/ScriptingEngine.h"

#include "Developer/Core/Optix/OptixAccelerationStructure.h"
#include "Developer/Core/Optix/OptixContext.h"
#include "Developer/Core/Optix/OptixModule.h"
#include "Developer/Core/Optix/OptixPipeline.h"
#include "Developer/Core/Optix/OptixShaderBindingTable.h"

#include "Importer/ImporterData.h"

#include "Components.h"

using namespace math;
using namespace math::literals;
using namespace LTSE::Graphics;
namespace fs = std::filesystem;
using namespace LTSE::Core::EntityComponentSystem::Components;

namespace LTSE::Core
{

    class Scene
    {
      public:
        enum class eSceneState : uint8_t
        {
            EDITING,
            RUNNING
        };

        typedef Entity Element;

        Scene( GraphicContext &a_GraphicContext, Ref<LTSE::Core::UIContext> a_UI );
        Scene( Scene & ) = delete;
        ~Scene();

        Element Create( std::string a_Name, Element a_Parent );

        Element CreateEntity();
        Element CreateEntity( std::string a_Name );

        Element LoadModel( Ref<sImportedModel> aModelData, math::mat4 aTransform );
        Element LoadModel( Ref<sImportedModel> aModelData, math::mat4 aTransform, std::string a_Name );

        void BeginScenario();
        void EndScenario();

        void MarkAsRayTracingTarget( Element a_Element );
        void AttachScript( Element aElement, fs::path aScriptPath );

        math::mat4 GetView();
        math::mat4 GetProjection();
        math::vec3 GetCameraPosition();

        void Update( Timestep ts );
        void Render();

        Element CurrentCamera;
        Element DefaultCamera;

        Element Environment;
        Element Root;

        GraphicContext &GetGraphicContext() { return mGraphicContext; }

        template <typename... Args> void ForEach( std::function<void( Element, Args &... )> a_ApplyFunction ) { m_Registry.ForEach<Args...>( a_ApplyFunction ); }

        void UpdateRayTracingComponents();
        OptixTraversableHandle GetRayTracingRoot()
        {
            if( m_AccelerationStructure )
                return m_AccelerationStructure->RTObject;
            return 0;
        }

        Ref<LTSE::Graphics::OptixDeviceContextObject> GetRayTracingContext() { return m_RayTracingContext; }

        eSceneState GetState() { return mState; }
        MaterialSystem &GetMaterialSystem() { return mMaterialSystem; }

        void ClearScene();

        Ref<Buffer> mVertexBuffer = nullptr;
        Ref<Buffer> mIndexBuffer  = nullptr;

        Ref<Buffer> mTransformedVertexBuffer = nullptr;

        Cuda::GPUExternalMemory mTransformedVertexBufferMemoryHandle{};
        Cuda::GPUExternalMemory mVertexBufferMemoryHandle{};
        Cuda::GPUExternalMemory mIndexBufferMemoryHandle{};

      private:
        eSceneState mState = eSceneState::EDITING;
        GraphicContext mGraphicContext;
        MaterialSystem mMaterialSystem;

        Ref<ScriptingEngine> mSceneScripting = nullptr;

        Ref<UIContext> m_UI                                 = nullptr;
        Ref<OptixDeviceContextObject> m_RayTracingContext   = nullptr;
        Ref<OptixTraversableObject> m_AccelerationStructure = nullptr;

        Ref<Graphics::Texture2D> m_EmptyTexturePreview = nullptr;
        UI::ImageHandle m_EmptyTexturePreviewImageHandle;

        void UpdateParent(Entity const &aEntity, sRelationshipComponent const &aComponent);
        void UpdateLocalTransform(Entity const &aEntity, LocalTransformComponent const &aComponent);
        void UpdateTransformMatrix(Entity const &aEntity, TransformMatrixComponent const &aComponent);

      protected:
        LTSE::Core::EntityRegistry m_Registry;

        void InitializeRayTracing();
        void RebuildAccelerationStructure();
        void DestroyEntity( Element entity );
        void ConnectSignalHandlers();

        std::unordered_map<std::string, Element> mAssetSystem = {};
        GPUMemory mTransforms{};
        GPUMemory mVertexOffsets{};
        GPUMemory mVertexCounts{};


      private:
        friend class Element;
    };

} // namespace LTSE::Core
