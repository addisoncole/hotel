require_relative 'spec_helper'

describe "Room class" do

  describe "Room instantiation" do
    before do
      @room = Hotel::Room.new(1)
    end

    it "is an instance of Room" do
      expect(@room).must_be_kind_of Hotel::Room
    end

    it "can return a room number" do
      expect(@room.room_number).must_equal 1
    end

    it "returns an array of reservations" do
      expect(@room.reservations).must_be_kind_of Array
    end

    it "has a cost associated with it" do
      expect(@room.room_cost).must_equal 200.0
      expect(@room.room_cost).must_be_kind_of Float
    end

  end
end
