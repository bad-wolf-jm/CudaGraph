-- Test sensor

local vec2 = Math.vec2
local Ops = Cuda.Ops

local function create_flash(self, tile, position, extent, laser, photodetector)
    -- create a laser flash definition and assign it to the tile
    flash = self.sensor_model:create_flash(tile, "", position, extent)

    -- bind the flash to the laser and the photodetector
    flash:adjoin(Sensor.sLaserAssembly, laser)
    flash:adjoin(Sensor.sPhotoDetector, photodetector)

    return flash
end

flash_coordinates = Core.Vec2Array{
    vec2{ -4.20368304, 0.0 }, vec2{ -3.93247768, 0.0 }, vec2{ -3.66127232, 0.0 }, vec2{ -3.39006696, 0.0 }, vec2{ -3.11886161, 0.0 }, vec2{ -2.84765625, 0.0 }, vec2{-2.57645089, 0.0}, vec2{-2.30524554, 0.0},
    vec2{ -2.03404018, 0.0 }, vec2{ -1.76283482, 0.0 }, vec2{ -1.49162946, 0.0 }, vec2{ -1.22042411, 0.0 }, vec2{ -0.94921875, 0.0 }, vec2{ -0.67801339, 0.0 }, vec2{-0.40680804, 0.0}, vec2{-0.13560268, 0.0},
    vec2{  0.13560268, 0.0 }, vec2{  0.40680804, 0.0 }, vec2{  0.67801339, 0.0 }, vec2{  0.94921875, 0.0 }, vec2{  1.22042411, 0.0 }, vec2{  1.49162946, 0.0 }, vec2{ 1.76283482, 0.0}, vec2{ 2.03404018, 0.0},
    vec2{  2.30524554, 0.0 }, vec2{  2.57645089, 0.0 }, vec2{  2.84765625, 0.0 }, vec2{  3.11886161, 0.0 }, vec2{  3.39006696, 0.0 }, vec2{  3.66127232, 0.0 }, vec2{ 3.93247768, 0.0}, vec2{ 4.20368304, 0.0}
}

flash_size_hint = Core.Vec2Array{
    vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 },
    vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 },
    vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 },
    vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }, vec2{ 0.135, 3.05 }
}

tile_positions = Core.Vec2Array{
    vec2{ -56.410713, 12.2200012 }, vec2{ -47.73214, 12.2200012 }, vec2{ -39.053566, 12.2200012 }, vec2{ -30.374994, 12.2200012 }, vec2{ -21.696423, 12.2200012 }, vec2{ -13.017851, 12.2200012 }, vec2{ -4.339279, 12.2200012 },
    vec2{ 4.3392925, 12.2200012 }, vec2{ 13.017864, 12.2200012 },vec2{ 21.696436, 12.2200012 }, vec2{ 30.375008, 12.2200012 }, vec2{ 39.05358, 12.2200012 }, vec2{ 47.732155, 12.2200012 }, vec2{ 56.41073, 12.2200012 },

    vec2{ -56.410713, 6.1100006 }, vec2{ -47.73214, 6.1100006 }, vec2{ -39.053566, 6.1100006 }, vec2{ -30.374994, 6.1100006 }, vec2{ -21.696423, 6.1100006 }, vec2{ -13.017851, 6.1100006 }, vec2{ -4.339279, 6.1100006 },
    vec2{ 4.3392925, 6.1100006 }, vec2{ 13.017864, 6.1100006 }, vec2{ 21.696436, 6.1100006 }, vec2{ 30.375008,   6.1100006 }, vec2{ 39.05358, 6.1100006 }, vec2{ 47.732155, 6.1100006 }, vec2{ 56.41073, 6.1100006 },

    vec2{ -56.410713, 4.7683716e-07 }, vec2{ -47.73214, 4.7683716e-07 }, vec2{ -39.053566, 4.7683716e-07 }, vec2{ -30.374994, 4.7683716e-07 }, vec2{ -21.696423, 4.7683716e-07 }, vec2{ -13.017851, 4.7683716e-07 }, vec2{ -4.339279, 4.7683716e-07 },
    vec2{ 4.3392925, 4.7683716e-07 }, vec2{ 13.017864, 4.7683716e-07 }, vec2{ 21.696436, 4.7683716e-07 }, vec2{ 30.375008, 4.7683716e-07 }, vec2{ 39.05358, 4.7683716e-07 }, vec2{ 47.732155, 4.7683716e-07 }, vec2{ 56.41073, 4.7683716e-07 },

    vec2{ -56.410713, -6.1099997 }, vec2{ -47.73214, -6.1099997 }, vec2{ -39.053566, -6.1099997 }, vec2{ -30.374994, -6.1099997 }, vec2{ -21.696423, -6.1099997 }, vec2{ -13.017851, -6.1099997 }, vec2{ -4.339279, -6.1099997 },
    vec2{ 4.3392925, -6.1099997 }, vec2{ 13.017864, -6.1099997 }, vec2{ 21.696436, -6.1099997 }, vec2{ 30.375008, -6.1099997 }, vec2{ 39.05358, -6.1099997 }, vec2{ 47.732155, -6.1099997 }, vec2{ 56.41073, -6.1099997 },
}

