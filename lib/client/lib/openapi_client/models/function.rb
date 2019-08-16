=begin
#WASAPI Export API as implemented by Archive-It

#WASAPI Export API.  What Archive-It has implemented. 

The version of the OpenAPI document: 1.0.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.1.0

=end

require 'date'

module OpenapiClient
  class Function
    WAT = "build-wat".freeze
    WANE = "build-wane".freeze
    CDX = "build-cdx".freeze

    # Builds the enum from string
    # @param [String] The enum value in the form of the string
    # @return [String] The enum value
    def self.build_from_hash(value)
      new.build_from_hash(value)
    end

    # Builds the enum from string
    # @param [String] The enum value in the form of the string
    # @return [String] The enum value
    def build_from_hash(value)
      constantValues = Function.constants.select { |c| Function::const_get(c) == value }
      raise "Invalid ENUM value #{value} for class #Function" if constantValues.empty?
      value
    end
  end
end
