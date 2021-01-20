# frozen_string_literal: true

##
# Permissions for a Technician
# TODO: check below
# Allowed to:
# check printers???
module Permissions
  class TechnicianPermission < BasePermission
    def initialize(user)
      super
      allow :scans, [:create]
      # TODO: check if api is needed and by what
      allow "api/scans", [:create]
      allow "api/coordinates", [:update]
      allow "api/locations/coordinates", [:update]
      allow :move_locations, [:create]
      allow :empty_locations, [:create]
      allow :upload_labware, [:create]
    end
  end
end
