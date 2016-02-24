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

RSpec.shared_examples 'deployment with valid data' do
  it 'assigns a new deployment instance as @deployment' do
    post :validate, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(assigns(:decorator)).to be_a(DeploymentDecorator)
    expect(assigns(:decorator).deployment).to be_a_new(Deployment)
    expect(assigns(:decorator).deployment).not_to be_persisted
  end

  it 'validate responds with success' do
    post :validate, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(response).to have_http_status(:no_content)
  end

  context 'rendering' do
    render_views
    it 'validate generates the response data' do
      post :validate, { deployment: valid_attributes, template_id: template.to_param, format: :json }, valid_session
      expect(response.body).to be_empty
    end
  end
end

RSpec.shared_examples 'deployment with invalid data' do |use_invalid_attributes|
  it 'validate responds with error' do
    post :validate, { deployment: use_invalid_attributes ? invalid_attributes : valid_attributes, template_id: template.to_param, format: :json }, valid_session
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

RSpec.shared_examples 'deployment options with valid data' do |type|
  it 'assigns a new deployment instance as @deployment' do
    post :options, { deployment: valid_attributes, template_id: template.to_param, type: type, format: :json }, valid_session
    expect(assigns(:decorator)).to be_a(DeploymentDecorator)
    expect(assigns(:decorator).deployment).to be_a_new(Deployment)
    expect(assigns(:decorator).deployment).not_to be_persisted
  end

  it 'validate responds with success' do
    post :options, { deployment: valid_attributes, template_id: template.to_param, type: type, format: :json }, valid_session
    expect(response).to have_http_status(:ok)
  end

  context 'rendering' do
    render_views
    it 'validate generates the response data' do
      post :options, { deployment: valid_attributes, template_id: template.to_param, type: type, format: :json }, valid_session
      expect(response.body).not_to be_empty
    end
  end
end

RSpec.shared_examples 'deployment options with invalid data' do |type, use_invalid_attributes|
  it 'validate responds with error' do
    post :options, { deployment: use_invalid_attributes ? invalid_attributes : valid_attributes, template_id: template.to_param, type: type, format: :json }, valid_session
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
