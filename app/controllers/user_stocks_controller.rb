class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.iex_new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was added to your portfolio"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    UserStock.where(stock: stock, user: current_user.id).first.destroy
    flash[:notice] = "#{stock.ticker} tracking removed"
    redirect_to my_portfolio_path
  end
end
