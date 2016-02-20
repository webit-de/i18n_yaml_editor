# encoding: utf-8

module I18nYamlEditor
  class TransformationError < StandardError; end

  # Transformation provides
  module Transformation
    # Public: Converts a deep hash to one level by generating new keys
    #         by joining the previous key path to the value with a '.'
    #
    # hash      - The original Hash.
    # namespace - An optional namespace, default: [].
    # tree      - An optional tree to add values to, default: {}.
    #
    # Examples
    #   flatten_hash({da: {session: { login: 'Log ind', logout: 'Log ud' }}})
    #   # => {"da.session.login"=>"Log ind", "da.session.logout"=>"Log ud"}
    #
    # Returns the generated Hash.
    def flatten_hash(hash, namespace = [], tree = {})
      hash.each do|key, value|
        child_ns = namespace.dup << key
        if value.is_a?(Hash)
          flatten_hash value, child_ns, tree
        else
          tree[child_ns.join('.')] = value
        end
      end
      tree
    end
    module_function :flatten_hash

    # Public: Converts a flat hash with key path to the value joined
    #         with a '.' to a one level Hash, it's the reverse of flatten_hash
    #
    # hash - Hash with keys that represent the path to the value in the new Hash
    #
    # Examples
    #  nest_hash({"da.session.login"=>"Log ind", "da.session.logout"=>"Log ud"})
    #  # => {"da"=>{"session"=>{"login"=>"Log ind", "logout"=>"Log ud"}}}
    #
    # Returns the generated Hash.
    def nest_hash(hash)
      result = {}
      hash.each do |key, value|
        begin
          nest_key result, key, value
        rescue
          raise TransformationError,
                "Failed to nest key: #{key.inspect} with #{value.inspect}"
        end
      end
      result
    end
    module_function :nest_hash

    private

    def nest_key(result, key, value)
      sub_result = result
      keys = key.split('.')
      keys.each_with_index do |k, idx|
        if keys.size - 1 == idx
          sub_result[k] = value
        else
          sub_result = (sub_result[k] ||= {})
        end
      end
    end
    module_function :nest_key
  end
end
