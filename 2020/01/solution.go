package main

import (
  "bufio"
  "fmt"
  "io/ioutil"
  "strings"
  "strconv"
)

func readInputNumbers() ([]int) {
  input, err := ioutil.ReadFile("2020/01/input.txt")

  if err != nil {
    panic(err)
  }

  reader := strings.NewReader(string(input))
  scanner := bufio.NewScanner(reader)
  var input_numbers []int
  for scanner.Scan() {
    x, err := strconv.Atoi(scanner.Text())
    if err != nil {
      panic(err)
    }
    input_numbers = append(input_numbers, x)
  }

  return input_numbers
}

func main() {
  input := readInputNumbers()
  length := len(input)

  for i := 0; i < length; i++ {
    for j := i + 1; j < length; j++ {
      if input[i] + input[j] == 2020 {
        fmt.Printf("%d\n", (input[i] * input[j]))
      }
    }
  }

  for i := 0; i < length; i++ {
    for j := i + 1; j < length; j++ {
      for k := j + 1; k < length; k++ {
        if input[i] + input[j] + input[k] == 2020 {
          fmt.Printf("%d\n", (input[i] * input[j] * input[k]))
        }
      }
    }
  }
}
