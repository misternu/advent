package main

import (
  "bufio"
  "fmt"
  "io/ioutil"
  "strconv"
  "strings"
)

type instr struct {
  op string
  num int
}

func readInput() ([]instr) {
  input, err := ioutil.ReadFile("2020/08/input.txt")
  if err != nil { panic(err) }

  reader    := strings.NewReader(string(input))
  scanner   := bufio.NewScanner(reader)

  var result []instr
  for scanner.Scan() {
    line := scanner.Text()
    instruction := strings.Split(line, " ")
    op := instruction[0]
    num, _ := strconv.Atoi(instruction[1])
    instr := instr{op, num}
    result = append(result, instr)
  }
  return result
}

func run(instrs []instr) (int, bool) {
  length := len(instrs)
  pos := 0
  acc := 0
  visited := make(map[int]bool)
  for !visited[pos] && pos < length {
    visited[pos] = true
    instr := instrs[pos]
    switch instr.op {
    case "acc":
      acc = acc + instr.num
      pos++
    case "jmp":
      pos = pos + instr.num
    default:
      pos++
    }
  }
  return acc, pos >= length
}

func main() {
  instrs := readInput()
  result, _ := run(instrs)
  fmt.Printf("%d\n", result)

  length := len(instrs)
  for i := 0; i < length; i++ {
    current_instr := instrs[i]
    if current_instr.op != "acc" {
      var mod_instrs []instr
      for j := 0; j < length; j++ {
        if j != i {
          mod_instrs = append(mod_instrs, instrs[j])
        } else {
          current_instr := instrs[j]
          if current_instr.op == "jmp" {
            mod_instrs = append(mod_instrs, instr{"nop", current_instr.num})
          } else {
            mod_instrs = append(mod_instrs, instr{"jmp", current_instr.num})
          }
        }
      }
      result, valid := run(mod_instrs)
      if valid {
        fmt.Printf("%d\n", result)
        break
      }
    }
  }
}
