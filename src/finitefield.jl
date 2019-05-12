
abstract type AbstractFiniteField <: Number end

# Eratosthenes
function isprime(n::Integer)
    if n == 0
        return false
    elseif n < 0
        n = - n
    end
    sqrd = 0
    while sqrd ^ 2 < n
        sqrd += 1
    end
    prime_arrays = fill(true, n)
    for k = 2:sqrd
        if prime_arrays[k]
            quotient =  n ÷ k
            for i in k:quotient
                prime_arrays[i * k] = false
            end
        end
    end
    return prime_arrays[n]
end

struct PrimeField{T<:Integer} <: Real
    prime::T
    function PrimeField{T}(prime::T) where T<:Integer
        if isprime(prime)
            new(prime)
        else
            error("invalid. input is not prime")
        end
    end

end

PrimeField(num::T)  where {T<:Integer} = PrimeField{T}(num);

function inverse(fp::PrimeField, a::Integer)
    p = fp.prime
    a %= p
    if a == 0
        error("invalid. input is not prime")
    end
    inverse = 1
    for i in 1:(p-2)
        inverse *= a
        inverse %= p
    end
    return inverse
end

fp = PrimeField(5)
inverse(fp, 3)
