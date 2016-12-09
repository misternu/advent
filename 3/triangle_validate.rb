def validate(triangle)
  return false unless triangle[0] + triangle[1] > triangle[2]
  return false unless triangle[0] + triangle[2] > triangle[1]
  return false unless triangle[1] + triangle[2] > triangle[0]
  true
end