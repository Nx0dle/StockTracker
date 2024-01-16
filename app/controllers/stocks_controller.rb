# frozen_string_literal: true

class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.twelve_data_new_lookup(params[:stock])
      if @stock
        if turbo_frame_request? && turbo_frame_request_id == 'api-res'
          render partial: 'users/result'
        end
      else
        if turbo_frame_request? && turbo_frame_request_id == 'api-res'
          flash.now[:alert] = "#{params[:stock]} is not a valid symbol."
          render partial: 'users/result'
        end
      end
    else
      if turbo_frame_request? && turbo_frame_request_id == 'api-res'
        flash.now[:alert] = "Please enter a symbol to search"
        render partial: 'users/result'
      end
    end
  end
end
