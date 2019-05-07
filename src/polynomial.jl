import Base: +, -, *
import Base: gcd, isequal

struct Poly{T}
  a::Vector{T}
  var::Symbol
  # constructor
  function Poly(a::Vector{T}, var::Symbol = :x) where {T<:Number}
    #  a == [] -> a = [0]
    if length(a) == 0
      new{T}(zeros(T,1), var)
    else
      last_nz = findlast(!iszero, a)
      if last_nz == nothing
        new{T}(zeros(T,1), var)
      else
        new{T}(a[1:last_nz], var)
      end
    end
  end
end

function isequal(f::Poly, q::Poly)
  return f.a == q.a
end

Poly(n::Number, var::Symbol=:x) = Poly([n], var)

# show polynomial
function printpoly(p::Poly)
  first_nz = findfirst(!iszero, p.a)
  if first_nz == nothing
    print(0)
  end
  for (_degree, value) in enumerate(p.a)
    degree = _degree - 1
    if value == 0
      continue
    end
    if value < 0
      print(string(value), string(p.var) * "^", string(degree))
    else
      if degree == first_nz - 1
          print(string(value), string(p.var) * "^", string(degree))
      else
          print(" + " * string(value), string(p.var) * "^", string(degree))
      end
    end
  end
end

function degree(p::Poly)
  return length(p.a) - 1
end

function +(p::Poly, q::Poly)
  deg_p, deg_q = degree(p), degree(q)
  print(deg_p)
  if deg_p >= deg_q
    a = copy(p.a)
    a[1:deg_q + 1] += q.a
  else
    a = copy(q.a)
    a[1:deg_p + 1] += p.a
  end
  return Poly(a, p.var)
end

+(p::Poly, num::Number) = +(p::Poly, Poly([num], p.var))
+(num::Number, p::Poly) = +(p::Poly, Poly([num], p.var))

function -(p::Poly, q::Poly)
  deg_p, deg_q = degree(p), degree(q)
  if deg_p >= deg_q
    a = copy(p.a)
    a[1:deg_q + 1] -= q.a
  else
    a = copy(q.a)
    a[1:deq_p + 1] -= p.a
  end
  return Poly(a, p.var)
end

function *(p::Poly, q::Poly)
  deg_p, deg_q = degree(p), degree(q)
  a = zeros(typeof(p.a[1]), deg_p + deg_q + 1)
  for (_degree, coefficient) in enumerate(p.a)
    a[_degree: _degree + deg_q] += q.a * coefficient
  end
  return Poly(a, p.var)
end

function *(p::Poly, n::Number)
  return Poly(n * p.a, p.var)
end
*(n::Number, p::Poly) = *(p::Poly, n::Number)

function lowdegree(target::Array, divide::Array, quotient::Array)
  deg_target = length(target)
  deg_divide = length(divide)
  num = target[deg_target] // divide[deg_divide]
  quotient[deg_target - deg_divide + 1] += num
  target[(deg_target-deg_divide) + 1:deg_target] -= num * divide
  return (target[1:deg_target-1], divide, quotient)
end

function /(p::Poly, q::Poly)
  if q.a == [0]
    error(DivideError())
  end
  if degree(p) < degree(q)
    return (p, q, Poly([0//1], p.var))
  end
  quotient = zeros(typeof(p.a[1]), degree(p) - degree(q) + 1)
  target = copy(p.a)
  divide = copy(q.a)
  while length(target) >= length(divide) && length(target) > 1
    target, divide, quotient = lowdegree(target, divide, quotient)
  end
  return Poly(quotient,p.var)
end

function %(p::Poly, q::Poly)
  if q.a == [0]
    error(DivideError())
  end
  if degree(p) < degree(q)
    return (p, q, Poly([0//1], p.var))
  end
  quotient = zeros(typeof(p.a[1]), degree(p) - degree(q) + 1)
  target = copy(p.a)
  divide = copy(q.a)
  while length(target) >= length(divide) && length(target) > 1
    target, divide, quotient = lowdegree(target, divide, quotient)
  end
  return Poly(target, p.var)
end

zero_poly = Poly([0//1], :x)

function gcd(p::Poly, q::Poly)
  while p.a != [0]
    if degree(p) < degree(q)
      p, q = q, p
    end
    p = p % q

  end
  return q
end

function differential(p::Poly)
  diff_p = zeros(typeof(p.a[1]), degree(p))
  for (i, val) in enumerate(p.a[2:degree(p) + 1])
    diff_p[i] = i * val
  end
  return   Poly(diff_p, p.var)
end

function substitution(p::Poly,inp::Number)
  val = 0
  for (i, cff) in enumerate(reverse(p.a))
    val *= inp
    val += cff
  end
  return  val
end

# TODO
# better algorithim
function compose(f::Poly, g::Poly)
  deg_f, deg_g = degree(f), degree(g)
  composed = Poly([0], f.var)
  temp = Poly([1], f.var)
  for i = 1:deg_f + 1
    composed += f.a[i] * temp
    temp *= g
  end
  return composed
end

function squarefree(f::Poly)
  f_prime = differential(f)
  return f / gcd(f, f_prime)
end

function monic(f::Poly)
  deg_f = degree(f)
  return Poly(f.a // f.a[deg_f + 1], f.var)
end

x = Poly([0, 1],:x)


a = [0//1 ,1//1 ,2//1]
var = :x
p = Poly(a, var)
q = p * p
r = Poly(a, var)



diff_p = zeros(typeof(p.a[1]), 100)
diff_p[100] = 3
d = Poly(diff_p, p.var)
