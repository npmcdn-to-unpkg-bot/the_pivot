class CartItemsController < ApplicationController

  def create
    if params[:supply_item]
      supply_item = SupplyItem.find(params[:supply_item][:id].to_i)
      @cart.add_cart_item(supply_item, params[:supply_item][:quantity])
      session[:cart] = @cart.contents
      flash[:success] = "You added #{supply_item.name}"
      redirect_to family_path(supply_item.family)
    else
      loan = Loan.find(params[:loan][:id].to_i)
      @cart.add_cart_item(loan, params[:loan][:requested_amount])
      session[:cart] = @cart.contents
      flash[:success] = "You added #{loan.purpose} loan to your cart"
      redirect_to family_path(loan.family)
    end
  end

  def update
    if params[:supply_item]
      supply_item = SupplyItem.find(params[:supply_item][:id].to_i)
      @cart.change_cart_item_quantity(supply_item, params[:supply_item][:quantity])
    else
      loan = Loan.find(params[:loan][:id].to_i)
      @cart.change_cart_item_quantity(loan, params[:loan][:quantity])
    end
    session[:cart] = @cart.contents
    redirect_to cart_index_path
  end

  def destroy
    @cart.delete_cart_item(params[:id])
    session[:cart] = @cart.contents
    supply_name = SupplyItem.find(params[:id]).supply.name
    family = SupplyItem.find_family(params[:id])
    flash[:success] = "Successfully deleted #{view_context.link_to(supply_name, family_path(family))} from your cart."
    redirect_to cart_index_path
  end
end
