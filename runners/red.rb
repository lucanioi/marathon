def sum_and_min(array)
  sum = min = array[0]

  array[1..-1].each do |num|
    sum += num
    min = num if num < min
  end

  [sum, min]
end


#====================== setup above, code below =======================#


sum_and_min(@array)
