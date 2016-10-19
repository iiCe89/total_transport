module ApplicationHelper
  def friendly_date(date, length=false)
    if date == Date.today
      "Today"
    elsif date == Date.tomorrow
      "Tomorrow"
    elsif (date > Date.today.beginning_of_year) && (date < Date.today.end_of_year)
      if length
        date.strftime("%a, %-d %B")
      else
        date.strftime("%A, %-d %B")
      end
      
    else  
      if length
        date.strftime("%a, %-d %B, %Y")
      else
        date.strftime("%A, %-d %B, %Y")
      end
    end
  end

  def payment_class(payment_method_type)
    payment_method_type = payment_method_type.to_s
    if payment_method_type == 'paypal'
      'fa-paypal'
    elsif payment_method_type == 'apple_pay'
      'fa-apple'
    elsif payment_method_type == 'credit_card'
      'fa-credit-card-alt'
    elsif payment_method_type == 'google_pay'
      'fa-google-wallet'
    elsif payment_method_type == 'cash'
      'fa-money'
    end
  end

  def num_of_adults(num_of_passengers)
    num_of_adults = num_of_passengers - @booking.child_tickets - @booking.older_bus_passes - @booking.disabled_bus_passes - @booking.scholar_bus_passes
  end
end
