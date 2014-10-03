class String
  def to_bool
    if self =~ /(true|t|yes|y|1)/
      return true
    else
      return false
    end
  end
end

class Fixnum
  def to_bool
    if self == 1
      return true
    else
      return false
    end
  end
end

class TrueClass
  def to_i; 1; end
  def to_bool; self; end
end

class FalseClass
  def to_i
    0
  end

  def to_bool
    self
  end
end

class NilClass
  def to_bool
    false
  end
end
