FactoryGirl.define do
  factory :template_argument do
    sequence(:textkey) { |n| "argument_#{n}" }
    sequence(:name) { |n| "Argument #{n}" }
    sequence(:required) { [true, false].sample }
    validator DeploymentArgumentsValidator::VALIDATORS.keys.sample.to_s
    template
  end
end
