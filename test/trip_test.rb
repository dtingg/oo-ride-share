require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 54, 
          name: "Test Driver", 
          vin: "12345678901234567", 
          status: :AVAILABLE
        ),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3 
      }
      @trip = RideShare::Trip.new(@trip_data)
    end
    
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end
    
    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end
    
    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
    
    it "throws an error if start time is after end time" do
      @trip_data = {
        id: 8,
        driver_id: 2, 
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: Time.parse("May 5, 2015"),
        end_time: Time.parse("May 4, 2015"),
        cost: 23.45,
        rating: 3 
      }
      expect{ RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end
    
    it "doesn't throw an error if end time is nil" do
      @trip_data = {
        id: 8,
        driver_id: 2, 
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: Time.parse("May 5, 2015"),
        end_time: nil,
        cost: 23.45,
        rating: 3 
      }
      assert_nil(RideShare::Trip.new(@trip_data).end_time)
    end
  end
  
  describe "duration method" do 
    it "returns the duration of the trip in seconds" do
      @trip_data = {      
        id: 8,
        driver_id: 2, 
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: Time.parse('May 5, 2015, 12:15 PM'),
        end_time: Time.parse('May 5, 2015, 12:30 PM'),
        cost: 23.45,
        rating: 3 
      }
      @trip = RideShare::Trip.new(@trip_data)
      
      expect(@trip.duration).must_equal 900.0
    end
    
    it "returns nil for duration if the trip hasn't finished" do
      @trip_data = {      
        id: 8,
        driver_id: 2, 
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: Time.parse('May 5, 2015'),
        end_time: nil,
        cost: 23.45,
        rating: 3 
      }
      @trip = RideShare::Trip.new(@trip_data)
      
      assert_nil(@trip.duration)
    end
  end
end
