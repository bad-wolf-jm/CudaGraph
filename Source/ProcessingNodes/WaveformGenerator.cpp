/// @file   WaveformGenerator.cpp
///
/// @brief  Implementation of the waveform generator.
///
/// @author Jean-Martin Albert
///
/// @copyright (c) 2022 LeddarTech Inc. All rights reserved.

#include <numeric>

#include "WaveformGenerator.h"
#include "WaveformGeneratorKernels.h"

#include "Cuda/MultiTensor.h"
#include "Cuda/Texture2D.h"

#include "TensorOps/ScalarTypes.h"

namespace LTSE::SensorModel
{

    using namespace LTSE::Core;
    using namespace LTSE::TensorOps;

    void sResolveAbstractWaveformsController::Run()
    {
        auto &lValue       = GetControlledEntity().Get<sMultiTensorComponent>().mValue;
        auto &lOperandData = GetControlledEntity().Get<sResolveAbstractWaveforms>();

        uint32_t lMaxAPDSize = 0;
        for( auto lSize : lOperandData.mAPDSizes.Get<sU32VectorComponent>().mValue )
            lMaxAPDSize = std::max( lMaxAPDSize, lSize );

        uint32_t lMaxWaveformLength = 0;
        for( auto lParam : lOperandData.mSamplingLength.Get<sU32VectorComponent>().mValue )
            lMaxWaveformLength = std::max( lMaxWaveformLength, lParam );

        auto &lReturnIntensities    = lOperandData.mReturnIntensities.Get<sMultiTensorComponent>().mValue;
        auto &lReturnTimes          = lOperandData.mReturnTimes.Get<sMultiTensorComponent>().mValue;
        auto &lSummandCount         = lOperandData.mSummandCount.Get<sVectorBufferComponent>().mValue;
        auto &lAPDSizes             = lOperandData.mAPDSizes.Get<sVectorBufferComponent>().mValue;
        auto &lAPDTemplatePositions = lOperandData.mAPDTemplatePositions.Get<sVectorBufferComponent>().mValue;
        auto &lSamplingLength       = lOperandData.mSamplingLength.Get<sVectorBufferComponent>().mValue;
        auto &lSamplingInterval     = lOperandData.mSamplingInterval.Get<sVectorBufferComponent>().mValue;
        auto &lPulseTemplates       = lOperandData.mPulseTemplates.Get<sVectorBufferComponent>().mValue;

        Kernels::ResolveAbstractWaveformsOp( lValue, lReturnIntensities, lReturnTimes, lSummandCount, lAPDSizes, lAPDTemplatePositions, lSamplingLength, lSamplingInterval,
                                             lPulseTemplates, lMaxAPDSize, lMaxWaveformLength );
    }

    OpNode ResolveWaveforms( LTSE::TensorOps::Scope &aScope, OpNode aReturnTimes, OpNode aReturnIntensities, OpNode aSamplingLength, OpNode aSamplingInterval,
                             OpNode aPulseTemplates )
    {
        auto lNewEntity = aScope.CreateNode();

        auto &lType  = lNewEntity.Add<sTypeComponent>();
        lType.mValue = eScalarType::FLOAT32;

        auto &lOperandData              = lNewEntity.Add<sResolveAbstractWaveforms>();
        lOperandData.mReturnTimes       = aReturnTimes;
        lOperandData.mReturnIntensities = aReturnIntensities;
        lOperandData.mSamplingLength    = aSamplingLength;
        lOperandData.mSamplingInterval  = aSamplingInterval;
        lOperandData.mPulseTemplates    = aPulseTemplates;

        auto &lTimesTensorShape = aReturnTimes.Get<sMultiTensorComponent>().mValue.Shape();
        uint32_t lLayerCount    = lTimesTensorShape.CountLayers();

        std::vector<uint32_t> lSummandCount( lLayerCount );

        std::vector<uint32_t> lAPDSizes = lTimesTensorShape.GetDimension( 0 );
        std::vector<uint32_t> lAPDTemplatePosition( lAPDSizes.size() );
        std::exclusive_scan( lAPDSizes.begin(), lAPDSizes.end(), lAPDTemplatePosition.begin(), 0u );

        for( uint32_t i = 0; i < lLayerCount; i++ )
            lSummandCount[i] = std::accumulate( lTimesTensorShape.mShape[i].begin() + 1, lTimesTensorShape.mShape[i].end(), 1, std::multiplies<uint32_t>() );

        lOperandData.mAPDSizes             = VectorValue( aScope, lAPDSizes );
        lOperandData.mAPDTemplatePositions = VectorValue( aScope, lAPDTemplatePosition );
        lOperandData.mSummandCount         = VectorValue( aScope, lSummandCount );

        auto &lOperands     = lNewEntity.Add<sOperandComponent>();
        lOperands.mOperands = { aReturnTimes,
                                aReturnIntensities,
                                aSamplingLength,
                                aSamplingInterval,
                                aPulseTemplates,
                                lOperandData.mAPDSizes,
                                lOperandData.mAPDTemplatePositions,
                                lOperandData.mSummandCount };

        auto &lValue = lNewEntity.Add<sMultiTensorComponent>();
        sTensorShape lTargetShape( lAPDSizes, SizeOf( lType.mValue ) );
        lTargetShape.InsertDimension( -1, aSamplingLength.Get<sU32VectorComponent>().mValue );
        lValue.mValue = Cuda::MultiTensor( aScope.mPool, lTargetShape );

        lNewEntity.Add<sGraphOperationComponent>().Bind<sResolveAbstractWaveformsController>();
        return lNewEntity;
    }

} // namespace LTSE::SensorModel