package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"strings"
)

func readInput() [][]bool {
	input, err := ioutil.ReadFile("2020/03/input.txt")

	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)
	var result [][]bool
	for scanner.Scan() {
		line := scanner.Text()
		length := len(line)
		line_result := make([]bool, length)
		for i := 0; i < length; i++ {
			if line[i] == byte('#') {
				line_result[i] = true
			}
		}
		result = append(result, line_result)
	}

	return result
}

func main() {
	input := readInput()
	width := len(input[0])

	part_one := 0
	part_two_factors := make([]int, 5)
	for i, line := range input {
		if line[i%width] {
			part_two_factors[0]++
		}

		if line[(i*3)%width] {
			part_one++
			part_two_factors[1]++
		}

		if line[(i*5)%width] {
			part_two_factors[2]++
		}

		if line[(i*7)%width] {
			part_two_factors[3]++
		}

		if (i%2 == 0) && line[(i/2)%width] {
			part_two_factors[4]++
		}
	}

	part_two := part_two_factors[0]

	for i := 1; i < 5; i++ {
		part_two = part_two * part_two_factors[i]
	}

	fmt.Printf("%d\n", part_one)
	fmt.Printf("%d\n", part_two)
}
