require_relative 'spec_helper'
require 'pry'

describe "Hotel Manager class" do

  describe 'Hotel Manager instantiation' do
    before do
      @hotel = Hotel::Booking_Manager.new
    end

    it 'has an array of all rooms in hotel' do
      expect(@hotel.rooms).must_be_kind_of Array
    end

    it 'has 20 rooms in the hotel' do
      expect(@hotel.rooms.length).must_equal 20
    end

    it 'each index of the array is an instance of class' do
      expect(@hotel.rooms[0]).must_be_kind_of Hotel::Room
      # binding.pry
    end
  end

  describe 'get_room method' do
    before do
      @hotel = Hotel::Booking_Manager.new
    end

    it 'returns an Array of rooms in hotel' do
      expect(@hotel.get_rooms).must_be_kind_of Array
      # binding.pry
    end
  end

  describe 'find_room_number method' do
    before do
      @hotel = Hotel::Booking_Manager.new
    end

    it 'returns an instance of Room' do
      expect(@hotel.find_room_number(1)).must_be_kind_of Hotel::Room
      expect(@hotel.find_room_number(20)).must_be_kind_of Hotel::Room
      # binding.pry
    end

    it 'must be a valid room number 1-20' do
      VALID_ROOM_NUMBERS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
      @hotel.rooms.each do |room|
        expect(VALID_ROOM_NUMBERS.include?(room.room_number)).must_equal true
      end
    end
  end

  describe 'reserve_room method' do
    before do
      @hotel = Hotel::Booking_Manager.new
      @input = { name: "Dr. Frankenstein",
        room_number: 6,
        check_in_date: Date.new(2018, 6, 6),
        check_out_date: Date.new(2018, 6, 9)
      }
    end

    it 'adds a reservation to the array of all reservations' do
      @hotel.reserve_room(@input)
      expect(@hotel.hotel_reservations[0].name).must_equal "Dr. Frankenstein"
    end
  end

  describe 'list_reservations method' do
    before do
      @hotel = Hotel::Booking_Manager.new
      @date = Date.new(2018, 6, 8)
      @input1 = { name: "Dr. Frankenstein",
        room_number: 6,
        check_in_date: Date.new(2018, 6, 6),
        check_out_date: Date.new(2018, 6, 9)
      }
      @input2 = { name: "Mx. Mummy",
        room_number: 3,
        check_in_date: Date.new(2018, 6, 6),
        check_out_date: Date.new(2018, 6, 12)
      }
      @hotel.reserve_room(@input1)
      @hotel.reserve_room(@input2)
      @names = ["Dr. Frankenstein", "Mx. Mummy"]
    end

    it 'returns an array of all reservations for that date' do

      expect(@hotel.list_reservations(@date)).must_be_kind_of Array

      @hotel.list_reservations(@date).each do |reservation|
        expect(@names.include?(reservation.name)).must_equal true
      end
    end
  end

  describe 'total_cost_of_stay method' do
    before do
      @hotel = Hotel::Booking_Manager.new
      @input = {name:"Dr. Frankenstein", room_number: 6,check_in_date: Date.new(2018, 6, 6), check_out_date: Date.new(2018, 6, 9)}
      @reservation = Hotel::Reservation.new(@input)
    end

    it 'correctly sums the cost of a stay at the hotel' do
      expect(@hotel.total_cost_of_stay(@reservation)).must_equal 600
    end
  end

  describe 'connect_reservation_to_room' do

    it 'finds the room being reserved and adds the reservation to its list of reservations' do
      @hotel = Hotel::Booking_Manager.new
      @input = { name: "Mx Thing",
        room_number: 1,
        check_in_date: Date.new(2020,9,9),
        check_out_date: Date.new(2020,9,13),
      }
      @hotel.reserve_room(@input)
      expect(@hotel.rooms[0].reservations[0].name).must_equal "Mx Thing"

    end
  end

  describe 'search_room_availability' do

    before do
      @hotel = Hotel::Booking_Manager.new
      #TEST RANGE
      @date1 = Date.new(2020,9,9)
      @date2 = Date.new(2020,9,13)
      #INSIDE TEST RANGE
      @date3 = Date.new(2020,9,10)
      @date4 = Date.new(2020,9,12)
      #OUTSIDE TEST RANGE
      @date5 = Date.new(2020,9,4)
      @date6 = Date.new(2020,9,16)

      @input = { name: "Mx Thing",
        room_number: 1,
        check_in_date: @date1,
        check_out_date: @date2,
      }
      @input2 = { name: "Teen Wolf",
        room_number: 2,
        check_in_date: @date1,
        check_out_date: @date2,
      }
      @input3 = { name: "Señor Dracula",
        room_number: 3,
        check_in_date: @date1,
        check_out_date: @date2,
      }
      @hotel.reserve_room(@input2)
      @hotel.reserve_room(@input3)
      @hotel.reserve_room(@input)
      @available_rooms = [4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
      @all_rooms_available = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    end

    it 'given a range of dates, it returns a list of available rooms, if the reservation shares the same dates as a reserved room' do
      expect(@hotel.search_room_availability(@date1, @date2)).must_equal @available_rooms
    end

    it 'it returns a list of available rooms, leaving rooms out if the reservation check in date is in the middle dates of a reserved room'do
      expect(expect(@hotel.search_room_availability(@date3, @date4)).must_equal @available_rooms)
    end
    it 'it returns a list of available rooms, leaving rooms out if the reservation check in date is in the middle dates of a reserved room'do
          expect(expect(@hotel.search_room_availability(@date3, @date6)).must_equal @available_rooms)
    end
    it 'it returns a list of available rooms, leaving rooms out if the check out date is in the middle dates of a reserved room'do
    expect(expect(@hotel.search_room_availability(@date5, @date4)).must_equal @available_rooms)
  end
    it 'it returns a list of available rooms, leaving rooms out if the reservation check in date and check out date is in the middle dates of a reserved room'do
        expect(expect(@hotel.search_room_availability(@date3, @date4)).must_equal @available_rooms)
    end
    it 'it returns a list of available rooms, leaving rooms out if the reservation check in date is in the middle dates of a reserved room'do
        expect(expect(@hotel.search_room_availability(@date3, @date6)).must_equal @available_rooms)
    end
    it 'it returns a list of available rooms, leaving rooms out if the dates of a reserved room fall within a proposed check in date or check out date'do
        expect(expect(@hotel.search_room_availability(@date5, @date6)).must_equal @available_rooms)
    end
    it 'it returns a list of available rooms, returning rooms where the  reservation check in date is on the check out day of another reservation'do
        expect(expect(@hotel.search_room_availability(@date2, @date6)).must_equal @all_rooms_available)
    end
    it 'it returns a list of available rooms, returning rooms where the  reservation check out date is on the check in day of another reservation'do
        expect(expect(@hotel.search_room_availability(@date5, @date1)).must_equal @all_rooms_available)
    end
  end

  describe 'sort_reservations' do

    it 'finds the room being reserved and adds the reservation to its list of reservations' do
      @hotel = Hotel::Booking_Manager.new
      @input = { name: "Mx Thing",
        room_number: 1,
        check_in_date: Date.new(2020,9,9),
        check_out_date: Date.new(2020,9,13),
      }
      @hotel.reserve_room(@input)
      @input2 = { name: "Teen Wolf",
        room_number: 1,
        check_in_date: Date.new(2016,7,9),
        check_out_date: Date.new(2016,7,13),
      }
      @hotel.reserve_room(@input2)
      @input3 = { name: "Señor Dracula",
        room_number: 1,
        check_in_date: Date.new(2018,7,9),
        check_out_date: Date.new(2018,7,13),
      }
      @hotel.reserve_room(@input3)

      @hotel.sort_reservations(@hotel.hotel_reservations)

      expect(@hotel.hotel_reservations.first.name).must_equal "Teen Wolf"
      expect(@hotel.hotel_reservations.last.name).must_equal "Mx Thing"
    end
  end




end
