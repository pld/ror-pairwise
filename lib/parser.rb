class LibXML::XML::Parser
  class << self
    # ==== Return
    # Array of elements from XML parseed by retrieving attribute value
    # for each element in path of XML.
    # ==== Params
    # string:: the XML to parse.
    # path:: the path to find in the XML.
    # attribute:: the attribute to request per element of the XML.
    def parse(string, path, attribute)
      string(string).parse.find(path).inject([]) do |arr, el|
        arr << el.attributes[attribute]
        arr
      end
    end
  end
end