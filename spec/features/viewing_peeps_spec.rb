require 'spec_helper'

feature 'Viewing peeps' do

  scenario 'I can see peeps on the homepage' do
    user = build(:user)
    sign_up(user)
    sign_in(user)
    peep('This is a random peep')
    visit '/'
    click_button 'Sign out'
    expect(page.status_code).to eq 200

    within 'ul#peeps' do
      expect(page).to have_content('This is a random peep')
    end
  end
end
