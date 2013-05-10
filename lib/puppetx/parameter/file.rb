require 'puppet/parameter'

# forward declarations
module PuppetX
  module Parameter; end
end

class PuppetX::Parameter::File < Puppet::Parameter

  # Meant to be passed as an option to newparam
  def accept_file_with_content(bool = true)
    @accept_file_with_content = !!bool
  end
  def accept_file_with_content?
    @accept_file_with_content
  end

  def unsafe_validate(value)
    fail("#{name} does not accept an array as input") if value.is_a? Array

    if value.is_a? String
      fail("#{name} must be a fully qualified path") unless absolute_path?(value)
    elsif not value.resource_type == Puppet::Type.type(:file)
      fail("#{name} only accepts strings and File[] references, #{value.to_s} is not valid")
    end
    value
  end

  def unmunge(value)
    if @ref.nil? and value.is_a? Puppet::Resource
      @ref = resource.catalog.resource(value.to_ref)
      if @ref and !accept_file_with_content?
        fail("#{value} is managing content, #{name} will not overwrite") if @ref[:content] or @ref[:source]
      end
    end

    if @ref
      return @ref[:path]
    end
    value
  end
end
