#function fib1(x)
#  sum=0;
#  for y in 1:x
#    sum= sum+y
#  end
#  println(sum)
#  end

function printN()
    for N in 1:5:200000
    println("The N of this iteration in $N")
end
end

function printN_parallel()
    @distributed    for N in 1:5:200000
        println("The N of this iteration in $N")
end
end



function printa()
    a= zeros(1000000)
    for  i 1:200000
    a[i]=i;
end
end

function function printa_parallel()
    a= zeros(1000000)
    @distributed for  i 1:200000
    a[i]=i;
end
end
