#include "Wall2D.h"

// #include <Corrade/Containers/GrowableArray.h>
// #include <Magnum/Math/Quaternion.h>

void Wall2D::UpdatePositions()
{
    uint32_t _positionCount = 0;
    uint32_t _indexCount    = 0;
    math::vec4 _l           = { 0.0f, Depth, 0.0f, 1 };
    float _Left = float( -Width / 2 ), _Right = float( Width / 2 ), _Top = float( Height / 2 ), _Bottom = float( -Height / 2 );
    float _SegmentStep = float( Width / (float)Segments );

    float _HorizontalSubdivisionsStep = float( Width / (float)HorizontalSubdivisions );
    float _VerticalSubdivisionsStep   = float( Height / ( (float)VerticalSubdivisions ) );

    math::vec3 _TopLeft     = math::vec3( math::Rotation( _Top, math::x_axis() ) * math::Rotation( _Left, math::z_axis() ) * _l );
    math::vec3 _TopRight    = math::vec3( math::Rotation( _Top, math::x_axis() ) * math::Rotation( _Right, math::z_axis() ) * _l );
    math::vec3 _BottomLeft  = math::vec3( math::Rotation( _Bottom, math::x_axis() ) * math::Rotation( _Left, math::z_axis() ) * _l );
    math::vec3 _BottomRight = math::vec3( math::Rotation( _Bottom, math::x_axis() ) * math::Rotation( _Right, math::z_axis() ) * _l );

    _positionCount = ( VerticalSubdivisions + 1 ) * ( Segments * 2 + 1 ) + ( HorizontalSubdivisions + 1 ) * ( ( VerticalSubdivisions + 1 ) * 2 + 1 );
    _indexCount    = ( VerticalSubdivisions + 1 ) * ( Segments * 2 ) + ( HorizontalSubdivisions + 1 ) * ( ( VerticalSubdivisions + 1 ) * 2 + 1 );

    m_WireframeGrid.Vertices.resize( _positionCount );
    for( auto &e : m_WireframeGrid.Vertices )
        e = math::vec3{};

    m_WireframeGrid.Indices.resize( _indexCount );
    for( auto &e : m_WireframeGrid.Indices )
        e = 0;

    math::mat4 _TopRotation    = math::Rotation( _Top, math::x_axis() );
    math::mat4 _BottomRotation = math::Rotation( _Bottom, math::x_axis() );
    math::mat4 _StepRotation   = math::Rotation( _SegmentStep, math::z_axis() );

    math::mat4 _HorizontalStepRotation = math::Rotation( _HorizontalSubdivisionsStep, math::z_axis() );
    math::mat4 _VerticalStepRotation   = math::Rotation( -_VerticalSubdivisionsStep, math::x_axis() );

    math::vec4 _TopSegment    = ( math::Rotation( _Left, math::z_axis() ) * _l );
    math::vec4 _BottomSegment = ( math::Rotation( _Left, math::z_axis() ) * _l );

    uint32_t _currentIndex    = 0;
    uint32_t _currentPosition = 0;

    m_WireframeGrid.Vertices[_currentPosition] = _TopLeft;
    m_WireframeGrid.Indices[_currentIndex]     = _currentPosition++;

    for( uint32_t l_LineIndex = 0; l_LineIndex < VerticalSubdivisions + 1; l_LineIndex++ )
    {
        m_WireframeGrid.Vertices[_currentPosition] = math::vec3( _TopRotation * _TopSegment );
        m_WireframeGrid.Indices[_currentIndex++]   = _currentPosition++;

        for( int i = 0; i < Segments; i++ )
        {
            _TopSegment                                = _StepRotation * _TopSegment;
            m_WireframeGrid.Vertices[_currentPosition] = math::vec3( _TopRotation * _TopSegment );
            m_WireframeGrid.Indices[_currentIndex++]   = _currentPosition;
            if( i < Segments - 1 )
            {
                m_WireframeGrid.Indices[_currentIndex++] = _currentPosition++;
            }
            else
            {
                _currentPosition++;
            }
        }
        _TopRotation = _VerticalStepRotation * _TopRotation;
        _TopSegment  = ( math::Rotation( _Left, math::z_axis() ) * _l );
    }

    m_WireframeGrid.Vertices[_currentPosition] = _TopLeft;
    m_WireframeGrid.Indices[_currentIndex]     = _currentPosition++;

    _TopRotation = math::Rotation( _Top, math::x_axis() );
    _TopSegment  = ( math::Rotation( _Left, math::z_axis() ) * _l );
    for( uint32_t l_LineIndex = 0; l_LineIndex < HorizontalSubdivisions + 1; l_LineIndex++ )
    {
        m_WireframeGrid.Vertices[_currentPosition] = math::vec3( _TopRotation * _TopSegment );
        m_WireframeGrid.Indices[_currentIndex++]   = _currentPosition++;
        auto _segment                              = _TopSegment;
        for( int i = 0; i < ( VerticalSubdivisions ); i++ )
        {
            _TopSegment                                = _VerticalStepRotation * _TopSegment;
            m_WireframeGrid.Vertices[_currentPosition] = math::vec3( _TopRotation * _TopSegment );
            m_WireframeGrid.Indices[_currentIndex++]   = _currentPosition;
            if( i < VerticalSubdivisions - 1 )
            {
                m_WireframeGrid.Indices[_currentIndex++] = _currentPosition++;
            }
            else
            {
                _currentPosition++;
            }
        }
        _TopRotation = math::Rotation( _Top, math::x_axis() );
        _TopSegment  = _HorizontalStepRotation * _segment;
    }
}
