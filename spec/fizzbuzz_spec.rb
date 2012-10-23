require_relative '../fizzbuzz.rb'

describe "Integer#fizzbuzz" do

  it "should raise a RangeError if the Integer is less than 1" do
    lambda do
      0.fizzbuzz
    end.should raise_error(RangeError)
  end

  it "should be 'Fizz' if the Integer is divisible by 3" do
    6.fizzbuzz.should == "Fizz"
  end

  it "should be 'Buzz' if the Integer is divisible by 5" do
    10.fizzbuzz.should == "Buzz"
  end

  it "should be 'FizzBuzz' if the Integer is divisible by both 3 and 5" do
    15.fizzbuzz.should == "FizzBuzz"
  end

  it "should be Integer.to_s if the Integer is divisible by neither 3 nor 5" do
    2.fizzbuzz.should == 2.to_s
  end
end
