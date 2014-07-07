require "spec_helper"

feature "Homepage" do
  scenario "Logged out user sees Contacts on homepage" do
    visit "/"

    expect(page).to have_content("Contacts")

    click_button("Login")

    expect(page).to have_content("Username:", "Password:")

    fill_in "username", :with => "Jeff"
    fill_in "password", :with => "jeff123"

    click_button("Login")
    expect(page).to have_content "Welcome, Jeff"
    expect(page).to_not have_button("Login")

    expect(page).to have_content("Spencer", "spen@example.com")
    expect(page).to_not have_content("Kirsten", "kirsten@example.com")

    click_button("Logout")

    expect(page).to_not have_content("Welcome, Jeff")
    expect(page).to have_button("Login")
  end
end