require 'csv'
require "time"

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :driver, :driver_id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating
    
    def initialize(id:, driver: nil, driver_id: nil, passenger: nil, passenger_id: nil, 
      start_time:, end_time: nil, cost: nil, rating: nil)
      super(id)
      
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or Driver ID is required.'
      end
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, 'Passenger or Passenger ID is required.'
      end
      
      if end_time && (start_time > end_time)
        raise ArgumentError, "Start time cannot be after end time."
      end
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      
      if rating && (rating > 5 || rating < 1)
        raise ArgumentError.new("Invalid rating: #{@rating}")
      end
    end
    
    def duration
      if !end_time
        return nil
      else
        return end_time - start_time
      end
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        driver_id: record[:driver_id],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time]),
        end_time: Time.parse(record[:end_time]),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
