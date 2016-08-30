FactoryGirl.define do
  factory(:booking) do
    dropoff_lat nil
    dropoff_lng nil
    dropoff_stop
    journey
    passenger
    payment_method
    phone_number nil
    pickup_lat nil
    pickup_lng nil
    pickup_stop
    state nil
  end
end