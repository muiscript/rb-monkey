module RMonkey
  module ObjectType
    INTEGER = 'INTEGER'
    BOOLEAN = 'BOOLEAN'
    RETURN_VALUE = 'RETURN_VALUE'
    FUNCTION = 'FUNCTION'
    NULL = 'NULL'
  end

  class Object
    attr_accessor :type

    def to_s
      raise 'should be overridden in subclasses'
    end
  end

  class Integer < Object
    attr_accessor :value

    def initialize(value)
      @type = ObjectType::INTEGER
      @value = value
    end

    def to_s
      value.to_s
    end
  end

  class Boolean < Object
    attr_accessor :value

    def initialize(value)
      @type = ObjectType::BOOLEAN
      @value = value
    end

    def to_s
      value.to_s
    end
  end

  class ReturnValue < Object
    attr_accessor :object

    def initialize(object)
      @type = ObjectType::RETURN_VALUE
      @object = object
    end
    
    def to_s
      "return<#{@object}>"
    end
  end

  class Function < Object
    attr_reader :parameters, :body, :env

    def initialize(parameters, body, env)
      @type = ObjectType::FUNCTION
      @parameters = parameters
      @body = body
      @env = env
    end

    def to_s
      "fn (#{parameters.map(&:name)}) { #{body} }"
    end
  end

  class Null < Object
    attr_reader :value

    def initialize
      @type = ObjectType::NULL
      @value = nil
    end

    def to_s
      "null"
    end
  end
end