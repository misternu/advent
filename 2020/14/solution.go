package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

type instruction struct {
	mask string
	ints []int
}

func readInput() []instruction {
	input, err := ioutil.ReadFile("2020/14/input.txt")
	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)

	mask_re := regexp.MustCompile(`mask = ([01X]{36})`)
	mem_re := regexp.MustCompile(`mem\[(\d+)\] = (\d+)`)

	var result []instruction
	var mask string
	for scanner.Scan() {
		line := scanner.Text()
		if matched, _ := regexp.Match(`mask`, []byte(line)); matched {
			mask = mask_re.FindStringSubmatch(line)[1]
		} else {
			mem := mem_re.FindStringSubmatch(line)
			addr, _ := strconv.Atoi(mem[1])
			val, _ := strconv.Atoi(mem[2])
			mem_ints := []int{addr, val}
			result = append(result, instruction{mask, mem_ints})
		}
	}

	return result
}

func runOne(instructions []instruction) int {
	memory := make(map[int]int)
	for _, instr := range instructions {
		value_string := fmt.Sprintf("%036b", instr.ints[1])
		var masked_value_string []byte
		for i := 0; i < 36; i++ {
			if instr.mask[i] == 'X' {
				masked_value_string = append(masked_value_string, value_string[i])
			} else {
				masked_value_string = append(masked_value_string, instr.mask[i])
			}
		}
		addr := instr.ints[0]
		value, _ := strconv.ParseInt(string(masked_value_string), 2, 64)
		memory[addr] = int(value)
	}
	total := 0
	for _, val := range memory {
		total = total + val
	}
	return total
}

func main() {
	instructions := readInput()
	fmt.Println(runOne(instructions))
}
