# Add code here
class SingleCharacterMatcher
  class << self
    def contains?(char, string)
      /^[^#{char}]*#{char}[^#{char}]*$/ =~ string
    end

    def check(string)
      /^.$/ =~ string
    end
  end
end

class CharacterSequenceMatcher
  class << self
    def check(string)
      /(\S)\1+/ =~ string
    end
  end
end

class VowlerPairMatcher
  VOWELS = "[aeiou]"
  
  class << self    
    def check(string)
      /(#{VOWELS}[\\n]*#{VOWELS})/i =~ string
    end
  end
end

class RepetitionMatcher
  class << self
    def check(string)
      /(\S)\1+/i =~ string
    end

    def last(string)
      string.scan(/((\S)[\W]*\2+)/i).last.first.gsub('.','')
    end
  end
end
