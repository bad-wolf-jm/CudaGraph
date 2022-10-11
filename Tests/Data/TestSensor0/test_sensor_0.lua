-- local Core = require("LTSE.Core")

local vec2 = Math.vec2

local function create_flash(self, tile, position, extent, laser, photodetector)
    flash = self.sensor_model:create_flash(tile, "", position, extent)
    flash:adjoin(Sensor.sLaserAssembly, laser)
    flash:adjoin(Sensor.sPhotoDetector, photodetector)
    return flash
end

function configure(self)
    laser_component = self.sensor_model:load_asset("laser_diode_1", "laser_diode_1", "C:\\GitLab\\LTSimulationEngine\\Tests\\Data\\TestSensor0\\laser", "asset.yaml")
    photodetector_array = self.sensor_model:load_asset("photodetector_array_1", "photodetector_array_1", "C:\\GitLab\\LTSimulationEngine\\Tests\\Data\\TestSensor0\\photodetector", "component.yaml")

    tile_0 = self.sensor_model:create_tile("tile_0", vec2 { 0.0, 0.0 })
    create_flash(self, tile_0, vec2 { -16, 0 }, vec2 { 12, 34 }, laser_component, photodetector_array)

    tile_1 = self.sensor_model:create_tile("tile_1", Math.vec2 { 0.0, 0.0 })
    create_flash(self, tile_1, vec2 { -16, 0 }, vec2 { 12, 34 }, laser_component, photodetector_array)
    create_flash(self, tile_1, vec2 { -15, 0 }, vec2 { 2.5, 16 }, laser_component, photodetector_array)
end

function sample(self, acquisition_info, sampler_info, tiles, positions, timestamps)
    context = Sensor.AcquisitionContext(acquisition_info, tiles, positions, timestamps)
    sampler = Sensor.EnvironmentSampler(sampler_info, self.computation_scope, context)
    sampler:run()

    return sampler
end

function process_environment_returns(self, ts, context, scope, azimuth, elevation, intensity, distance)
    return {}
end