#include "Core/Logging.h"
#include "DeveloperTools/Profiling/BlockTimer.h"
#include "Scripting/ScriptedSensorDevice.h"
#include "Scripting/ScriptingEngine.h"

#include <iostream>

using namespace math;
using namespace LTSE::Core;
using namespace LTSE::Cuda;
using namespace LTSE::TensorOps;
using namespace LTSE::SensorModel;

int main( int, char *[] )
{
    LuaSensorDevice lDevice( 3 * 1024 * 1024 * 1024, "C:\\GitLab\\LTSimulationEngine\\Programs\\TestLua\\Test\\test_sensor.lua" );

    auto x = lDevice.mSensorDefinition->GetTileByID( "tile_0" );

    Instrumentor::Get().BeginSession( "PROFILING" );
    for( uint32_t i = 0; i < 1000; i++ )
    {
        {
            LTSE_PROFILE_SCOPE( "WHOLE_PIPELINE" );
            lDevice.mComputationScope->Reset();
            auto s = lDevice.Sample( std::vector<Entity>{ x }, std::vector<math::vec2>{ math::vec2{ 1.0f, 2.0f } }, std::vector<float>{ 3.0f } );

            OpNode a = s["azimuths"];
            OpNode e = s["elevations"];
            OpNode i = s["intensities"];

            auto d = MultiTensorValue( *lDevice.mComputationScope, sConstantValueInitializerComponent( 3.0f ), a.Get<sMultiTensorComponent>().mValue.Shape() );

            auto &o = lDevice.Process( 0.0f, std::vector<Entity>{ x }, std::vector<math::vec2>{ math::vec2{ 1.0f, 2.0f } }, std::vector<float>{ 3.0f }, a, e, i, d );
            // auto v = o.Get<sMultiTensorComponent>().mValue.FetchBufferAt<float>(0);
            // auto w = o.Get<sMultiTensorComponent>().mValue.FetchBufferAt<float>(1);
        }
        if( ( i % 1 ) == 0 )
            LTSE::Logging::Info( "{}", i );
    }
    auto lResults = LTSE::Core::Instrumentor::Get().EndSession();

    // LTSE::Logging::Info( "{}", lResults->mEvents.size() );

    static std::unordered_map<std::string, float> lProfilingResults  = {};
    static std::unordered_map<std::string, uint32_t> lProfilingCount = {};

    for( auto &lEvent : lResults->mEvents )
    {
        if( lProfilingResults.find( lEvent.mName ) == lProfilingResults.end() )
        {
            lProfilingResults[lEvent.mName] = lEvent.mElapsedTime;
            lProfilingCount[lEvent.mName]   = 1;
        }
        else
        {
            lProfilingResults[lEvent.mName] += lEvent.mElapsedTime;
            lProfilingCount[lEvent.mName] += 1;
        }
    }

    for( auto &lEntry : lProfilingResults )
        lProfilingResults[lEntry.first] /= lProfilingCount[lEntry.first];

    for( auto &lEntry : lProfilingResults )
        LTSE::Logging::Info( "{} ----> {} us", lEntry.first, lEntry.second );

    return 0;
}
