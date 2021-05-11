class Endpoint < ApplicationRecord
  # Constants
  VALID_VERBS = %w(GET POST PATCH DELETE).freeze
  RESPONSE_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'response.json_schema').to_s

  PATH_DELIMETERS = %w[: / ? # [ ] @].freeze

  # Validations
  validates :verb, presence: true, inclusion: { in: VALID_VERBS }
  validates :path, presence: true
  validates :response, presence: true, json: { schema: RESPONSE_JSON_SCHEMA }

  # Custom Validations
  validate :valid_path, if: -> { path.present? }

  private

  def valid_path
    return if PATH_DELIMETERS.include? path[0]

    errors.add(:path, 'invalid path')
  end
end
