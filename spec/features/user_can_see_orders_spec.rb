require 'rails_helper'

RSpec.feature "user can see all orders" do
  scenario "authenticated user sees list of only her orders" do

    user = User.create(username: "test", password: "password")
    other_user = User.create(username: "other", password: "password")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return( user )

    nationality = Nationality.create(photo_path: "http://www.criticalthreats.org/sites/default/files/AEI_Somalia_Map_Political.gif" ,info_link: "Somali", greeting: "most-critical", name: "Somali")

    family = Family.create(first_name: "TestFirst", last_name: "TestLast", arrival_date: 10.days.from_now, donation_deadline: 5.days.from_now, nationality: nationality, num_married_adults: 2, num_unmarried_adults: 1, num_children_over_two: 0, num_children_under_two: 0)


    supply = Supply.create(name: "Small Pot", value: 3.0, description: "New or used.", multiplier_type: "household")
    other_supply = Supply.create(name: "Large Pot", value: 3.0, description: "New or used.", multiplier_type: "household")

    supply_item = SupplyItem.create(supply: supply, quantity: 1, family: family)
    other_supply_item = SupplyItem.create(supply: other_supply, quantity: 1, family: family)

    order = Order.create(status: 'pledged', user: user)
    other_order = Order.create(status: 'pledged', user: other_user)

    order_item = OrderItem.create(quantity: 1, supply_item: supply_item, order: order)
    other_order_item = OrderItem.create(quantity: 1, supply_item: other_supply_item, order: other_order)

    visit orders_path

  save_and_open_page

    expect(page).to have_content("#{user.username}'s Orders")
    expect(page).to have_content("Total Orders: 1")
    expect(page).to have_content("Order placed on: #{Time.now.to_date}")
    expect(page).to have_content("Order benefitting: Somali family of 3")
    expect(page).to have_content("1 Small Pot")
    expect(page).to_not have_content("1 Large Pot")


  end

end
