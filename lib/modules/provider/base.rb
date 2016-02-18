module Provider
  module Base
    def regions
      []
    end

    def flavors
      []
    end

    def images(_os)
      []
    end

    def valid?
      false
    end
  end
end
