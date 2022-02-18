package main

import (
  "bufio"
  "fmt"
  "io/ioutil"
  "strconv"
  "strings"
)

func readInput() ([]int) {
  input, err := ioutil.ReadFile("2020/09/input.txt")
  if err != nil { panic(err) }

  reader := strings.NewReader(string(input))
  scanner := bufio.NewScanner(reader)

  var result []int
  for scanner.Scan() {
    line := scanner.Text()
    num, _ := strconv.Atoi(line)
    result = append(result, num)
  }
  return result
}

func partOne(numbers) {
  length = len(numbers)

  for i := 25; i < length; i++ {

  }
}

func main() {
  numbers := readInput()

  partOne(numbers)
}
