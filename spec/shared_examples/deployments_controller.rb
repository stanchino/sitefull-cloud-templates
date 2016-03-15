require 'shared_examples/controllers'

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

      context 'with new internet gateway' do
        it 'publish the event' do
          expect do
            post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
          end.to broadcast(:deployment_saved)
        end
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
