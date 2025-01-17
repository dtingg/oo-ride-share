require_relative 'test_helper'

describe "Passenger class" do
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        cost: 5,
        rating: 5
      )
      trip2 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse("2016-08-02"),
        end_time: Time.parse("2016-08-09"),
        cost: 10,
        rating: 5
      )
      @passenger.add_trip(trip1) 
      @passenger.add_trip(trip2)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end
  
  describe "passenger methods" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:15:00+00:00'),
        end_time: Time.parse('2015-05-20T12:20:00+00:00'),
        cost: 5,
        rating: 5
      )
      trip2 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:10:00+00:00'),
        end_time: Time.parse('2015-05-20T12:13:00+00:00'),
        cost: 10,
        rating: 5
      )
      @passenger.add_trip(trip1) 
      @passenger.add_trip(trip2)
    end
    
    it "should return total cost of all trips" do
      expect(@passenger.net_expenditures).must_equal 15
    end
    
    it "should return 0 cost if passenger has no trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      
      expect(@passenger.net_expenditures).must_equal 0
    end
    
    it "should return 0 cost if passenger has one in progress trip" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip3 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:10:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      
      expect(@passenger.net_expenditures).must_equal 0
    end
    
    it "should return total cost of all trips and skip in progress trips" do
      trip3 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:10:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      
      expect(@passenger.net_expenditures).must_equal 15
    end
    
    it "should return duration of all trips" do 
      expect(@passenger.total_time_spent).must_equal 480.0
    end
    
    it "should return 0 duration if passenger has no trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      
      expect(@passenger.total_time_spent).must_equal 0
    end
    
    it "should return 0 duration if passenger has one in progress trip" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip3 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:10:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      
      expect(@passenger.total_time_spent).must_equal 0
    end
    
    it "should return the correct total duration if there is an in progress trip" do      
      trip3 = RideShare::Trip.new(
        id: 6,
        driver: @driver, 
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:10:00+00:00'),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      
      expect(@passenger.total_time_spent).must_equal 480.0
    end
  end
end
