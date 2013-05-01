puppet-file_param
=================

Parameter for file path that will accept strings or Puppet::Type::File
references.

Overview
--------

This paramter is for use when a resource needs to accept an absolute
file path for its functionality. Since most types that need a path are
not managing the other attributes of the file in questions, there is
usually an accompanying File[] resource. This paramter can accept either
a string or a Puppet::Type::File as it's input. If it receives a File[],
it will munge the path out of it.

By default, this paramter fails if provided a File[] resource and it is
managing the content, either via 'content =>' or 'source =>' attributes.
This behavior can be turned off however.

Example
-------
```ruby
require 'puppet/parameter/file'

# Disclaimer: Not best example ever
Puppet::Type.newtype(:best_example_ever) do
        
  newparam(:name, :namevar => true)

  # We want a string path, or a File[] that isn't managing content  
  newparam(:example1, :parent => Puppet::Parameter::File)

  # We don't care if a File[] is managing content
  newparam(:example2, :parent => Puppet::Parameter::File) do
    # This changes the default behaviour to not check File[] for managed content, and just extract the path
    accept_file_with_content
  end
end
```
