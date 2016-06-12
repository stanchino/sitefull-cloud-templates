module TemplatesHelper
  def validators_collection
    Hash[DeploymentArgumentsValidator::VALIDATORS.keys.map { |key| [I18n.t("validators.collection_names.#{key}"), key] }]
  end
end
