module Nest
  class Status
    def initialize(response, user_id)
      @response =     response
      @structure_id = response['user'][user_id]['structures'][0].split('.')[1]
      @device_id =    response['structure'][structure_id]['devices'][0].split('.')[1]
    end

    def current_temperature
      response['shared'][device_id]['current_temperature']
    end

    def target_temperature
      response['shared'][device_id]['target_temperature']
    end

    def target_temperature_low
      response['shared'][device_id]['target_temperature_low']
    end

    def target_temperature_high
      response['shared'][device_id]['target_temperature_high']
    end

    def target_temperature_at
      response['device'][device_id]['time_to_target']
    end

    def humidity
      response['device'][device_id]['current_humidity']
    end

    def away?
      response['structure'][structure_id]['away']
    end

    def leaf?
      response['device'][device_id]['leaf']
    end

    def hot_water_active?
      response['device'][device_id]['hot_water_active']
    end

    private

    attr_reader :response, :structure_id, :device_id
  end
end
