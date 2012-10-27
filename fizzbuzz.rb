class Integer

  def fizzbuzz
    raise RangeError if self < 1

    if (self % 15 == 0)
      "FizzBuzz"
    elsif (self % 3 == 0)
      "Fizz"
    elsif (self % 5 == 0)
      "Buzz"
    else
      self.to_s
    end
  end
end
