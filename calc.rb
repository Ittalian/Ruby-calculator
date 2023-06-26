require "strscan"

class Calc
@@opes = {
   '+' => :add,
   '-' => :sub,
   '*' => :mul,
   '/' => :div,
   '(' => :lpar
}

def search
   if @scanner.scan(/\d+|[\+\-\*\/()]/)
      if @scanner[0] =~ /[\+\-\*\/()]/
         @@opes[@scanner[0]]
      else
         @scanner[0]
      end
   else
      nil
   end
end
   
def calc(exp)
   if exp.instance_of?(Array)
      case exp[0]
	  when :add
	     return calc(exp[1]) + calc(exp[2])
	  when :sub
	     return calc(exp[1]) - calc(exp[2])
	  when :mul
	     return calc(exp[1]) * calc(exp[2])
	  when :div
	     return calc(exp[1]) / calc(exp[2])
      end
   else
      return exp
   end
end
   
def reverse_search
   if !(@scanner.eos?)
      @scanner.unscan()
   end
end
 
def exp
   ans = term()
   ope = search()
   while ope == :add || ope == :sub
	  ans = [ope, ans, term()]
	  ope = search()
   end
   reverse_search()
   return ans
end

def term
   ans = factor()
   ope = search()
   while ope == :mul || ope == :div
      ans = [ope, ans, factor()]
	  ope = search()
   end
   reverse_search()
   return ans
end

def factor
   ope = search()
   if ope =~ /\d+/
      ans = ope.to_f
   elsif ope == :lpar
      ans = exp()
	  search()
   else
      raise Exception,"Statement Error!"
   end
      return ans
end

def initialize
   state = 'Result is '
   while true do
      print ">"
	  input = STDIN.gets
	  if input == "q\n"
	     p "exit"
		 exit
	  end
	  @scanner = StringScanner.new(input.chomp)
	  p state + (calc(exp)).to_s
   end
end
end
Calc.new