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
