# frozen_string_literal: true

module FHIR
  class Model
    def [](key)
      k = key.to_s

      if respond_to?(:source_hash) && source_hash.is_a?(Hash) && source_hash.key?(k)
        return source_hash[k]
      end

      return public_send(k) if respond_to?(k)

      nil
    end

    def find_extension(extension_source, method_name)
      Array(extension_source).select do |extension|
        url = extension.respond_to?(:url) ? extension.url : nil
        next false if url.nil?

        name = url.tr('-', '_').split('/').last
        name == method_name
      end
    end
  end
end
