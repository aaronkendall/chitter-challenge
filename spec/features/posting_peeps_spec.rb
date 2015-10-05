require 'spec_helper'

feature 'User peep posting' do

  before(:each) do
    @user = build(:user)
  end

  scenario 'User can post peeps' do
    sign_up(@user)
    sign_in(@user)
    peep("What an amazing test peep")
    expect(page).to have_content("What an amazing test peep")
  end

  scenario 'User must be logged in to post a peep' do
    visit '/peeps/new'
    expect(page).to have_content("You must be logged in to access that page")
    expect(page).not_to have_content("Another peep")
  end

  scenario 'username is shown with their peeps' do
    sign_up(@user)
    sign_in(@user)
    peep("This is a peep")
    expect(page).to have_content("by Ken")
  end
end
