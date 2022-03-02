package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func readInput() []int {
	input, err := ioutil.ReadFile("2020/09/input.txt")
	if err != nil {
		panic(err)
	}

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

func partOne(numbers []int) int {
	length := len(numbers)

	for i := 25; i < length; i++ {
		var sums []int
		for j := i - 25; j < i-1; j++ {
			for k := j + 1; k < i; k++ {
				sums = append(sums, numbers[j]+numbers[k])
			}
		}
		valid := false
		for _, sum := range sums {
			if numbers[i] == sum {
				valid = true
				break
			}
		}
		if !valid {
			return numbers[i]
		}
	}

	return -1
}

func partTwo(numbers []int, target int) int {
	i := 0
	j := 1
	sum := numbers[i] + numbers[j]
	for sum != target {
		if sum < target {
			j++
			sum = sum + numbers[j]
		} else {
			sum = sum - numbers[i]
			i++
		}
	}
	min := numbers[i]
	max := numbers[j]
	for k := i; k <= j; k++ {
		number := numbers[k]
		if number < min {
			min = number
		}
		if number > max {
			max = number
		}
	}
	return min + max
}

func main() {
	numbers := readInput()

	part_one := partOne(numbers)
	part_two := partTwo(numbers, part_one)

	fmt.Printf("%d\n", part_one)
	fmt.Printf("%d\n", part_two)
}
