package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func readInput() []int {
	input, err := ioutil.ReadFile("2020/05/input.txt")

	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)

	var result []int
	for scanner.Scan() {
		line := scanner.Text()
		var digits []byte
		for _, char := range line {
			if char == 'B' || char == 'R' {
				digits = append(digits, '1')
			} else {
				digits = append(digits, '0')
			}
		}
		number, _ := strconv.ParseInt(string(digits), 2, 32)
		result = append(result, int(number))
	}

	return result
}

func gaussSum(n int) int {
	return ((n + 1) * n) / 2
}

func main() {
	numbers := readInput()

	max := numbers[0]
	min := numbers[0]
	total := 0

	for _, num := range numbers {
		if num > max {
			max = num
		}
		if num < min {
			min = num
		}
		total = total + num
	}

	plane_total := gaussSum(max) - gaussSum(min-1)
	missing_ticket := plane_total - total

	fmt.Printf("%d\n", max)
	fmt.Printf("%d\n", missing_ticket)
}
