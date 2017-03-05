function asympdf(x)
  x >= -1 && x <= 1 || throw(DomainError())
  x >= -1 && x < 0 && return (4 + 4x)/5
  (4 - 2x)/5
end
