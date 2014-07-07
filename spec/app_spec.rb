require "spec_helper"

feature "Homepage" do
  scenario "Logged out user sees Contacts on homepage" do
    visit "/"

    expect(page).to have_content("Contacts")
  end
end