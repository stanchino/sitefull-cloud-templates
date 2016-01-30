RSpec.shared_examples 'successful GET action' do |action, template, layout|
  it 'responds with success' do
    get action
    expect(response).to be_success
  end

  it 'renders the corrent template' do
    get action
    expect(response).to render_template template, layout: layout
  end
end
