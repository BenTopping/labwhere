# frozen_string_literal: true

require "rails_helper"

RSpec.describe Permissions::ScientistPermission, type: :model do
  let(:sci_swipe_card_id) { generate(:swipe_card_id) }
  let(:scientist) { create(:scientist, swipe_card_id: sci_swipe_card_id) }
  let(:permissions) { Permissions.permission_for(scientist) }

  it "should allow access to create a scan" do
    expect(permissions).to allow_permission(:scans, :create)
  end

  it "should allow access to move a location" do
    unprotected_location = create(:location, protect: false)
    params = ActionController::Parameters.new(controller: "move_locations", action: "create",
                                              user: { user_code: sci_swipe_card_id },
                                              move_location_form: { child_location_barcodes: unprotected_location.barcode, parent_location_barcodes: '1234'
    })
    move_location_form = MoveLocationForm.new
    move_location_form.assign_params(params)
    move_location_form.assign_attributes

    expect(permissions).to allow_permission(:move_locations, :create, move_location_form)
  end

  it "should not be allowed to move a protected location" do
    protected_location = create(:location, protect: true)
    params = ActionController::Parameters.new(controller: "move_locations", action: "create",
                                              user: { user_code: sci_swipe_card_id },
                                              move_location_form: { child_location_barcodes: protected_location.barcode, parent_location_barcodes: '1234'
    })
    move_location_form = MoveLocationForm.new
    move_location_form.assign_params(params)
    move_location_form.assign_attributes

    expect(permissions).to_not allow_permission(:move_locations, :create, move_location_form)
  end

  it "should allow access to empty a location" do
    expect(permissions).to allow_permission(:empty_locations, :create)
  end

  it "should allow access to create a scan through the api" do
    expect(permissions).to allow_permission("api/scans", :create)
  end

  it "should allow access to update a coordinate" do
    expect(permissions).to allow_permission("api/locations/coordinates", :update)
  end

  it "should allow access to bulk update coordinates" do
    expect(permissions).to allow_permission("api/coordinates", :update)
  end

  it "should allow access to upload a labware file" do
    expect(permissions).to allow_permission(:upload_labware, :create)
  end

  it "should not allow access to create or modify a location" do
    expect(permissions).to_not allow_permission(:locations, :create)
    expect(permissions).to_not allow_permission(:locations, :update)
  end

  it "should not allow access to create or modify a location type" do
    expect(permissions).to_not allow_permission(:location_types, :create)
    expect(permissions).to_not allow_permission(:location_types, :update)
  end

  it "should allow access to modify their own user" do
    params = ActionController::Parameters.new(controller: "users", action: "update", user: { user_code: sci_swipe_card_id })
    scientist_form = UserForm.new(scientist)
    scientist_form.assign_attributes(params)

    expect(permissions).to allow_permission(:users, :update, scientist_form)
  end

  it "should not allow access to create or modify a user" do
    expect(permissions).to_not allow_permission(:users, :create)
    expect(permissions).to_not allow_permission(:users, :update)
  end

  it "should not allow access to create or modify a team" do
    expect(permissions).to_not allow_permission(:teams, :create)
    expect(permissions).to_not allow_permission(:teams, :update)
  end
end
