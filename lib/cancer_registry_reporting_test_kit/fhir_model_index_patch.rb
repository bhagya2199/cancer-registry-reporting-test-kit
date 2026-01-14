# frozen_string_literal: true

module FHIR
  class Model
    def [](key)
      k = key.to_s

      # Prefer raw JSON hash when available
      if respond_to?(:source_hash) && source_hash.is_a?(Hash) && source_hash.key?(k)
        return source_hash[k]
      end

      # Fallback to normal model accessors
      return public_send(k) if respond_to?(k)

      nil
    end
  end
end
