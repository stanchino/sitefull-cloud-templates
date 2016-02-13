RSpec.shared_examples 'unauthenticated user' do
  it 'that is redirected to the login page' do
    expect(response).to redirect_to new_user_session_path
    follow_redirect!
    expect(response).to be_success
    expect(response).to render_template('devise/sessions/new', layout: 'application')
    expect(response.body).to include 'You are not authorized to access this page.'
  end
end
