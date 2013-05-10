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
    elsif not value.is_a? Puppet::Resource
      fail("#{name} only accepts strings and resource references")
    end
    value
  end

  # Incase someone Overrides `unsafe_validate` this is a second chance to fight off arrays
  def unsafe_munge(value)
    fail("{name} does not accept an array as input") if value.is_a? Array

    if @ref.nil? and value.is_a? Puppet::Resource
      @ref = resource.catalog.resource(value.to_ref)
      if @ref.is_a? Puppet::Type.type(:file).class and !accept_file_with_content?
        fail("#{value} is managing content, #{name} will not overwrite") if value.to_hash[:content] or value.to_hash[:source]
      end
    end

    if @ref and @ref.is_a? Puppet::Type.type(:file).class
      return @ref[:path]
    end
    value
  end
end
