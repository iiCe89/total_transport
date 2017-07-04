class RoutesController < ApplicationController
  def index
    @page_title = "Choose Your Route"
    @routes = Route.bookable_routes
  end
end
