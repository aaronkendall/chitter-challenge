require 'spec_helper'

feature 'User sign up' do

  before(:each) do
    @user = build(:user)
  end

  scenario 'I can sign up as a new user' do
    expect { sign_up(@user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, Ken')
  end

  scenario 'with a password that does not match' do
    user = build(:user, password_confirmation: "wrong")
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'email is a required field' do
    user = build(:user, email: nil)
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up(@user)
    expect { sign_up(@user) }.to change(User, :count).by(0)
    expect(page).to have_content 'Email is already taken'
  end
end

feature 'Sign in' do

  before(:each) do
    @user = build(:user)
  end

  scenario 'with correct credentials' do
    sign_up(@user)
    sign_in(@user)
    expect(page).to have_content 'Welcome, Ken'
  end
end

feature 'User signs out' do

  before(:each) do
    @user = build(:user)
  end

  scenario 'while being signed in' do
    sign_up(@user)
    sign_in(@user)
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, Ken')
  end
end
