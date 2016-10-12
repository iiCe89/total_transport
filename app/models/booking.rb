class Booking < ActiveRecord::Base
  belongs_to :journey
  belongs_to :return_journey, class_name: 'Journey'
  belongs_to :pickup_stop, class_name: 'Stop'
  belongs_to :dropoff_stop, class_name: 'Stop'
  belongs_to :passenger
  belongs_to :payment_method

  scope :booked, -> {where("journey_id IS NOT NULL AND pickup_stop_id IS NOT NULL AND dropoff_stop_id IS NOT NULL AND payment_method_id IS NOT NULL")}

  def route
    journey.route
  end

  def past?
    pickup_stop.time_for_journey(journey) < Time.now
  end

  def future?
    !past?
  end

  def price_distance
    @price_distance ||= pickup_stop.distance_to(dropoff_stop)
  end

  def reversed?
    pickup_stop.position > dropoff_stop.position
  end

  def price
    if return_journey?
      return_price
    else
      single_price
    end
  end

  def single_price
    if price_distance < 2
      2.5
    elsif price_distance >= 2 && price_distance <= 5
      4.5
    elsif price_distance > 5
      5.5
    end
  end

  def return_price
    if price_distance < 2
      3.5
    elsif price_distance >= 2 && price_distance <= 5
      6.5
    elsif price_distance > 5
      8
    end
  end

  def return_journey?
    !!return_journey
  end

  def send_notification!(message)
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: TWILIO_PHONE_NUMBER,
      to: self.phone_number,
      body: message
    )
  end
end
