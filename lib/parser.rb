class LibXML::XML::Parser
  class << self
    # Call LibXML parse function in fork to avoid memory leak.
    # Method is detailed in: http://xaop.com/blog/2008/04/01/libxml-ruby-memory-leaks/.
    #
    # string:: the XML to parse.
    #
    # path:: the path to find in the XML.
    #
    # attribute:: the attribute to request per element of the XML.
    #
    # Returns array of elements from XML parseed by retrieving attribute value
    # for each element in path of XML.
    def parse(string, path, attribute)
      parser = new
      rd, wr = IO.pipe
      begin
        pid = fork do
          rd.close
          begin
            parser.string = string
            result = parser.parse.find(path).inject([]) do |arr, el|
              arr << el.attributes[attribute]
              arr
            end
            wr.write Marshal.dump(result)
            wr.close
          rescue
          ensure
            exit!
          end
        end
        wr.close
        result = Marshal.load(rd.read)
        rd.close
        Process.wait(pid)
      end
      result
    end
  end
end