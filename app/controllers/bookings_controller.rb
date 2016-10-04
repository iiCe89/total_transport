class BookingsController < ApplicationController
  before_filter :find_route
  before_filter :find_booking, except: [:new, :create]

  # Choose stops
  def new
    @page_title = "Choose Your Pick Up Area"
    @top_sec = "Choose your pick up and drop off areas."
    @booking = current_passenger.bookings.new
    render template: 'bookings/choose_stops'
  end

  # Save stops
  def create
    @booking = current_passenger.bookings.create(booking_params)
    redirect_to choose_journey_route_booking_path(@route, @booking)
  end

  def choose_journey
    @page_title = "Pick Your Time"
    @top_sec = "All times listed are estimates and may change based on who else schedules a ride."
  end

  def save_journey
    @booking.update_attributes(booking_params)
    redirect_to choose_pickup_location_route_booking_path(@route, @booking)
  end

  def choose_pickup_location
    @page_title = "Choose Pick Up Point"
    @stop = @booking.pickup_stop
    @pickup_of_dropoff = 'pickup'
    render template: 'bookings/choose_pickup_dropoff_location'
  end

  def save_pickup_location
    @booking.update_attributes(booking_params)
    redirect_to choose_dropoff_location_route_booking_path(@route, @booking)
  end

  def choose_dropoff_location
    @page_title = "Choose Drop Off Point"
    @stop = @booking.dropoff_stop
    @pickup_of_dropoff = 'dropoff'
    render template: 'bookings/choose_pickup_dropoff_location'
  end

  def save_dropoff_location
    @booking.update_attributes(booking_params)
    if current_passenger.payment_methods.any?
      redirect_to choose_payment_method_route_booking_path(@route, @booking)
    else
      redirect_to add_payment_method_route_booking_path(@route, @booking)
    end
  end

  def choose_payment_method
    @page_title = "Choose Your Payment Method"
  end

  def save_payment_method
    if params[:booking][:payment_method_id] == 'new'
      redirect_to add_payment_method_route_booking_path(@route, @booking)
    else
      @booking.update_attributes(booking_params)
      redirect_to confirm_route_booking_path(@route, @booking)
    end
  end

  def add_payment_method
    @page_title = "New Payment Method"
    @payment_method = current_passenger.payment_methods.new
  end

  def create_payment_method
    @payment_method = current_passenger.payment_methods.create!(payment_method_params)
    @booking.update_attribute(:payment_method, @payment_method)
    redirect_to confirm_route_booking_path(@route, @booking)
  end

  def confirm
    @page_title = "Confirm Your Booking"
  end

  def save_confirm
    @booking.update_attributes(booking_params)
    redirect_to confirmation_route_booking_path(@route, @booking)
  end

  def confirmation
  end

  def destroy
    @booking.destroy
    redirect_to passenger_path
  end

  def suggest_journey
    @page_title = "Suggest A New Time"
    if request.method == 'POST'
      @suggested_journey = SuggestedJourney.create!(suggested_journey_params)
      redirect_to choose_journey_route_booking_path(@route, @booking)
    else
      @suggested_journey = SuggestedJourney.new
    end
  end

  def suggest_edit_to_stop
    @page_title = "Suggest A Stop Area Edit"
    @stop = Stop.find(params[:stop_id])
    if request.method == 'POST'
      @suggested_edit_to_stop = SuggestedEditToStop.create!(suggested_edit_to_stop_params)
      redirect_to choose_pickup_location_route_booking_path(@route, @booking)
    else
      @suggested_edit_to_stop = SuggestedEditToStop.new
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:journey_id, :pickup_stop_id, :pickup_lat, :pickup_lng, :dropoff_stop_id, :dropoff_lat, :dropoff_lng, :state, :phone_number, :payment_method_id)
  end

  def payment_method_params
    params.require(:payment_method).permit(:name)
  end

  def suggested_journey_params
    params.require(:suggested_journey).permit(:start_time, :description).merge(route: @route, passenger: current_passenger)
  end

  def suggested_edit_to_stop_params
    params.require(:suggested_edit_to_stop).permit(:description).merge(stop: @stop, passenger: current_passenger)
  end

  def find_route
    @route = Route.find(params[:route_id])
  end

  def find_booking
    @booking = current_passenger.bookings.find(params[:id])
  end
end
