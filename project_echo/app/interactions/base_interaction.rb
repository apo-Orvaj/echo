class BaseInteraction < ActiveInteraction::Base
  private

  def merge_errors(record)
    errors.details.merge!(record.errors.details)
    errors.messages.deep_merge!(record.errors.messages) { |_key, this_val, other_val| this_val + other_val }
  end
end
