require 'spec_helper'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, Ken')
    expect(User.first.email).to eq('ken@ken.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  end

  def sign_up(email: 'ken@ken.com',
              first_name: 'aaron',
              last_name: 'kendall',
              username: 'Ken',
              password: 'secret',
              password_confirmation: 'secret')
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :first_name, with: first_name
    fill_in :last_name, with: last_name
    fill_in :username, with: username
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end

  scenario 'with a password that does not match' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Confirmation does not match password'
  end

  scenario 'email is a required field' do
    expect { sign_up_email }.not_to change(User, :count)
    expect(current_path).to eq('/users')
  end

  def sign_up_email(first_name: 'aaron',
                    last_name: 'kendall',
                    username: 'Ken',
                    password: 'secret',
                    password_confirmation: 'secret')
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :first_name, with: first_name
    fill_in :last_name, with: last_name
    fill_in :username, with: username
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end
end
