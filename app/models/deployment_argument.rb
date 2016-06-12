class DeploymentArgument < OpenStruct
  def initialize(deployment, argument)
    @deployment = deployment
    @argument = argument
    super hash
  end

  private

  def hash
    argument_hash.merge errors_hash || {}
  end

  def argument_hash
    { @argument.textkey => @deployment.arguments.try(:[], @argument.textkey) || @argument.default }
  end

  def errors_hash
    { errors: { @argument.textkey => errors } } if errors.any?
  end

  def errors
    @errors ||= @deployment.errors[:arguments].select { |e| e.keys.include? @argument.textkey }.map(&:values).flatten
  end
end
