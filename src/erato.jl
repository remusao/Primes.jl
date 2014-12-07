
function collect1(primes_mask::BitArray{1})
    n_primes = countnz(primes_mask)
    primes_arr = Array(Int64, n_primes)
    collect1!(primes_mask, primes_arr)
    return primes_arr
end


function collect1!(primes_mask::BitArray{1}, primes_arr::Array{Int64, 1})
    prime_index = 1
    for i = 2:length(primes_mask)
        if primes_mask[i]
            primes_arr[prime_index] = i
            prime_index += 1
        end
    end
    return primes_arr
end


function collect2(primes_mask::BitArray{1})
    # +1 because of 2 not in `primes_mask`
    n_primes = countnz(primes_mask) + 1
    primes_arr = Array(Int64, n_primes)
    collect2!(primes_mask, primes_arr)
    return primes_arr
end


function collect2!(primes_mask::BitArray{1}, primes_arr::Array{Int64, 1})
    prime_index = 2
    primes_arr[1] = 2
    # Start at 2 because 1 is not prime
    for i = 2:length(primes_mask)
        if primes_mask[i]
            primes_arr[prime_index] = i * 2 - 1
            prime_index += 1
        end
    end
    return primes_arr
end



#=
First naive version of Erato sieve.
    * bitarray to store primes
    * only eliminate multiples of primes
    * separately eliminate even non-primes
=#
function erato1(n::Int)
    # Create bitarray to store primes
    primes_mask = trues(n)
    primes_mask[1] = false

    # Eliminate even numbers first
    for i = 4:2:n
        primes_mask[i] = false
    end

    # Eliminate odd non-primes numbers
    for i = 3:2:n
        if primes_mask[i]
            for j = (i + i):i:n
                primes_mask[j] = false
            end
        end
    end

    # Collect every primes in an array
    return collect1(primes_mask)
end


#=
Same as erato1 but stop testing after sqrt(n)
=#
function erato2(n::Int)
    # Create bitarray to store primes
    limit = int(sqrt(n)) + 1
    primes_mask = trues(n)
    primes_mask[1] = false

    # Eliminate even numbers first
    for i = 4:2:n
        primes_mask[i] = false
    end

    # Eliminate odd non-primes numbers
    for i = 3:2:limit
        if primes_mask[i]
            for j = (i + i):i:n
                primes_mask[j] = false
            end
        end
    end

    # Collect every primes in an array
    return collect1(primes_mask)
end


#=
Same as erato2 but doesn't store even numbers
=#
function erato3(n::Int)
    # Create bitarray to store primes
    limit = int(sqrt(n)) + 1
    mem_size = int(n / 2)
    primes_mask = trues(mem_size)
    primes_mask[1] = false

    # Eliminate odd non-primes numbers
    # 1. iterate on every odd number
    # 2. step is the value of the odd number
    #    (note: it's the step to go from one multiple to another)
    # 3. if it's prime, remove its multiples
    for i = 2:limit
        step = 2 * (i - 1) + 1
        if primes_mask[i]
            for j = i+step:step:mem_size
                primes_mask[j] = false
            end
        end
    end

    # Collect every primes in an array
    return collect2(primes_mask)
end

# TODO:
# 1. wheel factorization
# 2. fragmented sieve

n = 100000000


#println("Base-line")
#ref = primes(n)
#@time primes(n)

#println("Erato 1")
#result = erato1(n)
#@time erato1(n)
#@assert result == ref

println("Erato 3")
result = erato3(n)
@time erato3(n)
# @assert result == ref
