class BookingsController < ApplicationController
  before_filter :find_route
  before_filter :find_booking, except: [:new, :create]

  # Choose stops
  def new
    @booking = current_passenger.bookings.new
    render template: 'bookings/choose_stops'
  end

  # Save stops
  def create
    @booking = current_passenger.bookings.create(booking_params)
    redirect_to choose_journey_route_booking_path(@route, @booking)
  end

  def choose_journey
  end

  def save_journey
    @booking.update_attributes(booking_params)
    redirect_to choose_pickup_location_route_booking_path(@route, @booking)
  end

  def choose_pickup_location
    @stop = @booking.pickup_stop
    @pickup_of_dropoff = 'pickup'
    render template: 'bookings/choose_pickup_dropoff_location'
  end

  def save_pickup_location
    @booking.update_attributes(booking_params)
    redirect_to choose_dropoff_location_route_booking_path(@route, @booking)
  end

  def choose_dropoff_location
    @stop = @booking.dropoff_stop
    @pickup_of_dropoff = 'dropoff'
    render template: 'bookings/choose_pickup_dropoff_location'
  end

  def save_dropoff_location
    @booking.update_attributes(booking_params)
    redirect_to confirm_route_booking_path(@route, @booking)
  end

  def confirm
    @token = Braintree::ClientToken.generate
  end

  def save_confirm
    if params[:payment_nonce]
      result = Braintree::Customer.create(
        :id => current_passenger.id,
        :first_name => current_passenger.name,
        :payment_method_nonce => params[:payment_nonce]
      )
      if result.success?
        current_passenger.braintree_id = result.customer.id
        current_passenger.braintree_token = result.customer.payment_methods[0].token
        current_passenger.save!
      else
        raise result
      end
    end

    result = Braintree::Transaction.sale(
      :amount => "1.00",
      :customer_id => current_passenger.id,
      :options => {
        :submit_for_settlement => true
      },
      :device_data => params[:device_data]
    )
    if result.success?
      @booking.update_attributes(booking_params)
      redirect_to confirmation_route_booking_path(@route, @booking)
    else
      raise result
    end
  end

  def confirmation
  end

  def destroy
    @booking.destroy
    redirect_to passenger_path
  end

  def suggest_journey
    if request.method == 'POST'
      @suggested_journey = SuggestedJourney.create!(suggested_journey_params)
      redirect_to choose_journey_route_booking_path(@route, @booking)
    else
      @suggested_journey = SuggestedJourney.new
    end
  end

  def suggest_edit_to_stop
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
    params.require(:booking).permit(:journey_id, :pickup_stop_id, :pickup_lat, :pickup_lng, :dropoff_stop_id, :dropoff_lat, :dropoff_lng, :state, :phone_number)
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
