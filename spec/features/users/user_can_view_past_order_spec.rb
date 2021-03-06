require 'rails_helper'

RSpec.feature "An existing user" do
  context "with a single order" do

    it "can see that completed order" do
      order = create(:order_with_items, status: 3, completed_date: DateTime.now)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(order.user)
      item1 = order.items[0]
      item2 = order.items[1]
      item3 = order.items[2]

      visit user_orders_path(order.user)

      expect(page).to have_content(order.total)
      expect(page).to have_content(order.status.capitalize)
      expect(page).to have_content(order.completed)

      click_link(href: user_order_path(order.user, order))
      expect(page).to have_content(item1.name)
      expect(page).to have_content(order.order_items.find_by(item_id: item1.id).qty)
      expect(page).to have_content(order.order_items.first.line_item_subtotal)
      expect(page).to have_link("#{item1.name}", :href=>item_path(item1))
      expect(page).to have_content(item2.name)
      expect(page).to have_content(order.order_items.find_by(item_id: item2.id).qty)
      expect(page).to have_content(order.order_items.last.line_item_subtotal)
      expect(page).to have_link("#{item2.name}", :href=>item_path(item2))
      expect(page).to have_content("Completed on #{order.completed}")
    end

    it "can see that cancelled order" do
      order = create(:order_with_items, status: 2, cancelled_date: DateTime.now)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(order.user)
      item1 = order.items[0]
      item2 = order.items[1]
      item3 = order.items[2]

      visit user_orders_path(order.user)

      expect(page).to have_content(order.total)
      expect(page).to have_content(order.status.capitalize)
      expect(page).to have_content(order.ordered)

      click_link(href: user_order_path(order.user, order))
      expect(page).to have_content(item1.name)
      expect(page).to have_content(order.order_items.find_by(item_id: item1.id).qty)
      expect(page).to have_content(order.order_items.first.line_item_subtotal)
      expect(page).to have_link("#{item1.name}", :href=>item_path(item1))
      expect(page).to have_content(item2.name)
      expect(page).to have_content(order.order_items.find_by(item_id: item2.id).qty)
      expect(page).to have_content(order.order_items.last.line_item_subtotal)
      expect(page).to have_link("#{item2.name}", :href=>item_path(item2))
      expect(page).to have_content("Cancelled on #{order.cancelled}")
    end

    it "can see the original price if item price changes" do
      item = create(:item, price: 10.00)
      order = create(:order, status: 0)
      user = order.user
      order.order_items.create(item_id: item.id, qty: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit user_order_path(user, order)
      expect(page).to have_content(item.name)
      expect(page).to have_content(30.00)

      item.update(price: 12.00)

      visit user_order_path(user, order)

      expect(page).to have_content(item.name)
      expect(page).to have_content(30.00)
      expect(page).to_not have_content(36.00)

      visit item_path(item)

      expect(page).to have_content(12)
    end
  end
end
