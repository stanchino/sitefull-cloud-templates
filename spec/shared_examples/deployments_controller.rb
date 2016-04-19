require 'shared_examples/controllers'

RSpec.shared_examples 'successfull deployment' do
  it 'creates a new Deployment' do
    expect do
      post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
    end.to change(Deployment, :count).by(1)
  end

  it 'assigns a newly created deployment as @deployment' do
    post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
    expect(assigns(:deployment)).to be_a(Deployment)
    expect(assigns(:deployment)).to be_persisted
  end

  it 'redirects to the created deployment' do
    post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
    expect(response).to redirect_to(Deployment.last)
  end

=begin
  context 'with new internet gateway' do
    it 'publish the event' do
      expect do
        post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
      end.to broadcast(:deployment_saved)
    end
  end
=end
end

RSpec.shared_examples 'deployment controller' do |provider|
  setup_access(provider)
  let(:deployment) { FactoryGirl.create(:deployment, provider, template: template) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, provider, template: template) }

  describe 'GET #all' do
    it 'assigns all deployments as @deployments' do
      get :all, {}, valid_session
      expect(assigns(:deployments)).to eq([deployment])
    end
  end

  describe 'GET #index' do
    it 'assigns all deployments as @deployments' do
      get :index, { template_id: template.id }, valid_session
      expect(assigns(:deployments)).to eq([deployment])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested deployment as @deployment' do
      get :show, { id: deployment.to_param }, valid_session
      expect(assigns(:deployment)).to eq(deployment)
    end
  end

  describe 'GET #new' do
    it 'responds with success' do
      get :new, { template_id: template.id }, valid_session
      expect(response).to be_success
    end

    it 'assigns a new deployment as @deployment' do
      get :new, { template_id: template.id }, valid_session
      expect(assigns(:template)).to eq template
      expect(assigns(:deployment)).to be_a_new(Deployment)
      expect(assigns(:decorator)).to be_a DeploymentDecorator
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:session) { double }
      let(:channel) { double }
      let(:ch) { double }
=begin
      before do
        expect(Net::SSH).to receive(:start).and_yield(session)
        expect(session).to receive(:open_channel).and_yield(channel).and_return(double(wait: true))
        expect(channel).to receive(:request_pty)
      end
=end

      context 'when the script is executed successfully' do
=begin
        before do
          expect(ch).to receive(:on_data).and_yield(any_args, :output)
          expect(ch).to receive(:on_extended_data).and_yield(any_args, any_args, :output)
          expect(channel).to receive(:exec).and_yield(ch, true)
        end
=end
        it_behaves_like 'successfull deployment'
      end

      context 'when the ssh connection cannot be established' do
=begin
        before do
          expect(ch).not_to receive(:on_data)
          expect(ch).not_to receive(:on_extended_data)
          expect(channel).to receive(:exec).and_raise(StandardError)
        end
=end
        it_behaves_like 'successfull deployment'
      end

      context 'when the script execution fails' do
=begin
        before do
          expect(ch).not_to receive(:on_data)
          expect(ch).not_to receive(:on_extended_data)
          expect(channel).to receive(:exec).and_yield(ch, false)
        end
=end
        it_behaves_like 'successfull deployment'
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved deployment as @deployment' do
        post :create, { deployment: invalid_attributes, template_id: template.to_param }, valid_session
        expect(assigns(:deployment)).to be_a_new(Deployment)
      end

      it "re-renders the 'new' template" do
        post :create, { deployment: invalid_attributes, template_id: template.to_param }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'POST #validate' do
    it_behaves_like 'deployment with valid data'
    it_behaves_like 'deployment with invalid data', true
  end

  describe 'POST #options' do
    [:regions, :images, :machine_types].each do |type|
      context "for #{type}" do
        it_behaves_like 'deployment options with valid data', type
        it_behaves_like 'deployment options with invalid data', type, true
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested deployment' do
      id = deployment.to_param
      expect do
        delete :destroy, { id: id, template_id: template.to_param }, valid_session
      end.to change(Deployment, :count).by(-1)
    end

    it 'redirects to the deployments list' do
      delete :destroy, { id: deployment.to_param, template_id: template.to_param }, valid_session
      expect(response).to redirect_to(deployments_url)
    end
  end
end
