require 'shared_examples/controllers'

RSpec.shared_examples 'deployment with state' do |state|
  describe state do
    it { expect { create_event('deployments.created', deployment_id: deployment.id).dispatch }.to change { Deployment.with_state(state).count }.by(1) }
  end
end

RSpec.shared_examples 'controller that runs the deployment' do |provider|
  let(:accounts_user) { AccountsUser.where(user: template.user, account: template.user.current_account).first }
  let(:deployment) { FactoryGirl.create(:deployment, provider, state: :running, template: template, accounts_user: accounts_user) }

  context 'executing the flow' do
    let(:session) { double }
    let(:channel) { double }
    let(:ch) { double }

    describe 'without exceptions' do
      before do
        expect(Net::SSH).to receive(:start).twice.and_yield(session)
        expect(session).to receive(:open_channel).ordered.and_return(true)
        expect(session).to receive(:open_channel).ordered.and_yield(channel).and_return(double(wait: true))
        expect(channel).to receive(:request_pty)
      end

      context 'when the script is executed successfully' do
        before do
          expect(ch).to receive(:on_data).and_yield(any_args, :output)
          expect(ch).to receive(:on_extended_data).and_yield(any_args, any_args, :output)
          expect(channel).to receive(:exec).and_yield(ch, true)
        end
        it_behaves_like 'deployment with state', :completed
      end

      context 'when the ssh connection cannot be established' do
        before do
          expect(ch).not_to receive(:on_data)
          expect(ch).not_to receive(:on_extended_data)
          expect(channel).to receive(:exec).and_raise(StandardError)
        end
        it_behaves_like 'deployment with state', :failed
      end

      context 'when the script execution fails' do
        before do
          expect(ch).not_to receive(:on_data)
          expect(ch).not_to receive(:on_extended_data)
          expect(channel).to receive(:exec).and_yield(ch, false)
        end
        it_behaves_like 'deployment with state', :failed
      end
    end

    context 'when the instance does not start' do
      [Errno::ECONNREFUSED, Net::SSH::ConnectionTimeout].each do |exc|
        context "in case of #{exc}" do
          before do
            expect_any_instance_of(ConnectionDecorator).to receive(:sleep).with(10).and_raise TimeoutError
            expect(Net::SSH).to receive(:start).and_raise(exc)
          end
          it_behaves_like 'deployment with state', :failed
        end
      end
    end

    context 'when the script execution raises an error' do
      before do
        expect(Net::SSH).not_to receive(:start)
        expect_any_instance_of(ConnectionDecorator).to receive(:ssh_session).and_raise(StandardError)
      end
      it_behaves_like 'deployment with state', :failed
    end
  end
end