flash_world_position = {}
flash_azimuth_range = {}
flash_elevation_range = {}
flash_diffusion = {}
flash_pulse_template = {}
flash_timebase_delay = {}

photodetector_cell_count = {}
sampling_length = {}
sampling_interval = {}

photodetector_cell_extalk = Core.CudaTextureSamplerArray()

photodetector_cell_azimuth_range = {}
photodetector_cell_elevation_range = {}
photodetector_cell_gain = {}
photodetector_cell_baseline = {}
photodetector_cell_static_noise_shift = {}
photodetector_cell_static_noise = {}

static_noise_sample_times = {}
static_noise_sampler_shape_data = {}

multisample_factor = 4
sampling_resolution_x = 0.1
sampling_resolution_y = 0.1
laser_power = 1.0

sampling_frequency = 160000000
base_points = 100
oversampling = 4
total_sampling_length = base_points * oversampling
sampling_interval_ns = 1000000000.0 / (sampling_frequency * oversampling)

local function eval_polynomial(coeffs, x)
    return x * ( x * ( x * coeffs.w + coeffs.z ) + coeffs.y ) + coeffs.x;
end

function configure(self)
    laser_component = self.sensor_model:load_asset("laser_diode_1", "laser_diode_1", "C:\\GitLab\\EchoDS_FLM\\SensorData\\Assets\\laser", "asset.yaml")
    photodetector_array = self.sensor_model:load_asset("photodetector_array_1", "photodetector_array_1", "C:\\GitLab\\EchoDS_FLM\\SensorData\\Assets\\photodetector", "asset.yaml")

    tile = self.sensor_model:create_tile("tile_0", vec2 { 0.0, 0.0 })
    flash_size = { width = 0.135 * 2, height = 3.05 * 2}
    tile_size = { width = 8.4, height = 8.4}

    laser = laser_component:get(Sensor.sLaserAssembly)
    diffusion = laser.diffuser_data:get(Sensor.sDiffusionPattern).interpolator
    flash_extent = vec2(diffusion.spec.scaling[1] / 2, diffusion.spec.scaling[2] / 2)
    pulse_template = laser.waveform_data:get(Sensor.sPulseTemplate).interpolator.device_data

    photodetector = photodetector_array:get(Sensor.sPhotoDetector)
    pd = photodetector.extalk_templates
    for ex=1,#pd do
        photodetector_cell_extalk:append(pd[ex]:get(Sensor.sElectronicCrosstalk).interpolator.device_data)
    end

    for i, tile_position in pairs(tile_positions.array) do
        print("preprocessing tile:", i)
        photodetector_cell_count[i] = Core.U32Array()
        sampling_length[i] = Core.U32Array()
        sampling_interval[i] = Core.F32Array()
        flash_timebase_delay[i] = Core.F32Array()
        flash_pulse_template[i] = Core.CudaTextureSamplerArray()
        flash_diffusion[i] = Core.CudaTextureSamplerArray()
        flash_world_position[i] = { x = Core.F32Array(), y = Core.F32Array() }
        flash_azimuth_range[i] = { min = Core.F32Array(), max = Core.F32Array() }
        flash_elevation_range[i] = { min = Core.F32Array(), max = Core.F32Array() }
        photodetector_cell_azimuth_range[i] = { min = Core.F32Array(), max = Core.F32Array() }
        photodetector_cell_elevation_range[i] = { min = Core.F32Array(), max = Core.F32Array() }
        photodetector_cell_gain[i] = Core.F32Array()
        photodetector_cell_baseline[i] = Core.F32Array()
        photodetector_cell_static_noise_shift[i] = Core.F32Array()
        photodetector_cell_static_noise[i] = Core.CudaTextureSamplerArray()
        static_noise_sample_times[i] = Core.F32Array()

        for j, flash_position in pairs(flash_coordinates.array) do
            world_position = flash_position + tile_position
            flash_range_min = world_position - flash_extent;
            flash_range_max = world_position + flash_extent;

            flash_world_position[i].x:append(world_position.x)
            flash_world_position[i].y:append(world_position.y)

            flash_azimuth_range[i].min:append(flash_range_min.x)
            flash_azimuth_range[i].max:append(flash_range_max.x)

            flash_elevation_range[i].min:append(flash_range_min.y)
            flash_elevation_range[i].max:append(flash_range_max.y)

            flash_diffusion[i]:append(diffusion.device_data)
            flash_pulse_template[i]:append(pulse_template)
            flash_timebase_delay[i]:append(eval_polynomial(laser.timebase_delay, 25.0))

            photodetector_cell_count[i]:append(#photodetector.cell_positions)
            sampling_length[i]:append(total_sampling_length)
            sampling_interval[i]:append( sampling_interval_ns)

            for k=1,total_sampling_length do
                static_noise_sample_times[i]:append(k * sampling_interval_ns)
            end

            for c=1,#photodetector.cell_positions do
                cell_position = vec2(photodetector.cell_positions[c].x, photodetector.cell_positions[c].y) + world_position
                cell_size = vec2(photodetector.cell_positions[c].z, photodetector.cell_positions[c].w)

                cell_world_bound_min = cell_position - cell_size
                cell_world_bound_max = cell_position + cell_size

                photodetector_cell_azimuth_range[i].min:append(cell_world_bound_min.x)
                photodetector_cell_azimuth_range[i].max:append(cell_world_bound_max.x)
                photodetector_cell_elevation_range[i].min:append(cell_world_bound_min.y)
                photodetector_cell_elevation_range[i].max:append(cell_world_bound_max.y)

                photodetector_cell_gain[i]:append(eval_polynomial(photodetector.gain[c], 25.0))
                photodetector_cell_baseline[i]:append(eval_polynomial(photodetector.baseline[c], 25.0))
                photodetector_cell_static_noise_shift[i]:append(eval_polynomial(photodetector.static_noise_shift[c], 25.0))

                photodetector_cell_static_noise[i]:append(photodetector.static_noise[c]:get(Sensor.sStaticNoise).interpolator.device_data)
            end
        end

        static_noise_sampler_shape_data[i] = Core.U32Array()
        for pd_count_id=1,#photodetector_cell_count[i] do
            for z=1,photodetector_cell_count[i][pd_count_id] do
                static_noise_sampler_shape_data[i]:append(total_sampling_length)
            end
        end
    end

    for flash_id = 1, 32 do
        flash_x_position = ((flash_size.width / 2) + (flash_id - 1) * flash_size.width) - (tile_size.width / 2)
        flash_y_position = 0.0
        create_flash(self, tile, vec2(flash_x_position, flash_y_position), vec2(flash_size.width / 2, flash_size.height / 2), laser_component, photodetector_array )
    end
end


local function create_range_node(scope, range_start, range_end, delta)
    start_node = Ops.ScalarVectorValue( scope, Ops.eScalarType.FLOAT32, range_start )
    end_node = Ops.ScalarVectorValue( scope, Ops.eScalarType.FLOAT32, range_end )

    delta_init = Core.F32Array(#range_start, delta)
    delta_node = Ops.ScalarVectorValue( scope, Ops.eScalarType.FLOAT32, delta_init )

    return Ops.ARange( scope, start_node, end_node, delta_node )
end

local function cartesian_product(scope, left, right)
    x_shape = left:get(Ops.sMultiTensorComponent).value:shape()
    y_shape = right:get(Ops.sMultiTensorComponent).value:shape()

    x_repetitions_node = Ops.VectorValue( scope, y_shape:get_dimension(-1) )
    y_repetitions_node = Ops.VectorValue( scope, x_shape:get_dimension(-1) )

    prod_x = Ops.Repeat( scope, left, x_repetitions_node )
    prod_y = Ops.Tile( scope, right, y_repetitions_node )

    return prod_x, prod_y
end


function sample(self, tiles, positions, timestamps)
    local flash_world_position = flash_world_position[1]
    local flash_azimuth_range = flash_azimuth_range[1]
    local flash_elevation_range = flash_elevation_range[1]
    local flash_diffusion = flash_diffusion[1]

    resolution_x = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, sampling_resolution_x )
    azimuth_range_0 = create_range_node( self.computation_scope, flash_azimuth_range.min, flash_azimuth_range.max, sampling_resolution_x )
    azimuth_range_1 = Ops.Add( self.computation_scope, azimuth_range_0, resolution_x );

    resolution_y = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, sampling_resolution_y )
    elevation_range_0 = create_range_node( self.computation_scope, flash_elevation_range.min, flash_elevation_range.max, sampling_resolution_y )
    elevation_range_1 = Ops.Add( self.computation_scope, elevation_range_0, resolution_y )

    elevation_xy_0, azimuth_xy_0 = cartesian_product( self.computation_scope, elevation_range_0, azimuth_range_0 );
    elevation_xy_1, azimuth_xy_1 = cartesian_product( self.computation_scope, elevation_range_1, azimuth_range_1 );

    if  multisample_factor > 1 then
        multisample_repetition_initializer = Core.U32Array(#(flash_world_position.x), multisample_factor)

        multisampling_repetitions_node = Ops.VectorValue( self.computation_scope, multisample_repetition_initializer );
        azimuth_multisampled_xy_0 = Ops.Repeat( self.computation_scope, azimuth_xy_0, multisampling_repetitions_node );
        azimuth_multisampled_xy_1 = Ops.Repeat( self.computation_scope, azimuth_xy_1, multisampling_repetitions_node );
        elevation_multisampled_xy_0 = Ops.Repeat( self.computation_scope, elevation_xy_0, multisampling_repetitions_node );
        elevation_multisampled_xy_1 = Ops.Repeat( self.computation_scope, elevation_xy_1, multisampling_repetitions_node );

        initializer = Ops.sRandomUniformInitializerComponent(Ops.eScalarType.FLOAT32);
        azimuth_sampling_coefficients   = Ops.MultiTensorValue( self.computation_scope, initializer, azimuth_multisampled_xy_0:get(Ops.sMultiTensorComponent).value:shape() );
        elevation_sampling_coefficients = Ops.MultiTensorValue( self.computation_scope, initializer, elevation_multisampled_xy_0:get(Ops.sMultiTensorComponent).value:shape() );

        sampled_azimuths   = Ops.Mix( self.computation_scope, azimuth_multisampled_xy_0, azimuth_multisampled_xy_1, azimuth_sampling_coefficients );
        sampled_elevations = Ops.Mix( self.computation_scope, elevation_multisampled_xy_0, elevation_multisampled_xy_1, elevation_sampling_coefficients );
    else
        initializer = Ops.sConstantValueInitializerComponent(Ops.eScalarType.FLOAT32, 0.5)
        sampling_coefficients = Ops.MultiTensorValue( self.computation_scope, initializer, azimuth_xy_0:get(Ops.sMultiTensorComponent).value:shape() );

        sampled_azimuths = Ops.Mix( self.computation_scope, azimuth_xy_0, azimuth_xy_1, sampling_coefficients );
        sampled_elevations = Ops.Mix( self.computation_scope, elevation_xy_0, elevation_xy_1, sampling_coefficients );
    end

    sampling_shape = sampled_azimuths:get(Ops.sMultiTensorComponent).value:shape();

    flash_id_lut_initializer_values = Core.U32Array(#flash_world_position.x)
    for i = 1,#flash_world_position.x do
        flash_id_lut_initializer_values[i] = i
    end

    flash_id_lut_initialiser = Ops.sVectorInitializerComponent(flash_id_lut_initializer_values)
    flash_id_lut = Ops.MultiTensorValue(self.computation_scope, flash_id_lut_initialiser, sampling_shape );

    timestamp_initializer = Ops.sVectorInitializerComponent(timestamps)
    sampled_timestamps = Ops.MultiTensorValue(self.computation_scope, timestamp_initializer, sampling_shape );

    intensity_initializer = Ops.sConstantValueInitializerComponent(Ops.eScalarType.FLOAT32, laser_power)
    sampled_ray_intensities = Ops.MultiTensorValue(self.computation_scope, intensity_initializer, sampling_shape );

    sampled_azimuths = Ops.Flatten( self.computation_scope, sampled_azimuths );
    sampled_elevations = Ops.Flatten( self.computation_scope, sampled_elevations );
    sampled_ray_intensities = Ops.Flatten(self.computation_scope, sampled_ray_intensities );

    azimuth_offset = Ops.ScalarVectorValue(self.computation_scope, Ops.eScalarType.FLOAT32, flash_world_position.x );
    relative_azimuths = Ops.Subtract( self.computation_scope, sampled_azimuths, azimuth_offset );

    elevation_offset = Ops.ScalarVectorValue(self.computation_scope, Ops.eScalarType.FLOAT32, flash_world_position.y );
    relative_elevations = Ops.Subtract( self.computation_scope, sampled_elevations, elevation_offset );

    reduction_interpolator_node = Ops.VectorValue(self.computation_scope, flash_diffusion );
    diffusion_coefficient = Ops.Sample2D(self.computation_scope, relative_azimuths, relative_elevations, reduction_interpolator_node );

    sampled_ray_intensities = Ops.Multiply( self.computation_scope, sampled_ray_intensities, diffusion_coefficient );

    avg_factor = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, multisample_factor );
    sampled_ray_intensities = Ops.Divide( self.computation_scope, sampled_ray_intensities, avg_factor );

    flash_id_lut = Ops.Flatten(self.computation_scope, flash_id_lut );
    sampled_timestamps = Ops.Flatten( self.computation_scope, sampled_timestamps );

    self.computation_scope:run{ flash_id_lut, sampled_azimuths, sampled_elevations, sampled_ray_intensities, sampled_timestamps }

    return {
        flash_id = flash_id_lut,
        timestamps = sampled_timestamps,
        azimuths = sampled_azimuths,
        elevations = sampled_elevations,
        intensities = sampled_ray_intensities
    }
end


function process_environment_returns(self, ts, tiles, positions, timestamps, azimuth, elevation, intensity, distance)
    local photodetector_cell_count = photodetector_cell_count[1]
    local photodetector_cell_azimuth_range = photodetector_cell_azimuth_range[1]
    local photodetector_cell_elevation_range = photodetector_cell_elevation_range[1]
    local photodetector_cell_gain = photodetector_cell_gain[1]
    local photodetector_cell_baseline = photodetector_cell_baseline[1]
    local photodetector_cell_static_noise_shift = photodetector_cell_static_noise_shift[1]
    local photodetector_cell_static_noise = photodetector_cell_static_noise[1]
    local flash_pulse_template = flash_pulse_template[1]
    local flash_timebase_delay = flash_timebase_delay[1]
    local sampling_length = sampling_length[1]
    local sampling_interval = sampling_interval[1]

    -- Count photodetector cells for every configured flash for this acquisition.
    photodetector_cell_count_node = Ops.VectorValue( self.computation_scope, photodetector_cell_count );

    -- Tile all multitensor to have one copy for every photodetector.
    azimuth_blow_up = Ops.Tile( self.computation_scope, azimuth, photodetector_cell_count_node );
    elevation_blow_up = Ops.Tile( self.computation_scope, elevation, photodetector_cell_count_node );
    intensities_blow_up = Ops.Tile( self.computation_scope, intensity, photodetector_cell_count_node );
    distances_blow_up = Ops.Tile( self.computation_scope, distance, photodetector_cell_count_node );

    -- Collect APD sizes into multi-tensors
    pd_tensor_shape = Cuda.sTensorShape( photodetector_cell_count, Ops.size_of( Ops.eScalarType.FLOAT32 ) );
    photodetector_cell_world_azimuth_min_0 = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( photodetector_cell_azimuth_range.min ), pd_tensor_shape );
    photodetector_cell_world_azimuth_max_0 = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( photodetector_cell_azimuth_range.max ), pd_tensor_shape );
    photodetector_cell_world_elevation_min_0 = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( photodetector_cell_elevation_range.min ), pd_tensor_shape );
    photodetector_cell_world_elevation_max_0 = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( photodetector_cell_elevation_range.max ), pd_tensor_shape );

    -- Dual to the above, the photodetector data needs to be repeated for every detection
    -- for the data to be available. This way the dimensions match.
    detection_count_per_flash = Ops.VectorValue( self.computation_scope, azimuth:get(Ops.sMultiTensorComponent).value:shape():get_dimension( 0 ) );
    photodetector_cell_world_azimuth_min = Ops.Repeat( self.computation_scope, photodetector_cell_world_azimuth_min_0, detection_count_per_flash );
    photodetector_cell_world_azimuth_max = Ops.Repeat( self.computation_scope, photodetector_cell_world_azimuth_max_0, detection_count_per_flash );
    photodetector_cell_world_elevation_min = Ops.Repeat( self.computation_scope, photodetector_cell_world_elevation_min_0, detection_count_per_flash );
    photodetector_cell_world_elevation_max = Ops.Repeat( self.computation_scope, photodetector_cell_world_elevation_max_0, detection_count_per_flash );

    -- Apply the reduction to the detections. This effectively assigns to each photodetector the set of all detections which
    -- contribute to the output of the photodetector. All detections which line up vertically and/or horizontally  with the
    -- photodetector will retain their intensity, whereas all other detections will have their intensity set to 0.
    vertically_aligned_detections   = Ops.InInterval( self.computation_scope, azimuth_blow_up, photodetector_cell_world_azimuth_min, photodetector_cell_world_azimuth_max, false, false );
    horizontally_aligned_detections = Ops.InInterval( self.computation_scope, elevation_blow_up, photodetector_cell_world_elevation_min, photodetector_cell_world_elevation_max, false, false );

    -- Using AND as a combinator effectively eliminates all possibility of optical xtalk in the imaging direction,
    -- whereas using OR as a combinator introduces it. More complicated boolean expressions can be used here in
    -- order to properly tag detections which arise from xtalk.
    photodetector_aligned_detections = Ops.And( self.computation_scope, vertically_aligned_detections, horizontally_aligned_detections );

    zero = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 0.0 );
    reduced_intensities = Ops.Where( self.computation_scope, photodetector_aligned_detections, intensities_blow_up, zero );

    -- Each retection in the input array carries a certain amount of photoelectric energy. This constant converts the energy to a current
    -- contribution to the fonal waveform. After the following two lines, the intensity buffer should be interpreted as current values in
    -- milliamps
    intensity_to_power = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 4.0 ); -- This is arbitrary for now
    reduced_intensities = Ops.Multiply( self.computation_scope, reduced_intensities, intensity_to_power );

    -- Optical XTalk goes here. Detection data which survived the above culling see their intensity further multiplied
    -- by an optical crosstalk kernel. After this step, the intensity value for each detection corresponds to its
    -- contribution to the photodetector.
    --
    --
    --
    --
    --

    -- Collect the effective lengths of the waveforms to sample.
    -- Collect the sampling intervals foir each flash. The oversampling is already taken into account
    base_points_n = Ops.VectorValue( self.computation_scope, sampling_length );
    sampling_interval_n = Ops.VectorValue( self.computation_scope, sampling_interval );

    -- Convert distance to time, in nanoseconds, and add a time offset to account for the delay in firing the laser.
    SPEED_OF_LIGHT_M_NS = 0.299792458;
    timebase_delay = Ops.ScalarVectorValue( self.computation_scope, Ops.eScalarType.FLOAT32, flash_timebase_delay );
    distance_to_time = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 2.0 / SPEED_OF_LIGHT_M_NS );
    detection_times = Ops.AffineTransform( self.computation_scope, distance_to_time, distances_blow_up, timebase_delay );

    -- Sample waveforms.
    pulse_templates = Ops.VectorValue( self.computation_scope, flash_pulse_template );
    waveform_buffer = Sensor.ResolveWaveforms( self.computation_scope, detection_times, reduced_intensities, base_points_n, sampling_interval_n, pulse_templates );
    waveform_scaling = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 1.0 ); -- this is arbitrary
    waveform_buffer = Ops.Multiply( self.computation_scope, waveform_buffer, waveform_scaling );

    -- Electronic crosstalk component. The same detection data used to produce the above waveforms is used
    -- to calculate the electronic crosstalk. The buffer conaining the electronic crosstalk has the same
    -- dimension as the raw waveform buffer, and will simply be added to it at the end of the pipeline
    extalk_waveform_templates = Ops.VectorValue( self.computation_scope, photodetector_cell_extalk );
    extalk_waveform_buffer = Sensor.ResolveElectronicCrosstalkWaveforms( self.computation_scope, detection_times, reduced_intensities, base_points_n, sampling_interval_n, extalk_waveform_templates );
    extalk_strength  = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 0.0 );
    extalk_waveform_buffer = Ops.Multiply( self.computation_scope, extalk_waveform_buffer, extalk_strength );

    -- Apply APD switch offset. The baseline shift is related to the APD electrical switch. When the information is collected
    -- from the database, each configured laser flash gets a copy of the array of baseline shift values.
    baseline_shift = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( photodetector_cell_baseline ), pd_tensor_shape );
    waveform_buffer = Ops.Add( self.computation_scope, waveform_buffer, baseline_shift );

    local flash_count = azimuth:get(Ops.sMultiTensorComponent).value:shape():count_layers()

    -- Static noise
    -- In the acquisition context, the static noise data is represented as a list of samplers and a matching list of time offsets. There
    -- is one such pair per flash per photodetector. We first compute the sample times.
    local static_noise_sample_times_data = static_noise_sample_times[1]
    static_noise_sample_times_tensor_shape = Cuda.sTensorShape( sampling_length, Ops.size_of(  Ops.eScalarType.FLOAT32 ) );
    static_noise_sample_times_0 = Ops.MultiTensorValue( self.computation_scope, Ops.sDataInitializerComponent( static_noise_sample_times_data ), static_noise_sample_times_tensor_shape );
    static_noise_sample_times_n  = Ops.Tile( self.computation_scope, static_noise_sample_times_0, photodetector_cell_count_node );
    static_noise_sample_time_offsets = Ops.ScalarVectorValue( self.computation_scope, Ops.eScalarType.FLOAT32, photodetector_cell_static_noise_shift );

    -- We now reshape the static noise sample times to match with the offset vector and the sampler vector. Operator broadcasting will
    -- make this unnecessary in the future
    local static_noise_sampler_shape_data = static_noise_sampler_shape_data[1]

    static_noise_samples_shape = Cuda.sTensorShape( static_noise_sampler_shape_data, Ops.size_of(  Ops.eScalarType.FLOAT32 ) )
    static_noise_sample_times_per_pd = Ops.Relayout( self.computation_scope, static_noise_sample_times_n, static_noise_samples_shape );
    static_noise_sample_shifted_times = Ops.Add( self.computation_scope, static_noise_sample_times_per_pd, static_noise_sample_time_offsets );

    -- Sample the static noise values from the various samplers. By convention, we use 2D textures to represent linear data, and in such a case
    -- the y coordinate of the sample is set to 0.5f.
    static_noise_samplers = Ops.VectorValue( self.computation_scope, photodetector_cell_static_noise );
    template_y_position = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 0.0 );
    static_noise_values_0 = Ops.Sample2D( self.computation_scope, static_noise_sample_shifted_times, template_y_position, static_noise_samplers );

    -- Multiply the samples static noise values by an amplitude factor.
    static_noise_strength = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 0.0 );
    static_noise_values = Ops.Multiply( self.computation_scope, static_noise_values_0, static_noise_strength );

    -- The static noise values have the correct layout in memory, but the actual shape of the tensor is wrong. We use another relayout
    -- to obtain the correct tensor shape. Note that the original tiles sample times have the correct shape, and that this shape should be
    -- the same as the waveform buffer shape, and we can therefore simply add them together to obtain the final waveform.
    static_noise_values = Ops.Relayout( self.computation_scope, static_noise_values, static_noise_sample_times_n:get(Ops.sMultiTensorComponent).value:shape() );
    waveform_buffer = Ops.Add( self.computation_scope, waveform_buffer, static_noise_values );
    waveform_buffer = Ops.Add( self.computation_scope, waveform_buffer, extalk_waveform_buffer );

    -- Apply ambiant noise to sampled waveforms. We model the ambiand noise with a set of independent identically distributed random
    -- variables in which the mean is the direct current component, and the variance represents the alternating current component. In
    -- this case we assume that the random variables are normally distributed. Note that in order for the accumulation to be taken
    -- into account here, the standard deviation of the noise should be adjusted.
    noise_initializer = Ops.sRandomNormalInitializerComponent(Ops.eScalarType.FLOAT32, 0.0, 0.00000001);
    ambient_noise = Ops.MultiTensorValue( self.computation_scope, noise_initializer, waveform_buffer:get(Ops.sMultiTensorComponent).value:shape() );
    noisy_waveform_buffer = Ops.Add( self.computation_scope, waveform_buffer, ambient_noise );

    -- Saturation. All samples whose values after transformation lie outside a configured interval are clamped to that interval.
    -- Possiible future optimisation: create a clamping operator using CUDA's clamp function.
    saturation_value_min = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, -1.0 );
    saturation_value_max = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 1.0 );
    is_saturated_up = Ops.GreaterThan( self.computation_scope, noisy_waveform_buffer, saturation_value_max );
    is_saturated_down = Ops.LessThan( self.computation_scope, noisy_waveform_buffer, saturation_value_min );
    noisy_waveform_buffer = Ops.Where( self.computation_scope, is_saturated_up, saturation_value_max, noisy_waveform_buffer );
    noisy_waveform_buffer = Ops.Where( self.computation_scope, is_saturated_down, saturation_value_min, noisy_waveform_buffer );

    -- Quantization. The output of the previous steps in the pipeline is purposely scaled to lie in the interval [-1, 1], so that conversion
    -- into ADC counts simply requires a multiplication
    adc_scaling = Ops.ConstantScalarValue( self.computation_scope, Ops.eScalarType.FLOAT32, 8191.0 );
    adc_output = Ops.Multiply( self.computation_scope, noisy_waveform_buffer, adc_scaling );

    self.computation_scope:run( adc_output );
    return adc_output
end
