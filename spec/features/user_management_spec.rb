require 'spec_helper'

feature 'User sign up' do

  xscenario 'I can sign up as a new user' do
    user = create(:user)
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, Ken')
    expect(User.first.email).to eq('ken@ken.com')
  end

  def sign_up(user)
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :first_name, with: user.first_name
    fill_in :last_name, with: user.last_name
    fill_in :username, with: user.username
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

  scenario 'with a password that does not match' do
    user = create(:user, password_confirmation: "wrong")
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'email is a required field' do
    user = create(:user, email: nil)
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
  end

  scenario 'I cannot sign up with an existing email' do
    user = create(:user)
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content 'Email is already taken'
  end
end

feature 'Sign in' do
  let(:user_sign_in) do
    User.create(email: 'user@example',
                password: 'secret1234',
                username: 'user123',
                password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials' do
    sign_in(email: user_sign_in.email, password: user_sign_in.password)
    expect(page).to have_content 'Welcome, #{user_sign_in.username}'
  end

  def sign_in(email:, password:)
    visit '/sessions/new'
    fill_in :email, with: user_sign_in.email
    fill_in :password, with: user_sign_in.password
  end
end
