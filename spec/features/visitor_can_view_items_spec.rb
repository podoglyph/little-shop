require "rails_helper"

RSpec.feature "When a visitor" do
  context "visits the items page" do
    item1, item2, item3 = create_list(:items)

    visit "/items"
    expect(page).to have_content(item1.title)
    expect(page).to have_content(item1.description)
    expect(page).to have_content(item1.price)
    # expect(page).to have_xpath("//img[@src=#{item1.image_path}")
    expect(page).to have_content(item2.title)
    expect(page).to have_content(item2.description)
    expect(page).to have_content(item2.price)
    # expect(page).to have_xpath("//img[@src=#{item2.image_path}")
    expect(page).to have_content(item3.title)
    expect(page).to have_content(item3.description)
    expect(page).to have_content(item3.price)
    # expect(page).to have_xpath("//img[@src=#{item3.image_path}")
    expect(page).to have_content("Login")
  end
end
