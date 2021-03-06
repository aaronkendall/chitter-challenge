module SessionHelpers

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

  def sign_in(user)
    visit '/sessions/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end

  def peep(content)
    visit '/peeps/new'
    fill_in :peep, with: content
    click_button 'Submit'
  end

end
