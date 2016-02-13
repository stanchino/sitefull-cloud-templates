RSpec.shared_examples 'successful GET action' do |action, view, layout|
  subject { response }

  before { get action }

  it { is_expected.to be_success }
  it { is_expected.to render_template view, layout: layout }
end

RSpec.shared_examples 'successfull GET resource action' do |action, resource, view, layout, test_json|
  subject { response }

  context 'for HTML requests' do
    before { get action, { id: send(resource).to_param }, valid_session }

    it { is_expected.to be_success }
    it { is_expected.to render_template view, layout: layout }
    it { expect(assigns(resource)).to eq send(resource) }
  end

  if test_json
    context 'for JSON requests' do
      before { get action, { id: send(resource).to_param, format: :json }, valid_session }

      it { is_expected.to be_success }
      it { is_expected.to render_template view, layout: false }
    end
  end
end

RSpec.shared_examples 'update action with data' do |resource, data|
  it 'assigns the requested resource' do
    put :update, { id: send(resource).to_param, resource => send(data) }, valid_session
    expect(assigns(resource)).to eq(send(resource))
  end
end

RSpec.shared_examples 'deployment with valid options response' do
  it 'assigns a new deployment instance as @deployment' do
    post :options, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(assigns(:deployment)).to be_a_new(Deployment)
    expect(assigns(:deployment)).not_to be_persisted
  end

  it 'responds with success' do
    post :options, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(response).to be_ok
  end

  it 'renders the options' do
    post :options, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(response).to render_template('deployments/options', layout: false)
  end
end

RSpec.shared_examples 'deployment with invalid options' do |use_invalid_attributes|
  it 'responds with error' do
    post :options, { deployment: use_invalid_attributes ? invalid_attributes : valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(response).to have_http_status(422)
  end
end
