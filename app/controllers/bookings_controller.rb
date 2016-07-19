class BookingsController < ApplicationController
  before_filter :find_route
  before_filter :find_booking, except: [:new, :create]

  # Choose stops
  def new
    @booking = Booking.new
    render template: 'bookings/choose_stops'
  end

  # Save stops
  def create
    @booking = Booking.create(booking_params)
    redirect_to choose_journey_route_booking_path(@route, @booking)
  end

  # Choose journey
  def choose_journey
  end

  def save_journey
    @booking.update_attributes(booking_params)
    redirect_to choose_pickup_location_route_booking_path(@route, @booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:journey_id, :pickup_stop_id, :pickup_lat, :pickup_lng, :dropoff_stop_id, :dropoff_lat, :dropoff_lng, :state)
  end

  def find_route
    @route = Route.find(params[:route_id])
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
